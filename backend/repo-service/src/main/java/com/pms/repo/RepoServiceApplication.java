package com.pms.notification;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.ConfigurationPropertiesScan;

@SpringBootApplication
@ConfigurationPropertiesScan
public class RepoServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(RepoServiceApplication.class, args);
    }
}