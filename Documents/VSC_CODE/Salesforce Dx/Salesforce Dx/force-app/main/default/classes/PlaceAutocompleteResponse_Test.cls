/*****************************************************************
Name: PlaceAutocompleteResponse_Test
Copyright © 2016 ITC
============================================================
Purpose:  Class tests PlaceAutocompleteResponse method
History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0         Natalia Nawrocka        17/06/2019      Created             ---
********************************************************************************/

@isTest
public with sharing class PlaceAutocompleteResponse_Test {

    /*******************************************************************************
       Purpose:  Method tests PlaceAutocompleteResponse.parse, checks
                 if object of PlaceAutocompleteResponse type parsed from String is the same
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
        PlaceAutocompleteResponse.Matched_substrings matchedSubstrings = new PlaceAutocompleteResponse.Matched_substrings();
        matchedSubstrings.length = 5;
        matchedSubstrings.offset = 5;

        PlaceAutocompleteResponse.Terms term = new PlaceAutocompleteResponse.Terms();
        term.value = 'termValue';
        term.offset = 3;

        PlaceAutocompleteResponse.Predictions prediction = new PlaceAutocompleteResponse.Predictions();
        prediction.description = 'descr';
        prediction.id = 'id';
        prediction.matched_substrings = new List<PlaceAutocompleteResponse.Matched_substrings>();
        prediction.matched_substrings.add(matchedSubstrings);
        prediction.place_id = 'placeId';
        prediction.reference = 'ref';
        prediction.terms = new List<PlaceAutocompleteResponse.Terms>();
        prediction.terms.add(term);
        prediction.types = new List<String>();
        prediction.types.add('typeOne');

        PlaceAutocompleteResponse expected = new PlaceAutocompleteResponse();
        expected.status = 'status';
        expected.predictions = new List<PlaceAutocompleteResponse.Predictions>();
        expected.predictions.add(prediction);

        String toCheck = JSON.serialize(expected);

        PlaceAutocompleteResponse result = (PlaceAutocompleteResponse) PlaceAutocompleteResponse.parse(toCheck);

        System.assertEquals(toCheck, JSON.serialize(result));

    }
}