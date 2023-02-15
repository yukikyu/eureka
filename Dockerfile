FROM openjdk:8u212-jre-alpine
WORKDIR /home/dev
COPY ./target/*.jar /home/dev/app.jar
CMD ["java", "-jar", "app.jar"]