# Setup Script for the PartsUnlimited MRP AzureStack CI/CD Demo

Original Git can be found here: https://microsoft.github.io/PartsUnlimitedMRP/azurestack/azurestack-31-start.html

To make it easier to reinstall the needed VMs the steps have been captured in PowerShell Scripts.

After running the script and installing the Jenkins VM continue with the setup steps starting at "Jenkins Setup" from here:
https://microsoft.github.io/PartsUnlimitedMRP/azurestack/azurestack-36-jenkins-setup.html

Do not install the JDK as described. No Oracle Java Account is needed if the JDK is installed from a repository.

run the following command in the SSH session:

	sudo add-apt-repository ppa:webupd8team/java -y
	sudo apt-get update -y
	sudo apt-get install oracle-java8-installer -y
	
Then run the following command 

$ sudo update-alternatives --config java

and select the Oralce Java JDK 8 Installation as the default Location. Note the path to the java binary. In my case it was 
	/usr/lib/jvm/java-8-oracle
Enter this path as JAVA_HOME in Jenkins.

# Parts Unlimited MRP

Parts Unlimited MRP is a fictional outsourced Manufacturing Resource Planning (MRP) application for training purposes based on the description in chapters 31-35 of The Phoenix Projectby Gene Kim, Kevin Behr and George Spafford. © 2013 IT Revolution Press LLC, Portland, OR. Resemblance to “Project Unicorn” in the novel is intentional; resemblance to any real company is purely coincidental.

The application uses entirely open source software including Linux, Java, Apache, and MongoDB which creates a web front end, an order service, and an integration service. Click here for the related [Parts Unlimited Website application](http://github.com/microsoft/partsunlimited).

To read and learn more about this project, please visit the [documentation website](https://aka.ms/pumrplabs).
