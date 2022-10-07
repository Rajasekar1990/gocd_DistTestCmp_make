#WORK_DIR := $(shell pwd)

# incase of changes made to the below tag names; check docker file and docker compose and update tag names on them
MasterImgTag=jmeter5.3Azmastergocdsh
SlaveImgTag=jmeter5.3Azslavegocdsh

#To use gocd pre defined and user defined variables in Makefile then enclose them with $()
#To use Makefile variables in Makefile enclose them with ${}

ACR_Login:
	@docker login jmeteracrrepo.azurecr.io -u $(ACRusername) -p $(ACRpwd)

ACR_Build_Master_Img:
	docker build -f jmetermasterimage/Dockerfile -t jmeteracrrepo.azurecr.io/jmeter:${MasterImgTag} .
	
ACR_Push_Master_Img:
	docker push jmeteracrrepo.azurecr.io/jmeter:${MasterImgTag}

ACR_Build_Slave_Img:
	docker build -f jmeterslaveimage/Dockerfile -t jmeteracrrepo.azurecr.io/jmeter:${SlaveImgTag} .
	
ACR_Push_Slave_Img:
	docker push jmeteracrrepo.azurecr.io/jmeter:${SlaveImgTag}

Run_Load_Test:
	chmod +x sh runloadtest.sh; \
	sh runloadtest.sh

Create_HTML_Report:
	chmod +x sh createHTMLReport.sh; \
	sh createHTMLReport.sh

CleanUp_Workspace:
	chmod +x sh killremovedockercmp.sh; \
	sh killremovedockercmp.sh