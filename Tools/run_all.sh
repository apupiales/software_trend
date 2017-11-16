#!/bin/bash
case $1 in
start)
echo "Iniciando Fase 1 Britanico..."
echo "Iniciando HADOOP..."
./run_hdfs.sh start
echo "Limpiando Sistema de Archivos..."
su - hive -c /media/hive/Data/tools/clean_hdfs.sh
echo "Iniciando ZOOKEEPER..."
./run_zookeeper.sh start
echo "Iniciando HIVE..."
./run_hive.sh start
echo "Ejecucion 5N-EN-GB-Part1..."
su - hive -c "/usr/local/hive/bin/hive -f /media/hive/Data/tools/5N-EN-GB-Part1.q"
echo "Deteniendo HIVE..."
./run_hive.sh stop
echo "Deteniendo ZOOKEEPER..."
./run_zookeeper.sh stop
echo "Iniciando Fase 2 Britanico..."
echo "Limpiando Sistema de Archivos..."
su - hive -c /media/hive/Data/tools/clean_hdfs.sh
echo "Iniciando ZOOKEEPER..."
./run_zookeeper.sh start
echo "Iniciando HIVE..."
./run_hive.sh start
echo "Ejecucion 5N-EN-GB-Part2..."
su - hive -c "/usr/local/hive/bin/hive -f /media/hive/Data/tools/5N-EN-GB-Part2.q"
echo "Deteniendo HIVE..."
./run_hive.sh stop
echo "Deteniendo ZOOKEEPER..."
./run_zookeeper.sh stop
echo "Iniciando Fase 3 Britanico..."
echo "Limpiando Sistema de Archivos..."
su - hive -c /media/hive/Data/tools/clean_hdfs.sh
echo "Iniciando ZOOKEEPER..."
./run_zookeeper.sh start
echo "Iniciando HIVE..."
./run_hive.sh start
echo "Ejecucion 5N-EN-GB-Part3..."
su - hive -c "/usr/local/hive/bin/hive -f /media/hive/Data/tools/5N-EN-GB-Part3.q"
echo "Deteniendo HIVE..."
./run_hive.sh stop
echo "Deteniendo ZOOKEEPER..."
./run_zookeeper.sh stop
echo "Iniciando Fase 1 Americano..."
echo "Limpiando Sistema de Archivos..."
su - hive -c /media/hive/Data/tools/clean_hdfs.sh
echo "Iniciando ZOOKEEPER..."
./run_zookeeper.sh start
echo "Iniciando HIVE..."
./run_hive.sh start
echo "Ejecucion 5N-EN-US-Part1..."
su - hive -c "/usr/local/hive/bin/hive -f /media/hive/Data/tools/5N-EN-US-Part1.q"
echo "Deteniendo HIVE..."
./run_hive.sh stop
echo "Deteniendo ZOOKEEPER..."
./run_zookeeper.sh stop
echo "Iniciando Fase 2 Americano..."
echo "Limpiando Sistema de Archivos..."
su - hive -c /media/hive/Data/tools/clean_hdfs.sh
echo "Iniciando ZOOKEEPER..."
./run_zookeeper.sh start
echo "Iniciando HIVE..."
./run_hive.sh start
echo "Ejecucion 5N-EN-US-Part2..."
su - hive -c "/usr/local/hive/bin/hive -f /media/hive/Data/tools/5N-EN-US-Part2.q"
echo "Deteniendo HIVE..."
./run_hive.sh stop
echo "Deteniendo ZOOKEEPER..."
./run_zookeeper.sh stop
echo "Iniciando Fase 3 Americano..."
echo "Limpiando Sistema de Archivos..."
su - hive -c /media/hive/Data/tools/clean_hdfs.sh
echo "Iniciando ZOOKEEPER..."
./run_zookeeper.sh start
echo "Iniciando HIVE..."
./run_hive.sh start
echo "Ejecucion 5N-EN-US-Part3..."
su - hive -c "/usr/local/hive/bin/hive -f /media/hive/Data/tools/5N-EN-US-Part3.q"
echo "Deteniendo HIVE..."
./run_hive.sh stop
echo "Deteniendo ZOOKEEPER..."
./run_zookeeper.sh stop
echo "Iniciando Fase 4 Americano..."
echo "Limpiando Sistema de Archivos..."
su - hive -c /media/hive/Data/tools/clean_hdfs.sh
echo "Iniciando ZOOKEEPER..."
./run_zookeeper.sh start
echo "Iniciando HIVE..."
./run_hive.sh start
echo "Ejecucion 5N-EN-US-Part4..."
su - hive -c "/usr/local/hive/bin/hive -f /media/hive/Data/tools/5N-EN-US-Part4.q"
echo "Deteniendo HIVE..."
./run_hive.sh stop
echo "Deteniendo ZOOKEEPER..."
./run_zookeeper.sh stop
echo "Iniciando Fase 5 Americano..."
echo "Limpiando Sistema de Archivos..."
su - hive -c /media/hive/Data/tools/clean_hdfs.sh
echo "Iniciando ZOOKEEPER..."
./run_zookeeper.sh start
echo "Iniciando HIVE..."
./run_hive.sh start
echo "Ejecucion 5N-EN-US-Part5..."
su - hive -c "/usr/local/hive/bin/hive -f /media/hive/Data/tools/5N-EN-US-Part5.q"
echo "Deteniendo HIVE..."
./run_hive.sh stop
echo "Deteniendo ZOOKEEPER..."
./run_zookeeper.sh stop
echo "Iniciando Fase 6 Americano..."
echo "Limpiando Sistema de Archivos..."
su - hive -c /media/hive/Data/tools/clean_hdfs.sh
echo "Iniciando ZOOKEEPER..."
./run_zookeeper.sh start
echo "Iniciando HIVE..."
./run_hive.sh start
echo "Ejecucion 5N-EN-US-Part6..."
su - hive -c "/usr/local/hive/bin/hive -f /media/hive/Data/tools/5N-EN-US-Part6.q"
echo "Deteniendo HIVE..."
./run_hive.sh stop
echo "Deteniendo ZOOKEEPER..."
./run_zookeeper.sh stop
echo "Iniciando Fase 7 Americano..."
echo "Limpiando Sistema de Archivos..."
su - hive -c /media/hive/Data/tools/clean_hdfs.sh
echo "Iniciando ZOOKEEPER..."
./run_zookeeper.sh start
echo "Iniciando HIVE..."
./run_hive.sh start
echo "Ejecucion 5N-EN-US-Part7..."
su - hive -c "/usr/local/hive/bin/hive -f /media/hive/Data/tools/5N-EN-US-Part7.q"
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
