# BUILD
FROM gradle:jdk21-jammy as build
ENV HOME=/usr/app
RUN mkdir -p $HOME
WORKDIR $HOME
ADD . $HOME
RUN cd $HOME
RUN --mount=type=cache,target=/root/.gradle gradle --no-daemon build

# RUN
FROM eclipse-temurin:21-jre-jammy

RUN mkdir -p /app/bin

COPY --from=build /usr/app/build/libs/*.jar /app/bin/app.jar

CMD java -jar /app/bin/app.jar
