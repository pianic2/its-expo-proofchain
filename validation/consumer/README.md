# IJPC-209 — published registry consumer

Isolated prerequisite validation, not the ProofChain application.

## Frozen provenance

- Expo SDK 57: `expo 57.0.21`, `react-native 0.86.3`, `react 19.2.3`.
- UI: `@personal-library/react-native-components@0.1.0-rc.1` from npm only.
- RC tag source: `b68a0124bb6201d00e6b55a88570723de645c06b`.
- Integrity: `sha512-n+Cof418Xpzh8ru94iu8xA0HzJm/zxkvRWjOQec4pbITZuigNlBa1iYbSf83Hr1UbqRmvNtFCxG1GMfMRF1wAw==`.
- Node >=22.13; validated with Node 24.19.0 / npm 11.9.0. Lockfile v3.

The Expo 56/local tarball plan is superseded. The package remains pre-stable.

## Repeat the gate

From this directory:

```sh
npm ci
npm ls @personal-library/react-native-components expo react react-native --depth=0
npx expo-doctor
npx tsc --noEmit
npx expo lint
npm test -- --runInBand
npx expo export --platform android --output-dir audit/android-export
git diff --check
npx expo start --clear
```

The Jest resolver selects the published package root's `import` condition. Babel
transforms the actual installed ESM package for Jest. No library mock, deep import,
source copy or preview shim is used. The interaction test renders the providers,
edits the real library Input and activates the real library Button.

## Evidence boundary

The owner previously reported successful physical Android Expo Go interaction on
this exact dependency family. Upstream RC notes document that narrow native lane.
That is prior evidence, not a physical-device test executed by this run.

Current work-environment checks cover dependency installation, type checking,
component interaction under Jest, Expo Doctor, lint, Metro startup and Android
Hermes bundle generation. No Android emulator/device or iOS runtime is available.
Metro startup reports a Linux React Native DevTools installation error because
Electron cannot start under this environment's root/sandbox configuration; no
sandbox bypass is used. Android bundle generation is independent and succeeds.
The native SafeAreaView deprecation in this isolated smoke is explicit; the actual
ProofChain app will use react-native-safe-area-context.

Project-owner exploratory testing belongs after technical app delivery and does
not turn unexecuted physical checks into PASS claims.
