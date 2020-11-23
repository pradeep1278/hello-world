# Pull base image 
From tomcat:8-jre8 

# Maintainer 
MAINTAINER "pradeep kumar" 
COPY ./webapp/target/webapp.war /usr/local/tomcat/webapps

