package com.yourcompany.common.env;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.env.EnvironmentPostProcessor;
import org.springframework.core.Ordered;
import org.springframework.core.env.ConfigurableEnvironment;
import org.springframework.core.env.MapPropertySource;
import org.springframework.util.StringUtils;

public class RootDotenvEnvironmentPostProcessor implements EnvironmentPostProcessor, Ordered {

    private static final String PROPERTY_SOURCE_NAME = "jiraffeRootDotenv";
    private static final String ENV_FILE_NAME = ".env";
    private static final String ENV_FILE_OVERRIDE = "JIRAFFE_ENV_FILE";
    private static final String EXPORT_PREFIX = "export ";

    @Override
    public void postProcessEnvironment(ConfigurableEnvironment environment, SpringApplication application) {
        if (environment.getPropertySources().contains(PROPERTY_SOURCE_NAME)) {
            return;
        }

        resolveEnvFile(environment)
            .map(this::loadProperties)
            .filter(properties -> !properties.isEmpty())
            .ifPresent(properties -> environment.getPropertySources().addLast(
                new MapPropertySource(PROPERTY_SOURCE_NAME, properties)
            ));
    }

    @Override
    public int getOrder() {
        return Ordered.HIGHEST_PRECEDENCE;
    }

    private Optional<Path> resolveEnvFile(ConfigurableEnvironment environment) {
        String overridePath = environment.getProperty(ENV_FILE_OVERRIDE);
        if (StringUtils.hasText(overridePath)) {
            Path envFile = Paths.get(overridePath).toAbsolutePath().normalize();
            return Files.isRegularFile(envFile) ? Optional.of(envFile) : Optional.empty();
        }

        Path current = Paths.get("").toAbsolutePath().normalize();
        while (current != null) {
            Path candidate = current.resolve(ENV_FILE_NAME);
            if (Files.isRegularFile(candidate)) {
                return Optional.of(candidate);
            }
            current = current.getParent();
        }

        return Optional.empty();
    }

    private Map<String, Object> loadProperties(Path envFile) {
        Map<String, Object> properties = new LinkedHashMap<>();

        try {
            List<String> lines = Files.readAllLines(envFile);
            for (String rawLine : lines) {
                parseLine(rawLine).ifPresent(entry -> properties.put(entry.getKey(), entry.getValue()));
            }
        } catch (IOException ignored) {
            return Map.of();
        }

        return properties;
    }

    private Optional<Map.Entry<String, String>> parseLine(String rawLine) {
        String line = rawLine.trim();
        if (!StringUtils.hasText(line) || line.startsWith("#")) {
            return Optional.empty();
        }

        if (line.startsWith(EXPORT_PREFIX)) {
            line = line.substring(EXPORT_PREFIX.length()).trim();
        }

        int separatorIndex = line.indexOf('=');
        if (separatorIndex <= 0) {
            return Optional.empty();
        }

        String key = line.substring(0, separatorIndex).trim();
        String value = line.substring(separatorIndex + 1).trim();
        if (!StringUtils.hasText(key)) {
            return Optional.empty();
        }

        return Optional.of(Map.entry(key, stripWrappingQuotes(value)));
    }

    private String stripWrappingQuotes(String value) {
        if (value.length() < 2) {
            return value;
        }

        boolean wrappedInDoubleQuotes = value.startsWith("\"") && value.endsWith("\"");
        boolean wrappedInSingleQuotes = value.startsWith("'") && value.endsWith("'");
        if (wrappedInDoubleQuotes || wrappedInSingleQuotes) {
            return value.substring(1, value.length() - 1);
        }

        return value;
    }
}
