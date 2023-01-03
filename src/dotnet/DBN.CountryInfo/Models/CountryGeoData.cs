namespace DBN.CountryInfo.Models
{
    public class CountryGeoData
    {
        /// <summary>
        /// Capital
        /// </summary>
        public string[] Capital { get; set; }

        /// <summary>
        /// Region
        /// </summary>
        public string Region { get; set; }

        /// <summary>
        /// Subregion
        /// </summary>
        public string Subregion { get; set; }

        /// <summary>
        /// Landlock status
        /// </summary>
        public bool? IsLandlocked { get; set; }

        /// <summary>
        /// Area
        /// </summary>
        public float Area { get; set; }

        /// <summary>
        /// Population
        /// </summary>
        public long Population { get; set; }

        /// <summary>
        /// Continents
        /// </summary>
        public string[] Continents { get; set; }

        /// <summary>
        /// Border countries
        /// </summary>
        public string[] Borders { get; set; }

        /// <summary>
        /// Position
        /// </summary>
        public float[] LatLng { get; set; }
    }
}
