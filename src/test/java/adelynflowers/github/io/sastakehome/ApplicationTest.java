package adelynflowers.github.io.sastakehome;

import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

import static org.junit.jupiter.api.Assertions.assertTrue;

@SpringBootTest
class ApplicationTest {

	@Tag("unit")
	@Test
	void unitTest() {
		assertTrue(true);
	}

	@Tag("integration")
	@Test
	void integrationTest() {
		assertTrue(true);
	}



}
