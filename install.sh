#!/bin/bash

set -e

# In production you really want to change this variable
CLAWIO_INSTALL_PATH=/tmp/clawioproject
rm -rf ${CLAWIO_INSTALL_PATH}
mkdir -p ${CLAWIO_INSTALL_PATH}
cd ${CLAWIO_INSTALL_PATH}

# Clone required services. Add your own.
git clone https://github.com/clawio/orches
git clone https://github.com/clawio/service-auth
git clone https://github.com/clawio/service-ocwebdav
git clone https://github.com/clawio/service-mysql
git clone https://github.com/clawio/service-mysql-localfsxattr
git clone https://github.com/clawio/service-localfs-data
git clone https://github.com/clawio/service-localfs-meta
git clone https://github.com/clawio/service-localfs-prop
git clone https://github.com/clawio/service-localfsxattr-data
git clone https://github.com/clawio/service-localfsxattr-meta
git clone https://github.com/clawio/service-localfsxattr-mysqlprop
git clone https://github.com/clawio/service-localfsxattr-redisprop
git clone https://github.com/clawio/clawio
git clone https://github.com/clawio/clawiobench

cp orches/deploy.json .

# Ideally docker-compose up -d will be enough but given that
# some containers need to be launched in sequence and
# compose does not guarantee that, we launch them in manually
# in the desired sequence.
docker-compose -f deploy.json build --no-cache --force-rm
docker-compose -f deploy.json up -d --force-recreate

# show services running.
docker-compose -f deploy.json ps
docker-compose -f deploy.json ps
docker-compose -f deploy.json ps
docker-compose -f deploy.json ps

## Increase max connections for MySQL
docker exec -it service-localfs-prop-mysql mysql -uroot -padmin -e "set global max_connections=100000"
docker exec -it service-localfsxattr-mysqlprop-mysql mysql -uroot -padmin -e "set global max_connections=100000"

echo "ClawIO is up and running"
echo "If you see some service with status Exit run:"
echo " 'docker-compose -f deploy.json up -d' a couple of times until"
echo "all services are up."


