FROM jenkins/jenkins:lts-jdk11
USER root
RUN apt-get update && apt-get -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common && curl -fsSL https://download.docker.com/linux/$(. /etc/os-release;echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable" && apt-get update && apt-get -y install docker-ce
RUN apt-get install -y docker-ce
RUN usermod -a -G docker jenkins
USER jenkins
# copy the list of plugins we want to install
COPY plugins.txt /usr/share/jenkins/plugins.txt
# run the install-plugins script to install the plugins
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/plugins.txt
# disable the setup wizard as we will set up jenkins as code :)
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
# copy the seedjob file into the image
COPY seedjob.groovy /usr/local/seedjob.groovy
# copy the config-as-code yaml file into the image
COPY jenkins-casc.yaml /usr/local/jenkins-casc.yaml
# tell the jenkins config-as-code plugin where to find the yaml file
ENV CASC_JENKINS_CONFIG /usr/local/jenkins-casc.yaml
