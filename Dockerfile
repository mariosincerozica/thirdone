# Estágio 1: Build da aplicação com Maven
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app

# Copia apenas os arquivos de dependência primeiro para aproveitar o cache
COPY pom.xml .
COPY .mvn .mvn
COPY mvnw .
RUN ./mvnw dependency:go-offline -B

# Copia o código-fonte e gera o pacote .jar
COPY src src
RUN ./mvnw clean package -DskipTests

# Estágio 2: Imagem leve de execução (JRE)
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Cria usuário não-root para segurança
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

# Copia o .jar gerado no primeiro estágio
COPY --from=build /app/target/*.jar app.jar

# Expõe a porta padrão do Spring Boot
EXPOSE 8080

# Executa a aplicação
ENTRYPOINT ["java", "-jar", "app.jar"]
