import { Component, Inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'app-country-info',
  templateUrl: './country-info.component.html',
})
export class CountryInfoComponent {
  private http: HttpClient;
  private baseUrl: string;
  public countries: Country[] = [];

  constructor(http: HttpClient, @Inject('BASE_URL') baseUrl: string) {
    this.http = http;
    this.baseUrl = baseUrl;
    this.filterCountries('');
  }

  filterCountries(searchText: string) {
    searchText = searchText.trim().toLowerCase();
    if (searchText) {
      searchText = '?search=' + searchText;
    }

    this.http.get<Country[]>(this.baseUrl + 'countryinfo' + searchText).subscribe(result => {
      this.countries = result;
    }, error => console.error(error));
  }

  onFilterCountries(event: any) {
    this.filterCountries(event.target.value);
  }
}

interface Country {
  code: string;
  name: string;
}
