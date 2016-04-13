export IP=@@xsite.site2.ip@@
export OFFSETS="@@xsite.site2.jdg1.offset@@ @@xsite.site2.jdg2.offset@@ @@xsite.site2.jdg3.offset@@"
export EAP_HOME=@@rhq.deploy.dir@@/@@eap.folder.name@@

for OFFSET in $OFFSETS; do
    ((MGMT_PORT = 9999 + OFFSET))
    echo ">> Stopping the JDG server bound to address: $IP and at management port: $MGMT_PORT "
    export REMOTE_SERVER_EXISTS=`nc -z $IP $MGMT_PORT | wc -l`
    if [[ $REMOTE_SERVER_EXISTS -ge 1 ]]; then 
        $EAP_HOME/bin/jboss-cli.sh --connect --controller=$IP:$MGMT_PORT --user=@@xsite.admin.username@@ --password=@@xsite.admin.password@@ --command="shutdown"
    fi
done

