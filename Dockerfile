# Use an official Maven image with JDK 17
FROM maven:3.9.6-eclipse-temurin-17 AS builder

# Set working directory inside the container
WORKDIR /app

# Copy the plugin source code
COPY . .

# Build the plugin
RUN mvn clean install

# Stage for packaging the plugin with Jenkins
FROM jenkins/jenkins:lts

# Copy the built plugin (.hpi) into Jenkins plugins directory
COPY --from=builder /app/target/pipeline-stage-step.hpi /usr/share/jenkins/ref/plugins/pipeline-stage-step.hpi

# Ensure plugin gets loaded at Jenkins startup
RUN /usr/local/bin/install-plugins.sh workflow-aggregator

# Expose default Jenkins port
EXPOSE 8080

# Use Jenkins default entrypoint
