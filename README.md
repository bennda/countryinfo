# Country Info
Country data library implemented in various languages:

| Path   | Language   | Type  | Output  | Output Name | Description
|--|--|--|--|--|--|
| [src/dotnet/DNB.CountryInfo](https://github.com/dnbnt/countryinfo/blob/main/src/dotnet/DBN.CountryInfo/README.md)  | .NET  | Class Library  | nuget package  | DNB.CountryInfo.nupkg | .NET library that contains country data and flags |
| [src/dotnet/DNB.CountryInfo.Service](https://github.com/dnbnt/countryinfo/blob/main/src/dotnet/DBN.CountryInfo.Service/README.md)  | .NET  | Web API  | docker image  | dnbnt/countryinfo:1.0-net | Dockerized REST service that provides country data and flags |
| [src/nodejs/server](https://github.com/dnbnt/countryinfo/blob/main/src/nodejs/server/README.md) | Node.js  | REST API  | docker image  | dnbnt/countryinfo:1.0-nodejs | Dockerized REST service that provides country data and flags |

DBN.CountryInfo is available as Nuget package here: [https://www.nuget.org/packages/DBN.CountryInfo](https://www.nuget.org/packages/DBN.CountryInfo)

## Build
The project contains a `Makefile` which uses `docker` to download country data, flag images files and build all projects in a container.
```
make all
```

### Makefile
The `Makefile` supports the following parameters:
Download countries resource files from [https://restcountries.com/v3/all](https://restcountries.com/v3/all)
| Name  | Description |
|--|--|
| `help` | Show help (default) |
| `all` | Build everything (`init`, `build`) |
| `init` | Download countries resource files from [https://restcountries.com/v3/all](https://restcountries.com/v3/all) and copy `countries.json` and flag image files to project directories |
| `build` | Build all projects |
| `dotnet-lib` | Build .NET class library |
| `dotnet-service` | Build .NET rest webapi docker image |
| `nodejs-service` | Build Node.js rest webservice docker image |

## License
The MIT License (MIT) see [License file](https://github.com/dnbnt/countryinfo/blob/main/LICENSE)