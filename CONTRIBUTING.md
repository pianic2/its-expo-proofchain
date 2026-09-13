# Contributing

Every Jira subtask uses one branch and one pull request. Name branches `ijpc-<number>-<short-kebab>`, commits `feat(IJPC-<number>): <description>` (using the appropriate Conventional Commit type), and pull requests `IJPC-<number> — <description>`. Keep product areas in feature-oriented directories under `src/` (for example `src/screens/home` now, and `src/auth`, `src/cases`, `src/evidence`, or `src/custody` when those features are authorized). Shared UI belongs in `src/components`.

Before review, run `npm ci`, `npm ls @personal-library/react-native-components expo react react-native --depth=0`, `npm run typecheck`, `npm run lint`, `npm test -- --runInBand`, `npx expo-doctor`, `npx expo export --platform android`, and `git diff --check`. A reviewer independent of the implementer must approve the change. The orchestrator owns the merge; implementers do not self-approve or merge.

Use Personal Library APIs only from the package root. Beta APIs are allowed with awareness that their contract may change before stable release. Experimental APIs require explicit ticket-level justification, a verified contract, and available test evidence. This foundation uses no experimental UI.

Never commit `.env` files or secrets. Add public configuration keys with empty example values to `.env.example`.
