# Dockerfile for Cyclos project (http://www.cyclos.org)
FROM tomcat:jre8

# Environmet setup
ENV CYCLOS_VERSION 4.13
ENV CYCLOS_HOME /usr/local/cyclos
ENV CYCLOS_LOGDIR /var/log/cyclos

# Download and extract the Cyclos package, and remove the temporary files.
# The ca-certificates / openssl packages are left because they could be needed in runtime.
RUN set -x && \
    apt-get update && apt-get install -y ca-certificates openssl fonts-dejavu && \
    wget "https://license.cyclos.org/downloads/cyclos/cyclos-${CYCLOS_VERSION}.zip" -O /tmp/cyclos.zip && \
    unzip /tmp/cyclos.zip -d /tmp && \
    mkdir -p ${CYCLOS_HOME} && \
    mkdir -p ${CYCLOS_LOGDIR} && \
    mv /tmp/cyclos-${CYCLOS_VERSION}/web/* ${CYCLOS_HOME} && \
    rm -rf /tmp/cyclos* &&\
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Change the workdir to CYCLOS_HOME and copy the docker properties to the regular properties
WORKDIR ${CYCLOS_HOME}
RUN cp WEB-INF/classes/cyclos-docker.properties WEB-INF/classes/cyclos.properties

# Tomcat setup
RUN rm -rf /usr/local/tomcat/webapps/*
RUN ln -s ${CYCLOS_HOME} /usr/local/tomcat/webapps/ROOT
COPY context.xml /usr/local/tomcat/conf/context.xml

# Set the log dir as a persistent volume
VOLUME ${CYCLOS_LOGDIR}
