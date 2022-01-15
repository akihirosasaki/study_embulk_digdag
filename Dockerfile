FROM openjdk:8-jdk

# args
ARG DB_USER
ARG DB_PASSWORD
ARG DB_HOST
ARG DB_PORT
ARG DB_NAME
ARG DIGDAG_ENCRYPTION_KEY

RUN apt-get update && apt-get install -y \
  curl gettext-base postgresql-client vim \
  && rm -rf /var/lib/apt/lists/*

ENV INSTALL_DIR=/usr/local/bin \
    JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
 
# setup digdag server props
COPY ./digdag/server.properties /etc/server.properties
RUN envsubst < /etc/server.properties > /etc/server.properties

# Installin docker client
ENV DOCKER_CLIENT_VERSION=1.12.6 \
    DOCKER_API_VERSION=1.24
RUN curl -fsSL https://get.docker.com/builds/Linux/x86_64/docker-${DOCKER_CLIENT_VERSION}.tgz \
  | tar -xzC /usr/local/bin --strip=1 docker/docker
 
# digdag 本体をインストールする
RUN curl -o ${INSTALL_DIR}/digdag --create-dirs -L "https://dl.digdag.io/digdag-latest" \ 
  && chmod +x ${INSTALL_DIR}/digdag 

# Embulk 本体をインストールする
RUN wget -q https://dl.embulk.org/embulk-latest.jar -O ${INSTALL_DIR}/embulk \
  && chmod +x ${INSTALL_DIR}/embulk
 
 ## Add the wait script to the image
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.0.0/wait ${INSTALL_DIR}/wait
RUN chmod 755 ${INSTALL_DIR}/wait

# 使いたいプラグインを入れる(embulk-input-mysqlなど)
RUN embulk gem install embulk-input-s3 embulk-output-bigquery

EXPOSE 65432 65433

CMD ${INSTALL_DIR}/wait && digdag server --config /etc/server.properties --task-log /var/lib/digdag/logs/tasks  -m -b 0.0.0.0