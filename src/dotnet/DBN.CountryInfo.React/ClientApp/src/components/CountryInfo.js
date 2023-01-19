import React, { Component } from 'react';

export class CountryInfo extends Component {
    static displayName = CountryInfo.name;

    constructor(props) {
        super(props);
        this.state = { countries: [], search: '', loading: true };
    }

    componentDidMount() {
        this.populateCountryInfo('');
    }

    static renderCountriesTable(countries) {
        return (
            <table className="table table-striped" aria-labelledby="tableLabel">
                <thead>
                    <tr>
                        <th>Code</th>
                        <th>Name</th>
                        <th>Flag</th>
                    </tr>
                </thead>
                <tbody>
                    {countries.map(country =>
                        <tr key={country.code}>
                            <td>{country.code}</td>
                            <td>{country.name}</td>
                            <td><img src={`countryinfo/${country.code}/flag`} width="80" height="40" /></td>
                        </tr>
                    )}
                </tbody>
            </table>
        );
    }

    render() {
        let contents = this.state.loading
            ? <p><em>Loading...</em></p>
            : CountryInfo.renderCountriesTable(this.state.countries);

        return (
            <div>
                Filter Countries:
                <input type="text"
                    value={this.state.search}
                    onChange={this.handleSearch.bind(this)}
                    placeholder="" />
                
                {contents}
            </div>
        );
    }

    handleSearch(e) {
        this.setState({ search: e.target.value })
        this.populateCountryInfo(e.target.value)
    }


    async populateCountryInfo(search) {
        let url = 'countryinfo'
        if (!(search === '')) {
            url += '?search=' + search
        }

        const response = await fetch(url);
        const data = await response.json();
        this.setState({ countries: data, loading: false });
    }
}
