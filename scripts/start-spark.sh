#!/bin/bash

. "/opt/spark/bin/load-spark-env.sh"

if [ "$SPARK_WORKLOAD" == "master" ]; then
  export SPARK_MASTER_HOST=${HOSTNAME}
  echo "Starting Spark Master on $SPARK_MASTER_HOST"
  cd /opt/spark/bin && ./spark-class org.apache.spark.deploy.master.Master \
    --ip $SPARK_MASTER_HOST \
    --port $SPARK_MASTER_PORT \
    --webui-port $SPARK_MASTER_WEBUI_PORT >>$SPARK_MASTER_LOG

elif [ "$SPARK_WORKLOAD" == "worker" ]; then
  echo "Starting Spark Worker connecting to $SPARK_MASTER"
  cd /opt/spark/bin && ./spark-class org.apache.spark.deploy.worker.Worker \
    --webui-port $SPARK_WORKER_WEBUI_PORT \
    $SPARK_MASTER >>$SPARK_WORKER_LOG

elif [ "$SPARK_WORKLOAD" == "submit" ]; then
  echo "Starting Spark Submit mode"
  tail -f /dev/null

else
  echo "Undefined Workload Type: $SPARK_WORKLOAD"
  echo "Must specify: master, worker, or submit"
  exit 1
fi
