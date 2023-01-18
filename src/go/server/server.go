package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"strings"

	"github.com/gorilla/mux"
)

func getCountriesHandler(writer http.ResponseWriter, request *http.Request) {
	countries := getCountriesSimple()
	text, _ := json.Marshal(countries)
	writer.WriteHeader(http.StatusOK)
	writer.Header().Set("Content-Type", "application/json")
	fmt.Fprintf(writer, string(text))
}

func getCountryHandler(writer http.ResponseWriter, request *http.Request) {
	vars := mux.Vars(request)
	name := vars["name"]
	country, err := getCountry(name)
	if err != nil {
		writer.WriteHeader(404)
		fmt.Fprintf(writer, string("country not found"))
		return
	}

	text, _ := json.Marshal(country)
	writer.WriteHeader(http.StatusOK)
	writer.Header().Set("Content-Type", "application/json")
	fmt.Fprintf(writer, string(text))
}

func getFlagHandler(writer http.ResponseWriter, request *http.Request) {
	vars := mux.Vars(request)
	code := strings.ToLower(vars["code"])

	flagfile := fmt.Sprintf("./data/flags/%s.png", code)
	fileBytes, err := ioutil.ReadFile(flagfile)
	if err != nil {
		writer.WriteHeader(404)
		fmt.Fprintf(writer, string("country not found"))
		return
	}

	writer.WriteHeader(http.StatusOK)
	writer.Header().Set("Content-Type", "image/png")
	writer.Write(fileBytes)
}

func main() {
	log.Println("starting server, listening on port 8080")

	r := mux.NewRouter()

	r.HandleFunc("/countries/{code}/flag", getFlagHandler)
	r.HandleFunc("/countries/{name}", getCountryHandler)
	r.HandleFunc("/countries", getCountriesHandler)
	r.HandleFunc("/flags/{code}", getFlagHandler)

	http.ListenAndServe(":8080", r)
}
