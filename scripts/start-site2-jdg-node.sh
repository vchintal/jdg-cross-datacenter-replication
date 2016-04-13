export NODEID=$1
export IP=@@xsite.site2.ip@@
export DG_HOME=@@rhq.deploy.dir@@/@@jdg.folder.name@@

export SITE1_NODE1_TCP_PORT=$((7600+@@xsite.site1.jdg1.offset@@))
export SITE1_NODE2_TCP_PORT=$((7600+@@xsite.site1.jdg2.offset@@))
export SITE1_NODE3_TCP_PORT=$((7600+@@xsite.site1.jdg3.offset@@))
export SITE2_NODE1_TCP_PORT=$((7600+@@xsite.site2.jdg1.offset@@))
export SITE2_NODE2_TCP_PORT=$((7600+@@xsite.site2.jdg2.offset@@))
export SITE2_NODE3_TCP_PORT=$((7600+@@xsite.site2.jdg3.offset@@))

export SITE1_TCP_CLUSTER=@@xsite.site1.ip@@[$SITE1_NODE1_TCP_PORT],@@xsite.site1.ip@@[$SITE1_NODE2_TCP_PORT],@@xsite.site1.ip@@[$SITE1_NODE3_TCP_PORT]
export SITE2_TCP_CLUSTER=@@xsite.site1.ip@@[$SITE2_NODE1_TCP_PORT],@@xsite.site1.ip@@[$SITE2_NODE2_TCP_PORT],@@xsite.site1.ip@@[$SITE2_NODE3_TCP_PORT]

echo ">> Starting JBoss Data Grid Node $i in Site 2"     

if [ "udp" == "@@jgroups.stack@@" ]; then
    screen -d -m $DG_HOME/bin/clustered.sh -c jdg-site-2.xml \
        -P @@rhq.deploy.dir@@/properties/site2-jdg$NODEID.properties \
        -u 239.2.2.2
else
    screen -d -m $DG_HOME/bin/clustered.sh -c jdg-site-2-tcp.xml \
        -P @@rhq.deploy.dir@@/properties/site2-jdg$NODEID.properties \
        -Dsite1.tcp.cluster=$SITE1_TCP_CLUSTER \
        -Dsite2.tcp.cluster=$SITE2_TCP_CLUSTER
fi
