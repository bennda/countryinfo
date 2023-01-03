using System.Collections.Generic;

namespace DBN.CountryInfo.Models
{
    public class CountryName
    {
        public string Common { get; set; }
        public string Official { get; set; }
    }

    public class CountryNames
    {
        public CountryName Name { get; set; }
        public Dictionary<string, CountryName> Native { get; set; }        
        public string[] AltSpellings { get; set; }
        public Dictionary<string, CountryName> Translations { get; set; }
    }
}
