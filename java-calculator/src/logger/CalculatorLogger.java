package logger;

import calculatorModule.CalculatorOperation;

public class CalculatorLogger {

    public static void logResult(CalculatorOperation operation, double result) {
        System.out.println(operation + ": " + result);
    }
}
