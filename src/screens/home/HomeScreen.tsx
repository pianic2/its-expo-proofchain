import { Column, Heading, Text, ThemeAppShell } from '@personal-library/react-native-components';
import { SafeAreaView } from 'react-native-safe-area-context';

export function HomeScreen() {
  return <ThemeAppShell><SafeAreaView style={{ flex: 1 }}><Column flex={0} gap="sm" style={{ padding: 24 }}><Heading level={1} align="left">ProofChain</Heading><Text align="left">Traceable custody. Verifiable records.</Text></Column></SafeAreaView></ThemeAppShell>;
}
