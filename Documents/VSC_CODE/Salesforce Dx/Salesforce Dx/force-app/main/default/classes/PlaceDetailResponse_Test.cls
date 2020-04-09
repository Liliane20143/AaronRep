/*****************************************************************
Name: PlaceDetailResponse_Test
Copyright © 2016 ITC
============================================================
Purpose:  Class tests PlaceDetailResponse method
History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0         Natalia Nawrocka        17/06/2019      Created             ---
********************************************************************************/

@isTest
public with sharing class PlaceDetailResponse_Test {

    /*******************************************************************************
   Purpose:  Method tests PlaceDetailResponse.parse, checks
             if object of PlaceDetailResponse type parsed from String is the same
             as given object of the same type by comparing 2 Strings created
             with JSON.serialize method
   Parameters: -
   Returns: -
   History
   --------
   VERSION     AUTHOR                  DATE            DETAIL          Description
   1.0      Natalia Nawrocka        17/06/2019         Created             ---
   ********************************************************************************/
    @isTest
    public static void parseTest() {
        PlaceDetailResponse.address_component addressComponent = new PlaceDetailResponse.address_component();
        addressComponent.long_name = 'longName';
        addressComponent.short_name = 'shortName';

        PlaceDetailResponse.Location location = new PlaceDetailResponse.Location();
        location.lat = -36.848461;
        location.lng = 174.763336;

        PlaceDetailResponse.Geometry geometry = new PlaceDetailResponse.Geometry();
        geometry.location = location;

        PlaceDetailResponse.Result placeDetailResponseResult = new PlaceDetailResponse.Result();
        placeDetailResponseResult.address_components = new List<PlaceDetailResponse.address_component>();
        placeDetailResponseResult.address_components.add(addressComponent);
        placeDetailResponseResult.formatted_address = '2 Hapua St, Remuera, Auckland 1050, New Zealand';
        placeDetailResponseResult.geometry = geometry;

        PlaceDetailResponse expected = new PlaceDetailResponse();
        expected.result = placeDetailResponseResult;
        expected.Status = 'some status';

        String toCheck = JSON.serialize(expected);

        PlaceDetailResponse result = (PlaceDetailResponse) PlaceDetailResponse.parse(toCheck);

        System.assertEquals(toCheck, JSON.serialize(result));
    }

}