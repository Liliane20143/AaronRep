public class GoogleMapsAutoCompleteAPI {

    // Google Maps API Place Autocomplete
    // Documentation: https://developers.google.com/places/web-service/autocomplete

    public PlaceDetailResponse getPlaceDetail(String input){
           String url = 'https://maps.googleapis.com/maps/api/place/details/json?placeid='
            +  input
            + '&key=' + getAPIKey();
	    PlaceDetailResponse placeDetail = (PlaceDetailResponse) JSON.deserialize( makeAPICall(url), PlaceDetailResponse.class);
        System.debug('URL-->' + url);
        System.debug('placeDetail-->' + placeDetail);
        return placeDetail;
    }
    
    
    public PlaceAutocompleteResponse getAutoComplete(String input, String types, String components) {
        return getAutoComplete(input, types, components, getAPIKey());
    }
    
    public PlaceAutocompleteResponse getAutoComplete(String input, String types, String components, String apiKey) {
        String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input='
            + EncodingUtil.urlEncode(input, 'UTF-8')
            + '&components=country:it'// + components // country:uk'
            + '&libraries=places'
            + '&key=' + apiKey;

        return PlaceAutocompleteResponse.parse(makeAPICall(url));
    }

    private string makeAPICall(string url) {

        Http http = new Http();
        HttpRequest httpRequest = new HttpRequest();
        HttpResponse httpResponse = new HttpResponse();
        httpRequest.setMethod('GET');
        httpRequest.setEndpoint(url);
        httpRequest.setTimeout(120000);
        httpResponse = http.send(httpRequest); 

        if (httpResponse.getStatusCode() == 200){
            return httpResponse.getBody();    
        } else {
            System.debug(httpResponse.getStatusCode());
            System.debug(httpResponse.getBody());
            throw new AuraHandledException(httpResponse.getBody());
        } 
    }

    public string getAPIKey() {
        return 'AIzaSyCbeYekdr0w9ZiimTRGC_rBcTBShNKKalI'; // add api key or get from custom settings
    }
}