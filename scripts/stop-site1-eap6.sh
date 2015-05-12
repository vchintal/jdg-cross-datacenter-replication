export IP=@@xsite.site1.ip@@
export OFFSET=@@xsite.site1.eap.offset@@
export EAP_HOME=@@rhq.deploy.dir@@/jboss-eap-6.4

((MGMT_PORT = 9999 + OFFSET))

echo ">> Stopping the EAP server bound to address: $IP and at management port: $MGMT_PORT "

export REMOTE_SERVER_EXISTS=`nc -z $IP $MGMT_PORT | wc -l`
if [[ $REMOTE_SERVER_EXISTS -ge 1 ]]; then 
	$EAP_HOME/bin/jboss-cli.sh --connect --controller=$IP:$MGMT_PORT --user=@@xsite.admin.username@@ --password=@@xsite.admin.password@@ --command="shutdown"
fi

