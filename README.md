Cross Data Center Replication with JBoss Data Grid 6.2
======================================================

This demo allows you to quickly put together two sites (and their associated clusters), using __JBoss Data Grid (JDG) 6.2__, such that one acts as a backup for another for any distributed cache configured for Cross Data Center Replication.

Prerequisites 
-------------

* Single platform VM or two as per the requirement
* Java JDK/JRE 7 installed
* Binaries for JDG 6.2 and JBoss EAP 6.2, review [README](https://github.com/vbchin2/cross-datacenter-replication/blob/master/binaries/README.md) file in the __binaries__ folder for instructions on how to obtain them
* Web application archive (WAR) build/package of the [visual](https://github.com/vbchin2/visual) project
* Java archive (JAR) build/package of the [hotrod-demo](https://github.com/vbchin2/hotrod-demo) project 

Pre-Installation Checks on VMs
------------------------------

* At least __3 GB of additional RAM__ per VM is required for the demo  
* Make sure environment variable __JAVA_HOME__ is set and __java__ is in the __PATH__. 
* If Linux is one of the platforms on which the demo is run, ensure that a decent value for __ulimit__ is set. If running the demo under a user account, add the line `ulimit -u 4096` in the user's ___.profile___ file <br/>	
* If RHEL is one of the platforms check the file : `/etc/security/limits.d/90-nproc.conf` and make sure that user account under which the demo is run has the same settings as the root. You may need to create an entry for the user account if one doesn't exist already
* The packaged Shell scripts use [screen](http://www.gnu.org/software/screen/manual/screen.html) to run processes in the background, so make sure it is installed. On RHEL or Mac type `screen` on the command-line to check if it is installed. If not installed on RHEL, run `sudo yum install screen`, provided your account is in the sudoers list

Installation
------------

1. Download this project as a zip file and uzip the file in a location of choice on the machine hosting the __Site 1 JDG cluster__. *From here on every __installation__ instruction is expected to be run within the unzipped folder* 
2. Get a copy of the `rhq-bundle-deployer-4.10.0.zip` from [here](http://search.maven.org/remotecontent?filepath=org/rhq/rhq-ant-bundle-common/4.10.0/rhq-ant-bundle-common-4.10.0.zip) and unzip it in the project folder. The project's folder structure should resemble the list below:
		
		cross-datacenter-replication> ls
				rhq-bundle-deployer-4.10.0/
				install.sh
				configuration/
				properties/
				deployment.properties
				deploy.xml
				scripts/
				binaries/
				README.md
3. Ensure that the __four__ essential binaries exist in the binaries folder. The binaries folder structure should resemble the list below:

		cross-datacenter-replication/binaries> ls 
				jboss-datagrid-6.2.0-server.zip
				jboss-eap-6.2.0.zip
				jdg-visualizer.war
				hotrod-demo.jar
				README.md

4. Edit the __deployment.properties__ file :
	a. On line 1, provide the path to the folder where the deployment should happen
	b. Update the IP addresses of each site (VM) on which the demo is to run. To run the demo on a single VM you will give the same IP address for both sites  
	b. Other property values can be changed as required but those are __*optional*__   
5. Using the Unix/Linux command-line run the following commands:
      
		cd scripts
		./install.sh
6. If you are using a single VM for the demo *(implied here is that you provided the same IP for both sites in deployment.properties file)*, __Site 2 JDG cluster__ would also run on the same VM and hence no further steps are required and you are done with installation 
7. If you are running the demo using two VMs. Repeat steps 1 thru 4 on the other machine hosting __Site 2 JDG cluster__
		
Testing
-------
<br/>        

<font color="red">**IMPORTANT NOTE:**</font> Scripts with __site1__ in them should be executed on the machine/VM that is hosting Site 1 and scripts with __site2__ on machine/VM that is hosting Site 2. All script <font color="red">**must**</font> be executed within the scripts folder of the demo project.


<br/>
For all the testing workflow steps below we would run the commands within or in the path relative to the folder where the deployment happened. The deployment folder is the path you provided on line 1 of the deployment.properties in the installation section.    

	
1. __Start the JDG cluster on the machine hosting Site 1__ 
			
		cd scripts
		./start-site1-jdg-cluster.sh
2. __Start the EAP on the machine hosting Site 1__ 
			
		# Within the scripts folder, run the following command
		./start-site1-eap6.sh
		
	After waiting for about 10 seconds access the URL to the visualizer. Assuming you didn't change the optional properties the URL should be:

		# Replace site1.ip with the actual IP address for Site 1
		http://site1.ip:8080/jdg-visualizer
*Proceed to the next steps only if you are able to see three floating __RED__ spheres.* 

3. __Start the JDG cluster on the machine hosting Site 2__ 
			
		./start-site2-jdg-cluster.sh
4. __Start the EAP on the machine hosting Site 2__ 
			
		./start-site2-eap6.sh
After waiting for about 10 seconds access the URL to the visualizer. Assuming you didn't change the optional properties the URL should be:

		# Replace site2.ip with the IP address for Site 2
		http://site2.ip:8180/jdg-visualizer
*Proceed to the next steps only if you are able to see three floating __YELLOW__ spheres.* 

5. __Pump 100 entries into the cache on Node 1/Site 1 using Hotrod client__
		
        # Command below will insert 100 entries from 1-100 as the key values into  Node 1/Site 
	    ./pump-data-into-site1-via-hotrod.sh 1 1 100

	In the command shown above:		

	* First argument is the Node index, in this case its : 1
	* Second argument is the starting key value for the set to be inserted 
	* Third argument is the # of seq. entries from the starting value to be put in cache   
<br/>

	The expectation is that the 100 entries will be:
	* Distributed among the cluster nodes of Site 1
	 Replicated to Site 2
	* Distributed among the cluster nodes of Site 2    
<br/>


6. __Stop Node 1/Site 1 and verify redistribution of cache entries in the local cluster__
	
	The expectation here is that remaining two nodes will both show 100 entries each      
				
		# The command below will stop the first node of Site 1
		./stop-site1-jdg-node.sh 1
7. __Pump a different set of 100 entries into the cache on Node 2/Site 1 using Hotrod client__  	  

	The expectation here is that Node 2 will accept the 100 entries, distribute those with Node 3 of Site 1 and replicate it to Site 2 
			
        # Command below will insert 100 entries from 101-200 as the key values into Node 2/Site 1
	    ./pump-data-into-site1-via-hotrod.sh 2 101 100 
8. __Bring back-up alive the Node 1/Site 1 and verify redistribution again in the local cluster__

	The expectation is that the Node 1 once alive and detected will cause a redistribution withing the Site 1 cluster. Site 2 cluster should remain unchanged

		# The command below will stop the first node of Site 1
		./start-site1-jdg-node.sh 1
9. __Simulate the crash of entire Site 1__

		./stop-site1-eap6.sh
		./stop-site1-jdg-cluster.sh
10. __Pump a different set of 100 entries into cache on Node 1/Site 2 using Hotrod client__

	The expectation here is that, since the __failure-policy__ of the __backup__ of the distributed cache is __WARN__, we will be warned in the logs of Node 1/Site 2 that Site 1 is unreachable but the writes would go thru into the local cluster of Site 2
			
        # Command below will insert 100 entries from 201-300 as the key values into Node 1/Site 2
	    ./pump-data-into-site2-via-hotrod.sh 1 201 100 
11. __Simulate bringing back up the entire Site 1__

	The expectation here is that when the nodes of Site 1 come back up again, they wouldn't have any knowledge of cache entries that existed prior to the crash and all of them would should 0 entries

		./start-site1-jdg-cluster.sh
		./start-site1-eap6.sh

12. __Simulate the STATE TRANSFER functionality by refreshing the cache entries on Site 2__
  
    To achieve this click on the __Refresh__ button on the Site 2 visualizer tool and you would see that nodes of Site 1 start to receive cache entries from Site 1. 
    
    The simulation of State Transfer is done by iterating over the cache entries of Site 2 nodes and reinserting them back into the cache. 

13. __Verify state transfer by repeating Step #6 and verify the counts on live nodes__ 
   