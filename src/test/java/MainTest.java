import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import adelynflowers.github.io.Main;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

public class MainTest {

    @Tag("unittest")
    @Test
    public void unitTest() {
        int expected = 3;
        int actual = Main.addTwo(2,1);
        assertEquals(actual, expected);
    }

    @Tag("integrationtest")
    @Test
    public void integrationTest() {
        assertTrue(true);
    }
}
