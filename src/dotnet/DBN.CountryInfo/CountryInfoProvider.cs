using System.Reflection;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using DBN.CountryInfo.Models;
using System.Text.Json;

namespace DBN.CountryInfo
{
    public class CountryInfoProvider
    {
        private static CountryInfoProvider _instance;
        public static CountryInfoProvider Instance { 
            get
            {
                if (_instance == null)
                {
                    _instance = new CountryInfoProvider();
                }
                return _instance;
            }
        }

        private static IEnumerable<Country> _countries;

        public CountryInfoProvider()
        {
            if (_countries == null)
            {
                _countries = _DeserializeCountriesFromEmbeddedResource();
            }
        }                
        
        public IEnumerable<Country> GetCountries()
        {
            return _countries;
        }
        
        public Country GetCountry(string name)
        {
            // get by code
            switch (name.Length)
            {
                case 2:
                    return _countries.FirstOrDefault(p => p.Codes.Cca2.Equals(name, System.StringComparison.OrdinalIgnoreCase));
                case 3:
                    return _countries.FirstOrDefault(p =>
                        p.Codes.Cca3.Equals(name, System.StringComparison.OrdinalIgnoreCase) ||
                        p.Codes.Ccn3.Equals(name, System.StringComparison.OrdinalIgnoreCase));
                default:
                    return _countries.FirstOrDefault(c =>
                        c.Names.Name.Common.Equals(name, System.StringComparison.OrdinalIgnoreCase) ||
                        c.Names.Translations.Values.Any(t => t.Common.Equals(name, System.StringComparison.OrdinalIgnoreCase)));
            }
        }

        public CountryFlag GetCountryFlag(string name, CountryFlagFormat format = CountryFlagFormat.Png)
        {
            var resName = $"{typeof(CountryInfoProvider).Namespace}.Data.Flags.{name}";
            if (!Assembly.GetExecutingAssembly().GetManifestResourceNames().Any(p => p == resName)) {
                if (name.EndsWith(".png", System.StringComparison.OrdinalIgnoreCase))
                {
                    format = CountryFlagFormat.Png;
                }
                else if (name.EndsWith(".svg", System.StringComparison.OrdinalIgnoreCase))
                {
                    format = CountryFlagFormat.Svg;
                }
                resName = $"{typeof(CountryInfoProvider).Namespace}.Data.Flags.{name}.{format.ToString().ToLowerInvariant()}";
                if (!Assembly.GetExecutingAssembly().GetManifestResourceNames().Any(p => p == resName))
                {
                    var country = GetCountry(name);
                    if (country != null)
                    {
                        resName = $"{typeof(CountryInfoProvider).Namespace}.Data.Flags.{country.Codes.Cca2.ToLowerInvariant()}.{format.ToString().ToLowerInvariant()}";
                    } else
                    {
                        return null;
                    }
                }
            }

            if (resName.EndsWith(".png"))
            {
                format = CountryFlagFormat.Png;
            }
            if (resName.EndsWith(".svg"))
            {
                format = CountryFlagFormat.Svg;
            }

            using var stream = Assembly.GetExecutingAssembly().GetManifestResourceStream($"{resName}");
            byte[] flagBytes = new byte[stream.Length];
            stream.Read(flagBytes, 0, flagBytes.Length);
            return new CountryFlag { Content = flagBytes, Format = format };
        }


        /// <summary>
        /// Deserialize countries from embedded .json file
        /// </summary>
        /// <returns></returns>
        private static IEnumerable<Country> _DeserializeCountriesFromEmbeddedResource()
        {
            var assembly = Assembly.GetAssembly(typeof(CountryInfoProvider));
            var names = assembly.GetManifestResourceNames();
            using var stream = assembly.GetManifestResourceStream($"{typeof(CountryInfoProvider).Namespace}.Data.countries.json");
            
            using var streamReader = new StreamReader(stream);
            return JsonSerializer.Deserialize<Country[]>(streamReader.ReadToEnd(), new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
        }
    }
}