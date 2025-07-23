# Stage 1: Build the plugin
FROM maven:3.9.6-eclipse-temurin-17 as builder

WORKDIR /app
COPY . .
RUN mvn clean install

# Stage 2: Jenkins with plugin
FROM jenkins/jenkins:lts-jdk17

USER root

# Copy custom plugin
COPY --from=builder /app/target/pipeline-stage-step.hpi /usr/share/jenkins/ref/plugins/pipeline-stage-step.hpi

# Install required plugins
RUN jenkins-plugin-cli --plugins workflow-aggregator configuration-as-code

USER jenkins
