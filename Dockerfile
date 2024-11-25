FROM openjdk:17-bullseye

LABEL maintainer="danoooob" version="6.1.2"

ARG ATLASSIAN_PRODUCTION=crowd-webapp
ARG APP_NAME=crowd
ARG APP_VERSION=6.1.2
ARG AGENT_VERSION=1.3.3
ARG MYSQL_DRIVER_VERSION=8.0.22

ENV CROWD_HOME=/var/crowd \
    CROWD_INSTALL=/opt/crowd \
    JVM_MINIMUM_MEMORY=2g \
    JVM_MAXIMUM_MEMORY=8g \
    JVM_CODE_CACHE_ARGS='-XX:InitialCodeCacheSize=2g -XX:ReservedCodeCacheSize=4g' \
    AGENT_PATH=/var/agent \
    AGENT_FILENAME=atlassian-agent.jar \
    LIB_PATH=/crowd-webapp/WEB-INF/lib

ENV JAVA_OPTS="-javaagent:${AGENT_PATH}/${AGENT_FILENAME} ${JAVA_OPTS}"

RUN mkdir -p ${CROWD_INSTALL} ${CROWD_HOME} ${AGENT_PATH} ${CROWD_INSTALL}${LIB_PATH}
RUN curl -o ${AGENT_PATH}/${AGENT_FILENAME}  https://github.com/haxqer/jira/releases/download/v${AGENT_VERSION}/atlassian-agent.jar -L
RUN curl -o /tmp/atlassian.tar.gz https://product-downloads.atlassian.com/software/crowd/downloads/atlassian-${APP_NAME}-${APP_VERSION}.tar.gz -L
RUN tar xzf /tmp/atlassian.tar.gz -C /opt/crowd/ --strip-components 1
RUN rm -f /tmp/atlassian.tar.gz
RUN curl -o ${CROWD_INSTALL}/apache-tomcat/lib/mysql-connector-java-${MYSQL_DRIVER_VERSION}.jar https://repo1.maven.org/maven2/mysql/mysql-connector-java/${MYSQL_DRIVER_VERSION}/mysql-connector-java-${MYSQL_DRIVER_VERSION}.jar -L
RUN cp ${CROWD_INSTALL}/apache-tomcat/lib/mysql-connector-java-${MYSQL_DRIVER_VERSION}.jar ${CROWD_INSTALL}${LIB_PATH}/mysql-connector-java-${MYSQL_DRIVER_VERSION}.jar
RUN echo "crowd.home = ${CROWD_HOME}" > ${CROWD_INSTALL}/${ATLASSIAN_PRODUCTION}/WEB-INF/classes/crowd-init.properties

WORKDIR $CROWD_INSTALL
EXPOSE 8095

ENTRYPOINT ["/opt/crowd/start_crowd.sh", "-fg"]