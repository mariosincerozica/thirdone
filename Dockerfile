# Estágio 1: build da aplicação com Maven
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app

COPY pom.xml .
COPY .mvn .mvn
COPY mvnw .
RUN ./mvnw dependency:go-offline -B

COPY src src
RUN ./mvnw clean package -DskipTests

# Estágio 2: imagem de execução
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Cria usuário não-root para segurança
RUN addgroup -S spring && adduser -S spring -G spring

# OTEL: Copia o .jar gerado no primeiro estágio
COPY --chown=spring:spring otel/opentelemetry-javaagent.jar /otel/opentelemetry-javaagent.jar
COPY --from=build --chown=spring:spring /app/target/*.jar app.jar

# Muda para o usuário não-root
USER spring:spring

# Expõe a porta padrão do Spring Boot
EXPOSE 8080

# Executa a aplicação
ENTRYPOINT ["java", "-jar", "app.jar"]