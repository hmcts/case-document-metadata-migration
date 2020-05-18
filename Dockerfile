ARG APP_INSIGHTS_AGENT_VERSION=2.5.1-BETA
FROM node:12-alpine

RUN apk update && apk add --no-cache bash

WORKDIR /app

RUN mkdir -p scripts steps tmp

COPY lib/AI-Agent.xml /app/
COPY scripts /app/scripts
COPY steps /app/steps
COPY tmp /app/tmp
COPY *.sh /app/

ENTRYPOINT ["bash", "/app/test.sh"]