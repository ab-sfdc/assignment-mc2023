public class CountryDataUpdater {
    //private static final string RESPONSE_EG = '[ { "name": "Afghanistan", "topLevelDomain": [ ".af" ], "alpha2Code": "AF", "alpha3Code": "AFG", "callingCodes": [ "93" ], "capital": "Kabul", "altSpellings": [ "AF", "Afġānistān" ], "region": "Asia", "subregion": "Southern Asia", "population": 27657145, "latlng": [ 33, 65 ], "demonym": "Afghan", "area": 652230, "gini": 27.8, "timezones": [ "UTC+04:30" ], "borders": [ "IRN", "PAK", "TKM", "UZB", "TJK", "CHN" ], "nativeName": "افغانستان", "numericCode": "004", "currencies": [ { "code": "AFN", "name": "Afghan afghani", "symbol": "؋" } ], "languages": [ { "iso639_1": "ps", "iso639_2": "pus", "name": "Pashto", "nativeName": "پښتو" }, { "iso639_1": "uz", "iso639_2": "uzb", "name": "Uzbek", "nativeName": "Oʻzbek" }, { "iso639_1": "tk", "iso639_2": "tuk", "name": "Turkmen", "nativeName": "Türkmen" } ], "translations": { "br": "Afeganistão", "de": "Afghanistan", "es": "Afganistán", "fa": "افغانستان", "fr": "Afghanistan", "hr": "Afganistan", "it": "Afghanistan", "ja": "アフガニスタン", "nl": "Afghanistan", "pt": "Afeganistão" }, "flag": "https://restcountries.eu/data/afg.svg", "regionalBlocs": [ { "acronym": "SAARC", "name": "South Asian Association for Regional Cooperation" } ], "cioc": "AFG" }]';
    public static void updateCountryData() {
		HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:countryLayer');
        request.setMethod('GET');
        HttpResponse response = new Http().send(request);
        if (response.getStatusCode() == 200) {
            List<CountryApiResponse> countryDataList = (List<CountryApiResponse>) 
                JSON.deserialize(response.getBody(), List<CountryApiResponse>.class);  
            List<Country__c> countriesToUpdate = new List<Country__c>();
            for (CountryApiResponse countryData : countryDataList) {
                Country__c countryRecord = new Country__c();
                countryRecord.Alpha2Code__c = countryData.alpha2Code;
                countryRecord.Alpha3Code__c = countryData.alpha3Code;
                countryRecord.Name = countryData.name;
                countryRecord.Capital_City__c = countryData.capital;
                countryRecord.Region__c = countryData.region;
                List<String> regionalBlocAcronyms = new List<String>();

                for (Map<String, String> bloc : countryData.regionalBlocs) {
                    regionalBlocAcronyms.add(bloc.get('acronym'));
                }
                countryRecord.regionalBlocs__c = String.join(regionalBlocAcronyms, ',');                
                countriesToUpdate.add(countryRecord);
            }

            List<Database.UpsertResult> upsertResults = 
                Database.upsert(countriesToUpdate, Country__c.Alpha2Code__c, false);            
            for (Database.UpsertResult result : upsertResults) {
                if (!result.isSuccess()) {
                    for (Database.Error error : result.getErrors()) {
                        System.debug('Error upserting record ID ' + result.getId() + ': ' + 
                                     error.getStatusCode() + ' - ' + error.getMessage());
                        // Handle the error as needed
                    }
                }
            }
        }
    }
}