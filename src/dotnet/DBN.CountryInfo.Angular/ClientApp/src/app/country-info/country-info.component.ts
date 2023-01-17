import { Component, Inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'app-country-info',
  templateUrl: './country-info.component.html',
})
export class CountryInfoComponent {
  public countries: Country[] = [];

  constructor(http: HttpClient, @Inject('BASE_URL') baseUrl: string) {
    http.get<Country[]>(baseUrl + 'countryinfo').subscribe(result => {
      this.countries = result;
    }, error => console.error(error));
  }
}

interface Country {
  code: string;
  name: string;
}
