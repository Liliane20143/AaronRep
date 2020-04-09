public without sharing class OB_EnrichOrder { 
    
    public static String GT                     = 'MONETICA';
    public static String OTHER                  = 'Other';  //francesca.ribezzi 17/09/19 - WN-420 - adding other for GT 
    public static String SIA                    = 'SIA';
    public static String EQUENS                 = 'EQUENS';

    public static String TERMINALE              = 'Terminali';
    public static String GATEWAY                = 'Gateway_Virtuale';
    public static String COMMISSIONE            = 'Commissione';
    public static String ACQUIRING              = 'Acquiring';
    public static String VAS                    = 'Vas';
    public static String PRICING                = 'Pricing';
    public static String PAGOBANCOMAT           = 'Pagobancomat'; 
    public static String NEXI                   = 'NEXI';
    public static String PCI                    = 'PCI';
    public static String UNATTENDED             = 'POS_TERZI_UNATTENDED';
    public static String ALBERGIAUTONOLEGGI     = 'ALB_AUTO';
    public static String ONECLICK               = 'ONECLICK';
    public static String RECURRING              = 'RECURRING';
    public static String TRANS_DINAMICA         = 'TRANS DINAMICA';
    public static String TRANS_STATICA          = 'TRANS STATICA';
     //START Simone Misani WN-1333
    public static String ECOMMERCERT            = 'eCommerce';
    public static String INTEGRAZIONE           = 'Integrazione';
    public static String APM                    = 'APM';
    public static String MOTORT                 = 'Moto';
     //END Simone Misani WN-1333
    public static String ECOMMERCE              = 'ECOMM';
    public static String MOTO                   = 'MOTO';
    public static String PETROL                 = '5542';
    public static String ADD                    = 'Add';
    public static String ACTIVE                 = 'Active';
    public static String NONE                   = 'None';
    public static String DISCONNECT             = 'Remove';
    public static String CHANGE                 = 'Change';

    public static Boolean setConfigurationInformation(Id confId){
        //TODO: insert right start date
        system.debug('@@ confId: '+confId);
        Date startDate = Date.today();
        
        List<NE__OrderItem__c> configItemList = getItemList(confId);
        system.debug('@@ confconfigItemListId: '+configItemList);
        if(configItemList.size()>0){

            orderInfo order                 = new orderInfo(configItemList);

            associativeCode keyToUse        = selectEternalRow(order);

            System.debug('skip GT:' + JSON.serialize(order));
            system.debug('@@KEY: '+keyToUse);
            system.debug('@@Config Item List:'+configItemList);

            String mccDescription ='';
            // 18/03/2019 NEED TO REFRESH THE ITEM LIST
            // BECAUSE ORDERINFO CAN UPDATE CONFIGURATION
            configItemList = getItemList(confId);

            
            //  START   micol.ferrari 13/12/2018 - FROM KEYTOUSE TO ORDER AND REMOVE TRY/CATCH
            //try{               
                //mccDescription = [SELECT Id,Name FROM NE__Lov__c where ne__type__c = 'mcc' and NE__value3__c = 'L3' and NE__Value2__c =: keyToUse.orderL3 LIMIT 1].Name;                           
            //} catch(exception e){
            //    //system.debug('@@@ L3 DESCRIPTION MISSING');
            //}
            NE__Order__c orderToUpdate = new NE__Order__c();
            orderToUpdate.Id=order.orderId;

            // DG - 21/03/2019 - CONS-157
            if(!String.isBlank(order.existingCode.CTI)){
               orderToUpdate.OB_CTI_Code__c = keyToUse.CTI;
            }

            if(String.isNotBlank(order.orderL3)){
                mccDescription = [SELECT Id,Name FROM NE__Lov__c where ne__type__c = 'mcc' and NE__value3__c = 'L3' and NE__Value2__c =: order.orderL3 LIMIT 1].Name;
            //  END   micol.ferrari 13/12/2018 - FROM KEYTOUSE TO ORDER AND REMOVE TRY/CATCH
                system.debug('@@ mccDescription:'+mccDescription);
                //  START   micol.ferrari 13/12/2018 - FROM KEYTOUSE TO ORDER
                //orderToUpdate.OB_MCC__c= keyToUse.orderL3;
                //orderToUpdate.OB_MCCL2__c=keyToUse.orderL2;
                orderToUpdate.OB_MCC__c     = order.orderL3;
                orderToUpdate.OB_MCCL2__c   = order.orderL2;
            //  END   micol.ferrari 13/12/2018 - FROM KEYTOUSE TO ORDER
            }
            
            
            //START D.F 15/01/2019
            orderToUpdate.OB_Business_Model_Acquiring__c    = order.busModel;
            orderToUpdate.OB_Business_Model_POS__c          = order.busModelPOS;
            //END D.F 15/01/2019

            // Start AV 07/03/2019 cons127 billingProfile
            if(order.isMaintenance && order.isPricing)
            {
                orderToUpdate.NE__BillingProfId__c = order.bpGT;
                orderToUpdate.OB_BankAccount_Acquiring__c = order.bpAcqVAS;
            }


            // end AV 07/03/2019 cons127 billingProfile
            
            orderToUpdate.OB_MCC_Description__c = mccDescription;
            orderToUpdate.NE__ConfigurationStatus__c ='Valid';

            NE__Order_Header__c header  = new NE__Order_Header__c();
            header.id                   = order.headerId;
            header.OB_PEP__c            =  order.isPEP;

            List<NE__OrderItem__c> itemToUpdate = new List<NE__OrderItem__c>();
            List<NE__Order_Item_Attribute__c> attributesToUpdate  = new List<NE__Order_Item_Attribute__c>();

            for(NE__OrderItem__c lineItem : configItemList){
                
                if (!(lineItem.NE__Action__c == ADD)){
                    continue;
                }
                //system.debug('Item:'+lineItem);
                 //START Simone Misani WN-1333
                if(lineItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.TERMINALE || lineItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.GATEWAY || lineItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.ECOMMERCERT ||
                lineItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.MOTORT|| (lineItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.VAS && (lineItem.NE__ProdId__r.OB_Codice_sfdc__c == ONECLICK||lineItem.NE__ProdId__r.OB_Codice_sfdc__c == RECURRING))){
                 
                    lineItem.OB_GT__c = keyToUse.gt;
                    if(order.isFisico || (order.isMaintenance && !order.isFisico)){
                            lineItem.OB_ShopCode__c = keyToUse.shopCode;
                        }   //END Simone Misani WN-1333                
                    lineItem.OB_CustomerCode__c = keyToUse.customerCode;
                    lineItem.OB_Conventioncode__c = keyToUse.conventionCode;
                }

                if(((lineItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.ACQUIRING && lineItem.NE__ProdId__r.OB_Acquirer__c==OB_EnrichOrder.NEXI)|| lineItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.VAS || lineItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.INTEGRAZIONE ||  lineItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.APM ) && lineItem.NE__Parent_Order_Item__c ==null){ //

                        lineItem.OB_Processor__c            = keyToUse.processor;
                        if(order.isFisico || (order.isMaintenance && !order.isFisico)){
                            lineItem.OB_CompanyCode__c          = keyToUse.companyCode;
                        }//END Simone Misani WN-1333
                        lineItem.OB_ServicePointCode__c     = keyToUse.servicePointCode;
                        //TO DO xPAY FULL  -- scommentare 
                        //lineItem.OB_ServicePointType__c     = keyToUse.servicePointType;
                        if(order.isFisico) {
                            lineItem.OB_ServicePointType__c = 'FISICO';                         
                        }

                 
                }


                if((lineItem.NE__ProdId__r.RecordType.DeveloperName != OB_EnrichOrder.PRICING) && lineItem.NE__Parent_Order_Item__c !=null){

                    lineItem.OB_Processor__c        = keyToUse.conventionCodeSource;
                    lineItem.OB_ShopCode__c         = keyToUse.shopCode;
                    lineItem.OB_CustomerCode__c     = keyToUse.customerCode;
                    lineItem.OB_Conventioncode__c   = keyToUse.conventionCode;
                }
                
                //if(lineItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.TERMINALE){
                    if(lineItem.NE__Order_Item_Attributes__r.size()>0 && !String.isEmpty(lineItem.NE__Order_Item_Attributes__r[0].NE__Value__c)){
                        lineItem.OB_TermId__c = lineItem.NE__Order_Item_Attributes__r[0].NE__Value__c;
                    }
                                

                //}

                lineItem.OB_ProposerABI__c                      = lineItem.NE__OrderId__r.NE__Order_Header__r.OB_ProposerABI__c;
                lineItem.NE__Service_Point__c                   = lineItem.NE__OrderId__r.OB_Service_Point__c;
                lineItem.NE__BillingProfId__c                   = lineItem.NE__OrderId__r.NE__BillingProfId__c;
                lineItem.OB_DebitProfId__c                      = lineItem.NE__OrderId__r.NE__BillingProfId__c;
                lineItem.OB_Billing_Profile_Credit_Acquiring__c = lineItem.NE__OrderId__r.OB_BankAccount_Acquiring__c;
                lineItem.OB_BankAccount_Debit_Acquiring__c      = lineItem.NE__OrderId__r.OB_BankAccount_Acquiring__c;
                //TODO remove
                
                lineItem.NE__StartDate__c                       =startDate;
                
                
                if(lineItem.NE__ProdId__r.OB_Acquirer__c==OB_EnrichOrder.NEXI && lineItem.NE__Parent_Order_Item__c ==null){
                    lineItem.OB_SettlementMethod__c = lineItem.NE__OrderId__r.OB_InternationalSettlementMethod__c;
                }

                if((lineItem.NE__ProdId__r.RecordType.DeveloperName != OB_EnrichOrder.PRICING) && lineItem.NE__Parent_Order_Item__c !=null){

                    if(lineItem.NE__ProdId__r.RecordType.DeveloperName== PAGOBANCOMAT){
                        lineItem.OB_SettlementMethod__c = lineItem.NE__OrderId__r.OB_PBSettlementMethod__c;
                    }else if(lineItem.NE__ProdId__r.RecordType.DeveloperName != OB_EnrichOrder.PRICING && lineItem.NE__ProdId__r.OB_Acquirer__c==OB_EnrichOrder.NEXI){
                        lineItem.OB_SettlementMethod__c = lineItem.NE__OrderId__r.OB_InternationalSettlementMethod__c;
                    }
                }

                //lineItem.OB_MCC__c   = keyToUse.orderL3;
                //lineItem.OB_MCCL2__c = keyToUse.orderL2;
                lineItem.OB_MCC__c   = order.orderL3;
                lineItem.OB_MCCL2__c = order.orderL2;
                lineItem.NE__AssetItemEnterpriseId__c = lineItem.Id; 
                itemToUpdate.add(lineItem);


            }   
            //system.debug('@@ITEM LIST: '+ itemToUpdate);
            //LUBRANO -- FIX DUPLICAZIONE ATTRIBUTI
            List<NE__Order_Item_Attribute__c> attributes = getAllAttributes(confId);
            for(NE__Order_Item_Attribute__c attr : attributes){
                attr.NE__AttrEnterpriseId__c  = attr.Id;
                attributesToUpdate.add(attr);
            }

            update attributesToUpdate;
            update itemToUpdate;   
            update orderToUpdate;
            update header;
            return true;
        } 
        

        return false;

    } 
    public static associativeCode selectEternalRow(orderInfo order){

            Map<String,List<associativeCode>> externalKey = getExternalKey(order);
            //system.debug('externalKey: ' + JSON.serialize(externalKey));
            associativeCode keyToUse = new associativeCode(order);
            //system.debug('keyToUse: '+keyToUse);

            Boolean codeNotFound= true;

        System.debug( 'debug : ! ' + order + ' code not found ' + codeNotFound );   //francesca.ribezzi 17/09/19 - WN-420 - skip this if gt is other
            if(order.isUnattended && codeNotFound && !order.skipGT && order.hasPos && !order.isOther){//antonio.vatrano 06/09/2019 wn373
                //SE UNATTENDED USO SIA
                if(externalKey.containsKey(OB_EnrichOrder.SIA)){
                    for(associativeCode t : externalKey.get(OB_EnrichOrder.SIA)){
                        if(t.isValid){
                            keyToUse = t;
                            if(String.isNotEmpty(t.servicePointCode)){
                                codeNotFound = false;
                            }
                            break;
                        }
                    }
                }
            } 
            
            if(!order.isUnattended && codeNotFound && !order.skipGT && order.hasPos){//antonio.vatrano 06/09/2019 wn373
                //SE DIVERSO DA UNATTENDED USO EQUENS
                if(externalKey.containsKey(OB_EnrichOrder.EQUENS)){
                    for(associativeCode t : externalKey.get(OB_EnrichOrder.EQUENS)){
                        if(t.isValid){
                            keyToUse = t;
                            if(String.isNotEmpty(t.servicePointCode)){
                                codeNotFound = false;
                            }
                            break;
                        }
                    }
                }
            } 
                                                                                //francesca.ribezzi 17/09/19 - WN-420 - skip this if gt is other 
            if(codeNotFound && !order.skipAcquiring && order.hasAcquiring && !order.isOther){ //antonio.vatrano 06/09/2019 wn373
                //SE SIA NON ESISTE CERCO MONETICA CON OB_ConventionCodeSource__c DIEVRSO DA SIA (EQUENS)
                if(externalKey.containsKey(OB_EnrichOrder.GT)){
                    for(associativeCode gtRow: externalKey.get(OB_EnrichOrder.GT)){
                        if(gtRow.conventionCodeSource != OB_EnrichOrder.SIA && gtRow.isValid){
                            if(String.isNotEmpty(keyToUse.companyCode)){
                                keyToUse.gt                     = gtRow.gt;
                                keyToUse.customerCode           = gtRow.customerCode;
                                keyToUse.shopCode               = gtRow.shopCode;
                                keyToUse.conventionCode         = gtRow.conventionCode ;
                                keyToUse.conventionCodeSource   = gtRow.conventionCodeSource;
                                keyToUse.OBPBSettlementMethod   = gtRow.OBPBSettlementMethod;
                                codeNotFound = false;
                                break;
                            }
                            keyToUse = gtRow;
                            codeNotFound = false;
                            break;
                        }
                    }
                }
            }

            //system.debug('final Key to use: ' + JSON.serialize(keyToUse));
            return keyToUse;
    }

    public static Map<String,List<associativeCode>>  getExternalKey(orderInfo order){
        Id merchantId           = order.merchantId;
        Id servicePointId       = order.servicePointId;
        String busModel         = order.busModel;
        String pricingType      = order.pricingType;
        String fisico           = 'Fisico';
        Id proposerAbiId        = order.merchantId;
        String shopSign         = order.shopSign;
        String orderL2          = order.orderL2;
        String orderL3          = order.orderL3;
        String orderId          = order.orderId;

        //system.debug('Pricing Type:'+ pricingType);
        //system.debug('Merchant Id:'+ merchantId);

        String query  = 'SELECT Id,MIG_Batch_ID__c,Mig_External_ID__c,MIG_Run_ID__c, Name, OB_Business_Model__c, ';
               query += 'OB_Company_End_Reason__c,OB_Conventioncode__c,OB_CTICode__c,OB_CustomerCodeClientCode__c,';
               query += 'OB_Description__c,OB_EcommerceType__c,OB_End_Date__c,';
               query += 'OB_isCarRentalisHotel__c,OB_isMoTo__c, OB_Merchant_ID__c, ';
               query += 'OB_Pricing__c,OB_ReportTypeFormat__c,OB_ReportType__c,OB_ServicePointCodeShopCode__c, ';
               query += 'OB_Service_Point_ID__c,OB_Service_Point_Type__c,OB_SionID__c,OB_Source__c,OB_Start_Date__c, OB_ConventionCodeSource__c,';
               query += 'OB_PBSettlementMethod__c,OB_InternationalSettlementMethod__c, OB_MCC__c, OB_MCCL2__c, ';
               query += 'OB_ToBeChecked__c FROM ExternalSourceMapping__c ';
               query += 'WHERE (OB_Merchant_ID__c = : merchantId OR (OB_Service_Point_ID__c =: servicePointId ';
        //Start antonio.vatrano 13/06/2019 r1f2-229       
        if(String.isNotEmpty(orderL3)){
            query += ' AND OB_MCC__c =: orderL3 ';
        }
        else{
            query += ' AND OB_MCCL2__c =: orderL2 ';
        }
        if(order.isFisico){
            query += ' AND OB_isMoTo__c = false ';
        }           
        query += 'AND OB_ShopSign__c =: shopSign AND OB_Pricing__c =: pricingType))';

        //query += 'AND OB_Business_Model__c =: busModel AND OB_Pricing__c =: pricingType  AND OB_ToBeChecked__c=false ';
        // query += '  AND OB_ToBeChecked__c=false ';
         //End antonio.vatrano 13/06/2019 r1f2-229  
        
        
        List<ExternalSourceMapping__c> externalMapping = Database.query(query);
        //system.debug('@@ externalMapping query' + query);
        //system.debug('@@ externalMapping'+externalMapping);

        Map<String,List<associativeCode>> associativeTable = new Map<String,List<associativeCode>>();
        Map<String,Map<String,associativeCode>> gtCodes = new Map<String,Map<String,associativeCode>>();
         Map<String,String> pvCodes = new Map<String,String>();
        
        for (ExternalSourceMapping__c associativeRow: externalMapping ){
            
            String nexiSystem = associativeRow.OB_Source__c;
            List<associativeCode> tmpCodes = new List<associativeCode>();
            
            if(associativeTable.containsKey(nexiSystem)){
                tmpCodes = associativeTable.get(nexiSystem);
            }
            associativeCode tmpAssociativeCode = new associativeCode(order);
            if(nexiSystem == OB_EnrichOrder.GT){
                tmpAssociativeCode.gt                   = associativeRow.OB_Source__c;
                tmpAssociativeCode.CTI                  = associativeRow.OB_CTICode__c;
                tmpAssociativeCode.customerCode         = associativeRow.OB_CustomerCodeClientCode__c;
                tmpAssociativeCode.shopCode             = associativeRow.OB_ServicePointCodeShopCode__c;
                tmpAssociativeCode.conventionCode       = associativeRow.OB_Conventioncode__c ;
                tmpAssociativeCode.conventionCodeSource = associativeRow.OB_ConventionCodeSource__c ;
                tmpAssociativeCode.OBInternationalSettlementMethod = associativeRow.OB_PBSettlementMethod__c;
                tmpAssociativeCode.orderL2              = associativeRow.OB_MCCL2__c;
                tmpAssociativeCode.orderL3              = associativeRow.OB_MCC__c;

                Map<String,associativeCode> t = new Map<String,associativeCode>();
                t.put(associativeRow.OB_Conventioncode__c,tmpAssociativeCode);
                gtCodes.put(associativeRow.OB_ConventionCodeSource__c, t);

            }else if(nexiSystem == OB_EnrichOrder.EQUENS || (nexiSystem == OB_EnrichOrder.SIA && associativeRow.OB_Business_Model__c==busModel)){
                //system.debug('@@ nexiSystem: ' + nexiSystem);
                //system.debug('@@ associativeRow.OB_Business_Model__c: ' + associativeRow.OB_Business_Model__c);
                //system.debug('@@ busModel: ' + busModel);

                tmpAssociativeCode.processor            = associativeRow.OB_Source__c;
                tmpAssociativeCode.companyCode          = associativeRow.OB_CustomerCodeClientCode__c;
                
                //system.debug('@@ cond1: ' + (nexiSystem == OB_EnrichOrder.SIA));
                //system.debug('@@ cond2: ' + (nexiSystem == OB_EnrichOrder.EQUENS && associativeRow.OB_Business_Model__c == busModel));

                if(nexiSystem == OB_EnrichOrder.SIA || (nexiSystem == OB_EnrichOrder.EQUENS && associativeRow.OB_Business_Model__c == busModel)){
                    
                    tmpAssociativeCode.servicePointCode     = associativeRow.OB_ServicePointCodeShopCode__c;
                    tmpAssociativeCode.servicePointType     = associativeRow.OB_Service_Point_Type__c;
                    tmpAssociativeCode.OBPBSettlementMethod = associativeRow.OB_PBSettlementMethod__c;
                    //system.debug('@@ tmpAssociativeCode.servicePointCode: ' + tmpAssociativeCode.servicePointCode);
                    if(String.isNotEmpty(associativeRow.OB_ServicePointCodeShopCode__c)){
                        pvCodes.put(associativeRow.OB_ServicePointCodeShopCode__c,'');
                    }
                }
                
                //tmpAssociativeCode.orderL2              = associativeRow.OB_MCCL2__c;
                //tmpAssociativeCode.orderL3              = associativeRow.OB_MCC__c;
            }
            tmpCodes.add(tmpAssociativeCode);
            associativeTable.put(nexiSystem,tmpCodes);  
        }

        //Filtrare il codice OB_ConventionCodeSource__c e verificare se ci sono Ordini/Asset associati
        // nel caso in cui esista eiminare il codice dal gt
        Map<String,Map<String,String>> codeToExclude = new Map<String,Map<String,String>>();
        system.debug('pvCodes size ' + pvCodes.Size());
        system.debug('pvCodes empty ' + pvCodes.keyset().isEmpty());
        system.debug('pvCodes ' + pvCodes);
        if(pvCodes.Size()>0){
            for(NE__OrderItem__c item: [SELECT Id,OB_ShopCode__c,OB_ServicePointCode__c,OB_Processor__c 
                                        FROM NE__OrderItem__c 
                                        WHERE (OB_ShopCode__c in: pvCodes.keyset() OR OB_ServicePointCode__c in: pvCodes.keyset()) AND NE__OrderId__c !=:orderId and NE__Account__c=: merchantId LIMIT 200000]){
                    
                Map<String,String> tmpMap = new Map<String,String>();
                if( codeToExclude.containsKey(item.OB_Processor__c)){
                    tmpMap=codeToExclude.get(item.OB_Processor__c);
                }
                if(String.isNotBlank(item.OB_ShopCode__c)){
                   tmpMap.put(item.OB_ShopCode__c,item.OB_ShopCode__c) ;    
                }
                if(String.isNotBlank(item.OB_ServicePointCode__c)){
                    tmpMap.put(item.OB_ServicePointCode__c,item.OB_ServicePointCode__c); 
                }
                codeToExclude.put(item.OB_Processor__c,tmpMap);
            }
            
            for(Asset assetRow:  [SELECT Id,OB_ShopCode__c,OB_ServicePointCode__c,OB_Processor__c 
                                  FROM Asset 
                                  WHERE (OB_ShopCode__c in: pvCodes.keyset() OR OB_ServicePointCode__c in: pvCodes.keyset()) AND AccountId=: merchantId LIMIT 200000]){
                
                Map<String,String> tmpMap = new Map<String,String>();
                if( codeToExclude.containsKey(assetRow.OB_Processor__c)){
                    tmpMap=codeToExclude.get(assetRow.OB_Processor__c);
                }
                if(String.isNotBlank(assetRow.OB_ShopCode__c)){
                   tmpMap.put(assetRow.OB_ShopCode__c,assetRow.OB_ShopCode__c);     
                }
                if(String.isNotBlank(assetRow.OB_ServicePointCode__c)){
                    tmpMap.put(assetRow.OB_ServicePointCode__c,assetRow.OB_ServicePointCode__c); 
                }
                codeToExclude.put(assetRow.OB_Processor__c,tmpMap);
            }
        }
        ////system.debug('@@ gtCodes: ' + JSON.serialize(gtCodes));
        ////system.debug('@@ associativeTable: ' + JSON.serialize(associativeTable));
        ////system.debug('@@ codeToExclude: ' + codeToExclude);

        for(String nexiSystem :codeToExclude.keySet()){
            if(gtCodes.containsKey(nexiSystem)){
                for(String alreadyUsedCode :codeToExclude.get(nexiSystem).keyset()){
                    associativeCode result = gtCodes.get(nexiSystem).remove(alreadyUsedCode); 
                }
            }
        }
        

        for(String nexiSystem : associativeTable.keySet() ){
            if(nexiSystem != OB_EnrichOrder.GT){
                //system.debug('@@ nexiSystem2' + nexiSystem);
                for(associativeCode processor : associativeTable.get(nexiSystem)){
                    //system.debug('@@ processor' + processor.processor);
                    //system.debug('@@ processor.servicePointCode: ' + processor.servicePointCode);
                    //system.debug('@@ processor2 ' + gtCodes.containsKey(processor.processor));

                    if(gtCodes.containsKey(processor.processor)){
                        //system.debug('@@ servicePointCode ' + gtCodes.get(processor.processor).containsKey(processor.servicePointCode));
                        if(gtCodes.get(processor.processor).containsKey(processor.servicePointCode)){
                            
                            associativeCode tmpAssociativeCode = gtCodes.get(processor.processor).get(processor.servicePointCode);
                            processor.gt                    = tmpAssociativeCode.gt;
                            processor.customerCode          = tmpAssociativeCode.customerCode;
                            processor.shopCode              = tmpAssociativeCode.shopCode;
                            processor.conventionCode        = tmpAssociativeCode.conventionCode;
                            processor.conventionCodeSource  = tmpAssociativeCode.conventionCodeSource;
                            processor.OBInternationalSettlementMethod = tmpAssociativeCode.OBInternationalSettlementMethod;
                        } else{
                            processor.isValid = false;
                        }
                    }
                }
            }else{
                for(associativeCode gt : associativeTable.get(nexiSystem)){
                    if(!gtCodes.containsKey(gt.conventionCodeSource)){
                        gt.isValid = false;
                    }
                }
            }
        }

        return associativeTable;
    }

    public static List<NE__OrderItem__c> getItemList(Id confId){
        return [SELECT Id,createdDate,NE__OrderId__r.NE__Order_Header__r.OB_Business_Model_Acquiring__c, NE__OrderId__r.OB_ShopSign__c,NE__OrderId__r.OB_MCCL2__c,NE__OrderId__r.OB_MCC__c,
                                                NE__OrderId__r.NE__Order_Header__r.OB_Business_Model_POS__c,NE__Account__c ,NE__OrderId__c,OB_MCCL2__c,OB_MCC__c,
                                                NE__OrderId__r.OB_Service_Point__c, NE__Parent_Order_Item__c,NE__OrderId__r.NE__Order_Header__r.OB_ProposerABI__c,
                                                NE__OrderId__r.NE__BillingProfId__c, NE__OrderId__r.OB_BankAccount_Acquiring__c, NE__OrderId__r.NE__Order_Header__c,
                                                NE__OrderId__r.OB_FormulaPBSettlementMethod__c,NE__OrderId__r.OB_FormulaInternationalSettlementMethod__c,NE__Action__c,OB_GT__c,OB_CustomerCode__c,
                                                OB_ShopCode__c,OB_Conventioncode__c,OB_SettlementMethod__c,OB_Processor__c,OB_ServicePointCode__c,OB_ServicePointType__c,OB_CompanyCode__c, 
                                                NE__ProdId__r.OB_Acquirer__c,NE__ProdId__r.OB_Codice_sfdc__c,NE__ProdId__r.RecordType.DeveloperName,NE__OrderId__r.NE__Order_Header__r.OB_Main_Process__c,NE__OrderId__r.NE__Order_Header__r.OB_Sub_Process__c,
                                                NE__BillingProfId__c,OB_Billing_Profile_Credit_Acquiring__c, NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName  //AV CONS127
                                                ,NE__OrderId__r.OB_SettlementType__c,NE__OrderId__r.OB_PBSettlementMethod__c,NE__OrderId__r.OB_InternationalSettlementMethod__c, NE__OrderId__r.OB_GT__c //francesca.ribezzi 17/09/19 - WN-420 - adding gt on config
                                                ,(select id,Name,NE__Action__c,NE__FamPropExtId__c, NE__Value__c,NE__Old_Value__c from NE__Order_Item_Attributes__r where name ='Terminal Id')
                                                FROM NE__OrderItem__c WHERE NE__OrderId__c =  :confId];
    }

    public static List<NE__Order_Item_Attribute__c> getAllAttributes(Id confId){
        return [SELECT id,NE__AttrEnterpriseId__c FROM NE__Order_Item_Attribute__c WHERE NE__Order_Item__r.NE__OrderId__c =:confId  AND NE__Order_Item__r.NE__Action__c = 'Add'];
    } 

    public class associativeCode {  
        //EQUENS/SIA
        public String processor; 
        public String companyCode;
        public String servicePointCode;
        public String servicePointType;
        public String OBInternationalSettlementMethod;
        // GT NEXI
        public String gt;
        public String customerCode;
        public String shopCode;
        public String conventionCode;
        public String conventionCodeSource;
        public String OBPBSettlementMethod;
        public String CTI;
        public Boolean isValid = true;
        public Boolean isPEP;

        public String orderL2;
        public String orderL3;

        associativeCode(){
            
        }
        associativeCode(orderInfo order){
            
            gt          = OB_EnrichOrder.GT;
            processor   = OB_EnrichOrder.EQUENS;
            
            if(order.isUnattended){
                processor = OB_EnrichOrder.SIA;
            }
            //START francesca.ribezzi 17/09/19 - WN-420 - checking if it's other
            if(order.gt == OTHER){
                 gt          = OTHER;
            }
            //END francesca.ribezzi 17/09/19 - WN-420
            orderL2 = order.orderL2;
            orderL3 = order.orderL3;
            isPEP   = order.isPEP;

            if(order.isMaintenance){
                if(order.skipGT){
                    gt                      = order.existingCode.gt;
                    customerCode            = order.existingCode.customerCode;
                    shopCode                = order.existingCode.shopCode;
                    conventionCode          = order.existingCode.conventionCode;
                    conventionCodeSource    = order.existingCode.conventionCodeSource;
                    OBPBSettlementMethod    = order.existingCode.OBPBSettlementMethod;
                    CTI                     = order.existingCode.CTI;

                }

                if(order.skipAcquiring){
                    processor                       = order.existingCode.processor;
                    companyCode                     = order.existingCode.companyCode;
                    servicePointCode                = order.existingCode.servicePointCode;
                    servicePointType                = order.existingCode.servicePointType;
                    OBInternationalSettlementMethod = order.existingCode.OBInternationalSettlementMethod;
                }

            }
        }
    }

    public class orderInfo {  
        Id servicePointId;
        Id merchantId;
        String busModel;
        String busModelPOS;     // ADDED D.F. 15/01/2019

        public String pricingType;
        public Boolean isAlberghiAutonoleggi    = false;
        public Boolean isOneClick               = false;
        public Boolean isRecurring              = false;
        public Boolean isTransStatica           = false;
        public Boolean isDinamica               = false;
        public Boolean isEcomm                  = false;
        public Boolean isMoto                   = false;
        public Boolean isFisico                 = false;
        public Boolean isUnattended             = false;
        public Boolean isPBNexi                 = false;
        public Boolean isPEP                    = false;
        public Boolean skipGT                   = false;
        public Boolean skipAcquiring            = false;
        public Id      proposerAbiId;
        public String shopSign;
        public String orderL2;
        public String orderL3;
        public Id       orderId;
        public Id headerId;
        public Boolean isMaintenance            = false;
        public associativeCode existingCode     ;
        // Start AV 07/03/2019 cons127 billingProfile
        public Id bpGT;
        public Id bpAcqVAS;
        public Boolean isPricing                 = false;
        //Start antonio.vatrano wn373 06/09/2019
        public Boolean hasAcquiring            = false;
        public Boolean hasPos                  = false;
        //End antonio.vatrano wn373 06/09/2019
        public String gt;                                 //francesca.ribezzi 17/09/19 - WN-420 - adding gt node
        public Boolean isOther              = false;     //francesca.ribezzi 17/09/19 - WN-420 - adding isOther node

        public orderInfo(List<NE__OrderItem__c> configItemList){
            existingCode = new associativeCode () ;
            
            servicePointId  = configItemList[0].NE__OrderId__r.OB_Service_Point__c; 
            merchantId      = configItemList[0].NE__Account__c;
            busModel        = configItemList[0].NE__OrderId__r.NE__Order_Header__r.OB_Business_Model_Acquiring__c;
            busModelPOS     = configItemList[0].NE__OrderId__r.NE__Order_Header__r.OB_Business_Model_POS__c;    // ADDED D.F. 15/01/2019
            proposerAbiId   = configItemList[0].NE__OrderId__r.NE__Order_Header__r.OB_ProposerABI__c;
            shopSign        = configItemList[0].NE__OrderId__r.OB_ShopSign__c;
            orderL2         = configItemList[0].NE__OrderId__r.OB_MCCL2__c;
            orderL3         = String.isBlank(configItemList[0].NE__OrderId__r.OB_MCC__c) ? orderL2 : configItemList[0].NE__OrderId__r.OB_MCC__c;
            orderId         = configItemList[0].NE__OrderId__c;
            isPEP           = getPEP(merchantId,proposerAbiId);
            headerId        = configItemList[0].NE__OrderId__r.NE__Order_Header__c;
            isMaintenance   = String.valueOf(configItemList[0].NE__OrderId__r.NE__Order_Header__r.OB_Main_Process__c).equalsIgnoreCase('Maintenance')  ;
            gt              = configItemList[0].NE__OrderId__r.OB_GT__c; // francesca.ribezzi 17/09/19 - WN-420 - adding  GT  node
            isOther         = configItemList[0].NE__OrderId__r.OB_GT__c == OTHER ? true : false;
            //START simone.misani 08/03/2019 - control null object
            System.debug('isPricing: '+String.valueOf(configItemList[0].NE__OrderId__r.NE__Order_Header__r.OB_Sub_Process__c));
            if(String.valueOf(configItemList[0].NE__OrderId__r.NE__Order_Header__r.OB_Sub_Process__c)!= null){
                isPricing       = String.valueOf(configItemList[0].NE__OrderId__r.NE__Order_Header__r.OB_Sub_Process__c).equalsIgnoreCase('variazione economica')  ;
            }
            //END simone.misani 08/03/2019 - control null object
            for (NE__OrderItem__c lineItem: configItemList){
                if (lineItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.COMMISSIONE){
                    pricingType = lineItem.NE__ProdId__r.OB_Codice_sfdc__c;
                }
                //Start antonio.vatrano 06/09/2019 wn373
                if(existingCode.gt == null && lineItem.NE__ProdId__r.RecordType.DeveloperName == TERMINALE){ 
                    if(lineItem.NE__Action__c != DISCONNECT){
                        hasPos = true;
                    }
                    if(lineItem.NE__Action__c== NONE){
                        existingCode.gt                     = lineItem.OB_GT__c;
                        existingCode.customerCode           = lineItem.OB_CustomerCode__c;
                        existingCode.shopCode               = lineItem.OB_ShopCode__c;
                        existingCode.conventionCode         = lineItem.OB_Conventioncode__c;
                        //existingCode.conventionCodeSource   = lineItem.OB_ConventionCodeSource__c;
                        existingCode.OBPBSettlementMethod   = lineItem.OB_SettlementMethod__c;
                        skipGT = true;
                    }
                }
                 //START Simone Misani WN-1333
                if(existingCode.gt == null && (lineItem.NE__ProdId__r.RecordType.DeveloperName == ECOMMERCERT || lineItem.NE__ProdId__r.RecordType.DeveloperName == MOTORT )){
                    if(lineItem.NE__Action__c != DISCONNECT){
                        hasPos = true;
                    }
                    if(lineItem.NE__Action__c== NONE){
                        existingCode.gt                     = lineItem.OB_GT__c;
                        existingCode.customerCode           = lineItem.OB_CustomerCode__c;
                        existingCode.conventionCode         = lineItem.OB_Conventioncode__c;
                        //existingCode.conventionCodeSource   = lineItem.OB_ConventionCodeSource__c;
                        existingCode.OBPBSettlementMethod   = lineItem.OB_SettlementMethod__c;
                        skipGT = true;
                    } //END Simone Misani WN-1333
                }

                if(existingCode.processor == null && lineItem.NE__ProdId__r.RecordType.DeveloperName == ACQUIRING && lineItem.NE__ProdId__r.OB_Acquirer__c == NEXI){
                    if(lineItem.NE__Action__c != DISCONNECT){
                        hasAcquiring = true;
                    }
                    if(lineItem.NE__Action__c== NONE){
                        existingCode.processor                          = lineItem.OB_Processor__c;
                        existingCode.companyCode                        = lineItem.OB_CompanyCode__c;
                        existingCode.servicePointCode                   = lineItem.OB_ServicePointCode__c;
                        existingCode.servicePointType                   = lineItem.OB_ServicePointType__c;
                        existingCode.OBInternationalSettlementMethod    = lineItem.OB_SettlementMethod__c;
                        existingCode.conventionCodeSource               = lineItem.OB_Processor__c;
                        skipAcquiring = true;
                    }
                }
                //END antonio.vatrano 06/09/2019 wn373

                if(lineItem.NE__Action__c== ADD){
                    if(lineItem.NE__ProdId__r.OB_Codice_sfdc__c == OB_EnrichOrder.ALBERGIAUTONOLEGGI)
                        isAlberghiAutonoleggi = true;
                    if(lineItem.NE__ProdId__r.OB_Codice_sfdc__c == OB_EnrichOrder.ONECLICK)
                        isOneClick = true;
                    if(lineItem.NE__ProdId__r.OB_Codice_sfdc__c == OB_EnrichOrder.RECURRING)
                        isRecurring = true;
                    if(lineItem.NE__ProdId__r.OB_Codice_sfdc__c == OB_EnrichOrder.TRANS_STATICA)
                        isTransStatica = true;
                    if(lineItem.NE__ProdId__r.OB_Codice_sfdc__c == OB_EnrichOrder.TRANS_DINAMICA)
                        isDinamica = true;
                    if(lineItem.NE__ProdId__r.OB_Codice_sfdc__c == OB_EnrichOrder.ECOMMERCE)
                        isEcomm = true;
                    if(lineItem.NE__ProdId__r.OB_Codice_sfdc__c == OB_EnrichOrder.MOTO)
                        isMoto = true;
                    if (lineItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.PAGOBANCOMAT && lineItem.NE__ProdId__r.OB_Acquirer__c==OB_EnrichOrder.NEXI){
                        isPBNexi = true;
                    }
                }
                //francesca.ribezzi/simone.misani 02/10/19 - WN-544 - isUnattended moved here - considering it with every kind of action.
                if(lineItem.NE__ProdId__r.OB_Codice_sfdc__c == OB_EnrichOrder.UNATTENDED && orderL3 == OB_EnrichOrder.PETROL){
                    isUnattended = true; 
                }
                
                // Start AV 07/03/2019 cons127 billingProfile //START Simone Misani WN-1333
                if( (lineItem.NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName == TERMINALE || lineItem.NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName == ONECLICK || lineItem.NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName == RECURRING || lineItem.NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName == MOTORT || lineItem.NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName == ECOMMERCERT) && lineItem.NE__Action__c== CHANGE )
                {
                    bpGT = lineItem.NE__BillingProfId__c;
                }
                if((lineItem.NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName == VAS  || lineItem.NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName == INTEGRAZIONE ||  lineItem.NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName == APM||lineItem.NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName == ACQUIRING) && lineItem.NE__Action__c!= NONE )
                { //END Simone Misani WN-1333
                    bpAcqVAS = lineItem.OB_Billing_Profile_Credit_Acquiring__c;
                }
                // END AV 07/03/2019 cons127 billingProfile
                    
            }


            // DG - 21/03/2019 - CONS-157 - START
            List<ExternalSourceMapping__c> exSourceMapList = new List<ExternalSourceMapping__c>();
            String queryString;
            String custCod = existingCode.customerCode;
            String shCode = existingCode.shopCode;
            String convCode = '';
            if(!String.isBlank(existingCode.conventionCode)){
                convCode = existingCode.conventionCode;
            }
            

            queryString = 'SELECT Id, OB_CTICode__c FROM ExternalSourceMapping__c WHERE OB_Source__c =: GT';
            queryString += ' AND OB_Service_Point_ID__c =: servicePointId';
            queryString += ' AND OB_Merchant_ID__c =: merchantId';
            queryString += ' AND OB_CustomerCodeClientCode__c =: custCod';
            queryString += ' AND OB_ServicePointCodeShopCode__c =: shCode';
            if(!String.isBlank(convCode)){
                queryString = ' AND OB_Conventioncode__c =: convCode';
            }
            exSourceMapList = Database.query(queryString);

            if(!exSourceMapList.isEmpty()){
                existingCode.CTI = exSourceMapList[0].OB_CTICode__c;
            }
            System.debug('servicePointId: ' + servicePointId);
            System.debug('merchantId: ' + merchantId);
            System.debug('custCod: ' + custCod);
            System.debug('shCode: ' + shCode);
            System.debug('convCode: ' + convCode);
            System.debug('existingCode: ' + existingCode);
            System.debug('@@@@ ExternalSourceMapping: ' + JSON.serialize(exSourceMapList));
            // DG - 21/03/2019 - CONS-157 - END


            isFisico = !(isMoto || isEcomm);
            
            /**EP 18/03 BACO Payment Method INIZIO **/
            Boolean isPaymentEmpty = String.isBlank(configItemList[0].NE__OrderId__r.OB_SettlementType__c) || String.isBlank(configItemList[0].NE__OrderId__r.OB_PBSettlementMethod__c)|| String.isBlank(configItemList[0].NE__OrderId__r.OB_InternationalSettlementMethod__c);
            if(isPaymentEmpty && !isMaintenance){
                String ST = [SELECT OB_SettlementType__c FROM OB_Bank_Profile__c WHERE OB_Bank__c =:  configItemList[0].NE__OrderId__r.NE__Order_Header__r.OB_ProposerABI__c LIMIT 1].OB_SettlementType__c;
                if(ST == OB_UtilityConstants.PREPAGATO){
                   NE__Order__c Ord = new NE__Order__c( Id = orderId, 
                                                        OB_SettlementType__c= OB_UtilityConstants.PREPAGATO,
                                                        OB_PBSettlementMethod__c = Label.OB_PostpaidSettlmentMethodGrossValue,
                                                        OB_InternationalSettlementMethod__c = Label.OB_PostpaidSettlmentMethodGrossValue
                                                        );
                system.debug('@@Ord ' + Ord);
                   update Ord;
                }
            }

            /**EP 18/03 BACO Payment Method FINE **/

        }

        public Boolean getPEP(Id merchant, Id proposerABI){
            List<Contact> tmpContact = [select Id from Contact where OB_PEP__c =true and AccountId =: merchant and OB_Bank__c=: proposerABI];
            return (tmpContact.size()>0);
        }
    }

}