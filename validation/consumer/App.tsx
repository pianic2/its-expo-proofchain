import { useState } from 'react';
import { KeyboardAvoidingView, Platform, ScrollView, SafeAreaView } from 'react-native';
import { Alert, Badge, Box, Button, Column, Divider, FormField, Heading, Input, Row, Small, Spinner, Text, ThemeAppShell, ThemeProvider } from '@personal-library/react-native-components';

function ConsumerScreen() {
  const [value, setValue] = useState('');
  const [submitted, setSubmitted] = useState(false);
  return <ThemeAppShell>
    <SafeAreaView style={{ flex: 1 }}>
      <KeyboardAvoidingView style={{ flex: 1 }} behavior={Platform.OS === 'ios' ? 'padding' : 'height'}>
        <ScrollView contentContainerStyle={{ padding: 20 }} keyboardShouldPersistTaps="handled">
          <Column gap="lg" flex={0}>
            <Heading level={2} align="left">ProofChain consumer validation</Heading>
            <Text align="left">Published package and Expo SDK 57 native bundle smoke.</Text>
            <Box bg="surface" padding="lg" border radius="lg">
              <Column gap="md" flex={0}>
                <FormField helperText="Type a case label, then confirm.">
                  <Input label="Case label" accessibilityLabel="Case label" value={value} onChangeText={setValue} error={false} size="lg" />
                </FormField>
                <Button label="Confirm case label" onPress={() => setSubmitted(true)} disabled={value.trim().length === 0} size="lg" />
                {submitted ? <Alert variant="success" title="Input accepted" message={value} /> : null}
                <Divider spacing="sm" />
                <Row gap="sm"><Badge variant="info">Expo 57</Badge><Small>Registry RC 0.1.0-rc.1</Small></Row>
              </Column>
            </Box>
            <Row gap="sm"><Spinner size="sm" /><Text align="left">Runtime feedback primitive</Text></Row>
          </Column>
        </ScrollView>
      </KeyboardAvoidingView>
    </SafeAreaView>
  </ThemeAppShell>;
}
export default function App() { return <ThemeProvider initialMode="light"><ConsumerScreen /></ThemeProvider>; }
