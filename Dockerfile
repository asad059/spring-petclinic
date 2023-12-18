FROM openjdk:22-jdk-bullseye

RUN mkdir -p /home/petclinic

COPY target/spring-petclinic-3.2.0-SNAPSHOT.jar /home/petclinic/

WORKDIR /home/petclinic/

EXPOSE 8080

ENV MYSQL_URL="jdbc:mysql://my-rds-instance.cquiuovhxfm5.us-east-1.rds.amazonaws.com:3306/petclinic"

CMD ["java", "-jar", "spring-petclinic-3.2.0-SNAPSHOT.jar", "--spring.profiles.active=mysql"]
