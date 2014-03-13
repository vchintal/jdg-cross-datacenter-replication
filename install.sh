export SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export PATH=$PATH:$PWD/rhq-bundle-deployer-4.9.0/bin
rhq-ant -propertyfile deployment.properties
