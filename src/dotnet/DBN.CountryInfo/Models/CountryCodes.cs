namespace DBN.CountryInfo.Models
{
    public class CountryCodes
    {
        /// <summary>
        /// Top level domains
        /// </summary>
        public string[] TLD { get; set; }

        /// <summary>
        /// ISO 3166-1 alpha-2
        /// </summary>
        public string Cca2 { get; set; }

        /// <summary>
        /// ISO 3166-1 alpha-3
        /// </summary>
        public string Cca3 { get; set; }

        /// <summary>
        ///  ISO 3166-1 numeric
        /// </summary>
        public string Ccn3 { get; set; }

        /// <summary>
        /// Internation olympic committee
        /// </summary>
        public string Cioc { get; set; }

        /// <summary>
        /// Fédération Internationale de Football Association
        /// </summary>
        public string Fifa { get; set; }

        /// <summary>
        /// Car plate country codes
        /// </summary>
        public string[] Car { get; set; }

        /// <summary>
        /// Internation phone code
        /// </summary>
        public CountryPhone Phone { get; set; }
    }
}
