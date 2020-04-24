FROM gradle:jdk8 AS builder

COPY . /tmp/kafka-connect-bigquery-source

# Creating build argument
ARG GRADLE_LATEST_VERSION
# Creating environmental variable and assigning an argument value to it
ENV GRADLEVERSION=${GRADLE_LATEST_VERSION}

RUN cd /tmp/kafka-connect-bigquery-source && ./gradlew clean distTar
RUN mkdir -p /tmp/kafka-connect-bigquery \
    && cd /tmp/kafka-connect-bigquery-source && pwd && tar -xf ./kcbq-confluent/build/distributions/kcbq-confluent-$GRADLEVERSION.tar \
       -C /tmp/kafka-connect-bigquery --strip-components=1

FROM confluentinc/cp-kafka-connect:5.3.1
ARG plugin_path=/usr/share/java
COPY --from=builder --chown=root:root /tmp/kafka-connect-bigquery ${plugin_path}/kafka-connect-bigquery
