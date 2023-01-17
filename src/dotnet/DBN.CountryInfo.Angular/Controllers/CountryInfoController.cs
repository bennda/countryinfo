using DBN.CountryInfo.Models;
using Microsoft.AspNetCore.Mvc;

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
        public async Task<IActionResult> Get()
        {
            var countries = await Task.Run(() => _countryProvider.GetCountries()
                .Select(x => new Country { 
                    Code = x.Codes.Cca2, 
                    Name = x.Names.Name.Common 
                })
                .OrderBy(x => x.Code));

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