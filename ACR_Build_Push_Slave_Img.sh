#!/usr/bin/env bash

echo "Current working dir:$(pwd)"
echo "listing files in current working dir"
ls -lrt

echo "Build Jmeter Slave Image"
Slave_Build=$(docker build -f jmetermasterimage/Dockerfile -t jmeteracrrepo.azurecr.io/jmeter:jmeter5.3Azslavegocd . | grep "naming to jmeteracrrepo.azurecr.io/jmeter:jmeter5.3Azslavegocd done" | wc -l)

if [ $Slave_Build != 0 ] 
then
    echo "Push JMeter Slave Image to ACR"
    SlaveImg_Push=$(docker push jmeteracrrepo.azurecr.io/jmeter:jmeter5.3Azslavegocd | grep "jmeter5.3Azslavegocd" | wc -l)
    if [ $SlaveImg_Push != 0 ] 
    then
        echo "Jmeter Slave Image Push Successful"
    else
        echo "Jmeter Slave Image Push Failed"
    fi  
else 
    echo "Jmeter Slave Image Build Failed"
fi