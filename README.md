# Software_Trend
Final project of trends in software engineering

# Minimum Hardware and OS Requirements:

 * OS: Ubuntu 16.04
 * HDD: 1 TB SSD
 * HDD2: 2TB 
 * RAM: 8GB DDR4
 * CPU: Quad Core 2.2 Ghz

For execution follow the next steps with a user with sudo permissions:

# Install HADOOP

1. Install Oracle Java 8
   
   Open a terminal session and execute the following commands with a user that has sudo privileges
   ```
   sudo apt-get update
   sudo apt-get install default-jre
   sudo apt-get install default-jdk
   sudo add-apt-repository ppa:webupd8team/java
   sudo apt-get update
   sudo apt-get install oracle-java8-installer
   ```
2. Configure JAVA_HOME

   Execute the following command in terminal console to determinate java install path
   ```
   sudo update-alternatives --config java
   ```          
   Copy the preferred install path and open /etc/environment with the prefered editor. P.E: nano, gedit
   
   `sudo nano /etc/environment` or `sudo gedit /etc/environment`
   
   Add the following line at the end of the file replacing the <path> with the preferred install path surrounded by double quotes
   
   `JAVA_HOME=<path>` P.E: `JAVA_HOME="/usr/lib/jvm/java-8-oracle"`
   
   Save, close the file and proceed to reload it with the next command
   ```
   source /etc/environment
   ```
   Test the new environment variable
   ```
   echo $JAVA_HOME
   ```
3. Install SSH

   Execute the following command in terminal
   ```   
   sudo apt-get install ssh
   ```         
4. Update OS Limits

   Set limits in /etc/security/limits.conf.  Without these the hadoop instance may get below error and will get occasionally killed by OS. First open the file for edit
   ```
   sudo nano /etc/security/limits.conf` or `sudo gedit /etc/security/limits.conf
   ```
   Add the following lines at the end of the file
   ```   
   *        hard    nofile        50000
   *        soft    nofile        50000
   *        hard    nproc         10000
   *        soft    nproc         10000
   ```
5. Workaround for "Kill" command

   Open the file logind.conf under the path /etc/systemd/logind.conf with your preferred editor
      
   P.E: `sudo nano /etc/systemd/logind.conf` or `sudo gedit /etc/systemd/logind.conf `
          
   Remove the hash (#) symbol from the line
   ```   
   KillUserProcesses=no
   ```
   Save and close the file
6. Add users for HDFS and Yarn

   Create users which will own and run hdfs and yarn processes, also create hadoop group and make all bigdata users part of it. In order to do that execute the following commands:
   ```
   sudo addgroup hadoop
   sudo adduser --ingroup hadoop hduser
   sudo adduser --ingroup hadoop yarn
   sudo usermod -a -G hadoop kamal
   ```         
7. Setup SSH

   * Create the public and private key for hdfs user. **Note:** Press ENTER when asked for a file
     ```
     sudo su - hduser
     ssh-keygen -t rsa -P "" 
     ```            
   * Save the generated public key as authorized key
     ``` 
     cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys
     ```
   * Test SSH for hdfs user. **Note:** Enter 'yes' when prompt for confirmation.
     ``` 
     ssh localhost
     exit
     exit
     ```
   * Repeat the previous three (3) steps for user yarn with the following commands
     ``` 
     sudo su - yarn
     ssh-keygen -t rsa -P ""
     cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys
     ssh localhost
     exit
     exit
     ```            
8. Download HADOOP distribution
   
   * Locate in the Downloads directory
     ```         
     cd Downloads/
     ```
   * Download the distribution (2.8.2 at the moment)
     ```
     wget http://www.apache.org/dyn/closer.cgi/hadoop/common/hadoop-2.8.2/hadoop-2.8.2.tar.gz
     ```
   * Untar the downloaded file using the following command
     ``` 
     tar xvf hadoop-2.8.2.tar.gz
     ```
   * Move and rename the folder to his final destination
     ``` 
     sudo mv hadoop-2.8.2  /usr/local/hadoop
     ```
9. Create and set permissions for directories

   * Execute the following commands to create the paths for datanode and namenode
     ``` 
     sudo mkdir -p /usr/local/hadoop/data/namenode
     sudo mkdir -p /usr/local/hadoop/data/datanode
     sudo mkdir -p /usr/local/hadoop/logs
     sudo chmod 777 /tmp
     ```       
   * Ensure hadoop user owns the previous folders
     ``` 
     cd /usr/local
     sudo chown -R hduser:hadoop hadoop
     sudo su - hduser
     chmod g+w /usr/local/hadoop/logs
     exit
     ```       
10. Configure HADOOP

    * Set environment variables for HADOOP, in order to do this the **.bashrc** file has to be modified for the **hduser, yarn, and user accounts**, the file is modified using the preferred editor
      ``` 
      sudo su - hduser
      ```
      `gedit .bashrc` or `nano .bashrc`
            
    * Add the following block at the end of the file and then save it:
      ```
      #HADOOP VARIABLES START
      export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
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
      ```            
11. Setup configuration files

    * Move to hadoop configuration directory and edit configuration files.
      ```
      cd /usr/local/hadoop/etc/hadoop
      ```
    There are two (2) options, copy the files from the **Hadoop** folder in this repository (Only if you have followed these step by step) or configure each file manually, if this is the case then:
      
    * Open the file **core-site.xml**
          
      `sudo gedit core-site.xml` or `sudo nano core-site.xml`
            
    * Replace the content between the **\<configuration>** tags with:
      ```
      <property>
            <name>fs.defaultFS</name>
            <value>hdfs://localhost:9000</value>
      </property>
      ```
    * Save and close file **core-site.xml**
         
    * Open file **hdfs-site.xml**
         
      `sudo gedit hdfs-site.xml` or `sudo nano hdfs-site.xml`
            
    * Replace the content between the **\<configuration>** tags with:
      ```
      <property>
          <name>dfs.replication</name>
          <value>1</value>
      </property>
      <property>
          <name>dfs.namenode.name.dir</name>
          <value>file:/usr/local/hadoop/data/namenode</value>
      </property>
      <property>
          <name>dfs.datanode.data.dir</name>
          <value>file:/usr/local/hadoop/data/datanode</value>
      </property>
      <property>
          <name>dfs.permissions.superusergroup</name>
          <value>hadoop</value>
      </property>
      <property>
          <name>dfs.webhdfs.enabled</name>
          <value>true</value>
      </property>
      ```
    * Save and close file **hdfs-site.xml**
          
    * Create file **mapred-site.xml** from template executing the following commands
      ```
      su hduser
      cp mapred-site.xml.template mapred-site.xml
      exit
      ```
    * As with the previous files this one has to be opened
          
      `sudo gedit mapred-site.xml` or `sudo nano mapred-site.xml`
             
    * Replace the content between the **\<configuration>** tags with:
      ```
      <property>
          <name>mapreduce.framework.name</name>
          <value>yarn</value>
      </property>
      <property>
          <name>mapreduce.reduce.memory.mb</name>
          <value>1024</value>
      </property>
      <property>
          <name>mapreduce.map.memory.mb</name>
          <value>1024</value>
      </property>
      <property>
          <name>mapreduce.reduce.java.opts</name>
          <value>-Xmx500m</value>
      </property>
      <property>
          <name>mapreduce.map.java.opts</name>
          <value>-Xmx500m</value>
      </property>
      <property>
          <name>yarn.app.mapreduce.am.resource.mb</name>
          <value>512</value>
      </property>
      <property>
          <name>yarn.app.mapreduce.am.command-opts</name>
          <value>-Xmx200m</value>
      </property>
      <property>
          <name>mapreduce.jobhistory.done-dir</name>
          <value>/tmp/mr-history/done</value>
      </property>
      <property>
          <name>mapreduce.jobhistory.intermediate-done-dir</name>
          <value>/tmp/mr-history/intermediate</value>
      </property>
      <property>
          <name>mapreduce.task.userlog.limit.kb</name>
          <value>5000</value>
      </property>
      <property>
          <name>yarn.app.mapreduce.task.container.log.backups</name>
          <value>3</value>
      </property>
      <property>
          <name>mapred.userlog.retain.hours.max</name>
          <value>6</value>
      </property>
      ```
    * Save and close the file **mapred-site.xml**
    * Open file **hadoop-env.sh**
      
      `sudo gedit hadoop-env.sh` or `sudo nano hadoop-env.sh`
      
    * Configure **JAVA_HOME**
      ```
      export JAVA_HOME=/usr/lib/jvm/java-8-oracle
      ```
    * Save and close the file **hadoop-env.sh**
    * Open file **mapred-env.sh**
      
      `sudo gedit mapred-env.sh` or `sudo nano mapred-env.sh`
    * Configure the following
      ```
      export JAVA_HOME=/usr/lib/jvm/java-8-oracle
      export HADOOP_MAPRED_IDENT_STRING=hduser
      ```
    * Save and close file **mapred-env.sh**
    * Open file **yarn-site.xml**
      
      `sudo gedit yarn-site.xml` or `sudo nano yarn-site.xml`
    * Replace the content between the **\<configuration>** tags
      ```
      <property>
          <name>yarn.nodemanager.aux-services</name>
          <value>mapreduce_shuffle</value>
      </property>
      <property>
          <name>yarn.nodemanager.aux-services.mapreduce.shuffle.class</name>
          <value> org.apache.hadoop.mapred.ShuffleHandler</value>
      </property>
      <property>
          <name>yarn.resourcemanager.hostname</name>
          <value>localhost</value>
      </property>
      <property>
          <name>yarn.nodemanager.resource.memory-mb</name>
          <value>6144</value>
      </property>
      <property>
          <name>yarn.scheduler.minimum-allocation-mb</name>
          <value>1024</value>
      </property>
      <property>
          <name>yarn.scheduler.maximum-allocation-mb</name>
          <value>1024</value>
      </property>
      <property>
          <name>yarn.scheduler.minimum-allocation-vcores</name>
          <value>1</value>
      </property>
      <property>
          <name>yarn.scheduler.maximum-allocation-vcores</name>
          <value>2</value>
      </property>
      <property>
          <name>yarn.nodemanager.vmem-pmem-ratio</name>
          <value>6</value>
      </property>
      <property>
          <name>yarn.nodemanager.default-container-executor.log-dirs.permissions</name>
          <value>755</value>
      </property>
      ```
    * Save and close the file **yarn-site.xml**
12. Format Namenode
    * Format namenode and start, stop your hdfs first from hdfs account (first source your environment)
      ```
      source .bashrc 
      sudo su - hduser 
      $HADOOP_INSTALL/bin/hdfs namenode -format
      $HADOOP_INSTALL/sbin/start-dfs.sh Note: First time will prompt confirmation, type 'yes'
      $HADOOP_INSTALL/sbin/stop-dfs.sh 
      exit
      ```        
13. Start hdfs and resourcemanager
    * Execute the following commands
      ```
      sudo su -p - hduser -c $HADOOP_INSTALL/sbin/start-dfs.sh
      sudo su -p - yarn -c $HADOOP_INSTALL/sbin/start-yarn.sh
      ```        
14. Create user and history-server directories
    ```
    sudo su - hduser 
    hdfs dfs -mkdir -p /user/apa
    hdfs dfs -mkdir -p /tmp/mr-history/done
    hdfs dfs -mkdir -p /tmp/mr-history/intermediate 
    hdfs dfs -mkdir -p /tmp/hadoop-yarn 
    hdfs dfs -chown apa:hadoop  /user/apa
    hdfs dfs -chown hduser:hadoop /tmp
    hdfs dfs -chown hduser:hadoop /user
    hdfs dfs -chmod -R 1777 /tmp
    hdfs dfs -chmod 777 /tmp/mr-history
    hdfs dfs -chmod 777 /tmp/mr-history/done
    hdfs dfs -chmod 777 /tmp/mr-history/intermediate
    hdfs dfs -chmod 1777 /tmp/hadoop-yarn 
    exit 
    ```    
15. Start history server

    `sudo su -p - hduser -c "$HADOOP_INSTALL/sbin/mr-jobhistory-daemon.sh start historyserver"`
    
16. Verify Install

    `yarn jar $YARN_EXAMPLES/hadoop-mapreduce-examples-2.7.3.jar pi 16 1000`
    
17. Create start - stop script
    ```
    cat run_hdfs.sh
 
    #HADOOP VARIABLES START
    export JAVA_HOME=/usr/lib/jvm/java-8-oracle-amd64
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
    ```    
18. Start and Stop hdfs as below.
    ```
    chmod u+x run_hdfs.sh
    sudo ./run_hdfs.sh start
    sudo ./run_hdfs.sh stop
    ```    
# Install ZOOKEEPER

Apache zookeeper is used by hadoop components to co-ordinate  their actions across cluster.

1. Create a zookeeper user. We use this user for our installation
   ```
   sudo adduser --ingroup hadoop zookeeper
   ```
2. Download instance of Zookeeper (Latest Stable version 3.4.10 at the moment)
   ```
   cd Downloads/
   wget http://www-us.apache.org/dist/zookeeper/stable/zookeeper-3.4.10.tar.gz
   ```
3. Untar the binaries and make two (2) copies, one for each instance
   ```
   tar xvf zookeeper-3.4.10.tar.gz 
   sudo mv zookeeper-3.4.10 /usr/local/zookeeper
   tar xvf zookeeper-3.4.10.tar.gz
   sudo mv zookeeper-3.4.10 /usr/local/zookeeper1
   ```
4. Configure Zookeeper
   * Open file **zoo.cfg** with your preferred editor
   
     `sudo gedit /usr/local/zookeeper/conf/zoo.cfg` or `sudo nano /usr/local/zookeeper/conf/zoo.cfg`
   * Set the file as follows
     ```
     # The number of milliseconds of each tick
     tickTime=2000
     # The number of ticks that the initial
     # synchronization phase can take
     initLimit=10
     # The number of ticks that can pass between
     # sending a request and getting an acknowledgement
     syncLimit=5
     # the directory where the snapshot is stored.
     # do not use /tmp for storage, /tmp here is just
     # example sakes.
     dataDir=/usr/local/zookeeper/data
     # the port at which the clients will connect
     clientPort=2181
     # the maximum number of client connections.
     # increase this if you need to handle more clients
     #maxClientCnxns=60
     #
     # Be sure to read the maintenance section of the
     # administrator guide before turning on autopurge.
     #
     # http://zookeeper.apache.org/doc/current/zookeeperAdmin.html#sc_maintenance
     #
     # The number of snapshots to retain in dataDir
     #autopurge.snapRetainCount=3
     # Purge task interval in hours
     # Set to "0" to disable auto purge feature
     #autopurge.purgeInterval=1
     server.1=localhost:2888:3888
     server.2=localhost:2889:3889
     ```
5. Copy file **java.env** located in Zookeeper folder to **/usr/local/zookeeper/conf**
   ```
   sudo mv Zookeeper/java.env /usr/local/zookeeper/conf
   ```
6. Create data directory. In that directory, we need to create myid file, which will have only one character - 1, which tells this zookeeper server as to which server it is and accordingly which ports to use (from the last two lines in zoo.cfg).
   ```
   mkdir /usr/local/zookeeper/data
   mkdir /usr/local/zookeeper/logs
   echo "1" > /usr/local/zookeeper/data/myid
   ```
7. Configure second server
   * Open file **zoo.cfg** with your preferred editor
     
     `sudo gedit /usr/local/zookeeper1/conf/zoo.cfg` or `sudo nano /usr/local/zookeeper1/conf/zoo.cfg`
   * Set the file as follows
     ```
     # The number of milliseconds of each tick
     tickTime=2000
     # The number of ticks that the initial
     # synchronization phase can take
     initLimit=10
     # The number of ticks that can pass between
     # sending a request and getting an acknowledgement
     syncLimit=5
     # the directory where the snapshot is stored.
     # do not use /tmp for storage, /tmp here is just
     # example sakes.
     dataDir=/usr/local/zookeeper1/data
     # the port at which the clients will connect
     clientPort=2182
     # the maximum number of client connections.
     # increase this if you need to handle more clients
     #maxClientCnxns=60
     #
     # Be sure to read the maintenance section of the
     # administrator guide before turning on autopurge.
     #
     # http://zookeeper.apache.org/doc/current/zookeeperAdmin.html#sc_maintenance
     #
     # The number of snapshots to retain in dataDir
     #autopurge.snapRetainCount=3
     # Purge task interval in hours
     # Set to "0" to disable auto purge feature
     #autopurge.purgeInterval=1
     server.1=localhost:2888:3888
     server.2=localhost:2889:3889
     ```
8. Copy file **java.env** located in Zookeeper1 folder to **/usr/local/zookeeper1/conf**
   ```
   sudo mv Zookeeper1/java.env /usr/local/zookeeper1/conf
   ```
9. Create data directory for server 2
   ```
   mkdir /usr/local/zookeeper1/data
   mkdir /usr/local/zookeeper1/logs 
   echo "2" > /usr/local/zookeeper1/data/myid
   ```
10. Change ownership of directories
    ```
    sudo chown -R zookeeper:hadoop /usr/local/zookeeper
    sudo chown -R zookeeper:hadoop /usr/local/zookeeper1
    ```
11. Start server for test purposes
    ```
    apa@apa-Lenovo-ideapad-700-15ISK:~$ sudo su -p - zookeeper -c "/usr/local/zookeeper/bin/zkServer.sh start"
    ZooKeeper JMX enabled by default
    Using config: /usr/local/zookeeper/bin/../conf/zoo.cfg
    Starting zookeeper ... STARTED
    apa@apa-Lenovo-ideapad-700-15ISK:~$ sudo su -p - zookeeper -c "/usr/local/zookeeper1/bin/zkServer.sh start"
    ZooKeeper JMX enabled by default
    Using config: /usr/local/zookeeper1/bin/../conf/zoo.cfg
    Starting zookeeper ... STARTED
    apa@apa-Lenovo-ideapad-700-15ISK:~$ echo srvr | nc localhost 2181
    Zookeeper version: 3.4.10-39d3a4f269333c922ed3db283be479f9deacaa0f, built on 03/23/2017 10:13 GMT
    Latency min/avg/max: 0/0/0
    Received: 1
    Sent: 0
    Connections: 1
    Outstanding: 0
    Zxid: 0x0
    Mode: follower
    
    Node count: 4
    apa@apa-Lenovo-ideapad-700-15ISK:~$ echo srvr | nc localhost 2182
    Zookeeper version: 3.4.10-39d3a4f269333c922ed3db283be479f9deacaa0f, built on 03/23/2017 10:13 GMT
    Latency min/avg/max: 0/0/0
    Received: 1
    Sent: 0
    Connections: 1
    Outstanding: 0
    Zxid: 0x200000000
    Mode: leader
    Node count: 4
    ```
12. Stop servers
    ```
    sudo su -p - zookeeper -c "/usr/local/zookeeper/bin/zkServer.sh stop"
    sudo su -p - zookeeper -c "/usr/local/zookeeper1/bin/zkServer.sh stop"
    ```

# Install Apache HIVE

1. Install prerequisites
   * Install hadoop
   * Install Zookeeper
   * Install mysql  and mysql jdbc driver as below
     ```
     sudo apt-get update
     sudo apt-get install mysql-server
     sudo service mysql status
     sudo  mysql_secure_installation
     sudo apt-get install libmysql-java
     ```
2. Add environment variables to file **bashrc** (This must be done for all users **hduser, zookeeper, yarn, user**), in order to do this execute the following commands

   * Execute for **hduser** user
     ```
     sudo su - hduser
     ```
     Open the **bashrc** file to edit
     
     `gedit .bashrc` or `nano .bashrc` or `vi .bashrc`
     
     Add the following text at the end of the file
     ```
     #PIG VARIABLES
     export PIG_HOME=/usr/local/pig
     export PATH=$PATH:$PIG_HOME/bin
     export PIG_CLASSPATH=$PIG_HOME/conf:$HADOOP_INSTALL/etc/hadoop
     #PIG VARIABLES END
     
     #HIVE_VARIABLES
     export HIVE_HOME=/usr/local/hive
     export PATH=$PATH:$HIVE_HOME/bin
     ```
     Save, close the file and close the **hduser** session
     ```
     exit
     ```
   * Execute for **zookeeper** user
     ```
     sudo su - zookeeper
     ```
     Open the **bashrc** file to edit
     
     `gedit .bashrc` or `nano .bashrc` or `vi .bashrc`
     
     Add the following text at the end of the file
     ```
     #PIG VARIABLES
     export PIG_HOME=/usr/local/pig
     export PATH=$PATH:$PIG_HOME/bin
     export PIG_CLASSPATH=$PIG_HOME/conf:$HADOOP_INSTALL/etc/hadoop
     #PIG VARIABLES END
     
     #HIVE_VARIABLES
     export HIVE_HOME=/usr/local/hive
     export PATH=$PATH:$HIVE_HOME/bin
     ```
     Save, close the file and close the **zookeeper** session
     ```
     exit
     ```
   * Execute for the **yarn** user
     ```
     sudo su - yarn
     ```
     Open the **bashrc** file to edit
     
     `gedit .bashrc` or `nano .bashrc` or `vi .bashrc`
        
     Add the following text at the end of the file
     ```
     #PIG VARIABLES
     export PIG_HOME=/usr/local/pig
     export PATH=$PATH:$PIG_HOME/bin
     export PIG_CLASSPATH=$PIG_HOME/conf:$HADOOP_INSTALL/etc/hadoop
     #PIG VARIABLES END
     
     #HIVE_VARIABLES
     export HIVE_HOME=/usr/local/hive
     export PATH=$PATH:$HIVE_HOME/bin
     ```
     Save, close the file and close the **yarn** session
     ```
     exit
     ```
   * Execute for the your user account, in this example is **apa**
     
     Open the **bashrc** file to edit
     
     `gedit .bashrc` or `nano .bashrc` or `vi .bashrc`
     
     Add the following text at the end of the file
     ```
     #PIG VARIABLES
     export PIG_HOME=/usr/local/pig
     export PATH=$PATH:$PIG_HOME/bin
     export PIG_CLASSPATH=$PIG_HOME/conf:$HADOOP_INSTALL/etc/hadoop
     #PIG VARIABLES END
     
     #HIVE_VARIABLES
     export HIVE_HOME=/usr/local/hive
     export PATH=$PATH:$HIVE_HOME/bin
     ```
     Save, close the file
     
3. Create **hive** user
   ```
   sudo adduser --ingroup hadoop hive
   ```
4. Edit **bashrc** file for hive user
   ```
   sudo su - hive
   ```
   Open the **bashrc** file to edit
     
   `gedit .bashrc` or `nano .bashrc` or `vi .bashrc`
        
   Add the following text at the end of the file
   ```
   #HADOOP VARIABLES START
   export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
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
   ```
   Save, close the file and close the **hive** user session
   ```
   exit
   ```
5. Download and extract hive binary
   ```
   cd Downloads/
   wget http://apache.mirrors.lucidnetworks.net/hive/stable-2/apache-hive-2.3.2-bin.tar.gz
   tar xvf apache-hive-2.3.2-bin.tar.gz
   sudo mv apache-hive-2.3.2-bin /usr/local/hive
   cd /usr/local
   sudo chown -R hive:hadoop hive
   ```
6. Make mysql connector library available to hive
   ```
   source .bashrc
   sudo su - hive
   cd $HIVE_HOME/lib
   ln -s /usr/share/java/mysql-connector-java.jar mysq-connector-java.jar
   exit
   ```
7. Create metastore database and user for hive
   ```
   mysql -u root -p
   mysql> create database metastore;
   mysql> create user 'hive'@localhost identified by 'hive';
   mysql> grant all on metastore.*  to 'hive'@localhost identified by 'hive'; 
   mysql> flush privileges;
   mysql> quit;
   ```
8. Set Hive configuration
   * Configure **hive-env.sh**
     * Open file **hive-env.sh** located in **$HIVE_HOME/conf/hive-env.sh** using your preferred editor
     
       `sudo gedit $HIVE_HOME/conf/hive-env.sh` or `sudo nano $HIVE_HOME/conf/hive-env.sh` or `sudo vi $HIVE_HOME/conf/hive-env.sh`
     * Add or update HADOOP_HOME in this file as follows
       ```
       # Set HADOOP_HOME to point to a specific hadoop install directory
       HADOOP_HOME=/usr/local/hadoop
       ```
     * Save and close the file
   * Configure **hive-log4j2.properties**
     * Open file **hive-log4j2.properties** located in **$HIVE_HOME/conf/hive-log4j2.properties** using your preferred editor
       
       `sudo gedit $HIVE_HOME/conf/hive-log4j2.properties` or `sudo nano $HIVE_HOME/conf/hive-log4j2.properties` or `sudo vi $HIVE_HOME/conf/hive-log4j2.properties`
     * Update log location, default is /tmp.
       ```
       property.hive.log.dir = /usr/local/hive/logs/${sys:user.name}
       ```
     * Save and close the file
   * Configure **hive-site.xml**
     * Open file **hive-site.xml** located in **$HIVE_HOME/conf/hive-site.xml** using your preferred editor
       
       `sudo gedit $HIVE_HOME/conf/hive-site.xml` or `sudo nano $HIVE_HOME/conf/hive-site.xml` or `sudo vi $HIVE_HOME/conf/hive-site.xml`
     * Add the following text between the **\<configuration>** tags
       ```
       <property>
            <name>javax.jdo.option.ConnectionURL</name>
            <value>jdbc:mysql://localhost/metastore</value>
            <description>the URL of the MySQL database</description>
       </property>
       <property>
            <name>javax.jdo.option.ConnectionDriverName</name>
            <value>com.mysql.jdbc.Driver</value>
       </property>
       <property>
            <name>javax.jdo.option.ConnectionUserName</name>
            <value>hive</value>
       </property>
       <property>
            <name>javax.jdo.option.ConnectionPassword</name>
            <value>Hp1nvent</value>
       </property>
       <property>
            <name>datanucleus.fixedDatastore</name>
            <value>true</value>
       </property>
       <property>
            <name>hive.metastore.schema.verification</name>
            <value>true</value>
       </property>
       <property>
            <name>hive.metastore.uris</name>
            <value>thrift://localhost:9083</value>
            <description>IP address (or fully-qualified domain name) and port of the metastore host</description>
       </property>
       <property>
            <name>hive.support.concurrency</name>
            <description>Enable Hive's Table Lock Manager Service</description>
            <value>true</value>
       </property>
       <property>
            <name>datanucleus.autoStartMechanism</name>
            <value>SchemaTable</value>
       </property>
       <property>
            <name>hive.security.authorization.createtable.owner.grants</name>
            <value>ALL</value>
            <description>
            The privileges automatically granted to the owner whenever a table gets created.
            An example like "select,drop" will grant select and drop privilege to the owner
            of the table. Note that the default gives the creator of a table no access to the
            table (but see HIVE-8067).
            </description>
       </property>
       <property>
            <name>hive.warehouse.subdir.inherit.perms</name>
            <value>false</value>
            <description>
            Set this to false if the table directories should be created
            with the permissions derived from dfs umask instead of
            inheriting the permission of the warehouse or database directory.
            </description>
       </property>
       <property>
            <name>hive.security.authorization.enabled</name>
            <value>true</value>
            <description>enable or disable the Hive client authorization</description>
       </property>
       <property>
            <name>hive.users.in.admin.role</name>
            <value>apa,hive</value>
            <description>
            Comma separated list of users who are in admin role for bootstrapping.
            More users can be added in ADMIN role later.
            </description>
       </property>
       <property>
            <name>hive.zookeeper.quorum</name>
            <description>Zookeeper quorum used by Hive's Table Lock Manager</description>
            <value>localhost:2181,localhost:2182</value>
       </property>
       <property>
            <name>hive.server2.thrift.port</name>
            <value>10001</value>
            <description>TCP port number to listen on, default 10000</description>
       </property>
       </configuration>
       ```
     * Save and close the file
9. Initialize metastore schema
   ```
   sudo su - hive 
   schematool -dbType mysql -initSchema 
   exit
   ```
10. Create hdfs directories for hive
    ```
    sudo su - hduser 
    hdfs dfs -mkdir /user/hive
    hdfs dfs -chmod 755 /user/hive
    hdfs dfs -mkdir /user/hive/warehouse
    hdfs dfs -chmod 1777 /user/hive/warehouse
    hdfs dfs -chown -R hive:hadoop  /user/hive 
    exit
    ```
11. Run Hiveserver2 and Metastore
    ```
    sudo ./run_hdfs.sh start
    sudo su -p - zookeeper -c "/usr/local/zookeeper/bin/zkServer.sh start"
    sudo su -p - zookeeper -c "/usr/local/zookeeper1/bin/zkServer.sh start"
    sudo su - hive 
    $HIVE_HOME/bin/hive --service metastore & $HIVE_HOME/bin/hive --service hiveserver2
    ```
12. Run beeline to verify your installation (Replace user **apa** for your own user)
    ```
    apa@apa-Lenovo-ideapad-700-15ISK:~$ $HIVE_HOME/bin/beeline -u jdbc:hive2://localhost:10001 -n apa - p apa
    SLF4J: Class path contains multiple SLF4J bindings.
    SLF4J: Found binding in [jar:file:/usr/local/hive/lib/log4j-slf4j-impl-2.4.1.jar!/org/slf4j/impl/StaticLoggerBinder.class]
    SLF4J: Found binding in [jar:file:/usr/local/hadoop/share/hadoop/common/lib/slf4j-log4j12-1.7.10.jar!/org/slf4j/impl/StaticLoggerBinder.class]
    SLF4J: See http://www.slf4j.org/codes.html#multiple_bindings for an explanation.
    SLF4J: Actual binding is of type [org.apache.logging.slf4j.Log4jLoggerFactory]
    Connecting to jdbc:hive2://localhost:10001
    Connected to: Apache Hive (version 2.1.1)
    Driver: Hive JDBC (version 2.1.1)
    17/07/29 23:44:56 [main]: WARN jdbc.HiveConnection: Request to set autoCommit to false; Hive does not support autoCommit=false.
    Transaction isolation: TRANSACTION_REPEATABLE_READ
    Beeline version 2.1.1 by Apache Hive
    0: jdbc:hive2://localhost:10001> show tables;
    +-----------+--+
    | tab_name  |
    +-----------+--+
    +-----------+--+
    No rows selected (0.444 seconds)
    0: jdbc:hive2://localhost:10001> create table test (foo int, bar string);
    No rows affected (1.316 seconds)
    0: jdbc:hive2://localhost:10001> show tables;
    +-----------+--+
    | tab_name  |
    +-----------+--+
    | test      |
    +-----------+--+
    1 row selected (0.216 seconds)
    0: jdbc:hive2://localhost:10001> !q
    Closing: 0: jdbc:hive2://localhost:10001
    apa@apa-Lenovo-ideapad-700-15ISK:~$ 
    ```
13. Daemonize hive processes
    ```
    apa@apa-Lenovo-ideapad-700-15ISK:~$ cat run_hive.sh 
    #HADOOP VARIABLES START
    export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
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
    ```
14. Make the script executable and test it
    ```
    chmod u+x run_hive.sh
    sudo ./run_hive.sh start
    sudo ./run_hive.sh stop 
    ```
# Book Language Detection using Google N-Gram (British English - American English)

1. [Download](https://github.com/apupiales/software_trend/archive/master.zip) or [Clone](https://github.com/apupiales/software_trend.git) this repository.
2. Make sure your 2TB HDD is the media disk
3. Give your user permissions to modify your media disk
   ```
   sudo chown -R apa:hadoop /media/
   ```
4. Create path **/hive/Data/** in your **media** unit, the final path should be: **/media/hive/Data/**
   ```
   cd /media/
   mkdir hive
   mkdir hive/Data
   cd
   ```
5. Create folder **tools** in your **home** directory
   ```
   mkdir tools
   ```
6. Move or Copy **[Tools](https://github.com/apupiales/software_trend/tree/master/Tools)** content into your local **tools** folder
   * Move example with **apa** user, change **apa** for your local user
     ```
     mv /home/apa/software_trend//Tools/ /home/apa/tools
     ```
   * Copy example with **apa** user, change **apa** for your local user
     ```
     cp -r /home/apa/software_trend//Tools/ /home/apa/tools
     ```
7. Download the Google N-Gram repository executing the file **5Ngram-EN-US-GB-download.sh** located inside **tools** folder, in order to do that execute the following command in a terminal session:
   ```
   sudo ./tools/5Ngram-EN-US-GB-download.sh
   ```
   After a while (Depending of your internet connection download speed) you will have a set of **folders** and **tar.gz files** in your **/media/hive/Data/** path
   ```
   /media/hive/Data/5N-EN-US-Part1/googlebooks-eng-us-all-5gram-20120701-0.gz
   /media/hive/Data/5N-EN-US-Part1/googlebooks-eng-us-all-5gram-20120701-1.gz
   /media/hive/Data/5N-EN-US-Part1/googlebooks-eng-us-all-5gram-20120701-2.gz
   /media/hive/Data/5N-EN-US-Part1/googlebooks-eng-us-all-5gram-20120701-3.gz
   ...
   ...
   /media/hive/Data/5N-EN-GB-Part4/googlebooks-eng-gb-all-5gram-20120701-_VERB_.gz
   ```
8. Mapreduce the Google N-Gram repository using Hive. In order to do this execute the following **sh** script
   ```
   sudo ./tools/run_all.sh start
   ```
9. Divide the book to compare (Must be in **txt file**) into 5-grams, to do that execute the following command:
   ```
   hadoop jar Ngram/Ngram/out/artifacts/Ngram_jar/Ngram.jar file:///home/apa/Ngram/Dracula.txt file:///home/apa/Ngram/Output/DemoOutOne 5
   ```
10. Using Hive compare the American English 5 Grams with the book 5-Grams, and the British English 5-Grams with the book 5-Grams, once the comparative is made the system calculates the **Jaccard Coefficient** and the **Jaccard Distance** for each one in order to find out the more likely language.
    Execute the following command:
    ```
    sudo ./tools/run_all_2.sh start
    ```
