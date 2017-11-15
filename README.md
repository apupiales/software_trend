# Software_Trend
Final project of trends in software engineering

# Minimum Hardware and OS Requirements:

 * OS: Ubuntu 16.04
 * HDD: 1 TB SSD
 * HDD2: 2TB 
 * RAM: 8GB DDR4
 * CPU: Quad Core 2.2 Ghz

For execution follow the next steps:

# Install HADOOP

1. Install Oracle Java 8

    1. Open a terminal session and execute the following commands with a user that has sudo privileges

        * `sudo apt-get update`
        * `sudo apt-get install default-jre`
        * `sudo apt-get install default-jdk`
        * `sudo add-apt-repository ppa:webupd8team/java`
        * `sudo apt-get update`
        * `sudo apt-get install oracle-java8-installer`

2. Configure JAVA_HOME

    1. Execute the following command in terminal console to determinate java install path

         * `sudo update-alternatives --config java`
          
    2. Copy the preferred install path and open /etc/environment with the prefered editor. P.E: nano, gedit
    
         * `sudo nano /etc/environment` or `sudo gedit /etc/environment`
 
    3. Add the following line at the end of the file replacing the <path> with the preferred install path surrounded by double quotes
    
         * `JAVA_HOME=<path>` P.E: `JAVA_HOME="/usr/lib/jvm/java-8-oracle"`
         
     4. Save, close the file and proceed to reload it with the next command
     
         * `source /etc/environment`
         
     5. Test the new environment variable
     
         * `echo $JAVA_HOME`

3. Install SSH

      1. Execute the following command in terminal
      
         * `sudo apt-get install ssh`
         
4. Update OS Limits

      1. Set limits in /etc/security/limits.conf.  Without these the hadoop instance may get below error and will get occasionally killed by OS. First open de file for edit
      
          * `sudo nano /etc/security/limits.conf` or `sudo gedit /etc/security/limits.conf`
          
      2. Add the following lines at the end of the file
      
          * `*        hard    nofile        50000`
          * `*        soft    nofile        50000`
          * `*        hard    nproc         10000`
          * `*        soft    nproc         10000`
          
5. Workaround for "Kill" command

      1. Open the file logind.conf under the path /etc/systemd/logind.conf with your preferred editor
      
          * P.E: `sudo nano /etc/systemd/logind.conf` or `sudo gedit /etc/systemd/logind.conf `
          
      2. Remove the hash (#) symbol from the line
      
           * `KillUserProcesses=no`
           
6. Add users for HDFS and Yarn

      1. Create users which will own and run hdfs and yarn processes, also create hadoop group and make all bigdata users part of it. In order to do that execute the following commands:
      
            * `sudo addgroup hadoop` 
            * `sudo adduser --ingroup hadoop hduser`
            * `sudo adduser --ingroup hadoop yarn`
            * `sudo usermod -a -G hadoop kamal`
            
7. Setup SSH

      1. Create the public and private key for hdfs user
      
            * `sudo su - hduser`
            * `ssh-keygen -t rsa -P ""` Note: Press ENTER when asked for a file
            
      2. Save the generated public key as authorized key
      
            * `cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys`
            
      3. Test SSH for hdfs user
      
            * `ssh localhost` Note: Enter 'yes' when prompt for confirmation.
            * `exit`
            * `exit`
            
      4. Repeat the previous three (3) steps for user yarn with the following commands
      
            * `sudo su - yarn`
            * `ssh-keygen -t rsa -P ""`
            * `cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys`
            * `ssh localhost`
            * `exit`
            * `exit`
            
8. Download HADOOP distribution

      1. Locate in the Downloads directory
            
            * `cd Downloads/`
            
      2. Download the distribution (2.8.2 at the moment)
      
            * `wget http://www.apache.org/dyn/closer.cgi/hadoop/common/hadoop-2.8.2/hadoop-2.8.2.tar.gz`
            
      3. Untar the downloaded file using the following command
      
            * `tar xvf hadoop-2.8.2.tar.gz`
            
      4. Move and rename the folder to his final destination
      
            * `sudo mv hadoop-2.8.2  /usr/local/hadoop`
            
9. Create and set permissions for directories

      1. Execute the following commands to create the paths for datanode and namenode
      
            * `sudo mkdir -p /usr/local/hadoop/data/namenode`
            * `sudo mkdir -p /usr/local/hadoop/data/datanode`
            * `sudo mkdir -p /usr/local/hadoop/logs`
            * `sudo chmod 777 /tmp`
            
      2. Ensure hadoop user owns the previous folders
      
            * `cd /usr/local`
            * `sudo chown -R hduser:hadoop hadoop`
            * `sudo su - hduser`
            * `chmod g+w /usr/local/hadoop/logs`
            * `exit`
            
10. Configure HADOOP

       1. Set environment variables for HADOOP, in order to do this the **.bashrc** file has to be modified for the **hduser, yarn, and user accounts**, the file is modified using the preferred editor
       
            * `sudo su - hduser`
            * `gedit .bashrc` or `nano .bashrc`
            
       2. Add the following block at the end of the file and then save it:
       
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

    1. Move to hadoop configuration directory and edit configuration files.
    
        * `cd /usr/local/hadoop/etc/hadoop`
           
    2. There are two (2) options, copy the files from the **Hadoop** folder in this repository (Only if you have followed these step by step) or configure each file manually, if this is the case then:
    
        1. Open the file **core-site.xml**
        
            * `sudo gedit core-site.xml` or `sudo nano core-site.xml`
            
        2. Replace the content between the **\<configuration>** tags with:
        
            ```
            <property>
                <name>fs.defaultFS</name>
                <value>hdfs://localhost:9000</value>
            </property>
            ```
         3. Save and close file **core-site.xml**
         
         4. Open file **hdfs-site.xml**
         
            * `sudo gedit hdfs-site.xml` or `sudo nano hdfs-site.xml`
            
         5. Replace the content between the **\<configuration>** tags with:
         
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
          6. Save and close file **hdfs-site.xml**
          
          7. Create file **mapred-site.xml** from template executing the following commands
          
             ```
             su hduser
             cp mapred-site.xml.template mapred-site.xml
             exit
             ```
          8. As with the previous files this one has to be opened
          
             * `sudo gedit mapred-site.xml` or `sudo nano mapred-site.xml`
             
          9. Replace the content between the **\<configuration>** tags with:
          
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
            10. Save and close the file **mapred-site.xml**
            11. Open file **hadoop-env.sh**
                * `sudo gedit hadoop-env.sh` or `sudo nano hadoop-env.sh`
            12. Configure **JAVA_HOME**
                * `export JAVA_HOME=/usr/lib/jvm/java-8-oracle`
            13. Save and close the file **hadoop-env.sh**
            14. Open file **mapred-env.sh**
                * `sudo gedit mapred-env.sh` or `sudo nano mapred-env.sh`
            15. Configure the following
                ```
                export JAVA_HOME=/usr/lib/jvm/java-8-oracle
                export HADOOP_MAPRED_IDENT_STRING=hduser
                ```
            16. Save and close file **mapred-env.sh**
            17. Open file **yarn-site.xml**
                * `sudo gedit yarn-site.xml` or `sudo nano yarn-site.xml`
            18. Replace the content between the **\<configuration>** tags
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
             19. Save and close the file **yarn-site.xml**
12. Format Namenode
    1. Format namenode and start, stop your hdfs first from hdfs account (first source your environment)
    
        ```
        . .bashrc 
        sudo su - hduser 
        $HADOOP_INSTALL/bin/hdfs namenode -format
        $HADOOP_INSTALL/sbin/start-dfs.sh Note: First time will prompt confirmation, type 'yes'
        $HADOOP_INSTALL/sbin/stop-dfs.sh 
        exit
        ```
        
13. Start hdfs and resourcemanager
    1. Execute the following commands
    
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

    * `sudo su -p - hduser -c "$HADOOP_INSTALL/sbin/mr-jobhistory-daemon.sh start historyserver"`
    
16. Verify Install

    * `yarn jar $YARN_EXAMPLES/hadoop-mapreduce-examples-2.7.3.jar pi 16 1000`
    
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
