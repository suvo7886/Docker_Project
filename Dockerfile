FROM tomcat:latest
COPY ./target/subhajit.war /usr/local/tomcat/webapps
