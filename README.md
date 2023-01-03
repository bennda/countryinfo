# Country Info

Country data library implemented in various languages

## Build
The project contains a `Makefile` to prepare and build projects

### initialize
Download countries resource files from [https://restcountries.com/v3/all](https://restcountries.com/v3/all)
```
make init
```

### build nuget packages
Generate nuget packages
```
make nuget
```

## DNB.CountryInfo
.NET library that contains country data and flags

See documentation [here](https://github.com/dnbnt/countryinfo/blob/main/src/dotnet/DBN.CountryInfo/README.md)

## DNB.CountryInfo.Service
Dockerized REST service that provides country data and flags.

See documentation [here](https://github.com/dnbnt/countryinfo/blob/main/src/dotnet/DBN.CountryInfo.Service/README.md)

## DNB.CountryInfo.Test
Unit test project for DNB.CountryInfo

## License

The MIT License (MIT) see [License file](https://github.com/dnbnt/countryinfo/blob/main/LICENSE)