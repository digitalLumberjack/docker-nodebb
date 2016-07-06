FROM node:4.4
ARG NODEBB_VERSION=v1.0.3

RUN apt-get update && apt-get install -y gettext-base

ENV NODE_ENV=production \
    daemon=false \
    silent=false
ENV NODEBB_URL ''
ENV NODEBB_PORT ''
ENV NODEBB_SECRET ''
ENV MONGO_HOST 'mongo'
ENV MONGO_PORT '27017'
ENV MONGO_USERNAME ''
ENV MONGO_PASSWORD ''
ENV MONGO_DATABASE ''

ENV ADMIN_USERNAME ''
ENV ADMIN_PASSWORD ''
ENV ADMIN_EMAIL ''

ENV SSMTP_DOMAIN ''
ENV SSMTP_EMAIL ''
ENV SSMTP_HOST '' 
ENV SSMTP_PORT ''
ENV SSMTP_PASSWORD ''

ENV AWS_ACCESS_KEY_ID ''
ENV AWS_SECRET_ACCESS_KEY ''
ENV S3_UPLOADS_BUCKET ''
ENV S3_UPLOADS_HOST ''

WORKDIR /opt/nodebb
ADD https://github.com/NodeBB/NodeBB/archive/${NODEBB_VERSION}.tar.gz /opt/nodebb.tar.gz
RUN tar xvzf /opt/nodebb.tar.gz -C /opt/nodebb --strip 1
ADD start.sh /usr/local/bin/start.sh
ADD conf/config.json.template /opt/nodebb/config.json.template
ADD conf/ssmtp.conf.template /etc/ssmtp/ssmtp.conf.template

RUN npm install --production
RUN npm install nodebb-plugin-s3-uploads-updated@0.3.10

CMD /usr/local/bin/start.sh
