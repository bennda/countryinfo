using DBN.CountryInfo;
using DBN.CountryInfo.Models;

// init variables
Dictionary<string, string> imageContentTypeMap = new Dictionary<string, string>() {
    { "png", "image/png" },
    { "svg", "image/svg+xml" }
};

var builder = WebApplication.CreateBuilder(args);

// add services to the container.
var app = builder.Build();

// Configure the HTTP request pipeline.
app.UseHttpsRedirection();

// configure routes
app.MapGet("/countries", () =>
{
    return new Dictionary<string, string>(CountryInfoProvider.Instance.GetCountries().Select(x =>
        new KeyValuePair<string, string>(x.Codes.Cca2, x.Names.Name.Common)));
});

app.MapGet("/countries/{name}", (string name) =>
{
    var country = CountryInfoProvider.Instance.GetCountry(name);
    return country == null ? TypedResults.NotFound("country not found")  : Results.Json(country);
});

app.MapGet("/countries/{name}/flag", (string name, string? format) =>
{
    Enum.TryParse(format, true, out CountryFlagFormat imageFormat);
    var flag = CountryInfoProvider.Instance.GetCountryFlag(name, imageFormat);
    return flag == null
        ? TypedResults.NotFound("country flag not found")
        : Results.File(flag.Content, imageContentTypeMap.GetValueOrDefault(flag.Format.ToString().ToLower()));
});

app.MapGet("/countries/flags/{name}", (string name, string? format) =>
{
    Enum.TryParse(format, true, out CountryFlagFormat imageFormat);
    var flag = CountryInfoProvider.Instance.GetCountryFlag(name, imageFormat);
    return flag == null
        ? TypedResults.NotFound("country flag not found")
        : Results.File(flag.Content, imageContentTypeMap.GetValueOrDefault(flag.Format.ToString().ToLower()));
});

app.Run();