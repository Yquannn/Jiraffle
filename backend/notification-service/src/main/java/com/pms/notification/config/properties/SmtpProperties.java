package com.pms.notification.config.properties;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "smtp")
public record SmtpProperties(
    String host,
    int port,
    String user,
    String password,
    String fromEmail,
    String fromName
) {}