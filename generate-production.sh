#!/bin/bash

export NODE_ENV=production
export RAILS_ENV=production
export INSTALLATION_ENV=docker

rm -rf spec/enterprise
rm -rf enterprise
echo -en '\nENV CW_EDITION="ce"' >> docker/Dockerfile

docker buildx build --no-cache --push --platform linux/arm64 --tag juliancesar/chatwoot:v3.16.0-ekipes -f ./docker/Dockerfile .