#!/bin/bash

# Bring the services up
function startServices {
  docker start nodemaster node2 node3 node4
  sleep 5
  echo ">> Starting hdfs ..."
  docker exec -u hadoop -it nodemaster hadoop/sbin/start-dfs.sh
  sleep 5
  echo ">> Starting yarn ..."
  docker exec -u hadoop -d nodemaster hadoop/sbin/start-yarn.sh
  sleep 5
  echo ">> Starting Spark ..."
  docker exec -u hadoop -d nodemaster /home/hadoop/sparkcmd.sh start
  docker exec -u hadoop -d node2 /home/hadoop/sparkcmd.sh start
  docker exec -u hadoop -d node3 /home/hadoop/sparkcmd.sh start
  docker exec -u hadoop -d node4 /home/hadoop/sparkcmd.sh start
  show_info
}

function show_info {
  masterIp=`docker inspect -f "{{ .NetworkSettings.Networks.sparknet.IPAddress }}" nodemaster`
  echo "Hadoop info @ nodemaster: http://$masterIp:8088/cluster"
  echo "Spark info @ nodemater  : http://$masterIp:8080/"
  echo "DFS Health @ nodemaster : http://$masterIp:9870/dfshealth.html"
}

# matt68 add this function
function show_nodes_info {
  echo " ### Copy and execute this commands to add the new nodes to your /etc/hosts : "
  echo ' echo #  >>>>>   Next lines define the hadoop over docker cluster nodes. <<<<<      | sudo tee -a /etc/hosts  '
  echo ' echo ' `docker inspect -f "{{ .NetworkSettings.Networks.sparknet.IPAddress }}" nodemaster` '"      nodemaster "' '  | sudo tee -a /etc/hosts  '
  echo ' echo ' `docker inspect -f "{{ .NetworkSettings.Networks.sparknet.IPAddress }}" node2`      '"      node2      "' '   | sudo tee -a /etc/hosts  '
  echo ' echo ' `docker inspect -f "{{ .NetworkSettings.Networks.sparknet.IPAddress }}" node3`      '"      node3      "' '   | sudo tee -a /etc/hosts  '
  echo ' echo ' `docker inspect -f "{{ .NetworkSettings.Networks.sparknet.IPAddress }}" node4`      '"      node4      "' '   | sudo tee -a /etc/hosts  '
  echo ' ### At the end you coud use this command to erase all the ips with the hostnames node* : '
  echo ' sudo sed '/node/  d' -i /etc/hosts   '  
}

if [[ $1 = "start" ]]; then
  startServices
  exit
fi

if [[ $1 = "stop" ]]; then
  docker exec -u hadoop -d nodemaster /home/hadoop/sparkcmd.sh stop
  docker exec -u hadoop -d node2 /home/hadoop/sparkcmd.sh stop
  docker exec -u hadoop -d node3 /home/hadoop/sparkcmd.sh stop
  docker exec -u hadoop -d node4 /home/hadoop/sparkcmd.sh stop
  docker stop nodemaster node2 node3 node4
  exit
fi

if [[ $1 = "deploy" ]]; then
  docker rm -f `docker ps -aq` # delete old containers
  docker network rm sparknet
  docker network create --driver bridge sparknet # create custom network

  # 3 nodes
  echo ">> Starting nodes master and worker nodes ..."
  docker run -dP --network sparknet --name nodemaster -h nodemaster -it matt68/sparkbase
  docker run -dP --network sparknet --name node2 -it -h node2 matt68/sparkbase
  docker run -dP --network sparknet --name node3 -it -h node3 matt68/sparkbase
  docker run -dP --network sparknet --name node4 -it -h node4 matt68/sparkbase

  # Format nodemaster
  echo ">> Formatting hdfs ..."
  docker exec -u hadoop -it nodemaster hadoop/bin/hdfs namenode -format
  startServices
  exit
fi

if [[ $1 = "info" ]]; then
  show_info
  exit
fi

# matt68 add this option
if [[ $1 = "show_nodes" ]]; then
  show_nodes_info
  exit
fi

echo "Usage: cluster.sh deploy|start|stop"
echo "                 deploy       - create a new Docker network"
echo "                 start        - start the existing containers"
echo "                 stop         - stop the running containers" 
echo "                 info         - useful URLs" 
# matt68 add this line : 
echo "                 show_nodes   - commands to manage the nodes into your /etc/hosts file" 
