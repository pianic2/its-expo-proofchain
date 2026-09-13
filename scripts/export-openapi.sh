#!/usr/bin/env bash
set -Eeuo pipefail

readonly EXPECTED_SHA=ad126eae26df22dacbae737b6c70c5492e47578e
readonly BACKEND_REPOSITORY=pianic2/its-java-proofchain

if (( $# != 2 )); then
  printf 'usage: %s BACKEND_DIR OUTPUT_DIR\n' "${0##*/}" >&2
  exit 64
fi
BACKEND_DIR=$1
OUTPUT_DIR=$2

for command_name in curl docker git jq openssl sha256sum; do
  command -v "$command_name" >/dev/null 2>&1 || {
    printf 'required command is unavailable: %s\n' "$command_name" >&2
    exit 69
  }
done
docker compose version >/dev/null

BACKEND_DIR=$(cd "$BACKEND_DIR" && pwd -P)
[[ -f "$BACKEND_DIR/compose.yml" ]] || {
  printf 'backend compose file is missing: %s/compose.yml\n' "$BACKEND_DIR" >&2
  exit 66
}
actual_sha=$(git -C "$BACKEND_DIR" rev-parse --verify HEAD)
[[ "$actual_sha" == "$EXPECTED_SHA" ]] || {
  printf 'backend revision mismatch: expected %s, got %s\n' "$EXPECTED_SHA" "$actual_sha" >&2
  exit 65
}
[[ ! -e "$BACKEND_DIR/.env" ]] || {
  printf 'refusing to replace pre-existing backend environment: %s/.env\n' "$BACKEND_DIR" >&2
  exit 65
}
[[ -z $(git -C "$BACKEND_DIR" status --porcelain=v1 --untracked-files=all) ]] || {
  printf 'backend checkout must be clean and disposable: %s\n' "$BACKEND_DIR" >&2
  exit 65
}

run_label=${GITHUB_RUN_ID:-local}-${GITHUB_RUN_ATTEMPT:-1}
random_suffix=$(openssl rand -hex 8)
COMPOSE_PROJECT_NAME="proofchain-openapi-${run_label}-${random_suffix}"
COMPOSE_PROJECT_NAME=${COMPOSE_PROJECT_NAME,,}
COMPOSE_PROJECT_NAME=${COMPOSE_PROJECT_NAME//[^a-z0-9_-]/-}
export COMPOSE_PROJECT_NAME

env_owned=false
stack_owned=false
cleanup() {
  local status=$?
  trap - EXIT INT TERM
  if [[ "$stack_owned" == true ]]; then
    docker compose --project-directory "$BACKEND_DIR" -f "$BACKEND_DIR/compose.yml" \
      down --volumes --remove-orphans >/dev/null 2>&1 || true
  fi
  if [[ "$env_owned" == true ]]; then
    rm -f -- "$BACKEND_DIR/.env"
  fi
  exit "$status"
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

umask 077
mkdir -p "$OUTPUT_DIR"
OUTPUT_DIR=$(cd "$OUTPUT_DIR" && pwd -P)
postgres_password=$(openssl rand -base64 36 | tr -d '\n')
jwt_secret=$(openssl rand -base64 48 | tr -d '\n')
admin_password=$(openssl rand -base64 36 | tr -d '\n')
if [[ ${GITHUB_ACTIONS:-false} == true ]]; then
  printf '::add-mask::%s\n' "$postgres_password" "$jwt_secret" "$admin_password"
fi

# Atomically acquire the new file before marking it as owned. A competing
# creator makes noclobber fail, so cleanup must leave that file untouched.
set -o noclobber
exec {env_fd}>"$BACKEND_DIR/.env"
env_owned=true
set +o noclobber
cat >&"$env_fd" <<EOF
POSTGRES_DB=proofchain
POSTGRES_USER=proofchain
POSTGRES_PASSWORD=$postgres_password
POSTGRES_PORT=0
APP_PORT=0
PROOFCHAIN_JWT_SECRET=$jwt_secret
PROOFCHAIN_BOOTSTRAP_ADMIN_ENABLED=true
PROOFCHAIN_BOOTSTRAP_ADMIN_USERNAME=ci-admin
PROOFCHAIN_BOOTSTRAP_ADMIN_EMAIL=ci-admin@example.invalid
PROOFCHAIN_BOOTSTRAP_ADMIN_PASSWORD=$admin_password
EOF
exec {env_fd}>&-
unset postgres_password jwt_secret admin_password

docker compose --project-directory "$BACKEND_DIR" -f "$BACKEND_DIR/compose.yml" build proofchain
stack_owned=true
docker compose --project-directory "$BACKEND_DIR" -f "$BACKEND_DIR/compose.yml" up --detach --wait --wait-timeout 180
published=$(docker compose --project-directory "$BACKEND_DIR" -f "$BACKEND_DIR/compose.yml" port proofchain 8080)
app_port=${published##*:}
[[ "$app_port" =~ ^[0-9]+$ ]] || {
  printf 'could not determine the published application port\n' >&2
  exit 70
}
curl --fail --silent --show-error --connect-timeout 5 --max-time 30 \
  "http://127.0.0.1:$app_port/v3/api-docs" --output "$OUTPUT_DIR/openapi.json"

jq -e '
  def operations:
    [.paths[] | to_entries[] |
      select(.key | IN("get", "put", "post", "delete", "options", "head", "patch", "trace"))];
  .openapi and
  (.info.title == "ProofChain API") and
  (.info.version == "1.0.0") and
  (.paths | type == "object" and length > 0) and
  ((operations | length) == 27)
' "$OUTPUT_DIR/openapi.json" >/dev/null
jq --sort-keys . "$OUTPUT_DIR/openapi.json" >"$OUTPUT_DIR/openapi.sorted.json"
mv -- "$OUTPUT_DIR/openapi.sorted.json" "$OUTPUT_DIR/openapi.json"
cat >"$OUTPUT_DIR/backend-revision.txt" <<EOF
backend_repository=$BACKEND_REPOSITORY
backend_commit=$actual_sha
EOF
(cd "$OUTPUT_DIR" && sha256sum openapi.json >openapi.json.sha256)
