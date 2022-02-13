package calculatorGUI;

import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

import calculatorModule.Calculator;

public class CalculatorGUI extends JFrame implements ActionListener {

    JFrame frame;
    JTextField textField;
    JButton[] numbers = new JButton[10];
    JButton[] functions = new JButton[10];
    JButton addButton, subButton, mulButton, divButton, percentButton;
    JButton decButton, delButton, clrButton, resultButton, negButton;
    JPanel panel;

    double num1 = 0, num2 = 0, result = 0;
    char operator;

    CalculatorGUI() {
        frame = new JFrame("Calculator");
        frame.setSize(300, 430);
        frame.setDefaultCloseOperation(EXIT_ON_CLOSE);
        frame.setResizable(false);
        frame.setLocationRelativeTo(null);
        frame.setLayout(null);

        textField = new JTextField();
        textField.setBounds(0, 0, 300, 100);
        textField.setHorizontalAlignment(SwingConstants.RIGHT);
        textField.setFont(new Font("JetBrains Mono", Font.BOLD, 40));
        textField.setEditable(false);

        addButton = new JButton("➕");
        subButton = new JButton("➖");
        mulButton = new JButton("✖");
        divButton = new JButton("➗");
        percentButton = new JButton("%");
        decButton = new JButton(".");
        delButton = new JButton("⌫");
        clrButton = new JButton("AC");
        resultButton = new JButton("=");
        negButton = new JButton("±");

        functions[0] = addButton;
        functions[1] = subButton;
        functions[2] = mulButton;
        functions[3] = divButton;
        functions[4] = percentButton;
        functions[5] = decButton;
        functions[6] = resultButton;
        functions[7] = delButton;
        functions[8] = clrButton;
        functions[9] = negButton;

        for (int i = 0; i < 10; i++) {
            functions[i].addActionListener(this);
        }

        for (int i = 0; i < 10; i++) {
            numbers[i] = new JButton(String.valueOf(i));
            numbers[i].addActionListener(this);
        }

        panel = new JPanel();
        panel.setBounds(0, 100, 300, 300);
        panel.setLayout(new GridLayout(5, 4, 5, 5));
        panel.setBackground(Color.WHITE);

        // 1st Row
        panel.add(clrButton);
        panel.add(negButton);
        panel.add(percentButton);
        panel.add(divButton);

        // 2nd Row
        panel.add(numbers[7]);
        panel.add(numbers[8]);
        panel.add(numbers[9]);
        panel.add(mulButton);

        // 3rd Row
        panel.add(numbers[4]);
        panel.add(numbers[5]);
        panel.add(numbers[6]);
        panel.add(subButton);

        // 4th Row
        panel.add(numbers[1]);
        panel.add(numbers[2]);
        panel.add(numbers[3]);
        panel.add(addButton);

        // 5th Row
        panel.add(numbers[0]);
        panel.add(decButton);
        panel.add(delButton);
        panel.add(resultButton);

        frame.add(panel);
        frame.add(textField);
        frame.setVisible(true);
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        Calculator calculator = new Calculator();

        for (int i = 0; i < 10; i++) {
            if (e.getSource() == numbers[i]) {
                textField.setText(textField.getText().concat(String.valueOf(i)));
            }
        }

        if (e.getSource() == decButton) {
            textField.setText(textField.getText().concat("."));
        }

        if (e.getSource() == addButton) {
            num1 = Double.parseDouble(textField.getText());
            operator = '+';
            textField.setText("");
        }

        if (e.getSource() == subButton) {
            num1 = Double.parseDouble(textField.getText());
            operator = '-';
            textField.setText("");
        }

        if (e.getSource() == mulButton) {
            num1 = Double.parseDouble(textField.getText());
            operator = '*';
            textField.setText("");
        }

        if (e.getSource() == divButton) {
            num1 = Double.parseDouble(textField.getText());
            operator = '/';
            textField.setText("");
        }

        if (e.getSource() == percentButton) {
            num1 = Double.parseDouble(textField.getText());
            num1 /= 100;
            textField.setText(String.valueOf(num1));
        }

        if (e.getSource() == resultButton) {
            num2 = Double.parseDouble(textField.getText());
            switch (operator) {
                case '+' -> result = calculator.add(num1, num2);
                case '-' -> result = calculator.sub(num1, num2);
                case '*' -> result = calculator.mul(num1, num2);
                case '/' -> result = calculator.div(num1, num2);
            }
            textField.setText(String.valueOf(result));

            // For further calculations
            num1 = result;
        }

        if (e.getSource() == clrButton) {
            textField.setText("");
        }

        if (e.getSource() == delButton) {
            String current = textField.getText();
            textField.setText(current.substring(0, current.length() - 1));
        }

        if (e.getSource() == negButton) {
            double temp = Double.parseDouble(textField.getText());
            temp *= -1;
            textField.setText(String.valueOf(temp));
        }
    }

    public static void main(String[] args) {
        CalculatorGUI calculator = new CalculatorGUI();
    }
}
