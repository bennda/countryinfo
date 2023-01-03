using System.Collections.Generic;

namespace DBN.CountryInfo.Models
{
    public class Country
    {
        /// <summary>
        /// Names
        /// </summary>
        public CountryNames Names { get; set; }

        /// <summary>
        /// Codes
        /// </summary>
        public CountryCodes Codes { get; set; }

        /// <summary>
        /// Geo data information
        /// </summary>
        public CountryGeoData GeoData { get; set; }

        /// <summary>
        /// Languages
        /// </summary>
        public Dictionary<string, string> Languages { get; set; }

        /// <summary>
        /// Currencies
        /// </summary>
        public Dictionary<string, CountryCurrency> Currencies { get; set; }

        /// <summary>
        /// Timezones
        /// </summary>
        public string[] Timezones { get; set; }

        /// <summary>
        /// United Nations member
        /// </summary>
        public bool? IsMemberUN { get; set; }

        /// <summary>
        /// Indenepdence status
        /// </summary>
        public bool? IsIndependent { get; set; }

        /// <summary>
        /// Flag
        /// </summary>
        public string Flag { get; set; }
    }
}