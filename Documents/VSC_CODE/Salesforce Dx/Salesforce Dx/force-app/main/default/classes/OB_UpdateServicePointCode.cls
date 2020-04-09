/*------------------------------------------------------------
Author:         Andrea Saracini
Company:        Accenture Tecnology
Description:    Cmp controller for Update Service Point Code 
Inputs:
Test Class:     
History:
<Date>          <Authors Name>      <Brief Description of Change>
2019-03-13      Andrea Saracini     Creator
------------------------------------------------------------*/
public without sharing class OB_UpdateServicePointCode {
    @AuraEnabled
	public static List<Asset> myOrderItem(String objectDataString){
        Map<String,Object> objectDataMap = (Map<String,Object>)JSON.deserializeUntyped(objectDataString);
        String bpString = JSON.serialize(objectDataMap.get('BillingProfilePOS'));
        String orderString = JSON.serialize(objectDataMap.get('Configuration'));
        String merchantString = JSON.serialize(objectDataMap.get('merchant'));
        String bankString = JSON.serialize(objectDataMap.get('bank'));
        NE__Billing_Profile__c bp = (NE__Billing_Profile__c)JSON.deserialize(bpString, NE__Billing_Profile__c.class);
        NE__Order__c order = (NE__Order__c)JSON.deserialize(orderString, NE__Order__c.class);
        Account merchant = (Account)JSON.deserialize(merchantString, Account.class);
        Account bank = (Account)JSON.deserialize(bankString, Account.class);
        List<Asset> listOfAsset;
        Set<Id> assetIds = new Set<Id>();
        //davide.franzini - 06/09/2019 - WN-369 - START
        listOfAsset = [SELECT NE__Bundle_Configuration__c, 
                                OB_ProposerABI__c 
                        FROM Asset 
                        WHERE AccountId = :merchant.Id 
                            AND NE__Order_Config__r.OB_Business_Model_Acquiring__c = :OB_UtilityConstants.BUSINESSMODEL_BANCARIO    //davide.franzini - WN-584 - 10/10/2019
                            AND OB_ProposerABI__r.OB_ABI__c = :bank.OB_ABI__c 
                            AND NE__Status__c != :OB_UtilityConstants.ASSET_STATUS_DISCONNECTED];    //davide.franzini - WN-605 - 14/10/2019
        //davide.franzini - 06/09/2019 - WN-369 - END
        System.debug('### MODELLO COMMISSIONALE :' + listOfAsset); 
        if(listOfAsset != null && listOfAsset.size()>0){
            for(Asset item : listOfAsset){
                assetIds.add(item.NE__Bundle_Configuration__c);
            }
        }
        System.debug('### NE__Bundle_Configuration__c :' + assetIds); 
        List<Asset> items = new List<Asset>();
        if(assetIds.size()>0){
            //davide.franzini - 06/09/2019 - WN-369 - START
            List<Asset> allAssets = [
                SELECT Id, 
                (
                    SELECT Id, 
                            NE__ProdId__c, 
                            NE__ProdId__r.RecordType.DeveloperName, 
                            NE__Bundle_Configuration__r.Name, 
                            NE__Bundle_Configuration__c, 
                            OB_Conventioncode__c,
                            NE__Status__c, 
                            Name, 
                            OB_ServicePointCode__c, 
                            NE__StartDate__c, 
                            LastModifiedDate, 
                            NE__EndDate__c, 
                            NE__Order_Config__c, 
                            OB_MCC__c, 
                            NE__Bundle__r.Name, 
                            NE__Root_Order_Item__c //davide.franzini - F2WAVE2-145 - 18/07/2019 added offer name
                    FROM  NE__Assets4__r 
                    WHERE NE__ProdId__r.RecordType.DeveloperName = 'Commissione' 
                        AND NE__Parent_Order_Item__c = '' 
                        AND NE__Status__c =: OB_UtilityConstants.STATUS_ACTIVE
                ) 
                FROM Asset 
                WHERE Id IN: (assetIds)
            ];
            System.debug('### COMMISSIONE:' + allAssets);
            //davide.franzini - 06/09/2019 - WN-369 - START
            if(allAssets != null && allAssets.size()>0 ){
                for(Asset item : allAssets){
                    if(item.NE__Assets4__r != null)
                        items.addAll(item.NE__Assets4__r);
                }
            }
        }        
        System.debug('### SERVICE POINT CODE :' + items);                                
		return items;
	}

	/*------------------------------------------------------------
    Author:         Davide Franzini
    Company:        Accenture Technology
    Description:    Inherit acquiring product and pricing component from active offers
    Inputs:         String objectDataString, String sourceConf, String code
    History:
    <Date>          <Authors Name>      <Brief Description of Change>
    ------------------------------------------------------------*/
    @AuraEnabled
	public static String updateConventionalCode(String objectDataString, String sourceConf, String bundleAssetId){//davide.franzini - 06/09/2019 - WN-369 - code parameter Removed
        Map<String,Object> objectDataMap = (Map<String,Object>)JSON.deserializeUntyped(objectDataString);
        String confStr = JSON.serialize(objectDataMap.get('Configuration'));
        NE__Order__c conf = (NE__Order__c)JSON.deserialize(confStr, NE__Order__c.class);
        NE.DataMap mp = new NE.DataMap();
        Map <String , String> result = new map<String,String>();
        Ne.DataMap.DataMapRequest  dReq    =     new Ne.DataMap.DataMapRequest();
        map<String,String>  mapOfQuery  =   new map<String,String>();
        list<String> listOfPlaceholder  =   new list<String>();
        String errorMessage = '';
        String errorCode = '';
        String convCode = '';
        String newBundleId = ''; //davide.franzini 15/10/19 - WN-619 
        //03/07/19 francesca.ribezzi - F2WAVE2-7 - adding pci recordType:
        String pci = OB_UtilityConstants.PRODUCT_RECORDTYPE_PCI;
        //davide.franzini - 09/09/2019 - WN-369 - START
        Set<String> terminalSet = new Set<String>();
        List<NE__OrderItem__c> acqToDelete =    [SELECT Id, 
		                                                NE__ProdId__r.OB_Codice_sfdc__c, 
		                                                OB_Conventioncode__c,
                                                        OB_ServicePointCode__c, //davide.franzini - WN-584 - 09/10/2019
		                                                NE__Root_Order_Item__c 
	                                            FROM NE__OrderItem__c 
	                                            WHERE NE__OrderId__c = :conf.Id
	                                                AND
                                                    (( 
                                                        (NE__ProdId__r.OB_Acquirer__c = :OB_UtilityConstants.PRODUCT_ACQUIRER_NEXI 
		                                                    OR 	NE__Root_Order_Item__r.NE__ProdId__r.OB_Acquirer__c = :OB_UtilityConstants.PRODUCT_ACQUIRER_NEXI  
	                                                    )
	                                                    AND 
                                                        (NE__Root_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName = :OB_UtilityConstants.ACQUIRING_RT 
                                                            OR 	NE__ProdId__r.RecordType.DeveloperName = :OB_UtilityConstants.ACQUIRING_RT
                                                        )
                                                    )
                                                    OR  (NE__Root_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName = :pci
                                                            OR NE__ProdId__r.RecordType.DeveloperName = :pci)
                                                    OR  (NE__Root_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName = :OB_UtilityConstants.PRODUCT_RECORDTYPE_COMMISSIONE
                                                        OR NE__ProdId__r.RecordType.DeveloperName = :OB_UtilityConstants.PRODUCT_RECORDTYPE_COMMISSIONE)
                                                    )
                                                    
                                                ];

        List<NE__OrderItem__c> terminalList = [SELECT Id,
                                                        NE__Bundle_Configuration__c, //davide.franzini 15/10/19 - WN-619 adding NE__Bundle_Configuration__c
                                                        NE__ProdId__r.RecordType.DeveloperName
                                                FROM NE__OrderItem__c 
                                                WHERE NE__OrderId__c = :conf.Id];

        for(NE__OrderItem__c ordIt : terminalList){ 
            Boolean isTerminal = (ordIt.NE__ProdId__r.RecordType.DeveloperName == OB_UtilityConstants.POS_RT || ordIt.NE__ProdId__r.RecordType.DeveloperName == OB_UtilityConstants.PRODUCT_RECORDTYPE_MOTO || ordIt.NE__ProdId__r.RecordType.DeveloperName == 'eCommerce');            if(isTerminal){
                terminalSet.add(ordIt.Id);
                newBundleId = ordIt.NE__Bundle_Configuration__c; //davide.franzini 15/10/19 - WN-619 setting bundle config
            }
        }
        //davide.franzini - 09/09/2019 - WN-369 - END
        
        String customQuery = 'Status__c !=: {!0}';
        listOfPlaceholder.add('Disconnected');
        mapOfQuery.put('StdAsset2Order',customQuery);
        dReq.mapName             =   'StdAsset2Order';
        dReq.sourceId            =   bundleAssetId; 
        dReq.mapOfCustomQueries  =   mapOfQuery;
        dReq.listOfPlaceHolders  =   listOfPlaceholder; 
        NE.DataMap.DataMapResponse dResp = mp.callDataMap(dReq);
                    
        errorMessage    = dResp.ErrorMessage;
        errorCode       = dResp.ErrorCode;
        system.debug('### orderitem cloned');

        //  F2WAVE2-7 Micol Ferrari <micol.ferrari@accenture.com>, 04/07/2019 - START
        if(Test.isRunningTest())
        {
            errorCode = '0';
            dResp.ParentId = conf.Id;
        }
        //  F2WAVE2-7 Micol Ferrari <micol.ferrari@accenture.com>, 04/07/2019 - STOP
 
        if(errorCode.equalsIgnoreCase('0'))
        {
            system.debug('### errorCode: '+errorCode);
            String newOrdId    =   dResp.ParentId;
            //davide.franzini - 06/09/2019 - WN-369 - fields added in SELECT
            List<NE__OrderItem__c> ordItList = [SELECT Id,
                                                        RecordTypeId,
                                                        NE__OrderId__c,
                                                        NE__AssetItemEnterpriseId__c, 
                                                        NE__Root_Order_Item__c, 
                                                        NE__Parent_Order_Item__c,  
                                                        NE__Bundle_Configuration__c, 
                                                        NE__ProdId__r.Name, 
                                                        NE__ProdId__r.RecordType.DeveloperName, 
                                                        NE__Root_Order_Item__r.NE__ProdId__r.Name, 
                                                        NE__Root_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName,
                                                        NE__ProdId__r.OB_Acquirer__c,
                                    					NE__Root_Order_Item__r.NE__ProdId__r.OB_Acquirer__c,
                                                        NE__ProdId__r.OB_Codice_sfdc__c,
                                                        OB_Conventioncode__c,
                                                        OB_ServicePointCode__c //davide.franzini - WN-584 - 09/10/2019
                                                FROM NE__OrderItem__c 
                                                WHERE NE__OrderId__c = :newOrdId];

            if(!ordItList.isEmpty() && ordItList != null)
            {
                 Id acquiringRT = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByName().get('Acquiring').getRecordTypeId();
                //03/07/19 francesca.ribezzi adding pci recordTypeId -F2WAVE2-7 
                Id pciRT = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByName().get('PCI').getRecordTypeId();
                Id pricingRT = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByName().get('Pricing').getRecordTypeId();
                //START francesca.ribezzi 04/07/19 adding nexi and acquiring - F2WAVE2-7 
                String nexi = OB_UtilityConstants.PRODUCT_ACQUIRER_NEXI ;
                String acquiring = OB_UtilityConstants.ACQUIRING_RT;
                //END francesca.ribezzi 04/07/19
                for(NE__OrderItem__c ordIt : ordItList)
                {
                    ordIt.NE__Bundle_Configuration__c = newBundleId; //davide.franzini 15/10/19 - WN-619 setting bundle config  
                    //davide.franzini - 06/09/2019 - WN-369 - getting VisaMastercard convention code
                    if(ordIt.NE__ProdId__r.OB_Codice_sfdc__c == 'VISAMASTERCARD' && String.isBlank(convCode)){
                        convCode = ordIt.OB_ServicePointCode__c; //davide.franzini - WN-584 - 09/10/2019
                    }                   
                    //START francesca.ribezzi 04/07/19 adding pci orderItems - F2WAVE2-7 
                    Boolean isAcqNexi = (ordIt.NE__ProdId__r.OB_Acquirer__c == nexi || ordIt.NE__Root_Order_Item__r.NE__ProdId__r.OB_Acquirer__c == nexi);
                    Boolean isAcq = (ordIt.NE__ProdId__r.RecordType.DeveloperName == acquiring|| ordIt.NE__Root_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName == acquiring);
                    Boolean isPci = (ordIt.NE__ProdId__r.RecordType.DeveloperName == pci || ordIt.NE__Root_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName == pci);
                    //davide.franzini - 09/09/2019 - WN-369 - START
                    Boolean isCommission = ordIt.NE__ProdId__r.RecordType.DeveloperName == OB_UtilityConstants.PRODUCT_RECORDTYPE_COMMISSIONE;
                    Boolean isEnablement = ordIt.NE__Root_Order_Item__c != null && (ordIt.NE__Root_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName == OB_UtilityConstants.PRODUCT_RECORDTYPE_MOTO || ordIt.NE__Root_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName == OB_UtilityConstants.PRODUCT_RECORDTYPE_ECOMMERCE);
                    if((isAcq && isAcqNexi) || isPci || isCommission){
                    //davide.franzini - 09/09/2019 - WN-369 - END
                    //END francesca.ribezzi 04/07/19
                    //Reparenting to running order and assetitementerpriseid cleaning
                        system.debug('### reparenting orderItem');
                        ordIt.NE__OrderId__c = conf.id;
                        ordIt.NE__AssetItemEnterpriseId__c = null;
                        //davide.franzini - 09/09/2019 - WN-369 - START
                        ordIt.NE__Action__c = 'Add';
                        ordIt.NE__Status__c = 'Pending';
                        //davide.franzini - 09/09/2019 - WN-369 - END
                        if(ordIt.NE__Root_Order_Item__c != null && !isEnablement){
                            ordIt.RecordTypeId = pricingRT;
                        //START francesca.ribezzi 04/07/19 - F2WAVE2-7 
                        }else if(isPci){
                            System.debug('pci!');  
                            ordIt.RecordTypeId = pciRT;
                        }else if(isAcq){
                                System.debug('acq!');  
                            ordIt.RecordTypeId = acquiringRT;
                        }
                        //END francesca.ribezzi 04/07/19 - F2WAVE2-7 
                    }   
                }
                //davide.franzini - 09/09/2019 - WN-369 - START
                for(NE__OrderItem__c ordIt : ordItList)
                {
                    system.debug('## enablement reparenting if: '+ordIt);
                    //Start antonio.vatrano wn-551 03/09/2019
                    Boolean isEnablement = ordIt.NE__Root_Order_Item__c != null && 
                                            (ordIt.NE__Root_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName == OB_UtilityConstants.PRODUCT_RECORDTYPE_MOTO || 
                                            ordIt.NE__Root_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName == OB_UtilityConstants.PRODUCT_RECORDTYPE_ECOMMERCE || 
                                            ordIt.NE__Root_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName == OB_UtilityConstants.POS_RT);
                    //End antonio.vatrano wn-551 03/09/2019
                    if(isEnablement){
                        system.debug('## terminalSet: '+terminalSet);
                        for(String cId : terminalSet){
                            ordIt.NE__Root_Order_Item__c = cId;
                            ordIt.NE__Parent_Order_Item__c = cId; //Antonio.vatrano wn-551 04/10/2019
                            system.debug('## reparented ordIt: '+ordIt.Id+' to: '+cId);
                        }
                    }
                }
                //davide.franzini - 09/09/2019 - WN-369 - END
                try{
                    system.debug('### before update newOrderItem');
                    update ordItList;
                    system.debug('### before delete new Order');
                    delete [SELECT Id FROM NE__Order__c WHERE Id = :newOrdId];
                    system.debug('### conf: '+conf);
                    delete acqToDelete;
                    system.debug('### oldAcq deleted');
                }catch(DmlException dmlE){
                    System.debug( 'OB_UpdateServicePointCode - updateConventionalCode - Exception: ' + dmlE.getMessage() + ' [LINE]: ' + dmlE.getLineNumber() );
                }
            }
            
        }

        if(sourceConf != '')
        {
            system.debug('### sourceConf: '+sourceConf); 
            system.debug('### conf.Id: '+conf.Id); 
            NE__Order__c cConf = [SELECT Id, OB_RelatedServicePointCode__c FROM NE__Order__c WHERE Id =: conf.Id];
            system.debug('### cConf: '+cConf); 
            try{
                //davide.franzini - 06/09/2019 - WN-369 - START
                cConf.OB_RelatedServicePointCode__c = convCode;
                update cConf;
                return convCode;
                //davide.franzini - 06/09/2019 - WN-369 - END
            }
            catch(DmlException dmlE){
                System.debug( 'OB_UpdateServicePointCode - updateConventionalCode - Exception: ' + dmlE.getMessage() + ' [LINE]: ' + dmlE.getLineNumber() );
            }
        }
        return null;
	}
}