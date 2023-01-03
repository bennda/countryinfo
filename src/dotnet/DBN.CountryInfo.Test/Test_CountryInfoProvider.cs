using DBN.CountryInfo;
using DBN.CountryInfo.Models;

namespace DBN.CountryInfo.Test
{
    [TestClass]
    public class Test_CountryInfoProvider
    {
        [TestMethod]
        public void Test_Get_Countries()
        {            
            var countries = CountryInfoProvider.Instance.GetCountries();
            Assert.IsTrue(countries.Any());
            Assert.AreEqual(0, countries.Where(p => string.IsNullOrEmpty(p.Names.Name.Common)).Count(), "array contains empty common name");
            Assert.AreEqual(0, countries.Where(p => string.IsNullOrEmpty(p.Names.Name.Official)).Count(), "array contains empty official name");
            Assert.AreEqual(0, countries.Where(p => string.IsNullOrEmpty(p.Codes.Cca2)).Count(), "array contains empty cca2 code");
            Assert.AreEqual(0, countries.Where(p => string.IsNullOrEmpty(p.Codes.Cca3)).Count(), "array contains empty cca3 code");
            Assert.AreEqual(0, countries.Where(p => string.IsNullOrEmpty(p.GeoData.Region)).Count(), "array contains empty region");
            Assert.AreEqual(0, countries.Where(p => !p.Timezones.Any()).Count(), "array contains empty timezone");
        }

        [TestMethod]
        public void Test_Get_Country()
        {
            var country = CountryInfoProvider.Instance.GetCountry("Aruba");
            Assert.IsNotNull(country, "country is null");
            Assert.AreEqual("Aruba", country.Names.Name.Common, "common name incorrect");
        }

        [TestMethod]
        public void Test_Get_TLD()
        {
            var countries = CountryInfoProvider.Instance.GetCountries().Where(p => p.Names.Name.Common != "Kosovo");
            Assert.AreEqual(0, countries.Where(p => (p.Codes.TLD == null || p.Codes.TLD.Count() == 0)).Count(), "array contains empty tld code");
        }

        [TestMethod]
        public void Test_Get_Flag()
        {
            var flag = CountryInfoProvider.Instance.GetCountryFlag("ad.png");
            Assert.IsNotNull(flag, "flag is null");
        }
    }
}
