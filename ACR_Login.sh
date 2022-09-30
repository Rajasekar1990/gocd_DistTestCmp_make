#!/usr/bin/env bash

# ACRusername="jmeteracrrepo"
# ACRpwd="jrW6sM=SUnX9kYNW8pdzdQFct7bkJW3j" 

echo "Login to ACR"
LoginStatus=$(docker login jmeteracrrepo.azurecr.io -u ${ACRusername} -p ${ACRpwd} | grep "Succeeded" | wc -l)
#LoginStatus=$(docker login jmeteracrrepo.azurecr.io -u $ACRusername -p $ACRpwd | grep "Succeeded" | wc -l)

echo "LoginStatus:$LoginStatus"

if [ $LoginStatus != 0 ] 
then
echo "ACR Login Succeeded"
else
echo "ACR Login Failed"
fi