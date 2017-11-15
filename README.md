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
