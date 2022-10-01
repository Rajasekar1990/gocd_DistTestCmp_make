#!/usr/bin/env bash

echo "## Creating HTML Report ##"
#docker exec -i jm_master /bin/bash -c "cd /home/jmeter/ && jmeter -g /home/jmeter/jmeter-${GO_PIPELINE_COUNTER}.jtl -e -o /home/jmeter/htmlreport-${GO_PIPELINE_COUNTER}/"
docker exec -i jm_master /bin/bash -c "cd /home/jmeter/ && jmeter -g /home/jmeter/jmeter-${GO_PIPELINE_COUNTER}.jtl -e -o /home/jmeter/htmlreport-${GO_PIPELINE_COUNTER}/"

echo "## Copying JTL and HTML Report to GOCD working DIR ##"
# cd jm
echo "Current Working DIR is:$PWD"
echo "Current Working DIR file list:$(ls -lrt)"
# mkdir Report-${GO_PIPELINE_COUNTER}
# echo "Current Working DIR file list with Report dir created:$(ls -lrt)"

echo "jm_master Current Working DIR is:$(docker exec -i jm_master /bin/bash -c "pwd && ls -lrt")"
docker cp jm_master:/home/jmeter/htmlreport-${GO_PIPELINE_COUNTER}/ ./Report-${GO_PIPELINE_COUNTER}
docker cp jm_master:/home/jmeter/jmeter-${GO_PIPELINE_COUNTER}.jtl ./Report-${GO_PIPELINE_COUNTER}.jtl

##> /dev/null && cat /home/jmeter/jmeter${GO_PIPELINE_COUNTER}.jtl' > test/jmeter${GO_PIPELINE_COUNTER}jtl
echo "pwd is: $pwd"
ls -lrt 

echo "Check files in Report-${GO_PIPELINE_COUNTER} folder"
ls -lrt Report-${GO_PIPELINE_COUNTER}