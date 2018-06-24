FROM openjdk:8

ENV PLAY_VERSION 2.2.0

RUN wget --no-check-certificate -q https://downloads.typesafe.com/play/${PLAY_VERSION}/play-${PLAY_VERSION}.zip \
    && unzip -q play-${PLAY_VERSION}.zip \
    && rm play-${PLAY_VERSION}.zip \
    && ln -s /play-${PLAY_VERSION}/play /usr/local/bin/

VOLUME /app

EXPOSE 9000

COPY run-play2-webapp /usr/local/bin/
RUN chmod a+x /usr/local/bin/run-play2-webapp

ENTRYPOINT ["run-play2-webapp"]
