#!/usr/bin/env bash

echo "Current working dir:$(pwd)"
echo "listing files in current working dir"
ls -lrt

echo "Build Jmeter Master Image"
Master_Build=$(docker build -f jmetermasterimage/Dockerfile -t jmeteracrrepo.azurecr.io/jmeter:jmeter5.3Azmastergocd . | grep "writing image" | wc -l)

echo "Master_BuildStatus:$Master_Build"
if [ $Master_Build != 0 ] 
then
    echo "Push JMeter Master Image to ACR"
    MasterImg_Push=$(docker push jmeteracrrepo.azurecr.io/jmeter:jmeter5.3Azmastergocd | grep "digest" | wc -l)
    echo "MasterImg_PushStatus:$MasterImg_Push"
    if [ $MasterImg_Push != 0 ] 
    then
        echo "Jmeter Master Image Push Successful"
    else
        echo "Jmeter Master Image Push Failed"
    fi    
else 
    echo "Jmeter Master Image Build Failed"
fi