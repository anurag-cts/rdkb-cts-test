#!/bin/bash

docker buildx build -t rdk-b:latest \
	--build-arg "USER=$(whoami)" \
	--build-arg "host_uid=$(id -u)" \
	--build-arg "host_gid=$(id -g)" .
