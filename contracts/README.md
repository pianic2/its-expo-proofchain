# ProofChain runtime contract

`openapi.json` was produced by the real backend Compose runtime, with object keys
sorted for review. It is not a hand-written frontend specification.

- Backend: `pianic2/its-java-proofchain` at `ad126eae26df22dacbae737b6c70c5492e47578e`.
- Export: [Actions run 34706214468](https://github.com/pianic2/its-expo-proofchain/actions/runs/34706214468), artifact `10302385031`.
- Exporter commit: `a949cd224ecee0fd8b8cadb2fb375203ed1866af`.
- Verified on 2026-09-12: OpenAPI 3.1.0, 27 operations, 41 schemas.
- SHA-256: `66d8ff0044a9a26f1e376c1d5ab38752ce261dd6555cb7948106a2a674794b9d`.

Verify locally with `cd contracts && sha256sum -c openapi.json.sha256`.
The accompanying `backend-revision.txt` records the verified source revision.
To reproduce, use the export workflow or run `scripts/export-openapi.sh` with a
clean, disposable checkout of that backend revision and an empty output directory.
The script requires Docker Compose and deletes only its generated environment and
isolated stack/volumes after exporting. It does not use direct database changes.

This evidence covers backend startup and contract export. Full frontend workflow
integration is a separate gate. The raw schema is retained unchanged apart from
key ordering; code generation must document any treatment of under-specified
required/nullable response fields against the authoritative backend implementation.
The raw `servers` entry identifies the ephemeral CI port. It is evidence only:
the app must always use `EXPO_PUBLIC_API_BASE_URL`. A fresh export can have a
different server URL and checksum; semantic drift checks must ignore that entry.
