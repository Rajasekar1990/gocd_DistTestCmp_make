#!/usr/bin/env bash

echo "## Current working dir:$(pwd) ##"
echo "## listing files in current working dir ##"
ls -lrt

echo "## Build Jmeter Slave Image ##"
docker build -f jmeterslaveimage/Dockerfile -t jmeteracrrepo.azurecr.io/jmeter:jmeter5.3Azslavegocdsh .
Slavebuildstatus=$?
echo "## Slavebuildstatus:$Slavebuildstatus ##"

if [ $Slavebuildstatus -eq 0 ] 
then
    echo "## Push JMeter Slave Image to ACR ##"
    docker push jmeteracrrepo.azurecr.io/jmeter:jmeter5.3Azslavegocdsh
    SlavePushstatus=$?
    echo "## SlavePushstatus:$SlavePushstatus ##"
    
    if [ $SlavePushstatus -eq 0 ] 
    then
        echo "## Jmeter Slave Build and Push was Successful ##"
    else
        echo "## Jmeter Slave Build and Push was Failed ##"
    fi  

else 
    echo "## Jmeter Slave Image Build was Failed ##"
fi