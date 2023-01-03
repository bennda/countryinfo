namespace DBN.CountryInfo.Models
{
    public class CountryFlag
    {
        /// <summary>
        /// Flag image format
        /// </summary>
        public CountryFlagFormat Format { get; set; }

        /// <summary>
        /// Flag image bytes
        /// </summary>
        public byte[] Content { get; set; }
    }
}
