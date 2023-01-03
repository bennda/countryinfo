# DBN.CountryInfo v1.0.0
.NET library to load country data, incl. image flags (.png/.svg). 

Documentation is available on [GitHub](https://github.com/dnbnt/countryinfo/README.md).

## Usage

Add dependency to DBN.CountryInfo to your project and import namespace.

## Examples

- Get all countries

```csharp
var countries = CountryInfoProvider.Instance.GetCountries();
```

- Get country by name

```csharp
var japan   = CountryInfoProvider.Instance.GetCountry("japan");
var italy   = CountryInfoProvider.Instance.GetCountry("italia");
var austria = CountryInfoProvider.Instance.GetCountry("at");
var denmark = CountryInfoProvider.Instance.GetCountry("dnk");
```

- Get country flag

```csharp
var china  = CountryInfoProvider.Instance.GetCountryFlag("china")
var sweden = CountryInfoProvider.Instance.GetCountryFlag("se", CountryFlagFormat.Svg)
```

## License

The MIT License (MIT) see [License file](https://github.com/dnbnt/countryinfo/LICENSE)