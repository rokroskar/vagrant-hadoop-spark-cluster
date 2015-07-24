vagrant-hadoop-spark-cluster
============================

# Introduction
### Vagrant project to spin up a HADOOP/YARN/SPARK cluster

Specifically, this setup creates a *firewalled* cluster, with `node-2`
acting as a gateway. All of the YARN/HADOOP core services run on `node-1`.
The idea is that you can submit jobs from the desktop/laptop to the remote cluster via a SOCKS proxy connection. 

Currently using Hadoop 2.6, Spark 1.4.1

Ideal for development cluster on a laptop with at least 4GB of memory.

1. node1 : HDFS NameNode + Spark Master
2. node1 : YARN ResourceManager + JobHistoryServer + ProxyServer
3. node3 : HDFS DataNode + YARN NodeManager + Spark Slave
4. node4 : HDFS DataNode + YARN NodeManager + Spark Slave

The primary purpose of this particular build is to test settings/functionality 
of a remote firewalled cluster. 

# Getting Started
1. [Download and install VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. [Download and install Vagrant](http://www.vagrantup.com/downloads.html).
4. Git clone this project, and change directory (cd) into this project (directory).
5. [Download Hadoop 2.6 into the /resources directory](http://mirror.nexcess.net/apache/hadoop/common/hadoop-2.6.0/hadoop-2.6.0.tar.gz)
6. [Download Spark 1.4.1 into the /resources directory](http://d3kbcqa49mib13.cloudfront.net/spark-1.4.1-bin-hadoop2.6.tgz)
8. Run ```vagrant up``` to create the VM.
9. Run ```vagrant ssh node-2``` to get into your VM cluster at the gateway node
10. from `node-2` you can ssh into the rest of the nodes
10. Run ```vagrant destroy``` when you want to destroy and get rid of the VM.

# Running an example

## Setup your environment

1. make sure your `JAVA_HOME` is set -- on Mac OS X you can do this easily with `export JAVA_HOME=$(/usr/libexec/java_home)`
2. source the `local_env/setup_local_env.sh` file to set up the environment 
3. add the following to your local `/etc/hosts` file: 

```
10.211.55.101 node1
10.211.55.102 node2
10.211.55.103 node3
10.211.55.104 node4
```

## Test YARN
Run the following command to make sure you can run a MapReduce job.

```
yarn jar ~/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.6.0.jar pi 2 100
```

## Test Spark on YARN
You can test if Spark can run on YARN by issuing the following command. Try NOT to run this command on the slave nodes.
```
$SPARK_HOME/bin/spark-shell --master yarn-client
```
    
# Modifying scripts for adapting to your environment
You need to modify the scripts to adapt the VM setup to your environment.  

1. [List of available Vagrant boxes](http://www.vagrantbox.es)

2. ./Vagrantfile  
To add/remove slaves, change the number of nodes:  
line 5: ```numNodes = 4```  
To modify VM memory change the following line:  
line 13: ```v.customize ["modifyvm", :id, "--memory", "1024"]```  
3. /scripts/common.sh  
To use a different version of Java, change the following line depending on the version you downloaded to /resources directory.  
line 4: JAVA_ARCHIVE=jdk-8u25-linux-i586.tar.gz  
To use a different version of Hadoop you've already downloaded to /resources directory, change the following line:  
line 8: ```HADOOP_VERSION=hadoop-2.6.0```  
To use a different version of Hadoop to be downloaded, change the remote URL in the following line:  
line 10: ```HADOOP_MIRROR_DOWNLOAD=http://apache.crihan.fr/dist/hadoop/common/stable/hadoop-2.6.0.tar.gz```  
To use a different version of Spark, change the following lines:  
line 13: ```SPARK_VERSION=spark-1.4.1```  
line 14: ```SPARK_ARCHIVE=$SPARK_VERSION-bin-hadoop2.6.tgz```  
line 15: ```SPARK_MIRROR_DOWNLOAD=../resources/spark-1.4.1-bin-hadoop2.6.tgz```  

3. /scripts/setup-java.sh  
To install from Java downloaded locally in /resources directory, if different from default version (1.8.0_25), change the version in the following line:  
line 18: ```ln -s /usr/local/jdk1.8.0_25 /usr/local/java```  
To modify version of Java to be installed from remote location on the web, change the version in the following line:  
line 12: ```yum install -y jdk-8u25-linux-i586```  

4. /scripts/setup-centos-ssh.sh  
To modify the version of sshpass to use, change the following lines within the function installSSHPass():  
line 23: ```wget http://pkgs.repoforge.org/sshpass/sshpass-1.05-1.el6.rf.i686.rpm```  
line 24: ```rpm -ivh sshpass-1.05-1.el6.rf.i686.rpm```  

5. /scripts/setup-spark.sh  
To modify the version of Spark to be used, if different from default version (built for Hadoop2.4), change the version suffix in the following line:  
line 32: ```ln -s /usr/local/$SPARK_VERSION-bin-hadoop2.6 /usr/local/spark```  

# Web UI
You can check the following URLs to monitor the Hadoop daemons.

1. [NameNode] (http://10.211.55.101:50070/dfshealth.html)
2. [ResourceManager] (http://10.211.55.102:8088/cluster)
3. [JobHistory] (http://10.211.55.102:19888/jobhistory)
4. [Spark] (http://10.211.55.101:8080)


# Prerequisites and Gotchas to be aware of
1. At least 1GB memory for each VM node. Default script is for 4 nodes, so you need 4GB for the nodes, in ad
2. dition to the memory for your host machine.
2. Vagrant 1.7 or higher, Virtualbox 4.3.2 or higher (the base box used packages Guest Services v4.3.28 so if you use something different you may experience problems mounting the shared directories)
3. Preserve the Unix/OSX end-of-line (EOL) characters while cloning this project; scripts will fail with Windows EOL characters.
4. Project is tested on Ubuntu 32-bit 14.04 LTS host OS; not tested with VMware provider for Vagrant.
5. The Vagrant box is downloaded to the ~/.vagrant.d/boxes directory. On Windows, this is C:/Users/{your-username}/.vagrant.d/boxes.


# References
This project was put together with great pointers from all around the internet. All references made inside the files themselves.
Primaily this project is forked from [Jee Vang's vagrant project](https://github.com/vangj/vagrant-hadoop-2.4.1-spark-1.0.1)

# Copyright Stuff
Copyright 2014 Maloy Manna

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
