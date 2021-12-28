#
# Build stage
#
FROM maven:3.8.1 AS build
COPY src /home/app/src
COPY pom.xml /home/app
#RUN ls /home/app
RUN ls /home/app/
COPY application*.properties /home/app/src/main/resources/
RUN ls /home/app/src/main/resources/
RUN mvn -f /home/app/pom.xml clean package
WORKDIR /home/app
RUN ls /home/app/target
#RUN ls /home/app/target/
#
# Package stage
#
#FROM openjdk:11-jre-slim
#COPY --from=build /home/app/target/demo-0.0.1-SNAPSHOT.jar /usr/local/lib/demo.ja3r
#EXPOSE 8080
#ENTRYPOINT ["java","-jar","/usr/local/lib/demo.jar --spring.config.location=file:/config/application.properties"]


FROM adoptopenjdk/openjdk11:alpine-jre
#RUN ls /home/app/target
#RUN ls /home/app/target/
# Refer to Maven build -> finalName
ARG JAR_FILE=/home/app/target/javaSB-0.0.1-SNAPSHOT.jar
WORKDIR /opt/app
COPY --from=build /home/app/src/main/resources/application*.properties /opt/app/
# cd /opt/app
#WORKDIR /opt/app

# cp target/spring-boot-web.jar /opt/app/app.jar
COPY --from=build ${JAR_FILE} app.jar

# java -jar /opt/app/app.jar
#ENTRYPOINT ["java","-jar","app.jar"]
ENTRYPOINT ["java" ,"-Djava.security.egd=file:/dev/./urandom --spring.profiles.active=dev --spring.config.location=/opt/app/application.properties","-jar","app.jar"]