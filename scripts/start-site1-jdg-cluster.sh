export IP=@@xsite.site1.ip@@
export DG_HOME=@@rhq.deploy.dir@@/jboss-datagrid-6.2.0-server

for i in {1..3}; do 
	echo ">> Starting JBoss Data Grid Node $i in Site 1"     
	screen -d -m $DG_HOME/bin/clustered.sh -c jdg-site-1.xml -P @@rhq.deploy.dir@@/properties/site1-jdg$i.properties -u 239.1.1.1 
done