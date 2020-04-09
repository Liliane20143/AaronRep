global without sharing class OB_FlowControlUtility implements bit2flow.OverwriteButtonsIF, bit2flow.dynWizardsIFExt
{
    //GIOVANNI SPINELLI - 16/01/2019 - RETRIEVE FLOWS NAME AND STEP NUMBER FROM CUSTOM META DATA

    //  START enrico.purificato 12/02/2019
    @TestVisible
    private static Boolean isNumeric( String s )
    {
        Boolean ReturnValue;
        try
        {
            Decimal.valueOf( s );
            ReturnValue = TRUE;
        } catch ( Exception e )
        {
            ReturnValue = FALSE;
        }
        return ReturnValue;
    }
    //  END enrico.purificato 12/02/2019

    @TestVisible
    private static String getStepMapping( String flowName, String stepName )
    {
        String stepNumber = null;
        try
        {
            String queryConfigurationInformation = 'SELECT Id,MasterLabel,Label,QualifiedApiName,OB_String_Value__c,OB_String_Value_2__c FROM OB_ConfigurationInformation__mdt WHERE QualifiedApiName LIKE \'%' + 'Mapping' + '%\' AND  OB_String_Value__c LIKE \'%' + flowName + '%\'' ;
            System.debug( 'queryConfigurationInformation: ' + queryConfigurationInformation );
            List<OB_ConfigurationInformation__mdt> listOfConfigurationInformations = Database.Query( queryConfigurationInformation );
            System.debug( 'listOfConfigurationInformations: ' + listOfConfigurationInformations );
            if ( !listOfConfigurationInformations.isEmpty( ) )
            {
                OB_ConfigurationInformation__mdt setConfInfSplit = listOfConfigurationInformations.get( 0 );
                System.debug( 'setConfInfSplit: ' + setConfInfSplit );
                String toSplit = setConfInfSplit.OB_String_Value_2__c;
                System.debug( 'toSplit: ' + toSplit );
                //System.debug('toSplit method: ' + toSplit.split('&#124;&#124;'));
                String[] listaNameNumber = toSplit.split( ';' ); //&#124 is ||
                System.debug( 'listaNameNumber: ' + listaNameNumber );
                Map<String, String> mapSplitted = new Map<String, String>( );
                for ( String s : listaNameNumber )
                {

                    mapSplitted.put( s.split( '-' ).get( 0 ), s.split( '-' ).get( 1 ) );
                    System.debug( 'KEY: : ' + s.split( '-' ).get( 0 ) );//STEP NAME
                    System.debug( 'VALUE: ' + s.split( '-' ).get( 1 ) );//STEP NUMBER
                }

                if ( !mapSplitted.isEmpty( ) && mapSplitted.containsKey( stepName ) )
                {
                    stepNumber = mapSplitted.get( stepName );
                }
                System.debug( 'stepNumber: ' + stepNumber );
            }
        } catch ( Exception ecc )
        {
            //NEXI-178 Zuzanna Urban <z.urban@accenture.com>, 24/07/2019 start, add a log level
            System.debug( LoggingLevel.ERROR, 'Generic Error getStepMapping: ' + ecc.getMessage( ) + ' at line: ' + ecc.getLineNumber( ) + ' stack trace: ' + ecc.getStackTraceString( ) );
            //NEXI-178 Zuzanna Urban <z.urban@accenture.com>, 24/07/2019 stop, add a log level
        }
        return stepNumber;
    }

    /*******************************************************************************
    Purpose:  Method check if cab was properly searched on first step of flow
    Parameters: Map<String, Object> inOutData entire bit2flow map
    Returns: Boolean true-there is an error, false - check pass

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       03/04/2019      Created         RP_015
    ********************************************************************************/
    private static Boolean checkCab( Map<String, Object> inOutData )
    {
        Map<String, Object> bankAccountMap = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( inOutData.get( 'bank' ) ) );
        Map<String, Object> userAbiMap = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( inOutData.get( 'user' ) ) );
        String cabForTest = userAbiMap.get( 'OB_CAB__c' ) != null ? ( String ) userAbiMap.get( 'OB_CAB__c' ) : '';
        if ( inOutData.get( 'correctCAB' ) == null || !( Boolean ) inOutData.get( 'correctCAB' ) )
        {
            inOutData.put( 'cabError', true );
            inOutData.put( 'cabErrorMessage', Label.OB_InvalidCAB );
            return true;
        }
        return false;
    }

    //Method to save Account, Service Point, Order Header, Configuration objects on the step:  Identify Company
    @AuraEnabled
    global static bit2flow.DynamicWizardStepWrapper identifyCompany( String step, map<String, Object> data, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, String targetObjectKey, String method, bit2flow.DynamicWizardWrapper wizardWrapper )
    {

        System.debug( 'Complex data in identifyCompany method' + Json.serialize( data ) );
        System.debug( 'Configuration.OB_GT__c ::::' + data.get( 'Configuration' ) );
        System.debug( 'GT ::::' + data.get( 'GT' ) );
        System.debug( 'pv datamap first method' + JSON.Serialize( data.get( 'pv' ) ) );
        System.debug( 'merchant datamap first method' + JSON.Serialize( data.get( 'merchant' ) ) );
        System.debug( 'data end method identifyCompany begin' + JSON.serialize( data ) );
        System.debug( 'error family :' + JSON.serialize( data.get( 'errorFamily' ) ) );
        Object bankAccount = data.get( 'bank' );
        Map<String, Object> bankAccountMap = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( bankAccount ) );
        System.debug( 'bankAccountMap.OB_ABI__c :' + bankAccountMap.get( 'OB_ABI__c' ) );
        //START - elena.preteni 17/07/2019 F3 ABI CAB Selection missing ABI message
        bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper( );
        OB_FlowCustomError errorObject = new OB_FlowCustomError( );
        Boolean goToCart = true;
        Boolean isError = false;
        //END - elena.preteni 17/07/2019 F3 ABI CAB Selection missing ABI message
        if ( bankAccountMap.get( 'OB_ABI__c' ) != null )
        {
            system.debug( 'ABI not null' );
            Object userAbi = data.get( 'user' );
            Map<String, Object> userAbiMap = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( userAbi ) );
            System.debug( 'userAbiMap: '+userAbiMap);
            System.debug( 'userAbi.OB_CAB__c :' + userAbiMap.get( 'OB_CAB__c' ) );
            //START - elena.preteni 17/07/2019 F3 ABI CAB Selection missing nodes bankProfile and actualBank
            if ( Boolean.valueOf( data.get( 'isOperation' ) ) )
            {                           //francesca.ribezzi 15/11/19 - PROD-96 - adding record type filter - bank
                List<Account> bankAcc = [ SELECT id FROM Account WHERE OB_ABI__c = :String.valueOf( bankAccountMap.get( 'OB_ABI__c' ) ) AND RecordType.DeveloperName = :OB_UtilityConstants.BANK LIMIT 1 ];
                String bankId = !bankAcc.isEmpty( ) ? bankAcc.get( 0 ).Id : '';
                data.put( 'actualBank', bankId );
                List<OB_Bank_Profile__c> bankProfile = new List<OB_Bank_Profile__c>( );
                bankProfile =
                [
                        SELECT id,
                                OB_Business_Model_Acquiring__c,
                                OB_Bank__c,
                                OB_GT__c,
                                OB_Business_Model_POS__c,
                                OB_Circuit__c,
                                OB_Other_Acquirer__c,
                                OB_Service_Type__c,
                                OB_Apm_Circuit__c,
                                OB_Vas__c,
                                OB_SettlementType__c,
                                OB_AccountHolder__c,
                                OB_Applicant_RAC_Code_SIA__c,
                                OB_Terminal_Id_Generator__c,
                                OB_NeedBIO__c,
                                OB_NDG__c
                        FROM OB_Bank_Profile__c
                        WHERE OB_Bank__c = :bankId
                        LIMIT 1
                ];
                if ( !bankProfile.isEmpty( ) )
                {
                    data.put( 'bankProfile', bankProfile.get( 0 ).getPopulatedFieldsAsMap( ) );//NEXI-276 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 27/08/2019
                }

                data.put( 'isSetup', true );
                userAbiMap.put( 'OB_CAB__c', '99999' );
                data.put( 'user', userAbiMap );

            }
            //END - elena.preteni 17/07/2019 F3 ABI CAB Selection missing nodes bankProfile and actualBank
            // Get Object bankProfile
            Object orderHeaderOBJ = data.get( 'OrderHeader' );
            Object bankProfile = data.get( 'bankProfile' );
            Map<String, Object> bankProfiletMap = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( bankProfile ) );
            Map<String, Object> orderHeaderMap = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( orderHeaderOBJ ) );
            System.debug( 'bankProfile:' + JSON.serialize( bankProfile ) );
            System.debug( 'bankProfile.OB_Business_Model_Acquiring__c :' + JSON.serialize( bankProfiletMap ) );
            //set all the temporary datamap object, we created before, to null when we use the method because we dont want the temporary objects to be used when we press next again in the same session
            data.put( 'merchant_temp', null );
            data.put( 'pv_temp', null );
            data.put( 'OrderHeader_temp', null );
            data.put( 'Configuration_temp', null );
            data.put( 'pvAlreadyExist', false );


            errorObject.message = '';
            errorObject.severity = 'SUCCESS';


            isError = checkCab( data );//RP_015 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 02.04.2019 add cab check Start
            try
            {
                String MCCL2 = ( String ) bit2flow.B2FUtils.getJSONValue( data, 'order', 'OB_MCC__c' );
                String MCCL3 = ( String ) bit2flow.B2FUtils.getJSONValue( data, 'order2', 'OB_MCC__c' );
                //GIOVANNI SPINELLI 06/08/2018
                //METHOD TO CHECK INPUT WHEN I CLICK NEXT BUTTON****START
                /*IT USED A CUSTOM LABEL VALUE TO ACTIVATE THIS METHOD
                -->IT NEED TO DISACTIVATE THIS METHOD TO ACCELERATE THE PASSAGE AT SECOND STEP*/
                String switchTest = Label.SwitchToTest;
                //START - elena.preteni R1F3 - 16 check typology per PO118
                Boolean isVirtuale = false;
                //END - elena.preteni R1F3 - 16 check typology per PO118
                if ( switchTest == 'yes' )
                {
                    System.debug( 'map from method--> ' + OB_MandatoryFormalCheck.inputCheck( data, 'identifyCompany' ) );
                    System.debug( 'Size Map check formal data in identifyCompany: ' + ( OB_MandatoryFormalCheck.inputCheck( data, 'identifyCompany' ) ).size( ) );
                    data.put( 'setRedBorder', false );
                    if ( ( OB_MandatoryFormalCheck.inputCheck( data, 'identifyCompany' ) ).size( ) >= 1 )
                    {
                        System.debug( 'MAP not empty' );
                        data.put( 'checkMapValues', OB_MandatoryFormalCheck.inputCheck( data, 'identifyCompany' ) );
                        data.put( 'setRedBorder', true );
                        isError = true;
                        System.debug( 'setRedBorder ::::' + data.get( 'setRedBorder' ) );
                    }

                    /******Giovanni.Spinelli START 18/09/2018 ****************************************/
                    // Method to check formality of custom field
                    Object errorFamilyObject = data.get( 'errorFamily' );
                    Map<String, Object> mappaErrorFamily = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( errorFamilyObject ) );
                    if ( mappaErrorFamily != null )
                    {
                        for ( String key : mappaErrorFamily.keySet( ) )
                        {
                            if ( ( Boolean ) ( mappaErrorFamily.get( key ) ) )
                            {
                                errorObject.message = 'Test Phone';
                                errorObject.severity = 'ERROR';
                            }
                        }
                    }

                    Object errorEEMapObject = data.get( 'errorEEMap' );
                    Map<String, Object> mappaErrorEE = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( errorEEMapObject ) );
                    if ( mappaErrorEE != null )
                    {
                        for ( String key : mappaErrorEE.keySet( ) )
                        {
                            if ( ( Boolean ) ( mappaErrorEE.get( key ) ) )
                            {
                                isError = true;
                            }
                        }
                    }

                    String shopSign = ( String ) data.get( 'shopSign' );
                    if ( String.IsBlank( shopSign ) )
                    {
                        isError = true;
                        data.put( 'isShopSignBlank', true );
                        data.put( 'setRedBorder', true );
                    }
                    else
                    {
                        data.put( 'isShopSignBlank', false );

                    }

                    if ( String.IsBlank( MCCL2 ) )
                    {
                        isError = true;
                        data.put( 'isMCCL2Blank', true );
                        data.put( 'setRedBorder', true );
                    }
                    else
                    {
                        data.put( 'isMCCL2Blank', false );
                    }
                    Boolean isL3Required = ( Boolean ) data.get( 'isL3Required' );
                    if ( isL3Required )
                    {
                        if ( String.IsBlank( MCCL3 ) )
                        {
                            isError = true;
                            data.put( 'isMCCL3Blank', true );
                            data.put( 'setRedBorder', true );
                        }
                        else
                        {
                            data.put( 'isMCCL3Blank', false );
                        }
                    }
                    //NEXI-116 Wojciech Szuba <wojciech.szuba@accenture.com>, 27/06/2019, START
                    Object merchantObject = data.get( OB_UtilityConstants.FLOW_MERCHANT );
                    Map<String, Object> mapMerchantObjectParameters = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( merchantObject ) );
                    String merchantVatDescription = '';
                    if ( mapMerchantObjectParameters.get( 'OB_DescriptionVATNotPresent__c' ) != null )
                    {
                        merchantVatDescription = ( String ) mapMerchantObjectParameters.get( 'OB_DescriptionVATNotPresent__c' );
                    }
                    if ( mapMerchantObjectParameters.get( 'OB_VAT_Not_Present__c' ) == true && OB_UtilityConstants.B_AND_B.equalsIgnoreCase( merchantVatDescription ) )
                    {
                        Object orderObject = data.get( OB_UtilityConstants.FLOW_ORDER );
                        Map<String, Object> mapOrderObjectParameters = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( orderObject ) );
                        String orderAlberghiCode = '';
                        for ( String key : mapOrderObjectParameters.keySet( ) )
                        {
                            if ( mapOrderObjectParameters.get( key ) != null )
                            {
                                orderAlberghiCode = ( String ) mapOrderObjectParameters.get( key );
                            }
                            if ( key.equalsIgnoreCase( 'OB_MCC__c' ) && !( OB_UtilityConstants.ALBERGHI_CODE.equalsIgnoreCase( orderAlberghiCode ) ) )
                            {
                                data.put( 'isMCCL2Wrong', true );
                                data.put( 'setRedBorder', true );
                                errorObject.message = Label.OB_WrongMCCL2NonAlberghi;
                                errorObject.severity = 'ERROR';
                                isError = true;
                            }
                        }
                    }
                    //NEXI-116 Wojciech Szuba <wojciech.szuba@accenture.com>, 27/06/2019, STOP
                    
                    //NEXI-280 Kinga Fornal <kinga.fornal@accenture.com>, 28/08/2019, START
                    if ( data.get( 'pv' ) != null )
                    {
                        Map<String, Object> newServicePoint = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( data.get( 'pv' ) ) );
                        //START - elena.preteni R1F3 - 16 check typology per PO118
                        if(String.valueOf(newServicePoint.get( 'OB_Typology__c' )) == 'Virtuale'){
                            isVirtuale=true;
                        }
                        //END - elena.preteni R1F3 - 16 check typology per PO118
                        if ( mapMerchantObjectParameters != null && mapMerchantObjectParameters.get( 'OB_VAT_Not_Present__c' ) == true &&
                                OB_UtilityConstants.LIVIGNO.equalsIgnoreCase( merchantVatDescription ) &&
                                !OB_UtilityConstants.LIVIGNO.equalsIgnoreCase( ( String ) newServicePoint.get( 'NE__City__c' ) ) )
                        {
                            data.put( 'isCityWrong', true );
                            data.put( 'setRedBorder', true );
                            errorObject.message = Label.OB_LIVIGNO_CHECK_ERROR;
                            errorObject.severity = 'ERROR';
                            isError = true;
                        }
                    }
                    //NEXI-280 Kinga Fornal <kinga.fornal@accenture.com>, 28/08/2019, STOP


                }
                /******Giovanni.Spinelli END 18/09/2018 ****************************************/
                //METHOD TO CHECK INPUT WHEN I CLICK NEXT BUTTON****END
                system.debug( 'external account: ' + data.get( 'ExternalAccount' ) );
                String extSourceString = JSON.serialize( data.get( 'ExternalAccount' ) );
                List<ExternalSourceMapping__c> extSourceMapList = ( List<ExternalSourceMapping__c> ) JSON.deserialize( extSourceString, List<ExternalSourceMapping__c>.class );
                List<String> rtDevNamesMerch = new List<String> {OB_UtilityConstants.MASTER_MERCHANT, OB_UtilityConstants.MERCHANTRT};
                List<String> rtDevNamesServicePoint = new List<String> {OB_UtilityConstants.SERVICE_POINT_FISICO, OB_UtilityConstants.SERVICE_POINT_VIRTUALE};
                List<String> rtDevNamesOrder = new List<String> {OB_UtilityConstants.ORDER};
                Map<String, RecordType> RTNameIdAcc = ( recordTypeQuery( 'Account', rtDevNamesMerch ) );
                Map<String, RecordType> RTNameIdOrder = ( recordTypeQuery( 'NE__Order__c', rtDevNamesOrder ) );
                Map<String, RecordType> RTNameIdServicePoint = ( recordTypeQuery( 'NE__Service_Point__c', rtDevNamesServicePoint ) );
                system.debug( 'RTNameIdAcc' + RTNameIdAcc.get( OB_UtilityConstants.MERCHANTRT ) );
                //START francesca.ribezzi 20/07/19 - WN-133 - community setup -> bankOwner node happens to be null
                Id bankOwnerId;
                if ( data.get( 'bankOwner' ) == null )
                {
                    bankOwnerId = ( Id ) bankProfiletMap.get( 'OB_Bank__c' );
                }
                else
                {
                    bankOwnerId = ( Id ) data.get( 'bankOwner' );
                }
                Account accFromService = checkAccountSFDC( ( Account ) JSON.deserialize( JSON.serialize( data.get( 'merchant' ) ), Account.class ), bankOwnerId );
                //END francesca.ribezzi 20/07/19 - WN-133
                //if the objects id are blank, then we will have an error while inserting those object.
                //To fix this we call a method to set ids from blank to null.
                setJSONNullFields( data, 'pv', 'Id' );
                setJSONNullFields( data, 'OrderHeader', 'Id' );
                setJSONNullFields( data, 'Configuration', 'Id' );
                //Retrieve Service Point from the datamap
                //giovanni spinelli 12/02/2019 method to convert string to time - start
                String openingTime = null;
                String endingTime = null;
                String breakStartTime = null;
                String breakEndTime = null;
                Object servicePointObject = data.get( 'pv_temp' );
                Map<String, Object> spMap = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( data.get( 'pv_temp' ) ) );

                Object openingTimeTmp = spMap.get( 'OB_Opening_Time__c' );
                Object endingTimeTmp = spMap.get( 'OB_Ending_Time__c' );
                Object breakStartTimeTmp = spMap.get( 'OB_Break_Start_Time__c' );
                Object breakEndTimeTmp = spMap.get( 'OB_Break_End_Time__c' );
                System.debug( 'data.keySet(): ' + JSON.serialize( data.keySet( ) ) );

                if ( !String.isBlank( String.valueOf( openingTimeTmp ) ) )
                {
                    System.debug( 'IF OPENING' );
                    openingTime = ( String ) ( bit2flow.B2FUtils.getJSONValue( data, 'pv_temp', 'OB_Opening_Time__c' ) );
                    bit2flow.B2FUtils.setJSONValue( data, 'pv_temp', 'OB_Opening_Time__c', null );
                }
                if ( !String.isBlank( String.valueOf( endingTimeTmp ) ) )
                {
                    endingTime = ( String ) ( bit2flow.B2FUtils.getJSONValue( data, 'pv_temp', 'OB_Ending_Time__c' ) );
                    bit2flow.B2FUtils.setJSONValue( data, 'pv_temp', 'OB_Ending_Time__c', null );
                }
                if ( !String.isBlank( String.valueOf( breakStartTimeTmp ) ) )
                {
                    System.debug( 'IF START BREAK' );
                    breakStartTime = ( String ) ( bit2flow.B2FUtils.getJSONValue( data, 'pv_temp', 'OB_Break_Start_Time__c' ) );
                    bit2flow.B2FUtils.setJSONValue( data, 'pv_temp', 'OB_Break_Start_Time__c', null );
                }
                if ( !String.isBlank( String.valueOf( breakEndTimeTmp ) ) )
                {
                    breakEndTime = ( String ) ( bit2flow.B2FUtils.getJSONValue( data, 'pv_temp', 'OB_Break_End_Time__c' ) );
                    bit2flow.B2FUtils.setJSONValue( data, 'pv_temp', 'OB_Break_End_Time__c', null );
                }

                String pvString = JSON.serialize( data.get( 'pv_temp' ) );
                system.debug( 'pvString' + pvString );
                NE__Service_Point__c newPv = ( NE__Service_Point__c ) JSON.deserialize( pvString, NE__Service_Point__c.class );
                //convert time from js in time for sfdc
                if ( !isNumeric( openingTime ) )
                {
                    openingTime = '';
                }
                if ( !String.IsBlank( openingTime ) )
                {
                    newPv.OB_Opening_Time__c = ParseTime( openingTime );
                }
                if ( !isNumeric( endingTime ) )
                {
                    endingTime = '';
                }
                if ( !String.IsBlank( endingTime ) )
                {
                    newPv.OB_Ending_Time__c = ParseTime( endingTime );
                }
                if ( !isNumeric( breakStartTime ) )
                {
                    breakStartTime = '';
                }
                if ( !String.IsBlank( breakStartTime ) )
                {
                    newPv.OB_Break_Start_Time__c = ParseTime( breakStartTime );
                }
                if ( !isNumeric( breakEndTime ) )
                {
                    breakEndTime = '';
                }
                System.debug( 'PV AFTER SET TIME: ' + newPv );
                if ( !String.IsBlank( breakEndTime ) )
                {
                    newPv.OB_Break_End_Time__c = ParseTime( breakEndTime );
                }

                //put old value of time in obj to visualize them in servicepoint step
                if ( !String.isBlank( String.valueOf( openingTimeTmp ) ) )
                {
                    bit2flow.B2FUtils.setJSONValue( data, 'pv_temp', 'OB_Opening_Time__c', openingTime );
                }
                if ( !String.isBlank( String.valueOf( endingTimeTmp ) ) )
                {
                    bit2flow.B2FUtils.setJSONValue( data, 'pv_temp', 'OB_Ending_Time__c', endingTime );
                }
                if ( !String.isBlank( String.valueOf( breakStartTimeTmp ) ) )
                {
                    bit2flow.B2FUtils.setJSONValue( data, 'pv_temp', 'OB_Break_Start_Time__c', breakStartTime );
                }
                if ( !String.isBlank( String.valueOf( breakEndTimeTmp ) ) )
                {
                    bit2flow.B2FUtils.setJSONValue( data, 'pv_temp', 'OB_Break_End_Time__c', breakEndTime );
                }
                //giovanni spinelli 12/02/2019 method to convert string to time - end
                //Retrieve Order Header from the datamap
                String orderString = JSON.serialize( data.get( 'OrderHeader_temp' ) );
                System.debug( ' orderString string :' + orderString );
                NE__Order_Header__c orderHeader = ( NE__Order_Header__c ) JSON.deserialize( orderString, NE__Order_Header__c.class );

                //Retrieve Configuration from the datamap
                String configurationString = JSON.serialize( data.get( 'Configuration_temp' ) );
                NE__Order__c configuration = ( NE__Order__c ) JSON.deserialize( configurationString, NE__Order__c.class );

                if ( String.IsBlank( errorObject.message ) && !isError )
                {
                    if ( String.isBlank( newPv.Id ) && accFromService != null )
                    {
                        Boolean pvAlreadyExist = checkPvSFDC( ( NE__Service_Point__c ) JSON.deserialize( JSON.serialize( data.get( 'pv' ) ), NE__Service_Point__c.class ), accFromService.Id );
                        if ( pvAlreadyExist )
                        {
                            isError = true;
                            data.put( 'pvAlreadyExist', true );
                        }
                    }
                }
                if ( String.IsBlank( errorObject.message ) && !isError )
                {
                    //End check errors
                    //Start insert, update statements

                    if ( accFromService != null )
                    {
                        data.put( 'merchant', accFromService );
                    }

                    setJSONNullFields( data, 'merchant', 'Id' );
                    //Here we use the temporary datamap object with the modifications (Id, Dates from blank to null)
                    //Retrieve account merchant from the datamap, serialize it and deserialize into the object we need
                    String accString = JSON.serialize( data.get( 'merchant_temp' ) );
                    Account acc = ( Account ) JSON.deserialize( accString, Account.class );

                    //ANDREA MORITTU END 23-Jul-19 WN-178 - Fix length of fiscal code
                    if ( !String.isBlank( acc.NE__VAT__c ) )
                    {
                        if ( acc.NE__VAT__c.length( ) == 11 && acc.NE__VAT__c.isNumeric( ) )
                        {
                            isError = false;
                        }
                        else
                        {
                            isError = true;
                        }
                    }
                    //ANDREA MORITTU END 23-Jul-19 WN-178 - Fix length of fiscal code

                    System.debug( ' Account dataMap :' + acc );
                    //davide.franzini - WN-238 - 02/08/2019 - retrieve Gt from BankProfile instead of GT node - START
                    system.debug( '##bankProfiletMap: ' + bankProfiletMap );
                    String GTconcatenation = ( String ) bankProfiletMap.get( 'OB_GT__c' );
                    //davide.franzini - WN-238 - 02/08/2019 - retrieve Gt from BankProfile instead of GT node - END
                    if ( !String.isEmpty( GTconcatenation ) )
                    {
                        List<String> listOfGTs = new List<String>( );
                        listOfGTs = GTconcatenation.split( ';' );
                        System.debug( 'OB_FlowControlUtility.identifyCompany listOfGts: ' + listOfGTs +'	size: '+listOfGTs.size( ) ); // antonio.vatrano 27-10-2019 post production
                        if ( listOfGTs.size( ) > 1 )
                        {
                            goToCart = false;
                        }
                        else if ( listOfGTs.size( ) == 1 )
                        {
                            System.debug('@@@listOfGTs: '+listOfGTs.get( 0 )); // antonio.vatrano 27-10-2019 post production
                            configuration.OB_GT__c = listOfGTs.get( 0 );
                        }
                        else
                        {
                            System.debug('@@@listOfGTs: NOTHING'); // antonio.vatrano 27-10-2019 post production
                        }
                    }
                    //Begin upsert logic for: account (merchant), Service Point, Configuration, Order Header
                    if ( String.isEmpty( acc.Id ) )
                    {
                        //When we create an Account (merchant), you need to specify the account master (NE__Fiscal_code__c is unique for this kind of accounts).
                        Account accM;
                        List<Account> accMaster = [ SELECT Id FROM Account WHERE NE__Fiscal_code__c = :acc.NE__Fiscal_code__c AND RecordType.DeveloperName = :OB_UtilityConstants.MASTER_MERCHANT ];
                        if ( accMaster != null && accMaster.size( ) > 0 )
                            accM = accMaster[ 0 ];
                        //If account master exists populate the lookup from the merchant, if doesn't exist insert it
                        if ( accM == null || ( accM != null && String.IsBlank( accM.Id ) ) )
                        {
                            accM = new Account( );

                            /* START    micol.ferrari 20/10/2018 - MASTER MERCHANT NAME POPULATED WITH THE FISCAL CODE */
                            accM.Name = acc.NE__Fiscal_code__c;
                            /* END      micol.ferrari 20/10/2018 - MASTER MERCHANT NAME POPULATED WITH THE FISCAL CODE */

                            accM.NE__Fiscal_code__c = acc.NE__Fiscal_code__c;
                            system.debug( 'recordtype master' + recordTypeQuery( 'Account', rtDevNamesMerch ) );
                            accM.RecordTypeId = ( RTNameIdAcc.get( OB_UtilityConstants.MASTER_MERCHANT ) ).Id;

                            //  START   micol.ferrari 17/10/2018 - BYPASS VALIDATION
                            accM.OB_BypassValidation__c = true;
                            insert accM;
                            //  END     micol.ferrari 17/10/2018 - BYPASS VALIDATION
                        }
                        acc.OB_Master_Merchant_ID__c = accM.id;
                        /******lea.emalieu START 24/09/2018 *********************************/
                        //Bank owner banca = BankOwner objectDataMap
                        //START francesca.ribezzi 20/07/19 - WN-133 - community setup -> bankOwner node happens to be null
                        acc.OB_Bank_owner__c = bankOwnerId;
                        //END francesca.ribezzi 20/07/19 - WN-133
                        acc.RecordTypeId = ( RTNameIdAcc.get( OB_UtilityConstants.MERCHANTRT ) ).Id;

                        //  START   micol.ferrari 17/10/2018 - BYPASS VALIDATION
                        acc.OB_BypassValidation__c = true;
                        insert acc;
                        //  END     micol.ferrari 17/10/2018 - BYPASS VALIDATION

                        System.debug( 'Account Id ' + acc.Id );

                        if ( String.isBlank( newPv.Id ) )
                        {
                            newPv.NE__Account__c = acc.Id;
                            if ( newPv.OB_Typology__c == 'Fisico' )
                            {
                                newPv.RecordTypeId = ( RTNameIdServicePoint.get( OB_UtilityConstants.SERVICE_POINT_FISICO ) ).Id;
                            }
                            if ( newPv.OB_Typology__c == 'Virtuale' )
                            {
                                newPv.RecordTypeId = ( RTNameIdServicePoint.get( OB_UtilityConstants.SERVICE_POINT_VIRTUALE ) ).Id;
                            }

                            //  START   micol.ferrari 17/10/2018 - BYPASS VALIDATION
                            newPv.OB_BypassValidation__c = true;
                            upsert newPv;
                            //  END     micol.ferrari 17/10/2018 - BYPASS VALIDATION
                            System.debug( 'ServicePoint Id ' + newPv.Id );
                        }
                    }
                    else
                    {
                        System.debug( 'Update merchant Here i am' );

                        //  START   micol.ferrari 17/10/2018 - BYPASS VALIDATION
                        acc.OB_BypassValidation__c = true;
                        update acc;
                        //  END     micol.ferrari 17/10/2018 - BYPASS VALIDATION

                        System.debug( 'Account update Id ' + acc.Id );
                        if ( String.isBlank( newPv.Id ) )
                        {
                            if ( newPv.OB_Typology__c == 'Fisico' )
                            {
                                newPv.RecordTypeId = ( RTNameIdServicePoint.get( OB_UtilityConstants.SERVICE_POINT_FISICO ) ).Id;
                            }
                            if ( newPv.OB_Typology__c == 'Virtuale' )
                            {
                                newPv.RecordTypeId = ( RTNameIdServicePoint.get( OB_UtilityConstants.SERVICE_POINT_VIRTUALE ) ).Id;
                            }
                            system.debug( 'new pv Here i am' );
                            newPv.NE__Account__c = acc.Id;

                            //  START   micol.ferrari 17/10/2018 - BYPASS VALIDATION
                            newPv.OB_BypassValidation__c = true;
                            upsert newPv;
                            //  END     micol.ferrari 17/10/2018 - BYPASS VALIDATION

                            system.debug( 'upsert pv opening' + newPv.Id );
                        }
                        //Call method to retrieve contacts using actualBank Id and merchant Id
                        retrieveDataContact( step, data, stepsDefinition, targetObjectKey, method, wizardWrapper );
                    }
                    if ( extSourceMapList != null )
                    {
                        for ( ExternalSourceMapping__c esms : extSourceMapList )
                        {
                            esms.OB_Merchant_ID__c = acc.Id;
                        }
                        insert extSourceMapList;
                    }
                    bit2flow.B2FUtils.setJSONValue( data, 'unbind', 'InsegnaPv', newPv.Name );
                    bit2flow.B2FUtils.setJSONValue( data, 'unbind', 'DenominazioneSociale', acc.Name );
                    if ( acc.OB_Year_constitution_company__c != null && String.valueOf( acc.OB_Year_constitution_company__c ) != '' && String.valueOf( acc.OB_Year_constitution_company__c ).length( ) >= 4 )
                    {
                        bit2flow.B2FUtils.setJSONValue( data, 'unbind', 'yearOfConstitutionCompany', String.valueOf( acc.OB_Year_constitution_company__c ).substring( 0, 4 ) );
                    }
                    //Andrea Saracini 18.04.2019 Card No Present: is Nexi Acquirer and is active Service Point START
                    //davide.franzini - WN-605 - 14/10/2019 - abi field added
                    List<Asset> assets =
                    [
                            SELECT Id,
                                    OB_ABI__c,
                                    AccountId,
                                    NE__Service_Point__c,
                                    NE__ProdId__r.RecordType.DeveloperName,
                                    NE__ProdId__r.OB_Acquirer__c,
                                    NE__ProdId__r.OB_Codice_sfdc__c
                            FROM Asset
                            WHERE AccountId = :acc.Id OR NE__Service_Point__c = :newPv.Id
                    ];
                    Boolean isNexiAcquirer = false;
                    Boolean isActiveOfferOnSp = false;
                    //Check if is Nexi Acquirer or there is an Active offer on Service Point
                    if ( assets != null && !assets.isEmpty( ) )
                    {
                        for ( Asset item : assets )
                        {
                            //davide.franzini - WN-605 - 14/10/2019 - abi match filter added
                            isNexiAcquirer = !isNexiAcquirer && bankAccountMap.get( 'OB_ABI__c' ).equals(item.OB_ABI__c) && acc.Id.equals( item.AccountId ) && OB_UtilityConstants.ACQUIRING_RT.equals( item.NE__ProdId__r.RecordType.DeveloperName ) && OB_UtilityConstants.GT_NEXICAPS.equalsIgnoreCase( item.NE__ProdId__r.OB_Acquirer__c ) ? true : isNexiAcquirer; //Andrea Saracini 14.05.2019 Card No Present: GT_NEXICAPS
                            isActiveOfferOnSp = !isActiveOfferOnSp && newPv.Id.equals( item.NE__Service_Point__c ) && ( OB_UtilityConstants.START_SFDC.equals( item.NE__ProdId__r.OB_Codice_sfdc__c ) || OB_UtilityConstants.CUSTOM_SFDC.equals( item.NE__ProdId__r.OB_Codice_sfdc__c ) ) ? true : isActiveOfferOnSp;
                        }
                    }
                   
                    //Andrea Saracini 18.04.2019 Card No Present: is Nexi Acquirer and is active Service Point STOP
                    if ( String.IsBlank( orderHeader.Id ) )
                    {
                        orderHeader.NE__AccountId__c = acc.Id;
                        orderHeader.NE__BillAccId__c = acc.Id;
                        orderHeader.OB_Business_Model_Acquiring__c = ( String ) bankProfiletMap.get( 'OB_Business_Model_Acquiring__c' );
                        orderHeader.OB_Business_Model_POS__c = ( String ) bankProfiletMap.get( 'OB_Business_Model_POS__c' );
                        orderHeader.OB_Main_Process__c = 'Setup';
                        data.put('MainProcess', 'Setup'); //Antonio.vatrano r1f3-99 23/09/2019
                        orderHeader.OB_ProposerABI__c = ( Id ) data.get( 'actualBank' );
                        orderHeader.OB_CAB__c = ( String ) userAbiMap.get( 'OB_CAB__c' );
                        orderHeader.OB_ABI__c = ( String ) bankAccountMap.get( 'OB_ABI__c' );
                        orderHeader.OB_Circuit__c = ( String ) bankProfiletMap.get( 'OB_Circuit__c' );
                        orderHeader.OB_Other_Acquirer__c = ( String ) bankProfiletMap.get( 'OB_Other_Acquirer__c' );
                        orderHeader.OB_Service_Type__c = ( String ) bankProfiletMap.get( 'OB_Service_Type__c' );
                        orderHeader.OB_Apm_Circuit__c = ( String ) bankProfiletMap.get( 'OB_Apm_Circuit__c' );
                        orderHeader.OB_Vas__c = ( String ) bankProfiletMap.get( 'OB_VAS__c' );  //davide.franzini - 29/07/2019 - WN-212
                        orderHeader.OB_Applicant_RAC_Code_SIA__c = ( String ) bankProfiletMap.get( 'OB_Applicant_RAC_Code_SIA__c' );
                        orderHeader.OB_Terminal_Id_Generator__c = ( String ) bankProfiletMap.get( 'OB_Terminal_Id_Generator__c' );
                        orderHeader.OB_Terminal_Id_Gateway__c = ( String ) bankProfiletMap.get( 'OB_Terminal_Id_Gateway__c' );  // davide.franzini - F2WAVE2-4 - 17/07/2019
                        insert orderHeader;
                    }
                    if ( String.IsBlank( configuration.Id ) )
                    {
                        system.debug( 'MCCL2: ' + MCCL2 + ' MCCL3: ' + MCCL3 );
                        System.debug( 'Insert configuration' );
                        String shopSign = ( String ) data.get( 'shopSign' );
                        configuration.RecordTypeId = ( RTNameIdOrder.get( OB_UtilityConstants.ORDER ) ).Id;
                        configuration.NE__AccountId__c = acc.Id;
                        configuration.NE__BillAccId__c = acc.Id;
                        configuration.NE__ServAccId__c = acc.Id;
                        configuration.OB_Service_Point__c = newPv.Id;
                        configuration.OB_ABI__c = ( String ) bankAccountMap.get( 'OB_ABI__c' );
                        configuration.OB_CAB__c = ( String ) userAbiMap.get( 'OB_CAB__c' );
                        configuration.NE__Order_Header__c = orderHeader.Id;
                        configuration.OB_ShopSign__c = ( String ) data.get( 'shopSign' );
                        configuration.OB_MCCL2__c = MCCL2;
                        configuration.OB_MCC__c = MCCL3;
                        if ( shopSign.length( ) <= 24 )
                        {
                            configuration.OB_ReceiptHeader__c = shopSign;
                        }
                        else
                        {
                            configuration.OB_ReceiptHeader__c = shopSign.substring( 0, 24 );
                        }
                        if ( newPv.NE__City__c.length( ) <= 24 )
                        {
                            configuration.OB_ReceiptCity__c = newPv.NE__City__c;
                        }
                        else
                        {
                            configuration.OB_ReceiptCity__c = newPv.NE__City__c.substring( 0, 24 );
                        }
                        //Andrea Saracini 18.04.2019 Card No Present: is Nexi Acquirer and is active Service Point START
                        configuration.OB_isNexiAcquirer__c = isNexiAcquirer;
                        configuration.OB_IsActiveOfferOnSp__c = isActiveOfferOnSp;
                        //Andrea Saracini 18.04.2019 Card No Present: is Nexi Acquirer and is active Service Point STOP
                        insert configuration;

                        System.debug( 'configuration inserted with id :' + configuration.Id );
                        System.debug( 'is community user? :' + ( Boolean ) data.get( 'isCommunityUser' ) );
                        configuration.NE__Parameters__c = 'lightningFromVF=' + OB_UtilityCallingServices.isCommunityUser( ) + ';ordId=' + configuration.Id; //davide.franzini - 27/06/2019 - F2WAVE2-45 //enrico.purificato 10/9 performance
                        update configuration;


                    }

                    OB_UtilityCallingServices.createShare( bankAccountMap, orderHeader, newPv, acc, ( Boolean ) data.get( 'isCommunityUser' ) );

                    //set the Ids in the datamap JSON so we can retrieve them later
                    // antonio.vatrano 27-10-2019 post production
                    //bit2flow.B2FUtils.setJSONValue( data, 'Configuration', 'NE__Parameters__c', 'lightningFromVF=' + OB_UtilityCallingServices.isCommunityUser( ) + ';ordId=' + configuration.Id  ); //davide.franzini - 27/06/2019 - F2WAVE2-45 //enrico.purificato 10/9 performance
                    bit2flow.B2FUtils.setJSONValue( data, 'merchant', 'Id', acc.Id );
                    bit2flow.B2FUtils.setJSONValue( data, 'pv', 'Id', newPv.Id );
                    bit2flow.B2FUtils.setJSONValue( data, 'OrderHeader', 'Id', orderHeader.Id );
                    //bit2flow.B2FUtils.setJSONValue( data, 'Configuration', 'Id', configuration.Id ); // antonio.vatrano 27-10-2019 post production

                    bit2flow.B2FUtils.setJSONValue( data, 'BillingProfilePOS', 'OB_ABICode__c', ( String ) bankAccountMap.get( 'OB_ABI__c' ) );
                    //REPORT SERVICE POINT NAME AND CITY

                    //bit2flow.B2FUtils.setJSONValue( data, 'Configuration', 'OB_ReceiptHeader__c', configuration.OB_ReceiptHeader__c ); // antonio.vatrano 27-10-2019 post production
                    //bit2flow.B2FUtils.setJSONValue( data, 'Configuration', 'OB_ReceiptCity__c', configuration.OB_ReceiptCity__c ); // antonio.vatrano 27-10-2019 post production

                    bit2flow.B2FUtils.setJSONValue( data, 'sede_legale', 'Phone', acc.Phone );
                    bit2flow.B2FUtils.setJSONValue( data, 'sede_legale', 'Email', acc.NE__E_mail__c );
                    
                    data.put( 'Configuration', configuration ); // antonio.vatrano 27-10-2019 post production

                    List<NE__Lov__c> lovSAE = [ SELECT NE__Value2__c,name FROM NE__Lov__c WHERE NE__Type__c = 'SAE' and NE__Active__c = true and name = :acc.OB_SAE_Code__c ];
                    if ( lovSAE != null && lovSAE.size( ) > 0 )
                    {
                        bit2flow.B2FUtils.setJSONValue( data, 'merchant', 'OB_FATECO__c', lovSAE[ 0 ].NE__Value2__c );
                    }

                    //START gianluigi.virga 15/07/2019 - BACKLOG-153 - Show input field 'Check-in date' if the field OB_Show_check_in_date__c is checked on bank profile
                    Boolean bankProfCheckInDate = false;
                    if ( bankProfiletMap.get( 'OB_Show_check_in_date__c' ) != null )
                    {
                        bankProfCheckInDate = Boolean.valueOf( bankProfiletMap.get( 'OB_Show_check_in_date__c' ) );
                    }
                    //davide.franzini - WN-238 - 02/08/2019 - START
                    String orderCheckInDate = '';
                    if ( configuration.OB_Check_in_date__c != null )
                    {
                        orderCheckInDate = ( String ) bit2flow.B2FUtils.getJSONValue( data, 'Configuration', 'OB_Check_in_date__c' );
                    }
                    //davide.franzini - WN-238 - 02/08/2019 - END
                    if ( bankProfCheckInDate )
                    {
                        Date convertedDate = Date.valueOf( orderCheckInDate );
                        configuration.OB_Check_in_date__c = convertedDate;
                        update configuration;
                    }
                    //END gianluigi.virga - BACKLOG-153

                    //ANDREA MORITTU START 11/02/2019:  bankOB_NDG__c is set to true when the field on bank profile is true
                    String VALIDCHARS = 'abcdefghijklmnopqrstuvwxyz0123456789 ';
                    String orderHeaderNDG = String.valueOf( orderHeaderMap.get( 'OB_NDG__c' ) );
                    if ( bankProfiletMap.get( 'OB_NDG__c' )!= null && Boolean.valueOf( bankProfiletMap.get( 'OB_NDG__c' ) ) ) //NEXI-276 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 27/08/2019
                    {
                        if ( String.isBlank( orderHeaderNDG ) )
                        {

                            errorObject.message = Label.MandatoryField;
                            errorObject.severity = 'ERROR';
                            isError = true;
                        }
                        else
                        {
                            orderHeaderNDG = orderHeaderNDG.toLowerCase( );
                            if ( !orderHeaderNDG.containsOnly( VALIDCHARS ) || ( orderHeaderNDG.length( ) < 1 || orderHeaderNDG.length( ) > 16 ) )
                            {
                                errorObject.message = Label.OB_NDGErrorLabel;
                                errorObject.severity = 'ERROR';
                                isError = true;
                            }
                            else if ( orderHeaderNDG.containsOnly( VALIDCHARS ) && ( orderHeaderNDG.length( ) > 1 && orderHeaderNDG.length( ) < 16 ) )
                            {
                                isError = false;
                            }
                        }
                    }
                    //ANDREA MORITTU END:  bankOB_NDG__c is set to true when the field on bank profile is true
                }

                //finally set the message (can be error, warning or success) and we populate the response correctly
                data.put( 'messageNext', errorObject );
                bit2flow.B2FUtils.setJSONValue( data, 'messageNext', 'message', errorObject.message );
                bit2flow.B2FUtils.setJSONValue( data, 'messageNext', 'severity', errorObject.severity );
            } catch ( Exception ecc )
            {
                //NEXI-178 Zuzanna Urban <z.urban@accenture.com>, 24/07/2019 start, add a log level
                System.debug( LoggingLevel.ERROR, 'Generic Error: ' + ecc.getMessage( ) + ' at line: ' + ecc.getLineNumber( ) + ' stack trace: ' + ecc.getStackTraceString( ) );
                //NEXI-178 Zuzanna Urban <z.urban@accenture.com>, 24/07/2019 stop, add a log level
                //NEXI-116 Wojciech Szuba <wojciech.szuba@accenture.com>, 09/07/2019, START
                response.result = '666';
                response.description = Label.OB_ServerLogicFailed;
                response.stepToGo = Integer.valueOf( getStepMapping( String.valueOf( wizardWrapper.name ), OB_UtilityConstants.STEP_IDENTIFICA_SOCIETA ) ); // NEXI-116 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 26/07/2019
                return response;
                //NEXI-116 Wojciech Szuba <wojciech.szuba@accenture.com>, 09/07/2019, STOP
            }
        }
        //START - elena.preteni 17/07/2019 F3 abi blank
        else
        {
            errorObject.message = 'ABI missing';
            errorObject.severity = 'ERROR';
            isError = true;
            data.put( 'abiError', 'true' );
            system.debug( 'ABI missing' );

        }
        //END - elena.preteni 17/07/2019 F3 abi blank
        //If there is an error we stop and we stay in the same step we are now, showing an error message (set by the component)
        System.debug( 'Method executed ' );
        if ( !String.IsBlank( errorObject.message ) || isError )
        {

            String stepToGo = getStepMapping( String.valueOf( wizardWrapper.name ), OB_UtilityConstants.STEP_IDENTIFICA_SOCIETA );
            response.stepToGo = Integer.valueOf( stepToGo );
            response.result = bit2flow.DynamicWizardStepWrapper.OKCODE;
        }
        else
        {
            if ( !goToCart )
            {
                String stepToGo = getStepMapping( String.valueOf( wizardWrapper.name ), OB_UtilityConstants.STEP_GT );
                response.stepToGo = Integer.valueOf( stepToGo );
                response.result = bit2flow.DynamicWizardStepWrapper.OKCODE;
            }
            else
            {
                String stepToGo = getStepMapping( String.valueOf( wizardWrapper.name ), OB_UtilityConstants.STEP_OFFERTA );
                response.stepToGo = Integer.valueOf( stepToGo );
                response.result = bit2flow.DynamicWizardStepWrapper.OKCODE;
            }
        }
        response.data = data;
        System.debug( 'data end method identifyCompany ' + JSON.serialize( data ) );

        return response;
    }

    //Method to save the current GT on the Configuration in the step: GT
    /* micol.ferrari 30/08/2018 */
    @AuraEnabled
    global static bit2flow.DynamicWizardStepWrapper GTselection( String step, map<String, Object> data, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, String targetObjectKey, String method, bit2flow.DynamicWizardWrapper wizardWrapper )
    {
        bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper( );
        System.debug( 'datamap begin method GTselection ' + data );
        OB_FlowCustomError errorObject = new OB_FlowCustomError( );
        errorObject.message = '';
        errorObject.severity = 'SUCCESS';
        try
        {
            String configurationString = JSON.serialize( data.get( 'Configuration' ) );
            System.debug( 'OB_FlowControlUtility.GTselection CONFIGURATION string :' + configurationString );
            NE__Order__c configuration = ( NE__Order__c ) JSON.deserialize( configurationString, NE__Order__c.class );
            /************lea.emalieu START 24/09/2018   **************************************************/
            // Control if one option of Gt is selected
            System.debug( 'GT Inbound : ' + configuration.OB_GT__c );
            if ( String.isBlank( configuration.OB_GT__c ) )
            {
                System.debug( '@@@@ERROR' );
                errorObject.message = Label.GT_SelectionWrongValue;
                errorObject.severity = 'ERROR';
            }

            if ( String.isBlank( errorObject.message ) )
            {
                System.debug( 'OB_FlowControlUtility.GTselection configuration record:' + configuration );

                update configuration;
            }
            //finally set the message (can be error, warning or success) and we populate the response correctly
            system.debug( 'errorObjectNext' + errorObject );
            data.put( 'messageNext', errorObject );
            bit2flow.B2FUtils.setJSONValue( data, 'messageNext', 'message', errorObject.message );
            bit2flow.B2FUtils.setJSONValue( data, 'messageNext', 'severity', errorObject.severity );

        } catch ( Exception ecc )
        {
            System.debug( 'OB_FlowControlUtility.GTselection: ' + ecc.getMessage( ) + ' at line: ' + ecc.getLineNumber( ) + ' stack trace: ' + ecc.getStackTraceString( ) );
        }

        if ( !String.IsBlank( errorObject.message ) )
        {
            String stepToGo = getStepMapping( String.valueOf( wizardWrapper.name ), OB_UtilityConstants.STEP_GT );
            response.stepToGo = Integer.valueOf( stepToGo );
            response.result = bit2flow.DynamicWizardStepWrapper.OKCODE;
        }
        else
        {
            String stepToGo = getStepMapping( String.valueOf( wizardWrapper.name ), OB_UtilityConstants.STEP_OFFERTA );
            response.stepToGo = Integer.valueOf( stepToGo );
        }
        response.data = data;
        response.result = bit2flow.DynamicWizardStepWrapper.OKCODE;
        return response;
    }

    //Method to save Billing Profile object on the step: operational data
    /**************************lea.emalieu START 25/09/2018 ***********************************************/
    //COMMENT LOGIC OF SAVE DATI OPERATIVI

    @AuraEnabled
    global static bit2flow.DynamicWizardStepWrapper operationalData( String step, map<String, Object> data, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, String targetObjectKey, String method, bit2flow.DynamicWizardWrapper wizardWrapper )
    {
        System.debug( 'operationalData Method' );
        System.debug( 'Complex data in operationalData method' + Json.serialize( data ) );
        bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper( );
        return response;
    }

    /**************************lea.emalieu END 25/09/2018 ***********************************************/

    //Method to save the 3 contacts (Legal Headquarter, Administrative Headquarter, Legal Advisor) and to create the injunction object for the legal advisor in the step: Company Data
    global static bit2flow.DynamicWizardStepWrapper companyData( String step, map<String, Object> data, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, String targetObjectKey, String method, bit2flow.DynamicWizardWrapper wizardWrapper )
    {
        bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper( );
        System.debug( 'datamap begin method  companyData' + JSON.serialize( data ) );
        System.debug( 'STEP IN COMPANY DATA: ' + step );
        data.put( 'legale_rappresentante_temp', null );
        data.put( 'sede_legale_temp', null );
        //Create 2 List: one for the records to insert, the other for the records to update.
        //After executing the insert, for the legal advisor record we need to create the junction object (that connects the contact to the order header)
        List<Contact> contactListToInsert = new List<Contact>( );
        List<Contact> contactListToUpdate = new List<Contact>( );
        Boolean skipActualOwner = false;
        Boolean isError = false;
        Map<String, String> mandatoryFormalCheck = OB_MandatoryFormalCheck.inputCheck( data, 'companyData' );
        try
        {
            /* ANDREA MORITTU START 17-Sept-2019 - BACKLOG_10 */
			Boolean pagoBancomatArePresent = false;
			if(data.containsKey( 'pagoBancomatArePresent' )) {
				pagoBancomatArePresent = Boolean.valueOf( data.get( 'pagoBancomatArePresent' ) ) ;
			}
			if(pagobancomatArePresent && mandatoryFormalCheck.containsKey('documentExpirationDatelegaleRappDoc') && mandatoryFormalCheck.get('documentExpirationDatelegaleRappDoc') == Label.MandatoryField ) {
				mandatoryFormalCheck.remove('documentExpirationDatelegaleRappDoc');
			}
			/* ANDREA MORITTU END 17-Sept-2019 - BACKLOG_10 */
            /*************lea.emalieu START 24/09/2018 *************************************/
            //Method to check mandatory fields
            System.debug( 'map from method--> ' + mandatoryFormalCheck );
            System.debug( 'Size Map check formal data in companyData: ' + mandatoryFormalCheck.size( ) );
            data.put( 'checkMapValues', mandatoryFormalCheck );
            data.put( 'setRedBordercompanyData', false );
            if ( mandatoryFormalCheck.size( ) >= 1 )
            {
                System.debug( 'MAP not empty' );
                data.put( 'setRedBordercompanyData', true );
                isError = true;
                System.debug( 'setRedBorder ::::' + data.get( 'setRedBordercompanyData' ) );
            }

            /************lea.emalieu END 24/09/2018*********************************************/
            setJSONNullFields( data, 'legale_rappresentante', 'Id' );
            setJSONNullFields( data, 'sede_legale', 'Id' );

            if ( !isError )
            {
                List<String> rtDevNamesContacts = new List<String> {OB_UtilityConstants.ESECUTORE, OB_UtilityConstants.DATI_SOCIETA_LEGALE, OB_UtilityConstants.REFERENTE_AMMINISTRATIVO};
                Map<String, RecordType> RTNameId = ( recordTypeQuery( 'Contact', rtDevNamesContacts ) );
                // Get Merchant Already created
                String accString = JSON.serialize( data.get( 'merchant' ) );
                System.debug( ' Account string :' + accString );
                Account acc = ( Account ) JSON.deserialize( accString, Account.class );
                System.debug( ' Account dataMap :' + acc );
                //***GIOVANNI SPINELLI 03/09/2918 - SET A STANDARD FIELD WITH THE VALUE OF AN UNBIND - START ***//
                system.debug( 'yearofconstitution' + bit2flow.B2FUtils.getJSONValue( data, 'unbind', 'yearOfConstitutionCompany' ) );
                String yearOfConstString = String.ValueOf( bit2flow.B2FUtils.getJSONValue( data, 'unbind', 'yearOfConstitutionCompany' ) );
                if ( yearOfConstString != null && yearOfConstString != '' )
                {
                    Decimal yearOfConstitutionCompany = Decimal.ValueOf( yearOfConstString );
                    acc.OB_Year_constitution_company__c = yearOfConstitutionCompany;
                }
                //***GIOVANNI SPINELLI 03/09/2918 - SET A STANDARD FIELD WITH THE VALUE OF AN UNBIND - END   ***//

                //get OrderHeader already created
                String orderHeaderString = JSON.serialize( data.get( 'OrderHeader' ) );
                System.debug( ' orderHeaderString string :' + orderHeaderString );
                NE__Order_Header__c orderHeader = ( NE__Order_Header__c ) JSON.deserialize( orderHeaderString, NE__Order_Header__c.class );
                System.debug( ' NE__Order_Header__c dataMap :' + orderHeader );
                //We also need to set the dates from blank to null because the deserialize breaks parsing null dates
                setJSONNullFields( data, 'legale_rappresentante', 'OB_Birth_Date__c' );
                setJSONNullFields( data, 'legale_rappresentante', 'OB_Document_Release_Date__c' );
                setJSONNullFields( data, 'legale_rappresentante', 'OB_Document_Expiration_Date__c' );

                String ContactString = JSON.serialize( data.get( 'legale_rappresentante_temp' ) );
                System.debug( ' ContactString string :' + ContactString );
                system.debug( 'call method setjsonnull' );
                Contact esecutore = ( Contact ) JSON.deserialize( ContactString, Contact.class );
                System.debug( ' esecutore dataMap :' + esecutore );

                String StringLegalHeadquarter = JSON.serialize( data.get( 'sede_legale_temp' ) );
                System.debug( ' ContactStringLegalHeadquarter string :' + StringLegalHeadquarter );
                Contact legalHeadquarter = ( Contact ) JSON.deserialize( StringLegalHeadquarter, Contact.class );
                System.debug( ' legalHeadquarter dataMap :' + legalHeadquarter );

                if ( esecutore.OB_Country_Birth__c != 'ITALIA' )
                {
                    List<NE__Lov__c> lovCadastralCode = [ SELECT Id, NE__Value2__c FROM NE__Lov__c WHERE NE__Type__c = 'COUNTRY' AND Name = :esecutore.OB_Country_Birth__c ];
                    if ( lovCadastralCode != null && lovCadastralCode.size( ) > 0 )
                    {
                        esecutore.OB_Cadastral_Code__c = lovCadastralCode[ 0 ].NE__Value2__c;
                    }
                }
                system.debug( 'esecutore.OB_Cadastral_Code__c: ' + esecutore.OB_Cadastral_Code__c );
                system.debug( 'actualBank contacts' + ( Id ) data.get( 'actualBank' ) );
                Pattern docNumPattern = Pattern.compile( '^[a-zA-Z0-9]+$' );
                Matcher docNum = docNumPattern.matcher( esecutore.OB_Document_Number__c );
                Date checkBirthDate = Date.newInstance( 1900, 1, 1 );
                Map<String, String> mandatoryValidationCheck = new Map<String, String>( );
                //elena.preteni 19/02/19 SAE check Visamastercard
                // Configuration
                String configurationString = JSON.serialize( data.get( 'Configuration' ) );
                System.debug( ' configurationString string :' + configurationString );
                NE__Order__c order = ( NE__Order__c ) JSON.deserialize( configurationString, NE__Order__c.class );
                System.debug( ' NE__Order__c dataMap :' + order );
                // Start antonio.vatrano r1f3_94 19/09/2019
                String typeGateway = '';
                Boolean isVirtuale = false;
                List<String> GATEWAYLIST = new List<String> {'MOTO', 'ECOMM'};
                if ( data.get( 'pv' ) != null ){
                    Map<String, Object> newServicePoint = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( data.get( 'pv' ) ) );
                    if(String.valueOf(newServicePoint.get( 'OB_Typology__c' )) == 'Virtuale'){
                        isVirtuale=true;
                    }
                }
                // End antonio.vatrano r1f3_94 19/09/2019
                List<NE__OrderItem__c> orderItems =
                [
                        SELECT id,NE__ProdId__r.OB_Codice_sfdc__c
                        FROM NE__OrderItem__c
                        WHERE
                        NE__OrderId__c = :order.id
                        AND
                        NE__Action__c = 'Add'
                ];
                for ( NE__OrderItem__c oi : orderItems )
                {
                    //elena.preteni fix R1F2-209 add not null condition for codice sfdc null for pin pad
                    if ( oi.NE__ProdId__r.OB_Codice_sfdc__c != null && oi.NE__ProdId__r.OB_Codice_sfdc__c.equalsIgnoreCase( 'VISAMASTERCARD' ) && acc.OB_SAE_Code__c == '999' )
                    //elena.preteni fix R1F2-209 add not null condition for codice sfdc null for pin pad
                    {
                        mandatoryValidationCheck.put( OB_UtilityConstants.MANDATORYINPUTMAPCOMPANYDATA.get( 'merchant' ).get( 'OB_SAE_Code__c' ), Label.OB_SAE_not_correct );
                    }
                    // Start antonio.vatrano r1f3_94 19/09/2019
                    if(isVirtuale && String.isBlank(oi.NE__ProdId__r.OB_Codice_sfdc__c) && GATEWAYLIST.contains(oi.NE__ProdId__r.OB_Codice_sfdc__c)){
                        typeGateway = oi.NE__ProdId__r.OB_Codice_sfdc__c;
                    }
                    // End antonio.vatrano r1f3_94 19/09/2019
                }

                //NEXI-122 Monika Kocot monika.kocot@accenture.com, 08/07/2019 START check for legal form and fiscal code
                if ( acc.OB_Legal_Form__c != null && isFCCompatibilityCheckRequired( acc.OB_Legal_Form__c ) )
                {
                    if ( acc.NE__Fiscal_code__c.length( ) != 16 || !acc.NE__Fiscal_code__c.isAlphanumeric( ) )
                    {
                        data.put( 'isFiscalCodeInCorrect', true );
                    }
                }
                //NEXI-122 Monika Kocot monika.kocot@accenture.com, 08/07/2019  STOP

                //elena.preteni 19/02/19 SAE check Visamastercard

                // NEXI-140 Michal Targiel <michal.targiel@accenture.com>, 03/07/2019, START
                if ( acc != null )
                {
                    if ( acc.OB_VAT_Not_Present__c == true
                            && OB_UtilityConstants.LIVIGNO.equalsIgnoreCase( acc.OB_DescriptionVATNotPresent__c )
                            && !OB_UtilityConstants.LIVIGNO.equalsIgnoreCase( acc.OB_Legal_Address_City__c ) )
                    {
                        mandatoryValidationCheck.put( 'comuneSedeLegale', Label.OB_LIVIGNO_CHECK_ERROR );
                    }
                }
                // NEXI-140 Michal Targiel <michal.targiel@accenture.com>, 03/07/2019, STOP

                if ( acc.OB_Year_constitution_company__c != null && ( acc.OB_Year_constitution_company__c > System.Today( ).year( ) ) )
                {
                    mandatoryValidationCheck.put( 'input:unbind:yearOfConstitutionCompany', Label.yearNotValid );
                }
                /* ANDREA MORITTU START 26-Nov-2019 - PRODOB_552 - ADDING LOGIC ON DOCUMENT NUMBER LENGTH */
                if(esecutore.OB_Document_Type__c == OB_UtilityConstants.CARTA_DI_IDENTITA) {
                    /* ANDREA MORITTU START 04-Dec-2019 - PRODOB_552 -ADDING FIX ON LENGHT */
                   if ( esecutore.OB_Document_Release_Country_Code__c == 'ITA' && (!(esecutore.OB_Document_Number__c).isAlphanumeric() ||  (esecutore.OB_Document_Number__c.length() < 8 || esecutore.OB_Document_Number__c.length() > 9 )  )) {
                       /* ANDREA MORITTU END 04-Dec-2019 - PRODOB_552 -ADDING FIX ON LENGHT */
                       mandatoryValidationCheck.put(OB_UtilityConstants.MANDATORYINPUTMAPCOMPANYDATA.get('legale_rappresentante').get('OB_Document_Number__c'),Label.OB_InvalidDocumentNumber);
                   }
                } else {
                    //START gianluigi.virga 09/07/2019 - BACKLOG-50 - Added country condition in the if statement
                    if ( esecutore.OB_Document_Release_Country_Code__c == 'ITA' && ( !docNum.matches( ) || ( esecutore.OB_Document_Number__c.length( ) != 10 && esecutore.OB_Document_Number__c.length( ) != 9 ) ) )
                    //END gianluigi.virga
                    {
                        mandatoryValidationCheck.put(OB_UtilityConstants.MANDATORYINPUTMAPCOMPANYDATA.get('legale_rappresentante').get('OB_Document_Number__c'),Label.OB_InvalidDocumentNumber);
                    }
                }
                /* ANDREA MORITTU END 26-Nov-2019 - PRODOB_552 - ADDING LOGIC ON DOCUMENT NUMBER LENGTH */
				// ANDREA MORITTU START 23-Sept-2019- BACKLOG_10 
				if(! pagoBancomatArePresent) {
					if ( esecutore.OB_Document_Release_Date__c > system.today( ) || esecutore.OB_Document_Release_Date__c < esecutore.OB_Birth_Date__c )
					{
						mandatoryValidationCheck.put(OB_UtilityConstants.MANDATORYINPUTMAPCOMPANYDATA.get('legale_rappresentante').get('OB_Document_Release_Date__c'),Label.OB_Invalid_Release_Date);
					}
					if ( esecutore.OB_Document_Release_Country_Code__c == 'ITA' && ( esecutore.OB_Document_Type__c == OB_UtilityConstants.CARTA_DI_IDENTITA ))
					{
						Date checkDate = Date.newInstance(2012, 2, 10);
						if(((esecutore.OB_Document_Release_Date__c < checkDate || esecutore.OB_Document_Release_Date__c == checkDate)
							// michele.lubrano 29/04/2019 PRODOB-67 add check if expiration day is not the same with release day START
							&& (esecutore.OB_Document_Expiration_Date__c != esecutore.OB_Document_Release_Date__c.addYears(10).addDays(-1) && esecutore.OB_Document_Expiration_Date__c != esecutore.OB_Document_Release_Date__c.addYears(10) ) )
							// michele.lubrano 29/04/2019 PRODOB-67 END
								|| ( esecutore.OB_Document_Expiration_Date__c < system.today( ) ) )
						{
							mandatoryValidationCheck.put(OB_UtilityConstants.MANDATORYINPUTMAPCOMPANYDATA.get('legale_rappresentante').get('OB_Document_Expiration_Date__c'),Label.OB_InvalidDocumentExpirationDate);
						}
						else if ( esecutore.OB_Document_Release_Date__c > checkDate )
						{
							if ( ( ( esecutore.OB_Birth_Date__c.month( ) < esecutore.OB_Document_Release_Date__c.month( ) ) || ( esecutore.OB_Birth_Date__c.month( ) == esecutore.OB_Document_Release_Date__c.month( ) && esecutore.OB_Birth_Date__c.day( ) < esecutore.OB_Document_Release_Date__c.day( ) ) ) && esecutore.OB_Document_Expiration_Date__c != Date.newInstance( esecutore.OB_Document_Release_Date__c.addYears( 11 ).year( ), esecutore.OB_Birth_Date__c.month( ), esecutore.OB_Birth_Date__c.day( ) ) )
							{
								mandatoryValidationCheck.put(OB_UtilityConstants.MANDATORYINPUTMAPCOMPANYDATA.get('legale_rappresentante').get('OB_Document_Expiration_Date__c'),Label.OB_InvalidDocumentExpirationDate);
							}
							else if ( ( ( esecutore.OB_Birth_Date__c.month( ) > esecutore.OB_Document_Release_Date__c.month( ) ) || ( esecutore.OB_Birth_Date__c.month( ) == esecutore.OB_Document_Release_Date__c.month( ) && esecutore.OB_Birth_Date__c.day( ) >= esecutore.OB_Document_Release_Date__c.day( ) ) ) && esecutore.OB_Document_Expiration_Date__c != Date.newInstance( esecutore.OB_Document_Release_Date__c.addYears( 10 ).year( ), esecutore.OB_Birth_Date__c.month( ), esecutore.OB_Birth_Date__c.day( ) ) )
							{
								mandatoryValidationCheck.put(OB_UtilityConstants.MANDATORYINPUTMAPCOMPANYDATA.get('legale_rappresentante').get('OB_Document_Expiration_Date__c'),Label.OB_InvalidDocumentExpirationDate);
							}
						}
						
						if ( esecutore.OB_Document_Release_Authority__c != OB_UtilityConstants.COMUNE )
						{
							mandatoryValidationCheck.put(OB_UtilityConstants.MANDATORYINPUTMAPCOMPANYDATA.get('legale_rappresentante').get('OB_Document_Release_Authority__c'),Label.OB_InvalidDocumentReleaseAuthority);
						}
					}
					else if (esecutore.OB_Document_Release_Country_Code__c == 'ITA' && ( esecutore.OB_Document_Type__c == OB_UtilityConstants.PASSAPORTO ))
					{
						if(((esecutore.OB_Document_Expiration_Date__c != esecutore.OB_Document_Release_Date__c.addYears(10).addDays(-1)) && (esecutore.OB_Document_Expiration_Date__c != esecutore.OB_Document_Release_Date__c.addYears(10) ) )
							|| (esecutore.OB_Document_Expiration_Date__c < system.today()))
						{
							mandatoryValidationCheck.put(OB_UtilityConstants.MANDATORYINPUTMAPCOMPANYDATA.get('legale_rappresentante').get('OB_Document_Expiration_Date__c'),Label.OB_InvalidDocumentExpirationDate);
						}
						
						if ( esecutore.OB_Document_Release_Authority__c != OB_UtilityConstants.QUESTURA )
						
						{
							mandatoryValidationCheck.put(OB_UtilityConstants.MANDATORYINPUTMAPCOMPANYDATA.get('legale_rappresentante').get('OB_Document_Release_Authority__c'),Label.OB_InvalidDocumentReleaseAuthority);
						}
					}
					else if ( esecutore.OB_Document_Release_Country_Code__c == 'ITA' && ( esecutore.OB_Document_Type__c == OB_UtilityConstants.PATENTE ))
					{
						if ( esecutore.OB_Document_Release_Authority__c != OB_UtilityConstants.UCO && esecutore.OB_Document_Release_Authority__c != OB_UtilityConstants.MOTORIZZAZIONE && esecutore.OB_Document_Release_Authority__c != OB_UtilityConstants.PREFETTURA )
						{
							mandatoryValidationCheck.put(OB_UtilityConstants.MANDATORYINPUTMAPCOMPANYDATA.get('legale_rappresentante').get('OB_Document_Release_Authority__c'),Label.OB_InvalidDocumentReleaseAuthority);
						}
						if ( esecutore.OB_Document_Expiration_Date__c < system.today( ) )
						{
							mandatoryValidationCheck.put(OB_UtilityConstants.MANDATORYINPUTMAPCOMPANYDATA.get('legale_rappresentante').get('OB_Document_Expiration_Date__c'),Label.OB_InvalidDocumentExpirationDate);
						}
					}
					if ( esecutore.OB_Birth_Date__c > system.today( ).addYears( -16 ) || esecutore.OB_Birth_Date__c < checkBirthDate )
					{
						mandatoryValidationCheck.put(OB_UtilityConstants.MANDATORYINPUTMAPCOMPANYDATA.get('legale_rappresentante').get('OB_Birth_Date__c'),Label.OB_InvalidBirthDate);
					}
				} else {
					// ELSE = THERE ARE ARE ACQUIRING INSIDE OFFER, SO BYPASS CONTROLS IF EXPIRATION IS BLANK
					if(esecutore.OB_Document_Release_Date__c != null && esecutore.OB_Document_Expiration_Date__c == null ) {						
						mandatoryValidationCheck.remove(OB_UtilityConstants.MANDATORYINPUTMAPCOMPANYDATA.get('legale_rappresentante').get('OB_Document_Expiration_Date__c'));

					} else {
						if ( esecutore.OB_Document_Release_Date__c > system.today( ) || esecutore.OB_Document_Release_Date__c < esecutore.OB_Birth_Date__c ){
							mandatoryValidationCheck.put(OB_UtilityConstants.MANDATORYINPUTMAPCOMPANYDATA.get('legale_rappresentante').get('OB_Document_Release_Date__c'),Label.OB_Invalid_Release_Date);
						}
						if ( esecutore.OB_Document_Release_Country_Code__c == 'ITA' && ( esecutore.OB_Document_Type__c == OB_UtilityConstants.CARTA_DI_IDENTITA ))
						{
						if(esecutore.OB_Document_Release_Date__c != null && esecutore.OB_Document_Expiration_Date__c == null ) {		
							mandatoryValidationCheck.remove(OB_UtilityConstants.MANDATORYINPUTMAPCOMPANYDATA.get('legale_rappresentante').get('OB_Document_Expiration_Date__c'));
						} else {
							Date checkDate = Date.newInstance(2012, 2, 10);
							if(((esecutore.OB_Document_Release_Date__c < checkDate || esecutore.OB_Document_Release_Date__c == checkDate)
								&& (esecutore.OB_Document_Expiration_Date__c != esecutore.OB_Document_Release_Date__c.addYears(10).addDays(-1) && esecutore.OB_Document_Expiration_Date__c != esecutore.OB_Document_Release_Date__c.addYears(10) ) )
									|| ( esecutore.OB_Document_Expiration_Date__c < system.today( ) ) )
							{
								mandatoryValidationCheck.put(OB_UtilityConstants.MANDATORYINPUTMAPCOMPANYDATA.get('legale_rappresentante').get('OB_Document_Expiration_Date__c'),Label.OB_InvalidDocumentExpirationDate);
							}
							else if ( esecutore.OB_Document_Release_Date__c > checkDate )
							{
								if ( ( ( esecutore.OB_Birth_Date__c.month( ) < esecutore.OB_Document_Release_Date__c.month( ) ) || ( esecutore.OB_Birth_Date__c.month( ) == esecutore.OB_Document_Release_Date__c.month( ) && esecutore.OB_Birth_Date__c.day( ) < esecutore.OB_Document_Release_Date__c.day( ) ) ) && esecutore.OB_Document_Expiration_Date__c != Date.newInstance( esecutore.OB_Document_Release_Date__c.addYears( 11 ).year( ), esecutore.OB_Birth_Date__c.month( ), esecutore.OB_Birth_Date__c.day( ) ) )
								{
									mandatoryValidationCheck.put(OB_UtilityConstants.MANDATORYINPUTMAPCOMPANYDATA.get('legale_rappresentante').get('OB_Document_Expiration_Date__c'),Label.OB_InvalidDocumentExpirationDate);
								}
								else if ( ( ( esecutore.OB_Birth_Date__c.month( ) > esecutore.OB_Document_Release_Date__c.month( ) ) || ( esecutore.OB_Birth_Date__c.month( ) == esecutore.OB_Document_Release_Date__c.month( ) && esecutore.OB_Birth_Date__c.day( ) >= esecutore.OB_Document_Release_Date__c.day( ) ) ) && esecutore.OB_Document_Expiration_Date__c != Date.newInstance( esecutore.OB_Document_Release_Date__c.addYears( 10 ).year( ), esecutore.OB_Birth_Date__c.month( ), esecutore.OB_Birth_Date__c.day( ) ) )
								{
									mandatoryValidationCheck.put(OB_UtilityConstants.MANDATORYINPUTMAPCOMPANYDATA.get('legale_rappresentante').get('OB_Document_Expiration_Date__c'),Label.OB_InvalidDocumentExpirationDate);
								}
							}
							if ( esecutore.OB_Document_Release_Authority__c != OB_UtilityConstants.COMUNE )
							{
								mandatoryValidationCheck.put(OB_UtilityConstants.MANDATORYINPUTMAPCOMPANYDATA.get('legale_rappresentante').get('OB_Document_Release_Authority__c'),Label.OB_InvalidDocumentReleaseAuthority);
							}
						}
					} else if (esecutore.OB_Document_Release_Country_Code__c == 'ITA' && ( esecutore.OB_Document_Type__c == OB_UtilityConstants.PASSAPORTO )) {	

						if(esecutore.OB_Document_Release_Date__c != null && esecutore.OB_Document_Expiration_Date__c == null ) {		
							mandatoryValidationCheck.remove(OB_UtilityConstants.MANDATORYINPUTMAPCOMPANYDATA.get('legale_rappresentante').get('OB_Document_Expiration_Date__c'));
						} else {
							if(((esecutore.OB_Document_Expiration_Date__c != esecutore.OB_Document_Release_Date__c.addYears(10).addDays(-1)) && (esecutore.OB_Document_Expiration_Date__c != esecutore.OB_Document_Release_Date__c.addYears(10) ) )
								|| (esecutore.OB_Document_Expiration_Date__c < system.today()))
							{
								mandatoryValidationCheck.put(OB_UtilityConstants.MANDATORYINPUTMAPCOMPANYDATA.get('legale_rappresentante').get('OB_Document_Expiration_Date__c'),Label.OB_InvalidDocumentExpirationDate);
							}
							
							if ( esecutore.OB_Document_Release_Authority__c != OB_UtilityConstants.QUESTURA )
							
							{
								mandatoryValidationCheck.put(OB_UtilityConstants.MANDATORYINPUTMAPCOMPANYDATA.get('legale_rappresentante').get('OB_Document_Release_Authority__c'),Label.OB_InvalidDocumentReleaseAuthority);
							}
						}		
					} else if ( esecutore.OB_Document_Release_Country_Code__c == 'ITA' && ( esecutore.OB_Document_Type__c == OB_UtilityConstants.PATENTE )) {
						if(esecutore.OB_Document_Release_Date__c != null && esecutore.OB_Document_Expiration_Date__c == null) {
							mandatoryValidationCheck.remove(OB_UtilityConstants.MANDATORYINPUTMAPCOMPANYDATA.get('legale_rappresentante').get('OB_Document_Expiration_Date__c'));
						} else {
							if ( esecutore.OB_Document_Release_Authority__c != OB_UtilityConstants.UCO && esecutore.OB_Document_Release_Authority__c != OB_UtilityConstants.MOTORIZZAZIONE && esecutore.OB_Document_Release_Authority__c != OB_UtilityConstants.PREFETTURA ) {
							mandatoryValidationCheck.put(OB_UtilityConstants.MANDATORYINPUTMAPCOMPANYDATA.get('legale_rappresentante').get('OB_Document_Release_Authority__c'),Label.OB_InvalidDocumentReleaseAuthority);
							}
							if ( esecutore.OB_Document_Expiration_Date__c < system.today( ) )
							{
								mandatoryValidationCheck.put(OB_UtilityConstants.MANDATORYINPUTMAPCOMPANYDATA.get('legale_rappresentante').get('OB_Document_Expiration_Date__c'),Label.OB_InvalidDocumentExpirationDate);
							}
							if ( esecutore.OB_Birth_Date__c > system.today( ).addYears( -16 ) || esecutore.OB_Birth_Date__c < checkBirthDate ) {
								mandatoryValidationCheck.put(OB_UtilityConstants.MANDATORYINPUTMAPCOMPANYDATA.get('legale_rappresentante').get('OB_Birth_Date__c'),Label.OB_InvalidBirthDate);
							}
                            if ( esecutore.OB_Document_Number__c.length() < 9 || esecutore.OB_Document_Number__c.length()  > 10 || esecutore.OB_Document_Number__c.isAlphaNumeric() == false )
							{
								mandatoryValidationCheck.put(OB_UtilityConstants.MANDATORYINPUTMAPCOMPANYDATA.get('legale_rappresentante').get('OB_Document_Expiration_Date__c'),Label.OB_InvalidDocumentExpirationDate);
							}
						}
					}
					
				}				

				}	
				/* ANDREA MORITTU END 17-Sept-2019 - BACKLOG_10 */

				data.put('isErrorCF',false);
                System.debug('esecutore.OB_Fiscal_Code_c : '+ esecutore.OB_Fiscal_Code__c);
                if ( esecutore.OB_Fiscal_Code__c != null && esecutore.OB_Fiscal_Code__c.length( ) == 16 )
                {
                    //  START   micol.ferrari 12/12/2018 -> OB_SkipCadastralCodeCheck__c
                    String errorCFType = checkNameSurnameCF( esecutore.FirstName, esecutore.LastName, esecutore.OB_Fiscal_Code__c, String.valueOf( esecutore.OB_Birth_Date__c ), esecutore.OB_Sex__c, esecutore.OB_Cadastral_Code__c, esecutore.OB_SkipCadastralCodeCheck__c );
                    //NEXI-123 02.07.2019 Damian Krzyzaniak <damian.krzyzaniak@accenture.com> START - check if Contact(Executor RT) FC is the same as Account FC when the legal form of the account is within given picklist
                    if ( isFCCompatibilityCheckRequired( acc.OB_Legal_Form__c ) && !esecutore.OB_Fiscal_Code__c.equalsIgnoreCase( acc.NE__Fiscal_code__c ) )
                    {
                        mandatoryValidationCheck.put( 'fiscalCodeLegaleRapp', Label.OB_SetupExecutorFCInvalid );
                        data.put( 'isErrorCF', true );
                    }
                    //NEXI-123 02.07.2019 damian.krzyzaniak@accenture.com STOP
                    else if ( errorCFType == 'errorName' )
                    {
                        system.debug( 'errorecfName' );
                        mandatoryValidationCheck.put( 'fiscalCodeLegaleRapp', Label.OB_InconsistentFiscalCode );
                        //mandatoryValidationCheck.put('input:legale_rappresentante:OB_Fiscal_Code__c',Label.OB_InconsistentFiscalCode);
                        data.put( 'isErrorCF', true );
                    }
                    else if ( errorCFType == 'errorData' )
                    {
                        system.debug( 'errorecfData' );
                        //mandatoryValidationCheck.put('input:legale_rappresentante:OB_Fiscal_Code__c',Label.OB_InvalidFiscalCodeBirthDate);
                        mandatoryValidationCheck.put( 'fiscalCodeLegaleRapp', Label.OB_InvalidFiscalCodeBirthDate );
                        data.put( 'isErrorCF', true );
                    }
                    else if ( errorCFType == 'errorSurname' )
                    {
                        system.debug( 'errorSurname' );
                        mandatoryValidationCheck.put( 'fiscalCodeLegaleRapp', Label.OB_InvalidFiscalCodeSurname );
                        data.put( 'isErrorCF', true );
                    }
                    else if ( errorCFType == 'errorGender' )
                    {
                        system.debug( 'errorGender' );
                        mandatoryValidationCheck.put( 'fiscalCodeLegaleRapp', Label.OB_InvalidFiscalCodeGender );
                        data.put( 'isErrorCF', true );
                    }
                    else if ( errorCFType == 'errorCadastralCode' )
                    {
                        system.debug( 'cadastralCode' );
                        mandatoryValidationCheck.put( 'fiscalCodeLegaleRapp', Label.OB_InvalidFiscalCodeCadastralCode );
                        data.put( 'isErrorCF', true );
                    }
                    //ANDREA MORITTU START 18/02/2019
                    else if ( errorCFType == 'errorLastChar' )
                    {
                        system.debug( 'errorLastChar' );
                        mandatoryValidationCheck.put( 'fiscalCodeLegaleRapp', Label.OB_InvalidFiscalCode );
                        data.put( 'isErrorCF', true );
                    }
                }
                system.debug( 'data error x exp' + Date.newInstance( esecutore.OB_Document_Release_Date__c.addYears( 10 ).year( ), esecutore.OB_Birth_Date__c.month( ), esecutore.OB_Birth_Date__c.day( ) ) );
                data.put( 'validationCheckMap', mandatoryValidationCheck );
                if ( mandatoryValidationCheck.size( ) >= 1 )
                {
                    System.debug( 'MAP not empty' + mandatoryValidationCheck );
                    data.put( 'setRedBordercompanyDataValidation', true );
                    isError = true;
                    System.debug( 'setRedBordercompanyDataValidation ::::' + data.get( 'setRedBordercompanyDataValidation' ) );
                }
                Object errorEEMapObject = data.get( 'errorEEMap' );

                Map<String, Object> mappaErrorEE = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( errorEEMapObject ) );
                if ( mappaErrorEE != null )
                {
                    for ( String key : mappaErrorEE.keySet( ) )
                    {
                        if ( ( Boolean ) ( mappaErrorEE.get( key ) ) )
                        {
                            isError = true;
                        }
                    }
                }
                //TODO BEFORE: check mandatory fields
                //Call web service to check if the merchant is in blacklist
                List<Contact> contactList = new List<Contact>( );
                esecutore.OB_BypassValidation__c = true;
                legalHeadquarter.OB_BypassValidation__c = true;

                if ( String.isEmpty( esecutore.Id ) )
                {
					esecutore.AccountId = acc.Id;
					esecutore.RecordTypeId = (RTNameId.get(OB_UtilityConstants.ESECUTORE)).Id;
					esecutore.OB_Bank__c = (Id) data.get('actualBank');
					contactListToInsert.add(esecutore);
					//START gianluigi.virga 01/10/2019 - Deactivate all others duplicate 'Esecutore'
					OB_FlowControlUtility.checkEsecutore(esecutore.AccountId, esecutore.RecordTypeId, esecutore.OB_Bank__c);
					//END gianluigi.virga 01/10/2019
                }
                else
                {
                    esecutore.AccountId = acc.Id;
                    esecutore.RecordTypeId = ( RTNameId.get( OB_UtilityConstants.ESECUTORE ) ).Id;
                    esecutore.OB_Bank__c = ( Id ) data.get( 'actualBank' );
                    contactListToUpdate.add( esecutore );
                }
                if ( String.isEmpty( legalHeadquarter.Id ) )
                {
                    legalHeadquarter.AccountId = acc.Id;
                    legalHeadquarter.RecordTypeId = ( RTNameId.get( OB_UtilityConstants.DATI_SOCIETA_LEGALE ) ).Id;
                    legalHeadquarter.OB_Bank__c = ( Id ) data.get( 'actualBank' );
                    legalHeadquarter.LastName = ( RTNameId.get( OB_UtilityConstants.DATI_SOCIETA_LEGALE ) ).Name;
                    contactListToInsert.add( legalHeadquarter );
                }
                else
                {
                    legalHeadquarter.AccountId = acc.Id;
                    legalHeadquarter.RecordTypeId = ( RTNameId.get( OB_UtilityConstants.DATI_SOCIETA_LEGALE ) ).Id;
                    legalHeadquarter.OB_Bank__c = ( Id ) data.get( 'actualBank' );
                    contactListToUpdate.add( legalHeadquarter );
                }
                if ( !isError )
                {
                    if ( contactListToInsert != null && contactListToInsert.size( ) > 0 )
                    {
                        insert contactListToInsert;
                        System.debug( 'Contacts Id ' + esecutore.Id + ' ' + legalHeadquarter.Id );
                    }
                    if ( contactListToUpdate != null && contactListToUpdate.size( ) > 0 )
                    {
                        System.debug( 'company Data Update' );
                        update contactListToUpdate;
                        System.debug( 'esecutore update Id ' + esecutore.Id );

                    }

                    bit2flow.B2FUtils.setJSONValue( data, 'legale_rappresentante', 'Id', esecutore.Id );
                    bit2flow.B2FUtils.setJSONValue( data, 'sede_legale', 'Id', legalHeadquarter.Id );
                    // Start antonio.vatrano  r1f3_94 19/09/2019
                    Boolean isMoto = false;
                    //START - elena.preteni 21/09/2019 change node in ObjectDataMap becasue odrer2 to present anymore
                    //START - antonio.vatrano 23/09/2019 r1f3-99
                    String MCCL3;
                    String mainProcess = String.valueOf(data.get('MainProcess'));
                    if (mainProcess == 'Setup'){
                        MCCL3 = ( String ) bit2flow.B2FUtils.getJSONValue( data, 'order2', 'OB_MCC__c' );
                    }else{
                        MCCL3 = ( String ) bit2flow.B2FUtils.getJSONValue( data, 'Configuration', 'OB_MCC__c' );
                    }
                     //END - antonio.vatrano 23/09/2019 r1f3-99
                    //END - elena.preteni 21/09/2019 change node in ObjectDataMap becasue odrer2 to present anymore
                    List<NE__Lov__c> lovList =[SELECT Id
                                                FROM NE__Lov__c
                                                WHERE NE__Type__c = :OB_Maintenance_EditServicePoint_Ctr.MCC
                                                AND NE__Value2__c = :MCCL3
                                                AND NE__Value1__c = :OB_Maintenance_EditServicePoint_Ctr.PO118];
                    if ( !lovList.isEmpty( ) ){	
                        if(isVirtuale){
                            //review antonio.vatrano 20/09/2019
                            isMoto = String.isBlank(typeGateway) ? false : ((typeGateway == 'MOTO') ? true : false);
                            orderHeader.OB_PO118_Ecommerce__c= !isMoto;
                            orderHeader.OB_PO118_MOTO__c= isMoto; 
                        }
                        else{
                            orderHeader.OB_isPO118__c = true;
                        }
                    }
                    // Start antonio.vatrano r1f3_94  19/09/2019
                    update orderHeader;
                    Boolean isLegalEqualAdm = ( Boolean ) data.get( 'isLegalEqualAdm' );
                    if ( isLegalEqualAdm )
                    {
                        acc.OB_Administrative_Office_Hamlet__c = acc.OB_Legal_Address_Hamlet__c;
                        acc.OB_Administrative_Office_Address_Details__c = acc.OB_Legal_Address_Detail__c;
                        acc.OB_Administrative_Office_City__c = acc.OB_Legal_Address_City__c;
                        acc.OB_Administrative_Office_Country__c = acc.OB_Legal_Address_Country__c;
                        acc.OB_Administrative_Office_Country_Code__c = acc.OB_Legal_Address_Country_Code__c;
                        acc.OB_Administrative_Office_State__c = acc.OB_Legal_Address_State__c;
                        acc.OB_Administrative_Office_State_Code__c = acc.OB_Legal_Address_State_Code__c;
                        acc.OB_Administrative_Office_Street__c = acc.OB_Legal_Address_Street__c;
                        acc.OB_Administrative_Office_Street_number__c = acc.OB_Legal_Address_Street_Number__c;
                        acc.OB_Administrative_Office_ZIP__c = acc.OB_Legal_Address_ZIP__c;
                    }

                    //  WN-167 Micol Ferrari <micol.ferrari@accenture.com>, 22/07/2019 - START
                    acc.OB_Legal_Form_Code__c = getLegalFormCode( acc.OB_Legal_Form__c, acc.OB_Legal_Form_Code__c );
                    //  WN-167 Micol Ferrari <micol.ferrari@accenture.com>, 22/07/2019 - STOP

                    //  START   micol.ferrari 17/10/2018 - BYPASS VALIDATION
                    acc.OB_BypassValidation__c = true;
                    update acc;
                    //  END     micol.ferrari 17/10/2018 - BYPASS VALIDATION
                }
            }
            // START AV 04/02/2019 CONS-87 ADD CONTROLL ON OB_Annual_Negotiated__c OB_Annual_Revenue__c OB_Employees_Number__c
            if ( !isError )
            {
                Object merchant = data.get( 'merchant' );
                if ( merchant != null )
                {
                    Map<String, Object> merch = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( merchant ) );
                    /* ANDREA MORITTU START 22-Jul-19 - Removed runtime conversion exception */
                    String annualNegotiatedString = String.valueOf( merch.get( 'OB_Annual_Negotiated__c' ) );
                    String annualRevenueString = String.valueOf( merch.get( 'OB_Annual_Revenue__c' ) );
                    String employeesNumString = String.valueOf( merch.get( 'OB_Employees_Number__c' ) );

                    if ( annualNegotiatedString != '' && annualRevenueString != '' )
                    {
                        /* ANDREA MORITTU END 22-Jul-19 - Removed runtime conversion exception */
                        Double annualNegotiated = double.valueOf( annualNegotiatedString );
                        Double annualRevenue = double.valueOf( annualRevenueString );
                        String employeesNum = employeesNumString;
                        if ( annualNegotiated <= 0 || annualRevenue <= 0 || annualNegotiated > annualRevenue )
                        {
                            isError = true;
                        }
                        if ( employeesNum == null || employeesNum == '' )
                        {
                            isError = true;
                        }
                    }
                }
            }
            // END AV 04/02/2019 CONS-87 ADD CONTROLL ON OB_Annual_Negotiated__c OB_Annual_Revenue__c OB_Employees_Number__c


        } catch ( Exception ecc )
        {
            //NEXI-178 Zuzanna Urban <z.urban@accenture.com>, 24/07/2019 start, add a log level
            System.debug( LoggingLevel.ERROR, 'Generic Error: ' + ecc.getMessage( ) + ' at line: ' + ecc.getLineNumber( ) + ' stack trace: ' + ecc.getStackTraceString( ) );
            //NEXI-178 Zuzanna Urban <z.urban@accenture.com>, 24/07/2019 stop, add a log level
        }
        System.debug( 'WIZARD WRAPPER COMPANY DATA ' + wizardWrapper.name );
        System.debug( 'method executed companyData' );
        if ( isError )
        {
            System.debug( 'ERROR COMPANY DATA STEP TO GO' );
            //GIOVANNI SPINELLI - 16/01/2019
            String stepToGo = getStepMapping( String.valueOf( wizardWrapper.name ), OB_UtilityConstants.STEP_DATI_SOCIETA );
            response.stepToGo = Integer.valueOf( stepToGo );
            response.result = bit2flow.DynamicWizardStepWrapper.OKCODE;
        }
        else
        {
            //GIOVANNI SPINELLI - 16/01/2019
            String stepToGo = getStepMapping( String.valueOf( wizardWrapper.name ), OB_UtilityConstants.STEP_TITOLARE_EFFETTIVO );
            response.stepToGo = Integer.valueOf( stepToGo );
        }
        response.result = bit2flow.DynamicWizardStepWrapper.OKCODE;
        response.data = data;
        System.debug( 'RESPONSE AFTER COMPANY DATA: ' + response );
        System.debug( 'datamap end method companyData' + JSON.serialize( data ) );
        return response;
    }

    //methods to save the Actual Owners of a service point: a service point can have up to 6 contacts. Each contact has a lookup to the merchant (Account created or retrieved before) and to the Order Header
    @AuraEnabled
    global static bit2flow.DynamicWizardStepWrapper actualOwner( String step, map<String, Object> data, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, String targetObjectKey, String method, bit2flow.DynamicWizardWrapper wizardWrapper )
    {
        System.debug( 'datamap begin method  actualOwner' + Json.serialize( data ) );
        bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper( );
        Boolean isError = false;
        Map<String, String> mandatoryValidationCheck = new Map<String, String>( );
        try
        {
            List<String> countryList = new List<String>( );

            for ( Integer i = 1; i < 7; i++ )
            {
                data.put( 'contact' + i + '_temp', null );
            }

            List<String> rtDevNamesContacts = new List<String> {OB_UtilityConstants.TITOLARE_EFFETTIVO};
            ID RTTitolareEffettivo = ( ( recordTypeQuery( 'Contact', rtDevNamesContacts ) ).get( OB_UtilityConstants.TITOLARE_EFFETTIVO ) ).Id;
            //Create 2 List: one for the records to insert, the other for the records to update.
            //After executing the insert, for those records we need to create the junction object (that connects the contact to the order header)
            List<Contact> actualOwnerContactsToInsert = new List<Contact>( );
            List<Contact> actualOwnerContactsToUpdate = new List<Contact>( );
            System.debug( 'dati complessi nel createConfiguration method cmp code ' + data );
            String listContInactive = JSON.serialize( data.get( 'ListContactsInactive' ) );
            List<String> listContactInactive = ( List<String> ) JSON.deserialize( listContInactive, List<String>.class );
            system.debug( 'listContactInactive:: ' + listContactInactive );
            String indexContact = JSON.serialize( data.get( 'lastContact' ) );
            system.debug( 'indexContact:: ' + indexContact );
            Contact contact1;
            Contact contact2;
            Contact contact3;
            Contact contact4;
            Contact contact5;
            Contact contact6;
            Boolean isErrorEE = false;

            Object errorEEMapObject = data.get( 'errorEEMap' );
            Map<String, Object> mappaErrorEE = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( errorEEMapObject ) );
            system.debug( 'data.get()' + bit2flow.B2FUtils.getJSONValue( data, 'contact1', 'LastName' ) );
            for ( Integer i = 1; i < 7; i++ )
            {
                setJSONNullFields( data, 'contact' + i, 'Id' );
                setJSONNullFields( data, 'contact' + i, 'OB_Birth_Date__c' );
                setJSONNullFields( data, 'contact' + i, 'OB_Document_Release_Date__c' );
                setJSONNullFields( data, 'contact' + i, 'OB_Document_Expiration_Date__c' );
            }
            //Since the contacts are not mandatory, it is possible that some contacts don't exist, so we check LastName of each contact before looking for them in the datamap (LastName is always mandatory for contacts)

            if ( bit2flow.B2FUtils.getJSONValue( data, 'contact1', 'LastName' ) != '' )
            {
                String contact1String = JSON.serialize( data.get( 'contact1_temp' ) );
                System.debug( ' contact1String string :' + contact1String );
                contact1 = ( Contact ) JSON.deserialize( contact1String, Contact.class );
                countryList.add( contact1.OB_Country_Birth__c );
            }
            if ( indexContact == '1' )
            {
                data.put( 'setRedBordercompanyData', false );
                data.put( 'checkMapValues', OB_MandatoryFormalCheck.inputCheck( data, 'actualOwnerOne' ) );
                if ( ( OB_MandatoryFormalCheck.inputCheck( data, 'actualOwnerOne' ) ).size( ) >= 1 )
                {

                    data.put( 'setRedBordercompanyData', true );
                    isError = true;
                }
                system.debug( 'isError mandatory:: ' + isError );
                if ( !isError )
                {
                    mandatoryValidationCheck = checkMandatoryValCheckCont( contact1, indexContact, mappaErrorEE );
                    data.put( 'validationCheckMap', mandatoryValidationCheck );
                    if ( mandatoryValidationCheck.size( ) >= 1 )
                    {
                        if ( mandatoryValidationCheck.get( 'fiscalCodeContact1' ) != null )
                        {
                            data.put( 'isErrorCF', true );
                        }
                        System.debug( 'MAP not empty' + mandatoryValidationCheck );
                        data.put( 'setRedBordercompanyDataValidation', true );
                        isError = true;
                        System.debug( 'setRedBordercompanyDataValidation ::::' + data.get( 'setRedBordercompanyDataValidation' ) );
                    }
                    if ( isErrorEE )
                    {
                        isError = true;
                    }
                }
                system.debug( 'isError:: ' + isError );
            }

            if ( bit2flow.B2FUtils.getJSONValue( data, 'contact2', 'LastName' ) != '' )
            {
                String contact2String = JSON.serialize( data.get( 'contact2_temp' ) );
                System.debug( ' contact2String string :' + contact2String );
                contact2 = ( Contact ) JSON.deserialize( contact2String, Contact.class );
                countryList.add( contact2.OB_Country_Birth__c );
            }
            if ( indexContact == '2' )
            {
                data.put( 'setRedBordercompanyData', false );
                system.debug( 'mappa errori obl' + OB_MandatoryFormalCheck.inputCheck( data, 'actualOwnerTwo' ) );
                data.put( 'checkMapValues', OB_MandatoryFormalCheck.inputCheck( data, 'actualOwnerTwo' ) );
                if ( ( OB_MandatoryFormalCheck.inputCheck( data, 'actualOwnerTwo' ) ).size( ) >= 1 )
                {
                    data.put( 'setRedBordercompanyData', true );
                    isError = true;
                }
                if ( !isError )
                {
                    mandatoryValidationCheck = checkMandatoryValCheckCont( contact2, indexContact, mappaErrorEE );
                    data.put( 'validationCheckMap', mandatoryValidationCheck );
                    if ( mandatoryValidationCheck.size( ) >= 1 )
                    {
                        if ( mandatoryValidationCheck.get( 'fiscalCodeContact2' ) != null )
                        {
                            data.put( 'isErrorCF', true );
                        }
                        System.debug( 'MAP not empty' + mandatoryValidationCheck );
                        data.put( 'setRedBordercompanyDataValidation', true );
                        isError = true;
                        System.debug( 'setRedBordercompanyDataValidation ::::' + data.get( 'setRedBordercompanyDataValidation' ) );
                    }
                    if ( isErrorEE )
                    {
                        isError = true;
                    }
                }
                system.debug( 'isError:: ' + isError );
            }

            if ( bit2flow.B2FUtils.getJSONValue( data, 'contact3', 'LastName' ) != '' )
            {
                String contact3String = JSON.serialize( data.get( 'contact3_temp' ) );
                System.debug( ' contact3String string :' + contact3String );
                contact3 = ( Contact ) JSON.deserialize( contact3String, Contact.class );
                countryList.add( contact3.OB_Country_Birth__c );
            }
            if ( indexContact == '3' )
            {
                data.put( 'setRedBordercompanyData', false );
                if ( ( OB_MandatoryFormalCheck.inputCheck( data, 'actualOwnerThree' ) ).size( ) >= 1 )
                {
                    data.put( 'checkMapValues', OB_MandatoryFormalCheck.inputCheck( data, 'actualOwnerThree' ) );
                    data.put( 'setRedBordercompanyData', true );
                    isError = true;
                }

                if ( !isError )
                {
                    mandatoryValidationCheck = checkMandatoryValCheckCont( contact3, indexContact, mappaErrorEE );
                    data.put( 'validationCheckMap', mandatoryValidationCheck );
                    if ( mandatoryValidationCheck.size( ) >= 1 )
                    {
                        if ( mandatoryValidationCheck.get( 'fiscalCodeContact3' ) != null )
                        {
                            data.put( 'isErrorCF', true );
                        }
                        System.debug( 'MAP not empty' + mandatoryValidationCheck );
                        data.put( 'setRedBordercompanyDataValidation', true );
                        isError = true;
                        System.debug( 'setRedBordercompanyDataValidation ::::' + data.get( 'setRedBordercompanyDataValidation' ) );
                    }
                    if ( isErrorEE )
                    {
                        isError = true;
                    }
                }
                system.debug( 'isError:: ' + isError );
            }

            if ( bit2flow.B2FUtils.getJSONValue( data, 'contact4', 'LastName' ) != '' )
            {
                String contact4String = JSON.serialize( data.get( 'contact4_temp' ) );
                System.debug( ' contact4String string :' + contact4String );
                contact4 = ( Contact ) JSON.deserialize( contact4String, Contact.class );
                countryList.add( contact4.OB_Country_Birth__c );
            }
            if ( indexContact == '4' )
            {
                data.put( 'setRedBordercompanyData', false );
                if ( ( OB_MandatoryFormalCheck.inputCheck( data, 'actualOwnerFour' ) ).size( ) >= 1 )
                {
                    data.put( 'checkMapValues', OB_MandatoryFormalCheck.inputCheck( data, 'actualOwnerFour' ) );
                    data.put( 'setRedBordercompanyData', true );
                    isError = true;
                }

                if ( !isError )
                {
                    mandatoryValidationCheck = checkMandatoryValCheckCont( contact4, indexContact, mappaErrorEE );
                    data.put( 'validationCheckMap', mandatoryValidationCheck );
                    if ( mandatoryValidationCheck.size( ) >= 1 )
                    {
                        if ( mandatoryValidationCheck.get( 'fiscalCodeContact4' ) != null )
                        {
                            data.put( 'isErrorCF', true );
                        }
                        System.debug( 'MAP not empty' + mandatoryValidationCheck );
                        data.put( 'setRedBordercompanyDataValidation', true );
                        isError = true;
                        System.debug( 'setRedBordercompanyDataValidation ::::' + data.get( 'setRedBordercompanyDataValidation' ) );
                    }
                    if ( isErrorEE )
                    {
                        isError = true;
                    }
                }
                system.debug( 'isError:: ' + isError );
            }

            if ( bit2flow.B2FUtils.getJSONValue( data, 'contact5', 'LastName' ) != '' )
            {
                String contact5String = JSON.serialize( data.get( 'contact5_temp' ) );
                System.debug( ' contact5String string :' + contact5String );
                contact5 = ( Contact ) JSON.deserialize( contact5String, Contact.class );
                countryList.add( contact5.OB_Country_Birth__c );
            }
            if ( indexContact == '5' )
            {
                data.put( 'setRedBordercompanyData', false );
                if ( ( OB_MandatoryFormalCheck.inputCheck( data, 'actualOwnerFive' ) ).size( ) >= 1 )
                {
                    data.put( 'checkMapValues', OB_MandatoryFormalCheck.inputCheck( data, 'actualOwnerFive' ) );
                    data.put( 'setRedBordercompanyData', true );
                    isError = true;
                }
                if ( !isError )
                {
                    mandatoryValidationCheck = checkMandatoryValCheckCont( contact5, indexContact, mappaErrorEE );
                    data.put( 'validationCheckMap', mandatoryValidationCheck );
                    if ( mandatoryValidationCheck.size( ) >= 1 )
                    {
                        if ( mandatoryValidationCheck.get( 'fiscalCodeContact5' ) != null )
                        {
                            data.put( 'isErrorCF', true );
                        }
                        System.debug( 'MAP not empty' + mandatoryValidationCheck );
                        data.put( 'setRedBordercompanyDataValidation', true );
                        isError = true;
                        System.debug( 'setRedBordercompanyDataValidation ::::' + data.get( 'setRedBordercompanyDataValidation' ) );
                    }
                    if ( isErrorEE )
                    {
                        isError = true;
                    }
                }
                system.debug( 'isError:: ' + isError );
            }

            if ( bit2flow.B2FUtils.getJSONValue( data, 'contact6', 'LastName' ) != '' )
            {
                String contact6String = JSON.serialize( data.get( 'contact6_temp' ) );
                System.debug( ' contact6String string :' + contact6String );
                contact6 = ( Contact ) JSON.deserialize( contact6String, Contact.class );
                countryList.add( contact6.OB_Country_Birth__c );
            }
            if ( indexContact == '6' )
            {
                data.put( 'setRedBordercompanyData', false );
                if ( ( OB_MandatoryFormalCheck.inputCheck( data, 'actualOwnerSix' ) ).size( ) >= 1 )
                {
                    data.put( 'checkMapValues', OB_MandatoryFormalCheck.inputCheck( data, 'actualOwnerSix' ) );
                    data.put( 'setRedBordercompanyData', true );
                    isError = true;
                }
                if ( !isError )
                {
                    mandatoryValidationCheck = checkMandatoryValCheckCont( contact6, indexContact, mappaErrorEE );
                    data.put( 'validationCheckMap', mandatoryValidationCheck );
                    if ( mandatoryValidationCheck.size( ) >= 1 )
                    {
                        if ( mandatoryValidationCheck.get( 'fiscalCodeContact6' ) != null )
                        {
                            data.put( 'isErrorCF', true );
                        }
                        System.debug( 'MAP not empty' + mandatoryValidationCheck );
                        data.put( 'setRedBordercompanyDataValidation', true );
                        isError = true;
                        System.debug( 'setRedBordercompanyDataValidation ::::' + data.get( 'setRedBordercompanyDataValidation' ) );
                    }
                    if ( isErrorEE )
                    {
                        isError = true;
                    }
                }
                system.debug( 'isError:: ' + isError );
            }


            List<NE__Lov__c> lovCadastralCode = [ SELECT Id, NE__Value2__c, Name FROM NE__Lov__c WHERE NE__Type__c = 'COUNTRY' AND Name IN:countryList ];
            Map<String, String> mapCountryCad = new Map<String, String>( );
            for ( NE__Lov__c lov : lovCadastralCode )
            {
                mapCountryCad.put( lov.Name, lov.NE__Value2__c );
            }

            String accString = JSON.serialize( data.get( 'merchant' ) );
            System.debug( ' Account string :' + accString );
            Account acc = ( Account ) JSON.deserialize( accString, Account.class );
            System.debug( ' Account dataMap :' + acc );

            //get OrderHeader already created
            String orderHeaderString = JSON.serialize( data.get( 'OrderHeader' ) );
            System.debug( ' orderHeaderString string :' + orderHeaderString );
            NE__Order_Header__c orderHeader = ( NE__Order_Header__c ) JSON.deserialize( orderHeaderString, NE__Order_Header__c.class );
            System.debug( ' NE__Order_Header__c dataMap :' + orderHeader );
            system.debug( 'contact1 2 3 4 5 6' + contact1 + ' ' + contact2 + ' ' + contact3 + ' ' + contact4 + ' ' + contact5 + ' ' + contact6 );
            if ( contact1 != null )
            {
                system.debug( 'exp date' + Date.valueOf( contact1.OB_Document_Expiration_Date__c ) );
                contact1.OB_BypassValidation__c = true;
                contact1.AccountId = acc.Id;
                contact1.RecordTypeId = RTTitolareEffettivo;
                contact1.OB_Bank__c = ( Id ) data.get( 'actualBank' );
                if ( contact1.OB_Country_Birth__c != 'ITALIA' )
                {
                    contact1.OB_Cadastral_Code__c = mapCountryCad.get( contact1.OB_Country_Birth__c );
                }
                contact1.OB_Contact_State__c = 'Active';
                if ( String.isBlank( contact1.Id ) )
                {
                    actualOwnerContactsToInsert.add( contact1 );
                }
                else
                {
                    actualOwnerContactsToUpdate.add( contact1 );
                }

            }
            if ( contact2 != null )
            {
                system.debug( 'contact2' + contact2 );
                contact2.OB_BypassValidation__c = true;
                contact2.AccountId = acc.Id;
                contact2.RecordTypeId = RTTitolareEffettivo;
                contact2.OB_Bank__c = ( Id ) data.get( 'actualBank' );
                if ( contact2.OB_Country_Birth__c != 'ITALIA' )
                {
                    contact2.OB_Cadastral_Code__c = mapCountryCad.get( contact2.OB_Country_Birth__c );
                }
                contact2.OB_Contact_State__c = 'Active';
                if ( String.isBlank( contact2.Id ) )
                {
                    actualOwnerContactsToInsert.add( contact2 );
                }
                else
                {
                    actualOwnerContactsToUpdate.add( contact2 );
                }

            }
            if ( contact3 != null )
            {
                contact3.OB_BypassValidation__c = true;
                contact3.AccountId = acc.Id;
                contact3.RecordTypeId = RTTitolareEffettivo;
                contact3.OB_Bank__c = ( Id ) data.get( 'actualBank' );
                if ( contact3.OB_Country_Birth__c != 'ITALIA' )
                {
                    contact3.OB_Cadastral_Code__c = mapCountryCad.get( contact3.OB_Country_Birth__c );
                }
                contact3.OB_Contact_State__c = 'Active';
                if ( String.isBlank( contact3.Id ) )
                {
                    actualOwnerContactsToInsert.add( contact3 );
                }
                else
                {
                    actualOwnerContactsToUpdate.add( contact3 );
                }

            }
            if ( contact4 != null )
            {
                contact4.OB_BypassValidation__c = true;
                contact4.AccountId = acc.Id;
                contact4.RecordTypeId = RTTitolareEffettivo;
                contact4.OB_Bank__c = ( Id ) data.get( 'actualBank' );
                if ( contact4.OB_Country_Birth__c != 'ITALIA' )
                {
                    contact4.OB_Cadastral_Code__c = mapCountryCad.get( contact4.OB_Country_Birth__c );
                }
                contact4.OB_Contact_State__c = 'Active';
                if ( String.isBlank( contact4.Id ) )
                {
                    actualOwnerContactsToInsert.add( contact4 );
                }
                else
                {
                    actualOwnerContactsToUpdate.add( contact4 );
                }
            }
            if ( contact5 != null )
            {
                contact5.OB_BypassValidation__c = true;
                contact5.AccountId = acc.Id;
                contact5.RecordTypeId = RTTitolareEffettivo;
                contact5.OB_Bank__c = ( Id ) data.get( 'actualBank' );
                if ( contact5.OB_Country_Birth__c != 'ITALIA' )
                {
                    contact5.OB_Cadastral_Code__c = mapCountryCad.get( contact5.OB_Country_Birth__c );
                }
                contact5.OB_Contact_State__c = 'Active';
                if ( String.isBlank( contact5.Id ) )
                {
                    actualOwnerContactsToInsert.add( contact5 );
                }
                else
                {
                    actualOwnerContactsToUpdate.add( contact5 );
                }
            }
            if ( contact6 != null )
            {
                contact6.OB_BypassValidation__c = true;
                contact6.AccountId = acc.Id;
                contact6.RecordTypeId = RTTitolareEffettivo;
                contact6.OB_Bank__c = ( Id ) data.get( 'actualBank' );
                if ( contact6.OB_Country_Birth__c != 'ITALIA' )
                {
                    contact6.OB_Cadastral_Code__c = mapCountryCad.get( contact6.OB_Country_Birth__c );
                }
                contact6.OB_Contact_State__c = 'Active';
                if ( String.isBlank( contact6.Id ) )
                {
                    actualOwnerContactsToInsert.add( contact6 );
                }
                else
                {
                    actualOwnerContactsToUpdate.add( contact6 );
                }
            }
            if ( listContactInactive != null && listContactInactive.size( ) > 0 )
            {
                for ( ID contId : listContactInactive )
                {
					Contact con = new Contact(Id = contId, OB_Contact_State__c = 'Inactive');
					actualOwnerContactsToUpdate.add(con);
				}
			}
			//START gianluigi.virga 04/07/2019 - PRODOB-184 - check if the new submitted contacts already exist
			data.put('fiscalCodeisDuplicate', false);
			data.put('duplicateFiscalCode', null);
			List<String> duplicateTitolariEffettivi = OB_FlowControlUtility.checkTitolareEffettivoAlreadyExist(data);
			if(!duplicateTitolariEffettivi.isEmpty() && duplicateTitolariEffettivi != null){
				isError = true;
				data.put('fiscalCodeisDuplicate', true);
				data.put('duplicateFiscalCode', duplicateTitolariEffettivi.get(0));
			}
			//END gianluigi.virga 04/07/2019
            if ( !isError )
            {
                if ( actualOwnerContactsToInsert != null && actualOwnerContactsToInsert.size( ) > 0 )
                {
                    insert actualOwnerContactsToInsert;
                }
                if ( actualOwnerContactsToUpdate != null && actualOwnerContactsToUpdate.size( ) > 0 )
                {
                    update actualOwnerContactsToUpdate;
                }

                if ( contact1 != null )
                    bit2flow.B2FUtils.setJSONValue( data, 'contact1', 'Id', contact1.Id );
                if ( contact2 != null )
                    bit2flow.B2FUtils.setJSONValue( data, 'contact2', 'Id', contact2.Id );
                if ( contact3 != null )
                    bit2flow.B2FUtils.setJSONValue( data, 'contact3', 'Id', contact3.Id );
                if ( contact4 != null )
                    bit2flow.B2FUtils.setJSONValue( data, 'contact4', 'Id', contact4.Id );
                if ( contact5 != null )
                    bit2flow.B2FUtils.setJSONValue( data, 'contact5', 'Id', contact5.Id );
                if ( contact6 != null )
                    bit2flow.B2FUtils.setJSONValue( data, 'contact6', 'Id', contact6.Id );

                Id configId = ( Id ) bit2flow.B2FUtils.getJSONValue( data, 'Configuration', 'Id' );
                system.debug( 'configId: ' + configId );
                NE__Order__c configuration = new NE__Order__c( );
                if ( configId != null )
                {
                    configuration = [ SELECT Id, OB_MCC_Description__c FROM NE__Order__c WHERE Id = :configId ];
                    system.debug( 'configuration: ' + configuration );
                    system.debug( 'DATA BEFORE SET CONFIGURATION: ' + JSON.serialize( data ) );
                    system.debug( 'configuration.OB_MCC_Description__c: ' + configuration.OB_MCC_Description__c );
                    String newConfiguration = JSON.serialize( data.get( 'Configuration' ) );
                    NE__Order__c configurationUt = ( NE__Order__c ) JSON.deserialize( newConfiguration, NE__Order__c.class );

                    configurationUt.OB_MCC_Description__c = configuration.OB_MCC_Description__c;
                    data.put( 'Configuration', configurationUt );
                    system.debug( 'DATA AFTER SET CONFIGURATION: ' + JSON.serialize( data ) );
                }

            }
        } catch ( Exception ecc )
        {
            //NEXI-178 Zuzanna Urban <z.urban@accenture.com>, 24/07/2019 start, add a log level
            System.debug( LoggingLevel.ERROR, 'Generic Error: ' + ecc.getMessage( ) + ' at line: ' + ecc.getLineNumber( ) + ' stack trace: ' + ecc.getStackTraceString( ) );
            //NEXI-178 Zuzanna Urban <z.urban@accenture.com>, 24/07/2019 stop, add a log level
        }

        if ( isError )
        {
            System.debug( 'Method KO' );
            String stepToGo = getStepMapping( String.valueOf( wizardWrapper.name ), OB_UtilityConstants.STEP_TITOLARE_EFFETTIVO );
            response.stepToGo = Integer.valueOf( stepToGo );
        }
        else
        {
            System.debug( 'Method OK' );
            String stepToGo = getStepMapping( String.valueOf( wizardWrapper.name ), OB_UtilityConstants.STEP_PUNTO_VENDITA );
            response.stepToGo = Integer.valueOf( stepToGo );
        }
        response.result = bit2flow.DynamicWizardStepWrapper.OKCODE;
        response.data = data;
        System.debug( 'End actual owner method ' + JSON.serialize( data ) );
        return response;
    }

    global static bit2flow.DynamicWizardStepWrapper servicePoint( String step, map<String, Object> data, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, String targetObjectKey, String method, bit2flow.DynamicWizardWrapper wizardWrapper )
    {
        bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper( );
        System.debug( 'datamap begin method ' + JSON.serialize( data ) );
        data.put( 'Responsabile_Amm_PV_temp', null );
        data.put( 'Responsabile_PV_temp', null );
        data.put( 'Referente_TecnicoPV_temp', null );

        OB_FlowCustomError errorObject = new OB_FlowCustomError( );
        Boolean isError = false;

        //Create 2 List: one for the records to insert, the other for the records to update.
        //After executing the insert, for the legal advisor record we need to create the junction object (that connects the contact to the order header)
        List<Contact> contactListToInsert = new List<Contact>( );
        List<Contact> contactListToUpdate = new List<Contact>( );
        Contact adminPerson;
        Contact pvPerson;
        Contact techContact;

        try
        {
            // START antonio.vatrano 05/12/2019 PERF - 2
            // setJSONNullFields( data, 'Responsabile_Amm_PV', 'Id' );
            // setJSONNullFields( data, 'Responsabile_PV', 'Id' );
            // setJSONNullFields( data, 'Referente_TecnicoPV', 'Id' );
            // END antonio.vatrano 05/12/2019 PERF - 2

            String openingTime = '';
            String endingTime = '';
            String breakStartTime = '';
            String breakEndTime = '';

            // Get Merchant Already created
            String accString = JSON.serialize( data.get( 'merchant' ) );
            System.debug( ' Account string :' + accString );
            Account acc = ( Account ) JSON.deserialize( accString, Account.class );
            System.debug( ' Account dataMap :' + acc );
            NE__Service_Point__c sp = new NE__Service_Point__c( );
            //get OrderHeader already created
            String orderHeaderString = JSON.serialize( data.get( 'OrderHeader' ) );
            System.debug( ' orderHeaderString string :' + orderHeaderString );
            NE__Order_Header__c orderHeader = ( NE__Order_Header__c ) JSON.deserialize( orderHeaderString, NE__Order_Header__c.class );
            System.debug( ' NE__Order_Header__c dataMap :' + orderHeader );
            //GIOVANNI SPINELLI - START
            Object servicePointObject = data.get( 'pv' );
            Map<String, Object> servicePointMap = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( servicePointObject ) );
            Object openingTimeTmp = servicePointMap.get( 'OB_Opening_Time__c' );
            Object endingTimeTmp = servicePointMap.get( 'OB_Ending_Time__c' );
            Object breakStartTimeTmp = servicePointMap.get( 'OB_Break_Start_Time__c' );
            Object breakEndTimeTmp = servicePointMap.get( 'OB_Break_End_Time__c' );
            //****** SIMONE MISANI 04/02/2019 - CHANGE  FIELD CONTROLL - START ************//
            /*ANDREA MORITTU START 2019.Aug.22 - UX.xxx - Radio Button Checkboxes mandatory logic */
			Object privacyC3	= servicePointMap.get('OB_Privacy_C3__c');
			System.debug('## privacyC3 is ' + privacyC3);
			Object privacyC4	= servicePointMap.get('OB_Privacy_C4__c');
			System.debug('## privacyC4 is ' + privacyC4);
			Object privacyC5	= servicePointMap.get('OB_Privacy_C5__c');
			System.debug('## privacyC5 is ' + privacyC5);
			Boolean privacyIsBlank = false;
			Map<String, String> mandatoryValidationChecktTime = new Map<String, String>();
			/*ANDREA MORITTU END 2019.Aug.22 - UX.xxx - Radio Button Checkboxes mandatory logic */
            System.debug( 'data.keySet(): ' + JSON.serialize( data.keySet( ) ) );
            system.debug( 'before if' );

            if ( data.keySet( ).contains( 'pv' ) )
            {
                if ( !String.isBlank( String.valueOf( openingTimeTmp ) ) )
                {
                    openingTime = ( String ) ( bit2flow.B2FUtils.getJSONValue( data, 'pv', 'OB_Opening_Time__c' ) );
                    bit2flow.B2FUtils.setJSONValue( data, 'pv', 'OB_Opening_Time__c', null );
                }

                System.debug( '@@@@1 - OB_Opening_Time__c should be null: ' + JSON.serialize( data ) );

                if ( !String.isBlank( String.valueOf( endingTimeTmp ) ) )
                {
                    System.debug( 'IF ENDING' );
                    endingTime = ( String ) ( bit2flow.B2FUtils.getJSONValue( data, 'pv', 'OB_Ending_Time__c' ) );
                    bit2flow.B2FUtils.setJSONValue( data, 'pv', 'OB_Ending_Time__c', null );
                }

                System.debug( '2 - OB_Ending_Time__c should be null: ' + JSON.serialize( data ) );

                if ( !String.isBlank( String.valueOf( breakStartTimeTmp ) ) )
                {
                    breakStartTime = ( String ) ( bit2flow.B2FUtils.getJSONValue( data, 'pv', 'OB_Break_Start_Time__c' ) );
                    bit2flow.B2FUtils.setJSONValue( data, 'pv', 'OB_Break_Start_Time__c', null );
                }

                System.debug( '3 - OB_Break_Start_Time__c should be null: ' + JSON.serialize( data ) );

                if ( !String.isBlank( String.valueOf( breakEndTimeTmp ) ) )
                {
                    System.debug( 'IF END BREAK' );
                    breakEndTime = ( String ) ( bit2flow.B2FUtils.getJSONValue( data, 'pv', 'OB_Break_End_Time__c' ) );
                    bit2flow.B2FUtils.setJSONValue( data, 'pv', 'OB_Break_End_Time__c', null );
                }

                System.debug( '4 - OB_Break_End_Time__c should be null: ' + JSON.serialize( data ) );
            }

            //****** SIMONE MISANI 04/02/2019 - CHANGE  FIELD CONTROLL - END ************//
            //GIOVANNI SPINELLI - END
            String pvString = JSON.serialize( data.get( 'pv' ) );
            system.debug( 'pvString' + pvString );

            NE__Service_Point__c oldPv = ( NE__Service_Point__c ) JSON.deserialize( pvString, NE__Service_Point__c.class );
            system.debug( 'oldPv object' + oldPv );
            //g.s. put again value in objdatamap --> to have them at previous
            if ( !String.isBlank( String.valueOf( openingTimeTmp ) ) )
            {
                bit2flow.B2FUtils.setJSONValue( data, 'pv', 'OB_Opening_Time__c', String.valueOf( openingTimeTmp ) );
            }
            if ( !String.isBlank( String.valueOf( endingTimeTmp ) ) )
            {
                bit2flow.B2FUtils.setJSONValue( data, 'pv', 'OB_Ending_Time__c', String.valueOf( endingTimeTmp ) );

            }
            if ( !String.isBlank( String.valueOf( breakStartTimeTmp ) ) )
            {
                bit2flow.B2FUtils.setJSONValue( data, 'pv', 'OB_Break_Start_Time__c', String.valueOf( breakStartTimeTmp ) );
            }
            if ( !String.isBlank( String.valueOf( breakEndTimeTmp ) ) )
            {
                bit2flow.B2FUtils.setJSONValue( data, 'pv', 'OB_Break_End_Time__c', String.valueOf( breakEndTimeTmp ) );
            }

            if ( !String.IsBlank( openingTime ) )
            {
                oldPv.OB_Opening_Time__c = ParseTime( openingTime );
            }
            if ( !String.IsBlank( endingTime ) )
            {
                oldPv.OB_Ending_Time__c = ParseTime( endingTime );
            }
            if ( !String.IsBlank( breakStartTime ) )
            {
                oldPv.OB_Break_Start_Time__c = ParseTime( breakStartTime );
            }
            if ( !String.IsBlank( breakEndTime ) )
            {
                oldPv.OB_Break_End_Time__c = ParseTime( breakEndTime );
            }
            if ( data.keySet( ).contains( 'pv' ) && !String.IsBlank( openingTime ) )
            {
                bit2flow.B2FUtils.setJSONValue( data, 'pv', 'OB_Opening_Time__c', String.valueOf( oldPv.OB_Opening_Time__c ) );
            }
            if ( data.keySet( ).contains( 'pv' ) && !String.IsBlank( endingTime ) )
            {
                bit2flow.B2FUtils.setJSONValue( data, 'pv', 'OB_Ending_Time__c', String.valueOf( oldPv.OB_Ending_Time__c ) );
            }
            if ( data.keySet( ).contains( 'pv' ) && !String.IsBlank( breakStartTime ) )
            {
                bit2flow.B2FUtils.setJSONValue( data, 'pv', 'OB_Break_Start_Time__c', String.valueOf( oldPv.OB_Break_Start_Time__c ) );
            }
            if ( data.keySet( ).contains( 'pv' ) && !String.IsBlank( breakEndTime ) )
            {
                bit2flow.B2FUtils.setJSONValue( data, 'pv', 'OB_Break_End_Time__c', String.valueOf( oldPv.OB_Break_End_Time__c ) );
            }
            System.debug( 'DATA AFTER SET PV: ' + JSON.serialize( data ) );
            //Doris D ___START____ 15/10/2018
            System.debug( 'isError Value line 1681: ' + isError );
            if ( isError == false )
            {   
                /*ANDREA MORITTU START 2019.Aug.22 - UX.xxx - Radio Button Checkboxes mandatory logic */
                Boolean activateMandatoryChecksPrivacyInput	= Boolean.valueOf(data.get('activateMandatoryChecksPrivacyInput'));
				System.debug('## privacy Mandatory is : ' + activateMandatoryChecksPrivacyInput);
				if(activateMandatoryChecksPrivacyInput) {
				    if(privacyC3 == null || privacyC3 == '') {
						privacyIsBlank = true;
						mandatoryValidationChecktTime.put(OB_UtilityConstants.MANDATORYINPUTMAPSERVICEPOINT.get('pv').get('OB_Privacy_C3__c'),Label.MandatoryField);
					}
					if(privacyC4 == null || privacyC4 == '') {
						mandatoryValidationChecktTime.put(OB_UtilityConstants.MANDATORYINPUTMAPSERVICEPOINT.get('pv').get('OB_Privacy_C4__c'),Label.MandatoryField);
						privacyIsBlank = true;
					}
					if(privacyC5 == null || privacyC5 == '') {
						mandatoryValidationChecktTime.put(OB_UtilityConstants.MANDATORYINPUTMAPSERVICEPOINT.get('pv').get('OB_Privacy_C5__c'),Label.MandatoryField);
						privacyIsBlank = true;
					}

					if(privacyIsBlank) {
						data.put('setRedBorderServicePointStep',true);
						isError = true;
						errorObject.message = 'Valorizzare tutti i campi';
						errorObject.severity='ERROR';
						
						System.debug('## setRedBorder' + data.get('setRedBorder'));
					}
				}
				/*ANDREA MORITTU END 2019.Aug.22 - UX.xxx - Radio Button Checkboxes mandatory logic */
                Time midnight = Time.newInstance( 00, 00, 00, 00 );
                
                System.debug( 'oldPv.OB_Opening_Time__c: ' + oldPv.OB_Opening_Time__c + ' oldPv.OB_Ending_Time__c  ' + oldPv.OB_Ending_Time__c );

                if ( ( oldPv.OB_Opening_Time__c == null && oldPv.OB_Ending_Time__c == null ) && ( oldPv.OB_Break_Start_Time__c != null && oldPv.OB_Break_End_Time__c != null ) )
                {
                    System.debug( 'INTO ERROR 1' );
                    mandatoryValidationChecktTime.put( OB_UtilityConstants.MANDATORYINPUTMAPSERVICEPOINTOPENING.get( 'pv' ).get( 'OB_Opening_Time__c' ), Label.MandatoryField );
                    mandatoryValidationChecktTime.put( OB_UtilityConstants.MANDATORYINPUTMAPSERVICEPOINTOPENING.get( 'pv' ).get( 'OB_Ending_Time__c' ), Label.MandatoryField );
                }

                if ( ( oldPv.OB_Opening_Time__c != null && oldPv.OB_Ending_Time__c == null ) && ( oldPv.OB_Break_Start_Time__c != null && oldPv.OB_Break_End_Time__c != null ) )
                {
                    System.debug( 'INTO ERROR 2' );
                    mandatoryValidationChecktTime.put( OB_UtilityConstants.MANDATORYINPUTMAPSERVICEPOINTOPENING.get( 'pv' ).get( 'OB_Ending_Time__c' ), Label.MandatoryField );
                }

                if ( ( oldPv.OB_Opening_Time__c == null && oldPv.OB_Ending_Time__c != null ) && ( oldPv.OB_Break_Start_Time__c != null && oldPv.OB_Break_End_Time__c != null ) )
                {
                    System.debug( 'INTO ERROR 3' );
                    mandatoryValidationChecktTime.put( OB_UtilityConstants.MANDATORYINPUTMAPSERVICEPOINTOPENING.get( 'pv' ).get( 'OB_Opening_Time__c' ), Label.MandatoryField );
                }

                if ( ( oldPv.OB_Opening_Time__c != null && oldPv.OB_Ending_Time__c != null )
                        &&
                        ( oldPv.OB_Break_Start_Time__c == null && oldPv.OB_Break_End_Time__c != null )
                        &&
                        ( ( oldPv.OB_Break_End_Time__c > oldPv.OB_Opening_Time__c ) && ( oldPv.OB_Break_End_Time__c < oldPv.OB_Ending_Time__c || oldPv.OB_Ending_Time__c == midnight ) )
                        )
                {
                    System.debug( 'INTO ERROR 4' );
                    mandatoryValidationChecktTime.put( OB_UtilityConstants.MANDATORYINPUTMAPSERVICEPOINTBREAKTIME.get( 'pv' ).get( 'OB_Break_Start_Time__c' ), Label.MandatoryField );
                }

                if ( ( oldPv.OB_Opening_Time__c != null && oldPv.OB_Ending_Time__c != null )
                        &&
                        ( oldPv.OB_Break_Start_Time__c != null && oldPv.OB_Break_End_Time__c == null )
                        &&
                        ( ( oldPv.OB_Break_Start_Time__c > oldPv.OB_Opening_Time__c ) && ( oldPv.OB_Break_Start_Time__c < oldPv.OB_Ending_Time__c || oldPv.OB_Ending_Time__c == midnight ) )
                        )
                {
                    System.debug( 'INTO ERROR 5' );
                    mandatoryValidationChecktTime.put( OB_UtilityConstants.MANDATORYINPUTMAPSERVICEPOINTBREAKTIME.get( 'pv' ).get( 'OB_Break_End_Time__c' ), Label.MandatoryField );
                }


                if ( ( oldPv.OB_Opening_Time__c != null && oldPv.OB_Ending_Time__c != null ) || ( oldPv.OB_Break_Start_Time__c != null && oldPv.OB_Break_End_Time__c != null ) )
                {

                    if ( ( oldPv.OB_Opening_Time__c >= oldPv.OB_Ending_Time__c && oldPv.OB_Ending_Time__c != midnight )
                            ||
                            ( oldPv.OB_Opening_Time__c == oldPv.OB_Ending_Time__c && oldPv.OB_Ending_Time__c == midnight && oldPv.OB_Opening_Time__c == midnight ) )
                    {
                        System.debug( 'INTO ERROR 6' );
                        mandatoryValidationChecktTime.put( OB_UtilityConstants.MANDATORYINPUTMAPSERVICEPOINTOPENING.get( 'pv' ).get( 'OB_Ending_Time__c' ), Label.OB_EndTimeGreater );
                    }

                    if ( oldPv.OB_Opening_Time__c < oldPv.OB_Ending_Time__c && oldPv.OB_Ending_Time__c != midnight )
                    {

                        if ( ( ( oldPv.OB_Break_Start_Time__c > oldPv.OB_Opening_Time__c ) && ( oldPv.OB_Break_Start_Time__c < oldPv.OB_Ending_Time__c && oldPv.OB_Ending_Time__c != midnight ) )
                                &&
                                ( ( oldPv.OB_Break_End_Time__c <= oldPv.OB_Opening_Time__c ) || ( oldPv.OB_Break_End_Time__c >= oldPv.OB_Ending_Time__c && oldPv.OB_Ending_Time__c != midnight ) )
                                )
                        {
                            mandatoryValidationChecktTime.put( OB_UtilityConstants.MANDATORYINPUTMAPSERVICEPOINTBREAKTIME.get( 'pv' ).get( 'OB_Break_End_Time__c' ), Label.OB_BreakTimeIncoherent );
                        }
                        else if ( ( ( oldPv.OB_Break_End_Time__c > oldPv.OB_Opening_Time__c ) && ( oldPv.OB_Break_End_Time__c < oldPv.OB_Ending_Time__c && oldPv.OB_Ending_Time__c != midnight ) )
                                &&
                                ( ( oldPv.OB_Break_Start_Time__c <= oldPv.OB_Opening_Time__c ) || ( oldPv.OB_Break_Start_Time__c >= oldPv.OB_Ending_Time__c && oldPv.OB_Ending_Time__c != midnight ) )
                                )
                        {
                            mandatoryValidationChecktTime.put( OB_UtilityConstants.MANDATORYINPUTMAPSERVICEPOINTBREAKTIME.get( 'pv' ).get( 'OB_Break_Start_Time__c' ), Label.OB_BreakTimeIncoherent );
                        }
                    }

                    if ( ( ( oldPv.OB_Break_Start_Time__c <= oldPv.OB_Opening_Time__c ) || ( oldPv.OB_Break_Start_Time__c >= oldPv.OB_Ending_Time__c && oldPv.OB_Ending_Time__c != midnight ) )
                            &&
                            ( ( oldPv.OB_Break_End_Time__c <= oldPv.OB_Opening_Time__c ) || ( oldPv.OB_Break_End_Time__c >= oldPv.OB_Ending_Time__c && oldPv.OB_Ending_Time__c != midnight ) ) )
                    {
                        mandatoryValidationChecktTime.put( OB_UtilityConstants.MANDATORYINPUTMAPSERVICEPOINTBREAKTIME.get( 'pv' ).get( 'OB_Break_Start_Time__c' ), Label.OB_BreakTimeIncoherent );
                        mandatoryValidationChecktTime.put( OB_UtilityConstants.MANDATORYINPUTMAPSERVICEPOINTBREAKTIME.get( 'pv' ).get( 'OB_Break_End_Time__c' ), Label.OB_BreakTimeIncoherent );

                    }

                    if ( oldPv.OB_Break_Start_Time__c >= oldPv.OB_Break_End_Time__c && oldPv.OB_Break_End_Time__c != midnight )
                    {
                        mandatoryValidationChecktTime.put( OB_UtilityConstants.MANDATORYINPUTMAPSERVICEPOINTBREAKTIME.get( 'pv' ).get( 'OB_Break_End_Time__c' ), Label.OB_BreakEndTimeGreater );
                    }
                }

                //NEXI-141 Michal Targiel<michal.targiel@accenture.com>, 04/07/2019 START
                if ( oldPv.NE__Account__c != null )
                {
                    List<Account> accounts =
                    [
                            SELECT OB_VAT_Not_Present__c,
                                    OB_DescriptionVATNotPresent__c
                            FROM Account
                            WHERE Id = :oldPv.NE__Account__c
                    ];
                    if ( !accounts.isEmpty( ) )
                    {
                        if ( accounts.get( 0 ).OB_VAT_Not_Present__c == true
                                && OB_UtilityConstants.LIVIGNO.equalsIgnoreCase( accounts.get( 0 ).OB_DescriptionVATNotPresent__c )
                                && !OB_UtilityConstants.LIVIGNO.equalsIgnoreCase( oldPv.NE__City__c ) )
                        {
                            mandatoryValidationChecktTime.put( OB_UtilityConstants.COMUNE.toLowerCase( ), Label.OB_LIVIGNO_CHECK_ERROR );
                        }
                    }
                }
                //NEXI-141 Michal Targiel<michal.targiel@accenture.com>, 04/07/2019 STOP

                data.put( 'checkMapValuesServicePointStepValidation', mandatoryValidationChecktTime );
                if ( mandatoryValidationChecktTime.size( ) >= 1 )
                {
                    System.debug( 'MAP not empty' + mandatoryValidationChecktTime );
                    data.put( 'setRedBorderServicePointStepValidation', true );
                    isError = true;
                }

                //***********GIOVANNI SPINELLI - 03/10/2018 - MANDATORY FIELD CONTROL - START ***************//
                if ( ( OB_MandatoryFormalCheck.inputCheck( data, 'servicePoint' ) ).size( ) >= 1 )
                {
                    System.debug( 'MAP SP not empty' );
                    data.put( 'checkMapValuesServicePointStep', OB_MandatoryFormalCheck.inputCheck( data, 'servicePoint' ) );
                    data.put( 'setRedBorderServicePointStep', true );
                    isError = true;
                    System.debug( 'datamap into if method of service point step ' + data.get( 'pv' ) );
                    System.debug( 'the boolean into sp step : ' + isError );
                }
                //***********GIOVANNI SPINELLI - 03/10/2018 - MANDATORY FIELD CONTROL - END  ***************//
            }

            //Doris D ___END____ 15/10/2018

            if ( bit2flow.B2FUtils.getJSONValue( data, 'Responsabile_Amm_PV', 'LastName' ) != '' )
            {
                String adminString = JSON.serialize( data.get( 'Responsabile_Amm_PV' ) ); //  antonio.vatrano 05/12/2019 PERF - 2
                System.debug( ' adminString string :' + adminString );
                adminPerson = ( Contact ) JSON.deserialize( adminString, Contact.class );
                System.debug( ' adminPerson dataMap :' + adminPerson );
            }

            if ( bit2flow.B2FUtils.getJSONValue( data, 'Responsabile_PV', 'LastName' ) != '' )
            {
                String pvPersonString = JSON.serialize( data.get( 'Responsabile_PV' ) ); //  antonio.vatrano 05/12/2019 PERF - 2
                System.debug( ' pvPersonString string :' + pvPersonString );
                pvPerson = ( Contact ) JSON.deserialize( pvPersonString, Contact.class );
                System.debug( ' pvPerson dataMap :' + pvPerson );
            }

            if ( bit2flow.B2FUtils.getJSONValue( data, 'Referente_TecnicoPV', 'LastName' ) != '' )
            {
                String techString = JSON.serialize( data.get( 'Referente_TecnicoPV' ) ); //  antonio.vatrano 05/12/2019 PERF - 2
                System.debug( ' techString string :' + techString );
                techContact = ( Contact ) JSON.deserialize( techString, Contact.class );
                System.debug( ' techContact dataMap :' + techContact );
            }

            system.debug( 'actualBank contacts' + ( Id ) data.get( 'actualBank' ) );
            //TODO BEFORE: check mandatory fields
            List<Contact> contactList = new List<Contact>( );
            if ( adminPerson != null )
            {
                //NEXI-112 Zuzanna Urban <z.urban@accenture.com> 24/06/2019 - Start, change logic for lookup
                adminPerson.OB_Service_Point__c = oldPv.Id;
                //NEXI-112 Zuzanna Urban <z.urban@accenture.com> 24/06/2019 - Stop, change logic for lookup

                //ANDREA @START : SAVE CONTACT ONLY IF FIRSTNAME, LASTNAME, EMAIL, MOBILEPHONE ALL COMPILED
                System.debug( 'Admin Person: ' + 'FirstName : ' + adminPerson.FirstName + 'LastName: '
                        + adminPerson.LastName + 'Email: ' + adminPerson.Email + 'MobilePhone: ' + adminPerson.MobilePhone );
                if ( ( !String.isBlank( adminPerson.FirstName ) ) &&
                        ( !String.isBlank( adminPerson.LastName ) ) &&
                        ( !String.isBlank( adminPerson.Email ) ) &&
                        ( !String.isBlank( adminPerson.MobilePhone ) ) )
                {
                    System.debug( '@@@ I AM INSIDE ADMINPERSON NOT NULL' );
                    System.debug( 'String.isEmpty(adminPerson.Id)?' + String.isEmpty( adminPerson.Id ) );
                    if ( String.isBlank( adminPerson.Id ) )
                    {
                        adminPerson.AccountId = acc.Id;
                        adminPerson.Id = null;
                        adminPerson.OB_Bank__c = ( Id ) data.get( 'actualBank' );
                        contactListToInsert.add( adminPerson );
                        System.debug( 'My AdminPerson is : ' + adminPerson );

                    }
                    else
                    {
                        contactListToUpdate.add( adminPerson );
                        System.debug( 'My AdminPerson Updated is : ' + adminPerson );
                    }
                }
                else if ( ( String.isBlank( adminPerson.FirstName ) ) &&
                        ( String.isBlank( adminPerson.LastName ) ) &&
                        ( String.isBlank( adminPerson.Email ) ) &&
                        ( String.isBlank( adminPerson.MobilePhone ) ) )
                {
                    isError = true;
                    errorObject.message = 'Valorizzare tutti i campi';
                    errorObject.severity = 'ERROR';
                    System.debug( 'setRedBorder ::::' + data.get( 'setRedBorder' ) );
                }
                //ANDREA END : SAVE CONTACT ONLY IF FIRSTNAME, LASTNAME, EMAIL, MOBILEPHONE ALL COMPILED
            }
            if ( pvPerson != null )
            {
                //NEXI-112 Zuzanna Urban <z.urban@accenture.com> 24/06/2019 - Start, change logic for lookup
                pvPerson.OB_Service_Point__c = oldPv.Id;
                //NEXI-112 Zuzanna Urban <z.urban@accenture.com> 24/06/2019 - Stop, change logic for lookup
                //ANDREA @START : SAVE CONTACT ONLY IF FIRSTNAME, LASTNAME, EMAIL, MOBILEPHONE ALL COMPILED
                if ( ( !String.isBlank( pvPerson.FirstName ) ) &&
                        ( !String.isBlank( pvPerson.LastName ) ) &&
                        ( !String.isBlank( pvPerson.Email ) ) &&
                        ( !String.isBlank( pvPerson.MobilePhone ) )
                        )
                //ANDREA END : SAVE CONTACT ONLY IF FIRSTNAME, LASTNAME, EMAIL, MOBILEPHONE ALL COMPILED
                {
                    if ( String.isBlank( pvPerson.Id ) )
                    {
                        pvPerson.AccountId = acc.Id;
                        pvPerson.Id = null; //  antonio.vatrano 05/12/2019 PERF - 2
                        pvPerson.OB_Bank__c = ( Id ) data.get( 'actualBank' );
                        contactListToInsert.add( pvPerson );
                        System.debug( 'My pvPerson is : ' + pvPerson ); //  antonio.vatrano 05/12/2019 PERF - 2
                    }
                    else
                    {
                        contactListToUpdate.add( pvPerson );
                        System.debug( 'My pvPerson updated is : ' + pvPerson ); //  antonio.vatrano 05/12/2019 PERF - 2
                    }
                }
            }

            if ( techContact != null )
            {
                //NEXI-112 Zuzanna Urban <z.urban@accenture.com> 24/06/2019 - Start, change logic for lookup
                techContact.OB_Service_Point__c = oldPv.Id;
                //NEXI-112 Zuzanna Urban <z.urban@accenture.com> 24/06/2019 - Stop, change logic for lookup
                //ANDREA @START : SAVE CONTACT ONLY IF FIRSTNAME, LASTNAME, EMAIL, MOBILEPHONE ALL COMPILED
                if ( ( !String.isBlank( techContact.FirstName ) ) &&
                        ( !String.isBlank( techContact.LastName ) ) &&
                        ( !String.isBlank( techContact.Email ) ) &&
                        ( !String.isBlank( techContact.MobilePhone ) ) )
                {
                    //ANDREA END : SAVE CONTACT ONLY IF FIRSTNAME, LASTNAME, EMAIL, MOBILEPHONE ALL COMPILED

                    if ( String.isBlank( techContact.Id ) )
                    {
                        techContact.AccountId = acc.Id;
                        techContact.Id = null;  //  antonio.vatrano 05/12/2019 PERF - 2
                        techContact.OB_Bank__c = ( Id ) data.get( 'actualBank' );
                        contactListToInsert.add( techContact );
                    }
                    else
                    {
                        contactListToUpdate.add( techContact );
                    }
                }
            }

            if ( !isError )
            {
                // Start antonio.vatrano 05/12/2019 PERF - 2
                System.debug('@@@@contactListToInsert: '+JSON.serialize(contactListToInsert));
                System.debug('@@@@contactListToUpdate: '+JSON.serialize(contactListToUpdate));
                // End antonio.vatrano 05/12/2019 PERF - 2
                if ( contactListToInsert != null && contactListToInsert.size( ) > 0 )
                {
                    insert contactListToInsert;
                }
                if ( contactListToUpdate != null && contactListToUpdate.size( ) > 0 )
                {
                    System.debug( 'company Data Update' );
                    update contactListToUpdate;
                }
                if ( adminPerson != null )
                {
                    //NEXI-112 Zuzanna Urban <z.urban@accenture.com> 24/06/2019 - Start, change logic for lookup
                    bit2flow.B2FUtils.setJSONValue( data, 'Responsabile_Amm_PV', 'Id', adminPerson.Id );
                    //NEXI-112 Zuzanna Urban <z.urban@accenture.com> 24/06/2019 - Stop, change logic for lookup
                }
                if ( pvPerson != null )
                {
                    //NEXI-112 Zuzanna Urban <z.urban@accenture.com> 24/06/2019 - Start, change logic for lookup
                    bit2flow.B2FUtils.setJSONValue( data, 'Responsabile_PV', 'Id', pvPerson.Id );
                    //NEXI-112 Zuzanna Urban <z.urban@accenture.com> 24/06/2019 - Stop, change logic for lookup
                }
                if ( techContact != null )
                {
                    //NEXI-112 Zuzanna Urban <z.urban@accenture.com> 24/06/2019 - Start, change logic for lookup
                    bit2flow.B2FUtils.setJSONValue( data, 'Referente_TecnicoPV', 'Id', techContact.Id );
                    ////NEXI-112 Zuzanna Urban <z.urban@accenture.com> 24/06/2019 - Stop, change logic for lookup
                }

                //  START   micol.ferrari 17/10/2018 - BYPASS VALIDATION
                oldPv.OB_BypassValidation__c = true;
                System.debug( 'OLD PV BEFORE UPDATE: ' + oldPv );
                update oldPv;
                //  END     micol.ferrari 17/10/2018 - BYPASS VALIDATION
                // PRODOB-61 , Doris Dongmo <doris.tatiana.dongmo@accenture.com>,  29/04/2019 - START
                String configurationString = JSON.serialize( data.get( 'Configuration' ) );
                NE__Order__c configuration = ( NE__Order__c ) JSON.deserialize( configurationString, NE__Order__c.class );
                update configuration;
                // PRODOB-61 , Doris Dongmo <doris.tatiana.dongmo@accenture.com>,  29/04/2019 - END
                Id configId = ( Id ) bit2flow.B2FUtils.getJSONValue( data, 'Configuration', 'Id' );
                List<NE__OrderItem__c> configItems = [ SELECT Id, OB_ReceiptCity__c, OB_ReceiptHeader__c, OB_ShopSign__c, NE__OrderId__r.OB_ReceiptCity__c, NE__OrderId__r.OB_ReceiptHeader__c, NE__OrderId__r.OB_ShopSign__c FROM NE__OrderItem__c WHERE NE__OrderId__c = :configId ];
                for ( NE__OrderItem__c configIt : configItems )
                {
                    configIt.OB_ReceiptCity__c = configIt.NE__OrderId__r.OB_ReceiptCity__c;
                    configIt.OB_ReceiptHeader__c = configIt.NE__OrderId__r.OB_ReceiptHeader__c;
                    if ( configIt.NE__OrderId__r.OB_ShopSign__c.length( ) <= 24 )
                    {
                        configIt.OB_ShopSign__c = configIt.NE__OrderId__r.OB_ShopSign__c;
                    }
                    else
                    {
                        configIt.OB_ShopSign__c = configIt.NE__OrderId__r.OB_ShopSign__c.substring( 0, 24 );
                    }
                }
                update configItems;
            }

        } catch ( Exception ecc )
        {
            //NEXI-178 Zuzanna Urban <z.urban@accenture.com>, 24/07/2019 start, add a log level
            System.debug( LoggingLevel.ERROR, 'Generic Error: ' + ecc.getMessage( ) + ' at line: ' + ecc.getLineNumber( ) + ' stack trace: ' + ecc.getStackTraceString( ) );
            //NEXI-178 Zuzanna Urban <z.urban@accenture.com>, 24/07/2019 stop, add a log level
        }
        //IF THE BOOLEAN IS TRUE-->REMAIN IN PAGE
        if ( isError )
        {
            System.debug( 'IN IF TO BLOCK THE PAGE' );
            String stepToGo = getStepMapping( String.valueOf( wizardWrapper.name ), OB_UtilityConstants.STEP_PUNTO_VENDITA );
            response.stepToGo = Integer.valueOf( stepToGo );
            response.result = bit2flow.DynamicWizardStepWrapper.OKCODE;
        }
        //ELSE GO TO THE NEXT STOP
        else
        {
            String stepToGo = getStepMapping( String.valueOf( wizardWrapper.name ), OB_UtilityConstants.STEP_CARICA_DOCUMENTI );
            response.stepToGo = Integer.valueOf( stepToGo );
        }

        System.debug( 'method executed companyData' );

        response.result = bit2flow.DynamicWizardStepWrapper.OKCODE;
        response.data = data;
        System.debug( 'datamap end method companyData' + JSON.serialize( data ) );
        return response;
    }

    @AuraEnabled
    global static bit2flow.DynamicWizardStepWrapper downloadDocument( String step, map<String, Object> data, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, String targetObjectKey, String method, bit2flow.DynamicWizardWrapper wizardWrapper )
    {
        bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper( );
        OB_FlowCustomError errorObject = new OB_FlowCustomError( );
        errorObject.message = '';
        errorObject.severity = 'SUCCESS';
        System.debug( 'allCheckedCreate :' + data.get( 'allCheckedCreate' ) );
        System.debug( 'allCheckedLoad :' + data.get( 'allCheckedLoad' ) );
        Boolean isError = false;
        String allLoad = ( String ) data.get( 'allCheckedLoad' );
        String allCreate = ( String ) data.get( 'allCheckedCreate' );
        try
        {
            if ( allCreate == 'false' || allLoad == 'false' )
            {
                System.debug( 'NO SHOW MODAL NEW ORDER' );
                data.put( 'missingDocs', true );
                isError = true;
                errorObject.message = 'Mancano documenti da caricare o generare.';
                errorObject.severity = 'ERROR';
            }
            else
            {
                isError = false;
                //Era a true per mostrare la modale, per ora commentato
                data.put( 'missingDocs', false );
                System.debug( 'method downloadDocument' );
            }
        } catch ( Exception ecc )
        {
            //NEXI-178 Zuzanna Urban <z.urban@accenture.com>, 24/07/2019 start, add a log level
            System.debug( LoggingLevel.ERROR, 'Generic Error: ' + ecc.getMessage( ) + ' at line: ' + ecc.getLineNumber( ) + ' stack trace: ' + ecc.getStackTraceString( ) );
            //NEXI-178 Zuzanna Urban <z.urban@accenture.com>, 24/07/2019 stop, add a log level
        }

        data.put( 'messageNext', errorObject );
        if ( isError )
        {
            String stepToGo = getStepMapping( String.valueOf( wizardWrapper.name ), OB_UtilityConstants.STEP_CARICA_DOCUMENTI );
            response.stepToGo = Integer.valueOf( stepToGo );
        }
        else
        {
            String stepToGo = getStepMapping( String.valueOf( wizardWrapper.name ), OB_UtilityConstants.STEP_SUMMARY );
            response.stepToGo = Integer.valueOf( stepToGo );
        }
        response.result = bit2flow.DynamicWizardStepWrapper.OKCODE;
        response.data = data;
        System.debug( 'datamap end method downloadDocument' + JSON.serialize( data ) );
        return response;
    }

    @AuraEnabled
    global static bit2flow.DynamicWizardStepWrapper offertaSelectionPrevious( String step, map<String, Object> data, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, String targetObjectKey, String method, bit2flow.DynamicWizardWrapper wizardWrapper )
    {
        System.debug( 'offertaSelectionPrevious Method' );
        bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper( );
        try
        {
            data.put( 'correctABI', true );
            data.put( 'correctCAB', true );
            data.put( 'showOtherInput', false );
            data.put( 'setShowSP', true );
            data.put( 'showMerchantData', true );
            data.put( 'isPrevious', true );
            //SHOW THE DESCRIPTION OF VAT NOT PRESENT COMPANY IF I HAVE CHECKED THE CHECKBOX
            Object merchantObject = data.get( 'merchant' );
            Map<String, Object> merchantMap = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( merchantObject ) );
            Object checkBoxState = merchantMap.get( 'OB_VAT_Not_Present__c' );
            Boolean checkBoxStateBool = false;
            if ( checkBoxState != '' )
                checkBoxStateBool = ( Boolean ) checkBoxState;

            if ( checkBoxStateBool == true )
                data.put( 'showModal', true );

            System.debug( 'viewPicklistValue ' + data.get( 'viewPicklistValue' ) );
            Boolean goToCart = true;
            String GTconcatenation = ( String ) data.get( 'GT' );
            System.debug( 'gt previous ' + ( String ) data.get( 'GT' ) );
            if ( !String.isEmpty( GTconcatenation ) )
            {
                List<String> listOfGTs = new List<String>( );
                listOfGTs = GTconcatenation.split( ';' );

                if ( listOfGTs.size( ) > 1 )
                {
                    goToCart = false;
                }
            }
            if ( goToCart )
            {
                String stepToGo = getStepMapping( String.valueOf( wizardWrapper.name ), OB_UtilityConstants.STEP_IDENTIFICA_SOCIETA );
                response.stepToGo = Integer.valueOf( stepToGo );
            }
            else
            {
                String stepToGo = getStepMapping( String.valueOf( wizardWrapper.name ), OB_UtilityConstants.STEP_GT );
                response.stepToGo = Integer.valueOf( stepToGo );
            }
            bit2flow.B2FUtils.setJSONValue( data, 'messageNext', 'message', null );
            bit2flow.B2FUtils.setJSONValue( data, 'messageNext', 'severity', null );
        } catch ( Exception ecc )
        {
            //NEXI-178 Zuzanna Urban <z.urban@accenture.com>, 24/07/2019 start, add a log level
            System.debug( LoggingLevel.ERROR, 'Generic Error: ' + ecc.getMessage( ) + ' at line: ' + ecc.getLineNumber( ) + ' stack trace: ' + ecc.getStackTraceString( ) );
            //NEXI-178 Zuzanna Urban <z.urban@accenture.com>, 24/07/2019 stop, add a log level
        }
        response.result = bit2flow.DynamicWizardStepWrapper.OKCODE;
        response.data = data;

        return response;
    }
    @AuraEnabled
    global static bit2flow.DynamicWizardStepWrapper GTselectionPrevious( String step, map<String, Object> data, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, String targetObjectKey, String method, bit2flow.DynamicWizardWrapper wizardWrapper )
    {
        bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper( );
        try
        {
            data.put( 'correctABI', true );
            data.put( 'correctCAB', true );
            data.put( 'showOtherInput', false );
            data.put( 'setShowSP', true );
            data.put( 'showMerchantData', true );
            data.put( 'isPrevious', true );

            bit2flow.B2FUtils.setJSONValue( data, 'messageNext', 'message', null );
            bit2flow.B2FUtils.setJSONValue( data, 'messageNext', 'severity', null );
        } catch ( Exception ecc )
        {
            //NEXI-178 Zuzanna Urban <z.urban@accenture.com>, 24/07/2019 start, add a log level
            System.debug( LoggingLevel.ERROR, 'Generic Error: ' + ecc.getMessage( ) + ' at line: ' + ecc.getLineNumber( ) + ' stack trace: ' + ecc.getStackTraceString( ) );
            //NEXI-178 Zuzanna Urban <z.urban@accenture.com>, 24/07/2019 stop, add a log level
        }
        String stepToGo = getStepMapping( String.valueOf( wizardWrapper.name ), OB_UtilityConstants.STEP_IDENTIFICA_SOCIETA );
        response.stepToGo = Integer.valueOf( stepToGo );
        response.result = bit2flow.DynamicWizardStepWrapper.OKCODE;
        response.data = data;

        return response;
    }

    @AuraEnabled
    global static bit2flow.DynamicWizardStepWrapper operationalDataPrevious( String step, map<String, Object> data, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, String targetObjectKey, String method, bit2flow.DynamicWizardWrapper wizardWrapper )
    {
        bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper( );
        try
        {
            // Get Merchant Already created
            System.debug( 'WIZARD_WRAPPER_NAME: ' + wizardWrapper.name );
            String stepToGo = getStepMapping( String.valueOf( wizardWrapper.name ), OB_UtilityConstants.STEP_OFFERTA );
            System.debug( 'STEP_TO_GO: ' + stepToGo );
            response.stepToGo = Integer.valueOf( stepToGo );
            response.result = bit2flow.DynamicWizardStepWrapper.OKCODE;
            response.data = data;
        } catch ( Exception ecc )
        {
            //NEXI-178 Zuzanna Urban <z.urban@accenture.com>, 24/07/2019 start, add a log level
            System.debug( LoggingLevel.ERROR, 'GENERIC_EROR_PREVIOUS_OPERATIONAL_DATA: ' + ecc.getMessage( ) + ' at line: ' + ecc.getLineNumber( ) + ' stack trace: ' + ecc.getStackTraceString( ) );
            //NEXI-178 Zuzanna Urban <z.urban@accenture.com>, 24/07/2019 stop, add a log level
        }
        return response;
    }

    @AuraEnabled
    global static bit2flow.DynamicWizardStepWrapper companyDataPrevious( String step, map<String, Object> data, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, String targetObjectKey, String method, bit2flow.DynamicWizardWrapper wizardWrapper )
    {
        System.debug( 'companyDataPrevious Method' );
        bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper( );
        // Get Merchant Already created
        String billingProfileString = JSON.serialize( data.get( 'BillingProfilePOS' ) );
        System.debug( ' billingProfileString string :' + billingProfileString );
        String stepToGo = getStepMapping( String.valueOf( wizardWrapper.name ), OB_UtilityConstants.STEP_DATI_OPERATIVI );
        response.stepToGo = Integer.valueOf( stepToGo );
        //response.stepToGo = Integer.valueOf(OB_UtilityConstants.MAP_STEP_FLOW.get(OB_UtilityConstants.STEP_DATI_OPERATIVI));
        response.result = bit2flow.DynamicWizardStepWrapper.OKCODE;
        response.data = data;

        return response;
    }

    @AuraEnabled
    global static bit2flow.DynamicWizardStepWrapper servicePointPrevious( String step, map<String, Object> data, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, String targetObjectKey, String method, bit2flow.DynamicWizardWrapper wizardWrapper )
    {
        bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper( );
        // Get Merchant Already created
        try
        {
            System.debug( 'PREVIOUS_SERVICEPOINT' );

            String accString = JSON.serialize( data.get( 'merchant' ) );
            System.debug( ' Account string :' + accString );
            Account acc = ( Account ) JSON.deserialize( accString, Account.class );
            System.debug( ' Account dataMap :' + acc );
            if ( acc.OB_Beneficial_Owner_Existence__c )
            {
                System.debug( 'WIZARD_WRAPPER_NAME: ' + wizardWrapper.name );
                String stepToGo = getStepMapping( String.valueOf( wizardWrapper.name ), OB_UtilityConstants.STEP_TITOLARE_EFFETTIVO );
                System.debug( 'STEP_TO_GO: ' + stepToGo );
                response.stepToGo = Integer.valueOf( stepToGo );
            }
            else
            {
                System.debug( 'WIZARD_WRAPPER_NAME: ' + wizardWrapper.name );
                String stepToGo = getStepMapping( String.valueOf( wizardWrapper.name ), OB_UtilityConstants.STEP_DATI_SOCIETA );
                System.debug( 'STEP_TO_GO: ' + stepToGo );
                response.stepToGo = Integer.valueOf( stepToGo );
            }

            response.result = bit2flow.DynamicWizardStepWrapper.OKCODE;
            response.data = data;
        } catch ( Exception ecc )
        {
            //NEXI-178 Zuzanna Urban <z.urban@accenture.com>, 24/07/2019 start, add a log level
            System.debug( LoggingLevel.ERROR, 'GENERIC_EROR_PREVIOUS_SERVICEPOINT: ' + ecc.getMessage( ) + ' at line: ' + ecc.getLineNumber( ) + ' stack trace: ' + ecc.getStackTraceString( ) );
            //NEXI-178 Zuzanna Urban <z.urban@accenture.com>, 24/07/2019 stop, add a log level
        }
        return response;
    }

    @AuraEnabled
    global static bit2flow.DynamicWizardStepWrapper riepilogoPrevious( String step, map<String, Object> data, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, String targetObjectKey, String method, bit2flow.DynamicWizardWrapper wizardWrapper )
    {
        System.debug( 'riepilogoPrevious Method' );
        bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper( );
        // Get Merchant Already created
        data.put( 'newOrder', false );
        String stepToGo = getStepMapping( String.valueOf( wizardWrapper.name ), OB_UtilityConstants.STEP_CARICA_DOCUMENTI );
        response.stepToGo = Integer.valueOf( stepToGo );
        response.result = bit2flow.DynamicWizardStepWrapper.OKCODE;
        response.data = data;

        return response;
    }

    @AuraEnabled
    global static bit2flow.DynamicWizardStepWrapper riepilogoSave( String step, map<String, Object> data, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, String targetObjectKey, String method, bit2flow.DynamicWizardWrapper wizardWrapper )
    {
        System.debug( 'riepilogoSave Method' );
        bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper( );
        String orderHeaderId;
        try
        {
            String orderHeaderString = JSON.serialize( data.get( 'OrderHeader' ) );
            System.debug( ' orderHeaderString string :' + orderHeaderString );
            NE__Order_Header__c orderHeader = ( NE__Order_Header__c ) JSON.deserialize( orderHeaderString, NE__Order_Header__c.class );
            orderHeaderId = orderHeader.Id;
            //07-11-2018-SP-Call the check method for approval process
        } catch ( Exception ecc )
        {
            System.debug( '[EXCE] OB_FlowControlUtility.riepilogoSave ' + ecc.getMessage( ) + ' at line: ' + ecc.getLineNumber( ) + ' stack trace: ' + ecc.getStackTraceString( ) );
        }

        try
        {
            List<NE__Order__c> configList = [ SELECT Id from NE__Order__c where NE__Order_Header__c = :orderHeaderId ];
            if ( !configList.isEmpty( ) )
            {
                for ( NE__Order__c config : configList )
                {
                    Boolean isEnriched = OB_EnrichOrder.setConfigurationInformation( config.id );
                }
            }
        } catch ( Exception e )
        {
            system.debug( e );
        }

        response.result = bit2flow.DynamicWizardStepWrapper.OKCODE;
        response.data = data;

        return response;
    }
    //Method to set the blank fields in the JSON Schema to null
    public static void setJSONNullFields( map<String, Object> data, String objectName, String field )
    {
        //Create a temporary datamap object where to put the json object with all the modified values (blank to null)
        system.debug( 'JSON.serialize(data.get(objectName))' + JSON.serialize( data.get( objectName ) ) );
        String objectNameTemp = objectName + '_temp';
        system.debug( 'data object temp' + JSON.serialize( data.get( objectNameTemp ) ) );
        if ( data.get( objectNameTemp ) != null )
        {
            data.put( objectName + '_temp', data.get( objectNameTemp ) );
        }
        else
        {
            data.put( objectName + '_temp', data.get( objectName ) );
        }
        system.debug( 'data object temp' + ' ' + objectNameTemp + '  ' + JSON.serialize( data.get( objectNameTemp ) ) );
        if ( JSON.serialize( data.get( objectNameTemp ) ) != null && JSON.serialize( data.get( objectNameTemp ) ).contains( field ) )
        {
            String jsonValue = ( String ) bit2flow.B2FUtils.getJSONValue( data, objectName, field );
            system.debug( 'jsonvalue method' + jsonValue );
            if ( jsonValue == '' )
            {
                bit2flow.B2FUtils.setJSONValue( data, objectNameTemp, field, null );
            }
        }
    }

    public static Time ParseTime( String timeString )
    {
        // 14:26:41.276Z or "14:26:41.276Z"
        System.debug( 'TIME STRING: ' + timeString );
        System.debug( 'TIME STRING LENGTH: ' + timeString.length( ) );
        //g.s. manage time string if it is retrieved from a specific Sp
        if ( timeString.length( ) == 5 || timeString.length( ) == 4 )
        {
            System.debug( 'INTO IF LENGTH 5' );
            String tmpTime = timeString.replace( '.', ':' );//09:00
            tmpTime = tmpTime + ':00.000';
            timeString = tmpTime;
        }
        System.debug( 'TIME STRING AFTER SET: ' + timeString );
        List<String> values = timeString.replace( 'Z', '' ).replace( '"', '' ).split( ':' );
        System.debug( 'VALUES: ' + values );
        // (14, 26, 41.276)
        Integer hours = Integer.valueOf( values[ 0 ] );
        Integer minutes = Integer.valueOf( values[ 1 ] );

        // 41.276 -> (41, 276)
        Integer seconds = Integer.valueOf( values[ 2 ].split( '\\.' )[ 0 ] );
        Integer milliseconds = Integer.valueOf( values[ 2 ].split( '\\.' )[ 1 ] );

        return Time.newInstance( hours, minutes, seconds, milliseconds );
    }

    /*****************************************************************************************/
    /*************** Retrieve of Contact in lookup with actual bank and merchant  *************************/
    @AuraEnabled
    global static void retrieveDataContact( String step, map<String, Object> data, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, String targetObjectKey, String method, bit2flow.DynamicWizardWrapper wizardWrapper )
    {
        bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper( );
        List<String> CostantRecordType = new List<String>
        {
                OB_UtilityConstants.ESECUTORE,
                OB_UtilityConstants.TITOLARE_EFFETTIVO,
                //OB_UtilityConstants.REFERENTE_AMMINISTRATIVO,
                OB_UtilityConstants.DATI_SOCIETA_LEGALE
        };
        String accString = JSON.serialize( data.get( 'merchant' ) );
        Account merch = ( Account ) JSON.deserialize( accString, Account.class );
        String bankId = ( String ) data.get( 'actualBank' );
        system.debug( 'BankId retrieve' + bankId );
        system.debug( 'merchant id retrieve' + merch.Id );
        List<Contact> contactsActualBank =
        [
                Select AccountId,FirstName,LastName,RecordType.DeveloperName, Id, Phone, Fax, MobilePhone, Email, NE__Languages__c, NE__Level__c, OB_PEC__c, OB_Document_Type__c, OB_Document_Number__c,
                        OB_Document_Release_Date__c, OB_Document_Expiration_Date__c, OB_Document_Release_City__c, OB_Document_Release_State__c, OB_Document_Release_Country__c, OB_Bank__c,
                        OB_PEP__c, OB_Fiscal_Code__c, OB_Birth_Date__c, OB_Sex__c, OB_Birth_City__c, OB_Birth_State__c, OB_Birth_State_Code__c, OB_Address_State_Code__c, OB_Address_Country_Code__c,
                        OB_Document_Release_Country_Code__c, OB_Address_Street_Number__c, OB_Address_PostalCode__c, OB_Address_City__c, OB_Address_State__c, OB_Address_Country__c, OB_Details_Address__c,
                        OB_Document_Release_Authority__c, OB_Company_Link_Type__c, OB_Business_Qualification__c, OB_Address_Street__c, OB_Document_Release_State_Code__c, OB_Country_Birth__c,
                        OB_Address_Hamlet__c, OB_Citizenship__c, OB_Contact_State__c, OB_Cadastral_Code__c
                from Contact
                where RecordType.DeveloperName IN:CostantRecordType AND OB_Bank__c = :bankId AND AccountId = :merch.Id
        ];
        system.debug( 'contactsActualBank' + contactsActualBank );
        if ( contactsActualBank != null && contactsActualBank.size( ) > 0 )
        {
            integer i = 1;
            for ( Contact ct : contactsActualBank )
            {
                if ( ct.RecordType.DeveloperName == OB_UtilityConstants.ESECUTORE )
                {
                    data.put( 'legale_rappresentante', ct );
                }

                if ( ct.RecordType.DeveloperName == OB_UtilityConstants.DATI_SOCIETA_LEGALE )
                {
                    data.put( 'sede_legale', ct );
                }
                if ( ct.RecordType.DeveloperName == OB_UtilityConstants.TITOLARE_EFFETTIVO && ct.OB_Contact_State__c == 'Active' )
                {
                    data.put( 'contact' + i, ct );
                    i++;
                }
            }
        }
    }

    public static Map<String, RecordType> recordTypeQuery( String objectName, List<String> developerName )
    {
        //we use this mthod to query the record types
        Map<String, RecordType> mapNameIdRT = new Map<String, RecordType>( );
        List<RecordType> rts = [ Select id,SobjectType,DeveloperName,Name from RecordType where SobjectType = :objectName and DeveloperName IN:developerName ];
        for ( RecordType rt : rts )
        {
            mapNameIdRT.put( rt.DeveloperName, rt );
        }
        return mapNameIdRT;
    }

    public static Account checkAccountSFDC( Account accService, ID bankOwner )
    {
        String fiscalCode = accService.NE__Fiscal_code__c;
        system.debug( 'fiscalCode checkAccountSFDC' + fiscalCode );
        //Response of service accountaccService
        system.debug( 'accService ' + accService );
        JSONParser parserAcc1 = JSON.createParser( JSON.serialize( accService ) );
        Map<String, Schema.SObjectField> fieldsAcc1 = accService.getsObjectType( ).getDescribe( ).fields.getMap( );
        Map<String, Object> accServiceJson = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( accService ) );
        system.debug( 'fiscalCode: ' + fiscalCode + '  ' + OB_UtilityConstants.MERCHANTRT + '  ' + bankOwner );
        // SFDC Account
//giovanni spinelli 30/04/2019 add fields in query: OB_Legal_Address_State_Code__c,OB_Administrative_Office_State_Code__c
        List<Account> accSFDCQuery =
        [
                select id,OB_Master_Merchant_Id__c,RecordTypeId,OB_Bank_Owner__c,OB_Legal_Form__c,NE__VAT__c,OB_ABI__c,OB_Description__c,NE__Status__c,OB_Bank_Group__c,
                        OB_Legal_Address_State_Code__c,OB_Administrative_Office_State_Code__c,
                        OB_New_Bank__c,OB_New_Bank_ABI__c,OB_Legal_Address_Name__c,OB_Legal_Address_Detail__c,OB_Legal_Address_Street__c,OB_Legal_Address_Street_Number__c,OB_Legal_Address_ZIP__c,
                        OB_Legal_Address_City__c,OB_Legal_Address_State__c,OB_Legal_Address_Country__c,OB_Merchants_Mngmnt_Office_Name__c,OB_Merchants_Mngmnt_Office_Street__c,
                        OB_Merchants_Mngmnt_Office_ZIP__c,OB_Merchants_Mngmnt_Office_City__c,OB_Merchants_Mngmnt_Office_State__c,OB_Merchants_Mngmnt_Office_Country__c,OB_Administrative_Office_Name__c,
                        OB_Administrative_Office_Street__c,OB_Administrative_Office_Street_Number__c,OB_Administrative_Office_Address_Details__c,OB_Administrative_Office_ZIP__c,OB_Administrative_Office_City__c,
                        OB_Administrative_Office_State__c,OB_Administrative_Office_Country__c,BillingAddress,Name,OB_Group_Code__c,OB_Year_constitution_company__c,
                        OB_No_Profit_Class__c,OB_No_Profit_Recipient_Class__c,OB_No_Profit_Recipient_Other__c,NE__Fiscal_code__c,OB_CCIAA__c,OB_CCIAA_Province__c,OB_SAE_Code__c,
                        OB_SAE_Description__c,OB_ATECO__c,OB_ATECO_Description__c,OB_Employees_Number__c,OB_Annual_Revenue__c,OB_Annual_Negotiated__c,OB_Beneficial_Owner_Existence__c,
                        OB_Reason_Absence_Owner__c,OB_VAT_Not_Present__c,OB_DescriptionVATNotPresent__c,OB_POSCTICode__c,OB_POSToolFreeNumber__c,OB_AcquiringToolFreeNumber__c,
                        OB_AlternativeAddress__c,OB_Legal_Form_Code__c, OB_FATECO__c
                from account
                where NE__Fiscal_code__c = :fiscalCode AND RecordType.DeveloperName = :OB_UtilityConstants.MERCHANTRT AND OB_Bank_owner__c = :bankOwner
                limit 1
        ];

        if ( accSFDCQuery != null && accSFDCQuery.size( ) > 0 )
        {
            Account accSFDC = accSFDCQuery[ 0 ];
            accSFDC.OB_FATECO__c = '';
            Map<String, Object> accSFDCJson = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( accSFDC ) );
            system.debug( 'accSFDC ' + accSFDC );

            while ( parserAcc1.nextToken( ) != null )
            {
                if ( parserAcc1.getCurrentToken( ) == JSONToken.FIELD_NAME )
                {
                    if ( fieldsAcc1.containsKey( parserAcc1.getText( ) ) )
                    {
                        Schema.DisplayType typeField = fieldsAcc1.get( parserAcc1.getText( ) ).getDescribe( ).getType( );
                        system.debug( 'typeField:: ' + typeField );
                        system.debug( 'campoo::' + parserAcc1.getText( ) );
                        String labelAcc1 = parserAcc1.getText( );
                        parserAcc1.nextValue( );
                        String valueAcc1 = parserAcc1.getText( );
                        if ( !String.isBlank( valueAcc1 ) && valueAcc1 != 'null' )
                        {
                            accSFDCJson.put( labelAcc1, valueAcc1 );
                        }
                    }
                }
            }
            system.debug( 'accSFDCJson end' + JSON.serialize( accSFDCJson ) );
            Account accResponse = ( Account ) JSON.deserialize( JSON.serialize( accSFDCJson ), Account.class );

            return accResponse;
        }
        else
        {
            return null;
        }

    }

    public static Boolean checkPvSFDC( NE__Service_Point__c newPv, ID accountId )
    {
        JSONParser parserPv1 = JSON.createParser( JSON.serialize( newPv ) );
        Map<String, Schema.SObjectField> fieldsPv1 = newPv.getsObjectType( ).getDescribe( ).fields.getMap( );
        Map<String, Object> pvServiceJson = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( newPv ) );
        // SFDC Service Point
        List<NE__Service_Point__c> pvSFDCQuery =
        [
                SELECT Id, Name, OB_MCC_Description__c, NE__Street__c, OB_Street_Number__c, NE__City__c, NE__Country__c, NE__Province__c,
                        OB_Service_Point_City__c, OB_Service_Point_Name__c
                FROM NE__Service_Point__c
                WHERE OB_Typology__c = :newPV.OB_Typology__c  // F2WAVE2-144 Micol Ferrari <micol.ferrari@accenture.com>, 15/07/2019
                AND Name = :newPV.Name  // F2WAVE2-144 Micol Ferrari <micol.ferrari@accenture.com>, 19/07/2019
                AND OB_MCC_Description__c = :newPv.OB_MCC_Description__c AND NE__Province__c = :newPv.NE__Province__c
                AND NE__City__c = :newPv.NE__City__c AND NE__Street__c = :newPv.NE__Street__c AND OB_Street_Number__c = :newPv.OB_Street_Number__c
                AND NE__Zip_Code__c = :newPv.NE__Zip_Code__c AND NE__Account__c = :accountId
                LIMIT 1
        ];

        if ( pvSFDCQuery.size( ) > 0 )
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    public static Map<String, String> checkMandatoryValCheckCont( Contact checkCont, String section, Map<String, Object> mappaErrorEE )
    {
        System.debug( ' INSIDE checkMandatoryValCheckCont : ' );
        Map<String, String> mandatoryValidationCheck = new Map<String, String>( );
        Pattern docNumPattern = Pattern.compile( '^[a-zA-Z0-9]+$' );
        Matcher docNum = docNumPattern.matcher( checkCont.OB_Document_Number__c );
        Date checkBirthDate = Date.newInstance( 1900, 1, 1 );
        if ( checkCont.OB_Country_Birth__c != 'ITALIA' )
        {
            List<NE__Lov__c> lovCadastralCode = [ SELECT Id, NE__Value2__c FROM NE__Lov__c WHERE NE__Type__c = 'COUNTRY' AND Name = :checkCont.OB_Country_Birth__c ];
            if ( lovCadastralCode != null && lovCadastralCode.size( ) > 0 )
            {
                checkCont.OB_Cadastral_Code__c = lovCadastralCode[ 0 ].NE__Value2__c;
            }
        }
        system.debug( 'checkCont.OB_Cadastral_Code__c: ' + checkCont.OB_Cadastral_Code__c );
        if ( mappaErrorEE != null )
        {
            for ( String key : mappaErrorEE.keySet( ) )
            {
                if ( ( Boolean ) ( mappaErrorEE.get( key ) ) )
                {
                    mandatoryValidationCheck.put( 'isErrorEE', '' );
                }
            }
        }
        System.debug( ' INSIDE checkMandatoryValCheckCont : ' );
        //START gianluigi.virga 09/07/2019 - BACKLOG-50 - Added country condition in the if statement
        if ( checkCont.OB_Document_Release_Country_Code__c == 'ITA')
        // //END gianluigi.virga
        {

            if ( checkCont.OB_Document_Release_Date__c > system.today( ) || checkCont.OB_Document_Release_Date__c < checkCont.OB_Birth_Date__c )
            {
                mandatoryValidationCheck.put( 'documentReleaseDatecontact' + section + 'Doc', Label.OB_Invalid_Release_Date );
            }
            System.debug( ' @@@ Document Type : ' + checkCont.OB_Document_Type__c );
            //START gianluigi.virga 09/07/2019 - BACKLOG-50 - Added country condition in the if statement
            if ( checkCont.OB_Document_Release_Country_Code__c == 'ITA' && checkCont.OB_Document_Type__c == OB_UtilityConstants.CARTA_DI_IDENTITA )
            //END gianluigi.virga
            {
                if ( checkCont.OB_Document_Release_Country_Code__c == 'ITA' && ( checkCont.OB_Document_Number__c.isAlphaNumeric() == false || (checkCont.OB_Document_Number__c.length() <8 || checkCont.OB_Document_Number__c.length() > 9 ) ))
            //END gianluigi.virga
            {
                mandatoryValidationCheck.put( 'documentNumber', Label.OB_InvalidDocumentNumber );
            }

                Date checkDate = Date.newInstance( 2012, 2, 10 );
                // michele.lubrano 29/04/2019 PRODOB-67 add check if expiration day is not the same with release day START
                System.debug( ' @@@ OB_Document_Release_Date__c : ' + checkCont.OB_Document_Release_Date__c + ' OB_Document_Expiration_Date__c : ' + checkCont.OB_Document_Expiration_Date__c );
                if ( ( checkCont.OB_Document_Release_Date__c < checkDate && ( checkCont.OB_Document_Expiration_Date__c != checkCont.OB_Document_Release_Date__c.addYears( 10 ).addDays( -1 ) && checkCont.OB_Document_Expiration_Date__c != checkCont.OB_Document_Release_Date__c.addYears( 10 ) ) ) || checkCont.OB_Document_Expiration_Date__c < system.today( ) )
                {
                    // michele.lubrano 29/04/2019 PRODOB-67 END
                    System.debug( ' ##### ' );
                    mandatoryValidationCheck.put( 'documentExpirationDatecontact' + section + 'Doc', Label.OB_InvalidDocumentExpirationDate );
                }
                else if ( checkCont.OB_Document_Release_Date__c > checkDate )
                {
                    if ( ( ( checkCont.OB_Birth_Date__c.month( ) < checkCont.OB_Document_Release_Date__c.month( ) ) || ( checkCont.OB_Birth_Date__c.month( ) == checkCont.OB_Document_Release_Date__c.month( ) && checkCont.OB_Birth_Date__c.day( ) < checkCont.OB_Document_Release_Date__c.day( ) ) ) && checkCont.OB_Document_Expiration_Date__c != Date.newInstance( checkCont.OB_Document_Release_Date__c.addYears( 11 ).year( ), checkCont.OB_Birth_Date__c.month( ), checkCont.OB_Birth_Date__c.day( ) ) )
                    {
                        mandatoryValidationCheck.put( 'documentExpirationDatecontact' + section + 'Doc', Label.OB_InvalidDocumentExpirationDate );
                    }
                    else if ( ( ( checkCont.OB_Birth_Date__c.month( ) > checkCont.OB_Document_Release_Date__c.month( ) ) || ( checkCont.OB_Birth_Date__c.month( ) == checkCont.OB_Document_Release_Date__c.month( ) && checkCont.OB_Birth_Date__c.day( ) >= checkCont.OB_Document_Release_Date__c.day( ) ) ) && checkCont.OB_Document_Expiration_Date__c != Date.newInstance( checkCont.OB_Document_Release_Date__c.addYears( 10 ).year( ), checkCont.OB_Birth_Date__c.month( ), checkCont.OB_Birth_Date__c.day( ) ) )
                    {
                        mandatoryValidationCheck.put( 'documentExpirationDatecontact' + section + 'Doc', Label.OB_InvalidDocumentExpirationDate );
                    }
                }

                if ( checkCont.OB_Document_Release_Authority__c != OB_UtilityConstants.COMUNE )
                {
                    mandatoryValidationCheck.put( 'documentAuthcontact' + section + 'Doc', Label.OB_InvalidDocumentReleaseAuthority );
                }
                // /* ANDREA MORITTU START 04-Dec-2019 - PRODOB_552 -ADDING FIX ON LENGHT */
                // if ( checkCont.OB_Document_Release_Country_Code__c == 'ITA' && (!(checkCont.OB_Document_Number__c).isAlphanumeric() ||  (checkCont.OB_Document_Number__c.length() < 8 || checkCont.OB_Document_Number__c.length() > 9 )  )) {
                //     mandatoryValidationCheck.put('documentNumber',Label.OB_InvalidDocumentNumber);
                // }
                // /* ANDREA MORITTU END 04-Dec-2019 - PRODOB_552 -ADDING FIX ON LENGHT */
            }
            //START gianluigi.virga 09/07/2019 - BACKLOG-50 - Added country condition in the if statement
            else if ( checkCont.OB_Document_Release_Country_Code__c == 'ITA' && checkCont.OB_Document_Type__c == OB_UtilityConstants.PASSAPORTO )
            //END gianluigi.virga
            {
                if ( ( checkCont.OB_Document_Expiration_Date__c != checkCont.OB_Document_Release_Date__c.addYears( 10 ).addDays( -1 ) && checkCont.OB_Document_Expiration_Date__c != checkCont.OB_Document_Release_Date__c.addYears( 10 ) )
                        || checkCont.OB_Document_Expiration_Date__c < system.today( ) )
                {
                    mandatoryValidationCheck.put( 'documentExpirationDatecontact' + section + 'Doc', Label.OB_InvalidDocumentExpirationDate );
                }

                if ( checkCont.OB_Document_Release_Authority__c != OB_UtilityConstants.QUESTURA )
                {
                    mandatoryValidationCheck.put( 'documentAuthcontact' + section + 'Doc', Label.OB_InvalidDocumentReleaseAuthority );
                }
            }
            //START gianluigi.virga 09/07/2019 - BACKLOG-50 - Added country condition in the if statement
            else if ( checkCont.OB_Document_Release_Country_Code__c == 'ITA' && checkCont.OB_Document_Type__c == OB_UtilityConstants.PATENTE )
            //END gianluigi.virga
            {
                if ( checkCont.OB_Document_Release_Authority__c != OB_UtilityConstants.UCO && checkCont.OB_Document_Release_Authority__c != OB_UtilityConstants.MOTORIZZAZIONE && checkCont.OB_Document_Release_Authority__c != OB_UtilityConstants.PREFETTURA )
                {
                    mandatoryValidationCheck.put( 'documentAuthcontact' + section + 'Doc', Label.OB_InvalidDocumentReleaseAuthority );
                }
                if ( checkCont.OB_Document_Expiration_Date__c < system.today( ) )
                {
                    mandatoryValidationCheck.put( OB_UtilityConstants.MANDATORYINPUTMAPCOMPANYDATA.get( 'legale_rappresentante' ).get( 'OB_Document_Expiration_Date__c' ), Label.OB_InvalidDocumentExpirationDate );
                }
                /* ANDREA MORITTU START 06-Dec-2019 - ADDING LENGTH OF PATENTE DOCUMENT NUMBER  */
                if(checkCont.OB_Document_Number__c.length() < 9 || checkCont.OB_Document_Number__c.length() > 10 || checkCont.OB_Document_Number__c.isAlphaNumeric() == false ){
                    mandatoryValidationCheck.put( 'documentNumber', Label.OB_InvalidDocumentNumber );			} 
                }
                /* ANDREA MORITTU END 06-Dec-2019 - ADDING LENGTH OF PATENTE DOCUMENT NUMBER  */
            if ( checkCont.OB_Birth_Date__c > system.today( ).addYears( -16 ) || checkCont.OB_Birth_Date__c < checkBirthDate )
            {
                mandatoryValidationCheck.put( 'birthDatecontact' + section + 'Doc', Label.OB_InvalidBirthDate );
            }
        }
        //  START   micol.ferrari 12/12/2018 -> OB_SkipCadastralCodeCheck__c
        String errorCFType = checkNameSurnameCF( checkCont.FirstName, checkCont.LastName, checkCont.OB_Fiscal_Code__c, String.valueOf( checkCont.OB_Birth_Date__c ), checkCont.OB_Sex__c, checkCont.OB_Cadastral_Code__c, checkCont.OB_SkipCadastralCodeCheck__c );
        if ( checkCont.OB_Fiscal_Code__c.length( ) != 16 )
        {
            System.debug( 'errorecfinvalid' );
            mandatoryValidationCheck.put( 'fiscalCodeContact' + section, Label.OB_InvalidFiscalCode );
        }
        else if ( errorCFType == 'errorName' )
        {
            System.debug( 'errorecfname' );
            mandatoryValidationCheck.put( 'fiscalCodeContact' + section, Label.OB_InconsistentFiscalCode );
        }
        else if ( errorCFType == 'errorData' )
        {
            System.debug( 'errorecfdata' );
            mandatoryValidationCheck.put( 'fiscalCodeContact' + section, Label.OB_InvalidFiscalCodeBirthDate );
        }
        else if ( errorCFType == 'errorSurname' )
        {
            System.debug( 'errorSurname' );
            mandatoryValidationCheck.put( 'fiscalCodeContact' + section, Label.OB_InvalidFiscalCodeSurname );
        }
        else if ( errorCFType == 'errorGender' )
        {
            System.debug( 'errorGender' );
            mandatoryValidationCheck.put( 'fiscalCodeContact' + section, Label.OB_InvalidFiscalCodeGender );
        }
        else if ( errorCFType == 'errorCadastralCode' )
        {
            system.debug( 'cadastralCode' );
            mandatoryValidationCheck.put( 'fiscalCodeContact' + section, Label.OB_InvalidFiscalCodeCadastralCode );
        }
        else if ( errorCFType == 'errorLastChar' )
        {
            System.debug( 'errorLastChar' );
            mandatoryValidationCheck.put( 'fiscalCodeContact' + section, Label.OB_InvalidFiscalCode );
        }

        system.debug( 'data error x exp' + Date.newInstance( checkCont.OB_Document_Release_Date__c.addYears( 10 ).year( ), checkCont.OB_Birth_Date__c.month( ), checkCont.OB_Birth_Date__c.day( ) ) );
        return mandatoryValidationCheck;

    }

    public static String checkNameSurnameCF( String nome, String cognome, String cf, String birthDate, String gender, String cadastralCode, Boolean skipCheckCadCode )
    {
        nome = stringNormalizer( nome.replaceAll( ' ', '' ).replaceAll( '\'', '' ).toUpperCase( ) );
        cognome = stringNormalizer( cognome.replaceAll( ' ', '' ).replaceAll( '\'', '' ).toUpperCase( ) );
        cf = cf.toUpperCase( );
        String check = null;
        String nc = extractConsonants( nome );
        if ( nc.length( ) > 3 )
            nc = nc.subString( 0, 1 ) + nc.subString( 2, 3 ) + nc.subString( 3, 4 );
        else
        {
            String nv = extractVowels( nome );
            Integer i = 0;
            while ( nc.length( ) < 3 )
            {
                try
                {
                    nc += nv.subString( i, i + 1 );
                } catch ( Exception ecc )
                {
                    nc += 'X';
                }
                i++;
            }
        }
        String cc = extractConsonants( cognome );
        if ( cc.length( ) >= 3 )
            cc = cc.subString( 0, 3 );
        else
        {
            String cv = extractVowels( cognome );
            Integer i = 0;
            while ( cc.length( ) < 3 )
            {
                try
                {
                    cc += cv.subString( i, i + 1 );
                } catch ( Exception ecc )
                {
                    cc += 'X';
                }
                i++;
            }
        }
        String cadastralCodeCheck = cf.subString( 11, 15 );
        String dataCheck = cf.subString( 6, 11 );
        String pn = cf.subString( 3, 6 );
        String pc = cf.subString( 0, 3 );
        System.debug( 'controllo CF nome: ' + nome + ' cognome: ' + cognome + ' parteNomeCF: ' + pn + ' calcolato nome: ' + nc + ' parteCognomeCF: ' + pc + ' calcolato cognome: ' + cc );

        String dd = birthDate.substring( 8, 10 );
        String mm = birthDate.substring( 5, 7 );
        String yy = birthDate.substring( 2, 4 );
        if ( gender == 'F' )
        {
            Integer ddInt = Integer.valueOf( dd );
            ddInt += 40;
            dd = String.valueOf( ddInt );
        }

        //ANDREA START 2019/02/18
        /* MAP CONTAINING THE VALUES UPON THE MODULUS OF THE ALGORITHM */
        Map<Integer, String> finalRemainderCF = new Map<Integer, String>
        {
                0 => 'A',
                1 => 'B',
                2 => 'C',
                3 => 'D',
                4 => 'E',
                5 => 'F',
                6 => 'G',
                7 => 'H',
                8 => 'I',
                9 => 'J',
                10 => 'K',
                11 => 'L',
                12 => 'M',
                13 => 'N',
                14 => 'O',
                15 => 'P',
                16 => 'Q',
                17 => 'R',
                18 => 'S',
                19 => 'T',
                20 => 'U',
                21 => 'V',
                22 => 'W',
                23 => 'X',
                24 => 'Y',
                25 => 'Z'
        };

        /* MAP CONTAINING ALL CHARS VALUES IF THEY ARE IN AN EVEN POSITION */
        Map<String, Integer> evenSumValues = new Map<String, Integer>
        {
                '0' => 0,
                '1' => 1,
                '2' => 2,
                '3' => 3,
                '4' => 4,
                '5' => 5,
                '6' => 6,
                '7' => 7,
                '8' => 8,
                '9' => 9,
                'A' => 0,
                'B' => 1,
                'C' => 2,
                'D' => 3,
                'E' => 4,
                'F' => 5,
                'G' => 6,
                'H' => 7,
                'I' => 8,
                'J' => 9,
                'K' => 10,
                'L' => 11,
                'M' => 12,
                'N' => 13,
                'O' => 14,
                'P' => 15,
                'Q' => 16,
                'R' => 17,
                'S' => 18,
                'T' => 19,
                'U' => 20,
                'V' => 21,
                'W' => 22,
                'X' => 23,
                'Y' => 24,
                'Z' => 25
        };

        /* MAP CONTAINING ALL CHARS VALUES IF THEY ARE IN AN ODD POSITION */
        Map<String, Integer> oddSumValues = new Map<String, Integer>
        {
                '0' => 1,
                '1' => 0,
                '2' => 5,
                '3' => 7,
                '4' => 9,
                '5' => 13,
                '6' => 15,
                '7' => 17,
                '8' => 19,
                '9' => 21,
                'A' => 1,
                'B' => 0,
                'C' => 5,
                'D' => 7,
                'E' => 9,
                'F' => 13,
                'G' => 15,
                'H' => 17,
                'I' => 19,
                'J' => 21,
                'K' => 2,
                'L' => 4,
                'M' => 18,
                'N' => 20,
                'O' => 11,
                'P' => 3,
                'Q' => 6,
                'R' => 8,
                'S' => 12,
                'T' => 14,
                'U' => 16,
                'V' => 10,
                'W' => 22,
                'X' => 25,
                'Y' => 24,
                'Z' => 23
        };


        Integer evenSum = 0;
        Integer oddSum = 0;
        Integer finalSumValues;
        String finalCharCF;
        List<Integer> sum = new List<Integer>( );

        // STRING CONTAINIG ALL CHARS OF FISCAL CODE WITHOUT THE LAST ONE
        String fiscalCodewithoutControlCode = cf.substring( 0, 15 );
        // THIS IS THE LAST CHAR OF FISCAL CODE.
        String lastChar = cf.substring( 15, 16 );

        System.debug( 'Fiscal code without control code is: ' + fiscalCodewithoutControlCode );
        for ( Integer i = 0; i < fiscalCodewithoutControlCode.length( ); i += 2 )
        {
            System.debug( 'current value ' + fiscalCodewithoutControlCode.subString( i, i + 1 ) );
            oddSum += oddSumValues.get( fiscalCodewithoutControlCode.subString( i, i + 1 ) );

        }
        System.debug( 'oddSum is : ' + oddSum );
        for ( Integer i = 1; i < fiscalCodewithoutControlCode.length( ); i += 2 )
        {
            evenSum += evenSumValues.get( fiscalCodewithoutControlCode.subString( i, i + 1 ) );
        }
        if ( evenSum != 0 && oddSum != 0 )
        {
            finalSumValues = oddSum + evenSum;
            Integer remainder = Math.mod( finalSumValues, 26 );
            finalCharCF = finalRemainderCF.get( remainder );
        }
        //ANDREA END 2019/02/18
        System.debug( '## finalCharCF is :' + finalCharCF );
        System.debug( '## lastChar is :' + lastChar );
        Map<String, String> mmCode = new Map<String, String> {'01' => 'A', '02' => 'B', '03' => 'C', '04' => 'D', '05' => 'E', '06' => 'H', '07' => 'L', '08' => 'M', '09' => 'P', '10' => 'R', '11' => 'S', '12' => 'T'};
        String dateCode = yy + mmCode.get( mm ) + dd;
        System.debug( 'dateCode:: ' + dateCode + ' == ' + dataCheck );
        if ( !pn.equalsIgnoreCase( nc ) )
        {
            check = 'errorName';
        }
        else if ( !pc.equalsIgnoreCase( cc ) )
        {
            check = 'errorSurname';
        }
        else if ( gender == 'F' && Integer.valueOf( dataCheck.substring( 3, 5 ) ) - 40 < 0 )
        {
            check = 'errorGender';
        }
        else if ( gender == 'M' && Integer.valueOf( dataCheck.substring( 3, 5 ) ) - 40 > 0 )
        {
            check = 'errorGender';
        }
        else if ( dateCode != dataCheck )
        {
            check = 'errorData';
        }
        //  START   ANDREA.MORITTU 18.02.2019
        //START elena.preteni 29/5/2019 RI-62, do not check last char if cadastrial code check to  skip
        else if ( !skipCheckCadCode && finalCharCF != lastChar )
        //END elena.preteni 29/5/2019 RI-62, do  not check last char if cadastrial code check to skip
        {
            check = 'errorLastChar';
        }
        //  END     ANDREA.MORITTU 18.02.2019
        //  START   micol.ferrari 12/12/2018 -> OB_SkipCadastralCodeCheck__c
        else if ( !skipCheckCadCode && !String.IsBlank( cadastralCode ) && cadastralCode != cadastralCodeCheck )
        {
            check = 'errorCadastralCode';
        }
        //  END     micol.ferrari 12/12/2018
        //else
        return ( check ); // && controllaCheckDigit(cf)
    }

    public static String stringNormalizer( String input )
    {
        try
        {
            String acc = 'ÀÂÄÇÉÈÊËÎÏÌÛÜÙÔÖÒÑ' + '°()§<>%^¨*$€£`#,;./?!+=_@"' + '\'Œ&Æ';        // et Œ, Æ, &;
            String maj = 'AAACEEEEIIIUUUOOON' + '                          ' + '    ';
            String out = '';
            for ( Integer i = 0; i < input.length( ); i++ )
            {
                String car = input.substring( i, i + 1 );
                Integer idx = acc.indexOf( car );
                if ( idx != -1 )
                {
                    out += maj.substring( idx, idx + 1 );
                }
                else
                {
                    out += car;
                }
            }

            return out.replaceAll( ' ', '' );
        } catch ( Exception ecc )
        {
            System.debug( 'pulisci stringa: ' + ecc.getMessage( ) + ' at line: ' + ecc.getLineNumber( ) + ' stack trace: ' + ecc.getStackTraceString( ) );
            return '';
        }
    }

    public static String extractVowels( String p )
    {
        String ris = '';
        for ( Integer i = 0; i < p.length( ); i++ )
        {
            String ss = p.subString( i, i + 1 );
            if ( ss.equalsIgnoreCase( 'A' ) || ss.equalsIgnoreCase( 'E' ) || ss.equalsIgnoreCase( 'I' ) || ss.equalsIgnoreCase( 'O' ) || ss.equalsIgnoreCase( 'U' ) )
                ris += ss;
        }
        return ris;
    }

    public static String extractConsonants( String p )
    {
        String ris = '';
        for ( Integer i = 0; i < p.length( ); i++ )
        {
            String ss = p.subString( i, i + 1 );
            if ( !ss.equalsIgnoreCase( 'A' ) && !ss.equalsIgnoreCase( 'E' ) && !ss.equalsIgnoreCase( 'I' ) && !ss.equalsIgnoreCase( 'O' ) && !ss.equalsIgnoreCase( 'U' ) )
                ris += ss;
        }
        return ris;
    }

    public static Boolean controllaCheckDigit( String CF )
    {
        try
        {

            Map <Integer, Integer> conversione = new Map <Integer, Integer>
            {
                    0 => 1
                    , 1 => 0
                    , 2 => 5
                    , 3 => 7
                    , 4 => 9
                    , 5 => 13
                    , 6 => 15
                    , 7 => 17
                    , 8 => 19
                    , 9 => 21
                    , 10 => 2
                    , 11 => 4
                    , 12 => 18
                    , 13 => 20
                    , 14 => 11
                    , 15 => 3
                    , 16 => 6
                    , 17 => 8
                    , 18 => 12
                    , 19 => 14
                    , 20 => 16
                    , 21 => 10
                    , 22 => 22
                    , 23 => 25
                    , 24 => 24
                    , 25 => 23
            };
            String cfp = CF.substring( 0, CF.length( ) - 1 );
            String checkDigit = CF.substring( CF.length( ) - 1, cf.length( ) );


            List<String> lettere = new List<String> {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'};
            List<String> vocali = new List<String> {'A', 'E', 'I', 'O', 'U'};
            Integer ritorno;
            Integer sommatoria = 0;


            for ( Integer i = 0; i < cfp.length( ); i++ )
            {
                if ( Math.mod( i, 2 ) != 0 )
                {
                    Pattern isnumbers = Pattern.Compile( '^[0-9]+$' );
                    Matcher numberMatch = isnumbers.matcher( cfp.substring( i, i + 1 ) );
                    if ( !numberMatch.Matches( ) )
                    {
                        Integer trovato = 0;
                        for ( Integer j = 0; j < lettere.size( ) && trovato == 0; j++ )
                            if ( lettere[ j ] == cfp.substring( i, i + 1 ) )
                            {
                                sommatoria += j;
                                trovato = 1;
                            }//ifF
                    }//se è una lettera
                    else
                    {
                        sommatoria += Integer.valueOf( cfp.substring( i, i + 1 ) ) * 1;
                    }//se è un numero
                }//pari
                else
                {
                    Integer tmp = 0;

                    Pattern isnumbers = Pattern.Compile( '^[0-9]+$' );
                    Matcher numberMatch = isnumbers.matcher( cfp.substring( i, i + 1 ) );
                    if ( !numberMatch.Matches( ) )
                    {
                        integer trovato = 0;
                        for ( Integer j = 0; j < lettere.size( ) && trovato == 0; j++ )
                            if ( lettere[ j ] == cfp.substring( i, i + 1 ) )
                            {
                                tmp = j;
                                trovato = 1;
                            }//if
                    }//se è una lettera
                    else
                    {
                        tmp = integer.valueOf( cfp.substring( i, i + 1 ) ) * 1;
                    }//se è un numero
                    sommatoria += conversione.get( tmp );
                }//dispari
            }//for

            ritorno = ( Math.mod( sommatoria, 26 ) );

            String ritornoDigit = lettere[ ritorno ];
            system.debug( 'ritornoDigit: ' + ritornoDigit + ' |checkDigit: ' + checkDigit );

            return ritornoDigit == checkDigit;

        } catch ( Exception ecc )
        {
            //NEXI-178 Zuzanna Urban <z.urban@accenture.com>, 24/07/2019 start, add a log level
            System.debug( LoggingLevel.ERROR, 'Generic Error: ' + ecc.getMessage( ) + ' at line: ' + ecc.getLineNumber( ) + ' stack trace: ' + ecc.getStackTraceString( ) );
            //NEXI-178 Zuzanna Urban <z.urban@accenture.com>, 24/07/2019 stop, add a log level
            return null;
        }
    }

    /*******************************************************************************
    Purpose:  Method that retrieve the Legal Form Code from Lovs, starting from Legal Form
              when legal form code is empty (due to migrated accounts)
    Parameters: String legal form, String legal form code
    Returns: String

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Micol Ferrari           22/05/2019      Created         WN-167
    ********************************************************************************/
    public static String getLegalFormCode( String legalform, String legalformcode )
    {
        String toReturn = legalformcode;
        if ( !String.isBlank( legalform ) && String.isBlank( legalformcode ) )
        {
            List<NE__Lov__c> listOfLovs =
            [
                    SELECT Id,NE__Value1__c, Name
                    FROM NE__Lov__c
                    WHERE Name = :legalform
                    AND NE__Type__c = 'LegalForm'
                    AND NE__Sub_Type__c = 'TIPOLOGICHE'
                    AND NE__Active__c = true
            ];
            if ( !listOfLovs.isEmpty( ) )
            {
                toReturn = listOfLovs.get( 0 ).NE__Value1__c;
            }
        }
        return toReturn;
    }

    global bit2flow.DynamicWizardStepWrapper save( String step, map<String, Object> data, String targetObjectKey, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, bit2flow.DynamicWizardWrapper dynamicWizardWrapper )
    {
        return null;
    }

    global bit2flow.DynamicWizardStepWrapper init( String step, map<String, Object> data, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, bit2flow.DynamicWizardWrapper dynamicWizardWrapper )
    {
        system.debug( 'Init Method' );
        /* ANDREA MORITTU @START: JUMP TO NEXT STEP -- 22/11/2018*/
        bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper( );

        response.result = '000'; //bit2flow.DynamicWizardStepWrapper.OKCODE;
        response.description = 'OK';
        response.data = data;
        response.dynamicWizardWrapper = dynamicWizardWrapper;
        if ( data != null && data.size( ) > 0 && data.containsKey( 'OrderHeader' ) )
        {
            if ( data.containsKey( 'JumpToStep' ) )
            {
                Integer numberStep = Integer.valueOf( data.get( 'JumpToStep' ) );
                System.debug( 'numberStep is' + numberStep );
                response.stepToGo = numberStep;
                System.debug( 'response.steptogo is: ' + response.stepToGo );

            }
        }
        System.debug( '@@response is: ' + response );
        return response;
    }

    global static bit2flow.DynamicWizardStepWrapper executeMethod( String step, map<String, Object> data, String targetObjectKey, String method, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, bit2flow.DynamicWizardWrapper dynamicWizardWrapper )
    {
        return null;
    }

    global bit2flow.DynamicWizardStepWrapper validate( String step, map<String, Object> data, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, bit2flow.DynamicWizardWrapper dynamicWizardWrapper )
    {
        return null;
    }


    @AuraEnabled
    public static bit2flow.DynamicWizardStepWrapper overwriteNext( String step, Map<String, Object> data, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, bit2flow.DynamicWizardWrapper wizardWrapper )
    {
        bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper( );

        System.debug( 'response' + response );

        return response;
    }

    @AuraEnabled
    public static bit2flow.DynamicWizardStepWrapper overwritePrevious( String step, Map<String, Object> data, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, bit2flow.DynamicWizardWrapper wizardWrapper )
    {
        bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper( );

        return response;
    }

    @AuraEnabled
    public static bit2flow.DynamicWizardStepWrapper overwriteSave( String step, Map<String, Object> data, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, bit2flow.DynamicWizardWrapper wizardWrapper, String targetObjectKey )
    {
        return null;
    }
    @AuraEnabled
    public static bit2flow.DynamicWizardStepWrapper overwriteExit( String step, Map<String, Object> data, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, bit2flow.DynamicWizardWrapper wizardWrapper, String targetObjectKey )
    {

        bit2flow.DynamicWizardStepWrapper response = new bit2flow.DynamicWizardStepWrapper( );

        response.result = '000';
        response.description = 'This is a successfully test for overwrite a wizard button';
        response.data = data;
        response.dynamicWizardWrapper = wizardWrapper;

        System.debug( 'response' + response );

        return response;
    }

    //  START   marco.armato 24/12/2018 - SAVE AS DRAFT
    @AuraEnabled
    public static String saveDraft( String step, Map<String, Object> data, List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition, bit2flow.DynamicWizardWrapper wizardWrapper, String wizardWrapperString )
    {
        System.debug( 'Into OB_FlowControlUtility.saveDraft' );
        String toReturnURL;

        try
        {
            System.debug( 'wizardWrapperString: ' + wizardWrapperString );

            /*PASSING TO OBJECTDATAMAP A NODE THAT IDENTIFY THE CURRENT TAB (WHERE I AM)*/
            data.put( 'JumpToStep', step );

            String wizardWrapperLabel = wizardWrapper.label;
            String wizardWrapperName = wizardWrapper.name;
            String wizardWrapperId = wizardWrapper.wizardId;

            wizardWrapperLabel = wizardWrapperLabel.replace( '"', '' );
            wizardWrapperName = wizardWrapperName.replace( '"', '' );
            System.debug( ' @@@ wizardWrapperLabel ' + wizardWrapperLabel );
            System.debug( 'wizardWrapperName ' + wizardWrapperName );
            /*ANDREA END (PARSING wizardWrapper into string)*/
            system.debug( 'saveHistoricData: ' + data );

            system.debug( 'bi2flow : ' + wizardWrapper );

            system.debug( 'saveHistoricData: ' + data );
            //  START   micol.ferrari 12/11/2018
            String orderString = JSON.serialize( data.get( 'OrderHeader' ) );
            System.debug( 'orderString string :' + orderString );
            NE__Order_Header__c orderHeader = ( NE__Order_Header__c ) JSON.deserialize( orderString, NE__Order_Header__c.class );
            //  END     micol.ferrari 12/11/2018

            // Retrieve from the wrapper the wizardId (not the attach Id). If the field is not there or it is empty, get the Id by Name
            String wizardIdValue = '';
            //System.debug('wizardWrapper.wizardId: ' + wizardWrapper.wizardId);

            if ( wizardWrapperId != null && wizardWrapperId != '' && wizardWrapperId != 'null' )
            {
                wizardIdValue = wizardWrapperId;
            }
            else
            {
                // we have to retrieve the Id from the IntegrationAdministarion or the Wizard Definition
                if ( Type.forName( 'NE__IntegrationAdministration__c' ) != null )
                {
                    System.debug( 'Finding administrationList' );
                    List<sObject> administrationList = Database.query( 'SELECT Id FROM NE__IntegrationAdministration__c WHERE NE__Name__c =\'' + wizardWrapperName + '\'  ORDER BY CreatedDate DESC LIMIT 1' );
                    System.debug( 'administrationList: ' + administrationList );
                    if ( !administrationList.isEmpty( ) )
                    {
                        wizardIdValue = ( String ) administrationList[ 0 ].get( 'Id' );
                    }
                }
                //JGL 20/03/2018 fix saving historic
                if ( wizardIdValue == '' )
                {
                    System.debug( 'Finding wizarddefList' );
                    List<sObject> wizarddefList = Database.query( 'SELECT Id FROM bit2flow__Wizard_Definition__c WHERE bit2flow__Name__c =\'' + wizardWrapperName + '\'  ORDER BY CreatedDate DESC LIMIT 1' );
                    System.debug( 'wizarddefList: ' + wizarddefList );
                    if ( !wizarddefList.isEmpty( ) )
                    {
                        wizardIdValue = ( String ) wizarddefList[ 0 ].get( 'Id' );
                    }
                }
            }

            bit2flow__Historic_Wizard_Data__c historicData = new bit2flow__Historic_Wizard_Data__c( );
            historicData.bit2flow__Wizard_Name__c = wizardWrapperName;
            historicData.bit2flow__Wizard_Label__c = wizardWrapperLabel;
            historicData.bit2flow__Status__c = 'Draft';
            historicData.bit2flow__Wizard_Id__c = wizardIdValue;

            //  START   micol.ferrari 12/11/2018 Adapted marco.ferri 17/11/2018
            if ( orderHeader != null )
            {
                historicData.OB_OrderHeaderId__c = orderHeader.Id;
            }
            //  END     micol.ferrari 12/11/2018 Adapted marco.ferri 17/11/2018

            String historicExistingId = '';

            upsert historicData;

            System.debug( 'upsert done: ' + historicData );

            List<Attachment> atachmentsList = new List<Attachment>( );

            // data attachment
            Attachment dataAttachment = new Attachment( );
            dataAttachment.Body = Blob.valueOf( JSON.serialize( data ) );
            dataAttachment.Name = String.valueOf( 'dataJSON.json' );
            dataAttachment.ParentId = ( Id ) historicData.get( 'Id' );

            atachmentsList.add( dataAttachment );

            // wrapper attachment
            Attachment wrapperAttachment = new Attachment( );
            wrapperAttachment.Body = Blob.valueOf( wizardwrapperstring );
            wrapperAttachment.Name = String.valueOf( 'wrapperJSON.json' );
            wrapperAttachment.ParentId = ( Id ) historicData.get( 'Id' );

            atachmentsList.add( wrapperAttachment );

            insert atachmentsList;

            //need to check if Community send community URL

            String operationComplete = Label.OB_SavedFlowLabel;
            //Start antonio.vatrano r1f3_75 20/09/2019
            NE__Order_Header__c oHeader = new NE__Order_Header__c(Id = orderHeader.Id);
            oHeader.OB_Save_as_Draft__c = true;
            update oHeader;
            //End antonio.vatrano r1f3_75 20/09/2019
            return operationComplete;

        } catch ( Exception ecc )
		{	
			//toReturnURL = null;
			System.debug('Exception : ' +ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString()); 
			String operationFailed = Label.OB_OperationFailedLabel;
			return operationFailed;
			//return toReturnURL;
		}
	}	
	//	END 	marco.armato 24/12/2018 - SAVE AS DRAFT 
	
	//START gianluigi.virga 03/07/2019 - PRODOB-284 - method to check if the contact in input already exist that return list of error message
	@AuraEnabled
    public static List<String> checkTitolareEffettivoAlreadyExist(Map<String, Object> data){
		List<String> codFiscAlreadyExist = new List<String>();
		Boolean codFiscAlreadyExistInSFDC;
		List<Contact> listOfContact = new List<Contact>();
		try{
			String contactString1 =JSON.serialize(data.get('contact1_temp'));
			System.debug('contactString1'+contactString1);
			String contactString2 =JSON.serialize(data.get('contact2_temp'));
			System.debug('contactString2'+contactString2);
			String contactString3 =JSON.serialize(data.get('contact3_temp'));
			System.debug('contactString3'+contactString3);
			String contactString4 =JSON.serialize(data.get('contact4_temp'));
			System.debug('contactString4'+contactString4);
			String contactString5 =JSON.serialize(data.get('contact5_temp'));
			System.debug('contactString5'+contactString5);
			String contactString6 =JSON.serialize(data.get('contact6_temp'));
			System.debug('contactString6'+contactString6);

			Contact contact1 = (Contact)JSON.deserialize(contactString1, Contact.class);
			if(contact1.OB_Fiscal_Code__c != null && contact1.OB_Fiscal_Code__c != ''){
				listOfContact.add(contact1);
			}
			Contact contact2 = (Contact)JSON.deserialize(contactString2, Contact.class);
			if(contact2.OB_Fiscal_Code__c != null && contact2.OB_Fiscal_Code__c != ''){
				listOfContact.add(contact2);
			}
			Contact contact3 = (Contact)JSON.deserialize(contactString3, Contact.class);
			if(contact3.OB_Fiscal_Code__c != null && contact3.OB_Fiscal_Code__c != ''){
				listOfContact.add(contact3);
			}
			Contact contact4 = (Contact)JSON.deserialize(contactString4, Contact.class);
			if(contact4.OB_Fiscal_Code__c != null && contact4.OB_Fiscal_Code__c != ''){
				listOfContact.add(contact4);
			}
			Contact contact5 = (Contact)JSON.deserialize(contactString5, Contact.class);
			if(contact5.OB_Fiscal_Code__c != null && contact5.OB_Fiscal_Code__c != ''){
				listOfContact.add(contact5);
			}
			Contact contact6 = (Contact)JSON.deserialize(contactString6, Contact.class);
			if(contact6.OB_Fiscal_Code__c != null && contact6.OB_Fiscal_Code__c != ''){
				listOfContact.add(contact6);
			}
			System.debug('List of Contact: '+listOfContact);
			if(!listOfContact.isEmpty() && listOfContact != null){
				for(Contact contact : listOfContact){
					Integer count = 0;
					for(Contact checkContact : listOfContact){
					 	if(checkContact.OB_Fiscal_Code__c == contact.OB_Fiscal_Code__c){
					 		count++;
					 	}
					}
					if(count >= 2){
						codFiscAlreadyExist.add(contact.OB_Fiscal_Code__c);
					}
					if(count == 1){
						String accId = (String) bit2flow.B2FUtils.getJSONValue( data, 'merchant', 'Id');
						String abi = (String) bit2flow.B2FUtils.getJSONValue( data, 'bank', 'OB_ABI__c' );
						codFiscAlreadyExistInSFDC = OB_FlowControlUtility.getAllTitolariEffettiviPerABI(contact.id, contact.OB_Fiscal_Code__c, accId, abi);
						if(codFiscAlreadyExistInSFDC == true){
							codFiscAlreadyExist.add(contact.OB_Fiscal_Code__c);
						}
					}
				}
			}
			System.debug('codFiscAlreadyExist: '+codFiscAlreadyExist);
			return codFiscAlreadyExist;
		}catch (Exception exc)
		{
			System.debug(LoggingLevel.ERROR, 'OB_FlowControlUtility.checkTitolareEffettivoAlreadyExist Exception: ' + exc.getMessage() + ' at line: ' + exc.getLineNumber() + ' stack trace: ' + exc.getStackTraceString());
			return codFiscAlreadyExist;
		}
	}

	// method to check if a contact in input isn't diplayed but already exist in SFDC for current account and current ABI
	@AuraEnabled
	public static Boolean getAllTitolariEffettiviPerABI(String contactId, String codFisc, String accId, String ABI){
		Boolean contactAlreadyExistInSFDC = false;
		List<Contact> listOfDuplicate = new List<Contact>();
		if(contactId != null && contactId != ''){
			listOfDuplicate = [SELECT Id, OB_Fiscal_Code__c FROM Contact WHERE OB_Fiscal_Code__c=: codFisc AND AccountId =:accId AND OB_Bank__r.OB_ABI__c =:ABI AND RecordType.DeveloperName = 'Titolare_Effettivo' AND OB_Contact_State__c = 'Active' AND Id !=: contactId];
		}else{
			listOfDuplicate = [SELECT Id, OB_Fiscal_Code__c FROM Contact WHERE OB_Fiscal_Code__c=: codFisc AND AccountId =:accId AND OB_Bank__r.OB_ABI__c =:ABI AND RecordType.DeveloperName = 'Titolare_Effettivo' AND OB_Contact_State__c = 'Active'];
		}
		System.debug('$$$listOfDuplicate: ' + listOfDuplicate);
		if(!listOfDuplicate.isEmpty() && listOfDuplicate != null){
			contactAlreadyExistInSFDC = true;
			System.debug('Contatto già esistente in SFDC: ' + listOfDuplicate.get(0));
		}
		return contactAlreadyExistInSFDC;
	} 
	//END gianluigi.virga - PRODOB-284

	/*******************************************************************************
	Purpose:  method to deactivate all 'Esecutore' different from the current contact
    Parameters: Account Id, Esecutore Record Type, OB_Bank__c Id 
    Returns: -

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         gianluigi.virga         01/10/2019      Created         deactivate all 'Esecutore' different from the current contact
	
 	********************************************************************************/
	@AuraEnabled
	public static void checkEsecutore(String accountId, String esecutoreRT, String bankId){
		List<Contact> contactsToDeactivate = [SELECT Id FROM Contact WHERE AccountId=: accountId AND RecordTypeId =: esecutoreRT AND OB_Bank__c =: bankId AND OB_Contact_State__c = 'Active'];
		System.debug('contactsToDeactivate: '+contactsToDeactivate);
		for(Contact contact : contactsToDeactivate){
			contact.OB_Contact_State__c = 'Inactive';
		}
		update contactsToDeactivate;
	}
    /*******************************************************************************
    Purpose:  Method to check if contact(RT executor) legal form require the fiscal code check against the account(merchant) fiscal code
    Parameters: String accountLegalForm
    Returns: Boolean

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Damian Krzyzaniak       02/07/2019      Created         NEXI-123
    ********************************************************************************/
    public static Boolean isFCCompatibilityCheckRequired( String accountLegalForm )
    {
        if ( String.isBlank( accountLegalForm ) )
        {
            System.debug( LoggingLevel.INFO, 'OB_FlowControlUtility.isFCCompatibilityCheckRequired: Empty accountLegalForm ' );
            return false;
        }
        return OB_UtilityConstants.legalFormsRequiringCheckInLowerCase.contains( accountLegalForm.toLowerCase( ) ) ? true : false;
    }
}