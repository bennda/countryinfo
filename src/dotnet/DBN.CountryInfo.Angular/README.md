# DBN.CountryInfo.Angular
Dockerized Angular web application that provides country data and flag images.

## Usage

Build docker image and start container.

### Build image

```
docker build -t dnbnt/countryinfo:1.0-net-angular .
```

### Start container
```
docker run --rm -d -p 8080:80 --name countryinfo dnbnt/countryinfo:1.0-net
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
GET http://localhost:8080/countries/china/flag
GET http://localhost:8080/countries/se/flag
GET http://localhost:8080/countries/flags/jp
GET http://localhost:8080/countries/flags/de?format=svg
```

## License

The MIT License (MIT) see [License file](https://github.com/dnbnt/countryinfo/blob/main/LICENSE)