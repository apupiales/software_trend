#HADOOP VARIABLES START
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export HADOOP_INSTALL=/usr/local/hadoop
export HADOOP_CONF_DIR=$HADOOP_INSTALL/etc/hadoop
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

case $1 in
start)
su -p - hduser -c $HADOOP_INSTALL/sbin/start-dfs.sh
su -p - yarn -c $HADOOP_INSTALL/sbin/start-yarn.sh
su -p - hduser -c "$HADOOP_INSTALL/sbin/mr-jobhistory-daemon.sh start historyserver"
;;

stop)
su -p - hduser -c "$HADOOP_INSTALL/sbin/mr-jobhistory-daemon.sh stop historyserver"
su -p - yarn -c $HADOOP_INSTALL/sbin/stop-yarn.sh
su -p - hduser -c $HADOOP_INSTALL/sbin/stop-dfs.sh
;;

esac
