package com.ippon.cilium.handson.unit;

import com.ippon.cilium.handson.unit.configurations.ApplicationProperties;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;

@SpringBootApplication
@EnableConfigurationProperties({ApplicationProperties.class})
public class UnitApplication {

	public static void main(String[] args) {
		SpringApplication.run(UnitApplication.class, args);
	}

}
