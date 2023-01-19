# DBN.CountryInfo.React
Dockerized React web application that provides country data and flag images.

## Usage

Build docker image and start container.

### Build image

```
docker build -t dnbnt/countryinfo:1.0-net-react .
```

### Start container
```
docker run --rm -d -p 8080:80 --name countryinfo dnbnt/countryinfo:1.0-net-react
```

## License

The MIT License (MIT) see [License file](https://github.com/dnbnt/countryinfo/blob/main/LICENSE)