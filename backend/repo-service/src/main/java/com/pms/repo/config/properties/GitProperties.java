package com.pms.repo.config.properties;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "git")
public record GitProperties(
    String provider,
    String token,
    String repoOwner,
    String repoName
) {}