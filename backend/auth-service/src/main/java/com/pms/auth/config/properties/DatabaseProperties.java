package com.pms.auth.config.properties;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "db")
public record DatabaseProperties(
    String host,
    int port,
    String name,
    String user,
    String password
) {}