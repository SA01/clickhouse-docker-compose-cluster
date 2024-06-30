FROM ubuntu:24.04

RUN apt-get update -y
RUN apt-get install -y apt-transport-https ca-certificates curl gnupg tzdata
RUN curl -fsSL 'https://packages.clickhouse.com/rpm/lts/repodata/repomd.xml.key' | gpg --dearmor -o /usr/share/keyrings/clickhouse-keyring.gpg

RUN echo "deb [signed-by=/usr/share/keyrings/clickhouse-keyring.gpg] https://packages.clickhouse.com/deb stable main" | tee /etc/apt/sources.list.d/clickhouse.list
RUN apt-get -y update

# Disable interactive debian: https://stackoverflow.com/questions/75468076/automatic-installation-of-clickhouse-via-script-how-to-answer-the-question-abou
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y clickhouse-server clickhouse-client

ENV TZ=GMT
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Set ownership to root: https://github.com/ClickHouse/ClickHouse/issues/6289
RUN chown -R root:root /var/lib/clickhouse

RUN apt-get clean && rm -rf /var/lib/apt/lists/*
ENV CLICKHOUSE_CONFIG=/etc/clickhouse-server/config.xml