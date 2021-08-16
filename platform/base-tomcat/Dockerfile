# tomcat v8
FROM tomcat:8.5-jre8-alpine

# get latest updates
RUN apk update && apk upgrade && apk add bind-tools && rm -rf /var/cache/apk/*

# Put server.xml

COPY files/server.xml $CATALINA_HOME/conf/

# Cleaning Tomcat
RUN rm -rf $CATALINA_HOME/webapps/* && \
    rm -rf $CATALINA_HOME/server/webapps/*

ADD target/*.jar $CATALINA_HOME/lib/

CMD ["catalina.sh", "run"]
