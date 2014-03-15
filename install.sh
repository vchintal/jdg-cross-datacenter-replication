export PROJECTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export PATH=$PATH:$PROJECTDIR/rhq-bundle-deployer-4.10.0/bin
rhq-ant -propertyfile deployment.properties
