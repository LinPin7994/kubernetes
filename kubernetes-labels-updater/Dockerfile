FROM alpine
WORKDIR /opt
COPY set_labels.sh ./
COPY kubectl /bin
COPY ca.crt client.crt client.key config /opt/
RUN apk add --no-cache git bash
ENTRYPOINT ["bash", "/opt/set_labels.sh"]