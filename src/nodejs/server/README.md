# Node.js CountryInfo REST Service
Dockerized REST service that provides country data and flag images.

## Usage

Build docker image and start container.

### Build image
Note: Build context needs to be the repository's root directory
```
docker build -f ./Dockerfile -t dnbnt/countryinfo:1.0-nodejs ./../../..
```

### Start container
```
docker run --rm -d -p 8080:8080 --name countryinfo dnbnt/countryinfo:1.0-nodejs
```

## Examples

### Get all countries
```
GET http://localhost:8080/countries
```

### Get country by name
```
GET http://localhost:8080/countries/japan
GET http://localhost:8080/countries/italia
GET http://localhost:8080/countries/at
GET http://localhost:8080/countries/dnk
```

### Get country flag

```
GET http://localhost:8080/countries/china/flag
GET http://localhost:8080/countries/se/flag
GET http://localhost:8080/countries/flags/jp
GET http://localhost:8080/countries/flags/de?format=svg
```

## License

The MIT License (MIT) see [License file](https://github.com/dnbnt/countryinfo/blob/main/LICENSE)