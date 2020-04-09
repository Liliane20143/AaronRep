public without sharing class AutoCompleteComponentController
{

    @AuraEnabled
    public static Map<String, String> getResult( String response, String field )
    {
        system.debug( 'here i am' );
        Map<String, String> result = OB_CallService.getService( field, response );
        System.debug( 'mappa delle province' + result );
        return result;
    }

    @AuraEnabled
    public static List<String> getCaps( String street, String keyCity )
    {
        List<String> capsList = new List<String>( );
        Dom.Document doc = new Dom.Document( );

        String url = 'callout:OB_Postel_Autocomplete/strade?in=' + street + '&loc=' + keyCity;
        system.debug( 'url' + url );
        HttpResponse response = new HttpResponse( );
        if ( !Test.isRunningTest( ) ){ response = OB_UtilityCallingServices.callServiceUtil( url, 'GET' );}
        else
        {
            response.setBody( '<response><errorMessage/><indexSize>1937</indexSize><originalInput>col</originalInput><match>false</match><time>0</time><format>STRADA</format><strada flagMulticap="false"><value>VIA COLBRICON</value><idfrazione>0</idfrazione><label/><key>69948637</key><listaCap><cap>37126</cap></listaCap></strada></response>' );
        }
        system.debug( 'response.getBody()' + response.getBody( ) );
        doc.load( response.getBody( ) );
        Dom.XmlNode rootNode = doc.getRootElement( );
        for ( Dom.XMLNode child : rootNode.getChildren( ) )
        {
            if ( child.getChildElement( 'value', null ) != null && ( child.getChildElement( 'value', null ).getText( ) ).equalsIgnoreCase( street.replaceAll( '%20', ' ' ) ) )
            {
                if ( child.getChildElement( 'listaCap', null ) != null )
                {
                    Dom.XmlNode caps = child.getChildElement( 'listaCap', null );
                    for ( Dom.XMLNode childish : caps.getChildren( ) )
                    {
                        capsList.add( childish.getText( ) );
                    }
                }
            }
        }
        return capsList;
    }


    @AuraEnabled
    public static Map<String, String> getProvince( )
    {
        system.debug( 'in apexClass getProvince' );
        OB_ProvinceService provService = new OB_ProvinceService( );
        Map<String, String> province = new Map<String, String>( );
        Dom.Document doc = new Dom.Document( );
        String url = 'callout:OB_Postel_Autocomplete/province';
        system.debug( 'url: ' + url );
        HttpResponse response = new HttpResponse( );
        if ( !Test.isRunningTest( ) )
        {
            response = OB_UtilityCallingServices.callServiceUtil( url, 'GET' );
        }
        else
        {
            response.setBody( '<response><provincia><nome>MILANO</nome><id>123</id><sigla>MI</sigla></provincia></response>' );
            System.debug( 'response.getBody(): ' + response.getBody( ) );
        }
        province = provService.callService( response.getBody( ) );
        return province;
    }

    @AuraEnabled
    public static Map<String, String> getCities( String input, String idField )
    {
        system.debug( 'in apexClass getCities' );
        OB_ComuneService comuneService = new OB_ComuneService( );
        Map<String, String> comune = new Map<String, String>( );
        Dom.Document doc = new Dom.Document( );
        String url = 'callout:OB_Postel_Autocomplete/comuni?in=' + input + '&prov=' + idField;
        system.debug( 'url: ' + url );
        HttpResponse response = new HttpResponse( );
        if ( !Test.isRunningTest( ) )
        {
            response = OB_UtilityCallingServices.callServiceUtil( url, 'GET' );
        }
        else
        {
            response.setBody( '<response><comune><key>123</key><value>MILANO</value></comune></response>' );
            system.debug( 'response.getBody(): ' + response.getBody( ) );
        }
        comune = comuneService.callService( response.getBody( ) );
        return comune;
    }

    @AuraEnabled
    public static Map<String, String> getDistrict( String input, String idField )
    {
        system.debug( 'in apexClass getDistrict' );
        OB_DistrictService districtService = new OB_DistrictService( );
        Map<String, String> district = new Map<String, String>( );
        Dom.Document doc = new Dom.Document( );
        String url = 'callout:OB_Postel_Autocomplete/frazioni?in=' + input + '&com=' + idField;
        system.debug( 'url: ' + url );
        HttpResponse response = new HttpResponse( );
        if ( !Test.isRunningTest( ) )
        {
            response = OB_UtilityCallingServices.callServiceUtil( url, 'GET' );
        }
        else
        {
            response.setBody( '<response><district><key>123</key><value>MYDISTRICT</value></district></response>' );
            system.debug( 'response.getBody(): ' + response.getBody( ) );
        }
        district = districtService.callService( response.getBody( ) );
        return district;
    }

    @AuraEnabled
    public static Map<String, String> getStreet( String input, String idField )
    {
        system.debug( 'in apexClass getStreet' );
        OB_StradaService streetService = new OB_StradaService( );
        Map<String, String> street = new Map<String, String>( );
        Dom.Document doc = new Dom.Document( );
        String url = 'callout:OB_Postel_Autocomplete/strade?in=' + input + '&loc=' + idField;
        system.debug( 'url: ' + url );
        HttpResponse response = new HttpResponse( );
        if ( !Test.isRunningTest( ) )
        {
            response = OB_UtilityCallingServices.callServiceUtil( url, 'GET' );
        }
        else
        {
            response.setBody( '<response><street><key>123</key><value>VIA%20LEPETIT</value></street></response>' );
            system.debug( 'response.getBody(): ' + response.getBody( ) );
        }
        street = streetService.callService( response.getBody( ) );
        return street;
    }

    @AuraEnabled
    public static String getCadastrialCode( String url )
    {
        HttpRequest req = new HttpRequest( );
        req.setEndpoint( url );
        req.setMethod( 'GET' );
        String token = OB_UtilityCallingServices.checkToken( );
        req.setHeader( OB_UtilityConstants.AUTH, OB_UtilityConstants.PREFIX + token );
        req.setHeader( 'Content-Type', 'application/json' );
        System.debug( 'Request to service contract: ' + req );
        Http http = new Http( );
        HTTPResponse res = http.send( req );
        System.debug( 'Response body: ' + res.getBody( ) );

        String bodyWithoutSquareBrackets = res.getBody( ).subString( 1, res.getBody( ).length( ) - 1 );
        Map<String, Object> serializeResponseOne = ( Map<String, Object> ) JSON.deserializeUntyped( bodyWithoutSquareBrackets );
        String candidates = JSON.serialize( serializeResponseOne.get( 'Candidati' ) );
        List<Object> candidatesList = ( List< Object> ) JSON.deserializeUntyped( candidates );
        String candidateOne = JSON.serialize( candidatesList[ 0 ] );
        Map<String, Object> serilaizeCandidateOne = ( Map<String, Object> ) JSON.deserializeUntyped( candidateOne );
        String enrichedInfo = JSON.serialize( serilaizeCandidateOne.get( 'Arricchito' ) );
        Map<String, Object> serializeEnrichedInfo = ( Map<String, Object> ) JSON.deserializeUntyped( enrichedInfo );
        system.debug( serializeEnrichedInfo.get( 'CodCF' ) );
        return String.valueOF( serializeEnrichedInfo.get( 'CodCF' ) );
    }
}