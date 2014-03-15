export NODEID=$1
export startEntryIndex=$2
export maxEntries=$3

if [[ "$NODEID" == "" || "$startEntryIndex" == "" || "$maxEntries" == "" ]]; then 
    echo "Insufficient or incorrect parameters provided"
    echo "Usage : pump-data-into-site1-via-hotrod.sh <Node Index> <Starting Number> <Max Entries>" 
    exit
fi

((NODEID=NODEID-1))
export IP=@@xsite.site1.ip@@
export SITE1_JDG_OFFSETS=(@@xsite.site1.jdg1.offset@@ @@xsite.site1.jdg2.offset@@ @@xsite.site1.jdg3.offset@@)
export JDG_OFFSET=${SITE1_JDG_OFFSETS[$NODEID]}
export SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export CLASSPATH="$SCRIPTDIR/../runtime/hotrod-demo.jar"

((HOTROD_PORT = 11222 + JDG_OFFSET))
echo ">> Pumping data into the node bound to address: $IP and at hotrod port: $HOTROD_PORT"
java -cp $CLASSPATH -Djdg.demo.startEntryIndex=$startEntryIndex -Djdg.demo.initialList=$IP:$HOTROD_PORT -Djdg.demo.cacheName=labCache -Djdg.demo.maxEntries=$maxEntries -Djdg.demo.clearOnFinish=false -Djdg.demo.putDelay=0 -Djdg.demo.useTwitter=false com.redhat.middleware.jdg.Main

