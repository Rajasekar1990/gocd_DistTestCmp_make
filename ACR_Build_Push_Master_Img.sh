#!/usr/bin/env bash

echo "## Current working dir:$(pwd) ##"
echo "## listing files in current working dir ##"
ls -lrt

echo "## Build Jmeter Master Image ##"
docker build -f jmetermasterimage/Dockerfile -t jmeteracrrepo.azurecr.io/jmeter:jmeter5.3Azmastergocdsh .
Masterbuildstatus=$?
echo "## Masterbuildstatus:$Masterbuildstatus ##"

if [ $Masterbuildstatus -eq 0 ] 
then
    echo "## Push JMeter Master Image to ACR ##"
    docker push jmeteracrrepo.azurecr.io/jmeter:jmeter5.3Azmastergocdsh
    MasterPushstatus=$?
    echo "## MasterPushstatus:$MasterPushstatus ##"
    
    if [ $MasterPushstatus -eq 0 ] 
    then
        echo "## Jmeter Master Build and Push was Successful ##"
    else
        echo "## Jmeter Master Build and Push was Failed ##"
    fi    

else 
    echo "## Jmeter Master Image Build was Failed ##"
fi