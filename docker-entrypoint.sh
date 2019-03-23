#!/bin/bash
set -e

: ${COORDINATOR_IP='coordinator'}
: ${COORDINATOR_PORT='8081'}
: ${KAFKA_BROKER_HOSTNAME='kafka'}
: ${KAFKA_BROKER_PORT='9092'}

echo "Starting $@ with the following"
echo "DRUID_XMX ${DRUID_XMX}"
echo "DRUID_XMS ${DRUID_XMS}"
echo "DRUID_MAXNEWSIZE ${DRUID_MAXNEWSIZE}"
echo "DRUID_NEWSIZE ${DRUID_NEWSIZE}"
echo "DRUID_HOSTNAME ${DRUID_HOSTNAME}"
echo "DRUID_LOGLEVEL ${DRUID_LOGLEVEL}"
echo "DRUID_USE_CONTAINER_IP ${DRUID_USE_CONTAINER_IP}"
echo "DRUID_MAX_DIRECTMEM_SIZE ${DRUID_MAX_DIRECTMEM_SIZE}"
echo "DRUID_MIDDLEMANAGER_NUM_WORKERS ${DRUID_MIDDLEMANAGER_NUM_WORKERS}"
echo "DRUID_HISTORICAL_NUM_PROCESSING_THREADS ${DRUID_HISTORICAL_NUM_PROCESSING_THREADS}"
echo "DRUID_PROCESSING_BUFFER_SIZEBYTES ${DRUID_PROCESSING_BUFFER_SIZEBYTES}"
echo "DRUID_PEONS_JAVA_OPTS ${DRUID_PEONS_JAVA_XMX}"
echo "DRUID_SERVER_MAX_SIZE ${DRUID_SERVER_MAX_SIZE}"
echo "COORDINATOR_IP ${COORDINATOR_IP}"
echo "COORDINATOR_PORT ${COORDINATOR_PORT}"
echo "DRUID_CACHE_SIZE ${DRUID_CACHE_SIZE}"
echo "DRUID_S3_BUCKET_NAME ${DRUID_S3_BUCKET_NAME}"

echo "ipaddress ${ipaddress}"


# Run as broker if needed
if [ "${1:0:1}" = '' ]; then
    set -- broker "$@"
fi
if [ "$DRUID_XMX" != "-" ]; then
    sed -ri 's/Xmx.*/Xmx'${DRUID_XMX}'/g' /opt/druid/conf/druid/$1/jvm.config
fi
if [ "$DRUID_XMS" != "-" ]; then
    sed -ri 's/Xms.*/Xms'${DRUID_XMS}'/g' /opt/druid/conf/druid/$1/jvm.config
fi
if [ "$DRUID_MAXNEWSIZE" != "-" ]; then
    sed -ri 's/MaxNewSize=.*/MaxNewSize='${DRUID_MAXNEWSIZE}'/g' /opt/druid/conf/druid/$1/jvm.config
fi
if [ "$DRUID_NEWSIZE" != "-" ]; then
    sed -ri 's/NewSize=.*/NewSize='${DRUID_NEWSIZE}'/g' /opt/druid/conf/druid/$1/jvm.config
fi
if [ "$DRUID_HOSTNAME" != "-" ]; then
    sed -ri 's/druid.host=.*/druid.host='${DRUID_HOSTNAME}'/g' /opt/druid/conf/druid/$1/runtime.properties
elif [ "$DRUID_HOSTNAME" = "-" ]; then
    sed -ri 's/druid.host=.*//g' /opt/druid/conf/druid/$1/runtime.properties
fi
if [ "$DRUID_LOGLEVEL" != "-" ]; then
    sed -ri 's/druid.emitter.logging.logLevel=.*/druid.emitter.logging.logLevel='${DRUID_LOGLEVEL}'/g' /opt/druid/conf/druid/_common/common.runtime.properties
fi

# Set the druid.emitter property to the value of DRUID_EMITTER (defaults to http when not set)
sed -ri "s/^druid.emitter=.*$/druid.emitter=${DRUID_EMITTER:-logging}/g" /opt/druid/conf/druid/_common/common.runtime.properties

if [ "$DRUID_USE_CONTAINER_IP" != "-" ]; then
    ipaddress=`ip a|grep "global eth0"|awk '{print $2}'|awk -F '\/' '{print $1}'`
    sed -ri 's/druid.host=.*/druid.host='${ipaddress}'/g' /opt/druid/conf/druid/$1/runtime.properties
fi
if [ "$DRUID_MAX_DIRECTMEM_SIZE" != "-" ]; then
    sed -ri 's/MaxDirectMemorySize.*/MaxDirectMemorySize='${DRUID_MAX_DIRECTMEM_SIZE}'/g' /opt/druid/conf/druid/$1/jvm.config
fi

if [ "$DRUID_MIDDLEMANAGER_NUM_WORKERS" != "-" ]; then
   sed -ri 's/druid.worker.capacity=.*/druid.worker.capacity='${DRUID_MIDDLEMANAGER_NUM_WORKERS}'/g' /opt/druid/conf/druid/$1/runtime.properties
fi

if [ "${DRUID_HISTORICAL_NUM_PROCESSING_THREADS}" != "-" ]; then
   sed -ri 's/druid.processing.numThreads=.*/druid.processing.numThreads='${DRUID_HISTORICAL_NUM_PROCESSING_THREADS}'/g' /opt/druid/conf/druid/$1/runtime.properties
fi

if [ "${DRUID_PROCESSING_BUFFER_SIZEBYTES}" != "-" ]; then
   sed -ri 's/druid.processing.buffer.sizeBytes=.*/druid.processing.buffer.sizeBytes='${DRUID_PROCESSING_BUFFER_SIZEBYTES}'/g' /opt/druid/conf/druid/$1/runtime.properties
fi

if [ "${DRUID_CACHE_SIZE}" != "-" ]; then
   sed -ri 's/druid.cache.sizeInBytes=.*/druid.cache.sizeInBytes='${DRUID_CACHE_SIZE}'/g' /opt/druid/conf/druid/$1/runtime.properties
fi

if [ "${DRUID_SERVER_MAX_SIZE}" != "-" ]; then
	sed -ri 's/druid.server.maxSize=.*/druid.server.maxSize='${DRUID_SERVER_MAX_SIZE}'/g' /opt/druid/conf/druid/$1/runtime.properties
	sed -ri 's|druid.segmentCache.locations=.*|druid.segmentCache.locations=[{"path":"var/druid/segment-cache","maxSize":'${DRUID_SERVER_MAX_SIZE}'}]|g' /opt/druid/conf/druid/$1/runtime.properties
fi
if [ "${DRUID_PEONS_JAVA_XMX}" != "-" ]; then
   sed -ri "s/PEON_SIZE/${DRUID_PEONS_JAVA_XMX}/g" /opt/druid/conf/druid/$1/runtime.properties
elif [ "${DRUID_PEONS_JAVA_XMX}" = "-" ]; then
   sed -ri "s/PEON_SIZE/4000m/g" /opt/druid/conf/druid/$1/runtime.properties
fi

if [ "${DRUID_S3_BUCKET_NAME}" != "-" ]; then
    sed -ri "s/^druid.storage.bucket=.*$/druid.storage.bucket=${DRUID_S3_BUCKET_NAME}/g" /opt/druid/conf/druid/_common/common.runtime.properties
    sed -ri "s/^druid.indexer.logs.s3Bucket=.*$/druid.indexer.logs.s3Bucket=${DRUID_S3_BUCKET_NAME}/g" /opt/druid/conf/druid/_common/common.runtime.properties
    sed -ri "s/^druid.indexer.logs.s3Bucket=.*$/druid.indexer.logs.s3Bucket=${DRUID_S3_BUCKET_NAME}/g" /opt/druid/conf/druid/$1/runtime.properties
fi

if [ "$1" != "coordinator" ]; then
	echo "Waiting for the coordinator to come online at ${COORDINATOR_IP} port ${COORDINATOR_PORT}"
	until nc -z -w 2 ${COORDINATOR_IP} ${COORDINATOR_PORT}; do sleep 1; done
fi
echo "Waiting for kafka server @ $KAFKA_BROKER_HOSTNAME:$KAFKA_BROKER_PORT to start... "
until nc -z -w 2 ${KAFKA_BROKER_HOSTNAME} ${KAFKA_BROKER_PORT}; do sleep 1; done
echo "Kafka brokers are now online @ $KAFKA_BROKER_HOSTNAME:$KAFKA_BROKER_PORT"

# Java agent is used to forward JMX metrics to prometheus.
java -javaagent:/jmx_prometheus_javaagent-0.3.1.jar=9123:/jmx_exporter.conf.yaml `cat /opt/druid/conf/druid/$1/jvm.config | xargs` -cp /opt/druid/conf/druid/_common:/opt/druid/conf/druid/$1:/opt/druid/lib/* io.druid.cli.Main server $@
