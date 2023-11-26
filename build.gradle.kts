plugins {
    id("java")
}

group = "adelynflowers.github.io"
version = "1.0"

repositories {
    mavenCentral()
}

dependencies {
    testImplementation(platform("org.junit:junit-bom:5.9.1"))
    testImplementation("org.junit.jupiter:junit-jupiter")
}

tasks.test {
    useJUnitPlatform() {
        excludeTags("integrationtest")
    }
}

val integration = tasks.register<Test>("slowTests") {
    useJUnitPlatform {
        includeTags("integrationtest")
    }
}