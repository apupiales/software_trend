case $1 in
start)
echo "Starting zookeeper server 1...."
sudo su -p - zookeeper -c "/usr/local/zookeeper/bin/zkServer.sh start"
echo "Starting zookeeper server 2...."
sudo su -p - zookeeper -c "/usr/local/zookeeper1/bin/zkServer.sh start"
;;

stop)
echo "Stoping zookeeper server 1...."
sudo su -p - zookeeper -c "/usr/local/zookeeper/bin/zkServer.sh stop"
echo "Stoping zookeeper server 1...."
sudo su -p - zookeeper -c "/usr/local/zookeeper1/bin/zkServer.sh stop"
;;

esac
