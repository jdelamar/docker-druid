FROM iron/java:1.8-dev
MAINTAINER jbaptiste <jb@zen.ly>

# Java config
ENV DRUID_VERSION   0.12.3
#ENV JAVA_HOME       /opt/jdk1.8.0_131
#ENV PATH            $PATH:/opt/jdk1.8.0_131/bin

RUN cat /etc/apk/repositories
RUN apk update && apk add --update-cache wget tar bash curl vim openjdk8 \
    && mkdir /tmp/druid \ 
    && rm -rf /var/cache/apk/*

RUN mkdir -p /opt
# RUN wget -q --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" -O - \
#      http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/server-jre-8u131-linux-x64.tar.gz | tar -xzf - -C /opt
 
RUN wget -q --no-check-certificate --no-cookies -O - \
      http://static.druid.io/artifacts/releases/druid-$DRUID_VERSION-bin.tar.gz | tar -xzf - -C /opt \
      && ln -s /opt/druid-$DRUID_VERSION /opt/druid

RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.1/dumb-init_1.2.1_amd64
RUN chmod +x /usr/local/bin/dumb-init


# Druid env variable
ENV DRUID_XMX           '-'
ENV DRUID_XMS           '-'
ENV DRUID_NEWSIZE       '-'
ENV DRUID_MAXNEWSIZE    '-'
ENV DRUID_HOSTNAME      '-'
ENV DRUID_LOGLEVEL      '-'
ENV DRUID_USE_CONTAINER_IP      '-'
ENV DRUID_MAX_DIRECTMEM_SIZE "-"
ENV DRUID_MIDDLEMANAGER_NUM_WORKERS "-"
ENV DRUID_HISTORICAL_NUM_PROCESSING_THREADS "-"
ENV DRUID_PROCESSING_BUFFER_SIZEBYTES "-"
ENV DRUID_PEONS_JAVA_XMX "-"
ENV DRUID_SERVER_MAX_SIZE "-"
ENV DRUID_CACHE_SIZE "-"


#ADD druid-0.10.1-bin.tar.gz /opt/
#RUN ln -s /opt/druid-$DRUID_VERSION /opt/druid 
COPY hadoop-dependencies/hadoop-aws-2.7.3.jar /opt/druid/hadoop-dependencies/hadoop-client/2.7.3/
COPY extensions/ /opt/druid/extensions/
COPY lib/* /opt/druid/lib/
COPY conf /opt/druid-$DRUID_VERSION/conf
COPY docker-entrypoint.sh /docker-entrypoint.sh

# JMX exporter java agent
COPY jmx_exporter/jmx_exporter.conf.yaml /jmx_exporter.conf.yaml
COPY jmx_exporter/jmx_prometheus_javaagent-0.3.1.jar /jmx_prometheus_javaagent-0.3.1.jar

RUN mkdir -p /tmp/druid
EXPOSE 8090 8081 8080 8082
# dumb-init must be used for all entrypoint
# Note that Druid swarm task or docker run will typically be run with a CMD having the node flavor that
# must be started (such as overlord, middlemanager, etc...

ENTRYPOINT ["/usr/local/bin/dumb-init", "--", "/docker-entrypoint.sh"] 

