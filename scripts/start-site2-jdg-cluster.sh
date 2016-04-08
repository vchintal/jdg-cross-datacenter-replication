export IP=@@xsite.site2.ip@@
export DG_HOME=@@rhq.deploy.dir@@/@@jdg.folder.name@@

for i in {1..3}; do 
	echo ">> Starting JBoss Data Grid Node $i in Site 2"     
	screen -d -m $DG_HOME/bin/clustered.sh -c jdg-site-2.xml -P @@rhq.deploy.dir@@/properties/site2-jdg$i.properties -u 239.2.2.2 
done
