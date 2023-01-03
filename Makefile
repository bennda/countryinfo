# makefile variables
URL_DUMP=https://restcountries.com/v3/all
OUT_FILE=/data/countries.json
VERSION=1.0

.PHONY: help

help:
	@echo "Makefile arguments:"
	@echo ""
	@echo "init : download country resources and write .csproj file"
	@echo "nuget: build nuget packages"

.DEFAULT_GOAL := all

init:
	@mkdir -p $$(pwd)/data
	@docker run --rm \
		-v $$(pwd)/data:/data \
		-v $$(pwd)/src:/src mcr.microsoft.com/powershell pwsh /data/dump.ps1

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

publish: dotnet-nuget

all: init build publish