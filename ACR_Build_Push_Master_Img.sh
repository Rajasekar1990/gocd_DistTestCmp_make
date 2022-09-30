#!/usr/bin/env bash

echo "Current working dir:$(pwd)"
echo "listing files in current working dir"
ls -lrt

echo "Build Jmeter Master Image"
Master_Build=$(docker build -f jmetermasterimage/Dockerfile -t jmeteracrrepo.azurecr.io/jmeter:jmeter5.3Azmastergocd . | grep "Successfully built" | wc -l)

if [$Master_Build != 0] 
then
    echo "Push JMeter Master Image to ACR"
    MasterImg_Push=$(docker push jmeteracrrepo.azurecr.io/jmeter:jmeter5.3Azmastergocd | grep "jmeter5.3Azmastergocd" | wc -l)
    if [$MasterImg_Push != 0] 
    then
        echo "Jmeter Master Image Push Successful"
    else
        echo "Jmeter Master Image Push Failed"
    fi    
else 
    echo "Jmeter Master Image Build Failed"
fi









