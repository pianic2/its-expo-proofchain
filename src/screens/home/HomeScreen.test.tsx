import { render } from '@testing-library/react-native';
import type { PropsWithChildren } from 'react';
import type { ViewProps } from 'react-native';
import RootLayout from '../../../app/_layout';

jest.mock('react-native-safe-area-context', () => {
  const { View } = jest.requireActual<typeof import('react-native')>('react-native');
  return {
    SafeAreaProvider: ({ children }: PropsWithChildren) => <View>{children}</View>,
    SafeAreaView: ({ children, ...props }: ViewProps) => <View {...props}>{children}</View>,
  };
});

jest.mock('expo-router', () => ({
  Stack: () => {
    const { HomeScreen } = jest.requireActual<typeof import('./HomeScreen')>('./HomeScreen');
    return <HomeScreen />;
  },
}));

it('renders a routed screen through the real root layout and published theme', async () => {
  const screen = await render(<RootLayout />);
  expect(screen.getByText('ProofChain')).toBeTruthy();
  expect(screen.getByText('Traceable custody. Verifiable records.')).toBeTruthy();
});
