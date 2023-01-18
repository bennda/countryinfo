# Go Country Info Service
REST API webservice to get country data and image flags. Implemented in Go.

## Usage

Add dependency to DBN.CountryInfo to your project and import namespace.

### Build image
```
docker build -t dnbnt/countryinfo:1.0-net-go .
```

### Start container
```
docker run --rm -d -p 8080:8080 --name countryinfo dnbnt/countryinfo:1.0-go
```

## Examples

### Get all countries
```
GET http://localhost:8080/countries
```

### Get country by name/code
```
GET http://localhost:8080/countries/japan
GET http://localhost:8080/countries/italia
GET http://localhost:8080/countries/at
GET http://localhost:8080/countries/dnk
```
### Get country flag

```
GET http://localhost:8080/countries/it/flag
GET http://localhost:8080/countries/us/flag
GET http://localhost:8080/flags/jp
GET http://localhost:8080/flags/de
```

## License

The MIT License (MIT) see [License file](https://github.com/dnbnt/countryinfo/LICENSE)