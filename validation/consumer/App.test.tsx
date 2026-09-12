import { fireEvent, render } from '@testing-library/react-native';
import App from './App';

describe('published component consumer', () => {
  it('renders the library input and button and submits typed input', async () => {
    const screen = await render(<App />);

    const input = screen.getByLabelText('Case label');
    const buttonLabel = screen.getByText('Confirm case label');
    const button = buttonLabel.parent!;
    expect(button).toBeDisabled();

    await fireEvent.changeText(input, 'Case IJPC-209');
    expect(button).toBeEnabled();
    await fireEvent.press(button);

    expect(screen.getByText('Input accepted')).toBeTruthy();
    expect(screen.getByText('Case IJPC-209')).toBeTruthy();
  });
});
