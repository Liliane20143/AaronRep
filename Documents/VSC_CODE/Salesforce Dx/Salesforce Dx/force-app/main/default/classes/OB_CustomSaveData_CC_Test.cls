@isTest
public class OB_CustomSaveData_CC_Test {
    
    @isTest
    private static Map<String ,  Object> setupData(){ 
        Id esecutoreRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Esecutore').getRecordTypeId(); 
        return (Map<String, Object>)JSON.deserializeUntyped('{ "Object": { "pv": { "NE__Street__c": "VIA CASALE", "OB_AlternativeAddress__c": "", "OB_Opening_Monday_Afternoon__c": "true", "OB_Fax_Number__c": "", "OB_PEC__c": "", "OB_Start_Seasonal__c": "", "OB_Opening_Tuesday_Morning__c": "true", "OB_Opening_Thursday_Afternoon__c": "true", "Name": "test88888", "OB_Opening_Wednesday_Morning__c": "true", "OB_Opening_Wednesday_Afternoon__c": "true", "OB_Opening_Thursday_Morning__c": "true", "OB_Opening_Friday_Afternoon__c": "true", "OB_Email__c": "", "OB_Workshift__c": "false", "OB_Address_Hamlet__c": "", "NE__City__c": "SALERNO", "OB_Opening_Monday_Morning__c": "true", "OB_Opening_Saturday_Morning__c": "true", "OB_Phone_Number__c": "", "OB_Opening_Tuesday_Afternoon__c": "true", "OB_Privacy_C4__c": "false", "OB_Privacy_C3__c": "false", "OB_BypassValidation__c": "false", "OB_Street_Number__c": "3", "OB_Opening_Friday_Morning__c": "true", "OB_Service_Point_City__c": "", "OB_End_Seasonal__c": "", "OB_Mobile_Phone_Number__c": "", "OB_Opening_Saturday_Afternoon__c": "true", "NE__Province__c": "SALERNO", "OB_MCC_Description__c": "ALL", "NE__Postal_Code__c": "", "OB_MCC__c": "0000", "OB_Typology__c": "Fisico", "OB_Opening_Sunday_Afternoon__c": "true", "OB_Service_Point_Name__c": "", "OB_Privacy_C5__c": "false", "OB_Opening_Sunday_Morning__c": "true", "OB_Ecommerce__c": false, "NE__Country__c": "ITALIA", "sobjectType": "ne__service_point__c", "NE__Zip_Code__c": "84133", "NE__Country_Code__c": "ITA" }, "legale_rappresentante": { "OB_Country_Birth__c": "", "OB_Document_Release_Country__c": "", "OB_Company_Link_Type__c": "", "OB_Document_Release_City__c": "", "OB_Birth_City__c": "Milano", "OB_Document_Release_State__c": "", "Fax": "", "OB_Document_Expiration_Date__c": "2011-01-20", "OB_Citizenship__c": "", "OB_PEP__c": "false", "Id": "", "OB_Document_Release_Authority__c": "Comune", "OB_Document_Release_Date__c": "2001-01-21", "OB_Document_Number__c": "012345678", "OB_Document_Type__c": "Carta di Identità", "OB_Birth_State__c": "", "OB_Birth_Date__c": "1986-06-06", "Role__c": "", "OB_Sex__c": "", "OB_Fiscal_Code__c": "RSSMRA86H06F205I", "LastName": "Rossi", "FirstName": "Mario", "RecordTypeId": "'+esecutoreRecordTypeId+'", "sobjectType": "contact" }, "isLegalEqualAdm": false, "JumpToStep": 4, "messageNext": { "severity": "SUCCESS", "message": "" }, "checkMapValuesAnnRevNeg": {}, "isMCCL2Blank": false, "isShopSignBlank": false, "Configuration_temp": { "sobjectType": "ne__order__c", "RecordTypeId": "", "NE__Parameters__c": "", "OB_ReceiptCity__c": "", "OB_ReceiptHeader__c": "" }, "OrderHeader_temp": { "sobjectType": "ne__order_header__c", "RecordTypeId": "", "OB_Report_Type__c": "", "OB_OrderDate__c": "2018-11-22" }, "disabledABI": true, "correctABI": true, "disabledCAB": true, "correctCAB": true, "lookupLov": "", "hideFieldTypology": true, "disabledInput_sp": true, "isOldMerchantOldSp": true, "isOldMerchantNewSp": false, "disableButtonMcc": true, "ShopSign": "chiesa bella2", "shopSign": "chiesa bella2", "disabledVat": true, "hideFiscalCode": true, "showButtons": true, "disableDescriptionVat": true, "showModal": true, "showMerchantData": true, "hideVat": true, "disableName": true, "pvAlreadyExist": false, "setRedBorderBackup": false, "setRedBorder": false, "isNewMerchant": false, "GT": "Nexi;TRV;Other", "actualBank": "", "bankOwner": "", "isCommunityUser": true, "searchMerchantButton": true, "isL3Required": false, "OrderHeader": { "sobjectType": "ne__order_header__c", "RecordTypeId": "", "Id": "", "OB_Report_Type__c": "", "OB_OrderDate__c": "2018-11-22" }, "Configuration": { "OB_GT__c": "Nexi", "OB_ReceiptHeader__c": "chiesa bella2", "OB_ReceiptCity__c": "SALERNO", "Id": "", "RecordTypeId": "", "sobjectType": "ne__order__c" }, "merchant": { "Id": "", "Name": "test", "OB_FATECO__c": "S", "OB_VAT_Not_Present__c": true, "OB_Annual_Negotiated__c": 0, "OB_Annual_Revenue__c": 123456789, "NE__Fiscal_code__c": "MRTMTT25D09F205Z", "OB_Employees_Number__c": "Minore di 10", "OB_DescriptionVATNotPresent__c": "ENTE ECCLESIASTICO", "Phone": "12345678", "Type": "Account", "OB_Beneficial_Owner_Existence__c": true, "OB_Year_constitution_company__c": 2018, "NE__E_mail__c": "test@test.as", "OB_Legal_Address_Country__c": "ITALIA", "NE__Status__c": "Prospect", "attributes": { "url": "", "type": "Account" } } } }  ');
    }
        
    @isTest 
    static void initTest(){
        Map<String, Object> data = OB_CustomSaveData_CC_Test.setupData();
        OB_CustomSaveData_CC csd = new OB_CustomSaveData_CC();
        csd.init('', data, null, null);
        
    }
    
    @isTest
    static void validateTest(){
        Map<String, Object> data = OB_CustomSaveData_CC_Test.setupData();
        OB_CustomSaveData_CC csd = new OB_CustomSaveData_CC();
        csd.validate('', data, null, null);  
        
    }
    
    @isTest
    static void executeMethodTest(){
        
        /*
Id merchantRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Merchant').getRecordTypeId();

Account merchant = new Account(	OB_Annual_Negotiated__c = 0, 
OB_Annual_Revenue__c = 123456789, 
NE__Fiscal_code__c = 'MRTMTT25D09F205Z',
OB_Employees_Number__c = 'Minore di 10',
RecordTypeId = merchantRecordTypeId, 
OB_DescriptionVATNotPresent__c = 'ENTE ECCLESIASTICO',
Phone = '12345678',  
OB_VAT_Not_Present__c = true,
OB_FATECO__c = '',
Type = 'Account',
OB_Beneficial_Owner_Existence__c = true,
Name = 'test',
OB_Year_constitution_company__c = 2018,
NE__E_mail__c = 'test@test.as',
OB_Legal_Address_Country__c = 'ITALIA',
NE__Status__c = 'Prospect'
);
insert merchant; 
*/ 
        
        Map<String, Object> data = OB_CustomSaveData_CC_Test.setupData();
        OB_CustomSaveData_CC csd = new OB_CustomSaveData_CC();
        
        //Test Create Configuration without Account and SP
        
        csd.executeMethod('', data, '', 'createConfiguration', null, null);
        
        //Test Create Configuration with Account and no SP
        
        Id merchantId = [SELECT Id FROM Account WHERE Name='test'].Id;
        
        Object dataComplex = data.get('Object'); 
        Map<String,Object> mapFromObj = (Map<String,Object>)JSON.deserializeUntyped(JSON.serialize(dataComplex));
        bit2flow.B2FUtils.setJSONValue(mapFromObj, 'merchant', 'Id', merchantId);
        //String stringWithAccObj = JSON.serialize(mapFromObj);
        //MapFromObjWithAcc =(Map<String, Object>)JSON.deserializeUntyped(stringWithAccObj);
        Map<String, Object> dataWithAcc = new Map<String, Object>();
        dataWithAcc.put('Object', mapFromObj);
        
        csd.executeMethod('', dataWithAcc, '', 'createConfiguration', null, null);
        
        //Test Create Configuration with SP and NO Account
        
        Id spId = [SELECT Id FROM NE__Service_Point__c WHERE Name='test88888' LIMIt 1].Id; 
        Id merchantRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Merchant').getRecordTypeId();  
        Id esecutoreRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Esecutore').getRecordTypeId(); 
        Map<String, Object> dataWithSPNOAcc = (Map<String, Object>)JSON.deserializeUntyped('{"Object":{"pv":{"Id":"'+spId+'","NE__Street__c":"VIA CASALE","OB_AlternativeAddress__c":"","OB_Opening_Monday_Afternoon__c":"true","OB_Fax_Number__c":"","OB_PEC__c":"","OB_Start_Seasonal__c":"","OB_Opening_Tuesday_Morning__c":"true","OB_Opening_Thursday_Afternoon__c":"true","Name":"test88888","OB_Opening_Wednesday_Morning__c":"true","OB_Opening_Wednesday_Afternoon__c":"true","OB_Opening_Thursday_Morning__c":"true","OB_Opening_Friday_Afternoon__c":"true","OB_Email__c":"","OB_Workshift__c":"false","OB_Address_Hamlet__c":"","NE__City__c":"SALERNO","OB_Opening_Monday_Morning__c":"true","OB_Opening_Saturday_Morning__c":"true","OB_Phone_Number__c":"","OB_Opening_Tuesday_Afternoon__c":"true","OB_Privacy_C4__c":"false","OB_Privacy_C3__c":"false","OB_BypassValidation__c":"false","OB_Street_Number__c":"3","OB_Opening_Friday_Morning__c":"true","OB_Service_Point_City__c":"","OB_End_Seasonal__c":"","OB_Mobile_Phone_Number__c":"","OB_Opening_Saturday_Afternoon__c":"true","NE__Province__c":"SALERNO","OB_MCC_Description__c":"ALL","NE__Postal_Code__c":"","NE__Account__c":"","OB_MCC__c":"0000","OB_Typology__c":"Fisico","OB_Opening_Sunday_Afternoon__c":"true","OB_Service_Point_Name__c":"","OB_Privacy_C5__c":"false","OB_Opening_Sunday_Morning__c":"true","OB_Ecommerce__c":false,"NE__Country__c":"ITALIA","sobjectType":"ne__service_point__c","NE__Zip_Code__c":"84133","NE__Country_Code__c":"ITA"},"legale_rappresentante":{"OB_Country_Birth__c":"","OB_Document_Release_Country__c":"","OB_Company_Link_Type__c":"","OB_Document_Release_City__c":"","OB_Birth_City__c":"","OB_Document_Release_State__c":"","Fax":"","OB_Document_Expiration_Date__c":"","OB_Citizenship__c":"","OB_PEP__c":"false","Id":"","OB_Document_Release_Authority__c":"","OB_Document_Release_Date__c":"","OB_Document_Number__c":"","OB_Document_Type__c":"","OB_Birth_State__c":"","OB_Birth_Date__c":"","Role__c":"","OB_Sex__c":"","OB_Fiscal_Code__c":"","LastName":"","FirstName":"","RecordTypeId":"'+esecutoreRecordTypeId+'","sobjectType":"contact"},"isLegalEqualAdm":false,"JumpToStep":4,"messageNext":{"severity":"SUCCESS","message":""},"checkMapValuesAnnRevNeg":{},"isMCCL2Blank":false,"isShopSignBlank":false,"Configuration_temp":{"sobjectType":"ne__order__c","RecordTypeId":"","NE__Parameters__c":"","OB_ReceiptCity__c":"","OB_ReceiptHeader__c":""},"OrderHeader_temp":{"sobjectType":"ne__order_header__c","RecordTypeId":"","OB_Report_Type__c":"","OB_OrderDate__c":"2018-11-22"},"pv_temp":{"NE__Country_Code__c":"ITA","OB_MCC__c":"0000","NE__Country__c":"ITALIA","NE__Account__c":"","OB_Ecommerce__c":false,"OB_BypassValidation__c":"false","NE__Zip_Code__c":"84133","OB_Typology__c":"Fisico","OB_AlternativeAddress__c":"","OB_Privacy_C5__c":"false","OB_Privacy_C4__c":"false","OB_Privacy_C3__c":"false","OB_Fax_Number__c":"","OB_Mobile_Phone_Number__c":"","OB_Phone_Number__c":"","OB_End_Seasonal__c":"","OB_Start_Seasonal__c":"","OB_Workshift__c":"false","OB_Service_Point_City__c":"","OB_Service_Point_Name__c":"","OB_PEC__c":"","OB_Email__c":"","OB_Address_Hamlet__c":"","OB_Street_Number__c":"3","OB_MCC_Description__c":"ALL","OB_Opening_Sunday_Afternoon__c":"true","OB_Opening_Sunday_Morning__c":"true","OB_Opening_Saturday_Afternoon__c":"true","OB_Opening_Saturday_Morning__c":"true","OB_Opening_Friday_Afternoon__c":"true","OB_Opening_Friday_Morning__c":"true","OB_Opening_Thursday_Afternoon__c":"true","OB_Opening_Thursday_Morning__c":"true","OB_Opening_Wednesday_Afternoon__c":"true","OB_Opening_Wednesday_Morning__c":"true","OB_Opening_Tuesday_Afternoon__c":"true","OB_Opening_Tuesday_Morning__c":"true","OB_Opening_Monday_Afternoon__c":"true","OB_Opening_Monday_Morning__c":"true","NE__Postal_Code__c":"","NE__Province__c":"SALERNO","NE__Street__c":"VIA CASALE","NE__City__c":"SALERNO","Id":"","Name":"test88888","RecordTypeId":"","sobjectType":"ne__service_point__c"},"disabledABI":true,"correctABI":true,"disabledCAB":true,"correctCAB":true,"lookupLov":"","hideFieldTypology":true,"disabledInput_sp":true,"isOldMerchantOldSp":true,"isOldMerchantNewSp":false,"disableButtonMcc":true,"ShopSign":"chiesa bella2","shopSign":"chiesa bella2","disabledVat":true,"hideFiscalCode":true,"showButtons":true,"disableDescriptionVat":true,"showModal":true,"showMerchantData":true,"hideVat":true,"disableName":true,"pvAlreadyExist":false,"setRedBorderBackup":false,"setRedBorder":false,"isNewMerchant":false,"GT":"Nexi;TRV;Other","actualBank":"","bankOwner":"","isCommunityUser":true,"searchMerchantButton":true,"isL3Required":false,"OrderHeader":{"sobjectType":"ne__order_header__c","RecordTypeId":"","Id":"","OB_Report_Type__c":"","OB_OrderDate__c":"2018-11-22"},"Configuration":{"OB_GT__c":"Nexi","OB_ReceiptHeader__c":"chiesa bella2","OB_ReceiptCity__c":"SALERNO","NE__Parameters__c":"","Id":"","RecordTypeId":"","sobjectType":"ne__order__c"},"merchant":{"Id":"","Name":"test","RecordTypeId":"'+merchantRecordTypeId+'","OB_FATECO__c":"S","OB_VAT_Not_Present__c":true,"OB_Annual_Negotiated__c":0,"OB_Annual_Revenue__c":123456789,"NE__Fiscal_code__c":"MRTMTT25D09F205Z","OB_Employees_Number__c":"Minore di 10","OB_DescriptionVATNotPresent__c":"ENTE ECCLESIASTICO","Phone":"12345678","Type":"Account","OB_Bank_owner__c":"","OB_Beneficial_Owner_Existence__c":true,"OB_Year_constitution_company__c":2018,"NE__E_mail__c":"test@test.as","OB_Legal_Address_Country__c":"ITALIA","NE__Status__c":"Prospect","attributes":{"url":"","type":"Account"}}}}');
        
        csd.executeMethod('', dataWithSPNOAcc, '', 'createConfiguration', null, null);
        
        //Test Create Configuration with SP and Account
        
        Map<String, Object> dataWithAccSP = (Map<String, Object>)JSON.deserializeUntyped('{"Object":{"pv":{"Id":"'+spId+'","NE__Street__c":"VIA CASALE","OB_AlternativeAddress__c":"","OB_Opening_Monday_Afternoon__c":"true","OB_Fax_Number__c":"","OB_PEC__c":"","OB_Start_Seasonal__c":"","OB_Opening_Tuesday_Morning__c":"true","OB_Opening_Thursday_Afternoon__c":"true","Name":"test88888","OB_Opening_Wednesday_Morning__c":"true","OB_Opening_Wednesday_Afternoon__c":"true","OB_Opening_Thursday_Morning__c":"true","OB_Opening_Friday_Afternoon__c":"true","OB_Email__c":"","OB_Workshift__c":"false","OB_Address_Hamlet__c":"","NE__City__c":"SALERNO","OB_Opening_Monday_Morning__c":"true","OB_Opening_Saturday_Morning__c":"true","OB_Phone_Number__c":"","OB_Opening_Tuesday_Afternoon__c":"true","OB_Privacy_C4__c":"false","OB_Privacy_C3__c":"false","OB_BypassValidation__c":"false","OB_Street_Number__c":"3","OB_Opening_Friday_Morning__c":"true","OB_Service_Point_City__c":"","OB_End_Seasonal__c":"","OB_Mobile_Phone_Number__c":"","OB_Opening_Saturday_Afternoon__c":"true","NE__Province__c":"SALERNO","OB_MCC_Description__c":"ALL","NE__Postal_Code__c":"","NE__Account__c":"","OB_MCC__c":"0000","OB_Typology__c":"Fisico","OB_Opening_Sunday_Afternoon__c":"true","OB_Service_Point_Name__c":"","OB_Privacy_C5__c":"false","OB_Opening_Sunday_Morning__c":"true","OB_Ecommerce__c":false,"NE__Country__c":"ITALIA","sobjectType":"ne__service_point__c","NE__Zip_Code__c":"84133","NE__Country_Code__c":"ITA"},"legale_rappresentante":{"OB_Country_Birth__c":"","OB_Document_Release_Country__c":"","OB_Company_Link_Type__c":"","OB_Document_Release_City__c":"","OB_Birth_City__c":"","OB_Document_Release_State__c":"","Fax":"","OB_Document_Expiration_Date__c":"2029-05-08","OB_Citizenship__c":"","OB_PEP__c":"false","Id":"","OB_Document_Release_Authority__c":"Comune","OB_Document_Release_Date__c":"2018-10-01","OB_Document_Number__c":"ar1234567","OB_Document_Type__c":"Carta di Identità","OB_Birth_State__c":"","OB_Birth_Date__c":"1994-05-08","Role__c":"","OB_Sex__c":"","OB_Fiscal_Code__c":"VRDFNC90P01D969G","LastName":"Test Lastname","FirstName":"Test Name","RecordTypeId":"'+esecutoreRecordTypeId+'","sobjectType":"contact"},"isLegalEqualAdm":false,"JumpToStep":4,"messageNext":{"severity":"SUCCESS","message":""},"checkMapValuesAnnRevNeg":{},"isMCCL2Blank":false,"isShopSignBlank":false,"Configuration_temp":{"sobjectType":"ne__order__c","RecordTypeId":"","NE__Parameters__c":"","OB_ReceiptCity__c":"","OB_ReceiptHeader__c":""},"OrderHeader_temp":{"sobjectType":"ne__order_header__c","RecordTypeId":"","OB_Report_Type__c":"","OB_OrderDate__c":"2018-11-22"},"pv_temp":{"NE__Country_Code__c":"ITA","OB_MCC__c":"0000","NE__Country__c":"ITALIA","NE__Account__c":"","OB_Ecommerce__c":false,"OB_BypassValidation__c":"false","NE__Zip_Code__c":"84133","OB_Typology__c":"Fisico","OB_AlternativeAddress__c":"","OB_Privacy_C5__c":"false","OB_Privacy_C4__c":"false","OB_Privacy_C3__c":"false","OB_Fax_Number__c":"","OB_Mobile_Phone_Number__c":"","OB_Phone_Number__c":"","OB_End_Seasonal__c":"","OB_Start_Seasonal__c":"","OB_Workshift__c":"false","OB_Service_Point_City__c":"","OB_Service_Point_Name__c":"","OB_PEC__c":"","OB_Email__c":"","OB_Address_Hamlet__c":"","OB_Street_Number__c":"3","OB_MCC_Description__c":"ALL","OB_Opening_Sunday_Afternoon__c":"true","OB_Opening_Sunday_Morning__c":"true","OB_Opening_Saturday_Afternoon__c":"true","OB_Opening_Saturday_Morning__c":"true","OB_Opening_Friday_Afternoon__c":"true","OB_Opening_Friday_Morning__c":"true","OB_Opening_Thursday_Afternoon__c":"true","OB_Opening_Thursday_Morning__c":"true","OB_Opening_Wednesday_Afternoon__c":"true","OB_Opening_Wednesday_Morning__c":"true","OB_Opening_Tuesday_Afternoon__c":"true","OB_Opening_Tuesday_Morning__c":"true","OB_Opening_Monday_Afternoon__c":"true","OB_Opening_Monday_Morning__c":"true","NE__Postal_Code__c":"","NE__Province__c":"SALERNO","NE__Street__c":"VIA CASALE","NE__City__c":"SALERNO","Id":"","Name":"test88888","RecordTypeId":"","sobjectType":"ne__service_point__c"},"disabledABI":true,"correctABI":true,"disabledCAB":true,"correctCAB":true,"lookupLov":"","hideFieldTypology":true,"disabledInput_sp":true,"isOldMerchantOldSp":true,"isOldMerchantNewSp":false,"disableButtonMcc":true,"ShopSign":"chiesa bella2","shopSign":"chiesa bella2","disabledVat":true,"hideFiscalCode":true,"showButtons":true,"disableDescriptionVat":true,"showModal":true,"showMerchantData":true,"hideVat":true,"disableName":true,"pvAlreadyExist":false,"setRedBorderBackup":false,"setRedBorder":false,"isNewMerchant":false,"GT":"Nexi;TRV;Other","actualBank":"","bankOwner":"","isCommunityUser":true,"searchMerchantButton":true,"isL3Required":false,"OrderHeader":{"sobjectType":"ne__order_header__c","RecordTypeId":"","Id":"","OB_Report_Type__c":"","OB_OrderDate__c":"2018-11-22"},"Configuration":{"OB_GT__c":"Nexi","OB_ReceiptHeader__c":"chiesa bella2","OB_ReceiptCity__c":"SALERNO","NE__Parameters__c":"","Id":"","RecordTypeId":"","sobjectType":"ne__order__c"},"merchant":{"Id":"'+merchantId+'","Name":"test","RecordTypeId":"'+merchantRecordTypeId+'","OB_FATECO__c":"S","OB_VAT_Not_Present__c":true,"OB_Annual_Negotiated__c":0,"OB_Annual_Revenue__c":123456789,"NE__Fiscal_code__c":"MRTMTT25D09F205Z","OB_Employees_Number__c":"Minore di 10","OB_DescriptionVATNotPresent__c":"ENTE ECCLESIASTICO","Phone":"12345678","Type":"Account","OB_Bank_owner__c":"","OB_Beneficial_Owner_Existence__c":true,"OB_Year_constitution_company__c":2018,"NE__E_mail__c":"test@test.as","OB_Legal_Address_Country__c":"ITALIA","NE__Status__c":"Prospect","attributes":{"url":"","type":"Account"}}}}');
        
        csd.executeMethod('', dataWithAccSP, '', 'createConfiguration', null, null);
    }
    
    @isTest
    static void createEsecutoreTest(){
        Map<String, Object> data = OB_CustomSaveData_CC_Test.setupData();
        OB_CustomSaveData_CC csd = new OB_CustomSaveData_CC(); 
        csd.executeMethod('', data, '', 'createEsecutore', null, null);
        


        Contact cont = new Contact();
        cont.FirstName = 'RIRI';
        cont.LastName = 'TOTI';
        cont.OB_Fiscal_Code__c = 'TTORRI00B01D150K';
        cont.OB_Document_Release_Authority__c = 'Comune' ;
        cont.OB_Document_Type__c = 'Carta di Identità';
        cont.OB_Sex__c = 'M';
        cont.OB_BypassValidation__c = false;
        cont.OB_Document_Number__c = '123erty644';
        insert cont;
        
        Id esecutoreId = cont.Id;
        
        Object dataComplex = data.get('Object'); 
        Map<String,Object> mapFromObj = (Map<String,Object>)JSON.deserializeUntyped(JSON.serialize(dataComplex));
        bit2flow.B2FUtils.setJSONValue(mapFromObj, 'legale_rappresentante', 'Id', esecutoreId);
        Map<String, Object> dataWithId = new Map<String, Object>();
        dataWithId.put('Object', mapFromObj);
        
        csd.executeMethod('', dataWithId, '', 'createEsecutore', null, null);
    }
    
    
    @isTest
    static void saveTest(){
        String step='';
        String targetObjectKey='';
        List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition = new List <bit2flow.DynamicWizardWrapper.StepDefinitions>();
       // insert stepsDefinition;
        bit2flow.DynamicWizardWrapper dynamicWizardWrapper = new bit2flow.DynamicWizardWrapper();
       // insert dynamicWizardWrapper;
        Id merchantRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Merchant').getRecordTypeId();

        Account merchant = new Account(	OB_Annual_Negotiated__c = 0, 
        OB_Annual_Revenue__c = 123456789, 
        NE__Fiscal_code__c = 'MRTMTT25D09F205Z',
        OB_Employees_Number__c = 'Minore di 10',
        RecordTypeId = merchantRecordTypeId, 
        OB_DescriptionVATNotPresent__c = 'ENTE ECCLESIASTICO',
        Phone = '12345678',  
        OB_VAT_Not_Present__c = true,
        OB_FATECO__c = '',
        Type = 'Account',
        OB_Beneficial_Owner_Existence__c = true,
        Name = 'test',
        OB_Year_constitution_company__c = 2018,
        NE__E_mail__c = 'test@test.as',
        OB_Legal_Address_Country__c = 'ITALIA',
        NE__Status__c = 'Prospect'
        );
        insert merchant; 



        // //List<Account> accList = new List<Account>();
        // //Id rtMerchant 			= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Merchant').getRecordTypeId(); 
        // //Account myMastMerchant 	= new Account(	Name='TEST',
        // //                                      RecordTypeId=rtMerchant,
        // //                                      OB_Employees_Number__c='Minore di 10',
        // //                                      OB_VAT_Not_Present__c=true, 
        // //                                      OB_DescriptionVATNotPresent__c='description', 
        // //                                      NE__Fiscal_code__c='RSSMRA80A01F205X',
        // //                                      OB_BypassValidation__c=true,
        // //                                      OB_Status__c='Active'); 
        
        // //Id accountBankRecordId 			= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bank').getRecordTypeId(); 
        // //Account bankAccount 	= new Account(	Name='TEST',
        // //                                      RecordTypeId=accountBankRecordId,
        // //                                      OB_Employees_Number__c='Minore di 10',
        // //                                      OB_VAT_Not_Present__c=true, 
        // //                                      OB_DescriptionVATNotPresent__c='description', 
        // //                                      NE__Fiscal_code__c='RSSMRA80A01F205X',
        // //                                      OB_BypassValidation__c=true,
        // //                                      OB_Status__c='Active');   
        // //accList.add(myMastMerchant);
        // //accList.add(bankAccount);
        // //insert accList;
        // //NE__Service_Point__c servicePoint1 = new NE__Service_Point__c();
        // //insert servicePoint1;
        // //NE__Order_Header__c orderHeader = new NE__Order_Header__c(OB_ProposerABI__c=bankAccount.Id ,NE__AccountId__c=myMastMerchant.Id );
        // //insert orderHeader;
        // Account acc = new Account();
		// acc.Name = 'Test';
		// //acc.Description  = 'Test';
		// acc.NE__E_mail__c  = 'test@null.it';
		// acc.OB_Employees_Number__c = 'Minore di 10';
		// acc.NE__VAT__c  = '12345678901';
		// acc.NE__Fiscal_code__c= '12345678901';
		// acc.OB_VAT_Not_Present__c = false;
		// insert acc;


        //  Contact cont           = new Contact();
        //  cont.FirstName                        = 'RIRI';
        //  cont.LastName                         = 'TOTI';
        //  cont.OB_Fiscal_Code__c                = 'TTORRI00B01D150K';
        //  cont.OB_Document_Release_Authority__c = 'Comune' ;
        //  cont.OB_Document_Type__c            = 'Carta di IdentitĂ ';
        //  cont.OB_Sex__c                      = 'M';
        //  cont.OB_BypassValidation__c         = false;
        //  cont.OB_Document_Number__c          = '123erty644';
        //  cont.RecordTypeId                   = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Esecutore').getRecordTypeId();
        //  cont.AccountId=acc.Id;
        //  insert cont;

        //  Map<String, Object> contactObject = (Map<String, Object>)JSON.deserialize(JSON.serialize(cont),Map<String, Object>.class)


        //data.put('NE__Order_Header__c', orderHeader); 
        
       // String esecutoreRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Esecutore' AND sObjectType = 'Account' LIMIT 1].id;
        //Map<String, Object> data =(Map<String, Object>)JSON.deserializeUntyped('{"pv":{"NE__Street__c":"VIA CASALE","OB_AlternativeAddress__c":"","OB_Opening_Monday_Afternoon__c":"true","OB_Fax_Number__c":"","OB_PEC__c":"","OB_Start_Seasonal__c":"","OB_Opening_Tuesday_Morning__c":"true","OB_Opening_Thursday_Afternoon__c":"true","Name":"test88888","RecordTypeId":"","OB_Opening_Wednesday_Morning__c":"true","OB_Opening_Wednesday_Afternoon__c":"true","OB_Opening_Thursday_Morning__c":"true","OB_Opening_Friday_Afternoon__c":"true","OB_Email__c":"","OB_Workshift__c":"false","OB_Address_Hamlet__c":"","NE__City__c":"SALERNO","OB_Opening_Monday_Morning__c":"true","OB_Opening_Saturday_Morning__c":"true","OB_Phone_Number__c":"","OB_Opening_Tuesday_Afternoon__c":"true","OB_Privacy_C4__c":"false","OB_Privacy_C3__c":"false","OB_BypassValidation__c":"false","OB_Street_Number__c":"3","OB_Opening_Friday_Morning__c":"true","OB_Service_Point_City__c":"","OB_End_Seasonal__c":"","OB_Mobile_Phone_Number__c":"","OB_Opening_Saturday_Afternoon__c":"true","NE__Province__c":"SALERNO","OB_MCC_Description__c":"ALL","NE__Postal_Code__c":"","NE__Account__c":"","OB_MCC__c":"0000","OB_Typology__c":"Fisico","OB_Opening_Sunday_Afternoon__c":"true","OB_Service_Point_Name__c":"","OB_Privacy_C5__c":"false","OB_Opening_Sunday_Morning__c":"true","OB_Ecommerce__c":false,"NE__Country__c":"ITALIA","sobjectType":"ne__service_point__c","NE__Zip_Code__c":"84133","NE__Country_Code__c":"ITA","Id":""},"legale_rappresentante":{"OB_Country_Birth__c":"","OB_Document_Release_Country__c":"","OB_Company_Link_Type__c":"","OB_Document_Release_City__c":"","OB_Birth_City__c":"","OB_Document_Release_State__c":"","Fax":"","OB_Document_Expiration_Date__c":"","OB_Citizenship__c":"","OB_PEP__c":"false","Id":"","OB_Document_Release_Authority__c":"","OB_Document_Release_Date__c":"","OB_Document_Number__c":"","OB_Document_Type__c":"","OB_Birth_State__c":"","OB_Birth_Date__c":"","Role__c":"","OB_Sex__c":"","OB_Fiscal_Code__c":"","LastName":"","FirstName":"","RecordTypeId":"'+esecutoreRecordTypeId+'","sobjectType":"contact"},"OrderHeader":{"sobjectType":"ne__order_header__c","RecordTypeId":"","Id":"","OB_Report_Type__c":"","OB_OrderDate__c":"2018-11-22"},"Configuration":{"OB_GT__c":"Nexi","OB_ReceiptHeader__c":"chiesa bella2","OB_ReceiptCity__c":"SALERNO","NE__Parameters__c":"","Id":"","RecordTypeId":"","sobjectType":"ne__order__c"},"merchant":{"Id":"","Name":"test","OB_FATECO__c":"S","OB_VAT_Not_Present__c":true,"OB_Annual_Negotiated__c":0,"OB_Annual_Revenue__c":123456789,"NE__Fiscal_code__c":"MRTMTT25D09F205Z","OB_Employees_Number__c":"Minore di 10","OB_DescriptionVATNotPresent__c":"ENTE ECCLESIASTICO","Phone":"12345678","Type":"Account","OB_Bank_owner__c":"","OB_Beneficial_Owner_Existence__c":true,"OB_Year_constitution_company__c":2018,"NE__E_mail__c":"test@test.as","OB_Legal_Address_Country__c":"ITALIA","NE__Status__c":"Prospect","attributes":{"url":"","type":"Account"}}}');
        //sData.put('Object',customObject); 
        //OB_CustomSaveData_CC csd = new OB_CustomSaveData_CC();

        Map<String,Object> data = (Map<String,Object>)JSON.deserializeUntyped('{"BillingProfile2":{"sobjectType":"ne__billing_profile__c","RecordTypeId":"","OB_ABI__c":"","OB_Bank_Account_Number__c":"","OB_Bank_Account_Owner__c":"","OB_Bank_Account_Type__c":"Debit"},"BillingProfile1":{"sobjectType":"ne__billing_profile__c","RecordTypeId":"","OB_ABI__c":"","OB_Bank_Account_Number__c":"","OB_Bank_Account_Owner__c":"","OB_Bank_Account_Type__c":"Credit"},"contact6":{"sobjectType":"contact","RecordTypeId":"0129E000000AcI6QAK","FirstName":"","LastName":"","OB_Fiscal_Code__c":"","OB_Sex__c":"","Role__c":"","AccountId":"","OB_Birth_Date__c":"","OB_Birth_State__c":"","OB_Birth_City__c":"","OB_Document_Type__c":"","OB_Document_Release_City__c":"","OB_Document_Number__c":"","OB_Document_Release_Date__c":"","OB_Document_Release_Authority__c":""},"contact5":{"sobjectType":"contact","RecordTypeId":"0129E000000AcI6QAK","FirstName":"","LastName":"","OB_Fiscal_Code__c":"","OB_Sex__c":"","Role__c":"","AccountId":"","OB_Birth_Date__c":"","OB_Birth_State__c":"","OB_Birth_City__c":"","OB_Document_Type__c":"","OB_Document_Release_City__c":"","OB_Document_Number__c":"","OB_Document_Release_Date__c":"","OB_Document_Release_Authority__c":""},"contact4":{"sobjectType":"contact","RecordTypeId":"0129E000000AcI6QAK","FirstName":"","LastName":"","OB_Fiscal_Code__c":"","OB_Sex__c":"","Role__c":"","AccountId":"","OB_Birth_Date__c":"","OB_Birth_State__c":"","OB_Birth_City__c":"","OB_Document_Type__c":"","OB_Document_Release_City__c":"","OB_Document_Number__c":"","OB_Document_Release_Date__c":"","OB_Document_Release_Authority__c":""},"contact3":{"sobjectType":"contact","RecordTypeId":"0129E000000AcI6QAK","FirstName":"","LastName":"","OB_Fiscal_Code__c":"","OB_Sex__c":"","Role__c":"","AccountId":"","OB_Birth_Date__c":"","OB_Birth_State__c":"","OB_Birth_City__c":"","OB_Document_Type__c":"","OB_Document_Release_City__c":"","OB_Document_Number__c":"","OB_Document_Release_Date__c":"","OB_Document_Release_Authority__c":""},"contact2":{"sobjectType":"contact","RecordTypeId":"0129E000000AcI6QAK","FirstName":"","LastName":"","OB_Fiscal_Code__c":"","OB_Sex__c":"","Role__c":"","AccountId":"","OB_Birth_Date__c":"","OB_Birth_State__c":"","OB_Birth_City__c":"","OB_Document_Type__c":"","OB_Document_Release_City__c":"","OB_Document_Number__c":"","OB_Document_Release_Date__c":"","OB_Document_Release_Authority__c":""},"contact1":{"sobjectType":"contact","RecordTypeId":"0129E000000AcI6QAK","FirstName":"","LastName":"test","OB_Fiscal_Code__c":"","OB_Sex__c":"","Role__c":"","AccountId":"","OB_Birth_Date__c":"","OB_Birth_State__c":"","OB_Birth_City__c":"","OB_Document_Type__c":"","OB_Document_Release_City__c":"","OB_Document_Number__c":"","OB_Document_Release_Date__c":"","OB_Document_Release_Authority__c":""},"legale_rappresentante":{"sobjectType":"contact","RecordTypeId":"","FirstName":"","LastName":"test","OB_Fiscal_Code__c":"","OB_Sex__c":"","Role__c":"","OB_Birth_Date__c":"","OB_Birth_State__c":"","OB_Birth_City__c":"","OB_Document_Type__c":"","OB_Document_Number__c":"","OB_Document_Release_Date__c":"","OB_Document_Release_City__c":"","OB_Document_Release_Authority__c":""},"orderId":{"sobjectType":"UNBIND","RecordTypeId":""},"pv":{"sobjectType":"ne__service_point__c","RecordTypeId":"","NE__Account__c":"","Name":"","NE__Street__c":"","NE__Zip_Code__c":"","NE__City__c":"","NE__Province__c":"","NE__Country__c":"","Id":"","OB_MCC__c":"","OB_Email__c":"","OB_PEC__c":"","OB_Opening_Monday_Morning__c":"true","OB_Opening_Monday_Afternoon__c":"true","OB_Opening_Thursday_Morning__c":"true","OB_Opening_Thursday_Afternoon__c":"true","OB_Opening_Tuesday_Morning__c":"true","OB_Opening_Tuesday_Afternoon__c":"true","OB_Opening_Wednesday_Morning__c":"true","OB_Opening_Wednesday_Afternoon__c":"true","OB_Opening_Friday_Morning__c":"true","OB_Opening_Friday_Afternoon__c":"true","OB_Opening_Saturday_Morning__c":"true","OB_Opening_Saturday_Afternoon__c":"true","OB_Opening_Sunday_Morning__c":"true","OB_Opening_Sunday_Afternoon__c":"true"},"unbind":{"sobjectType":"UNBIND","RecordTypeId":"","nextCheckout":"","nextCheck":"","orderId":"","UNBIND7":"ACQUIRING","UNBIND5":"","UNBIND6":""},"merchant":{"sobjectType":"account","RecordTypeId":"","Id":"' + merchant.id + '","Name":"' + merchant.Name + '","NE__Fiscal_code__c":"yuiou8956tyu895t","NE__VAT__c":"","OB_Services_Choice__c":"","OB_Legal_Address_Street__c":"","OB_Legal_Address_City__c":"","OB_Legal_Address_State__c":"","OB_Legal_Address_ZIP__c":"","OB_Legal_Address_Country__c":"","OB_Administrative_Office_City__c":"","OB_Administrative_Office_Street__c":"","OB_Administrative_Office_State__c":"","OB_Administrative_Office_ZIP__c":"","OB_Administrative_Office_Name__c":""}}');
               Map<String,Object> data2 = (Map<String,Object>)JSON.deserializeUntyped('{"BillingProfile2":{"sobjectType":"ne__billing_profile__c","RecordTypeId":"","OB_ABI__c":"","OB_Bank_Account_Number__c":"","OB_Bank_Account_Owner__c":"","OB_Bank_Account_Type__c":"Debit"},"BillingProfile1":{"sobjectType":"ne__billing_profile__c","RecordTypeId":"","OB_ABI__c":"","OB_Bank_Account_Number__c":"","OB_Bank_Account_Owner__c":"","OB_Bank_Account_Type__c":"Credit"},"contact6":{"sobjectType":"contact","RecordTypeId":"0129E000000AcI6QAK","FirstName":"","LastName":"","OB_Fiscal_Code__c":"","OB_Sex__c":"","Role__c":"","AccountId":"","OB_Birth_Date__c":"","OB_Birth_State__c":"","OB_Birth_City__c":"","OB_Document_Type__c":"","OB_Document_Release_City__c":"","OB_Document_Number__c":"","OB_Document_Release_Date__c":"","OB_Document_Release_Authority__c":""},"contact5":{"sobjectType":"contact","RecordTypeId":"0129E000000AcI6QAK","FirstName":"","LastName":"","OB_Fiscal_Code__c":"","OB_Sex__c":"","Role__c":"","AccountId":"","OB_Birth_Date__c":"","OB_Birth_State__c":"","OB_Birth_City__c":"","OB_Document_Type__c":"","OB_Document_Release_City__c":"","OB_Document_Number__c":"","OB_Document_Release_Date__c":"","OB_Document_Release_Authority__c":""},"contact4":{"sobjectType":"contact","RecordTypeId":"0129E000000AcI6QAK","FirstName":"","LastName":"","OB_Fiscal_Code__c":"","OB_Sex__c":"","Role__c":"","AccountId":"","OB_Birth_Date__c":"","OB_Birth_State__c":"","OB_Birth_City__c":"","OB_Document_Type__c":"","OB_Document_Release_City__c":"","OB_Document_Number__c":"","OB_Document_Release_Date__c":"","OB_Document_Release_Authority__c":""},"contact3":{"sobjectType":"contact","RecordTypeId":"0129E000000AcI6QAK","FirstName":"","LastName":"","OB_Fiscal_Code__c":"","OB_Sex__c":"","Role__c":"","AccountId":"","OB_Birth_Date__c":"","OB_Birth_State__c":"","OB_Birth_City__c":"","OB_Document_Type__c":"","OB_Document_Release_City__c":"","OB_Document_Number__c":"","OB_Document_Release_Date__c":"","OB_Document_Release_Authority__c":""},"contact2":{"sobjectType":"contact","RecordTypeId":"0129E000000AcI6QAK","FirstName":"","LastName":"","OB_Fiscal_Code__c":"","OB_Sex__c":"","Role__c":"","AccountId":"","OB_Birth_Date__c":"","OB_Birth_State__c":"","OB_Birth_City__c":"","OB_Document_Type__c":"","OB_Document_Release_City__c":"","OB_Document_Number__c":"","OB_Document_Release_Date__c":"","OB_Document_Release_Authority__c":""},"contact1":{"sobjectType":"contact","RecordTypeId":"0129E000000AcI6QAK","FirstName":"","LastName":"test","OB_Fiscal_Code__c":"","OB_Sex__c":"","Role__c":"","AccountId":"","OB_Birth_Date__c":"","OB_Birth_State__c":"","OB_Birth_City__c":"","OB_Document_Type__c":"","OB_Document_Release_City__c":"","OB_Document_Number__c":"","OB_Document_Release_Date__c":"","OB_Document_Release_Authority__c":""},"legale_rappresentante":{"sobjectType":"contact","RecordTypeId":"","FirstName":"","LastName":"test","OB_Fiscal_Code__c":"","OB_Sex__c":"","Role__c":"","OB_Birth_Date__c":"","OB_Birth_State__c":"","OB_Birth_City__c":"","OB_Document_Type__c":"","OB_Document_Number__c":"","OB_Document_Release_Date__c":"","OB_Document_Release_City__c":"","OB_Document_Release_Authority__c":""},"orderId":{"sobjectType":"UNBIND","RecordTypeId":""},"pv":{"sobjectType":"ne__service_point__c","RecordTypeId":"","NE__Account__c":"","Name":"","NE__Street__c":"","NE__Zip_Code__c":"","NE__City__c":"","NE__Province__c":"","NE__Country__c":"","Id":"","OB_MCC__c":"","OB_Email__c":"","OB_PEC__c":"","OB_Opening_Monday_Morning__c":"true","OB_Opening_Monday_Afternoon__c":"true","OB_Opening_Thursday_Morning__c":"true","OB_Opening_Thursday_Afternoon__c":"true","OB_Opening_Tuesday_Morning__c":"true","OB_Opening_Tuesday_Afternoon__c":"true","OB_Opening_Wednesday_Morning__c":"true","OB_Opening_Wednesday_Afternoon__c":"true","OB_Opening_Friday_Morning__c":"true","OB_Opening_Friday_Afternoon__c":"true","OB_Opening_Saturday_Morning__c":"true","OB_Opening_Saturday_Afternoon__c":"true","OB_Opening_Sunday_Morning__c":"true","OB_Opening_Sunday_Afternoon__c":"true"},"unbind":{"sobjectType":"UNBIND","RecordTypeId":"","nextCheckout":"","nextCheck":"","orderId":"","UNBIND7":"ACQUIRING","UNBIND5":"","UNBIND6":""},"merchant":{"sobjectType":"account","RecordTypeId":"","Id":"","Name":"' + merchant.Name + '","NE__Fiscal_code__c":"yuiou8956tyu895t","NE__VAT__c":"","OB_Services_Choice__c":"","OB_Legal_Address_Street__c":"","OB_Legal_Address_City__c":"","OB_Legal_Address_State__c":"","OB_Legal_Address_ZIP__c":"","OB_Legal_Address_Country__c":"","OB_Administrative_Office_City__c":"","OB_Administrative_Office_Street__c":"","OB_Administrative_Office_State__c":"","OB_Administrative_Office_ZIP__c":"","OB_Administrative_Office_Name__c":""}}');

        Test.startTest(); 
        OB_CustomSaveData_CC csd = new OB_CustomSaveData_CC();   
        csd.save(step, data, targetObjectKey, stepsDefinition, dynamicWizardWrapper);
        //csd.save(step, data2, targetObjectKey, stepsDefinition, dynamicWizardWrapper);    
        Test.stopTest(); 
   
    }
    
        
   //  @isTest
   // public static void saveTest()
   // {

   // Map<String, Object> data = OB_CustomSaveData_CC_Test.setupData();

   //Contact cont           = new Contact();
   //     cont.FirstName                        = 'RIRI';
   //     cont.LastName                         = 'TOTI';
   //     cont.OB_Fiscal_Code__c                = 'TTORRI00B01D150K';
   //     cont.OB_Document_Release_Authority__c = 'Comune' ;
   //     cont.OB_Document_Type__c            = 'Carta di IdentitĂ ';
   //     cont.OB_Sex__c                      = 'M';
   //     cont.OB_BypassValidation__c         = false;
   //     cont.OB_Document_Number__c          = '123erty644';
   //     cont.RecordTypeId                   = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Esecutore').getRecordTypeId();
   //     //cont.AccountId  

   // NE__Order_Header__c orderHeader = new NE__Order_Header__c();
   // insert orderHeader;


   // Account acc = new Account();
   //     acc.Name                   = 'Test';
   //     acc.NE__E_mail__c          = 'test@null.it';
   //     acc.OB_Employees_Number__c = 'Minore di 10';
   //     acc.NE__VAT__c             = '12345678901';
   //     acc.NE__Fiscal_code__c     = '12345678901';
   //     acc.OB_VAT_Not_Present__c  = false;
   //     acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Merchant').getRecordTypeId();
   //     insert acc;

   // data.put('OrderHeader', orderHeader);
   // data.put('legale_rappresentante',cont);
   // data.put('merchant' , acc);
   // String step = '';
   // String targetObjectKey = '';
   // List<bit2flow.DynamicWizardWrapper.StepDefinitions> stepsDefinition = new List <bit2flow.DynamicWizardWrapper.StepDefinitions>();
   // bit2flow.DynamicWizardWrapper dynamicWizardWrapper = new bit2flow.DynamicWizardWrapper();

   // try{
   //  Map<String,sObject> sObjMap = bit2flow.B2FUtils.createSObjectMap(data);
   // }
   // catch(Exception ex){

   //      system.debug('***Exception***: ' + ex + ': Line ---> ' + ex.getLineNumber());
   // }

   // Test.startTest();
   // OB_CustomSaveData_CC csd = new OB_CustomSaveData_CC();
   // csd.save(step,data,targetObjectKey,stepsDefinition, dynamicWizardWrapper);
   // //csd.save('', data, '', null, null);
   // Test.stopTest();      

   // }

    
}