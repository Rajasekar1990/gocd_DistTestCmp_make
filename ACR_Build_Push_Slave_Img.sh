#!/usr/bin/env bash

echo "Current working dir:$(pwd)"
echo "listing files in current working dir"
ls -lrt

echo "Build Jmeter Slave Image"
docker build -f jmeterslaveimage/Dockerfile -t jmeteracrrepo.azurecr.io/jmeter:jmeter5.3Azslavegocd .
buildstatus=$?
echo "buildstatus=$?"

if [ $(buildstatus=$?) -eq 0 ] 
then
    echo "Push JMeter Slave Image to ACR"
    docker push jmeteracrrepo.azurecr.io/jmeter:jmeter5.3Azslavegocd
    pushstatus=$?
    echo "pushstatus=$?"
    if [ $pushstatus -eq 0 ] 
    then
        echo "Jmeter Slave Build and Push was Successful"
    else
        echo "Jmeter Slave Build and Push was Failed"
    fi  
else 
    echo "Jmeter Slave Image Build was Failed"
fi