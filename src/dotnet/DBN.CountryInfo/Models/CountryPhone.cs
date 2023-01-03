namespace DBN.CountryInfo.Models
{
    public class CountryPhone
    {
        /// <summary>
        /// Root phone code
        /// </summary>
        public string Root { get; set; }

        /// <summary>
        /// Suffix codes
        /// </summary>
        public string[] Suffixes { get; set; }
    }
}
