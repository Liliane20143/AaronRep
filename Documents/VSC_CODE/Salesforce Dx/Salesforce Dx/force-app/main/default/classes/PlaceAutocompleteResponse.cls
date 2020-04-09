/*
* @author TBD
* @date TBD
* @group TBD
* @description 
*/
public class PlaceAutocompleteResponse {
    
    /*
    * @author TBD
    * @date TBD
    * @group TBD
    * @description TBD
    */
    public class Matched_substrings {
        public Integer length;
        public Integer offset;
    }
    
    public String status;
    public List<Predictions> predictions;
    
	/*
    * @author TBD
    * @date TBD
    * @group TBD
    * @description TBD
    */    
    public class Predictions {
        public String description;
        public String id;
        public List<Matched_substrings> matched_substrings;
        public String place_id;
        public String reference;
        public List<Terms> terms;
        public List<String> types;
    }
    
    /*
    * @author TBD
    * @date TBD
    * @group TBD
    * @description TBD
    */
    public class Terms {
        public Integer offset;
        public String value;
    }
    
    /*
    * @description TBD
    * @param TBD
    * @return TBD
    */
    public static PlaceAutocompleteResponse parse(String json) {
        return (PlaceAutocompleteResponse) System.JSON.deserialize(json, PlaceAutocompleteResponse.class);
    }
}