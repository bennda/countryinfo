import { Component, Inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'app-country-info',
  templateUrl: './country-info.component.html',
})
export class CountryInfoComponent {
  private _countries: Country[] = [];
  public countries: Country[] = [];

  constructor(http: HttpClient, @Inject('BASE_URL') baseUrl: string) {
    http.get<Country[]>(baseUrl + 'countryinfo').subscribe(result => {
      this._countries = result;
      this.filterCountries('');
    }, error => console.error(error));
  }

  filterCountries(searchText: string) {
    searchText = searchText.trim().toLowerCase();
    if (searchText) {
      this.countries = this._countries.filter((obj) => {
        return obj.code.toLowerCase().includes(searchText)
          || obj.name.toLowerCase().includes(searchText)
      });
    } else {
      this.countries = this._countries;
    }
  }

  onFilterCountries(event: any) {
    this.filterCountries(event.target.value.toLowerCase().trim());
  }
}

interface Country {
  code: string;
  name: string;
}
