FROM openjdk:8-jdk
COPY target/spring-petclinic-rest-2.2.5.jar /opt/spring-petclinic-rest-2.2.5.jar
ENTRYPOINT ["sh", "-c"]
CMD ["java -jar opt/spring-petclinic-rest-2.2.5.jar","--host", "0.0.0.0"]
