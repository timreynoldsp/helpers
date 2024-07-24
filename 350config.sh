#!/bin/bash

#Export template config named TEMPLATE to this directory
#All instances of SWTEMPLATE will be changed to the supplied hostname
#All instances of 192.168.1.254 will be changed to the supplied IP

#config_gen.sh <switch hostname> <switch ip>

cp TEMPLATE $1
sed -i '' "s/SWTEMPLATE/$1/g" $1
sed -i '' "s/192.168.1.254/$2/g" $1
diff -y --suppress-common-lines TEMPLATE $1
