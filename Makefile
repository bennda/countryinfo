# makefile variables
URL_DUMP=https://restcountries.com/v3/all
OUT_FILE=/data/countries.json

IMAGE_NAME=dnbnt/countryinfo
IMAGE_VERSION=1.0
IMAGE_FULLNAME=${IMAGE_NAME}:${IMAGE_VERSION}
NETWORK_NAME=countryinfo-test
TEST_CONTAINER_NAME=testcountryinfo
SUFFIX_GO=go
SUFFIX_NET=net
SUFFIX_NODE=node
SUFFIX_PYTHON=python

.PHONY: help

help:
	@echo "Makefile arguments:"
	@echo ""
	@echo "all           : init, build and publish"
	@echo "init          : download country resources files"
	@echo "build         : build all projects"
	@echo "dotnet-lib    : build DBN.CountryInfo, incl. nuget package"
	@echo "dotnet-service: build DBN.CountryInfo.Service, incl. docker image"
	@echo "dotnet-angular: build DBN.CountryInfo.Angular docker image"
	@echo "dotnet-react  : build DBN.CountryInfo.React docker image"
	@echo "nodejs-service: build dnbnt/countryinfo node.js docker image"
	@echo "go-service    : build dnbnt/countryinfo go docker image"
	@echo "test          : test all projects"

.DEFAULT_GOAL := help

init:
	@mkdir -p $$(pwd)/data
	@docker run --rm \
		-v $$(pwd):/repo \
		mcr.microsoft.com/powershell \
		pwsh /repo/src/scripts/dumpResources.ps1 -BasePath /repo -NodeJs

test-init:
		@echo "\n===== test-init"
		@export NETWORK="$(shell docker network ls --filter name=${NETWORK_NAME} --format "{{.Name}}")"; \
		if ! [ "$(shell docker network ls --filter name=${NETWORK_NAME} --format "{{.Name}}")" = "${NETWORK_NAME}" ]; then docker network create --driver=bridge --subnet=172.232.0.0/16 ${NETWORK_NAME}; fi;

test-cleanup:
		@echo "\n===== test-cleanup"
		@if [ "$(shell docker ps -a --filter name=${TEST_CONTAINER_NAME} --format "{{.Names}}")" = "${TEST_CONTAINER_NAME}" ]; then docker rm -f ${TEST_CONTAINER_NAME}; fi;
		@if [ "$(shell docker ps -a --filter name=${TEST_CONTAINER_NAME}-${SUFFIX_GO} --format "{{.Names}}")" = "${TEST_CONTAINER_NAME}-${SUFFIX_GO}" ]; then docker rm -f ${TEST_CONTAINER_NAME}-${SUFFIX_GO}; fi;
		@if [ "$(shell docker ps -a --filter name=${TEST_CONTAINER_NAME}-${SUFFIX_NET} --format "{{.Names}}")" = "${TEST_CONTAINER_NAME}-${SUFFIX_NET}" ]; then docker rm -f ${TEST_CONTAINER_NAME}-${SUFFIX_NET}; fi;
		@if [ "$(shell docker ps -a --filter name=${TEST_CONTAINER_NAME}-${SUFFIX_NODE} --format "{{.Names}}")" = "${TEST_CONTAINER_NAME}-${SUFFIX_NODE}" ]; then docker rm -f ${TEST_CONTAINER_NAME}-${SUFFIX_NODE}; fi;
		@if [ "$(shell docker ps -a --filter name=${TEST_CONTAINER_NAME}-${SUFFIX_PYTHON} --format "{{.Names}}")" = "${TEST_CONTAINER_NAME}-${SUFFIX_PYTHON}" ]; then docker rm -f ${TEST_CONTAINER_NAME}-${SUFFIX_PYTHON}; fi;
		@if [ "$(shell docker network ls --filter name=${NETWORK_NAME} --format "{{.Name}}")" = "${NETWORK_NAME}" ]; then docker network rm ${NETWORK_NAME}; fi

dotnet-lib:
	@echo "===== build .net project: DBN.CountryInfo"
	@docker run --rm \
		-v $$(pwd):/repo \
		-w /repo/src/dotnet/DBN.CountryInfo mcr.microsoft.com/dotnet/sdk \
		dotnet build -c release
	@echo "===== build package: DBN.CountryInfo"
	@docker run --rm \
		-v $$(pwd):/repo \
		-w /repo/src/dotnet/DBN.CountryInfo mcr.microsoft.com/dotnet/sdk \
		dotnet pack -o /repo/output/nuget \
					-c release \
					-p:NuspecFile=./DBN.CountryInfo.nuspec

dotnet-service:
	@echo "\n===== build docker image: ${IMAGE_FULLNAME}-${SUFFIX_NET}"
	@docker build --no-cache --pull \
		-t ${IMAGE_FULLNAME}-${SUFFIX_NET} \
		-f $$(pwd)/src/dotnet/DBN.CountryInfo.Service/Dockerfile $$(pwd)/src/dotnet/DBN.CountryInfo.Service

dotnet-test:
	@echo "\n===== test docker image: ${IMAGE_FULLNAME}-${SUFFIX_NET}"
	@if [ "$(shell docker ps -a --filter name=${TEST_CONTAINER_NAME}-${SUFFIX_NET} --format "{{.Names}}")" = "${TEST_CONTAINER_NAME}-${SUFFIX_NET}" ]; then docker rm -f ${TEST_CONTAINER_NAME}-${SUFFIX_NET}; fi
		@docker run -d --name ${TEST_CONTAINER_NAME}-${SUFFIX_NET} --network ${NETWORK_NAME} ${IMAGE_FULLNAME}-${SUFFIX_NET}
		@JSON="$$(docker run --rm --network ${NETWORK_NAME} curlimages/curl -s '${TEST_CONTAINER_NAME}-${SUFFIX_NET}/countries')"; \
		echo "JSON: $$JSON";


dotnet-angular:
	@echo "\n===== build docker image: dnbnt/countryinfo:${VERSION}-net-angular"
	@docker build --no-cache --pull \
		-t dnbnt/countryinfo:${VERSION}-net-angular \
		-f $$(pwd)/src/dotnet/DBN.CountryInfo.Angular/Dockerfile $$(pwd)/src/dotnet/DBN.CountryInfo.Angular

dotnet-react:
	@echo "\n===== build docker image: dnbnt/countryinfo:${VERSION}-net-react"
	@docker build --no-cache --pull \
		-t dnbnt/countryinfo:${VERSION}-net-react \
		-f $$(pwd)/src/dotnet/DBN.CountryInfo.React/Dockerfile $$(pwd)/src/dotnet/DBN.CountryInfo.React

nodejs-service:
	@echo "===== build node.js project: ${IMAGE_FULLNAME}-${SUFFIX_NODE}"
	@docker build --no-cache --pull \
		-t ${IMAGE_FULLNAME}-${SUFFIX_NODE} \
		-f $$(pwd)/src/nodejs/server/Dockerfile $$(pwd)/src/nodejs/server

nodejs-service-test:
	@echo "\n===== test docker image: ${IMAGE_FULLNAME}-${SUFFIX_NODE}"
	@if [ "$(shell docker ps -a --filter name=${TEST_CONTAINER_NAME}-${SUFFIX_NODE} --format "{{.Names}}")" = "${TEST_CONTAINER_NAME}-${SUFFIX_NODE}" ]; then docker rm -f ${TEST_CONTAINER_NAME}-${SUFFIX_NODE}; fi
		@docker run -d --name ${TEST_CONTAINER_NAME}-${SUFFIX_NODE} --network ${NETWORK_NAME} ${IMAGE_FULLNAME}-${SUFFIX_NODE}
		@JSON="$$(docker run --rm --network ${NETWORK_NAME} curlimages/curl -s '${TEST_CONTAINER_NAME}-${SUFFIX_NODE}:8080/countries')"; \
		echo "JSON: $$JSON";

go-service:
	@echo "===== build go project: dbn.countryinfo"
	@docker build --no-cache --pull \
		-t dnbnt/countryinfo:${VERSION}-go \
		-f $$(pwd)/src/go/server/Dockerfile $$(pwd)/src/go/server

go-service-test:
	@echo "\n===== test docker image: ${IMAGE_FULLNAME}-${SUFFIX_GO}"
	@if [ "$(shell docker ps -a --filter name=${TEST_CONTAINER_NAME}-${SUFFIX_GO} --format "{{.Names}}")" = "${TEST_CONTAINER_NAME}-${SUFFIX_GO}" ]; then docker rm -f ${TEST_CONTAINER_NAME}-${SUFFIX_GO}; fi
		@docker run -d --name ${TEST_CONTAINER_NAME}-${SUFFIX_GO} --network ${NETWORK_NAME} ${IMAGE_FULLNAME}-${SUFFIX_GO}
		@JSON="$$(docker run --rm --network ${NETWORK_NAME} curlimages/curl -s '${TEST_CONTAINER_NAME}-${SUFFIX_GO}:8080/countries')"; \
		echo "JSON: $$JSON";

build: dotnet-lib dotnet-service dotnet-angular dotnet-react nodejs-service go-service

test: test-init dotnet-test nodejs-service-test go-service-test test-cleanup

all: init build