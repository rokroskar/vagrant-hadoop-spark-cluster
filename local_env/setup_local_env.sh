#!/bin/bash

echo "Setting up environment to use hadoop VM cluster..."

VM_BASE_DIR=${HOME}/vagrant-hadoop-spark-cluster

export HADOOP_PREFIX=~/hadoop
export HADOOP_HOME=$HADOOP_PREFIX
export HADOOP_YARN_HOME=${HADOOP_PREFIX}
export HADOOP_CONF_DIR=${VM_BASE_DIR}/local_env/hadoop
export YARN_LOG_DIR=${HADOOP_YARN_HOME}/logs
export YARN_IDENT_STRING=root
export HADOOP_MAPRED_IDENT_STRING=root
export PATH=${HADOOP_PREFIX}/bin:${PATH}

if [ -z "$JAVA_HOME" ]; then echo "JAVA_HOME is unset"; else echo "JAVA_HOME is set to '$JAVA_HOME'"; fi

