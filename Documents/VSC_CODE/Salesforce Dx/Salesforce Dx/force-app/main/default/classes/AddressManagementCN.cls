/*
* @author Alessio De Castro
* @date 07 May 2018
* @group CONTROLLER
* @description Address Management Controller
*/
public without sharing class AddressManagementCN {
    
    // Extending the virtual Service Request and Response to make them suitable for this class
//    public class Request extends ServiceRequest {}
//    public class Response extends ServiceResponse {}
    
    // Constants
    private static final String APARTMENT_FLOOR = 'ApartmentFloor__c';
    private static final String APARTMENT_NUMBER = 'ApartmentNumber__c';
    private static final String BUILDING = 'Building__c';
    private static final String CITY = 'City__c';
    private static final String COUNRTY = 'Country__c';
    private static final String EXTERNAL_CODE = 'ExternalCode__c';
    private static final String GEO_LOCATION = 'GeoLocation__c';
    private static final String IS_NORMALIZED = 'IsNormalized__c';
    private static final String NOTES = 'Notes__c';
    private static final String PROVINCE = 'Province__c';
    private static final String REGION = 'Region__c';
    private static final String STAIR = 'Stair__c';
    private static final String STREET_NAME = 'StreetName__c';
    private static final String STREET_NUMBER = 'StreetNumber__c';
    private static final String TOPONYMY = 'Toponymy__c';
    private static final String ZIP_CODE = 'ZipCode__c';
    
//    /*
//    * @description Util method to upsert Address Objects
//    * @param required a Request (Map<String, Map<String, Object>>). The inner map must with data object structure.
//    * @return return a Response (Map<String, Map<String, Object>>). The inner map will be enriched with Status and Message.
//    */
//    public static Response upsertAddress(Request req) {
//        Response resp = new Response();
//        try {
//            for (String reqKey : req.parameters.keySet()) {
//                //Get the request details map containing all the info
//                Map<String, Object> reqDetails = req.parameters.get(reqKey);
//                //Instance the response detail map cloning the request and instancing the further details
//                Map<String, Object> respDetails = reqDetails;
//                Boolean toUpsert = true;
//                String messageKo = '';
//                try {
//                    //GUID VALIDATION
//                    if(reqDetails.containsKey(EXTERNAL_CODE)
//                       && String.isNotEmpty(String.valueOf(reqDetails.get(EXTERNAL_CODE)))
//                       && !UtlGuid.validateGuid(String.valueOf(reqDetails.get(EXTERNAL_CODE)))){
//                           toUpsert = false;
//                           messageKo += EXTERNAL_CODE + ': GUID FORMAT NOT VALID - ';
//                       }
//                    //OTHER LOGIC TBD
//                    if(!toUpsert){
//                        req.parameters.remove(reqKey); //remove the structure from the request to avoid the upsert on DB
//                        respDetails.put('Status', 'KO');
//                        respDetails.put('Message', messageKo);
//                    }
//                }
//                catch (Exception e) {
//                    respDetails.put('Status', 'EXCEPTION');
//                    respDetails.put('Message', 'ERROR: ' + e.getMessage() + ' AT LINE ' +e.getLineNumber());
//                    System.debug(logginglevel.ERROR, 'upsertAddress: ' + e.getMessage() + ' AT LINE ' +e.getLineNumber());
//                }
//                //put the response copied from the request with further details about validation
//                resp.parameters.put(reqKey, respDetails);
//            }
//
//            //perform the upsert operation
//            UtilityDB.upsertObjectUI(req, resp);
//        }
//        catch (Exception e) {
//            System.debug(logginglevel.ERROR, 'upsertAddress: ' + e.getMessage() + ' AT LINE ' +e.getLineNumber());
//        }
//
//        return resp;
//    }
//
//    /**
//    * @description: Retrive information about Province, Region, Zone and Country from CityRegistry__c table starting by city.
//    * @param: cityNames The cities for which you want to get information
//    * @return: Map containing information about the cities in input.
//    */
//    public static Map<String, CityRegistry__c> retrieveCityRegistries(Set<String> cityNames) {
//        if(!cityNames.isEmpty()) {
//            Set<String> cityNamesUpc = new Set<String>();
//            for(String city : cityNames) {
//                cityNamesUpc.add(city.toUppercase());
//            }
//            if (!Schema.sObjectType.CityRegistry__c.isAccessible()){
//                throw new UtlCRUDException('##### AddressManagementCN.retrieveCityRegistries ERROR - Insufficient permission on object');
//            }
//            List<CityRegistry__c> crList = [SELECT CityName__c, ProvinceName__c, ProvinceShort__c, RegionName__c, ZoneName__c
//                                            FROM CityRegistry__c
//                                            WHERE CityName__c IN :cityNamesUpc];
//            System.debug('crList : '+ crList);
//
//            if (crList != null && crList.size() > 0) {
//                Map<String, CityRegistry__c> crMap = new Map<String, CityRegistry__c>();
//                for(CityRegistry__c crItem: crList) {
//                    crMap.put(crItem.CityName__c, crItem);
//                }
//                System.debug('crMap : '+ crMap);
//                return crMap;
//            }
//            return null;
//        }
//        return null;
//    }
//
//    /**
//    * @description: method for UI call: Retrive information about Province, Region, Zone and Country from CityRegistry__c table starting by city.
//    * @param: adrCity The city for which you want to get information
//    * @return: A JSON that contains information about the city.
//    */
//    @AuraEnabled
//    public static String retrieveCityRegistry(String adrCity) {
//        if(adrCity != null && (adrCity.equals('') != true)) {
//            Set<String> cityNames = new Set<String>();
//            cityNames.add(adrCity.toUppercase());
//            Map<String, CityRegistry__c> crMap = retrieveCityRegistries(cityNames);
//            if(!crMap.isEmpty()) {
//                System.debug('crMap.get(' + adrCity.toUppercase() + ') = ' + JSON.serialize(crMap.get(adrCity.toUppercase())));
//                return JSON.serialize(crMap.get(adrCity.toUppercase()));
//            }
//        }
//        return null;
//    }
    
    /*
    * @description: Public method that invoke Google Map's Api for Auto complete address.
    * @param: input The address street name
    * @param: types The address region
    * @return: Response(JSON) A valid address
    */
    @AuraEnabled
    public static string getAddressAutoComplete(String input, String types) {
        GoogleMapsAutoCompleteAPI api = new GoogleMapsAutoCompleteAPI();
        PlaceAutocompleteResponse response = api.getAutoComplete(input, types, null);
        System.debug('AddressManagementCN.getAddressAutoComplete -->' + response);
        return System.JSON.serialize(response);
    }
    
    /*
    * @description: Fill in the correct field on the address form.
    * @param: input Response(JSON) a valid address result of getAddressAutocomplete() invocation
    * @return: Response(JSON) with the correct fields to be inserted in the address form.
    */
    @AuraEnabled
    public static string getPlaceDetail(String input) {
        GoogleMapsAutoCompleteAPI api = new GoogleMapsAutoCompleteAPI();
        PlaceDetailResponse response = api.getPlaceDetail(input);
        System.debug('AddressManagementCN.getPlaceDetail-->' + response);
        return System.JSON.serialize(response);
    }
    
}