@isTest
public class TestCountryDataUpdater {

    // Create a mock HTTP response
    public class MockHttpResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('[{ "name": "Afghanistan", "topLevelDomain": [ ".af" ], "alpha2Code": "AF", "alpha3Code": "AFG", "callingCodes": [ "93" ], "capital": "Kabul", "altSpellings": [ "AF", "Afġānistān" ], "region": "Asia", "subregion": "Southern Asia", "population": 27657145, "latlng": [ 33, 65 ], "demonym": "Afghan", "area": 652230, "gini": 27.8, "timezones": [ "UTC+04:30" ], "borders": [ "IRN", "PAK", "TKM", "UZB", "TJK", "CHN" ], "nativeName": "افغانستان", "numericCode": "004", "currencies": [ { "code": "AFN", "name": "Afghan afghani", "symbol": "؋" } ], "languages": [ { "iso639_1": "ps", "iso639_2": "pus", "name": "Pashto", "nativeName": "پښتو" }, { "iso639_1": "uz", "iso639_2": "uzb", "name": "Uzbek", "nativeName": "Oʻzbek" }, { "iso639_1": "tk", "iso639_2": "tuk", "name": "Turkmen", "nativeName": "Türkmen" } ], "translations": { "br": "Afeganistão", "de": "Afghanistan", "es": "Afganistán", "fa": "افغانستان", "fr": "Afghanistan", "hr": "Afganistan", "it": "Afghanistan", "ja": "アフガニスタン", "nl": "Afghanistan", "pt": "Afeganistão" }, "flag": "https://restcountries.eu/data/afg.svg", "regionalBlocs": [ { "acronym": "SAARC", "name": "South Asian Association for Regional Cooperation" } ], "cioc": "AFG" }]');
            res.setStatusCode(200);
            return res;
        }
    }

    @isTest
    static void testUpdateCountryData() {
        // Set the mock HTTP callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());

        // Call the method to be tested
        Test.startTest();
        CountryDataUpdater.updateCountryData();
        Test.stopTest();

        // Verify the results
        List<Country__c> countries = [SELECT Alpha2Code__c, Name, Capital_City__c, Region__c, regionalBlocs__c FROM Country__c];
        System.assertEquals(1, countries.size());

        Country__c country = countries[0];
        System.assertEquals('AF', country.Alpha2Code__c);
        System.assertEquals('Afghanistan', country.Name);
        System.assertEquals('Kabul', country.Capital_City__c);
        System.assertEquals('Asia', country.Region__c);
        System.assertEquals('SAARC', country.regionalBlocs__c);
    }
}