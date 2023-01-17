using DBN.CountryInfo.Models;
using Microsoft.AspNetCore.Mvc;
using System.Xml.Linq;

namespace DBN.CountryInfo.Angular.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class CountryInfoController : ControllerBase
    {
        private readonly ILogger<CountryInfoController> _logger;
        private readonly CountryInfoProvider _countryProvider;

        public CountryInfoController(ILogger<CountryInfoController> logger, CountryInfoProvider countryInfoProvider)
        {
            _logger = logger;
            _countryProvider = countryInfoProvider;
        }

        [HttpGet]
        public async Task<IActionResult> Get(string? search)
        {
            var countries = await Task.Run(() => _countryProvider.GetCountries()
                .Where(c => !string.IsNullOrEmpty(search) &&
                    (c.Codes.Cca2 ?? "").Contains(search ?? "", StringComparison.OrdinalIgnoreCase) ||
                    (c.Codes.Cca3 ?? "").Contains(search ?? "", StringComparison.OrdinalIgnoreCase) ||
                    (c.Codes.Ccn3 ?? "").Contains(search ?? "", StringComparison.OrdinalIgnoreCase) ||
                    (c.Names.Name.Common ?? "").Contains(search ?? "", StringComparison.OrdinalIgnoreCase) ||
                    (c.Names.Name.Official ?? "").Contains(search ?? "", StringComparison.OrdinalIgnoreCase)

                )
                .Select(x => new Country { 
                    Code = x.Codes.Cca2, 
                    Name = x.Names.Name.Common 
                })
                .OrderBy(x => x.Code));

            return Ok(countries);
        }

        [HttpGet]
        [Route("{code}")]
        public async Task<IActionResult> GetCountry(string code)
        {  
            var countries = await Task.Run(() =>
            {
                return _countryProvider.GetCountries().Where(c =>
                    (c.Codes.Cca2 ?? "").Equals(code, StringComparison.OrdinalIgnoreCase));
            });

            return Ok(countries);
        }



        [HttpGet]
        [Route("{name}/flag")]
        public async Task<IActionResult> GetFlag(string name)
        {
            var flag = await Task.Run<CountryFlag>(()=> _countryProvider.GetCountryFlag(name));
            return File(flag.Content, "image/jpg");
        }
    }

    public class Country
    {
        public string? Name { get; set; }
        public string? Code { get; set; }
    }
}