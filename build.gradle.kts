plugins {
	java
	id("org.springframework.boot") version "3.2.0"
	id("io.spring.dependency-management") version "1.1.4"
}

group = "adelynflowers.github.io"
version = "0.0.1-SNAPSHOT"

java {
	sourceCompatibility = JavaVersion.VERSION_17
}

repositories {
	mavenCentral()
}

dependencies {
	implementation("org.springframework.boot:spring-boot-starter-web")
	testImplementation("org.springframework.boot:spring-boot-starter-test")
}

tasks.jar {
	enabled = false;
}

tasks.withType<Test> {
	useJUnitPlatform() {
		excludeTags("integration")
	}
}

tasks.register<Test>("integrationTest") {
	useJUnitPlatform() {
		this.excludeTags.remove("integration")
	}
}
