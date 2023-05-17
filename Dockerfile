FROM  maven:3.9.2-eclipse-temurin-17-alpine as build
COPY src /home/app/src
COPY pom.xml /home/app
COPY camunda-h2-database.mv.db /home/app/camunda-h2-database.mv.db

RUN mvn -f /home/app/pom.xml clean package spring-boot:repackage

FROM eclipse-temurin:17.0.7_7-jre-alpine

COPY --from=build /home/app/target/my-project-1.0.0-SNAPSHOT-exec.jar /usr/local/lib/my-project.jar
COPY --from=build /home/app/camunda-h2-database.mv.db /usr/local/lib/camunda-h2-database.mv.db

EXPOSE 8080
ENTRYPOINT ["java","-jar","/usr/local/lib/my-project.jar","--spring.profiles.active=docker"]