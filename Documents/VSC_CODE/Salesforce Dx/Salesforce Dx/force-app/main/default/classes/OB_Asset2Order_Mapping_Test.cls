@isTest
public class OB_Asset2Order_Mapping_Test {
    @isTest
    public static void callAssetToOrderServerTest1(){
        
        Account acc  =  new Account(); 
        acc.Name         = 'TEST';
        acc.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Bank'].id;
        acc.OB_Employees_Number__c         = 'Minore di 10';
        acc.OB_VAT_Not_Present__c          = false;
        acc.OB_DescriptionVATNotPresent__c = 'description';
        acc.NE__Fiscal_code__c             = 'RSSMRA80A01F205X';
        acc.OB_BypassValidation__c         = true;
        acc.OB_Status__c                   = 'Active'; 
        acc.NE__VAT__c                     = '12312312312'; 
        acc.OB_ABI__c                      = '05696';
        insert acc;
        
        NE__Service_Point__c sp   = new NE__Service_Point__c();
        sp.OB_MCC__c   ='2345';
        sp.NE__City__c = 'Yaounde';
        insert sp;
        
        NE__Billing_Profile__c bp = new NE__Billing_Profile__c(NE__Account__c = acc.id);
        insert bp;

        NE__Order__c ord        = new NE__Order__c();
        ord.NE__AccountId__c    = acc.id;
        ord.NE__BillAccId__c    = acc.Id;
        ord.NE__ServAccId__c    = acc.Id;
        ord.OB_MCCL2__c         = '0000';
        ord.OB_GT__c		    = 'Nexi';
        ord.OB_Service_Point__c = sp.id;
        ord.NE__BillingProfId__c = bp.Id;    
        insert ord; 

        Id rtStd = Schema.SObjectType.Asset.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        Asset assFather = new Asset();
        assFather.Name = 'test';
        assFather.AccountId = acc.id;
        assFather.NE__Billing_Account__c = acc.id;
        assFather.NE__Service_Account__c = acc.id;
        assFather.recordTypeId = rtStd;
        assFather.NE__Status__c ='Active';
        assFather.NE__Order_Config__c = ord.id;
        assFather.NE__BillingProf__c = bp.Id; 
        assFather.quantity = 1;
        insert assFather;

        OB_Asset2Order_Mapping AOM = new OB_Asset2Order_Mapping ();
        OB_Asset2Order AO = new OB_Asset2Order();
        String selectBody = AO.getAssetBody();
        String 	assetQuery  = 'SELECT ' + selectBody;
        assetQuery += ' FROM asset where RootAssetId = :offerAssetId AND NE__Status__c =\'Active\' LIMIT 1';
        Id offerAssetId = assFather.Id;
        Asset rootAsset = Database.query(assetQuery);

        system.System.assertEquals(AOM.getAssetFields().size() > 0,true);
        system.System.assertEquals(AOM.getAssetAttributeFields().size() > 0,true);
        system.System.assertEquals(AOM.mapAsset2OrderHeader(rootAsset).getSObjectType().getDescribe().getName(),'NE__Order_Header__c');
        system.System.assertEquals(AOM.mapAsset2Order(rootAsset).getSObjectType().getDescribe().getName(),'NE__Order__c');
        system.System.assertEquals(AOM.mapAsset2OrderItem(rootAsset).getSObjectType().getDescribe().getName(),'NE__OrderItem__c');
    }
    

}