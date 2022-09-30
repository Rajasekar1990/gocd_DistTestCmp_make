#!/usr/bin/env bash

echo "Current working dir:$(pwd)"
echo "listing files in current working dir"
ls -lrt

echo "Build Jmeter Master Image"
docker build -f jmetermasterimage/Dockerfile -t jmeteracrrepo.azurecr.io/jmeter:jmeter5.3Azmastergocd .
buildstatus=$?

if [ $buildstatus -eq 0 ] 
then
    echo "Push JMeter Master Image to ACR"
    docker push jmeteracrrepo.azurecr.io/jmeter:jmeter5.3Azmastergocd
    pushstatus=$?
    if [ $pushstatus -eq 0 ] 
    then
        echo "Jmeter Master Image Push Successful"
    else
        echo "Jmeter Master Image Push Failed"
    fi    
else 
    echo "Jmeter Master Image Build Failed"
fi