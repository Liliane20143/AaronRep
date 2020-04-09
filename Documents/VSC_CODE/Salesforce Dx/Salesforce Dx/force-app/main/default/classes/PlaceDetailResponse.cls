/*
* @author TBD
* @date TBD
* @group TBD
* @description 
*/
public class PlaceDetailResponse {
    
    public List<String> html_attributions;
    public Result result;
    public String Status;
    
    /*
    * @author TBD
    * @date TBD
    * @group TBD
    * @description 
    */
    public class Result{
        public List<address_component> address_components;
        public String formatted_address;
        public  String formatted_phone_number;
        public String adr_address;
        public  Geometry geometry;
        public String istatCode;
    }
    
    /*
    * @author TBD
    * @date TBD
    * @group TBD
    * @description 
    */
    public class Geometry{
        public         Location location;
        public   Viewport viewport;
    }
    
    /*
    * @author TBD
    * @date TBD
    * @group TBD
    * @description 
    */
    public class Location{
        public   Decimal lat;
        public   Decimal lng;
    }
    
    /*
    * @author TBD
    * @date TBD
    * @group TBD
    * @description 
    */
    public class Viewport{
        public   Northeast northeast;
        public   Southwest southwest;
    }
    
    /*
    * @author TBD
    * @date TBD
    * @group TBD
    * @description 
    */
    public class Northeast{
        public   Decimal lat;
        public    Decimal lng;
    }
    
    /*
    * @author TBD
    * @date TBD
    * @group TBD
    * @description 
    */
    public class Southwest{
        public    Decimal lat;
        public   Decimal lng;
    }
    
    /*
    * @author TBD
    * @date TBD
    * @group TBD
    * @description 
    */
    public class address_component {
        public String long_name;
        public String short_name;
        public String[] types;
    }
    
    /*
    * @description TBD
    * @param TBD
    * @return TBD
    */
    public static PlaceDetailResponse parse(String json) {
        return (PlaceDetailResponse) System.JSON.deserialize(json, PlaceDetailResponse.class);
    }
}