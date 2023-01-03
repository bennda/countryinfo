# makefile variables
URL_DUMP=https://restcountries.com/v3/all
OUT_FILE=/data/countries.json
VERSION=1.0

.PHONY: help

help:
	@echo "Makefile arguments:"
	@echo ""
	@echo "all           : init, build and publish"
	@echo "init          : download country resources files"
	@echo "build         : build all projects"
	@echo "dotnet-lib    : build DBN.CountryInfo, incl. nuget package"
	@echo "dotnet-service: build DBN.CountryInfo.Service, incl. docker image"
	@echo "nodejs-service: build dnbnt/countryinfo node.js docker image"

.DEFAULT_GOAL := help

init:
	@mkdir -p $$(pwd)/data
	@docker run --rm \
		-v $$(pwd):/repo \
		mcr.microsoft.com/powershell \
		pwsh /repo/src/scripts/dumpResources.ps1 -BasePath /repo -NodeJs

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
	@echo "\n===== publish .net project: DBN.CountryInfo.Service"
	@docker run --rm \
		-v $$(pwd):/repo \
		-w /repo/src/dotnet/DBN.CountryInfo.Service mcr.microsoft.com/dotnet/sdk \
		dotnet restore
	@docker run --rm \
		-v $$(pwd):/repo \
		-w /repo/src/dotnet/DBN.CountryInfo.Service mcr.microsoft.com/dotnet/sdk \
		dotnet publish -c release
	@echo "\n===== build docker image: dnbnt/countryinfo:${VERSION}"
	@docker build --no-cache --pull \
		-t dnbnt/countryinfo:${VERSION}-net \
		-f $$(pwd)/src/dotnet/DBN.CountryInfo.Service/Dockerfile $$(pwd)

nodejs-service:
	@echo "===== build node.js project: dbn.countryinfo"
	@docker build --no-cache --pull \
		-t dnbnt/countryinfo:${VERSION}-nodejs \
		-f $$(pwd)/src/nodejs/server/Dockerfile $$(pwd)/src/nodejs/server

build: dotnet-lib dotnet-service nodejs-service

all: init build