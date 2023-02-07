#!/bin/bash
GROUP=azure-ej-lb
for id in 0 1 2
do
 echo "Setting up httpd server in VM ${id}"
  az vm run-command invoke \
--resource-group ${GROUP} \
-n vm0${id} \
--command-id RunShellScript \
--scripts @01_setup_httpd.sh
done
