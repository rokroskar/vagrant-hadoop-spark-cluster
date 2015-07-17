Vagrant.require_version ">= 1.4.3"
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
	numNodes = 4
	r = numNodes..1
	(r.first).downto(r.last).each do |i|
		config.vm.define "node-#{i}" do |node|
			node.vm.box = "rrrrrok/centos-6.6-VBGuest4.3.28"
			node.vm.provider "virtualbox" do |v|
			  v.name = "node#{i}"
			  v.customize ["modifyvm", :id, "--memory", "2048"]
			end
			if i < 10
				node.vm.network :private_network, ip: "10.211.55.10#{i}"
			else
				node.vm.network :private_network, ip: "10.211.55.1#{i}"
			end
			node.vm.hostname = "node#{i}"
			node.vm.provision "centos-firewall", type: "shell", path: "scripts/setup-centos.sh"
			node.vm.provision "centos-hosts", type: "shell" do |s|
				s.path = "scripts/setup-centos-hosts.sh"
				s.args = "-t #{numNodes}"
			end
			if i == 2
				node.vm.provision "shell" do |s|
					s.path = "scripts/setup-centos-ssh.sh"
					s.args = "-s 3 -t #{numNodes}"
				end
			end
			if i == 1
				node.vm.provision "shell" do |s|
					s.path = "scripts/setup-centos-ssh.sh"
					s.args = "-s 2 -t #{numNodes}"
				end
			end
			node.vm.provision "java", type: "shell", path: "scripts/setup-java.sh"
			node.vm.provision "hadoop-config", type: "shell", path: "scripts/setup-hadoop.sh"
			node.vm.provision "hadoop-slaves", type: "shell" do |s|
				s.path = "scripts/setup-hadoop-slaves.sh"
				s.args = "-s 3 -t #{numNodes}"
			end
			node.vm.provision "spark", type: "shell", path: "scripts/setup-spark.sh"
			node.vm.provision "spark-slaves", type: "shell" do |s|
				s.path = "scripts/setup-spark-slaves.sh"
				s.args = "-s 3 -t #{numNodes}"
			end

			# the main nodes, 1 and 2, are set up last so it's safe to issue 
			# HADOOP and YARN setup commands by the time they are provisioning

			# start up HADOOP on node 1
			if i == 1
				node.vm.provision "hadoop-startup", type: "shell", inline: <<-SHELL
					sudo $HADOOP_PREFIX/bin/hdfs namenode -format myhadoop
					sudo $HADOOP_PREFIX/sbin/hadoop-daemon.sh --config $HADOOP_CONF_DIR --script hdfs start namenode
					sudo $HADOOP_PREFIX/sbin/hadoop-daemons.sh --config $HADOOP_CONF_DIR --script hdfs start datanode
					SHELL
			end

			# start up YARN on node 2
			if i == 2
				node.vm.provision "yarn-startup", type: "shell", inline: <<-SHELL
					sudo $HADOOP_YARN_HOME/sbin/yarn-daemon.sh --config $HADOOP_CONF_DIR start resourcemanager
					sudo $HADOOP_YARN_HOME/sbin/yarn-daemons.sh --config $HADOOP_CONF_DIR start nodemanager
					sudo $HADOOP_YARN_HOME/sbin/yarn-daemon.sh start proxyserver --config $HADOOP_CONF_DIR
					sudo $HADOOP_PREFIX/sbin/mr-jobhistory-daemon.sh start historyserver --config $HADOOP_CONF_DIR
					SHELL
			end
		end
	end
end
