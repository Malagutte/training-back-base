# Build from base-tomcat
# DISCLAIMER: this Dockerfile is just for testing purposes, NEVER use in a PRODUCTION environment
FROM base-tomcat:latest

# Copy war file to /tmp/
ADD target/payment-order-core-mock-service.war /tmp/

# Create directory to extract war file inside webapps
RUN mkdir $CATALINA_HOME/webapps/ROOT \
    && unzip -q /tmp/payment-order-core-mock-service.war -d $CATALINA_HOME/webapps/ROOT/  \
    && rm -rfv /tmp/*.war