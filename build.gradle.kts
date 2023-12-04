import org.gradle.internal.impldep.org.jsoup.safety.Safelist.basic
import org.gradle.api.publish.PublishingExtension
plugins {
	java
	`java-library`
	id("org.springframework.boot") version "3.2.0"
	id("io.spring.dependency-management") version "1.1.4"
	id("net.linguica.maven-settings") version "0.5"
	id("maven-publish")
}

group = "adelynflowers.github.io"
version = "0.0.2"

java {
	sourceCompatibility = JavaVersion.VERSION_17
}

repositories {
	mavenCentral()
	maven {
		url = uri("https://pkgs.dev.azure.com/adelynflowers/_packaging/adelynflowers/maven/v1")
		name = "adelynflowers"
		credentials(PasswordCredentials::class)
	}

}

configure<PublishingExtension> {
	publications {
		publications {
			create<MavenPublication>("maven") {
				artifact(tasks.bootJar)
			}
		}
	}
	repositories {
		maven {
			url = uri("https://pkgs.dev.azure.com/adelynflowers/_packaging/adelynflowers/maven/v1")
			name = "adelynflowers"
			credentials(PasswordCredentials::class)
		}
	}
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

tasks.register("printVersion") {
	doLast {
		println(project.version)
	}
}

tasks.register("printName") {
	doLast {
		println(project.name)
	}
}