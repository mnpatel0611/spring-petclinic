# install maven and JDK
FROM maven:3.6.3-jdk-8 AS build-env
WORKDIR /app

COPY pom.xml ./

# download dependency
RUN mvn dependency:go-offline

COPY . ./
RUN mvn compile package

FROM openjdk:8-jre-alpine

WORKDIR /app
COPY --from=build-env /app/target/spring-petclinic-2.4.0.BUILD-SNAPSHOT.jar ./spring-petclinic.jar

EXPOSE 8080
CMD ["java", "-jar", "/app/spring-petclinic.jar"]
