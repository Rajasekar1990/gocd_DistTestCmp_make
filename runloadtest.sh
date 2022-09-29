#!/usr/bin/env bash

echo "listing files in working dir"
ls -lrt

echo "listing files in jm dir"
ls -lrt jm

echo "CurrentWorkingDir"
currentworkdir=$(pwd)
echo "current working dir is:${currentworkdir}"

echo "##Checking for docker-compose containers status##"
status_dockercmp=$(docker compose -f ${currentworkdir}/jm/docker-compose.yml ps -q --filter status=running | wc -l)
echo "Before Load Test docker compose status:$status_dockercmp"

if [ $status_dockercmp > 0 ]
then
  docker-compose -f ${currentworkdir}/jm/docker-compose.yml down
fi

echo "##Creating a Master and a Slave container from ACR##"
docker-compose -f ${currentworkdir}/jm/docker-compose.yml up -d

echo "##Listing Containers##"
docker-compose -f ${currentworkdir}/jm/docker-compose.yml ps

echo "##Scale Slave machines to required numbers of replicas | default is set as 2##"
docker-compose -f ${currentworkdir}/jm/docker-compose.yml scale slave=${NumOfSlaves}

echo "##Listing Containers to get total number of slaves running##"
docker compose -f ${currentworkdir}/jm/docker-compose.yml ps --filter status=running slave

echo "##Total count of slaves##"
#Totalslavecount=$(docker ps --filter status=running | grep "slave" | wc -l)
Totalslavecount=$(docker compose -f ${currentworkdir}/jm/docker-compose.yml ps -q --filter status=running slave | wc -l)
echo "Total slave count:$Totalslavecount"

echo "##Extracting jm_master container IP address##"
master_ip=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' jm_master)
echo "master ip:$master_ip"

echo "##Extracting jm_slave containers IP address##"
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}} %tab% {{.Name}}' $(docker compose -f ./jm/docker-compose.yml ps -q --filter status=running slave) | sed 's#%tab%#\t#g' | sed 's#/##g' | sort -t . -k 1,1n -k 2,2n -k 3,3n -k 4,4n

echo "##Storing slave ip addresses in a seperate variable##"
temp=""
for ((i=1; i<=$Totalslavecount; i++))
do
  #slave_ip=`docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker compose -f ${currentworkdir}/jm/docker-compose.yml ps -q --filter status=running slave) | sed 's#%tab%#\t#g' | sed 's#/##g' | sort -t . -k 1,1n -k 2,2n -k 3,3n -k 4,4n | awk 'NR==$i{print $1}'`
  slave_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker compose -f ${currentworkdir}/jm/docker-compose.yml ps -q --filter status=running slave) | awk "NR==$i {print $1}")
  echo "slave_$i=$slave_ip"
  temp=$temp$slave_ip,
  echo "temp value=$temp"
done

ip_set=$temp
echo "ip_set with comma delimted is=$ip_set"
finalipset=${ip_set%?}
#echo "finalipset is=${ip_set%?}"
echo "finalipset is=$finalipset"

echo "##Copying test scripts and csv files to /home/jmeter/ location of Master and all slave containers##"
docker compose -f ${currentworkdir}/jm/docker-compose.yml cp ${currentworkdir}/test/ master:/home/jmeter/test/
docker compose -f ${currentworkdir}/jm/docker-compose.yml cp ${currentworkdir}/test/ slave:/home/jmeter/test/

echo "##Listing files in master container##"
docker exec -i jm_master /bin/bash -c 'cd /home/jmeter/test/ && ls -lart'

echo "##Listing files in slave container##"
for ((i=1; i<=$Totalslavecount; i++))
do
  docker exec -i jm_slave_$i /bin/bash -c 'cd /home/jmeter/test/ && ls -lart'
done

echo "##Executing Loadtest##"
# cd jm
# echo "Current Working DIR is: $PWD"
# ls -lrt
docker exec -i jm_master /bin/bash -c "pwd"
docker exec -i jm_master /bin/bash -c "ls -lrt"
#docker exec -i -e JVM_ARGS="-Xms2048m -Xmx4096m" jm_master /bin/bash -c "cd /home/jmeter/apache-jmeter-5.3/bin && jmeter -n -t /home/jmeter/test/Pipeline_SampleScript.jmx -Dserver.rmi.ssl.disable=true -R${finalipset} -l /home/jmeter/jmeter-${GO_PIPELINE_COUNTER}.jtl"
docker exec -i -e JVM_ARGS="-Xms2048m -Xmx4096m" jm_master /bin/bash -c "cd /home/jmeter/ && jmeter -n -t /home/jmeter/test/Pipeline_SampleScript.jmx -l /home/jmeter/jmeter-${GO_PIPELINE_COUNTER}.jtl"

# echo "##Docker container logs##"
# docker logs jm_master

echo "##Viewing master machine jmeter.log##"
docker exec -i jm_master /bin/bash -c "pwd"
docker exec -i jm_master /bin/bash -c "ls -lrt"
docker exec -i jm_master /bin/bash -c 'cd /home/jmeter/ && cat jmeter.log'