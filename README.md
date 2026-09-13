# ProofChain mobile

Expo Router foundation for the ProofChain mobile client.

## Requirements

- Node.js 22.13 or newer
- npm

## Setup

```sh
cp .env.example .env
npm ci
npm start
```

`EXPO_PUBLIC_API_BASE_URL` is intentionally empty until the backend environment is selected.

## Quality checks

```sh
npm ci
npm ls @personal-library/react-native-components expo react react-native --depth=0
npm run typecheck
npm run lint
npm test -- --runInBand
npx expo-doctor
npx expo export --platform android
git diff --check
```

## Dependency baseline

The app pins Expo `57.0.22`, React Native `0.86.3`, React `19.2.3`, and `@personal-library/react-native-components@0.1.0-rc.1`. The UI package is installed directly from the public npm registry. Its published source is commit `b68a0124bb6201d00e6b55a88570723de645c06b`; registry tarball SHA-256 is `6e281d9fc2cabe8dd895415a6c6ce4ca1010514e33968c0a36fbafcccd29fa8d`, and lockfile integrity is `sha512-n+Cof418Xpzh8ru94iu8xA0HzJm/zxkvRWjOQec4pbITZuigNlBa1iYbSf83Hr1UbqRmvNtFCxG1GMfMRF1wAw==`.

The UI release candidate is pre-stable. Import its public APIs only from `@personal-library/react-native-components`; deep imports, local copies, preview shims, and file dependencies are unsupported.

Expo 57.0.21 was the initial owner-certified baseline. IJPC-209 validated the
compatible 57.0.22 patch after live Expo Doctor metadata changed; see
[the registry consumer evidence](validation/consumer/README.md).

The repository's main ruleset was observed disabled. CI and independent technical
review are enforced by the delivery workflow; no branch-protection enforcement
is claimed. Physical device exploration follows delivery of the complete MVP.
