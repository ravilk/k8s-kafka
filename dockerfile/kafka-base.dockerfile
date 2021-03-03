FROM adoptopenjdk:8u262-b10-jdk-openj9-0.21.0-bionic

ARG KAFKA_VERSION=2.12-2.4.1


# Must have packages
RUN apt-get update && apt-get install -y vim nano zsh curl git sudo dnsutils

RUN mkdir /logs && groupadd -r usergroup && useradd -r -g usergroup user && chown -R user:usergroup /logs && adduser user sudo

COPY config /config
ADD  certs/certs.tar.gz /
COPY distrib/jmx_prometheus_javaagent-0.12.0.jar /distrib/

ADD distrib/kafka_$KAFKA_VERSION.tgz /distrib
COPY scripts/start-kafka.sh /distrib/kafka_$KAFKA_VERSION/
RUN chmod -R +x /distrib/kafka_$KAFKA_VERSION/bin && \
    chown -R user:usergroup /distrib

EXPOSE 9092/tcp 7171/tcp

WORKDIR /distrib/kafka_$KAFKA_VERSION

USER user
