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

.DEFAULT_GOAL := help

init:
	@mkdir -p $$(pwd)/data
	@docker run --rm \
		-v $$(pwd)/data:/data \
		-v $$(pwd)/src/scripts:/src mcr.microsoft.com/powershell \
		pwsh /src/dumpResources.ps1 -DumpPath /data

dotnet-lib:
	@echo "===== build project: DBN.CountryInfo"
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
	@echo "\n===== publish project: DBN.CountryInfo.Service"
	@docker run --rm \
		-v $$(pwd):/repo \
		-w /repo/src/dotnet/DBN.CountryInfo.Service mcr.microsoft.com/dotnet/sdk \
		dotnet restore
	@docker run --rm \
		-v $$(pwd):/repo \
		-w /repo/src/dotnet/DBN.CountryInfo.Service mcr.microsoft.com/dotnet/sdk \
		dotnet publish -c release
	@echo "\n===== build docker image: dnbnt/countryinfo:${VERSION}"
	@docker build \
		-t dnbnt/countryinfo:${VERSION} \
		-f $$(pwd)/src/dotnet/DBN.CountryInfo.Service/Dockerfile $$(pwd)

build: dotnet-lib dotnet-service

all: init build