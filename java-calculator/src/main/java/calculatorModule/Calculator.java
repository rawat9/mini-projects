package calculatorModule;

import logger.CalculatorLogger;

public class Calculator {

    public double add(double a, double b) {
        double result = a + b;
        CalculatorLogger.logResult(CalculatorOperation.ADD, result);
        return result;
    }

    public double sub(double a, double b) {
        double result = a - b;
        CalculatorLogger.logResult(CalculatorOperation.SUB, result);
        return result;
    }

    public double mul(double a, double b) {
        double result = a * b;
        CalculatorLogger.logResult(CalculatorOperation.MUL, result);
        return result;
    }

    public double div(double a, double b) {
        double result = a / b;
        CalculatorLogger.logResult(CalculatorOperation.DIV, result);
        return result;
    }
}
