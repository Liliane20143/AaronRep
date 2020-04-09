public without sharing class OB_OperationalData_CC {

    @AuraEnabled
     public static Map<String,String> getReportTypeValues(){
            Map<String,String> pickListValuesList= new Map<String,String>();
            Schema.DescribeFieldResult fieldResult = NE__Order_Header__c.OB_Report_Type__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry pickListVal : ple){
               pickListValuesList.put(pickListVal.getValue(),pickListVal.getLabel());
                 System.debug('pickListValuesList reportTypes ' + pickListValuesList);
            }
           
            return pickListValuesList;
        } 
    
    @AuraEnabled
    public static Map<String,Object> doInitMethod(String objectDataString){
        Map<String,Object> objectDataMap = (Map<String,Object>) JSON.deserializeUntyped(objectDataString);
        try{
            String configurationString = JSON.serialize(objectDataMap.get('Configuration'));
            System.debug(' CONFIGURATION string :' + configurationString);
            NE__Order__c configuration =(NE__Order__c)JSON.deserialize(configurationString, NE__Order__c.class);
            
            String orderString = JSON.serialize(objectDataMap.get('OrderHeader'));
            System.debug(' orderString string :' + orderString);
            NE__Order_Header__c orderHeader = (NE__Order_Header__c)JSON.deserialize(orderString, NE__Order_Header__c.class);
            
            String bankProfileString = JSON.serialize(objectDataMap.get('bankProfile'));
            System.debug(' bankProfileString string :' + bankProfileString);
            OB_Bank_Profile__c bankProfile = (OB_Bank_Profile__c)JSON.deserialize(bankProfileString, OB_Bank_Profile__c.class);
            System.debug('BANK PROFILE: ' + bankProfile);
            OB_EnrichOrder.orderInfo order   = new OB_EnrichOrder.orderInfo(OB_EnrichOrder.getItemList(configuration.Id));  
            OB_EnrichOrder.associativeCode keyToUse     = OB_EnrichOrder.selectEternalRow(order);
            String extSourceString =JSON.serialize(objectDataMap.get('ExternalAccount'));
            //GIOVANNI SPINELLI 13/12/2018
            System.debug('EXTERNAL SOURCE STRING 1: ' + extSourceString);
            System.debug('OBJECT DATA MAP EXT: ' + objectDataMap.get('externalAccountBackup'));
            if(extSourceString=='null' || String.isBlank(extSourceString) || extSourceString=='[]'){
                System.debug('IF EXTERNAL NULL');
                extSourceString = JSON.serialize(objectDataMap.get('externalAccountBackup'));
            }
            System.debug('EXTERNAL SOURCE STRING 2: ' + extSourceString);
            List<ExternalSourceMapping__c> extSourceMapList = (List<ExternalSourceMapping__c>)JSON.deserialize(extSourceString, List<ExternalSourceMapping__c>.class);
            System.debug('@extSourceMapList : ' + JSON.serialize(extSourceMapList));
            ExternalSourceMapping__c extSourceMap = new ExternalSourceMapping__c();
            Boolean isNEXI = false;
            Boolean isPagoB = false;
            objectDataMap.put('prelimVerifCodeRO',true);
            system.debug('keyToUse::: '+keyToUse);
            //davide.franzini - 24/06/2019 - F2WAVE2-1 - START
            String accString = JSON.serialize(objectDataMap.get('merchant'));
            Account acc = (Account)JSON.deserialize(accString, Account.class);
            Boolean isActiveAcc = false;
            List<Asset> assetForAccount = [SELECT Id 
                                            FROM Asset 
                                            WHERE AccountId = :acc.Id 
                                                AND NE__Status__c != :OB_UtilityConstants.ASSET_STATUS_DISCONNECTED];
            if(assetForAccount.size()>0){
                isActiveAcc = true;
            }
            //davide.franzini - 24/06/2019 - F2WAVE2-1 - END
            //START [10-05-2019 Maintenance Terminal Removed] Andrea Saracini
            List<NE__OrderItem__c> configOrderItems = [SELECT Id,
                                                            RecordType.DeveloperName,
                                                            OB_Report_Type__c,
                                                            NE__ProdId__c,
                                                            NE__ProdId__r.OB_Acquirer__c, 
                                                            NE__Root_Order_Item__c,
                                                            NE__ProdId__r.RecordType.DeveloperName,
                                                            NE__ProdId__r.Name,
                                                            OB_SettlementMethod__c,
                                                            NE__OrderId__r.OB_InternationalSettlementMethod__c,
                                                            NE__OrderId__r.OB_PBSettlementMethod__c,
                                                            NE__ProdId__r.OB_Codice_sfdc__c,
                                                            NE__Action__c, 
                                                            NE__OrderId__r.NE__Order_Header__r.OB_Main_Process__c, //francesca.ribezzi 17/09/19- WN-368- adding main process
                                                            (SELECT Id, 
                                                                    Name, 
                                                                    NE__Value__c,
                                                                    NE__FamPropId__r.NE__Hidden__c
                                                             FROM NE__Order_Item_Attributes__r)
                                                        FROM NE__OrderItem__c 
                                                        WHERE NE__OrderId__c = :configuration.Id];
            //STOP [10-05-2019 Maintenance Terminal Removed] Andrea Saracini
            system.debug('configOrderItems: '+configOrderItems);
            //START [28-03-2019 No Card Present] Andrea Saracini
            objectDataMap.put('isEcommerce',false);
            //STOP [28-03-2019 No Card Present] Andrea Saracini
            List<NE__OrderItem__c> itemsInRemove = new List<NE__OrderItem__c>();//[10-05-2019 Maintenance Terminal Removed] Andrea Saracini
            //START Simone Misani 27/06/2019 Maintenance Acquiring vas and pos Removed and add F2Wave-34
            objectDataMap.put('hasAcquiring','false');
            objectDataMap.put('hasVas','false');
            objectDataMap.put('hasPos','false');
            //END Simone Misani 27/06/2019 Maintenance Acquiring vas and pos Removed and add F2Wave-34
            //START gianluigi.virga 17/07/2019 - BACKLOG-110
			objectDataMap.put('showReportType', false);
			//END gianluigi.virga - BACKLOG-110
            for(NE__OrderItem__c singleOrdIt : configOrderItems){
                //START [28-03-2019 No Card Present] Andrea Saracini
                if(('XPAY_FULL_SOLO_GT'.equals(singleOrdIt.NE__ProdId__r.OB_Codice_sfdc__c) || 'ECOMM_ACQ_EST'.equals(singleOrdIt.NE__ProdId__r.OB_Codice_sfdc__c)) && isActiveAcc){ //davide.franzini - 24/06/2019 - F2WAVE2-1 - changed offer's codiceSfdc and filter on account status added
                //Antonio.vatrano wn 551 02/10/2019
                    objectDataMap.put('isEcommerce',true);
                }
                //STOP [28-03-2019 No Card Present] Andrea Saracini
                //START gianluigi.virga 17/07/2019 - BACKLOG-110
				if(singleOrdIt.RecordType.DeveloperName.equalsIgnoreCase(OB_UtilityConstants.ACQUIRING)){
					objectDataMap.put('showReportType', true);
				}
				//END gianluigi.virga - BACKLOG-110
                //START [10-05-2019 Maintenance Terminal Removed] Andrea Saracini
                 
                if(OB_UtilityConstants.REMOVE_ACTION.equalsIgnoreCase(singleOrdIt.NE__Action__c) && OB_UtilityConstants.POS_RT.equalsIgnoreCase(singleOrdIt.NE__ProdId__r.RecordType.DeveloperName)){
                    itemsInRemove.add(singleOrdIt);
                }
                //STOP [10-05-2019 Maintenance Terminal Removed] Andrea Saracini
                //STArt Simone Misani 27/06/2019 Maintenance Acquiring vas and pos Removed and add F2Wave-34
                if(!OB_UtilityConstants.ORDERITEM_ACTION_NONE.equalsIgnoreCase(singleOrdIt.NE__Action__c) && OB_UtilityConstants.PRODUCT_RECORDTYPE_ACQUIRING.equalsIgnoreCase(singleOrdIt.NE__ProdId__r.RecordType.DeveloperName)&& (singleOrdIt.NE__Root_Order_Item__c != null || singleOrdIt.NE__Root_Order_Item__c != '')){
                        
                        objectDataMap.put('hasAcquiring','true'); 
                    }
                if(!OB_UtilityConstants.ORDERITEM_ACTION_NONE.equalsIgnoreCase(singleOrdIt.NE__Action__c) && OB_UtilityConstants.PRODUCT_RECORDTYPE_VAS.equalsIgnoreCase(singleOrdIt.NE__ProdId__r.RecordType.DeveloperName)&&
                (singleOrdIt.NE__Root_Order_Item__c != null || singleOrdIt.NE__Root_Order_Item__c != '')){
                        
                        objectDataMap.put('hasVas','true');
                    }
                if(!OB_UtilityConstants.ORDERITEM_ACTION_NONE.equalsIgnoreCase(singleOrdIt.NE__Action__c) && OB_UtilityConstants.PRODUCT_RECORDTYPE_VAS.equalsIgnoreCase(singleOrdIt.NE__ProdId__r.RecordType.DeveloperName)
                ){
                        
                        objectDataMap.put('hasPos','true');
                    }
              
                //STOP Simone Misani 27/06/2019 Maintenance Acquiring vas and pos Removed and add F2Wave-34
                  
                }
                //START [10-05-2019 Maintenance Terminal Removed] Andrea Saracini
                if(itemsInRemove != null && !itemsInRemove.isEmpty()){              
                    
                    objectDataMap.put('itemsInRemove', itemsInRemove);
                }
            System.debug('#### objectDataMap: ' + objectDataMap);
            //STOP [10-05-2019 Maintenance Terminal Removed] Andrea Saracini
            System.debug('keyToUse.companyCode: ' + keyToUse.companyCode);
            //START francesca.ribezzi 17/09/19 - WN-360_refix - checking if is setup
            String mainProcess =  configOrderItems.size() > 0 ? configOrderItems[0].NE__OrderId__r.NE__Order_Header__r.OB_Main_Process__c : null;
             System.debug('mainProcess : ' + mainProcess );
            if(OB_UtilityConstants.SETUP.equalsIgnoreCase(mainProcess)){
                  objectDataMap.put('reportTypeRO',false);
                  System.debug('reportTypeRO : ' +   objectDataMap.get('reportTypeRO'));
            //END francesca.ribezzi 17/09/19 - - WN-360_refix - checking if is setup
            }else if(keyToUse.companyCode != null){
                for(ExternalSourceMapping__c extSourceSingle : extSourceMapList){

                    if(extSourceSingle.OB_CustomerCodeClientCode__c == keyToUse.companyCode){
                        extSourceMap = extSourceSingle;
                    }
                }
                orderHeader.OB_Report_Type__c = extSourceMap.OB_ReportType__c;
                configuration.OB_Report_Type__c = extSourceMap.OB_ReportType__c;
                objectDataMap.put('reportTypeRO',true);
            } else {
                //salvare a on change
                /*orderHeader.OB_Report_Type__c = extSourceMap.OB_ReportType__c ;
                configuration.OB_Report_Type__c = extSourceMap.OB_ReportType__c;
                for(NE__OrderItem__c orderItem: configOrderItems){
                    if(orderItem.NE__ProdId__r.OB_Acquirer__c =='NEXI'){
                        orderItem.OB_Report_Type__c = extSourceMap.OB_ReportType__c ;
                    }
                }*/
                objectDataMap.put('reportTypeRO',false);
            }   
            
            //se esistono degli item legati a prodotti con OB_Codice_sfdc__c = POS_TERZI_ATTENDED OR OB_Codice_sfdc__c = POS_TERZI_UNATTENDED) Order Header.OB_PreliminaryVerificationCode__c 
            //deve essere obbligatorio, altrimenti Order Header.OB_PreliminaryVerificationCode__c deve essere read only.
            for(NE__OrderItem__c orderItem: configOrderItems){
                if(orderItem.NE__ProdId__r.OB_Acquirer__c == OB_UtilityConstants.GT_NEXICAPS){
                    isNEXI = true;
                    objectDataMap.put('isNEXI',true);
                }
                if(orderItem.NE__Root_Order_Item__c == null && orderItem.NE__ProdId__r.RecordType.DeveloperName == OB_UtilityConstants.PAGOBANCOMAT){
                    isPagoB=true;
                }
                if(orderItem.NE__ProdId__r.OB_Codice_sfdc__c == OB_UtilityConstants.POS_TERZI_ATTENDED || orderItem.NE__ProdId__r.OB_Codice_sfdc__c == OB_UtilityConstants.POS_TERZI_UNATTENDED){
                    objectDataMap.put('prelimVerifCodeRO',false);
                } 
            }
            if(isNEXI)
            {
                System.debug('IF zero');
                if(keyToUse.servicePointCode != null )
                {
                    System.debug('IF SERVICE POINT ISN T NULL');
                    if(keyToUse.Processor == OB_UtilityConstants.EQUENS && keyToUse.OBInternationalSettlementMethod != null)
                    {
                        System.debug('IF 1');
                        if(bankProfile.OB_Circuit__c.contains(OB_UtilityConstants.PAGOBANCOMAT_BANCARIO))
                        {
                            System.debug('IF 2');
                            configuration.OB_PBSettlementMethod__c = keyToUse.OBPBSettlementMethod;
                        } 
                        else if(bankProfile.OB_Circuit__c.contains(OB_UtilityConstants.PAGOBANCOMAT_SUBLICENZA)) 
                        {
                            System.debug('ELSE IF 2');
                           if(isPagoB)
                           {
                                System.debug('IF 3');
                                objectDataMap.put('viewSettMeth', true);
                                if(keyToUse.OBPBSettlementMethod != null)
                                {
                                    System.debug('IF 4');
                                    objectDataMap.put('settMethRO',true);
                                    configuration.OB_PBSettlementMethod__c = keyToUse.OBPBSettlementMethod;
                                } 
                                else 
                                {
                                    System.debug('ELSE 2');
                                    if(bankProfile.OB_SettlementType__c == OB_UtilityConstants.PREPAGATO){
                                        System.debug('IF 5');
                                        //READONLY valore 'BANCA (ACCREDITO AL LORDO DELLE COMMISSIONI)'            
                                        configuration.OB_PBSettlementMethod__c = Label.OB_PostpaidSettlmentMethodGrossValue;
                                        configuration.OB_InternationalSettlementMethod__c = Label.OB_PostpaidSettlmentMethodGrossValue;
                                        objectDataMap.put('viewSettMeth',true);
                                        objectDataMap.put('settMethRO',true);
                                    } else if(bankProfile.OB_SettlementType__c == OB_UtilityConstants.POSTPAGATO){
                                        System.debug('IF 6');
                                        //Simulo una picklist in pagina con i valori 
                                        //configuration.OB_PBSettlementMethod__c = valore selezionato;
                                        //configuration.OB_InternationalSettlementMethod__c = valore selezionato;
                                        objectDataMap.put('showPicklistPostpagato',true);
                        
                                    }
                                }
                                //configuration.OB_PBSettlementMethod__c = associativeCode.OBPBSettlementMethod;
        
                            } 
                            else {
                                System.debug('IF 7');
                                configuration.OB_PBSettlementMethod__c = keyToUse.OBPBSettlementMethod;
                            }
                        }
                        System.debug('ALWAY IN IF 1');
                        configuration.OB_InternationalSettlementMethod__c =  keyToUse.OBInternationalSettlementMethod;
                        configuration.OB_SettlementType__c = bankProfile.OB_SettlementType__c;
                        objectDataMap.put('interSettMethRO',true);
                    } 
                    else if(keyToUse.Processor == OB_UtilityConstants.SIA)
                    {
                        System.debug('ELSE IF 4');
                        configuration.OB_SettlementType__c = bankProfile.OB_SettlementType__c;
                        if(keyToUse.OBInternationalSettlementMethod != null){
                            objectDataMap.put('interSettMethRO',true);
                            System.debug('IF 7');
                            configuration.OB_PBSettlementMethod__c = keyToUse.OBPBSettlementMethod;
                            configuration.OB_InternationalSettlementMethod__c =  keyToUse.OBInternationalSettlementMethod;
                        } else {
                            if(bankProfile.OB_SettlementType__c == OB_UtilityConstants.PREPAGATO){
                                //READONLY valore 'BANCA (ACCREDITO AL LORDO DELLE COMMISSIONI)'               
                                configuration.OB_PBSettlementMethod__c = Label.OB_PostpaidSettlmentMethodGrossValue;
                                configuration.OB_InternationalSettlementMethod__c = Label.OB_PostpaidSettlmentMethodGrossValue;
                                objectDataMap.put('viewSettMeth',true);
                                objectDataMap.put('settMethRO',true);
                            } else if(bankProfile.OB_SettlementType__c == OB_UtilityConstants.POSTPAGATO){
                                //Simulo una picklist in pagina con i valori ‘NEXI (ACCREDITO AL NETTO DELLE COMMISSIONI)’ e ‘NEXI (ACCREDITO AL LORDO DELLE COMMISSIONI)’ 
                                //configuration.OB_PBSettlementMethod__c = valore selezionato;
                                //configuration.OB_InternationalSettlementMethod__c = valore selezionato;
                                objectDataMap.put('showPicklistPostpagato',true);
                            }
                        }
                    }
                } 
                else 
                {
                    System.debug('ELSE SERVICE POINT IS NULL');
                    configuration.OB_SettlementType__c = bankProfile.OB_SettlementType__c;
                    if(bankProfile.OB_SettlementType__c == OB_UtilityConstants.PREPAGATO){
                        System.debug('IF SERVICE POINT 1');
                        //READONLY valore 'BANCA (ACCREDITO AL LORDO DELLE COMMISSIONI)'            
                        configuration.OB_PBSettlementMethod__c = Label.OB_PostpaidSettlmentMethodGrossValue;
                        configuration.OB_InternationalSettlementMethod__c = Label.OB_PostpaidSettlmentMethodGrossValue;
                        objectDataMap.put('viewSettMeth',true);
                        objectDataMap.put('settMethRO',true);
                    } else if(bankProfile.OB_SettlementType__c == OB_UtilityConstants.POSTPAGATO){
                        System.debug('IF SERVICE POINT 2');
                        //Simulo una picklist in pagina con i valori ‘NEXI (ACCREDITO AL NETTO DELLE COMMISSIONI)’ e ‘NEXI (ACCREDITO AL LORDO DELLE COMMISSIONI)’ 
                        //configuration.OB_PBSettlementMethod__c = valore selezionato;
                        //configuration.OB_InternationalSettlementMethod__c = valore selezionato;
                        objectDataMap.put('showPicklistPostpagato',true);
        
                    }
                }
            }
            objectDataMap.put('Configuration',configuration); 
            objectDataMap.put('OrderHeader',orderHeader);
            objectDataMap.put('ExternalSourceMappingUnique',extSourceMap);
            objectDataMap.put('keyToUse',JSON.serialize((Object)keyToUse));  
            system.debug('Get from odm keyToUse'+objectDataMap.get('keyToUse'));
            system.debug('objectDataMap::: '+JSON.serialize(objectDataMap));
        } catch(Exception ecc){
            System.debug('Generic Error: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
        }
        return objectDataMap;
    }
    
    @AuraEnabled
    public static Map<String,String> callTerminalIdService(Boolean isToGenerate, String orderId, String proposerAbi, String posType, String terminalId, String contractId)
    {
        Map<String,String> terminalIdResult = new Map<String,String>();

        //NEXI-126, Kinga Fornal, kinga.fornal@accenture.com, l2.07.2019, START
        if ( String.isNotBlank( terminalId ) && isToGenerate != null && !isToGenerate && !checkTerminalIdUniqueness( terminalId ) )
        {
            terminalIdResult.put( 'result', Label.OB_TERMINALID_NOT_UNIQUE );
            System.debug( loggingLevel.INFO, 'OB_OperationalData_CC.callTerminalIdService: The requested terminal id is already used.' );
            return terminalIdResult;
        }
        //NEXI-126, Kinga Fornal, kinga.fornal@accenture.com, 12.07.2019 END

        HTTPResponse res = OB_UtilityCallingServices.callTerminalId(isToGenerate,orderId,proposerAbi,posType,terminalId,contractId);
                
        System.debug(res.getBody());
                
            // Parse JSON response to get all the totalPrice field values.
            JSONParser parser = JSON.createParser(res.getBody());
            String name;
            while (parser.nextToken() != null) {
                /*
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                    (parser.getText() == 'terminalId')) {
                    
                    terminalIdResult = parser.getText();
                     // Get the value.
                    parser.nextToken();   
                }*/
              if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)){
                
                    name = parser.getText();
                    parser.nextToken(); 
                    terminalIdResult.put(name,parser.getText());
                }
            }
            //missing error managing    
            return terminalIdResult;
    }
    
    /* START marco.ferri  split of order item of POS */  
    @AuraEnabled
    public static Boolean splitOrderItem2(String idOrder){
     
     List<NE__OrderItem__c> clonedPos = new List<NE__OrderItem__c>();
     List<NE__OrderItem__c> clonedItems = new List<NE__OrderItem__c>();
 
     Map<String,List<NE__Order_Item_Attribute__c>> attributeMap = new  Map<String,List<NE__Order_Item_Attribute__c>>();
     
     List<NE__Order_Item_Attribute__c> attributeMapList = new  List<NE__Order_Item_Attribute__c>();
     
     List<NE__Order_Item_Attribute__c> attributeToInsert = new  List<NE__Order_Item_Attribute__c>();
    
     List<NE__OrderItem__c> posListToClone = [
            SELECT id,RecordType.DeveloperName,MIG_Batch_Id__c,MIG_External_Id__c,MIG_Level_Id__c,MIG_Run_Id__c,Name,NE__Account__c,NE__Action__c,NE__Activation_Date__c,NE__Additional_Information__c,NE__Address_Line1__c,NE__Address_Line2__c,NE__Address_Line3__c,NE__assetItemActionCalc__c,NE__AssetItemEnterpriseCalc__c,NE__AssetItemEnterpriseId__c,NE__assetItemStatusCalc__c,NE__Asset_Item_Account__c,NE__BaseOneTimeFee__c,NE__BaseRecurringCharge__c,NE__BillingProfId__c,NE__Billing_Account_Asset_Item__c,NE__Billing_Account__c,NE__Billing_Description__c,NE__Billing_Profile__c,NE__Bundle_Configuration__c,NE__Bundle_Element__c,NE__Bundle__c,NE__CalculatedVisibility__c,NE__Cart_Description__c,NE__CatalogItem__c,NE__Catalog__c,NE__City__c,NE__Commissioning_cost__c,NE__Commitment_Expiration_Date__c,NE__Commitment_Period__c,NE__Commitment_UOM__c,NE__Commitment__c,NE__Contract__c,NE__Country_Code__c,NE__Country__c,NE__Currency_Extension_1__c,NE__Currency_Extension_2__c,NE__Currency_Extension_3__c,NE__Currency_Extension_4__c,NE__Currency_Extension_5__c,NE__Dated_Base_One_Time_Fee__c,NE__Dated_Recurring_Charge__c,NE__Decimal_Quantity__c,NE__Delivery_Date__c,NE__Description__c,NE__DiscountId__c,NE__Discount_One_time__c,NE__Discount_Perc_OneTimeFee__c,NE__Discount_Perc_RecurringCharge__c,NE__Discount__c,NE__Dynamic_Code__c,NE__EndDate__c,NE__FilterForDataMapNoPromo__c,NE__FilterForDataMapOkPromo__c,NE__FulfilmentStatus__c,NE__Generate_Asset_Item_Calc__c,NE__Generate_Asset_Item__c,NE__Generate_Promo_Asset_Item_Calc__c,NE__Geolocalization__c,NE__Geolocalization__Latitude__s,NE__Geolocalization__Longitude__s,NE__Hidden_in_Cart__c,NE__IsPromo__c,NE__Item_Code__c,NE__Magnitude__c,NE__Multiply_Configuration_Item__c,NE__OneTimeFeeCode__c,NE__OneTimeFeeOv__c,NE__OneTimeFeePb__c,NE__One_Time_Cost__c,NE__One_Time_Tax_Free__c,NE__Optional__c,NE__OrderId__c,NE__OrderItemPromoId__c,NE__Parameters__c,NE__Parent_Logic__c,NE__Parent_Order_Item__c,NE__PenaltyImage__c,NE__Penalty_Activated__c,NE__Penalty_Fee__c,NE__Penalty_Type__c,NE__Penalty__c,NE__Picked_By__c,NE__Postal_Code__c,NE__ProdId__c,NE__ProdName__c,NE__PromotionId__c,NE__Province__c,NE__Qty__c,NE__RecurringChargeCode__c,NE__RecurringChargeFrequency__c,NE__RecurringChargeOv__c,NE__RecurringChargePb__c,NE__Recurring_Charge_Tax_Free__c,NE__Recurring_Cost_Frequency__c,NE__Recurring_Cost__c,NE__Remove_from_total__c,NE__Reservation_code__c,NE__Reservation_date__c,NE__RollbackOneTimeFee__c,NE__RollbackRecurringCharge__c,NE__Root_Order_Item__c,NE__SerialNum__c,NE__Service_Account_Asset_Item__c,NE__Service_Account__c,NE__Service_Point__c,NE__Shipped_Qty__c,NE__SmartPartNumber__c,NE__SmartPart__c,NE__SourceLineItemId__c,NE__SP_Edit__c,NE__StartDate__c,NE__State_Code__c,NE__State__c,NE__Status__c,NE__Street__c,NE__Tax_for_Canal__c,NE__Tax_Models_Applied__c,NE__Test_Prezzi__c,NE__Text_Extension_1__c,NE__Text_Extension_2__c,NE__Text_Extension_3__c,NE__Text_Extension_4__c,NE__Text_Extension_5__c,NE__UnitCreditCode__c,NE__UnitCreditDescription__c,NE__UsageCode__c,NE__UsageDescription__c,NE__Zip_Code__c,OB_BankAccount_Debit_Acquiring__c,OB_Billing_Profile_Credit_Acquiring__c,OB_CedacriProfId__c,OB_CommercialName__c,OB_CompanyCode__c,OB_Conventioncode__c,OB_CustomerCode__c,OB_DebitProfId__c,OB_Description__c,OB_enablement__c,OB_GT__c,OB_MCC_Description__c,OB_MCC__c,OB_Processor__c,OB_ProposerABI__c,OB_ReceiptCity__c,OB_ReceiptHeader__c,OB_Report_Type__c,OB_Ro__c,OB_Sequence__c,OB_ServicePointCode__c,OB_ServicePointType__c,OB_SettlementMethod__c,OB_SettlementType__c,OB_ShopCode__c,OB_ShopSign__c,OB_TermId__c,OB_Visible__c,
            (SELECT id,RecordType.DeveloperName,MIG_Batch_Id__c,MIG_External_Id__c,MIG_Level_Id__c,MIG_Run_Id__c,Name,NE__Account__c,NE__Action__c,NE__Activation_Date__c,NE__Additional_Information__c,NE__Address_Line1__c,NE__Address_Line2__c,NE__Address_Line3__c,NE__assetItemActionCalc__c,NE__AssetItemEnterpriseCalc__c,NE__AssetItemEnterpriseId__c,NE__assetItemStatusCalc__c,NE__Asset_Item_Account__c,NE__BaseOneTimeFee__c,NE__BaseRecurringCharge__c,NE__BillingProfId__c,NE__Billing_Account_Asset_Item__c,NE__Billing_Account__c,NE__Billing_Description__c,NE__Billing_Profile__c,NE__Bundle_Configuration__c,NE__Bundle_Element__c,NE__Bundle__c,NE__CalculatedVisibility__c,NE__Cart_Description__c,NE__CatalogItem__c,NE__Catalog__c,NE__City__c,NE__Commissioning_cost__c,NE__Commitment_Expiration_Date__c,NE__Commitment_Period__c,NE__Commitment_UOM__c,NE__Commitment__c,NE__Contract__c,NE__Country_Code__c,NE__Country__c,NE__Currency_Extension_1__c,NE__Currency_Extension_2__c,NE__Currency_Extension_3__c,NE__Currency_Extension_4__c,NE__Currency_Extension_5__c,NE__Dated_Base_One_Time_Fee__c,NE__Dated_Recurring_Charge__c,NE__Decimal_Quantity__c,NE__Delivery_Date__c,NE__Description__c,NE__DiscountId__c,NE__Discount_One_time__c,NE__Discount_Perc_OneTimeFee__c,NE__Discount_Perc_RecurringCharge__c,NE__Discount__c,NE__Dynamic_Code__c,NE__EndDate__c,NE__FilterForDataMapNoPromo__c,NE__FilterForDataMapOkPromo__c,NE__FulfilmentStatus__c,NE__Generate_Asset_Item_Calc__c,NE__Generate_Asset_Item__c,NE__Generate_Promo_Asset_Item_Calc__c,NE__Geolocalization__c,NE__Geolocalization__Latitude__s,NE__Geolocalization__Longitude__s,NE__Hidden_in_Cart__c,NE__IsPromo__c,NE__Item_Code__c,NE__Magnitude__c,NE__Multiply_Configuration_Item__c,NE__OneTimeFeeCode__c,NE__OneTimeFeeOv__c,NE__OneTimeFeePb__c,NE__One_Time_Cost__c,NE__One_Time_Tax_Free__c,NE__Optional__c,NE__OrderId__c,NE__OrderItemPromoId__c,NE__Parameters__c,NE__Parent_Logic__c,NE__Parent_Order_Item__c,NE__PenaltyImage__c,NE__Penalty_Activated__c,NE__Penalty_Fee__c,NE__Penalty_Type__c,NE__Penalty__c,NE__Picked_By__c,NE__Postal_Code__c,NE__ProdId__c,NE__ProdName__c,NE__PromotionId__c,NE__Province__c,NE__Qty__c,NE__RecurringChargeCode__c,NE__RecurringChargeFrequency__c,NE__RecurringChargeOv__c,NE__RecurringChargePb__c,NE__Recurring_Charge_Tax_Free__c,NE__Recurring_Cost_Frequency__c,NE__Recurring_Cost__c,NE__Remove_from_total__c,NE__Reservation_code__c,NE__Reservation_date__c,NE__RollbackOneTimeFee__c,NE__RollbackRecurringCharge__c,NE__Root_Order_Item__c,NE__SerialNum__c,NE__Service_Account_Asset_Item__c,NE__Service_Account__c,NE__Service_Point__c,NE__Shipped_Qty__c,NE__SmartPartNumber__c,NE__SmartPart__c,NE__SourceLineItemId__c,NE__SP_Edit__c,NE__StartDate__c,NE__State_Code__c,NE__State__c,NE__Status__c,NE__Street__c,NE__Tax_for_Canal__c,NE__Tax_Models_Applied__c,NE__Test_Prezzi__c,NE__Text_Extension_1__c,NE__Text_Extension_2__c,NE__Text_Extension_3__c,NE__Text_Extension_4__c,NE__Text_Extension_5__c,NE__UnitCreditCode__c,NE__UnitCreditDescription__c,NE__UsageCode__c,NE__UsageDescription__c,NE__Zip_Code__c,OB_BankAccount_Debit_Acquiring__c,OB_Billing_Profile_Credit_Acquiring__c,OB_CedacriProfId__c,OB_CommercialName__c,OB_CompanyCode__c,OB_Conventioncode__c,OB_CustomerCode__c,OB_DebitProfId__c,OB_Description__c,OB_enablement__c,OB_GT__c,OB_MCC_Description__c,OB_MCC__c,OB_Processor__c,OB_ProposerABI__c,OB_ReceiptCity__c,OB_ReceiptHeader__c,OB_Report_Type__c,OB_Ro__c,OB_Sequence__c,OB_ServicePointCode__c,OB_ServicePointType__c,OB_SettlementMethod__c,OB_SettlementType__c,OB_ShopCode__c,OB_ShopSign__c,OB_TermId__c,OB_Visible__c from NE__Parent_Order_Item__r) 
            FROM NE__OrderItem__c
            WHERE NE__OrderId__c = :idOrder 
            AND RecordType.DeveloperName = 'Terminali'
            AND NE__Qty__c > 1.0
            AND NE__Parent_Order_Item__c = null ];
        System.debug('posListToClone size: ' + posListToClone.size());
        if(posListToClone.size() == 0){

            return true;
        }
     //List of all attribute of the order
     List<NE__Order_Item_Attribute__c> posListAttributes = [
        SELECT MIG_Batch_Id__c,MIG_External_Id__c,MIG_Level_Id__c,MIG_Run_Id__c,Name,NE__Action__c,NE__AttrEnterpriseIdCalc__c,NE__AttrEnterpriseId__c,NE__FamPropExtId__c,NE__FamPropId__c,NE__Old_Value__c,NE__Order_Item__c,NE__Previous_Attribute_Value__c,NE__Value__c,OB_Attribute_Code__c,OB_Massimale__c,OB_Max_Absolute__c,OB_Max_Threshold__c,OB_MIn_Absolute__c,OB_Min_Threshold__c 
        FROM NE__Order_Item_Attribute__c
        WHERE NE__Order_Item__r.NE__OrderId__c = :idOrder 
     ];
     System.debug('posListAttributes size: ' + posListAttributes.size());

        for(NE__Order_Item_Attribute__c attToMap :posListAttributes){
            List<NE__Order_Item_Attribute__c> tmp = new List<NE__Order_Item_Attribute__c>();
            if(attributeMap.containskey(attToMap.NE__Order_Item__c)){
                    tmp = attributeMap.get(attToMap.NE__Order_Item__c);
            }       
                    tmp.add(attToMap);
                    attributeMap.put(attToMap.NE__Order_Item__c,tmp);
        }
                
     //NE__Configuration_item_update_key__c, deleted from query temp

        for(NE__OrderItem__c posToClone:posListToClone){
            //always remove the original or we clone twice the size we want
            Integer iterations = posToClone.NE__Qty__c.intValue()-1;

            for(Integer i=0;i < iterations; i++ ){
                NE__OrderItem__c clonedRoot = posToClone.clone(false,true,false,false);
                clonedRoot.NE__Qty__c = 1.0;
                //String childExtKey = generateExternalId(posToClone.NE__Item_Code__c+Math.random());
                //System.debug('childExtKey '+childExtKey);
                //clonedRoot.NE__Configuration_item_update_key__c = posToClone.id+'_'+childExtKey;
                clonedRoot.NE__Item_Code__c = posToClone.id+'_'+generateExternalId(''+Math.random());
                insert clonedRoot ; //Impossible to avoid DML in for loop -- tread carefully
                clonedItems.add(clonedRoot);
                
                for(NE__OrderItem__c childsToClone: posToClone.NE__Parent_Order_Item__r){
                    System.debug('childsToClone: ' + childsToClone);
                    System.debug('@@@childItem: '+childsToClone.NE__ProdName__c);
                    NE__OrderItem__c clonedChild = childsToClone.clone(false,true,false,false);
                        //System.debug('clonedChild: ' + clonedChild);
                    //clonedChild.NE__Configuration_item_update_key__c = childsToClone.Id+'_'+generateExternalId(posToClone.NE__Item_Code__c+Math.random());
                    clonedChild.NE__Parent_Order_Item__c = clonedRoot.Id;
                    clonedChild.NE__Root_Order_Item__c = clonedRoot.Id;
                    clonedChild.NE__Item_Code__c = childsToClone.Id+'_'+generateExternalId(''+Math.random());
                    System.debug('clonedChild.NE__Parent_Order_Item__c: ' + clonedChild.NE__Parent_Order_Item__c);
                    System.debug('clonedChild.NE__Root_Order_Item__c: ' + clonedChild.NE__Root_Order_Item__c);
                    System.debug('clonedChild.NE__Item_Code__c: ' + clonedChild.NE__Item_Code__c);
                    clonedPos.add(clonedChild);
                    
                }
            }
            posToClone.NE__Qty__c = 1.0;
        }

        try{    
            insert clonedPos;
            clonedItems.addAll(clonedPos);
            update posListToClone;
            
             for(NE__OrderItem__c posChildClonedToAddAtt : clonedItems){
                String s = posChildClonedToAddAtt.NE__Item_Code__c.left(posChildClonedToAddAtt.NE__Item_Code__c.indexOf('_'));
                 System.debug('Id item ' +s);
                if(attributeMap.containsKey(s)){
                    for(NE__Order_Item_Attribute__c AttToClone : attributeMap.get(s)){
                                System.debug('AttToClone '+AttToClone);
                                NE__Order_Item_Attribute__c attCloned = attToClone.clone(false,true,false,false);
                                attCloned.NE__Order_Item__c = posChildClonedToAddAtt.id;
                                attributeToInsert.add(attCloned);
                        }
                }       
             }  
             
             insert attributeToInsert;
            
        }
        catch(Exception e){
            
            System.debug('Exception in OB_Operational_Data_CC::splitOrderItem2 '+e.getMessage()+' at line '+e.getLineNumber());
            return false;
        }
        return true;
    }
    /* END marco.ferri  split of order item of POS */
    
    /* START marco.ferri  enrich order method wrapper */     
    @AuraEnabled
    public static Boolean enrichOrderWrapper(String idOrder){
        System.debug('CALL ENRICH ORDER');
        Boolean resp=false;
        try{
            resp = OB_EnrichOrder.setConfigurationInformation((idOrder));
        }catch(Exception e){
            
            System.debug('Exception in enrichOrderWrapper: '+e.getMessage()+' at line '+e.getLineNumber());
            
        }
         
        
        return resp;
    }    
    /* END marco.ferri  enrich order method wrapper */  
    
    /* START    micol.ferrari 01/10/2018 - CREATION OF BILLING PROFILES */
    @AuraEnabled
    public static Map<String,Object> insertBillingProfilesUpdateOrderHeader(String objectDataString, String merchantId, String actualBankId, Boolean isCheckout)
    {
        //19/02/19 francesca.ribezzi adding new boolean isCheckout
        //17/07/19     francesca.ribezzi - isCheckout conditions deleted - performance changes
        Map<String,Object> objectDataMap = new Map<String,Object>();    
        try
        {
            //  FROM STRING TO OBJECT           
            objectDataMap = (Map<String,Object>) JSON.deserializeUntyped(objectDataString);

            //NEXI-315 Kinga Fornal <kinga.fornal@accenutre.com>, 09/09/2019 START
            Boolean isOperation = false;
            if ( !objectDataMap.isEmpty( ) && objectDataMap.get( 'isOperation' ) != null )
            {
                isOperation = Boolean.valueOf( objectDataMap.get( 'isOperation' ) );
            }
            //NEXI-315 Kinga Fornal <kinga.fornal@accenutre.com>, 09/09/2019 END
            
            Boolean isError = false;
            Object errorDateMapObject = objectDataMap.get('errorDateMap');
            system.debug('errorDateMapObject::'+errorDateMapObject);
            Map<String,Object> mappaErrorDate = (Map<String,Object>)JSON.deserializeUntyped(JSON.serialize(errorDateMapObject));
            if(mappaErrorDate!= null){
                for(String key:mappaErrorDate.keySet()){
                    if( (Boolean)(mappaErrorDate.get(key))){
                        isError=true;
                    }
                }
            }
            
            //check IBAN 
            if( objectDataMap.get('isIbanValid') == 'false' || objectDataMap.get('isIbanValid') == false  ){
                isError=true;    
            }
            
            //  CHECK MANDATORY FIELDS
            if((OB_MandatoryFormalCheck.inputCheck(objectDataMap,'operationalData')).size() >=1 || isError)
            {
                objectDataMap.put('checkMapValuesoperationalData',OB_MandatoryFormalCheck.inputCheck(objectDataMap,'operationalData'));
                objectDataMap.put('setRedBorderoperationalData',true);
                objectDataMap.put('confirmOperationalData',false);
                System.debug('OB_OperationalData_CC.insertBillingProfilesUpdateOrderHeader - setRedBorder '+ objectDataMap.get('setRedBorder'));

                System.debug('OB_OperationalData_CC.insertBillingProfilesUpdateOrderHeader - CHECK MANDATORY FIELD KO');
            }
            else
            {
                System.debug('OB_OperationalData_CC.insertBillingProfilesUpdateOrderHeader - CHECK MANDATORY FIELD OK');
                //  UPDATE ORDER HEADER
                NE__Order_Header__c contextOrderHeader      = new NE__Order_Header__c();
                contextOrderHeader                          = (NE__Order_Header__c)JSON.deserialize(JSON.serialize(objectDataMap.get('OrderHeader')), NE__Order_Header__c.class);
                System.debug('contextOrderHeader; ' + contextOrderHeader);
                update contextOrderHeader;
                System.debug('OB_OperationalData_CC.insertBillingProfilesUpdateOrderHeader - contextOrderHeader');
                System.debug(contextOrderHeader);

                //  RETRIEVE BOTH BILLING PROFILES TO INSERT
                List<NE__Billing_Profile__c> listOfBillingProfilesToInsert  = new List<NE__Billing_Profile__c>();
                NE__Billing_Profile__c billProfilePOS                       = new NE__Billing_Profile__c();
                NE__Billing_Profile__c billProfileAcquiring                 = new NE__Billing_Profile__c();

                billProfilePOS                                      = (NE__Billing_Profile__c)JSON.deserialize(JSON.serialize(objectDataMap.get('BillingProfilePOS')), NE__Billing_Profile__c.class);
                billProfilePOS.NE__Account__c                       = merchantId;
                billProfilePOS.OB_Bank_Account_Owner__c             = actualBankId;
                billProfilePOS.Id                                   = null;
                billProfileAcquiring                                = (NE__Billing_Profile__c)JSON.deserialize(JSON.serialize(objectDataMap.get('BillingProfileAcquiring')), NE__Billing_Profile__c.class);
                billProfileAcquiring.NE__Account__c                 = merchantId;
                billProfileAcquiring.OB_Bank_Account_Owner__c       = actualBankId;
                billProfileAcquiring.Id                             = null;     

                //  START   micol.ferrari 17/10/2018 - BYPASS VALIDATION
                billProfilePOS.OB_BypassValidation__c               = true;   
                billProfileAcquiring.OB_BypassValidation__c         = true;   
                //  END     micol.ferrari 17/10/2018 - BYPASS VALIDATION

                System.debug('OB_OperationalData_CC.insertBillingProfilesUpdateOrderHeader - billProfilePOS');
                System.debug(billProfilePOS);
                System.debug('OB_OperationalData_CC.insertBillingProfilesUpdateOrderHeader - billProfileAcquiring');
                System.debug(billProfileAcquiring);

                listOfBillingProfilesToInsert.add(billProfilePOS);
                listOfBillingProfilesToInsert.add(billProfileAcquiring);
                insert listOfBillingProfilesToInsert;
                objectDataMap.put('BillingProfilePOS',billProfilePOS);
                objectDataMap.put('BillingProfileAcquiring',billProfileAcquiring);

                System.debug('@@@@ OD after BP insert on it: ' + JSON.serialize(objectDataMap));
                
                
                //UPDATE ORDER
                billProfilePOS = (NE__Billing_Profile__c)JSON.deserialize(JSON.serialize(objectDataMap.get('BillingProfilePOS')), NE__Billing_Profile__c.class);
                billProfileAcquiring = (NE__Billing_Profile__c)JSON.deserialize(JSON.serialize(objectDataMap.get('BillingProfileAcquiring')), NE__Billing_Profile__c.class);
                NE__Order__c contextOrder = new NE__Order__c();
                system.debug('config string:: '+JSON.serialize(objectDataMap.get('Configuration')));
                contextOrder = (NE__Order__c)JSON.deserialize(JSON.serialize(objectDataMap.get('Configuration')), NE__Order__c.class);
                contextOrder.NE__BillingProfId__c = billProfilePOS.Id;
                contextOrder.OB_BankAccount_Acquiring__c = billProfileAcquiring.Id;

                //NEXI-315 Kinga Fornal <kinga.fornal@accenutre.com>, 09/09/2019 START
                if ( isOperation && String.isNotBlank( billProfilePOS.OB_CABCode__c ) )
                {
                    contextOrder.OB_CAB__c = billProfilePOS.OB_CABCode__c;
                    contextOrderHeader.OB_CAB__c = billProfilePOS.OB_CABCode__c;
                    update contextOrderHeader;
                }
                //NEXI-315 Kinga Fornal <kinga.fornal@accenutre.com>, 09/09/2019 END

                update contextOrder;
                objectDataMap.put('Configuration',contextOrder);
                
                //UPDATE ORDER ITEM
                //STAT Andrea Saracini 8/05/2019 - BillingProfile Query
                List<NE__OrderItem__c> contextOrderItems = [SELECT Id,
                                                                NE__ProdId__r.RecordType.DeveloperName,
                                                                NE__OrderId__r.OB_SettlementType__c,
                                                                NE__OrderId__r.OB_InternationalSettlementMethod__c,
                                                                NE__OrderId__r.OB_PBSettlementMethod__c,
                                                                NE__ProdId__r.OB_Acquirer__c,
                                                                RecordType.DeveloperName,
                                                                OB_Report_Type__c,
                                                                OB_SettlementType__c,
                                                                NE__BillingProfId__c,
                                                                OB_DebitProfId__c,
                                                                OB_SettlementMethod__c,
                                                                OB_Billing_Profile_Credit_Acquiring__c,
                                                                OB_BankAccount_Debit_Acquiring__c 
                                                            FROM NE__OrderItem__c 
                                                            WHERE NE__OrderId__c = :contextOrder.Id 
                                                                AND (RecordType.DeveloperName = 'Terminali' OR RecordType.DeveloperName = 'Acquiring') ];
                //STOP Andrea Saracini 8/05/2019 - BillingProfile Query
                for(NE__OrderItem__c orderItem : contextOrderItems){
                    if(orderItem.RecordType.DeveloperName == 'Terminali'){
                        orderItem.NE__BillingProfId__c = billProfilePOS.Id;
                        orderItem.OB_DebitProfId__c = billProfilePOS.Id;
                    } 
                    else{ 
                        orderItem.OB_Billing_Profile_Credit_Acquiring__c = billProfileAcquiring.Id;
                        orderItem.OB_BankAccount_Debit_Acquiring__c = billProfileAcquiring.Id;
                    }   
                    if(orderItem.NE__ProdId__r.RecordType.DeveloperName == OB_UtilityConstants.ACQUIRING){
                        orderItem.OB_SettlementMethod__c = orderItem.NE__OrderId__r.OB_InternationalSettlementMethod__c;
                    }
                    else if(orderItem.NE__ProdId__r.RecordType.DeveloperName == OB_UtilityConstants.PAGOBANCOMAT){
                        orderItem.OB_SettlementMethod__c = orderItem.NE__OrderId__r.OB_PBSettlementMethod__c;
                    }   
                    if(orderItem.NE__ProdId__r.OB_Acquirer__c =='NEXI'){
                        orderItem.OB_Report_Type__c = contextOrderHeader.OB_Report_Type__c;
                    }
                    orderItem.OB_SettlementType__c = orderItem.NE__OrderId__r.OB_SettlementType__c;
                }
                update contextOrderItems;
                //************************************************************
                
                objectDataMap.put('confirmOperationalData',true);
                objectDataMap.put('setRedBorderoperationalData',false);

            }
        }
        catch(Exception ecc)
        {
            System.debug('[EXCE] OB_OperationalData_CC.insertBillingProfilesUpdateOrderHeader '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
        }

        System.debug('OB_OperationalData_CC.insertBillingProfilesUpdateOrderHeader - BEFORE RETURN objectDataMap '+objectDataMap);
        return objectDataMap;
    }
    /* END      micol.ferrari 01/10/2018 - CREATION OF BILLING PROFILES */
    
    //francesca.ribezzi calling static method from OB_EnrichOrder class:
    @AuraEnabled
    public static Boolean callConfigurationInfoServer(Id confId)
    {
        System.debug('into callConfigurationInfoServer - calling  OB_EnrichOrder class method setConfigurationInformation...');
        Boolean isSet = OB_EnrichOrder.setConfigurationInformation(confId); 
        return isSet;
    }
    
    /* START     marco.ferri method to create a unique key */
    private static String generateExternalId(String s){
    
        Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(s));
        String uniqueString = EncodingUtil.convertToHex(hash).substring(0,20);
        
        return uniqueString;
    }
    /* END marco.ferri */
        @AuraEnabled
    public static List<Object> createCartListFromMapLight(String orderId, Boolean isPricing){
 		
		Id inputId = (Id) orderId;
        String sobjectType = inputId.getSObjectType().getDescribe().getName();

        if(sobjectType == 'NE__Order__c'){
            //START francesca.ribezzi 28/11/19 calling createMapFromOrder to retrive cart info
            Map<String,String> mapFromOrder= createMapFromOrder(inputId, isPricing);  // antonio.vatrano 11/12/2019 change name
            if(mapFromOrder  == null){
                return null;
            }
            //END francesca.ribezzi 28/11/19
            return (List<Object>) mapFromOrder.values();
        }
        else{ 
            
            Map<String,String> mapFromAsset = createMapFromAsset(inputId); 
            return  (List<Object>) mapFromAsset.values();
        }
    }

    @AuraEnabled
    public static Map<Integer,Object> createCartListFromMap(String orderId){     
        
        Map<Integer,Map<String,Object>> toReturn 	= new Map<Integer,Map<String,Object>>();
        List<String> objLisToMap 					= new List<String>();
		Map<String,List<Object>> childItems 		= new Map<String,List<Object>>();
		
		Id inputId = (Id) orderId;
        String sobjectType = inputId.getSObjectType().getDescribe().getName();

        if(sobjectType == 'NE__Order__c'){

            String userLang;
            String userLanguage = UserInfo.getLanguage();
            
            for(PicklistEntry value: User.LanguageLocalekey.getDescribe().getPicklistValues())
            {
                if(value.getValue() == userLanguage) 
                {
                    userLang = value.getLabel();
                    break;
                }
            }

            system.debug ('## ' + userLang);
            NE.b2wgin_DataRetrieve.loadB2WginInputFromExistingConfigurationRequest loadRequest = new NE.b2wgin_DataRetrieve.loadB2WginInputFromExistingConfigurationRequest();
            loadRequest.configurationId     =      orderId;
            loadRequest.language            =      userLang;
    
            NE.b2wgin_DataRetrieve.loadB2WginInputFromExistingConfigurationResponse loadResponde = NE.b2wgin_DataRetrieve.loadB2WginInputFromExistingConfiguration(loadRequest);

            objLisToMap = loadResponde.elementsToAssert.values();
        }
        else{ 
            
            Map<String,String> mapFromAsset = createMapFromAsset(inputId); 
            objLisToMap = mapFromAsset.values();
        }
        
		Integer index 	= 0;
		while (0 < objLisToMap.size())
		{
            Integer j = objLisToMap.size()-1;

			Object cartItem = JSON.deserializeUntyped(objLisToMap.get(j));
			objLisToMap.remove(j);

			Map<String,Object> objToCheck = (Map<String,Object>) cartItem; 
			Map<String,Object> itemFields = (Map<String, Object>) objToCheck.get('fields'); 
			
			if(itemFields.get('parent') != null)
			{
				String key = (String) itemFields.get('parentvid');
				List<Object> childItemsObj = childItems.get(key);
				if(childItemsObj == null)
				{
					childItemsObj = new List<Object>();
				}
				childItemsObj.add(cartItem);
				childItems.put(key,childItemsObj);
			}
			else{
				toReturn.put(index,objToCheck);
				index++;
			}				

		}

        for(Map<String,Object> parentItems : toReturn.values())
        {
            Map<String,Object> parentItemFields = (Map<String, Object>) parentItems.get('fields');
            List<Object> parentChildItems 		= (List<Object>) parentItems.get('childItems');
            
            String parentVid = (String) parentItemFields.get('vid');
            if(childItems.get(parentVid) != null)
            { 
                List<Object> childItemsToAdd = childItems.remove(parentVid);
                parentChildItems.addAll(childItemsToAdd);
            }
            
        }
		return toReturn;
	}
	
    /*******************************************************************************
    Purpose: this method is used to retrive cart info from offer asset id
    Parameters: offer asset id
    Returns: Map<String,String> 
    History: -
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         ?                         ?             Created             -
    2.0         Francesca Ribezzi      28/11/2019       Edit            Performance - matrix parameter row logic deleted 
    2.1         Francesca Ribezzi      29/11/2019       Edit            Performance - attachment deleted - using wrapper obj */
	@testVisible
	private static Map<String,String> createMapFromAsset(Id idOfferta){   
		 
		Map<String,String> outputMap = new Map<String,String>();
        List<Asset> assetList = [SELECT 	Id,
                                            
                                            NE__ProdId__r.RecordType.DeveloperName, 
                                            NE__ProdId__r.Name,
                                            NE__StartDate__c,
                                            NE__EndDate__c,
                                            NE__CatalogItem__c,
                                            NE__Parent_Order_Item__c,
                                            OB_model__c,ob_release__c,
                                            OB_linktype__c,
                                            OB_modeldescription__c,
                                            OB_releasedescription__c,
                                            OB_linkdescription__c,
                                            OB_companycode__c,
                                            OB_processor__c,
                                            OB_servicepointcode__c,
                                            OB_servicepointtype__c,
                                            OB_shopcode__c,
                                            OB_customercode__c, 
                                            OB_ro__c, 
                                            OB_enablement__c,
                                            OB_visible__c,ob_description__c,
                                            OB_proposerabi__c,
                                            OB_cedacriprofid__c,
                                            OB_commercialname__c,
                                            OB_mcc_description__c,
                                            OB_mccl2__c,
                                            OB_mcc__c,
                                            OB_receiptcity__c,
                                            OB_receiptheader__c,
                                            OB_report_type__c,
                                            OB_settlementmethod__c,
                                            OB_settlementtype__c,
                                            OB_shopsign__c,
                                            OB_termid__c,
                                            OB_debitprofid__c,
                                            OB_gt__c,
                                            MIG_batch_id__c,
                                            MIG_external_id__c,
                                            MIG_level_id__c,
                                            MIG_run_id__c,
                                            ob_sequence__c,
                                            ob_conventioncode__c,
                                            NE__Item_Code__c, 
                                            NE__Parent_Order_Item__r.NE__Item_Code__c,
                                            NE__Root_Order_Item__r.NE__Item_Code__c,
                                            NE__CatalogItem__r.NE__Parent_Catalog_Item__c,
                                            NE__CatalogItem__r.NE__Type__c,
                                            NE__Action__c,
                                            NE__Status__c,
                                            AccountId,
                                            NE__Service_Account__c,
                                            NE__Billing_Account__c,
                                            NE__BillingProf__c,
                                            NE__Catalog__c,
                                            NE__ProdId__c,
                                            NE__CatalogItem__r.NE__Configuration_Type__c,
                                            NE__CatalogItem__r.NE__Hidden_in_Cart__c,
                                            NE__Picked_By__c,
                                            NE__RecurringChargeFrequency__c,
                                            NE__Bundle__c, 
                                            NE__Bundle_element__c,
                                            NE__Bundle_Configuration__r.NE__Item_Code__c, 
                                            NE__Parent_Logic__r.NE__Item_Code__c, 
                                            NE__AssetItemEnterpriseId__c,NE__ProdId__r.OB_Codice_sfdc__c, 
                                            NE__ProdId__r.OB_CommercialBundle__c,
                                            NE__Order_Config__r.OB_FulfilmentStatus__c,
                                            NE__Order_Config__r.OB_AgreedChanges__c,
                                            NE__Order_Config__r.OB_Variation__c,
                                            NE__Order_Config__r.NE__Order_Header__r.OB_Sub_Process__c,
                                            OB_StartValidationDate__c,
                                            CreatedBy.OB_DataMigration__c,
                                            NE__FulfilmentStatus__c, 
                                            NE__CatalogItem__r.NE__Visible__c,
                                            NE__Order_Config__r.NE__Type__c, 
                                                (SELECT Id,
                                                        OB_massimale__c,
                                                        OB_max_absolute__c,
                                                        OB_max_threshold__c,
                                                        OB_min_absolute__c,
                                                        OB_attribute_code__c,
                                                        NE__attrenterpriseid__c,
                                                        NE__old_value__c,
                                                        NE__value__c,
                                                        Name,
                                                        OB_min_threshold__c,
                                                        NE__FamPropId__c,
                                                        NE__FamPropId__r.NE__ReadOnly__c,
                                                        NE__FamPropId__r.NE__FamilyId__c,
                                                        NE__FamPropId__r.NE__PropId__c,
                                                        NE__FamPropId__r.NE__FamilyPropertyCode__c  
                                                    FROM NE__AssetItemAttributes__r
                                                    WHERE ob_attribute_code__c != null) 
                                            FROM Asset 
                                            WHERE NE__Bundle_Configuration__c = :idOfferta
                                            AND NE__Status__c != :OB_UtilityConstants.ASSET_STATUS_DISCONNECTED	//Andrea Saracini 12/06/2019 R1F2-164
                                            //antonio.vatrano 17-04-2019 change variable
                                                AND (OB_StartValidationDate__c <=:System.today()
                                                OR 	NE__StartDate__c <= :System.today() ) // antonio.vatrano ri-28 02-05-2019 add where condition
                                            ORDER BY OB_StartValidationDate__c 
                                            DESC ];
                                            //NE__StartDate__c <= TODAY
        /*Andrea.morittu end 10/04/2019: */
        /*Andrea.morittu start 10/04/2019: --> calling a method for 
        */
    // shaghayegh.tofighian R1F2-117 15/05/2019 removed for new method
        /*Andrea.morittu start 10/04/2019: */
        if(assetList.size() == 0){
            return null;
        }
        //  START shaghayegh.tofighian 15/05/2019 R1F2-117
        //  START antonio.vatrano 17/05/2019 R1F2-117 change input to method
        String offerConfig = assetList[0].NE__Order_Config__c;
        boolean firstSubcription = checkChangeOrderServer(offerConfig);
        //  END antonio.vatrano 17/05/2019 R1F2-117 change input to method
        //  END shaghayegh.tofighian 15/05/2019 R1F2-117                                                                                                                                                                                                          
    
        List<Asset> assetNeActionNotNull = new List<Asset>();        
        for(Asset currentAsset : assetList){
            CompleteMap completeMap = new CompleteMap();
            map<String, Object> itemFields  =  completeMap.fields;
            itemFields.put('catalogitemid',currentAsset.NE__CatalogItem__c);
            itemFields.put('parentvid',OB_Utility.isnull(currentAsset.NE__Parent_Order_Item__r.NE__Item_Code__c,'')); 
            itemFields.put('rootvid',OB_Utility.isnull(currentAsset.NE__Parent_Order_Item__r.NE__Item_Code__c,''));
            itemFields.put('pickedby','human');
            //28/03/19 francesca.ribezzi adding termId node:
            itemFields.put('OB_TermId__c',currentAsset.OB_TermId__c); 
            itemFields.put('vid',currentAsset.NE__Item_Code__c);
            itemFields.put('itemCode',currentAsset.NE__Item_Code__c);//GC 4.0.7
            itemFields.put('parent',currentAsset.NE__CatalogItem__r.NE__Parent_Catalog_Item__c);
            itemFields.put('id',currentAsset.id);
            itemFields.put('type',currentAsset.NE__CatalogItem__r.NE__Type__c); 
            itemFields.put('action',currentAsset.NE__Action__c); 
            itemFields.put('status',currentAsset.NE__Status__c); 
            itemFields.put('qty',1);
            itemFields.put('account',currentAsset.AccountId);
            itemFields.put('billaccount',currentAsset.NE__Billing_Account__c);
            itemFields.put('NE__StartDate__c',currentAsset.NE__StartDate__c);  
            itemFields.put('NE__End_Date__c',currentAsset.NE__EndDate__c);
            itemFields.put('servaccount',currentAsset.NE__Service_Account__c);
            itemFields.put('billprofileid',currentAsset.NE__BillingProf__c);
            itemFields.put('catalogid',currentAsset.NE__Catalog__c);
            itemFields.put('productid',currentAsset.NE__ProdId__c);
              itemFields.put('productname',currentAsset.NE__ProdId__r.Name);
            itemFields.put('configurationType',currentAsset.NE__CatalogItem__r.NE__Configuration_Type__c);
            itemFields.put('hiddenInCart',currentAsset.NE__CatalogItem__r.NE__Hidden_in_Cart__c);
            itemFields.put('pickedby',currentAsset.NE__Picked_By__c);
            itemFields.put('recurringchargefrequency',currentAsset.NE__RecurringChargeFrequency__c);
            itemFields.put('bundleId',currentAsset.NE__Bundle__c);
            itemFields.put('bundleElement',currentAsset.NE__Bundle_element__c);
            itemFields.put('bundleConfigurationId',currentAsset.NE__Bundle_Configuration__r.NE__Item_Code__c);
            itemFields.put('bundlevid',currentAsset.NE__Bundle_Configuration__r.NE__Item_Code__c);
            itemFields.put('logicalParent',currentAsset.NE__Parent_Logic__r.NE__Item_Code__c);
            itemFields.put('isCatalogItem',false);
            itemFields.put('isCart',true);
            itemFields.put('assetitementerpriseid',currentAsset.NE__AssetItemEnterpriseId__c); 
            itemFields.put('OBCodiceSfd',currentAsset.NE__ProdId__r.OB_Codice_sfdc__c);
            itemFields.put('OBCommercialBundle',currentAsset.NE__ProdId__r.OB_CommercialBundle__c);
            itemFields.put('OB_Description__c',currentAsset.OB_Description__c);
            itemFields.put('OB_enablement__c',currentAsset.OB_enablement__c);
            itemFields.put('OB_Processor__c',currentAsset.OB_Processor__c);
            itemFields.put('OB_Ro__c',currentAsset.OB_Ro__c);
            itemFields.put('OB_Sequence__c',currentAsset.OB_Sequence__c);
            itemFields.put('RecordTypeName',currentAsset.NE__ProdId__r.RecordType.DeveloperName);
            itemFields.put('visible',currentAsset.NE__CatalogItem__r.NE__Visible__c );
      itemFields.put('active',currentAsset.NE__CatalogItem__r.NE__Visible__c );
            /*Andrea.morittu start 10/04/2019: */
            //START shaghayegh.tofighian RIF2-102
            if(currentAsset.OB_StartValidationDate__c!=null){
                itemFields.put('OB_StartValidationDate__c', 	currentAsset.OB_StartValidationDate__c);
            }
            else{
                itemFields.put('OB_StartValidationDate__c', 	currentAsset.NE__StartDate__c);
            }
            //END shaghayegh.tofighian RIF2-102
            itemFields.put('OB_AgreedChanges__c', 		currentAsset.NE__Order_Config__r.OB_AgreedChanges__c);							  
            //Start antonio.vatrano 08/05/2019 r1f2-96 change value of OB_Variation__c
            Boolean variation = (currentAsset.NE__Order_Config__r.OB_Variation__c == null) ? null : ((currentAsset.NE__Order_Config__r.OB_Variation__c == 'MIGLIORATIVA') ? true : false);
            itemFields.put('OB_Variation__c', variation);
            //End antonio.vatrano 08/05/2019 r1f2-96 change value of OB_Variation__c
            itemFields.put('OB_Sub_Process__c', 			currentAsset.NE__Order_Config__r.NE__Order_Header__r.OB_Sub_Process__c);
            itemFields.put('OB_DataMigration__c', 		currentAsset.CreatedBy.OB_DataMigration__c);
            /*Andrea.morittu start 10/04/2019: */
            //START shaghayegh.tofighian RIF2-117 15/05/2019
            itemFields.put('firstSubcription', firstSubcription);
            //END shaghayegh.tofighian RIF2-117 15/05/2019
            /*Andrea.morittu end 10/04/2019: */
            itemFields.put('OB_Sequence__c',String.valueof(currentAsset.OB_Sequence__c));
            itemFields.put('OB_Visible__c',currentAsset.OB_Visible__c);
            completeMap.fields = itemFields;

            for(NE__AssetItemAttribute__c currentAttr : currentAsset.NE__AssetItemAttributes__r){
    
                AttributeFiels  attributeFiels = new AttributeFiels();
                map<String, Object> attrFields  = attributeFiels.fields; 
                attrFields.put('OB_Attribute_Code__c',currentAttr.ob_attribute_code__c);
                attrFields.put('name',currentAttr.Name); //francesca.ribezzi 02/12/19 - performance - attribute code is equal to familyPropCode
                attrFields.put('attributeCode',currentAttr.NE__FamPropId__r.NE__FamilyPropertyCode__c); 
                attrFields.put('OB_MIn_Absolute__c',currentAttr.ob_min_absolute__c);
                attrFields.put('OB_Massimale__c',currentAttr.ob_massimale__c);
                attrFields.put('OB_Max_Absolute__c',currentAttr.ob_max_absolute__c);
                attrFields.put('OB_Max_Threshold__c',currentAttr.ob_max_threshold__c);
                attrFields.put('OB_Min_Threshold__c',currentAttr.ob_min_threshold__c);
                attrFields.put('Old_Value__c',currentAttr.ne__old_value__c);
                attrFields.put('value',currentAttr.ne__value__c);     
                attrFields.put('readonly',currentAttr.NE__FamPropId__r.NE__ReadOnly__c);      
                attrFields.put('propid',currentAttr.NE__FamPropId__r.NE__PropId__c  );    
                 attrFields.put('idfamily',currentAttr.NE__FamPropId__r.NE__FamilyId__c);        
                completeMap.listOfAttributes.add(attributeFiels);   
         
            }        
            outputMap.put(currentAsset.Id,JSON.serialize(completeMap));

        }        
 
        return outputMap;
    }
    
    //Antonio.vatrano 11/12/2019 remove method 
   	/*******************************************************************************
         AUTHOR:  Francesca Ribezzi                  
         Created:   28/11/2019           
         Description: Performance
         class used to relate orderItem and attributes 
    */
    public class orderItemWrapper {
       NE__OrderItem__c itemRecord;
       Map<Id,NE__Order_Item_Attribute__c> attrMap = new Map<Id,NE__Order_Item_Attribute__c>();

       public String isnull (String controlledValue, String alternativeValue){
                      if(controlledValue == null) return alternativeValue;
                      return controlledValue;
       }
    } 

    //ANDREA MORITTU start 28.02.2019
    @AuraEnabled
    public static NE__Order__c getApprovalStatusOfConfiguration(String orderId)  { 
    
        List<NE__Order__c> configuration = new  List<NE__Order__c>();
        NE__Order__c toReturn = new NE__Order__c();
        configuration = [SELECT Id, 
                         OB_ApprovalStatus__c 
                         FROM NE__Order__c 
                         WHERE Id = :orderId ];

        if(!configuration.isEmpty()) {
            toReturn = configuration.get(0);
        }
        return toReturn;
    }
    //ANDREA MORITTU  end 28.02.2019    

    //05/03/19 francesca.ribezzi updating terminal ids on orderItem and orderItemAttributes:
    @AuraEnabled
    public static Boolean updateTerminalIdServer(Map<Id, String> mapItemIdTerminalId)  { 
        List<NE__Order_Item_Attribute__c> listOfAttributes = new List<NE__Order_Item_Attribute__c>();
        List<NE__OrderItem__c> listToUpdate = [ 
            Select id, OB_TermId__c,
            (select id,Name, NE__Value__c,NE__Old_Value__c,NE__Order_Item__c  
            from NE__Order_Item_Attributes__r where name ='Terminal Id')
            FROM NE__OrderItem__c 
            WHERE id 
            IN : mapItemIdTerminalId.keySet()
        ];

        for(NE__OrderItem__c orderItem : listToUpdate){
            for(NE__Order_Item_Attribute__c attr: orderItem.NE__Order_Item_Attributes__r){
                attr.NE__Value__c = mapItemIdTerminalId.get(orderItem.Id);
                orderItem.OB_TermId__c = mapItemIdTerminalId.get(orderItem.Id);
                listOfAttributes.add(attr);
            }
        }
    
        try{
            update listOfAttributes;
            update listToUpdate;
            return true;
        }catch(Exception E){
                System.debug('Generic Error: '+e.getMessage()+ ' at line: '+e.getLineNumber()+' stack trace: '+e.getStackTraceString());
            return false;
        }
    } 
    

    //D.F. _ ManageRacSia v4 _ START
    /*------------------------------------------------------------
    Author:         Davide Franzini
    Company:        Accenture Technology
    Description:    Retrieve Account's Iban
    Inputs:         String objectDataString
    History:        Query on Asset added in order to retrieve Merchant's active terminal Iban
    <Date>          <Authors Name>      <Brief Description of Change>
    ------------------------------------------------------------*/
    @AuraEnabled
    public static List<String> checkActiveTerminalsIBAN(String objectDataString){
        Map<String,Object> objectDataMap = (Map<String,Object>)JSON.deserializeUntyped(objectDataString);
        String accString = JSON.serialize(objectDataMap.get('merchant'));
        Account acc = (Account)JSON.deserialize(accString, Account.class);
		//START Andrea Saracini 12/06/2019 - R1F2-153v2
		String configurationString = JSON.serialize(objectDataMap.get('Configuration'));
		NE__Order__c configuration =(NE__Order__c)JSON.deserialize(configurationString, NE__Order__c.class);
		//STOP Andrea Saracini 12/06/2019 - R1F2-153v2
		Set<String> ibanSet = new Set<String>();
		
		//16-04-2019 Changed iban field in select and constant added
		List<NE__OrderItem__c> ordItList = [SELECT Id,OB_DebitProfId__r.OB_IBAN__c 
										FROM NE__OrderItem__c 
										WHERE NE__ProdId__r.RecordType.DeveloperName = :OB_UtilityConstants.POS_RT 
										AND NE__Status__c = :OB_UtilityConstants.STATUS_ACTIVE
										AND NE__Action__c != :OB_UtilityConstants.ORDERITEM_ACTION_ADD  //Andrea Saracini 12/06/2019 - R1F2-153v2
										AND NE__Account__r.NE__Fiscal_code__c = :acc.NE__Fiscal_code__c
										AND NE__OrderId__c =: configuration.Id];
					
		//16-04-2019 Changed iban field to add in set
		for(NE__OrderItem__c ordIt : ordItList){
			ibanSet.add(ordIt.OB_DebitProfId__r.OB_IBAN__c);
		}
		
		List<String> ibanList = new List<String>(ibanSet);

        if(ibanList.size()>0){
            return ibanList;
        }else{
            return null;
        }
    }
    //D.F. _ END

    
    /*Andrea.morittu start 10/04/2019: */
    public class userInfoWrapper {
        @AuraEnabled Boolean isOperation { get; set; }
        @AuraEnabled Boolean isPartner { get; set; }
        @AuraEnabled Boolean hasError { get; set; }
    }

    @AuraEnabled
    public static userInfoWrapper getUserInformation( )
    {
        String partnerCommunity = System.Label.OB_License_PartnerCommunity;
        // String operationProfile = System.Label.OB_Operation;

        userInfoWrapper userInformationWrapper = new userInfoWrapper( );
        String userId = UserInfo.getUserId( );
        User currentUsr =
        [
                SELECT Id,
                        contactId,
                        contact.accountId,
                        Profile.UserLicense.Name,
                        Profile.Name,
                        OB_CAB__C,
                        OB_ABI__c
                FROM User
                WHERE Id = :userId
                LIMIT 1
        ];
        System.debug( '## current user is: ' + currentUsr );
        try
        {
			List<OB_ConfigurationInformation__mdt> listOfConfigurationInformations = new List<OB_ConfigurationInformation__mdt>( );
			listOfConfigurationInformations =[SELECT Id,
													 MasterLabel,
													 Label,
													 QualifiedApiName,
													 OB_String_Value__c,
													 OB_String_Value_2__c
													 FROM OB_ConfigurationInformation__mdt
													 WHERE QualifiedApiName = 'OB_OperationUserNewCartPrice'];

			if(!listOfConfigurationInformations.isEmpty()) {
				OB_ConfigurationInformation__mdt singleConfMdt = new OB_ConfigurationInformation__mdt();
				singleConfMdt = listOfConfigurationInformations.get(0);
				if(currentUsr.Profile.Name.equalsIgnoreCase(singleConfMdt.OB_String_Value__c)){
					userInformationWrapper.isOperation = true;
					userInformationWrapper.isPartner = false;
					userInformationWrapper.hasError = false;
				} 
				// ANDREA MORITTU START 18-Sept-2019 - EVO_PRODOB_452 - ADDING PARTNER USER ATTRIBUTES
				else {
					userInformationWrapper.isOperation = false;
					userInformationWrapper.isPartner = true;
					userInformationWrapper.hasError = false;
				}
				// ANDREA MORITTU END 18-Sept-2019 - EVO_PRODOB_452 - ADDING PARTNER USER ATTRIBUTES
			}
        } catch ( Exception ecc ) {
            System.debug( 'The following exception has occurred: ' + 'at line: ' + ecc.getLineNumber( ) + 'message : ' + ecc.getMessage( ) );
        }
        return userInformationWrapper;
    }
	/*Andrea.morittu start 10/04/2019: */
	// START shaghayegh.tofighian 15/05/2019 RIF2-117
	//  START antonio.vatrano 17/05/2019 R1F2-117 change input to method
	@AuraEnabled
	public static Boolean checkChangeOrderServer(string offerConfig){
		List<NE__OrderItem__c> orderItems = new List<NE__OrderItem__c>();
		/*	@AUTHOR	: Morittu Andrea (andrea.morittu@accenture.com)
			@DEFECT	: RI-29 --> Replaced wrong format where conditions
			@DATE	: 19.04.2019
		*/
		List<String> assetItems = new List<String> ();
		List<Asset> listAsset= [SELECT Id 
						FROM Asset 
						WHERE NE__Order_Config__c =:offerConfig];
		if (!listAsset.isEmpty()){
			for (Asset a : listAsset){
				assetItems.add(String.valueOf(a.id));
			}
			orderItems = [	SELECT 	Id, 
									Name, 
									NE__AssetItemEnterpriseId__c, 
									OB_FulfilmentStatus__c, 
									NE__OrderId__r.NE__Type__c, 
									NE__OrderId__r.NE__Order_Header__r.OB_Sub_Process__c 
							FROM 	NE__OrderItem__c
							WHERE	NE__OrderId__r.NE__Order_Header__r.OB_Sub_Process__c = 'variazione economica'  
							AND 	OB_FulfilmentStatus__c = 'Completed'
							AND 	NE__OrderId__r.NE__Type__c = 'ChangeOrder'
							AND 	NE__AssetItemEnterpriseId__c IN :assetItems ];
			if(!orderItems.isEmpty()) {
				return false;
			}        
			else{
				return true;
			}
		}
		return true;
	}
	//  END antonio.vatrano 17/05/2019 R1F2-117 change input to method
	// END shaghayegh.tofighian 15/05/2019 RIF2-117
	/*Andrea.morittu end 10/04/2019: */
    
    //Start antonio.vatrano prodob_314 11/07/2019
    @TestVisible
    public static Map<String, NE__Matrix_Parameter_Row__c> retrieveMatrix (String confId ){
        Map<String, NE__Matrix_Parameter_Row__c> matrixRowMap = new Map<String, NE__Matrix_Parameter_Row__c>(); 
 		List<NE__OrderItem__c> itemList = [SELECT  OB_ABI__c, NE__Bundle__c,NE__OrderId__r.NE__Order_Header__r.OB_Business_Model_Acquiring__c
            								FROM NE__OrderItem__c where NE__OrderId__c =:confId ];
            if(!itemList.isEmpty()){
                NE__OrderItem__c oi = itemList.get(0);
                String bundleId = oi.NE__Bundle__c;
                String proposerAbiCode = oi.OB_ABI__c;
                String busModelAcq = oi.NE__OrderId__r.NE__Order_Header__r.OB_Business_Model_Acquiring__c;
                
                List<NE__Matrix_Parameter_Row__c>rowList=[SELECT Id,Name,NE__Active__c,NE__End_Date__c,NE__Matrix_Parameter__c,NE__Start_Date__c,OB_ABI_BANCA__c,OB_Cab__c,OB_Codici__c,OB_Componente__c,OB_Default_Banca__c,OB_DynamicPropertyDefinition__c,OB_Family__c,OB_Hidden__c,OB_Massimale__c,OB_Massimo__c,OB_Minimo__c,OB_ModelloAcquiring__c,OB_Offerta__c,OB_Parent_Componente__c,OB_Product__c,OB_Read_Only_banca__c,OB_ReadOnly__c,OB_Schema_Prezzi__c,OB_Sequence__c,OB_Soglia_Max_Approvazione__c,OB_Soglia_Min_Approvazione__c,OB_Utilizzato_per_la_BANCA__c,OB_Valore_Default__c FROM NE__Matrix_Parameter_Row__c WHERE NE__Active__c=true AND OB_Componente__c<>null AND OB_ABI_BANCA__c=:proposerAbiCode AND OB_ModelloAcquiring__c=:busModelAcq AND OB_Offerta__c=:bundleId];
                
                if(!rowList.isEmpty()){
                    for(NE__Matrix_Parameter_Row__c mprRow : rowList ){
                        matrixRowMap.put(String.valueof(mprRow.OB_Componente__c),mprRow);
                    }
                } 
            }
        return matrixRowMap;
    }
    //End antonio.vatrano prodob_314 11/07/2019
    

	/*****************************************************************
	Purpose: Method to check the current profile logged and set visibility
	Returns: Boolean

	History 
	--------
	VERSION AUTHOR 				DATE 		DETAIL 		Description
	1.0 	Daniele Gandini 	17/05/2019 	Created 	CSR: 
	*****************************************************************/
    @AuraEnabled
	public static Boolean checkProfileLoggedUser()
	{
		Boolean toReturn = false;
		String userId = UserInfo.getUserId();
		list<User> listOfUsers = [	SELECT 	Id, Profile.Name, Profile.UserLicense.Name
									FROM 	User
									WHERE 	Id =: userId
									LIMIT 	1	];
		if(!listOfUsers.isEmpty())
		{
			User user					= listOfUsers.get(0);
			String license 		= user.Profile.UserLicense.Name;
			String profile 		= user.Profile.Name;
			System.debug('license:  '+license);
			System.debug('profile:  '+profile);

			String confInfProfiles;
			Boolean profileIsInConfInf = false;
			OB_ConfigurationInformation__mdt configurationInformation = new OB_ConfigurationInformation__mdt();
			OB_ConfigurationInformation__mdt[] listOfConfigurationInformations = [SELECT 	Id,
																							MasterLabel,
																							Label,
																							QualifiedApiName,
																							OB_String_Value__c
																							FROM 	OB_ConfigurationInformation__mdt 
																							WHERE 	QualifiedApiName =: OB_UtilityConstants.CUSTOM_MET_TECHDETAILS_USER ];
			if(!listOfConfigurationInformations.isEmpty())
			{
				configurationInformation = listOfConfigurationInformations.get(0);
				confInfProfiles = configurationInformation.OB_String_Value__c;
				System.debug('@confInfProfiles : ' +  confInfProfiles);
				profileIsInConfInf = confInfProfiles.contains(profile);
				System.debug('@profileIsInConfInf : ' +  profileIsInConfInf);

				if(profileIsInConfInf == true)
				{
					toReturn = true;
				}
			}
		}
		return toReturn;
	}

    /*****************************************************************
	Purpose: Method to check the current profile logged and set visibility
	Returns: Boolean

	History 
	--------
	VERSION AUTHOR 				DATE 		DETAIL 		Description
	1.0 	Daniele Gandini 	24/05/2019 	Created 	CSR: 
	*****************************************************************/
    @AuraEnabled
    public static List<Id> updateReplacedOrderItem(String orderId, List<String> terminalIdList){
        System.debug('@@@@ In updateReplacedOrderItem');
        List <NE__OrderItem__c> allOrderItemsToUpdate = new List <NE__OrderItem__c>();
        List <NE__OrderItem__c> addedOrderItemList = new List <NE__OrderItem__c>();
        List <NE__OrderItem__c> removeOrderItemList = new List <NE__OrderItem__c>();
        List <NE__OrderItem__c> updatedItemList = new List <NE__OrderItem__c>();
        List <Id> itemIdUpdatedList = new List<Id>();

        try{
            allOrderItemsToUpdate = [   SELECT  Id,
                                                //OB_RAC_SIA__c,
                                                OB_TermId__c,
                                                NE__BillingProfId__c,
                                                OB_DebitProfId__c,
                                                OB_Billing_Profile_Credit_Acquiring__c,
                                                OB_BankAccount_Debit_Acquiring__c,
                                                NE__Action__c
                                        FROM    NE__OrderItem__c
                                        WHERE   NE__OrderId__c = :orderId
                                        AND     (NE__Action__c = :OB_UtilityConstants.REMOVE_ACTION OR NE__Action__c = :OB_UtilityConstants.ADD_ACTION)
                                        AND     OB_TermId__c IN :terminalIdList
                                    ];
            if(!allOrderItemsToUpdate.isEmpty()){
                for(NE__OrderItem__c singleItem : allOrderItemsToUpdate){
                    if(singleItem.NE__Action__c == OB_UtilityConstants.ADD_ACTION){
                        addedOrderItemList.add(singleItem);
                    }else if(singleItem.NE__Action__c == OB_UtilityConstants.REMOVE_ACTION){
                        removeOrderItemList.add(singleItem);
                    }
                }
                if(!addedOrderItemList.isEmpty() && !removeOrderItemList.isEmpty() && (addedOrderItemList.size() == removeOrderItemList.size())){
                    for(NE__OrderItem__c removedItem : removeOrderItemList){
                        for(NE__OrderItem__c addedItem : addedOrderItemList){
                            if(addedItem.OB_TermId__c == removedItem.OB_TermId__c){
                                System.debug('@@@@ addedItem.OB_DebitProfId__c ' + JSON.serialize(addedItem.OB_DebitProfId__c));
                                System.debug('@@@@ removedItem.OB_DebitProfId__c ' + JSON.serialize(removedItem.OB_DebitProfId__c));
                                addedItem.NE__BillingProfId__c = removedItem.NE__BillingProfId__c;
                                addedItem.OB_DebitProfId__c = removedItem.OB_DebitProfId__c;
                                addedItem.OB_Billing_Profile_Credit_Acquiring__c = removedItem.OB_Billing_Profile_Credit_Acquiring__c;
                                addedItem.OB_BankAccount_Debit_Acquiring__c = removedItem.OB_BankAccount_Debit_Acquiring__c;
                                updatedItemList.add(addedItem);
                                System.debug('@@@@ addedItem ' + JSON.serialize(addedItem));
                                System.debug('@@@@ removedItem ' + JSON.serialize(removedItem));
                            }
                        }
                    }
                    System.debug('@@@@ out: ' + JSON.serialize(updatedItemList));                
                }
                update updatedItemList;
                for(NE__OrderItem__c itemId : updatedItemList){
                    itemIdUpdatedList.add(itemId.Id);
                }
                System.debug('@@@@ updatedItemList: ' + JSON.serialize(updatedItemList));
                System.debug('@@@@ itemIdUpdatedList: ' + JSON.serialize(itemIdUpdatedList));
            }
        }catch(Exception ecc){
            System.debug('Generic Error: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
        }
        return itemIdUpdatedList;
    }

    @AuraEnabled
    public static Map<String, Map<String, String>> retrieveSiaCodes(String orderId, List<String> terminalsId){
        System.debug('@@@@ retrieveSiaCodes');
        List<NE__OrderItem__c> orderItemList = new  List<NE__OrderItem__c>();
        Map<String, Map<String, String>> orderItemMap = new Map<String, Map<String, String>>();
        Map<String, String> siaCodesMap = new Map<String, String>();

        try{
            orderItemList = [   SELECT  Id,
                                        OB_TermId__c,
                                        NE__Action__c,
                                        (   SELECT  Id,
                                                    Name,
                                                    NE__Value__c
                                            FROM    NE__Order_Item_Attributes__r 
                                            WHERE   NE__Action__c = :OB_UtilityConstants.REMOVE_ACTION
                                            AND     (   Name = :OB_UtilityConstants.CODICE_SIA OR 
                                                        Name = :OB_UtilityConstants.CODICE_STABILIMENTO_SIA OR 
                                                        Name = :OB_UtilityConstants.PROGRESSIVO_SIA)
                                            
                                        )
                                FROM    NE__OrderItem__c
                                WHERE   NE__OrderId__c = :orderId
                                AND     NE__Action__c = :OB_UtilityConstants.REMOVE_ACTION
                                AND     OB_TermId__c IN :terminalsId
                                    ];
                                    system.debug('!orderItemList.isEmpty()'+(!orderItemList.isEmpty()));
        if(!orderItemList.isEmpty()){
            
            for(NE__OrderItem__c singleItem : orderItemList){
                for(NE__Order_Item_Attribute__c itemAttribute : singleItem.NE__Order_Item_Attributes__r){
                    if(itemAttribute.Name.equalsIgnoreCase(OB_UtilityConstants.PROGRESSIVO_SIA)){
                        siaCodesMap.put(OB_UtilityConstants.PROGRESSIVO_SIA,itemAttribute.NE__Value__c);
                    }
                    if(itemAttribute.Name.equalsIgnoreCase(OB_UtilityConstants.CODICE_STABILIMENTO_SIA)){
                        siaCodesMap.put(OB_UtilityConstants.CODICE_STABILIMENTO_SIA,itemAttribute.NE__Value__c);
                    }
                    if(itemAttribute.Name.equalsIgnoreCase(OB_UtilityConstants.CODICE_SIA)){
                        siaCodesMap.put(OB_UtilityConstants.CODICE_SIA,itemAttribute.NE__Value__c);
                    }
                }
                orderItemMap.put(singleItem.OB_TermId__c,siaCodesMap);
            }
            System.debug('singleItem: ' + JSON.serialize(orderItemMap));
        }
        }catch(Exception ecc){
            System.debug('Generic Error: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
        }
        return orderItemMap;
    }
    /**
*
* @author francesca.ribezzi
* @date Creation 10/07/2019
* @description this method is used to update orderItem and orderItemsAttributes:
*/
    @AuraEnabled
    public static Boolean updateAllItemsServer( List<Object> parentAndChilItems,  List<Object> listOfAttributes, String orderId ){
        System.debug('into updateAllItemsServer');
        Boolean isOk = false;
        List<NE__OrderItem__c> orderItemsList = new  List<NE__OrderItem__c>();
        List<NE__Order_Item_Attribute__c> attList = new  List<NE__Order_Item_Attribute__c>();
        try{
            for(Object objItem : parentAndChilItems){
                String objString = JSON.serialize(objItem);
                NE__OrderItem__c item = (NE__OrderItem__c)JSON.deserialize(objString, NE__OrderItem__c.class);
                System.debug('### childItem :' + item);
                orderItemsList.add(item);
            }
            for(Object attItemObj : listOfAttributes){
                String attString = JSON.serialize(attItemObj);
                    System.debug('##attString: ' + attString);
                Map<String, Object> attFields = (Map<String, Object>)JSON.deserializeUntyped(attString);
                String idLineAttribute = JSON.serialize(attFields.get('idLineAttribute'));
                idLineAttribute = idLineAttribute.replaceAll('"', '');
                //francesca.ribezzi 16/10/19 - WN-609 - logic moved outside of idLineAttribute blank condition
                String value;
                String action = 'None';
                String oldValue;
                //francesca.ribezzi 04/09/19 - WN-349 - getting action from action or NE__Action node
                String keyAction = attFields.get('action') != null? 'action' :'NE__Action__c';
                if(attFields.get('value') != null){
                    value = JSON.serialize(attFields.get('value'));
                    value = value.replaceAll('"', '');
                }
                if(keyAction != null){   //francesca.ribezzi 04/09/19 - WN-349 - getting action from action or NE__Action node
                    action = JSON.serialize(attFields.get(keyAction));
                    action = action.replaceAll('"', '');
                }
                if(attFields.get('Old_Value__c') != null){
                    oldValue = JSON.serialize(attFields.get('Old_Value__c'));
                    oldValue = action.replaceAll('"', '');
                }
                //START francesca.ribezzi - WN-349 - 04/09/19 checking if a sim card needs to be created:
                Boolean actionAddOrChange =  (attFields.get(keyAction) == 'Add' ||  attFields.get(keyAction) == 'Change');
                Boolean insertSimCard = (actionAddOrChange && attFields.get('name')  == 'SimCard' && value == 'Nexi');
                if(insertSimCard){
                    System.debug('creating a sim card');
                    createSimCard(attFields, orderId);
                }
                //END francesca.ribezzi - WN-349 - 04/09/19
                NE__Order_Item_Attribute__c  attItem = new NE__Order_Item_Attribute__c();
                if(String.isNotBlank(idLineAttribute)){ 
                    attItem.id = idLineAttribute;
                //davide.franzini - 18/10/2019 - attr id error fix - START
                }else{
                    attItem.NE__Order_Item__c = (Id)attFields.get('lineId');
                    attItem.Name = (String) attFields.get('name');
                    attItem.NE__FamPropExtId__c = (String) attFields.get('attributeCode');
                    attItem.NE__FamPropId__c = (String) attFields.get('pfpId');
                    attItem.OB_Attribute_Code__c = (String) attFields.get('OB_Attribute_Code__c');
                    attItem.NE__AttrEnterpriseId__c = (String) attFields.get('NE__AttrEnterpriseId__c');
                }
                //davide.franzini - 18/10/2019 - attr id error fix - END
                attItem.NE__Value__c = value;
                attItem.NE__Action__c = action; 
                attItem.NE__Old_Value__c = oldValue;
                System.debug('### attItem :' + attItem);
                attList.add(attItem);
            }
            update orderItemsList;
            upsert attList;  //francesca.ribezzi 16/10/19 - WN-609 - upsert insted of insert
            isOk = true;
        } catch(Exception ecc){
            System.debug(logginglevel.ERROR,'Generic Error: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
        }
        system.debug(LoggingLevel.INFO, '## orderItemsList: '+JSON.serializePretty(orderItemsList));
        system.debug(LoggingLevel.INFO, '## attList: '+JSON.serializePretty(attList));
        return isOk;
    }
    /**
    *
    * @author francesca.ribezzi
    * @date Creation 04/09/2019
    * @description this method is used to create a sim card child item
    */
    @AuraEnabled
    public static void createSimCard(Map<String, Object> attFields, String orderId){ 
        try{
            String rootOrderItemId = JSON.serialize(attFields.get('rootOrderItem'));
            rootOrderItemId = rootOrderItemId.replaceAll('"', '');
            Id pricingRT = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByDeveloperName( ).get( 'Pricing' ).getRecordTypeId( );
    
             //START francesca.ribezzi 23/09/19 - getting root information
            List<NE__OrderItem__c>  rootOrderItemList = 
            [
                SELECT 
                id, 
                NE__CatalogItem__c,
                NE__ProdId__c,
                NE__Bundle__c,
                OB_ABI__c,
                NE__Bundle_Configuration__c,
                NE__OrderId__r.NE__Order_Header__r.OB_Business_Model_Acquiring__c, //francesca.ribezzi 28/11/19 - performance - adding fields to filter next query
                NE__OrderId__r.NE__Order_Header__r.OB_Business_Model_POS__c
                FROM NE__OrderItem__c 
                WHERE id = :rootOrderItemId
            ];
            if(rootOrderItemList.size() == 0){
                throw new operationException('error - there are no rootOrderItems related to this id: ' + rootOrderItemId);
            }
            //END francesca.ribezzi 23/09/19
            NE__OrderItem__c root = rootOrderItemList.get(0);
            List<NE__Product__c> simCardNexiProd = [ //francesca.ribezzi 19/12/19 - internal-3 - adding subquery to take catalogItem id
                    SELECT id,
                         OB_Codice_sfdc__c,
                         (SELECT id FROM NE__Catalog_Items__r WHERE NE__Root_Catalog_Item__r.NE__ProductId__c  = :root.NE__ProdId__c )  
                    FROM NE__Product__c
                    WHERE OB_Codice_sfdc__c = 'NEXI_SIMCARD'
            ];
            if(simCardNexiProd.size() == 0){
                throw new operationException('error - there is no sim card nexi product');
            }
            //START francesca.ribezzi 19/12/19 - internal-3 - adding catalogItem id
            Id catalogItemId;
            if(simCardNexiProd[0].NE__Catalog_Items__r.size() > 0){
                    catalogItemId = simCardNexiProd[0].NE__Catalog_Items__r[0].Id;
            }
            //END francesca.ribezzi 19/12/19 - internal-3
            //francesca.ribezzi 02/12/19 - performance - simcard code block moved here 
            NE__OrderItem__c simCard = new NE__OrderItem__c();
            simCard.NE__Action__c =                 'Add';
            simCard.NE__Root_Order_Item__c =        rootOrderItemId;
            simCard.NE__Parent_Order_Item__c =      rootOrderItemId;
            simCard.NE__ProdId__c =                 simCardNexiProd[0].Id;  
            simCard.OB_enablement__c =              'N';
            simCard.NE__OrderId__c =                orderId; 
            simCard.NE__Qty__c =                    1;
            simCard.RecordTypeId =                  pricingRT;  
            simCard.NE__Bundle_Configuration__c =   root.NE__Bundle_Configuration__c;
            simCard.NE__CatalogItem__c =            catalogItemId; // francesca.ribezzi 19/12/19 - internal-3 - adding catalogItem id
            insert simCard;            

           //START francesca.ribezzi 20/09/19 - getting matrix parameter row associated with sim card nexi:
            List<NE__Matrix_Parameter_Row__c> matrixParameterRows =
            [
                SELECT 
                Id,
                OB_DynamicPropertyDefinition__r.Name,
                OB_Product__r.OB_Codice_sfdc__c,
                OB_Codici__c,
                OB_Product__r.name, 
                OB_Soglia_Min_Approvazione__c, 
                OB_Soglia_Max_Approvazione__c, 
                OB_Maximum__c, 
                OB_Minimo__c, 
                OB_Valore_Default__c
                FROM NE__Matrix_Parameter_Row__c
                WHERE OB_Product__r.OB_Codice_sfdc__c = 'NEXI_SIMCARD'
                AND OB_Componente__r.NE__Parent_Catalog_Item__c = :root.NE__CatalogItem__c
                AND OB_Offerta_2__c = :root.NE__Bundle__c //francesca.ribezzi 28/11/19 - performance - adding filters on query
                AND OB_ABI_BANCA__c = :root.OB_ABI__c
                AND OB_Cab__c = null
                AND OB_SelfLookup__c > ''
                AND NE__Matrix_Parameter__r.Name = 'CatalogoNexi' 
                AND OB_ModelloAcquiring__c = :root.NE__OrderId__r.NE__Order_Header__r.OB_Business_Model_Acquiring__c
                AND OB_Schema_Prezzi__c includes (:root.NE__OrderId__r.NE__Order_Header__r.OB_Business_Model_POS__c)
            ];
            if(matrixParameterRows.size() == 0){ 
                throw new operationException('error - there are no matrix parameters');
            }
            List<NE__Order_Item_Attribute__c> attributes = new  List<NE__Order_Item_Attribute__c>();
            for(NE__Matrix_Parameter_Row__c m : matrixParameterRows){
                String value = m.OB_Valore_Default__c != null ? String.valueOf(m.OB_Valore_Default__c) : null;
                NE__Order_Item_Attribute__c att = new NE__Order_Item_Attribute__c();
                att.Name                        = m.OB_DynamicPropertyDefinition__r.Name;
                att.NE__Order_Item__c           = simCard.Id;
                att.NE__Value__c                = value; 
                att.OB_MIn_Absolute__c          = m.OB_Minimo__c;
                att.OB_Min_Threshold__c         = m.OB_Soglia_Min_Approvazione__c;
                att.OB_Max_Threshold__c         = m.OB_Soglia_Max_Approvazione__c;
                att.OB_Max_Absolute__c          = m.OB_Maximum__c;             
                attributes.add(att); 

            }
            insert attributes;
            //END francesca.ribezzi 20/09/19 
        } catch(Exception ecc){
            System.debug( LoggingLevel.ERROR,'Generic Error: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
        }
    }
    /**
    *
    * @author francesca.ribezzi
    * @date Creation 11/07/2019
    * @description this method is used to get useful missing data for Dati Operativi Step
    */
    @AuraEnabled
    public static NE__Order__c getOrderDataServer(String orderId){
        NE__Order__c config = new NE__Order__c();
        List<NE__Order__c> order = [
                SELECT id, NE__Order_Header__r.OB_Terminal_Id_Generator__c,NE__Order_Header__r.OB_Applicant_RAC_Code_SIA__c,OB_ABI__c//Simone Misani WN-295 29/08/2019
                FROM NE__Order__c
                WHERE id = :orderId
        ];
        if(order.size() > 0){
            config = order[0];
        }
        return config;
    }

    /*******************************************************************************
    Purpose:  Method to perform check on terminal Id uniqness. The Id would be unique, if it's not present on any Asset or Order Item
    Parameters: String terminalId
    Returns: Boolean
    History: -
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Kinga Fornal            10/07/2019      Created         NEXI-126
    ********************************************************************************/
    private static Boolean checkTerminalIdUniqueness( String terminalId )
    {
        List<Asset> relatedAssetsList =
        [
                SELECT Id
                FROM Asset
                WHERE OB_TermId__c = :terminalId
                LIMIT 1
        ];
        if ( relatedAssetsList.size( ) > 0 )
        {
            return false;
        }

        List<NE__OrderItem__c> relatedOrderItemsList =
        [
                SELECT Id
                FROM NE__OrderItem__c
                WHERE OB_TermId__c = :terminalId
                // ANDREA MORITTU START 13/Jan/2019 - PRODOB-678 - Adding missing code (Francesca's code)
                AND NE__OrderId__r.NE__OrderStatus__c !=:  OB_UtilityConstants.ORDERITEM_STATUS_CANCELLED
                // ANDREA MORITTU END 13/Jan/2019 - PRODOB-678 - Adding missing code (Francesca's code)
                LIMIT 1
        ];

        return ( relatedOrderItemsList.size( ) > 0 ) ? false : true;
    }

    /*******************************************************************************
    Purpose: this method is used to update the configuration from objectDataMap configuration
    Parameters: 
    Returns: Boolean
    History: -
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Francesca Ribezzi      07/10/2019      Created              WN-566
    */
    @AuraEnabled
    public static Boolean updateConfigurationServer(String confString){
        Boolean toReturn = true;
        try{
        NE__Order__c contextOrder = new NE__Order__c();
        contextOrder = (NE__Order__c)JSON.deserialize(confString, NE__Order__c.class);
        update contextOrder;
        }catch(Exception ecc){
            toReturn = false;
            System.debug( LoggingLevel.ERROR, '[EXC] Exception in OB_OperationalData_CC.updateConfigurationServer ' +ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());

        }
        return toReturn;
    }


    /*
    * @author francesca.ribezzi
    * @date Creation 23/09/2019
    * @description adding an exception class to handle custom exceptions:
    */
    public class operationException extends Exception {   

    }


	/*
	*	Author		:	Morittu Andrea
	*	Date		:	01-10-2019
	*	Task		:	BACKLOG_245
	*	Description	:	Method used to retrieve all VISA/MASTERCARD asset item attribute
	*/
	@AuraEnabled
	public static Map<String, List<NE__AssetItemAttribute__c>> getOldAssetItemAttributes_VM(String configurationID) {
		Map<String, List<NE__AssetItemAttribute__c>> toReturn = new Map<String, List<NE__AssetItemAttribute__c>>();
		List<Asset> originAssets = new List<Asset>();
		String VISA_MASTERCARD = OB_UtilityConstants.VISA_MASTERCARD_PRODUCT_NAME.toUpperCase();
		Boolean isUniqueCommission;
		try {
			originAssets = [SELECT 	Id, 
										NE__Status__c,
										NE__ProdId__r.RecordType.DeveloperName, 
										NE__ProdId__r.Name, 
								(
								 SELECT Id, 
										Name, 
										OB_Hidden__c, 
										NE__Value__c,
										OB_ReadOnly__c 
								 FROM 	NE__AssetItemAttributes__r
								) 
							FROM 		Asset 
							WHERE 		NE__Order_Config__c =: configurationID
                            /* ANDREA MORITTU START - 15 - Oct- 2019 - Fix Old_V/M */
                            AND			NE__ProdId__r.recordType.DeveloperName =: OB_UtilityConstants.APPROV_TYPE_PRICING
                            /* ANDREA MORITTU END - 15 - Oct- 2019 - Fix Old_V/M */
							AND (NE__ProdId__r.Name=: OB_UtilityConstants.ASSET_Commissione_Unica 
								OR 
								NE__ProdId__r.Name=: VISA_MASTERCARD)
							AND 		NE__Status__c =: OB_UtilityConstants.STATUS_ACTIVE ];
			
			if(!originAssets.isEmpty()) {
				for(Asset singleAsset : originAssets) {
					if(singleAsset.NE__ProdId__r.Name == VISA_MASTERCARD) {
						toReturn.put(OB_UtilityConstants.ASSET_Commissione_Unica , singleAsset.NE__AssetItemAttributes__r);
					}
				}
			}
		} catch(Exception exc) {
			System.debug('An error has occured : ' + exc.getMessage());
		}
		return toReturn;
	}


      	/*******************************************************************************
    Purpose: this method is used to retrive cart for Tech detail service and 'consulta pratiche' pricing
    Parameters: orderId, isPricing
    Returns: Map<String,String> 
    History: -
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Francesca Ribezzi      28/11/2019      Created            Performance
    2.0         Francesca Ribezzi      29/11/2019      Edit              attachment logic deleted - using wrapper objs
    */
	public static Map<String,String> createMapFromOrder(Id orderId, Boolean isPricing){ // antonio.vatrano 11/12/2019 change name
        try{   
            String filter = !isPricing? ' AND NE__ProdId__r.RecordType.DeveloperName != \'' + OB_UtilityConstants.APPROV_TYPE_PRICING  + '\' ' : '';
            //francesca.ribezzi perf-82-84 - 18/12/19 - adding order by category sequence +NE__Action__c --> Simone Misani 18/12/2019
            String sequenceFilter = isPricing? ' OB_Sequence__c ' : ' RecordType.DeveloperName ,NE__Action__c,NE__CatalogItem__r.NE__Catalog_Category_Name__r.NE__Sequence__c, NE__CatalogItem__r.NE__Sequence__c '; //francesca.ribezzi perf-32- -17/12/19 - order by sequence filtered by pricing and enablements 
            Map<String,String> outputMap = new Map<String,String>();   
            String query= ' SELECT Id,'+
                                                    'NE__ProdName__c,'+
                                                    'NE__Action__c, '+
                                                    'OB_Processor__c,'+
                                                    'OB_CompanyCode__c,'+
                                                    'OB_ServicePointCode__c,'+
                                                    'NE__StartDate__c,'+
                                                    'NE__EndDate__c,'+
                                                    'OB_MCC__c,'+
                                                    'OB_MCCL2__c,'+
                                                    'OB_FulfilmentStatus__c,'+
                                                    'OB_TermId__c,'+
                                                    'NE__ProdId__c,'+
                                                    'NE__Parent_Order_Item__c,'+
                                                    'NE__ProdId__r.RecordType.DeveloperName,'+
                                                    'NE__ProdId__r.OB_Acquirer__c,'+
                                                    'NE__OrderId__r.NE__Order_Header__r.OB_ProposerABI__c,'+
                                                    'NE__OrderId__r.NE__Order_Header__r.OB_Report_Type_Format__c, '+
                                                    'NE__Bundle__c,'+
                                                    'NE__Bundle_Configuration__c,'+
                                                    'NE__ProdId__r.OB_Codice_sfdc__c,'+
                                                    'OB_GT__c,'+
                                                    'OB_CustomerCode__c,'+
                                                    'OB_Tech_Outcome_Monetica__c,'+
                                                    'OB_Tech_Outcome_Equens__c,'+
                                                    'OB_ShopCode__c,'+
                                                    'OB_RAC_SIA__c,'+
                                                    'NE__CatalogItem__c, '+
                                                    'NE__Parent_Order_Item__r.NE__Item_Code__c,'+
                                                    'NE__Item_Code__c,'+
                                                    'OB_Enablement__c,'+
                                                    'NE__Status__c,'+
                                                    'OB_Ro__c,'+
                                                    'OB_Visible__c,'+
                                                    'OB_Description__c,'+ 
                                                    'OB_Old_Enablement__c,'+
                                                    'OB_Sequence__c,'+
                                                    'RecordType.DeveloperName,'+ 
                                                    'NE__Hidden_in_Cart__c,'+ 
                                                    'NE__CatalogItem__r.NE__Hidden_in_Cart__c ,'+ 
                                                    'NE__CatalogItem__r.NE__Catalog_Category_Name__r.Name,'+
                                                    'NE__CatalogItem__r.NE__Parent_Catalog_Item__c,'+
                                                      'NE__CatalogItem__r.NE__Visible__c,'+
                                                    '  (SELECT id,Name, NE__Value__c, NE__Action__c,NE__FamPropId__c, OB_Attribute_Code__c, ne__old_value__c, '+
                                                                'OB_massimale__c,'+
																'OB_max_absolute__c,'+
																'OB_max_threshold__c,'+
																'OB_min_absolute__c,'+
                                                                'NE__FamPropId__r.NE__FamilyId__r.name,'+ 
                                                                'NE__FamPropId__r.NE__Required__c,' +
                                                                'NE__FamPropId__r.NE__Hidden__c,' +
                                                                'NE__FamPropId__r.NE__HiddenInCart__c,'+
                                                                 'NE__FamPropId__r.NE__ReadOnly__c,'+ 
                                                                 'NE__FamPropId__r.NE__Sequence__c,'+
                                                                'NE__FamPropId__r.NE__PropId__c,'+ 
                                                                 'NE__FamPropId__r.NE__PropId__r.NE__Type__c,'+ //francesca.ribezzi - perf-6_11 - 05/12/19 - adding type for listOfDomains
                                                                 'NE__FamPropId__r.NE__FamilyPropertyCode__c,'+ 
																'OB_min_threshold__c,'+  
                                                                'OB_ReadOnly__c,'+ 
                                                                'NE__Order_Item__c'+ 
                                                       ' FROM NE__Order_Item_Attributes__r ORDER BY NE__FamPropId__r.NE__Sequence__c'+
                                                        ') '+
                                                        ' FROM NE__OrderItem__c '+
                                                        ' WHERE NE__OrderId__c = \'' + orderId + '\''+  
                                                        '' + filter +'' +  
                                                        ' AND NE__Status__c != \'' + OB_UtilityConstants.ORDERITEM_STATUS_CANCELLED  + '\''+
                                                        ' AND NE__Action__c != \'' + OB_UtilityConstants.ORDERITEM_ACTION_REMOVE + '\''+ //davide.franzini - PERF-21 - 09/12/2019
                                                        ' ORDER BY ' + sequenceFilter;  //francesca.ribezzi perf-9 -05/12/19 - order by sequence added for attributes and items
           System.debug('query: ' + query); //  francesca.ribezzi perf-32 -17/12/19 - order by sequence filtered by pricing and enablements 
            List<NE__OrderItem__c> orderItems = Database.query(query); 
            if(orderItems.size() == 0){
                return null;
            }
           //START francesca.ribezzi - perf-6_11 - 05/12/19 - adding list of domains
           List<NE__PropertyDomain__c> listOfDomains = [SELECT id, name,NE__PropId__c FROM NE__PropertyDomain__c WHERE NE__Ineligible__c  = false]; //add where catalogo = nexi
            Map<String, List<String>> domainsMap = new Map<String, List<String>>();
            for(NE__PropertyDomain__c propDom : listOfDomains){
                if(domainsMap.containsKey(String.valueOf(propDom.NE__PropId__c))){
                    domainsMap.get(propDom.NE__PropId__c).add(propDom.Name);
                }else{
                    domainsMap.put(String.valueOf(propDom.NE__PropId__c), new List<String>{propDom.Name});
                }
            }
            //START francesca.ribezzi - perf-6_11 - 05/12/19
            for(NE__OrderItem__c currentItem : orderitems){   
                CompleteMap completeMap = new CompleteMap();
                //Map<String, Map<String, Object>>
                    //fields, nomeCampo, valore
                map<String, Object> itemFields  =  completeMap.fields;
                itemFields.put('catalogitemid',currentItem.NE__CatalogItem__c);
                itemFields.put('parentvid', OB_Utility.isnull(currentItem.NE__Parent_Order_Item__r.NE__Item_Code__c,'')); 
                itemFields.put('rootvid', OB_Utility.isnull(currentItem.NE__Parent_Order_Item__r.NE__Item_Code__c,'')); 
                //itemFields.put('pickedby','human');
                //28/03/19 francesca.ribezzi adding termId node:
                itemFields.put('OB_TermId__c',currentItem.OB_TermId__c); 
                itemFields.put('vid',currentItem.NE__Item_Code__c);
                itemFields.put('itemCode',currentItem.NE__Item_Code__c);//GC 4.0.7
                itemFields.put('parent',currentItem.NE__CatalogItem__r.NE__Parent_Catalog_Item__c);
                itemFields.put('id',currentItem.id);
            // itemFields.put('type',currentItem.NE__CatalogItem__r.NE__Type__c); 
                itemFields.put('action',currentItem.NE__Action__c); 
                itemFields.put('status',currentItem.NE__Status__c);  
                itemFields.put('qty',1);
                itemFields.put('OB_enablement__c',currentItem.OB_Enablement__c); 
                //  START antonio.vatrano perf 39 10/12/2019
                if(currentItem.NE__Action__c == 'None' && currentItem.OB_Enablement__c != currentItem.OB_Old_Enablement__c)
                {
                    itemFields.put('OB_enablement__c',currentItem.OB_Old_Enablement__c); 
                } 
                //  END antonio.vatrano perf 39 10/12/2019
                itemFields.put('OB_Old_Enablement__c',currentItem.OB_Old_Enablement__c); 
                itemFields.put('categoryname',currentItem.NE__CatalogItem__r.NE__Catalog_Category_Name__r.Name); 
                itemFields.put('OBCodiceSfd',currentItem.NE__ProdId__r.OB_Codice_sfdc__c);
                itemFields.put('RecordTypeName',currentItem.NE__ProdId__r.RecordType.DeveloperName);
                itemFields.put('readonly',currentItem.OB_RO__c);
                itemFields.put('productid',currentItem.NE__ProdId__c);
                itemFields.put('productname',currentItem.NE__ProdName__c);
                itemFields.put('hiddenInCart',currentItem.NE__CatalogItem__r.NE__Hidden_in_Cart__c);
                itemFields.put('sequence',currentItem.OB_Sequence__c);
                itemFields.put('OB_Sequence__c',currentItem.OB_Sequence__c);
                itemFields.put('OB_Description__c',currentItem.OB_Description__c);
                itemFields.put('OB_Ro__c',currentItem.OB_Ro__c);
                itemFields.put('OB_Visible__c',currentItem.OB_Visible__c);
                itemFields.put('visible',currentItem.NE__CatalogItem__r.NE__Visible__c );
                itemFields.put('hidden',currentItem.NE__CatalogItem__r.NE__Hidden_in_Cart__c); 
                completeMap.fields = itemFields;
          

                for(NE__Order_Item_Attribute__c currentAttr : currentItem.NE__Order_Item_Attributes__r){    
                   
                    AttributeFiels  attributeFiels = new AttributeFiels();
                   //START francesca.ribezzi - perf-6_11 - 05/12/19 - adding list of domains
                    List<String> currentDomList = domainsMap.get(String.valueOf(currentAttr.NE__FamPropId__r.NE__PropId__c));
                    List<listOfDomains> listOfDom = new list<listOfDomains>();
                    if(currentDomList != null ){
                        for(String dom : currentDomList){
                            listOfDomains templistOfDom = new listOfDomains();
                            map<String, Object> domFields  = templistOfDom.fields; 
                            domFields.put('value', dom);
                            templistOfDom.fields = domFields; 
                            listOfDom.add(templistOfDom);
                        }  
                    }
                    attributeFiels.listOfDomains= listOfDom;  
                    //END francesca.ribezzi - perf-6_11 - 05/12/19

                    map<String, Object> attrFields  = attributeFiels.fields; 
                    if(isPricing){
                        attrFields.put('OB_MIn_Absolute__c',currentAttr.ob_min_absolute__c);
                        attrFields.put('OB_Massimale__c',currentAttr.ob_massimale__c);
                        attrFields.put('OB_Max_Absolute__c',currentAttr.ob_max_absolute__c);
                        attrFields.put('OB_Max_Threshold__c',currentAttr.ob_max_threshold__c);
                        attrFields.put('OB_Min_Threshold__c',currentAttr.ob_min_threshold__c);
                    }
                    attrFields.put('familyname',currentAttr.NE__FamPropId__r.NE__FamilyId__r.name);  
                    attrFields.put('OB_Attribute_Code__c',currentAttr.ob_attribute_code__c);  
                    attrFields.put('attributeCode',currentAttr.NE__FamPropId__r.NE__FamilyPropertyCode__c);   //francesca.ribezzi 02/12/19 - performance - attribute code is equal to familyPropCode
                    attrFields.put('Old_Value__c',currentAttr.ne__old_value__c);
                    attrFields.put('value',currentAttr.ne__value__c);     
                    attrFields.put('name',currentAttr.Name);    
                    attrFields.put('action',currentAttr.NE__Action__c);    
                    attrFields.put('id',currentAttr.id);    
                    attrFields.put('idLineAttribute',currentAttr.id);
                    attrFields.put('lineId',currentAttr.NE__Order_Item__c); //TO DO check lineId
                    attrFields.put('required',currentAttr.NE__FamPropId__r.NE__Required__c);
                    attrFields.put('hidden',currentAttr.NE__FamPropId__r.NE__Hidden__c); 
                    attrFields.put('readonly',currentAttr.NE__FamPropId__r.NE__ReadOnly__c);     
                    attrFields.put('sequence',currentAttr.NE__FamPropId__r.NE__Sequence__c); 
                    attrFields.put('propid',currentAttr.NE__FamPropId__r.NE__PropId__c  );   
                    attrFields.put('type',currentAttr.NE__FamPropId__r.NE__PropId__r.NE__Type__c);  // francesca.ribezzi - perf-6_11 - 05/12/19 - adding type

                    attributeFiels.fields = attrFields;
                    completeMap.listOfAttributes.add(attributeFiels);        
                }
                outputMap.put(currentItem.Id,JSON.serialize(completeMap));
            }
            system.debug(LoggingLevel.INFO, '## outputMap: '+JSON.serializePretty(outputMap)); 
            return outputMap;
        }catch(Exception E){
            System.debug('Generic Error: '+e.getMessage()+ ' at line: '+e.getLineNumber()+' stack trace: '+e.getStackTraceString());
            return null;

        } 
    }    

   	/*******************************************************************************
         AUTHOR:  Francesca Ribezzi                  
         Created:   29/11/2019           
         Description: Performance
         class used to relate orderItem and attributes 
    */     
    public class CompleteMap{ 
        Map<String, Object> fields{get; set;}
        List<AttributeFiels> listOfAttributes{get; set;}	
        List<Object> childItems{get; set;}
        public CompleteMap(){
            fields = new  Map<String, Object>();
            listOfAttributes = new List<AttributeFiels>();
            childItems = new List<Object>(); 
        }   
    }
    public class AttributeFiels{
        Map<String, Object> fields {get; set;}
        List<listOfDomains> listOfDomains {get; set;} 
        public AttributeFiels(){
            fields = new  Map<String, Object>();
            listOfDomains = new List<listOfDomains>();
        }
    }
    // francesca.ribezzi - perf-6_11 - 05/12/19 - adding listOfDomains node
    public class listOfDomains{
        Map<String, Object> fields {get; set;}
        public listOfDomains(){
            fields = new  Map<String, Object>();
        }
    }



}