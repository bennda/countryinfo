package main

import (
	"encoding/json"
	"errors"
	"fmt"
	"io/ioutil"
	"os"
	"strings"
)

type Country struct {
	Names struct {
		Name struct {
			Common   string `json:"Common"`
			Official string `json:"Official"`
		} `json:"Name"`
		Native struct {
			Hun struct {
				Official string `json:"official"`
				Common   string `json:"common"`
			} `json:"hun"`
		} `json:"Native"`
		AltSpellings []string `json:"AltSpellings"`
		Translations struct {
			Ara struct {
				Official string `json:"official"`
				Common   string `json:"common"`
			} `json:"ara"`
			Bre struct {
				Official string `json:"official"`
				Common   string `json:"common"`
			} `json:"bre"`
			Ces struct {
				Official string `json:"official"`
				Common   string `json:"common"`
			} `json:"ces"`
			Cym struct {
				Official string `json:"official"`
				Common   string `json:"common"`
			} `json:"cym"`
			Deu struct {
				Official string `json:"official"`
				Common   string `json:"common"`
			} `json:"deu"`
			Est struct {
				Official string `json:"official"`
				Common   string `json:"common"`
			} `json:"est"`
			Fin struct {
				Official string `json:"official"`
				Common   string `json:"common"`
			} `json:"fin"`
			Fra struct {
				Official string `json:"official"`
				Common   string `json:"common"`
			} `json:"fra"`
			Hrv struct {
				Official string `json:"official"`
				Common   string `json:"common"`
			} `json:"hrv"`
			Hun struct {
				Official string `json:"official"`
				Common   string `json:"common"`
			} `json:"hun"`
			Ita struct {
				Official string `json:"official"`
				Common   string `json:"common"`
			} `json:"ita"`
			Jpn struct {
				Official string `json:"official"`
				Common   string `json:"common"`
			} `json:"jpn"`
			Kor struct {
				Official string `json:"official"`
				Common   string `json:"common"`
			} `json:"kor"`
			Nld struct {
				Official string `json:"official"`
				Common   string `json:"common"`
			} `json:"nld"`
			Per struct {
				Official string `json:"official"`
				Common   string `json:"common"`
			} `json:"per"`
			Pol struct {
				Official string `json:"official"`
				Common   string `json:"common"`
			} `json:"pol"`
			Por struct {
				Official string `json:"official"`
				Common   string `json:"common"`
			} `json:"por"`
			Rus struct {
				Official string `json:"official"`
				Common   string `json:"common"`
			} `json:"rus"`
			Slk struct {
				Official string `json:"official"`
				Common   string `json:"common"`
			} `json:"slk"`
			Spa struct {
				Official string `json:"official"`
				Common   string `json:"common"`
			} `json:"spa"`
			Swe struct {
				Official string `json:"official"`
				Common   string `json:"common"`
			} `json:"swe"`
			Urd struct {
				Official string `json:"official"`
				Common   string `json:"common"`
			} `json:"urd"`
			Zho struct {
				Official string `json:"official"`
				Common   string `json:"common"`
			} `json:"zho"`
		} `json:"Translations"`
	} `json:"Names"`
	Codes struct {
		TLD   []string `json:"TLD"`
		Cca2  string   `json:"Cca2"`
		Cca3  string   `json:"Cca3"`
		Ccn3  string   `json:"Ccn3"`
		Cioc  string   `json:"Cioc"`
		Fifa  string   `json:"Fifa"`
		Car   []string `json:"Car"`
		Phone struct {
			Root     string   `json:"Root"`
			Suffixes []string `json:"Suffixes"`
		} `json:"Phone"`
	} `json:"Codes"`
	Currencies struct {
		HUF struct {
			Name   string `json:"name"`
			Symbol string `json:"symbol"`
		} `json:"HUF"`
	} `json:"Currencies"`
	Languages struct {
		Hun string `json:"hun"`
	} `json:"Languages"`
	Timezones     []string `json:"Timezones"`
	IsMemberUN    bool     `json:"IsMemberUN"`
	IsIndependent bool     `json:"IsIndependent"`
	GeoData       struct {
		Capital      []string  `json:"Capital"`
		Region       string    `json:"Region"`
		SubRegion    string    `json:"SubRegion"`
		Continents   []string  `json:"Continents"`
		Area         float64   `json:"Area"`
		Population   int       `json:"Population"`
		Borders      []string  `json:"Borders"`
		IsLandlocked bool      `json:"IsLandlocked"`
		LatLng       []float64 `json:"LatLng"`
	} `json:"GeoData"`
	Flag string `json:"Flag"`
}

func getCountriesSimple() map[string]string {
	countries := getCountries()
	result := make(map[string]string, len(countries))

	for _, country := range countries {
		result[country.Codes.Cca2] = country.Names.Name.Common
	}

	return result
}

func getCountries() []Country {
	jsonFile, err := os.Open("data/countries.json")
	if err != nil {
		fmt.Println(err)
	}
	defer jsonFile.Close()

	byteValue, _ := ioutil.ReadAll(jsonFile)
	var countries []Country
	json.Unmarshal(byteValue, &countries)

	return countries
}

func getCountry(name string) (Country, error) {
	var country Country
	countries := getCountries()

	for _, e := range countries {
		if strings.EqualFold(e.Codes.Cca2, name) {
			return e, nil
		} else if strings.EqualFold(e.Codes.Cca3, name) {
			return e, nil
		} else if strings.EqualFold(e.Codes.Ccn3, name) {
			return e, nil
		} else if strings.EqualFold(e.Names.Name.Common, name) {
			return e, nil
		} else if strings.EqualFold(e.Names.Name.Official, name) {
			return e, nil
		}
	}

	return country, errors.New("country not found")
}
