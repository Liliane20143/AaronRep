/*------------------------------------------------------------
Author:         Andrea Saracini
Company:        Accenture Tecnology
Description:    Check RAC SIA attributes is valid 
Inputs:
Test Class:     OB_CheckRacSiaAttributes_Test
History:
<Date>          <Authors Name>      <Brief Description of Change>
2019-03-11      Andrea Saracini     Creator
------------------------------------------------------------*/
public without sharing class OB_CheckRacSiaAttributes {
    public static Boolean siaIsValid = true;
    public static final String MAINTENANCE = OB_UtilityConstants.MAINTENANCE;//Andrea Saracini 02/05/2019 RI-12-bis
    public static final String setup = OB_UtilityConstants.SETUP;
    public static final String TERMINALS =  OB_UtilityConstants.POS_RT;//Andrea Saracini 03/05/2019 RI-12-v3
    public static final String cancelled = OB_UtilityConstants.ORDERITEM_STATUS_CANCELLED;
    public static final String active = OB_UtilityConstants.STATUS_ACTIVE;
    /*------------------------------------------------------------
    Author:         Andrea Saracini
    Company:        Accenture Tecnology
    Description:    check RAC SIA Code if is correct.
    Inputs:         String objectDataString, String sia, String inputSiaValuesMap, String itemsToUpdate, Boolean isReset
    Output:         Boolean
    History:
    <Date>          <Authors Name>      <Brief Description of Change>
    2019-03-15      Andrea Saracini     Creator
    ------------------------------------------------------------*/
    public Boolean checkRacSiaAttributes(String objectDataString, String sia, String inputSiaValuesMap, String itemsToUpdate, Boolean isReset){
        System.debug(LoggingLevel.INFO, '### isReset :' + isReset);
        if(isReset){
            return updateRacSiaAttributes(sia, inputSiaValuesMap, itemsToUpdate);
        }
        
        Map<String,Object> objectDataMap = (Map<String,Object>)JSON.deserializeUntyped(objectDataString);
        //Get Billing Profile
        String bpString = JSON.serialize(objectDataMap.get('BillingProfilePOS'));
        NE__Billing_Profile__c bp = (NE__Billing_Profile__c)JSON.deserialize(bpString, NE__Billing_Profile__c.class);
       
        
        //andrea.saracini - 14/06/2019 - RI-105 - START
        String config = JSON.serialize(objectDataMap.get('Configuration'));
        NE__Order__c order = new NE__Order__c();
        try{
            order = (NE__Order__c)JSON.deserialize(config, NE__Order__c.class);
        }catch(Exception e){
            System.debug( LoggingLevel.ERROR, '[EXC] Exception ' + e.getMessage( ) + ' stacktrace ' + e.getStackTraceString( ) );
        }
        
        List<NE__OrderItem__c> orderItems = [SELECT Id,
                                                    NE__OrderId__r.NE__BillingProfId__r.OB_IBAN__c, 
                                                    NE__OrderId__r.NE__BillingProfId__r.OB_ABICode__c, 
                                                    NE__OrderId__r.OB_FulfilmentStatus__c, NE__OrderId__c, 
                                                    OB_RAC_SIA__c
                                            FROM NE__OrderItem__c
                                            WHERE OB_RAC_SIA__c =: sia 
                                                AND (NE__ProdId__r.RecordType.DeveloperName =: terminals  
                                                    OR NE__ProdId__r.RecordType.DeveloperName = 'eCommerce' 
                                                    OR NE__ProdId__r.RecordType.DeveloperName = 'Moto')//Simone Misani 16/10/2019 WN-609
                                                AND NE__OrderId__r.OB_FulfilmentStatus__c !=: cancelled 
                                                AND NE__OrderId__r.NE__BillingProfId__r.OB_ABICode__c =: bp.OB_ABICode__c 
                                                AND NE__OrderId__c !=: order.Id];

        List<Asset> assets = [SELECT Id, 
                                    NE__Order_Config__c, 
                                    NE__Order_Config__r.NE__BillingProfId__r.OB_IBAN__c, 
                                    NE__Order_Config__r.NE__BillingProfId__r.OB_ABICode__c
                            FROM Asset
                            WHERE OB_RAC_SIA__c =: sia 
                                AND NE__Status__c =: active 
                                AND NE__Order_Config__r.NE__BillingProfId__r.OB_ABICode__c =: bp.OB_ABICode__c];
        //andrea.saracini - 14/06/2019 - RI-105 - END
                         
        if(orderItems != null && orderItems.size()==0 && assets!= null && assets.size()==0){
            System.debug(LoggingLevel.INFO, '### orderItems and assets:'+orderItems.size()+assets.size());
            siaIsValid = updateRacSiaAttributes(sia, inputSiaValuesMap, itemsToUpdate);
            return siaIsValid;
        }
        if(orderItems != null && orderItems.size()>0){
            siaIsValid = checkIbanFromOrderItems(orderItems, bp.OB_IBAN__c);
        }
        if(!siaIsValid && assets!= null && assets.size()>0){
            siaIsValid = checkIbanFromAssets(assets, bp.OB_IBAN__c);
        }
        if(siaIsValid){
            siaIsValid = updateRacSiaAttributes(sia, inputSiaValuesMap, itemsToUpdate);
        }
        return siaIsValid;
    }
    /*------------------------------------------------------------
    Author:         Andrea Saracini
    Company:        Accenture Tecnology
    Description:    check IBAN is equals to IBAN in Billing Profile.
    Inputs:         List<NE__OrderItem__c> orderItems, String iban
    Output:         Boolean
    History:
    <Date>          <Authors Name>      <Brief Description of Change>
    2019-03-15      Andrea Saracini     Creator
    ------------------------------------------------------------*/
    @TestVisible
    private Boolean checkIbanFromOrderItems(List<NE__OrderItem__c> orderItems, String iban){
        Boolean siaIsValid = false;
        for(NE__OrderItem__c item : orderItems){
            if(iban!=null){
                siaIsValid = iban.equals(item.NE__OrderId__r.NE__BillingProfId__r.OB_IBAN__c) ? true : false;
            }
            if(siaIsValid){
                return siaIsValid;
            }
        }
        return siaIsValid;
    }
    /*------------------------------------------------------------
    Author:         Andrea Saracini
    Company:        Accenture Tecnology
    Description:    check IBAN is equals to IBAN in Billing Profile.
    Inputs:         List<Asset> assets, String iban
    Output:         Boolean
    History:
    <Date>          <Authors Name>      <Brief Description of Change>
    2019-03-15      Andrea Saracini     Creator
    ------------------------------------------------------------*/
    @TestVisible
    private Boolean checkIbanFromAssets(List<Asset> assets, String iban){
        Boolean siaIsValid = false;
        for(Asset item : assets){
            if(iban!=null){
                siaIsValid = iban.equals(item.NE__Order_Config__r.NE__BillingProfId__r.OB_IBAN__c) ? true : false;
            }
            if(siaIsValid){
                return siaIsValid;
            }
        }
        return siaIsValid;
    }

    /*******************************************************************************
    Purpose:  Save the RAC SIA code on order item attributes
    Parameters: String sia, String inputSiaValuesMap, String itemsToUpdate
    Returns: Boolean

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       Andrea Saracini     15/03/2019    Created    -
    1.1       Joanna Mielczarek   08/08/2019    Modified   NEXI-266 refactored method, added IN in queries, changed to private
    ********************************************************************************/
    private Boolean updateRacSiaAttributes( String sia, String inputSiaValuesMap, String itemsToUpdate )
    {
        System.debug( LoggingLevel.INFO, 'In OB_CheckRacSiaAttributes.updateRacSiaAttributes sia : ' + sia +
                ' inputSiaValuesMap : ' + inputSiaValuesMap + ' itemsToUpdate ' + itemsToUpdate );

        Map<String, Object> orderItemsByIds = new Map<String, Object>( );
        Map<String, Object> siaValuesByName = new Map<String, Object>( );
        try
        {
            orderItemsByIds = ( Map<String, Object> ) JSON.deserializeUntyped( itemsToUpdate );
            siaValuesByName = ( Map<String, Object> ) JSON.deserializeUntyped( inputSiaValuesMap );
        }
        catch ( Exception Ex )
        {
            System.debug( LoggingLevel.ERROR, '[EXC] Exception in OB_CheckRacSiaAttributes.updateRacSiaAttributes : ' + ex.getMessage( ) );
            return false;
        }

        if ( orderItemsByIds.isEmpty( ) && siaValuesByName.isEmpty( ) )
        {
            System.debug( LoggingLevel.ERROR, '[EXC] Exception in OB_CheckRacSiaAttributes.updateRacSiaAttributes : Empty maps' );
            return false;
        }

        List<NE__OrderItem__c> orderItemsToUpdate = new List<NE__OrderItem__c>( );
        for ( NE__OrderItem__c loopItem :
        [
                SELECT Id,
                        OB_RAC_SIA__c
                FROM NE__OrderItem__c
                WHERE Id IN :orderItemsByIds.keySet( )
        ] )
        {
            loopItem.OB_RAC_SIA__c = sia;
            orderItemsToUpdate.add( loopItem );
        }

        List<NE__Order_Item_Attribute__c> attributesToUpdate = new List<NE__Order_Item_Attribute__c>( );
        for ( NE__Order_Item_Attribute__c loopAttribute :
        [
                SELECT Id,
                        Name,
                        NE__Value__c
                FROM NE__Order_Item_Attribute__c
                WHERE Name IN :siaValuesByName.keySet( )
                AND NE__Order_Item__c IN :orderItemsByIds.keySet( )
        ] )
        {
            loopAttribute.NE__Value__c = ( String ) siaValuesByName.get( loopAttribute.Name );
            attributesToUpdate.add( loopAttribute );
        }

        try
        {
            update orderItemsToUpdate;
            update attributesToUpdate;
            return true;
        }
        catch ( DmlException dmlEx )
        {
            System.debug( LoggingLevel.ERROR, '[EXC] Exception in OB_CheckRacSiaAttributes.updateRacSiaAttributes : '
                    + dmlEx.getMessage( ) + ' stacktrace : ' + dmlEx.getStackTraceString( ) );
            return false;
        }
    }

    //D.F. 18-03-2019 check if sia is in use by other merchant - START 
    public Boolean checkSiaInUse(String objectDataString, String sia){
        Map<String,Object> objectDataMap = (Map<String,Object>)JSON.deserializeUntyped(objectDataString);
        String accStr = JSON.serialize(objectDataMap.get('merchant'));
        Account acc = (Account)JSON.deserialize(accStr, Account.class);

        List<NE__OrderItem__c> orderItems =
        [
                SELECT Id,
                        NE__Account__c,
                        NE__OrderId__r.NE__BillingProfId__r.OB_IBAN__c,
                        NE__OrderId__r.NE__BillingProfId__r.OB_ABICode__c,
                        NE__OrderId__r.OB_FulfilmentStatus__c,
                        NE__OrderId__c,
                        OB_RAC_SIA__c
                FROM NE__OrderItem__c
                WHERE OB_SiaCode__c = :sia
                AND(NE__ProdId__r.RecordType.DeveloperName =: terminals  
                    OR NE__ProdId__r.RecordType.DeveloperName = 'eCommerce' 
                    OR NE__ProdId__r.RecordType.DeveloperName = 'Moto')//Simone Misani 16/10/2019 WN-609
                AND NE__OrderId__r.OB_FulfilmentStatus__c != :cancelled
                AND NE__Account__c != :acc.Id
        ];

        List<Asset> assets =
        [
                SELECT Id,
                        AccountId,
                        NE__Order_Config__c,
                        NE__Order_Config__r.NE__BillingProfId__r.OB_IBAN__c,
                        NE__Order_Config__r.NE__BillingProfId__r.OB_ABICode__c
                FROM Asset
                WHERE OB_SiaCode__c = :sia
                AND NE__StartDate__c != null //Andrea Saracini FIX R1F2-25 12-04-2019
                AND AccountId != :acc.Id
        ];

        if ( ( orderItems != null && !orderItems.isEmpty( ) ) || ( assets != null && !assets.isEmpty( ) ) )//Andrea Saracini FIX R1F2-25 12-04-2019
        {
            return true;
        }
        else{
            return false;
        }
    } 

    public List<String> checkSiaCodeByCoba(String objectDataString){
        
        Map<String,Object> objectDataMap = (Map<String,Object>)JSON.deserializeUntyped(objectDataString);
        String bpString = JSON.serialize(objectDataMap.get('BillingProfilePOS'));
        NE__Billing_Profile__c bp = (NE__Billing_Profile__c)JSON.deserialize(bpString, NE__Billing_Profile__c.class);
        //davide.franzini - 19/04/2019 - RI-12 & RI-18 - added filter by account id -START
        String accStr = JSON.serialize(objectDataMap.get('merchant'));
        Account acc = (Account)JSON.deserialize(accStr, Account.class);
        Set<String> racSiaSet = new Set<String>();
        //START Andrea Saracini 02/05/2019 RI-12-bis
        String ordString = JSON.serialize(objectDataMap.get('Configuration'));
        NE__Order__c ord = (NE__Order__c)JSON.deserialize(ordString, NE__Order__c.class);
        //STOP Andrea Saracini 02/05/2019 RI-12-bis
        List<NE__OrderItem__c> ordItList = [SELECT Id, 
                                                   OB_RAC_SIA__c,
                                                   /*START Andrea Saracini 02/05/2019 RI-12-bis*/
                                                   NE__Action__c,
                                                   NE__OrderId__c,
                                                   NE__OrderId__r.NE__Order_Header__r.OB_Main_Process__c
                                                   /*STOP Andrea Saracini 02/05/2019 RI-12-bis*/
                                            FROM NE__OrderItem__c
                                            WHERE(NE__ProdId__r.RecordType.DeveloperName =: terminals  
                                                    OR NE__ProdId__r.RecordType.DeveloperName = 'eCommerce' 
                                                    OR NE__ProdId__r.RecordType.DeveloperName = 'Moto')//Simone Misani 16/10/2019 WN-609 /*Andrea Saracini 03/05/2019 RI-12-v3*/
                                                AND NE__OrderId__r.NE__BillingProfId__r.OB_IBAN__c =: bp.OB_IBAN__c
                                                AND OB_RAC_SIA__c != null 
                                                AND OB_RAC_SIA__c != ''
                                                AND NE__Account__c = :acc.Id];

        List<Asset> astList = [SELECT Id, 
                                      OB_RAC_SIA__c,
                                      NE__Order_Config__c/*Andrea Saracini 02/05/2019 RI-12-bis*/
                                FROM Asset 
                                WHERE (OB_DebitProfId__r.OB_IBAN__c = :bp.OB_IBAN__c
                                    OR NE__BillingProf__r.OB_IBAN__c = :bp.OB_IBAN__c)//Andrea Saracini 13/06/2019 query asset RAC SIA
                                    AND NE__ProdId__r.RecordType.DeveloperName =: TERMINALS /*Andrea Saracini 03/05/2019 RI-12-v3*/
                                    AND OB_RAC_SIA__c != null 
                                    AND OB_RAC_SIA__c != ''
                                    AND AccountId = :acc.Id];
        //START Andrea Saracini 02/05/2019 RI-12-bis                            
        List<String> racSiaList = new List<String>();
        
        if(!ordItList.isEmpty() && ordItList != null){
            Map<Id, List<NE__OrderItem__c>> ordIdPosMap = new Map<Id, List<NE__OrderItem__c>>();           
            for(NE__OrderItem__c item : ordItList){
                racSiaSet.add(item.OB_RAC_SIA__c);
                if(ordIdPosMap.containsKey(item.NE__OrderId__c)){
                    ordIdPosMap.get(item.NE__OrderId__c).add(item);
                }
                else{
                    ordIdPosMap.put(item.NE__OrderId__c, new List<NE__OrderItem__c>{item});
                }                      
            }
            List<NE__OrderItem__c> allPos = ordIdPosMap.get(ord.Id);
            if(allPos != null && !allPos.isEmpty() && MAINTENANCE.equals(allPos.get(0).NE__OrderId__r.NE__Order_Header__r.OB_Main_Process__c)){
                Integer posInAdd = 0;
                for(NE__OrderItem__c pos : allPos){
                    posInAdd += 'Add'.equals(pos.NE__Action__c) ? 1 : 0;
                }
                if(allPos.size() == posInAdd){
                    return racSiaList;
                }
            }
        }
        //STOP Andrea Saracini 02/05/2019 RI-12-bis
        if(!astList.isEmpty() && astList != null){
            for(Asset ast : astList){
                racSiaSet.add(ast.OB_RAC_SIA__c);
            }
        }

        racSiaList.addAll(racSiaSet);//Andrea Saracini 02/05/2019 RI-12-bis       
        //davide.franzini - 19/04/2019 - RI-12 & RI-18 - added filter by account id - END
        return racSiaList;
    }
    //D.F. END
}