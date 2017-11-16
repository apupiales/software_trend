#HADOOP VARIABLES START
export JAVA_HOME=/usr/lib/jvm/java-8-oracle
export HADOOP_INSTALL=/usr/local/hadoop
export HADOOP_CONF_DIR=$HADOOP_INSTALL/etc/hadoop
export YARN_CONF_DIR=$HADOOP_INSTALL/etc/hadoop
export PATH=$PATH:$HADOOP_INSTALL/bin
export PATH=$PATH:$HADOOP_INSTALL/sbin
export HADOOP_MAPRED_HOME=$HADOOP_INSTALL
export HADOOP_COMMON_HOME=$HADOOP_INSTALL
export HADOOP_HDFS_HOME=$HADOOP_INSTALL
export YARN_HOME=$HADOOP_INSTALL
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_INSTALL/lib/native
export HADOOP_OPTS="-Djava.library.path=$HADOOP_INSTALL/lib"
export HADOOP_OPTS="$HADOOP_OPTS -Djava.library.path=$HADOOP_INSTALL/lib/native"
export JAVA_LIBRARY_PATH=$HADOOP_INSTALL/lib/native
export LD_LIBRARY_PATH=$HADOOP_INSTALL/lib/native:$LD_LIBRARY_PATH
export YARN_EXAMPLES=$HADOOP_INSTALL/share/hadoop/mapreduce
export HADOOP_MAPRED_STOP_TIMEOUT=30
export YARN_STOP_TIMEOUT=30
#HADOOP VARIABLES END

#PIG VARIABLES
export PIG_HOME=/usr/local/pig
export PATH=$PATH:$PIG_HOME/bin
export PIG_CLASSPATH=$PIG_HOME/conf:$HADOOP_INSTALL/etc/hadoop
#PIG VARIABLES END

#HIVE_VARIABLES
export HIVE_HOME=/usr/local/hive
export PATH=$PATH:$HIVE_HOME/bin


case $1 in
start)
echo "Starting metastore..."
su - hive -c "nohup /usr/local/hive/bin/hive --service metastore > /usr/local/hive/logs/hivemetastore.log 2>&1 &"
sleep 20
su - hive -c "ps -U hive -f | grep metastore | awk '\$8 ~ /oracle/ {print \$2}' > /usr/local/hive/metastore.pid"
echo "Starting hiveserver2..."
su - hive -c "nohup /usr/local/hive/bin/hiveserver2 > /usr/local/hive/logs/hiveserver2.log 2>&1 &"
sleep 10
su - hive -c "ps -U hive -f | grep HiveServer | awk '\$8 ~ /oracle/ {print \$2}' > /usr/local/hive/hiveserver2.pid"
;;

stop)
echo "Stopping hiveserver2..."
su - hive -c "kill `cat /usr/local/hive/hiveserver2.pid`"
sleep 10
echo "Stopping metastore..."
su - hive -c "kill `cat /usr/local/hive/metastore.pid`"
sleep 10
;;

esac
