FROM iron/java:1.8-dev
MAINTAINER jbaptiste <jb@zen.ly>

ENV DRUID_VERSION   0.14.0-incubating

RUN cat /etc/apk/repositories
RUN apk update && apk add --update-cache wget tar bash curl vim openjdk8 \
    && mkdir /tmp/druid \ 
    && rm -rf /var/cache/apk/*

RUN mkdir -p /opt

RUN wget -q --no-check-certificate --no-cookies -O - \
     http://apache.mirror.vexxhost.com/incubator/druid/$DRUID_VERSION/apache-druid-$DRUID_VERSION-bin.tar.gz | tar -xzf - -C /opt \
      && ln -s /opt/apache-druid-$DRUID_VERSION /opt/druid

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
ENV DRUID_S3_BUCKET_NAME "-"

# The following is a bogus env set to comply with Amazon S3 API as of Druid-0.14.0. We use minio as a gateway to 
# S3, so any region speciifed here won't have any effect:
ENV AWS_REGION=us-east-1

#ADD druid-0.10.1-bin.tar.gz /opt/
#RUN ln -s /opt/druid-$DRUID_VERSION /opt/druid 
COPY hadoop-dependencies/hadoop-aws-2.7.3.jar /opt/druid/hadoop-dependencies/hadoop-client/2.7.3/
COPY extensions/ /opt/druid/extensions/
COPY lib/* /opt/druid/lib/
COPY conf /opt/druid/conf
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

