export IP=@@xsite.site1.ip@@
export OFFSET=@@xsite.site1.eap.offset@@
export EAP_HOME=@@rhq.deploy.dir@@/@@eap.folder.name@@
export CONFIG_HOME=@@rhq.deploy.dir@@/runtime/site1-eap6-standalone

((JDG1_PORT = 11222 + @@xsite.site1.jdg1.offset@@))
((JDG2_PORT = 11222 + @@xsite.site1.jdg2.offset@@))
((JDG3_PORT = 11222 + @@xsite.site1.jdg3.offset@@))

echo ">> Starting the EAP server bound to address: $IP and with port-offset: $OFFSET"
screen -d -m $EAP_HOME/bin/standalone.sh -c eap-standalone.xml -P @@rhq.deploy.dir@@/properties/site1-eap6.properties  -Djdg.visualizer.serverList="$IP:$JDG1_PORT;$IP:$JDG2_PORT;$IP:$JDG3_PORT"
