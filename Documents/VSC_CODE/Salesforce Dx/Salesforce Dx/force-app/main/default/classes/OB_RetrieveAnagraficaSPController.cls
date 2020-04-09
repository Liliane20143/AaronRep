public without sharing class OB_RetrieveAnagraficaSPController {
    
    @AuraEnabled
    public static NE__Service_Point__c getServicePoint(String idServicePoint)
    {  
        return  [SELECT Name,
                        OB_Service_Point_City__c,
                        OB_MCC__c,
                        NE__Street__c, 
                        OB_Street_Number__c,
                        OB_Address_Detail__c,
                        NE__Zip_Code__c,
                        NE__City__c,
                        NE__Province__c,
                        NE__Country__c,
                        OB_MCC_Description__c,  
                        NE__Account__r.NE__Fiscal_code__c, 
                        NE__Account__r.NE__VAT__c,
                        OB_Service_Point_Name__c,
                        NE__Account__r.Id
                    FROM NE__Service_Point__c
                    WHERE Id = :idServicePoint
                    LIMIT 1]; 
    }
   
    @AuraEnabled
    public static NE__Service_Point__c updateServicePoint (String idServicePoint, String spService)
    {
    	final List<String> ABI_NOT_BANK = new list<String>{'00000', '01030', '03104'};
        final List<String> BUSINESS_MODEL_VALUES = new list<String>{'Bancario',	'Diretto', 'Referral', 'Associate'};

        
        NE__Service_Point__c spLocal = OB_RetrieveAnagraficaSPController.getServicePoint(idServicePoint);

        System.debug('spService: ' + spService);

    	if (spService == null || spService == '[]' || spService =='{}')
            return spLocal;
        
        OB_ServicePointFromJSON spFromService = OB_ServicePointFromJSON.parse(spService);

        System.debug('spFromService: ' + spFromService);

        spLocal.Name = String.isBlank(spFromService.shopname) ? spLocal.name : spFromService.shopname;
        spLocal.OB_Service_Point_Name__c = String.isBlank(spFromService.receiptHeader) ? spLocal.OB_Service_Point_Name__c : spFromService.receiptHeader;
        spLocal.OB_Service_Point_City__c = String.isBlank(spFromService.receiptLocation) ? spLocal.OB_Service_Point_City__c : spFromService.receiptLocation;
        spLocal.OB_MCC__c = String.isBlank(spFromService.merchantCategoryCode) ? spLocal.OB_MCC__c : spFromService.merchantCategoryCode;
        spLocal.NE__Street__c = String.isBlank(spFromService.address.street) ? spLocal.NE__Street__c : spFromService.address.street;
        spLocal.OB_Street_Number__c = String.isBlank(spFromService.address.civicNumber) ? spLocal.OB_Street_Number__c : spFromService.address.civicNumber;
        spLocal.OB_Address_Detail__c = String.isBlank(spFromService.address.careOf) ? spLocal.OB_Address_Detail__c : spFromService.address.careOf;
        spLocal.NE__Zip_Code__c = String.isBlank(spFromService.address.postalCode) ? spLocal.NE__Zip_Code__c : spFromService.address.postalCode;
        spLocal.NE__City__c = String.isBlank(spFromService.address.city) ? spLocal.NE__City__c : spFromService.address.city;
        spLocal.NE__Province__c = String.isBlank(spFromService.address.province) ? spLocal.NE__Province__c : spFromService.address.province;
        spLocal.NE__Country__c = String.isBlank(spFromService.address.country) ? spLocal.NE__Country__c : spFromService.address.country;
    
        List<ExternalSourceMapping__c> listAcquiringDetails = new List<ExternalSourceMapping__c>();
        set<string> sourceSet = new set<string>();
        set<string> customerCodeClientCodeSet = new set<string>();
        set<String> servicePointIdSet = new set<string>();

        for (OB_ServicePointFromJSON.cls_acquiringDetails currentAcquiring : spFromService.AcquiringDetails) { 
                         
            ExternalSourceMapping__c spFormAcquiringDetailWithAcquiringCode = new ExternalSourceMapping__c(   
                                                                                        //  micol.ferrari DELETED FIELD
                                                                                        //OB_SourceSystem__c = currentAcquiring.acquiringCode, 
                                                                                        OB_ServicePointCodeShopCode__c = currentAcquiring.acquiringCode,
                                                                                        OB_CustomerCodeClientCode__c = currentAcquiring.companyCode,
                                                                                        OB_Source__c = currentAcquiring.processor, 
                                                                                        OB_Start_Date__c =  Date.valueOf(currentAcquiring.activityStartDate), 
                                                                                        OB_Pricing__c = currentAcquiring.pricingType, 
                                                                                        OB_EcommerceType__c = currentAcquiring.eCommerceType,
                                                                                        OB_Service_Point_ID__c  = idServicePoint, 
                                                                                        OB_isMoTo__c = currentAcquiring.moto,
                                                                                        OB_Service_Point_Type__c = OB_RetrieveAnagraficaSPController.getServicePointType(spFromService.type),
                                                                                        OB_isCarRentalisHotel__c = (currentAcquiring.distinctiveServices.isCarRental || currentAcquiring.distinctiveServices.isHotel) ? true : false
                                                                                        );

            
            if (currentAcquiring.abiCondi[0] != ABI_NOT_BANK[0] || currentAcquiring.abiCondi[0] != ABI_NOT_BANK[1] || currentAcquiring.abiCondi[0] != ABI_NOT_BANK[2])
                spFormAcquiringDetailWithAcquiringCode.OB_Business_Model__c = BUSINESS_MODEL_VALUES[0];
            else {
                return spLocal;
            }

            sourceSet.add(spFormAcquiringDetailWithAcquiringCode.OB_Source__c);
            customerCodeClientCodeSet.add(spFormAcquiringDetailWithAcquiringCode.OB_CustomerCodeClientCode__c);
            servicePointIdSet.add(spFormAcquiringDetailWithAcquiringCode.OB_Service_Point_ID__c);

            listAcquiringDetails.add(spFormAcquiringDetailWithAcquiringCode);
            /*
            ExternalSourceMapping__c spFormAcquiringDetailWithCompanyCode = spFormAcquiringDetailWithAcquiringCode.Clone(true, true, false, false);
            //  micol.ferrari DELETED FIELD
            //spFormAcquiringDetailWithCompanyCode.OB_SourceSystem__c = currentAcquiring.companyCode;
            spFormAcquiringDetailWithCompanyCode.OB_CustomerCodeClientCode__c = currentAcquiring.companyCode;
            spFormAcquiringDetailWithCompanyCode.OB_Service_Point_ID__c = null; 
            spFormAcquiringDetailWithCompanyCode.OB_Merchant_ID__C = spLocal.NE__Account__r.Id;
            listAcquiringDetails.add(spFormAcquiringDetailWithCompanyCode);
            sourceSet.add(spFormAcquiringDetailWithCompanyCode.OB_Source__c);
            customerCodeClientCodeSet.add(spFormAcquiringDetailWithCompanyCode.OB_CustomerCodeClientCode__c);
            servicePointIdSet.add(spFormAcquiringDetailWithCompanyCode.OB_Service_Point_ID__c);
            */
        }

        List<ExternalSourceMapping__c> listPOSDetails = new List<ExternalSourceMapping__c>();
        
        for (OB_ServicePointFromJSON.cls_posDetails currentPOS : spFromService.posDetails) {
            ExternalSourceMapping__c spFormAcquiringDetailWithGtCompanyCode = new ExternalSourceMapping__c(  
                                                                                        //  micol.ferrari DELETED FIELD 
                                                                                        //OB_SourceSystem__c = currentPOS.gtCompanyCode, 
                                                                                        OB_CustomerCodeClientCode__c = currentPOS.gtCompanyCode,
                                                                                        OB_Source__c = currentPOS.gtCode=='NEXI' ? 'Monetica' : currentPOS.gtCode,
                                                                                        OB_Service_Point_Type__c = OB_RetrieveAnagraficaSPController.getServicePointType(spFromService.type),
                                                                                        OB_Merchant_ID__C = spLocal.NE__Account__r.Id);
            listPOSDetails.add(spFormAcquiringDetailWithGtCompanyCode);
             
            ExternalSourceMapping__c spFormAcquiringDetailWithSalePointCode = spFormAcquiringDetailWithGtCompanyCode.Clone(true, true, false, false);
            //  micol.ferrari DELETED FIELD
            //spFormAcquiringDetailWithSalePointCode.OB_SourceSystem__c = currentPOS.gtSalePointCode;
            spFormAcquiringDetailWithSalePointCode.OB_CustomerCodeClientCode__c = currentPOS.gtSalePointCode;
            spFormAcquiringDetailWithSalePointCode.OB_Source__c = currentPOS.agreementCodes[0].processor;
            spFormAcquiringDetailWithSalePointCode.OB_Conventioncode__c = currentPOS.agreementCodes[0].code;
            spFormAcquiringDetailWithSalePointCode.OB_Merchant_ID__C = null; 
            spFormAcquiringDetailWithSalePointCode.OB_Service_Point_ID__c = idServicePoint;
            listAcquiringDetails.add(spFormAcquiringDetailWithSalePointCode); 
            sourceSet.add(spFormAcquiringDetailWithGtCompanyCode.OB_Source__c);
            customerCodeClientCodeSet.add(spFormAcquiringDetailWithGtCompanyCode.OB_CustomerCodeClientCode__c);
            servicePointIdSet.add(spFormAcquiringDetailWithGtCompanyCode.OB_Service_Point_ID__c);
        }



        List<ExternalSourceMapping__c> listExistingExternalSource = [   select Id, 
                                                                        OB_Source__c, 
                                                                        OB_CustomerCodeClientCode__c, 
                                                                        OB_Start_Date__c,
                                                                        OB_Pricing__c,
                                                                        OB_EcommerceType__c,
                                                                        OB_Service_Point_ID__c,
                                                                        OB_isMoTo__c,
                                                                        OB_Service_Point_Type__c,
                                                                        OB_isCarRentalisHotel__c,
                                                                        OB_Merchant_ID__C 
                                                                        from ExternalSourceMapping__c where OB_Service_Point_ID__c!='' AND OB_CustomerCodeClientCode__c in: customerCodeClientCodeSet AND OB_Source__c in: sourceSet ];
        List<ExternalSourceMapping__c> listNotExistingExternalSource = new List<ExternalSourceMapping__c>();
        List<ExternalSourceMapping__c> listNewExternalSource = new List<ExternalSourceMapping__c>();
        listNewExternalSource.addAll(listAcquiringDetails);
        listNewExternalSource.addAll(listPOSDetails);

        System.debug('List New External Source'+listNewExternalSource);
        System.debug('List Existing External Source'+listExistingExternalSource);

        for(ExternalSourceMapping__c currExternalSource: listNewExternalSource ){
            Boolean exist = false;
            ExternalSourceMapping__c tempSource = new ExternalSourceMapping__c();
            for(ExternalSourceMapping__c existExternalSource: listExistingExternalSource ){
                tempSource = existExternalSource;
                if((currExternalSource.OB_CustomerCodeClientCode__c == existExternalSource.OB_CustomerCodeClientCode__c && currExternalSource.OB_Source__c == existExternalSource.OB_Source__c && currExternalSource.OB_Service_Point_ID__c == existExternalSource.OB_Service_Point_ID__c )){
                    exist = true;
                    break;
                }
            }
            if(exist == false){
                tempSource.OB_CustomerCodeClientCode__c = currExternalSource.OB_CustomerCodeClientCode__c;
                tempSource.OB_Source__c = currExternalSource.OB_Source__c;
                tempSource.OB_Start_Date__c = currExternalSource.OB_Start_Date__c;
                tempSource.OB_Pricing__c = currExternalSource.OB_Pricing__c;
                tempSource.OB_ReportType__c = currExternalSource.OB_ReportType__c;
                listNotExistingExternalSource.add(tempSource);
            }
        }

        System.debug('List External : '+listNewExternalSource);
        System.debug('List Existing : '+listExistingExternalSource);
        System.debug('List Not Existing : '+listNotExistingExternalSource);

        try{
            //  micol.ferrari DELETED FIELD
            //database.upsert(listAcquiringDetails, ExternalSourceMapping__c.OB_SourceSystem__c);
            //database.upsert(listPOSDetails, ExternalSourceMapping__c.OB_SourceSystem__c);
            update(listExistingExternalSource);
            insert(listNotExistingExternalSource);
            update(splocal);
            return spLocal;
        }catch(Exception e){
            System.debug('The following exception has occurred: ' + e.getMessage());
            return null;
        }
    }

        private static String getServicePointType(String strReport){
        String[] values = OB_RetrieveAnagraficaSPController.picklist_values('ExternalSourceMapping__c', 'OB_Service_Point_Type__c');
        System.debug('Values List Picklist: '+values);
        if(strReport=='FISICO'){
            return values[0];
        }
        else if(strReport=='VIRTUALE')
            return values[1];
        else
            return '';     
    }
    
    private static String[] picklist_values(String object_name, String field_name) {
        String[] values = new String[]{};
        String[] types = new String[]{object_name};
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        for(Schema.DescribeSobjectResult res : results) {
            for (Schema.PicklistEntry entry : res.fields.getMap().get(field_name).getDescribe().getPicklistValues()) {
            if (entry.isActive()) {values.add(entry.getValue());}
            }
        }
        return values;
   }


   /********************************** START Antonio Vatrano  17-12-18 **********************/
    @AuraEnabled
    public static Object getretrieveMerchant(String fiscalCode, String vatCode)
    {
        Object res;
        try
        {
            res = OB_RetrieveAnagraficaMerchantController.retrieveMerchantNew(fiscalCode, vatCode);
        }
        catch(Exception ecc){
            System.debug('Generic Error: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
        }
        System.debug('*****RES: '+res);
        return res;
    }

/********************************** END Antonio Vatrano  17-12-18 **********************/



}