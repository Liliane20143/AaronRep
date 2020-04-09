@isTest
public with sharing class OB_DeltaRun_LightService_Test 
{
    @isTest
    public static void updateTerminal_Test_Exception()
    {
        OB_DeltaRun_LightService.CompanyInfo companyInfoWithCompanyCodeNull = new OB_DeltaRun_LightService.CompanyInfo();
        companyInfoWithCompanyCodeNull.companyCode = null;
        companyInfoWithCompanyCodeNull.ABI = 'ABI';
        companyInfoWithCompanyCodeNull.conventionCode = 'conventionCode';
        companyInfoWithCompanyCodeNull.activationDate = Date.newInstance(1960, 2, 17);
        companyInfoWithCompanyCodeNull.deactivationdDate = Date.newInstance(1960, 2, 17);

        OB_DeltaRun_LightService.CompanyInfo companyInfoWithConventionCodeNull = new OB_DeltaRun_LightService.CompanyInfo();
        companyInfoWithConventionCodeNull.companyCode = 'companyCode';
        companyInfoWithConventionCodeNull.ABI = 'ABI';
        companyInfoWithConventionCodeNull.conventionCode = null;
        companyInfoWithConventionCodeNull.activationDate = Date.newInstance(1960, 2, 17);
        companyInfoWithConventionCodeNull.deactivationdDate = Date.newInstance(1960, 2, 17);

        OB_DeltaRun_LightService.CompanyInfo companyInfoWithABINull = new OB_DeltaRun_LightService.CompanyInfo();
        companyInfoWithABINull.companyCode = 'companyCode';
        companyInfoWithABINull.ABI = null;
        companyInfoWithABINull.conventionCode = 'conventionCode';
        companyInfoWithABINull.activationDate = Date.newInstance(1960, 2, 17);
        companyInfoWithABINull.deactivationdDate = Date.newInstance(1960, 2, 17);

        OB_DeltaRun_LightService.CompanyInfo companyInfoWithDatesNull = new OB_DeltaRun_LightService.CompanyInfo();
        companyInfoWithDatesNull.companyCode = 'companyCode';
        companyInfoWithDatesNull.ABI = 'ABI';
        companyInfoWithDatesNull.conventionCode = 'conventionCode';
        companyInfoWithDatesNull.activationDate = null;
        companyInfoWithDatesNull.deactivationdDate = null;

        OB_DeltaRun_LightService.TermInfo termInfo = new OB_DeltaRun_LightService.TermInfo();
        termInfo.modelCode = 'modelCode';
        termInfo.modelDescription = 'modelDescription';
        termInfo.releaseCode = 'releaseCode';
        termInfo.releaseDescription = 'releaseDescription';
        termInfo.connectionCode = 'connectionCode';
        termInfo.connectionDescription = 'connectionDescription';

        OB_DeltaRun_LightService.DeltaRequest req1 = new OB_DeltaRun_LightService.DeltaRequest();
        OB_DeltaRun_LightService.DeltaRequest req2 = new OB_DeltaRun_LightService.DeltaRequest();
        req2.terminalId = 'terminalId';
        req2.clientId = 'clienId';
        req2.stabId = 'stabId';
        OB_DeltaRun_LightService.DeltaRequest req3 = new OB_DeltaRun_LightService.DeltaRequest();
        req3.terminalId = 'terminalId';
        req3.clientId = 'clienId';
        req3.stabId = 'stabId';
        req3.terminalData = termInfo;
        req3.companyData = companyInfoWithCompanyCodeNull;
        OB_DeltaRun_LightService.DeltaRequest req4 = new OB_DeltaRun_LightService.DeltaRequest();
        req4.terminalId = 'terminalId';
        req4.clientId = 'clienId';
        req4.stabId = 'stabId';
        req4.terminalData = termInfo;
        req4.companyData = companyInfoWithConventionCodeNull;
        OB_DeltaRun_LightService.DeltaRequest req5 = new OB_DeltaRun_LightService.DeltaRequest();
        req5.terminalId = 'terminalId';
        req5.clientId = 'clienId';
        req5.stabId = 'stabId';
        req5.terminalData = termInfo;
        req5.companyData = companyInfoWithABINull;
        OB_DeltaRun_LightService.DeltaRequest req6 = new OB_DeltaRun_LightService.DeltaRequest();
        req6.terminalId = 'terminalId';
        req6.clientId = 'clienId';
        req6.stabId = 'stabId';
        req6.terminalData = termInfo;
        req6.companyData = companyInfoWithDatesNull;
        
        OB_DeltaRun_LightService.CompanyInfo companyData = new OB_DeltaRun_LightService.CompanyInfo();
        companyData.companyCode = 'companyCode';
        companyData.ABI = '12345';
        companyData.conventionCode = 'conventionCode';
        companyData.activationDate = Date.newInstance(1960, 2, 17);
        companyData.deactivationdDate = Date.newInstance(1960, 2, 17);

        OB_DeltaRun_LightService.DeltaRequest request = new OB_DeltaRun_LightService.DeltaRequest();
        request.terminalId = 'terminalId';
        request.clientId = 'clientId';
        request.stabId = 'stabId';
        request.terminalData = termInfo;
        request.companyData = companyData;

        Test.startTest();
        OB_DeltaRun_LightService.updateTerminal(req1);
        OB_DeltaRun_LightService.updateTerminal(req2);
        OB_DeltaRun_LightService.updateTerminal(req3);
        OB_DeltaRun_LightService.updateTerminal(req4);
        OB_DeltaRun_LightService.updateTerminal(req5);
        OB_DeltaRun_LightService.updateTerminal(req6);
        OB_DeltaRun_LightService.updateTerminal(request);
        Test.stopTest();
    }

    @isTest
    public static void updateTerminal_Test() {

        Account acc  = new Account(); 
        acc.Name = 'TEST';
        acc.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Bank'].id;
        acc.OB_Employees_Number__c = 'Minore di 10';
        acc.OB_VAT_Not_Present__c = false;
        acc.OB_DescriptionVATNotPresent__c = 'description';
        acc.NE__Fiscal_code__c = 'RSSMRA80A01F205X';
        acc.OB_BypassValidation__c = true;
        acc.OB_Status__c = 'Active'; 
        acc.NE__VAT__c = '12312312312'; 
        acc.OB_ABI__c = '12345';
        insert acc;

        NE__Bundle__c bundle = new NE__Bundle__c();
        bundle.Name = 'test';
        bundle.NE__Configuration_Type__c = 'Free';
        bundle.NE__BaseRecurringCharge__c = 12.00;
        bundle.NE__RecurringChargeFrequency__c = 'Annual';
        bundle.NE__Start_Date__c = System.now();
        bundle.NE__End_Date__c = System.now().addDays(1);
        insert bundle;

        NE__Order_Header__c oh = new NE__Order_Header__c();
        oh.OB_Business_Model_Acquiring__c = 'Bancario'; 
        oh.OB_Business_Model_POS__c = 'Trilaterale Nuovo';
        oh.OB_Main_Process__c = 'Setup';
        insert oh;

        NE__Service_Point__c sp  = new NE__Service_Point__c();
        sp.OB_MCC__c   ='2345';
        sp.NE__City__c = 'Yaounde';
        insert sp;

        NE__Order__c ord = new NE__Order__c();
        ord.NE__Order_Header__c = oh.id;
        ord.NE__AccountId__c = acc.id;
        ord.NE__BillAccId__c = acc.Id;
        ord.NE__ServAccId__c = acc.Id;
        ord.OB_MCCL2__c = '0000';
        ord.OB_GT__c = 'Nexi';
        ord.OB_Service_Point__c = sp.id; 
        ord.OB_FulfilmentStatus__c = 'Sent';        
        insert ord; 

        NE__Item_Header__c itemHeader = new NE__Item_Header__c();
        itemHeader.Name = 'REFERRAL' ;
        insert itemHeader;
        
        NE__Product__c prod = new NE__Product__c();
        prod.OB_Codice_sfdc__c = '98765';
        insert prod;

        NE__Billing_Profile__c bp = new NE__Billing_Profile__c();
        bp.NE__Account__c = acc.id;
        insert bp;

        NE__Catalog__c cat = new NE__Catalog__c();
        insert cat;

        NE__Catalog_Item__c ci    = new NE__Catalog_Item__c();
        ci.NE__ProductId__c = prod.id;
        ci.NE__Catalog_Id__c = cat.id;
        ci.NE__Item_Header__c = itemHeader.id;
        ci.NE__Type__c = 'Product'; 
        insert ci;

        NE__OrderItem__c terminalItem = New NE__OrderItem__c(NE__Qty__c = 10 ,NE__OrderId__c = ord.id);
        terminalItem.NE__Action__c      = 'Add';
        terminalItem.OB_ShopCode__c     = 'stabId';
        terminalItem.OB_CustomerCode__c = 'clientId';
        terminalItem.OB_TermId__c       = 'terminalId';  
        terminalItem.OB_ProposerABI__c  = acc.id;
        terminalItem.NE__OrderId__c = ord.id;
        insert terminalItem;

        Asset ass = new Asset();
       // ass.RootAssetId                     = rootAsset.Id;
        ass.NE__CatalogItem__c              = ci.id;
        ass.AccountId                       = acc.id;
        ass.OB_DebitProfId__c               = bp.id;
        ass.OB_ProposerABI__c               = acc.id;
        ass.IsCompetitorProduct             = false;
       // ass.IsInternal                      = false;
        ass.Name                            = 'Offerta Personalizzata';
        ass.NE__Action__c                   = 'Change';
        ass.NE__AssetItemEnterpriseId__c    = '123123123';
        ass.NE__BaseOneTimeFee__c           = 0;
        ass.NE__BaseRecurringCharge__c      = 0;
        ass.NE__Billing_Account__c          = acc.id;
        ass.NE__Commitment__c               = false;
        ass.NE__Discount_One_time__c        = 0;
        ass.NE__Discount__c                 = 0;
        ass.NE__Generate_Asset_Item__c      = true;
        ass.NE__Item_Code__c                = '';
        ass.NE__Order_Config__c             = ord.id;
        ass.NE__ProdId__c                   = prod.id;
        ass.NE__RecurringChargeFrequency__c = 'Monthly';
        ass.NE__Remove_from_total__c        = false;
        ass.NE__Service_Account__c          = acc.id;
        ass.NE__Service_Point__c            = sp.id;
        ass.NE__Status__c                   = 'Active';
        ass.OB_enablement__c                = 'N';
        ass.OB_MCCL2__c                     = '0001';
        ass.OB_MCC__c                       = '5200';
        ass.OB_Report_Type__c               = 'Punto Vendita';
        ass.OB_Ro__c                        = 'N';
        ass.OB_Visible__c                   = 'N';
        ass.Quantity                        = 1;
        ass.OB_ShopSign__c                  = '23112';
        ass.OB_ShopCode__c                  = 'stabId';
        ass.OB_CustomerCode__c              = 'clientId';
        ass.OB_TermId__c                    = 'terminalId';
        ass.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Asset' AND DeveloperName = 'Standard' LIMIT 1].id;
        insert ass;

        Asset assetSon = new Asset();
       // ass.RootAssetId                     = rootAsset.Id;
        assetSon.NE__CatalogItem__c              = ci.id;
        assetSon.AccountId                       = acc.id;
        assetSon.OB_DebitProfId__c               = bp.id;
        assetSon.OB_ProposerABI__c               = acc.id;
        assetSon.IsCompetitorProduct             = false;
       // ass.IsInternal                      = false;
        assetSon.Name                            = 'Offerta Personalizzata';
        assetSon.NE__Action__c                   = 'Change';
        assetSon.NE__AssetItemEnterpriseId__c    = '123123123';
        assetSon.NE__BaseOneTimeFee__c           = 0;
        assetSon.NE__BaseRecurringCharge__c      = 0;
        assetSon.NE__Billing_Account__c          = acc.id;
        assetSon.NE__Commitment__c               = false;
        assetSon.NE__Discount_One_time__c        = 0;
        assetSon.NE__Discount__c                 = 0;
        assetSon.NE__Generate_Asset_Item__c      = true;
        assetSon.NE__Item_Code__c                = '';
        assetSon.NE__Order_Config__c             = ord.id;
        assetSon.NE__ProdId__c                   = prod.id;
        assetSon.NE__RecurringChargeFrequency__c = 'Monthly';
        assetSon.NE__Remove_from_total__c        = false;
        assetSon.NE__Service_Account__c          = acc.id;
        assetSon.NE__Service_Point__c            = sp.id;
        assetSon.NE__Status__c                   = 'Active';
        assetSon.OB_enablement__c                = 'N';
        assetSon.OB_MCCL2__c                     = '0001';
        assetSon.OB_MCC__c                       = '5200';
        assetSon.OB_Report_Type__c               = 'Punto Vendita';
        assetSon.OB_Ro__c                        = 'N';
        assetSon.OB_Visible__c                   = 'N';
        assetSon.Quantity                        = 1;
        assetSon.OB_ShopSign__c                  = '23112';
        assetSon.OB_ShopCode__c                  = 'stabId';
        assetSon.OB_CustomerCode__c              = 'clientId';
        assetSon.OB_TermId__c                    = 'terminalId';
        assetSon.NE__Parent_Order_Item__c = ass.id;
        assetSon.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Asset' AND DeveloperName = 'Standard' LIMIT 1].id;
        insert assetSon;
       
        List<NE__AssetItemAttribute__c> assetItemAttrList = new List<NE__AssetItemAttribute__c>();

        NE__AssetItemAttribute__c assetItemAttrRelease = new NE__AssetItemAttribute__c();
        assetItemAttrRelease.Name  = 'release';
        assetItemAttrRelease.NE__Value__c = 'Nexi';
        assetItemAttrRelease.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrRelease);

        NE__AssetItemAttribute__c assetItemAttrModello = new NE__AssetItemAttribute__c();
        assetItemAttrModello.Name  = 'modello';
        assetItemAttrModello.NE__Value__c = 'Nexi';
        assetItemAttrModello.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrModello);

        NE__AssetItemAttribute__c assetItemAttrModalitaCollegamento = new NE__AssetItemAttribute__c();
        assetItemAttrModalitaCollegamento.Name  = 'modalitàCollegamento';
        assetItemAttrModalitaCollegamento.NE__Value__c = 'Nexi';
        assetItemAttrModalitaCollegamento.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrModalitaCollegamento);

        NE__AssetItemAttribute__c assetItemAttrDescrizioneModello = new NE__AssetItemAttribute__c();
        assetItemAttrDescrizioneModello.Name  = 'Descrizione Modello';
        assetItemAttrDescrizioneModello.NE__Value__c = 'Nexi';
        assetItemAttrDescrizioneModello.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrDescrizioneModello);

        NE__AssetItemAttribute__c assetItemAttrDescrizioneRelease = new NE__AssetItemAttribute__c();
        assetItemAttrDescrizioneRelease.Name  = 'Descrizione Release';
        assetItemAttrDescrizioneRelease.NE__Value__c = 'Nexi';
        assetItemAttrDescrizioneRelease.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrDescrizioneRelease);

        NE__AssetItemAttribute__c assetItemAttrDescrizioneConnessione = new NE__AssetItemAttribute__c();
        assetItemAttrDescrizioneConnessione.Name  = 'Descrizione Connessione';
        assetItemAttrDescrizioneConnessione.NE__Value__c = 'Nexi';
        assetItemAttrDescrizioneConnessione.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrDescrizioneConnessione);
        
        insert assetItemAttrList;

        // NE__AssetItemAttribute__c assetItemAttr1 = new NE__AssetItemAttribute__c();
        // assetItemAttr1.Name         = 'modello';
        // assetItemAttr1.NE__Value__c = 'Nexi';
        // assetItemAttr1.NE__Asset__c = ass1.id;
        // insert assetItemAttr1;

        List<NE__Order_Item_Attribute__c> orderItemAttrList = new List<NE__Order_Item_Attribute__c>();

        NE__Order_Item_Attribute__c orderItemAttrModello = new NE__Order_Item_Attribute__c();
        orderItemAttrModello.Name              = 'modello';
        orderItemAttrModello.NE__Value__c      = 'Nexi';
        orderItemAttrModello.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrModello);

        NE__Order_Item_Attribute__c orderItemAttrRelease = new NE__Order_Item_Attribute__c();
        orderItemAttrRelease.Name              = 'release';
        orderItemAttrRelease.NE__Value__c      = 'Nexi';
        orderItemAttrRelease.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrRelease);

        NE__Order_Item_Attribute__c orderItemAttrModalitaCollegamento = new NE__Order_Item_Attribute__c();
        orderItemAttrModalitaCollegamento.Name              = 'modalitàCollegamento';
        orderItemAttrModalitaCollegamento.NE__Value__c      = 'Nexi';
        orderItemAttrModalitaCollegamento.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrModalitaCollegamento);

        NE__Order_Item_Attribute__c orderItemAttrDescrizioneModello = new NE__Order_Item_Attribute__c();
        orderItemAttrDescrizioneModello.Name              = 'Descrizione Modello';
        orderItemAttrDescrizioneModello.NE__Value__c      = 'Nexi';
        orderItemAttrDescrizioneModello.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrDescrizioneModello);

        NE__Order_Item_Attribute__c orderItemAttrDescrizioneRelease = new NE__Order_Item_Attribute__c();
        orderItemAttrDescrizioneRelease.Name              = 'Descrizione Release';
        orderItemAttrDescrizioneRelease.NE__Value__c      = 'Nexi';
        orderItemAttrDescrizioneRelease.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrDescrizioneRelease);

        NE__Order_Item_Attribute__c orderItemAttrDescrizioneConnessione = new NE__Order_Item_Attribute__c();
        orderItemAttrDescrizioneConnessione.Name              = 'Descrizione Connessione';
        orderItemAttrDescrizioneConnessione.NE__Value__c      = 'Nexi';
        orderItemAttrDescrizioneConnessione.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrDescrizioneConnessione);

        insert orderItemAttrList;
        
        NE__Lov__c lov = new NE__Lov__c();
        lov.NE__Sub_Type__c = 'TIPOLOGICHE';
        lov.NE__Type__c = 'TRACKING';
        lov.NE__Value1__c = 'companyCode';
        lov.NE__Value2__c = 'NE__Value2__c';
        insert lov;

        OB_DeltaRun_LightService.CompanyInfo  companyInfo = new OB_DeltaRun_LightService.CompanyInfo();
        companyInfo.companyCode         = '98765';
        companyInfo.ABI                 = '98765';
        companyInfo.conventionCode      = '78765';
        companyInfo.activationDate      = Date.newInstance(2006, 3, 16);
        companyInfo.deactivationdDate   = Date.newInstance(2011, 3, 16);

        OB_DeltaRun_LightService.CompanyInfo companyData = new OB_DeltaRun_LightService.CompanyInfo();
        companyData.companyCode = 'companyCode';
        companyData.ABI = '12345';
        companyData.conventionCode = 'conventionCode';
        companyData.activationDate = Date.newInstance(1960, 2, 17);
        companyData.deactivationdDate = Date.newInstance(1960, 2, 17);

        
        OB_DeltaRun_LightService.TermInfo termInfo = new OB_DeltaRun_LightService.TermInfo();
        termInfo.modelCode = 'modelCode';
        termInfo.modelDescription = 'modelDescription';
        termInfo.releaseCode = 'releaseCode';
        termInfo.releaseDescription = 'releaseDescription';
        termInfo.connectionCode = 'connectionCode';
        termInfo.connectionDescription = 'connectionDescription';

        OB_DeltaRun_LightService.DeltaRequest request = new OB_DeltaRun_LightService.DeltaRequest();
        request.terminalId = 'terminalId';
        request.clientId = 'clientId';
        request.stabId = 'stabId';
        request.terminalData = termInfo;
        request.companyData = companyData;


        OB_DeltaRun_LightService.DeltaRequest req = new OB_DeltaRun_LightService.DeltaRequest();
        req.terminalId   = ass.OB_TermId__c;
        req.clientId     = ass.OB_CustomerCode__c; 
        req.stabId       = ass.OB_ShopCode__c;
        req.terminalData = termInfo;
        req.companyData  = null;

        OB_DeltaRun_LightService.DeltaRequest req1 = new OB_DeltaRun_LightService.DeltaRequest();
        req1.terminalId   = '';
        req1.clientId     = ass.OB_CustomerCode__c; 
        req1.stabId       = ass.OB_ShopCode__c;
        req1.terminalData = null;
        req1.companyData  = null;

        OB_DeltaRun_LightService.DeltaRequest req2 = new OB_DeltaRun_LightService.DeltaRequest();
        req2.terminalId   = ass.OB_TermId__c;
        req2.clientId     = ass.OB_CustomerCode__c; 
        req2.stabId       = ass.OB_ShopCode__c;
        req2.terminalData = termInfo;
        req2.companyData  = companyInfo;
       
        OB_DeltaRun_LightService.DeltaResponse res = new OB_DeltaRun_LightService.DeltaResponse();
        res.errorCode      = 404;
        res.errorMessage   = 'error';
        res.assetId        = ass.id;
        res.rootAssetEntId = ass.id;
        res.childAssEntId  = ass.id;
        
        Test.StartTest();
        OB_DeltaRun_LightService.updateTerminal(request);
        Test.StopTest();
    }

   @isTest
    public static void updateTerminal_Test2() {

        Account acc  = new Account(); 
        acc.Name = 'TEST';
        acc.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Bank'].id;
        acc.OB_Employees_Number__c = 'Minore di 10';
        acc.OB_VAT_Not_Present__c = false;
        acc.OB_DescriptionVATNotPresent__c = 'description';
        acc.NE__Fiscal_code__c = 'RSSMRA80A01F205X';
        acc.OB_BypassValidation__c = true;
        acc.OB_Status__c = 'Active'; 
        acc.NE__VAT__c = '12312312312'; 
        acc.OB_ABI__c = '12345';
        insert acc;

        NE__Bundle__c bundle = new NE__Bundle__c();
        bundle.Name = 'test';
        bundle.NE__Configuration_Type__c = 'Free';
        bundle.NE__BaseRecurringCharge__c = 12.00;
        bundle.NE__RecurringChargeFrequency__c = 'Annual';
        bundle.NE__Start_Date__c = System.now();
        bundle.NE__End_Date__c = System.now().addDays(1);
        insert bundle;

        NE__Order_Header__c oh = new NE__Order_Header__c();
        oh.OB_Business_Model_Acquiring__c = 'Bancario'; 
        oh.OB_Business_Model_POS__c = 'Trilaterale Nuovo';
        oh.OB_Main_Process__c = 'Setup';
        insert oh;

        NE__Service_Point__c sp  = new NE__Service_Point__c();
        sp.OB_MCC__c   ='2345';
        sp.NE__City__c = 'Yaounde';
        insert sp;

        NE__Order__c ord = new NE__Order__c();
        ord.NE__Order_Header__c = oh.id;
        ord.NE__AccountId__c = acc.id;
        ord.NE__BillAccId__c = acc.Id;
        ord.NE__ServAccId__c = acc.Id;
        ord.OB_MCCL2__c = '0000';
        ord.OB_GT__c = 'Nexi';
        ord.OB_Service_Point__c = sp.id; 
        ord.OB_FulfilmentStatus__c = 'Sent';        
        insert ord; 

        NE__Item_Header__c itemHeader = new NE__Item_Header__c();
        itemHeader.Name = 'REFERRAL' ;
        insert itemHeader;
        
        NE__Product__c prod = new NE__Product__c();
        prod.OB_Codice_sfdc__c = 'NE__Value2__c';
        insert prod;

        NE__Billing_Profile__c bp = new NE__Billing_Profile__c();
        bp.NE__Account__c = acc.id;
        insert bp;

        NE__Catalog__c cat = new NE__Catalog__c();
        insert cat;

        NE__Catalog_Item__c ci    = new NE__Catalog_Item__c();
        ci.NE__ProductId__c = prod.id;
        ci.NE__Catalog_Id__c = cat.id;
        ci.NE__Item_Header__c = itemHeader.id;
        ci.NE__Type__c = 'Product'; 
        insert ci;

        NE__OrderItem__c terminalItem = New NE__OrderItem__c(NE__Qty__c = 10 ,NE__OrderId__c = ord.id);
        terminalItem.NE__Action__c      = 'Add';
        terminalItem.OB_ShopCode__c     = 'stabId';
        terminalItem.OB_CustomerCode__c = 'clientId';
        terminalItem.OB_TermId__c       = 'terminalId';  
        terminalItem.OB_ProposerABI__c  = acc.id;
        terminalItem.NE__OrderId__c = ord.id;
        insert terminalItem;

        Asset ass = new Asset();
       // ass.RootAssetId                     = rootAsset.Id;
        ass.NE__CatalogItem__c              = ci.id;
        ass.AccountId                       = acc.id;
        ass.OB_DebitProfId__c               = bp.id;
        ass.OB_ProposerABI__c               = acc.id;
        ass.IsCompetitorProduct             = false;
       // ass.IsInternal                      = false;
        ass.Name                            = 'Offerta Personalizzata';
        ass.NE__Action__c                   = 'Change';
        ass.NE__AssetItemEnterpriseId__c    = '123123123';
        ass.NE__BaseOneTimeFee__c           = 0;
        ass.NE__BaseRecurringCharge__c      = 0;
        ass.NE__Billing_Account__c          = acc.id;
        ass.NE__Commitment__c               = false;
        ass.NE__Discount_One_time__c        = 0;
        ass.NE__Discount__c                 = 0;
        ass.NE__Generate_Asset_Item__c      = true;
        ass.NE__Item_Code__c                = '';
        ass.NE__Order_Config__c             = ord.id;
        ass.NE__ProdId__c                   = prod.id;
        ass.NE__RecurringChargeFrequency__c = 'Monthly';
        ass.NE__Remove_from_total__c        = false;
        ass.NE__Service_Account__c          = acc.id;
        ass.NE__Service_Point__c            = sp.id;
        ass.NE__Status__c                   = 'Active';
        ass.OB_enablement__c                = 'N';
        ass.OB_MCCL2__c                     = '0001';
        ass.OB_MCC__c                       = '5200';
        ass.OB_Report_Type__c               = 'Punto Vendita';
        ass.OB_Ro__c                        = 'N';
        ass.OB_Visible__c                   = 'N';
        ass.Quantity                        = 1;
        ass.OB_ShopSign__c                  = '23112';
        ass.OB_ShopCode__c                  = 'stabId';
        ass.OB_CustomerCode__c              = 'clientId';
        ass.OB_TermId__c                    = 'terminalId';
        ass.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Asset' AND DeveloperName = 'Standard' LIMIT 1].id;
        insert ass;

        List<NE__AssetItemAttribute__c> assetItemAttrList = new List<NE__AssetItemAttribute__c>();

        NE__AssetItemAttribute__c assetItemAttrRelease = new NE__AssetItemAttribute__c();
        assetItemAttrRelease.Name  = 'release';
        assetItemAttrRelease.NE__Value__c = 'Nexi';
        assetItemAttrRelease.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrRelease);

        NE__AssetItemAttribute__c assetItemAttrModello = new NE__AssetItemAttribute__c();
        assetItemAttrModello.Name  = 'modello';
        assetItemAttrModello.NE__Value__c = 'Nexi';
        assetItemAttrModello.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrModello);

        NE__AssetItemAttribute__c assetItemAttrModalitaCollegamento = new NE__AssetItemAttribute__c();
        assetItemAttrModalitaCollegamento.Name  = 'modalitàCollegamento';
        assetItemAttrModalitaCollegamento.NE__Value__c = 'Nexi';
        assetItemAttrModalitaCollegamento.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrModalitaCollegamento);

        NE__AssetItemAttribute__c assetItemAttrDescrizioneModello = new NE__AssetItemAttribute__c();
        assetItemAttrDescrizioneModello.Name  = 'Descrizione Modello';
        assetItemAttrDescrizioneModello.NE__Value__c = 'Nexi';
        assetItemAttrDescrizioneModello.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrDescrizioneModello);

        NE__AssetItemAttribute__c assetItemAttrDescrizioneRelease = new NE__AssetItemAttribute__c();
        assetItemAttrDescrizioneRelease.Name  = 'Descrizione Release';
        assetItemAttrDescrizioneRelease.NE__Value__c = 'Nexi';
        assetItemAttrDescrizioneRelease.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrDescrizioneRelease);

        NE__AssetItemAttribute__c assetItemAttrDescrizioneConnessione = new NE__AssetItemAttribute__c();
        assetItemAttrDescrizioneConnessione.Name  = 'Descrizione Connessione';
        assetItemAttrDescrizioneConnessione.NE__Value__c = 'Nexi';
        assetItemAttrDescrizioneConnessione.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrDescrizioneConnessione);
        
        insert assetItemAttrList;

        List<NE__Order_Item_Attribute__c> orderItemAttrList = new List<NE__Order_Item_Attribute__c>();

        NE__Order_Item_Attribute__c orderItemAttrModello = new NE__Order_Item_Attribute__c();
        orderItemAttrModello.Name              = 'modello';
        orderItemAttrModello.NE__Value__c      = 'Nexi';
        orderItemAttrModello.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrModello);

        NE__Order_Item_Attribute__c orderItemAttrRelease = new NE__Order_Item_Attribute__c();
        orderItemAttrRelease.Name              = 'release';
        orderItemAttrRelease.NE__Value__c      = 'Nexi';
        orderItemAttrRelease.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrRelease);

        NE__Order_Item_Attribute__c orderItemAttrModalitaCollegamento = new NE__Order_Item_Attribute__c();
        orderItemAttrModalitaCollegamento.Name              = 'modalitàCollegamento';
        orderItemAttrModalitaCollegamento.NE__Value__c      = 'Nexi';
        orderItemAttrModalitaCollegamento.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrModalitaCollegamento);

        NE__Order_Item_Attribute__c orderItemAttrDescrizioneModello = new NE__Order_Item_Attribute__c();
        orderItemAttrDescrizioneModello.Name              = 'Descrizione Modello';
        orderItemAttrDescrizioneModello.NE__Value__c      = 'Nexi';
        orderItemAttrDescrizioneModello.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrDescrizioneModello);

        NE__Order_Item_Attribute__c orderItemAttrDescrizioneRelease = new NE__Order_Item_Attribute__c();
        orderItemAttrDescrizioneRelease.Name              = 'Descrizione Release';
        orderItemAttrDescrizioneRelease.NE__Value__c      = 'Nexi';
        orderItemAttrDescrizioneRelease.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrDescrizioneRelease);

        NE__Order_Item_Attribute__c orderItemAttrDescrizioneConnessione = new NE__Order_Item_Attribute__c();
        orderItemAttrDescrizioneConnessione.Name              = 'Descrizione Connessione';
        orderItemAttrDescrizioneConnessione.NE__Value__c      = 'Nexi';
        orderItemAttrDescrizioneConnessione.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrDescrizioneConnessione);

        insert orderItemAttrList;
        
        NE__Lov__c lov = new NE__Lov__c();
        lov.NE__Sub_Type__c = 'TIPOLOGICHE';
        lov.NE__Type__c = 'TRACKING';
        lov.NE__Value1__c = 'companyCode';
        lov.NE__Value2__c = 'NE__Value2__c';
        insert lov;

        OB_DeltaRun_LightService.CompanyInfo  companyInfo = new OB_DeltaRun_LightService.CompanyInfo();
        companyInfo.companyCode         = '98765';
        companyInfo.ABI                 = '98765';
        companyInfo.conventionCode      = '78765';
        companyInfo.activationDate      = Date.newInstance(2006, 3, 16);
        companyInfo.deactivationdDate   = Date.newInstance(2011, 3, 16);

        OB_DeltaRun_LightService.CompanyInfo companyData = new OB_DeltaRun_LightService.CompanyInfo();
        companyData.companyCode = 'companyCode';
        companyData.ABI = '12345';
        companyData.conventionCode = 'conventionCode';
        companyData.activationDate = Date.newInstance(1960, 2, 17);
        companyData.deactivationdDate = null;

        
        OB_DeltaRun_LightService.TermInfo termInfo = new OB_DeltaRun_LightService.TermInfo();
        termInfo.modelCode = 'modelCode';
        termInfo.modelDescription = 'modelDescription';
        termInfo.releaseCode = 'releaseCode';
        termInfo.releaseDescription = 'releaseDescription';
        termInfo.connectionCode = 'connectionCode';
        termInfo.connectionDescription = 'connectionDescription';

        OB_DeltaRun_LightService.DeltaRequest request = new OB_DeltaRun_LightService.DeltaRequest();
        request.terminalId = 'terminalId';
        request.clientId = 'clientId';
        request.stabId = 'stabId';
        request.terminalData = termInfo;
        request.companyData = companyData;


        OB_DeltaRun_LightService.DeltaRequest req = new OB_DeltaRun_LightService.DeltaRequest();
        req.terminalId   = ass.OB_TermId__c;
        req.clientId     = ass.OB_CustomerCode__c; 
        req.stabId       = ass.OB_ShopCode__c;
        req.terminalData = termInfo;
        req.companyData  = null;

        OB_DeltaRun_LightService.DeltaRequest req1 = new OB_DeltaRun_LightService.DeltaRequest();
        req1.terminalId   = '';
        req1.clientId     = ass.OB_CustomerCode__c; 
        req1.stabId       = ass.OB_ShopCode__c;
        req1.terminalData = null;
        req1.companyData  = null;

        OB_DeltaRun_LightService.DeltaRequest req2 = new OB_DeltaRun_LightService.DeltaRequest();
        req2.terminalId   = ass.OB_TermId__c;
        req2.clientId     = ass.OB_CustomerCode__c; 
        req2.stabId       = ass.OB_ShopCode__c;
        req2.terminalData = termInfo;
        req2.companyData  = companyInfo;
       
        OB_DeltaRun_LightService.DeltaResponse res = new OB_DeltaRun_LightService.DeltaResponse();
        res.errorCode      = 404;
        res.errorMessage   = 'error';
        res.assetId        = ass.id;
        res.rootAssetEntId = ass.id;
        res.childAssEntId  = ass.id;
        
        Test.StartTest();
        OB_DeltaRun_LightService.updateTerminal(request);
        Test.StopTest();
    }

    @isTest
    public static void updateTerminal_Test3() {

        Account acc  = new Account(); 
        acc.Name = 'TEST';
        acc.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Bank'].id;
        acc.OB_Employees_Number__c = 'Minore di 10';
        acc.OB_VAT_Not_Present__c = false;
        acc.OB_DescriptionVATNotPresent__c = 'description';
        acc.NE__Fiscal_code__c = 'RSSMRA80A01F205X';
        acc.OB_BypassValidation__c = true;
        acc.OB_Status__c = 'Active'; 
        acc.NE__VAT__c = '12312312312'; 
        acc.OB_ABI__c = '12345';
        insert acc;

        NE__Bundle__c bundle = new NE__Bundle__c();
        bundle.Name = 'test';
        bundle.NE__Configuration_Type__c = 'Free';
        bundle.NE__BaseRecurringCharge__c = 12.00;
        bundle.NE__RecurringChargeFrequency__c = 'Annual';
        bundle.NE__Start_Date__c = System.now();
        bundle.NE__End_Date__c = System.now().addDays(1);
        insert bundle;

        NE__Order_Header__c oh = new NE__Order_Header__c();
        oh.OB_Business_Model_Acquiring__c = 'Bancario'; 
        oh.OB_Business_Model_POS__c = 'Trilaterale Nuovo';
        oh.OB_Main_Process__c = 'Setup';
        insert oh;

        NE__Service_Point__c sp  = new NE__Service_Point__c();
        sp.OB_MCC__c   ='2345';
        sp.NE__City__c = 'Yaounde';
        insert sp;

        NE__Order__c ord = new NE__Order__c();
        ord.NE__Order_Header__c = oh.id;
        ord.NE__AccountId__c = acc.id;
        ord.NE__BillAccId__c = acc.Id;
        ord.NE__ServAccId__c = acc.Id;
        ord.OB_MCCL2__c = '0000';
        ord.OB_GT__c = 'Nexi';
        ord.OB_Service_Point__c = sp.id; 
        ord.OB_FulfilmentStatus__c = 'Sent';        
        insert ord; 

        NE__Item_Header__c itemHeader = new NE__Item_Header__c();
        itemHeader.Name = 'REFERRAL' ;
        insert itemHeader;
        
        NE__Product__c prod = new NE__Product__c();
        prod.OB_Codice_sfdc__c = 'companyCode';
        insert prod;

        NE__Billing_Profile__c bp = new NE__Billing_Profile__c();
        bp.NE__Account__c = acc.id;
        insert bp;

        NE__Catalog__c cat = new NE__Catalog__c();
        cat.Name = 'cat';
        insert cat;

        NE__Catalog_Item__c ci    = new NE__Catalog_Item__c();
        ci.NE__ProductId__c = prod.id;
        ci.NE__Catalog_Id__c = cat.id;
        ci.NE__Item_Header__c = itemHeader.id;
        ci.NE__Type__c = 'Category'; 
        insert ci;

        NE__Catalog_Item__c ci2 = new NE__Catalog_Item__c();
        ci2.NE__ProductId__c = prod.id;
        ci2.NE__Catalog_Id__c = cat.id;
        ci2.NE__Type__c = 'Product';
        

        NE__OrderItem__c terminalItem = New NE__OrderItem__c(NE__Qty__c = 10 ,NE__OrderId__c = ord.id);
        terminalItem.NE__Action__c      = 'Add';
        terminalItem.OB_ShopCode__c     = 'stabId';
        terminalItem.OB_CustomerCode__c = 'clientId';
        terminalItem.OB_TermId__c       = 'terminalId';  
        terminalItem.OB_ProposerABI__c  = acc.id;
        TerminalItem.NE__OrderId__c = ord.id;
        insert terminalItem;

        Asset ass = new Asset();
       // ass.RootAssetId                     = rootAsset.Id;
        ass.NE__CatalogItem__c              = ci.id;
        ass.AccountId                       = acc.id;
        ass.OB_DebitProfId__c               = bp.id;
        ass.OB_ProposerABI__c               = acc.id;
        ass.IsCompetitorProduct             = false;
        ass.NE__Catalog__c = cat.id;
       // ass.IsInternal                      = false;
        ass.Name                            = 'Offerta Personalizzata';
        ass.NE__Action__c                   = 'Change';
        ass.NE__AssetItemEnterpriseId__c    = '123123123';
        ass.NE__BaseOneTimeFee__c           = 0;
        ass.NE__BaseRecurringCharge__c      = 0;
        ass.NE__Billing_Account__c          = acc.id;
        ass.NE__Commitment__c               = false;
        ass.NE__Discount_One_time__c        = 0;
        ass.NE__Discount__c                 = 0;
        ass.NE__Generate_Asset_Item__c      = true;
        ass.NE__Item_Code__c                = '';
        ass.NE__Order_Config__c             = ord.id;
        ass.NE__ProdId__c                   = prod.id;
        ass.NE__RecurringChargeFrequency__c = 'Monthly';
        ass.NE__Remove_from_total__c        = false;
        ass.NE__Service_Account__c          = acc.id;
        ass.NE__Service_Point__c            = sp.id;
        ass.NE__Status__c                   = 'Active';
        ass.OB_enablement__c                = 'N';
        ass.OB_MCCL2__c                     = '0001';
        ass.OB_MCC__c                       = '5200';
        ass.OB_Report_Type__c               = 'Punto Vendita';
        ass.OB_Ro__c                        = 'N';
        ass.OB_Visible__c                   = 'N';
        ass.Quantity                        = 1;
        ass.OB_ShopSign__c                  = '23112';
        ass.OB_ShopCode__c                  = 'stabId';
        ass.OB_CustomerCode__c              = 'clientId';
        ass.OB_TermId__c                    = 'terminalId';
        ass.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Asset' AND DeveloperName = 'Standard' LIMIT 1].id;
        insert ass;

        System.debug('Asset inserito: ' + ass.id);

        List<NE__AssetItemAttribute__c> assetItemAttrList = new List<NE__AssetItemAttribute__c>();

        NE__AssetItemAttribute__c assetItemAttrRelease = new NE__AssetItemAttribute__c();
        assetItemAttrRelease.Name  = 'release';
        assetItemAttrRelease.NE__Value__c = 'Nexi';
        assetItemAttrRelease.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrRelease);

        NE__AssetItemAttribute__c assetItemAttrModello = new NE__AssetItemAttribute__c();
        assetItemAttrModello.Name  = 'modello';
        assetItemAttrModello.NE__Value__c = 'Nexi';
        assetItemAttrModello.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrModello);

        NE__AssetItemAttribute__c assetItemAttrModalitaCollegamento = new NE__AssetItemAttribute__c();
        assetItemAttrModalitaCollegamento.Name  = 'modalitàCollegamento';
        assetItemAttrModalitaCollegamento.NE__Value__c = 'Nexi';
        assetItemAttrModalitaCollegamento.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrModalitaCollegamento);

        NE__AssetItemAttribute__c assetItemAttrDescrizioneModello = new NE__AssetItemAttribute__c();
        assetItemAttrDescrizioneModello.Name  = 'Descrizione Modello';
        assetItemAttrDescrizioneModello.NE__Value__c = 'Nexi';
        assetItemAttrDescrizioneModello.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrDescrizioneModello);

        NE__AssetItemAttribute__c assetItemAttrDescrizioneRelease = new NE__AssetItemAttribute__c();
        assetItemAttrDescrizioneRelease.Name  = 'Descrizione Release';
        assetItemAttrDescrizioneRelease.NE__Value__c = 'Nexi';
        assetItemAttrDescrizioneRelease.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrDescrizioneRelease);

        NE__AssetItemAttribute__c assetItemAttrDescrizioneConnessione = new NE__AssetItemAttribute__c();
        assetItemAttrDescrizioneConnessione.Name  = 'Descrizione Connessione';
        assetItemAttrDescrizioneConnessione.NE__Value__c = 'Nexi';
        assetItemAttrDescrizioneConnessione.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrDescrizioneConnessione);
        
        insert assetItemAttrList;

        List<NE__Order_Item_Attribute__c> orderItemAttrList = new List<NE__Order_Item_Attribute__c>();

        NE__Order_Item_Attribute__c orderItemAttrModello = new NE__Order_Item_Attribute__c();
        orderItemAttrModello.Name              = 'modello';
        orderItemAttrModello.NE__Value__c      = 'Nexi';
        orderItemAttrModello.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrModello);

        NE__Order_Item_Attribute__c orderItemAttrRelease = new NE__Order_Item_Attribute__c();
        orderItemAttrRelease.Name              = 'release';
        orderItemAttrRelease.NE__Value__c      = 'Nexi';
        orderItemAttrRelease.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrRelease);

        NE__Order_Item_Attribute__c orderItemAttrModalitaCollegamento = new NE__Order_Item_Attribute__c();
        orderItemAttrModalitaCollegamento.Name              = 'modalitàCollegamento';
        orderItemAttrModalitaCollegamento.NE__Value__c      = 'Nexi';
        orderItemAttrModalitaCollegamento.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrModalitaCollegamento);

        NE__Order_Item_Attribute__c orderItemAttrDescrizioneModello = new NE__Order_Item_Attribute__c();
        orderItemAttrDescrizioneModello.Name              = 'Descrizione Modello';
        orderItemAttrDescrizioneModello.NE__Value__c      = 'Nexi';
        orderItemAttrDescrizioneModello.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrDescrizioneModello);

        NE__Order_Item_Attribute__c orderItemAttrDescrizioneRelease = new NE__Order_Item_Attribute__c();
        orderItemAttrDescrizioneRelease.Name              = 'Descrizione Release';
        orderItemAttrDescrizioneRelease.NE__Value__c      = 'Nexi';
        orderItemAttrDescrizioneRelease.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrDescrizioneRelease);

        NE__Order_Item_Attribute__c orderItemAttrDescrizioneConnessione = new NE__Order_Item_Attribute__c();
        orderItemAttrDescrizioneConnessione.Name              = 'Descrizione Connessione';
        orderItemAttrDescrizioneConnessione.NE__Value__c      = 'Nexi';
        orderItemAttrDescrizioneConnessione.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrDescrizioneConnessione);

        insert orderItemAttrList;
        
        NE__Lov__c lov = new NE__Lov__c();
        lov.NE__Sub_Type__c = 'TIPOLOGICHE';
        lov.NE__Type__c = 'TRACKING';
        lov.NE__Value1__c = 'companyCode';
        lov.NE__Value2__c = 'NE__Value2__c';
        insert lov;

        OB_DeltaRun_LightService.CompanyInfo  companyInfo = new OB_DeltaRun_LightService.CompanyInfo();
        companyInfo.companyCode         = '98765';
        companyInfo.ABI                 = '98765';
        companyInfo.conventionCode      = '78765';
        companyInfo.activationDate      = Date.newInstance(2006, 3, 16);
        companyInfo.deactivationdDate   = Date.newInstance(2011, 3, 16);

        OB_DeltaRun_LightService.CompanyInfo companyData = new OB_DeltaRun_LightService.CompanyInfo();
        companyData.companyCode = 'companyData';
        companyData.ABI = '12345';
        companyData.conventionCode = 'conventionCode';
        companyData.activationDate = Date.newInstance(1960, 2, 17);
        companyData.deactivationdDate = null;

        
        OB_DeltaRun_LightService.TermInfo termInfo = new OB_DeltaRun_LightService.TermInfo();
        termInfo.modelCode = 'modelCode';
        termInfo.modelDescription = 'modelDescription';
        termInfo.releaseCode = 'releaseCode';
        termInfo.releaseDescription = 'releaseDescription';
        termInfo.connectionCode = 'connectionCode';
        termInfo.connectionDescription = 'connectionDescription';

        OB_DeltaRun_LightService.DeltaRequest request = new OB_DeltaRun_LightService.DeltaRequest();
        request.terminalId = 'terminalId';
        request.clientId = 'clientId';
        request.stabId = 'stabId';
        request.terminalData = termInfo;
        request.companyData = companyData;

        Test.StartTest();
        OB_DeltaRun_LightService.updateTerminal(request);
        Test.StopTest();
    }

    // @isTest
    // public static void updateAsset_Test()
    // {
    //     String deltaRequestString = '{"terminalId" : "terminalIdValue", "clientId" : "clientIdValue", "stabId" : "stabIdValue", "terminalData" : {"modelCode" : "modelCodeValue", "modelDescription" : "modelDescriptionValue", "releaseCode" : "releaseCodeValue", "releaseDescription" : "releaseDescriptionValue", "connectionCode" : "connectionCodeValue", "connectionDescription" : "connectionDescriptionValue"}, "companyData" : {"companyCode" : "companyCodeValue", "ABI" : "ABIValue", "conventionCode" : "conventionCodeValue", "activationDate" : "' + Date.newInstance(1960, 2, 17) + '", "deactivationdDate" : "' + Date.newInstance(1960, 2, 17) + '"}}';
    //     OB_DeltaRun_LightService.DeltaRequest deltaRequest = (OB_DeltaRun_LightService.DeltaRequest)JSON.deserialize(deltaRequestString, OB_DeltaRun_LightService.DeltaRequest.class);
    //     Asset asset = new Asset();
    //     //  List<NE__Catalog_Item__c> rootItemList = [SELECT Id,NE__Type__c,NE__ProductId__c,NE__Item_Header__c, NE__ProductId__r.Name  
    //     //                                             FROM NE__Catalog_Item__c 
    //     //                                             WHERE NE__ProductId__r.OB_Codice_sfdc__c =:companyCode
    //     //                                             AND NE__Catalog_Id__c = :terminalAsset.NE__Catalog__c
    //     //   
    //                                             // ??? AND NE__Type__c ='Product' LIMIT 1];
    //     NE__Catalog_Item__c ci = new NE__Catalog_Item__c();
    //     insert ci;
    //     Test.startTest();
    //     OB_DeltaRun_LightService.updateAsset(deltaRequest, Asset asset);
    //     Test.stopTest();
    // }

    @isTest
    public static void updateAsset_Test()
    {
        Account acc  = new Account(); 
        acc.Name = 'TEST';
        acc.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Bank'].id;
        acc.OB_Employees_Number__c = 'Minore di 10';
        acc.OB_VAT_Not_Present__c = false;
        acc.OB_DescriptionVATNotPresent__c = 'description';
        acc.NE__Fiscal_code__c = 'RSSMRA80A01F205X';
        acc.OB_BypassValidation__c = true;
        acc.OB_Status__c = 'Active'; 
        acc.NE__VAT__c = '12312312312'; 
        acc.OB_ABI__c = '12345';
        insert acc;

        NE__Bundle__c bundle = new NE__Bundle__c();
        bundle.Name = 'test';
        bundle.NE__Configuration_Type__c = 'Free';
        bundle.NE__BaseRecurringCharge__c = 12.00;
        bundle.NE__RecurringChargeFrequency__c = 'Annual';
        bundle.NE__Start_Date__c = System.now();
        bundle.NE__End_Date__c = System.now().addDays(1);
        insert bundle;

        NE__Order_Header__c oh = new NE__Order_Header__c();
        oh.OB_Business_Model_Acquiring__c = 'Bancario'; 
        oh.OB_Business_Model_POS__c = 'Trilaterale Nuovo';
        oh.OB_Main_Process__c = 'Setup';
        insert oh;

        NE__Service_Point__c sp  = new NE__Service_Point__c();
        sp.OB_MCC__c   ='2345';
        sp.NE__City__c = 'Yaounde';
        insert sp;

        NE__Order__c ord = new NE__Order__c();
        ord.NE__Order_Header__c = oh.id;
        ord.NE__AccountId__c = acc.id;
        ord.NE__BillAccId__c = acc.Id;
        ord.NE__ServAccId__c = acc.Id;
        ord.OB_MCCL2__c = '0000';
        ord.OB_GT__c = 'Nexi';
        ord.OB_Service_Point__c = sp.id; 
        ord.OB_FulfilmentStatus__c = 'Sent';        
        insert ord; 

        NE__Item_Header__c itemHeader = new NE__Item_Header__c();
        itemHeader.Name = 'REFERRAL' ;
        insert itemHeader;
        
        NE__Product__c prod = new NE__Product__c();
        prod.OB_Codice_sfdc__c = 'companyCode';
        insert prod;

        NE__Billing_Profile__c bp = new NE__Billing_Profile__c();
        bp.NE__Account__c = acc.id;
        insert bp;

        NE__Catalog__c cat = new NE__Catalog__c();
        cat.Name = 'cat';
        insert cat;

        NE__Catalog_Item__c ci    = new NE__Catalog_Item__c();
        ci.NE__ProductId__c = prod.id;
        ci.NE__Catalog_Id__c = cat.id;
        ci.NE__Item_Header__c = itemHeader.id;
        ci.NE__Type__c = 'Category'; 
        insert ci;

        NE__Catalog_Item__c ci2 = new NE__Catalog_Item__c();
        ci2.NE__ProductId__c = prod.id;
        ci2.NE__Catalog_Id__c = cat.id;
        ci2.NE__Type__c = 'Product';
        

        NE__OrderItem__c terminalItem = New NE__OrderItem__c(NE__Qty__c = 10 ,NE__OrderId__c = ord.id);
        terminalItem.NE__Action__c      = 'Add';
        terminalItem.OB_ShopCode__c     = 'stabId';
        terminalItem.OB_CustomerCode__c = 'clientId';
        terminalItem.OB_TermId__c       = 'terminalId';  
        terminalItem.OB_ProposerABI__c  = acc.id;
        TerminalItem.NE__OrderId__c = ord.id;
        insert terminalItem;

        Asset ass = new Asset();
       // ass.RootAssetId                     = rootAsset.Id;
        ass.NE__CatalogItem__c              = ci.id;
        ass.AccountId                       = acc.id;
        ass.OB_DebitProfId__c               = bp.id;
        ass.OB_ProposerABI__c               = acc.id;
        ass.IsCompetitorProduct             = false;
        ass.NE__Catalog__c = cat.id;
       // ass.IsInternal                      = false;
        ass.Name                            = 'Offerta Personalizzata';
        ass.NE__Action__c                   = 'Change';
        ass.NE__AssetItemEnterpriseId__c    = '123123123';
        ass.NE__BaseOneTimeFee__c           = 0;
        ass.NE__BaseRecurringCharge__c      = 0;
        ass.NE__Billing_Account__c          = acc.id;
        ass.NE__Commitment__c               = false;
        ass.NE__Discount_One_time__c        = 0;
        ass.NE__Discount__c                 = 0;
        ass.NE__Generate_Asset_Item__c      = true;
        ass.NE__Item_Code__c                = '';
        ass.NE__Order_Config__c             = ord.id;
        ass.NE__ProdId__c                   = prod.id;
        ass.NE__RecurringChargeFrequency__c = 'Monthly';
        ass.NE__Remove_from_total__c        = false;
        ass.NE__Service_Account__c          = acc.id;
        ass.NE__Service_Point__c            = sp.id;
        ass.NE__Status__c                   = 'Active';
        ass.OB_enablement__c                = 'N';
        ass.OB_MCCL2__c                     = '0001';
        ass.OB_MCC__c                       = '5200';
        ass.OB_Report_Type__c               = 'Punto Vendita';
        ass.OB_Ro__c                        = 'N';
        ass.OB_Visible__c                   = 'N';
        ass.Quantity                        = 1;
        ass.OB_ShopSign__c                  = '23112';
        ass.OB_ShopCode__c                  = 'stabId';
        ass.OB_CustomerCode__c              = 'clientId';
        ass.OB_TermId__c                    = 'terminalId';
        ass.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Asset' AND DeveloperName = 'Standard' LIMIT 1].id;
        insert ass;

        System.debug('Asset inserito: ' + ass.id);

        List<NE__AssetItemAttribute__c> assetItemAttrList = new List<NE__AssetItemAttribute__c>();

        NE__AssetItemAttribute__c assetItemAttrRelease = new NE__AssetItemAttribute__c();
        assetItemAttrRelease.Name  = 'release';
        assetItemAttrRelease.NE__Value__c = 'Nexi';
        assetItemAttrRelease.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrRelease);

        NE__AssetItemAttribute__c assetItemAttrModello = new NE__AssetItemAttribute__c();
        assetItemAttrModello.Name  = 'modello';
        assetItemAttrModello.NE__Value__c = 'Nexi';
        assetItemAttrModello.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrModello);

        NE__AssetItemAttribute__c assetItemAttrModalitaCollegamento = new NE__AssetItemAttribute__c();
        assetItemAttrModalitaCollegamento.Name  = 'modalitàCollegamento';
        assetItemAttrModalitaCollegamento.NE__Value__c = 'Nexi';
        assetItemAttrModalitaCollegamento.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrModalitaCollegamento);

        NE__AssetItemAttribute__c assetItemAttrDescrizioneModello = new NE__AssetItemAttribute__c();
        assetItemAttrDescrizioneModello.Name  = 'Descrizione Modello';
        assetItemAttrDescrizioneModello.NE__Value__c = 'Nexi';
        assetItemAttrDescrizioneModello.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrDescrizioneModello);

        NE__AssetItemAttribute__c assetItemAttrDescrizioneRelease = new NE__AssetItemAttribute__c();
        assetItemAttrDescrizioneRelease.Name  = 'Descrizione Release';
        assetItemAttrDescrizioneRelease.NE__Value__c = 'Nexi';
        assetItemAttrDescrizioneRelease.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrDescrizioneRelease);

        NE__AssetItemAttribute__c assetItemAttrDescrizioneConnessione = new NE__AssetItemAttribute__c();
        assetItemAttrDescrizioneConnessione.Name  = 'Descrizione Connessione';
        assetItemAttrDescrizioneConnessione.NE__Value__c = 'Nexi';
        assetItemAttrDescrizioneConnessione.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrDescrizioneConnessione);
        
        insert assetItemAttrList;

        List<NE__Order_Item_Attribute__c> orderItemAttrList = new List<NE__Order_Item_Attribute__c>();

        NE__Order_Item_Attribute__c orderItemAttrModello = new NE__Order_Item_Attribute__c();
        orderItemAttrModello.Name              = 'modello';
        orderItemAttrModello.NE__Value__c      = 'Nexi';
        orderItemAttrModello.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrModello);

        NE__Order_Item_Attribute__c orderItemAttrRelease = new NE__Order_Item_Attribute__c();
        orderItemAttrRelease.Name              = 'release';
        orderItemAttrRelease.NE__Value__c      = 'Nexi';
        orderItemAttrRelease.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrRelease);

        NE__Order_Item_Attribute__c orderItemAttrModalitaCollegamento = new NE__Order_Item_Attribute__c();
        orderItemAttrModalitaCollegamento.Name              = 'modalitàCollegamento';
        orderItemAttrModalitaCollegamento.NE__Value__c      = 'Nexi';
        orderItemAttrModalitaCollegamento.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrModalitaCollegamento);

        NE__Order_Item_Attribute__c orderItemAttrDescrizioneModello = new NE__Order_Item_Attribute__c();
        orderItemAttrDescrizioneModello.Name              = 'Descrizione Modello';
        orderItemAttrDescrizioneModello.NE__Value__c      = 'Nexi';
        orderItemAttrDescrizioneModello.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrDescrizioneModello);

        NE__Order_Item_Attribute__c orderItemAttrDescrizioneRelease = new NE__Order_Item_Attribute__c();
        orderItemAttrDescrizioneRelease.Name              = 'Descrizione Release';
        orderItemAttrDescrizioneRelease.NE__Value__c      = 'Nexi';
        orderItemAttrDescrizioneRelease.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrDescrizioneRelease);

        NE__Order_Item_Attribute__c orderItemAttrDescrizioneConnessione = new NE__Order_Item_Attribute__c();
        orderItemAttrDescrizioneConnessione.Name              = 'Descrizione Connessione';
        orderItemAttrDescrizioneConnessione.NE__Value__c      = 'Nexi';
        orderItemAttrDescrizioneConnessione.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrDescrizioneConnessione);

        insert orderItemAttrList;
        
        NE__Lov__c lov = new NE__Lov__c();
        lov.NE__Sub_Type__c = 'TIPOLOGICHE';
        lov.NE__Type__c = 'TRACKING';
        lov.NE__Value1__c = 'companyCode';
        lov.NE__Value2__c = 'NE__Value2__c';
        insert lov;

        OB_DeltaRun_LightService.CompanyInfo  companyInfo = new OB_DeltaRun_LightService.CompanyInfo();
        companyInfo.companyCode         = '98765';
        companyInfo.ABI                 = '98765';
        companyInfo.conventionCode      = '78765';
        companyInfo.activationDate      = Date.newInstance(2006, 3, 16);
        companyInfo.deactivationdDate   = Date.newInstance(2011, 3, 16);

        OB_DeltaRun_LightService.CompanyInfo companyData = new OB_DeltaRun_LightService.CompanyInfo();
        companyData.companyCode = 'companyData';
        companyData.ABI = '12345';
        companyData.conventionCode = 'conventionCode';
        companyData.activationDate = Date.newInstance(1960, 2, 17);
        companyData.deactivationdDate = null;

        
        OB_DeltaRun_LightService.TermInfo termInfo = new OB_DeltaRun_LightService.TermInfo();
        termInfo.modelCode = 'modelCode';
        termInfo.modelDescription = 'modelDescription';
        termInfo.releaseCode = 'releaseCode';
        termInfo.releaseDescription = 'releaseDescription';
        termInfo.connectionCode = 'connectionCode';
        termInfo.connectionDescription = 'connectionDescription';

        OB_DeltaRun_LightService.DeltaRequest request = new OB_DeltaRun_LightService.DeltaRequest();
        request.terminalId = 'terminalId';
        request.clientId = 'clientId';
        request.stabId = 'stabId';
        request.terminalData = termInfo;
        request.companyData = companyData;


        Test.startTest();
        OB_DeltaRun_LightService.updateAsset(request, ass);
        Test.stopTest();
    }

    @isTest
    public static void updateAsset_Test2()
    {
        Account acc  = new Account(); 
        acc.Name = 'TEST';
        acc.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Bank'].id;
        acc.OB_Employees_Number__c = 'Minore di 10';
        acc.OB_VAT_Not_Present__c = false;
        acc.OB_DescriptionVATNotPresent__c = 'description';
        acc.NE__Fiscal_code__c = 'RSSMRA80A01F205X';
        acc.OB_BypassValidation__c = true;
        acc.OB_Status__c = 'Active'; 
        acc.NE__VAT__c = '12312312312'; 
        acc.OB_ABI__c = '12345';
        insert acc;

        NE__Bundle__c bundle = new NE__Bundle__c();
        bundle.Name = 'test';
        bundle.NE__Configuration_Type__c = 'Free';
        bundle.NE__BaseRecurringCharge__c = 12.00;
        bundle.NE__RecurringChargeFrequency__c = 'Annual';
        bundle.NE__Start_Date__c = System.now();
        bundle.NE__End_Date__c = System.now().addDays(1);
        insert bundle;

        NE__Order_Header__c oh = new NE__Order_Header__c();
        oh.OB_Business_Model_Acquiring__c = 'Bancario'; 
        oh.OB_Business_Model_POS__c = 'Trilaterale Nuovo';
        oh.OB_Main_Process__c = 'Setup';
        insert oh;

        NE__Service_Point__c sp  = new NE__Service_Point__c();
        sp.OB_MCC__c   ='2345';
        sp.NE__City__c = 'Yaounde';
        insert sp;

        NE__Order__c ord = new NE__Order__c();
        ord.NE__Order_Header__c = oh.id;
        ord.NE__AccountId__c = acc.id;
        ord.NE__BillAccId__c = acc.Id;
        ord.NE__ServAccId__c = acc.Id;
        ord.OB_MCCL2__c = '0000';
        ord.OB_GT__c = 'Nexi';
        ord.OB_Service_Point__c = sp.id; 
        ord.OB_FulfilmentStatus__c = 'Sent';        
        insert ord; 

        NE__Item_Header__c itemHeader = new NE__Item_Header__c();
        itemHeader.Name = 'REFERRAL' ;
        insert itemHeader;
        
        NE__Product__c prod = new NE__Product__c();
        prod.OB_Codice_sfdc__c = '98765';
        insert prod;

        NE__Billing_Profile__c bp = new NE__Billing_Profile__c();
        bp.NE__Account__c = acc.id;
        insert bp;

        NE__Catalog__c cat = new NE__Catalog__c();
        cat.Name = 'cat';
        insert cat;

        NE__Catalog_Item__c ci    = new NE__Catalog_Item__c();
        ci.NE__ProductId__c = prod.id;
        ci.NE__Catalog_Id__c = cat.id;
        ci.NE__Item_Header__c = itemHeader.id;
        ci.NE__Type__c = 'Category'; 
        insert ci;

        NE__Catalog_Item__c ci2 = new NE__Catalog_Item__c();
        ci2.NE__ProductId__c = prod.id;
        ci2.NE__Catalog_Id__c = cat.id;
        ci2.NE__Type__c = 'Product';
        

        NE__OrderItem__c terminalItem = New NE__OrderItem__c(NE__Qty__c = 10 ,NE__OrderId__c = ord.id);
        terminalItem.NE__Action__c      = 'Add';
        terminalItem.OB_ShopCode__c     = 'stabId';
        terminalItem.OB_CustomerCode__c = 'clientId';
        terminalItem.OB_TermId__c       = 'terminalId';  
        terminalItem.OB_ProposerABI__c  = acc.id;
        TerminalItem.NE__OrderId__c = ord.id;
        insert terminalItem;

        Asset ass = new Asset();
       // ass.RootAssetId                     = rootAsset.Id;
        ass.NE__CatalogItem__c              = ci.id;
        ass.AccountId                       = acc.id;
        ass.OB_DebitProfId__c               = bp.id;
        ass.OB_ProposerABI__c               = acc.id;
        ass.IsCompetitorProduct             = false;
        ass.NE__Catalog__c = cat.id;
       // ass.IsInternal                      = false;
        ass.Name                            = 'Offerta Personalizzata';
        ass.NE__Action__c                   = 'Change';
        ass.NE__AssetItemEnterpriseId__c    = '123123123';
        ass.NE__BaseOneTimeFee__c           = 0;
        ass.NE__BaseRecurringCharge__c      = 0;
        ass.NE__Billing_Account__c          = acc.id;
        ass.NE__Commitment__c               = false;
        ass.NE__Discount_One_time__c        = 0;
        ass.NE__Discount__c                 = 0;
        ass.NE__Generate_Asset_Item__c      = true;
        ass.NE__Item_Code__c                = '';
        ass.NE__Order_Config__c             = ord.id;
        ass.NE__ProdId__c                   = prod.id;
        ass.NE__RecurringChargeFrequency__c = 'Monthly';
        ass.NE__Remove_from_total__c        = false;
        ass.NE__Service_Account__c          = acc.id;
        ass.NE__Service_Point__c            = sp.id;
        ass.NE__Status__c                   = 'Active';
        ass.OB_enablement__c                = 'N';
        ass.OB_MCCL2__c                     = '0001';
        ass.OB_MCC__c                       = '5200';
        ass.OB_Report_Type__c               = 'Punto Vendita';
        ass.OB_Ro__c                        = 'N';
        ass.OB_Visible__c                   = 'N';
        ass.Quantity                        = 1;
        ass.OB_ShopSign__c                  = '23112';
        ass.OB_ShopCode__c                  = 'stabId';
        ass.OB_CustomerCode__c              = 'clientId';
        ass.OB_TermId__c                    = 'terminalId';
        ass.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Asset' AND DeveloperName = 'Standard' LIMIT 1].id;
        insert ass;

        System.debug('Asset inserito: ' + ass.id);

        List<NE__AssetItemAttribute__c> assetItemAttrList = new List<NE__AssetItemAttribute__c>();

        NE__AssetItemAttribute__c assetItemAttrRelease = new NE__AssetItemAttribute__c();
        assetItemAttrRelease.Name  = 'release';
        assetItemAttrRelease.NE__Value__c = 'Nexi';
        assetItemAttrRelease.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrRelease);

        NE__AssetItemAttribute__c assetItemAttrModello = new NE__AssetItemAttribute__c();
        assetItemAttrModello.Name  = 'modello';
        assetItemAttrModello.NE__Value__c = 'Nexi';
        assetItemAttrModello.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrModello);

        NE__AssetItemAttribute__c assetItemAttrModalitaCollegamento = new NE__AssetItemAttribute__c();
        assetItemAttrModalitaCollegamento.Name  = 'modalitàCollegamento';
        assetItemAttrModalitaCollegamento.NE__Value__c = 'Nexi';
        assetItemAttrModalitaCollegamento.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrModalitaCollegamento);

        NE__AssetItemAttribute__c assetItemAttrDescrizioneModello = new NE__AssetItemAttribute__c();
        assetItemAttrDescrizioneModello.Name  = 'Descrizione Modello';
        assetItemAttrDescrizioneModello.NE__Value__c = 'Nexi';
        assetItemAttrDescrizioneModello.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrDescrizioneModello);

        NE__AssetItemAttribute__c assetItemAttrDescrizioneRelease = new NE__AssetItemAttribute__c();
        assetItemAttrDescrizioneRelease.Name  = 'Descrizione Release';
        assetItemAttrDescrizioneRelease.NE__Value__c = 'Nexi';
        assetItemAttrDescrizioneRelease.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrDescrizioneRelease);

        NE__AssetItemAttribute__c assetItemAttrDescrizioneConnessione = new NE__AssetItemAttribute__c();
        assetItemAttrDescrizioneConnessione.Name  = 'Descrizione Connessione';
        assetItemAttrDescrizioneConnessione.NE__Value__c = 'Nexi';
        assetItemAttrDescrizioneConnessione.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrDescrizioneConnessione);
        
        insert assetItemAttrList;

        List<NE__Order_Item_Attribute__c> orderItemAttrList = new List<NE__Order_Item_Attribute__c>();

        NE__Order_Item_Attribute__c orderItemAttrModello = new NE__Order_Item_Attribute__c();
        orderItemAttrModello.Name              = 'modello';
        orderItemAttrModello.NE__Value__c      = 'Nexi';
        orderItemAttrModello.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrModello);

        NE__Order_Item_Attribute__c orderItemAttrRelease = new NE__Order_Item_Attribute__c();
        orderItemAttrRelease.Name              = 'release';
        orderItemAttrRelease.NE__Value__c      = 'Nexi';
        orderItemAttrRelease.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrRelease);

        NE__Order_Item_Attribute__c orderItemAttrModalitaCollegamento = new NE__Order_Item_Attribute__c();
        orderItemAttrModalitaCollegamento.Name              = 'modalitàCollegamento';
        orderItemAttrModalitaCollegamento.NE__Value__c      = 'Nexi';
        orderItemAttrModalitaCollegamento.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrModalitaCollegamento);

        NE__Order_Item_Attribute__c orderItemAttrDescrizioneModello = new NE__Order_Item_Attribute__c();
        orderItemAttrDescrizioneModello.Name              = 'Descrizione Modello';
        orderItemAttrDescrizioneModello.NE__Value__c      = 'Nexi';
        orderItemAttrDescrizioneModello.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrDescrizioneModello);

        NE__Order_Item_Attribute__c orderItemAttrDescrizioneRelease = new NE__Order_Item_Attribute__c();
        orderItemAttrDescrizioneRelease.Name              = 'Descrizione Release';
        orderItemAttrDescrizioneRelease.NE__Value__c      = 'Nexi';
        orderItemAttrDescrizioneRelease.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrDescrizioneRelease);

        NE__Order_Item_Attribute__c orderItemAttrDescrizioneConnessione = new NE__Order_Item_Attribute__c();
        orderItemAttrDescrizioneConnessione.Name              = 'Descrizione Connessione';
        orderItemAttrDescrizioneConnessione.NE__Value__c      = 'Nexi';
        orderItemAttrDescrizioneConnessione.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrDescrizioneConnessione);

        insert orderItemAttrList;
        
        NE__Lov__c lov = new NE__Lov__c();
        lov.NE__Sub_Type__c = 'TIPOLOGICHE';
        lov.NE__Type__c = 'TRACKING';
        lov.NE__Value1__c = 'abc';
        lov.NE__Value2__c = 'abc';
        insert lov;

        OB_DeltaRun_LightService.CompanyInfo  companyInfo = new OB_DeltaRun_LightService.CompanyInfo();
        companyInfo.companyCode         = '98765';
        companyInfo.ABI                 = '98765';
        companyInfo.conventionCode      = '78765';
        companyInfo.activationDate      = Date.newInstance(2006, 3, 16);
        companyInfo.deactivationdDate   = Date.newInstance(2011, 3, 16);

        OB_DeltaRun_LightService.CompanyInfo companyData = new OB_DeltaRun_LightService.CompanyInfo();
        companyData.companyCode = 'companyData';
        companyData.ABI = '12345';
        companyData.conventionCode = 'conventionCode';
        companyData.activationDate = Date.newInstance(1960, 2, 17);
        companyData.deactivationdDate = null;

        
        OB_DeltaRun_LightService.TermInfo termInfo = new OB_DeltaRun_LightService.TermInfo();
        termInfo.modelCode = 'modelCode';
        termInfo.modelDescription = 'modelDescription';
        termInfo.releaseCode = 'releaseCode';
        termInfo.releaseDescription = 'releaseDescription';
        termInfo.connectionCode = 'connectionCode';
        termInfo.connectionDescription = 'connectionDescription';

        OB_DeltaRun_LightService.DeltaRequest request = new OB_DeltaRun_LightService.DeltaRequest();
        request.terminalId = 'terminalId';
        request.clientId = 'clientId';
        request.stabId = 'stabId';
        request.terminalData = termInfo;
        request.companyData = companyData;


        Test.startTest();
        OB_DeltaRun_LightService.updateAsset(request, ass);
        Test.stopTest();
    }

    @isTest
    public static void updateOrder_Test()
    {
        Account acc  = new Account(); 
        acc.Name = 'TEST';
        acc.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Bank'].id;
        acc.OB_Employees_Number__c = 'Minore di 10';
        acc.OB_VAT_Not_Present__c = false;
        acc.OB_DescriptionVATNotPresent__c = 'description';
        acc.NE__Fiscal_code__c = 'RSSMRA80A01F205X';
        acc.OB_BypassValidation__c = true;
        acc.OB_Status__c = 'Active'; 
        acc.NE__VAT__c = '12312312312'; 
        acc.OB_ABI__c = '12345';
        insert acc;

        NE__Bundle__c bundle = new NE__Bundle__c();
        bundle.Name = 'test';
        bundle.NE__Configuration_Type__c = 'Free';
        bundle.NE__BaseRecurringCharge__c = 12.00;
        bundle.NE__RecurringChargeFrequency__c = 'Annual';
        bundle.NE__Start_Date__c = System.now();
        bundle.NE__End_Date__c = System.now().addDays(1);
        insert bundle;

        NE__Order_Header__c oh = new NE__Order_Header__c();
        oh.OB_Business_Model_Acquiring__c = 'Bancario'; 
        oh.OB_Business_Model_POS__c = 'Trilaterale Nuovo';
        oh.OB_Main_Process__c = 'Setup';
        insert oh;

        NE__Service_Point__c sp  = new NE__Service_Point__c();
        sp.OB_MCC__c   ='2345';
        sp.NE__City__c = 'Yaounde';
        insert sp;

        NE__Order__c ord = new NE__Order__c();
        ord.NE__Order_Header__c = oh.id;
        ord.NE__AccountId__c = acc.id;
        ord.NE__BillAccId__c = acc.Id;
        ord.NE__ServAccId__c = acc.Id;
        ord.OB_MCCL2__c = '0000';
        ord.OB_GT__c = 'Nexi';
        ord.OB_Service_Point__c = sp.id; 
        ord.OB_FulfilmentStatus__c = 'Sent';        
        insert ord; 

        NE__Item_Header__c itemHeader = new NE__Item_Header__c();
        itemHeader.Name = 'REFERRAL' ;
        insert itemHeader;
        
        NE__Product__c prod = new NE__Product__c();
        prod.OB_Codice_sfdc__c = '98765';
        insert prod;

        NE__Billing_Profile__c bp = new NE__Billing_Profile__c();
        bp.NE__Account__c = acc.id;
        insert bp;

        NE__Catalog__c cat = new NE__Catalog__c();
        cat.Name = 'cat';
        insert cat;

        NE__Catalog_Item__c ci    = new NE__Catalog_Item__c();
        ci.NE__ProductId__c = prod.id;
        ci.NE__Catalog_Id__c = cat.id;
        ci.NE__Item_Header__c = itemHeader.id;
        ci.NE__Type__c = 'Category'; 
        insert ci;

        NE__Catalog_Item__c ci2 = new NE__Catalog_Item__c();
        ci2.NE__ProductId__c = prod.id;
        ci2.NE__Catalog_Id__c = cat.id;
        ci2.NE__Type__c = 'Product';

        NE__OrderItem__c terminalItem = New NE__OrderItem__c(NE__Qty__c = 10);
        terminalItem.NE__Account__c = acc.id;
        terminalItem.NE__Service_Account__c = acc.id;
        terminalItem.NE__Billing_Account__c = acc.id;
        terminalItem.NE__Action__c      = 'Add';
        terminalItem.OB_ShopCode__c     = 'stabId';
        terminalItem.OB_CustomerCode__c = 'clientId';
        terminalItem.OB_TermId__c       = 'terminalId';  
        terminalItem.OB_ProposerABI__c  = acc.id;
        terminalItem.NE__OrderId__c = ord.id;
        terminalItem.NE__ProdId__c = prod.id;
        terminalItem.NE__CatalogItem__c = ci.id;
        terminalItem.NE__Catalog__c = cat.id;
        insert terminalItem;
        
        System.debug('terminalItem.id dopo la creazione: ' + terminalItem.id);


        

        Asset rootAsset = new Asset();
        rootAsset.NE__CatalogItem__c              = ci.id;
        rootAsset.AccountId                       = acc.id;
        rootAsset.OB_DebitProfId__c               = bp.id;
        rootAsset.OB_ProposerABI__c               = acc.id;
        rootAsset.IsCompetitorProduct             = false;
        rootAsset.NE__Catalog__c = cat.id;
       // ass.IsInternal                      = false;
        rootAsset.Name                            = 'Offerta Personalizzata';
        rootAsset.NE__Action__c                   = 'Change';
        rootAsset.NE__AssetItemEnterpriseId__c    = '123123123';
        rootAsset.NE__BaseOneTimeFee__c           = 0;
        rootAsset.NE__BaseRecurringCharge__c      = 0;
        rootAsset.NE__Billing_Account__c          = acc.id;
        rootAsset.NE__Commitment__c               = false;
        rootAsset.NE__Discount_One_time__c        = 0;
        rootAsset.NE__Discount__c                 = 0;
        rootAsset.NE__Generate_Asset_Item__c      = true;
        rootAsset.NE__Item_Code__c                = '';
        rootAsset.NE__Order_Config__c             = ord.id;
        rootAsset.NE__ProdId__c                   = prod.id;
        rootAsset.NE__RecurringChargeFrequency__c = 'Monthly';
        rootAsset.NE__Remove_from_total__c        = false;
        rootAsset.NE__Service_Account__c          = acc.id;
        rootAsset.NE__Service_Point__c            = sp.id;
        rootAsset.NE__Status__c                   = 'Active';
        rootAsset.OB_enablement__c                = 'N';
        rootAsset.OB_MCCL2__c                     = '0001';
        rootAsset.OB_MCC__c                       = '5200';
        rootAsset.OB_Report_Type__c               = 'Punto Vendita';
        rootAsset.OB_Ro__c                        = 'N';
        rootAsset.OB_Visible__c                   = 'N';
        rootAsset.Quantity                        = 1;
        rootAsset.OB_ShopSign__c                  = '23112';
        rootAsset.OB_ShopCode__c                  = 'stabId';
        rootAsset.OB_CustomerCode__c              = 'clientId';
        rootAsset.OB_TermId__c                    = 'terminalId';
        rootAsset.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Asset' AND DeveloperName = 'Standard' LIMIT 1].id;
        insert rootAsset;

        Asset ass = new Asset();
        //ass.RootAssetId                     = rootAsset.Id;
        ass.ParentId =                      rootAsset.id;
        ass.NE__CatalogItem__c              = ci.id;
        ass.AccountId                       = acc.id;
        ass.OB_DebitProfId__c               = bp.id;
        ass.OB_ProposerABI__c               = acc.id;
        ass.IsCompetitorProduct             = false;
        ass.NE__Catalog__c = cat.id;
       // ass.IsInternal                      = false;
        ass.Name                            = 'Offerta Personalizzata';
        ass.NE__Action__c                   = 'Change';
        ass.NE__AssetItemEnterpriseId__c    = '123123123';
        ass.NE__BaseOneTimeFee__c           = 0;
        ass.NE__BaseRecurringCharge__c      = 0;
        ass.NE__Billing_Account__c          = acc.id;
        ass.NE__Commitment__c               = false;
        ass.NE__Discount_One_time__c        = 0;
        ass.NE__Discount__c                 = 0;
        ass.NE__Generate_Asset_Item__c      = true;
        ass.NE__Item_Code__c                = '';
        ass.NE__Order_Config__c             = ord.id;
        ass.NE__ProdId__c                   = prod.id;
        ass.NE__RecurringChargeFrequency__c = 'Monthly';
        ass.NE__Remove_from_total__c        = false;
        ass.NE__Service_Account__c          = acc.id;
        ass.NE__Service_Point__c            = sp.id;
        ass.NE__Status__c                   = 'Active';
        ass.OB_enablement__c                = 'N';
        ass.OB_MCCL2__c                     = '0001';
        ass.OB_MCC__c                       = '5200';
        ass.OB_Report_Type__c               = 'Punto Vendita';
        ass.OB_Ro__c                        = 'N';
        ass.OB_Visible__c                   = 'N';
        ass.Quantity                        = 1;
        ass.OB_ShopSign__c                  = '23112';
        ass.OB_ShopCode__c                  = 'stabId';
        ass.OB_CustomerCode__c              = 'clientId';
        ass.OB_TermId__c                    = 'terminalId';
        ass.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Asset' AND DeveloperName = 'Standard' LIMIT 1].id;
        insert ass;

        System.debug('Asset inserito: ' + ass.id);

        List<NE__AssetItemAttribute__c> assetItemAttrList = new List<NE__AssetItemAttribute__c>();

        NE__AssetItemAttribute__c assetItemAttrRelease = new NE__AssetItemAttribute__c();
        assetItemAttrRelease.Name  = 'release';
        assetItemAttrRelease.NE__Value__c = 'Nexi';
        assetItemAttrRelease.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrRelease);

        NE__AssetItemAttribute__c assetItemAttrModello = new NE__AssetItemAttribute__c();
        assetItemAttrModello.Name  = 'modello';
        assetItemAttrModello.NE__Value__c = 'Nexi';
        assetItemAttrModello.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrModello);

        NE__AssetItemAttribute__c assetItemAttrModalitaCollegamento = new NE__AssetItemAttribute__c();
        assetItemAttrModalitaCollegamento.Name  = 'modalitàCollegamento';
        assetItemAttrModalitaCollegamento.NE__Value__c = 'Nexi';
        assetItemAttrModalitaCollegamento.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrModalitaCollegamento);

        NE__AssetItemAttribute__c assetItemAttrDescrizioneModello = new NE__AssetItemAttribute__c();
        assetItemAttrDescrizioneModello.Name  = 'Descrizione Modello';
        assetItemAttrDescrizioneModello.NE__Value__c = 'Nexi';
        assetItemAttrDescrizioneModello.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrDescrizioneModello);

        NE__AssetItemAttribute__c assetItemAttrDescrizioneRelease = new NE__AssetItemAttribute__c();
        assetItemAttrDescrizioneRelease.Name  = 'Descrizione Release';
        assetItemAttrDescrizioneRelease.NE__Value__c = 'Nexi';
        assetItemAttrDescrizioneRelease.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrDescrizioneRelease);

        NE__AssetItemAttribute__c assetItemAttrDescrizioneConnessione = new NE__AssetItemAttribute__c();
        assetItemAttrDescrizioneConnessione.Name  = 'Descrizione Connessione';
        assetItemAttrDescrizioneConnessione.NE__Value__c = 'Nexi';
        assetItemAttrDescrizioneConnessione.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrDescrizioneConnessione);
        
        insert assetItemAttrList;

        List<NE__Order_Item_Attribute__c> orderItemAttrList = new List<NE__Order_Item_Attribute__c>();

        NE__Order_Item_Attribute__c orderItemAttrModello = new NE__Order_Item_Attribute__c();
        orderItemAttrModello.Name              = 'modello';
        orderItemAttrModello.NE__Value__c      = 'Nexi';
        orderItemAttrModello.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrModello);

        NE__Order_Item_Attribute__c orderItemAttrRelease = new NE__Order_Item_Attribute__c();
        orderItemAttrRelease.Name              = 'release';
        orderItemAttrRelease.NE__Value__c      = 'Nexi';
        orderItemAttrRelease.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrRelease);

        NE__Order_Item_Attribute__c orderItemAttrModalitaCollegamento = new NE__Order_Item_Attribute__c();
        orderItemAttrModalitaCollegamento.Name              = 'modalitàCollegamento';
        orderItemAttrModalitaCollegamento.NE__Value__c      = 'Nexi';
        orderItemAttrModalitaCollegamento.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrModalitaCollegamento);

        NE__Order_Item_Attribute__c orderItemAttrDescrizioneModello = new NE__Order_Item_Attribute__c();
        orderItemAttrDescrizioneModello.Name              = 'Descrizione Modello';
        orderItemAttrDescrizioneModello.NE__Value__c      = 'Nexi';
        orderItemAttrDescrizioneModello.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrDescrizioneModello);

        NE__Order_Item_Attribute__c orderItemAttrDescrizioneRelease = new NE__Order_Item_Attribute__c();
        orderItemAttrDescrizioneRelease.Name              = 'Descrizione Release';
        orderItemAttrDescrizioneRelease.NE__Value__c      = 'Nexi';
        orderItemAttrDescrizioneRelease.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrDescrizioneRelease);

        NE__Order_Item_Attribute__c orderItemAttrDescrizioneConnessione = new NE__Order_Item_Attribute__c();
        orderItemAttrDescrizioneConnessione.Name              = 'Descrizione Connessione';
        orderItemAttrDescrizioneConnessione.NE__Value__c      = 'Nexi';
        orderItemAttrDescrizioneConnessione.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrDescrizioneConnessione);

        insert orderItemAttrList;
        
        NE__Lov__c lov = new NE__Lov__c();
        lov.NE__Sub_Type__c= 'TIPOLOGICHE';
        lov.NE__Type__c='TRACKING';
        lov.NE__Value1__c = '98765';
        lov.NE__Value2__c = '98765';
        lov.Name = 'test';
        insert lov;

        OB_DeltaRun_LightService.CompanyInfo  companyInfo = new OB_DeltaRun_LightService.CompanyInfo();
        companyInfo.companyCode         = '98765';
        companyInfo.ABI                 = '98765';
        companyInfo.conventionCode      = '78765';
        companyInfo.activationDate      = Date.newInstance(2006, 3, 16);
        companyInfo.deactivationdDate   = Date.newInstance(2011, 3, 16);

        OB_DeltaRun_LightService.CompanyInfo companyData = new OB_DeltaRun_LightService.CompanyInfo();
        companyData.companyCode = '98765';
        companyData.ABI = '98765';
        companyData.conventionCode = '78765';
        companyData.activationDate = Date.newInstance(1960, 2, 17);
        companyData.deactivationdDate = Date.newInstance(2021, 3, 16);

        OB_DeltaRun_LightService.TermInfo termInfo = new OB_DeltaRun_LightService.TermInfo();
        termInfo.modelCode = 'modelCode';
        termInfo.modelDescription = 'modelDescription';
        termInfo.releaseCode = 'releaseCode';
        termInfo.releaseDescription = 'releaseDescription';
        termInfo.connectionCode = 'connectionCode';
        termInfo.connectionDescription = 'connectionDescription';

        OB_DeltaRun_LightService.DeltaRequest request = new OB_DeltaRun_LightService.DeltaRequest();
        request.terminalId = 'terminalId';
        request.clientId = 'clientId';
        request.stabId = 'stabId';
        request.terminalData = termInfo;
        request.companyData = companyData;
        
        terminalItem = [SELECT Id, NE__Qty__c, NE__OrderId__c, NE__Action__c, OB_ShopCode__c, OB_CustomerCode__c, OB_TermId__c, OB_ProposerABI__c, NE__Account__c, NE__Status__c, OB_FulfilmentStatus__c, OB_MCCL2__c, OB_MCC__c,
                        NE__ProdId__c, NE__Bundle__c, NE__Catalog__c, NE__CatalogItem__r.NE__Item_Header__c, NE__CatalogItem__r.NE__Type__c, NE__Service_Account__c, NE__Billing_Account__c, (SELECT Name, NE__Value__c FROM NE__Order_Item_Attributes__r) FROM NE__OrderItem__c LIMIT 1];
        
        update terminalItem;
        
        
        System.debug('terminalItem.id prima di teststarttest: ' + terminalItem.id);

        Test.startTest();
                        System.debug('Request prima: ' + JSON.serialize(request));
                OB_DeltaRun_LightService.updateOrder(request, terminalItem, ass.id, rootAsset.id);

                request.companyData.activationDate = null;

        OB_DeltaRun_LightService.updateOrder(request, terminalItem, ass.id, rootAsset.id);
        NE__OrderItem__c parentItem = New NE__OrderItem__c(NE__Qty__c = 10);
        parentItem.NE__Action__c      = 'Add';
        parentItem.OB_ShopCode__c     = 'stabId';
        parentItem.OB_CustomerCode__c = 'clientId';
        parentItem.OB_TermId__c       = 'terminalId';  
        parentItem.OB_ProposerABI__c  = acc.id;
        parentItem.NE__OrderId__c = ord.id;
        parentItem.NE__ProdId__c = prod.id;
        parentItem.NE__CatalogItem__c = ci.id;
        parentItem.NE__Parent_Order_Item__c = terminalItem.id;
        insert parentItem;

                request.companyData.activationDate = null;
                System.debug('Request dopo: ' + JSON.serialize(request));

        OB_DeltaRun_LightService.updateOrder(request, terminalItem, ass.id, rootAsset.id);
        Test.stopTest();
    }

    @isTest
    public static void updateOrder_Test2()
    {
        Account acc  = new Account(); 
        acc.Name = 'TEST';
        acc.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Bank'].id;
        acc.OB_Employees_Number__c = 'Minore di 10';
        acc.OB_VAT_Not_Present__c = false;
        acc.OB_DescriptionVATNotPresent__c = 'description';
        acc.NE__Fiscal_code__c = 'RSSMRA80A01F205X';
        acc.OB_BypassValidation__c = true;
        acc.OB_Status__c = 'Active'; 
        acc.NE__VAT__c = '12312312312'; 
        acc.OB_ABI__c = '12345';
        insert acc;

        NE__Bundle__c bundle = new NE__Bundle__c();
        bundle.Name = 'test';
        bundle.NE__Configuration_Type__c = 'Free';
        bundle.NE__BaseRecurringCharge__c = 12.00;
        bundle.NE__RecurringChargeFrequency__c = 'Annual';
        bundle.NE__Start_Date__c = System.now();
        bundle.NE__End_Date__c = System.now().addDays(1);
        insert bundle;

        NE__Order_Header__c oh = new NE__Order_Header__c();
        oh.OB_Business_Model_Acquiring__c = 'Bancario'; 
        oh.OB_Business_Model_POS__c = 'Trilaterale Nuovo';
        oh.OB_Main_Process__c = 'Setup';
        insert oh;

        NE__Service_Point__c sp  = new NE__Service_Point__c();
        sp.OB_MCC__c   ='2345';
        sp.NE__City__c = 'Yaounde';
        insert sp;

        NE__Order__c ord = new NE__Order__c();
        ord.NE__Order_Header__c = oh.id;
        ord.NE__AccountId__c = acc.id;
        ord.NE__BillAccId__c = acc.Id;
        ord.NE__ServAccId__c = acc.Id;
        ord.OB_MCCL2__c = '0000';
        ord.OB_GT__c = 'Nexi';
        ord.OB_Service_Point__c = sp.id; 
        ord.OB_FulfilmentStatus__c = 'Sent';        
        insert ord; 

        NE__Item_Header__c itemHeader = new NE__Item_Header__c();
        itemHeader.Name = 'REFERRAL' ;
        insert itemHeader;
        
        NE__Product__c prod = new NE__Product__c();
        prod.OB_Codice_sfdc__c = 'test';
        insert prod;

        NE__Product__c prod2 = new NE__Product__c();
        prod.OB_Codice_sfdc__c = '98765';
        insert prod2;

        NE__Billing_Profile__c bp = new NE__Billing_Profile__c();
        bp.NE__Account__c = acc.id;
        insert bp;

        NE__Catalog__c cat = new NE__Catalog__c();
        cat.Name = 'cat';
        insert cat;

        NE__Catalog_Item__c ci    = new NE__Catalog_Item__c();
        ci.NE__ProductId__c = prod.id;
        ci.NE__Catalog_Id__c = cat.id;
        ci.NE__Item_Header__c = itemHeader.id;
        ci.NE__Type__c = 'Product'; 
        insert ci;

        NE__Catalog_Item__c ci2 = new NE__Catalog_Item__c();
        ci2.NE__ProductId__c = prod.id;
        ci2.NE__Catalog_Id__c = cat.id;
        ci2.NE__Type__c = 'Product';

        NE__Catalog_Item__c childItemList = new NE__Catalog_Item__c();
        childItemList.NE__Type__c = 'Product';
        childItemList.NE__ProductId__c = prod2.id;
        childItemList.NE__Item_Header__c = itemHeader.id;
        childItemList.NE__Catalog_Id__c = cat.id;
        insert childItemList;

        NE__Catalog_Item__c childItemList2 = new NE__Catalog_Item__c();
        childItemList2.NE__Type__c = 'Product';
        childItemList2.NE__ProductId__c = prod2.id;
        childItemList2.NE__Item_Header__c = itemHeader.id;
        childItemList2.NE__Catalog_Id__c = cat.id;
        insert childItemList2;

        NE__OrderItem__c terminalItem = New NE__OrderItem__c(NE__Qty__c = 10 ,NE__OrderId__c = ord.id);
        terminalItem.NE__Action__c      = 'Add';
        terminalItem.OB_ShopCode__c     = 'stabId';
        terminalItem.OB_CustomerCode__c = 'clientId';
        terminalItem.OB_TermId__c       = 'terminalId';  
        terminalItem.OB_ProposerABI__c  = acc.id;
        terminalItem.NE__OrderId__c = ord.id;
        terminalItem.NE__ProdId__c = prod.id;
        terminalItem.NE__Catalog__c = cat.id;
        insert terminalItem;

        NE__OrderItem__c parentItem = New NE__OrderItem__c(NE__Qty__c = 10 ,NE__OrderId__c = ord.id);
        parentItem.NE__Action__c      = 'Add';
        parentItem.OB_ShopCode__c     = 'stabId';
        parentItem.OB_CustomerCode__c = 'clientId';
        parentItem.OB_TermId__c       = 'terminalId';  
        parentItem.OB_ProposerABI__c  = acc.id;
        parentItem.NE__OrderId__c = ord.id;
        parentItem.NE__ProdId__c = prod.id;
        parentItem.NE__CatalogItem__c = ci.id;
        parentItem.NE__Parent_Order_Item__c = terminalItem.id;
        insert parentItem;

        Asset rootAsset = new Asset();
        rootAsset.NE__CatalogItem__c              = ci.id;
        rootAsset.AccountId                       = acc.id;
        rootAsset.OB_DebitProfId__c               = bp.id;
        rootAsset.OB_ProposerABI__c               = acc.id;
        rootAsset.IsCompetitorProduct             = false;
        rootAsset.NE__Catalog__c = cat.id;
       // ass.IsInternal                      = false;
        rootAsset.Name                            = 'Offerta Personalizzata';
        rootAsset.NE__Action__c                   = 'Change';
        rootAsset.NE__AssetItemEnterpriseId__c    = '123123123';
        rootAsset.NE__BaseOneTimeFee__c           = 0;
        rootAsset.NE__BaseRecurringCharge__c      = 0;
        rootAsset.NE__Billing_Account__c          = acc.id;
        rootAsset.NE__Commitment__c               = false;
        rootAsset.NE__Discount_One_time__c        = 0;
        rootAsset.NE__Discount__c                 = 0;
        rootAsset.NE__Generate_Asset_Item__c      = true;
        rootAsset.NE__Item_Code__c                = '';
        rootAsset.NE__Order_Config__c             = ord.id;
        rootAsset.NE__ProdId__c                   = prod.id;
        rootAsset.NE__RecurringChargeFrequency__c = 'Monthly';
        rootAsset.NE__Remove_from_total__c        = false;
        rootAsset.NE__Service_Account__c          = acc.id;
        rootAsset.NE__Service_Point__c            = sp.id;
        rootAsset.NE__Status__c                   = 'Active';
        rootAsset.OB_enablement__c                = 'N';
        rootAsset.OB_MCCL2__c                     = '0001';
        rootAsset.OB_MCC__c                       = '5200';
        rootAsset.OB_Report_Type__c               = 'Punto Vendita';
        rootAsset.OB_Ro__c                        = 'N';
        rootAsset.OB_Visible__c                   = 'N';
        rootAsset.Quantity                        = 1;
        rootAsset.OB_ShopSign__c                  = '23112';
        rootAsset.OB_ShopCode__c                  = 'stabId';
        rootAsset.OB_CustomerCode__c              = 'clientId';
        rootAsset.OB_TermId__c                    = 'terminalId';
        rootAsset.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Asset' AND DeveloperName = 'Standard' LIMIT 1].id;
        insert rootAsset;

        Asset ass = new Asset();
        //ass.RootAssetId                     = rootAsset.Id;
        ass.ParentId =                      rootAsset.id;
        ass.NE__CatalogItem__c              = ci.id;
        ass.AccountId                       = acc.id;
        ass.OB_DebitProfId__c               = bp.id;
        ass.OB_ProposerABI__c               = acc.id;
        ass.IsCompetitorProduct             = false;
        ass.NE__Catalog__c = cat.id;
       // ass.IsInternal                      = false;
        ass.Name                            = 'Offerta Personalizzata';
        ass.NE__Action__c                   = 'Change';
        ass.NE__AssetItemEnterpriseId__c    = '123123123';
        ass.NE__BaseOneTimeFee__c           = 0;
        ass.NE__BaseRecurringCharge__c      = 0;
        ass.NE__Billing_Account__c          = acc.id;
        ass.NE__Commitment__c               = false;
        ass.NE__Discount_One_time__c        = 0;
        ass.NE__Discount__c                 = 0;
        ass.NE__Generate_Asset_Item__c      = true;
        ass.NE__Item_Code__c                = '';
        ass.NE__Order_Config__c             = ord.id;
        ass.NE__ProdId__c                   = prod.id;
        ass.NE__RecurringChargeFrequency__c = 'Monthly';
        ass.NE__Remove_from_total__c        = false;
        ass.NE__Service_Account__c          = acc.id;
        ass.NE__Service_Point__c            = sp.id;
        ass.NE__Status__c                   = 'Active';
        ass.OB_enablement__c                = 'N';
        ass.OB_MCCL2__c                     = '0001';
        ass.OB_MCC__c                       = '5200';
        ass.OB_Report_Type__c               = 'Punto Vendita';
        ass.OB_Ro__c                        = 'N';
        ass.OB_Visible__c                   = 'N';
        ass.Quantity                        = 1;
        ass.OB_ShopSign__c                  = '23112';
        ass.OB_ShopCode__c                  = 'stabId';
        ass.OB_CustomerCode__c              = 'clientId';
        ass.OB_TermId__c                    = 'terminalId';
        ass.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Asset' AND DeveloperName = 'Standard' LIMIT 1].id;
        insert ass;

        System.debug('Asset inserito: ' + ass.id);

        List<NE__AssetItemAttribute__c> assetItemAttrList = new List<NE__AssetItemAttribute__c>();

        NE__AssetItemAttribute__c assetItemAttrRelease = new NE__AssetItemAttribute__c();
        assetItemAttrRelease.Name  = 'release';
        assetItemAttrRelease.NE__Value__c = 'Nexi';
        assetItemAttrRelease.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrRelease);

        NE__AssetItemAttribute__c assetItemAttrModello = new NE__AssetItemAttribute__c();
        assetItemAttrModello.Name  = 'modello';
        assetItemAttrModello.NE__Value__c = 'Nexi';
        assetItemAttrModello.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrModello);

        NE__AssetItemAttribute__c assetItemAttrModalitaCollegamento = new NE__AssetItemAttribute__c();
        assetItemAttrModalitaCollegamento.Name  = 'modalitàCollegamento';
        assetItemAttrModalitaCollegamento.NE__Value__c = 'Nexi';
        assetItemAttrModalitaCollegamento.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrModalitaCollegamento);

        NE__AssetItemAttribute__c assetItemAttrDescrizioneModello = new NE__AssetItemAttribute__c();
        assetItemAttrDescrizioneModello.Name  = 'Descrizione Modello';
        assetItemAttrDescrizioneModello.NE__Value__c = 'Nexi';
        assetItemAttrDescrizioneModello.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrDescrizioneModello);

        NE__AssetItemAttribute__c assetItemAttrDescrizioneRelease = new NE__AssetItemAttribute__c();
        assetItemAttrDescrizioneRelease.Name  = 'Descrizione Release';
        assetItemAttrDescrizioneRelease.NE__Value__c = 'Nexi';
        assetItemAttrDescrizioneRelease.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrDescrizioneRelease);

        NE__AssetItemAttribute__c assetItemAttrDescrizioneConnessione = new NE__AssetItemAttribute__c();
        assetItemAttrDescrizioneConnessione.Name  = 'Descrizione Connessione';
        assetItemAttrDescrizioneConnessione.NE__Value__c = 'Nexi';
        assetItemAttrDescrizioneConnessione.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrDescrizioneConnessione);
        
        insert assetItemAttrList;

        List<NE__Order_Item_Attribute__c> orderItemAttrList = new List<NE__Order_Item_Attribute__c>();

        NE__Order_Item_Attribute__c orderItemAttrModello = new NE__Order_Item_Attribute__c();
        orderItemAttrModello.Name              = 'modello';
        orderItemAttrModello.NE__Value__c      = 'Nexi';
        orderItemAttrModello.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrModello);

        NE__Order_Item_Attribute__c orderItemAttrRelease = new NE__Order_Item_Attribute__c();
        orderItemAttrRelease.Name              = 'release';
        orderItemAttrRelease.NE__Value__c      = 'Nexi';
        orderItemAttrRelease.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrRelease);

        NE__Order_Item_Attribute__c orderItemAttrModalitaCollegamento = new NE__Order_Item_Attribute__c();
        orderItemAttrModalitaCollegamento.Name              = 'modalitàCollegamento';
        orderItemAttrModalitaCollegamento.NE__Value__c      = 'Nexi';
        orderItemAttrModalitaCollegamento.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrModalitaCollegamento);

        NE__Order_Item_Attribute__c orderItemAttrDescrizioneModello = new NE__Order_Item_Attribute__c();
        orderItemAttrDescrizioneModello.Name              = 'Descrizione Modello';
        orderItemAttrDescrizioneModello.NE__Value__c      = 'Nexi';
        orderItemAttrDescrizioneModello.NE__Order_Item__c = parentItem.id;
        orderItemAttrList.add(orderItemAttrDescrizioneModello);

        NE__Order_Item_Attribute__c orderItemAttrDescrizioneRelease = new NE__Order_Item_Attribute__c();
        orderItemAttrDescrizioneRelease.Name              = 'Descrizione Release';
        orderItemAttrDescrizioneRelease.NE__Value__c      = 'Nexi';
        orderItemAttrDescrizioneRelease.NE__Order_Item__c = parentItem.id;
        orderItemAttrList.add(orderItemAttrDescrizioneRelease);

        NE__Order_Item_Attribute__c orderItemAttrDescrizioneConnessione = new NE__Order_Item_Attribute__c();
        orderItemAttrDescrizioneConnessione.Name              = 'Descrizione Connessione';
        orderItemAttrDescrizioneConnessione.NE__Value__c      = 'Nexi';
        orderItemAttrDescrizioneConnessione.NE__Order_Item__c = parentItem.id;
        orderItemAttrList.add(orderItemAttrDescrizioneConnessione);

        insert orderItemAttrList;
        
        NE__Lov__c lov = new NE__Lov__c();
        lov.NE__Sub_Type__c= 'TIPOLOGICHE';
        lov.NE__Type__c='TRACKING';
        lov.NE__Value1__c = '98765';
        lov.NE__Value2__c = '98765';
        lov.Name = 'test';
        insert lov;

        OB_DeltaRun_LightService.CompanyInfo  companyInfo = new OB_DeltaRun_LightService.CompanyInfo();
        companyInfo.companyCode         = '98765';
        companyInfo.ABI                 = '98765';
        companyInfo.conventionCode      = '78765';
        companyInfo.activationDate      = Date.newInstance(2006, 3, 16);
        companyInfo.deactivationdDate   = Date.newInstance(2011, 3, 16);

        OB_DeltaRun_LightService.CompanyInfo companyData = new OB_DeltaRun_LightService.CompanyInfo();
        companyData.companyCode = '98765';
        companyData.ABI = '98765';
        companyData.conventionCode = '78765';
        companyData.activationDate = Date.newInstance(1960, 2, 17);
        companyData.deactivationdDate = null;

        OB_DeltaRun_LightService.TermInfo termInfo = new OB_DeltaRun_LightService.TermInfo();
        termInfo.modelCode = 'modelCode';
        termInfo.modelDescription = 'modelDescription';
        termInfo.releaseCode = 'releaseCode';
        termInfo.releaseDescription = 'releaseDescription';
        termInfo.connectionCode = 'connectionCode';
        termInfo.connectionDescription = 'connectionDescription';

        OB_DeltaRun_LightService.DeltaRequest request = new OB_DeltaRun_LightService.DeltaRequest();
        request.terminalId = 'terminalId';
        request.clientId = 'clientId';
        request.stabId = 'stabId';
        request.terminalData = termInfo;
        request.companyData = companyData;

        Test.startTest();
        OB_DeltaRun_LightService.updateOrder(request, terminalItem, ass.id, rootAsset.id);
        Test.stopTest();
    }

    @isTest
    public static void updateOrder_Test3()
    {
        Account acc  = new Account(); 
        acc.Name = 'TEST';
        acc.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Bank'].id;
        acc.OB_Employees_Number__c = 'Minore di 10';
        acc.OB_VAT_Not_Present__c = false;
        acc.OB_DescriptionVATNotPresent__c = 'description';
        acc.NE__Fiscal_code__c = 'RSSMRA80A01F205X';
        acc.OB_BypassValidation__c = true;
        acc.OB_Status__c = 'Active'; 
        acc.NE__VAT__c = '12312312312'; 
        acc.OB_ABI__c = '12345';
        insert acc;

        NE__Bundle__c bundle = new NE__Bundle__c();
        bundle.Name = 'test';
        bundle.NE__Configuration_Type__c = 'Free';
        bundle.NE__BaseRecurringCharge__c = 12.00;
        bundle.NE__RecurringChargeFrequency__c = 'Annual';
        bundle.NE__Start_Date__c = System.now();
        bundle.NE__End_Date__c = System.now().addDays(1);
        insert bundle;

        NE__Order_Header__c oh = new NE__Order_Header__c();
        oh.OB_Business_Model_Acquiring__c = 'Bancario'; 
        oh.OB_Business_Model_POS__c = 'Trilaterale Nuovo';
        oh.OB_Main_Process__c = 'Setup';
        insert oh;

        NE__Service_Point__c sp  = new NE__Service_Point__c();
        sp.OB_MCC__c   ='2345';
        sp.NE__City__c = 'Yaounde';
        insert sp;

        NE__Order__c ord = new NE__Order__c();
        ord.NE__Order_Header__c = oh.id;
        ord.NE__AccountId__c = acc.id;
        ord.NE__BillAccId__c = acc.Id;
        ord.NE__ServAccId__c = acc.Id;
        ord.OB_MCCL2__c = '0000';
        ord.OB_GT__c = 'Nexi';
        ord.OB_Service_Point__c = sp.id; 
        ord.OB_FulfilmentStatus__c = 'Sent';        
        insert ord; 

        NE__Item_Header__c itemHeader = new NE__Item_Header__c();
        itemHeader.Name = 'REFERRAL' ;
        insert itemHeader;
        
        NE__Product__c prod = new NE__Product__c();
        prod.OB_Codice_sfdc__c = '98765';
        insert prod;

        NE__Billing_Profile__c bp = new NE__Billing_Profile__c();
        bp.NE__Account__c = acc.id;
        insert bp;

        NE__Catalog__c cat = new NE__Catalog__c();
        cat.Name = 'cat';
        insert cat;

        NE__Catalog_Item__c ci    = new NE__Catalog_Item__c();
        ci.NE__ProductId__c = prod.id;
        ci.NE__Catalog_Id__c = cat.id;
        ci.NE__Item_Header__c = itemHeader.id;
        ci.NE__Type__c ='Product'; 
        //NE__Catalog_Id__c = :terminalItem.NE__Catalog__c
        
        insert ci;

        NE__Catalog_Item__c ci2 = new NE__Catalog_Item__c();
        ci2.NE__ProductId__c = prod.id;
        ci2.NE__Catalog_Id__c = cat.id;
        ci2.NE__Type__c = 'Product';

        NE__OrderItem__c terminalItem = New NE__OrderItem__c(NE__Qty__c = 10 ,NE__OrderId__c = ord.id);
        terminalItem.NE__Action__c      = 'Add';
        terminalItem.OB_ShopCode__c     = 'stabId';
        terminalItem.OB_CustomerCode__c = 'clientId';
        terminalItem.OB_TermId__c       = 'terminalId';  
        terminalItem.OB_ProposerABI__c  = acc.id;
        terminalItem.NE__OrderId__c = ord.id;
        terminalItem.NE__ProdId__c = prod.id;
        terminalItem.NE__Catalog__c = cat.id;
        insert terminalItem;

        NE__OrderItem__c parentItem = New NE__OrderItem__c(NE__Qty__c = 10 ,NE__OrderId__c = ord.id);
        parentItem.NE__Action__c      = 'Add';
        parentItem.OB_ShopCode__c     = 'stabId';
        parentItem.OB_CustomerCode__c = 'clientId';
        parentItem.OB_TermId__c       = 'terminalId';  
        parentItem.OB_ProposerABI__c  = acc.id;
        parentItem.NE__OrderId__c = ord.id;
        parentItem.NE__ProdId__c = prod.id;
        parentItem.NE__CatalogItem__c = ci.id;
        parentItem.NE__Parent_Order_Item__c = terminalItem.id;
        terminalItem.NE__Catalog__c = cat.id;
        insert parentItem;

        Asset rootAsset = new Asset();
        rootAsset.NE__CatalogItem__c              = ci.id;
        rootAsset.AccountId                       = acc.id;
        rootAsset.OB_DebitProfId__c               = bp.id;
        rootAsset.OB_ProposerABI__c               = acc.id;
        rootAsset.IsCompetitorProduct             = false;
        rootAsset.NE__Catalog__c = cat.id;
       // ass.IsInternal                      = false;
        rootAsset.Name                            = 'Offerta Personalizzata';
        rootAsset.NE__Action__c                   = 'Change';
        rootAsset.NE__AssetItemEnterpriseId__c    = '123123123';
        rootAsset.NE__BaseOneTimeFee__c           = 0;
        rootAsset.NE__BaseRecurringCharge__c      = 0;
        rootAsset.NE__Billing_Account__c          = acc.id;
        rootAsset.NE__Commitment__c               = false;
        rootAsset.NE__Discount_One_time__c        = 0;
        rootAsset.NE__Discount__c                 = 0;
        rootAsset.NE__Generate_Asset_Item__c      = true;
        rootAsset.NE__Item_Code__c                = '';
        rootAsset.NE__Order_Config__c             = ord.id;
        rootAsset.NE__ProdId__c                   = prod.id;
        rootAsset.NE__RecurringChargeFrequency__c = 'Monthly';
        rootAsset.NE__Remove_from_total__c        = false;
        rootAsset.NE__Service_Account__c          = acc.id;
        rootAsset.NE__Service_Point__c            = sp.id;
        rootAsset.NE__Status__c                   = 'Active';
        rootAsset.OB_enablement__c                = 'N';
        rootAsset.OB_MCCL2__c                     = '0001';
        rootAsset.OB_MCC__c                       = '5200';
        rootAsset.OB_Report_Type__c               = 'Punto Vendita';
        rootAsset.OB_Ro__c                        = 'N';
        rootAsset.OB_Visible__c                   = 'N';
        rootAsset.Quantity                        = 1;
        rootAsset.OB_ShopSign__c                  = '23112';
        rootAsset.OB_ShopCode__c                  = 'stabId';
        rootAsset.OB_CustomerCode__c              = 'clientId';
        rootAsset.OB_TermId__c                    = 'terminalId';
        rootAsset.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Asset' AND DeveloperName = 'Standard' LIMIT 1].id;
        insert rootAsset;

        Asset ass = new Asset();
        //ass.RootAssetId                     = rootAsset.Id;
        ass.ParentId =                      rootAsset.id;
        ass.NE__CatalogItem__c              = ci.id;
        ass.AccountId                       = acc.id;
        ass.OB_DebitProfId__c               = bp.id;
        ass.OB_ProposerABI__c               = acc.id;
        ass.IsCompetitorProduct             = false;
        ass.NE__Catalog__c = cat.id;
       // ass.IsInternal                      = false;
        ass.Name                            = 'Offerta Personalizzata';
        ass.NE__Action__c                   = 'Change';
        ass.NE__AssetItemEnterpriseId__c    = '123123123';
        ass.NE__BaseOneTimeFee__c           = 0;
        ass.NE__BaseRecurringCharge__c      = 0;
        ass.NE__Billing_Account__c          = acc.id;
        ass.NE__Commitment__c               = false;
        ass.NE__Discount_One_time__c        = 0;
        ass.NE__Discount__c                 = 0;
        ass.NE__Generate_Asset_Item__c      = true;
        ass.NE__Item_Code__c                = '';
        ass.NE__Order_Config__c             = ord.id;
        ass.NE__ProdId__c                   = prod.id;
        ass.NE__RecurringChargeFrequency__c = 'Monthly';
        ass.NE__Remove_from_total__c        = false;
        ass.NE__Service_Account__c          = acc.id;
        ass.NE__Service_Point__c            = sp.id;
        ass.NE__Status__c                   = 'Active';
        ass.OB_enablement__c                = 'N';
        ass.OB_MCCL2__c                     = '0001';
        ass.OB_MCC__c                       = '5200';
        ass.OB_Report_Type__c               = 'Punto Vendita';
        ass.OB_Ro__c                        = 'N';
        ass.OB_Visible__c                   = 'N';
        ass.Quantity                        = 1;
        ass.OB_ShopSign__c                  = '23112';
        ass.OB_ShopCode__c                  = 'stabId';
        ass.OB_CustomerCode__c              = 'clientId';
        ass.OB_TermId__c                    = 'terminalId';
        ass.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Asset' AND DeveloperName = 'Standard' LIMIT 1].id;
        insert ass;

        System.debug('Asset inserito: ' + ass.id);

        List<NE__AssetItemAttribute__c> assetItemAttrList = new List<NE__AssetItemAttribute__c>();

        NE__AssetItemAttribute__c assetItemAttrRelease = new NE__AssetItemAttribute__c();
        assetItemAttrRelease.Name  = 'release';
        assetItemAttrRelease.NE__Value__c = 'Nexi';
        assetItemAttrRelease.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrRelease);

        NE__AssetItemAttribute__c assetItemAttrModello = new NE__AssetItemAttribute__c();
        assetItemAttrModello.Name  = 'modello';
        assetItemAttrModello.NE__Value__c = 'Nexi';
        assetItemAttrModello.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrModello);

        NE__AssetItemAttribute__c assetItemAttrModalitaCollegamento = new NE__AssetItemAttribute__c();
        assetItemAttrModalitaCollegamento.Name  = 'modalitàCollegamento';
        assetItemAttrModalitaCollegamento.NE__Value__c = 'Nexi';
        assetItemAttrModalitaCollegamento.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrModalitaCollegamento);

        NE__AssetItemAttribute__c assetItemAttrDescrizioneModello = new NE__AssetItemAttribute__c();
        assetItemAttrDescrizioneModello.Name  = 'Descrizione Modello';
        assetItemAttrDescrizioneModello.NE__Value__c = 'Nexi';
        assetItemAttrDescrizioneModello.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrDescrizioneModello);

        NE__AssetItemAttribute__c assetItemAttrDescrizioneRelease = new NE__AssetItemAttribute__c();
        assetItemAttrDescrizioneRelease.Name  = 'Descrizione Release';
        assetItemAttrDescrizioneRelease.NE__Value__c = 'Nexi';
        assetItemAttrDescrizioneRelease.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrDescrizioneRelease);

        NE__AssetItemAttribute__c assetItemAttrDescrizioneConnessione = new NE__AssetItemAttribute__c();
        assetItemAttrDescrizioneConnessione.Name  = 'Descrizione Connessione';
        assetItemAttrDescrizioneConnessione.NE__Value__c = 'Nexi';
        assetItemAttrDescrizioneConnessione.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrDescrizioneConnessione);
        
        insert assetItemAttrList;

        List<NE__Order_Item_Attribute__c> orderItemAttrList = new List<NE__Order_Item_Attribute__c>();

        NE__Order_Item_Attribute__c orderItemAttrModello = new NE__Order_Item_Attribute__c();
        orderItemAttrModello.Name              = 'modello';
        orderItemAttrModello.NE__Value__c      = 'Nexi';
        orderItemAttrModello.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrModello);

        NE__Order_Item_Attribute__c orderItemAttrRelease = new NE__Order_Item_Attribute__c();
        orderItemAttrRelease.Name              = 'release';
        orderItemAttrRelease.NE__Value__c      = 'Nexi';
        orderItemAttrRelease.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrRelease);

        NE__Order_Item_Attribute__c orderItemAttrModalitaCollegamento = new NE__Order_Item_Attribute__c();
        orderItemAttrModalitaCollegamento.Name              = 'modalitàCollegamento';
        orderItemAttrModalitaCollegamento.NE__Value__c      = 'Nexi';
        orderItemAttrModalitaCollegamento.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrModalitaCollegamento);

        NE__Order_Item_Attribute__c orderItemAttrDescrizioneModello = new NE__Order_Item_Attribute__c();
        orderItemAttrDescrizioneModello.Name              = 'Descrizione Modello';
        orderItemAttrDescrizioneModello.NE__Value__c      = 'Nexi';
        orderItemAttrDescrizioneModello.NE__Order_Item__c = parentItem.id;
        orderItemAttrList.add(orderItemAttrDescrizioneModello);

        NE__Order_Item_Attribute__c orderItemAttrDescrizioneRelease = new NE__Order_Item_Attribute__c();
        orderItemAttrDescrizioneRelease.Name              = 'Descrizione Release';
        orderItemAttrDescrizioneRelease.NE__Value__c      = 'Nexi';
        orderItemAttrDescrizioneRelease.NE__Order_Item__c = parentItem.id;
        orderItemAttrList.add(orderItemAttrDescrizioneRelease);

        NE__Order_Item_Attribute__c orderItemAttrDescrizioneConnessione = new NE__Order_Item_Attribute__c();
        orderItemAttrDescrizioneConnessione.Name              = 'Descrizione Connessione';
        orderItemAttrDescrizioneConnessione.NE__Value__c      = 'Nexi';
        orderItemAttrDescrizioneConnessione.NE__Order_Item__c = parentItem.id;
        orderItemAttrList.add(orderItemAttrDescrizioneConnessione);

        insert orderItemAttrList;
        
        NE__Lov__c lov = new NE__Lov__c();
        lov.NE__Sub_Type__c= 'TIPOLOGICHE';
        lov.NE__Type__c='TRACKING';
        lov.NE__Value1__c = '98765';
        lov.NE__Value2__c = '98765';
        lov.Name = 'test';
        insert lov;

        OB_DeltaRun_LightService.CompanyInfo  companyInfo = new OB_DeltaRun_LightService.CompanyInfo();
        companyInfo.companyCode         = '98765';
        companyInfo.ABI                 = '98765';
        companyInfo.conventionCode      = '78765';
        companyInfo.activationDate      = Date.newInstance(2006, 3, 16);
        companyInfo.deactivationdDate   = Date.newInstance(2011, 3, 16);

        OB_DeltaRun_LightService.CompanyInfo companyData = new OB_DeltaRun_LightService.CompanyInfo();
        companyData.companyCode = '98765';
        companyData.ABI = '98765';
        companyData.conventionCode = '78765';
        companyData.activationDate = Date.newInstance(1960, 2, 17);
        companyData.deactivationdDate = null;

        OB_DeltaRun_LightService.TermInfo termInfo = new OB_DeltaRun_LightService.TermInfo();
        termInfo.modelCode = 'modelCode';
        termInfo.modelDescription = 'modelDescription';
        termInfo.releaseCode = 'releaseCode';
        termInfo.releaseDescription = 'releaseDescription';
        termInfo.connectionCode = 'connectionCode';
        termInfo.connectionDescription = 'connectionDescription';

        OB_DeltaRun_LightService.DeltaRequest request = new OB_DeltaRun_LightService.DeltaRequest();
        request.terminalId = 'terminalId';
        request.clientId = 'clientId';
        request.stabId = 'stabId';
        request.terminalData = termInfo;
        request.companyData = companyData;

        Test.startTest();
        OB_DeltaRun_LightService.updateOrder(request, terminalItem, ass.id, rootAsset.id);
        Test.stopTest();
    }

    @isTest
    public static void updateOrder_Test4()
    {
        Account acc  = new Account(); 
        acc.Name = 'TEST';
        acc.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Bank'].id;
        acc.OB_Employees_Number__c = 'Minore di 10';
        acc.OB_VAT_Not_Present__c = false;
        acc.OB_DescriptionVATNotPresent__c = 'description';
        acc.NE__Fiscal_code__c = 'RSSMRA80A01F205X';
        acc.OB_BypassValidation__c = true;
        acc.OB_Status__c = 'Active'; 
        acc.NE__VAT__c = '12312312312'; 
        acc.OB_ABI__c = '12345';
        insert acc;

        NE__Bundle__c bundle = new NE__Bundle__c();
        bundle.Name = 'test';
        bundle.NE__Configuration_Type__c = 'Free';
        bundle.NE__BaseRecurringCharge__c = 12.00;
        bundle.NE__RecurringChargeFrequency__c = 'Annual';
        bundle.NE__Start_Date__c = System.now();
        bundle.NE__End_Date__c = System.now().addDays(1);
        insert bundle;

        NE__Order_Header__c oh = new NE__Order_Header__c();
        oh.OB_Business_Model_Acquiring__c = 'Bancario'; 
        oh.OB_Business_Model_POS__c = 'Trilaterale Nuovo';
        oh.OB_Main_Process__c = 'Setup';
        insert oh;

        NE__Service_Point__c sp  = new NE__Service_Point__c();
        sp.OB_MCC__c   ='2345';
        sp.NE__City__c = 'Yaounde';
        insert sp;

        NE__Order__c ord = new NE__Order__c();
        ord.NE__Order_Header__c = oh.id;
        ord.NE__AccountId__c = acc.id;
        ord.NE__BillAccId__c = acc.Id;
        ord.NE__ServAccId__c = acc.Id;
        ord.OB_MCCL2__c = '0000';
        ord.OB_GT__c = 'Nexi';
        ord.OB_Service_Point__c = sp.id; 
        ord.OB_FulfilmentStatus__c = 'Sent';        
        insert ord; 

        NE__Item_Header__c itemHeader = new NE__Item_Header__c();
        itemHeader.Name = 'REFERRAL' ;
        insert itemHeader;
        
        NE__Product__c prod = new NE__Product__c();
        prod.OB_Codice_sfdc__c = '00000';
        insert prod;

        NE__Product__c prod2 = new NE__Product__c();
        prod2.OB_Codice_sfdc__c = '98765';
        insert prod2;
        
        NE__Billing_Profile__c bp = new NE__Billing_Profile__c();
        bp.NE__Account__c = acc.id;
        insert bp;

        NE__Catalog__c cat = new NE__Catalog__c();
        cat.Name = 'cat';
        insert cat;

        NE__Catalog_Item__c ci    = new NE__Catalog_Item__c();
        ci.NE__ProductId__c = prod.id;
        ci.NE__Catalog_Id__c = cat.id;
        ci.NE__Item_Header__c = itemHeader.id;
        ci.NE__Type__c = 'Category'; 
        insert ci;

        NE__Catalog_Item__c ci2 = new NE__Catalog_Item__c();
        ci2.NE__ProductId__c = prod.id;
        ci2.NE__Catalog_Id__c = cat.id;
        ci2.NE__Type__c = 'Product';
        insert ci2;

        NE__OrderItem__c terminalItem = New NE__OrderItem__c(NE__Qty__c = 10 ,NE__OrderId__c = ord.id);
        terminalItem.NE__Action__c      = 'Add';
        terminalItem.OB_ShopCode__c     = 'stabId';
        terminalItem.OB_CustomerCode__c = 'clientId';
        terminalItem.OB_TermId__c       = 'terminalId';  
        terminalItem.OB_ProposerABI__c  = acc.id;
        terminalItem.NE__OrderId__c = ord.id;
        terminalItem.NE__ProdId__c = prod.id;
        terminalItem.NE__Account__c = acc.id;
        terminalItem.NE__Service_Account__c = acc.id;
        terminalItem.NE__Billing_Account__c = acc.id;
        terminalItem.NE__CatalogItem__c = ci.id;
        insert terminalItem;

        // NE__OrderItem__c parentItem = New NE__OrderItem__c(NE__Qty__c = 10 ,NE__OrderId__c = ord.id);
        // parentItem.NE__Action__c      = 'Add';
        // parentItem.OB_ShopCode__c     = 'stabId';
        // parentItem.OB_CustomerCode__c = 'clientId';
        // parentItem.OB_TermId__c       = 'terminalId';  
        // parentItem.OB_ProposerABI__c  = acc.id;
        // parentItem.NE__OrderId__c = ord.id;
        // parentItem.NE__ProdId__c = prod.id;
        // parentItem.NE__CatalogItem__c = ci.id;
        // insert parentItem;

        Asset rootAsset = new Asset();
        rootAsset.NE__CatalogItem__c              = ci.id;
        rootAsset.AccountId                       = acc.id;
        rootAsset.OB_DebitProfId__c               = bp.id;
        rootAsset.OB_ProposerABI__c               = acc.id;
        rootAsset.IsCompetitorProduct             = false;
        rootAsset.NE__Catalog__c = cat.id;
       // ass.IsInternal                      = false;
        rootAsset.Name                            = 'Offerta Personalizzata';
        rootAsset.NE__Action__c                   = 'Change';
        rootAsset.NE__AssetItemEnterpriseId__c    = '123123123';
        rootAsset.NE__BaseOneTimeFee__c           = 0;
        rootAsset.NE__BaseRecurringCharge__c      = 0;
        rootAsset.NE__Billing_Account__c          = acc.id;
        rootAsset.NE__Commitment__c               = false;
        rootAsset.NE__Discount_One_time__c        = 0;
        rootAsset.NE__Discount__c                 = 0;
        rootAsset.NE__Generate_Asset_Item__c      = true;
        rootAsset.NE__Item_Code__c                = '';
        rootAsset.NE__Order_Config__c             = ord.id;
        rootAsset.NE__ProdId__c                   = prod.id;
        rootAsset.NE__RecurringChargeFrequency__c = 'Monthly';
        rootAsset.NE__Remove_from_total__c        = false;
        rootAsset.NE__Service_Account__c          = acc.id;
        rootAsset.NE__Service_Point__c            = sp.id;
        rootAsset.NE__Status__c                   = 'Active';
        rootAsset.OB_enablement__c                = 'N';
        rootAsset.OB_MCCL2__c                     = '0001';
        rootAsset.OB_MCC__c                       = '5200';
        rootAsset.OB_Report_Type__c               = 'Punto Vendita';
        rootAsset.OB_Ro__c                        = 'N';
        rootAsset.OB_Visible__c                   = 'N';
        rootAsset.Quantity                        = 1;
        rootAsset.OB_ShopSign__c                  = '23112';
        rootAsset.OB_ShopCode__c                  = 'stabId';
        rootAsset.OB_CustomerCode__c              = 'clientId';
        rootAsset.OB_TermId__c                    = 'terminalId';
        rootAsset.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Asset' AND DeveloperName = 'Standard' LIMIT 1].id;
        insert rootAsset;

        Asset ass = new Asset();
        //ass.RootAssetId                     = rootAsset.Id;
        ass.ParentId =                      rootAsset.id;
        ass.NE__CatalogItem__c              = ci.id;
        ass.AccountId                       = acc.id;
        ass.OB_DebitProfId__c               = bp.id;
        ass.OB_ProposerABI__c               = acc.id;
        ass.IsCompetitorProduct             = false;
        ass.NE__Catalog__c = cat.id;
       // ass.IsInternal                      = false;
        ass.Name                            = 'Offerta Personalizzata';
        ass.NE__Action__c                   = 'Change';
        ass.NE__AssetItemEnterpriseId__c    = '123123123';
        ass.NE__BaseOneTimeFee__c           = 0;
        ass.NE__BaseRecurringCharge__c      = 0;
        ass.NE__Billing_Account__c          = acc.id;
        ass.NE__Commitment__c               = false;
        ass.NE__Discount_One_time__c        = 0;
        ass.NE__Discount__c                 = 0;
        ass.NE__Generate_Asset_Item__c      = true;
        ass.NE__Item_Code__c                = '';
        ass.NE__Order_Config__c             = ord.id;
        ass.NE__ProdId__c                   = prod.id;
        ass.NE__RecurringChargeFrequency__c = 'Monthly';
        ass.NE__Remove_from_total__c        = false;
        ass.NE__Service_Account__c          = acc.id;
        ass.NE__Service_Point__c            = sp.id;
        ass.NE__Status__c                   = 'Active';
        ass.OB_enablement__c                = 'N';
        ass.OB_MCCL2__c                     = '0001';
        ass.OB_MCC__c                       = '5200';
        ass.OB_Report_Type__c               = 'Punto Vendita';
        ass.OB_Ro__c                        = 'N';
        ass.OB_Visible__c                   = 'N';
        ass.Quantity                        = 1;
        ass.OB_ShopSign__c                  = '23112';
        ass.OB_ShopCode__c                  = 'stabId';
        ass.OB_CustomerCode__c              = 'clientId';
        ass.OB_TermId__c                    = 'terminalId';
        ass.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Asset' AND DeveloperName = 'Standard' LIMIT 1].id;
        insert ass;

        System.debug('Asset inserito: ' + ass.id);

        List<NE__AssetItemAttribute__c> assetItemAttrList = new List<NE__AssetItemAttribute__c>();

        NE__AssetItemAttribute__c assetItemAttrRelease = new NE__AssetItemAttribute__c();
        assetItemAttrRelease.Name  = 'release';
        assetItemAttrRelease.NE__Value__c = 'Nexi';
        assetItemAttrRelease.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrRelease);

        NE__AssetItemAttribute__c assetItemAttrModello = new NE__AssetItemAttribute__c();
        assetItemAttrModello.Name  = 'modello';
        assetItemAttrModello.NE__Value__c = 'Nexi';
        assetItemAttrModello.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrModello);

        NE__AssetItemAttribute__c assetItemAttrModalitaCollegamento = new NE__AssetItemAttribute__c();
        assetItemAttrModalitaCollegamento.Name  = 'modalitàCollegamento';
        assetItemAttrModalitaCollegamento.NE__Value__c = 'Nexi';
        assetItemAttrModalitaCollegamento.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrModalitaCollegamento);

        NE__AssetItemAttribute__c assetItemAttrDescrizioneModello = new NE__AssetItemAttribute__c();
        assetItemAttrDescrizioneModello.Name  = 'Descrizione Modello';
        assetItemAttrDescrizioneModello.NE__Value__c = 'Nexi';
        assetItemAttrDescrizioneModello.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrDescrizioneModello);

        NE__AssetItemAttribute__c assetItemAttrDescrizioneRelease = new NE__AssetItemAttribute__c();
        assetItemAttrDescrizioneRelease.Name  = 'Descrizione Release';
        assetItemAttrDescrizioneRelease.NE__Value__c = 'Nexi';
        assetItemAttrDescrizioneRelease.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrDescrizioneRelease);

        NE__AssetItemAttribute__c assetItemAttrDescrizioneConnessione = new NE__AssetItemAttribute__c();
        assetItemAttrDescrizioneConnessione.Name  = 'Descrizione Connessione';
        assetItemAttrDescrizioneConnessione.NE__Value__c = 'Nexi';
        assetItemAttrDescrizioneConnessione.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrDescrizioneConnessione);
        
        insert assetItemAttrList;

        List<NE__Order_Item_Attribute__c> orderItemAttrList = new List<NE__Order_Item_Attribute__c>();

        NE__Order_Item_Attribute__c orderItemAttrModello = new NE__Order_Item_Attribute__c();
        orderItemAttrModello.Name              = 'modello';
        orderItemAttrModello.NE__Value__c      = 'Nexi';
        orderItemAttrModello.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrModello);

        NE__Order_Item_Attribute__c orderItemAttrRelease = new NE__Order_Item_Attribute__c();
        orderItemAttrRelease.Name              = 'release';
        orderItemAttrRelease.NE__Value__c      = 'Nexi';
        orderItemAttrRelease.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrRelease);

        NE__Order_Item_Attribute__c orderItemAttrModalitaCollegamento = new NE__Order_Item_Attribute__c();
        orderItemAttrModalitaCollegamento.Name              = 'modalitàCollegamento';
        orderItemAttrModalitaCollegamento.NE__Value__c      = 'Nexi';
        orderItemAttrModalitaCollegamento.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrModalitaCollegamento);

        NE__Order_Item_Attribute__c orderItemAttrDescrizioneModello = new NE__Order_Item_Attribute__c();
        orderItemAttrDescrizioneModello.Name              = 'Descrizione Modello';
        orderItemAttrDescrizioneModello.NE__Value__c      = 'Nexi';
        orderItemAttrDescrizioneModello.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrDescrizioneModello);

        NE__Order_Item_Attribute__c orderItemAttrDescrizioneRelease = new NE__Order_Item_Attribute__c();
        orderItemAttrDescrizioneRelease.Name              = 'Descrizione Release';
        orderItemAttrDescrizioneRelease.NE__Value__c      = 'Nexi';
        orderItemAttrDescrizioneRelease.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrDescrizioneRelease);

        NE__Order_Item_Attribute__c orderItemAttrDescrizioneConnessione = new NE__Order_Item_Attribute__c();
        orderItemAttrDescrizioneConnessione.Name              = 'Descrizione Connessione';
        orderItemAttrDescrizioneConnessione.NE__Value__c      = 'Nexi';
        orderItemAttrDescrizioneConnessione.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrDescrizioneConnessione);

        insert orderItemAttrList;
        
        NE__Lov__c lov = new NE__Lov__c();
        lov.NE__Sub_Type__c= 'TIPOLOGICHE';
        lov.NE__Type__c='TRACKING';
        lov.NE__Value1__c = '98765';
        lov.NE__Value2__c = '98765';
        lov.Name = 'test';
        insert lov;

        OB_DeltaRun_LightService.CompanyInfo  companyInfo = new OB_DeltaRun_LightService.CompanyInfo();
        companyInfo.companyCode         = '98765';
        companyInfo.ABI                 = '98765';
        companyInfo.conventionCode      = '78765';
        companyInfo.activationDate      = Date.newInstance(2006, 3, 16);
        //companyInfo.deactivationdDate   = '';

        OB_DeltaRun_LightService.CompanyInfo companyData = new OB_DeltaRun_LightService.CompanyInfo();
        companyData.companyCode = '98765';
        companyData.ABI = '98765';
        companyData.conventionCode = '78765';
        companyData.activationDate = Date.newInstance(1960, 2, 17);
        //companyData.deactivationdDate = '';

        OB_DeltaRun_LightService.TermInfo termInfo = new OB_DeltaRun_LightService.TermInfo();
        termInfo.modelCode = 'modelCode';
        termInfo.modelDescription = 'modelDescription';
        termInfo.releaseCode = 'releaseCode';
        termInfo.releaseDescription = 'releaseDescription';
        termInfo.connectionCode = 'connectionCode';
        termInfo.connectionDescription = 'connectionDescription';

        OB_DeltaRun_LightService.DeltaRequest request = new OB_DeltaRun_LightService.DeltaRequest();
        request.terminalId = 'terminalId';
        request.clientId = 'clientId';
        request.stabId = 'stabId';
        request.terminalData = termInfo;
        request.companyData = companyData;

        NE__OrderItem__c oi = new NE__OrderItem__c();
        oi.NE__OrderId__c = ord.id;
        oi.NE__Qty__c = 10;
        oi.NE__ProdId__c = prod2.id;
        oi.OB_ProposerABI__c = acc.id;
        oi.NE__Account__c = acc.id;
        oi.NE__Service_Account__c = acc.id;
        oi.NE__Billing_Account__c = acc.id;
        oi.NE__CatalogItem__c = ci2.id;
        insert oi;

        NE__Catalog_Item__c cItem = new NE__Catalog_Item__c();
        cItem.NE__Type__c = 'Product';
        cItem.NE__ProductId__c = prod2.id;
        cItem.NE__Item_Header__c = itemHeader.id;
        cItem.NE__Catalog_Id__c = cat.id;
        insert cItem;

        Test.startTest();
        OB_DeltaRun_LightService.updateOrder(request, terminalItem, ass.id, rootAsset.id);
        Test.stopTest();
    }

    @isTest
    public static void updateOrder_Test5()
    {
        Account acc  = new Account(); 
        acc.Name = 'TEST';
        acc.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Bank'].id;
        acc.OB_Employees_Number__c = 'Minore di 10';
        acc.OB_VAT_Not_Present__c = false;
        acc.OB_DescriptionVATNotPresent__c = 'description';
        acc.NE__Fiscal_code__c = 'RSSMRA80A01F205X';
        acc.OB_BypassValidation__c = true;
        acc.OB_Status__c = 'Active'; 
        acc.NE__VAT__c = '12312312312'; 
        acc.OB_ABI__c = '12345';
        insert acc;

        NE__Bundle__c bundle = new NE__Bundle__c();
        bundle.Name = 'test';
        bundle.NE__Configuration_Type__c = 'Free';
        bundle.NE__BaseRecurringCharge__c = 12.00;
        bundle.NE__RecurringChargeFrequency__c = 'Annual';
        bundle.NE__Start_Date__c = System.now();
        bundle.NE__End_Date__c = System.now().addDays(1);
        insert bundle;

        NE__Order_Header__c oh = new NE__Order_Header__c();
        oh.OB_Business_Model_Acquiring__c = 'Bancario'; 
        oh.OB_Business_Model_POS__c = 'Trilaterale Nuovo';
        oh.OB_Main_Process__c = 'Setup';
        insert oh;

        NE__Service_Point__c sp  = new NE__Service_Point__c();
        sp.OB_MCC__c   ='2345';
        sp.NE__City__c = 'Yaounde';
        insert sp;

        NE__Order__c ord = new NE__Order__c();
        ord.NE__Order_Header__c = oh.id;
        ord.NE__AccountId__c = acc.id;
        ord.NE__BillAccId__c = acc.Id;
        ord.NE__ServAccId__c = acc.Id;
        ord.OB_MCCL2__c = '0000';
        ord.OB_GT__c = 'Nexi';
        ord.OB_Service_Point__c = sp.id; 
        ord.OB_FulfilmentStatus__c = 'Sent';        
        insert ord; 

        NE__Item_Header__c itemHeader = new NE__Item_Header__c();
        itemHeader.Name = 'REFERRAL' ;
        insert itemHeader;
        System.debug('item header id '+itemHeader.id);
        NE__Product__c prod = new NE__Product__c();
        prod.OB_Codice_sfdc__c = '00000';
        insert prod;

        NE__Product__c prod2 = new NE__Product__c();
        prod2.OB_Codice_sfdc__c = '98765';
        insert prod2;
        
        NE__Billing_Profile__c bp = new NE__Billing_Profile__c();
        bp.NE__Account__c = acc.id;
        insert bp;

        NE__Catalog__c cat = new NE__Catalog__c();
        cat.Name = 'cat';
        insert cat;

        NE__Catalog_Item__c ci    = new NE__Catalog_Item__c();
        ci.NE__ProductId__c = prod.id;
        ci.NE__Catalog_Id__c = cat.id;
        ci.NE__Type__c = 'Category'; 
        insert ci;

        NE__Catalog_Item__c ci2 = new NE__Catalog_Item__c();
        ci2.NE__ProductId__c = prod2.id;
        ci2.NE__Catalog_Id__c = cat.id;
        ci2.NE__Type__c = 'Product';
        ci.NE__Item_Header__c = itemHeader.id;
        insert ci2;

        NE__OrderItem__c terminalItem = New NE__OrderItem__c(NE__Qty__c = 10 ,NE__OrderId__c = ord.id);
        terminalItem.NE__Action__c      = 'Add';
        terminalItem.OB_ShopCode__c     = 'stabId';
        terminalItem.OB_CustomerCode__c = 'clientId';
        terminalItem.OB_TermId__c       = 'terminalId';  
        terminalItem.OB_ProposerABI__c  = acc.id;
        terminalItem.NE__OrderId__c = ord.id;
        terminalItem.NE__ProdId__c = prod.id;
        terminalItem.NE__Account__c = acc.id;
        //terminalItem.NE__Service_Account__c = acc.id;
        //terminalItem.NE__Billing_Account__c = acc.id;
        terminalItem.NE__CatalogItem__c = ci.id;
        insert terminalItem;

        // NE__OrderItem__c parentItem = New NE__OrderItem__c(NE__Qty__c = 10 ,NE__OrderId__c = ord.id);
        // parentItem.NE__Action__c      = 'Add';
        // parentItem.OB_ShopCode__c     = 'stabId';
        // parentItem.OB_CustomerCode__c = 'clientId';
        // parentItem.OB_TermId__c       = 'terminalId';  
        // parentItem.OB_ProposerABI__c  = acc.id;
        // parentItem.NE__OrderId__c = ord.id;
        // parentItem.NE__ProdId__c = prod.id;
        // parentItem.NE__CatalogItem__c = ci.id;
        // insert parentItem;

        Asset rootAsset = new Asset();
        rootAsset.NE__CatalogItem__c              = ci.id;
        rootAsset.AccountId                       = acc.id;
        rootAsset.OB_DebitProfId__c               = bp.id;
        rootAsset.OB_ProposerABI__c               = acc.id;
        rootAsset.IsCompetitorProduct             = false;
        rootAsset.NE__Catalog__c = cat.id;
       // ass.IsInternal                      = false;
        rootAsset.Name                            = 'Offerta Personalizzata';
        rootAsset.NE__Action__c                   = 'Change';
        rootAsset.NE__AssetItemEnterpriseId__c    = '123123123';
        rootAsset.NE__BaseOneTimeFee__c           = 0;
        rootAsset.NE__BaseRecurringCharge__c      = 0;
        rootAsset.NE__Billing_Account__c          = acc.id;
        rootAsset.NE__Commitment__c               = false;
        rootAsset.NE__Discount_One_time__c        = 0;
        rootAsset.NE__Discount__c                 = 0;
        rootAsset.NE__Generate_Asset_Item__c      = true;
        rootAsset.NE__Item_Code__c                = '';
        rootAsset.NE__Order_Config__c             = ord.id;
        rootAsset.NE__ProdId__c                   = prod.id;
        rootAsset.NE__RecurringChargeFrequency__c = 'Monthly';
        rootAsset.NE__Remove_from_total__c        = false;
        rootAsset.NE__Service_Account__c          = acc.id;
        rootAsset.NE__Service_Point__c            = sp.id;
        rootAsset.NE__Status__c                   = 'Active';
        rootAsset.OB_enablement__c                = 'N';
        rootAsset.OB_MCCL2__c                     = '0001';
        rootAsset.OB_MCC__c                       = '5200';
        rootAsset.OB_Report_Type__c               = 'Punto Vendita';
        rootAsset.OB_Ro__c                        = 'N';
        rootAsset.OB_Visible__c                   = 'N';
        rootAsset.Quantity                        = 1;
        rootAsset.OB_ShopSign__c                  = '23112';
        rootAsset.OB_ShopCode__c                  = 'stabId';
        rootAsset.OB_CustomerCode__c              = 'clientId';
        rootAsset.OB_TermId__c                    = 'terminalId';
        rootAsset.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Asset' AND DeveloperName = 'Standard' LIMIT 1].id;
        insert rootAsset;

        Asset ass = new Asset();
        //ass.RootAssetId                     = rootAsset.Id;
        ass.ParentId =                      rootAsset.id;
        ass.NE__CatalogItem__c              = ci.id;
        ass.AccountId                       = acc.id;
        ass.OB_DebitProfId__c               = bp.id;
        ass.OB_ProposerABI__c               = acc.id;
        ass.IsCompetitorProduct             = false;
        ass.NE__Catalog__c = cat.id;
       // ass.IsInternal                      = false;
        ass.Name                            = 'Offerta Personalizzata';
        ass.NE__Action__c                   = 'Change';
        ass.NE__AssetItemEnterpriseId__c    = '123123123';
        ass.NE__BaseOneTimeFee__c           = 0;
        ass.NE__BaseRecurringCharge__c      = 0;
        ass.NE__Billing_Account__c          = acc.id;
        ass.NE__Commitment__c               = false;
        ass.NE__Discount_One_time__c        = 0;
        ass.NE__Discount__c                 = 0;
        ass.NE__Generate_Asset_Item__c      = true;
        ass.NE__Item_Code__c                = '';
        ass.NE__Order_Config__c             = ord.id;
        ass.NE__ProdId__c                   = prod.id;
        ass.NE__RecurringChargeFrequency__c = 'Monthly';
        ass.NE__Remove_from_total__c        = false;
        ass.NE__Service_Account__c          = acc.id;
        ass.NE__Service_Point__c            = sp.id;
        ass.NE__Status__c                   = 'Active';
        ass.OB_enablement__c                = 'N';
        ass.OB_MCCL2__c                     = '0001';
        ass.OB_MCC__c                       = '5200';
        ass.OB_Report_Type__c               = 'Punto Vendita';
        ass.OB_Ro__c                        = 'N';
        ass.OB_Visible__c                   = 'N';
        ass.Quantity                        = 1;
        ass.OB_ShopSign__c                  = '23112';
        ass.OB_ShopCode__c                  = 'stabId';
        ass.OB_CustomerCode__c              = 'clientId';
        ass.OB_TermId__c                    = 'terminalId';
        ass.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Asset' AND DeveloperName = 'Standard' LIMIT 1].id;
        insert ass;

        System.debug('Asset inserito: ' + ass.id);

        List<NE__AssetItemAttribute__c> assetItemAttrList = new List<NE__AssetItemAttribute__c>();

        NE__AssetItemAttribute__c assetItemAttrRelease = new NE__AssetItemAttribute__c();
        assetItemAttrRelease.Name  = 'release';
        assetItemAttrRelease.NE__Value__c = 'Nexi';
        assetItemAttrRelease.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrRelease);

        NE__AssetItemAttribute__c assetItemAttrModello = new NE__AssetItemAttribute__c();
        assetItemAttrModello.Name  = 'modello';
        assetItemAttrModello.NE__Value__c = 'Nexi';
        assetItemAttrModello.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrModello);

        NE__AssetItemAttribute__c assetItemAttrModalitaCollegamento = new NE__AssetItemAttribute__c();
        assetItemAttrModalitaCollegamento.Name  = 'modalitàCollegamento';
        assetItemAttrModalitaCollegamento.NE__Value__c = 'Nexi';
        assetItemAttrModalitaCollegamento.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrModalitaCollegamento);

        NE__AssetItemAttribute__c assetItemAttrDescrizioneModello = new NE__AssetItemAttribute__c();
        assetItemAttrDescrizioneModello.Name  = 'Descrizione Modello';
        assetItemAttrDescrizioneModello.NE__Value__c = 'Nexi';
        assetItemAttrDescrizioneModello.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrDescrizioneModello);

        NE__AssetItemAttribute__c assetItemAttrDescrizioneRelease = new NE__AssetItemAttribute__c();
        assetItemAttrDescrizioneRelease.Name  = 'Descrizione Release';
        assetItemAttrDescrizioneRelease.NE__Value__c = 'Nexi';
        assetItemAttrDescrizioneRelease.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrDescrizioneRelease);

        NE__AssetItemAttribute__c assetItemAttrDescrizioneConnessione = new NE__AssetItemAttribute__c();
        assetItemAttrDescrizioneConnessione.Name  = 'Descrizione Connessione';
        assetItemAttrDescrizioneConnessione.NE__Value__c = 'Nexi';
        assetItemAttrDescrizioneConnessione.NE__Asset__c = ass.id;
        assetItemAttrList.add(assetItemAttrDescrizioneConnessione);
        
        insert assetItemAttrList;

        List<NE__Order_Item_Attribute__c> orderItemAttrList = new List<NE__Order_Item_Attribute__c>();

        NE__Order_Item_Attribute__c orderItemAttrModello = new NE__Order_Item_Attribute__c();
        orderItemAttrModello.Name              = 'modello';
        orderItemAttrModello.NE__Value__c      = 'Nexi';
        orderItemAttrModello.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrModello);

        NE__Order_Item_Attribute__c orderItemAttrRelease = new NE__Order_Item_Attribute__c();
        orderItemAttrRelease.Name              = 'release';
        orderItemAttrRelease.NE__Value__c      = 'Nexi';
        orderItemAttrRelease.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrRelease);

        NE__Order_Item_Attribute__c orderItemAttrModalitaCollegamento = new NE__Order_Item_Attribute__c();
        orderItemAttrModalitaCollegamento.Name              = 'modalitàCollegamento';
        orderItemAttrModalitaCollegamento.NE__Value__c      = 'Nexi';
        orderItemAttrModalitaCollegamento.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrModalitaCollegamento);

        NE__Order_Item_Attribute__c orderItemAttrDescrizioneModello = new NE__Order_Item_Attribute__c();
        orderItemAttrDescrizioneModello.Name              = 'Descrizione Modello';
        orderItemAttrDescrizioneModello.NE__Value__c      = 'Nexi';
        orderItemAttrDescrizioneModello.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrDescrizioneModello);

        NE__Order_Item_Attribute__c orderItemAttrDescrizioneRelease = new NE__Order_Item_Attribute__c();
        orderItemAttrDescrizioneRelease.Name              = 'Descrizione Release';
        orderItemAttrDescrizioneRelease.NE__Value__c      = 'Nexi';
        orderItemAttrDescrizioneRelease.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrDescrizioneRelease);

        NE__Order_Item_Attribute__c orderItemAttrDescrizioneConnessione = new NE__Order_Item_Attribute__c();
        orderItemAttrDescrizioneConnessione.Name              = 'Descrizione Connessione';
        orderItemAttrDescrizioneConnessione.NE__Value__c      = 'Nexi';
        orderItemAttrDescrizioneConnessione.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrDescrizioneConnessione);

        insert orderItemAttrList;
        
        NE__Lov__c lov = new NE__Lov__c();
        lov.NE__Sub_Type__c= 'TIPOLOGICHE';
        lov.NE__Type__c='TRACKING';
        lov.NE__Value1__c = '98765';
        lov.NE__Value2__c = '98765';
        lov.Name = 'test';
        insert lov;

        OB_DeltaRun_LightService.CompanyInfo  companyInfo = new OB_DeltaRun_LightService.CompanyInfo();
        companyInfo.companyCode         = '98765';
        companyInfo.ABI                 = '98765';
        companyInfo.conventionCode      = '78765';
        companyInfo.activationDate      = Date.newInstance(2006, 3, 16);
        //companyInfo.deactivationdDate   = '';

        OB_DeltaRun_LightService.CompanyInfo companyData = new OB_DeltaRun_LightService.CompanyInfo();
        companyData.companyCode = '98765';
        companyData.ABI = '98765';
        companyData.conventionCode = '78765';
        companyData.activationDate = Date.newInstance(1960, 2, 17);
        //companyData.deactivationdDate = '';

        OB_DeltaRun_LightService.TermInfo termInfo = new OB_DeltaRun_LightService.TermInfo();
        termInfo.modelCode = 'modelCode';
        termInfo.modelDescription = 'modelDescription';
        termInfo.releaseCode = 'releaseCode';
        termInfo.releaseDescription = 'releaseDescription';
        termInfo.connectionCode = 'connectionCode';
        termInfo.connectionDescription = 'connectionDescription';

        OB_DeltaRun_LightService.DeltaRequest request = new OB_DeltaRun_LightService.DeltaRequest();
        request.terminalId = 'terminalId';
        request.clientId = 'clientId';
        request.stabId = 'stabId';
        request.terminalData = termInfo;
        request.companyData = companyData;

        NE__OrderItem__c oi = new NE__OrderItem__c();
        oi.NE__OrderId__c = ord.id;
        oi.NE__Qty__c = 10;
        oi.NE__ProdId__c = prod.id;
        oi.OB_ProposerABI__c = acc.id;
        oi.NE__Account__c = acc.id;
        //oi.NE__Service_Account__c = acc.id;
        //oi.NE__Billing_Account__c = acc.id;
        oi.NE__CatalogItem__c = ci2.id;
        insert oi;

        // NE__Catalog_Item__c cItem = new NE__Catalog_Item__c();
        // cItem.NE__Type__c = 'Product';
        // cItem.NE__ProductId__c = prod2.id;
        // cItem.NE__Item_Header__c = itemHeader.id;
        // cItem.NE__Catalog_Id__c = cat.id;
        // insert cItem;

        NE__Catalog_Item__c ci522 = new NE__Catalog_Item__c();
        ci522.NE__Catalog_Id__c = cat.id;
        ci522.NE__ProductId__c = prod2.id;
        ci522.NE__Type__c = 'Product';
        ci522.NE__Item_Header__c = itemHeader.id;
        insert ci522;

        System.debug('ci522: ' + ci522.id + ' catalog: ' + ci522.NE__Catalog_Id__c + ' ProductId: ' + ci522.NE__ProductId__c + ' Type ' + ci522.NE__Type__c + ' ItemHEader: ' + ci522.NE__Item_Header__c);
        System.debug('prod2.id: ' + prod2.id + ' prod.companycode: ' + prod2.OB_Codice_sfdc__c + ' NE__Item_Header__c: ' + terminalItem.NE__CatalogItem__r.NE__Item_Header__c + ' CompanyCode: ' + request.companyData.companyCode);

        Test.startTest();
        OB_DeltaRun_LightService.updateOrder(request, terminalItem, ass.id, rootAsset.id);
        Test.stopTest();
    }

    @isTest
    public static void updateOrder_Test6()
    {
        Account acc  = new Account(); 
        acc.Name = 'TEST';
        acc.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Bank'].id;
        acc.OB_Employees_Number__c = 'Minore di 10';
        acc.OB_VAT_Not_Present__c = false;
        acc.OB_DescriptionVATNotPresent__c = 'description';
        acc.NE__Fiscal_code__c = 'RSSMRA80A01F205X';
        acc.OB_BypassValidation__c = true;
        acc.OB_Status__c = 'Active'; 
        acc.NE__VAT__c = '12312312312'; 
        acc.OB_ABI__c = '12345';
        insert acc;

        NE__Bundle__c bundle = new NE__Bundle__c();
        bundle.Name = 'test';
        bundle.NE__Configuration_Type__c = 'Free';
        bundle.NE__BaseRecurringCharge__c = 12.00;
        bundle.NE__RecurringChargeFrequency__c = 'Annual';
        bundle.NE__Start_Date__c = System.now();
        bundle.NE__End_Date__c = System.now().addDays(1);
        insert bundle;

        NE__Order_Header__c oh = new NE__Order_Header__c();
        oh.OB_Business_Model_Acquiring__c = 'Bancario'; 
        oh.OB_Business_Model_POS__c = 'Trilaterale Nuovo';
        oh.OB_Main_Process__c = 'Setup';
        insert oh;

        NE__Service_Point__c sp  = new NE__Service_Point__c();
        sp.OB_MCC__c   ='2345';
        sp.NE__City__c = 'Yaounde';
        insert sp;

        NE__Order__c ord = new NE__Order__c();
        ord.NE__Order_Header__c = oh.id;
        ord.NE__AccountId__c = acc.id;
        ord.NE__BillAccId__c = acc.Id;
        ord.NE__ServAccId__c = acc.Id;
        ord.OB_MCCL2__c = '0000';
        ord.OB_GT__c = 'Nexi';
        ord.OB_Service_Point__c = sp.id; 
        ord.OB_FulfilmentStatus__c = 'Sent';        
        insert ord; 

        NE__Item_Header__c itemHeader = new NE__Item_Header__c();
        itemHeader.Name = 'REFERRAL' ;
        insert itemHeader;
        System.debug('item header id '+itemHeader.id);
        NE__Product__c prod = new NE__Product__c();
        prod.OB_Codice_sfdc__c = '00000';
        insert prod;

        NE__Product__c prod2 = new NE__Product__c();
        prod2.OB_Codice_sfdc__c = '98765';
        insert prod2;
        
        NE__Billing_Profile__c bp = new NE__Billing_Profile__c();
        bp.NE__Account__c = acc.id;
        insert bp;

        NE__Catalog__c cat = new NE__Catalog__c();
        cat.Name = 'cat';
        insert cat;

        NE__Catalog_Item__c ci    = new NE__Catalog_Item__c();
        ci.NE__ProductId__c = prod2.id;
        ci.NE__Catalog_Id__c = cat.id;
        ci.NE__Type__c = 'Category'; 
        insert ci;

        NE__Catalog_Item__c ci2 = new NE__Catalog_Item__c();
        ci2.NE__ProductId__c = prod2.id;
        ci2.NE__Catalog_Id__c = cat.id;
        ci2.NE__Type__c = 'Product';
        //ci.NE__Item_Header__c = itemHeader.id;
        insert ci2;

        NE__OrderItem__c terminalItem = New NE__OrderItem__c(NE__Qty__c = 10 ,NE__OrderId__c = ord.id);
        terminalItem.NE__Action__c      = 'Add';
        terminalItem.OB_ShopCode__c     = 'stabId';
        terminalItem.OB_CustomerCode__c = 'clientId';
        terminalItem.OB_TermId__c       = 'terminalId';  
        terminalItem.OB_ProposerABI__c  = acc.id;
        terminalItem.NE__OrderId__c = ord.id;
        terminalItem.NE__ProdId__c = prod.id;
        terminalItem.NE__Account__c = acc.id;
        terminalItem.NE__Catalog__c = cat.id;
        //terminalItem.NE__Service_Account__c = acc.id;
        //terminalItem.NE__Billing_Account__c = acc.id;
        terminalItem.NE__CatalogItem__c = ci.id;
        insert terminalItem;

        // NE__OrderItem__c parentItem = New NE__OrderItem__c(NE__Qty__c = 10 ,NE__OrderId__c = ord.id);
        // parentItem.NE__Action__c      = 'Add';
        // parentItem.OB_ShopCode__c     = 'stabId';
        // parentItem.OB_CustomerCode__c = 'clientId';
        // parentItem.OB_TermId__c       = 'terminalId';  
        // parentItem.OB_ProposerABI__c  = acc.id;
        // parentItem.NE__OrderId__c = ord.id;
        // parentItem.NE__ProdId__c = prod.id;
        // parentItem.NE__CatalogItem__c = ci.id;
        // insert parentItem;

        Asset rootAsset = new Asset();
        rootAsset.NE__CatalogItem__c              = ci.id;
        rootAsset.AccountId                       = acc.id;
        rootAsset.OB_DebitProfId__c               = bp.id;
        rootAsset.OB_ProposerABI__c               = acc.id;
        rootAsset.IsCompetitorProduct             = false;
        rootAsset.NE__Catalog__c = cat.id;
       // ass.IsInternal                      = false;
        rootAsset.Name                            = 'Offerta Personalizzata';
        rootAsset.NE__Action__c                   = 'Change';
        rootAsset.NE__AssetItemEnterpriseId__c    = '123123123';
        rootAsset.NE__BaseOneTimeFee__c           = 0;
        rootAsset.NE__BaseRecurringCharge__c      = 0;
        rootAsset.NE__Billing_Account__c          = acc.id;
        rootAsset.NE__Commitment__c               = false;
        rootAsset.NE__Discount_One_time__c        = 0;
        rootAsset.NE__Discount__c                 = 0;
        rootAsset.NE__Generate_Asset_Item__c      = true;
        rootAsset.NE__Item_Code__c                = '';
        rootAsset.NE__Order_Config__c             = ord.id;
        rootAsset.NE__ProdId__c                   = prod.id;
        rootAsset.NE__RecurringChargeFrequency__c = 'Monthly';
        rootAsset.NE__Remove_from_total__c        = false;
        rootAsset.NE__Service_Account__c          = acc.id;
        rootAsset.NE__Service_Point__c            = sp.id;
        rootAsset.NE__Status__c                   = 'Active';
        rootAsset.OB_enablement__c                = 'N';
        rootAsset.OB_MCCL2__c                     = '0001';
        rootAsset.OB_MCC__c                       = '5200';
        rootAsset.OB_Report_Type__c               = 'Punto Vendita';
        rootAsset.OB_Ro__c                        = 'N';
        rootAsset.OB_Visible__c                   = 'N';
        rootAsset.Quantity                        = 1;
        rootAsset.OB_ShopSign__c                  = '23112';
        rootAsset.OB_ShopCode__c                  = 'stabId';
        rootAsset.OB_CustomerCode__c              = 'clientId';
        rootAsset.OB_TermId__c                    = 'terminalId';
        rootAsset.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Asset' AND DeveloperName = 'Standard' LIMIT 1].id;
        insert rootAsset;

        Asset ass = new Asset();
        //ass.RootAssetId                     = rootAsset.Id;
        ass.ParentId =                      rootAsset.id;
        ass.NE__CatalogItem__c              = ci.id;
        ass.AccountId                       = acc.id;
        ass.OB_DebitProfId__c               = bp.id;
        ass.OB_ProposerABI__c               = acc.id;
        ass.IsCompetitorProduct             = false;
        ass.NE__Catalog__c = cat.id;
       // ass.IsInternal                      = false;
        ass.Name                            = 'Offerta Personalizzata';
        ass.NE__Action__c                   = 'Change';
        ass.NE__AssetItemEnterpriseId__c    = '123123123';
        ass.NE__BaseOneTimeFee__c           = 0;
        ass.NE__BaseRecurringCharge__c      = 0;
        ass.NE__Billing_Account__c          = acc.id;
        ass.NE__Commitment__c               = false;
        ass.NE__Discount_One_time__c        = 0;
        ass.NE__Discount__c                 = 0;
        ass.NE__Generate_Asset_Item__c      = true;
        ass.NE__Item_Code__c                = '';
        ass.NE__Order_Config__c             = ord.id;
        ass.NE__ProdId__c                   = prod.id;
        ass.NE__RecurringChargeFrequency__c = 'Monthly';
        ass.NE__Remove_from_total__c        = false;
        ass.NE__Service_Account__c          = acc.id;
        ass.NE__Service_Point__c            = sp.id;
        ass.NE__Status__c                   = 'Active';
        ass.OB_enablement__c                = 'N';
        ass.OB_MCCL2__c                     = '0001';
        ass.OB_MCC__c                       = '5200';
        ass.OB_Report_Type__c               = 'Punto Vendita';
        ass.OB_Ro__c                        = 'N';
        ass.OB_Visible__c                   = 'N';
        ass.Quantity                        = 1;
        ass.OB_ShopSign__c                  = '23112';
        ass.OB_ShopCode__c                  = 'stabId';
        ass.OB_CustomerCode__c              = 'clientId';
        ass.OB_TermId__c                    = 'terminalId';
        ass.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Asset' AND DeveloperName = 'Standard' LIMIT 1].id;
        insert ass;

        Asset ass2 = new Asset();
        //ass.RootAssetId                     = rootAsset.Id;
        ass2.ParentId =                      rootAsset.id;
        ass2.NE__CatalogItem__c              = ci.id;
        ass2.AccountId                       = acc.id;
        ass2.OB_DebitProfId__c               = bp.id;
        ass2.OB_ProposerABI__c               = acc.id;
        ass2.IsCompetitorProduct             = false;
        ass2.NE__Catalog__c = cat.id;
       // ass.IsInternal                      = false;
        ass2.Name                            = 'Offerta Personalizzata';
        ass2.NE__Action__c                   = 'Change';
        ass2.NE__AssetItemEnterpriseId__c    = ass.id;
        ass2.NE__BaseOneTimeFee__c           = 0;
        ass2.NE__BaseRecurringCharge__c      = 0;
        ass2.NE__Billing_Account__c          = acc.id;
        ass2.NE__Commitment__c               = false;
        ass2.NE__Discount_One_time__c        = 0;
        ass2.NE__Discount__c                 = 0;
        ass2.NE__Generate_Asset_Item__c      = true;
        ass2.NE__Item_Code__c                = '';
        ass2.NE__Order_Config__c             = ord.id;
        ass2.NE__ProdId__c                   = prod.id;
        ass2.NE__RecurringChargeFrequency__c = 'Monthly';
        ass2.NE__Remove_from_total__c        = false;
        ass2.NE__Service_Account__c          = acc.id;
        ass2.NE__Service_Point__c            = sp.id;
        ass2.NE__Status__c                   = 'Active';
        ass2.OB_enablement__c                = 'N';
        ass2.OB_MCCL2__c                     = '0001';
        ass2.OB_MCC__c                       = '5200';
        ass2.OB_Report_Type__c               = 'Punto Vendita';
        ass2.OB_Ro__c                        = 'N';
        ass2.OB_Visible__c                   = 'N';
        ass2.Quantity                        = 1;
        ass2.OB_ShopSign__c                  = '23112';
        ass2.OB_ShopCode__c                  = 'stabId';
        ass2.OB_CustomerCode__c              = 'clientId';
        ass2.OB_TermId__c                    = 'terminalId';
        ass2.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Asset' AND DeveloperName = 'Standard' LIMIT 1].id;
        insert ass2;

        System.debug('Asset inserito: ' + ass.id);

        List<NE__AssetItemAttribute__c> assetItemAttrList = new List<NE__AssetItemAttribute__c>();

        NE__AssetItemAttribute__c assetItemAttrRelease = new NE__AssetItemAttribute__c();
        assetItemAttrRelease.Name  = 'release';
        assetItemAttrRelease.NE__Value__c = 'Nexi';
        assetItemAttrRelease.NE__Asset__c = ass2.id;
        assetItemAttrList.add(assetItemAttrRelease);

        NE__AssetItemAttribute__c assetItemAttrModello = new NE__AssetItemAttribute__c();
        assetItemAttrModello.Name  = 'modello';
        assetItemAttrModello.NE__Value__c = 'Nexi';
        assetItemAttrModello.NE__Asset__c = ass2.id;
        assetItemAttrList.add(assetItemAttrModello);

        NE__AssetItemAttribute__c assetItemAttrModalitaCollegamento = new NE__AssetItemAttribute__c();
        assetItemAttrModalitaCollegamento.Name  = 'modalitàCollegamento';
        assetItemAttrModalitaCollegamento.NE__Value__c = 'Nexi';
        assetItemAttrModalitaCollegamento.NE__Asset__c = ass2.id;
        assetItemAttrList.add(assetItemAttrModalitaCollegamento);

        NE__AssetItemAttribute__c assetItemAttrDescrizioneModello = new NE__AssetItemAttribute__c();
        assetItemAttrDescrizioneModello.Name  = 'Descrizione Modello';
        assetItemAttrDescrizioneModello.NE__Value__c = 'Nexi';
        assetItemAttrDescrizioneModello.NE__Asset__c = ass2.id;
        assetItemAttrList.add(assetItemAttrDescrizioneModello);

        NE__AssetItemAttribute__c assetItemAttrDescrizioneRelease = new NE__AssetItemAttribute__c();
        assetItemAttrDescrizioneRelease.Name  = 'Descrizione Release';
        assetItemAttrDescrizioneRelease.NE__Value__c = 'Nexi';
        assetItemAttrDescrizioneRelease.NE__Asset__c = ass2.id;
        assetItemAttrList.add(assetItemAttrDescrizioneRelease);

        NE__AssetItemAttribute__c assetItemAttrDescrizioneConnessione = new NE__AssetItemAttribute__c();
        assetItemAttrDescrizioneConnessione.Name  = 'Descrizione Connessione';
        assetItemAttrDescrizioneConnessione.NE__Value__c = 'Nexi';
        assetItemAttrDescrizioneConnessione.NE__Asset__c = ass2.id;
        assetItemAttrList.add(assetItemAttrDescrizioneConnessione);
        
        insert assetItemAttrList;

        List<NE__Order_Item_Attribute__c> orderItemAttrList = new List<NE__Order_Item_Attribute__c>();

        NE__Order_Item_Attribute__c orderItemAttrModello = new NE__Order_Item_Attribute__c();
        orderItemAttrModello.Name              = 'modello';
        orderItemAttrModello.NE__Value__c      = 'Nexi';
        orderItemAttrModello.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrModello);

        NE__Order_Item_Attribute__c orderItemAttrRelease = new NE__Order_Item_Attribute__c();
        orderItemAttrRelease.Name              = 'release';
        orderItemAttrRelease.NE__Value__c      = 'Nexi';
        orderItemAttrRelease.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrRelease);

        NE__Order_Item_Attribute__c orderItemAttrModalitaCollegamento = new NE__Order_Item_Attribute__c();
        orderItemAttrModalitaCollegamento.Name              = 'modalitàCollegamento';
        orderItemAttrModalitaCollegamento.NE__Value__c      = 'Nexi';
        orderItemAttrModalitaCollegamento.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrModalitaCollegamento);

        NE__Order_Item_Attribute__c orderItemAttrDescrizioneModello = new NE__Order_Item_Attribute__c();
        orderItemAttrDescrizioneModello.Name              = 'Descrizione Modello';
        orderItemAttrDescrizioneModello.NE__Value__c      = 'Nexi';
        orderItemAttrDescrizioneModello.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrDescrizioneModello);

        NE__Order_Item_Attribute__c orderItemAttrDescrizioneRelease = new NE__Order_Item_Attribute__c();
        orderItemAttrDescrizioneRelease.Name              = 'Descrizione Release';
        orderItemAttrDescrizioneRelease.NE__Value__c      = 'Nexi';
        orderItemAttrDescrizioneRelease.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrDescrizioneRelease);

        NE__Order_Item_Attribute__c orderItemAttrDescrizioneConnessione = new NE__Order_Item_Attribute__c();
        orderItemAttrDescrizioneConnessione.Name              = 'Descrizione Connessione';
        orderItemAttrDescrizioneConnessione.NE__Value__c      = 'Nexi';
        orderItemAttrDescrizioneConnessione.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrDescrizioneConnessione);

        insert orderItemAttrList;
        
        NE__Lov__c lov = new NE__Lov__c();
        lov.NE__Sub_Type__c= 'TIPOLOGICHE';
        lov.NE__Type__c='TRACKING';
        lov.NE__Value1__c = '98765';
        lov.NE__Value2__c = '98765';
        lov.Name = 'test';
        insert lov;

        OB_DeltaRun_LightService.CompanyInfo  companyInfo = new OB_DeltaRun_LightService.CompanyInfo();
        companyInfo.companyCode         = '98765';
        companyInfo.ABI                 = '98765';
        companyInfo.conventionCode      = '78765';
        companyInfo.activationDate      = Date.newInstance(2006, 3, 16);
        //companyInfo.deactivationdDate   = '';

        OB_DeltaRun_LightService.CompanyInfo companyData = new OB_DeltaRun_LightService.CompanyInfo();
        companyData.companyCode = '98765';
        companyData.ABI = '98765';
        companyData.conventionCode = '78765';
        companyData.activationDate = Date.newInstance(1960, 2, 17);
        //companyData.deactivationdDate = '';

        OB_DeltaRun_LightService.TermInfo termInfo = new OB_DeltaRun_LightService.TermInfo();
        termInfo.modelCode = 'modelCode';
        termInfo.modelDescription = 'modelDescription';
        termInfo.releaseCode = 'releaseCode';
        termInfo.releaseDescription = 'releaseDescription';
        termInfo.connectionCode = 'connectionCode';
        termInfo.connectionDescription = 'connectionDescription';

        OB_DeltaRun_LightService.DeltaRequest request = new OB_DeltaRun_LightService.DeltaRequest();
        request.terminalId = 'terminalId';
        request.clientId = 'clientId';
        request.stabId = 'stabId';
        request.terminalData = termInfo;
        request.companyData = companyData;

        NE__OrderItem__c oi = new NE__OrderItem__c();
        oi.NE__OrderId__c = ord.id;
        oi.NE__Qty__c = 10;
        oi.NE__ProdId__c = prod.id;
        oi.OB_ProposerABI__c = acc.id;
        oi.NE__Account__c = acc.id;
        //oi.NE__Service_Account__c = acc.id;
        //oi.NE__Billing_Account__c = acc.id;
        oi.NE__CatalogItem__c = ci2.id;
        insert oi;

        // NE__Catalog_Item__c cItem = new NE__Catalog_Item__c();
        // cItem.NE__Type__c = 'Product';
        // cItem.NE__ProductId__c = prod2.id;
        // cItem.NE__Item_Header__c = itemHeader.id;
        // cItem.NE__Catalog_Id__c = cat.id;
        // insert cItem;

        // NE__Catalog_Item__c ci522 = new NE__Catalog_Item__c();
        // ci522.NE__Catalog_Id__c = cat.id;
        // ci522.NE__ProductId__c = prod2.id;
        // ci522.NE__Type__c = 'Product';
        // //ci522.NE__Item_Header__c = itemHeader.id;
        // insert ci522;

        Test.startTest();
        OB_DeltaRun_LightService.updateOrder(request, terminalItem, ass.id, rootAsset.id);
        Test.stopTest();
    }

    @isTest
    public static void updateAsset_Test3() {
        
        Account acc  = new Account(); 
        acc.Name = 'TEST';
        acc.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Bank'].id;
        acc.OB_Employees_Number__c = 'Minore di 10';
        acc.OB_VAT_Not_Present__c = false;
        acc.OB_DescriptionVATNotPresent__c = 'description';
        acc.NE__Fiscal_code__c = 'RSSMRA80A01F205X';
        acc.OB_BypassValidation__c = true;
        acc.OB_Status__c = 'Active'; 
        acc.NE__VAT__c = '12312312312'; 
        acc.OB_ABI__c = '12345';
        insert acc;

        NE__Bundle__c bundle = new NE__Bundle__c();
        bundle.Name = 'test';
        bundle.NE__Configuration_Type__c = 'Free';
        bundle.NE__BaseRecurringCharge__c = 12.00;
        bundle.NE__RecurringChargeFrequency__c = 'Annual';
        bundle.NE__Start_Date__c = System.now();
        bundle.NE__End_Date__c = System.now().addDays(1);
        insert bundle;

        NE__Order_Header__c oh = new NE__Order_Header__c();
        oh.OB_Business_Model_Acquiring__c = 'Bancario'; 
        oh.OB_Business_Model_POS__c = 'Trilaterale Nuovo';
        oh.OB_Main_Process__c = 'Setup';
        insert oh;

        NE__Service_Point__c sp  = new NE__Service_Point__c();
        sp.OB_MCC__c   ='2345';
        sp.NE__City__c = 'Yaounde';
        insert sp;

        NE__Order__c ord = new NE__Order__c();
        ord.NE__Order_Header__c = oh.id;
        ord.NE__AccountId__c = acc.id;
        ord.NE__BillAccId__c = acc.Id;
        ord.NE__ServAccId__c = acc.Id;
        ord.OB_MCCL2__c = '0000';
        ord.OB_GT__c = 'Nexi';
        ord.OB_Service_Point__c = sp.id; 
        ord.OB_FulfilmentStatus__c = 'Sent';        
        insert ord; 

        NE__Item_Header__c itemHeader = new NE__Item_Header__c();
        itemHeader.Name = 'REFERRAL' ;
        insert itemHeader;
        System.debug('item header id '+itemHeader.id);
        NE__Product__c prod = new NE__Product__c();
        prod.OB_Codice_sfdc__c = '00000';
        insert prod;

        NE__Product__c prod2 = new NE__Product__c();
        prod2.OB_Codice_sfdc__c = '98765';
        insert prod2;
        
        NE__Billing_Profile__c bp = new NE__Billing_Profile__c();
        bp.NE__Account__c = acc.id;
        insert bp;

        NE__Catalog__c cat = new NE__Catalog__c();
        cat.Name = 'cat';
        insert cat;

        NE__Catalog_Item__c ci    = new NE__Catalog_Item__c();
        ci.NE__ProductId__c = prod.id;
        ci.NE__Catalog_Id__c = cat.id;
        ci.NE__Type__c = 'Category'; 
        insert ci;

        NE__Catalog_Item__c ci2 = new NE__Catalog_Item__c();
        ci2.NE__ProductId__c = prod2.id;
        ci2.NE__Catalog_Id__c = cat.id;
        ci2.NE__Type__c = 'Product';
        //ci.NE__Item_Header__c = itemHeader.id;
        insert ci2;

        NE__OrderItem__c terminalItem = New NE__OrderItem__c(NE__Qty__c = 10 ,NE__OrderId__c = ord.id);
        terminalItem.NE__Action__c      = 'Add';
        terminalItem.OB_ShopCode__c     = 'stabId';
        terminalItem.OB_CustomerCode__c = 'clientId';
        terminalItem.OB_TermId__c       = 'terminalId';  
        terminalItem.OB_ProposerABI__c  = acc.id;
        terminalItem.NE__OrderId__c = ord.id;
        terminalItem.NE__ProdId__c = prod.id;
        terminalItem.NE__Account__c = acc.id;
        terminalItem.NE__Catalog__c = cat.id;
        //terminalItem.NE__Service_Account__c = acc.id;
        //terminalItem.NE__Billing_Account__c = acc.id;
        terminalItem.NE__CatalogItem__c = ci.id;
        insert terminalItem;

        // NE__OrderItem__c parentItem = New NE__OrderItem__c(NE__Qty__c = 10 ,NE__OrderId__c = ord.id);
        // parentItem.NE__Action__c      = 'Add';
        // parentItem.OB_ShopCode__c     = 'stabId';
        // parentItem.OB_CustomerCode__c = 'clientId';
        // parentItem.OB_TermId__c       = 'terminalId';  
        // parentItem.OB_ProposerABI__c  = acc.id;
        // parentItem.NE__OrderId__c = ord.id;
        // parentItem.NE__ProdId__c = prod.id;
        // parentItem.NE__CatalogItem__c = ci.id;
        // insert parentItem;

        Asset rootAsset = new Asset();
        rootAsset.NE__CatalogItem__c              = ci.id;
        rootAsset.AccountId                       = acc.id;
        rootAsset.OB_DebitProfId__c               = bp.id;
        rootAsset.OB_ProposerABI__c               = acc.id;
        rootAsset.IsCompetitorProduct             = false;
        rootAsset.NE__Catalog__c = cat.id;
       // ass.IsInternal                      = false;
        rootAsset.Name                            = 'Offerta Personalizzata';
        rootAsset.NE__Action__c                   = 'Change';
        rootAsset.NE__AssetItemEnterpriseId__c    = '123123123';
        rootAsset.NE__BaseOneTimeFee__c           = 0;
        rootAsset.NE__BaseRecurringCharge__c      = 0;
        rootAsset.NE__Billing_Account__c          = acc.id;
        rootAsset.NE__Commitment__c               = false;
        rootAsset.NE__Discount_One_time__c        = 0;
        rootAsset.NE__Discount__c                 = 0;
        rootAsset.NE__Generate_Asset_Item__c      = true;
        rootAsset.NE__Item_Code__c                = '';
        rootAsset.NE__Order_Config__c             = ord.id;
        rootAsset.NE__ProdId__c                   = prod.id;
        rootAsset.NE__RecurringChargeFrequency__c = 'Monthly';
        rootAsset.NE__Remove_from_total__c        = false;
        rootAsset.NE__Service_Account__c          = acc.id;
        rootAsset.NE__Service_Point__c            = sp.id;
        rootAsset.NE__Status__c                   = 'Active';
        rootAsset.OB_enablement__c                = 'N';
        rootAsset.OB_MCCL2__c                     = '0001';
        rootAsset.OB_MCC__c                       = '5200';
        rootAsset.OB_Report_Type__c               = 'Punto Vendita';
        rootAsset.OB_Ro__c                        = 'N';
        rootAsset.OB_Visible__c                   = 'N';
        rootAsset.Quantity                        = 1;
        rootAsset.OB_ShopSign__c                  = '23112';
        rootAsset.OB_ShopCode__c                  = 'stabId';
        rootAsset.OB_CustomerCode__c              = 'clientId';
        rootAsset.OB_TermId__c                    = 'terminalId';
        rootAsset.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Asset' AND DeveloperName = 'Standard' LIMIT 1].id;
        insert rootAsset;

        Asset ass = new Asset();
        //ass.RootAssetId                     = rootAsset.Id;
        ass.ParentId =                      rootAsset.id;
        ass.NE__CatalogItem__c              = ci.id;
        ass.AccountId                       = acc.id;
        ass.OB_DebitProfId__c               = bp.id;
        ass.OB_ProposerABI__c               = acc.id;
        ass.IsCompetitorProduct             = false;
        ass.NE__Catalog__c = cat.id;
       // ass.IsInternal                      = false;
        ass.Name                            = 'Offerta Personalizzata';
        ass.NE__Action__c                   = 'Change';
        ass.NE__AssetItemEnterpriseId__c    = '123123123';
        ass.NE__BaseOneTimeFee__c           = 0;
        ass.NE__BaseRecurringCharge__c      = 0;
        ass.NE__Billing_Account__c          = acc.id;
        ass.NE__Commitment__c               = false;
        ass.NE__Discount_One_time__c        = 0;
        ass.NE__Discount__c                 = 0;
        ass.NE__Generate_Asset_Item__c      = true;
        ass.NE__Item_Code__c                = '';
        ass.NE__Order_Config__c             = ord.id;
        ass.NE__ProdId__c                   = prod2.id;
        ass.NE__RecurringChargeFrequency__c = 'Monthly';
        ass.NE__Remove_from_total__c        = false;
        ass.NE__Service_Account__c          = acc.id;
        ass.NE__Service_Point__c            = sp.id;
        ass.NE__Status__c                   = 'Active';
        ass.OB_enablement__c                = 'N';
        ass.OB_MCCL2__c                     = '0001';
        ass.OB_MCC__c                       = '5200';
        ass.OB_Report_Type__c               = 'Punto Vendita';
        ass.OB_Ro__c                        = 'N';
        ass.OB_Visible__c                   = 'N';
        ass.Quantity                        = 1;
        ass.OB_ShopSign__c                  = '23112';
        ass.OB_ShopCode__c                  = 'stabId';
        ass.OB_CustomerCode__c              = 'clientId';
        ass.OB_TermId__c                    = 'terminalId';
        ass.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Asset' AND DeveloperName = 'Standard' LIMIT 1].id;
        insert ass;

        Asset ass2 = new Asset();
        //ass.RootAssetId                     = rootAsset.Id;
        ass2.ParentId =                      rootAsset.id;
        ass2.NE__CatalogItem__c              = ci.id;
        ass2.AccountId                       = acc.id;
        ass2.OB_DebitProfId__c               = bp.id;
        ass2.OB_ProposerABI__c               = acc.id;
        ass2.IsCompetitorProduct             = false;
        ass2.NE__Catalog__c = cat.id;
       // ass.IsInternal                      = false;
        ass2.NE__ProdId__c                   = prod2.id;
        ass2.Name                            = 'Offerta Personalizzata';
        ass2.NE__Action__c                   = 'Change';
        ass2.NE__AssetItemEnterpriseId__c    = ass.id;
        ass2.NE__BaseOneTimeFee__c           = 0;
        ass2.NE__BaseRecurringCharge__c      = 0;
        ass2.NE__Billing_Account__c          = acc.id;
        ass2.NE__Commitment__c               = false;
        ass2.NE__Discount_One_time__c        = 0;
        ass2.NE__Discount__c                 = 0;
        ass2.NE__Generate_Asset_Item__c      = true;
        ass2.NE__Item_Code__c                = '';
        ass2.NE__Order_Config__c             = ord.id;
        ass2.NE__ProdId__c                   = prod.id;
        ass2.NE__RecurringChargeFrequency__c = 'Monthly';
        ass2.NE__Remove_from_total__c        = false;
        ass2.NE__Service_Account__c          = acc.id;
        ass2.NE__Service_Point__c            = sp.id;
        ass2.NE__Status__c                   = 'Active';
        ass2.OB_enablement__c                = 'N';
        ass2.OB_MCCL2__c                     = '0001';
        ass2.OB_MCC__c                       = '5200';
        ass2.OB_Report_Type__c               = 'Punto Vendita';
        ass2.OB_Ro__c                        = 'N';
        ass2.OB_Visible__c                   = 'N';
        ass2.Quantity                        = 1;
        ass2.OB_ShopSign__c                  = '23112';
        ass2.OB_ShopCode__c                  = 'stabId';
        ass2.OB_CustomerCode__c              = 'clientId';
        ass2.OB_TermId__c                    = 'terminalId';
        ass2.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Asset' AND DeveloperName = 'Standard' LIMIT 1].id;
        insert ass2;

        System.debug('Asset inserito: ' + ass.id);

        List<NE__AssetItemAttribute__c> assetItemAttrList = new List<NE__AssetItemAttribute__c>();

        NE__AssetItemAttribute__c assetItemAttrRelease = new NE__AssetItemAttribute__c();
        assetItemAttrRelease.Name  = 'release';
        assetItemAttrRelease.NE__Value__c = 'Nexi';
        assetItemAttrRelease.NE__Asset__c = ass2.id;
        assetItemAttrList.add(assetItemAttrRelease);

        NE__AssetItemAttribute__c assetItemAttrModello = new NE__AssetItemAttribute__c();
        assetItemAttrModello.Name  = 'modello';
        assetItemAttrModello.NE__Value__c = 'Nexi';
        assetItemAttrModello.NE__Asset__c = ass2.id;
        assetItemAttrList.add(assetItemAttrModello);

        NE__AssetItemAttribute__c assetItemAttrModalitaCollegamento = new NE__AssetItemAttribute__c();
        assetItemAttrModalitaCollegamento.Name  = 'modalitàCollegamento';
        assetItemAttrModalitaCollegamento.NE__Value__c = 'Nexi';
        assetItemAttrModalitaCollegamento.NE__Asset__c = ass2.id;
        assetItemAttrList.add(assetItemAttrModalitaCollegamento);

        NE__AssetItemAttribute__c assetItemAttrDescrizioneModello = new NE__AssetItemAttribute__c();
        assetItemAttrDescrizioneModello.Name  = 'Descrizione Modello';
        assetItemAttrDescrizioneModello.NE__Value__c = 'Nexi';
        assetItemAttrDescrizioneModello.NE__Asset__c = ass2.id;
        assetItemAttrList.add(assetItemAttrDescrizioneModello);

        NE__AssetItemAttribute__c assetItemAttrDescrizioneRelease = new NE__AssetItemAttribute__c();
        assetItemAttrDescrizioneRelease.Name  = 'Descrizione Release';
        assetItemAttrDescrizioneRelease.NE__Value__c = 'Nexi';
        assetItemAttrDescrizioneRelease.NE__Asset__c = ass2.id;
        assetItemAttrList.add(assetItemAttrDescrizioneRelease);

        NE__AssetItemAttribute__c assetItemAttrDescrizioneConnessione = new NE__AssetItemAttribute__c();
        assetItemAttrDescrizioneConnessione.Name  = 'Descrizione Connessione';
        assetItemAttrDescrizioneConnessione.NE__Value__c = 'Nexi';
        assetItemAttrDescrizioneConnessione.NE__Asset__c = ass2.id;
        assetItemAttrList.add(assetItemAttrDescrizioneConnessione);
        
        insert assetItemAttrList;

        List<NE__Order_Item_Attribute__c> orderItemAttrList = new List<NE__Order_Item_Attribute__c>();

        NE__Order_Item_Attribute__c orderItemAttrModello = new NE__Order_Item_Attribute__c();
        orderItemAttrModello.Name              = 'modello';
        orderItemAttrModello.NE__Value__c      = 'Nexi';
        orderItemAttrModello.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrModello);

        NE__Order_Item_Attribute__c orderItemAttrRelease = new NE__Order_Item_Attribute__c();
        orderItemAttrRelease.Name              = 'release';
        orderItemAttrRelease.NE__Value__c      = 'Nexi';
        orderItemAttrRelease.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrRelease);

        NE__Order_Item_Attribute__c orderItemAttrModalitaCollegamento = new NE__Order_Item_Attribute__c();
        orderItemAttrModalitaCollegamento.Name              = 'modalitàCollegamento';
        orderItemAttrModalitaCollegamento.NE__Value__c      = 'Nexi';
        orderItemAttrModalitaCollegamento.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrModalitaCollegamento);

        NE__Order_Item_Attribute__c orderItemAttrDescrizioneModello = new NE__Order_Item_Attribute__c();
        orderItemAttrDescrizioneModello.Name              = 'Descrizione Modello';
        orderItemAttrDescrizioneModello.NE__Value__c      = 'Nexi';
        orderItemAttrDescrizioneModello.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrDescrizioneModello);

        NE__Order_Item_Attribute__c orderItemAttrDescrizioneRelease = new NE__Order_Item_Attribute__c();
        orderItemAttrDescrizioneRelease.Name              = 'Descrizione Release';
        orderItemAttrDescrizioneRelease.NE__Value__c      = 'Nexi';
        orderItemAttrDescrizioneRelease.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrDescrizioneRelease);

        NE__Order_Item_Attribute__c orderItemAttrDescrizioneConnessione = new NE__Order_Item_Attribute__c();
        orderItemAttrDescrizioneConnessione.Name              = 'Descrizione Connessione';
        orderItemAttrDescrizioneConnessione.NE__Value__c      = 'Nexi';
        orderItemAttrDescrizioneConnessione.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrDescrizioneConnessione);

        insert orderItemAttrList;
        
        NE__Lov__c lov = new NE__Lov__c();
        lov.NE__Sub_Type__c= 'TIPOLOGICHE';
        lov.NE__Type__c='TRACKING';
        lov.NE__Value1__c = '98765';
        lov.NE__Value2__c = '98765';
        lov.Name = 'test';
        insert lov;

        OB_DeltaRun_LightService.CompanyInfo  companyInfo = new OB_DeltaRun_LightService.CompanyInfo();
        companyInfo.companyCode         = '98765';
        companyInfo.ABI                 = '98765';
        companyInfo.conventionCode      = '78765';
        companyInfo.activationDate      = Date.newInstance(2006, 3, 16);
        //companyInfo.deactivationdDate   = '';

        OB_DeltaRun_LightService.CompanyInfo companyData = new OB_DeltaRun_LightService.CompanyInfo();
        companyData.companyCode = '98765';
        companyData.ABI = '98765';
        companyData.conventionCode = '78765';
        companyData.activationDate = Date.newInstance(1960, 2, 17);
        //companyData.deactivationdDate = '';

        OB_DeltaRun_LightService.TermInfo termInfo = new OB_DeltaRun_LightService.TermInfo();
        termInfo.modelCode = 'modelCode';
        termInfo.modelDescription = 'modelDescription';
        termInfo.releaseCode = 'releaseCode';
        termInfo.releaseDescription = 'releaseDescription';
        termInfo.connectionCode = 'connectionCode';
        termInfo.connectionDescription = 'connectionDescription';

        OB_DeltaRun_LightService.DeltaRequest request = new OB_DeltaRun_LightService.DeltaRequest();
        request.terminalId = 'terminalId';
        request.clientId = 'clientId';
        request.stabId = 'stabId';
        request.terminalData = termInfo;
        request.companyData = companyData;

        NE__OrderItem__c oi = new NE__OrderItem__c();
        oi.NE__OrderId__c = ord.id;
        oi.NE__Qty__c = 10;
        oi.NE__ProdId__c = prod.id;
        oi.OB_ProposerABI__c = acc.id;
        oi.NE__Account__c = acc.id;
        //oi.NE__Service_Account__c = acc.id;
        //oi.NE__Billing_Account__c = acc.id;
        oi.NE__CatalogItem__c = ci2.id;
        insert oi;

        NE__DynamicPropertyDefinition__c dpd = new NE__DynamicPropertyDefinition__c();
        insert dpd;
        NE__Family__c f = new NE__Family__c();
        insert f;
        NE__ProductFamily__c pf = new NE__ProductFamily__c();
        pf.NE__ProdId__c = prod.id;
        pf.NE__FamilyId__c = f.id;
        insert pf;
        NE__ProductFamily__c pf2 = new NE__ProductFamily__c();
        pf2.NE__ProdId__c = prod2.id;
        pf2.NE__FamilyId__c = f.id;
        insert pf2;

        NE__ProductFamilyProperty__c pfp = new NE__ProductFamilyProperty__c();
        pfp.NE__FamilyId__c = f.id;
        pfp.NE__PropId__c = dpd.id;
        insert pfp;
        NE__ProductFamilyProperty__c pfp2 = new NE__ProductFamilyProperty__c();
        pfp2.NE__FamilyId__c = f.id;
        pfp2.NE__PropId__c = dpd.id;
        insert pfp2;

        Test.StartTest();
        OB_DeltaRun_LightService.updateAsset(request, ass);
        Test.StopTest();
    }

    @isTest
    public static void updateAsset_Test4() {
        
        Account acc  = new Account(); 
        acc.Name = 'TEST';
        acc.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Bank'].id;
        acc.OB_Employees_Number__c = 'Minore di 10';
        acc.OB_VAT_Not_Present__c = false;
        acc.OB_DescriptionVATNotPresent__c = 'description';
        acc.NE__Fiscal_code__c = 'RSSMRA80A01F205X';
        acc.OB_BypassValidation__c = true;
        acc.OB_Status__c = 'Active'; 
        acc.NE__VAT__c = '12312312312'; 
        acc.OB_ABI__c = '12345';
        insert acc;

        NE__Bundle__c bundle = new NE__Bundle__c();
        bundle.Name = 'test';
        bundle.NE__Configuration_Type__c = 'Free';
        bundle.NE__BaseRecurringCharge__c = 12.00;
        bundle.NE__RecurringChargeFrequency__c = 'Annual';
        bundle.NE__Start_Date__c = System.now();
        bundle.NE__End_Date__c = System.now().addDays(1);
        insert bundle;

        NE__Order_Header__c oh = new NE__Order_Header__c();
        oh.OB_Business_Model_Acquiring__c = 'Bancario'; 
        oh.OB_Business_Model_POS__c = 'Trilaterale Nuovo';
        oh.OB_Main_Process__c = 'Setup';
        insert oh;

        NE__Service_Point__c sp  = new NE__Service_Point__c();
        sp.OB_MCC__c   ='2345';
        sp.NE__City__c = 'Yaounde';
        insert sp;

        NE__Order__c ord = new NE__Order__c();
        ord.NE__Order_Header__c = oh.id;
        ord.NE__AccountId__c = acc.id;
        ord.NE__BillAccId__c = acc.Id;
        ord.NE__ServAccId__c = acc.Id;
        ord.OB_MCCL2__c = '0000';
        ord.OB_GT__c = 'Nexi';
        ord.OB_Service_Point__c = sp.id; 
        ord.OB_FulfilmentStatus__c = 'Sent';        
        insert ord; 

        NE__Item_Header__c itemHeader = new NE__Item_Header__c();
        itemHeader.Name = 'REFERRAL' ;
        insert itemHeader;
        System.debug('item header id '+itemHeader.id);
        NE__Product__c prod = new NE__Product__c();
        prod.OB_Codice_sfdc__c = '98765';
        insert prod;

        NE__Product__c prod2 = new NE__Product__c();
        prod2.OB_Codice_sfdc__c = '98765';
        insert prod2;
        
        NE__Billing_Profile__c bp = new NE__Billing_Profile__c();
        bp.NE__Account__c = acc.id;
        insert bp;

        NE__Catalog__c cat = new NE__Catalog__c();
        cat.Name = 'cat';
        insert cat;

        NE__Catalog_Item__c ci    = new NE__Catalog_Item__c();
        ci.NE__ProductId__c = prod.id;
        ci.NE__Catalog_Id__c = cat.id;
        ci.NE__Type__c = 'Category'; 
        insert ci;

        NE__Catalog_Item__c ci2 = new NE__Catalog_Item__c();
        ci2.NE__ProductId__c = prod2.id;
        ci2.NE__Catalog_Id__c = cat.id;
        ci2.NE__Type__c = 'Product';
        //ci.NE__Item_Header__c = itemHeader.id;
        insert ci2;

        NE__OrderItem__c terminalItem = New NE__OrderItem__c(NE__Qty__c = 10 ,NE__OrderId__c = ord.id);
        terminalItem.NE__Action__c      = 'Add';
        terminalItem.OB_ShopCode__c     = 'stabId';
        terminalItem.OB_CustomerCode__c = 'clientId';
        terminalItem.OB_TermId__c       = 'terminalId';  
        terminalItem.OB_ProposerABI__c  = acc.id;
        terminalItem.NE__OrderId__c = ord.id;
        terminalItem.NE__ProdId__c = prod2.id;
        terminalItem.NE__Account__c = acc.id;
        terminalItem.NE__Catalog__c = cat.id;
        //terminalItem.NE__Service_Account__c = acc.id;
        //terminalItem.NE__Billing_Account__c = acc.id;
        terminalItem.NE__CatalogItem__c = ci.id;
        insert terminalItem;

        // NE__OrderItem__c parentItem = New NE__OrderItem__c(NE__Qty__c = 10 ,NE__OrderId__c = ord.id);
        // parentItem.NE__Action__c      = 'Add';
        // parentItem.OB_ShopCode__c     = 'stabId';
        // parentItem.OB_CustomerCode__c = 'clientId';
        // parentItem.OB_TermId__c       = 'terminalId';  
        // parentItem.OB_ProposerABI__c  = acc.id;
        // parentItem.NE__OrderId__c = ord.id;
        // parentItem.NE__ProdId__c = prod.id;
        // parentItem.NE__CatalogItem__c = ci.id;
        // insert parentItem;

        Asset rootAsset = new Asset();
        rootAsset.NE__CatalogItem__c              = ci.id;
        rootAsset.AccountId                       = acc.id;
        rootAsset.OB_DebitProfId__c               = bp.id;
        rootAsset.OB_ProposerABI__c               = acc.id;
        rootAsset.IsCompetitorProduct             = false;
        rootAsset.NE__Catalog__c = cat.id;
       // ass.IsInternal                      = false;
        rootAsset.Name                            = 'Offerta Personalizzata';
        rootAsset.NE__Action__c                   = 'Change';
        rootAsset.NE__AssetItemEnterpriseId__c    = '123123123';
        rootAsset.NE__BaseOneTimeFee__c           = 0;
        rootAsset.NE__BaseRecurringCharge__c      = 0;
        rootAsset.NE__Billing_Account__c          = acc.id;
        rootAsset.NE__Commitment__c               = false;
        rootAsset.NE__Discount_One_time__c        = 0;
        rootAsset.NE__Discount__c                 = 0;
        rootAsset.NE__Generate_Asset_Item__c      = true;
        rootAsset.NE__Item_Code__c                = '';
        rootAsset.NE__Order_Config__c             = ord.id;
        rootAsset.NE__ProdId__c                   = prod2.id;
        rootAsset.NE__RecurringChargeFrequency__c = 'Monthly';
        rootAsset.NE__Remove_from_total__c        = false;
        rootAsset.NE__Service_Account__c          = acc.id;
        rootAsset.NE__Service_Point__c            = sp.id;
        rootAsset.NE__Status__c                   = 'Active';
        rootAsset.OB_enablement__c                = 'N';
        rootAsset.OB_MCCL2__c                     = '0001';
        rootAsset.OB_MCC__c                       = '5200';
        rootAsset.OB_Report_Type__c               = 'Punto Vendita';
        rootAsset.OB_Ro__c                        = 'N';
        rootAsset.OB_Visible__c                   = 'N';
        rootAsset.Quantity                        = 1;
        rootAsset.OB_ShopSign__c                  = '23112';
        rootAsset.OB_ShopCode__c                  = 'stabId';
        rootAsset.OB_CustomerCode__c              = 'clientId';
        rootAsset.OB_TermId__c                    = 'terminalId';
        rootAsset.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Asset' AND DeveloperName = 'Standard' LIMIT 1].id;
        insert rootAsset;

        Asset ass = new Asset();
        //ass.RootAssetId                     = rootAsset.Id;
        ass.ParentId =                      rootAsset.id;
        ass.NE__CatalogItem__c              = ci.id;
        ass.AccountId                       = acc.id;
        ass.OB_DebitProfId__c               = bp.id;
        ass.OB_ProposerABI__c               = acc.id;
        ass.IsCompetitorProduct             = false;
        ass.NE__Catalog__c = cat.id;
       // ass.IsInternal                      = false;
        ass.Name                            = 'Offerta Personalizzata';
        ass.NE__Action__c                   = 'Change';
        ass.NE__AssetItemEnterpriseId__c    = '123123123';
        ass.NE__BaseOneTimeFee__c           = 0;
        ass.NE__BaseRecurringCharge__c      = 0;
        ass.NE__Billing_Account__c          = acc.id;
        ass.NE__Commitment__c               = false;
        ass.NE__Discount_One_time__c        = 0;
        ass.NE__Discount__c                 = 0;
        ass.NE__Generate_Asset_Item__c      = true;
        ass.NE__Item_Code__c                = '';
        ass.NE__Order_Config__c             = ord.id;
        ass.NE__ProdId__c                   = prod2.id;
        ass.NE__RecurringChargeFrequency__c = 'Monthly';
        ass.NE__Remove_from_total__c        = false;
        ass.NE__Service_Account__c          = acc.id;
        ass.NE__Service_Point__c            = sp.id;
        ass.NE__Status__c                   = 'Active';
        ass.OB_enablement__c                = 'N';
        ass.OB_MCCL2__c                     = '0001';
        ass.OB_MCC__c                       = '5200';
        ass.OB_Report_Type__c               = 'Punto Vendita';
        ass.OB_Ro__c                        = 'N';
        ass.OB_Visible__c                   = 'N';
        ass.Quantity                        = 1;
        ass.OB_ShopSign__c                  = '23112';
        ass.OB_ShopCode__c                  = 'stabId';
        ass.OB_CustomerCode__c              = 'clientId';
        ass.OB_TermId__c                    = 'terminalId';
        //ass.NE__Parent_Order_Item__c        = ass2.id;
        ass.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Asset' AND DeveloperName = 'Standard' LIMIT 1].id;
        insert ass;

        Asset ass2 = new Asset();
        //ass.RootAssetId                     = rootAsset.Id;
        ass2.ParentId =                      rootAsset.id;
        ass2.NE__CatalogItem__c              = ci.id;
        ass2.AccountId                       = acc.id;
        ass2.OB_DebitProfId__c               = bp.id;
        ass2.OB_ProposerABI__c               = acc.id;
        ass2.IsCompetitorProduct             = false;
        ass2.NE__Catalog__c = cat.id;
       // ass.IsInternal                      = false;
        ass2.NE__ProdId__c                   = prod2.id;
        ass2.Name                            = 'Offerta Personalizzata';
        ass2.NE__Action__c                   = 'Change';
        ass2.NE__AssetItemEnterpriseId__c    = ass.id;
        ass2.NE__BaseOneTimeFee__c           = 0;
        ass2.NE__BaseRecurringCharge__c      = 0;
        ass2.NE__Billing_Account__c          = acc.id;
        ass2.NE__Commitment__c               = false;
        ass2.NE__Discount_One_time__c        = 0;
        ass2.NE__Discount__c                 = 0;
        ass2.NE__Generate_Asset_Item__c      = true;
        ass2.NE__Item_Code__c                = '';
        ass2.NE__Order_Config__c             = ord.id;
        ass2.NE__RecurringChargeFrequency__c = 'Monthly';
        ass2.NE__Remove_from_total__c        = false;
        ass2.NE__Service_Account__c          = acc.id;
        ass2.NE__Service_Point__c            = sp.id;
        ass2.NE__Status__c                   = 'Active';
        ass2.OB_enablement__c                = 'N';
        ass2.OB_MCCL2__c                     = '0001';
        ass2.OB_MCC__c                       = '5200';
        ass2.OB_Report_Type__c               = 'Punto Vendita';
        ass2.OB_Ro__c                        = 'N';
        ass2.OB_Visible__c                   = 'N';
        ass2.Quantity                        = 1;
        ass2.OB_ShopSign__c                  = '23112';
        ass2.OB_ShopCode__c                  = 'stabId';
        ass2.OB_CustomerCode__c              = 'clientId';
        ass2.OB_TermId__c                    = 'terminalId';
        ass2.NE__Parent_Order_Item__c        = ass.id;
        ass2.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Asset' AND DeveloperName = 'Standard' LIMIT 1].id;
        insert ass2;

        System.debug('Asset inserito: ' + ass.id);

        List<NE__AssetItemAttribute__c> assetItemAttrList = new List<NE__AssetItemAttribute__c>();

        NE__AssetItemAttribute__c assetItemAttrRelease = new NE__AssetItemAttribute__c();
        assetItemAttrRelease.Name  = 'release';
        assetItemAttrRelease.NE__Value__c = 'Nexi';
        assetItemAttrRelease.NE__Asset__c = ass2.id;
        assetItemAttrList.add(assetItemAttrRelease);

        NE__AssetItemAttribute__c assetItemAttrModello = new NE__AssetItemAttribute__c();
        assetItemAttrModello.Name  = 'modello';
        assetItemAttrModello.NE__Value__c = 'Nexi';
        assetItemAttrModello.NE__Asset__c = ass2.id;
        assetItemAttrList.add(assetItemAttrModello);

        NE__AssetItemAttribute__c assetItemAttrModalitaCollegamento = new NE__AssetItemAttribute__c();
        assetItemAttrModalitaCollegamento.Name  = 'modalitàCollegamento';
        assetItemAttrModalitaCollegamento.NE__Value__c = 'Nexi';
        assetItemAttrModalitaCollegamento.NE__Asset__c = ass2.id;
        assetItemAttrList.add(assetItemAttrModalitaCollegamento);

        NE__AssetItemAttribute__c assetItemAttrDescrizioneModello = new NE__AssetItemAttribute__c();
        assetItemAttrDescrizioneModello.Name  = 'Descrizione Modello';
        assetItemAttrDescrizioneModello.NE__Value__c = 'Nexi';
        assetItemAttrDescrizioneModello.NE__Asset__c = ass2.id;
        assetItemAttrList.add(assetItemAttrDescrizioneModello);

        NE__AssetItemAttribute__c assetItemAttrDescrizioneRelease = new NE__AssetItemAttribute__c();
        assetItemAttrDescrizioneRelease.Name  = 'Descrizione Release';
        assetItemAttrDescrizioneRelease.NE__Value__c = 'Nexi';
        assetItemAttrDescrizioneRelease.NE__Asset__c = ass2.id;
        assetItemAttrList.add(assetItemAttrDescrizioneRelease);

        NE__AssetItemAttribute__c assetItemAttrDescrizioneConnessione = new NE__AssetItemAttribute__c();
        assetItemAttrDescrizioneConnessione.Name  = 'Descrizione Connessione';
        assetItemAttrDescrizioneConnessione.NE__Value__c = 'Nexi';
        assetItemAttrDescrizioneConnessione.NE__Asset__c = ass2.id;
        assetItemAttrList.add(assetItemAttrDescrizioneConnessione);
        
        insert assetItemAttrList;

        List<NE__Order_Item_Attribute__c> orderItemAttrList = new List<NE__Order_Item_Attribute__c>();

        NE__Order_Item_Attribute__c orderItemAttrModello = new NE__Order_Item_Attribute__c();
        orderItemAttrModello.Name              = 'modello';
        orderItemAttrModello.NE__Value__c      = 'Nexi';
        orderItemAttrModello.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrModello);

        NE__Order_Item_Attribute__c orderItemAttrRelease = new NE__Order_Item_Attribute__c();
        orderItemAttrRelease.Name              = 'release';
        orderItemAttrRelease.NE__Value__c      = 'Nexi';
        orderItemAttrRelease.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrRelease);

        NE__Order_Item_Attribute__c orderItemAttrModalitaCollegamento = new NE__Order_Item_Attribute__c();
        orderItemAttrModalitaCollegamento.Name              = 'modalitàCollegamento';
        orderItemAttrModalitaCollegamento.NE__Value__c      = 'Nexi';
        orderItemAttrModalitaCollegamento.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrModalitaCollegamento);

        NE__Order_Item_Attribute__c orderItemAttrDescrizioneModello = new NE__Order_Item_Attribute__c();
        orderItemAttrDescrizioneModello.Name              = 'Descrizione Modello';
        orderItemAttrDescrizioneModello.NE__Value__c      = 'Nexi';
        orderItemAttrDescrizioneModello.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrDescrizioneModello);

        NE__Order_Item_Attribute__c orderItemAttrDescrizioneRelease = new NE__Order_Item_Attribute__c();
        orderItemAttrDescrizioneRelease.Name              = 'Descrizione Release';
        orderItemAttrDescrizioneRelease.NE__Value__c      = 'Nexi';
        orderItemAttrDescrizioneRelease.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrDescrizioneRelease);

        NE__Order_Item_Attribute__c orderItemAttrDescrizioneConnessione = new NE__Order_Item_Attribute__c();
        orderItemAttrDescrizioneConnessione.Name              = 'Descrizione Connessione';
        orderItemAttrDescrizioneConnessione.NE__Value__c      = 'Nexi';
        orderItemAttrDescrizioneConnessione.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrDescrizioneConnessione);

        insert orderItemAttrList;
        
        NE__Lov__c lov = new NE__Lov__c();
        lov.NE__Sub_Type__c= 'TIPOLOGICHE';
        lov.NE__Type__c='TRACKING';
        lov.NE__Value1__c = '98765';
        lov.NE__Value2__c = '98765';
        lov.Name = 'test';
        insert lov;

        OB_DeltaRun_LightService.CompanyInfo  companyInfo = new OB_DeltaRun_LightService.CompanyInfo();
        companyInfo.companyCode         = '98765';
        companyInfo.ABI                 = '98765';
        companyInfo.conventionCode      = '78765';
        companyInfo.activationDate      = Date.newInstance(2006, 3, 16);
        companyInfo.deactivationdDate   = Date.newInstance(2026, 3, 16);

        OB_DeltaRun_LightService.CompanyInfo companyData = new OB_DeltaRun_LightService.CompanyInfo();
        companyData.companyCode = '98765';
        companyData.ABI = '98765';
        companyData.conventionCode = '78765';
        companyData.activationDate = Date.newInstance(1960, 2, 17);
        companyData.deactivationdDate = Date.newInstance(2026, 3, 16);

        OB_DeltaRun_LightService.TermInfo termInfo = new OB_DeltaRun_LightService.TermInfo();
        termInfo.modelCode = 'modelCode';
        termInfo.modelDescription = 'modelDescription';
        termInfo.releaseCode = 'releaseCode';
        termInfo.releaseDescription = 'releaseDescription';
        termInfo.connectionCode = 'connectionCode';
        termInfo.connectionDescription = 'connectionDescription';

        OB_DeltaRun_LightService.DeltaRequest request = new OB_DeltaRun_LightService.DeltaRequest();
        request.terminalId = 'terminalId';
        request.clientId = 'clientId';
        request.stabId = 'stabId';
        request.terminalData = termInfo;
        request.companyData = companyData;

        NE__OrderItem__c oi = new NE__OrderItem__c();
        oi.NE__OrderId__c = ord.id;
        oi.NE__Qty__c = 10;
        oi.NE__ProdId__c = prod.id;
        oi.OB_ProposerABI__c = acc.id;
        oi.NE__Account__c = acc.id;
        //oi.NE__Service_Account__c = acc.id;
        //oi.NE__Billing_Account__c = acc.id;
        oi.NE__CatalogItem__c = ci2.id;
        insert oi;

        NE__DynamicPropertyDefinition__c dpd = new NE__DynamicPropertyDefinition__c();
        insert dpd;
        NE__Family__c f = new NE__Family__c();
        insert f;
        NE__ProductFamily__c pf = new NE__ProductFamily__c();
        pf.NE__ProdId__c = prod.id;
        pf.NE__FamilyId__c = f.id;
        insert pf;
        NE__ProductFamily__c pf2 = new NE__ProductFamily__c();
        pf2.NE__ProdId__c = prod2.id;
        pf2.NE__FamilyId__c = f.id;
        insert pf2;

        NE__ProductFamilyProperty__c pfp = new NE__ProductFamilyProperty__c();
        pfp.NE__FamilyId__c = f.id;
        pfp.NE__PropId__c = dpd.id;
        insert pfp;
        NE__ProductFamilyProperty__c pfp2 = new NE__ProductFamilyProperty__c();
        pfp2.NE__FamilyId__c = f.id;
        pfp2.NE__PropId__c = dpd.id;
        insert pfp2;

        Asset enablement = new Asset();
        enablement.NE__Parent_Order_Item__c = ass.id;
        enablement.Name = 'change';
        enablement.AccountId = acc.id;
        enablement.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Asset' AND DeveloperName = 'Standard' LIMIT 1].id;
        insert enablement;
        Asset enablement2 = new Asset();
        enablement2.NE__Parent_Order_Item__c = ass2.id;
        enablement2.Name = 'add';
        enablement2.AccountId = acc.id;
        enablement2.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Asset' AND DeveloperName = 'Standard' LIMIT 1].id;
        insert enablement2;
        System.debug('ass1: '+ass.id+' ass.NE__ProdId__r.OB_Codice_sfdc__c '+ ass.NE__ProdId__r.OB_Codice_sfdc__c);
        System.debug('ass1: '+ass2.id+' ass2.NE__ProdId__r.OB_Codice_sfdc__c '+ ass2.NE__ProdId__r.OB_Codice_sfdc__c);
        Test.StartTest();
        OB_DeltaRun_LightService.updateAsset(request, ass);
        Test.StopTest();
    }

    @isTest
    public static void updateTerminalStatus() {
        
        Account acc  = new Account(); 
        acc.Name = 'TEST';
        acc.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Bank'].id;
        acc.OB_Employees_Number__c = 'Minore di 10';
        acc.OB_VAT_Not_Present__c = false;
        acc.OB_DescriptionVATNotPresent__c = 'description';
        acc.NE__Fiscal_code__c = 'RSSMRA80A01F205X';
        acc.OB_BypassValidation__c = true;
        acc.OB_Status__c = 'Active'; 
        acc.NE__VAT__c = '12312312312'; 
        acc.OB_ABI__c = '12345';
        insert acc;

        NE__Bundle__c bundle = new NE__Bundle__c();
        bundle.Name = 'test';
        bundle.NE__Configuration_Type__c = 'Free';
        bundle.NE__BaseRecurringCharge__c = 12.00;
        bundle.NE__RecurringChargeFrequency__c = 'Annual';
        bundle.NE__Start_Date__c = System.now();
        bundle.NE__End_Date__c = System.now().addDays(1);
        insert bundle;

        NE__Order_Header__c oh = new NE__Order_Header__c();
        oh.OB_Business_Model_Acquiring__c = 'Bancario'; 
        oh.OB_Business_Model_POS__c = 'Trilaterale Nuovo';
        oh.OB_Main_Process__c = 'Maintenance';
        insert oh;

        NE__Service_Point__c sp  = new NE__Service_Point__c();
        sp.OB_MCC__c   ='2345';
        sp.NE__City__c = 'Yaounde';
        insert sp;

        NE__Order__c ord = new NE__Order__c();
        ord.NE__Order_Header__c = oh.id;
        ord.NE__AccountId__c = acc.id;
        ord.NE__BillAccId__c = acc.Id;
        ord.NE__ServAccId__c = acc.Id;
        ord.OB_MCCL2__c = '0000';
        ord.OB_GT__c = 'Nexi';
        ord.OB_Service_Point__c = sp.id; 
        ord.OB_FulfilmentStatus__c = 'Pending';
        insert ord; 

        NE__Item_Header__c itemHeader = new NE__Item_Header__c();
        itemHeader.Name = 'REFERRAL' ;
        insert itemHeader;
        System.debug('item header id '+itemHeader.id);
        NE__Product__c prod = new NE__Product__c();
        prod.OB_Codice_sfdc__c = '98765';
        insert prod;

        NE__Product__c prod2 = new NE__Product__c();
        prod2.OB_Codice_sfdc__c = '98765';
        insert prod2;
        
        NE__Billing_Profile__c bp = new NE__Billing_Profile__c();
        bp.NE__Account__c = acc.id;
        insert bp;

        NE__Catalog__c cat = new NE__Catalog__c();
        cat.Name = 'cat';
        insert cat;

        NE__Catalog_Item__c ci    = new NE__Catalog_Item__c();
        ci.NE__ProductId__c = prod.id;
        ci.NE__Catalog_Id__c = cat.id;
        ci.NE__Type__c = 'Category'; 
        insert ci;

        NE__Catalog_Item__c ci2 = new NE__Catalog_Item__c();
        ci2.NE__ProductId__c = prod2.id;
        ci2.NE__Catalog_Id__c = cat.id;
        ci2.NE__Type__c = 'Product';
        insert ci2;

        NE__OrderItem__c terminalItem = New NE__OrderItem__c(NE__Qty__c = 10 ,NE__OrderId__c = ord.id);
        terminalItem.NE__Action__c      = 'Add';
        terminalItem.OB_ShopCode__c     = 'stabId';
        terminalItem.OB_CustomerCode__c = 'clientId';
        terminalItem.OB_TermId__c       = 'terminalId';  
        terminalItem.OB_ProposerABI__c  = acc.id;
        terminalItem.NE__OrderId__c = ord.id;
        terminalItem.NE__ProdId__c = prod2.id;
        terminalItem.NE__Account__c = acc.id;
        terminalItem.NE__Catalog__c = cat.id;
        terminalItem.NE__CatalogItem__c = ci.id;
        insert terminalItem;

        List<NE__Order_Item_Attribute__c> orderItemAttrList = new List<NE__Order_Item_Attribute__c>();

        NE__Order_Item_Attribute__c orderItemAttrModello = new NE__Order_Item_Attribute__c();
        orderItemAttrModello.Name              = 'modello';
        orderItemAttrModello.NE__Value__c      = 'Nexi';
        orderItemAttrModello.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrModello);

        NE__Order_Item_Attribute__c orderItemAttrRelease = new NE__Order_Item_Attribute__c();
        orderItemAttrRelease.Name              = 'release';
        orderItemAttrRelease.NE__Value__c      = 'Nexi';
        orderItemAttrRelease.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrRelease);

        NE__Order_Item_Attribute__c orderItemAttrModalitaCollegamento = new NE__Order_Item_Attribute__c();
        orderItemAttrModalitaCollegamento.Name              = 'modalitàCollegamento';
        orderItemAttrModalitaCollegamento.NE__Value__c      = 'Nexi';
        orderItemAttrModalitaCollegamento.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrModalitaCollegamento);

        NE__Order_Item_Attribute__c orderItemAttrDescrizioneModello = new NE__Order_Item_Attribute__c();
        orderItemAttrDescrizioneModello.Name              = 'Descrizione Modello';
        orderItemAttrDescrizioneModello.NE__Value__c      = 'Nexi';
        orderItemAttrDescrizioneModello.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrDescrizioneModello);

        NE__Order_Item_Attribute__c orderItemAttrDescrizioneRelease = new NE__Order_Item_Attribute__c();
        orderItemAttrDescrizioneRelease.Name              = 'Descrizione Release';
        orderItemAttrDescrizioneRelease.NE__Value__c      = 'Nexi';
        orderItemAttrDescrizioneRelease.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrDescrizioneRelease);

        NE__Order_Item_Attribute__c orderItemAttrDescrizioneConnessione = new NE__Order_Item_Attribute__c();
        orderItemAttrDescrizioneConnessione.Name              = 'Descrizione Connessione';
        orderItemAttrDescrizioneConnessione.NE__Value__c      = 'Nexi';
        orderItemAttrDescrizioneConnessione.NE__Order_Item__c = terminalItem.id;
        orderItemAttrList.add(orderItemAttrDescrizioneConnessione);

        insert orderItemAttrList;
        
        NE__Lov__c lov = new NE__Lov__c();
        lov.NE__Sub_Type__c= 'TIPOLOGICHE';
        lov.NE__Type__c='TRACKING';
        lov.NE__Value1__c = '98765';
        lov.NE__Value2__c = '98765';
        lov.Name = 'test';
        insert lov;

        OB_DeltaRun_LightService.TermInfo termInfo = new OB_DeltaRun_LightService.TermInfo();
        termInfo.modelCode = 'modelCode';
        termInfo.modelDescription = 'modelDescription';
        termInfo.releaseCode = 'releaseCode';
        termInfo.releaseDescription = 'releaseDescription';
        termInfo.connectionCode = 'connectionCode';
        termInfo.connectionDescription = 'connectionDescription';

        termInfo.CTIcode = '111';
        termInfo.stabSIA = '222';
        termInfo.progressiveSIA = '333';
        termInfo.SIAcode = '444';
        termInfo.installationStatus = 'Installato';
        termInfo.installationDate = '2019-01-01';
        

        OB_DeltaRun_LightService.DeltaRequest request = new OB_DeltaRun_LightService.DeltaRequest();
        request.terminalId = 'terminalId';
        request.clientId = 'clientId';
        request.stabId = 'stabId';
        request.terminalData = termInfo;

        Test.StartTest();
        OB_DeltaRun_LightService.updateTerminal(request);
        Test.StopTest();
        
    }
}