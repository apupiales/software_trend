#!/bin/bash
case $1 in
start)
echo "Limpiando Sistema de Archivos..."
su - wisk -c ~/tools/clean_hdfs_2.sh
echo "Ejecucion..."
su - hive -c "/usr/local/hive/bin/hive -f /home/wisk/tools/5N-EN-COMPARISON.q"
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
