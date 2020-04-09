global without sharing class OB_UtilityCallingServices {

    global static Long timestamp {get;set;}

    global static Boolean isNew = false;

    global static String tokenGlobalVar {get;set;}

    global String rs {get;set;}

    // 06/09/18 - SALVATORE P. -  START METHOD TO CONVERTING &#39; IN '
    global static String getUnescape(String s1)
    {
        String s2 = s1.unescapeHtml3();
        return s2;
    }
    //06/09/18 - SALVATORE P. - END METHOD TO CONVERTING &#39; IN '

    //  START   micol.ferrari 17/01/2019 - METHOD THAT GET THE CURRENT ORG FROM A CUSTOM SETTING
    global static String returnCurrentOrg()
    {
        String toReturn = null;
        OB_EnvironmentConfiguration__c environmentConfiguration = OB_EnvironmentConfiguration__c.getValues(System.Label.OB_EnvironmentConfiguration);
        toReturn = environmentConfiguration.OB_CurrentOrg__c;
        return toReturn;
    }
    //  END     micol.ferrari 17/01/2019 - METHOD THAT GET THE CURRENT ORG FROM A CUSTOM SETTING

    /*
    Method: getToken
    Call service https://intapi.nexi.it/oauth/v2/token to get token needed to access MIP services
    */
    @AuraEnabled
    global static Map<String,String> getToken(){

        //  START   micol.ferrari 17/01/2019 - GET CURRENT ORG NAME
        //String environment = !Test.isRunningTest() ? system.Label.OB_Environment : 'DEV1';
        String environment = !Test.isRunningTest() ? OB_UtilityCallingServices.returnCurrentOrg() : 'DEV1';
        //  END     micol.ferrari 17/01/2019 - GET CURRENT ORG NAME

        OB_Integration_Configuration__c intConfig = OB_Integration_Configuration__c.getValues(environment);

        String body  ='';
        String token = '';
        //create body info from custom settings
        String firstParam = OB_UtilityConstants.FIRST_PARAM+'='+intConfig.OB_Grant_Type__c;
        String secondParam = OB_UtilityConstants.SECOND_PARAM+'='+intConfig.OB_Client_ID__c;
        String thirdParam = OB_UtilityConstants.THIRD_PARAM+'='+intConfig.OB_Client_Secret__c;
        System.debug('firstParam: '+firstParam+ ', secondParam: '+secondParam+ ', thirdParam: '+thirdParam);
        body = firstParam+'&'+secondParam+'&'+thirdParam;
        Map<String,String> infoToPass = new Map<String,String>();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(OB_UtilityConstants.NAMED_CREDENTIAL_TOKEN);
        req.setMethod(OB_UtilityConstants.METHOD_POST);
        req.setBody(body);
        if(intConfig.OB_CAsigned_name__c!=null){
            req.setClientCertificateName(intConfig.OB_CAsigned_name__c);
        }
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug('Response body: '+res.getBody());
        //Map into which token is saved in label Token and  expiration time
        Map<String, Object> deserializedJSON = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
        system.debug('deserializedJSON: ' + deserializedJSON.values());

        token = String.valueOf(deserializedJSON.get('access_token'));
        tokenGlobalVar = token ;
        String errorMessageCode =  String.valueOf(deserializedJSON.get('errcode'));
        String duration = String.valueOf(deserializedJSON.get('expires_in'));
        system.debug(token);
        system.debug(errorMessageCode);
        system.debug(duration);
        infoToPass.put('Token',token);
        infoToPass.put('Duration',duration);
        infoToPass.put('Error',errorMessageCode);
        return infoToPass;
    }
        /*
    Method: checkToken
    Verify the validity of the token. In case of expired token or it is going to expire within fine mins it makes
    a new cal to service, otherwise it gets the one saved in custom settings
    */
    @AuraEnabled
    global static String checkToken (){
        String token='';

        //  START   micol.ferrari 17/01/2019 - GET CURRENT ORG NAME
        //String environment = !Test.isRunningTest() ? system.Label.OB_Environment : 'DEV1';
        String environment = !Test.isRunningTest() ? OB_UtilityCallingServices.returnCurrentOrg() : 'DEV1';
        //  END     micol.ferrari 17/01/2019 - GET CURRENT ORG NAME

        OB_Integration_Configuration__c intConfig = OB_Integration_Configuration__c.getValues(environment);

        //timestamp when calling service to get token
        String y = JSON.serialize(intConfig);
        system.debug('intConfig: '+y);
        String timeNow = String.valueof(DateTime.now().getTime());
        String error = 'Error';
        system.debug('Token in Custom Settings null?: '+intConfig.OB_Token_1__c == null);
        system.debug('Time in Custom Settings null?: '+Long.valueOf(intConfig.OB_timestamp__c));
        //system.debug('Time is going to expire in Custom Settings?: '+ Long.valueOf(intConfig.OB_timestamp__c) - 300000);
        //for (OB_Integration_Configuration__c intConfig : intConfigs){
        if(intConfig.OB_Token_1__c == null ||  Long.valueOf(intConfig.OB_timestamp__c) - 300000 < Long.valueOf(timeNow)){
            System.debug('Token is going to expire ' + (Long.valueOf(intConfig.OB_timestamp__c) - 300000 < Long.valueOf(timeNow)) +  'or is null? ' + intConfig.OB_Token_1__c == null);
            Map<String,String> infoToken = new Map<String,String>();
            if(!Test.isRunningTest()){
                infoToken =  getToken();
                if(infoToken.get('Error')!=null){
                    system.debug(error);
                    return error;
                }
            } else {
                infoToken.put('Token','eyJ0eXAiOiJKV1QiLCJjdHkiOiJKV1QiLCJhbGciOiJkaXIiLCJlbmMiOiJBMTI4Q0JDLUhTMjU2In0..hxBlok5mj8kgmKAL2_vFvg.MoeN6WM19lzmTQjCWV7jvF86keiHCvl2BlYAPdp5dHCV5a4Iwsc5iISOhampRVi95u5uqGWwo1xd9DUxXvZHTyeS7BZsFzux9OCgEQP-Refq3hIDrdSezq48aiKlZSREj00DJApiu9mKbhdQ06yw4W0yiBdbEQxpCBFkt9BQMfmnFiazLbNMBhKxUPgJJWgiqIurZATVD9LUjWjwMb3dcFiykUn6KJ2jg_X5b6G5dbkm3CeElxlymCm8pBqopt34oXuSs0pMO8F4_0WKAFHoDYhewj2CsPwOBuB1MCx8WIEt56st2mgeFO0zNoce3Fh3sgTwE44N3RDBHsXW3uWUk71kmDDrV-ivmcWmoHJty3EneXh9imfspjkKyz-KJC2Sf9liKGaBW539dguIENajGS4feZcx30yn5vCn7H53FXydRyq2nDLCkJ0lyQWnKzEjEGLB5KxXsJiZzV5xYBY4aVvEQUQ_pufZ-lqE0NxT9WbL8CG69KvTSPiCPxOPL55cbsOuH9OHQGoyW7E3zzeHYm41ry5Z_pqVUYCoWuNzZ_RoqHU1FxthQ729ZAmBU9V6.q_SLSz3CYH8Tw95c0z2_nw');
                infoToken.put('Duration','3600');
            }
            System.debug('Response service to get a new token: '+infoToken);
            token = infoToken.get('Token');
            isNew = true;
            timestamp = Long.valueOf(timeNow) + Long.valueOf(infoToken.get('Duration'))*1000;
            System.debug('Is a new token? ' + isNew + 'Timestamp ms creation new Token' + timestamp);
        }else {
            timestamp = Long.valueOf(timeNow);
            System.debug('Token is valid');
            String s = JSON.serialize(intConfig);
            system.debug('intConfig: '+s);
            Map<String, Object> deserializedJSON = (Map<String, Object>)JSON.deserializeUntyped(s);
            Map<String,Object> mappa = new  Map<String,Object>();
            for(String key : deserializedJSON.keySet()){
                mappa.put(key.toUpperCase(),deserializedJSON.get(key));
            }
            system.debug('mappa OB_Integration_Configuration__c: '+mappa);
            Set<String> flds = OB_Integration_Configuration__c.sObjectType.getDescribe().fields.getMap().keySet();
            for(String t : flds){
            String upperCase = t.toUpperCase();
                for(integer i=1;i<10;i++){
                    if(upperCase.contains('OB_TOKEN_'+i)){
                        if(mappa.get(upperCase)!= null){
                           token += mappa.get(upperCase);
                           System.debug('Token: ' + i + ' is: ' + token);
                       }
                    }
                }
            }
        }
        System.debug('Token used for calling service: ' + token);
        tokenGlobalVar = token ;
        return token;
    }
    /*
    Method: saveToken
    Input Vars:
        - String currentToken: token used at the moment
        - String currentTime: time after which token is changed in custim settings
    Method to save a new token in custom settings
    */
    @AuraEnabled
    global static void saveToken (String currentToken, String currentTime){

        //  START   micol.ferrari 17/01/2019 - GET CURRENT ORG NAME
        //String environment = !Test.isRunningTest() ? system.Label.OB_Environment : 'DEV1';
        String environment = !Test.isRunningTest() ? OB_UtilityCallingServices.returnCurrentOrg() : 'DEV1';
        //  END     micol.ferrari 17/01/2019 - GET CURRENT ORG NAME

        OB_Integration_Configuration__c intConfig = OB_Integration_Configuration__c.getValues(environment);

        system.debug('currentTime: '+currentTime);
        system.debug('currentToken: '+currentToken);
        system.debug('timestamp: '+timestamp);
        //List<OB_Integration_Configuration__c> intConfigs = OB_Integration_Configuration__c.getall().values();
        //List<OB_Integration_Configuration__c> configToUpdate = new List<OB_Integration_Configuration__c>();
        //for (OB_Integration_Configuration__c intConfig : intConfigs){
        if(currentTime > intConfig.OB_timestamp__c){
            String s = JSON.serialize(intConfig);
            system.debug('intConfig: '+s);
            Map<String, Object> deserializedJSON = (Map<String, Object>)JSON.deserializeUntyped(s);
             system.debug(deserializedJSON);
            Map<String,Object> mappa = new  Map<String,Object>();
            Integer numberFields = (currentToken.length()/255)+1;
            List<String> utilListJson = new List<String>();
            system.debug('numberFields ' +numberFields);
            for(integer j = 1; j<=numberFields;j++){
                if(!deserializedJSON.keySet().contains('OB_Token_'+j)){
                    deserializedJSON.put('OB_Token_'+j+'__c','');
                    system.debug('deserializedJSON ' +deserializedJSON.get('OB_Token_'+j+'__c'));
                }
                utilListJson.add('OB_Token_'+j+'__c');
                system.debug('utilListJson '+ utilListJson);
            }
            for(String key : utilListJson){
                system.debug('key ' +key);
                for(integer i=1;i<=numberFields;i++){
                    String tokenPiece = '';
                    if(i*255<currentToken.length()){
                        tokenPiece = currentToken.substring((i-1)*255,i*255);
                    } else {
                        tokenPiece = currentToken.substring((i-1)*255,currentToken.length());
                    }
                    if(key.contains('OB_Token_'+i)){
                        system.debug('deserializedJSON key before ' +deserializedJSON.get(key));
                        deserializedJSON.remove(key);
                        system.debug('deserializedJSON before ' +deserializedJSON);
                        deserializedJSON.put(key,tokenPiece);
                        system.debug('deserializedJSON key after ' +deserializedJSON.get(key));
                    }else{
                         deserializedJSON.put('OB_Token_'+i+'__c',tokenPiece);
                        system.debug('deserializedJSON key after ' +deserializedJSON.get(key));
                    }
                }
            }
            if(deserializedJSON.get('OB_Timestamp__c')==null){
                deserializedJSON.put('OB_Timestamp__c',currentTime);
            } else {
                deserializedJSON.remove('OB_Timestamp__c');
                deserializedJSON.put('OB_Timestamp__c',currentTime);
            }
            String jsonstring = JSON.serialize(deserializedJSON);
            intConfig = (OB_Integration_Configuration__c) JSON.deserialize(jsonstring, Sobject.class);
        }
        //}
        system.debug('Custom setting to update: ' + intConfig);
        upsert intConfig;
    }


        @AuraEnabled
        global static String callServiceUtilAura(String url, String method){
            return JSON.serialize(OB_UtilityCallingServices.callServiceUtil(url,method));
        }


        global static HTTPResponse callServiceUtil(String url, String method){
            //  START   micol.ferrari 17/01/2019 - GET CURRENT ORG NAME
            //String environment = !Test.isRunningTest() ? system.Label.OB_Environment : 'DEV1';
            String environment = !Test.isRunningTest() ? OB_UtilityCallingServices.returnCurrentOrg() : 'DEV1';
            //  END     micol.ferrari 17/01/2019 - GET CURRENT ORG NAME

            OB_Integration_Configuration__c intConfig = OB_Integration_Configuration__c.getValues(environment);

            HttpRequest req = new HttpRequest();
            req.setEndpoint(url);
            req.setMethod(method);
            String token = checkToken();
            req.setHeader( OB_UtilityConstants.AUTH, OB_UtilityConstants.PREFIX+token);
            if(intConfig.OB_CAsigned_name__c!=null){
                req.setClientCertificateName(intConfig.OB_CAsigned_name__c);
            }
            System.debug('Request to service contract: ' + req);
            Http http = new Http();
            HTTPResponse res = http.send(req);
            System.debug(res.getBody());
            saveToken(token,String.valueof(timestamp));
        return res;
    }

        /*
        Method: callServiceUcamp
        Input Vars:
            - String vatNumber Merchat's National Insurance Number / VAT
        Method to call service using through MIPS
        */
        global static Boolean callServiceUcamp(String vatNumber,String token){
            try
            {
                //  START   micol.ferrari 17/01/2019 - GET CURRENT ORG NAME
                //String environment = !Test.isRunningTest() ? system.Label.OB_Environment : 'DEV1';
                String environment = !Test.isRunningTest() ? OB_UtilityCallingServices.returnCurrentOrg() : 'DEV1';
                //  END     micol.ferrari 17/01/2019 - GET CURRENT ORG NAME

                OB_Integration_Configuration__c intConfig = OB_Integration_Configuration__c.getValues(environment);

                HttpRequest req = new HttpRequest();
                String vatCodeEncrypt = OB_UtilityCallingServices.encryptionValues(vatNumber);
                String traceIdHeader = String.valueof(DateTime.now()).replaceAll(' ','T')+vatCodeEncrypt;
                req.setEndpoint('callout:OB_Reliability/checkAgainstFraud');
                req.setMethod(OB_UtilityConstants.METHOD_POST);
                //String token = checkToken();
                req.setHeader( OB_UtilityConstants.AUTH, OB_UtilityConstants.PREFIX+token);
                req.setHeader(OB_UtilityConstants.TRACE_ID_HEADER,traceIdHeader);
                req.setHeader('Content-Type','application/json');
                // req.setHeader('MT_COMPANY_GROUP','NEXI');
                // req.setHeader('MT_COMPANY','NEXI');
                // req.setHeader('MT_PARTNER','NEXI');
                req.setHeader('MT_USER','OB_DEV@NEXI.IT');
                //req.setHeader('MT_REQUEST_ID','PRFNRC74H09D773T2018AGU29160930');
                //req.setHeader('MT_SESSION_ID','PRFNRC74H09D773T2018AGU29160930');
                //Marco Lago, 20/12/2018
                String conc = String.valueof(DateTime.now()).replaceAll(' ','T') + vatNumber;
                System.debug('conc ' + conc);
                req.setHeader('MT_REQUEST_ID', conc);
                req.setHeader('MT_SESSION_ID', conc);
                req.setHeader('MT_APPLICATION','OBA');
                req.setHeader('MT_CHANNEL','WEB');
                req.setBody('{"vatNumber": "'+vatNumber+'"}');
                if(intConfig.OB_CAsigned_name__c!=null){
                    req.setClientCertificateName(intConfig.OB_CAsigned_name__c);
                }
                System.debug('Request to service contract: ' + req);
                Http http = new Http();
                HTTPResponse res = http.send(req);
                System.debug(res.getBody());
                OB_UtilityCallingServices.responseReliability objUCAMP = (OB_UtilityCallingServices.responseReliability)JSON.deserialize(res.getBody(),OB_UtilityCallingServices.responseReliability.class);
                System.debug('OB_UtilityCallingServices.callServiceUcamp - objUCAMP : '+objUCAMP);
                //saveToken(token,String.valueof(timestamp));
                Boolean isUCAMP = objUCAMP.fraudReportList.size() == 0 ? false : true;
                return isUCAMP;
            }
            catch(Exception e)
            {
                System.debug('Exception in OB_UtilityCallingServices.callServiceUcamp. Error message: ' + e.getMessage() + ' at line ' + e.getLineNumber());
                return false;
            }
        //return true;
    }

    /*
    Method:callServiceBlacklist
    Input Vars:
        - String vatNumberSOC Merchat's VAT
        - String fiscalCodeSOC  Merchat's National Insurance Number
        - String fiscalCodeSolicitor Solicitor's National Insurance Number
        - List<String> fiscalCodeProprietor Proprietors' National Insurance Number
    */
     global static Boolean callServiceBlacklist(String vatNumber, String fiscalCodeSOC, String fiscalCodeSolicitor,String token){
        try
        {
            //  START   micol.ferrari 17/01/2019 - GET CURRENT ORG NAME
            //String environment = !Test.isRunningTest() ? system.Label.OB_Environment : 'DEV1';
            String environment = !Test.isRunningTest() ? OB_UtilityCallingServices.returnCurrentOrg() : 'DEV1';
            //  END     micol.ferrari 17/01/2019 - GET CURRENT ORG NAME

            OB_Integration_Configuration__c intConfig = OB_Integration_Configuration__c.getValues(environment);

            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:OB_Reliability/checkBlacklist');
            req.setMethod(OB_UtilityConstants.METHOD_POST);
            //String token = checkToken();
            String vatCodeEncrypt = OB_UtilityCallingServices.encryptionValues(vatNumber);
            String fiscalCodeSOCEncrypt = OB_UtilityCallingServices.encryptionValues(fiscalCodeSOC);
            String fiscalCodeSolicitorEncrypt = OB_UtilityCallingServices.encryptionValues(fiscalCodeSolicitor);
            String traceIdHeader = String.valueof(DateTime.now()).replaceAll(' ','T')+fiscalCodeSOCEncrypt+'S'+fiscalCodeSolicitorEncrypt+'V'+vatCodeEncrypt;
            req.setHeader( OB_UtilityConstants.AUTH, OB_UtilityConstants.PREFIX+token);
            req.setHeader(OB_UtilityConstants.TRACE_ID_HEADER,traceIdHeader);
            system.debug('intConfig.OB_CAsigned_name__c:'+intConfig.OB_CAsigned_name__c);
            if(intConfig.OB_CAsigned_name__c!=null){
                req.setClientCertificateName(intConfig.OB_CAsigned_name__c);
            }
            req.setHeader('Content-Type','application/json');
            // req.setHeader('MT_COMPANY_GROUP','NEXI');
            // req.setHeader('MT_COMPANY','NEXI');
            // req.setHeader('MT_PARTNER','NEXI');
            req.setHeader('MT_USER','OB_DEV@NEXI.IT');
            //req.setHeader('MT_REQUEST_ID','PRFNRC74H09D773T2018AGU29160930');
            //req.setHeader('MT_SESSION_ID','PRFNRC74H09D773T2018AGU29160930');
            //Marco Lago, 20/12/2018
            String conc = String.valueof(DateTime.now()).replaceAll(' ','T') + vatNumber;
            System.debug('conc'+ conc);
            req.setHeader('MT_REQUEST_ID', conc);
            req.setHeader('MT_SESSION_ID', conc);
            req.setHeader('MT_APPLICATION','OBA');
            req.setHeader('MT_CHANNEL','WEB');
            //req.setBody('{"vatNumberSOC": "11209550158","fiscalCodeSOC": "11209550158","fiscalCodeSolicitor": "PRFNRC74H09D773T","fiscalCodeProprietor": "PRFNRC74H09D773T"}');
            //req.setBody('{"vatNumberSOC": "","fiscalCodeSOC": "'+fiscalCodeSOC+'","fiscalCodeSolicitor": "'+fiscalCodeSolicitor+'","fiscalCodeProprietor": []}');
            req.setBody('{"vatNumberSOC": "'+vatNumber+'","fiscalCodeSOC": "'+fiscalCodeSOC+'","fiscalCodeSolicitor": "'+fiscalCodeSolicitor+'"}');
            system.debug(req.getBody());
            System.debug('Request to service contract: ' + req);
            Http http = new Http();
            HTTPResponse res = http.send(req);
            System.debug('get body'+res.getBody());
            //saveToken(token,String.valueof(timestamp));
            OB_UtilityCallingServices.responseReliability objBlackList = (OB_UtilityCallingServices.responseReliability)JSON.deserialize(res.getBody(),OB_UtilityCallingServices.responseReliability.class);
            System.debug('OB_UtilityCallingServices.callServiceBlacklist - objBlackList : '+objBlackList);
            //saveToken(token,String.valueof(timestamp));


            //  micol.ferrari 10/01/2019 - IF BLACKLIST HAS GENERIC ERROR, WE NEED TO EVALUATE THE BLACKLIST OBJECT
            //Boolean isBlackList = objBlackList.blacklist.size() == 0 ? false : true;
            Boolean isBlackList = (objBlackList.blacklist==null || (objBlackList.blacklist!=null && objBlackList.blacklist.size()== 0)) ? false : true;
            return isBlackList;
        }
        catch(Exception e)
        {
            System.debug('Exception in OB_UtilityCallingServices.callServiceBlacklist. Error message: ' + e.getMessage() + ' at line ' + e.getLineNumber());
            return false;
        }
    }

    global static HTTPResponse callTerminalId(Boolean isToGenerate, String orderId, String proposerAbi, String posType, String terminalId, String contractId ){
            //  START   micol.ferrari 17/01/2019 - GET CURRENT ORG NAME
            //String environment = !Test.isRunningTest() ? system.Label.OB_Environment : 'DEV1';
            String environment = !Test.isRunningTest() ? OB_UtilityCallingServices.returnCurrentOrg() : 'DEV1';
            //  END     micol.ferrari 17/01/2019 - GET CURRENT ORG NAME

            OB_Integration_Configuration__c intConfig = OB_Integration_Configuration__c.getValues(environment);

            String traceIdHeader =  String.valueof(DateTime.now()).replaceAll(' ','T')+posType;
            HttpRequest req = new HttpRequest();
            String endpoint = '';
            String method = '';
            if(isToGenerate){
                endpoint =  'callout:OB_callService/api/terminals';
                method = OB_UtilityConstants.METHOD_POST;
                req.setBody('{"proposerABI": "'+proposerAbi+'","posType": "'+posType+'","orderId": "'+orderId+'"}');
                traceIdHeader += orderId;
            }else{
                endpoint = 'callout:OB_callService/api/terminals/'+terminalId+'?proposerABI='+proposerAbi+'&posType='+posType+'&contractId='+contractId;
                method =  OB_UtilityConstants.METHOD_GET;
                traceIdHeader +=terminalId+'_'+contractId;
            }
            req.setEndpoint(endpoint);
            req.setMethod(method);
            if(intConfig.OB_CAsigned_name__c!=null){
                req.setClientCertificateName(intConfig.OB_CAsigned_name__c);
            }
            //set timeout for safety
            req.setTimeout(5000); // timeout in milliseconds

            String token = checkToken();
            req.setHeader( OB_UtilityConstants.AUTH, OB_UtilityConstants.PREFIX+token);
            req.setHeader(OB_UtilityConstants.TRACE_ID_HEADER,traceIdHeader);
            req.setHeader('Content-Type','application/json');
            System.debug('Request to service contract: ' + req);
            Http http = new Http();
            HTTPResponse res = http.send(req);
            System.debug(res.getBody());
            saveToken(token,String.valueof(timestamp));
        return res;
    }
    /*
    Wrapper response servizio UCAMP
    */
    global class responseReliability{
            global result result;
            global List<Map<String,String>> fraudReportList;
            global List<Map<String,String>> blacklist;
    }

    /*Wrapper Object inside Reliability*/
    global class result{
        global String code;
        global String description;
    }

    global static void callSubmit (String orderHeaderId ){
        //  START   micol.ferrari 17/01/2019 - GET CURRENT ORG NAME
        String environment = !Test.isRunningTest() ? OB_UtilityCallingServices.returnCurrentOrg() : 'DEV1';
        //  END     micol.ferrari 17/01/2019 - GET CURRENT ORG NAME

        OB_Integration_Configuration__c intConfig = OB_Integration_Configuration__c.getValues(environment);

        System.debug('OB_UtilityCallingServices.callsubmit - '+orderHeaderId);
        String traceIdHeader = String.valueof(DateTime.now()).replaceAll(' ','T')+orderHeaderId;
        OB_Serialize_Order t = new OB_Serialize_Order();
        HttpRequest req = new HttpRequest();
        String token = OB_UtilityCallingServices.checkToken();
        system.debug('Service message: '+token);
        req.setHeader(OB_UtilityConstants.AUTH, OB_UtilityConstants.PREFIX+token);
        req.setHeader(OB_UtilityConstants.TRACE_ID_HEADER,traceIdHeader);
        req.setEndpoint('callout:OB_callService/api/contracts');
        req.setMethod(OB_UtilityConstants.METHOD_POST);
        req.setHeader('Content-Type','application/json');
        if(intConfig.OB_CAsigned_name__c!=null){
            req.setClientCertificateName(intConfig.OB_CAsigned_name__c);
        }
        req.setBody(t.serializeOrder(orderHeaderId));
        Http http = new Http();
        // <daniele.gandini@ccenture.com> - 28/06/2019 - WN-2 - START
        Datetime dateNow =  Datetime.now();
        Integer startCall = dateNow.millisecond();
        String plcStatus = 'S';
        System.debug('### http.send(req) req : '+req);
        //Nexi Kinga Fornal kinga.fornal@accenture.com 12.08.2019 START
        HTTPResponse res = new HTTPResponse();
        if ( !Test.isRunningTest( ) )
        {
            // <daniele.gandini@ccenture.com> - 28/06/2019 - WN-2 - STOP
            res = http.send( req );
            // <daniele.gandini@ccenture.com> - 28/06/2019 - WN-2 - START
        }
        else
        {
            res.setHeader( 'Content-Type', 'text/xml' );
            res.setBody( '' );
            res.setStatus( 'Created' );
            res.setStatusCode( 201 );
        }
        //NEXI Kinga Fornal kinga.fornal@accenture.com 12.08.2019 STOP

        if(res.getStatusCode() != 200){
            plcStatus = 'W';
        }
      
        String header = OB_UtilityConstants.AUTH + ',' + OB_UtilityConstants.PREFIX+token + ',' + OB_UtilityConstants.TRACE_ID_HEADER + ',' + traceIdHeader + 'Content-Type' + ',' + 'application/json';
        Plc_LogHelper.LogStructure ls = new Plc_LogHelper.LogStructure();
        ls.processingTime = String.valueOf(dateNow.millisecond() - startCall);
        ls.httpMethod = OB_UtilityConstants.METHOD_POST;
        ls.requestUri = 'callout:OB_callService/api/contracts';
        ls.requestBody = String.ValueOf(req.getBody());
        ls.responseBody = res.toString();
        ls.responseMessage = '';
        ls.responseStatus = plcStatus;
        ls.responseStackTrace = String.valueOf(res.getStatusCode());
        ls.recordUrl = '';
        Id plcId = Plc_LogHelper.logCall(ls); //francesca.ribezzi 26/09/19 - F2WAVE2-189 - logCall returns the plc id
        //START francesca.ribezzi 26/09/19 - F2WAVE2-189 - updating the new plcLog:
        List<NE__Order__c> orders = [SELECT id FROM NE__Order__c where NE__Order_Header__c = :orderHeaderId];
        String confId;
        if(orders.size()> 0){
            confId = orders[0].Id;
        }
     	OB_Utility.updateLogRequestOrderIdOnPlcLog(plcId, confId);   
        //END francesca.ribezzi 26/09/19 - F2WAVE2-189 
        // <daniele.gandini@ccenture.com> - 28/06/2019 - WN-2 - STOP

        //System.debug('Response body: '+res.getBody());
        System.debug('Response : '+res);
        //2018-12-13--Salvatore P.--If order is sent, change status of Order Header, Configuration, Configuration items to 'Sent'
        if(String.valueOf(res) == 'System.HttpResponse[Status=Created, StatusCode=201]')
        {
            OB_Utility.changeStatus(orderHeaderId);
        }
          if (res.getStatusCode() == 201){
            System.enqueueJob(new OB_QueueableClassTracking(orderHeaderId));//Simone Misani 16/09/2019 New-Tracking            
        }
        //Start antonio.vatrano 23/09/2019 wn-448
        List <Account> listAcc = [select id, ob_legal_form__c, Ob_legal_form_code__c from account where id in (select Ne__accountId__c from ne__order_header__c where id =:orderHeaderId)];
        if(!listAcc.isEmpty()){
            System.debug('ACCOUNT FOUND');
            Account acc = listAcc.get(0);
            OB_Serialize_Order.checkForEmptyLegalFormCode(acc);
        }
        //End antonio.vatrano 23/09/2019 wn-448
    }

    global static String encryptionValues(String valueToEncrypt){
        String encryptedValue = '';
        List<String> singleValuesToEncryptList = new List<String>();
        //Simone Misani 2019-09-21 Start
        if(valueToEncrypt != null){
             for(Integer i=0;i<valueToEncrypt.length();i++){
            Integer j = i<valueToEncrypt.length()?i+1:valueToEncrypt.length();
            singleValuesToEncryptList.add(valueToEncrypt.substring(i,j));
            system.debug('singleValuesToEncryptList: '+ singleValuesToEncryptList);
            }

        }
         //Simone Misani 2019-09-21 END
       
        List<String> valueEncoded = new List<String>();
        for(String singleValue : singleValuesToEncryptList){
            if(singleValue.isNumeric()){
                valueEncoded.add(OB_UtilityConstants.MAPNUMBERSTOLETTER.get(String.valueOf(Integer.valueOf(singleValue)+3)));
            }else{
                valueEncoded.add(String.valueOf(Math.abs(Integer.valueOf(OB_UtilityConstants.MAPLETTERSTONUMBERS.get(singleValue.toUpperCase()))-10)));
            }
            system.debug('valueEncoded: '+valueEncoded);
        }
        for(String valueEncode:valueEncoded){
            encryptedValue +=valueEncode;
            system.debug('encryptedValue: '+encryptedValue);
        }
        return encryptedValue;
    }

	/*******************************************************************************
	Purpose:  Method is a wrapper method of getClientTypeSet but without
			  company modification "indicator "parameter,
			  it is created due to compability reasons

    Parameters: List<OB_Special_Category_Configuration__c> listToFilter,
                List<NE__OrderItem__c> orderItems,
			    String mcc, String ateco, String legalForm, String merchantId,
			    List<String> listOfLogRequestTypes,String abi,String mainProcess

    Returns: Set<String>
	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         Grzegorz Banach       29/04/2019        Created         NEXI-32 Customer DS-4 & FG-4
	 ********************************************************************************/
	global static Set<String> getClientTypeSet (List<OB_Special_Category_Configuration__c> listToFilter,List<NE__OrderItem__c> orderItems,
			String mcc, String ateco, String legalForm, String merchantId, List<String> listOfLogRequestTypes,String abi,String mainProcess ){
		return OB_UtilityCallingServices.getClientTypeSet( listToFilter, orderItems, mcc, ateco, legalForm, merchantId, listOfLogRequestTypes, abi, mainProcess, false);
	}

    //  micol.ferrari 13/12/2018 - ADD listOfLogRequestTypes
    //Elena Preteni 10/01/2019 Added parameter abi in getClientTypeSet method signature NS_06
    // e.p 06/03/19 gambling per maintenance
    global static Set<String> getClientTypeSet (List<OB_Special_Category_Configuration__c> listToFilter,List<NE__OrderItem__c> orderItems,
        String mcc, String ateco, String legalForm, String merchantId, List<String> listOfLogRequestTypes,String abi,String mainProcess, Boolean isCompanyDataModified ){
		//NEXI-32 Customer DS-4 & FG-4 grzegorz.banach@accenture.com 20/05/2019 added "isCompanyDataModified" Boolean parameter
        List<OB_Bank_Profile__c> listBankProfile = [SELECT Id, OB_UploadSignedContract__c  FROM OB_Bank_Profile__c WHERE OB_Bank__r.OB_ABI__c = :abi limit 1];
        Boolean loadSignedContract = !listBankProfile.isEmpty() ? listBankProfile.get(0).OB_UploadSignedContract__c : false;
        system.debug('mcc: '+mcc);
        system.debug('ateco: '+ateco);
        system.debug('legalForm: '+legalForm);
        system.debug('merchantId: '+merchantId);
        // START 25/02/2019 AV dont show CONTRATTO FIRMATO if contract's list isEmpty [ML]
        Map <String, String> contracts = new Map <String, String>();
        if(orderItems!=null && !orderItems.isEmpty())
        {
            system.debug('orderId: '+orderItems.get(0).NE__OrderId__c);
            string confId = orderItems.get(0).NE__OrderId__c;
            contracts = commercialProductController.getContractList(confId);
            System.debug('@@@isEmpty: '+ contracts.isEmpty());
        }
        // END AV dont show CONTRATTO FIRMATO if contract's list isEmpty

        Set<String> clientTypeSet = new Set<String>();
        Boolean isCrowdfunding = false;
        Account account = new Account();
        try{
            account = [SELECT Id,OB_DescriptionVATNotPresent__c,OB_IsCrowdfunding__c FROM Account WHERE Id =:merchantId];
        }catch(Exception e){
            system.debug('Account not present for merchant: '+merchantId +'or exception: '+e);
        }
        if(account!= null && account.Id!=null ){
            isCrowdfunding = account.OB_IsCrowdfunding__c;
        }
        List<NE__Lov__c> mccLovList = [SELECT Id,NE__Value1__c FROM NE__Lov__c WHERE NE__Type__c='MCC' AND NE__Value2__c=:mcc AND NE__Value3__c = 'L3' ];
        system.debug('mccLov: '+mccLovList);
        List<NE__Lov__c> atecoLovList = [SELECT Id,NE__Value3__c FROM NE__Lov__c WHERE NE__Type__c='ATECO' AND NE__Active__c=true AND Name=:ateco];
        system.debug('atecoLov: '+atecoLovList);
        List<NE__Lov__c> legalFormLovList = [SELECT Id,NE__Value1__c FROM NE__Lov__c WHERE NE__Type__c='LegalForm' AND NE__Active__c=true AND Name=:legalForm];
        system.debug('legalFormLov: '+legalFormLovList);

        for(OB_Special_Category_Configuration__c record : listToFilter){
            Boolean isRightMcc = false;
            Boolean isRightAteco = false;
            Boolean isRightLegalForm = false;
            for(NE__Lov__c atecoLov : atecoLovList){
                if(atecoLov.NE__Value3__c!=null){
                    if(atecoLov.NE__Value3__c.equalsIgnoreCase(record.OB_ATECO__c)){
                        isRightAteco=true;
                        break;
                    }
                }
            }
            for(NE__Lov__c mccLov : mccLovList){
                if(mccLov.NE__Value1__c!=null){
                    if(mccLov.NE__Value1__c.equalsIgnoreCase(record.OB_MCC__c)){
                        isRightMcc=true;
                        break;
                    }
                }
            }
            system.debug('record: ' + record);
            system.debug('record.RecordType.DeveloperName: ' + record.RecordType.DeveloperName);
            system.debug('isRightAteco: ' + isRightAteco);
            system.debug('isRightMcc: ' + isRightMcc);
            if (record.RecordType.DeveloperName != '')
            {
                switch on (record.RecordType.DeveloperName){
                    //START [13-05-2019 No Card Present] Andrea Saracini
                    when 'PRODUCT_AND_ATTRIBUTE' {
                        for(NE__OrderItem__c orderItem: orderItems){
                            if(orderItem.NE__ProdId__c !=null && orderItem.NE__ProdId__r.NE__Engine_Code__c.equalsIgnoreCase(record.OB_EngineCodeCommercialProduct__c) && orderItem.NE__Order_Item_Attributes__r != null && orderItem.NE__Action__c == 'Add'){ // antonio.vatrano 02/09/2019 add condition for Server2Server, should be in ADD
                                for(NE__Order_Item_Attribute__c item : orderItem.NE__Order_Item_Attributes__r){
                                    system.debug('OB_PRODUCT_ACTIVATION: '+item);
                                    Boolean match = false;
                                    if(record.OB_Attribute_Name__c.equalsIgnoreCase(item.Name) && !String.isBlank(item.NE__Value__c) && item.NE__Value__c.equalsIgnoreCase(record.OB_Attribute_Value__c)){
                                        match = true;
                                    }
                                    if(match){
                                        clientTypeSet.add(record.Name);
                                    }
                                }
                                system.debug('OB_PRODUCT_ACTIVATION');
                            }
                        }
                    }
                    //STOP [13-05-2019 No Card Present] Andrea Saracini
                    when 'OB_MCC_OR_ATECO' {
                        if(mainProcess=='Setup'){
                            if(isRightMcc || isRightAteco){
                                clientTypeSet.add(record.Name);
                                system.debug('OB_MCC_OR_ATECO');
                            }//START - elena.preteni 13/07/2019 WN-101 Gambling
                        }else if(mainProcess=='Maintenance' && orderItems.isEmpty() && (isRightMcc || isRightAteco)){
                            clientTypeSet.add(record.Name);
                            system.debug('OB_MCC_OR_ATECO');
                            //END - elena.preteni 13/07/2019 WN-101 Gambling
                        }else if(!orderItems.isEmpty() && (isRightMcc || isRightAteco)){// DG - 08/03/2019 - ANAG-132 - added if condition on MCC switchCase for null orderItems case
                            system.debug( 'inside else OB_MCC_OR_ATECO' +orderItems);
                            for(NE__OrderItem__c orderItem: orderItems){
                                if(orderItem.NE__ProdId__r.Id!=null){
                                    system.debug( 'inside else OB_MCC_OR_ATECO' );
                                    if(orderItem.NE__Parent_Order_Item__c==null &&
                                        orderItem.NE__ProdId__r.OB_Codice_sfdc__c.equalsIgnoreCase('VISAMASTERCARD') &&
                                        orderItem.NE__Action__c.equalsIgnoreCase('Add')){
                                            system.debug( 'inside else OB_MCC_OR_ATECO' );
                                        clientTypeSet.add(record.Name);
                                        system.debug('OB_PRODUCT_ACTIVATION');
                                    }
                                }
                            }
                        }
                    }
                    when 'OB_MCC_OR_ATECO_FORMA_GIURIDICA'
                    {
                        for(NE__Lov__c legalFormLov : legalFormLovList){
                            if(legalFormLov.NE__Value1__c!=null){
                                if(legalFormLov.NE__Value1__c.equalsIgnoreCase(record.OB_Legal_Form__c)){
                                    isRightLegalForm=true;
                                    break;

                                }
                            }
                        }
                        if(mainProcess=='Setup'){
                            if((isRightMcc || isRightAteco) && !isRightLegalForm){
                                clientTypeSet.add(record.Name);
                                system.debug('OB_MCC_OR_ATECO_FORMA_GIURIDICA');
                            }
                        //Start - antonio.vatrano 17/07/2019 wn_109
                        }else if(mainProcess=='Maintenance' && orderItems.isEmpty() && ((isRightMcc || isRightAteco) && !isRightLegalForm)){
                            clientTypeSet.add(record.Name);
                        //End - antonio.vatrano 17/07/2019 wn_109
                        }else{
                            // DG - 08/03/2019 - ANAG-132 - added if condition on MCC switchCase for null orderItems case
                            if(orderItems != null && ((isRightMcc || isRightAteco) && !isRightLegalForm)){
                                for(NE__OrderItem__c orderItem: orderItems){
                                    if(orderItem.NE__ProdId__r.Id!=null){
                                        if(orderItem.NE__Parent_Order_Item__c==null &&
                                            orderItem.NE__ProdId__r.OB_Codice_sfdc__c.equalsIgnoreCase('VISAMASTERCARD') &&
                                            orderItem.NE__Action__c.equalsIgnoreCase('Add')){
                                            clientTypeSet.add(record.Name);
                                            system.debug('OB_PRODUCT_ACTIVATION');
                                        }
                                    }
                                }
                            }
                        }
                    }
                    when 'OB_PRODUCT_ACTIVATION' {
                        if (orderItems!=null && !orderItems.isEmpty()){
                            for(NE__OrderItem__c orderItem: orderItems){
                                if(orderItem.NE__ProdId__r.Id!=null){
                                    if(orderItem.NE__ProdId__r.NE__Engine_Code__c.equalsIgnoreCase(record.OB_EngineCodeCommercialProduct__c)){
                                        clientTypeSet.add(record.Name);
                                        system.debug('OB_PRODUCT_ACTIVATION');
                                    }
                                }
                            }
                        }
                    }
                    when 'OB_PRODUCT_ACTIVATION_FORMA_GIURIDICA'
                    {
                        if (orderItems!=null && !orderItems.isEmpty())
                        {
                            for(NE__Lov__c legalFormLov : legalFormLovList)
                            {
                                if(legalFormLov.NE__Value1__c!=null)
                                {
                                    if(legalFormLov.NE__Value1__c.equalsIgnoreCase(record.OB_Legal_Form__c))
                                    {
                                        isRightLegalForm=true;
                                        break;
                                    }
                                }
                            }
                            Boolean isEcommerceMotoAlone = false;
                            for(NE__OrderItem__c orderItem: orderItems){
                                if(orderItem.NE__ProdId__r.Id!=null){
                                    isEcommerceMotoAlone = (orderItem.NE__ProdId__r.NE__Engine_Code__c.equalsIgnoreCase(record.OB_EngineCodeCommercialProduct__c)) && isRightLegalForm;
                                    if(isEcommerceMotoAlone){
                                        clientTypeSet.add(record.Name);
                                        system.debug('OB_PRODUCT_ACTIVATION_FORMA_GIURIDICA');
                                    }
                                }
                            }
                        }
                    }
                    when 'OB_PRODUCT_ACTIVATION_NOT_FORMA_GIURIDICA'{
                        if (orderItems!=null && !orderItems.isEmpty()){
                            for(NE__Lov__c legalFormLov : legalFormLovList){
                                system.debug('legalFormLov.NE__Value1__c: '+legalFormLov.NE__Value1__c);
                                if(legalFormLov.NE__Value1__c!=null){
                                    if(!legalFormLov.NE__Value1__c.equalsIgnoreCase(record.OB_Legal_Form__c)){
                                        isRightLegalForm=true;
                                        break;
                                    }
                                }
                            }
                            Boolean isEcommerceMotoAlone = false;
                            for(NE__OrderItem__c orderItem: orderItems){
                                if(orderItem.NE__ProdId__r.Id!=null){
                                    isEcommerceMotoAlone = (orderItem.NE__ProdId__r.NE__Engine_Code__c.equalsIgnoreCase(record.OB_EngineCodeCommercialProduct__c)) && isRightLegalForm;
                                    if(isEcommerceMotoAlone){
                                        clientTypeSet.add(record.Name);
                                        system.debug('OB_PRODUCT_ACTIVATION_NOT_FORMA_GIURIDICA');
                                    }
                                }
                            }
                        }
                    }
                    when 'OB_CROWDFUNDING'{
                        if(isCrowdfunding){
                            clientTypeSet.add(record.Name);
                            system.debug('OB_CROWDFUNDING');
                        }
                    }
                    when 'OB_FORMA_GIURIDICA'{
                        for(NE__Lov__c legalFormLov : legalFormLovList){

                            if(legalFormLov.NE__Value1__c!=null || record.OB_Legal_Form__c != null){
                                System.debug(legalFormLov.NE__Value1__c+'   '+record.OB_Legal_Form__c+'     '+legalFormLov.NE__Value1__c.equalsIgnoreCase(record.OB_Legal_Form__c));
                                if(legalFormLov.NE__Value1__c.equalsIgnoreCase(record.OB_Legal_Form__c)){
                                    isRightLegalForm=true;
                                    break;
                                }
                            }
                        }
                        System.debug('isRightLegalForm: '+isRightLegalForm);
                        if(mainProcess=='Setup' && isRightLegalForm){
                            clientTypeSet.add(record.Name);
                            system.debug('OB_FORMA_GIURIDICA');
                        /*if(isRightLegalForm){
                            clientTypeSet.add(record.Name);
                            system.debug('OB_FORMA_GIURIDICA');*/
                        }else{
                            if(orderItems != null && isRightLegalForm){ 
                                for(NE__OrderItem__c orderItem: orderItems){
                                    if(orderItem.NE__ProdId__r.Id!=null){
                                        if(orderItem.NE__Parent_Order_Item__c==null &&
                                            orderItem.NE__ProdId__r.OB_Codice_sfdc__c.equalsIgnoreCase('VISAMASTERCARD') &&
                                            orderItem.NE__Action__c.equalsIgnoreCase('Add')){
                                            clientTypeSet.add(record.Name);
                                            system.debug('OB_PRODUCT_ACTIVATION');
                                        }
                                    }
                                }
                            }
                        }
                    }
                    when 'OB_PRODUCT_ENABLEMENT'{
                        if (orderItems!=null && !orderItems.isEmpty()){
                            Boolean isHotelCarRent = false;
                            for(NE__OrderItem__c orderItem: orderItems){
                                if(orderItem.NE__ProdId__r.Id!=null && orderItem.NE__Parent_Order_Item__r.Id!=null &&  record.OB_EngineCodeCommercialProduct__c!='' ){
                                    isHotelCarRent = orderItem.NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName.equalsIgnoreCase('Terminali')
                                                    && orderItem.NE__ProdId__r.NE__Engine_Code__c.equalsIgnoreCase(record.OB_EngineCodeCommercialProduct__c);
                                    if(isHotelCarRent){
                                        clientTypeSet.add(record.Name);
                                        system.debug('OB_PRODUCT_ENABLEMENT');
                                    }
                                }
                            }
                        }
                    }
                    when 'OB_DESCRIPTION_NO_VAT'{
                        if(record.OB_DescriptionNoVat__c!=''){
                            if(record.OB_DescriptionNoVat__c.equalsIgnoreCase(account.OB_DescriptionVATNotPresent__c)){
                                clientTypeSet.add(record.Name);
                                system.debug('OB_DESCRIPTION_NO_VAT');
                            }
                        }
                    }
                    //  START   micol.ferrari 13/12/2018 - ADD RECORDTYPES FOR MAINTENANCE
                    when 'CAMBIO_DENOMINAZIONE_SOCIALE'
                    {
                        if (listOfLogRequestTypes!=null && !listOfLogRequestTypes.isEmpty())
                        {
                            for (String logrequest : listOfLogRequestTypes)
                            {
                                if (logrequest.equalsIgnoreCase(Label.OB_MAINTENANCE_CHANGEMERCHANTNAME))
                                {
                                    clientTypeSet.add(record.Name);
                                }
                            }
                        }
                    }
                    when 'CAMBIO_FORMA_GIURIDICA'
                    {
                        if (listOfLogRequestTypes!=null && !listOfLogRequestTypes.isEmpty())
                        {
                            for (String logrequest : listOfLogRequestTypes)
                            {
                                if (logrequest.equalsIgnoreCase(Label.OB_MAINTENANCE_CHANGELEGALFORM))
                                {
                                    clientTypeSet.add(record.Name);
                                }
                            }
                        }
                    }
                    when 'CAMBIO_ESECUTORE'
                    {
                        if (listOfLogRequestTypes!=null && !listOfLogRequestTypes.isEmpty())
                        {
                            for (String logrequest : listOfLogRequestTypes)
                            {
                                if (logrequest.equalsIgnoreCase(Label.OB_MAINTENANCE_NEWLEGAL) || logrequest.equalsIgnoreCase(Label.OB_MAINTENANCE_CHANGELEGAL))
                                {
                                    clientTypeSet.add(record.Name);
                                }
                            }
                        }
                    }
                    //  END     micol.ferrari 13/12/2018 - ADD RECORDTYPES FOR MAINTENANCE
                    //Elena Preteni 10/01/2019 NS_06
                    when 'OB_UPLOAD_CONTRATTO_FIRMATO_MAINTENANCE'
                    {
                        if(loadSignedContract && record.OB_RequestType__c==OB_UtilityConstants.MAINTENANCE)
                        {
                            // START 25/02/2019 AV dont show CONTRATTO FIRMATO if contract's list isEmpty [ML]
                            if(!contracts.isEmpty())
                            {
                                if(listOfLogRequestTypes==null || listOfLogRequestTypes.isEmpty())
                                {
                                    clientTypeSet.add(record.Name);
                                }
                            }
                            // END AV dont show CONTRATTO FIRMATO if contract's list isEmpty
                        }
                    }
                    when 'OB_UPLOAD_CONTRATTO_FIRMATO_SETUP'
                    {
                        if(loadSignedContract)
                        {
                            clientTypeSet.add(record.Name);
                        }
                    }
                    //Elena Preteni 10/01/2019 NS_06
                    //NEXI-82 Document upload and error message wojciech.kucharek@accenture.com 12/06/2019 START
                    //start   antonio.vatrano wn-97 13/07/2019
                    when 'OB_MCC_UPLOAD_DOCUMENT'
                    {
                        //NEXI-166 Wojciech Kucharek <wojciech.kucharek@accenture.com> 12/07/2019  Document Visura/atto costitutivo/SCIA It always has to be uploaded for a change of MCC.
                        clientTypeSet.add( record.Name );
                    }
                    //end antonio.vatrano wn-97 13/07/2019
                    //NEXI-82 Document upload and error message wojciech.kucharek@accenture.com 12/06/2019 START

                    //NEXI-32 Customer DS-4 & FG-4 grzegorz.banach@accenture.com 13/05/2019 START
					when 'OB_CHANGENAMEORLEGALFORM'
                    {
						if ( isCompanyDataModified != null && isCompanyDataModified )
						{
							clientTypeSet.addAll( new List<String>{ record.Name } );
						}
					}
					//Elena Preteni 10/01/2019 NS_06
                    //NEXI-32 Customer DS-4 & FG-4 grzegorz.banach@accenture.com 13/05/2019 END
                }
            }
        }
        return clientTypeSet;
    }

    //@future(callout=true)
    global static void sendEmail (String orderHeader){
        try{
            OB_Serialize_Order t = new OB_Serialize_Order();
            List<NE__Order__c> orders = [SELECT Id,OB_Service_Point__c, NE__Order_Header__r.NE__AccountId__c,
                NE__Order_Header__r.NE__AccountId__r.OB_ATECO__c,
                NE__Order_Header__r.NE__AccountId__r.OB_IsCrowdfunding__c,
                NE__Order_Header__r.NE__AccountId__r.OB_DescriptionVATNotPresent__c,
                NE__Order_Header__r.NE__AccountId__r.OB_Legal_Form__c,
                OB_MCC__c,
                NE__Order_Header__r.OB_StartApprovalProcess__c,
                NE__Order_Header__r.OB_In_Approvazione_a__c ,
                NE__Order_Header__r.OB_Rejection_Reason__c,
                (SELECT id,  NE__Parent_Order_Item__c, NE__ProdId__c,  NE__ProdId__r.Name,
                NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName,
                NE__ProdId__r.Id,NE__ProdId__r.NE__Engine_Code__c,
                NE__ProdId__r.RecordType.DeveloperName ,
                NE__ProdName__c,NE__OrderId__r.NE__Order_Header__c,
                NE__OrderId__r.NE__Order_Header__r.OB_Main_Process__c,
                NE__OrderId__r.NE__Order_Header__r.OB_Business_Model_Acquiring__c,
                NE__OrderId__r.NE__Order_Header__r.OB_Business_Model_POS__c
                FROM NE__Order_Items__r)
                FROM NE__Order__c
                WHERE NE__Order_Header__c=:orderHeader];


            List<NE__Order_Header__c> oh = [SELECT Id,OB_FinalRejectionEmail__c FROM NE__Order_Header__c WHERE Id=:orderHeader];


            String orderId = orders[0].Id;
            String servicePointId = orders[0].OB_Service_Point__c;
            String accountId = orders[0].NE__Order_Header__r.NE__AccountId__c;

            //  START   micol.ferrari 17/01/2019 - GET CURRENT ORG NAME
            //String environment = !Test.isRunningTest() ? system.Label.OB_Environment : 'DEV1';
            String environment = !Test.isRunningTest() ? OB_UtilityCallingServices.returnCurrentOrg() : 'DEV1';
            //  END     micol.ferrari 17/01/2019 - GET CURRENT ORG NAME

            OB_Integration_Configuration__c intConfig = OB_Integration_Configuration__c.getValues(environment);

            String body = '';
            HttpRequest req = new HttpRequest();
            String traceIdHeader =  String.valueof(DateTime.now()).replaceAll(' ','T')+'EMAIL_DINIEGO'+orderHeader;
            String url = 'callout:OB_callService/api/merchants/'+accountId+'/sales-points/'+servicePointId+'/orders/'+orderId+'/documents';
            body = '{"documentType":"EMAIL_DINIEGO","templateName":"SFDCEMAILDINIEGO","templateVersion":"1",'
                    +'"documentStream":"","documentStatus":"ACTIVE","posType":"","documentBody":'+t.serializeOrder(orderHeader)+','
                    +'"documentFileName":"","callbackUrl":""}';
            String token = OB_UtilityCallingServices.checkToken();
            req.setEndpoint(url);
            req.setMethod('POST');
            req.setHeader( OB_UtilityConstants.AUTH, OB_UtilityConstants.PREFIX+token);
            req.setHeader(OB_UtilityConstants.TRACE_ID_HEADER,traceIdHeader);
            if(intConfig.OB_CAsigned_name__c!=null){
                req.setClientCertificateName(intConfig.OB_CAsigned_name__c);
            }
            req.setHeader('Content-Type','application/json');
            req.setBody(body);
            System.debug('Request to service contract createRequest: ' + req);
            System.debug('Request to service contract createRequest: ' + req.getBody());
            Http http = new Http();
            HTTPResponse res = http.send(req);
            System.debug(res);
            if(oh!=null && !oh.isEmpty()){
                oh[0].OB_FinalRejectionEmail__c = true;
            }
            update oh;
        }catch(Exception e){
            System.debug('OB_UtilityCallingServices.sendEmail Exception: ' + e.getMessage() + ' at line: ' + e.getLineNumber() + ' stack trace: ' + e.getStackTraceString());
        }
    }
    @future(callout=true)
    global static void welcomeLetter(String orderHEader,String order, String merchant,String salePoint ){
        //Start antonio.vatrano 07/05/2019 r1f2-48 control if welcomeletter was sent
        //michele.lubrano@accenutre.com preventing consecutive http callouts to filenet
        List<NE__Order__c> orderList = [SELECT id, NE__FulfilmentStatus__c FROM NE__Order__c WHERE id =:order LIMIT 1 FOR UPDATE];
        if(!orderList.isEmpty()){
            NE__Order__c currentOrder = orderList.get(0);
            String controlWelcomeLetter = currentOrder.NE__FulfilmentStatus__c;
            //End antonio.vatrano 07/05/2019 r1f2-48 control if welcomeletter was sent
            String  url = 'callout:OB_callService/api/merchants/'+merchant+'/sales-points/'+salePoint+'/orders/'+order+'/documents';
            //  START   micol.ferrari 17/01/2019 - GET CURRENT ORG NAME
            //String environment = !Test.isRunningTest() ? system.Label.OB_Environment : 'DEV1';
            String environment = !Test.isRunningTest() ? OB_UtilityCallingServices.returnCurrentOrg() : 'DEV1';
            //  END     micol.ferrari 17/01/2019 - GET CURRENT ORG NAME
            OB_Integration_Configuration__c intConfig = OB_Integration_Configuration__c.getValues(environment);
            String body = '';
            String plcStatus = 'S';
            HttpRequest req = new HttpRequest();
            String traceIdHeader =  String.valueof(DateTime.now()).replaceAll(' ','T')+'EMAIL_DINIEGO'+orderHeader;
            OB_Serialize_Order t = new OB_Serialize_Order();
            system.debug('orderHeader createRequest: '+orderHeader);
            body = '{"documentType":"CONTRATTO","templateName":"SFDCWELCOMELETTER","templateVersion":"1","documentStream":"","documentStatus":"ACTIVE","posType":"","documentBody":'+t.serializeOrder(orderHeader)+
                    ',"callbackUrl":""}';
            system.debug('createRequest body createRequest' + body );
            traceIdHeader +=orderHeader+'WL';
            String token = OB_UtilityCallingServices.checkToken();
            req.setEndpoint(url);
            req.setMethod('POST');
            req.setHeader( OB_UtilityConstants.AUTH, OB_UtilityConstants.PREFIX+token);
            req.setHeader(OB_UtilityConstants.TRACE_ID_HEADER,traceIdHeader);
            if(intConfig.OB_CAsigned_name__c!=null){
                req.setClientCertificateName(intConfig.OB_CAsigned_name__c);
            }
            req.setHeader('Content-Type','application/json');
            req.setBody(body);
            System.debug('Request to service contract createRequest: ' + req);
            System.debug('Request to service contract createRequest: ' + req.getBody());
            Http http = new Http();
            HTTPResponse res = http.send(req);
            System.debug(res);
            System.debug(res.getBody());
            //Start antonio.vatrano 07/05/2019 r1f2-48 control if welcomeletter was sent
            //michele.lubrano@accenutre.com 28-05-2019 preventing consecutive http callouts to filenet - START
            if(res.getStatusCode() != 200){	//antonio.vatrano r1f2-48 15/05/2019 change condition
                currentOrder.NE__FulfilmentStatus__c = '';
                update currentOrder;
                plcStatus = 'W';
            }
            //End antonio.vatrano 07/05/2019 r1f2-48 control if welcomeletter was sent

            //michele.lubrano@accenture.com 28-05-2019 implementing webresults logs - START
            String header = OB_UtilityConstants.AUTH + ',' + OB_UtilityConstants.PREFIX+token + ',' + OB_UtilityConstants.TRACE_ID_HEADER + ',' + traceIdHeader + 'Content-Type' + ',' + 'application/json';
            Datetime dateNow =  Datetime.now();
            Integer millisecondsNow = dateNow.millisecond();

            Plc_LogHelper.LogStructure ls = new Plc_LogHelper.LogStructure();
            ls.processingTime = String.valueOf(millisecondsNow);
            ls.httpMethod = 'POST';
            ls.requestUri = '';
            ls.requestBody = String.ValueOf(req.getBody());
            ls.responseBody = res.toString();
            ls.responseStatus = plcStatus;
            ls.responseMessage = '';
            ls.responseStackTrace = String.valueOf(res.getStatusCode());
            ls.recordUrl = '';
            Id plcId = Plc_LogHelper.logCall(ls); //francesca.ribezzi 26/09/19 - F2WAVE2-189 - logCall returns the plc id
            //francesca.ribezzi 26/09/19 - F2WAVE2-189 - updating the new plcLog:
     	    OB_Utility.updateLogRequestOrderIdOnPlcLog(plcId, currentOrder.Id);   
            //michele.lubrano@accenture.com 28-05-2019 - END
        }
    }

    //@future //enrico.purificato 25/11/2019 PERF F1
    global static void createAsset(String orderId, String mainProcessStatus){
       //enrico.purificato 25/11/2019 PERF F1 START
       Database.executeBatch(new OB_Order2Asset(orderId,mainProcessStatus));
       //enrico.purificato 25/11/2019 PERF F1 START
    }
//elena.preteni 9/2/19 central share objects
    global static void createShare (Map<String, Object> bankAccountMap, NE__Order_Header__c orh, NE__Service_Point__c sp, Account acc,Boolean isCommunityUser){

        system.debug('orh'+orh);
        system.debug('acc'+acc);
        system.debug('sp'+sp);
        String userRoleId       = null;
        List<Group> grp         = new List<Group>();
        // Boolean isCommunityUser = (Boolean) data.get('isCommunityUser');
        if (isCommunityUser)
        {
            userRoleId          = UserInfo.getUserRoleId();
            grp                 = [SELECT Id,Name,RelatedId,Type FROM Group WHERE RelatedId=: UserInfo.getUserRoleId() AND Type='RoleAndSubordinates'];
        }
        else
        {
            //  START   micol.ferrari 11/12/2018
            //  QUERY ON USER ROLE
            String orderABI             = (String) bankAccountMap.get('OB_ABI__c');
            List<Account> listOfBanks   = [SELECT Name FROM Account WHERE OB_ABI__c=: orderABI LIMIT 1];
            if (!listOfBanks.isEmpty())
            {
                String userRoleName         = listOfBanks.get(0).Name+' Partner User';
                List<UserRole> userRoles    = [SELECT Id,Name FROM UserRole WHERE Name =: userRoleName];
                if (!userRoles.isEmpty())
                {
                    userRoleId          = userRoles.get(0).Id;
                    //  RETRIEVE GROUPS QUEUE
                    grp                 = [SELECT Id,Name,RelatedId,Type FROM Group WHERE RelatedId=: userRoles.get(0).Id AND Type='RoleAndSubordinates'];
                }
            }
            //  END     micol.ferrari 11/12/2018
        }
        if (!grp.isEmpty())
        {
            // ACCOUNTSHARE
            system.debug('acc!=null'+(acc!=null));
            if(acc!=null){
                OB_UtilityCallingServices.shareAccount(acc,  grp);
            }

            //  SERVICEPOINTSHARE
            system.debug('sp!=null'+(sp!=null));
            if(sp!=null){
                OB_UtilityCallingServices.shareServicePoint(sp,grp);
            }

            //  ORDERHEADERSHARE
            system.debug('orh!=null'+(orh!=null));
            if(orh!=null){
                OB_UtilityCallingServices.shareOrderHeader(orh,grp);
            }
        }
    }

    global static void shareAccount(Account acc, List<Group> grp){
        List<AccountShare> listOfAccountShares = new List<AccountShare>();

        listOfAccountShares = [ SELECT AccountAccessLevel,AccountId,CaseAccessLevel,ContactAccessLevel,Id,IsDeleted,LastModifiedById,LastModifiedDate,OpportunityAccessLevel,RowCause,UserOrGroupId
                                FROM AccountShare
                                WHERE AccountId =: acc.Id AND UserOrGroupId =:  grp.get(0).Id];
        system.debug('listOfAccountShares '+listOfAccountShares);
        if (listOfAccountShares.isEmpty())
        {
            AccountShare contextAccountShare            = new AccountShare();
            contextAccountShare.AccountId               = acc.Id;
            contextAccountShare.UserOrGroupId           = grp.get(0).Id;
            contextAccountShare.AccountAccessLevel      = 'Edit';
            contextAccountShare.CaseAccessLevel         = 'Edit';
            contextAccountShare.OpportunityAccessLevel  = 'Edit';
            insert contextAccountShare;
        }
    }

    global static void shareAsset(List<Asset> assetList){
        String userRoleId       = null;
        List<Group> grp         = new List<Group>();
        List<AssetShare> listOfAssetShares = new List<AssetShare>();
        List<Id> idlist = new List<Id>();

        // = [SELECT id FROM Asset WHERE NE__Order_Config__c =: config ];

        userRoleId          = UserInfo.getUserRoleId();
        grp                 = [SELECT Id,Name,RelatedId,Type FROM Group WHERE RelatedId=: UserInfo.getUserRoleId() AND Type='RoleAndSubordinates'];

        if(grp == null || grp.size() == 0){
            return;
        }
        for(Asset ass : assetList){
            idList.add(ass.id);
        }
        Map<Id,Asset> mapAsset = new Map<Id,Asset>(assetList);
        listOfAssetShares = [SELECT AssetAccessLevel,AssetId,Id,IsDeleted,LastModifiedById,LastModifiedDate,RowCause,UserOrGroupId
                                FROM AssetShare
                                WHERE AssetId IN :idList AND UserOrGroupId =:  grp.get(0).Id];
        system.debug('listOfAssetShares '+listOfAssetShares);
        if(!listOfAssetShares.isEmpty()){
            for(AssetShare ashare : listOfAssetShares){
                if(mapAsset.containsKey(ashare.assetId)){
                    Asset tmp = mapAsset.remove(ashare.assetId);
                }
            }
        }
        if (mapAsset != null && !mapAsset.isEmpty())
        {
            List<AssetShare> assetShareList = new List<assetShare>();
            for(Id assetId :  mapAsset.keyset()){
                AssetShare contextAssetShare            = new AssetShare();
                contextAssetShare.AssetId               = assetId;
                contextAssetShare.UserOrGroupId         = grp.get(0).Id;
                contextAssetShare.AssetAccessLevel  = 'Edit';
                assetShareList.add(contextAssetShare);

            }

            insert assetShareList;
        }
    }

    /*****************************************************************
    Purpose:  wrapper to call asset share for making it Future
    --------
    VERSION  AUTHOR             DATE           DETAIL          Description
    1.0      elena.preteni    19/07/2019       Created         CSR: wrapper to call asset share for making it Future
    *****************************************************************/
    @future
    global static void shareAssetWrapper (String assetListString){
        List<Asset> assetList = (List<Asset>) JSON.deserialize(assetListString,List<Asset>.class);
        shareAsset(assetList);
    }

    global  static void shareServicePoint(NE__Service_Point__c newPv, List<Group> grp){
        //  SERVICEPOINTSHARE
        List<NE__Service_Point__Share> listOfServicePointShares = new List<NE__Service_Point__Share>();

        listOfServicePointShares = [SELECT AccessLevel,Id,IsDeleted,LastModifiedById,LastModifiedDate,ParentId,RowCause,UserOrGroupId
                                    FROM NE__Service_Point__Share
                                    WHERE ParentId =: newPv.Id AND UserOrGroupId =:  grp.get(0).Id];
        system.debug('listOfServicePointShares '+listOfServicePointShares);
        if (listOfServicePointShares.isEmpty())
        {
            NE__Service_Point__Share contextServicePointShare   = new NE__Service_Point__Share();
            contextServicePointShare.ParentId                   = newPv.Id;
            contextServicePointShare.UserOrGroupId              = grp.get(0).Id;
            contextServicePointShare.AccessLevel                = 'Edit';
            insert contextServicePointShare;
        }
    }

    global static void shareOrderHeader(NE__Order_Header__c orderHeader, List<Group> grp){
        //  ORDERHEADERSHARE
        List<NE__Order_Header__Share> listOfOrderHeaderShares = new List<NE__Order_Header__Share>();

        listOfOrderHeaderShares = [SELECT AccessLevel,Id,IsDeleted,LastModifiedById,LastModifiedDate,ParentId,RowCause,UserOrGroupId
                                    FROM NE__Order_Header__Share
                                    WHERE ParentId =: orderHeader.Id AND UserOrGroupId =:  grp.get(0).Id];
        system.debug('listOfOrderHeaderShares '+listOfOrderHeaderShares);
        if (listOfOrderHeaderShares.isEmpty())
        {
            NE__Order_Header__Share contextOrderHeaderShare     = new NE__Order_Header__Share();
            contextOrderHeaderShare.ParentId                    = orderHeader.Id;
            contextOrderHeaderShare.UserOrGroupId               = grp.get(0).Id;
            contextOrderHeaderShare.AccessLevel                 = 'Edit';
            insert contextOrderHeaderShare;
        }
    }
    //elena.preteni 9/2/19 central share objects

        /*------------------------------------------------------------
    Author:         Elena Preteni
    Company:        Accenture Tecnology
    Description:
    Date:           29/04/2019
   ------------------------------------------------------------*/
    @future(callout=true)
    global static void callService(String url, String method,String body){
        system.debug('callService url'+url);
        system.debug('callService body'+body);
        String environment = !Test.isRunningTest() ? OB_UtilityCallingServices.returnCurrentOrg() : 'DEV1';
        OB_Integration_Configuration__c intConfig = OB_Integration_Configuration__c.getValues(environment);
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod(method);
        req.setBody(body);
        String token = checkToken();
        req.setHeader( OB_UtilityConstants.AUTH, OB_UtilityConstants.PREFIX+token);

        req.setHeader(OB_UtilityConstants.CONTENT_TYPE,OB_UtilityConstants.APPLICATION_JSON); //Simone Misani 11/07/2019 call Mip Coba

        if(intConfig.OB_CAsigned_name__c!=null){
            req.setClientCertificateName(intConfig.OB_CAsigned_name__c);
        }
        System.debug('Request to service contract: ' + req);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
        saveToken(token,String.valueof(timestamp));
		//START elena.preteni@accenture.com 31/5/2019 Add PLC-LOG record
		Plc_LogHelper.LogStructure ls = new Plc_LogHelper.LogStructure();
		ls.httpMethod = method;
		ls.requestUri = url;
		ls.requestHeader =OB_UtilityConstants.AUTH+','+ OB_UtilityConstants.PREFIX+token;
        ls.requestHeader = OB_UtilityConstants.CONTENT_TYPE+','+OB_UtilityConstants.APPLICATION_JSON;
		ls.requestBody=body;
		ls.responseBody  = res.getBody();
		ls.responseStatus  = 'S';
		ls.responseMessage  = res.getStatus();
		ls.responseStackTrace  = String.valueOF(res.getStatusCode());
		Id plcId =Plc_LogHelper.logCall(ls);//francesca.ribezzi 26/09/19 - F2WAVE2-189 - logCall returns the plc id
        //END elena.preteni@accenture.com 31/5/2019 Add PLC-LOG record
        //START francesca.ribezzi 26/09/19 - F2WAVE2-189 - updating the new plcLog:
        OB_Maintenance_Serialize_Anagrafica.SerializeWrapperMerchant responseWrapper = ( OB_Maintenance_Serialize_Anagrafica.SerializeWrapperMerchant ) JSON.deserialize( body, OB_Maintenance_Serialize_Anagrafica.SerializeWrapperMerchant.class );
     	OB_Utility.updateLogRequestOrderIdOnPlcLog(plcId,  responseWrapper.requestId);   
        //END francesca.ribezzi 26/09/19 - F2WAVE2-189

    }



	/*****************************************************************
    Purpose:  checks if the current configuration needs to be approved by operation
    --------
    VERSION  AUTHOR             DATE           DETAIL          Description
    1.0      michele.lubrano    07/05/2019     Created         CSR:
    *****************************************************************/
	global static Boolean checkOperation(NE__Order__c configuration,List<NE__OrderItem__c> itemsList ){
		Boolean neddsOperationApproval = false;
		List<OB_EnablementsForOperation__mdt> enablementsList = [SELECT Id,OB_Enablement__c,OB_NeedVerification__c FROM OB_EnablementsForOperation__mdt WHERE OB_NeedVerification__c = true ];
		for(NE__OrderItem__c item : itemsList){
			for(OB_EnablementsForOperation__mdt enablement : enablementsList){
				if(item.NE__ProdId__r.Name.equalsIgnoreCase(enablement.OB_Enablement__c) && item.NE__Action__c.equalsIgnoreCase('Add') && item.NE__Parent_Order_Item__c == null){
					neddsOperationApproval = true;
					break;
				}
			}
		}
		return neddsOperationApproval;
	}
	//michele.lubrano@accenture.com 2019/05/07 END

	/*
	* Author : Giovanni Spinelli
	* Date : 16/05/2019
	* Description : get token and callout.
	*/
        
	public static Map<String , String> getTokenJWEMethod(string documentName){
		//get current user
		Map<String , String> returnMap = New Map<String , String>();
		String userId = UserInfo.getUserId();
		System.debug('userId is: ' + userId);
		//I need user Id
		User currentUser = [SELECT id, name
							FROM user
							WHERE  id =: userId
							LIMIT 1];
		
		HttpRequest req = new HttpRequest();
		req.setEndpoint('callout:OB_GetTokenJWE');
		req.setMethod('POST');
		req.setBody('{"documentFileName":"'+documentName+'","username":"'+currentUser.name+'"}'); 
		String token = OB_UtilityCallingServices.checkToken();
		System.debug('OAUTH: '+OB_UtilityConstants.AUTH );
		System.debug('PREFIX: '+OB_UtilityConstants.PREFIX );
		System.debug('Token: '+token );
		req.setHeader( OB_UtilityConstants.AUTH, OB_UtilityConstants.PREFIX+token);
		req.setHeader('Content-Type','application/json');
		System.debug('Request to service contract: ' + req);
		Http http = new Http();
		HTTPResponse res = http.send(req);
		System.debug('RESPONSE BODY: '+res.getBody());
		String jewToken = res.getBody();
		String convertedToken =    jewToken.split(':')[1].replace('"','').replace('}' , '') ;
		System.debug('BODY RESPONSE: ' +   convertedToken );
		//get FEurl
		String FEurl = OB_UtilityCallingServices.getFEurl();
		System.debug('feURL: ' +FEurl );
		returnMap.put('jewToken' , convertedToken);
		returnMap.put('FEurl' , FEurl);
		returnMap.put('documentId' , documentName);
		return returnMap;
	}
	/*
        * Author : Giovanni Spinelli
        * Date : 16/05/2019
        * Description : get feurl from custom setting.
        */
        private static String getFEurl (){
        String environment  =   null;
        String FEurl        =   null;
        OB_Integration_Configuration__c intConfig = new OB_Integration_Configuration__c();
        try{
            environment = !Test.isRunningTest() ? OB_UtilityCallingServices.returnCurrentOrg() : 'DEV1';
            intConfig = OB_Integration_Configuration__c.getValues(environment);
            FEurl = intConfig.OB_FEUrl__c;
        }
        catch(Exception ecc){
            System.debug('Generic Error: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
        }
        
        return FEurl ;
      }
        /*
        * Author : davide.franzini
        * Date : 27/06/2019
        * Description : check if is Community User
        */
        public static Boolean isCommunityUser(){
            List<User> listOfUsers = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId() AND ContactId <> null];
            return listOfUsers.size()>0;
        }
}