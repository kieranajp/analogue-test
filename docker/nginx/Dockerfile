# Use NGINX
# See https://github.com/nginxinc/docker-nginx for source
FROM nginx:1.13-alpine

# Configure nginx
COPY default.template /etc/nginx/conf.d/default.template

# Install application/service
ENV APP_DIR /server/http

RUN set -ex \
    && mkdir -p /server/http/public

# Chance the default command to replace enviroment variables in the template
CMD sh -exc "envsubst '\$PHP_FPM_URI \$APP_DIR' < /etc/nginx/conf.d/default.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"
