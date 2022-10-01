Project Title
    Distributed Load Testing Using JMeter on GoCD CI tool

Project Description
    This is an experimental project for performance testing purpose where helps in building your test bed instantly by making the below setup ready with the tools and images 

    1. Go-CD (Locally installed or on VM)
    2. JMeter Master (ready to be installed using docker file)
    3. JMeter Slave (ready to be installed using docker file)
    4. To bring this under the same network for achieving distributed load testing setup (docker compose yml to be used)
    5. Go-CD yml to orchestrate the load testing pipeline

Pre-requistes:
    1. Docker Desktop or Docker CLI & Docker Compose V2
    2. Go-CD
    3. ACR Respository 

Steps to follow:
    1. Build Docker file for installing jmetermasterimage --> dockerfile
    2. Build Docker file for installing jmeterslaveimage --> dockerfile
    3. Push Docker image for master and slave to ACR 
    4. Run Docker compose yml to bring up the master and slave containers on same network
    5. Scale slave machines to desired numbers for generating huge load on AUT 
    6. Execute load test from master on non-gui mode
    7. Collate results and create reports (jtl, html report etc.)
    8. Publish Artifacts to gocd server
    9. Clean up test bed (stop and kill docker containers)

Pipeline Stages:
    1. Login to Git and check out the repo using gocd
    2. Login to ACR using ACR_Login.sh
    3. Build and Push Master image to ACR using ACR_Build_Push_Master_Img.sh
    4. Build and Push Slave image to ACR using ACR_Build_Push_Slave_Img.sh
    5. Run Master and Slave from ACR image using docker compose yml
    6. Execute load test using runloadtest.sh
    7. Publish test results using createHTMLReport.sh
    8. Clean up test environment and workspace using killremovedockercmp.sh