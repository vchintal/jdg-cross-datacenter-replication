export IP=@@xsite.site2.ip@@
export OFFSET=@@xsite.site2.eap.offset@@
export EAP_HOME=@@rhq.deploy.dir@@/@@eap.folder.name@@
export CONFIG_HOME=@@rhq.deploy.dir@@/runtime/site2-eap6-standalone

((JDG1_PORT = 11222+ @@xsite.site2.jdg1.offset@@))
((JDG2_PORT = 11222+ @@xsite.site2.jdg2.offset@@))
((JDG3_PORT = 11222+ @@xsite.site2.jdg3.offset@@))

echo ">> Starting the EAP server bound to address: $IP and with port-offset: $OFFSET"
screen -m -d $EAP_HOME/bin/standalone.sh -c eap-standalone.xml -P @@rhq.deploy.dir@@/properties/site2-eap6.properties  -Djdg.visualizer.serverList="$IP:$JDG1_PORT;$IP:$JDG2_PORT;$IP:$JDG3_PORT"
