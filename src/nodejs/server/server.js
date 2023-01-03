'use strict';

const fs = require('fs')
const express = require('express');

const PORT = 8080;
const HOST = '0.0.0.0';
const app = express();

function parseCountries() {
    let rawdata = fs.readFileSync('data/countries.json');
    let countries = JSON.parse(rawdata);
    console.log(countries);

    return countries;
}

function getCountry(name) {
    let countries = parseCountries();

    name = name.toLowerCase();
    let filtered = countries.filter(item =>
        item.Codes.Cca2.toLowerCase() === name ||
        item.Codes.Cca3.toLowerCase() === name ||
        (item.Names.Name.Common ? item.Names.Name.Common : '').toLowerCase() === name ||
        item.Names.Name.Common.toLowerCase() === name ||
        item.Names.Name.Official.toLowerCase() === name
    );

    return (filtered.length === 0 ? null : filtered[0])
}

app.listen(PORT, HOST, () => {
    console.log(`Running on http://${HOST}:${PORT}`);
});

app.get('/countries', (req, res) => {
    let countries = parseCountries();
    if (countries == null) {
        console.error("null");
    }

    let result = {};
    countries.forEach(country => {
        result[country.Codes.Cca2] = country.Names.Name.Common
    });

    res.json(result);
});

app.get('/countries/:name', (req, res) => {
    let country = getCountry(req.params.name.toLowerCase());

    if (country == null) {
        res.status(404).send('country not found');
        return;
    }

    res.send(JSON.stringify(country));
});

app.get('/countries/:name/flag', (req, res) => {
    let country = getCountry(req.params.name.toLowerCase());
    if (country == null) {
        res.status(404).send('country not found');
        return;
    }

    let format = req.params.format === "svg" ? "svg" : "png";
    res.download(`data/flags/${country.Codes.Cca2}.${format}`);
});

app.get('/countries/flags/:name', (req, res) => {
    let country = getCountry(req.params.name.toLowerCase());
    if (country == null) {
        res.status(404).send('country not found');
        return;
    }

    let format = req.params.format === "svg" ? "svg" : "png";
    res.download(`data/flags/${country.Codes.Cca2}.${format}`);
});