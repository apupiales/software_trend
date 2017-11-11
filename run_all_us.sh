#!/bin/bash
case $1 in
start)
echo "Iniciando Fase Americano..."
echo "Iniciando HADOOP..."
./run_hdfs.sh start
echo "Iniciando ZOOKEEPER..."
./run_zookeeper.sh start
echo "Iniciando HIVE..."
./run_hive.sh start
echo "Ejecucion..."
su - hive -c "/usr/local/hive/bin/hive -f /media/hive/Data/tools/5N-EN-US-COMPARISON-B.q"
;;

stop)
echo "Deteniendo HIVE..."
./run_hive.sh stop
echo "Deteniendo ZOOKEEPER..."
./run_zookeeper.sh stop
echo "Deteniendo HADOOP..."
./run_hdfs.sh stop
;;

esac
