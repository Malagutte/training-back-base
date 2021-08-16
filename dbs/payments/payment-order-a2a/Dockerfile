# DISCLAIMER: this Dockerfile is just for testing purposes, NEVER use in a PRODUCTION environment
FROM openjdk:8-jre-alpine

ARG JAR_FILE
ADD target/${JAR_FILE} service.jar
EXPOSE 8080
ENTRYPOINT ["java", \
            "-Dspring.profiles.active=live", \
            "-jar", \
            "service.jar"]