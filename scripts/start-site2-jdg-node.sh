export NODEID=$1
export IP=@@xsite.site2.ip@@
export DG_HOME=@@rhq.deploy.dir@@/@@jdg.folder.name@@

echo ">> Starting JBoss Data Grid Node $i in Site 2"     

if [ "udp" == "@@jgroups.stack@@" ]; then
    screen -d -m $DG_HOME/bin/clustered.sh -c jdg-site-2.xml -P @@rhq.deploy.dir@@/properties/site2-jdg$NODEID.properties -u 239.2.2.2
else
    screen -d -m $DG_HOME/bin/clustered.sh -c jdg-site-2-tcp.xml -P @@rhq.deploy.dir@@/properties/site2-jdg$NODEID.properties 
fi
