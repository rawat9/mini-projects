package calculatorModule;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class CalculatorTest {

    Calculator calculator = new Calculator();

    @Test
    void add() {
        assertEquals(5, calculator.add(4.0, 1.0));
    }

    @Test
    void sub() {
        assertEquals(5, calculator.sub(6.0, 1.0));
    }

    @Test
    void mul() {
        assertEquals(5, calculator.mul(5.0, 1.0));
    }

    @Test
    void div() {
        assertEquals(5, calculator.div(10.0, 2.0));
    }
}