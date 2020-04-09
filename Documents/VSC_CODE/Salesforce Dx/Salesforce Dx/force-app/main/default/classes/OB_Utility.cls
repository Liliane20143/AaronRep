/*********************************************************************
Name:  OB_Utility
======================================================================                                                                                                       
History                                                            
                                                        
  AUTHOR            DATE CREATED        DESCRIPTION
  Salvatore     	31/10/2018			method to manage services 
  Pianura								and to call approval processes

**********************************************************************/

public without sharing class OB_Utility
{
    public static final String OB_LOGREQUEST_FIELD_CHANGE_OF_REPORTING_TYPE = 'OB_change_of_reporting_type__c'; //NEXI-179 Marta Stempien <marta.stempien@accenture.com> 25/07/2019

	/*
	*	Author		:	Morittu Andrea
	*	Date		:	12-Oct-2019
	*	Task		:	no task
	*	Description : 	Reusable exception class to throw if you want to fire an error.
	*/
	public virtual class applicationException extends Exception {

	}

    // START    salvatore.pianura 14/03/2019 - R1F2 MultiPV 8 – Allign method with Dev1
    public static Boolean retrieveSpecialCategoryConfigurations( String orderHeaderId )
    {
        Boolean toReturn = false;
        try
        {
            // NEXI-314 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 05/09/2019 detectSpecialCategories moved after callouts section

            System.debug( '@Into OB_Utility.retrieveSpecialCategoryConfigurations()' );
            //RETRIEVE THE ORDER HEADER GIVEN THE ID PASSED AS PARAMETER
            List<NE__Order_Header__c> listOfOrderHeader =
            [
                    SELECT NE__AccountId__c, NE__AccountId__r.OB_ATECO__c,OB_PEP__c,OB_Gianos__c,
                            NE__AccountId__r.NE__VAT__c, NE__AccountId__r.NE__Fiscal_code__c,
                            Name, OB_Main_Process__c,OB_StartApprovalProcess__c,
                            OB_Gambling__c,OB_PO118_Ecommerce__c,OB_PO118_MOTO__c,
                            OB_HotelCarRental__c,OB_isBlackList__c,OB_isUCAMP__c,
                            OB_PreAuth__c,OB_AdditionalDocumentationRequired__c,OB_FulfilmentStatus__c,
                            OB_eCommerce__c,
                            OB_Moto__c, //26/08/19 francesca.ribezzi - F2-Wave2-177 - adding OB_eCommerce__c,OB_Moto__c fields
                            OB_isPO118__c,
                            OB_ManualPAN__c,// NEXI-314 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 05/09/2019 added missing fields
                    ( SELECT Id,OB_MCC__c,OB_FulfilmentStatus__c,OB_AdditionalDocumentationRequired__c,OB_CheckApprovalProcessAcquiring__c FROM NE__Configurations__r )
                    FROM NE__Order_Header__c
                    WHERE Id = :orderHeaderId
                    LIMIT 1
            ];

            NE__Order_Header__c currentOrderHeader = new NE__Order_Header__c( );
            String execFiscalCode;
            //CHECK IF THE LIST OF ORDER HEADER IS NOT EMPTY (WE ASSUME THERE IS ONLY AN ELEMENT)
            if ( !listOfOrderHeader.isEmpty( ) )
            {
                //GET CURRENT ORDER HEADER
                currentOrderHeader = listOfOrderHeader.get( 0 );
                //RETRIEVE THE EXECUTOR
                Contact currentExec = new Contact( );
                Id execRt = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.ESECUTORE ).getRecordTypeId( );

                List<Contact> listOfExecutors =
                [
                        SELECT Id,OB_Fiscal_Code__c,OB_Contact_State__c
                        FROM Contact
                        WHERE AccountId = :currentOrderHeader.NE__AccountId__c
                        AND RecordTypeId = :execRt
                        AND OB_Contact_State__c = :OB_UtilityConstants.STATUS_ACTIVE
                ];
                if ( !listOfExecutors.isEmpty( ) )
                {
                    currentExec = listOfExecutors.get( 0 );
                    execFiscalCode = currentExec.OB_Fiscal_Code__c;
                }
                //CALL BLACKLIST AND UCAMP SERVICES
                String vat = currentOrderHeader.NE__AccountId__r.NE__VAT__c;
                String taxCode = currentOrderHeader.NE__AccountId__r.NE__Fiscal_code__c;

                if ( vat != null && vat != '' )
                {
                    String token = OB_UtilityCallingServices.checkToken( );
                    Boolean responseBlackList = OB_UtilityCallingServices.callServiceBlacklist( vat, taxCode, execFiscalCode, token );
                    System.debug( 'OB_Utility.retrieveSpecialCategoryConfigurations - responseBlackList :  ' + responseBlackList );
                    Boolean responseUcamp = OB_UtilityCallingServices.callServiceUcamp( vat, token );
                    System.debug( 'OB_Utility.retrieveSpecialCategoryConfigurations - responseUcamp :  ' + responseUcamp );
                    //SET isBLackList AND isUcamp ORDER HEADER'S FIELDS 
                    currentOrderHeader.OB_isBlackList__c = responseBlackList;
                    currentOrderHeader.OB_isUCAMP__c = responseUcamp;
                    //Start antonio.vatrano 30/09/2019 r1f3.119 
                    if(checkItemVM(orderHeaderId)){
                        if ( !OB_Util009_Gianos.callToGianos( orderHeaderId, false ) )
                        {
                            throw new OB_Util009_Gianos.GianosException( '[EXC] Gianos Integration Error' );
                        }//NEXI-202 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 19/07/2019
                    }
                    //End antonio.vatrano 30/09/2019 r1f3.119 
                }

                //GET FROM THE CURRENT ORDER HEADER THE LIST OF ALL ITS CONFIGURATIONS
                List<NE__Order__c> listOfConfigurations = new List<NE__Order__c>( );
                listOfConfigurations = currentOrderHeader.NE__Configurations__r;

                //CHECK IF THE LIST OF ALL THE CONFIGURATIONS CHILDREN OF THE CURRENT ORDER HEADER IS NOT EMPTY
                if ( !listOfConfigurations.isEmpty( ) )
                {
                    //RETRIEVE THE LIST OF ALL THE SPECIAL CATEGORY CONFIGURATIONS FILTERED BY APPROVALPROCESSREQUIRED TRUE
                    //AND THE MAIN PROCESS GIVEN BY THE CURRENT ORDER HEADER
                    List<OB_Special_Category_Configuration__c> listOfSpecialCat =
                    [
                            SELECT Id,Name,OB_ApprovalProcessRequired__c,OB_ATECO__c,
                                    OB_Commercial_Product__c,OB_DocRequired__c,OB_EngineCodeCommercialProduct__c,
                                    OB_isCrowdfunding__c,OB_Legal_Form__c,OB_MCC__c,OB_OrderHeader__c,
                                    OB_RequestType__c,RecordType.DeveloperName
                            FROM OB_Special_Category_Configuration__c
                            WHERE OB_ApprovalProcessRequired__c = true
                            AND OB_RequestType__c = :currentOrderHeader.OB_Main_Process__c
                    ];

                    System.debug( 'OB_Utility.retrieveSpecialCategoryConfigurations - listOfSpecialCat: ' + listOfSpecialCat );

                    //--------------------------------------------------------
                    // OB_MCC_OR_ATECO
                    //--------------------------------------------------------

                    //RETRIEVE ALL THE MCC CODES FROM THE CONFIGURATIONS CHILDREN OF THE CURRENT ORDER HEADER
                    List<String> listOfMcc = new List<String>( );
                    for ( NE__Order__c thisOrder : listOfConfigurations )
                    {
                        listOfMcc.add( thisorder.OB_MCC__c );
                    }

                    System.debug( 'OB_Utility.retrieveSpecialCategoryConfigurations - currentOrderHeader.NE__AccountId__r.OB_ATECO__c: ' + currentOrderHeader.NE__AccountId__r.OB_ATECO__c );
                    System.debug( 'OB_Utility.retrieveSpecialCategoryConfigurations - listOfMcc: ' + listOfMcc );

                    //RETRIEVE THE 'CATEGORY' FIELD RELATED TO THE CONTEXT ATECO
                    List<NE__Lov__c> atecoLovList =
                    [
                            SELECT Id,NE__Value3__c
                            FROM NE__Lov__c
                            WHERE NE__Type__c = 'ATECO'
                            AND NE__Active__c = true
                            AND Name = :currentOrderHeader.NE__AccountId__r.OB_ATECO__c
                    ];

                    //RETRIEVE THE 'CATEGORY' FIELDS RELATED TO THE CONTEXT MCCs
                    List<NE__Lov__c> mccLovList =
                    [
                            SELECT Id,NE__Value1__c,NE__Value2__c
                            FROM NE__Lov__c
                            WHERE NE__Type__c = 'MCC'
                            AND NE__Value3__c = 'L3'
                            AND NE__Value2__c
                                    IN:listOfMcc
                    ];

                    //GET A SET OF ALL THE ATECO 'CATEGORIES'
                    Set<String> setAteco = new Set<String>( );
                    for ( NE__Lov__c thisLov : atecoLovList )
                    {
                        if ( thisLov.NE__Value3__c != null )
                            setAteco.add( thisLov.NE__Value3__c );
                    }

                    //GET A SET OF ALL THE MCC 'CATEGORIES'
                    Set<String> setMcc = new Set<String>( );
                    for ( NE__Lov__c thisLov : mccLovList )
                    {
                        if ( thisLov.NE__Value1__c != null )
                            setMcc.add( thisLov.NE__Value1__c );
                    }

                    System.debug( 'OB_Utility.retrieveSpecialCategoryConfigurations - setAteco: ' + setAteco );
                    System.debug( 'OB_Utility.retrieveSpecialCategoryConfigurations - setMcc: ' + setMcc );

                    //PREPARE A SET OF SPECIAL CATEGORY CONFIGURATION THAT WILL CONTAINS THE FINAL RECORD TO ANALYZE
                    Set<OB_Special_Category_Configuration__c> finalSetSpecialCat = new Set<OB_Special_Category_Configuration__c>( );

                    //LOOP ON THE LIST OF SPECIAL CATEGORY CONFIGURATIONS
                    for ( OB_Special_Category_Configuration__c thisSpecialCat : listOfSpecialCat )
                    {
                        //CHECK IF THE:
                        //DEVELOPER NAME OF THE RECORD TYPE IS 'OB_MCC_OR_ATECO'
                        //AND
                        //THE MCC IS CONTAINED IN THE SET OF ALL MCC 'CATEGORIES' OR THE ATECO IS IS CONTAINED IN THE SET OF ALL ATECO 'CATEGORIES'
                        if ( thisSpecialCat.RecordType.DeveloperName == 'OB_MCC_OR_ATECO' &&
                                ( setMcc.contains( thisSpecialCat.OB_MCC__c ) || setAteco.contains( thisSpecialCat.OB_ATECO__c ) ) )
                        {
                            //  IF THE CONDITIONS ARE VALIDATED, THEN ADD THE LOOPED RECORD INSIDE THE FINAL SET
                            finalSetSpecialCat.add( thisSpecialCat );
                            System.debug( 'OB_Utility.retrieveSpecialCategoryConfigurations INSIDE OB_MCC_OR_ATECO' );
                        }

                    }
                    System.debug( 'OB_Utility.retrieveSpecialCategoryConfigurations - OB_MCC_OR_ATECO finalSetSpecialCat: ' + finalSetSpecialCat );

                    //--------------------------------------------------------
                    // OB_MCC_AND_PRODUCT
                    //--------------------------------------------------------

                    //RETRIEVE ALL THE CONFIGURATIONS, CHILDREN OF THE CURRENT ORDER HEADER, IN ORDER TO RETRIEVE THEIR CONFIGURATION ITEMS
                    List<NE__Order__c> listOfConfigurationsForOI =
                    [
                            SELECT Id, OB_MCC__c,
                            (
                                    SELECT Id, NE__ProdId__r.OB_Acquirer__c,NE__ProdId__r.NE__Engine_Code__c,
                                            OB_FulfilmentStatus__c,NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName
                                    FROM NE__Order_Items__r
                            )
                            FROM NE__Order__c
                            WHERE NE__Order_Header__c = :currentOrderHeader.Id
                    ];
                    //PREPARE A MAP THAT CONTAINS THE MCC 'CATEGORY' AS THE KEY, AND THE LIST OF ALL THE RELATED ENGINE CODES
                    Map<String, List<String>> mapOfMccEc = new Map <String, List<String>>( );
                    List<String> listOfAcquirer = new List<String>( );
                    Boolean acquirerNexi = false;

                    //LIST OF PRODUCTS' ENGINE CODES, RELATED TO CONFIGURATION ITEMS WITH A PARENT ORDER ITEM WITH RECORD TYPE TERMINALI
                    //FOR THE THIRD CHECK ON SPECIAL CATERGORY (OB_PRODUCT_ENABLEMENT)
                    List<String> listOfEngineCodesTerminali = new List<String>( );

                    //LOOP ON THE CONFIGURATIONS
                    for ( NE__Order__c thisOrder : listOfConfigurationsForOI )
                    {
                        String currentLovMCC = null;
                        //LOOP ON THE LIST OF MCCs
                        for ( NE__Lov__c thisLov : mccLovList )
                        {
                            if ( thisLov.NE__Value2__c == thisOrder.OB_MCC__c )
                            {
                                currentLovMCC = thisLov.NE__Value1__c;
                                break;
                            }
                        }

                        //GET THE CONFIGURATION ITEMS, CHILDREN OF THE CURRENT LOOPED CONFIGURATION
                        List<NE__OrderItem__c> listOfConfigItems = new List<NE__OrderItem__c>( );
                        listOfConfigItems = thisOrder.NE__Order_Items__r;
                        //CHECK IF THE LIST OF HE CONFIGURATION ITEMS, CHILDREN OF THE CURRENT LOOPED CONFIGURATION IS NOT EMPTY
                        if ( !listOfConfigItems.isEmpty( ) )
                        {
                            List<String> listOfEngineCodes = new List<String>( );

                            //LOOP ON THE LIST OF THE CONFIGURATION ITEMS, CHILDREN OF THE CURRENT LOOPED CONFIGURATION
                            for ( NE__OrderItem__c thisOI : listOfConfigItems )
                            {
                                //ADD TO A LIST OF STRING, ALL THE ENGINE CODES RELATED TO THE PRODUCT PARENT OF THE CONFIGURATION ITEM
                                listOfEngineCodes.add( thisOI.NE__ProdId__r.NE__Engine_Code__c );

                                listOfAcquirer.add( thisOI.NE__ProdId__r.OB_Acquirer__c );

                                //IF THE CURRENT CONFIGURATION ITEM HAS A PARENT ORDER ITEM REALTED TO A PRODUCT WITH RECORD TYPE TERMINALI
                                //THEN ADD THE CURRENT CONFIGURAITON ITEM'S ENGINE CODE TO A LIST OF STRINGS
                                if ( thisOI.NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName == 'Terminali' )
                                {
                                    listOfEngineCodesTerminali.add( thisOI.NE__ProdId__r.NE__Engine_Code__c );
                                }

                            }
                            if ( !listOfAcquirer.isEmpty( ) )
                            {
                                for ( String thisAcq : listOfAcquirer )
                                {
                                    if ( thisAcq == OB_UtilityConstants.PRODUCT_ACQUIRER_NEXI )
                                    {
                                        acquirerNexi = true;
                                    }
                                }
                            }

                            //POPULATE THE MAP WITH THE CURRENT MCC 'CATEGORY' AND THE LIST OF THE RELATED ENGINE CODES
                            mapOfMccEc.put( currentLovMCC, listOfEngineCodes );
                        }
                    }
                    System.debug( 'OB_Utility.retrieveSpecialCategoryConfigurations - listOfAcquirer: ' + listOfAcquirer );
                    System.debug( 'OB_Utility.retrieveSpecialCategoryConfigurations - mapOfMccEc: ' + mapOfMccEc );

                    //LOOP ON THE LIST OF SPECIAL CATEGORY CONFIGURATIONS
                    for ( OB_Special_Category_Configuration__c thisSpecialCat : listOfSpecialCat )
                    {
                        //CHECK IF THE:
                        //DEVELOPER NAME OF THE RECORD TYPE IS 'OB_MCC_AND_PRODUCT'
                        //AND
                        //THE MCC IS CONTAINED IN THE SET OF ALL MCC 'CATEGORIES'
                        //AND
                        //THE SPECIAL CATEGORY HAS AN ENGINE CODE THAT IS CONTAINED IN THE MAP
                        if ( thisSpecialCat.RecordType.DeveloperName == 'OB_MCC_AND_PRODUCT' &&
                                setMcc.contains( thisSpecialCat.OB_MCC__c ) &&
                                ( mapOfMccEc.get( thisSpecialCat.OB_MCC__c ) ).contains( thisSpecialCat.OB_EngineCodeCommercialProduct__c ) )
                        {
                            //IF THE CONDITIONS ARE VALIDATED, THEN ADD THE LOOPED RECORD INSIDE THE FINAL SET
                            finalSetSpecialCat.add( thisSpecialCat );
                            System.debug( 'OB_Utility.retrieveSpecialCategoryConfigurations INSIDE OB_MCC_AND_PRODUCT' );
                        }
                    }
                    System.debug( 'OB_Utility.retrieveSpecialCategoryConfigurations - OB_MCC_AND_PRODUCT finalSetSpecialCat: ' + finalSetSpecialCat );

                    //--------------------------------------------------------
                    // OB_PRODUCT_ENABLEMENT
                    //--------------------------------------------------------

                    //LOOP ON THE LIST OF SPECIAL CATEGORY CONFIGURATIONS
                    for ( OB_Special_Category_Configuration__c thisSpecialCat : listOfSpecialCat )
                    {
                        //CHECK IF THE:
                        //DEVELOPER NAME OF THE RECORD TYPE IS 'OB_PRODUCT_ENABLEMENT'
                        //AND
                        //THE PRODUCT TYPOLOGY OF THE SPECIAL CATEGORY IS CONTAINED IN THE LIST OF THE ENGINE CODES TERMINALI
                        if ( thisSpecialCat.RecordType.DeveloperName == 'OB_PRODUCT_ENABLEMENT' &&
                                ( !listOfEngineCodesTerminali.isEmpty( ) && listOfEngineCodesTerminali.contains( thisSpecialCat.OB_EngineCodeCommercialProduct__c ) ) )
                        {
                            //IF THE CONDITIONS ARE VALIDATED, THEN ADD THE LOOPED RECORD INSIDE THE FINAL SET
                            finalSetSpecialCat.add( thisSpecialCat );
                            System.debug( 'OB_Utility.retrieveSpecialCategoryConfigurations INSIDE OB_PRODUCT_ENABLEMENT' );
                        }
                    }
                    System.debug( 'OB_Utility.retrieveSpecialCategoryConfigurations - OB_PRODUCT_ENABLEMENT finalSetSpecialCat: ' + finalSetSpecialCat );


                    //18-02-2019-S.P.-CHECK IF ORDER HEADER'S CONFIGURATIONS CONTAINS A VISAMASTERCARD'S ITEM WITH ACTION IN ADD--START
                    Boolean checkVM = false;
                    NE__Order__c currentConfiguration = new NE__Order__c( );
                    List<NE__Order__c> listOfConf = new List<NE__Order__c>( );
                    List<Id> listOfId = new List<Id>( );
                    listOfConf.addAll( currentOrderHeader.NE__Configurations__r );
                    Integer consistenzaScenarioTwo = 0;
                    if ( !listOfConf.isEmpty( ) )
                    {
                        currentConfiguration = listOfConf.get( 0 );
                        for ( NE__Order__c conf : listOfConf )
                        {
                            listOfId.add( conf.Id );
                        }

                        //NEXI-207 Michal Targiel michal.targiel@acceture.com, 18.07.2019, START
                        consistenzaScenarioTwo =
                        [
                                SELECT Count( )
                                FROM NE__OrderItem__c
                                WHERE ( NE__ProdId__r.OB_Codice_sfdc__c = :OB_UtilityConstants.OBCodiceMPAN
                                OR NE__ProdId__r.OB_Codice_sfdc__c = :OB_UtilityConstants.OBCodiceALBAUTO )
                                AND NE__Action__c = :OB_UtilityConstants.ADD_ACTION
                                AND NE__Root_Order_Item__c = null
                                AND OB_ProductRecordType__c = :OB_UtilityConstants.PRODUCT_RECORDTYPE_VAS
                                AND NE__OrderId__c = :currentConfiguration.Id
                        ];
                        //NEXI-207 Michal Targiel michal.targiel@acceture.com, 18.07.2019, STOP
                    }
                    if ( !listOfId.isEmpty( ) )
                    {
                        List<NE__OrderItem__c> listOfItemsVM =
                        [
                                SELECT Id,NE__ProdId__c,NE__Action__c
                                FROM NE__OrderItem__c
                                WHERE NE__OrderId__c IN:listOfId
                                AND NE__ProdId__r.OB_Codice_sfdc__c = 'VISAMASTERCARD'
                                AND NE__Action__c = 'Add'
                                AND NE__Root_Order_Item__c = null
                        ];
                        if ( listOfItemsVM.size( ) > 0 )
                        {
                            checkVM = true;
                        }
                    }

                    Boolean additionalDocRequired = currentConfiguration.OB_AdditionalDocumentationRequired__c;
                    Boolean checkAcquiringOnConfiguration = currentConfiguration.OB_CheckApprovalProcessAcquiring__c;
                    //18-02-2019-S.P.-CHECK IF ORDER HEADER'S CONFIGURATIONS CONTAINS A VISAMASTERCARD'S ITEM WITH ACTION IN ADD--END

                    //--------------------------------------------------------
                    // GET ORDER HEADER FIELDS TO UPDATE
                    //--------------------------------------------------------

                    //CHECK IF THE LIST OF THE FINAL SET OF THE FILTERED SPECIAL CATEGORIES IS NOT EMPTY
                    if ( !finalSetSpecialCat.isEmpty( ) )
                    {
                        //LOOP ON THE FINAL SET OF THE FILTERED SPECIAL CATEGORIES
                        for ( OB_Special_Category_Configuration__c finalSpecialCat : finalSetSpecialCat )
                        {
                            //GET FOR THE CURRENT SPECIAL CATEGORY THE ORDER HEADER FIELD TO UPDATE TO TRUE
                            if ( finalSpecialCat.OB_OrderHeader__c.equalsIgnoreCase( 'OB_Gambling__c' ) )
                            {
                                currentOrderHeader.OB_Gambling__c = true;
                            }
                            else if ( finalSpecialCat.OB_OrderHeader__c.equalsIgnoreCase( 'OB_PO118_Ecommerce__c' ) )
                            {
                                currentOrderHeader.OB_PO118_Ecommerce__c = true;
                            }
                            else if ( finalSpecialCat.OB_OrderHeader__c.equalsIgnoreCase( 'OB_PO118_MOTO__c' ) )
                            {
                                currentOrderHeader.OB_PO118_MOTO__c = true;
                            }
                            else if ( finalSpecialCat.OB_OrderHeader__c.equalsIgnoreCase( 'OB_HotelCarRental__c' ) )
                            {
                                currentOrderHeader.OB_HotelCarRental__c = true;
                            }
                            else if ( finalSpecialCat.OB_OrderHeader__c.equalsIgnoreCase( 'OB_PreAuth__c' ) )
                            {
                                currentOrderHeader.OB_PreAuth__c = true;
                            }
                        }

                        System.debug( 'OB_Utility.retrieveSpecialCategoryConfigurations - currentOrderHeader: ' + currentOrderHeader );
                    }
                    // NEXI-314 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 05/09/2019 START moved logic with detecting, refactored code
                    Map<Id, List<String>> categoriesMap = detectSpecialCategory( new List<Id> {currentOrderHeader.Id} );
                    System.debug( LoggingLevel.FINE,'OB_Utility.retrieveSpecialCategoryConfigurations - categoriesMap: ' + categoriesMap );

                    Boolean hasSpecialCategory = categoriesMap.get( String.valueOf( currentOrderHeader.Id ) ).size( ) > 0;
                    List<NE__Order_Header__c> orderHeaderForCheck =
                    [
                            SELECT OB_Gianos__c,
                                   OB_Gambling__c
                            FROM NE__Order_Header__c
                            WHERE Id = :currentOrderHeader.Id
                            LIMIT 1
                    ];
                    System.debug( LoggingLevel.FINE,'OB_Utility.retrieveSpecialCategoryConfigurations - orderHeaderForCheck: ' + orderHeaderForCheck );

                    NE__Order_Header__c orderHeaderSpecialCategoryCheck = orderHeaderForCheck.get( 0 );
                    String gianosField = orderHeaderSpecialCategoryCheck.OB_Gianos__c;
                    System.debug( LoggingLevel.FINE,'OB_Utility.retrieveSpecialCategoryConfigurations - gianosField: ' + gianosField );

                    // NEXI-349 Kinga Fornal <kinga.fornal@accenture.com>, 26/09/2019 START
                    Double gianosValue;
                    try
                    {
                        gianosValue = Double.valueOf( gianosField );
                    } catch ( Exception ex )
                    {
                        gianosValue = 0.0;
                    }
                    // NEXI-349 Kinga Fornal <kinga.fornal@accenture.com>, 26/09/2019 STOP

                    // NEXI-314 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 05/09/2019 STOP
                    System.debug( LoggingLevel.FINE, 'OB_Utility.retrieveSpecialCategoryConfigurations - gianosValue: ' + gianosValue );
                    System.debug( LoggingLevel.FINE,'OB_Utility.retrieveSpecialCategoryConfigurations - acquirerNexi ' + acquirerNexi );
                    System.debug( LoggingLevel.FINE,'OB_Utility.retrieveSpecialCategoryConfigurations - checkVM ' + checkVM );
                    System.debug( LoggingLevel.FINE,'OB_Utility.retrieveSpecialCategoryConfigurations - additionalDocRequired ' + additionalDocRequired );
                    System.debug( LoggingLevel.FINE,'OB_Utility.retrieveSpecialCategoryConfigurations - checkAcquiringOnConfiguration ' + checkAcquiringOnConfiguration );
                    System.debug( LoggingLevel.FINE,'OB_Utility.retrieveSpecialCategoryConfigurations - orderHeaderSpecialCategoryCheck.OB_Gambling__c: ' + orderHeaderSpecialCategoryCheck.OB_Gambling__c );
                    System.debug( LoggingLevel.FINE,'OB_Utility.retrieveSpecialCategoryConfigurations - orderHeaderSpecialCategoryCheck.OB_PO118_Ecommerce__c: ' + currentOrderHeader.OB_PO118_Ecommerce__c );
                    System.debug( LoggingLevel.FINE,'OB_Utility.retrieveSpecialCategoryConfigurations - orderHeaderSpecialCategoryCheck.OB_PO118_MOTO__c: ' + currentOrderHeader.OB_PO118_MOTO__c );
                    System.debug( LoggingLevel.FINE,'OB_Utility.retrieveSpecialCategoryConfigurations - orderHeaderSpecialCategoryCheck.OB_HotelCarRental__c: ' + currentOrderHeader.OB_HotelCarRental__c );
                    System.debug( LoggingLevel.FINE,'OB_Utility.retrieveSpecialCategoryConfigurations - orderHeaderSpecialCategoryCheck.OB_PEP__c: ' + currentOrderHeader.OB_PEP__c );
                    System.debug( LoggingLevel.FINE,'OB_Utility.retrieveSpecialCategoryConfigurations - orderHeaderSpecialCategoryCheck.OB_isBlackList__c: ' + currentOrderHeader.OB_isBlackList__c );
                    System.debug( LoggingLevel.FINE,'OB_Utility.retrieveSpecialCategoryConfigurations - orderHeaderSpecialCategoryCheck.OB_isUCAMP__c: ' + currentOrderHeader.OB_isUCAMP__c );
                    System.debug( LoggingLevel.FINE,'OB_Utility.retrieveSpecialCategoryConfigurations - orderHeaderSpecialCategoryCheck.OB_PreAuth__c: ' + currentOrderHeader.OB_PreAuth__c );

                    //CHECK THE ENTRY CRITERIA TO PING THE APPROVAL PROCESS
                    if ( ( ( orderHeaderSpecialCategoryCheck.OB_Gambling__c || currentOrderHeader.OB_PO118_Ecommerce__c == true // NEXI-314 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 05/09/2019 changed gambling source
                            || currentOrderHeader.OB_PO118_MOTO__c == true || currentOrderHeader.OB_HotelCarRental__c == true
                            || currentOrderHeader.OB_PEP__c == true || currentOrderHeader.OB_isBlackList__c == true
                            || currentOrderHeader.OB_isUCAMP__c == true || currentOrderHeader.OB_PreAuth__c == true //||currentOrderHeader.OB_ManualPAN__c 	== true
                    ) && acquirerNexi == true && checkVM == true ) ||
                            ( additionalDocRequired == true && checkAcquiringOnConfiguration == false ) )
                    {
                        System.debug( '@Into if where check the entry criteria to ping the approval process' );
                        toReturn = true;
                        currentOrderHeader.OB_StartApprovalProcess__c = true;
                        update currentOrderHeader;
                    }
                    //NEXI-203 Kinga Fornal kinga.fornal@accenture.com, 17.07.2019, START
                    //START //Simone Misani 04/09/2019
                    else if ( OB_UtilityConstants.SETUP.equalsIgnoreCase( currentOrderHeader.OB_Main_Process__c )
                            && (
                            ( acquirerNexi || ( additionalDocRequired == true && checkAcquiringOnConfiguration == false ) )
                                    && ( currentOrderHeader.OB_isBlackList__c
                                    || currentOrderHeader.OB_isUCAMP__c
                                    || currentOrderHeader.OB_PEP__c
                                    || hasSpecialCategory
                                    || currentOrderHeader.OB_PO118_Ecommerce__c
                                    || currentOrderHeader.OB_PO118_MOTO__c
                                    || currentOrderHeader.OB_eCommerce__c
                                    || currentOrderHeader.OB_Moto__c
                                    || currentOrderHeader.OB_HotelCarRental__c
                                    || currentOrderHeader.OB_ManualPAN__c
                                    || gianosValue >= 25 )
                    ) )
                    //END //Simone Misani 04/09/2019
                    {
                        System.debug( '@@@@@ 1' );
                        toReturn = true;
                        currentOrderHeader.OB_StartApprovalProcess__c = true;
                        update currentOrderHeader;
                    }
                    //NEXI-203 Kinga Fornal kinga.fornal@accenture.com, 17.07.2019, END
                    //NEXI-207 Michal Targiel michal.targiel@acceture.com, 17.07.2019, START
                    else if ( OB_UtilityConstants.MAINTENANCE.equalsIgnoreCase( currentOrderHeader.OB_Main_Process__c )
                            && ( ( checkVM
                            && ( currentOrderHeader.OB_isBlackList__c
                            || currentOrderHeader.OB_isUCAMP__c
                            || currentOrderHeader.OB_PEP__c
                            || currentOrderHeader.OB_isPO118__c
                            || currentOrderHeader.OB_PO118_Ecommerce__c
                            || currentOrderHeader.OB_PO118_MOTO__c
                            || currentOrderHeader.OB_HotelCarRental__c
                            || currentOrderHeader.OB_ManualPAN__c
                            || hasSpecialCategory
                            || gianosValue >= 25 ) ) || ( additionalDocRequired == true && checkAcquiringOnConfiguration == false ) ) )//Simone Misani 04/09/2019
                    {
                        System.debug( '@@@@@ 2' );
                        currentOrderHeader.OB_StartApprovalProcess__c = true;
                        toReturn = true;
                    }
                    else if ( OB_UtilityConstants.MAINTENANCE.equalsIgnoreCase( currentOrderHeader.OB_Main_Process__c )
                            && ( ( consistenzaScenarioTwo > 0
                            && ( currentOrderHeader.OB_isBlackList__c
                            || currentOrderHeader.OB_isUCAMP__c
                            || currentOrderHeader.OB_PO118_Ecommerce__c
                            || currentOrderHeader.OB_PO118_MOTO__c
                            || hasSpecialCategory ) ) || ( additionalDocRequired == true && checkAcquiringOnConfiguration == false ) ) )//Simone Misani 04/09/2019
                    {
                        System.debug( '@@@@@ 3' );
                        currentOrderHeader.OB_StartApprovalProcess__c = true;
                        toReturn = true;
                    }
                    //NEXI-207 Michal Targiel michal.targiel@acceture.com, 17.07.2019, STOP
                    else
                    {
                        currentOrderHeader.OB_StartApprovalProcess__c = false;
                        update currentOrderHeader;
                    }
                }
            }
            //UPDATE CURRENT ORDER HEADER
            update currentOrderHeader;
            System.debug( '@currentOrderHeader after final update : ' + JSON.serialize( currentOrderHeader ) );
            OB_UtilityCallingServices.saveToken( OB_UtilityCallingServices.tokenGlobalVar, String.valueof( OB_UtilityCallingServices.timestamp ) );
        } catch ( Exception ecc )
        {
            System.debug( '[EXCE] OB_Utility.retrieveSpecialCategoryConfiguration() :  ' + ecc.getMessage( ) + ' at line: ' + ecc.getLineNumber( ) + ' stack trace: ' + ecc.getStackTraceString( ) );
        }

        System.debug( 'OB_Utility.retrieveSpecialCategoryConfigurations - toReturn ' + toReturn);
        return toReturn;
    }

    /*****************************************************************
    Purpose: Temporary method that will be removed at the end of sprint Anticipazione controlli
    Parameters: List<Id> detectedIdList
    Returns: Map<Id, List<String>>

    History
    --------
    VERSION AUTHOR 				DATE 		DETAIL 		Description
    1.0 	Wojciech Szuba 	    26/07/2019 	Created 	NEXI-208
    *****************************************************************/
    public static Map<Id, List<String>> detectSpecialCategory( List<Id> detectedIdList )
    {
        return OB_Util009_SpecialCategory.detectSpecialCategory( detectedIdList );
    }

    // END    salvatore.pianura 14/03/2019 - R1F2 MultiPV 8 – Allign method with Dev1
    //METHOD TO CALL "CONTROLLI ACQUIRING" APPROVAL PROCESS
    public static void submitApprovalProcess( String objectId, String approvalProcessName )
    {
        if ( approvalProcessName == Label.OB_ApprovalProcessAcquiring )
        {
            //NEXI-287 Marta Stempien <marta.stempien@accenture.com> 29/08/2019 Added fields to query
            List<NE__Order_Header__c> listOfOrderHeader =
            [
                    SELECT Id,
                            Name,
                            OB_Gambling__c,
                            OB_PO118_Ecommerce__c,
                            OB_PO118_MOTO__c,
                            OB_In_Approvazione_a__c,
                            OB_AdditionalDocumentationRequired__c,
                            OB_ApprovalStep__c,
                            OB_PEP__c,
                            OB_Gianos__c,
                            OB_Fiduciarie__c,
                            OB_Onlus__c,
                            OB_Moneytransfer__c,
                            OB_Trust__c,
                            OB_Crowdfunding__c,
                            OB_HotelCarRental__c,
                            OB_ManualPAN__c,
                            OB_eCommerce__c,
                            OB_Moto__c,
                            OB_isBlackList__c,
                            OB_isUCAMP__c,
                            OB_ProcessInstanceAlredyExist__c,
                            OB_StartApprovalProcess__c,
                    ( SELECT id, OB_Bank_LastStatusChange__c,OB_Bank_OrderStatus__c FROM NE__Configurations__r )//elena.preteni 12/06/19 R1F2-246 subquery
                    FROM NE__Order_Header__c
                    WHERE Id = :objectId
                    AND OB_ProcessInstanceAlredyExist__c = false //NEXI-287 Marta Stempien <marta.stempien@accenture.com> 29/08/2019 Add additional condition to where
            ];
            NE__Order_Header__c currentOrderHeader = new NE__Order_Header__c( );
            if ( !listOfOrderHeader.isEmpty( ) && OB_Utility.checkStepsEntryCriteriaOrderHeader( listOfOrderHeader.get( 0 ) ) ) //NEXI-287 Marta Stempien <marta.stempien@accenture.com> 29/08/2019 Add check for meeting steps entry criteria
            {
                currentOrderHeader = listOfOrderHeader.get( 0 );

                //CREATE AN APPROVAL PROCESS FOR THE ORDER HEADER
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest( );
                req1.setComments( 'Submitting request for approval.' );
                req1.setObjectId( currentOrderHeader.Id );

                //SUBMIT ON BEHALF OF A SPECIFIC SUBMITTER
                req1.setSubmitterId( UserInfo.getUserId( ) );

                //SUBMIT THE RECORD TO SPECIFIC PROCESS
                req1.setProcessDefinitionNameOrId( approvalProcessName );
                req1.setSkipEntryCriteria( false );
                System.debug( 'Approval Process: ' + req1 );

                //SUBMIT THE APPROVAL REQUEST FOR THE ACCOUNT
                try
                {
                    Approval.ProcessResult result = Approval.process( req1 );
                    //elena.preteni 12/06/19 R1F2-246
                    if ( !currentOrderHeader.NE__Configurations__r.isEmpty( ) )
                    {
                        NE__Order__c ordersToUpdate = new NE__Order__c( );
                        ordersToUpdate = currentOrderHeader.NE__Configurations__r.get( 0 );
                        ordersToUpdate.OB_Bank_LastStatusChange__c = System.now( );
                        ordersToUpdate.OB_Bank_OrderStatus__c = OB_Order_ChangeStatus.ORDER_STATUS_PROCEDURE_NEXI_PROCESSING;
                        update ordersToUpdate;
                    }
                    //elena.preteni 12/06/19 R1F2-246
                } catch ( Exception ecc )
                {
                    System.debug( '[EXCE] OB_Utility.submitApprovalProcess ' + ecc.getMessage( ) + ' at line: ' + ecc.getLineNumber( ) + ' stack trace: ' + ecc.getStackTraceString( ) );
                }
            }
        }
        if ( approvalProcessName == Label.OB_MAINTENANCE_APPROVALPROCESS )
        {
            System.debug( 'logrequestId : ' + objectId );
            List<OB_LogRequest__c> listOfLogRequests =
            [
                    //NEXI-287 Marta Stempien <marta.stempien@accenture.com> 29/08/2019 Added fields to query
                    SELECT Id,
                            OB_ApprovalStep__c,
                            OB_PEP__c,
                            OB_Gianos__c,
                            OB_isGambling__c,
                            OB_Fiduciarie__c,
                            OB_Onlus__c,
                            OB_Moneytransfer__c,
                            OB_Trust__c,
                            OB_Crowdfunding__c,
                            OB_PO118_eCommerce__c,
                            OB_PO118_MOTO__c,
                            OB_isBlackList__c,
                            OB_StartApprovalProcess__c
                    FROM OB_LogRequest__c
                    WHERE Id = :objectId
            ];
            OB_LogRequest__c currentRequest = new OB_LogRequest__c( );
            if ( !listOfLogRequests.isEmpty( ) && OB_Utility.checkStepsEntryCriteriaLogRequest( listOfLogRequests.get( 0 ) ) && isBooleanTrue( listOfLogRequests.get( 0 ).OB_StartApprovalProcess__c ) ) //NEXI-287 Marta Stempien <marta.stempien@accenture.com> 29/08/2019 Add check for meeting steps entry criteria //NEXI-289 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 04/09/2019 add start approval proces check
            {
                currentRequest = listOfLogRequests.get( 0 );
                //CREATE AN APPROVAL PROCESS FOR THE ORDER HEADER
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest( );
                req1.setComments( 'Submitting request for approval.' );
                req1.setObjectId( currentRequest.Id );

                //SUBMIT ON BEHALF OF A SPECIFIC SUBMITTER
                req1.setSubmitterId( UserInfo.getUserId( ) );

                //SUBMIT THE RECORD TO SPECIFIC PROCESS
                req1.setProcessDefinitionNameOrId( approvalProcessName );
                req1.setSkipEntryCriteria( false );
                //SUBMIT THE APPROVAL REQUEST FOR THE ACCOUNT
                try
                {
                    Approval.ProcessResult result = Approval.process( req1 );
                    System.debug( 'Result: ' + result );
                } catch ( Exception ecc )
                {
                    System.debug( '[EXCE] OB_Utility.submitApprovalProcess ' + ecc.getMessage( ) + ' at line: ' + ecc.getLineNumber( ) + ' stack trace: ' + ecc.getStackTraceString( ) );
                }
            }
        }
        //08-01-2019--S.P.--APPROVAL PROCESS BIO
        if ( approvalProcessName == Label.OB_BIO_ApprovalProcess )
        {
            System.debug( 'INTO APPROVAL PROCESS BIO' );
            try
            {
                List<NE__Order__c> listOfConfigurations =
                [
                        SELECT Id,Name
                        FROM NE__Order__c
                        WHERE Id = :objectId
                ];
                System.debug( 'listOfConfigurations: ' + listOfConfigurations );
                NE__Order__c currentConf = new NE__Order__c( );
                if ( !listOfConfigurations.isEmpty( ) )
                {
                    System.debug( 'INTO IF APPROVAL PROCESS BIO' );
                    currentConf = listOfConfigurations.get( 0 );
                    //CREATE AN APPROVAL PROCESS FOR THE ORDER HEADER
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest( );
                    req1.setComments( 'Submitting request for approval.' );
                    req1.setObjectId( currentConf.Id );

                    //SUBMIT ON BEHALF OF A SPECIFIC SUBMITTER
                    req1.setSubmitterId( UserInfo.getUserId( ) );

                    //SUBMIT THE RECORD TO SPECIFIC PROCESS
                    req1.setProcessDefinitionNameOrId( approvalProcessName );
                    req1.setSkipEntryCriteria( false );
                    System.debug( 'Approval Process: ' + req1 );

                    //SUBMIT THE APPROVAL REQUEST FOR THE ACCOUNT
                    Approval.ProcessResult result = Approval.process( req1 );
                }
            } catch ( Exception ecc )
            {
                System.debug( '[EXCE] OB_Utility.submitApprovalProcess ' + ecc.getMessage( ) + ' at line: ' + ecc.getLineNumber( ) + ' stack trace: ' + ecc.getStackTraceString( ) );
            }
        }
    }
    //26-11-2018---SALVATORE PIANURA
    //METHOD TO CHECK THE CONFIGURATION ITEMS TO CANCEL
    //WHEN AN APPROVAL REQUEST'S REJECTION REASON IS 'DEFINITIVE REJECTION' (METHOD CALLED FROM APEX TRIGGER ON ORDER HEADER)
    @future( callout=true )
    public static void checkItemsToCancel( String orderHeaderId )
    {
        //SEND DINIEGO EMAIL
        System.debug( '@Send diniego email' );
        Set<Id> idOrdeItemEnab = new Set<Id>( );//simone misani 14/06/2019 R1F2-275
        OB_UtilityCallingServices.sendEmail( orderHeaderId );
        //GET CONFIGURATIONS WITH LOOKUP ON CURRENT ORDER HEADER
        List<NE__Order__c> listOfConf =
        [
                SELECT Id, Name,OB_FulfilmentStatus__c,NE__Order_Header__r.OB_FulfilmentStatus__c
                FROM NE__Order__c
                WHERE NE__Order_Header__c = :orderHeaderId
        ];

        List<Id> listOfConfId = new List<Id>( );

        if ( !listOfConf.isEmpty( ) )
        {
            NE__Order_Header__c ohr = new NE__Order_Header__c( Id = orderHeaderId );
            Boolean customOffer = false;

            for ( NE__Order__c conf : listOfConf )
            {
                listOfConfId.add( conf.Id );
            }
            //GET THE CONFIGURATION ITEMS AND THEIR PARENTS
            List<NE__OrderItem__c> listOfItems =
            [
                    SELECT Id, Name, OB_FulfilmentStatus__c, NE__ProdId__c,NE__Root_Order_Item__c,NE__Bundle_Configuration__c,NE__Parent_Order_Item__c, NE__Service_Point__r.OB_Typology__c,NE__ProdId__r.OB_Codice_sfdc__c, // elena.preteni 12/06 R1F2-243 NE__Service_Point__r.OB_Typology__c,NE__ProdId__r.OB_Codice_sfdc__c
                            NE__OrderId__c,NE__ProdId__r.RecordType.DeveloperName,NE__ProdId__r.OB_Acquirer__c,NE__ProdId__r.OB_CommercialBundle__c,
                    (
                            SELECT Id, Name,OB_FulfilmentStatus__c,NE__ProdId__c
                            FROM NE__Parent_Order_Item__r
                    )
                    FROM NE__OrderItem__c
                    WHERE NE__OrderId__c IN:listOfConfId
            ];

            System.debug( 'OB_Utility.checkItemsToCancel() : listOfItems: ' + JSON.serialize( listOfItems ) );

            List<NE__OrderItem__c> finalListOfItems = new List<NE__OrderItem__c>( );

            //CHECK THE CONFIGURATION ITEMS TO CANCEL WHEN OFFER TYPE IS "START"

            for ( NE__OrderItem__c item : listOfItems )
            {
                //CHECK THE CONFIGURATION ITEMS TO CANCEL WHEN OFFER TYPE IS "START" OR "XPAYFULL"
                if ( item.NE__Root_Order_Item__c == null &&
                        item.NE__Bundle_Configuration__c == null &&
                        ( item.NE__Service_Point__r.OB_Typology__c == 'Virtuale' || item.NE__ProdId__r.OB_Codice_sfdc__c.equalsIgnoreCase( OB_UtilityConstants.START_SFDC ) ) )// elena.preteni 12/06 R1F2-243
                {
                    System.debug( 'OB_Utility.checkItemsToCancel() : Offerta Start/XPayFull' );
                    finalListOfItems.addAll( listOfItems );
                    //CHANGE ORDER AND ORDER HEADER'S STATUS TO "CANCELLED" IF OFFER'S TYPE IS "START" OR "XPAYFULL"
                    for ( NE__Order__c ord : listOfConf )
                    {
                        ord.OB_FulfilmentStatus__c = OB_UtilityConstants.ORDERITEM_STATUS_CANCELLED;
                    }

                    ohr.OB_FulfilmentStatus__c = OB_UtilityConstants.ORDERITEM_STATUS_CANCELLED;
                    break;
                }
                if ( item.NE__Root_Order_Item__c == null &&
                        item.NE__Bundle_Configuration__c == null &&
                        item.NE__ProdId__r.OB_Codice_sfdc__c.equalsIgnoreCase( OB_UtilityConstants.CUSTOM_SFDC ) )// elena.preteni 12/06 R1F2-243
                {
                    System.debug( 'OB_Utility.checkItemsToCancel() : Offerta Personalizzata' );
                    customOffer = true;
                }
            }

            //CHECK THE CONFIGURATION ITEMS TO CANCEL WHEN OFFER TYPE IS "CUSTOM OFFER"
            if ( customOffer == true )
            {
                for ( NE__OrderItem__c itemOfCustomOffer : listOfItems )
                {
                    //START----simone misani 14/06/2019 R1F2-275
                    if ( itemOfCustomOffer.NE__ProdId__r.RecordType.DeveloperName == OB_UtilityConstants.PRODUCT_RECORDTYPE_ACQUIRING || itemOfCustomOffer.NE__ProdId__r.RecordType.DeveloperName == 'Commissione' || itemOfCustomOffer.NE__ProdId__r.RecordType.DeveloperName == OB_UtilityConstants.PRODUCT_RECORDTYPE_PCI ||
                            ( itemOfCustomOffer.NE__ProdId__r.OB_Acquirer__c == OB_UtilityConstants.PRODUCT_ACQUIRER_NEXI && ( itemOfCustomOffer.NE__ProdId__r.RecordType.DeveloperName == OB_UtilityConstants.PRODUCT_RECORDTYPE_VAS ||
                                    itemOfCustomOffer.NE__ProdId__r.RecordType.DeveloperName == OB_UtilityConstants.PRODUCT_RECORDTYPE_PAGOBANCOMAT ) ) )
                    {
                        //END----simone misani 14/06/2019 R1F2-275
                        //NEXI-220 Monika Kocot monika.kocot@accenture.com, 18/07/2019 START change logic on acquiring approval process refusal
                        //CHECK THE CONFIGURATION ITEMS TO CANCEL WHEN OFFER TYPE IS NOT "START" (is Custom ) AND SP Typology is "Fisico"
                        if ( OB_UtilityConstants.SERVICE_POINT_FISICO.equalsIgnoreCase( itemOfCustomOffer.NE__Service_Point__r.OB_Typology__c ) )
                        {
                            ohr.OB_POSInstallationOnlyPBOperator__c = true;
                        }
                        //NEXI-220 Monika Kocot monika.kocot@accenture.com, 18/07/2019 STOP

                        //LUBRANO - 15/03/2019 - ACQUIRING CHILD ITEM STATUS UPDATE
                        if ( itemOfCustomOffer.NE__Parent_Order_Item__c == null )
                        {
                            finalListOfItems.add( itemOfCustomOffer );
                            //START-----simone misani 14/06/2019 R1F2-275
                            if ( itemOfCustomOffer.NE__ProdId__r.RecordType.DeveloperName.equalsIgnoreCase( OB_UtilityConstants.ACQUIRING_RT ) || itemOfCustomOffer.NE__ProdId__r.RecordType.DeveloperName.equalsIgnoreCase( OB_UtilityConstants.PRODUCT_RECORDTYPE_COMMISSIONE ) )
                            {
                                idOrdeItemEnab.add( itemOfCustomOffer.NE__ProdId__c );
                            }

                            //END------simone misani14/06/2019 R1F2-275
                            //IF ORDER ITEMS HAVE A CHILDS, CHANGE CHILD'S STATUS TO "CANCELLED"
                            for ( NE__OrderItem__c parentItem : itemOfCustomOffer.NE__Parent_Order_Item__r )
                            {
                                //LUBRANO - 15/03/2019 - ACQUIRING CHILD ITEM STATUS UPDATE
                                finalListOfItems.add( parentItem );
                            }
                        }
                    }
                }
            }
            //CHANGE ORDER ITEM'S STATUS TO "CANCELLED"
            for ( NE__OrderItem__c item : finalListOfItems )
            {

                item.OB_FulfilmentStatus__c = OB_UtilityConstants.ORDERITEM_STATUS_CANCELLED;
            }
            System.debug( 'idOrdeItemEnab: ' + idOrdeItemEnab );
            //START-----simone misani14/06/2019 R1F2-275
            List<NE__OrderItem__c> listOrderItemAcqEnab =
            [
                    SELECT Id,
                            OB_FulfilmentStatus__c
                    FROM NE__OrderItem__c
                    WHERE
                    NE__OrderId__c IN :listOfConfId
                    AND NE__Parent_Order_Item__c != ''
                    AND NE__ProdId__c IN :idOrdeItemEnab
                    AND NE__ProdId__r.OB_Acquirer__c = 'NEXI'
            ];

            for ( NE__OrderItem__c item : listOrderItemAcqEnab )
            {

                item.OB_FulfilmentStatus__c = OB_UtilityConstants.ORDERITEM_STATUS_CANCELLED;
                finalListOfItems.add( item );
            }
            //END------simone misani14/06/2019 R1F2-275

            update ohr;
            update finalListOfItems;
            update listOfConf;


            System.debug( 'OB_Utility.checkItemsToCancel() : finalListOfItems: ' + finalListOfItems );
            System.debug( 'OB_Utility.checkItemsToCancel() : listOfConf: ' + listOfConf );
            System.debug( 'OB_Utility.checkItemsToCancel() ---> OB_UtilityCallingServices.callSubmit(Id: ' + orderHeaderId + ');' );
            //CALL SUBMIT FROM QUEUEABLE CLASS
            //11-02-2019-S.P-DON'T CALL SUBMIT IF IS A MAINTENANCE'S ORDER
            if ( ohr.OB_Main_Process__c != 'Maintenance' )
            {
                System.enqueueJob( new OB_QueueableClass( orderHeaderId ) );
            }
        }
    }

    //METHOD TO CHANGE STATUS OF ORDER HEADER, CONFIGURATION
    //AND CONFIGURATION ITEM WHEN THE ORDER IS SENT
    public static void changeStatus( String orderHeaderId )
    {
        System.debug( '@Into OB_Utility.changestatus(' + orderHeaderId + ')' );
        List<NE__Order__c> listOfConf = new List<NE__Order__c>( );
        List<Id> listOfId = new List<Id>( );
        NE__Order_Header__c currentOrderHeader = new NE__Order_Header__c( );
        String mainProcess; //francesca.ribezzi 18/09/19 - WN-420 getting main process
        Boolean isGTother = false; //francesca.ribezzi 18/09/19 - WN-420 adding isGTother check
        List<NE__OrderItem__c> listOfChildren = new   List<NE__OrderItem__c>(); //francesca.ribezzi 18/09/19 - WN-420 - adding children to update those as well
        List<NE__Order_Header__c> listOfOrderHeader =
        [
                SELECT Id, Name, OB_FulfilmentStatus__c, OB_Main_Process__c, //francesca.ribezzi 18/09/19 - WN-420 - adding mainProcess field
                ( SELECT Id, OB_FulfilmentStatus__c,OB_MIPSubmissionDate__c FROM NE__Configurations__r )
                FROM NE__Order_Header__c
                WHERE Id = :orderHeaderId
        ];//antonio.vatrano 23/05/2019 add OB_MIPSubmissionDate__c

        if ( !listOfOrderHeader.isEmpty( ) )
        {
            mainProcess = listOfOrderHeader.get(0).OB_Main_Process__c; //francesca.ribezzi 18/09/19 - WN-420 setting main process
            currentOrderHeader = listOfOrderHeader.get( 0 );
            //CHANGE STATUS OF ORDER HEADER
            if ( currentOrderHeader.OB_FulfilmentStatus__c != OB_UtilityConstants.ORDERITEM_STATUS_CANCELLED )
            {
                currentOrderHeader.OB_FulfilmentStatus__c = OB_UtilityConstants.ORDERS_STATUS_SENT;
                System.debug( 'OB_Utility.changestatus() : currentOrderHeader : ' + currentOrderHeader );
                update currentOrderHeader;
            }

            listOfConf = currentOrderHeader.NE__Configurations__r;
            if ( !listOfConf.isEmpty( ) )
            {
                for ( NE__Order__c conf : listOfConf )
                {
                    //SAVE IN A LIST THE CONFIGURATIONS ID
                    listOfId.add( conf.Id );
                    //CHANGE STATUS OF CONFIGURATIONS OF THIS ORDER HEADER
                    if ( conf.OB_FulfilmentStatus__c != OB_UtilityConstants.ORDERITEM_STATUS_CANCELLED )
                    {
                        conf.OB_FulfilmentStatus__c = OB_UtilityConstants.ORDERS_STATUS_SENT;
                    }
                }
                System.debug( 'OB_Utility.changestatus() : listOfConf : ' + listOfConf );
                update listOfConf;

                //GET THE CONFIGURATION ITEMS OF THIS CONFIGURATIONS
                List<NE__OrderItem__c> listOfItems =
                [
                        SELECT 
                        Id,
                        NE__ProdId__r.OB_Acquirer__c,
                        NE__ProdName__c,
                        OB_FulfilmentStatus__c, 
                        OB_GT__c,
                        NE__ProdId__r.OB_Codice_sfdc__c,  //francesca.ribezzi 18/09/19 - WN-420 adding subquery and adding fields
                        (SELECT id,OB_GT__c,NE__ProdId__r.OB_Acquirer__c,NE__ProdName__c, NE__ProdId__r.OB_Codice_sfdc__c,OB_FulfilmentStatus__c  From NE__Parent_Order_Item__r )
                        FROM NE__OrderItem__c
                        WHERE NE__OrderId__c IN:listOfId
                        AND NE__Parent_Order_Item__c = null
                ];
                //START francesca.ribezzi 18/09/19 - WN-420 - setting isGTother
                for (NE__OrderItem__c item : listOfItems ){
                    if(item.OB_GT__c  == OB_UtilityConstants.GT_OTHER){
                        isGTother = true;
                        break;
                    }
                }
                //END francesca.ribezzi 18/09/19 - WN-420 
                if ( !listOfItems.isEmpty( ) )
                {
                    //CHANGE STATUS OF CONFIGURATION ITEMS
                    for ( NE__OrderItem__c item : listOfItems )
                    {
                        //START francesca.ribezzi 18/09/19 - WN-420 - adding conditions for gt equals to Other
                        Boolean isPagobancomat = (item.NE__ProdId__r.OB_Codice_sfdc__c == 'PAGOBANCOMAT' && item.NE__ProdId__r.OB_Acquirer__c != OB_UtilityConstants.GT_NEXICAPS);
                        Boolean isPOSother = (item.OB_GT__c == OB_UtilityConstants.GT_OTHER);
                        Boolean isNotCancelled = (item.OB_FulfilmentStatus__c != OB_UtilityConstants.ORDERITEM_STATUS_CANCELLED);
                        if(isGTother){ //if gt is other, setting FulfilmentStatus as completed for both parents and children and also for pagobancomat
                            if(isPagobancomat){ //for pagobancomat
                                item.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
                                for(NE__OrderItem__c oi : item.NE__Parent_Order_Item__r){
                                    oi.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;  
                                    listOfChildren.add(oi);
                                }
                            }
                            else if(isPOSother){ //for gt other
                                item.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;   
                                for(NE__OrderItem__c oi : item.NE__Parent_Order_Item__r){
                                    oi.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;  
                                    listOfChildren.add(oi);
                                }
                            }else if(isNotCancelled){ //for status not cancelled //&& !isPagobancomat && !isPOSother
                                item.OB_FulfilmentStatus__c = OB_UtilityConstants.ORDERS_STATUS_SENT;
                                for(NE__OrderItem__c oi : item.NE__Parent_Order_Item__r){
                                    oi.OB_FulfilmentStatus__c = OB_UtilityConstants.ORDERS_STATUS_SENT;  
                                      listOfChildren.add(oi);
                                }
                            }
                         //END francesca.ribezzi 18/09/19 - WN-420 
                        }else{  //if it is not gt other
                            if(isNotCancelled){
                                item.OB_FulfilmentStatus__c = OB_UtilityConstants.ORDERS_STATUS_SENT;
                                for(NE__OrderItem__c oi : item.NE__Parent_Order_Item__r){
                                    oi.OB_FulfilmentStatus__c = OB_UtilityConstants.ORDERS_STATUS_SENT;  
                                      listOfChildren.add(oi);
                                }
                            }

                        }
                    }
                    System.debug( 'OB_Utility.changestatus() : listOfItems : ' + listOfItems );
                    listOfItems.addAll(listOfChildren); //francesca.ribezzi 18/09/19 - WN-420 - adding children to update those as well
                    update listOfItems;
                }
            }
        }
    }

    /*******************************************************************************
    Purpose:  Method checks data of Log Request, prepare changes needed for submitApprovalProcess and update
    Log Request object
    Parameters: String logRequestId
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Salvatore Pianura       08/01/2019      Created         ACCEPT METHOD ON LOG REQUEST
    1.1         Wojciech Szuba          08/10/2019      Modified        NEXI-358
    ********************************************************************************/
    @AuraEnabled
    public static void checkLogRequest( String logRequestId )
    {
        System.debug( '@Into checkLogRequest' );
        try
        {
            List<OB_LogRequest__c> requests =
            [
                    SELECT Id,
                            Name,
                            OB_ReducedOldData__c,
                            OB_ReducedNewData__c,
                            OB_Status__c,OB_ABI__c,
                            OB_AccountId__c,
                            OB_PEP__c,
                            OB_isBlackList__c,
                            OB_ServicePointId__c,
                            OB_StartApprovalProcess__c,
                            OB_ChangeLegalRepresentative__c,
                            OB_NewLegalRepresentative__c,
                            OB_AccountId__r.NE__VAT__c,
                            OB_AccountId__r.NE__Fiscal_code__c
                    FROM OB_LogRequest__c
                    WHERE Id = :logRequestId
                    LIMIT 1
            ];
            OB_LogRequest__c request = new OB_LogRequest__c( );
            Boolean checkApprovalProcess = false;
            if ( !requests.isEmpty( ) )
            {
                request = requests.get( 0 );
                if ( request.OB_ChangeLegalRepresentative__c || request.OB_NewLegalRepresentative__c )
                {
                    System.debug( '@Is new legal representative or a change' );
                    // TODO -> SALVATORE
                    String vat = request.OB_AccountId__r.NE__VAT__c;
                    String taxCode = request.OB_AccountId__r.NE__Fiscal_code__c;
                    Boolean checkPep = false;
                    System.debug( '@Vat is present' );
                    String accountId = request.OB_AccountId__c;
                    System.debug( '@accountId ' + accountId + '    ' + OB_UtilityConstants.ORDERITEM_STATUS_CANCELLED + '    ' + request.OB_ABI__c );

                    List<Asset> listOfAsset =
                    [
                            SELECT Id,NE__CatalogItem__r.NE__ProductId__r.OB_Acquirer__c
                            FROM Asset
                            WHERE NE__CatalogItem__r.NE__ProductId__r.OB_Acquirer__c = :OB_UtilityConstants.PRODUCT_ACQUIRER_NEXI
                            AND ( NE__Status__c = 'Active' OR NE__Status__c = 'In progress')
                            AND AccountId = :accountId
                    ];
                    System.debug( '@listOfAsset in acceptLogRequest: ' + listOfAsset );

                    if ( !listOfAsset.isEmpty( ) )
                    {
                        Boolean acquirerNexi = false;
                        String esecFiscalCode;
                        Boolean esecPep = false;
                        Boolean oldEsecPep = false;

                        Map<String, Object> mapReducednewData = ( Map<String, Object> ) JSON.deserializeUntyped( request.OB_ReducednewData__c );
                        List<Object> newlistOfObjs = ( List<Object> ) JSON.deserializeUntyped( JSON.serialize( mapReducednewData.get( 'obj' ) ) );
                        List<Map<String, Object>> newlistOfMaps = new List<Map<String, Object>>( );
                        for ( Object obj : newlistOfObjs )
                        {
                            newlistOfMaps.add( ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( obj ) ) );
                        }
                        for ( Map<String, Object> singlemap : newlistOfMaps )
                        {
                            if ( singlemap.containsKey( 'attributes' ) )
                            {
                                Map<String, Object> attributesmap = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( singlemap.get( 'attributes' ) ) );
                                if ( attributesmap.containsKey( 'type' ) && attributesmap.get( 'type' ) == 'Contact' )
                                {

                                    if ( singlemap.containsKey( 'OB_Fiscal_Code__c' ) )
                                    {
                                        esecFiscalCode = ( String ) singlemap.get( 'OB_Fiscal_Code__c' );
                                        System.debug( '@esecFiscalCode : ' + esecFiscalCode );
                                    }
                                    if ( singlemap.containsKey( 'OB_PEP__c' ) )
                                    {
                                        esecPep = ( Boolean ) singlemap.get( 'OB_PEP__c' );
                                        System.debug( '@esecPep : ' + esecPep );
                                    }
                                }
                            }
                        }
                        // --------------------------------------------REDUCED OLD DATA TO GET OLD VALUE OF PEP----------------------------------------------------
                        Map<String, Object> mapReducedoldData = ( Map<String, Object> ) JSON.deserializeUntyped( request.OB_ReducedOldData__c );
                        List<Object> oldlistOfObjs = ( List<Object> ) JSON.deserializeUntyped( JSON.serialize( mapReducedoldData.get( 'obj' ) ) );
                        List<Map<String, Object>> oldlistOfMaps = new List<Map<String, Object>>( );
                        for ( Object obj : oldlistOfObjs )
                        {
                            oldlistOfMaps.add( ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( obj ) ) );
                        }
                        for ( Map<String, Object> oldSinglemap : oldlistOfMaps )
                        {
                            if ( oldSinglemap.containsKey( 'attributes' ) )
                            {
                                Map<String, Object> attributesmap = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( oldSinglemap.get( 'attributes' ) ) );
                                if ( attributesmap.containsKey( 'type' ) && attributesmap.get( 'type' ) == 'Contact' )
                                {
                                    if ( oldSinglemap.containsKey( 'OB_PEP__c' ) )
                                    {
                                        oldEsecPep = ( Boolean ) oldSinglemap.get( 'OB_PEP__c' );
                                        System.debug( '@oldEsecPep : ' + oldEsecPep );
                                    }
                                }
                            }
                        }
                        // --------------------------------------REDUCED OLD DATA TO GET OLD VALUE OF PEP---------------------------------------------------------

                        if ( oldEsecPep == true && request.OB_ChangeLegalRepresentative__c == true )
                        {
                            checkPep = true;
                        }

                        if ( !listOfAsset.isEmpty( ) && listOfAsset.size( ) > 0 )
                        {
                            acquirerNexi = true;
                            System.debug( '@Is an acquirer nexi' );
                        }

                        Boolean responseBlackList = false;
                        if ( request.OB_NewLegalRepresentative__c )
                        {
                            if ( vat != null && vat != '' )
                            {
                                String token = OB_UtilityCallingServices.checkToken( );
                                responseBlackList = OB_UtilityCallingServices.callServiceBlacklist( vat, taxCode, esecFiscalCode, token );
                                System.debug( 'OB_Maintenance_View_Request_Controller.acceptLogRequest() : responseBlackList : ' + responseBlackList );
                                request.OB_isBlackList__c = responseBlackList;
                            }
                        }
                        request.OB_PEP__c = esecPep;
                        //update request;

                        System.debug( '@request.OB_isBlackList__c : ' + request.OB_isBlackList__c );
                        System.debug( '@request.OB_PEP__c : ' + request.OB_PEP__c );
                        System.debug( '@acquirerNexi : ' + acquirerNexi );
                        System.debug( '@checkPEP: ' + checkPep );
                        //NEXI-289 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 04/09/2019 Start
                        //NEXI-204 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 22/07/2019 Start
                        if ( request.OB_NewLegalRepresentative__c && !OB_Util009_Gianos.callToGianos( request.Id, true ) )
                        {
                            System.debug( LoggingLevel.ERROR, '[EXC] OB_Utility.checkLogRequest Gianos integration error' );
                            throw new OB_Util009_Gianos.GianosException( Label.OB_ServerLogicFailed );
                        }
                        //NEXI-204 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 22/07/2019 Stop
                        List<OB_LogRequest__c> listOfLogRequests =
                        [
                                SELECT Id,
                                        OB_ApprovalStep__c,
                                        OB_PEP__c,
                                        OB_Gianos__c,
                                        OB_isGambling__c,
                                        OB_Fiduciarie__c,
                                        OB_Onlus__c,
                                        OB_Moneytransfer__c,
                                        OB_Trust__c,
                                        OB_Crowdfunding__c,
                                        OB_PO118_eCommerce__c,
                                        OB_PO118_MOTO__c,
                                        OB_isBlackList__c,
                                        OB_StartApprovalProcess__c
                                FROM OB_LogRequest__c
                                WHERE Id = :request.Id
                        ];
                        if(!listOfLogRequests.isEmpty( ))
                        {
                            listOfLogRequests.get( 0 ).OB_PEP__c = esecPep;
                        }
                        if ( !listOfLogRequests.isEmpty( ) && checkStepsEntryCriteriaLogRequest( listOfLogRequests.get( 0 ) ) ) //NEXI-287 Marta Stempien <marta.stempien@accenture.com> 03/09/2019
                        {
                            //NEXI-289 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 04/09/2019 Stop
                            // NEXI-281 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 28/08/2019 START moved Gianos callout to beginning to handle updates

                            //NEXI-288 Marta Stempien <marta.stempien@accenture.com>, 29/08/2019 Deleted unnecessary check
                            //CALL METHOD TO SUBMIT REQUEST IN APPROVAL PROCESS MAINTENANCE
                            System.debug( LoggingLevel.DEBUG, 'OB_Utility.checkLogRequest Call Approval Process ' + Label.OB_MAINTENANCE_APPROVALPROCESS + ' on ' + request.Name );
                            request.OB_StartApprovalProcess__c = true;
                            //NEXI-293 Marta Stempien <marta.stempien@accenture.com> 03/09/2019 Deleted setting status
                            update request;

                            checkApprovalProcess = true;
                            OB_Utility.submitApprovalProcess( logRequestId, Label.OB_MAINTENANCE_APPROVALPROCESS );
                            OB_Util009_AVRSOS.calloutAVRSOS( request.OB_AccountId__c, request.Id, OB_UtilityConstants.MAINTENANCE ); //NEXI-214 Damian Krzyzaniak <damian.krzyzaniak@accenture.com> 22/08/2019
                            System.debug( LoggingLevel.DEBUG, 'OB_Utility.checkLogRequest log request after callouts : ' + JSON.serialize( request ) );

                            // NEXI-281 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 28/08/2019 STOP
                            // NEXI-358 Wojciech Szuba, <wojciech.szuba@accenture.com>, 08/10/2019, START
                            List<OB_LogRequest__c> valuesFromApprovalProcess =
                            [
                                    SELECT OB_Status__c,
                                            OB_RejectReason__c
                                    FROM OB_LogRequest__c
                                    WHERE Id = :logRequestId
                                    LIMIT 1
                            ];
                            if ( !valuesFromApprovalProcess.isEmpty( )  )
                            {
                                request.OB_Status__c = valuesFromApprovalProcess.get( 0 ).OB_Status__c;
                                request.OB_RejectReason__c = valuesFromApprovalProcess.get( 0 ).OB_RejectReason__c;
                            }
                            // NEXI-358 Wojciech Szuba, <wojciech.szuba@accenture.com>, 08/10/2019, STOP
                        }
                        else
                        {
                            request.OB_Status__c = OB_UtilityConstants.LOGREQUEST_STATUS_INATTESA;//NEXI-127 Marta Stempien<marta.stempien@accenture.com>, 26/06/2019
                            update request;
                        }
                    }
                    //giovanni spinelli 03/05/2019 - start -PRODOB-174
                    else
                    {
                        System.debug( 'into else empty asset list' );
                        request.OB_Status__c = OB_UtilityConstants.LOGREQUEST_STATUS_INATTESA;
                        update request;
                    }
                    //giovanni spinelli 03/05/2019 - end -PRODOB-174
                }
                else
                {
                    request.OB_Status__c = OB_UtilityConstants.LOGREQUEST_STATUS_DRAFT;
                    update request;
                }
                //SP - 07/01/2019
                OB_UtilityCallingServices.saveToken( OB_UtilityCallingServices.tokenGlobalVar, String.valueof( OB_UtilityCallingServices.timestamp ) );
                if ( !checkApprovalProcess )
                {
                    System.debug( '@Final accept log request' );
                }
                //	START 	micol.ferrari 10/01/2019
                else
                {
                    update request;
                }
                //	END 	micol.ferrari 10/01/2019
            }
        } catch ( Exception ecc )
        {
            System.debug( '[EXCE] OB_Utility.checkLogRequest ' + ecc.getMessage( ) + ' at line: ' + ecc.getLineNumber( ) + ' stack trace: ' + ecc.getStackTraceString( ) );
        }
    }

    @AuraEnabled
    public static Boolean checkForAcquiringChanges( List<Id> confList )
    {
        Boolean acqChanged = false;
        List<NE__Order_Item_Attribute__c> attributesAcquiringEditing = new List<NE__Order_Item_Attribute__c>( );
        List<NE__OrderItem__c> itemModificaModelloCommissionale = new List<NE__OrderItem__c>( );
        attributesAcquiringEditing =
        [
                SELECT Id,
                        NE__Old_Value__c,
                        NE__Value__c
                FROM NE__Order_Item_Attribute__c
                WHERE NE__Order_Item__r.NE__OrderId__c IN :confList
                AND NE__Order_Item__r.NE__ProdId__r.RecordType.DeveloperName = 'Pricing'
                AND NE__Order_Item__r.NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName = 'Acquiring'
                AND NE__Order_Item__r.NE__Action__c = 'Change'
        ];
        itemModificaModelloCommissionale =
        [
                SELECT Id
                FROM NE__OrderItem__c
                WHERE NE__OrderId__c IN :confList
                AND NE__ProdId__r.RecordType.DeveloperName = 'Commissione'
                AND NE__Action__c = 'Add'
        ];

        if ( attributesAcquiringEditing.size( ) > 0 || itemModificaModelloCommissionale.size( ) > 0 )
        {
            acqChanged = true;
        }

        return acqChanged;
    }

    public static void opsEndFlow( String configurationId, Boolean missingFieldsBoolean )
    {
        NE__Order__c conf =
        [
                SELECT Id,OB_AdditionalDocumentationRequired__c,Name,OB_StartPricingApprovalProcess__c,
                        NE__Order_Header__r.OB_ProposerABI__r.Name,OwnerId,NE__Order_Header__r.OB_ProposerABI__r.OB_ABI__c,
                        OB_ApprovalType__c,OB_ApprovalStatus__c
                FROM NE__Order__c
                WHERE Id = :configurationId
        ];
        if ( conf != null )
        {
            String stringConcat;
            conf.OB_FulfilmentStatus__c = OB_UtilityConstants.ORDERS_STATUS_PENDING;
            update conf;
            System.debug( 'OB_Utility.opsEndFlow() : conf ' + JSON.serialize( conf ) );

            List<NE__OrderItem__c> listOfItems =
            [
                    SELECT Id,OB_FulfilmentStatus__c
                    FROM NE__OrderItem__c
                    WHERE NE__OrderId__c = :configurationId
            ];
            if ( !listOfItems.isEmpty( ) )
            {
                for ( NE__OrderItem__c item : listOfItems )
                {
                    item.OB_FulfilmentStatus__c = OB_UtilityConstants.ORDERS_STATUS_PENDING;
                }
                update listOfItems;

                System.debug( 'OB_Utility.opsEndFlow() : listOfItems ' + JSON.serialize( listOfItems ) );
            }

            System.debug( 'CONF_ID_BEFORE_ENRICH_ORDER: ' + conf.Id );
            Boolean isEnriched = OB_EnrichOrder.setConfigurationInformation( configurationId );
            System.debug( 'BOOLEAN_ENRICH: ' + isEnriched );
            //giovanni spinelli 12/04/2019 stop this method if there are missing fields -start
            if ( missingFieldsBoolean != true )
            {
                System.enqueueJob( new OB_QueueableClassCheckApprovalProcesses( configurationId ) );
            }
        }
    }

    // START    antonio.vatrano 15/03/2019 - R1F2 MultiPV  – Retrieve documents from Filenet
    public static Map<String, Documents> getDocumentsFromFilenet( String orderHeaderId )
    {
        Map<String, Documents> toReturn = new Map<String, Documents>( );
        List<NE__Order__c> orders = getOrders( orderHeaderId );
        if ( !orders.isEmpty( ) )
        {
            for ( NE__Order__c ord : orders )
            {
                String orderId = ord.Id;
                String merchantId = ord.NE__Order_Header__r.NE__AccountId__c;
                String salesPointId = ord.OB_Service_Point__c;
                String url = 'callout:OB_callService/api/merchants/' + merchantId + '/sales-points/' + salesPointId + '/orders/' + orderId + '/documents';
                HttpRequest req = new HttpRequest( );
                req.setEndpoint( url );
                req.setMethod( 'GET' );
                String token = OB_UtilityCallingServices.checkToken( );
                req.setHeader( OB_UtilityConstants.AUTH, OB_UtilityConstants.PREFIX + token );
                req.setHeader( 'Content-Type', 'application/json' );
                Http http = new Http( );
                HTTPResponse res = http.send( req );
                system.debug( '###MY RES' + res.getBody( ) );
                String jsonResponse = res.getBody( );
                String response = jsonResponse .replace( 'string', 'str' ).replaceAll( '\\\\', '' );
                Documents listDocuments = ( Documents ) JSON.deserialize( response, Documents.class );
                toReturn.put( orderId, listDocuments );
            }
        }
        return toReturn;
    }
    // RETRIEVE ORDERS BY ORDERHEADERID
    public static List<NE__Order__c> getOrders( String orderHeaderId )
    {
        List<NE__Order__c> orders =
        [
                SELECT Id,OB_Service_Point__c, NE__Order_Header__r.NE__AccountId__c
                FROM NE__Order__c
                WHERE NE__Order_Header__c = :orderHeaderId
        ];
        System.debug( '@@orders: ' + orders );
        return orders;
    }
    //Class wrapper for DOCS
    public class Documents
    {
        list<Document> documents;
    }
    public class Document
    {
        String documentId;
        list<Metadata> metadata;
    }
    public class Metadata
    {
        String metadataLabel;
        List<Values> values;
        String indexId;
    }
    public class Values
    {
        String str;
    }
    // METHOD TO GET ORDERITEMS BY ORDER
    public static List<NE__OrderItem__c> getOrderItems( String orderId )
    {
        List<NE__OrderItem__c> orderItems =
        [
                SELECT Id, NE__Parent_Order_Item__c, NE__ProdId__c,
                        NE__ProdId__r.Name, NE__Parent_Order_Item__r.NE__ProdId__r.Id,
                        NE__ProdId__r.NE__Engine_Code__c,NE__ProdId__r.RecordType.DeveloperName,
                        NE__OrderId__r.NE__Order_Header__c,
                        NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName,
                        NE__OrderId__r.NE__Order_Header__r.OB_Main_Process__c,
                        NE__OrderId__r.NE__Order_Header__r.OB_Business_Model_Acquiring__c,
                        NE__OrderId__r.NE__Order_Header__r.OB_Business_Model_POS__c
                FROM NE__OrderItem__c
                WHERE NE__OrderId__c = :orderId
        ];
        System.debug( '@@orderItems:  ' + orderItems );
        return orderItems;
    }
    // method to retrieve all OB_Special_Category_Configuration__c where OB_DocRequired__c = true
    public static List<OB_Special_Category_Configuration__c> getSpecialCategory( )
    {
        List<OB_Special_Category_Configuration__c> listSpecialCategory =
        [
                SELECT Name,OB_ATECO__c,OB_Commercial_Product__c,OB_DocRequired__c,
                        OB_DescriptionNoVat__c,OB_isCrowdfunding__c,OB_Legal_Form__c,
                        OB_MCC__c, RecordType.DeveloperName,OB_EngineCodeCommercialProduct__c,OB_RequestType__c
                FROM OB_Special_Category_Configuration__c
                WHERE OB_DocRequired__c = true
        ];
        system.debug( '@@listSpecialCategory: ' + listSpecialCategory );
        return listSpecialCategory;
    }
    // retrieve docs filtered by clientType and mainProcess
    public static List<OB_Product_Document__c> getAllDocuments( List<String> listClientType, String mainProcess )
    {
        List<OB_Product_Document__c> docs =
        [
                SELECT Name, OB_Description__c, OB_Commercial_Product__r.Name,
                        OB_Commercial_Product__c,OB_DocumentCode__c,OB_Start_Date__c, OB_End_Date__c,
                        OB_Client_Type__c,OB_Request_Typology__c,OB_Document_Typology__c,
                        OB_Multiple_upload__c,OB_Business_Model__c,Related_To__c
                FROM OB_Product_Document__c
                WHERE OB_Client_Type__c in :listClientType
                AND OB_Request_Typology__c = :mainProcess
        ];
        System.debug( '@@documents: ' + docs );
        return docs;
    }
    // END    antonio.vatrano 15/03/2019 - R1F2 MultiPV  – Retrieve documents from Filenet
    /* 
        *   Author      : Morittu Andrea
        *   Date        : 27/Aug/2019
        *   Description : Centralized Class to build Object Metadata
    */
    public class dataTableAccountWrapper {
        @AuraEnabled
        public String label                                                                 {get;set;}
        @AuraEnabled
        public String fieldName                                                          {get;set;}
        @AuraEnabled
        public String type                                                                  {get;set;}
    }

    /* 
        *   Author      : Morittu Andrea
        *   Date        : 27/Aug/2019
        *   Description : Centralized Method to build Object Metadata
    */
    @AuraEnabled
    public static List<dataTableAccountWrapper> retrieveObjectFieldsDetails(String objectType){

        List<dataTableAccountWrapper> dataTableScaffolding = new List<dataTableAccountWrapper>();

        try {
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Schema.SObjectType schema = schemaMap.get(objectType);
            Map<String, Schema.SObjectField> fieldMap = schema.getDescribe().fields.getMap();


                for (String fieldName: fieldMap.keySet()) {                    
					dataTableAccountWrapper singleWrap = new dataTableAccountWrapper();
					singleWrap.label            = fieldMap.get(fieldName).getDescribe().getLabel();
					singleWrap.fieldName     = fieldName;
					singleWrap.type             = String.valueOf(fieldMap.get(fieldName).getDescribe().getType());
					dataTableScaffolding.add(singleWrap);
                }
        } catch(Exception exc) {
            System.debug('An error has occured : ' + exc.getMessage());
        }
        return dataTableScaffolding;
    }
    /*
    * Author : Giovanni Spinelli
    * Date : 23/07/2019
    * Description : Method to convert some fields to uppercase if new objects are created.
    *   Input : list object and list of fields to make uppercase
    *   Output : -
    *   Note: 	this method is called from triggers class
    */
    public static void toUppercaseInsert( list<SObject> objToConvertList, List<String> fieldsListToUppercase )
    {


        System.debug( 'objToConvertList : ' + objToConvertList );
        System.debug( 'fieldsListToUppercase : ' + fieldsListToUppercase );

        for ( SObject obj : objToConvertList )
        {
            for ( Integer i = 0; i < fieldsListToUppercase.size( ); i++ )
            {
                System.debug( 'field: ' + fieldsListToUppercase.get( i ) );
                System.debug( 'value: ' + obj.get( fieldsListToUppercase.get( i ) ) );
                String field = fieldsListToUppercase.get( i );
                Object value = obj.get( field );
                if ( value != null )
                {
                    String toUpperCaseString = String.valueOf( value ) ;
                    //giovanni spinelli start 21/08/2019 replace à,ò,ù,è,é with a,o,u,e
                    toUpperCaseString = toUpperCaseString.replace( 'à', 'a\'' ).replace( 'ò', 'o\'' ).replace( 'ù', 'u\'' ).replace( 'è', 'e\'' ).replace( 'é', 'e\'' ).replace( 'ì', 'i\'' );
                    //giovanni spinelli end  21/08/2019 replace à,ò,ù,è,é with a,o,u,e
                    System.debug( 'toUpperCaseString: ' + toUpperCaseString );
                    obj.put( field, toUpperCaseString.toUpperCase( ) );
                }
                System.debug( 'after upper case: ' + obj );
            }
        }

    }
    /*
    * Author : Giovanni Spinelli
    * Date : 23/07/2019
    * Description : Method to convert some fields to uppercase if objects are updated.
    *   Input : list object and list of fields to make uppercase
    *   Output : -
    *   Note: 	this method is called from triggers class
    */
    public static void toUppercaseUpdate( list<SObject> newObjList, list<SObject> oldObjlist, List<String> fieldsListToUppercase )
    {
        try
        {
            System.debug( 'fieldsListToUppercase OB_Utility: ' + fieldsListToUppercase );
            for ( Integer i = 0; i < newObjList.size( ); i++ )
            {
                SObject temp_obj_new = newObjList[ i ];
                SObject temp_obj_old = oldObjlist[ i ];
                System.debug( 'fieldsListToUppercase.size(): ' + fieldsListToUppercase.size( ) );
                for ( Integer j = 0; j < fieldsListToUppercase.size( ); j++ )
                {
                    System.debug( 'index j: ' + j );
                    String field_tmp = '';
                    if ( fieldsListToUppercase.get( j ) != null )
                    {
                        field_tmp = fieldsListToUppercase.get( j );
                        System.debug( 'field_tmp: ' + field_tmp );
                        System.debug( 'temp_obj_new.get(field_tmp): ' + temp_obj_new.get( field_tmp ) );
                        System.debug( 'temp_obj_old.get(field_tmp): ' + temp_obj_old.get( field_tmp ) );

                        String newValue = String.valueOf( temp_obj_new.get( field_tmp ) );
                        String oldValue = String.valueOf( temp_obj_old.get( field_tmp ) );
                        String difference = '';
                        if ( oldValue != null && newValue != null )
                        {
                            difference = oldValue.difference( newValue );
                        }
                        System.debug( 'difference: ' + difference );

                        if ( temp_obj_new.get( field_tmp ) != null && ( temp_obj_new.get( field_tmp ) != temp_obj_old.get( field_tmp ) || difference.length( ) > 0 ) )
                        {
                            System.debug( 'into if' );
                            System.debug( 'field_tmp to uppercase: ' + field_tmp );
                            Object value = temp_obj_new.get( field_tmp );
                            String toUpperCaseString = String.valueOf( value ) ;
                            //giovanni spinelli start 21/08/2019 replace à,ò,ù,è,é with a,o,u,e
                            toUpperCaseString = toUpperCaseString.replace( 'à', 'a\'' ).replace( 'ò', 'o\'' ).replace( 'ù', 'u\'' ).replace( 'è', 'e\'' ).replace( 'é', 'e\'' ).replace( 'ì', 'i\'' );
                            //giovanni spinelli end  21/08/2019 replace à,ò,ù,è,é with a,o,u,e
                            System.debug( 'toUpperCaseString: ' + toUpperCaseString );
                            temp_obj_new.put( field_tmp, toUpperCaseString.toUpperCase( ) );

                        }
                    }
                }
            }
        } catch ( Exception ecc )
        {
            System.debug( logginglevel.ERROR, 'Generic Error ob_utility: ' + ecc.getMessage( ) + ' at line: ' + ecc.getLineNumber( ) + ' stack trace: ' + ecc.getStackTraceString( ) );
        }
    }


    /*****************************************************************
    Purpose: Method to insert Log Request
    Parameters: Map<String,String> sourceMap with the fields related to the Log Request to create
    Returns: OB_LogRequest__c logRequest

    History 
    --------
    VERSION AUTHOR 				DATE 		DETAIL 		Description
    1.0 	Salvatore Pianura 	03/05/2019 	Created 	CSR: 
    *****************************************************************/
    public static OB_LogRequest__c insertLogRequest( Map<String, String> sourceMap )
    {
        system.debug( 'sourceMap ' + sourceMap );
        String requestType = sourceMap.get( 'OB_MaintenanceType__c' );
        system.debug( 'requestType ' + requestType );
        OB_LogRequest__c logRequest = new OB_LogRequest__c( );
        try
        {
            if ( requestType == OB_UtilityConstants.ANAGRAFICA )
            {
                Id rtAnagrafica = Schema.SObjectType.OB_LogRequest__c.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.ANAGRAFICART ).getRecordTypeId( );
                logRequest.OB_AccountId__c = sourceMap.get( 'OB_AccountId__c' );
                logRequest.OB_ServicePointId__c = sourceMap.get( 'OB_ServicePointId__c' );
                logRequest.OB_ReducedOldData__c = sourceMap.get( 'OB_ReducedOldData__c' );
                logRequest.OB_ReducedNewData__c = sourceMap.get( 'OB_ReducedNewData__c' );
                logRequest.OB_ChangeCompanyData__c = Boolean.valueOf( sourceMap.get( 'OB_ChangeCompanyData__c' ) );
                logRequest.OB_ChangeLegalForm__c = Boolean.valueOf( sourceMap.get( 'OB_ChangeLegalForm__c' ) );
                logRequest.OB_ChangeLegalRepresentative__c = Boolean.valueOf( sourceMap.get( 'OB_ChangeLegalRepresentative__c' ) );
                logRequest.OB_ChangeMerchantName__c = Boolean.valueOf( sourceMap.get( 'OB_ChangeMerchantName__c' ) );
                logRequest.OB_ChangeServicePointData__c = Boolean.valueOf( sourceMap.get( 'OB_ChangeServicePointData__c' ) );
                logRequest.OB_NewLegalRepresentative__c = Boolean.valueOf( sourceMap.get( 'OB_NewLegalRepresentative__c' ) );
                // NEXI-232 Michal Targiel, <michal.targiel@accenture.com>, 25/07/2019 START
                logRequest.OB_PO118_MOTO__c = sourceMap.get( OB_UtilityConstants.OB_PO118_MOTO ) != null ? Boolean.valueOf( sourceMap.get( OB_UtilityConstants.OB_PO118_MOTO ) ) : false;
                // NEXI-232 Michal Targiel, <michal.targiel@accenture.com>, 25/07/2019 STOP
                logRequest.OB_Change_of_location_referents__c = sourceMap.get( 'OB_Change_of_location_referents__c' ) != null ? Boolean.valueOf( sourceMap.get( 'OB_Change_of_location_referents__c' ) ) : false;//NEXI-187 Grzegorz Banach <grzegorz.banach@accenture.com> 16/07/2019
                logRequest.OB_change_of_reporting_type__c = sourceMap.get( OB_LOGREQUEST_FIELD_CHANGE_OF_REPORTING_TYPE ) != null ? Boolean.valueOf( sourceMap.get( OB_LOGREQUEST_FIELD_CHANGE_OF_REPORTING_TYPE ) ) : false;  // NEXI-179 Marta Stempien <marta.stempien@accenture.com> 15/07/2019
                logRequest.OB_CAB__c = sourceMap.get( 'OB_CAB__c' );
                logRequest.OB_ABI__c = sourceMap.get( 'OB_ABI__c' );
                logRequest.OB_MaintenanceType__c = sourceMap.get( 'OB_MaintenanceType__c' );
                logRequest.OB_Status__c = sourceMap.get( 'OB_Status__c' );
                logRequest.OB_SIAToBeApproved__c = Boolean.valueOf( sourceMap.get( 'OB_SIAToBeApproved__c' ) );
                logRequest.RecordTypeId = rtAnagrafica;
                logRequest.OB_Change_of_data_of_beneficial_owners__c = sourceMap.get( 'OB_Change_of_data_of_beneficial_owners__c' ) != null ? Boolean.valueOf( sourceMap.get( 'OB_Change_of_data_of_beneficial_owners__c' ) ) : false;//NEXI-60 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 13/06/2019
                logRequest.OB_Settlement_Procedure__c = sourceMap.get( OB_UtilityConstants.SETTLEMENT_PROCEDURE_API_NAME ) != null ? Boolean.valueOf( sourceMap.get( OB_UtilityConstants.SETTLEMENT_PROCEDURE_API_NAME ) ) : false; // NEXI-180 Wojciech Szuba <wojciech.szuba@accenture.com> 12/07/2019
                // NEXI-83 Marta Stempien <marta.stempien@accenture.com> 24/06/2019 Start
                // NEXI-261 Marta Stempien <marta.stempien@accenture.com 07/08/2019 Start
                // Start antonio.vatrano f2wave2-112 10/07/2019
                logRequest.OB_isNotIntegrated__c = sourceMap.get( 'OB_isNotIntegrated__c' ) != null ? Boolean.valueOf( sourceMap.get( 'OB_isNotIntegrated__c' ) ) : false;
                // End antonio.vatrano f2wave2-112 10/07/2019
                // NEXI-83 Marta Stempien <marta.stempien@accenture.com> 24/06/2019 Start
                logRequest.OB_StartApprovalProcess__c = sourceMap.get( 'OB_StartApprovalProcess__c' ) != null ? Boolean.valueOf( sourceMap.get( 'OB_StartApprovalProcess__c' ) ) : false;
                logRequest.OB_isGambling__c = sourceMap.get( 'OB_isGambling__c' ) != null ? Boolean.valueOf( sourceMap.get( 'OB_isGambling__c' ) ) : false;
                logRequest.OB_PO118_eCommerce__c = sourceMap.get( 'OB_PO118_eCommerce__c' ) != null ? Boolean.valueOf( sourceMap.get( 'OB_PO118_eCommerce__c' ) ) : false;
                logRequest.OB_PEP__c = sourceMap.get( 'OB_PEP__c' ) != null ? Boolean.valueOf( sourceMap.get( 'OB_PEP__c' ) ) : false; //NEXI-287 Adrian Dlugolecki <adrian.dlugolecki@accenture.com> 30/08/2019
                // NEXI-83 Marta Stempien <marta.stempien@accenture.com> 24/06/2019 Stop
                // NEXI-261 Marta Stempien <marta.stempien@accenture.com> 07/08/2019 Stop
                // NEXI-295 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 03/09/2019 START
                logRequest.OB_Fiduciarie__c = sourceMap.get( 'OB_Fiduciarie__c' ) != null ? Boolean.valueOf( sourceMap.get( 'OB_Fiduciarie__c' ) ) : false;
                logRequest.OB_Moneytransfer__c = sourceMap.get( 'OB_Moneytransfer__c' ) != null ? Boolean.valueOf( sourceMap.get( 'OB_Moneytransfer__c' ) ) : false;
                // NEXI-295 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 03/09/2019 STOP
                // NEXI-325 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 12/09/2019 START
                logRequest.OB_Onlus__c = sourceMap.get( 'OB_Onlus__c' ) != null ? Boolean.valueOf( sourceMap.get( 'OB_Onlus__c' ) ) : false;
                logRequest.OB_Trust__c = sourceMap.get( 'OB_Trust__c' ) != null ? Boolean.valueOf( sourceMap.get( 'OB_Trust__c' ) ) : false;
                // NEXI-325 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 12/09/2019 STOP

            }
            if ( requestType == OB_UtilityConstants.CONSISTENZA )
            {
                //START--- Simone Misani F2WAVE2-66-18 08/07/2019
                Boolean confTech = OB_Maintenance_Consistenza_LogRequest_CC.compatibilityTechnicalConfigurator( sourceMap.get( 'OB_OrderId__c' ) );
                System.debug( 'utility congtech: ' + confTech );
                Id rtConsistenza;
                if ( !confTech )
                {
                    rtConsistenza = Schema.SObjectType.OB_LogRequest__c.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.CONSISTENZART ).getRecordTypeId( );
                }
                else
                {
                    rtConsistenza = Schema.SObjectType.OB_LogRequest__c.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.CONFIGURATORETECNICORT ).getRecordTypeId( );
                }
                //END--- Simone Misani F2WAVE2-66-18 08/07/2019
                logRequest.OB_AccountId__c = sourceMap.get( 'OB_AccountId__c' );
                logRequest.OB_ServicePointId__c = sourceMap.get( 'OB_ServicePointId__c' );
                logRequest.OB_OrderId__c = sourceMap.get( 'OB_OrderId__c' );
                logRequest.OB_ABI__c = sourceMap.get( 'OB_ABI__c' );
                logRequest.OB_CAB__c = sourceMap.get( 'OB_CAB__c' );
                if ( confTech )
                {
                    logRequest.OB_MaintenanceType__c = OB_UtilityConstants.CONFIGURATORETECNICO;

                }
                else
                {
                    logRequest.OB_MaintenanceType__c = sourceMap.get( 'OB_MaintenanceType__c' );

                }
                logRequest.OB_Status__c = sourceMap.get( 'OB_Status__c' );//Simone Misani 26/08/2019 WN-269; 
                logRequest.OB_HasAcquiring__c = Boolean.valueOf( sourceMap.get( 'OB_HasAcquiring__c' ) );
                logRequest.OB_HasPos__c = Boolean.valueOf( sourceMap.get( 'OB_HasPos__c' ) );
                logRequest.OB_HasVas__c = Boolean.valueOf( sourceMap.get( 'OB_HasVas__c' ) );
                logRequest.OB_OrderId__c = sourceMap.get( 'OB_OrderId__c' );
                logRequest.RecordTypeId = rtConsistenza;
                logRequest.OB_Mixed_Maintenance__c = sourceMap.get( 'OB_Mixed_Maintenance__c' ) != null ? Boolean.valueOf( sourceMap.get( 'OB_Mixed_Maintenance__c' ) ) : false;//Simone Misani 20/07/2019 fix Tracking
                logRequest.OB_Response_Track__c = '';//Simone Misani 22/07/2019 fix Tracking
                logRequest.OB_Error_Tracking__c = '';//Simone Misani 22/07/2019 fix Tracking
                //elena.preteni  28/06/2019 added field to logic descoping consistenza
                logRequest.OB_isNotIntegrated__c = Boolean.valueOf( sourceMap.get( 'OB_isNotIntegrated__c' ) );
                //elena.preteni  28/06/2019 added field to logic descoping consistenza
                //francesca.ribezzi 01/07/19 - F2WAVEF2-53 - adding OB_SIAToBeApproved__c
                system.debug( 'sourceMap.get OB_SIAToBeApproved__c?? ' + sourceMap.get( 'OB_SIAToBeApproved__c' ) );
                system.debug( 'sourceMap.get OB_Status__c?? ' + sourceMap.get( 'OB_Status__c' ) );
                logRequest.OB_SIAToBeApproved__c = sourceMap.get( 'OB_SIAToBeApproved__c' ) == null ? false : Boolean.valueOf( sourceMap.get( 'OB_SIAToBeApproved__c' ) );
            }
            if ( requestType == OB_UtilityConstants.PRICING )
            {
                Id rtPricing = Schema.SObjectType.OB_LogRequest__c.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.PRICINGRT ).getRecordTypeId( );
                logRequest.OB_Status__c = sourceMap.get( 'OB_Status__c' );
                logRequest.OB_AccountId__c = sourceMap.get( 'OB_AccountId__c' );
                logRequest.OB_ServicePointId__c = sourceMap.get( 'OB_ServicePointId__c' );
                logRequest.OB_OrderId__c = sourceMap.get( 'OB_OrderId__c' );
                logRequest.OB_ABI__c = sourceMap.get( 'OB_ABI__c' );
                logRequest.OB_CAB__c = sourceMap.get( 'OB_CAB__c' );
                logRequest.OB_MaintenanceType__c = sourceMap.get( 'OB_MaintenanceType__c' );
                logRequest.OB_HasAcquiring__c = Boolean.valueOf( sourceMap.get( 'OB_HasAcquiring__c' ) );
                logRequest.OB_HasPos__c = Boolean.valueOf( sourceMap.get( 'OB_HasPos__c' ) );
                logRequest.RecordTypeId = rtPricing;
            }
            if ( requestType == OB_UtilityConstants.CAMBIOCOBA )
            {
                Id rtCambioCoBa = Schema.SObjectType.OB_LogRequest__c.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.CAMBIOCOBART ).getRecordTypeId( );
                logRequest.OB_AccountId__c = sourceMap.get( 'OB_AccountId__c' );
                logRequest.OB_ReducedOldData__c = sourceMap.get( 'OB_ReducedOldData__c' );
                logRequest.OB_ReducedNewData__c = sourceMap.get( 'OB_ReducedNewData__c' );
                logRequest.OB_CAB__c = sourceMap.get( 'OB_CAB__c' );
                logRequest.OB_ABI__c = sourceMap.get( 'OB_ABI__c' );
                logRequest.OB_Status__c = sourceMap.get( 'OB_Status__c' );
                logRequest.OB_MaintenanceType__c = sourceMap.get( 'OB_MaintenanceType__c' );
                logRequest.RecordTypeId = rtCambioCoBa;
            }
            //START francesca.ribezzi 28/06/19 adding requestType for eCommerce - F2WAVE2-51
            if ( requestType == OB_UtilityConstants.CONSISTENZA_ECOMMERCE )
            {
                Id rtConsistenza = Schema.SObjectType.OB_LogRequest__c.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.CONSISTENZART ).getRecordTypeId( );
                logRequest.OB_AccountId__c = sourceMap.get( 'OB_AccountId__c' );
                logRequest.OB_ServicePointId__c = sourceMap.get( 'OB_ServicePointId__c' );
                logRequest.OB_OrderId__c = sourceMap.get( 'OB_OrderId__c' );
                logRequest.OB_ABI__c = sourceMap.get( 'OB_ABI__c' );
                logRequest.OB_CAB__c = sourceMap.get( 'OB_CAB__c' );
                logRequest.OB_MaintenanceType__c = sourceMap.get( 'OB_MaintenanceType__c' );
                logRequest.OB_Status__c = sourceMap.get( 'OB_Status__c' );//Simone Misani 19/09/2019 WN-429
                logRequest.OB_HasAcquiring__c = Boolean.valueOf( sourceMap.get( 'OB_HasAcquiring__c' ) );
                logRequest.OB_HasPos__c = Boolean.valueOf( sourceMap.get( 'OB_HasPos__c' ) );
                logRequest.OB_HasVas__c = Boolean.valueOf( sourceMap.get( 'OB_HasVas__c' ) );
                logRequest.OB_OrderId__c = sourceMap.get( 'OB_OrderId__c' );
                logRequest.RecordTypeId = rtConsistenza;
            }
            //END francesca.ribezzi 28/06/19 adding requestType for eCommerce - F2WAVE2-51

            // <daniele.gandini@ccenture.com> - 02/07/2019 - WN-9 - start
            // START--Simone Misani  set  required field  23/08/2019
            logRequest.OB_RequestDate__c = Date.today( );
            Boolean isPartnerCommunityLogged = OB_Utility.isPartnerCommunity( UserInfo.getUserId( ) );
            if ( isPartnerCommunityLogged )
            {
                logRequest.OB_Requestor__c = OB_UtilityConstants.Banca;
            }        // END--Simone Misani  set  required field  23/08/2019
            // <daniele.gandini@ccenture.com> - 02/07/2019 - WN-9 - stop
            system.debug( 'logRequest ' + logRequest );
            insert logRequest;
        } catch ( Exception ecc )
        {
            System.debug( '[EXCE] OB_Utility.insertLogRequest ' + ecc.getMessage( ) + ' at line: ' + ecc.getLineNumber( ) + ' stack trace: ' + ecc.getStackTraceString( ) );
        }
        return logRequest;
    }

    /*****************************************************************
    Purpose: Method to submit Maintenance Anagrafica
    Parameters: String id of Log Request

    History 
    --------
    VERSION AUTHOR 				DATE 		DETAIL 		Description
    1.0 	Salvatore Pianura 	08/05/2019 	Created 	CSR: 
    *****************************************************************/
    @AuraEnabled
    public static void serializeAnagrafica( String logRequestId )
    {
        List<OB_LogRequest__c> listOfLogRequest = new List<OB_LogRequest__c>( );
        OB_LogRequest__c currentLogRequest = new OB_LogRequest__c( );
        listOfLogRequest =
        [
                SELECT Id,OB_AccountId__c,OB_ReducedNewData__c,OB_ReducedOldData__c,OB_ChangeCompanyData__c,
                        OB_ChangeLegalForm__c,OB_ChangeLegalRepresentative__c,OB_ChangeMerchantName__c,
                        OB_ChangeServicePointData__c,OB_NewLegalRepresentative__c,OB_Status__c,OB_SIAToBeApproved__c
                FROM OB_LogRequest__c
                WHERE Id = :logRequestId
                LIMIT 1
        ];
        if ( !listOfLogRequest.isEmpty( ) )
        {
            currentLogRequest = listOfLogRequest.get( 0 );
            //START - elena.preteni 15/07/2019 WN-89 companyCodes to MIP
            List<ExternalSourceMapping__c> listesm =
            [
                    SELECT ID,OB_Merchant_ID__c,OB_Source__c,OB_CustomerCodeClientCode__c,OB_ServicePointCodeShopCode__c
                    FROM ExternalSourceMapping__c
                    WHERE OB_Merchant_ID__c = :currentLogRequest.OB_AccountId__c
            ];
            system.debug( 'listesm' + listesm );
            //END - elena.preteni 15/07/2019 WN-89 companyCodes to MIP

            if ( !currentLogRequest.OB_SIAToBeApproved__c && currentLogRequest.OB_Status__c == OB_UtilityConstants.LOGREQUEST_STATUS_DRAFT )
            {
                Map<String, Object> mapReducedNewData = ( Map<String, Object> ) JSON.deserializeUntyped( currentLogRequest.OB_ReducedNewData__c );
                List<Object> newlistOfObjs = ( List<Object> ) JSON.deserializeUntyped( JSON.serialize( mapReducedNewData.get( 'obj' ) ) );
                List<Map<String, Object>> newlistOfMaps = new List<Map<String, Object>>( );
                for ( Object obj : newlistOfObjs )
                {
                    newlistOfMaps.add( ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( obj ) ) );
                }
                // START elena.preteni@accenture.com 6/5/19 add callout to submit Stream Maintenance integrazioni Anagrafica
                OB_Maintenance_Serialize_Anagrafica.SerializeWrapperMerchant wrapperMerchant = new OB_Maintenance_Serialize_Anagrafica.SerializeWrapperMerchant( );
                OB_Maintenance_Serialize_Anagrafica.CompanyChanges companyChanges = new OB_Maintenance_Serialize_Anagrafica.CompanyChanges( );
                OB_Maintenance_Serialize_Anagrafica.Address registeredOfficeAddress = new OB_Maintenance_Serialize_Anagrafica.Address( );
                OB_Maintenance_Serialize_Anagrafica.Address administrativeOfficeAddress = new OB_Maintenance_Serialize_Anagrafica.Address( );
                OB_Maintenance_Serialize_Anagrafica.Address residenceAddress = new OB_Maintenance_Serialize_Anagrafica.Address( );
                OB_Maintenance_Serialize_Anagrafica.Phones phone = new OB_Maintenance_Serialize_Anagrafica.Phones( );
                OB_Maintenance_Serialize_Anagrafica.ContactExecutor contact = new OB_Maintenance_Serialize_Anagrafica.ContactExecutor( );
                OB_Maintenance_Serialize_Anagrafica.PersonalDocuments personalDocuments = new OB_Maintenance_Serialize_Anagrafica.PersonalDocuments( );
                wrapperMerchant.requestId = logRequestId;
                // <daniele.gandini@ccenture.com> - 17/07/2019 - WN-98 - start
                List<OB_Maintenance_Serialize_Anagrafica.CompanyCodes> companyCodesList = new List<OB_Maintenance_Serialize_Anagrafica.CompanyCodes>( );
                // <daniele.gandini@ccenture.com> - 17/07/2019 - WN-98 - stop
                for ( Map<String, Object> singlemap : newlistOfMaps )
                {
                    if ( singlemap.containsKey( 'attributes' ) )
                    {
                        Map<String, Object> attributesmap = ( Map<String, Object> ) JSON.deserializeUntyped( JSON.serialize( singlemap.get( 'attributes' ) ) );
                        system.debug( '## attributesmap: ' + attributesmap );
                        //START - elena.preteni 15/07/2019 WN-89 companyCodes to MIP
                        for ( ExternalSourceMapping__c esm : listesm )
                        {
                            OB_Maintenance_Serialize_Anagrafica.CompanyCodes companyCodes = new OB_Maintenance_Serialize_Anagrafica.CompanyCodes( ); // <daniele.gandini@ccenture.com> - 17/07/2019 - WN-98 - moved from above
                            companyCodes.source = esm.OB_Source__c;
                            companyCodes.code = esm.OB_CustomerCodeClientCode__c;
                            companyCodes.pvCode = esm.OB_ServicePointCodeShopCode__c ;
                            System.debug( 'companyCodes: ' + JSON.serialize( companyCodes ) );
                            companyCodesList.add( companyCodes );
                            System.debug( 'companyCodesList: ' + JSON.serialize( companyCodesList ) );
                        }
                        wrapperMerchant.companyCodes.addAll( companyCodesList );
                        System.debug( 'wrapperMerchant: ' + JSON.serialize( wrapperMerchant ) );
                        //END - elena.preteni 15/07/2019 WN-89 companyCodes to MIP
                        if ( attributesmap.containsKey( 'type' ) && attributesmap.get( 'type' ) == 'Contact' )
                        {
                            wrapperMerchant.companyChanges.registeredOfficeAddress = registeredOfficeAddress;
                            wrapperMerchant.companyChanges.administrativeOfficeAddress = administrativeOfficeAddress;
                            wrapperMerchant.companyChanges.phones.add( phone );
                            wrapperMerchant.companyChanges = companyChanges;
                            contact.action = 'Add';
                            contact.role = 'EXECUTOR';
                            contact.firstName = singlemap.containsKey( 'FirstName' ) ? ( String ) singlemap.get( 'FirstName' ) : null;
                            contact.lastName = singlemap.containsKey( 'LastName' ) ? ( String ) singlemap.get( 'LastName' ) : null;
                            contact.birthDate = singlemap.containsKey( 'OB_Birth_Date__c' ) ? convertStringToDate( ( String ) singlemap.get( 'OB_Birth_Date__c' ) ) : null; //NEXI-156 Wojciech Kucharel <wojciech.kucharek@accenture.com>
                            contact.birthCity = singlemap.containsKey( 'OB_Birth_City__c' ) ? ( String ) singlemap.get( 'OB_Birth_City__c' ) : null;
                            contact.birthProvince = singlemap.containsKey( 'OB_Birth_State__c' ) ? ( String ) singlemap.get( 'OB_Birth_State__c' ) : null;
                            contact.birthCountry = singlemap.containsKey( 'OB_Country_Birth__c' ) ? ( String ) singlemap.get( 'OB_Country_Birth__c' ) : null;
                            contact.fiscalCode = singlemap.containsKey( 'OB_Fiscal_Code__c' ) ? ( String ) singlemap.get( 'OB_Fiscal_Code__c' ) : null;
                            contact.gender = singlemap.containsKey( 'OB_Sex__c' ) ? ( String ) singlemap.get( 'OB_Sex__c' ) : null;
                            contact.email = singlemap.containsKey( 'Email' ) ? ( String ) singlemap.get( 'Email' ) : null;
                            contact.citizenship = singlemap.containsKey( 'OB_Citizenship__c' ) ? ( String ) singlemap.get( 'OB_Citizenship__c' ) : null;
                            contact.flagPEP = singlemap.containsKey( 'OB_PEP__c' ) ? ( Boolean ) singlemap.get( 'OB_PEP__c' ) : null;
                            contact.firstName = singlemap.containsKey( 'FirstName' ) ? ( String ) singlemap.get( 'FirstName' ) : null;
                            //START - elena.preteni 26/07/2019 Mobile only if telephone changed
                            phone.modality = singlemap.containsKey( 'MobilePhone' ) ? 'MOBILE' : null;
                            //END - elena.preteni 26/07/2019 Mobile only if telephone changed
                            phone.phoneNumber = singlemap.containsKey( 'MobilePhone' ) ? ( String ) singlemap.get( 'MobilePhone' ) : null;
                            contact.phones = phone;
                            residenceAddress.street = singlemap.containsKey( 'OB_Address_Street__c' ) ? ( String ) singlemap.get( 'OB_Address_Street__c' ) : null;
                            residenceAddress.civicNumber = singlemap.containsKey( 'OB_Address_Street_Number__c' ) ? ( String ) singlemap.get( 'OB_Address_Street_Number__c' ) : null;
                            residenceAddress.postalCode = singlemap.containsKey( 'OB_Address_PostalCode__c' ) ? ( String ) singlemap.get( 'OB_Address_PostalCode__c' ) : null;
                            residenceAddress.city = singlemap.containsKey( 'OB_Address_City__c' ) ? ( String ) singlemap.get( 'OB_Address_City__c' ) : null;
                            residenceAddress.province = singlemap.containsKey( 'OB_Address_State__c' ) ? ( String ) singlemap.get( 'OB_Address_State__c' ) : null;
                            residenceAddress.country = singlemap.containsKey( 'OB_Address_Country__c' ) ? ( String ) singlemap.get( 'OB_Address_Country__c' ) : null;
                            contact.ResidenceAddress = residenceAddress;
                            personalDocuments.documentType = singlemap.containsKey( 'OB_Document_Type__c' ) ? ( String ) singlemap.get( 'OB_Document_Type__c' ) : null;
                            personalDocuments.documentNumber = singlemap.containsKey( 'OB_Document_Number__c' ) ? ( String ) singlemap.get( 'OB_Document_Number__c' ) : null;
                            personalDocuments.releaseDate = singlemap.containsKey( 'OB_Document_Release_Date__c' ) ? convertStringToDate( ( String ) singlemap.get( 'OB_Document_Release_Date__c' ) ) : null; //NEXI-156 Wojciech Kucharel <wojciech.kucharek@accenture.com>
                            personalDocuments.expirationDate = singlemap.containsKey( 'OB_Document_Expiration_Date__c' ) ? convertStringToDate( ( String ) singlemap.get( 'OB_Document_Expiration_Date__c' ) ) : null; //NEXI-156 Wojciech Kucharel <wojciech.kucharek@accenture.com>
                            personalDocuments.releaseCity = singlemap.containsKey( 'OB_Document_Release_City__c' ) ? ( String ) singlemap.get( 'OB_Document_Release_City__c' ) : null;
                            personalDocuments.releaseProvince = singlemap.containsKey( 'OB_Document_Release_State__c' ) ? ( String ) singlemap.get( 'OB_Document_Release_State__c' ) : null;
                            personalDocuments.releaseCountry = singlemap.containsKey( 'OB_Document_Release_Country__c' ) ? ( String ) singlemap.get( 'OB_Document_Release_Country__c' ) : null;
                            contact.PersonalDocument = personalDocuments;
                            wrapperMerchant.companyChanges.Contacts.add( contact );
                            system.debug( 'OB_Maintenance_Serialize_Anagrafica.serializeObjectMerchant(wrapperMErchant) ' + OB_Maintenance_Serialize_Anagrafica.serializeObjectMerchant( wrapperMErchant ) );
                        }
                        if ( attributesmap.containsKey( 'type' ) && attributesmap.get( 'type' ) == 'Account' )
                        {
                            companyChanges.name = singlemap.containsKey( 'Name' ) ? ( String ) singlemap.get( 'Name' ) : null;
                            companyChanges.legalForm = singlemap.containsKey( 'OB_Legal_Form__c' ) ? ( String ) singlemap.get( 'OB_Legal_Form_Code__c' ) : null;//elena.preteni WN-155 code legal form
                            companyChanges.vatNumber = singlemap.containsKey( 'NE__VAT__c' ) ? ( String ) singlemap.get( 'NE__VAT__c' ) : null;
                            companyChanges.taxCode = singlemap.containsKey( 'NE__Fiscal_code__c' ) ? ( String ) singlemap.get( 'NE__Fiscal_code__c' ) : null;
                            companyChanges.email = singlemap.containsKey( 'NE__E_mail__c' ) ? ( String ) singlemap.get( 'NE__E_mail__c' ) : null;
                            companyChanges.commoditySectorCodeSAE = singlemap.containsKey( 'OB_SAE_Code__c' ) ? ( String ) singlemap.get( 'OB_SAE_Code__c' ) : null;
                            companyChanges.atecoCode = singlemap.containsKey( 'OB_ATECO__c' ) ? ( String ) singlemap.get( 'OB_ATECO__c' ) : null;
                            companyChanges.employeesNumber = singlemap.containsKey( 'OB_Employees_Number__c' ) ? ( String ) singlemap.get( 'OB_Employees_Number__c' ) : null;
                            companyChanges.annualRevenue = singlemap.containsKey( 'OB_Annual_Revenue__c' ) ? ( String ) singlemap.get( 'OB_Annual_Revenue__c' ) : null;
                            companyChanges.companyRegistrationNumber = singlemap.containsKey( 'OB_CCIAA__c' ) ? ( String ) singlemap.get( 'OB_CCIAA__c' ) : null;
                            companyChanges.provinceChamberOfCommerce = singlemap.containsKey( 'OB_CCIAA_Province__c' ) ? ( String ) singlemap.get( 'OB_CCIAA_Province__c' ) : null;
                            wrapperMerchant.companyChanges = companyChanges;
                            //START - elena.preteni WN-156,WN-160 indirizzo completo
                            if ( singlemap.containsKey( 'OB_Legal_Address_State__c' ) != null )
                            {
                                registeredOfficeAddress.street = singlemap.containsKey( 'OB_Legal_Address_Street__c' ) ? ( String ) singlemap.get( 'OB_Legal_Address_Street__c' ) : null;
                                registeredOfficeAddress.civicNumber = singlemap.containsKey( 'OB_Legal_Address_Street_Number__c' ) ? ( String ) singlemap.get( 'OB_Legal_Address_Street_Number__c' ) : null;
                                registeredOfficeAddress.postalCode = singlemap.containsKey( 'OB_Legal_Address_ZIP__c' ) ? ( String ) singlemap.get( 'OB_Legal_Address_ZIP__c' ) : null;
                                registeredOfficeAddress.city = singlemap.containsKey( 'OB_Legal_Address_City__c' ) ? ( String ) singlemap.get( 'OB_Legal_Address_City__c' ) : null;
                                //START - ELENNA.PRETENI WN-156
                                registeredOfficeAddress.province = singlemap.containsKey( 'OB_Legal_Address_State_Code__c' ) ? ( String ) singlemap.get( 'OB_Legal_Address_State_Code__c' ) : null;
                                //END - ELENNA.PRETENI WN-156
                                registeredOfficeAddress.country = 'ITA';
                            }
                            //END - elena.preteni WN-156 ,WN-160 indirizzo completo
                            wrapperMerchant.companyChanges.registeredOfficeAddress = registeredOfficeAddress;
                            //START - elena.preteni WN-156,WN-160 indirizzo completo
                            if ( singlemap.containsKey( 'OB_Administrative_Office_State__c' ) != null )
                            {
                                administrativeOfficeAddress.street = singlemap.containsKey( 'OB_Administrative_Office_Street__c' ) ? ( String ) singlemap.get( 'OB_Administrative_Office_Street__c' ) : null;
                                administrativeOfficeAddress.civicNumber = singlemap.containsKey( 'OB_Administrative_Office_Street_number__c' ) ? ( String ) singlemap.get( 'OB_Administrative_Office_Street_number__c' ) : null;
                                administrativeOfficeAddress.postalCode = singlemap.containsKey( 'OB_Administrative_Office_ZIP__c' ) ? ( String ) singlemap.get( 'OB_Administrative_Office_ZIP__c' ) : null;
                                administrativeOfficeAddress.city = singlemap.containsKey( 'OB_Administrative_Office_City__c' ) ? ( String ) singlemap.get( 'OB_Administrative_Office_City__c' ) : null;
                                //START - ELENNA.PRETENI WN-156
                                administrativeOfficeAddress.province = singlemap.containsKey( 'OB_Administrative_Office_State_Code__c' ) ? ( String ) singlemap.get( 'OB_Administrative_Office_State_Code__c' ) : null;
                                //END - ELENNA.PRETENI WN-156
                                administrativeOfficeAddress.country = 'ITA';
                            }
                            //END - elena.preteni WN-156,WN-160 indirizzo completo
                            wrapperMerchant.companyChanges.administrativeOfficeAddress = administrativeOfficeAddress;
                            //START - elena.preteni 01/08/2019 Mobile only if telephone changed
                            phone.modality = singlemap.containsKey( 'Phone' ) ? 'MOBILE' : null;
                            phone.phoneNumber = singlemap.containsKey( 'Phone' ) ? ( String ) singlemap.get( 'Phone' ) : null;
                            //END - elena.preteni 01/08/2019 Mobile only if telephone changed
                            wrapperMerchant.companyChanges.phones.add( phone );
                            system.debug( 'OB_Maintenance_Serialize_Anagrafica.serializeObjectMerchant(wrapperMErchant) ' + OB_Maintenance_Serialize_Anagrafica.serializeObjectMerchant( wrapperMErchant ) );
                        }
                    }
                }
                // <daniele.gandini@ccenture.com> - 03/07/2019 - WN-9 - start
                if ( !Test.isRunningTest( ) )
                {
                    OB_UtilityCallingServices.callService( 'callout:OB_callService/api/merchants/' + currentLogRequest.OB_AccountId__c, 'POST', OB_Maintenance_Serialize_Anagrafica.serializeObjectMerchant( wrapperMerchant ) );
                    //END elena.preteni@accenture.com 6/5/19 add callout to submit Stream Maintenance integrazioni Anagrafica
                }
                // <daniele.gandini@ccenture.com> - 03/07/2019 - WN-9 - stop

            }
            else
            {
                System.debug( '@SIA to be approved' );
            }
        }
    }
    /*
		* Author : Giovanni Spinelli
		* Date : 17/04/2019
		* Description : Method that compose a dynamic query on asset object, based on data received in input.
		*   Input : searchWrapper Wrapper = data inserted into te UI  , used as key into te filter.
		*   Output : boid :  the number of different accountid
		*   Note: 	this method was in ob_mainteanceSearch_controller but now this class is 'with sharing' and
					for this method we need a without sharing class
		*/
    //Start antonio.vatrano rif2-103 21/05/2019
    public static void searchOnAsset( OB_MaintenanceSearch_Controller.searchWrapper Wrapper, OB_MaintenanceSearch_Controller.SearchResultWrapper result )
    {
        OB_maintenance_Helper.bankOwnerWrapper bankOwner = OB_maintenance_Helper.retriveBankOwner( null );
        System.debug( 'BEFORE IF ASSET' );
        if ( !bankOwner.errorOccurred )
        {
            System.debug( 'BEFORE ASSET QUERY' );
            //Andrea Saracini 20/03/2019 Manage RAC SIa: add NE__Bundle__c field 17/04/2019 R1F2-21 bis add OB_RAC_SIA__c field
	   
			/* History : MORITTU ANDREA 26-Aug-2019 - UX.194 - Adding new searchable input
				ADDED ACCOUNT NAME FOR SEARCH MAINTENANCE
			*/
            string soql = 'select id, AccountId, Account.Name, OB_RAC_SIA__c, NE__Service_Point__c ,OB_TermId__c,OB_Model__c,OB_ModelDescription__c,OB_GT__C,NE__Status__c,OwnerId, NE__Bundle__c, NE__Bundle__r.Name, NE__Bundle__r.NE__Start_Date__c,NE__Bundle__r.LastModifiedDate,' +
                    ' NE__Order_Config__r.OB_MCCL2__c ,  NE__Order_Config__r.OB_ShopSign__c ' +
                    ' from ASSET ' +
                    ' WHERE Account.OB_Bank_owner__c = \'' + bankOwner.bankOwnerid + '\' AND ';
					
            //START MORITTU ANDREA 26-Aug-2019 - UX.194 - Adding new searchable input
            soql +=  String.isblank(Wrapper.businessAccountName )? '' :' Account.Name LIKE \'%' + Wrapper.businessAccountName   + '%\'' + ' AND ';
            soql +=  String.isBlank(wrapper.selectedMerchantId) ? ''	:	'AccountId = \'' + wrapper.selectedMerchantId + '\' AND ';
            //END MORITTU ANDREA 26-Aug-2019 - UX.194 - Adding new searchable input														 
  
			string contactABI = OB_MaintenanceSearch_Controller.retriveContactABI( );
            soql += String.isblank( contactABI ) ? '' : ( '  OB_ProposerABI__r.OB_ABI__c =  \'' + contactABI + '\' AND ' ); //--> COMMUNITY NON COMMUNITY??
            soql += String.isblank( Wrapper.MoneticaCustomerCode ) ? '' : ' OB_CompanyCode__c =  \'' + wrapper.MoneticaCustomerCode + '\' AND ';
            soql += String.isblank( Wrapper.MoneticaEstablishmentCode ) ? '' : ' OB_ShopCode__c =  \'' + wrapper.MoneticaEstablishmentCode + '\' AND ';
            //giovanni spinelli - 08/01/2019  - query on assetItemAttribute if sia code is not null
            soql += String.isblank( Wrapper.SiaEstablishment ) && String.isblank( Wrapper.SIACode ) ? '' : ' OB_RAC_SIA__c LIKE \'' + String.escapeSingleQuotes( wrapper.SIACode + Wrapper.SiaEstablishment ) + '%\' AND '; //Andrea Saracini 17/04/2019 R1F2-21 bis
            //giovanni spinelli - 09/01/2019  - query on assetItemAttribute if sia Establishment code is not null
            soql += String.isblank( Wrapper.TerminalId ) ? '' : ' OB_TermId__c =  \'' + Wrapper.TerminalId + '\' AND ';
            //START Andrea Saracini 18/03/2019 Card No Present: add url and app attribute
            soql += String.isblank( Wrapper.url ) ? '' : ' Id IN (SELECT NE__Asset__c FROM NE__AssetItemAttribute__c WHERE name = \'' + 'URL' + '\' AND NE__Value__c LIKE ' + '\'%' + String.escapeSingleQuotes( Wrapper.url ) + '%\' )  AND ';//Andrea Saracini 17/04/2019 R1F2-21 bis
            soql += String.isblank( Wrapper.app ) ? '' : ' Id IN (SELECT NE__Asset__c FROM NE__AssetItemAttribute__c WHERE name = \'' + 'APP' + '\' AND NE__Value__c = \'' + Wrapper.app + '\' )  AND ';
            //STOP Andrea Saracini 18/03/2019 Card No Present
            soql = soql.removeEndIgnoreCase( 'AND ' );
            System.debug( 'ASSET QUERY: ' + soql );
            System.debug( logginglevel.info, 'OB_MaintenanceSearch_Controller - searchByOtherKeys  - soql: ' + soql );
            list<Asset> listOfAsset = Database.query( soql );
            System.debug( 'LIST OF ASSET: ' + listOfAsset );

			//START MORITTU ANDREA 26-Aug-2019 - UX.194 - Adding new searchable input
			Set<String> totalAccountId = null;
			//END MORITTU ANDREA 26-Aug-2019 - UX.194 - Adding new searchable input																 

			if ( listOfAsset != null && !listOfAsset.isEmpty( ) )
            {
                //START Andrea Saracini 20/03/2019 Manage RAC SIA
                if ( !String.isblank( Wrapper.SIACode ) && OB_MaintenanceSearch_Controller.countBundleId( listOfAsset ) > 1 )
                {
                    result.errorMessage = Label.OB_MAINTENANCE_SIATOMANYBUNDLE;
                    result.outcome = LAbel.OB_MAINTENANCE_ERROR;
                }
                else if ( !String.isblank( Wrapper.SIACode ) && OB_MaintenanceSearch_Controller.countAccountid( listOfAsset ) > 1 )
                {
                    result.errorMessage = Label.OB_MAINTENANCE_SIATOMANYACCOUNT;
                    result.outcome = LAbel.OB_MAINTENANCE_ERROR;
                }
                //STOP Andrea Saracini 18/03/2019 Manage RAC RIC
				// ANDREA MORITTU START 04-Sep-2019 - UX.194								 
                else if ( OB_MaintenanceSearch_Controller.countAccountid( listOfAsset ) > 1 )
                {
                    totalAccountId = new Set<String>();
					for(Asset singleAsset : listOfAsset ) {
						(result.accountIds).add(singleAsset.AccountId);
					}
                }
				// ANDREA MORITTU END 04-Sep-2019 - UX.194
                else
                {
                    if ( listOfAsset.size( ) == 1 )
                    {
                        //STORE ASSET
                        result.selectedAsset = listOfAsset.get( 0 );
                        result.selectedServicePointAsset = listOfAsset.get( 0 ).NE__Service_Point__c;
                    }
                    else
                    {
                        //SAVE SERVICE POINT ID FROM MULTIPLE ASSETS IN A LIST
                        List<String> idListAsset = new List<String>( );
                        for ( Asset asset : listOfAsset )
                        {
                            idListAsset.add( String.valueOf( asset.NE__Service_Point__c ) );
                        }
                        result.selectServicePointListId = idListAsset;
                        System.debug( ' LIST OF ASSET RESULT: ' + result.selectServicePointListId );
                    }
                    result.selectedMerchantAsset = listOfAsset.get( 0 ).AccountId;
                    // retrive the account information , all the account is the same
                    // retriveAccountInformation(result,listOfAsset.get(0).accountid,Wrapper.TerminalId );
                }
            }
            else
            {
                // nothing found
                result.errorMessage = LAbel.OB_MAINTENANCE_NOACCOUNTFOUND;
                result.outcome = LAbel.OB_MAINTENANCE_ERROR;
            }
        }
        else
        {
            result.errorMessage = bankOwner.errorMessage;
            result.outcome = Label.OB_MAINTENANCE_ERROR;
        }
    }
    //END antonio.vatrano rif2-103 21/05/2019

    /*****************************************************************
	Purpose: Method to check if the logged user is parner community
	Returns: Boolean

	History 
	--------
	VERSION AUTHOR 				DATE 		DETAIL 		Description
	1.0 	Daniele Gandini 	02/07/2019 	Created 	CSR: 
	*****************************************************************/

    public static Boolean isPartnerCommunity( String userId )
    {

        Boolean isPartnerCommunity = false;
        list<User> listOfUsers =
        [
                SELECT Id, Profile.UserLicense.Name
                FROM User
                WHERE Id = :userId
                LIMIT 1
        ];
        if ( !listOfUsers.isEmpty( ) )
        {
            User user = listOfUsers.get( 0 );
            String license = user.Profile.UserLicense.Name;
            System.debug( 'license:  ' + license );

            String licenseAllowed;
            OB_ConfigurationInformation__mdt configurationInformation = new OB_ConfigurationInformation__mdt( );
            OB_ConfigurationInformation__mdt[] listOfConfigurationInformations =
            [
                    SELECT Id,
                            MasterLabel,
                            Label,
                            QualifiedApiName,
                            OB_String_Value__c
                    FROM OB_ConfigurationInformation__mdt
                    WHERE QualifiedApiName = :OB_UtilityConstants.PARTNER_COMMUNITY_LICENSE
            ];
            if ( !listOfConfigurationInformations.isEmpty( ) )
            {
                configurationInformation = listOfConfigurationInformations.get( 0 );
                licenseAllowed = configurationInformation.OB_String_Value__c;
                System.debug( '@licenseAllowed : ' + licenseAllowed );
                isPartnerCommunity = licenseAllowed.contains( license );
                System.debug( '@isPartnerCommunity : ' + isPartnerCommunity );
            }
        }
        return isPartnerCommunity;
    }
    //END antonio.vatrano rif2-103 21/05/2019

    /*****************************************************************
    Purpose: Method convert date in format String to format Date
    Returns: Date

    History
    --------
    VERSION AUTHOR 				DATE 		DETAIL 		Description
    1.0 	Wojciech Kucharek 	04/07/2019 	Created     NEXI-156
    *****************************************************************/
    private static Date convertStringToDate( String dateInString )
    {
        Date convertDate = null;
        if ( String.isNotBlank( dateInString ) )
        {
            String[] strDate = dateInString.split( '-' );
            Integer myIntDate = integer.valueOf( strDate[ 2 ] );
            Integer myIntMonth = integer.valueOf( strDate[ 1 ] );
            Integer myIntYear = integer.valueOf( strDate[ 0 ] );
            convertDate = Date.newInstance( myIntYear, myIntMonth, myIntDate );
        }
        return convertDate;
    }

    /*****************************************************************
    Purpose: Util method that returns true if boolean is true, if boolean is either null or false it return false
    Parameters: Boolean inBooleanVariable
    Returns: Boolean

    History
    --------
    VERSION       AUTHOR 		    DATE 		    DETAIL 		Description
    1.0 	    Marta Stempien 	    30/08/2019 	    Created     NEXI-287
    *****************************************************************/
    public static Boolean isBooleanTrue( Boolean inBooleanVariable )
    {
        Boolean isBooleanVariableTrue = inBooleanVariable != null ? inBooleanVariable : false;
        return isBooleanVariableTrue;
    }

    /*****************************************************************
    Purpose: Method checks if order header meets entry criteria of any step of approval process
    Parameters: NE__Order_Header__c inOrderHeader
    Returns: Boolean

    History
    --------
    VERSION       AUTHOR 		    DATE 		    DETAIL 		Description
    1.0 	    Marta Stempien 	    29/08/2019 	    Created     NEXI-287
    1.1 	    Kinga Fornal 	    20/09/2019 	    Modified    NEXI-344
    *****************************************************************/
    public static Boolean checkStepsEntryCriteriaOrderHeader( NE__Order_Header__c inOrderHeader )
    {
        System.debug( LoggingLevel.INFO, 'Start: checkStepsEntryCriteriaOrderHeader for order header: ' + inOrderHeader );
        Boolean isTrueSubmit = false;
        Boolean isGianosGreaterThanTwentyFive = false;
        try
        {
            isGianosGreaterThanTwentyFive = ( inOrderHeader.OB_Gianos__c != null && Integer.valueOf( inOrderHeader.OB_Gianos__c ) >= 25 ) ? true : false; //NEXI-287 Marta Stempien <marta.stempien@accenture.com> 04/09/2019 Added null check

        } catch ( Exception exc )
        {
            System.debug( LoggingLevel.ERROR, '[EXC] Exception ' + exc.getMessage( ) + ' stacktrace ' + exc.getStackTraceString( ) );

        }

        if ( inOrderHeader != null && !isBooleanTrue( inOrderHeader.OB_ProcessInstanceAlredyExist__c ) && isBooleanTrue ( inOrderHeader.OB_StartApprovalProcess__c ) )
        {
            if ( !String.isBlank( inOrderHeader.OB_In_Approvazione_a__c ) &&
                    (
                            OB_UtilityConstants.ORDER_HEADER_FASE_CONTROLLI_CONTROLLI_OPERATIVI.equalsIgnoreCase( inOrderHeader.OB_In_Approvazione_a__c )
                                    && isBooleanTrue( inOrderHeader.OB_AdditionalDocumentationRequired__c )
                                    && !OB_UtilityConstants.APPROVAL_STEP_3.equalsIgnoreCase( inOrderHeader.OB_ApprovalStep__c )
                                    && !OB_UtilityConstants.APPROVAL_STEP_4.equalsIgnoreCase( inOrderHeader.OB_ApprovalStep__c ) //NEXI-344 Kinga Fornal <kinga.fornal@accenture.com>, 20.09.2019 Start
                    ) ||
                    (
                            OB_UtilityConstants.ORDER_HEADER_FASE_CONTROLLI_CONTROLLI_AML.equalsIgnoreCase( inOrderHeader.OB_In_Approvazione_a__c )
                                    && !OB_UtilityConstants.APPROVAL_STEP_3.equalsIgnoreCase( inOrderHeader.OB_ApprovalStep__c )
                                    && ( isBooleanTrue( inOrderHeader.OB_PEP__c )
                                    || isGianosGreaterThanTwentyFive
                                    || isBooleanTrue( inOrderHeader.OB_Gambling__c )
                                    || isBooleanTrue( inOrderHeader.OB_Fiduciarie__c )
                                    || isBooleanTrue( inOrderHeader.OB_Onlus__c )
                                    || isBooleanTrue( inOrderHeader.OB_Moneytransfer__c )
                                    || isBooleanTrue( inOrderHeader.OB_Trust__c )
                                    || isBooleanTrue( inOrderHeader.OB_Crowdfunding__c ) )
                    ) ||
                    (
                            OB_UtilityConstants.ORDER_HEADER_FASE_CONTROLLI_CONTROLLI_SICUREZZA.equalsIgnoreCase( inOrderHeader.OB_In_Approvazione_a__c )
                                    && ( isBooleanTrue( inOrderHeader.OB_PO118_Ecommerce__c )
                                    || isBooleanTrue( inOrderHeader.OB_PO118_MOTO__c )
                                    || isBooleanTrue( inOrderHeader.OB_HotelCarRental__c )
                                    || isBooleanTrue( inOrderHeader.OB_ManualPAN__c )
                                    || isBooleanTrue( inOrderHeader.OB_eCommerce__c )
                                    || isBooleanTrue( inOrderHeader.OB_Moto__c )
                                    || isBooleanTrue( inOrderHeader.OB_isBlackList__c )
                                    || isBooleanTrue( inOrderHeader.OB_isUCAMP__c ) )
                    ) )
            {
                isTrueSubmit = true;
            }
            else
            {
                if ( isBooleanTrue( inOrderHeader.OB_StartApprovalProcess__c ) &&
                        ( isBooleanTrue( inOrderHeader.OB_AdditionalDocumentationRequired__c )
                                || isBooleanTrue( inOrderHeader.OB_PEP__c )
                                || isGianosGreaterThanTwentyFive
                                || isBooleanTrue( inOrderHeader.OB_Gambling__c )
                                || isBooleanTrue( inOrderHeader.OB_Fiduciarie__c )
                                || isBooleanTrue( inOrderHeader.OB_Onlus__c )
                                || isBooleanTrue( inOrderHeader.OB_Moneytransfer__c )
                                || isBooleanTrue( inOrderHeader.OB_Trust__c )
                                || isBooleanTrue( inOrderHeader.OB_Crowdfunding__c )
                                || isBooleanTrue( inOrderHeader.OB_PO118_MOTO__c )
                                || isBooleanTrue( inOrderHeader.OB_isBlackList__c )
                                || isBooleanTrue( inOrderHeader.OB_isUCAMP__c )
                                || isBooleanTrue( inOrderHeader.OB_PO118_Ecommerce__c )
                                || isBooleanTrue( inOrderHeader.OB_HotelCarRental__c )
                                || isBooleanTrue( inOrderHeader.OB_ManualPAN__c )
                                || isBooleanTrue( inOrderHeader.OB_eCommerce__c )
                                || isBooleanTrue( inOrderHeader.OB_Moto__c ) ) )
                {
                    isTrueSubmit = true;
                }
            }
        }
        System.debug( LoggingLevel.INFO, 'Stop: checkStepsEntryCriteriaOrderHeader, isTrueSubmit = ' + isTrueSubmit );
        return isTrueSubmit;
    }

    /*****************************************************************
    Purpose: Method checks if log request meets entry criteria of any step of approval process
    Parameters: OB__LogRequest__c inLogRequest
    Returns: Boolean

    History
    --------
    VERSION       AUTHOR 		    DATE 		    DETAIL 		Description
    1.0 	    Marta Stempien 	    29/08/2019 	    Created     NEXI-287
    *****************************************************************/
    public static Boolean checkStepsEntryCriteriaLogRequest( OB_LogRequest__c inLogRequest )
    {
        System.debug( LoggingLevel.INFO, 'Start: checkStepsEntryCriteriaLogRequest for log request: ' + inLogRequest );
        Boolean isGianosGreaterThanTwentyFive = false;
        try
        {
            isGianosGreaterThanTwentyFive = ( inLogRequest.OB_Gianos__c != null && Integer.valueOf( inLogRequest.OB_Gianos__c ) >= 25 ) ? true : false; //NEXI-287 Marta Stempien <marta.stempien@accenture.com> 04/09/2019 Added null check

        } catch ( Exception exc )
        {
            System.debug( LoggingLevel.ERROR, '[EXC] Exception ' + exc.getMessage( ) + ' stacktrace ' + exc.getStackTraceString( ) );

        }
        //NEXI-289 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 04/09/2019 remove start approval proces flag
        Boolean isTrueCriteriaMet = inLogRequest != null &&
                (
                        ( !OB_UtilityConstants.APPROVAL_STEP_2.equalsIgnoreCase( inLogRequest.OB_ApprovalStep__c )
                            && !OB_UtilityConstants.APPROVAL_STEP_3.equalsIgnoreCase( inLogRequest.OB_ApprovalStep__c ) //NEXI-344 Kinga Fornal <kinga.fornal@accenture.com>, 24.09.2019
                                && ( isBooleanTrue( inLogRequest.OB_PEP__c )
                                || ( isGianosGreaterThanTwentyFive )
                                || isBooleanTrue( inLogRequest.OB_isGambling__c )
                                || isBooleanTrue( inLogRequest.OB_Fiduciarie__c )
                                || isBooleanTrue( inLogRequest.OB_Onlus__c )
                                || isBooleanTrue( inLogRequest.OB_Moneytransfer__c )
                                || isBooleanTrue( inLogRequest.OB_Trust__c )
                                || isBooleanTrue( inLogRequest.OB_Crowdfunding__c ) )
                        )
                                || isBooleanTrue( inLogRequest.OB_PO118_eCommerce__c )
                                || isBooleanTrue( inLogRequest.OB_PO118_MOTO__c )
                                || isBooleanTrue( inLogRequest.OB_isBlackList__c )
                );
        System.debug( LoggingLevel.INFO, 'Stop: checkStepsEntryCriteriaLogRequest, isTrueCriteriaMet = ' + isTrueCriteriaMet );
        return isTrueCriteriaMet;
    }

    /*****************************************************************
    Purpose: Method to update order header when manual pan selectd
    Parameters: List<NE__OrderItem__c> oiList
    Returns: void

    History
    --------
    VERSION       AUTHOR 		    DATE 		    DETAIL 		Description
    1.0 	    Elena Preteni 	    04/09/2019 	    Created     R1F3-25
    *****************************************************************/
    public static void updateOrhFlagManualPan( NE__Order_Header__c orderHeader, List<NE__OrderItem__c> oiList )
    {
        if(orderHeader!= null && !oiList.isEmpty()){
            for(NE__OrderItem__c oiCurrent : oiList){
                if(oiCurrent.NE__ProdId__r.OB_Codice_sfdc__c == 'MPAN'){
                        orderHeader.OB_ManualPAN__c = true;
                        break;
                }
            }
        }
        update orderHeader;
    }

    /*******************************************************************************
    Purpose:    Method checks if User has Profile = Operation
    Parameters: -
    Returns:    Boolean if User Profile is Operation

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       11/09/2019      Created         NEXI-314
    ********************************************************************************/
    public static Boolean isOperation( )
    {
        System.debug( LoggingLevel.FINE, 'OB_Utility.isOperation INTO method' );
        List<Profile> currentUserProfile =
        [
                SELECT Name
                FROM Profile
                WHERE Id = :UserInfo.getProfileId( )
        ];
        Boolean isOperation = currentUserProfile.isEmpty( ) ? false : OB_UtilityConstants.OPERATION.equalsIgnoreCase( currentUserProfile.get( 0 ).Name );

        System.debug( LoggingLevel.FINE, 'OB_Utility.isOperation : ' + isOperation );
        return isOperation;
    }

    /*******************************************************************************
    Purpose:    Method update NE__Order__c.OB_FulfilmentStatus__c to 'To Approve'.
                Used for Order after Setup for Operation User, instead of starting BIO/Pricing Approval Process.
    Parameters: String inOrderId, String inApprovalType
    Returns:    -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       11/09/2019      Created         NEXI-314
    ********************************************************************************/
    public static void updateOrderToApprove( String inOrderId, String inApprovalType )
    {
        System.debug( LoggingLevel.FINE, 'OB_Utility.updateOrderToApprove INTO method. OrderId = ' + inOrderId );
        if ( String.isBlank( inOrderId ) || String.isBlank( inApprovalType ) )
        {
            return;
        }

        NE__Order__c currentOrder = new NE__Order__c( Id = inOrderId );
        currentOrder.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_TOAPPROVE;
        currentOrder.OB_ApprovalType__c = inApprovalType;

        try
        {
            update currentOrder;
            System.debug( LoggingLevel.FINE, 'OB_Utility.updateOrderToApprove after update ' + currentOrder );
        }
        catch ( DmlException dmlEx )
        {
            System.debug( LoggingLevel.ERROR, '[EXC] Exception : ' + dmlEx.getMessage( ) + ' at line: '
                    + dmlEx.getLineNumber( ) + ' stack trace: ' + dmlEx.getStackTraceString( ) );
        }
    }

    /*******************************************************************************
    Purpose:    Method update NE__Order_Header__c.OB_FulfilmentStatus__c to 'Pending'.
                Used for OrderHeader after Setup for Operation User.
    Parameters: String inOrderHeaderId
    Returns:    -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Joanna Mielczarek       11/09/2019      Created         NEXI-314
    ********************************************************************************/
    public static void updateOrderHeaderPending( String inOrderHeaderId )
    {
        System.debug( LoggingLevel.FINE, 'OB_Utility.updateOrderHeaderPending INTO method. OrderHeader Id = ' + inOrderHeaderId );
        if ( String.isBlank( inOrderHeaderId ) )
        {
            return;
        }

        NE__Order_Header__c currentOrderHeader = new NE__Order_Header__c( Id = inOrderHeaderId );
        currentOrderHeader.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_PENDING;

        try
        {
            update currentOrderHeader;
            System.debug( LoggingLevel.FINE, 'OB_Utility.updateOrderHeaderPending after update ' + currentOrderHeader );
        }
        catch ( DmlException dmlEx )
        {
            System.debug( LoggingLevel.ERROR, '[EXC] Exception : ' + dmlEx.getMessage( ) + ' at line: '
                    + dmlEx.getLineNumber( ) + ' stack trace: ' + dmlEx.getStackTraceString( ) );
        }
    }

    /*******************************************************************************
    Purpose:    This Method update either the OB_Log_Request__c or OB_OrderId__c field on plcLog
    Parameters: PlcLog id, SObject id
    Returns:    -
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Francesca Ribezzi      26/09/2019      Created           F2WAVE2-189
    2.0         Francesca Ribezzi      02/10/2019       Edit            using switch/case to handle 3 different object types
    ********************************************************************************/
    public static void updateLogRequestOrderIdOnPlcLog( Id plcId, Id sobjectId ){
        if(plcId == null){
            System.debug('plc log id is null');
            return; 
        }
        Plc_Log__c plcLog = new Plc_Log__c();
        String sobjectType =  sobjectId != null ? sobjectId.getSObjectType().getDescribe().getName() : null; 
        switch on sobjectType {
            when 'NE__Order__c' {	
                plcLog.OB_OrderId__c = sobjectId; 
            }	
            when 'OB_LogRequest__c' {	
                plcLog.OB_Log_Request__c = sobjectId;
            }
            when 'NE__Order_Header__c' {		
                List<NE__Order__c> orders = [SELECT id FROM NE__Order__c WHERE NE__Order_Header__c = :sobjectId];
                if(orders.size() > 0){
                    plcLog.OB_OrderId__c = orders[0].Id; 
                }
            }
            when else {		  
                // do nothing
                System.debug('sobjectId is not identified');
                return;
            }
        }
        plcLog.Id = plcId;
        update plcLog;
    }

    //Start antonio.vatrano 30/09/2019 r1f3-119
    @TestVisible
    public static Boolean checkItemVM ( String ohId ){
        if(ohId != null && ohId !=''){
            List<NE__OrderItem__c> listOfItemsVM =[ SELECT Id,NE__ProdId__c,NE__Action__c
                                                    FROM NE__OrderItem__c
                                                    WHERE NE__OrderId__r.NE__Order_Header__c=: ohId
                                                    AND NE__ProdId__r.OB_Codice_sfdc__c = 'VISAMASTERCARD'
                                                    AND NE__Action__c = 'Add'
                                                    AND NE__Root_Order_Item__c = null];
            if ( !listOfItemsVM.isEmpty() )
            {
                return true;
            }
        }
        return false;
    }
    //End antonio.vatrano 30/09/2019 r1f3-119

	/*
	*	Author	:	Morittu Andrea
	*	Date	:	11-Oct-2019
	*	Task	:	No_task
	*	Descr	:	Re-usable method to retrieve the object name by the Id (or multiple ids) as incoming parameter of the method.
 	*/
	public static Map<String, String> findObjectNameFromRecordIdPrefix(List<String> recordIdOrPrefixList){
        Map<String, String> toReturn = new Map<String, String>();
        try{
            for(String recordIdOrPrefix : recordIdOrPrefixList) {
                String myIdPrefix = String.valueOf(recordIdOrPrefix).substring(0,3);

                Map<String, Schema.SObjectType> gd =  Schema.getGlobalDescribe(); 
                
                for(Schema.SObjectType stype : gd.values()){


                    Schema.DescribeSObjectResult r = stype.getDescribe();
                    String prefix = r.getKeyPrefix();
                    
                    if(prefix!=null && prefix.equals(myIdPrefix)){
                        toReturn.put(r.getName() , recordIdOrPrefix);
                        System.debug('Object Name! ' + r.getName());
                        break;
                    }
                }
            }
        }catch(Exception e){
            System.debug('An error has occured inside findObjectNameFromRecordIdPrefix method : ' + e.getMessage());
        }
        return toReturn;
    }
    /* 
    *   Author      : Morittu Andrea
    *   Date        : 16/Oct/2019
    *   Description : Centralized Method to build Object Metadata by List of fields
*/
    @AuraEnabled
    public static List<dataTableAccountWrapper> retrieveObjectFieldsDetailsBySpecificFields(String objectType, List<String> fieldToReturn){
        List<dataTableAccountWrapper> dataTableScaffolding = new List<dataTableAccountWrapper>();

        try {
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Schema.SObjectType schema = schemaMap.get(objectType);
            Map<String, Schema.SObjectField> fieldMap = schema.getDescribe().fields.getMap();


                for (String fieldName: fieldMap.keySet()) {       
					System.debug('## fieldName is : ' + fieldName);      
					for(String singleField : fieldToReturn) {
						System.debug('## singleField is : ' + singleField);      
						if(singleField.equalsIgnoreCase(fieldName)) {
							dataTableAccountWrapper singleWrap = new dataTableAccountWrapper();
							String fieldType = String.valueOf(fieldMap.get(fieldName).getDescribe().getType());
							if(!String.isBlank(fieldType)) {
								if(fieldType == 'BOOLEAN')  {
									singleWrap.label            = fieldMap.get(fieldName).getDescribe().getLabel();
									singleWrap.fieldName     	= singleField;
									singleWrap.type             = 'boolean';
								}
								else if(fieldType == 'URL')  {
									singleWrap.label            = fieldMap.get(fieldName).getDescribe().getLabel();
									singleWrap.fieldName     	= singleField;
									singleWrap.type             = 'url';
								}
								else if(fieldType == 'INTEGER' || fieldType == 'DOUBLE' || fieldType == 'LONG')  {
									singleWrap.label            = fieldMap.get(fieldName).getDescribe().getLabel();
									singleWrap.fieldName     	= singleField;
									singleWrap.type             = 'number';
								}
								else if(fieldType == ('DATETIME') || fieldType == ('DATE') || fieldType == ('DATETIME') )  {
									singleWrap.label            = fieldMap.get(fieldName).getDescribe().getLabel();
									singleWrap.fieldName     	= singleField;
									singleWrap.type             = 'date';
								} 
								else if(fieldType == ('CURRENCY') ) {
									singleWrap.label            = fieldMap.get(fieldName).getDescribe().getLabel();
									singleWrap.fieldName     	= singleField;
									singleWrap.type             = 'currency';
								}
								else if(fieldType == ('EMAIL') ) {
									singleWrap.label            = fieldMap.get(fieldName).getDescribe().getLabel();
									singleWrap.fieldName     	= singleField;
									singleWrap.type             = 'email';
								}
								else if(fieldType == ('PHONE') ) {
									singleWrap.label            = fieldMap.get(fieldName).getDescribe().getLabel();
									singleWrap.fieldName     	= singleField;
									singleWrap.type             = 'phone';
								}
								else {
									singleWrap.label            = fieldMap.get(fieldName).getDescribe().getLabel();
									singleWrap.fieldName     	= singleField;
									singleWrap.type             = 'text';
								}
							}
							dataTableScaffolding.add(singleWrap);
						}
					}
                }
        } catch(Exception exc) {
            System.debug('An error has occured : ' + exc.getMessage());
        }
		System.debug('## dataTableScaffolding is: ' + dataTableScaffolding);
        return dataTableScaffolding;
    } 
    
/* 
    *   Author      : Morittu Andrea
    *   Date        : 16/Oct/2019
    *   Task        : EVO_BACKLOG_143
    *   Description : Retrieve dynamically filtered convention code (in case of partner user) . If partner admin, show all convention codes
*/	
    @AuraEnabled
    public static List<OB_Convention_Code__c> retrieveConventionCodes(String bankABI, Boolean isAdmin) {
        List<OB_Convention_Code__c> conventionCodeRetrieved = new List<OB_Convention_Code__c>();
        try {
            if( !String.isBlank(bankABI) ) {
                
                String query = ' SELECT Id, OB_Promo_Offer_Name_Loyalty__c, OB_Additional_Text__c, OB_Commission__c, OB_Start_Date__c, OB_End_Date__c, OB_LoyaltyCode__c, OB_Bank__c, OB_Product__c, CreatedBy.Name, CreatedDate,OB_Active__c '
                             +  ' FROM OB_Convention_Code__c '
                             +  ' WHERE OB_Bank__r.OB_ABI__c =: bankABI ';
                if(!isAdmin) {
                    // ANDREA MORITTU START 18/11/2019 - BASCKLOG_143 remove end date filter and adding start date filter 
                    query += 'AND OB_Active__c = true AND OB_Start_Date__c > TODAY ';
                    // ANDREA MORITTU END 18/11/2019 - BASCKLOG_143 remove end date filter and adding start date filter 
                }
                System.debug('query is : ' + query);
            	conventionCodeRetrieved = Database.query(query);
            } else {
                throw new applicationException('It seems it\'s missing OB_ABI__c, please check the data');
            }
        } catch(OB_Utility.applicationException exc) {
            System.debug('An error has occured : ' + exc.getMessage());
        }
        return conventionCodeRetrieved;
    }



     /*******************************************************************************
    Purpose:    Method set OB_MerchantTakeover__c flag on Asset to false when the configuration is cancelled
    Parameters: offerAsset id, orderStatus
    Returns:    Asset

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Francesca Ribezzi       19/11/2019      Created         PROD-69
    2.0         Francesca Ribezzi       20/11/2019      Edit            PROD-69_v2 - adding return 
    ********************************************************************************/
    public static Asset updateMerchantTakeOverOnAsset( String offerAssetId, String oldOrderStatus ){  
        if(oldOrderStatus == OB_UtilityConstants.FULFILMENTSTATUS_CANCELLED ){
             return null; //do nothing
        }
        if(String.isBlank(offerAssetId)){ //francesca.ribezzi 20/11/19 string.isBlank instead of null 
            return null; //do nothing 
        } 
        Asset a = new Asset();
        a.Id = offerAssetId;
        a.OB_MerchantTakeover__c = false;
        return a;  
    }
	
	public static String isnull (String controlledValue, String alternativeValue){
                      if(controlledValue == null) return alternativeValue;
                      return controlledValue;
    }

      /*******************************************************************************
    Purpose:    Method for delete the bit2flow__Historic_Wizard_Data__c on catalog Controller
    

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Simone Misani         11/12/2019        Created         perf-43-46
    
    ********************************************************************************/


    public static void deleteHosticWizardDataOnCatalogController(List<bit2flow__Historic_Wizard_Data__c> historicDataList){
        delete historicDataList;
    }

}