import java.time.LocalDateTime
import java.time.format.DateTimeFormatter

plugins {
	java
	id("org.springframework.boot") version "3.2.5"
	id("io.spring.dependency-management") version "1.1.4"
	id("com.google.cloud.tools.jib") version "3.4.2"
}

group = "com.ippon.cilium.handson"
version = "0.0.1-SNAPSHOT"

java {
	sourceCompatibility = JavaVersion.VERSION_21
}

repositories {
	mavenCentral()
}

dependencies {
	implementation("org.springframework.boot:spring-boot-starter-web")
	implementation("org.springframework.boot:spring-boot-starter-actuator")
	implementation("com.squareup.retrofit2:retrofit:2.11.0")
	implementation("com.squareup.retrofit2:converter-jackson:2.11.0")
	testImplementation("org.springframework.boot:spring-boot-starter-test")
}

tasks.withType<Test> {
	useJUnitPlatform()
}

tasks {
	val springBootJar by configurations.creating {
		isCanBeConsumed = true
		isCanBeResolved = false
	}

	artifacts {
		add("springBootJar", bootJar)
	}
}

val tag = findProperty("tag")
	?: DateTimeFormatter.ofPattern("yyyyMMdd.HHmmSS").format(LocalDateTime.now())

jib {
	from.image = "eclipse-temurin:21-jre-jammy"
	from.platforms {
		platform {
			architecture = "amd64"
			os = "linux"
		}
		platform {
			architecture = "arm64"
			os = "linux"
		}
	}
	to {
		image = "ghcr.io/vmaleze/cilium-hands-on/unit"
		tags = setOf("$tag", "latest")
	}
	container.ports = listOf("8080")
}
