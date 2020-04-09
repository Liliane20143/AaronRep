/*****************************************************************
Name:  OB_TrackingOrderMaintenance_Test
============================================================
Purpose: Test class for OB_TrackingOrderMaintenance
============================================================
History
-------                                                            
VERSION      AUTHOR             DATE             DETAIL          Description
1.0            gianluigi.virga     06/05/2019       Created         Creation of the class
*****************************************************************/
@isTest
public with sharing class OB_TrackingOrderMaintenance_Test {

  /*****************************************************************
Name:  OB_TrackingOrderMaintenance_Test
============================================================
Purpose: Test class for OB_TrackingOrderMaintenance
============================================================
History
-------                                                            
VERSION      AUTHOR             DATE             DETAIL          Description
1.0           Simone Misani      01/08/2019      Created         Creation of the class
*****************************************************************/
  @isTest
  public static void OB_TrackingOrderMaintenance_Test(){
    List<Account> accList = new List<Account>();
    List<NE__OrderItem__c> oiList = new List<NE__OrderItem__c>();
    Id rtMerchant       = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId(); 
    Account myMastMerchant  = new Account(Name='TEST',
                                          RecordTypeId=rtMerchant,
                                          OB_Employees_Number__c='Minore di 10',
                                          OB_VAT_Not_Present__c=true, 
                                          OB_DescriptionVATNotPresent__c='description', 
                                          NE__Fiscal_code__c='RSSMRA80A01F205X',
                                          OB_BypassValidation__c=true,
                                          OB_Status__c='Active'); 

    Id accountBankRecordId   = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Bank').getRecordTypeId(); 
    Account bankAccount   = new Account(Name='TEST',
                                        RecordTypeId=accountBankRecordId,
                                        OB_Employees_Number__c='Minore di 10',
                                        OB_VAT_Not_Present__c=true, 
                                        OB_DescriptionVATNotPresent__c='description', 
                                        NE__Fiscal_code__c='RSSMRA80A01F205X',
                                        OB_BypassValidation__c=true,
                                        OB_Status__c='Active');   
    accList.add(myMastMerchant);
    accList.add(bankAccount);
    insert accList;
    NE__Service_Point__c servicePoint = new NE__Service_Point__c();
    insert servicePoint;
    NE__Order_Header__c orderHeader = new NE__Order_Header__c(OB_ProposerABI__c=bankAccount.Id ,NE__AccountId__c=myMastMerchant.Id, OB_Main_Process__c = 'Maintenance', OB_Sub_Process__c = 'variazione operativa', OB_Business_Model_Acquiring__c = 'Bancario');
    insert orderHeader;
    NE__Order__c configuration = new NE__Order__c(NE__AccountId__c=myMastMerchant.Id, OB_Service_Point__c = servicePoint.Id,NE__Order_Header__c=orderHeader.Id, OB_MCC__c = '0001', OB_MCCL2__c = '5631', OB_GT__c = 'Nexi', OB_PBSettlementMethod__c = 'PB Settlement Method', OB_InternationalSettlementMethod__c = 'International Settlement Method', OB_ReceiptCity__c = 'MILANO', OB_ReceiptHeader__c='Sweet Years', OB_Report_Type__c = 'Punto Vendita', OB_ShopSign__c = 'Sweet Years');
    insert configuration;

    //OrderItem ACQUIRING
    Id rtProductAcqRoot           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.ACQUIRING).getRecordTypeId(); 
    NE__Product__c productAcqRoot = new NE__Product__c(OB_Acquirer__c='', RecordTypeId =rtProductAcqRoot, OB_Codice_sfdc__c = 'VISAMASTERCARD', Name = 'Visa/Mastercard', OB_Contract_Type__c = 'Contratto Acquiring');
    insert productAcqRoot;
    //Start Noemi Infantino
    NE__OrderItem__c orderItemAcqRoot = new NE__OrderItem__c(NE__Qty__c=10 ,NE__OrderId__c=configuration.id, NE__Action__c = 'Add', NE__ProdId__c = productAcqRoot.id, NE__Service_Point__c = servicePoint.Id, NE__Account__c = myMastMerchant.Id , NE__Status__c = 'Active', OB_FulfilmentStatus__c = 'Completed', NE__Parent_Order_Item__c = null);
    insert orderItemAcqRoot;
    NE__OrderItem__c orderItemAcqRoot2 = new NE__OrderItem__c(NE__Qty__c=10 ,NE__OrderId__c=configuration.id, NE__Action__c = 'None', NE__ProdId__c = productAcqRoot.id, NE__Service_Point__c = servicePoint.Id, NE__Account__c = myMastMerchant.Id , NE__Status__c = 'Active', OB_FulfilmentStatus__c = 'Completed', NE__Parent_Order_Item__c = null);
    insert orderItemAcqRoot2;
    NE__OrderItem__c orderItemAcqRoot2_Child = new NE__OrderItem__c(NE__Qty__c=10 ,NE__OrderId__c=configuration.id, NE__Action__c = 'None', NE__ProdId__c = productAcqRoot.id, NE__Service_Point__c = servicePoint.Id, NE__Account__c = myMastMerchant.Id , NE__Status__c = 'Active', OB_FulfilmentStatus__c = 'Completed', NE__Parent_Order_Item__c =orderItemAcqRoot2.Id );
    insert orderItemAcqRoot2_Child;
    //Finish Noemi Infantino

    orderItemAcqRoot.NE__AssetItemEnterpriseId__c = orderItemAcqRoot.id;
    update orderItemAcqRoot;
    oiList.add(orderItemAcqRoot);
    //OrderItem GT
    Id rtProductGTRoot          = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.TERMINALE).getRecordTypeId(); 
    NE__Product__c productGTRoot = new NE__Product__c(RecordTypeId = rtProductGTRoot, OB_Codice_sfdc__c = 'SMPOS_CASSA', Name = 'SmartPOS Cassa', OB_Contract_Type__c = 'Contratto POS;Modulo Off Commercial', OB_Business_Model_POS__c = 'Diretto;Trilaterale Nuovo');
    insert productGTRoot;
    NE__OrderItem__c orderItemGTRoot = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__Action__c = 'Add', OB_GT__c = 'MONETICA', OB_TermId__c = '4444333221', NE__ProdId__c = productGTRoot.id, NE__Status__c = 'PENDING', OB_FulfilmentStatus__c = 'Completed');
    orderItemGTRoot.NE__AssetItemEnterpriseId__c = orderItemGTRoot.id;
    insert orderItemGTRoot;
    

    
    oiList.add(orderItemGTRoot);
    NE__Order_Item_Attribute__c attrGTRoot1 = new NE__Order_Item_Attribute__c();
    attrGTRoot1.Name = 'TermId';
    attrGTRoot1.NE__Order_Item__c = orderItemGTRoot.id;
    
    insert attrGTRoot1;
    NE__Order_Item_Attribute__c attrGTRoot2 = new NE__Order_Item_Attribute__c();
    attrGTRoot2.Name = 'modello';
    attrGTRoot2.NE__Order_Item__c = orderItemGTRoot.id;
    
    insert attrGTRoot2;
    NE__Order_Item_Attribute__c attrGTRoot3 = new NE__Order_Item_Attribute__c();
    attrGTRoot3.Name = 'release';
    attrGTRoot3.NE__Order_Item__c = orderItemGTRoot.id;
   
    insert attrGTRoot3;
    NE__Order_Item_Attribute__c attrGTRoot4 = new NE__Order_Item_Attribute__c();
    attrGTRoot4.Name = 'modalitaCollegamento';
    attrGTRoot4.NE__Order_Item__c = orderItemGTRoot.id;
   
    insert attrGTRoot4;
    NE__Order_Item_Attribute__c attrGTRoot5 = new NE__Order_Item_Attribute__c();
    attrGTRoot5.Name = 'descrizioneModello';
    attrGTRoot5.NE__Order_Item__c = orderItemGTRoot.id;
    
    insert attrGTRoot5;
    NE__Order_Item_Attribute__c attrGTRoot6 = new NE__Order_Item_Attribute__c();
    attrGTRoot6.Name = 'descrizioneRelease';
    attrGTRoot6.NE__Order_Item__c = orderItemGTRoot.id;
 
    insert attrGTRoot6;
    NE__Order_Item_Attribute__c attrGTRoot7 = new NE__Order_Item_Attribute__c();
    attrGTRoot7.Name = 'descrizioneConnessione';
    attrGTRoot7.NE__Order_Item__c = orderItemGTRoot.id;
  
    insert attrGTRoot7;
    NE__Order_Item_Attribute__c attrGTRoot8 = new NE__Order_Item_Attribute__c();
    attrGTRoot8.Name = 'Progressivo SIA';
    attrGTRoot8.NE__Order_Item__c = orderItemGTRoot.id;
    
    insert attrGTRoot8;
    NE__Order_Item_Attribute__c attrGTRoot9 = new NE__Order_Item_Attribute__c();
    attrGTRoot9.Name = 'Codice Stabilimento SIA';
    attrGTRoot9.NE__Order_Item__c = orderItemGTRoot.id;
   
    insert attrGTRoot9;
    NE__Order_Item_Attribute__c attrGTRoot10 = new NE__Order_Item_Attribute__c();
    attrGTRoot10.Name = 'Codice SIA';
    attrGTRoot10.NE__Order_Item__c = orderItemGTRoot.id;
    
    insert attrGTRoot10;
    Id rtProductGT           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.TERMINALE).getRecordTypeId(); 
    NE__Product__c productGT = new NE__Product__c(RecordTypeId = rtProductGT, OB_Codice_sfdc__c = 'INST', Name = 'Installazione pos', OB_Contract_Type__c = 'Installazione pos', OB_Contract_Description__c = 'Installazione pos');
    insert productGT;
    //Start Noemi Infantino
    NE__OrderItem__c orderItemGTroot2 = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__Action__c = 'None', NE__ProdId__c = productGT.id , OB_FulfilmentStatus__c = 'Completed', NE__Status__c='Active');

    NE__OrderItem__c orderItemGT = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__Parent_Order_Item__c = orderItemGTRoot.id, NE__Action__c = 'Add', NE__ProdId__c = productGT.id , OB_FulfilmentStatus__c = 'Completed', NE__Status__c='Active');
    NE__OrderItem__c orderItemGT2 = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__Parent_Order_Item__c = orderItemGTroot2.id, NE__Action__c = 'None', NE__ProdId__c = productGT.id , OB_FulfilmentStatus__c = 'Completed', NE__Status__c='Active');
    orderItemGT.NE__AssetItemEnterpriseId__c= orderItemGT.id;
    insert orderItemGT;
    insert orderItemGT2;
    insert orderItemGTroot2;
    //Finish Noemi Infantino

    //Item Acquiring Child
    Id rtProductAcq           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.ACQUIRING).getRecordTypeId(); 
    NE__Product__c productAcq = new NE__Product__c(RecordTypeId = rtProductAcq, OB_Acquirer__c='NEXI', OB_Codice_sfdc__c = 'VISAMASTERCARD', Name = 'Visa/Mastercard', OB_Contract_Type__c = 'Contratto Acquiring', OB_Offer__c ='PERSONALIZZATA;START;XPAY_FULL');
    insert productAcq;
    NE__OrderItem__c orderItemAcq = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__ProdId__c = productAcq.id, NE__Action__c = 'Add', NE__Parent_Order_Item__c = orderItemGTRoot.id, OB_FulfilmentStatus__c = 'Completed', NE__Status__c='Active'); //Noemi Infantino
    orderItemAcq.NE__AssetItemEnterpriseId__c =orderItemAcq.id;
    insert orderItemAcq;
    Id rtProductPric           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.PRICING).getRecordTypeId(); 
    NE__Product__c productPric = new NE__Product__c(RecordTypeId = rtProductPric, OB_Codice_sfdc__c = 'MAE_PRE', Name = 'MAESTRO CONSUMER PREPAID', OB_Contract_Type__c = 'Contratto Acquiring');
    insert productPric;
    NE__OrderItem__c orderItemPric = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__ProdId__c = productPric.id, NE__Action__c = 'Add', NE__Parent_Order_Item__c = orderItemAcq.id, OB_FulfilmentStatus__c = 'Completed', NE__Status__c='Active'); //Noemi Infantino
    orderItemPric.NE__AssetItemEnterpriseId__c =orderItemPric.id;
    insert orderItemPric;

    //ADD ITEM TO CONFIGURATION
    Id rtProductPB    = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.PAGOBANCOMAT).getRecordTypeId(); 
        NE__Product__c productPB    = new NE__Product__c(OB_Acquirer__c=OB_EnrichOrder.NEXI, RecordTypeId =rtProductPB, OB_Codice_sfdc__c = 'PAGOBANCOMAT' );
        insert productPB;
    NE__OrderItem__c pagobancomat = New NE__OrderItem__c(NE__Qty__c=1 ,NE__OrderId__c=configuration.id, NE__Action__c = 'None', NE__ProdId__c = productPB.id, OB_FulfilmentStatus__c = 'Completed', NE__Status__c='Active');    //Noemi Infantino
    pagobancomat.NE__AssetItemEnterpriseId__c =pagobancomat.id;     
        insert pagobancomat;

    //Start Noemi Infantino
        NE__OrderItem__c pagobancomat1 = New NE__OrderItem__c(NE__Qty__c=1 ,NE__OrderId__c=configuration.id, NE__Action__c = 'Add', NE__ProdId__c = productPB.id, NE__Status__c='Pending');    
    pagobancomat1.NE__AssetItemEnterpriseId__c =pagobancomat1.id;
    //pagobancomat1.NE__Parent_Order_Item__c =pagobancomat.id;
        insert pagobancomat1;
        
        //Finish Noemi Infantino

    Id rtProductVAS   = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.VAS).getRecordTypeId(); 
    NE__Product__c productRootVAS   = new NE__Product__c(RecordTypeId = rtProductVAS, OB_Codice_sfdc__c = 'PELLEGRINI',OB_Acquirer__c='NEXI');
        insert productRootVAS;

         //Start Noemi Infantino
    NE__OrderItem__c rootVas = New NE__OrderItem__c(NE__Qty__c=1 ,NE__OrderId__c=configuration.id, NE__Action__c = 'None', OB_FulfilmentStatus__c = 'Completed', NE__Status__c='Active');   
    rootVas.NE__AssetItemEnterpriseId__c =rootVas.id;

    //Finish Noemi Infantino
        insert rootVas;
    oiList.add(rootVas);
    NE__Product__c productVAS   = new NE__Product__c(RecordTypeId = rtProductVAS, OB_Codice_sfdc__c = 'PELLEGRINI',OB_Acquirer__c='NEXI');
        insert productVAS;
    NE__OrderItem__c vas = New NE__OrderItem__c(NE__Qty__c=1 ,NE__OrderId__c=configuration.id, NE__Action__c = 'Add', OB_FulfilmentStatus__c = 'Completed', NE__Status__c='Active');    // Noemi Infantino    
    vas.NE__AssetItemEnterpriseId__c    =vas.id;
        insert vas;
    oiList.add(vas);
    NE__Product__c product1    = new NE__Product__c(OB_Acquirer__c=OB_EnrichOrder.NEXI , RecordTypeId =rtProductPric );
        product1.OB_Codice_sfdc__c = 'ALB_AUTO';
        insert product1;

        NE__OrderItem__c orderItem1 = new NE__OrderItem__c();
        orderItem1.NE__Qty__c     = 1;
        orderItem1.NE__OrderId__c = configuration.id;
        orderItem1.NE__ProdId__c  = product1.id;
    orderItem1.NE__Action__c = 'Add';
    orderItem1.OB_FulfilmentStatus__c = 'Completed';
    orderItem1.NE__Parent_Order_Item__c = orderItemAcq.id;
    orderItem1.NE__Parent_Order_Item__c = orderItemAcq.id;
    orderItem1.NE__AssetItemEnterpriseId__c = orderItem1.id;
        insert orderItem1;

    //orderItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.ACQUIRING && orderItem.NE__ProdId__r.OB_Acquirer__c!=OB_EnrichOrder.NEXI
    NE__Product__c productNotNexi    = new NE__Product__c(OB_Acquirer__c='AMEX' , RecordTypeId =rtProductAcqRoot, OB_Codice_sfdc__c = 'AMEX' );
        insert productNotNexi;

    NE__OrderItem__c orderItemNotNexi = new NE__OrderItem__c();
    orderItemNotNexi.NE__Qty__c     = 1;
        orderItemNotNexi.NE__OrderId__c = configuration.id;
        orderItemNotNexi.NE__ProdId__c  = productNotNexi.id;
    orderItemNotNexi.NE__Action__c = 'None';
    orderItemNotNexi.OB_FulfilmentStatus__c = 'Completed';
    orderItemNotNexi.NE__Parent_Order_Item__c = null;
    orderItemNotNexi.OB_FulfilmentStatus__c = 'Completed';
    orderItemNotNexi.NE__AssetItemEnterpriseId__c= orderItemNotNexi.id;
        insert orderItemNotNexi;

    NE__Product__c productNotNexiPricing   = new NE__Product__c(OB_Acquirer__c='AMEX' , RecordTypeId =rtProductPric, OB_Codice_sfdc__c = 'PRICING' );
        insert productNotNexiPricing;
    NE__OrderItem__c orderItemNotNexiPric = new NE__OrderItem__c();
    orderItemNotNexiPric.NE__Qty__c     = 1;
        orderItemNotNexiPric.NE__OrderId__c = configuration.id;
        orderItemNotNexiPric.NE__ProdId__c  = productNotNexiPricing.id;
    orderItemNotNexiPric.NE__Action__c = 'None';
    orderItemNotNexiPric.OB_FulfilmentStatus__c = 'Completed';
    orderItemNotNexiPric.NE__Parent_Order_Item__c = orderItemNotNexi.id;
    orderItemNotNexiPric.NE__AssetItemEnterpriseId__c= orderItemNotNexiPric.id;
        insert orderItemNotNexiPric;
    
    
    
    //ASSET
    Asset asset = new Asset(NE__AssetItemEnterpriseId__c = orderItemGTRoot.Id, OB_ShopCode__c = 'shopCode', OB_GT__c = 'GT', OB_CustomerCode__c = 'customerCode', Name = 'SmartPOS');
    insert asset;
    NE__AssetItemAttribute__c attr1 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.TERMID, NE__Asset__c = asset.id);
    insert attr1;
    NE__AssetItemAttribute__c attr2 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.MODELLO, NE__Asset__c = asset.id);
    insert attr2;
    NE__AssetItemAttribute__c attr3 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.RELEASE, NE__Asset__c = asset.id);
    insert attr3;
    NE__AssetItemAttribute__c attr4 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.MODCOLLEGAMENTO, NE__Asset__c = asset.id);
    insert attr4;
    NE__AssetItemAttribute__c attr5 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.DMODELLO, NE__Asset__c = asset.id);
    insert attr5;
    NE__AssetItemAttribute__c attr6 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.DRELEASE, NE__Asset__c = asset.id);
    insert attr6;
    NE__AssetItemAttribute__c attr7 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.DCONNESSIONE, NE__Asset__c = asset.id);
    insert attr7;
    NE__AssetItemAttribute__c attr8 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.PROGRESSIVOSIA, NE__Asset__c = asset.id);
    insert attr8;
    NE__AssetItemAttribute__c attr9 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.CODICESTABILIMENTOSIA, NE__Asset__c = asset.id);
    insert attr9;
    NE__AssetItemAttribute__c attr10 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.CODICESIA, NE__Asset__c = asset.id);
    insert attr10;

    //LOV
    NE__Lov__c lovMCC2 = new NE__Lov__c();
    lovMCC2.NE__Type__c   = 'mcc';
    lovMCC2.NE__Value3__c = 'L2';
    lovMCC2.OB_Value4__c  = configuration.OB_MCCL2__c;
    lovMCC2.NE__Value2__c = configuration.OB_MCCL2__c;
    insert lovMCC2;
    System.debug('@@@lovMCC2 '+lovMCC2);
    NE__Lov__c lov = new NE__Lov__c();
    lov.NE__Type__c     ='TRACKING';
    lov.NE__Sub_Type__c = 'TIPOLOGICHE';
    lov.NE__Value2__c   = 'DINERS';
    lov.NE__Value1__c   = '12';
    insert lov;

    OB_TrackingUtility.ErrorList error1 = new OB_TrackingUtility.ErrorList();

     List<OB_TrackingUtility.ErrorList> errorsList1 = new List<OB_TrackingUtility.ErrorList>();
    

    OB_TrackingUtility.Changes change = new OB_TrackingUtility.Changes();
    change.externalId = rootVas.id; //TERMINALE
    change.result = 'OK';
    change.errors = errorsList1; //List

   
  
    List<OB_TrackingUtility.Changes> changesList = new List<OB_TrackingUtility.Changes>();
    changesList.add(change);

    
    
    OB_TrackingUtility.CodiciConvenzioni codConv = new OB_TrackingUtility.CodiciConvenzioni();
    codConv.companyCode = 'companyCode';
    codConv.companyName = 'companyName';                                
    codConv.code        = 'code';                                       
    codConv.causaleRifiuto ='causaleRifiuto';
    codConv.startDate = '2011-11-13';
    codConv.endDate = '';
    codConv.status  = 'Active';

    List<OB_TrackingUtility.CodiciConvenzioni> codConvList = new List<OB_TrackingUtility.CodiciConvenzioni>();
    codConvList.add(codConv);

    OB_TrackingUtility.TermsIdInformation termInfo = new OB_TrackingUtility.TermsIdInformation();    
    termInfo.terminalId = orderItemGTRoot.OB_TermId__c;
    termInfo.model = 'model';
    termInfo.connectionType = 'connectionType';
    termInfo.modality = 'modality';
    termInfo.modelDescription = 'modelDescription';
    termInfo.release = 'release';
    termInfo.releaseDescription = 'releaseDescription';
    termInfo.status = 'Pending';
    termInfo.reasonOfRejection = '';
    termInfo.installationDate = '2011-11-13';
    termInfo.uninstallationDate = '';
    termInfo.agreementCodes = codConvList; //List
    termInfo.errors = null; //List

    List<OB_TrackingUtility.TermsIdInformation> termsInfoList = new List<OB_TrackingUtility.TermsIdInformation>();
    termsInfoList.add(termInfo);

    OB_TrackingUtility.ErrorList error = new OB_TrackingUtility.ErrorList();
    error.code = '';
    error.description = '';

    
   

    List<OB_TrackingUtility.ErrorList> errorsList = new List<OB_TrackingUtility.ErrorList>();
    errorsList.add(error);
   

    OB_TrackingUtility.puntoVendita pV = new OB_TrackingUtility.puntoVendita();
    //pV.itemId = '';
    pV.PVCode = servicePoint.id;
    pV.startDate = '2011-11-13';
    pV.endDate = '';
    pV.reasonOfClosure = '';
    //pV.tipo = '';
    pV.ctiCode = 'ctiCode';
    pV.StabiCode = 'StabiCode';
    pV.siaPVCode = 'siaPVCode';
    pV.siaProgressiveCode = 'siaProgressiveCode';
    pV.siaMerchantCode = 'siaMerchantCode';
    pV.assistanceNumber = 'assistanceNumber';
    //pV.dataInizioAttivita = '2011-11-13';
    pv.terminalInformation = termsInfoList; //List
    pv.changes = changesList;

    List<OB_TrackingUtility.puntoVendita> pVList = new List<OB_TrackingUtility.puntoVendita>();
    pVList.add(pV);

    OB_TrackingUtility.GT gT = new OB_TrackingUtility.GT();
    gT.source = 'MONETICA';
    gT.gtCompanyCode = 'companyCode';
    gT.errors = null; //List
    gT.PVCodes = pVList; //List
    //gT.statoProvisioning = '';

    List<OB_TrackingUtility.GT> gTList = new List<OB_TrackingUtility.GT>();
    gTList.add(gT);

    OB_TrackingUtility.Acquiring acquiring = new OB_TrackingUtility.Acquiring();
    acquiring.source = 'NEXI';
    acquiring.companyCode = 'companyCode';
    acquiring.errori = null;
    acquiring.PVCodes = pVList;

    List<OB_TrackingUtility.Acquiring> acquiringList = new List<OB_TrackingUtility.Acquiring>();
    acquiringList.add(acquiring);

    OB_TrackingUtility.TrackingOrderRequestMaintenance trackingOrderRequest = new OB_TrackingUtility.TrackingOrderRequestMaintenance();
    trackingOrderRequest.orderId = configuration.id;
    trackingOrderRequest.Acquiring = acquiringList;
    trackingOrderRequest.GT = gTList;

    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();
    req.requestURI = '/TrackingOrderMaintenance/*'; 
    req.httpMethod = 'POST';
    RestContext.request = req;
    String json = JSON.serialize(trackingOrderRequest);
    RestContext.request.requestBody =  Blob.valueof(json);
    RestContext.response = res;

    List<OB_LogRequest__c> listLog = new List<OB_LogRequest__c>();
    OB_LogRequest__c log = OB_TestDataFactory.getLogRequest();
    listLog.add(log);
    Test.startTest();
    OB_TrackingUtility.TrackingOrderResponseMaintenance response = OB_TrackingOrderMaintenance.trackOrderMaintenance();
    OB_TrackingOrderMaintenance.isAcquiringVas(acquiringList);
    OB_TrackingOrderMaintenance.isAcquiringTerminal(acquiringList, true);
    OB_TrackingOrderMaintenance.isAcquiringTerminal(acquiringList, false);
    OB_TrackingOrderMaintenance.updateLogRequest(configuration.id);
    OB_TrackingOrderMaintenance.updateVasItems(oiList,changesList,'','','','',listLog);
    System.assertEquals( 500, response.httpStatus);
    Test.stopTest();
    }
 
/*****************************************************************
Name:  OB_TrackingOrderMaintenance_Test
============================================================
Purpose: Test class for OB_TrackingOrderMaintenance
============================================================
History
-------                                                            
VERSION      AUTHOR             DATE             DETAIL          Description
1.0           Simone Misani      01/08/2019      Created         Creation of the class
*****************************************************************/
     @isTest
  public static void OB_TrackingOrderMaintenance1_Test(){
    List<Account> accList = new List<Account>();
    Id rtMerchant       = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId(); 
    Account myMastMerchant  = new Account(Name='TEST',
                                          RecordTypeId=rtMerchant,
                                          OB_Employees_Number__c='Minore di 10',
                                          OB_VAT_Not_Present__c=true, 
                                          OB_DescriptionVATNotPresent__c='description', 
                                          NE__Fiscal_code__c='RSSMRA80A01F205X',
                                          OB_BypassValidation__c=true,
                                          OB_Status__c='Active'); 

    Id accountBankRecordId   = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Bank').getRecordTypeId(); 
    Account bankAccount   = new Account(Name='TEST',
                                        RecordTypeId=accountBankRecordId,
                                        OB_Employees_Number__c='Minore di 10',
                                        OB_VAT_Not_Present__c=true, 
                                        OB_DescriptionVATNotPresent__c='description', 
                                        NE__Fiscal_code__c='RSSMRA80A01F205X',
                                        OB_BypassValidation__c=true,
                                        OB_Status__c='Active');   
    accList.add(myMastMerchant);
    accList.add(bankAccount);
    insert accList;
    NE__Service_Point__c servicePoint = new NE__Service_Point__c();
    insert servicePoint;
    NE__Order_Header__c orderHeader = new NE__Order_Header__c(OB_ProposerABI__c=bankAccount.Id ,NE__AccountId__c=myMastMerchant.Id, OB_Main_Process__c = 'Maintenance', OB_Sub_Process__c = 'variazione operativa', OB_Business_Model_Acquiring__c = 'Bancario');
    insert orderHeader;
    
    NE__Order__c configuration = new NE__Order__c(NE__AccountId__c=myMastMerchant.Id, OB_Service_Point__c = servicePoint.Id,NE__Order_Header__c=orderHeader.Id, OB_MCC__c = '0001', OB_MCCL2__c = '5631', OB_GT__c = 'Nexi', OB_PBSettlementMethod__c = 'PB Settlement Method', OB_InternationalSettlementMethod__c = 'International Settlement Method', OB_ReceiptCity__c = 'MILANO', OB_ReceiptHeader__c='Sweet Years', OB_Report_Type__c = 'Punto Vendita', OB_ShopSign__c = 'Sweet Years');
    insert configuration;

     Id rtProductAcqRoot           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.ACQUIRING).getRecordTypeId(); 
    NE__Product__c productAcqRoot = new NE__Product__c(OB_Acquirer__c='', RecordTypeId =rtProductAcqRoot, OB_Codice_sfdc__c = 'VISAMASTERCARD', Name = 'Visa/Mastercard', OB_Contract_Type__c = 'Contratto Acquiring');
    insert productAcqRoot;
    NE__OrderItem__c orderItemAcqRoot = new NE__OrderItem__c(NE__Qty__c=10 ,NE__OrderId__c=configuration.id, NE__Action__c = 'Add', NE__ProdId__c = productAcqRoot.id, NE__Service_Point__c = servicePoint.Id, NE__Account__c = myMastMerchant.Id , OB_FulfilmentStatus__c = 'Completed');
    orderItemAcqRoot.NE__AssetItemEnterpriseId__c = orderItemAcqRoot.id;
    insert orderItemAcqRoot;
   
    //OrderItem GT
    Id rtProductGTRoot          = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.TERMINALE).getRecordTypeId(); 
    NE__Product__c productGTRoot = new NE__Product__c(RecordTypeId = rtProductGTRoot, OB_Codice_sfdc__c = 'SMPOS_CASSA', Name = 'SmartPOS Cassa', OB_Contract_Type__c = 'Contratto POS;Modulo Off Commercial', OB_Business_Model_POS__c = 'Diretto;Trilaterale Nuovo');
    insert productGTRoot;
    NE__OrderItem__c orderItemGTRoot = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__Action__c = 'Add', OB_GT__c = 'MONETICA', OB_TermId__c = '4444333221', NE__ProdId__c = productGTRoot.id, NE__Status__c = 'PENDING', OB_FulfilmentStatus__c = 'Completed');
    orderItemGTRoot.NE__AssetItemEnterpriseId__c = orderItemGTRoot.id;
    insert orderItemGTRoot;

    
    
    NE__Order_Item_Attribute__c attrGTRoot1 = new NE__Order_Item_Attribute__c();
    attrGTRoot1.Name = 'TermId';
    attrGTRoot1.NE__Order_Item__c = orderItemGTRoot.id;
    
    insert attrGTRoot1;
    NE__Order_Item_Attribute__c attrGTRoot2 = new NE__Order_Item_Attribute__c();
    attrGTRoot2.Name = 'modello';
    attrGTRoot2.NE__Order_Item__c = orderItemGTRoot.id;
    
    insert attrGTRoot2;
    NE__Order_Item_Attribute__c attrGTRoot3 = new NE__Order_Item_Attribute__c();
    attrGTRoot3.Name = 'release';
    attrGTRoot3.NE__Order_Item__c = orderItemGTRoot.id;
   
    insert attrGTRoot3;
    NE__Order_Item_Attribute__c attrGTRoot4 = new NE__Order_Item_Attribute__c();
    attrGTRoot4.Name = 'modalitaCollegamento';
    attrGTRoot4.NE__Order_Item__c = orderItemGTRoot.id;
   
    insert attrGTRoot4;
    NE__Order_Item_Attribute__c attrGTRoot5 = new NE__Order_Item_Attribute__c();
    attrGTRoot5.Name = 'descrizioneModello';
    attrGTRoot5.NE__Order_Item__c = orderItemGTRoot.id;
    
    insert attrGTRoot5;
    NE__Order_Item_Attribute__c attrGTRoot6 = new NE__Order_Item_Attribute__c();
    attrGTRoot6.Name = 'descrizioneRelease';
    attrGTRoot6.NE__Order_Item__c = orderItemGTRoot.id;
 
    insert attrGTRoot6;
    NE__Order_Item_Attribute__c attrGTRoot7 = new NE__Order_Item_Attribute__c();
    attrGTRoot7.Name = 'descrizioneConnessione';
    attrGTRoot7.NE__Order_Item__c = orderItemGTRoot.id;
  
    insert attrGTRoot7;
    NE__Order_Item_Attribute__c attrGTRoot8 = new NE__Order_Item_Attribute__c();
    attrGTRoot8.Name = 'Progressivo SIA';
    attrGTRoot8.NE__Order_Item__c = orderItemGTRoot.id;
    
    insert attrGTRoot8;
    NE__Order_Item_Attribute__c attrGTRoot9 = new NE__Order_Item_Attribute__c();
    attrGTRoot9.Name = 'Codice Stabilimento SIA';
    attrGTRoot9.NE__Order_Item__c = orderItemGTRoot.id;
   
    insert attrGTRoot9;
    NE__Order_Item_Attribute__c attrGTRoot10 = new NE__Order_Item_Attribute__c();
    attrGTRoot10.Name = 'Codice SIA';
    attrGTRoot10.NE__Order_Item__c = orderItemGTRoot.id;
    
    insert attrGTRoot10;
    Id rtProductGT           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.TERMINALE).getRecordTypeId(); 
    NE__Product__c productGT = new NE__Product__c(RecordTypeId = rtProductGT, OB_Codice_sfdc__c = 'INST', Name = 'Installazione pos', OB_Contract_Type__c = 'Installazione pos', OB_Contract_Description__c = 'Installazione pos');
    insert productGT;
    NE__OrderItem__c orderItemGT = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__Parent_Order_Item__c = orderItemGTRoot.id, NE__Action__c = 'Add', NE__ProdId__c = productGT.id , OB_FulfilmentStatus__c = 'Completed');
    orderItemGT.NE__AssetItemEnterpriseId__c= orderItemGT.id;
    insert orderItemGT;

    //Start Noemi Infantino
    NE__OrderItem__c orderItemGTRootext = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__Action__c = 'Add', OB_GT__c = 'MONETICA', OB_TermId__c = '4444333221', NE__ProdId__c = productGTRoot.id, NE__Status__c = 'PENDING', OB_FulfilmentStatus__c = 'Completed',OB_CustomerCode__c='000001',OB_ShopCode__c='123');
    insert orderItemGTRootext;

    ExternalSourceMapping__c ex12 = OB_TestDataFactory.getExternalSourceMapping( );
    ex12.OB_Source__c = 'MONETICA';
     ex12.OB_CustomerCodeClientCode__c ='000001';
     ex12.OB_ServicePointCodeShopCode__c ='123';
      ex12.OB_Service_Point_ID__c = servicePoint.id ;
      insert ex12;
      ExternalSourceMapping__c ex2 = OB_TestDataFactory.getExternalSourceMapping( );
    ex2.OB_Source__c = 'MONETICA';
     ex2.OB_CustomerCodeClientCode__c ='000001';
     ex2.OB_ServicePointCodeShopCode__c ='123';
      ex2.OB_Service_Point_ID__c = servicePoint.id ;
      insert ex2;

    //Finish Noemi Infantino


    //Item Acquiring Child
    Id rtProductAcq           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.ACQUIRING).getRecordTypeId(); 
    NE__Product__c productAcq = new NE__Product__c(RecordTypeId = rtProductAcq, OB_Acquirer__c='NEXI', OB_Codice_sfdc__c = 'VISAMASTERCARD', Name = 'Visa/Mastercard', OB_Contract_Type__c = 'Contratto Acquiring', OB_Offer__c ='PERSONALIZZATA;START;XPAY_FULL');
    insert productAcq;
    NE__OrderItem__c orderItemAcq = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__ProdId__c = productAcq.id, NE__Action__c = 'Add', NE__Parent_Order_Item__c = orderItemGTRoot.id, OB_FulfilmentStatus__c = 'Completed'); 
    orderItemAcq.NE__AssetItemEnterpriseId__c =orderItemAcq.id;
    insert orderItemAcq;
    Id rtProductPric           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.PRICING).getRecordTypeId(); 
    NE__Product__c productPric = new NE__Product__c(RecordTypeId = rtProductPric, OB_Codice_sfdc__c = 'MAE_PRE', Name = 'MAESTRO CONSUMER PREPAID', OB_Contract_Type__c = 'Contratto Acquiring');
    insert productPric;
    NE__OrderItem__c orderItemPric = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__ProdId__c = productPric.id, NE__Action__c = 'Add', NE__Parent_Order_Item__c = orderItemAcq.id, OB_FulfilmentStatus__c = 'Completed'); 
    orderItemPric.NE__AssetItemEnterpriseId__c =orderItemPric.id;
    insert orderItemPric;

    //ADD ITEM TO CONFIGURATION
    Id rtProductPB    = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.PAGOBANCOMAT).getRecordTypeId(); 
        NE__Product__c productPB    = new NE__Product__c(OB_Acquirer__c=OB_EnrichOrder.NEXI, RecordTypeId =rtProductPB, OB_Codice_sfdc__c = 'PAGOBANCOMAT' );
        insert productPB;
    NE__OrderItem__c pagobancomat = new NE__OrderItem__c(NE__Qty__c=1 ,NE__OrderId__c=configuration.id, NE__Action__c = 'None', NE__ProdId__c = productPB.id, OB_FulfilmentStatus__c = 'Completed');
     
    pagobancomat.NE__AssetItemEnterpriseId__c = pagobancomat.id;    
        insert pagobancomat;

    Id rtProductVAS   = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.VAS).getRecordTypeId(); 
    NE__Product__c productRootVAS   = new NE__Product__c(RecordTypeId = rtProductVAS, OB_Codice_sfdc__c = 'PELLEGRINI',OB_Acquirer__c='NEXI');
        insert productRootVAS;
    NE__OrderItem__c rootVas = new NE__OrderItem__c(NE__Qty__c=1 ,NE__OrderId__c=configuration.id, NE__Action__c = 'None', OB_FulfilmentStatus__c = 'Completed');   
    rootVas.NE__AssetItemEnterpriseId__c        =rootVas.id;
        insert rootVas;
  
    NE__Product__c productVAS   = new NE__Product__c(RecordTypeId = rtProductVAS, OB_Codice_sfdc__c = 'PELLEGRINI',OB_Acquirer__c='NEXI');
        insert productVAS;
    NE__OrderItem__c vas = new NE__OrderItem__c(NE__Qty__c=1 ,NE__OrderId__c=configuration.id, NE__Action__c = 'Add', OB_FulfilmentStatus__c = 'Completed');        
    vas.NE__AssetItemEnterpriseId__c    =vas.id;
        insert vas;
    
    NE__Product__c product1    = new NE__Product__c(OB_Acquirer__c=OB_EnrichOrder.NEXI , RecordTypeId =rtProductPric );
        product1.OB_Codice_sfdc__c = 'ALB_AUTO';
        insert product1;

        NE__OrderItem__c orderItem1 = new NE__OrderItem__c();
        orderItem1.NE__Qty__c     = 1;
        orderItem1.NE__OrderId__c = configuration.id;
        orderItem1.NE__ProdId__c  = product1.id;
    orderItem1.NE__Action__c = 'Add';
    orderItem1.OB_FulfilmentStatus__c = 'Completed';
    orderItem1.NE__Parent_Order_Item__c = orderItemAcq.id;
    orderItem1.NE__Parent_Order_Item__c = orderItemAcq.id;
    orderItem1.NE__AssetItemEnterpriseId__c = orderItem1.id;
        insert orderItem1;

    //orderItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.ACQUIRING && orderItem.NE__ProdId__r.OB_Acquirer__c!=OB_EnrichOrder.NEXI
    NE__Product__c productNotNexi    = new NE__Product__c(OB_Acquirer__c='AMEX' , RecordTypeId =rtProductAcqRoot, OB_Codice_sfdc__c = 'AMEX' );
        insert productNotNexi;

    NE__OrderItem__c orderItemNotNexi = new NE__OrderItem__c();
    orderItemNotNexi.NE__Qty__c     = 1;
        orderItemNotNexi.NE__OrderId__c = configuration.id;
        orderItemNotNexi.NE__ProdId__c  = productNotNexi.id;
    orderItemNotNexi.NE__Action__c = 'None';
    orderItemNotNexi.OB_FulfilmentStatus__c = 'Completed';
    orderItemNotNexi.NE__Parent_Order_Item__c = null;
    orderItemNotNexi.OB_FulfilmentStatus__c = 'Completed';
    orderItemNotNexi.NE__AssetItemEnterpriseId__c= orderItemNotNexi.id;
        insert orderItemNotNexi;

    NE__Product__c productNotNexiPricing   = new NE__Product__c(OB_Acquirer__c='AMEX' , RecordTypeId =rtProductPric, OB_Codice_sfdc__c = 'PRICING' );
        insert productNotNexiPricing;
    NE__OrderItem__c orderItemNotNexiPric = new NE__OrderItem__c();
    orderItemNotNexiPric.NE__Qty__c     = 1;
        orderItemNotNexiPric.NE__OrderId__c = configuration.id;
        orderItemNotNexiPric.NE__ProdId__c  = productNotNexiPricing.id;
    orderItemNotNexiPric.NE__Action__c = 'None';
    orderItemNotNexiPric.OB_FulfilmentStatus__c = 'Completed';
    orderItemNotNexiPric.NE__Parent_Order_Item__c = orderItemNotNexi.id;
    orderItemNotNexiPric.NE__AssetItemEnterpriseId__c= orderItemNotNexiPric.id;
        insert orderItemNotNexiPric;
    
    
    
    Map<Id, Asset> mapAsset = new Map<Id,Asset>();
    //ASSET
    Asset asset = new Asset(NE__AssetItemEnterpriseId__c = orderItemGTRoot.Id, OB_ShopCode__c = 'shopCode', OB_GT__c = 'GT', OB_CustomerCode__c = 'customerCode', Name = 'SmartPOS');
    insert asset;
    mapAsset.put(asset.id, asset);
    NE__AssetItemAttribute__c attr1 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.TERMID, NE__Asset__c = asset.id);
    insert attr1;
    NE__AssetItemAttribute__c attr2 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.MODELLO, NE__Asset__c = asset.id);
    insert attr2;
    NE__AssetItemAttribute__c attr3 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.RELEASE, NE__Asset__c = asset.id);
    insert attr3;
    NE__AssetItemAttribute__c attr4 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.MODCOLLEGAMENTO, NE__Asset__c = asset.id);
    insert attr4;
    NE__AssetItemAttribute__c attr5 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.DMODELLO, NE__Asset__c = asset.id);
    insert attr5;
    NE__AssetItemAttribute__c attr6 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.DRELEASE, NE__Asset__c = asset.id);
    insert attr6;
    NE__AssetItemAttribute__c attr7 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.DCONNESSIONE, NE__Asset__c = asset.id);
    insert attr7;
    NE__AssetItemAttribute__c attr8 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.PROGRESSIVOSIA, NE__Asset__c = asset.id);
    insert attr8;
    NE__AssetItemAttribute__c attr9 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.CODICESTABILIMENTOSIA, NE__Asset__c = asset.id);
    insert attr9;
    NE__AssetItemAttribute__c attr10 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.CODICESIA, NE__Asset__c = asset.id);
    insert attr10;


    //LOV
    NE__Lov__c lovMCC2 = new NE__Lov__c();
    lovMCC2.NE__Type__c   = 'mcc';
    lovMCC2.NE__Value3__c = 'L2';
    lovMCC2.OB_Value4__c  = configuration.OB_MCCL2__c;
    lovMCC2.NE__Value2__c = configuration.OB_MCCL2__c;
    insert lovMCC2;
    System.debug('@@@lovMCC2 '+lovMCC2);
    NE__Lov__c lov = new NE__Lov__c();
    lov.NE__Type__c     ='TRACKING';
    lov.NE__Sub_Type__c = 'TIPOLOGICHE';
    lov.NE__Value2__c   = 'DINERS';
    lov.NE__Value1__c   = '12';
    insert lov;

    OB_TrackingUtility.ErrorList error1 = new OB_TrackingUtility.ErrorList();

     List<OB_TrackingUtility.ErrorList> errorsList1 = new List<OB_TrackingUtility.ErrorList>();
    

    OB_TrackingUtility.Changes change = new OB_TrackingUtility.Changes();
    change.externalId = orderItemGTRoot.id; //TERMINALE
    change.result = 'OK';
    change.errors = errorsList1; //List

   
  
    List<OB_TrackingUtility.Changes> changesList = new List<OB_TrackingUtility.Changes>();
    changesList.add(change);

    
    
    OB_TrackingUtility.CodiciConvenzioni codConv = new OB_TrackingUtility.CodiciConvenzioni();
    codConv.companyCode = 'companyCode';
    codConv.idItemSalesforce    ='';
    codConv.companyName = 'companyName';                                
    codConv.code        = 'code';                                       
    codConv.causaleRifiuto ='causaleRifiuto';
    codConv.startDate = '2011-11-13';
    codConv.endDate = '';
    codConv.status  = 'Active';

    List<OB_TrackingUtility.CodiciConvenzioni> codConvList = new List<OB_TrackingUtility.CodiciConvenzioni>();
    codConvList.add(codConv);
    OB_TrackingUtility.pricingChange prcicode = new OB_TrackingUtility.pricingChange();
    prcicode.status = 'ok';
    prcicode.startDate = '2011-11-13';                              
    

    //List<OB_TrackingUtility.pricingChange> pricList = new List<OB_TrackingUtility.pricingChange>();
    //pricList.add(prcicode);


    OB_TrackingUtility.TermsIdInformation termInfo = new OB_TrackingUtility.TermsIdInformation();    
    termInfo.terminalId = orderItemGTRoot.OB_TermId__c;
    termInfo.model = 'model';
    termInfo.connectionType = 'connectionType';
    termInfo.modality = 'modality';
    termInfo.modelDescription = 'modelDescription';
    termInfo.release = 'release';
    termInfo.releaseDescription = 'releaseDescription';
    termInfo.status = 'Pending';
    termInfo.reasonOfRejection = '';
    termInfo.installationDate = '2011-11-13';
    termInfo.uninstallationDate = '';
    termInfo.agreementCodes = codConvList; //List
    termInfo.pricingChange = prcicode;//Roland Nieznanski <roland.nieznanski@accenture.com> 19/09/2019 changed from list on wrapper. 
    termInfo.errors = errorsList1; //List

    List<OB_TrackingUtility.TermsIdInformation> termsInfoList = new List<OB_TrackingUtility.TermsIdInformation>();
    termsInfoList.add(termInfo);

    OB_TrackingUtility.ErrorList error = new OB_TrackingUtility.ErrorList();
    error.code = '';
    error.description = '';

    
   

    List<OB_TrackingUtility.ErrorList> errorsList = new List<OB_TrackingUtility.ErrorList>();
    errorsList.add(error);
   

    OB_TrackingUtility.puntoVendita pV = new OB_TrackingUtility.puntoVendita();
    pV.itemId = '';
    pV.PVCode = servicePoint.id;
    pV.startDate = '2011-11-13';
    pV.endDate = '';
    pV.reasonOfClosure = '';
    //pV.tipo = '';
    pV.ctiCode = 'ctiCode';
    pV.StabiCode = 'StabiCode';
    pV.siaPVCode = 'siaPVCode';
    pV.siaProgressiveCode = 'siaProgressiveCode';
    pV.siaMerchantCode = 'siaMerchantCode';
    pV.assistanceNumber = 'assistanceNumber';
    pV.dataInizioAttivita = '2011-11-13';
    pv.terminalInformation = termsInfoList; //List
    pv.changes = changesList;

    List<OB_TrackingUtility.puntoVendita> pVList = new List<OB_TrackingUtility.puntoVendita>();
    pVList.add(pV);

    OB_TrackingUtility.GT gT = new OB_TrackingUtility.GT();
    gT.source = 'MONETICA';
    gT.gtCompanyCode = 'companyCode';
    gt.statoProvisioning    ='';
    gT.errors = errorsList; //List
    gT.PVCodes = pVList; //List
    //gT.statoProvisioning = '';

    List<OB_TrackingUtility.GT> gTList = new List<OB_TrackingUtility.GT>();
    gTList.add(gT);

    OB_TrackingUtility.Acquiring acquiring = new OB_TrackingUtility.Acquiring();
    acquiring.source = 'NEXI';
    acquiring.companyCode = 'companyCode';
    acquiring.errori = null;
    acquiring.PVCodes = pVList;

    List<OB_TrackingUtility.Acquiring> acquiringList = new List<OB_TrackingUtility.Acquiring>();
    acquiringList.add(acquiring);

    OB_TrackingUtility.TrackingOrderRequestMaintenance trackingOrderRequest = new OB_TrackingUtility.TrackingOrderRequestMaintenance();
    trackingOrderRequest.orderId = configuration.id;
    trackingOrderRequest.Acquiring = acquiringList;
    //trackingOrderRequest.GT = gTList;
    ExternalSourceMapping__c ex = OB_TestDataFactory.getExternalSourceMapping( );
    ex.OB_Source__c = 'MONETICA';
     ex.OB_CustomerCodeClientCode__c ='customerCode';
     ex.OB_ServicePointCodeShopCode__c ='shopCode';
      ex.OB_Service_Point_ID__c = servicePoint.id ;
      insert ex;
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();
    req.requestURI = '/TrackingOrderMaintenance/*'; 
    req.httpMethod = 'POST';
    RestContext.request = req;
    String json = JSON.serialize(trackingOrderRequest);
    RestContext.request.requestBody =  Blob.valueof(json);
    RestContext.response = res;

     

  
  
    Test.startTest();
    OB_TrackingUtility.TrackingOrderResponseMaintenance response = OB_TrackingOrderMaintenance.trackOrderMaintenance();
    System.assertEquals( 200 , response.httpStatus);
     List<NE__OrderItem__c> listOi = [SELECT OB_isNotIntegrated__c from NE__OrderItem__c where NE__OrderId__c = : configuration.id];
    System.assertEquals(false, listOi.get(0).OB_isNotIntegrated__c);
    
    OB_TrackingOrderMaintenance.updateAssetDate( termsInfoList, configuration.id , mapAsset  );
    Test.stopTest();
     }
/*****************************************************************
Name:  OB_TrackingOrderMaintenance_Test
============================================================
Purpose: Test class for OB_TrackingOrderMaintenance
============================================================
History
-------                                                            
VERSION      AUTHOR             DATE             DETAIL          Description
1.0           Simone Misani      01/08/2019      Created         Creation of the class
*****************************************************************/
  @isTest
  public static void isGtTerminal_Test(){
    List<Account> accList = new List<Account>();
    Id rtMerchant       = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId(); 
    Account myMastMerchant  = new Account(Name='TEST',
                                          RecordTypeId=rtMerchant,
                                          OB_Employees_Number__c='Minore di 10',
                                          OB_VAT_Not_Present__c=true, 
                                          OB_DescriptionVATNotPresent__c='description', 
                                          NE__Fiscal_code__c='RSSMRA80A01F205X',
                                          OB_BypassValidation__c=true,
                                          OB_Status__c='Active'); 

    Id accountBankRecordId   = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Bank').getRecordTypeId(); 
    Account bankAccount   = new Account(Name='TEST',
                                        RecordTypeId=accountBankRecordId,
                                        OB_Employees_Number__c='Minore di 10',
                                        OB_VAT_Not_Present__c=true, 
                                        OB_DescriptionVATNotPresent__c='description', 
                                        NE__Fiscal_code__c='RSSMRA80A01F205X',
                                        OB_BypassValidation__c=true,
                                        OB_Status__c='Active');   
    accList.add(myMastMerchant);
    accList.add(bankAccount);
    insert accList;

     NE__Service_Point__c servicePoint = new NE__Service_Point__c();
    insert servicePoint;
    NE__Order_Header__c orderHeader = new NE__Order_Header__c(OB_ProposerABI__c=bankAccount.Id ,NE__AccountId__c=myMastMerchant.Id, OB_Main_Process__c = 'Maintenance', OB_Sub_Process__c = 'variazione operativa', OB_Business_Model_Acquiring__c = 'Bancario');
    insert orderHeader;
    NE__Order__c configuration = new NE__Order__c(NE__AccountId__c=myMastMerchant.Id, OB_Service_Point__c = servicePoint.Id,NE__Order_Header__c=orderHeader.Id, OB_MCC__c = '0001', OB_MCCL2__c = '5631', OB_GT__c = 'Nexi', OB_PBSettlementMethod__c = 'PB Settlement Method', OB_InternationalSettlementMethod__c = 'International Settlement Method', OB_ReceiptCity__c = 'MILANO', OB_ReceiptHeader__c='Sweet Years', OB_Report_Type__c = 'Punto Vendita', OB_ShopSign__c = 'Sweet Years');
    insert configuration;

    Id rtProductGTRoot          = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.ACQUIRING).getRecordTypeId(); 
    NE__Product__c productGTRoot = new NE__Product__c(RecordTypeId = rtProductGTRoot, OB_Codice_sfdc__c = ' VISAMASTERCARD', Name = 'Visa/Mastercard', OB_Contract_Type__c = 'Contratto Acquiring');
    insert productGTRoot;
    NE__OrderItem__c orderItemGTRoot = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__Action__c = 'Add', OB_Processor__c = 'EQUENS', NE__ProdId__c = productGTRoot.id, NE__Status__c = 'PENDING',OB_TermId__c='00987654');
    insert orderItemGTRoot;

    OB_TrackingUtility.ErrorList error1 = new OB_TrackingUtility.ErrorList();

     List<OB_TrackingUtility.ErrorList> errorsList1 = new List<OB_TrackingUtility.ErrorList>();
    

    // OB_TrackingUtility.Changes change = new OB_TrackingUtility.Changes();
    // change.externalId = orderItemGTRoot.id; //TERMINALE
    // change.result = 'OK';
    // change.errors = errorsList1; //List


    OB_TrackingUtility.CodiciConvenzioni codConv = new OB_TrackingUtility.CodiciConvenzioni();
    codConv.companyCode = 'companyCode';
    codConv.companyName = 'companyName';                                
    codConv.code        = 'code';                                       
    codConv.causaleRifiuto ='causaleRifiuto';
    codConv.startDate = '2011-11-13';
    codConv.endDate = '';
    codConv.status  = 'Active';

    List<OB_TrackingUtility.CodiciConvenzioni> codConvList = new List<OB_TrackingUtility.CodiciConvenzioni>();
    codConvList.add(codConv);

    OB_TrackingUtility.TermsIdInformation termInfo = new OB_TrackingUtility.TermsIdInformation();    
    termInfo.terminalId = orderItemGTRoot.OB_TermId__c;
    termInfo.model = 'model';
    termInfo.connectionType = 'connectionType';
    termInfo.modality = 'modality';
    termInfo.modelDescription = 'modelDescription';
    termInfo.release = 'release';
    termInfo.releaseDescription = 'releaseDescription';
    termInfo.status = 'Pending';
    termInfo.reasonOfRejection = '';
    termInfo.installationDate = '2011-11-13';
    termInfo.uninstallationDate = '';
    termInfo.agreementCodes = codConvList; //List
    termInfo.errors = errorsList1; //List

    List<OB_TrackingUtility.TermsIdInformation> termsInfoList = new List<OB_TrackingUtility.TermsIdInformation>();
    termsInfoList.add(termInfo);

    OB_TrackingUtility.puntoVendita pV = new OB_TrackingUtility.puntoVendita();
    //pV.itemId = '';
    pV.PVCode = servicePoint.id;
    pV.startDate = '2011-11-13';
    pV.endDate = '';
    pV.reasonOfClosure = '';
    //pV.tipo = '';
    pV.ctiCode = 'ctiCode';
    pV.StabiCode = 'StabiCode';
    pV.siaPVCode = 'siaPVCode';
    pV.siaProgressiveCode = 'siaProgressiveCode';
    pV.siaMerchantCode = 'siaMerchantCode';
    pV.assistanceNumber = 'assistanceNumber';
    //pV.dataInizioAttivita = '2011-11-13';
    pv.terminalInformation = termsInfoList; //List
    pv.changes = null;

    List<OB_TrackingUtility.puntoVendita> pVList = new List<OB_TrackingUtility.puntoVendita>();
    pVList.add(pV);

    OB_TrackingUtility.GT gT = new OB_TrackingUtility.GT();
    gT.source = 'MONETICA';
    gT.gtCompanyCode = 'companyCode';
    gT.errors = null; //List
    gT.PVCodes = pVList; //List
    //gT.statoProvisioning = '';

    List<OB_TrackingUtility.GT> gTList = new List<OB_TrackingUtility.GT>();
    gTList.add(gT);

    OB_TrackingUtility.TrackingOrderRequestMaintenance trackingOrderRequest = new OB_TrackingUtility.TrackingOrderRequestMaintenance();
    trackingOrderRequest.orderId = configuration.id;
    trackingOrderRequest.GT = gTList;

    Test.startTest();
    OB_TrackingOrderMaintenance.isGtTerminal(gTList, true, false, true);
    OB_TrackingOrderMaintenance.isGtTerminal(gTList, false, true, true);
    OB_TrackingOrderMaintenance.isGtAcquiring(gTList,configuration.id);
     OB_TrackingOrderMaintenance.isGtVas(gTList,configuration.id);
    Test.stopTest();

  }
/*****************************************************************
Name:  OB_TrackingOrderMaintenance_Test
============================================================
Purpose: Test class for OB_TrackingOrderMaintenance
============================================================
History
-------                                                            
VERSION      AUTHOR             DATE             DETAIL          Description
1.0           Simone Misani      01/08/2019      Created         Creation of the class
*****************************************************************/
  @isTest
  public static void updateorderItemChangeterm_test(){
     List<Account> accList = new List<Account>();
    Id rtMerchant       = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId(); 
    Account myMastMerchant  = new Account(Name='TEST',
                                          RecordTypeId=rtMerchant,
                                          OB_Employees_Number__c='Minore di 10',
                                          OB_VAT_Not_Present__c=true, 
                                          OB_DescriptionVATNotPresent__c='description', 
                                          NE__Fiscal_code__c='RSSMRA80A01F205X',
                                          OB_BypassValidation__c=true,
                                          OB_Status__c='Active'); 

    Id accountBankRecordId   = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Bank').getRecordTypeId(); 
    Account bankAccount   = new Account(Name='TEST',
                                        RecordTypeId=accountBankRecordId,
                                        OB_Employees_Number__c='Minore di 10',
                                        OB_VAT_Not_Present__c=true, 
                                        OB_DescriptionVATNotPresent__c='description', 
                                        NE__Fiscal_code__c='RSSMRA80A01F205X',
                                        OB_BypassValidation__c=true,
                                        OB_Status__c='Active');   
    accList.add(myMastMerchant);
    accList.add(bankAccount);
    insert accList;

     NE__Service_Point__c servicePoint = new NE__Service_Point__c();
    insert servicePoint;
    NE__Order_Header__c orderHeader = new NE__Order_Header__c(OB_ProposerABI__c=bankAccount.Id ,NE__AccountId__c=myMastMerchant.Id, OB_Main_Process__c = 'Maintenance', OB_Sub_Process__c = 'sostituzione terminali', OB_Business_Model_Acquiring__c = 'Bancario');
    insert orderHeader;
    NE__Order__c configuration = new NE__Order__c(NE__AccountId__c=myMastMerchant.Id, OB_Service_Point__c = servicePoint.Id,NE__Order_Header__c=orderHeader.Id, OB_MCC__c = '0001', OB_MCCL2__c = '5631', OB_GT__c = 'Nexi', OB_PBSettlementMethod__c = 'PB Settlement Method', OB_InternationalSettlementMethod__c = 'International Settlement Method', OB_ReceiptCity__c = 'MILANO', OB_ReceiptHeader__c='Sweet Years', OB_Report_Type__c = 'Punto Vendita', OB_ShopSign__c = 'Sweet Years');
    insert configuration;

    Id rtProductGTRoot          = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.ACQUIRING).getRecordTypeId(); 
    NE__Product__c productGTRoot = new NE__Product__c(RecordTypeId = rtProductGTRoot, OB_Codice_sfdc__c = ' VISAMASTERCARD', Name = 'Visa/Mastercard', OB_Contract_Type__c = 'Contratto Acquiring');
    insert productGTRoot;
    NE__OrderItem__c orderItemGTRoot = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__Action__c = 'Remove', OB_Processor__c = 'EQUENS', NE__ProdId__c = productGTRoot.id, NE__Status__c = 'PENDING',OB_TermId__c='00987654');
    insert orderItemGTRoot;


    OB_TrackingUtility.ErrorList error1 = new OB_TrackingUtility.ErrorList();
      error1.code ='99';
      error1.description ='errore';
     List<OB_TrackingUtility.ErrorList> errorsList1 = new List<OB_TrackingUtility.ErrorList>();
    errorsList1.add(error1);
    OB_TrackingUtility.TermsIdInformation termInfo = new OB_TrackingUtility.TermsIdInformation();    
    termInfo.terminalId = orderItemGTRoot.OB_TermId__c;
    termInfo.model = 'model';
    termInfo.connectionType = 'connectionType';
    termInfo.modality = 'modality';
    termInfo.modelDescription = 'modelDescription';
    termInfo.release = 'release';
    termInfo.releaseDescription = 'releaseDescription';
    termInfo.status = 'Pending';
    termInfo.reasonOfRejection = '';
    termInfo.installationDate = '2011-11-13';
    termInfo.uninstallationDate = '';
    termInfo.agreementCodes = null; //List
    termInfo.errors = errorsList1; //List

    List<OB_TrackingUtility.TermsIdInformation> termsInfoList = new List<OB_TrackingUtility.TermsIdInformation>();
    termsInfoList.add(termInfo);

    OB_TrackingUtility.puntoVendita pV = new OB_TrackingUtility.puntoVendita();
    //pV.itemId = '';
    pV.PVCode = servicePoint.id;
    pV.startDate = '2011-11-13';
    pV.endDate = '';
    pV.reasonOfClosure = '';
    //pV.tipo = '';
    pV.ctiCode = 'ctiCode';
    pV.StabiCode = 'StabiCode';
    pV.siaPVCode = 'siaPVCode';
    pV.siaProgressiveCode = 'siaProgressiveCode';
    pV.siaMerchantCode = 'siaMerchantCode';
    pV.assistanceNumber = 'assistanceNumber';
    //pV.dataInizioAttivita = '2011-11-13';
    pv.terminalInformation = termsInfoList; //List
    pv.changes = null;

    List<OB_TrackingUtility.puntoVendita> pVList = new List<OB_TrackingUtility.puntoVendita>();
    pVList.add(pV);

    OB_TrackingUtility.GT gT = new OB_TrackingUtility.GT();
    gT.source = 'MONETICA';
    gT.gtCompanyCode = 'companyCode';
    gT.errors = null; //List
    gT.PVCodes = pVList; //List
    //gT.statoProvisioning = '';

    List<OB_TrackingUtility.GT> gTList = new List<OB_TrackingUtility.GT>();
    gTList.add(gT);

    OB_TrackingUtility.TrackingOrderRequestMaintenance trackingOrderRequest = new OB_TrackingUtility.TrackingOrderRequestMaintenance();
    trackingOrderRequest.orderId = configuration.id;
    trackingOrderRequest.GT = gTList;

    Test.startTest();
    String orderid= configuration.id;
 
    List<NE__OrderItem__c> listOi = [SELECT OB_isNotIntegrated__c from NE__OrderItem__c where NE__OrderId__c = :orderid];
    
    
    
    
     
    
     OB_TrackingOrderMaintenance.updateorderItemChangeterm(configuration.id);
    //OB_TrackingOrderMaintenance.checkedErrorTerminalInfo(termsInfoList,configuration.id );
     System.assertEquals(false, listOi.get(0).OB_isNotIntegrated__c);
    Test.stopTest();
  }

 /*****************************************************************
Name:  OB_TrackingOrderMaintenance_Test
============================================================
Purpose: Test class for OB_TrackingOrderMaintenance
============================================================
History
-------                                                            
VERSION      AUTHOR             DATE             DETAIL          Description
1.0           Simone Misani      21/08/2019      Created         Creation of the class
*****************************************************************/
  @isTest
   public static void updatePciandCommissione_test(){
      List<Account> accList = new List<Account>();
    Id rtMerchant       = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId(); 
    Account myMastMerchant  = new Account(Name='TEST',
                                          RecordTypeId=rtMerchant,
                                          OB_Employees_Number__c='Minore di 10',
                                          OB_VAT_Not_Present__c=true, 
                                          OB_DescriptionVATNotPresent__c='description', 
                                          NE__Fiscal_code__c='RSSMRA80A01F205X',
                                          OB_BypassValidation__c=true,
                                          OB_Status__c='Active'); 

    Id accountBankRecordId   = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Bank').getRecordTypeId(); 
    Account bankAccount   = new Account(Name='TEST',
                                        RecordTypeId=accountBankRecordId,
                                        OB_Employees_Number__c='Minore di 10',
                                        OB_VAT_Not_Present__c=true, 
                                        OB_DescriptionVATNotPresent__c='description', 
                                        NE__Fiscal_code__c='RSSMRA80A01F205X',
                                        OB_BypassValidation__c=true,
                                        OB_Status__c='Active');   
    accList.add(myMastMerchant);
    accList.add(bankAccount);
    insert accList;

     NE__Service_Point__c servicePoint = new NE__Service_Point__c();
    insert servicePoint;
    NE__Order_Header__c orderHeader = new NE__Order_Header__c(OB_ProposerABI__c=bankAccount.Id ,NE__AccountId__c=myMastMerchant.Id, OB_Main_Process__c = 'Maintenance', OB_Sub_Process__c = 'sostituzione terminali', OB_Business_Model_Acquiring__c = 'Bancario');
    insert orderHeader;
    NE__Order__c configuration = new NE__Order__c(NE__AccountId__c=myMastMerchant.Id, OB_Service_Point__c = servicePoint.Id,NE__Order_Header__c=orderHeader.Id, OB_MCC__c = '0001', OB_MCCL2__c = '5631', OB_GT__c = 'Nexi', OB_PBSettlementMethod__c = 'PB Settlement Method', OB_InternationalSettlementMethod__c = 'International Settlement Method', OB_ReceiptCity__c = 'MILANO', OB_ReceiptHeader__c='Sweet Years', OB_Report_Type__c = 'Punto Vendita', OB_ShopSign__c = 'Sweet Years');
    insert configuration;

    Id rtProductGTRoot          = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get('Commissione').getRecordTypeId(); 
    NE__Product__c productGTRoot = new NE__Product__c(RecordTypeId = rtProductGTRoot, OB_Codice_sfdc__c = ' VISAMASTERCARD', Name = 'Visa/Mastercard', OB_Contract_Type__c = 'Contratto Acquiring');
    insert productGTRoot;
    NE__OrderItem__c orderItemGTRoot = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__Action__c = 'Remove', OB_Processor__c = 'EQUENS', NE__ProdId__c = productGTRoot.id, NE__Status__c = 'PENDING',OB_TermId__c='00987654');
    insert orderItemGTRoot;

    
     Test.startTest();

    String orderid= configuration.id;
 
    List<NE__OrderItem__c> listOi = [SELECT OB_isNotIntegrated__c from NE__OrderItem__c where NE__OrderId__c = :orderid];
    
    
     OB_TrackingOrderMaintenance.updatePciandCommissione(configuration.id, true);
     System.assertEquals(false, listOi.get(0).OB_isNotIntegrated__c);
     
    Test.stopTest();
   }

 @isTest
   public static void updatePciandCommissione_test2(){
      List<Account> accList = new List<Account>();
    Id rtMerchant       = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId(); 
    Account myMastMerchant  = new Account(Name='TEST',
                                          RecordTypeId=rtMerchant,
                                          OB_Employees_Number__c='Minore di 10',
                                          OB_VAT_Not_Present__c=true, 
                                          OB_DescriptionVATNotPresent__c='description', 
                                          NE__Fiscal_code__c='RSSMRA80A01F205X',
                                          OB_BypassValidation__c=true,
                                          OB_Status__c='Active'); 

    Id accountBankRecordId   = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Bank').getRecordTypeId(); 
    Account bankAccount   = new Account(Name='TEST',
                                        RecordTypeId=accountBankRecordId,
                                        OB_Employees_Number__c='Minore di 10',
                                        OB_VAT_Not_Present__c=true, 
                                        OB_DescriptionVATNotPresent__c='description', 
                                        NE__Fiscal_code__c='RSSMRA80A01F205X',
                                        OB_BypassValidation__c=true,
                                        OB_Status__c='Active');   
    accList.add(myMastMerchant);
    accList.add(bankAccount);
    insert accList;

     NE__Service_Point__c servicePoint = new NE__Service_Point__c();
    insert servicePoint;
    NE__Order_Header__c orderHeader = new NE__Order_Header__c(OB_ProposerABI__c=bankAccount.Id ,NE__AccountId__c=myMastMerchant.Id, OB_Main_Process__c = 'Maintenance', OB_Sub_Process__c = 'sostituzione terminali', OB_Business_Model_Acquiring__c = 'Bancario');
    insert orderHeader;
    NE__Order__c configuration = new NE__Order__c(NE__AccountId__c=myMastMerchant.Id, OB_Service_Point__c = servicePoint.Id,NE__Order_Header__c=orderHeader.Id, OB_MCC__c = '0001', OB_MCCL2__c = '5631', OB_GT__c = 'Nexi', OB_PBSettlementMethod__c = 'PB Settlement Method', OB_InternationalSettlementMethod__c = 'International Settlement Method', OB_ReceiptCity__c = 'MILANO', OB_ReceiptHeader__c='Sweet Years', OB_Report_Type__c = 'Punto Vendita', OB_ShopSign__c = 'Sweet Years');
    insert configuration;

    Id rtProductGTRoot          = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get('Commissione').getRecordTypeId(); 
    NE__Product__c productGTRoot = new NE__Product__c(RecordTypeId = rtProductGTRoot, OB_Codice_sfdc__c = ' VISAMASTERCARD', Name = 'Visa/Mastercard', OB_Contract_Type__c = 'Contratto Acquiring');
    insert productGTRoot;
    NE__OrderItem__c orderItemGTRoot = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__Action__c = 'Remove', OB_Processor__c = 'EQUENS', NE__ProdId__c = productGTRoot.id, NE__Status__c = 'PENDING',OB_TermId__c='00987654', OB_FulfilmentStatus__c='Sent');
    insert orderItemGTRoot;

    
     Test.startTest();
      String orderid= configuration.id;
   
    List<NE__OrderItem__c> listOi = [SELECT OB_isNotIntegrated__c from NE__OrderItem__c where NE__OrderId__c = :orderid];
    
   
    
     OB_TrackingOrderMaintenance.updatePciandCommissione(configuration.id, true);
     System.assertEquals(false, listOi.get(0).OB_isNotIntegrated__c);
     
    Test.stopTest();
   }


    /*****************************************************************
Name:  OB_TrackingOrderMaintenance_Test
============================================================
Purpose: Test class for OB_TrackingOrderMaintenance
============================================================
History
-------                                                            
VERSION      AUTHOR             DATE             DETAIL          Description
1.0           Simone Misani      21/08/2019      Created         Creation of the class
*****************************************************************/
  @isTest
  public static void OB_TrackingOrderMaintenance_Test2(){
    List<Account> accList = new List<Account>();
    List<NE__OrderItem__c> oiList = new List<NE__OrderItem__c>();
    Id rtMerchant       = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId(); 
    Account myMastMerchant  = new Account(Name='TEST',
                                          RecordTypeId=rtMerchant,
                                          OB_Employees_Number__c='Minore di 10',
                                          OB_VAT_Not_Present__c=true, 
                                          OB_DescriptionVATNotPresent__c='description', 
                                          NE__Fiscal_code__c='RSSMRA80A01F205X',
                                          OB_BypassValidation__c=true,
                                          OB_Status__c='Active'); 

    Id accountBankRecordId   = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Bank').getRecordTypeId(); 
    Account bankAccount   = new Account(Name='TEST',
                                        RecordTypeId=accountBankRecordId,
                                        OB_Employees_Number__c='Minore di 10',
                                        OB_VAT_Not_Present__c=true, 
                                        OB_DescriptionVATNotPresent__c='description', 
                                        NE__Fiscal_code__c='RSSMRA80A01F205X',
                                        OB_BypassValidation__c=true,
                                        OB_Status__c='Active');   
    accList.add(myMastMerchant);
    accList.add(bankAccount);
    insert accList;
    NE__Service_Point__c servicePoint = new NE__Service_Point__c();
    insert servicePoint;
    NE__Order_Header__c orderHeader = new NE__Order_Header__c(OB_ProposerABI__c=bankAccount.Id ,NE__AccountId__c=myMastMerchant.Id, OB_Main_Process__c = 'Maintenance', OB_Sub_Process__c = 'variazione operativa', OB_Business_Model_Acquiring__c = 'Bancario');
    insert orderHeader;
    NE__Order__c configuration = new NE__Order__c(NE__AccountId__c=myMastMerchant.Id, OB_Service_Point__c = servicePoint.Id,NE__Order_Header__c=orderHeader.Id, OB_MCC__c = '0001', OB_MCCL2__c = '5631', OB_GT__c = 'Nexi', OB_PBSettlementMethod__c = 'PB Settlement Method', OB_InternationalSettlementMethod__c = 'International Settlement Method', OB_ReceiptCity__c = 'MILANO', OB_ReceiptHeader__c='Sweet Years', OB_Report_Type__c = 'Punto Vendita', OB_ShopSign__c = 'Sweet Years');
    insert configuration;

    //OrderItem ACQUIRING
      Id rtProductAcqRoot           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.ACQUIRING).getRecordTypeId(); 
    NE__Product__c productAcqRoot = new NE__Product__c(OB_Acquirer__c='', RecordTypeId =rtProductAcqRoot, OB_Codice_sfdc__c = 'VISAMASTERCARD', Name = 'Visa/Mastercard', OB_Contract_Type__c = 'Contratto Acquiring');
    insert productAcqRoot;
    NE__OrderItem__c orderItemAcqRoot = new NE__OrderItem__c(NE__Qty__c=10 ,NE__OrderId__c=configuration.id, NE__Action__c = 'Add', NE__ProdId__c = productAcqRoot.id, NE__Service_Point__c = servicePoint.Id, NE__Account__c = myMastMerchant.Id , OB_FulfilmentStatus__c = 'Completed');
    orderItemAcqRoot.NE__AssetItemEnterpriseId__c = orderItemAcqRoot.id;
    insert orderItemAcqRoot;
    oiList.add(orderItemAcqRoot);
    //OrderItem GT
    Id rtProductGTRoot          = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.TERMINALE).getRecordTypeId(); 
    NE__Product__c productGTRoot = new NE__Product__c(RecordTypeId = rtProductGTRoot, OB_Codice_sfdc__c = 'SMPOS_CASSA', Name = 'SmartPOS Cassa', OB_Contract_Type__c = 'Contratto POS;Modulo Off Commercial', OB_Business_Model_POS__c = 'Diretto;Trilaterale Nuovo');
    insert productGTRoot;
    NE__OrderItem__c orderItemGTRoot = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__Action__c = 'Add', OB_GT__c = 'MONETICA', OB_TermId__c = '4444333221', NE__ProdId__c = productGTRoot.id, NE__Status__c = 'PENDING', OB_FulfilmentStatus__c = 'Completed');
    orderItemGTRoot.NE__AssetItemEnterpriseId__c = orderItemGTRoot.id;
    insert orderItemGTRoot;

    
    oiList.add(orderItemGTRoot);
    NE__Order_Item_Attribute__c attrGTRoot1 = new NE__Order_Item_Attribute__c();
    attrGTRoot1.Name = 'TermId';
    attrGTRoot1.NE__Order_Item__c = orderItemGTRoot.id;
    
    insert attrGTRoot1;
    NE__Order_Item_Attribute__c attrGTRoot2 = new NE__Order_Item_Attribute__c();
    attrGTRoot2.Name = 'modello';
    attrGTRoot2.NE__Order_Item__c = orderItemGTRoot.id;
    
    insert attrGTRoot2;
    NE__Order_Item_Attribute__c attrGTRoot3 = new NE__Order_Item_Attribute__c();
    attrGTRoot3.Name = 'release';
    attrGTRoot3.NE__Order_Item__c = orderItemGTRoot.id;
   
    insert attrGTRoot3;
    NE__Order_Item_Attribute__c attrGTRoot4 = new NE__Order_Item_Attribute__c();
    attrGTRoot4.Name = 'modalitaCollegamento';
    attrGTRoot4.NE__Order_Item__c = orderItemGTRoot.id;
   
    insert attrGTRoot4;
    NE__Order_Item_Attribute__c attrGTRoot5 = new NE__Order_Item_Attribute__c();
    attrGTRoot5.Name = 'descrizioneModello';
    attrGTRoot5.NE__Order_Item__c = orderItemGTRoot.id;
    
    insert attrGTRoot5;
    NE__Order_Item_Attribute__c attrGTRoot6 = new NE__Order_Item_Attribute__c();
    attrGTRoot6.Name = 'descrizioneRelease';
    attrGTRoot6.NE__Order_Item__c = orderItemGTRoot.id;
 
    insert attrGTRoot6;
    NE__Order_Item_Attribute__c attrGTRoot7 = new NE__Order_Item_Attribute__c();
    attrGTRoot7.Name = 'descrizioneConnessione';
    attrGTRoot7.NE__Order_Item__c = orderItemGTRoot.id;
  
    insert attrGTRoot7;
    NE__Order_Item_Attribute__c attrGTRoot8 = new NE__Order_Item_Attribute__c();
    attrGTRoot8.Name = 'Progressivo SIA';
    attrGTRoot8.NE__Order_Item__c = orderItemGTRoot.id;
    
    insert attrGTRoot8;
    NE__Order_Item_Attribute__c attrGTRoot9 = new NE__Order_Item_Attribute__c();
    attrGTRoot9.Name = 'Codice Stabilimento SIA';
    attrGTRoot9.NE__Order_Item__c = orderItemGTRoot.id;
   
    insert attrGTRoot9;
    NE__Order_Item_Attribute__c attrGTRoot10 = new NE__Order_Item_Attribute__c();
    attrGTRoot10.Name = 'Codice SIA';
    attrGTRoot10.NE__Order_Item__c = orderItemGTRoot.id;
    
    insert attrGTRoot10;
    Id rtProductGT           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.TERMINALE).getRecordTypeId(); 
    NE__Product__c productGT = new NE__Product__c(RecordTypeId = rtProductGT, OB_Codice_sfdc__c = 'INST', Name = 'Installazione pos', OB_Contract_Type__c = 'Installazione pos', OB_Contract_Description__c = 'Installazione pos');
    insert productGT;
    NE__OrderItem__c orderItemGT = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__Parent_Order_Item__c = orderItemGTRoot.id, NE__Action__c = 'Add', NE__ProdId__c = productGT.id , OB_FulfilmentStatus__c = 'Completed');
    orderItemGT.NE__AssetItemEnterpriseId__c= orderItemGT.id;
    insert orderItemGT;

    //Item Acquiring Child
    Id rtProductAcq           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.ACQUIRING).getRecordTypeId(); 
    NE__Product__c productAcq = new NE__Product__c(RecordTypeId = rtProductAcq, OB_Acquirer__c='NEXI', OB_Codice_sfdc__c = 'VISAMASTERCARD', Name = 'Visa/Mastercard', OB_Contract_Type__c = 'Contratto Acquiring', OB_Offer__c ='PERSONALIZZATA;START;XPAY_FULL');
    insert productAcq;
    NE__OrderItem__c orderItemAcq = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__ProdId__c = productAcq.id, NE__Action__c = 'Add', NE__Parent_Order_Item__c = orderItemGTRoot.id, OB_FulfilmentStatus__c = 'Completed'); 
    orderItemAcq.NE__AssetItemEnterpriseId__c =orderItemAcq.id;
    insert orderItemAcq;
    Id rtProductPric           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.PRICING).getRecordTypeId(); 
    NE__Product__c productPric = new NE__Product__c(RecordTypeId = rtProductPric, OB_Codice_sfdc__c = 'MAE_PRE', Name = 'MAESTRO CONSUMER PREPAID', OB_Contract_Type__c = 'Contratto Acquiring');
    insert productPric;
    NE__OrderItem__c orderItemPric = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__ProdId__c = productPric.id, NE__Action__c = 'Add', NE__Parent_Order_Item__c = orderItemAcq.id, OB_FulfilmentStatus__c = 'Completed'); 
    orderItemPric.NE__AssetItemEnterpriseId__c =orderItemPric.id;
    insert orderItemPric;

    //ADD ITEM TO CONFIGURATION
    Id rtProductPB    = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.PAGOBANCOMAT).getRecordTypeId(); 
        NE__Product__c productPB    = new NE__Product__c(OB_Acquirer__c=OB_EnrichOrder.NEXI, RecordTypeId =rtProductPB, OB_Codice_sfdc__c = 'PAGOBANCOMAT' );
        insert productPB;
    NE__OrderItem__c pagobancomat = New NE__OrderItem__c(NE__Qty__c=1 ,NE__OrderId__c=configuration.id, NE__Action__c = 'None', NE__ProdId__c = productPB.id, OB_FulfilmentStatus__c = 'Completed');            
        insert pagobancomat;

    Id rtProductVAS   = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.VAS).getRecordTypeId(); 
    NE__Product__c productRootVAS   = new NE__Product__c(RecordTypeId = rtProductVAS, OB_Codice_sfdc__c = 'PELLEGRINI',OB_Acquirer__c='NEXI');
        insert productRootVAS;
    NE__OrderItem__c rootVas = New NE__OrderItem__c(NE__Qty__c=1 ,NE__OrderId__c=configuration.id, NE__Action__c = 'None', OB_FulfilmentStatus__c = 'Completed');   
    rootVas.NE__AssetItemEnterpriseId__c        =rootVas.id;
        insert rootVas;
    oiList.add(rootVas);
    NE__Product__c productVAS   = new NE__Product__c(RecordTypeId = rtProductVAS, OB_Codice_sfdc__c = 'PELLEGRINI',OB_Acquirer__c='NEXI');
        insert productVAS;
    NE__OrderItem__c vas = New NE__OrderItem__c(NE__Qty__c=1 ,NE__OrderId__c=configuration.id, NE__Action__c = 'Add', OB_FulfilmentStatus__c = 'Completed');        
    vas.NE__AssetItemEnterpriseId__c    =vas.id;
        insert vas;
    oiList.add(vas);
    NE__Product__c product1    = new NE__Product__c(OB_Acquirer__c=OB_EnrichOrder.NEXI , RecordTypeId =rtProductPric );
        product1.OB_Codice_sfdc__c = 'ALB_AUTO';
        insert product1;

        NE__OrderItem__c orderItem1 = new NE__OrderItem__c();
        orderItem1.NE__Qty__c     = 1;
        orderItem1.NE__OrderId__c = configuration.id;
        orderItem1.NE__ProdId__c  = product1.id;
    orderItem1.NE__Action__c = 'Add';
    orderItem1.OB_FulfilmentStatus__c = 'Completed';
    orderItem1.NE__Parent_Order_Item__c = orderItemAcq.id;
    orderItem1.NE__Parent_Order_Item__c = orderItemAcq.id;
    orderItem1.NE__AssetItemEnterpriseId__c = orderItem1.id;
        insert orderItem1;

    //orderItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.ACQUIRING && orderItem.NE__ProdId__r.OB_Acquirer__c!=OB_EnrichOrder.NEXI
    NE__Product__c productNotNexi    = new NE__Product__c(OB_Acquirer__c='AMEX' , RecordTypeId =rtProductAcqRoot, OB_Codice_sfdc__c = 'AMEX' );
        insert productNotNexi;

    NE__OrderItem__c orderItemNotNexi = new NE__OrderItem__c();
    orderItemNotNexi.NE__Qty__c     = 1;
        orderItemNotNexi.NE__OrderId__c = configuration.id;
        orderItemNotNexi.NE__ProdId__c  = productNotNexi.id;
    orderItemNotNexi.NE__Action__c = 'None';
    orderItemNotNexi.OB_FulfilmentStatus__c = 'Completed';
    orderItemNotNexi.NE__Parent_Order_Item__c = null;
    orderItemNotNexi.OB_FulfilmentStatus__c = 'Completed';
    orderItemNotNexi.NE__AssetItemEnterpriseId__c= orderItemNotNexi.id;
        insert orderItemNotNexi;

    NE__Product__c productNotNexiPricing   = new NE__Product__c(OB_Acquirer__c='AMEX' , RecordTypeId =rtProductPric, OB_Codice_sfdc__c = 'PRICING' );
        insert productNotNexiPricing;
    NE__OrderItem__c orderItemNotNexiPric = new NE__OrderItem__c();
    orderItemNotNexiPric.NE__Qty__c     = 1;
        orderItemNotNexiPric.NE__OrderId__c = configuration.id;
        orderItemNotNexiPric.NE__ProdId__c  = productNotNexiPricing.id;
    orderItemNotNexiPric.NE__Action__c = 'None';
    orderItemNotNexiPric.OB_FulfilmentStatus__c = 'Completed';
    orderItemNotNexiPric.NE__Parent_Order_Item__c = orderItemNotNexi.id;
    orderItemNotNexiPric.NE__AssetItemEnterpriseId__c= orderItemNotNexiPric.id;
        insert orderItemNotNexiPric;
    
    
    //ASSET
    Asset asset = new Asset(NE__AssetItemEnterpriseId__c = orderItemGTRoot.Id, OB_ShopCode__c = 'shopCode', OB_GT__c = 'GT', OB_CustomerCode__c = 'customerCode', Name = 'SmartPOS');
    insert asset;
    NE__AssetItemAttribute__c attr1 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.TERMID, NE__Asset__c = asset.id);
    insert attr1;
    NE__AssetItemAttribute__c attr2 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.MODELLO, NE__Asset__c = asset.id);
    insert attr2;
    NE__AssetItemAttribute__c attr3 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.RELEASE, NE__Asset__c = asset.id);
    insert attr3;
    NE__AssetItemAttribute__c attr4 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.MODCOLLEGAMENTO, NE__Asset__c = asset.id);
    insert attr4;
    NE__AssetItemAttribute__c attr5 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.DMODELLO, NE__Asset__c = asset.id);
    insert attr5;
    NE__AssetItemAttribute__c attr6 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.DRELEASE, NE__Asset__c = asset.id);
    insert attr6;
    NE__AssetItemAttribute__c attr7 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.DCONNESSIONE, NE__Asset__c = asset.id);
    insert attr7;
    NE__AssetItemAttribute__c attr8 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.PROGRESSIVOSIA, NE__Asset__c = asset.id);
    insert attr8;
    NE__AssetItemAttribute__c attr9 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.CODICESTABILIMENTOSIA, NE__Asset__c = asset.id);
    insert attr9;
    NE__AssetItemAttribute__c attr10 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.CODICESIA, NE__Asset__c = asset.id);
    insert attr10;

    //LOV
    NE__Lov__c lovMCC2 = new NE__Lov__c();
    lovMCC2.NE__Type__c   = 'mcc';
    lovMCC2.NE__Value3__c = 'L2';
    lovMCC2.OB_Value4__c  = configuration.OB_MCCL2__c;
    lovMCC2.NE__Value2__c = configuration.OB_MCCL2__c;
    insert lovMCC2;
    System.debug('@@@lovMCC2 '+lovMCC2);
    NE__Lov__c lov = new NE__Lov__c();
    lov.NE__Type__c     ='TRACKING';
    lov.NE__Sub_Type__c = 'TIPOLOGICHE';
    lov.NE__Value2__c   = 'DINERS';
    lov.NE__Value1__c   = '12';
    insert lov;

    OB_TrackingUtility.ErrorList error1 = new OB_TrackingUtility.ErrorList();

     List<OB_TrackingUtility.ErrorList> errorsList1 = new List<OB_TrackingUtility.ErrorList>();
      OB_TrackingUtility.ErrorList error2 = new OB_TrackingUtility.ErrorList();
    error2.code = '';
    error2.description = '';

    
   

    List<OB_TrackingUtility.ErrorList> errorsList2 = new List<OB_TrackingUtility.ErrorList>();
    errorsList2.add(error2);
    

    OB_TrackingUtility.Changes change = new OB_TrackingUtility.Changes();
    change.externalId = rootVas.id; //TERMINALE
    change.result = 'KO';
    change.errors = errorsList2; //List

   
  
    List<OB_TrackingUtility.Changes> changesList = new List<OB_TrackingUtility.Changes>();
    changesList.add(change);

    
    
    OB_TrackingUtility.CodiciConvenzioni codConv = new OB_TrackingUtility.CodiciConvenzioni();
    codConv.companyCode = 'companyCode';
    codConv.companyName = 'companyName';                                
    codConv.code        = 'code';                                       
    codConv.causaleRifiuto ='causaleRifiuto';
    codConv.startDate = '2011-11-13';
    codConv.endDate = '';
    codConv.status  = 'Active';

    List<OB_TrackingUtility.CodiciConvenzioni> codConvList = new List<OB_TrackingUtility.CodiciConvenzioni>();
    codConvList.add(codConv);

    OB_TrackingUtility.TermsIdInformation termInfo = new OB_TrackingUtility.TermsIdInformation();    
    termInfo.terminalId = orderItemGTRoot.OB_TermId__c;
    termInfo.model = 'model';
    termInfo.connectionType = 'connectionType';
    termInfo.modality = 'modality';
    termInfo.modelDescription = 'modelDescription';
    termInfo.release = 'release';
    termInfo.releaseDescription = 'releaseDescription';
    termInfo.status = 'Pending';
    termInfo.reasonOfRejection = '';
    termInfo.installationDate = '2011-11-13';
    termInfo.uninstallationDate = '';
    termInfo.agreementCodes = codConvList; //List
    termInfo.errors = null; //List

    List<OB_TrackingUtility.TermsIdInformation> termsInfoList = new List<OB_TrackingUtility.TermsIdInformation>();
    termsInfoList.add(termInfo);

    OB_TrackingUtility.ErrorList error = new OB_TrackingUtility.ErrorList();
    error.code = '';
    error.description = '';

    
   

    List<OB_TrackingUtility.ErrorList> errorsList = new List<OB_TrackingUtility.ErrorList>();
    errorsList.add(error);
   

    OB_TrackingUtility.puntoVendita pV = new OB_TrackingUtility.puntoVendita();
    //pV.itemId = '';
    pV.PVCode = servicePoint.id;
    pV.startDate = '2011-11-13';
    pV.endDate = '';
    pV.reasonOfClosure = '';
    //pV.tipo = '';
    pV.ctiCode = 'ctiCode';
    //NEXI Kinga Fornal, kinga.fornal@accenture.com,  08.08.20119 test fix START
    pV.StabiCode = 'StabiCode';
    pV.siaPVCode = 'pVCode';
    pV.siaProgressiveCode = 'progCode';
    pV.siaMerchantCode = 'merchCode';
    pV.assistanceNumber = 'assistanceNumber';
    //pV.dataInizioAttivita = '2011-11-13';
    pv.terminalInformation = termsInfoList; //List
    pv.changes = changesList;

    List<OB_TrackingUtility.puntoVendita> pVList = new List<OB_TrackingUtility.puntoVendita>();
    pVList.add(pV);

    OB_TrackingUtility.GT gT = new OB_TrackingUtility.GT();
    gT.source = 'MONETICA';
    gT.gtCompanyCode = 'companyCode';
    gT.errors = errorsList; //List
    gT.PVCodes = pVList; //List
    //gT.statoProvisioning = '';

    List<OB_TrackingUtility.GT> gTList = new List<OB_TrackingUtility.GT>();
    gTList.add(gT);

    OB_TrackingUtility.Acquiring acquiring = new OB_TrackingUtility.Acquiring();
    acquiring.source = 'NEXI';
    acquiring.companyCode = 'companyCode';
    acquiring.errori = null;
    acquiring.PVCodes = pVList;

    List<OB_TrackingUtility.Acquiring> acquiringList = new List<OB_TrackingUtility.Acquiring>();
    acquiringList.add(acquiring);

    OB_TrackingUtility.TrackingOrderRequestMaintenance trackingOrderRequest = new OB_TrackingUtility.TrackingOrderRequestMaintenance();
    trackingOrderRequest.orderId = configuration.id;
    trackingOrderRequest.Acquiring = acquiringList;
    trackingOrderRequest.GT = gTList;

    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();
    req.requestURI = '/TrackingOrderMaintenance/*'; 
    req.httpMethod = 'POST';
    RestContext.request = req;
    String json = JSON.serialize(trackingOrderRequest);
    RestContext.request.requestBody =  Blob.valueof(json);
    RestContext.response = res;

    List<OB_LogRequest__c> listLog = new List<OB_LogRequest__c>();
    OB_LogRequest__c log = OB_TestDataFactory.getLogRequest();
    insert log;
    OB_LogRequest__c log1 = OB_TestDataFactory.getLogRequest();
    insert log1;
    listLog.add(log);
     listLog.add(log1);
    Test.startTest();
    OB_TrackingUtility.TrackingOrderResponseMaintenance response = OB_TrackingOrderMaintenance.trackOrderMaintenance();
    // OB_TrackingOrderMaintenance.isAcquiringVas(acquiringList);
    // OB_TrackingOrderMaintenance.isAcquiringTerminal(acquiringList, true);
    // OB_TrackingOrderMaintenance.isAcquiringTerminal(acquiringList, false);
    // OB_TrackingOrderMaintenance.updateLogRequest(configuration.id);
    //OB_TrackingUtility.updateVasItems(oiList,changesList,'','','','',listLog);
    System.assertEquals( 500, response.httpStatus);
    Test.stopTest();
    }

     /*****************************************************************
Name:  OB_TrackingOrderMaintenance_Test
============================================================
Purpose: Test class for OB_TrackingOrderMaintenance
============================================================
History
-------                                                            
VERSION      AUTHOR             DATE             DETAIL          Description
1.0           Simone Misani      21/08/2019      Created         Creation of the class
*****************************************************************/

    @isTest
  public static void OB_TrackingOrderMaintenance_Test3(){
    List<Account> accList = new List<Account>();
    List<NE__OrderItem__c> oiList = new List<NE__OrderItem__c>();
    Id rtMerchant       = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId(); 
    Account myMastMerchant  = new Account(Name='TEST',
                                          RecordTypeId=rtMerchant,
                                          OB_Employees_Number__c='Minore di 10',
                                          OB_VAT_Not_Present__c=true, 
                                          OB_DescriptionVATNotPresent__c='description', 
                                          NE__Fiscal_code__c='RSSMRA80A01F205X',
                                          OB_BypassValidation__c=true,
                                          OB_Status__c='Active'); 

    Id accountBankRecordId   = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Bank').getRecordTypeId(); 
    Account bankAccount   = new Account(Name='TEST',
                                        RecordTypeId=accountBankRecordId,
                                        OB_Employees_Number__c='Minore di 10',
                                        OB_VAT_Not_Present__c=true, 
                                        OB_DescriptionVATNotPresent__c='description', 
                                        NE__Fiscal_code__c='RSSMRA80A01F205X',
                                        OB_BypassValidation__c=true,
                                        OB_Status__c='Active');   
    accList.add(myMastMerchant);
    accList.add(bankAccount);
    insert accList;
    NE__Service_Point__c servicePoint = new NE__Service_Point__c();
    insert servicePoint;
    NE__Order_Header__c orderHeader = new NE__Order_Header__c(OB_ProposerABI__c=bankAccount.Id ,NE__AccountId__c=myMastMerchant.Id, OB_Main_Process__c = 'Maintenance', OB_Sub_Process__c = 'variazione operativa', OB_Business_Model_Acquiring__c = 'Bancario');
    insert orderHeader;
    NE__Order__c configuration = new NE__Order__c(NE__AccountId__c=myMastMerchant.Id, OB_Service_Point__c = servicePoint.Id,NE__Order_Header__c=orderHeader.Id, OB_MCC__c = '0001', OB_MCCL2__c = '5631', OB_GT__c = 'Nexi', OB_PBSettlementMethod__c = 'PB Settlement Method', OB_InternationalSettlementMethod__c = 'International Settlement Method', OB_ReceiptCity__c = 'MILANO', OB_ReceiptHeader__c='Sweet Years', OB_Report_Type__c = 'Punto Vendita', OB_ShopSign__c = 'Sweet Years');
    insert configuration;

    //OrderItem ACQUIRING
    Id rtProductAcqRoot           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.ACQUIRING).getRecordTypeId(); 
    NE__Product__c productAcqRoot = new NE__Product__c(OB_Acquirer__c='', RecordTypeId =rtProductAcqRoot, OB_Codice_sfdc__c = 'VISAMASTERCARD', Name = 'Visa/Mastercard', OB_Contract_Type__c = 'Contratto Acquiring');
    insert productAcqRoot;
    NE__OrderItem__c orderItemAcqRoot = new NE__OrderItem__c(NE__Qty__c=10 ,NE__OrderId__c=configuration.id, NE__Action__c = 'Add', NE__ProdId__c = productAcqRoot.id, NE__Service_Point__c = servicePoint.Id, NE__Account__c = myMastMerchant.Id , OB_FulfilmentStatus__c = 'Completed');
    orderItemAcqRoot.NE__AssetItemEnterpriseId__c = orderItemAcqRoot.id;
    insert orderItemAcqRoot;
    oiList.add(orderItemAcqRoot);
    //OrderItem GT
    Id rtProductGTRoot          = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.TERMINALE).getRecordTypeId(); 
    NE__Product__c productGTRoot = new NE__Product__c(RecordTypeId = rtProductGTRoot, OB_Codice_sfdc__c = 'SMPOS_CASSA', Name = 'SmartPOS Cassa', OB_Contract_Type__c = 'Contratto POS;Modulo Off Commercial', OB_Business_Model_POS__c = 'Diretto;Trilaterale Nuovo');
    insert productGTRoot;
    NE__OrderItem__c orderItemGTRoot = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__Action__c = 'Add', OB_GT__c = 'MONETICA', OB_TermId__c = '4444333221', NE__ProdId__c = productGTRoot.id, NE__Status__c = 'PENDING', OB_FulfilmentStatus__c = 'Completed');
    orderItemGTRoot.NE__AssetItemEnterpriseId__c = orderItemGTRoot.id;
    insert orderItemGTRoot;

    
    oiList.add(orderItemGTRoot);
    NE__Order_Item_Attribute__c attrGTRoot1 = new NE__Order_Item_Attribute__c();
    attrGTRoot1.Name = 'TermId';
    attrGTRoot1.NE__Order_Item__c = orderItemGTRoot.id;
    
    insert attrGTRoot1;
    NE__Order_Item_Attribute__c attrGTRoot2 = new NE__Order_Item_Attribute__c();
    attrGTRoot2.Name = 'modello';
    attrGTRoot2.NE__Order_Item__c = orderItemGTRoot.id;
    
    insert attrGTRoot2;
    NE__Order_Item_Attribute__c attrGTRoot3 = new NE__Order_Item_Attribute__c();
    attrGTRoot3.Name = 'release';
    attrGTRoot3.NE__Order_Item__c = orderItemGTRoot.id;
   
    insert attrGTRoot3;
    NE__Order_Item_Attribute__c attrGTRoot4 = new NE__Order_Item_Attribute__c();
    attrGTRoot4.Name = 'modalitaCollegamento';
    attrGTRoot4.NE__Order_Item__c = orderItemGTRoot.id;
   
    insert attrGTRoot4;
    NE__Order_Item_Attribute__c attrGTRoot5 = new NE__Order_Item_Attribute__c();
    attrGTRoot5.Name = 'descrizioneModello';
    attrGTRoot5.NE__Order_Item__c = orderItemGTRoot.id;
    
    insert attrGTRoot5;
    NE__Order_Item_Attribute__c attrGTRoot6 = new NE__Order_Item_Attribute__c();
    attrGTRoot6.Name = 'descrizioneRelease';
    attrGTRoot6.NE__Order_Item__c = orderItemGTRoot.id;
 
    insert attrGTRoot6;
    NE__Order_Item_Attribute__c attrGTRoot7 = new NE__Order_Item_Attribute__c();
    attrGTRoot7.Name = 'descrizioneConnessione';
    attrGTRoot7.NE__Order_Item__c = orderItemGTRoot.id;
  
    insert attrGTRoot7;
    NE__Order_Item_Attribute__c attrGTRoot8 = new NE__Order_Item_Attribute__c();
    attrGTRoot8.Name = 'Progressivo SIA';
    attrGTRoot8.NE__Order_Item__c = orderItemGTRoot.id;
    
    insert attrGTRoot8;
    NE__Order_Item_Attribute__c attrGTRoot9 = new NE__Order_Item_Attribute__c();
    attrGTRoot9.Name = 'Codice Stabilimento SIA';
    attrGTRoot9.NE__Order_Item__c = orderItemGTRoot.id;
   
    insert attrGTRoot9;
    NE__Order_Item_Attribute__c attrGTRoot10 = new NE__Order_Item_Attribute__c();
    attrGTRoot10.Name = 'Codice SIA';
    attrGTRoot10.NE__Order_Item__c = orderItemGTRoot.id;
    
    insert attrGTRoot10;
    Id rtProductGT           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.TERMINALE).getRecordTypeId(); 
    NE__Product__c productGT = new NE__Product__c(RecordTypeId = rtProductGT, OB_Codice_sfdc__c = 'INST', Name = 'Installazione pos', OB_Contract_Type__c = 'Installazione pos', OB_Contract_Description__c = 'Installazione pos');
    insert productGT;
    NE__OrderItem__c orderItemGT = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__Parent_Order_Item__c = orderItemGTRoot.id, NE__Action__c = 'Add', NE__ProdId__c = productGT.id , OB_FulfilmentStatus__c = 'Completed');
    orderItemGT.NE__AssetItemEnterpriseId__c= orderItemGT.id;
    insert orderItemGT;

    //Item Acquiring Child
    Id rtProductAcq           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.ACQUIRING).getRecordTypeId(); 
    NE__Product__c productAcq = new NE__Product__c(RecordTypeId = rtProductAcq, OB_Acquirer__c='NEXI', OB_Codice_sfdc__c = 'VISAMASTERCARD', Name = 'Visa/Mastercard', OB_Contract_Type__c = 'Contratto Acquiring', OB_Offer__c ='PERSONALIZZATA;START;XPAY_FULL');
    insert productAcq;
    NE__OrderItem__c orderItemAcq = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__ProdId__c = productAcq.id, NE__Action__c = 'Add', NE__Parent_Order_Item__c = orderItemGTRoot.id, OB_FulfilmentStatus__c = 'Completed'); 
    orderItemAcq.NE__AssetItemEnterpriseId__c =orderItemAcq.id;
    insert orderItemAcq;
    Id rtProductPric           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.PRICING).getRecordTypeId(); 
    NE__Product__c productPric = new NE__Product__c(RecordTypeId = rtProductPric, OB_Codice_sfdc__c = 'MAE_PRE', Name = 'MAESTRO CONSUMER PREPAID', OB_Contract_Type__c = 'Contratto Acquiring');
    insert productPric;
    NE__OrderItem__c orderItemPric = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__ProdId__c = productPric.id, NE__Action__c = 'Add', NE__Parent_Order_Item__c = orderItemAcq.id, OB_FulfilmentStatus__c = 'Completed'); 
    orderItemPric.NE__AssetItemEnterpriseId__c =orderItemPric.id;
    insert orderItemPric;

    //ADD ITEM TO CONFIGURATION
    Id rtProductPB    = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.PAGOBANCOMAT).getRecordTypeId(); 
        NE__Product__c productPB    = new NE__Product__c(OB_Acquirer__c=OB_EnrichOrder.NEXI, RecordTypeId =rtProductPB, OB_Codice_sfdc__c = 'PAGOBANCOMAT' );
        insert productPB;
    NE__OrderItem__c pagobancomat = New NE__OrderItem__c(NE__Qty__c=1 ,NE__OrderId__c=configuration.id, NE__Action__c = 'None', NE__ProdId__c = productPB.id, OB_FulfilmentStatus__c = 'Completed');            
        insert pagobancomat;

    Id rtProductVAS   = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.VAS).getRecordTypeId(); 
    NE__Product__c productRootVAS   = new NE__Product__c(RecordTypeId = rtProductVAS, OB_Codice_sfdc__c = 'PELLEGRINI',OB_Acquirer__c='NEXI');
        insert productRootVAS;
    NE__OrderItem__c rootVas = New NE__OrderItem__c(NE__Qty__c=1 ,NE__OrderId__c=configuration.id, NE__Action__c = 'None', OB_FulfilmentStatus__c = 'Completed');   
    rootVas.NE__AssetItemEnterpriseId__c        =rootVas.id;
        insert rootVas;
    oiList.add(rootVas);
    NE__Product__c productVAS   = new NE__Product__c(RecordTypeId = rtProductVAS, OB_Codice_sfdc__c = 'PELLEGRINI',OB_Acquirer__c='NEXI');
        insert productVAS;
    NE__OrderItem__c vas = New NE__OrderItem__c(NE__Qty__c=1 ,NE__OrderId__c=configuration.id, NE__Action__c = 'Add', OB_FulfilmentStatus__c = 'Completed');        
    vas.NE__AssetItemEnterpriseId__c    =vas.id;
        insert vas;
    oiList.add(vas);
    NE__Product__c product1    = new NE__Product__c(OB_Acquirer__c=OB_EnrichOrder.NEXI , RecordTypeId =rtProductPric );
        product1.OB_Codice_sfdc__c = 'ALB_AUTO';
        insert product1;

        NE__OrderItem__c orderItem1 = new NE__OrderItem__c();
        orderItem1.NE__Qty__c     = 1;
        orderItem1.NE__OrderId__c = configuration.id;
        orderItem1.NE__ProdId__c  = product1.id;
    orderItem1.NE__Action__c = 'Add';
    orderItem1.OB_FulfilmentStatus__c = 'Completed';
    orderItem1.NE__Parent_Order_Item__c = orderItemAcq.id;
    orderItem1.NE__Parent_Order_Item__c = orderItemAcq.id;
    orderItem1.NE__AssetItemEnterpriseId__c = orderItem1.id;
        insert orderItem1;

    //orderItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.ACQUIRING && orderItem.NE__ProdId__r.OB_Acquirer__c!=OB_EnrichOrder.NEXI
    NE__Product__c productNotNexi    = new NE__Product__c(OB_Acquirer__c='AMEX' , RecordTypeId =rtProductAcqRoot, OB_Codice_sfdc__c = 'AMEX' );
        insert productNotNexi;

    NE__OrderItem__c orderItemNotNexi = new NE__OrderItem__c();
    orderItemNotNexi.NE__Qty__c     = 1;
        orderItemNotNexi.NE__OrderId__c = configuration.id;
        orderItemNotNexi.NE__ProdId__c  = productNotNexi.id;
    orderItemNotNexi.NE__Action__c = 'None';
    orderItemNotNexi.OB_FulfilmentStatus__c = 'Completed';
    orderItemNotNexi.NE__Parent_Order_Item__c = null;
    orderItemNotNexi.OB_FulfilmentStatus__c = 'Completed';
    orderItemNotNexi.NE__AssetItemEnterpriseId__c= orderItemNotNexi.id;
        insert orderItemNotNexi;

    NE__Product__c productNotNexiPricing   = new NE__Product__c(OB_Acquirer__c='AMEX' , RecordTypeId =rtProductPric, OB_Codice_sfdc__c = 'PRICING' );
        insert productNotNexiPricing;
    NE__OrderItem__c orderItemNotNexiPric = new NE__OrderItem__c();
    orderItemNotNexiPric.NE__Qty__c     = 1;
        orderItemNotNexiPric.NE__OrderId__c = configuration.id;
        orderItemNotNexiPric.NE__ProdId__c  = productNotNexiPricing.id;
    orderItemNotNexiPric.NE__Action__c = 'None';
    orderItemNotNexiPric.OB_FulfilmentStatus__c = 'Completed';
    orderItemNotNexiPric.NE__Parent_Order_Item__c = orderItemNotNexi.id;
    orderItemNotNexiPric.NE__AssetItemEnterpriseId__c= orderItemNotNexiPric.id;
        insert orderItemNotNexiPric;
    
    
    
    
    //ASSET
    Asset asset = new Asset(NE__AssetItemEnterpriseId__c = orderItemGTRoot.Id, OB_ShopCode__c = 'shopCode', OB_GT__c = 'GT', OB_CustomerCode__c = 'customerCode', Name = 'SmartPOS');
    insert asset;
    NE__AssetItemAttribute__c attr1 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.TERMID, NE__Asset__c = asset.id);
    insert attr1;
    NE__AssetItemAttribute__c attr2 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.MODELLO, NE__Asset__c = asset.id);
    insert attr2;
    NE__AssetItemAttribute__c attr3 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.RELEASE, NE__Asset__c = asset.id);
    insert attr3;
    NE__AssetItemAttribute__c attr4 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.MODCOLLEGAMENTO, NE__Asset__c = asset.id);
    insert attr4;
    NE__AssetItemAttribute__c attr5 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.DMODELLO, NE__Asset__c = asset.id);
    insert attr5;
    NE__AssetItemAttribute__c attr6 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.DRELEASE, NE__Asset__c = asset.id);
    insert attr6;
    NE__AssetItemAttribute__c attr7 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.DCONNESSIONE, NE__Asset__c = asset.id);
    insert attr7;
    NE__AssetItemAttribute__c attr8 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.PROGRESSIVOSIA, NE__Asset__c = asset.id);
    insert attr8;
    NE__AssetItemAttribute__c attr9 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.CODICESTABILIMENTOSIA, NE__Asset__c = asset.id);
    insert attr9;
    NE__AssetItemAttribute__c attr10 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.CODICESIA, NE__Asset__c = asset.id);
    insert attr10;


    ExternalSourceMapping__c ex = OB_TestDataFactory.getExternalSourceMapping( );
    ex.OB_Source__c = 'MONETICA';
     ex.OB_CustomerCodeClientCode__c =null;
     ex.OB_ServicePointCodeShopCode__c =null;
      ex.OB_Service_Point_ID__c = servicePoint.id ;
      insert ex;
    //LOV
    NE__Lov__c lovMCC2 = new NE__Lov__c();
    lovMCC2.NE__Type__c   = 'mcc';
    lovMCC2.NE__Value3__c = 'L2';
    lovMCC2.OB_Value4__c  = configuration.OB_MCCL2__c;
    lovMCC2.NE__Value2__c = configuration.OB_MCCL2__c;
    insert lovMCC2;
    System.debug('@@@lovMCC2 '+lovMCC2);
    NE__Lov__c lov = new NE__Lov__c();
    lov.NE__Type__c     ='TRACKING';
    lov.NE__Sub_Type__c = 'TIPOLOGICHE';
    lov.NE__Value2__c   = 'DINERS';
    lov.NE__Value1__c   = '12';
    insert lov;

    OB_TrackingUtility.ErrorList error1 = new OB_TrackingUtility.ErrorList();

     List<OB_TrackingUtility.ErrorList> errorsList1 = new List<OB_TrackingUtility.ErrorList>();
      OB_TrackingUtility.ErrorList error2 = new OB_TrackingUtility.ErrorList();
    error2.code = '';
    error2.description = '';

    
   

    List<OB_TrackingUtility.ErrorList> errorsList2 = new List<OB_TrackingUtility.ErrorList>();
    errorsList2.add(error2);
    

    OB_TrackingUtility.Changes change = new OB_TrackingUtility.Changes();
    change.externalId = orderItemAcqRoot.id; //TERMINALE
    change.result = 'KO';
    change.errors = errorsList2; //List

   
  
    List<OB_TrackingUtility.Changes> changesList = new List<OB_TrackingUtility.Changes>();
    changesList.add(change);

    
    
    OB_TrackingUtility.CodiciConvenzioni codConv = new OB_TrackingUtility.CodiciConvenzioni();
    codConv.companyCode = 'companyCode';
    codConv.companyName = 'companyName';                                
    codConv.code        = 'code';                                       
    codConv.causaleRifiuto ='causaleRifiuto';
    codConv.startDate = '2011-11-13';
    codConv.endDate = '';
    codConv.status  = 'Active';

    List<OB_TrackingUtility.CodiciConvenzioni> codConvList = new List<OB_TrackingUtility.CodiciConvenzioni>();
    codConvList.add(codConv);

    OB_TrackingUtility.TermsIdInformation termInfo = new OB_TrackingUtility.TermsIdInformation();    
    termInfo.terminalId = orderItemGTRoot.OB_TermId__c;
    termInfo.model = 'model';
    termInfo.connectionType = 'connectionType';
    termInfo.modality = 'modality';
    termInfo.modelDescription = 'modelDescription';
    termInfo.release = 'release';
    termInfo.releaseDescription = 'releaseDescription';
    termInfo.status = 'Pending';
    termInfo.reasonOfRejection = '';
    termInfo.installationDate = '2011-11-13';
    termInfo.uninstallationDate = '';
    termInfo.agreementCodes = codConvList; //List
    termInfo.errors = null; //List

    List<OB_TrackingUtility.TermsIdInformation> termsInfoList = new List<OB_TrackingUtility.TermsIdInformation>();
    termsInfoList.add(termInfo);

    OB_TrackingUtility.ErrorList error = new OB_TrackingUtility.ErrorList();
    error.code = '';
    error.description = '';

    
   

    List<OB_TrackingUtility.ErrorList> errorsList = new List<OB_TrackingUtility.ErrorList>();
    errorsList.add(error);
   

    OB_TrackingUtility.puntoVendita pV = new OB_TrackingUtility.puntoVendita();
    //pV.itemId = '';
    pV.PVCode = servicePoint.id;
    pV.startDate = '2011-11-13';
    pV.endDate = '';
    pV.reasonOfClosure = '';
    //pV.tipo = '';
    pV.ctiCode = 'ctiCode';
    pV.StabiCode = 'StabiCode';
    pV.siaPVCode = 'siaPVCode';
    pV.siaProgressiveCode = 'siaProgressiveCode';
    pV.siaMerchantCode = 'siaMerchantCode';
    pV.assistanceNumber = 'assistanceNumber';
    //pV.dataInizioAttivita = '2011-11-13';
    pv.terminalInformation = termsInfoList; //List
    pv.changes = changesList;

    List<OB_TrackingUtility.puntoVendita> pVList = new List<OB_TrackingUtility.puntoVendita>();
    pVList.add(pV);

    OB_TrackingUtility.GT gT = new OB_TrackingUtility.GT();
    gT.source = 'MONETICA';
    gT.gtCompanyCode = 'companyCode';
    gT.errors = errorsList; //List
    gT.PVCodes = pVList; //List
    //gT.statoProvisioning = '';

    List<OB_TrackingUtility.GT> gTList = new List<OB_TrackingUtility.GT>();
    gTList.add(gT);

    OB_TrackingUtility.Acquiring acquiring = new OB_TrackingUtility.Acquiring();
    acquiring.source = 'NEXI';
    acquiring.companyCode = 'companyCode';
    acquiring.errori = null;
    acquiring.PVCodes = pVList;

    List<OB_TrackingUtility.Acquiring> acquiringList = new List<OB_TrackingUtility.Acquiring>();
    acquiringList.add(acquiring);

    OB_TrackingUtility.TrackingOrderRequestMaintenance trackingOrderRequest = new OB_TrackingUtility.TrackingOrderRequestMaintenance();
    trackingOrderRequest.orderId = configuration.id;
    trackingOrderRequest.Acquiring = acquiringList;
    //trackingOrderRequest.GT = gTList;

    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();
    req.requestURI = '/TrackingOrderMaintenance/*'; 
    req.httpMethod = 'POST';
    RestContext.request = req;
    String json = JSON.serialize(trackingOrderRequest);
    RestContext.request.requestBody =  Blob.valueof(json);
    RestContext.response = res;

    List<OB_LogRequest__c> listLog = new List<OB_LogRequest__c>();
    OB_LogRequest__c log = OB_TestDataFactory.getLogRequest();
    insert log;
    OB_LogRequest__c log1 = OB_TestDataFactory.getLogRequest();
    insert log1;
    listLog.add(log);
     listLog.add(log1);
    Test.startTest();
    OB_TrackingUtility.TrackingOrderResponseMaintenance response = OB_TrackingOrderMaintenance.trackOrderMaintenance();
    // OB_TrackingOrderMaintenance.isAcquiringVas(acquiringList);
    // OB_TrackingOrderMaintenance.isAcquiringTerminal(acquiringList, true);
    // OB_TrackingOrderMaintenance.isAcquiringTerminal(acquiringList, false);
    // OB_TrackingOrderMaintenance.updateLogRequest(configuration.id);
    System.assertEquals(  200, response.httpStatus);
    Test.stopTest();
    }


     /*****************************************************************
Name:  OB_TrackingOrderMaintenance_Test
============================================================
Purpose: Test class for OB_TrackingOrderMaintenance
============================================================
History
-------                                                            
VERSION      AUTHOR             DATE             DETAIL          Description
1.0           Simone Misani      21/08/2019      Created         Creation of the class
*****************************************************************/
    @isTest
  public static void OB_TrackingOrderMaintenance_Test4(){
    List<Account> accList = new List<Account>();
    List<NE__OrderItem__c> oiList = new List<NE__OrderItem__c>();
    Id rtMerchant       = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId(); 
    Account myMastMerchant  = new Account(Name='TEST',
                                          RecordTypeId=rtMerchant,
                                          OB_Employees_Number__c='Minore di 10',
                                          OB_VAT_Not_Present__c=true, 
                                          OB_DescriptionVATNotPresent__c='description', 
                                          NE__Fiscal_code__c='RSSMRA80A01F205X',
                                          OB_BypassValidation__c=true,
                                          OB_Status__c='Active'); 

    Id accountBankRecordId   = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Bank').getRecordTypeId(); 
    Account bankAccount   = new Account(Name='TEST',
                                        RecordTypeId=accountBankRecordId,
                                        OB_Employees_Number__c='Minore di 10',
                                        OB_VAT_Not_Present__c=true, 
                                        OB_DescriptionVATNotPresent__c='description', 
                                        NE__Fiscal_code__c='RSSMRA80A01F205X',
                                        OB_BypassValidation__c=true,
                                        OB_Status__c='Active');   
    accList.add(myMastMerchant);
    accList.add(bankAccount);
    insert accList;
    NE__Service_Point__c servicePoint = new NE__Service_Point__c();
    insert servicePoint;
    NE__Order_Header__c orderHeader = new NE__Order_Header__c(OB_ProposerABI__c=bankAccount.Id ,NE__AccountId__c=myMastMerchant.Id, OB_Main_Process__c = 'Maintenance', OB_Sub_Process__c = 'variazione operativa', OB_Business_Model_Acquiring__c = 'Bancario');
    insert orderHeader;
    NE__Order__c configuration = new NE__Order__c(NE__AccountId__c=myMastMerchant.Id, OB_Service_Point__c = servicePoint.Id,NE__Order_Header__c=orderHeader.Id, OB_MCC__c = '0001', OB_MCCL2__c = '5631', OB_GT__c = 'Nexi', OB_PBSettlementMethod__c = 'PB Settlement Method', OB_InternationalSettlementMethod__c = 'International Settlement Method', OB_ReceiptCity__c = 'MILANO', OB_ReceiptHeader__c='Sweet Years', OB_Report_Type__c = 'Punto Vendita', OB_ShopSign__c = 'Sweet Years');
    insert configuration;

    //OrderItem ACQUIRING
     Id rtProductAcqRoot           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.ACQUIRING).getRecordTypeId(); 
    NE__Product__c productAcqRoot = new NE__Product__c(OB_Acquirer__c='', RecordTypeId =rtProductAcqRoot, OB_Codice_sfdc__c = 'VISAMASTERCARD', Name = 'Visa/Mastercard', OB_Contract_Type__c = 'Contratto Acquiring');
    insert productAcqRoot;
    NE__OrderItem__c orderItemAcqRoot = new NE__OrderItem__c(NE__Qty__c=10 ,NE__OrderId__c=configuration.id, NE__Action__c = 'Add', NE__ProdId__c = productAcqRoot.id, NE__Service_Point__c = servicePoint.Id, NE__Account__c = myMastMerchant.Id , OB_FulfilmentStatus__c = 'Completed');
    orderItemAcqRoot.NE__AssetItemEnterpriseId__c = orderItemAcqRoot.id;
    insert orderItemAcqRoot;
    oiList.add(orderItemAcqRoot);
    //OrderItem GT
    Id rtProductGTRoot          = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.TERMINALE).getRecordTypeId(); 
    NE__Product__c productGTRoot = new NE__Product__c(RecordTypeId = rtProductGTRoot, OB_Codice_sfdc__c = 'SMPOS_CASSA', Name = 'SmartPOS Cassa', OB_Contract_Type__c = 'Contratto POS;Modulo Off Commercial', OB_Business_Model_POS__c = 'Diretto;Trilaterale Nuovo');
    insert productGTRoot;
    NE__OrderItem__c orderItemGTRoot = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__Action__c = 'Add', OB_GT__c = 'MONETICA', OB_TermId__c = '4444333221', NE__ProdId__c = productGTRoot.id, NE__Status__c = 'PENDING', OB_FulfilmentStatus__c = 'Completed');
    orderItemGTRoot.NE__AssetItemEnterpriseId__c = orderItemGTRoot.id;
    insert orderItemGTRoot;

    
    oiList.add(orderItemGTRoot);
    NE__Order_Item_Attribute__c attrGTRoot1 = new NE__Order_Item_Attribute__c();
    attrGTRoot1.Name = 'TermId';
    attrGTRoot1.NE__Order_Item__c = orderItemGTRoot.id;
    
    insert attrGTRoot1;
    NE__Order_Item_Attribute__c attrGTRoot2 = new NE__Order_Item_Attribute__c();
    attrGTRoot2.Name = 'modello';
    attrGTRoot2.NE__Order_Item__c = orderItemGTRoot.id;
    
    insert attrGTRoot2;
    NE__Order_Item_Attribute__c attrGTRoot3 = new NE__Order_Item_Attribute__c();
    attrGTRoot3.Name = 'release';
    attrGTRoot3.NE__Order_Item__c = orderItemGTRoot.id;
   
    insert attrGTRoot3;
    NE__Order_Item_Attribute__c attrGTRoot4 = new NE__Order_Item_Attribute__c();
    attrGTRoot4.Name = 'modalitaCollegamento';
    attrGTRoot4.NE__Order_Item__c = orderItemGTRoot.id;
   
    insert attrGTRoot4;
    NE__Order_Item_Attribute__c attrGTRoot5 = new NE__Order_Item_Attribute__c();
    attrGTRoot5.Name = 'descrizioneModello';
    attrGTRoot5.NE__Order_Item__c = orderItemGTRoot.id;
    
    insert attrGTRoot5;
    NE__Order_Item_Attribute__c attrGTRoot6 = new NE__Order_Item_Attribute__c();
    attrGTRoot6.Name = 'descrizioneRelease';
    attrGTRoot6.NE__Order_Item__c = orderItemGTRoot.id;
 
    insert attrGTRoot6;
    NE__Order_Item_Attribute__c attrGTRoot7 = new NE__Order_Item_Attribute__c();
    attrGTRoot7.Name = 'descrizioneConnessione';
    attrGTRoot7.NE__Order_Item__c = orderItemGTRoot.id;
  
    insert attrGTRoot7;
    NE__Order_Item_Attribute__c attrGTRoot8 = new NE__Order_Item_Attribute__c();
    attrGTRoot8.Name = 'Progressivo SIA';
    attrGTRoot8.NE__Order_Item__c = orderItemGTRoot.id;
    
    insert attrGTRoot8;
    NE__Order_Item_Attribute__c attrGTRoot9 = new NE__Order_Item_Attribute__c();
    attrGTRoot9.Name = 'Codice Stabilimento SIA';
    attrGTRoot9.NE__Order_Item__c = orderItemGTRoot.id;
   
    insert attrGTRoot9;
    NE__Order_Item_Attribute__c attrGTRoot10 = new NE__Order_Item_Attribute__c();
    attrGTRoot10.Name = 'Codice SIA';
    attrGTRoot10.NE__Order_Item__c = orderItemGTRoot.id;
    
    insert attrGTRoot10;
    Id rtProductGT           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.TERMINALE).getRecordTypeId(); 
    NE__Product__c productGT = new NE__Product__c(RecordTypeId = rtProductGT, OB_Codice_sfdc__c = 'INST', Name = 'Installazione pos', OB_Contract_Type__c = 'Installazione pos', OB_Contract_Description__c = 'Installazione pos');
    insert productGT;
    NE__OrderItem__c orderItemGT = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__Parent_Order_Item__c = orderItemGTRoot.id, NE__Action__c = 'Add', NE__ProdId__c = productGT.id , OB_FulfilmentStatus__c = 'Completed');
    orderItemGT.NE__AssetItemEnterpriseId__c= orderItemGT.id;
    insert orderItemGT;

    //Item Acquiring Child
    Id rtProductAcq           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.ACQUIRING).getRecordTypeId(); 
    NE__Product__c productAcq = new NE__Product__c(RecordTypeId = rtProductAcq, OB_Acquirer__c='NEXI', OB_Codice_sfdc__c = 'VISAMASTERCARD', Name = 'Visa/Mastercard', OB_Contract_Type__c = 'Contratto Acquiring', OB_Offer__c ='PERSONALIZZATA;START;XPAY_FULL');
    insert productAcq;
    NE__OrderItem__c orderItemAcq = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__ProdId__c = productAcq.id, NE__Action__c = 'Add', NE__Parent_Order_Item__c = orderItemGTRoot.id, OB_FulfilmentStatus__c = 'Completed'); 
    orderItemAcq.NE__AssetItemEnterpriseId__c =orderItemAcq.id;
    insert orderItemAcq;
    Id rtProductPric           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.PRICING).getRecordTypeId(); 
    NE__Product__c productPric = new NE__Product__c(RecordTypeId = rtProductPric, OB_Codice_sfdc__c = 'MAE_PRE', Name = 'MAESTRO CONSUMER PREPAID', OB_Contract_Type__c = 'Contratto Acquiring');
    insert productPric;
    NE__OrderItem__c orderItemPric = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__ProdId__c = productPric.id, NE__Action__c = 'Add', NE__Parent_Order_Item__c = orderItemAcq.id, OB_FulfilmentStatus__c = 'Completed'); 
    orderItemPric.NE__AssetItemEnterpriseId__c =orderItemPric.id;
    insert orderItemPric;

    //ADD ITEM TO CONFIGURATION
    Id rtProductPB    = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.PAGOBANCOMAT).getRecordTypeId(); 
        NE__Product__c productPB    = new NE__Product__c(OB_Acquirer__c=OB_EnrichOrder.NEXI, RecordTypeId =rtProductPB, OB_Codice_sfdc__c = 'PAGOBANCOMAT' );
        insert productPB;
    NE__OrderItem__c pagobancomat = New NE__OrderItem__c(NE__Qty__c=1 ,NE__OrderId__c=configuration.id, NE__Action__c = 'None', NE__ProdId__c = productPB.id, OB_FulfilmentStatus__c = 'Completed');
         
        insert pagobancomat;
       

    Id rtProductVAS   = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.VAS).getRecordTypeId(); 
    NE__Product__c productRootVAS   = new NE__Product__c(RecordTypeId = rtProductVAS, OB_Codice_sfdc__c = 'PELLEGRINI',OB_Acquirer__c='NEXI');
        insert productRootVAS;
    NE__OrderItem__c rootVas = New NE__OrderItem__c(NE__Qty__c=1 ,NE__OrderId__c=configuration.id, NE__Action__c = 'None', OB_FulfilmentStatus__c = 'Completed');   
    rootVas.NE__AssetItemEnterpriseId__c        =rootVas.id;
        insert rootVas;
    oiList.add(rootVas);
    NE__Product__c productVAS   = new NE__Product__c(RecordTypeId = rtProductVAS, OB_Codice_sfdc__c = 'PELLEGRINI',OB_Acquirer__c='NEXI');
        insert productVAS;
    NE__OrderItem__c vas = New NE__OrderItem__c(NE__Qty__c=1 ,NE__OrderId__c=configuration.id, NE__Action__c = 'Add', OB_FulfilmentStatus__c = 'Completed');        
    vas.NE__AssetItemEnterpriseId__c    =vas.id;
        insert vas;
    oiList.add(vas);
    NE__Product__c product1    = new NE__Product__c(OB_Acquirer__c=OB_EnrichOrder.NEXI , RecordTypeId =rtProductPric );
        product1.OB_Codice_sfdc__c = 'ALB_AUTO';
        insert product1;

        NE__OrderItem__c orderItem1 = new NE__OrderItem__c();
        orderItem1.NE__Qty__c     = 1;
        orderItem1.NE__OrderId__c = configuration.id;
        orderItem1.NE__ProdId__c  = product1.id;
    orderItem1.NE__Action__c = 'Add';
    orderItem1.OB_FulfilmentStatus__c = 'Completed';
    orderItem1.NE__Parent_Order_Item__c = orderItemAcq.id;
    orderItem1.NE__Parent_Order_Item__c = orderItemAcq.id;
    orderItem1.NE__AssetItemEnterpriseId__c = orderItem1.id;
        insert orderItem1;

    //orderItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.ACQUIRING && orderItem.NE__ProdId__r.OB_Acquirer__c!=OB_EnrichOrder.NEXI
    NE__Product__c productNotNexi    = new NE__Product__c(OB_Acquirer__c='AMEX' , RecordTypeId =rtProductAcqRoot, OB_Codice_sfdc__c = 'AMEX' );
        insert productNotNexi;

    NE__OrderItem__c orderItemNotNexi = new NE__OrderItem__c();
    orderItemNotNexi.NE__Qty__c     = 1;
        orderItemNotNexi.NE__OrderId__c = configuration.id;
        orderItemNotNexi.NE__ProdId__c  = productNotNexi.id;
    orderItemNotNexi.NE__Action__c = 'None';
    orderItemNotNexi.OB_FulfilmentStatus__c = 'Completed';
    orderItemNotNexi.NE__Parent_Order_Item__c = null;
    orderItemNotNexi.OB_FulfilmentStatus__c = 'Completed';
    orderItemNotNexi.NE__AssetItemEnterpriseId__c= orderItemNotNexi.id;
        insert orderItemNotNexi;

    NE__Product__c productNotNexiPricing   = new NE__Product__c(OB_Acquirer__c='AMEX' , RecordTypeId =rtProductPric, OB_Codice_sfdc__c = 'PRICING' );
        insert productNotNexiPricing;
    NE__OrderItem__c orderItemNotNexiPric = new NE__OrderItem__c();
    orderItemNotNexiPric.NE__Qty__c     = 1;
        orderItemNotNexiPric.NE__OrderId__c = configuration.id;
        orderItemNotNexiPric.NE__ProdId__c  = productNotNexiPricing.id;
    orderItemNotNexiPric.NE__Action__c = 'None';
    orderItemNotNexiPric.OB_FulfilmentStatus__c = 'Completed';
    orderItemNotNexiPric.NE__Parent_Order_Item__c = orderItemNotNexi.id;
    orderItemNotNexiPric.NE__AssetItemEnterpriseId__c= orderItemNotNexiPric.id;
        insert orderItemNotNexiPric;
    
    
    //ASSET
    Asset asset = new Asset(NE__AssetItemEnterpriseId__c = orderItemGTRoot.Id, OB_ShopCode__c = 'shopCode', OB_GT__c = 'GT', OB_CustomerCode__c = 'customerCode', Name = 'SmartPOS');
    insert asset;
    NE__AssetItemAttribute__c attr1 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.TERMID, NE__Asset__c = asset.id);
    insert attr1;
    NE__AssetItemAttribute__c attr2 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.MODELLO, NE__Asset__c = asset.id);
    insert attr2;
    NE__AssetItemAttribute__c attr3 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.RELEASE, NE__Asset__c = asset.id);
    insert attr3;
    NE__AssetItemAttribute__c attr4 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.MODCOLLEGAMENTO, NE__Asset__c = asset.id);
    insert attr4;
    NE__AssetItemAttribute__c attr5 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.DMODELLO, NE__Asset__c = asset.id);
    insert attr5;
    NE__AssetItemAttribute__c attr6 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.DRELEASE, NE__Asset__c = asset.id);
    insert attr6;
    NE__AssetItemAttribute__c attr7 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.DCONNESSIONE, NE__Asset__c = asset.id);
    insert attr7;
    NE__AssetItemAttribute__c attr8 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.PROGRESSIVOSIA, NE__Asset__c = asset.id);
    insert attr8;
    NE__AssetItemAttribute__c attr9 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.CODICESTABILIMENTOSIA, NE__Asset__c = asset.id);
    insert attr9;
    NE__AssetItemAttribute__c attr10 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.CODICESIA, NE__Asset__c = asset.id);
    insert attr10;


    ExternalSourceMapping__c ex = OB_TestDataFactory.getExternalSourceMapping( );
    ex.OB_Source__c = 'MONETICA';
    ex.OB_CustomerCodeClientCode__c =null;
    ex.OB_ServicePointCodeShopCode__c =null;
    ex.OB_Service_Point_ID__c = servicePoint.id ;
    insert ex;

    ExternalSourceMapping__c ex1 = OB_TestDataFactory.getExternalSourceMapping( );
    ex1.OB_Source__c = 'MONETICA';
    ex1.OB_CustomerCodeClientCode__c =null;
    ex1.OB_ServicePointCodeShopCode__c =null;
    ex1.OB_Service_Point_ID__c = servicePoint.id ;
    insert ex1;
    //LOV
    NE__Lov__c lovMCC2 = new NE__Lov__c();
    lovMCC2.NE__Type__c   = 'mcc';
    lovMCC2.NE__Value3__c = 'L2';
    lovMCC2.OB_Value4__c  = configuration.OB_MCCL2__c;
    lovMCC2.NE__Value2__c = configuration.OB_MCCL2__c;
    insert lovMCC2;
    System.debug('@@@lovMCC2 '+lovMCC2);
    NE__Lov__c lov = new NE__Lov__c();
    lov.NE__Type__c     ='TRACKING';
    lov.NE__Sub_Type__c = 'TIPOLOGICHE';
    lov.NE__Value2__c   = 'DINERS';
    lov.NE__Value1__c   = '12';
    insert lov;

    OB_TrackingUtility.ErrorList error1 = new OB_TrackingUtility.ErrorList();

     List<OB_TrackingUtility.ErrorList> errorsList1 = new List<OB_TrackingUtility.ErrorList>();
      OB_TrackingUtility.ErrorList error2 = new OB_TrackingUtility.ErrorList();
    error2.code = '';
    error2.description = '';

    
   

    List<OB_TrackingUtility.ErrorList> errorsList2 = new List<OB_TrackingUtility.ErrorList>();
    errorsList2.add(error2);
    

    OB_TrackingUtility.Changes change = new OB_TrackingUtility.Changes();
    change.externalId = rootVas.id; //TERMINALE
    change.result = 'KO';
    change.errors = errorsList2; //List

   
  
    List<OB_TrackingUtility.Changes> changesList = new List<OB_TrackingUtility.Changes>();
    changesList.add(change);

    
    
    OB_TrackingUtility.CodiciConvenzioni codConv = new OB_TrackingUtility.CodiciConvenzioni();
    codConv.companyCode = 'companyCode';
    codConv.companyName = 'companyName';                                
    codConv.code        = 'code';                                       
    codConv.causaleRifiuto ='causaleRifiuto';
    codConv.startDate = '2011-11-13';
    codConv.endDate = '';
    codConv.status  = 'Active';

    List<OB_TrackingUtility.CodiciConvenzioni> codConvList = new List<OB_TrackingUtility.CodiciConvenzioni>();
    codConvList.add(codConv);

    OB_TrackingUtility.TermsIdInformation termInfo = new OB_TrackingUtility.TermsIdInformation();    
    termInfo.terminalId = orderItemGTRoot.OB_TermId__c;
    termInfo.model = 'model';
    termInfo.connectionType = 'connectionType';
    termInfo.modality = 'modality';
    termInfo.modelDescription = 'modelDescription';
    termInfo.release = 'release';
    termInfo.releaseDescription = 'releaseDescription';
    termInfo.status = 'Pending';
    termInfo.reasonOfRejection = '';
    termInfo.installationDate = '2011-11-13';
    termInfo.uninstallationDate = '';
    termInfo.agreementCodes = codConvList; //List
    termInfo.errors = null; //List

    List<OB_TrackingUtility.TermsIdInformation> termsInfoList = new List<OB_TrackingUtility.TermsIdInformation>();
    termsInfoList.add(termInfo);

    OB_TrackingUtility.ErrorList error = new OB_TrackingUtility.ErrorList();
    error.code = '';
    error.description = '';

    
   

    List<OB_TrackingUtility.ErrorList> errorsList = new List<OB_TrackingUtility.ErrorList>();
    errorsList.add(error);
   

    OB_TrackingUtility.puntoVendita pV = new OB_TrackingUtility.puntoVendita();
    //pV.itemId = '';
    pV.PVCode = servicePoint.id;
    pV.startDate = '2011-11-13';
    pV.endDate = '';
    pV.reasonOfClosure = '';
    //pV.tipo = '';
    pV.ctiCode = 'ctiCode';
    pV.StabiCode = 'StabiCode';
    pV.siaPVCode = 'siaPVCode';
    pV.siaProgressiveCode = 'siaProgressiveCode';
    pV.siaMerchantCode = 'siaMerchantCode';
    pV.assistanceNumber = 'assistanceNumber';
    //pV.dataInizioAttivita = '2011-11-13';
    pv.terminalInformation = termsInfoList; //List
    pv.changes = changesList;

    List<OB_TrackingUtility.puntoVendita> pVList = new List<OB_TrackingUtility.puntoVendita>();
    pVList.add(pV);

    OB_TrackingUtility.GT gT = new OB_TrackingUtility.GT();
    gT.source = 'MONETICA';
    gT.gtCompanyCode = 'companyCode';
    gT.errors = null; //List
    gT.PVCodes = pVList; //List
    //gT.statoProvisioning = '';

    List<OB_TrackingUtility.GT> gTList = new List<OB_TrackingUtility.GT>();
    gTList.add(gT);

    OB_TrackingUtility.Acquiring acquiring = new OB_TrackingUtility.Acquiring();
    acquiring.source = 'NEXI';
    acquiring.companyCode = 'companyCode';
    acquiring.errori = null;
    acquiring.PVCodes = pVList;

    List<OB_TrackingUtility.Acquiring> acquiringList = new List<OB_TrackingUtility.Acquiring>();
    acquiringList.add(acquiring);

    OB_TrackingUtility.TrackingOrderRequestMaintenance trackingOrderRequest = new OB_TrackingUtility.TrackingOrderRequestMaintenance();
    trackingOrderRequest.orderId = configuration.id;
    //trackingOrderRequest.Acquiring = acquiringList;
    trackingOrderRequest.GT = gTList;

    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();
    req.requestURI = '/TrackingOrderMaintenance/*'; 
    req.httpMethod = 'POST';
    RestContext.request = req;
    String json = JSON.serialize(trackingOrderRequest);
    RestContext.request.requestBody =  null; //Blob.valueof(json);
    RestContext.response = res;

    List<OB_LogRequest__c> listLog = new List<OB_LogRequest__c>();
    OB_LogRequest__c log = OB_TestDataFactory.getLogRequest();
    insert log;
    OB_LogRequest__c log1 = OB_TestDataFactory.getLogRequest();
    insert log1;
    listLog.add(log);
     listLog.add(log1);
    Test.startTest();
    OB_TrackingUtility.TrackingOrderResponseMaintenance response = OB_TrackingOrderMaintenance.trackOrderMaintenance();
    OB_TrackingOrderMaintenance.isAcquiringVas(acquiringList);
    OB_TrackingOrderMaintenance.isAcquiringTerminal(acquiringList, true);
    OB_TrackingOrderMaintenance.isAcquiringTerminal(acquiringList, false);
    OB_TrackingOrderMaintenance.updateLogRequest(configuration.id);
    System.assertEquals( 400, response.httpStatus);
    //OB_TrackingOrderMaintenance.isAcquiringAcquiring(acquiringList);
    //OB_TrackingUtility.updateVasItems(oiList,changesList,'','','','',listLog);
    Test.stopTest();
    }

  /*******************************************************************************
    Purpose:  Method tests updateAcquiringItems, scenario with OK

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.10      Kinga Fornal        12/08/2019    Created         -
    ********************************************************************************/
  @isTest static void updateLogRequestOKTest()
  {

    NE__Order__c testOrder = OB_TestDataFactory.getOrder();
    insert testOrder;
    NE__OrderItem__c testOrderItem = OB_TestDataFactory.getOrderItem(testOrder.Id);
    testOrderItem.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    insert testOrderItem;
     NE__OrderItem__c testOrderItem1 = OB_TestDataFactory.getOrderItem(testOrder.Id);
    testOrderItem1.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem1.NE__Root_Order_Item__c= null;
    testOrderItem1.NE__Bundle_Configuration__c=testOrderItem.id;
    insert testOrderItem1;
    OB_LogRequest__c testLogRequest = OB_TestDataFactory.getLogRequest();
    testLogRequest.OB_OrderId__c = testOrder.Id;
    insert testLogRequest;
    Asset assetTest = OB_TestDataFactory.getAsset();
    assetTest.NE__Order_Config__c = testOrder.id;
    insert assetTest;
    Test.startTest( );
    OB_TrackingOrderMaintenance.updateLogRequest(testOrder.Id);
    Test.stopTest( );

    List<OB_LogRequest__c> resultLogRequest = [SELECT Id, OB_Status__c,OB_Response_Track__c FROM OB_LogRequest__c WHERE Id =:testLogRequest.Id ];

    System.assertEquals(OB_UtilityConstants.CONFERMATO, resultLogRequest.get(0).OB_Status__c);
    System.assertEquals('OK', resultLogRequest.get(0).OB_Response_Track__c);
  }



    /*******************************************************************************
    Purpose:  Method tests updateAcquiringItems, scenario with OK

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.10      Kinga Fornal        12/08/2019    Created         -
    ********************************************************************************/
  @isTest static void updateLogRequestTest()
  {

    NE__Order__c testOrder = OB_TestDataFactory.getOrder();
    insert testOrder;
    NE__OrderItem__c testOrderItem = OB_TestDataFactory.getOrderItem(testOrder.Id);
    testOrderItem.OB_FulfilmentStatus__c = 'Sent';
    insert testOrderItem;
     NE__OrderItem__c testOrderItem1 = OB_TestDataFactory.getOrderItem(testOrder.Id);
    testOrderItem1.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem1.NE__Root_Order_Item__c= null;
    testOrderItem1.NE__Bundle_Configuration__c=testOrderItem.id;
    insert testOrderItem1;
    OB_LogRequest__c testLogRequest = OB_TestDataFactory.getLogRequest();
    testLogRequest.OB_OrderId__c = testOrder.Id;
    insert testLogRequest;
    Asset assetTest = OB_TestDataFactory.getAsset();
    assetTest.NE__Order_Config__c = testOrder.id;
    insert assetTest;
    Test.startTest( );
    OB_TrackingOrderMaintenance.updateLogRequest(testOrder.Id);
    Test.stopTest( );

    List<OB_LogRequest__c> resultLogRequest = [SELECT Id, OB_Status__c,OB_Response_Track__c FROM OB_LogRequest__c WHERE Id =:testLogRequest.Id ];

    System.assertEquals(OB_UtilityConstants.Bozza, resultLogRequest.get(0).OB_Status__c);
  }
  /*******************************************************************************
  Purpose:  Method tests conventionCodeManagement, scenario with empty OB_ConventionCode__c

  History
  --------
  VERSION   AUTHOR              DATE          DETAIL     Description
  1.0       Kinga Fornal        12/08/2019    Created         -
  ********************************************************************************/
  @isTest static void conventionCodeManagementTest()
  {

    NE__Order__c testOrder = OB_TestDataFactory.getOrder();
    insert testOrder;
    NE__OrderItem__c testOrderItem = OB_TestDataFactory.getOrderItem(testOrder.Id);
    testOrderItem.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem.OB_CustomerCode__c = 'TEST';
    testOrderItem.OB_ShopCode__c = 'TEST';
    insert testOrderItem;
    OB_LogRequest__c testLogRequest = OB_TestDataFactory.getLogRequest();
    testLogRequest.OB_OrderId__c = testOrder.Id;
    insert testLogRequest;
    ExternalSourceMapping__c mapping = OB_TestDataFactory.getExternalSourceMapping();
    mapping.OB_ServicePointCodeShopCode__c = 'TEST';
    insert mapping;
    Map<String,List<NE__OrderItem__c>> acquiringNexiMap = new Map<String,List<NE__OrderItem__c>>();
    Map<String,NE__OrderItem__c> mapTermId = new Map<String,NE__OrderItem__c>();
    mapTermId.put('123456', testOrderItem);
    NE__Service_Point__c testServicePoint = OB_TestDataFactory.getServicePoint();
    testServicePoint = OB_TestDataFactory.getServicePoint();
    insert testServicePoint;
    ExternalSourceMapping__c mapping2 = OB_TestDataFactory.getExternalSourceMapping();
    mapping2.OB_Source__c = 'MONETICA';
    mapping2.OB_CustomerCodeClientCode__c =testOrderItem.OB_CustomerCode__c;
    mapping2.OB_ServicePointCodeShopCode__c =testOrderItem.OB_ShopCode__c;
    mapping2.OB_Service_Point_ID__c =testServicePoint.Id;
    insert mapping2;
    Test.startTest( );
    ExternalSourceMapping__c result = OB_TrackingOrderMaintenance.conventionCodeManagement(true, false, false, mapping, acquiringNexiMap,testServicePoint.Id, mapTermId, '123test333');
    Test.stopTest( );

    System.assertEquals(mapping.OB_ServicePointCodeShopCode__c, result.OB_ConventionCode__c);
  }


  /*******************************************************************************
      Purpose:  Method tests saving - returning null

      History
      --------
      VERSION     AUTHOR                  DATE            DETAIL          Description
      1.0        Roland Nieznanski       21/08/2019      Created         update NE__OrderItem__c and OB_LogRequest__c
      ********************************************************************************/
  public static void updateAcquiringItems_Test( String answerResult )
  {
    NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
    insert testOrder;

    list< NE__OrderItem__c > orderItemsList = new list<NE__OrderItem__c>( );

    NE__OrderItem__c testOrderItem = OB_TestDataFactory.getOrderItem( testOrder.Id );
    testOrderItem.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem.OB_CustomerCode__c = 'TEST';
    testOrderItem.OB_ShopCode__c = 'TEST';
    testOrderItem.NE__Action__c = 'Remove';
    insert testOrderItem;

    OB_LogRequest__c testLogRequest = OB_TestDataFactory.getLogRequest( );
    testLogRequest.OB_OrderId__c = testOrder.Id;
    insert testLogRequest;

    NE__OrderItem__c testOrderItem3 = OB_TestDataFactory.getOrderItem(testOrder.Id);
    testOrderItem3.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem3.OB_CustomerCode__c = 'TEST';
    testOrderItem3.OB_ShopCode__c = 'TEST';
    testOrderItem3.NE__Root_Order_Item__c = testOrderItem.Id;
    
    orderItemsList.add(testOrderItem3);

    NE__OrderItem__c testOrderItem2 = OB_TestDataFactory.getOrderItem(testOrder.Id);
    testOrderItem2.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem2.OB_CustomerCode__c = 'TEST';
    testOrderItem2.OB_ShopCode__c = 'TEST';
    testOrderItem2.NE__Root_Order_Item__c = testOrderItem.Id;
    orderItemsList.add(testOrderItem2);

    insert orderItemsList;


    list< NE__OrderItem__c > orderItemsList1 = new list< NE__OrderItem__c >( );

    NE__OrderItem__c testOrderItem1 = OB_TestDataFactory.getOrderItem( testOrder.Id );
    testOrderItem1.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem1.OB_CustomerCode__c = 'TEST';
    testOrderItem1.OB_ShopCode__c = 'TEST';
    testOrderItem1.NE__Root_Order_Item__c = testOrderItem2.Id;
    orderItemsList1.add(testOrderItem1);
    NE__OrderItem__c testOrderItem4 = OB_TestDataFactory.getOrderItem( testOrder.Id );
    testOrderItem4.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem4.OB_CustomerCode__c = 'TEST';
    testOrderItem4.OB_ShopCode__c = 'TEST';
    testOrderItem4.NE__Root_Order_Item__c = testOrderItem2.Id;
    orderItemsList1.add( testOrderItem4 );
    insert orderItemsList1;
    list< NE__OrderItem__c > orderItemsList2 = new list< NE__OrderItem__c >( );
    NE__OrderItem__c testOrderItem5 = OB_TestDataFactory.getOrderItem( testOrder.Id );
    testOrderItem5.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem5.OB_CustomerCode__c = 'TEST';
    testOrderItem5.OB_ShopCode__c = 'TEST';
    testOrderItem5.NE__Root_Order_Item__c = testOrderItem3.Id;
    orderItemsList2.add( testOrderItem5 );
    NE__OrderItem__c testOrderItem6 = OB_TestDataFactory.getOrderItem( testOrder.Id );
    testOrderItem6.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem6.OB_CustomerCode__c = 'TEST';
    testOrderItem6.OB_ShopCode__c = 'TEST';
    testOrderItem6.NE__Root_Order_Item__c = testOrderItem3.Id;
    orderItemsList2.add( testOrderItem6 );
    insert orderItemsList2;
    orderItemsList2.add( testOrderItem );
    OB_TrackingUtility.ErrorList errorGet = new OB_TrackingUtility.ErrorList( );

    List< OB_TrackingUtility.ErrorList > errorsList1 = new List< OB_TrackingUtility.ErrorList >( );
    errorsList1.add( errorGet );

    OB_TrackingUtility.Changes change = new OB_TrackingUtility.Changes( );
    change.externalId = testOrderItem.Id;
    change.result = answerResult;
    change.errors = errorsList1;

    List< OB_TrackingUtility.Changes > changesList = new List< OB_TrackingUtility.Changes >( );
    changesList.add( change );
    Map< String, List< NE__OrderItem__c> > linkedAcquiringNexi = new Map< String, List< NE__OrderItem__c > >( );
    linkedAcquiringNexi.put( testOrderItem.Id, orderItemsList );
    Map< Id, List< NE__OrderItem__c > > mapChildOI = new Map< Id, List< NE__OrderItem__c > >( );
    List< NE__OrderItem__c> listoi = new  List< NE__OrderItem__c> ();

    mapChildOI.put( testOrderItem2.Id, orderItemsList1 );
    mapChildOI.put( testOrderItem3.Id, orderItemsList2 );
    List< OB_LogRequest__c > currentLog = new List< OB_LogRequest__c >( );
    currentLog.add( testLogRequest );

    OB_TrackingOrderMaintenance.updateAcquiringItems( testOrder, changesList, linkedAcquiringNexi, mapChildOI, '123', '1234', '2019-2-10', '2019-10-10', currentLog, true, orderItemsList2 );
    List<NE__OrderItem__c> result = [SELECT Id, OB_FulfilmentStatus__c FROM NE__OrderItem__c WHERE Id =: orderItemsList2.get(0).Id ];

    if( answerResult == 'OK' )
    {
      System.assertEquals( 'Completed', result[0].OB_FulfilmentStatus__c);
    }
    else
    {
      System.assertEquals( 'Completed', result[0].OB_FulfilmentStatus__c);
    }

  }


  /*******************************************************************************
      Purpose:  Method tests saving - returning null

      History
      --------
      VERSION     AUTHOR                  DATE            DETAIL          Description
      1.0        Roland Nieznanski       21/08/2019      Created         update NE__OrderItem__c and OB_LogRequest__c and check ok
  ********************************************************************************/
  @isTest
  public static void updateAcquiringItemsOK_Test( )
  {
    updateAcquiringItems_Test( 'OK' );
  }

  /*******************************************************************************
      Purpose:  Method tests saving - returning null

      History
      --------
      VERSION     AUTHOR                  DATE            DETAIL          Description
      1.0        Roland Nieznanski       21/08/2019      Created         update NE__OrderItem__c and OB_LogRequest__c and check ko
  ********************************************************************************/
  @isTest
  public static void updateAcquiringItemsKO_Test( )
  {
    updateAcquiringItems_Test( 'KO' );
  }

 @isTest
  public static void updateAssetDate_Test ( ){

      Id rtMerchant       = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId(); 
    Account myMastMerchant  = new Account(Name='TEST',
                                          RecordTypeId=rtMerchant,
                                          OB_Employees_Number__c='Minore di 10',
                                          OB_VAT_Not_Present__c=true, 
                                          OB_DescriptionVATNotPresent__c='description', 
                                          NE__Fiscal_code__c='RSSMRA80A01F205X',
                                          OB_BypassValidation__c=true,
                                          OB_Status__c='Active'); 

  
    insert myMastMerchant;
      Id accountBankRecordId   = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Bank').getRecordTypeId(); 
    account bankAccount   = new Account(Name='TEST',
                                        RecordTypeId=accountBankRecordId,
                                        OB_Employees_Number__c='Minore di 10',
                                        OB_VAT_Not_Present__c=true, 
                                        OB_DescriptionVATNotPresent__c='description', 
                                        NE__Fiscal_code__c='RSSMRA80A01F205X',
                                        OB_BypassValidation__c=true,
                                        OB_Status__c='Active');   
     insert  bankAccount;
    NE__Service_Point__c servicePoint = new NE__Service_Point__c();
    insert servicePoint;
    NE__Order_Header__c orderHeader = new NE__Order_Header__c(OB_ProposerABI__c=bankAccount.Id ,NE__AccountId__c=myMastMerchant.Id, OB_Main_Process__c = 'Maintenance', OB_Sub_Process__c = 'variazione operativa', OB_Business_Model_Acquiring__c = 'Bancario');
    insert orderHeader;
     NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
     testOrder.OB_Service_Point__c = servicePoint.id;
     testOrder.NE__Order_Header__c = orderHeader.id;
    insert testOrder;

    //Start Noemi Infantino
    id pagobancomatRT       = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get('Pagobancomat').getRecordTypeId(); 
    NE__Product__c pagoRT = new NE__Product__c(RecordTypeId=pagobancomatRT , OB_Codice_sfdc__c = 'SMPOS_CASSA', Name = 'SmartPOS Cassa', OB_Contract_Type__c = 'Contratto POS;Modulo Off Commercial', OB_Business_Model_POS__c = 'Diretto;Trilaterale Nuovo');
    insert pagoRT;

     NE__OrderItem__c pagobancomatOI = OB_TestDataFactory.getOrderItem( testOrder.Id );
    pagobancomatOI.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    pagobancomatOI.OB_CustomerCode__c = 'TEST';
    pagobancomatOI.OB_ShopCode__c = 'TEST';
    pagobancomatOI.NE__ProdId__c  =pagoRT.id;
    insert pagobancomatOI;
    //Finish Noemi Infantino

    id rtProductGTRoot          = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.TERMINALE).getRecordTypeId(); 
    NE__Product__c productGTRoot = new NE__Product__c(RecordTypeId = rtProductGTRoot, OB_Codice_sfdc__c = 'SMPOS_CASSA', Name = 'SmartPOS Cassa', OB_Contract_Type__c = 'Contratto POS;Modulo Off Commercial', OB_Business_Model_POS__c = 'Diretto;Trilaterale Nuovo');
    insert productGTRoot;
    list< NE__OrderItem__c > orderItemsList = new list<NE__OrderItem__c>( );

    NE__OrderItem__c testOrderItem = OB_TestDataFactory.getOrderItem( testOrder.Id );
    testOrderItem.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem.OB_CustomerCode__c = 'TEST';
    testOrderItem.OB_ShopCode__c = 'TEST';
    testOrderItem.NE__ProdId__c  = productGTRoot.id;
    testOrderItem.OB_TermId__c = '4444333221';
    testOrderItem.NE__Action__c = 'Add';
    testOrderItem.NE__Account__c = myMastMerchant.id;

  
    insert testOrderItem;

 

    NE__OrderItem__c testOrderItem3 = OB_TestDataFactory.getOrderItem(testOrder.Id);
    testOrderItem3.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem3.OB_CustomerCode__c = 'TEST';
    testOrderItem3.OB_ShopCode__c = 'TEST';
    testOrderItem3.NE__Parent_Order_Item__c = testOrderItem.Id;
    orderItemsList.add(testOrderItem3);

    NE__OrderItem__c testOrderItem2 = OB_TestDataFactory.getOrderItem(testOrder.Id);
    testOrderItem2.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem2.OB_CustomerCode__c = 'TEST';
    testOrderItem2.OB_ShopCode__c = 'TEST';
    testOrderItem2.NE__Parent_Order_Item__c = testOrderItem.Id;
    orderItemsList.add(testOrderItem2);

    insert orderItemsList;


    list< NE__OrderItem__c > orderItemsList1 = new list< NE__OrderItem__c >( );

    NE__OrderItem__c testOrderItem1 = OB_TestDataFactory.getOrderItem( testOrder.Id );
    testOrderItem1.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem1.OB_CustomerCode__c = 'TEST';
    testOrderItem1.OB_ShopCode__c = 'TEST';
    testOrderItem1.NE__Root_Order_Item__c = testOrderItem2.Id;
    orderItemsList1.add(testOrderItem1);
    NE__OrderItem__c testOrderItem4 = OB_TestDataFactory.getOrderItem( testOrder.Id );
    testOrderItem4.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem4.OB_CustomerCode__c = 'TEST';
    testOrderItem4.OB_ShopCode__c = 'TEST';
    testOrderItem4.NE__Root_Order_Item__c = testOrderItem2.Id;
    orderItemsList1.add( testOrderItem4 );
    insert orderItemsList1;
    list< NE__OrderItem__c > orderItemsList2 = new list< NE__OrderItem__c >( );
    NE__OrderItem__c testOrderItem5 = OB_TestDataFactory.getOrderItem( testOrder.Id );
    testOrderItem5.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem5.OB_CustomerCode__c = 'TEST';
    testOrderItem5.OB_ShopCode__c = 'TEST';
    testOrderItem5.NE__Root_Order_Item__c = testOrderItem3.Id;
    orderItemsList2.add( testOrderItem5 );
    NE__OrderItem__c testOrderItem6 = OB_TestDataFactory.getOrderItem( testOrder.Id );
    testOrderItem6.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem6.OB_CustomerCode__c = 'TEST';
    testOrderItem6.OB_ShopCode__c = 'TEST';
    testOrderItem6.NE__Root_Order_Item__c = testOrderItem3.Id;
    orderItemsList2.add( testOrderItem6 );
    insert orderItemsList2;

    Map<Id, Asset> mapAsset = new Map<Id,Asset>();

    Asset asset1 = new Asset(NE__AssetItemEnterpriseId__c = testOrderItem.Id, OB_ShopCode__c = 'shopCode',  OB_GT__c = 'GT', OB_CustomerCode__c = 'customerCode', Name = 'SmartPOS', NE__Status__c = 'Active', NE__Action__c = 'None');
    insert asset1;
    mapAsset.put(asset1.id, asset1);
    Asset asset = new Asset(NE__AssetItemEnterpriseId__c = testOrderItem.Id, OB_ShopCode__c = 'shopCode',   OB_GT__c = 'GT', OB_CustomerCode__c = 'customerCode', Name = 'SmartPOS', NE__Status__c = 'Active', NE__Action__c = 'None');
    insert asset;
    asset.id= asset1.id;
    update asset;
    mapAsset.put(asset.id, asset);
    //Start Noemi Infantino
    List<OB_TrackingUtility.ErrorList> errorsList = new List<OB_TrackingUtility.ErrorList>();
    OB_TrackingUtility.ErrorList errors = new OB_TrackingUtility.ErrorList();
    errors.code = '';
    errors.description = '';
    errorsList.add(errors);
    //Finish Noemi Infantino
    OB_TrackingUtility.TermsIdInformation termInfo = new OB_TrackingUtility.TermsIdInformation();    
    termInfo.terminalId = testOrderItem.OB_TermId__c;
    termInfo.model = 'model';
    termInfo.connectionType = 'connectionType';
    termInfo.modality = 'modality';
    termInfo.modelDescription = 'modelDescription';
    termInfo.release = 'release';
    termInfo.releaseDescription = 'releaseDescription';
    termInfo.status = 'Refused';
    termInfo.reasonOfRejection = '';
    termInfo.installationDate = '2011-11-13';
    termInfo.uninstallationDate = '';
    termInfo.agreementCodes = null; //List
    termInfo.errors = errorsList; //List         //Noemi Infantino

    List<OB_TrackingUtility.TermsIdInformation> termsInfoList = new List<OB_TrackingUtility.TermsIdInformation>();
    termsInfoList.add(termInfo);

    

    
   

  

    OB_TrackingUtility.puntoVendita pV = new OB_TrackingUtility.puntoVendita();
    //pV.itemId = '';
    pV.PVCode = '1234567';
    pV.startDate = '2011-11-13';
    pV.endDate = '';
    pV.reasonOfClosure = '';
    //pV.tipo = '';
    pV.ctiCode = 'ctiCode';
    pV.StabiCode = 'StabiCode';
    pV.siaPVCode = 'siaPVCode';
    pV.siaProgressiveCode = 'siaProgressiveCode';
    pV.siaMerchantCode = 'siaMerchantCode';
    pV.assistanceNumber = 'assistanceNumber';
    //pV.dataInizioAttivita = '2011-11-13';
    pv.terminalInformation = termsInfoList; //List
    pv.changes = null;

    List<OB_TrackingUtility.puntoVendita> pVList = new List<OB_TrackingUtility.puntoVendita>();
    pVList.add(pV);

    OB_TrackingUtility.GT gT = new OB_TrackingUtility.GT();
    gT.source = 'MONETICA';
    gT.gtCompanyCode = 'companyCode';
    gT.errors = null; //List
    gT.PVCodes = pVList; //List
    //gT.statoProvisioning = '';

    List<OB_TrackingUtility.GT> gTList = new List<OB_TrackingUtility.GT>();
    gTList.add(gT);



    
    // OB_TrackingUtility.TrackingOrderRequestMaintenance trackingOrderRequest = new OB_TrackingUtility.TrackingOrderRequestMaintenance();
    // trackingOrderRequest.orderId = testOrder.id;
    // //trackingOrderRequest.Acquiring = acquiringList;
    // trackingOrderRequest.GT = gTList;
    String orderid= testOrder.id;
    Test.startTest();
    
    OB_TrackingOrderMaintenance.updateAssetDate(termsInfoList, orderid, mapAsset );
    
 
    //OB_TrackingOrderMaintenance.isAcquiringAcquiring(acquiringList);
    //OB_TrackingUtility.updateVasItems(oiList,changesList,'','','','',listLog);
    Test.stopTest();

  }

   @isTest
  public static void updateAssetDate_Test1 ( ){

      Id rtMerchant       = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId(); 
    Account myMastMerchant  = new Account(Name='TEST',
                                          RecordTypeId=rtMerchant,
                                          OB_Employees_Number__c='Minore di 10',
                                          OB_VAT_Not_Present__c=true, 
                                          OB_DescriptionVATNotPresent__c='description', 
                                          NE__Fiscal_code__c='RSSMRA80A01F205X',
                                          OB_BypassValidation__c=true,
                                          OB_Status__c='Active'); 

  
    insert myMastMerchant;
      Id accountBankRecordId   = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Bank').getRecordTypeId(); 
    account bankAccount   = new Account(Name='TEST',
                                        RecordTypeId=accountBankRecordId,
                                        OB_Employees_Number__c='Minore di 10',
                                        OB_VAT_Not_Present__c=true, 
                                        OB_DescriptionVATNotPresent__c='description', 
                                        NE__Fiscal_code__c='RSSMRA80A01F205X',
                                        OB_BypassValidation__c=true,
                                        OB_Status__c='Active');   
     insert  bankAccount;
    NE__Service_Point__c servicePoint = new NE__Service_Point__c();
    insert servicePoint;
    NE__Order_Header__c orderHeader = new NE__Order_Header__c(OB_ProposerABI__c=bankAccount.Id ,NE__AccountId__c=myMastMerchant.Id, OB_Main_Process__c = 'Maintenance', OB_Sub_Process__c = 'variazione operativa', OB_Business_Model_Acquiring__c = 'Bancario');
    insert orderHeader;
     NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
     testOrder.OB_Service_Point__c = servicePoint.id;
     testOrder.NE__Order_Header__c = orderHeader.id;
    insert testOrder;
    id rtProductGTRoot          = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.TERMINALE).getRecordTypeId(); 
    NE__Product__c productGTRoot = new NE__Product__c(RecordTypeId = rtProductGTRoot, OB_Codice_sfdc__c = 'SMPOS_CASSA', Name = 'SmartPOS Cassa', OB_Contract_Type__c = 'Contratto POS;Modulo Off Commercial', OB_Business_Model_POS__c = 'Diretto;Trilaterale Nuovo');
    insert productGTRoot;
    list< NE__OrderItem__c > orderItemsList = new list<NE__OrderItem__c>( );

    NE__OrderItem__c testOrderItem = OB_TestDataFactory.getOrderItem( testOrder.Id );
    testOrderItem.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem.OB_CustomerCode__c = 'TEST';
    testOrderItem.OB_ShopCode__c = 'TEST';
    testOrderItem.NE__ProdId__c  = productGTRoot.id;
    testOrderItem.OB_TermId__c = '4444333221';
    testOrderItem.NE__Action__c = 'Add';
    testOrderItem.NE__Account__c = myMastMerchant.id;

  
    insert testOrderItem;

 

    NE__OrderItem__c testOrderItem3 = OB_TestDataFactory.getOrderItem(testOrder.Id);
    testOrderItem3.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem3.OB_CustomerCode__c = 'TEST';
    testOrderItem3.OB_ShopCode__c = 'TEST';
    testOrderItem3.NE__Parent_Order_Item__c = testOrderItem.Id;
    orderItemsList.add(testOrderItem3);

    NE__OrderItem__c testOrderItem2 = OB_TestDataFactory.getOrderItem(testOrder.Id);
    testOrderItem2.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem2.OB_CustomerCode__c = 'TEST';
    testOrderItem2.OB_ShopCode__c = 'TEST';
    testOrderItem2.NE__Parent_Order_Item__c = testOrderItem.Id;
    orderItemsList.add(testOrderItem2);

    insert orderItemsList;


    list< NE__OrderItem__c > orderItemsList1 = new list< NE__OrderItem__c >( );

    NE__OrderItem__c testOrderItem1 = OB_TestDataFactory.getOrderItem( testOrder.Id );
    testOrderItem1.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem1.OB_CustomerCode__c = 'TEST';
    testOrderItem1.OB_ShopCode__c = 'TEST';
    testOrderItem1.NE__Root_Order_Item__c = testOrderItem2.Id;
    orderItemsList1.add(testOrderItem1);
    NE__OrderItem__c testOrderItem4 = OB_TestDataFactory.getOrderItem( testOrder.Id );
    testOrderItem4.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem4.OB_CustomerCode__c = 'TEST';
    testOrderItem4.OB_ShopCode__c = 'TEST';
    testOrderItem4.NE__Root_Order_Item__c = testOrderItem2.Id;
    orderItemsList1.add( testOrderItem4 );
    insert orderItemsList1;
    list< NE__OrderItem__c > orderItemsList2 = new list< NE__OrderItem__c >( );
    NE__OrderItem__c testOrderItem5 = OB_TestDataFactory.getOrderItem( testOrder.Id );
    testOrderItem5.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem5.OB_CustomerCode__c = 'TEST';
    testOrderItem5.OB_ShopCode__c = 'TEST';
    testOrderItem5.NE__Root_Order_Item__c = testOrderItem3.Id;
    orderItemsList2.add( testOrderItem5 );
    NE__OrderItem__c testOrderItem6 = OB_TestDataFactory.getOrderItem( testOrder.Id );
    testOrderItem6.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem6.OB_CustomerCode__c = 'TEST';
    testOrderItem6.OB_ShopCode__c = 'TEST';
    testOrderItem6.NE__Root_Order_Item__c = testOrderItem3.Id;
    orderItemsList2.add( testOrderItem6 );
    insert orderItemsList2;

  Map<Id, Asset> mapAsset = new Map<Id,Asset>();
    Asset asset1 = new Asset(NE__AssetItemEnterpriseId__c = testOrderItem.Id, OB_ShopCode__c = 'shopCode',  OB_GT__c = 'GT', OB_CustomerCode__c = 'customerCode', Name = 'SmartPOS', NE__Status__c = 'Active', NE__Action__c = 'None');
    insert asset1;
    mapAsset.put(asset1.id, asset1);
    Asset asset = new Asset(NE__AssetItemEnterpriseId__c = testOrderItem.Id, OB_ShopCode__c = 'shopCode',   OB_GT__c = 'GT', OB_CustomerCode__c = 'customerCode', Name = 'SmartPOS', NE__Status__c = 'Active', NE__Action__c = 'None');
    insert asset;
    asset.id= asset1.id;
    update asset;
    mapAsset.put(asset.id, asset);


    OB_TrackingUtility.CodiciConvenzioni codConv = new OB_TrackingUtility.CodiciConvenzioni();
    codConv.companyCode = 'companyCode';
    codConv.companyName = 'companyName';                                
    codConv.code        = 'code';                                       
    codConv.causaleRifiuto ='causaleRifiuto';
    codConv.startDate = '2011-11-13';
    codConv.endDate = '';
    codConv.status  = 'Activated';

    List<OB_TrackingUtility.CodiciConvenzioni> codConvList = new List<OB_TrackingUtility.CodiciConvenzioni>();
    codConvList.add(codConv);

    


    OB_TrackingUtility.TermsIdInformation termInfo = new OB_TrackingUtility.TermsIdInformation();    
    termInfo.terminalId = testOrderItem.OB_TermId__c;
    termInfo.model = 'model';
    termInfo.connectionType = 'connectionType';
    termInfo.modality = 'modality';
    termInfo.modelDescription = 'modelDescription';
    termInfo.release = 'release';
    termInfo.releaseDescription = 'releaseDescription';
    termInfo.status = 'Installed';
    termInfo.reasonOfRejection = '';
    termInfo.installationDate = '2011-11-13';
    termInfo.uninstallationDate = '';
    termInfo.agreementCodes = codConvList; //List
    termInfo.errors = null; //List

    List<OB_TrackingUtility.TermsIdInformation> termsInfoList = new List<OB_TrackingUtility.TermsIdInformation>();
    termsInfoList.add(termInfo);

    OB_TrackingUtility.ErrorList error = new OB_TrackingUtility.ErrorList();
    error.code = '';
    error.description = '';

    
   

    List<OB_TrackingUtility.ErrorList> errorsList = new List<OB_TrackingUtility.ErrorList>();
    errorsList.add(error);
   

    OB_TrackingUtility.puntoVendita pV = new OB_TrackingUtility.puntoVendita();
    //pV.itemId = '';
    pV.PVCode = '1234567';
    pV.startDate = '2011-11-13';
    pV.endDate = '';
    pV.reasonOfClosure = '';
    //pV.tipo = '';
    pV.ctiCode = 'ctiCode';
    pV.StabiCode = 'StabiCode';
    pV.siaPVCode = 'siaPVCode';
    pV.siaProgressiveCode = 'siaProgressiveCode';
    pV.siaMerchantCode = 'siaMerchantCode';
    pV.assistanceNumber = 'assistanceNumber';
    //pV.dataInizioAttivita = '2011-11-13';
    pv.terminalInformation = termsInfoList; //List
    pv.changes = null;

    List<OB_TrackingUtility.puntoVendita> pVList = new List<OB_TrackingUtility.puntoVendita>();
    pVList.add(pV);

    OB_TrackingUtility.GT gT = new OB_TrackingUtility.GT();
    gT.source = 'MONETICA';
    gT.gtCompanyCode = 'companyCode';
    gT.errors = null; //List
    gT.PVCodes = pVList; //List
    //gT.statoProvisioning = '';

    List<OB_TrackingUtility.GT> gTList = new List<OB_TrackingUtility.GT>();
    gTList.add(gT);



    
    // OB_TrackingUtility.TrackingOrderRequestMaintenance trackingOrderRequest = new OB_TrackingUtility.TrackingOrderRequestMaintenance();
    // trackingOrderRequest.orderId = testOrder.id;
    // //trackingOrderRequest.Acquiring = acquiringList;
    // trackingOrderRequest.GT = gTList;
    String orderid= testOrder.id;
    Test.startTest();
    
    OB_TrackingOrderMaintenance.updateAssetDate(termsInfoList, orderid , mapAsset);
    
 
    //OB_TrackingOrderMaintenance.isAcquiringAcquiring(acquiringList);
    //OB_TrackingUtility.updateVasItems(oiList,changesList,'','','','',listLog);
    Test.stopTest();

  }



   @isTest
  public static void updateAssetDate_Test2 ( ){

      Id rtMerchant       = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId(); 
    Account myMastMerchant  = new Account(Name='TEST',
                                          RecordTypeId=rtMerchant,
                                          OB_Employees_Number__c='Minore di 10',
                                          OB_VAT_Not_Present__c=true, 
                                          OB_DescriptionVATNotPresent__c='description', 
                                          NE__Fiscal_code__c='RSSMRA80A01F205X',
                                          OB_BypassValidation__c=true,
                                          OB_Status__c='Active'); 

  
    insert myMastMerchant;
      Id accountBankRecordId   = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Bank').getRecordTypeId(); 
    account bankAccount   = new Account(Name='TEST',
                                        RecordTypeId=accountBankRecordId,
                                        OB_Employees_Number__c='Minore di 10',
                                        OB_VAT_Not_Present__c=true, 
                                        OB_DescriptionVATNotPresent__c='description', 
                                        NE__Fiscal_code__c='RSSMRA80A01F205X',
                                        OB_BypassValidation__c=true,
                                        OB_Status__c='Active');   
     insert  bankAccount;
    NE__Service_Point__c servicePoint = new NE__Service_Point__c();
    insert servicePoint;
    NE__Order_Header__c orderHeader = new NE__Order_Header__c(OB_ProposerABI__c=bankAccount.Id ,NE__AccountId__c=myMastMerchant.Id, OB_Main_Process__c = 'Maintenance', OB_Sub_Process__c = 'variazione operativa', OB_Business_Model_Acquiring__c = 'Bancario');
    insert orderHeader;
     NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
     testOrder.OB_Service_Point__c = servicePoint.id;
     testOrder.NE__Order_Header__c = orderHeader.id;
    insert testOrder;
    id rtProductGTRoot          = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.TERMINALE).getRecordTypeId(); 
    NE__Product__c productGTRoot = new NE__Product__c(RecordTypeId = rtProductGTRoot, OB_Codice_sfdc__c = 'PRE-AUT', Name = 'SmartPOS Cassa', OB_Contract_Type__c = 'Contratto POS;Modulo Off Commercial', OB_Business_Model_POS__c = 'Diretto;Trilaterale Nuovo');
    insert productGTRoot;
    list< NE__OrderItem__c > orderItemsList = new list<NE__OrderItem__c>( );

    NE__OrderItem__c testOrderItem = OB_TestDataFactory.getOrderItem( testOrder.Id );
    testOrderItem.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem.OB_CustomerCode__c = 'TEST';
    testOrderItem.OB_ShopCode__c = 'TEST';
    testOrderItem.NE__ProdId__c  = productGTRoot.id;
    testOrderItem.OB_TermId__c = '4444333221';
    testOrderItem.NE__Action__c = 'Remove';
    testOrderItem.NE__Account__c = myMastMerchant.id;

  
    insert testOrderItem;

 

    NE__OrderItem__c testOrderItem3 = OB_TestDataFactory.getOrderItem(testOrder.Id);
    testOrderItem3.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem3.OB_CustomerCode__c = 'TEST';
    testOrderItem3.OB_ShopCode__c = 'TEST';
    testOrderItem3.NE__Parent_Order_Item__c = testOrderItem.Id;
    orderItemsList.add(testOrderItem3);

    NE__OrderItem__c testOrderItem2 = OB_TestDataFactory.getOrderItem(testOrder.Id);
    testOrderItem2.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem2.OB_CustomerCode__c = 'TEST';
    testOrderItem2.OB_ShopCode__c = 'TEST';
    testOrderItem2.NE__Parent_Order_Item__c = testOrderItem.Id;
    orderItemsList.add(testOrderItem2);

    insert orderItemsList;


    list< NE__OrderItem__c > orderItemsList1 = new list< NE__OrderItem__c >( );

    NE__OrderItem__c testOrderItem1 = OB_TestDataFactory.getOrderItem( testOrder.Id );
    testOrderItem1.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem1.OB_CustomerCode__c = 'TEST';
    testOrderItem1.OB_ShopCode__c = 'TEST';
    testOrderItem1.NE__Root_Order_Item__c = testOrderItem2.Id;
    orderItemsList1.add(testOrderItem1);
    NE__OrderItem__c testOrderItem4 = OB_TestDataFactory.getOrderItem( testOrder.Id );
    testOrderItem4.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem4.OB_CustomerCode__c = 'TEST';
    testOrderItem4.OB_ShopCode__c = 'TEST';
    testOrderItem4.NE__Root_Order_Item__c = testOrderItem2.Id;
    orderItemsList1.add( testOrderItem4 );
    insert orderItemsList1;
    list< NE__OrderItem__c > orderItemsList2 = new list< NE__OrderItem__c >( );
    NE__OrderItem__c testOrderItem5 = OB_TestDataFactory.getOrderItem( testOrder.Id );
    testOrderItem5.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem5.OB_CustomerCode__c = 'TEST';
    testOrderItem5.OB_ShopCode__c = 'TEST';
    testOrderItem5.NE__Root_Order_Item__c = testOrderItem3.Id;
    orderItemsList2.add( testOrderItem5 );
    NE__OrderItem__c testOrderItem6 = OB_TestDataFactory.getOrderItem( testOrder.Id );
    testOrderItem6.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem6.OB_CustomerCode__c = 'TEST';
    testOrderItem6.OB_ShopCode__c = 'TEST';
    testOrderItem6.NE__Root_Order_Item__c = testOrderItem3.Id;
    orderItemsList2.add( testOrderItem6 );
    insert orderItemsList2;

    Map<Id, Asset> mapAsset = new Map<Id,Asset>();
    Asset asset1 = new Asset(NE__AssetItemEnterpriseId__c = testOrderItem.Id, OB_ShopCode__c = 'shopCode',  OB_GT__c = 'GT', OB_CustomerCode__c = 'customerCode', Name = 'SmartPOS', NE__Status__c = 'Active', NE__Action__c = 'None');
    insert asset1;
    mapAsset.put(asset1.id, asset1);
    Asset asset = new Asset(NE__AssetItemEnterpriseId__c = testOrderItem.Id, OB_ShopCode__c = 'shopCode',   OB_GT__c = 'GT', OB_CustomerCode__c = 'customerCode', Name = 'SmartPOS', NE__Status__c = 'Active', NE__Action__c = 'None');
    insert asset;
    asset.id= asset1.id;
    update asset;
    mapAsset.put(asset.id, asset);


     OB_TrackingUtility.CodiciConvenzioni codConv = new OB_TrackingUtility.CodiciConvenzioni();
    codConv.companyCode = 'companyCode';
    codConv.companyName = 'PRE-AUT';                                
    codConv.code        = 'code';                                       
    codConv.causaleRifiuto ='causaleRifiuto';
    codConv.startDate = '2011-11-13';
    codConv.endDate = '';
    codConv.status  = 'Activated';

    List<OB_TrackingUtility.CodiciConvenzioni> codConvList = new List<OB_TrackingUtility.CodiciConvenzioni>();
    codConvList.add(codConv);


    OB_TrackingUtility.TermsIdInformation termInfo = new OB_TrackingUtility.TermsIdInformation();    
    termInfo.terminalId = testOrderItem.OB_TermId__c;
    termInfo.model = 'model';
    termInfo.connectionType = 'connectionType';
    termInfo.modality = 'modality';
    termInfo.modelDescription = 'modelDescription';
    termInfo.release = 'release';
    termInfo.releaseDescription = 'releaseDescription';
    termInfo.status = 'Uninstalled';
    termInfo.reasonOfRejection = '';
    termInfo.installationDate = '';
    termInfo.uninstallationDate = '2011-11-13';
    termInfo.agreementCodes = codConvList; //List
    termInfo.errors = null; //List

    List<OB_TrackingUtility.TermsIdInformation> termsInfoList = new List<OB_TrackingUtility.TermsIdInformation>();
    termsInfoList.add(termInfo);

    OB_TrackingUtility.ErrorList error = new OB_TrackingUtility.ErrorList();
    error.code = '';
    error.description = '';

    
   

    List<OB_TrackingUtility.ErrorList> errorsList = new List<OB_TrackingUtility.ErrorList>();
    errorsList.add(error);
   

    OB_TrackingUtility.puntoVendita pV = new OB_TrackingUtility.puntoVendita();
    //pV.itemId = '';
    pV.PVCode = '1234567';
    pV.startDate = '2011-11-13';
    pV.endDate = '';
    pV.reasonOfClosure = '';
    //pV.tipo = '';
    pV.ctiCode = 'ctiCode';
    pV.StabiCode = 'StabiCode';
    pV.siaPVCode = 'siaPVCode';
    pV.siaProgressiveCode = 'siaProgressiveCode';
    pV.siaMerchantCode = 'siaMerchantCode';
    pV.assistanceNumber = 'assistanceNumber';
    //pV.dataInizioAttivita = '2011-11-13';
    pv.terminalInformation = termsInfoList; //List
    pv.changes = null;

    List<OB_TrackingUtility.puntoVendita> pVList = new List<OB_TrackingUtility.puntoVendita>();
    pVList.add(pV);

    OB_TrackingUtility.GT gT = new OB_TrackingUtility.GT();
    gT.source = 'MONETICA';
    gT.gtCompanyCode = 'companyCode';
    gT.errors = null; //List
    gT.PVCodes = pVList; //List
    //gT.statoProvisioning = '';

    List<OB_TrackingUtility.GT> gTList = new List<OB_TrackingUtility.GT>();
    gTList.add(gT);



    
    // OB_TrackingUtility.TrackingOrderRequestMaintenance trackingOrderRequest = new OB_TrackingUtility.TrackingOrderRequestMaintenance();
    // trackingOrderRequest.orderId = testOrder.id;
    // //trackingOrderRequest.Acquiring = acquiringList;
    // trackingOrderRequest.GT = gTList;
    String orderid= testOrder.id;
    Test.startTest();
     List<NE__OrderItem__c> listOi = [SELECT OB_isNotIntegrated__c from NE__OrderItem__c where NE__OrderId__c = :orderid];
    System.assertEquals(false, listOi.get(0).OB_isNotIntegrated__c);
    
    OB_TrackingOrderMaintenance.updateAssetDate(termsInfoList, orderid, mapAsset);
    
 
    //OB_TrackingOrderMaintenance.isAcquiringAcquiring(acquiringList);
    //OB_TrackingUtility.updateVasItems(oiList,changesList,'','','','',listLog);
    Test.stopTest();

  }


   @isTest
  public static void updateAssetDate_Test3 ( ){

      Id rtMerchant       = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId(); 
    Account myMastMerchant  = new Account(Name='TEST',
                                          RecordTypeId=rtMerchant,
                                          OB_Employees_Number__c='Minore di 10',
                                          OB_VAT_Not_Present__c=true, 
                                          OB_DescriptionVATNotPresent__c='description', 
                                          NE__Fiscal_code__c='RSSMRA80A01F205X',
                                          OB_BypassValidation__c=true,
                                          OB_Status__c='Active'); 

  
    insert myMastMerchant;
      Id accountBankRecordId   = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Bank').getRecordTypeId(); 
    account bankAccount   = new Account(Name='TEST',
                                        RecordTypeId=accountBankRecordId,
                                        OB_Employees_Number__c='Minore di 10',
                                        OB_VAT_Not_Present__c=true, 
                                        OB_DescriptionVATNotPresent__c='description', 
                                        NE__Fiscal_code__c='RSSMRA80A01F205X',
                                        OB_BypassValidation__c=true,
                                        OB_Status__c='Active');   
     insert  bankAccount;
    NE__Service_Point__c servicePoint = new NE__Service_Point__c();
    insert servicePoint;
    NE__Order_Header__c orderHeader = new NE__Order_Header__c(OB_ProposerABI__c=bankAccount.Id ,NE__AccountId__c=myMastMerchant.Id, OB_Main_Process__c = 'Maintenance', OB_Sub_Process__c = 'variazione operativa', OB_Business_Model_Acquiring__c = 'Bancario');
    insert orderHeader;
     NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
     testOrder.OB_Service_Point__c = servicePoint.id;
     testOrder.NE__Order_Header__c = orderHeader.id;
    insert testOrder;
    id rtProductGTRoot          = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.TERMINALE).getRecordTypeId(); 
    NE__Product__c productGTRoot = new NE__Product__c(RecordTypeId = rtProductGTRoot, OB_Codice_sfdc__c = 'SMPOS_CASSA', Name = 'SmartPOS Cassa', OB_Contract_Type__c = 'Contratto POS;Modulo Off Commercial', OB_Business_Model_POS__c = 'Diretto;Trilaterale Nuovo');
    insert productGTRoot;
    list< NE__OrderItem__c > orderItemsList = new list<NE__OrderItem__c>( );

    NE__OrderItem__c testOrderItem = OB_TestDataFactory.getOrderItem( testOrder.Id );
    testOrderItem.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem.OB_CustomerCode__c = 'TEST';
    testOrderItem.OB_ShopCode__c = 'TEST';
    testOrderItem.NE__ProdId__c  = productGTRoot.id;
    testOrderItem.OB_TermId__c = '4444333221';
    testOrderItem.NE__Action__c = 'Remove';
    testOrderItem.NE__Account__c = myMastMerchant.id;

  
    insert testOrderItem;

 

    NE__OrderItem__c testOrderItem3 = OB_TestDataFactory.getOrderItem(testOrder.Id);
    testOrderItem3.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem3.OB_CustomerCode__c = 'TEST';
    testOrderItem3.OB_ShopCode__c = 'TEST';
    testOrderItem3.NE__Parent_Order_Item__c = testOrderItem.Id;
    orderItemsList.add(testOrderItem3);

    NE__OrderItem__c testOrderItem2 = OB_TestDataFactory.getOrderItem(testOrder.Id);
    testOrderItem2.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem2.OB_CustomerCode__c = 'TEST';
    testOrderItem2.OB_ShopCode__c = 'TEST';
    testOrderItem2.NE__Parent_Order_Item__c = testOrderItem.Id;
    orderItemsList.add(testOrderItem2);

    insert orderItemsList;


    list< NE__OrderItem__c > orderItemsList1 = new list< NE__OrderItem__c >( );

    NE__OrderItem__c testOrderItem1 = OB_TestDataFactory.getOrderItem( testOrder.Id );
    testOrderItem1.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem1.OB_CustomerCode__c = 'TEST';
    testOrderItem1.OB_ShopCode__c = 'TEST';
    testOrderItem1.NE__Root_Order_Item__c = testOrderItem2.Id;
    orderItemsList1.add(testOrderItem1);
    NE__OrderItem__c testOrderItem4 = OB_TestDataFactory.getOrderItem( testOrder.Id );
    testOrderItem4.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem4.OB_CustomerCode__c = 'TEST';
    testOrderItem4.OB_ShopCode__c = 'TEST';
    testOrderItem4.NE__Root_Order_Item__c = testOrderItem2.Id;
    orderItemsList1.add( testOrderItem4 );
    insert orderItemsList1;
    list< NE__OrderItem__c > orderItemsList2 = new list< NE__OrderItem__c >( );
    NE__OrderItem__c testOrderItem5 = OB_TestDataFactory.getOrderItem( testOrder.Id );
    testOrderItem5.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem5.OB_CustomerCode__c = 'TEST';
    testOrderItem5.OB_ShopCode__c = 'TEST';
    testOrderItem5.NE__Root_Order_Item__c = testOrderItem3.Id;
    orderItemsList2.add( testOrderItem5 );
    NE__OrderItem__c testOrderItem6 = OB_TestDataFactory.getOrderItem( testOrder.Id );
    testOrderItem6.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem6.OB_CustomerCode__c = 'TEST';
    testOrderItem6.OB_ShopCode__c = 'TEST';
    testOrderItem6.NE__Root_Order_Item__c = testOrderItem3.Id;
    orderItemsList2.add( testOrderItem6 );
    insert orderItemsList2;

    Map<Id, Asset> mapAsset = new Map<Id,Asset>();
    Asset asset1 = new Asset( OB_ShopCode__c = 'shopCode',  OB_GT__c = 'GT', OB_CustomerCode__c = 'customerCode', Name = 'SmartPOS', NE__Status__c = 'Active', NE__Action__c = 'None');
    insert asset1;
    mapAsset.put(asset1.id, asset1);
    Asset asset = new Asset(NE__AssetItemEnterpriseId__c = asset1.Id, OB_ShopCode__c = 'shopCode',  OB_GT__c = 'GT', OB_CustomerCode__c = 'customerCode', Name = 'SmartPOS', NE__Status__c = 'Active', NE__Action__c = 'None');
    insert asset;
   mapAsset.put(asset.id, asset);
   OB_TrackingUtility.CodiciConvenzioni codConv = new OB_TrackingUtility.CodiciConvenzioni();
    codConv.companyCode = 'companyCode';
    codConv.companyName = 'companyName';                                
    codConv.code        = 'code';                                       
    codConv.causaleRifiuto ='causaleRifiuto';
    codConv.startDate = '2011-11-13';
    codConv.endDate = '';
    codConv.status  = 'Activated';

    List<OB_TrackingUtility.CodiciConvenzioni> codConvList = new List<OB_TrackingUtility.CodiciConvenzioni>();
    codConvList.add(codConv);

    //Start noemi Infantino
    OB_TrackingUtility.ErrorList error = new OB_TrackingUtility.ErrorList();
    error.code = '';
    error.description = '';

    
   

    List<OB_TrackingUtility.ErrorList> errorsList = new List<OB_TrackingUtility.ErrorList>();
    errorsList.add(error);
    //Finish Noemi Infantino

    OB_TrackingUtility.TermsIdInformation termInfo = new OB_TrackingUtility.TermsIdInformation();    
    termInfo.terminalId = testOrderItem.OB_TermId__c;
    termInfo.model = 'model';
    termInfo.connectionType = 'connectionType';
    termInfo.modality = 'modality';
    termInfo.modelDescription = 'modelDescription';
    termInfo.release = 'release';
    termInfo.releaseDescription = 'releaseDescription';
    termInfo.status = 'Refused';
    termInfo.reasonOfRejection = '';
    termInfo.installationDate = '';
    termInfo.uninstallationDate = '2011-11-13';
    termInfo.agreementCodes = codConvList; //List
    termInfo.errors = errorsList; //List                                                //Noemi Infantino

    List<OB_TrackingUtility.TermsIdInformation> termsInfoList = new List<OB_TrackingUtility.TermsIdInformation>();
    termsInfoList.add(termInfo);

   

    OB_TrackingUtility.puntoVendita pV = new OB_TrackingUtility.puntoVendita();
    //pV.itemId = '';
    pV.PVCode = '1234567';
    pV.startDate = '2011-11-13';
    pV.endDate = '';
    pV.reasonOfClosure = '';
    //pV.tipo = '';
    pV.ctiCode = 'ctiCode';
    pV.StabiCode = 'StabiCode';
    pV.siaPVCode = 'siaPVCode';
    pV.siaProgressiveCode = 'siaProgressiveCode';
    pV.siaMerchantCode = 'siaMerchantCode';
    pV.assistanceNumber = 'assistanceNumber';
    //pV.dataInizioAttivita = '2011-11-13';
    pv.terminalInformation = termsInfoList; //List
    pv.changes = null;

    List<OB_TrackingUtility.puntoVendita> pVList = new List<OB_TrackingUtility.puntoVendita>();
    pVList.add(pV);

    OB_TrackingUtility.GT gT = new OB_TrackingUtility.GT();
    gT.source = 'MONETICA';
    gT.gtCompanyCode = 'companyCode';
    gT.errors = null; //List
    gT.PVCodes = pVList; //List
    //gT.statoProvisioning = '';

    List<OB_TrackingUtility.GT> gTList = new List<OB_TrackingUtility.GT>();
    gTList.add(gT);



    
    // OB_TrackingUtility.TrackingOrderRequestMaintenance trackingOrderRequest = new OB_TrackingUtility.TrackingOrderRequestMaintenance();
    // trackingOrderRequest.orderId = testOrder.id;
    // //trackingOrderRequest.Acquiring = acquiringList;
    // trackingOrderRequest.GT = gTList;
    String orderid= testOrder.id;
    Test.startTest();
    List<NE__OrderItem__c> listOi = [SELECT OB_isNotIntegrated__c from NE__OrderItem__c where NE__OrderId__c = :orderid];
    System.assertEquals(false, listOi.get(0).OB_isNotIntegrated__c);
    OB_TrackingOrderMaintenance.updateAssetDate(termsInfoList, orderid, mapAsset);
    
 
    //OB_TrackingOrderMaintenance.isAcquiringAcquiring(acquiringList);
    //OB_TrackingUtility.updateVasItems(oiList,changesList,'','','','',listLog);
    Test.stopTest();

  }

  /*****************************************************************
Name:  OB_TrackingOrderMaintenance_Test
============================================================
Purpose: Test class for OB_TrackingOrderMaintenance
============================================================
History
-------                                                            
VERSION      AUTHOR             DATE             DETAIL          Description
1.0           Simone Misani      01/08/2019      Created         Creation of the class
*****************************************************************/


    @isTest
  public static void OB_TrackingOrderMaintenance_Test5(){
    List<Account> accList = new List<Account>();
    List<NE__OrderItem__c> oiList = new List<NE__OrderItem__c>();
    Id rtMerchant       = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId(); 
    Account myMastMerchant  = new Account(Name='TEST',
                                          RecordTypeId=rtMerchant,
                                          OB_Employees_Number__c='Minore di 10',
                                          OB_VAT_Not_Present__c=true, 
                                          OB_DescriptionVATNotPresent__c='description', 
                                          NE__Fiscal_code__c='RSSMRA80A01F205X',
                                          OB_BypassValidation__c=true,
                                          OB_Status__c='Active'); 

    Id accountBankRecordId   = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Bank').getRecordTypeId(); 
    Account bankAccount   = new Account(Name='TEST',
                                        RecordTypeId=accountBankRecordId,
                                        OB_Employees_Number__c='Minore di 10',
                                        OB_VAT_Not_Present__c=true, 
                                        OB_DescriptionVATNotPresent__c='description', 
                                        NE__Fiscal_code__c='RSSMRA80A01F205X',
                                        OB_BypassValidation__c=true,
                                        OB_Status__c='Active');   
    accList.add(myMastMerchant);
    accList.add(bankAccount);
    insert accList;
    NE__Service_Point__c servicePoint = new NE__Service_Point__c();
    insert servicePoint;
    NE__Order_Header__c orderHeader = new NE__Order_Header__c(OB_ProposerABI__c=bankAccount.Id ,NE__AccountId__c=myMastMerchant.Id, OB_Main_Process__c = 'Maintenance', OB_Sub_Process__c = 'variazione operativa', OB_Business_Model_Acquiring__c = 'Bancario');
    insert orderHeader;
    NE__Order__c configuration = new NE__Order__c(NE__AccountId__c=myMastMerchant.Id, OB_Service_Point__c = servicePoint.Id,NE__Order_Header__c=orderHeader.Id, OB_MCC__c = '0001', OB_MCCL2__c = '5631', OB_GT__c = 'Nexi', OB_PBSettlementMethod__c = 'PB Settlement Method', OB_InternationalSettlementMethod__c = 'International Settlement Method', OB_ReceiptCity__c = 'MILANO', OB_ReceiptHeader__c='Sweet Years', OB_Report_Type__c = 'Punto Vendita', OB_ShopSign__c = 'Sweet Years');
    insert configuration;

    //OrderItem ACQUIRING
    Id rtProductAcqRoot           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.ACQUIRING).getRecordTypeId(); 
    NE__Product__c productAcqRoot = new NE__Product__c(OB_Acquirer__c='', RecordTypeId =rtProductAcqRoot, OB_Codice_sfdc__c = 'VISAMASTERCARD', Name = 'Visa/Mastercard', OB_Contract_Type__c = 'Contratto Acquiring');
    insert productAcqRoot;
    NE__OrderItem__c orderItemAcqRoot = new NE__OrderItem__c(NE__Qty__c=10 ,NE__OrderId__c=configuration.id, NE__Action__c = 'Add', NE__ProdId__c = productAcqRoot.id, NE__Service_Point__c = servicePoint.Id, NE__Account__c = myMastMerchant.Id , OB_FulfilmentStatus__c = 'Completed');
   
    insert orderItemAcqRoot;
     orderItemAcqRoot.NE__AssetItemEnterpriseId__c = orderItemAcqRoot.id;
     update orderItemAcqRoot;
    oiList.add(orderItemAcqRoot);
    //OrderItem GT
    Id rtProductGTRoot          = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.TERMINALE).getRecordTypeId(); 
    NE__Product__c productGTRoot = new NE__Product__c(RecordTypeId = rtProductGTRoot, OB_Codice_sfdc__c = 'SMPOS_CASSA', Name = 'SmartPOS Cassa', OB_Contract_Type__c = 'Contratto POS;Modulo Off Commercial', OB_Business_Model_POS__c = 'Diretto;Trilaterale Nuovo');
    insert productGTRoot;
    NE__OrderItem__c orderItemGTRoot = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__Action__c = 'Add', OB_GT__c = 'MONETICA', OB_TermId__c = '4444333221', NE__ProdId__c = productGTRoot.id, NE__Status__c = 'PENDING', OB_FulfilmentStatus__c = 'Completed');
    orderItemGTRoot.NE__AssetItemEnterpriseId__c = orderItemGTRoot.id;
    insert orderItemGTRoot;

    
    oiList.add(orderItemGTRoot);
    NE__Order_Item_Attribute__c attrGTRoot1 = new NE__Order_Item_Attribute__c();
    attrGTRoot1.Name = 'TermId';
    attrGTRoot1.NE__Order_Item__c = orderItemGTRoot.id;
    
    insert attrGTRoot1;
    NE__Order_Item_Attribute__c attrGTRoot2 = new NE__Order_Item_Attribute__c();
    attrGTRoot2.Name = 'modello';
    attrGTRoot2.NE__Order_Item__c = orderItemGTRoot.id;
    
    insert attrGTRoot2;
    NE__Order_Item_Attribute__c attrGTRoot3 = new NE__Order_Item_Attribute__c();
    attrGTRoot3.Name = 'release';
    attrGTRoot3.NE__Order_Item__c = orderItemGTRoot.id;
   
    insert attrGTRoot3;
    NE__Order_Item_Attribute__c attrGTRoot4 = new NE__Order_Item_Attribute__c();
    attrGTRoot4.Name = 'modalitaCollegamento';
    attrGTRoot4.NE__Order_Item__c = orderItemGTRoot.id;
   
    insert attrGTRoot4;
    NE__Order_Item_Attribute__c attrGTRoot5 = new NE__Order_Item_Attribute__c();
    attrGTRoot5.Name = 'descrizioneModello';
    attrGTRoot5.NE__Order_Item__c = orderItemGTRoot.id;
    
    insert attrGTRoot5;
    NE__Order_Item_Attribute__c attrGTRoot6 = new NE__Order_Item_Attribute__c();
    attrGTRoot6.Name = 'descrizioneRelease';
    attrGTRoot6.NE__Order_Item__c = orderItemGTRoot.id;
 
    insert attrGTRoot6;
    NE__Order_Item_Attribute__c attrGTRoot7 = new NE__Order_Item_Attribute__c();
    attrGTRoot7.Name = 'descrizioneConnessione';
    attrGTRoot7.NE__Order_Item__c = orderItemGTRoot.id;
  
    insert attrGTRoot7;
    NE__Order_Item_Attribute__c attrGTRoot8 = new NE__Order_Item_Attribute__c();
    attrGTRoot8.Name = 'Progressivo SIA';
    attrGTRoot8.NE__Order_Item__c = orderItemGTRoot.id;
    
    insert attrGTRoot8;
    NE__Order_Item_Attribute__c attrGTRoot9 = new NE__Order_Item_Attribute__c();
    attrGTRoot9.Name = 'Codice Stabilimento SIA';
    attrGTRoot9.NE__Order_Item__c = orderItemGTRoot.id;
   
    insert attrGTRoot9;
    NE__Order_Item_Attribute__c attrGTRoot10 = new NE__Order_Item_Attribute__c();
    attrGTRoot10.Name = 'Codice SIA';
    attrGTRoot10.NE__Order_Item__c = orderItemGTRoot.id;
    
    insert attrGTRoot10;
    Id rtProductGT           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.TERMINALE).getRecordTypeId(); 
    NE__Product__c productGT = new NE__Product__c(RecordTypeId = rtProductGT, OB_Codice_sfdc__c = 'INST', Name = 'Installazione pos', OB_Contract_Type__c = 'Installazione pos', OB_Contract_Description__c = 'Installazione pos');
    insert productGT;
    NE__OrderItem__c orderItemGT = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__Parent_Order_Item__c = orderItemGTRoot.id, NE__Action__c = 'Add', NE__ProdId__c = productGT.id , OB_FulfilmentStatus__c = 'Completed');
    orderItemGT.NE__AssetItemEnterpriseId__c= orderItemGT.id;
    insert orderItemGT;

    //Item Acquiring Child
    Id rtProductAcq           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.ACQUIRING).getRecordTypeId(); 
    NE__Product__c productAcq = new NE__Product__c(RecordTypeId = rtProductAcq, OB_Acquirer__c='NEXI', OB_Codice_sfdc__c = 'VISAMASTERCARD', Name = 'Visa/Mastercard', OB_Contract_Type__c = 'Contratto Acquiring', OB_Offer__c ='PERSONALIZZATA;START;XPAY_FULL');
    insert productAcq;
    NE__OrderItem__c orderItemAcq = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__ProdId__c = productAcq.id, NE__Action__c = 'Add', NE__Parent_Order_Item__c = orderItemGTRoot.id, OB_FulfilmentStatus__c = 'Completed'); 
    orderItemAcq.NE__AssetItemEnterpriseId__c =orderItemAcq.id;
    insert orderItemAcq;
    Id rtProductPric           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.PRICING).getRecordTypeId(); 
    NE__Product__c productPric = new NE__Product__c(RecordTypeId = rtProductPric, OB_Codice_sfdc__c = 'MAE_PRE', Name = 'MAESTRO CONSUMER PREPAID', OB_Contract_Type__c = 'Contratto Acquiring');
    insert productPric;
    NE__OrderItem__c orderItemPric = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__ProdId__c = productPric.id, NE__Action__c = 'Add', NE__Parent_Order_Item__c = orderItemAcq.id, OB_FulfilmentStatus__c = 'Completed'); 
    orderItemPric.NE__AssetItemEnterpriseId__c =orderItemPric.id;
    insert orderItemPric;

    //ADD ITEM TO CONFIGURATION
    Id rtProductPB    = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.PAGOBANCOMAT).getRecordTypeId(); 
        NE__Product__c productPB    = new NE__Product__c(OB_Acquirer__c=OB_EnrichOrder.NEXI, RecordTypeId =rtProductPB, OB_Codice_sfdc__c = 'PAGOBANCOMAT' );
        insert productPB;
    NE__OrderItem__c pagobancomat = New NE__OrderItem__c(NE__Qty__c=1 ,NE__OrderId__c=configuration.id, NE__Action__c = 'None', NE__ProdId__c = productPB.id, OB_FulfilmentStatus__c = 'Completed');    
    pagobancomat.NE__AssetItemEnterpriseId__c =pagobancomat.id;     
        insert pagobancomat;

    Id rtProductVAS   = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.VAS).getRecordTypeId(); 
    NE__Product__c productRootVAS   = new NE__Product__c(RecordTypeId = rtProductVAS, OB_Codice_sfdc__c = 'PELLEGRINI',OB_Acquirer__c='NEXI');
        insert productRootVAS;
    NE__OrderItem__c rootVas = New NE__OrderItem__c(NE__Qty__c=1 ,NE__OrderId__c=configuration.id, NE__Action__c = 'None', OB_FulfilmentStatus__c = 'Completed');   
    rootVas.NE__AssetItemEnterpriseId__c        =rootVas.id;
        insert rootVas;
    oiList.add(rootVas);
    NE__Product__c productVAS   = new NE__Product__c(RecordTypeId = rtProductVAS, OB_Codice_sfdc__c = 'PELLEGRINI',OB_Acquirer__c='NEXI');
        insert productVAS;
    NE__OrderItem__c vas = New NE__OrderItem__c(NE__Qty__c=1 ,NE__OrderId__c=configuration.id, NE__Action__c = 'Add', OB_FulfilmentStatus__c = 'Completed');        
    vas.NE__AssetItemEnterpriseId__c    =vas.id;
        insert vas;
    oiList.add(vas);
    NE__Product__c product1    = new NE__Product__c(OB_Acquirer__c=OB_EnrichOrder.NEXI , RecordTypeId =rtProductPric );
        product1.OB_Codice_sfdc__c = 'ALB_AUTO';
        insert product1;

        NE__OrderItem__c orderItem1 = new NE__OrderItem__c();
        orderItem1.NE__Qty__c     = 1;
        orderItem1.NE__OrderId__c = configuration.id;
        orderItem1.NE__ProdId__c  = product1.id;
    orderItem1.NE__Action__c = 'Add';
    orderItem1.OB_FulfilmentStatus__c = 'Completed';
    orderItem1.NE__Parent_Order_Item__c = orderItemAcq.id;
    orderItem1.NE__Parent_Order_Item__c = orderItemAcq.id;
    orderItem1.NE__AssetItemEnterpriseId__c = orderItem1.id;
        insert orderItem1;

    //orderItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.ACQUIRING && orderItem.NE__ProdId__r.OB_Acquirer__c!=OB_EnrichOrder.NEXI
    NE__Product__c productNotNexi    = new NE__Product__c(OB_Acquirer__c='AMEX' , RecordTypeId =rtProductAcqRoot, OB_Codice_sfdc__c = 'AMEX' );
        insert productNotNexi;

    NE__OrderItem__c orderItemNotNexi = new NE__OrderItem__c();
    orderItemNotNexi.NE__Qty__c     = 1;
        orderItemNotNexi.NE__OrderId__c = configuration.id;
        orderItemNotNexi.NE__ProdId__c  = productNotNexi.id;
    orderItemNotNexi.NE__Action__c = 'None';
    orderItemNotNexi.OB_FulfilmentStatus__c = 'Completed';
    orderItemNotNexi.NE__Parent_Order_Item__c = null;
    orderItemNotNexi.OB_FulfilmentStatus__c = 'Completed';
    orderItemNotNexi.NE__AssetItemEnterpriseId__c= orderItemNotNexi.id;
        insert orderItemNotNexi;

    NE__Product__c productNotNexiPricing   = new NE__Product__c(OB_Acquirer__c='AMEX' , RecordTypeId =rtProductPric, OB_Codice_sfdc__c = 'PRICING' );
        insert productNotNexiPricing;
    NE__OrderItem__c orderItemNotNexiPric = new NE__OrderItem__c();
    orderItemNotNexiPric.NE__Qty__c     = 1;
        orderItemNotNexiPric.NE__OrderId__c = configuration.id;
        orderItemNotNexiPric.NE__ProdId__c  = productNotNexiPricing.id;
    orderItemNotNexiPric.NE__Action__c = 'None';
    orderItemNotNexiPric.OB_FulfilmentStatus__c = 'Completed';
    orderItemNotNexiPric.NE__Parent_Order_Item__c = orderItemNotNexi.id;
    orderItemNotNexiPric.NE__AssetItemEnterpriseId__c= orderItemNotNexiPric.id;
        insert orderItemNotNexiPric;
    
    
    
    //ASSET
    Asset asset = new Asset(NE__AssetItemEnterpriseId__c = orderItemGTRoot.Id, OB_ShopCode__c = 'shopCode', OB_GT__c = 'GT', OB_CustomerCode__c = 'customerCode', Name = 'SmartPOS');
    insert asset;
    NE__AssetItemAttribute__c attr1 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.TERMID, NE__Asset__c = asset.id);
    insert attr1;
    NE__AssetItemAttribute__c attr2 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.MODELLO, NE__Asset__c = asset.id);
    insert attr2;
    NE__AssetItemAttribute__c attr3 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.RELEASE, NE__Asset__c = asset.id);
    insert attr3;
    NE__AssetItemAttribute__c attr4 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.MODCOLLEGAMENTO, NE__Asset__c = asset.id);
    insert attr4;
    NE__AssetItemAttribute__c attr5 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.DMODELLO, NE__Asset__c = asset.id);
    insert attr5;
    NE__AssetItemAttribute__c attr6 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.DRELEASE, NE__Asset__c = asset.id);
    insert attr6;
    NE__AssetItemAttribute__c attr7 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.DCONNESSIONE, NE__Asset__c = asset.id);
    insert attr7;
    NE__AssetItemAttribute__c attr8 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.PROGRESSIVOSIA, NE__Asset__c = asset.id);
    insert attr8;
    NE__AssetItemAttribute__c attr9 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.CODICESTABILIMENTOSIA, NE__Asset__c = asset.id);
    insert attr9;
    NE__AssetItemAttribute__c attr10 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.CODICESIA, NE__Asset__c = asset.id);
    insert attr10;

    //LOV
    NE__Lov__c lovMCC2 = new NE__Lov__c();
    lovMCC2.NE__Type__c   = 'mcc';
    lovMCC2.NE__Value3__c = 'L2';
    lovMCC2.OB_Value4__c  = configuration.OB_MCCL2__c;
    lovMCC2.NE__Value2__c = configuration.OB_MCCL2__c;
    insert lovMCC2;
    System.debug('@@@lovMCC2 '+lovMCC2);
    NE__Lov__c lov = new NE__Lov__c();
    lov.NE__Type__c     ='TRACKING';
    lov.NE__Sub_Type__c = 'TIPOLOGICHE';
    lov.NE__Value2__c   = 'DINERS';
    lov.NE__Value1__c   = '12';
    insert lov;

    OB_TrackingUtility.ErrorList error1 = new OB_TrackingUtility.ErrorList();

     List<OB_TrackingUtility.ErrorList> errorsList1 = new List<OB_TrackingUtility.ErrorList>();
    

    OB_TrackingUtility.Changes change = new OB_TrackingUtility.Changes();
    change.externalId = rootVas.id; //TERMINALE
    change.result = 'OK';
    change.errors = errorsList1; //List

   
  
    List<OB_TrackingUtility.Changes> changesList = new List<OB_TrackingUtility.Changes>();
    changesList.add(change);

    
    
    OB_TrackingUtility.CodiciConvenzioni codConv = new OB_TrackingUtility.CodiciConvenzioni();
    codConv.companyCode = 'companyCode';
    codConv.companyName = 'companyName';                                
    codConv.code        = 'code';                                       
    codConv.causaleRifiuto ='causaleRifiuto';
    codConv.startDate = '2011-11-13';
    codConv.endDate = '';
    codConv.status  = 'Activated';

    List<OB_TrackingUtility.CodiciConvenzioni> codConvList = new List<OB_TrackingUtility.CodiciConvenzioni>();
    codConvList.add(codConv);

    OB_TrackingUtility.TermsIdInformation termInfo = new OB_TrackingUtility.TermsIdInformation();    
    termInfo.terminalId = orderItemGTRoot.OB_TermId__c;
    termInfo.model = 'model';
    termInfo.connectionType = 'connectionType';
    termInfo.modality = 'modality';
    termInfo.modelDescription = 'modelDescription';
    termInfo.release = 'release';
    termInfo.releaseDescription = 'releaseDescription';
    termInfo.status = 'Pending';
    termInfo.reasonOfRejection = '';
    termInfo.installationDate = '2011-11-13';
    termInfo.uninstallationDate = '';
    termInfo.agreementCodes = codConvList; //List
    termInfo.errors = null; //List

    List<OB_TrackingUtility.TermsIdInformation> termsInfoList = new List<OB_TrackingUtility.TermsIdInformation>();
    termsInfoList.add(termInfo);

    OB_TrackingUtility.ErrorList error = new OB_TrackingUtility.ErrorList();
    error.code = '';
    error.description = '';

    
   

    List<OB_TrackingUtility.ErrorList> errorsList = new List<OB_TrackingUtility.ErrorList>();
    errorsList.add(error);
   

    OB_TrackingUtility.puntoVendita pV = new OB_TrackingUtility.puntoVendita();
    //pV.itemId = '';
    pV.PVCode = servicePoint.id;
    pV.startDate = '2011-11-13';
    pV.endDate = '';
    pV.reasonOfClosure = '';
    //pV.tipo = '';
    pV.ctiCode = 'ctiCode';
    pV.StabiCode = 'StabiCode';
    pV.siaPVCode = 'siaPVCode';
    pV.siaProgressiveCode = 'siaProgressiveCode';
    pV.siaMerchantCode = 'siaMerchantCode';
    pV.assistanceNumber = 'assistanceNumber';
    //pV.dataInizioAttivita = '2011-11-13';
    pv.terminalInformation = termsInfoList; //List
    pv.changes = changesList;

    List<OB_TrackingUtility.puntoVendita> pVList = new List<OB_TrackingUtility.puntoVendita>();
    pVList.add(pV);

    OB_TrackingUtility.GT gT = new OB_TrackingUtility.GT();
    gT.source = 'MONETICA';
    gT.gtCompanyCode = 'companyCode';
    gT.errors = errorsList; //List
    gT.PVCodes = pVList; //List
    //gT.statoProvisioning = '';

    List<OB_TrackingUtility.GT> gTList = new List<OB_TrackingUtility.GT>();
    gTList.add(gT);

    OB_TrackingUtility.Acquiring acquiring = new OB_TrackingUtility.Acquiring();
    acquiring.source = 'NEXI';
    acquiring.companyCode = 'companyCode';
    acquiring.errori = null;
    acquiring.PVCodes = pVList;

    List<OB_TrackingUtility.Acquiring> acquiringList = new List<OB_TrackingUtility.Acquiring>();
    acquiringList.add(acquiring);

    OB_TrackingUtility.TrackingOrderRequestMaintenance trackingOrderRequest = new OB_TrackingUtility.TrackingOrderRequestMaintenance();
    trackingOrderRequest.orderId = configuration.id;
    trackingOrderRequest.Acquiring = acquiringList;
    trackingOrderRequest.GT = gTList;

    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();
    req.requestURI = '/TrackingOrderMaintenance/*'; 
    req.httpMethod = 'POST';
    RestContext.request = req;
    String json = JSON.serialize(trackingOrderRequest);
    RestContext.request.requestBody =  Blob.valueof(json);
    RestContext.response = res;

    List<OB_LogRequest__c> listLog = new List<OB_LogRequest__c>();
    OB_LogRequest__c log = OB_TestDataFactory.getLogRequest();
    listLog.add(log);
    Test.startTest();
    OB_TrackingUtility.TrackingOrderResponseMaintenance response = OB_TrackingOrderMaintenance.trackOrderMaintenance();
    OB_TrackingOrderMaintenance.isAcquiringVas(acquiringList);
    OB_TrackingOrderMaintenance.isAcquiringTerminal(acquiringList, true);
    OB_TrackingOrderMaintenance.isAcquiringTerminal(acquiringList, false);
    OB_TrackingOrderMaintenance.updateLogRequest(configuration.id);
    OB_TrackingOrderMaintenance.updateVasItems(oiList,changesList,'','','','',listLog);
    System.assertEquals( 500, response.httpStatus);
    Test.stopTest();
    }


     @isTest
  public static void updateAssetDate_Test4 ( ){

      Id rtMerchant       = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId(); 
    Account myMastMerchant  = new Account(Name='TEST',
                                          RecordTypeId=rtMerchant,
                                          OB_Employees_Number__c='Minore di 10',
                                          OB_VAT_Not_Present__c=true, 
                                          OB_DescriptionVATNotPresent__c='description', 
                                          NE__Fiscal_code__c='RSSMRA80A01F205X',
                                          OB_BypassValidation__c=true,
                                          OB_Status__c='Active'); 

  
    insert myMastMerchant;
      Id accountBankRecordId   = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Bank').getRecordTypeId(); 
    account bankAccount   = new Account(Name='TEST',
                                        RecordTypeId=accountBankRecordId,
                                        OB_Employees_Number__c='Minore di 10',
                                        OB_VAT_Not_Present__c=true, 
                                        OB_DescriptionVATNotPresent__c='description', 
                                        NE__Fiscal_code__c='RSSMRA80A01F205X',
                                        OB_BypassValidation__c=true,
                                        OB_Status__c='Active');   
     insert  bankAccount;
    NE__Service_Point__c servicePoint = new NE__Service_Point__c();
    insert servicePoint;
    NE__Order_Header__c orderHeader = new NE__Order_Header__c(OB_ProposerABI__c=bankAccount.Id ,NE__AccountId__c=myMastMerchant.Id, OB_Main_Process__c = 'Maintenance', OB_Sub_Process__c = 'variazione operativa', OB_Business_Model_Acquiring__c = 'Bancario');
    insert orderHeader;
     NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
     testOrder.OB_Service_Point__c = servicePoint.id;
     testOrder.NE__Order_Header__c = orderHeader.id;
    insert testOrder;
    id rtProductGTRoot          = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.TERMINALE).getRecordTypeId(); 
    NE__Product__c productGTRoot = new NE__Product__c(RecordTypeId = rtProductGTRoot, OB_Codice_sfdc__c = 'SMPOS_CASSA', Name = 'SmartPOS Cassa', OB_Contract_Type__c = 'Contratto POS;Modulo Off Commercial', OB_Business_Model_POS__c = 'Diretto;Trilaterale Nuovo');
    insert productGTRoot;
    list< NE__OrderItem__c > orderItemsList = new list<NE__OrderItem__c>( );

    NE__OrderItem__c testOrderItem = OB_TestDataFactory.getOrderItem( testOrder.Id );
    testOrderItem.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem.OB_CustomerCode__c = 'TEST';
    testOrderItem.OB_ShopCode__c = 'TEST';
    testOrderItem.NE__ProdId__c  = productGTRoot.id;
    testOrderItem.OB_TermId__c = '4444333221';
    testOrderItem.NE__Action__c = 'Add';
    testOrderItem.NE__Account__c = myMastMerchant.id;

  
    insert testOrderItem;

 

    NE__OrderItem__c testOrderItem3 = OB_TestDataFactory.getOrderItem(testOrder.Id);
    testOrderItem3.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem3.OB_CustomerCode__c = 'TEST';
    testOrderItem3.OB_ShopCode__c = 'TEST';
    testOrderItem3.NE__Parent_Order_Item__c = testOrderItem.Id;
    orderItemsList.add(testOrderItem3);

    NE__OrderItem__c testOrderItem2 = OB_TestDataFactory.getOrderItem(testOrder.Id);
    testOrderItem2.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem2.OB_CustomerCode__c = 'TEST';
    testOrderItem2.OB_ShopCode__c = 'TEST';
    testOrderItem2.NE__Parent_Order_Item__c = testOrderItem.Id;
    orderItemsList.add(testOrderItem2);

    insert orderItemsList;


    list< NE__OrderItem__c > orderItemsList1 = new list< NE__OrderItem__c >( );

    NE__OrderItem__c testOrderItem1 = OB_TestDataFactory.getOrderItem( testOrder.Id );
    testOrderItem1.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem1.OB_CustomerCode__c = 'TEST';
    testOrderItem1.OB_ShopCode__c = 'TEST';
    testOrderItem1.NE__Root_Order_Item__c = testOrderItem2.Id;
    orderItemsList1.add(testOrderItem1);
    NE__OrderItem__c testOrderItem4 = OB_TestDataFactory.getOrderItem( testOrder.Id );
    testOrderItem4.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem4.OB_CustomerCode__c = 'TEST';
    testOrderItem4.OB_ShopCode__c = 'TEST';
    testOrderItem4.NE__Root_Order_Item__c = testOrderItem2.Id;
    orderItemsList1.add( testOrderItem4 );
    insert orderItemsList1;
    list< NE__OrderItem__c > orderItemsList2 = new list< NE__OrderItem__c >( );
    NE__OrderItem__c testOrderItem5 = OB_TestDataFactory.getOrderItem( testOrder.Id );
    testOrderItem5.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem5.OB_CustomerCode__c = 'TEST';
    testOrderItem5.OB_ShopCode__c = 'TEST';
    testOrderItem5.NE__Root_Order_Item__c = testOrderItem3.Id;
    orderItemsList2.add( testOrderItem5 );
    NE__OrderItem__c testOrderItem6 = OB_TestDataFactory.getOrderItem( testOrder.Id );
    testOrderItem6.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem6.OB_CustomerCode__c = 'TEST';
    testOrderItem6.OB_ShopCode__c = 'TEST';
    testOrderItem6.NE__Root_Order_Item__c = testOrderItem3.Id;
    orderItemsList2.add( testOrderItem6 );
    insert orderItemsList2;

  Map<Id, Asset> mapAsset = new Map<Id,Asset>();
    Asset asset1 = new Asset(NE__AssetItemEnterpriseId__c = testOrderItem.Id, OB_ShopCode__c = 'shopCode',  OB_GT__c = 'GT', OB_CustomerCode__c = 'customerCode', Name = 'SmartPOS', NE__Status__c = 'Active', NE__Action__c = 'None');
    insert asset1;
    mapAsset.put(asset1.id, asset1);
    Asset asset = new Asset(NE__AssetItemEnterpriseId__c = testOrderItem.Id, OB_ShopCode__c = 'shopCode',   OB_GT__c = 'GT', OB_CustomerCode__c = 'customerCode', Name = 'SmartPOS', NE__Status__c = 'Active', NE__Action__c = 'None');
    insert asset;
    asset.id= asset1.id;
    update asset;
    mapAsset.put(asset.id, asset);


    OB_TrackingUtility.CodiciConvenzioni codConv = new OB_TrackingUtility.CodiciConvenzioni();
    codConv.companyCode = 'companyCode';
    codConv.companyName = 'companyName';                                
    codConv.code        = 'code';                                       
    codConv.causaleRifiuto ='causaleRifiuto';
    codConv.startDate = '2011-11-13';
    codConv.endDate = '';
    codConv.status  = 'Disabled';

    List<OB_TrackingUtility.CodiciConvenzioni> codConvList = new List<OB_TrackingUtility.CodiciConvenzioni>();
    codConvList.add(codConv);

    


    OB_TrackingUtility.TermsIdInformation termInfo = new OB_TrackingUtility.TermsIdInformation();    
    termInfo.terminalId = testOrderItem.OB_TermId__c;
    termInfo.model = 'model';
    termInfo.connectionType = 'connectionType';
    termInfo.modality = 'modality';
    termInfo.modelDescription = 'modelDescription';
    termInfo.release = 'release';
    termInfo.releaseDescription = 'releaseDescription';
    termInfo.status = 'Installed';
    termInfo.reasonOfRejection = '';
    termInfo.installationDate = '2011-11-13';
    termInfo.uninstallationDate = '';
    termInfo.agreementCodes = codConvList; //List
    termInfo.errors = null; //List

    List<OB_TrackingUtility.TermsIdInformation> termsInfoList = new List<OB_TrackingUtility.TermsIdInformation>();
    termsInfoList.add(termInfo);

    OB_TrackingUtility.ErrorList error = new OB_TrackingUtility.ErrorList();
    error.code = '';
    error.description = '';

    
   

    List<OB_TrackingUtility.ErrorList> errorsList = new List<OB_TrackingUtility.ErrorList>();
    errorsList.add(error);
   

    OB_TrackingUtility.puntoVendita pV = new OB_TrackingUtility.puntoVendita();
    //pV.itemId = '';
    pV.PVCode = '1234567';
    pV.startDate = '2011-11-13';
    pV.endDate = '';
    pV.reasonOfClosure = '';
    //pV.tipo = '';
    pV.ctiCode = 'ctiCode';
    pV.StabiCode = 'StabiCode';
    pV.siaPVCode = 'siaPVCode';
    pV.siaProgressiveCode = 'siaProgressiveCode';
    pV.siaMerchantCode = 'siaMerchantCode';
    pV.assistanceNumber = 'assistanceNumber';
    //pV.dataInizioAttivita = '2011-11-13';
    pv.terminalInformation = termsInfoList; //List
    pv.changes = null;

    List<OB_TrackingUtility.puntoVendita> pVList = new List<OB_TrackingUtility.puntoVendita>();
    pVList.add(pV);

    OB_TrackingUtility.GT gT = new OB_TrackingUtility.GT();
    gT.source = 'MONETICA';
    gT.gtCompanyCode = 'companyCode';
    gT.errors = null; //List
    gT.PVCodes = pVList; //List
    //gT.statoProvisioning = '';

    List<OB_TrackingUtility.GT> gTList = new List<OB_TrackingUtility.GT>();
    gTList.add(gT);



    
    // OB_TrackingUtility.TrackingOrderRequestMaintenance trackingOrderRequest = new OB_TrackingUtility.TrackingOrderRequestMaintenance();
    // trackingOrderRequest.orderId = testOrder.id;
    // //trackingOrderRequest.Acquiring = acquiringList;
    // trackingOrderRequest.GT = gTList;
    String orderid= testOrder.id;
    Test.startTest();
    
    OB_TrackingOrderMaintenance.updateAssetDate(termsInfoList, orderid , mapAsset);
    
 
    //OB_TrackingOrderMaintenance.isAcquiringAcquiring(acquiringList);
    //OB_TrackingUtility.updateVasItems(oiList,changesList,'','','','',listLog);
    Test.stopTest();

  }

   @isTest
  public static void updateAssetDate_Test5 ( ){

      Id rtMerchant       = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId(); 
    Account myMastMerchant  = new Account(Name='TEST',
                                          RecordTypeId=rtMerchant,
                                          OB_Employees_Number__c='Minore di 10',
                                          OB_VAT_Not_Present__c=true, 
                                          OB_DescriptionVATNotPresent__c='description', 
                                          NE__Fiscal_code__c='RSSMRA80A01F205X',
                                          OB_BypassValidation__c=true,
                                          OB_Status__c='Active'); 

  
    insert myMastMerchant;
      Id accountBankRecordId   = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Bank').getRecordTypeId(); 
    account bankAccount   = new Account(Name='TEST',
                                        RecordTypeId=accountBankRecordId,
                                        OB_Employees_Number__c='Minore di 10',
                                        OB_VAT_Not_Present__c=true, 
                                        OB_DescriptionVATNotPresent__c='description', 
                                        NE__Fiscal_code__c='RSSMRA80A01F205X',
                                        OB_BypassValidation__c=true,
                                        OB_Status__c='Active');   
     insert  bankAccount;
    NE__Service_Point__c servicePoint = new NE__Service_Point__c();
    insert servicePoint;
    NE__Order_Header__c orderHeader = new NE__Order_Header__c(OB_ProposerABI__c=bankAccount.Id ,NE__AccountId__c=myMastMerchant.Id, OB_Main_Process__c = 'Maintenance', OB_Sub_Process__c = 'variazione operativa', OB_Business_Model_Acquiring__c = 'Bancario');
    insert orderHeader;
     NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
     testOrder.OB_Service_Point__c = servicePoint.id;
     testOrder.NE__Order_Header__c = orderHeader.id;
    insert testOrder;
    id rtProductGTRoot          = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.TERMINALE).getRecordTypeId(); 
    NE__Product__c productGTRoot = new NE__Product__c(RecordTypeId = rtProductGTRoot, OB_Codice_sfdc__c = 'SMPOS_CASSA', Name = 'SmartPOS Cassa', OB_Contract_Type__c = 'Contratto POS;Modulo Off Commercial', OB_Business_Model_POS__c = 'Diretto;Trilaterale Nuovo');
    insert productGTRoot;
    list< NE__OrderItem__c > orderItemsList = new list<NE__OrderItem__c>( );

    NE__OrderItem__c testOrderItem = OB_TestDataFactory.getOrderItem( testOrder.Id );
    testOrderItem.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem.OB_CustomerCode__c = 'TEST';
    testOrderItem.OB_ShopCode__c = 'TEST';
    testOrderItem.NE__ProdId__c  = productGTRoot.id;
    testOrderItem.OB_TermId__c = '4444333221';
    testOrderItem.NE__Action__c = 'Add';
    testOrderItem.NE__Account__c = myMastMerchant.id;

  
    insert testOrderItem;

 

    NE__OrderItem__c testOrderItem3 = OB_TestDataFactory.getOrderItem(testOrder.Id);
    testOrderItem3.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem3.OB_CustomerCode__c = 'TEST';
    testOrderItem3.OB_ShopCode__c = 'TEST';
    testOrderItem3.NE__Parent_Order_Item__c = testOrderItem.Id;
    testOrderItem3.OB_enablement__c= 'N';
    testOrderItem3.OB_Old_Enablement__c= 'Y';
    orderItemsList.add(testOrderItem3);

    NE__OrderItem__c testOrderItem2 = OB_TestDataFactory.getOrderItem(testOrder.Id);
    testOrderItem2.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem2.OB_CustomerCode__c = 'TEST';
    testOrderItem2.OB_ShopCode__c = 'TEST';
    testOrderItem2.NE__Parent_Order_Item__c = testOrderItem.Id;
    testOrderItem2.OB_enablement__c= 'Y';
    testOrderItem2.OB_Old_Enablement__c= 'N';
    orderItemsList.add(testOrderItem2);

    insert orderItemsList;


    list< NE__OrderItem__c > orderItemsList1 = new list< NE__OrderItem__c >( );

    NE__OrderItem__c testOrderItem1 = OB_TestDataFactory.getOrderItem( testOrder.Id );
    testOrderItem1.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem1.OB_CustomerCode__c = 'TEST';
    testOrderItem1.OB_ShopCode__c = 'TEST';
    testOrderItem1.NE__Root_Order_Item__c = testOrderItem2.Id;
    orderItemsList1.add(testOrderItem1);
    NE__OrderItem__c testOrderItem4 = OB_TestDataFactory.getOrderItem( testOrder.Id );
    testOrderItem4.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem4.OB_CustomerCode__c = 'TEST';
    testOrderItem4.OB_ShopCode__c = 'TEST';
    testOrderItem4.NE__Root_Order_Item__c = testOrderItem2.Id;
    orderItemsList1.add( testOrderItem4 );
    insert orderItemsList1;
    list< NE__OrderItem__c > orderItemsList2 = new list< NE__OrderItem__c >( );
    NE__OrderItem__c testOrderItem5 = OB_TestDataFactory.getOrderItem( testOrder.Id );
    testOrderItem5.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem5.OB_CustomerCode__c = 'TEST';
    testOrderItem5.OB_ShopCode__c = 'TEST';
    testOrderItem5.NE__Root_Order_Item__c = testOrderItem3.Id;
    orderItemsList2.add( testOrderItem5 );
    NE__OrderItem__c testOrderItem6 = OB_TestDataFactory.getOrderItem( testOrder.Id );
    testOrderItem6.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem6.OB_CustomerCode__c = 'TEST';
    testOrderItem6.OB_ShopCode__c = 'TEST';
    testOrderItem6.NE__Root_Order_Item__c = testOrderItem3.Id;
    orderItemsList2.add( testOrderItem6 );
    insert orderItemsList2;

    Map<Id, Asset> mapAsset = new Map<Id,Asset>();
    Asset asset1 = new Asset(NE__AssetItemEnterpriseId__c = testOrderItem.Id, OB_ShopCode__c = 'shopCode',  OB_GT__c = 'GT', OB_CustomerCode__c = 'customerCode', Name = 'SmartPOS', NE__Status__c = 'Active', NE__Action__c = 'None');
    insert asset1;
    mapAsset.put(asset1.id, asset1);
    Asset asset = new Asset(NE__AssetItemEnterpriseId__c = testOrderItem.Id, OB_ShopCode__c = 'shopCode',   OB_GT__c = 'GT', OB_CustomerCode__c = 'customerCode', Name = 'SmartPOS', NE__Status__c = 'Active', NE__Action__c = 'None');
    insert asset;
    asset.id= asset1.id;
    update asset;
    mapAsset.put(asset.id, asset);


    OB_TrackingUtility.ErrorList error = new OB_TrackingUtility.ErrorList();
    error.code = '';
    error.description = '';

    
   

    List<OB_TrackingUtility.ErrorList> errorsList = new List<OB_TrackingUtility.ErrorList>();
    errorsList.add(error);


    OB_TrackingUtility.CodiciConvenzioni codConv = new OB_TrackingUtility.CodiciConvenzioni();
    codConv.companyCode = 'companyCode';
    codConv.companyName = 'companyName';                                
    codConv.code        = 'code';                                       
    codConv.causaleRifiuto ='causaleRifiuto';
    codConv.startDate = '2011-11-13';
    codConv.endDate = '';
    codConv.status  = 'Refused';

    List<OB_TrackingUtility.CodiciConvenzioni> codConvList = new List<OB_TrackingUtility.CodiciConvenzioni>();
    codConvList.add(codConv);

    


    OB_TrackingUtility.TermsIdInformation termInfo = new OB_TrackingUtility.TermsIdInformation();    
    termInfo.terminalId = testOrderItem.OB_TermId__c;
    termInfo.model = 'model';
    termInfo.connectionType = 'connectionType';
    termInfo.modality = 'modality';
    termInfo.modelDescription = 'modelDescription';
    termInfo.release = 'release';
    termInfo.releaseDescription = 'releaseDescription';
    termInfo.status = 'Installed';
    termInfo.reasonOfRejection = '';
    termInfo.installationDate = '2011-11-13';
    termInfo.uninstallationDate = '';
    termInfo.agreementCodes = codConvList; //List
    termInfo.errors = errorsList; //List

    List<OB_TrackingUtility.TermsIdInformation> termsInfoList = new List<OB_TrackingUtility.TermsIdInformation>();
    termsInfoList.add(termInfo);

    
   

    OB_TrackingUtility.puntoVendita pV = new OB_TrackingUtility.puntoVendita();
    //pV.itemId = '';
    pV.PVCode = '1234567';
    pV.startDate = '2011-11-13';
    pV.endDate = '';
    pV.reasonOfClosure = '';
    //pV.tipo = '';
    pV.ctiCode = 'ctiCode';
    pV.StabiCode = 'StabiCode';
    pV.siaPVCode = 'siaPVCode';
    pV.siaProgressiveCode = 'siaProgressiveCode';
    pV.siaMerchantCode = 'siaMerchantCode';
    pV.assistanceNumber = 'assistanceNumber';
    //pV.dataInizioAttivita = '2011-11-13';
    pv.terminalInformation = termsInfoList; //List
    pv.changes = null;

    List<OB_TrackingUtility.puntoVendita> pVList = new List<OB_TrackingUtility.puntoVendita>();
    pVList.add(pV);

    OB_TrackingUtility.GT gT = new OB_TrackingUtility.GT();
    gT.source = 'MONETICA';
    gT.gtCompanyCode = 'companyCode';
    gT.errors = null; //List
    gT.PVCodes = pVList; //List
    //gT.statoProvisioning = '';

    List<OB_TrackingUtility.GT> gTList = new List<OB_TrackingUtility.GT>();
    gTList.add(gT);



    
    // OB_TrackingUtility.TrackingOrderRequestMaintenance trackingOrderRequest = new OB_TrackingUtility.TrackingOrderRequestMaintenance();
    // trackingOrderRequest.orderId = testOrder.id;
    // //trackingOrderRequest.Acquiring = acquiringList;
    // trackingOrderRequest.GT = gTList;
    String orderid= testOrder.id;
    Test.startTest();
     List<NE__OrderItem__c> listOi = [SELECT OB_isNotIntegrated__c from NE__OrderItem__c where NE__OrderId__c = :orderid];
   
   
   
    
    OB_TrackingOrderMaintenance.updateAssetDate(termsInfoList, orderid , mapAsset);
      System.assertEquals(false, listOi.get(0).OB_isNotIntegrated__c);  
 
    //OB_TrackingOrderMaintenance.isAcquiringAcquiring(acquiringList);
    //OB_TrackingUtility.updateVasItems(oiList,changesList,'','','','',listLog);
    Test.stopTest();

  }


  @isTest
  public static void enablementTerminal_test ( ){

    NE__Order_Header__c oh =  OB_TestDataFactory.getOrderHeader();
    insert oh;
    // NE__Order__c or =   new NE__order__C();//OB_TestDataFactory.getOrder(oh);
    // or.NE__Order_Header__c= oh.Id;
    // insert or;

    // NE__OrderItem__c oi = OB_TestDataFactory.getOrderItem(or.Id);
    // oi.OB_enablement__c = 'N';
    // oi.OB_Old_Enablement__c = 'Y';
    // insert oi;

    // NE__OrderItem__c oi1 = OB_TestDataFactory.getOrderItem(or.Id);
    // oi1.OB_enablement__c = 'Y';
    // oi1.OB_Old_Enablement__c = 'N';
    // insert oi1;


    // NE__Order_Header__c oh = OB_TestDataFactory.getOrderHeader();
    // oh.OB_Main_Process__c = 'Maintenance';
    // insert oh;
    NE__Order__c order = OB_TestDataFactory.getOrder(oh);
    insert Order;

    NE__Product__c prod =OB_TestDataFactory.getProduct( );
    prod.RecordTypeId = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.POS_RT ).getRecordTypeId( );
    NE__Product__c prod1 =OB_TestDataFactory.getProduct( );
    prod1.RecordTypeId = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.ACQUIRING_RT ).getRecordTypeId( );
    prod1.OB_Codice_sfdc__c ='JCB';
    insert prod;
    insert prod1;
    NE__OrderItem__c oi = OB_TestDataFactory.getOrderItem(order.Id);
    oi.NE__ProdId__c = prod.id;
    oi.OB_TermId__c ='1234234';
    insert oi;

    NE__OrderItem__c oi2 = OB_TestDataFactory.getOrderItem(order.Id);
    oi2.OB_enablement__c = 'N';
    oi2.OB_Old_Enablement__c = 'Y';
    oi2.NE__Parent_Order_Item__c = oi.Id;
    oi2.NE__ProdId__c = prod1.id;
    oi2.NE__Action__c = 'Add';
    insert oi2;

    NE__OrderItem__c oi1 = OB_TestDataFactory.getOrderItem(order.Id);
    oi1.OB_enablement__c = 'Y';
    oi1.OB_Old_Enablement__c = 'N';
    oi1.NE__Parent_Order_Item__c = oi.Id;
    insert oi1;
   
    OB_TrackingUtility.ErrorList error = new OB_TrackingUtility.ErrorList();
    error.code = '';
    error.description = '';

    List<OB_TrackingUtility.ErrorList> errorsList = new List<OB_TrackingUtility.ErrorList>();
    errorsList.add(error);


    OB_TrackingUtility.CodiciConvenzioni codConv = new OB_TrackingUtility.CodiciConvenzioni();
    codConv.companyCode = 'companyCode';
    codConv.companyName = 'JCB';								
    codConv.code        = 'code';										
    codConv.causaleRifiuto ='causaleRifiuto';
    codConv.startDate = '2011-11-13';
    codConv.endDate = '';
    codConv.status	= 'Activated';

    List<OB_TrackingUtility.CodiciConvenzioni> codConvList = new List<OB_TrackingUtility.CodiciConvenzioni>();
    codConvList.add(codConv);

    


    OB_TrackingUtility.TermsIdInformation termInfo = new OB_TrackingUtility.TermsIdInformation();    
    termInfo.terminalId = '1234234';
    termInfo.model = 'model';
    termInfo.connectionType = 'connectionType';
    termInfo.modality = 'modality';
    termInfo.modelDescription = 'modelDescription';
    termInfo.release = 'release';
    termInfo.releaseDescription = 'releaseDescription';
    termInfo.status = 'Installed';
    termInfo.reasonOfRejection = '';
    termInfo.installationDate = '2011-11-13';
    termInfo.uninstallationDate = '';
    termInfo.agreementCodes = codConvList; //List
    termInfo.errors = errorsList; //List

    List<OB_TrackingUtility.TermsIdInformation> termsInfoList = new List<OB_TrackingUtility.TermsIdInformation>();
    termsInfoList.add(termInfo);

    
   

    OB_TrackingUtility.puntoVendita pV = new OB_TrackingUtility.puntoVendita();
    //pV.itemId = '';
    pV.PVCode = '1234567';
    pV.startDate = '2011-11-13';
    pV.endDate = '';
    pV.reasonOfClosure = '';
    //pV.tipo = '';
    pV.ctiCode = 'ctiCode';
    pV.StabiCode = 'StabiCode';
    pV.siaPVCode = 'siaPVCode';
    pV.siaProgressiveCode = 'siaProgressiveCode';
    pV.siaMerchantCode = 'siaMerchantCode';
    pV.assistanceNumber = 'assistanceNumber';
    //pV.dataInizioAttivita = '2011-11-13';
    pv.terminalInformation = termsInfoList; //List
    pv.changes = null;

    List<OB_TrackingUtility.puntoVendita> pVList = new List<OB_TrackingUtility.puntoVendita>();
    pVList.add(pV);

    OB_TrackingUtility.GT gT = new OB_TrackingUtility.GT();
    gT.source = 'MONETICA';
    gT.gtCompanyCode = 'companyCode';
    gT.errors = null; //List
    gT.PVCodes = pVList; //List
    //gT.statoProvisioning = '';

    List<OB_TrackingUtility.GT> gTList = new List<OB_TrackingUtility.GT>();
    gTList.add(gT);



    
    // OB_TrackingUtility.TrackingOrderRequestMaintenance trackingOrderRequest = new OB_TrackingUtility.TrackingOrderRequestMaintenance();
    // trackingOrderRequest.orderId = testOrder.id;
    // //trackingOrderRequest.Acquiring = acquiringList;
    // trackingOrderRequest.GT = gTList;
   
    Test.startTest();
    
    List<NE__OrderItem__c> listOi = [SELECT OB_isNotIntegrated__c from NE__OrderItem__c where NE__OrderId__c = :order.id];
   
    OB_TrackingOrderMaintenance.enablementAgreedCode(order.id , codConvList, termInfo.terminalId , termInfo.errors);
     System.assertEquals(false, listOi.get(0).OB_isNotIntegrated__c);  
    
 
    //OB_TrackingOrderMaintenance.isAcquiringAcquiring(acquiringList);
    //OB_TrackingUtility.updateVasItems(oiList,changesList,'','','','',listLog);
    Test.stopTest();




  }


   @isTest
  public static void enablementTerminal_test2 ( ){

    NE__Order_Header__c oh =  OB_TestDataFactory.getOrderHeader();
    insert oh;
    // NE__Order__c or =   new NE__order__C();//OB_TestDataFactory.getOrder(oh);
    // or.NE__Order_Header__c= oh.Id;
    // insert or;

    // NE__OrderItem__c oi = OB_TestDataFactory.getOrderItem(or.Id);
    // oi.OB_enablement__c = 'N';
    // oi.OB_Old_Enablement__c = 'Y';
    // insert oi;

    // NE__OrderItem__c oi1 = OB_TestDataFactory.getOrderItem(or.Id);
    // oi1.OB_enablement__c = 'Y';
    // oi1.OB_Old_Enablement__c = 'N';
    // insert oi1;


    // NE__Order_Header__c oh = OB_TestDataFactory.getOrderHeader();
    // oh.OB_Main_Process__c = 'Maintenance';
    // insert oh;
    NE__Order__c order = OB_TestDataFactory.getOrder(oh);
    insert Order;

    NE__Product__c prod =OB_TestDataFactory.getProduct( );
    prod.RecordTypeId = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.POS_RT ).getRecordTypeId( );
    NE__Product__c prod1 =OB_TestDataFactory.getProduct( );
    prod1.RecordTypeId = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.ACQUIRING_RT ).getRecordTypeId( );
    prod1.OB_Codice_sfdc__c ='JCB';
    insert prod;
    insert prod1;
    NE__OrderItem__c oi = OB_TestDataFactory.getOrderItem(order.Id);
    oi.NE__ProdId__c = prod.id;
    oi.OB_TermId__c ='1234234';
    insert oi;

    NE__OrderItem__c oi2 = OB_TestDataFactory.getOrderItem(order.Id);
    oi2.OB_enablement__c = 'N';
    oi2.OB_Old_Enablement__c = 'Y';
    oi2.NE__Parent_Order_Item__c = oi.Id;
    oi2.NE__ProdId__c = prod1.id;
    oi2.NE__Action__c = 'Remove';
    insert oi2;

    NE__OrderItem__c oi1 = OB_TestDataFactory.getOrderItem(order.Id);
    oi1.OB_enablement__c = 'Y';
    oi1.OB_Old_Enablement__c = 'N';
    oi1.NE__Parent_Order_Item__c = oi.Id;
    insert oi1;
   
    OB_TrackingUtility.ErrorList error = new OB_TrackingUtility.ErrorList();
    error.code = '';
    error.description = '';

    List<OB_TrackingUtility.ErrorList> errorsList = new List<OB_TrackingUtility.ErrorList>();
    errorsList.add(error);


    OB_TrackingUtility.CodiciConvenzioni codConv = new OB_TrackingUtility.CodiciConvenzioni();
    codConv.companyCode = 'companyCode';
    codConv.companyName = 'JCB';								
    codConv.code        = 'code';										
    codConv.causaleRifiuto ='causaleRifiuto';
    codConv.startDate = '2011-11-13';
    codConv.endDate = '2011-11-13';
    codConv.status	= 'Disabled';

    List<OB_TrackingUtility.CodiciConvenzioni> codConvList = new List<OB_TrackingUtility.CodiciConvenzioni>();
    codConvList.add(codConv);

    


    OB_TrackingUtility.TermsIdInformation termInfo = new OB_TrackingUtility.TermsIdInformation();    
    termInfo.terminalId = '1234234';
    termInfo.model = 'model';
    termInfo.connectionType = 'connectionType';
    termInfo.modality = 'modality';
    termInfo.modelDescription = 'modelDescription';
    termInfo.release = 'release';
    termInfo.releaseDescription = 'releaseDescription';
    termInfo.status = 'Installed';
    termInfo.reasonOfRejection = '';
    termInfo.installationDate = '2011-11-13';
    termInfo.uninstallationDate = '';
    termInfo.agreementCodes = codConvList; //List
    termInfo.errors = errorsList; //List

    List<OB_TrackingUtility.TermsIdInformation> termsInfoList = new List<OB_TrackingUtility.TermsIdInformation>();
    termsInfoList.add(termInfo);

    
   

    OB_TrackingUtility.puntoVendita pV = new OB_TrackingUtility.puntoVendita();
    //pV.itemId = '';
    pV.PVCode = '1234567';
    pV.startDate = '2011-11-13';
    pV.endDate = '';
    pV.reasonOfClosure = '';
    //pV.tipo = '';
    pV.ctiCode = 'ctiCode';
    pV.StabiCode = 'StabiCode';
    pV.siaPVCode = 'siaPVCode';
    pV.siaProgressiveCode = 'siaProgressiveCode';
    pV.siaMerchantCode = 'siaMerchantCode';
    pV.assistanceNumber = 'assistanceNumber';
    //pV.dataInizioAttivita = '2011-11-13';
    pv.terminalInformation = termsInfoList; //List
    pv.changes = null;

    List<OB_TrackingUtility.puntoVendita> pVList = new List<OB_TrackingUtility.puntoVendita>();
    pVList.add(pV);

    OB_TrackingUtility.GT gT = new OB_TrackingUtility.GT();
    gT.source = 'MONETICA';
    gT.gtCompanyCode = 'companyCode';
    gT.errors = null; //List
    gT.PVCodes = pVList; //List
    //gT.statoProvisioning = '';

    List<OB_TrackingUtility.GT> gTList = new List<OB_TrackingUtility.GT>();
    gTList.add(gT);



    
    // OB_TrackingUtility.TrackingOrderRequestMaintenance trackingOrderRequest = new OB_TrackingUtility.TrackingOrderRequestMaintenance();
    // trackingOrderRequest.orderId = testOrder.id;
    // //trackingOrderRequest.Acquiring = acquiringList;
    // trackingOrderRequest.GT = gTList;
   
    Test.startTest();
    
    List<NE__OrderItem__c> listOi = [SELECT OB_isNotIntegrated__c from NE__OrderItem__c where NE__OrderId__c = :order.id];
   
    OB_TrackingOrderMaintenance.enablementAgreedCode(order.id , codConvList, termInfo.terminalId , termInfo.errors);
     System.assertEquals(false, listOi.get(0).OB_isNotIntegrated__c);  
    
 
    //OB_TrackingOrderMaintenance.isAcquiringAcquiring(acquiringList);
    //OB_TrackingUtility.updateVasItems(oiList,changesList,'','','','',listLog);
    Test.stopTest();
  }


   @isTest
  public static void enablementTerminal_test3 ( ){

    NE__Order_Header__c oh =  OB_TestDataFactory.getOrderHeader();
    insert oh;
    // NE__Order__c or =   new NE__order__C();//OB_TestDataFactory.getOrder(oh);
    // or.NE__Order_Header__c= oh.Id;
    // insert or;

    // NE__OrderItem__c oi = OB_TestDataFactory.getOrderItem(or.Id);
    // oi.OB_enablement__c = 'N';
    // oi.OB_Old_Enablement__c = 'Y';
    // insert oi;

    // NE__OrderItem__c oi1 = OB_TestDataFactory.getOrderItem(or.Id);
    // oi1.OB_enablement__c = 'Y';
    // oi1.OB_Old_Enablement__c = 'N';
    // insert oi1;


    // NE__Order_Header__c oh = OB_TestDataFactory.getOrderHeader();
    // oh.OB_Main_Process__c = 'Maintenance';
    // insert oh;
    NE__Order__c order = OB_TestDataFactory.getOrder(oh);
    insert Order;

    NE__Product__c prod =OB_TestDataFactory.getProduct( );
    prod.RecordTypeId = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.POS_RT ).getRecordTypeId( );
    NE__Product__c prod1 =OB_TestDataFactory.getProduct( );
    prod1.RecordTypeId = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.ACQUIRING_RT ).getRecordTypeId( );
    prod1.OB_Codice_sfdc__c ='JCB';
    insert prod;
    insert prod1;

    NE__Product__c prod2 =OB_TestDataFactory.getProduct( );
    prod2.RecordTypeId = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.ACQUIRING_RT ).getRecordTypeId( );
    prod2.OB_Codice_sfdc__c ='UPI';
    insert prod2;
    NE__OrderItem__c oi = OB_TestDataFactory.getOrderItem(order.Id);
    oi.NE__ProdId__c = prod.id;
    oi.OB_TermId__c ='1234234';
    insert oi;

    NE__OrderItem__c oi2 = OB_TestDataFactory.getOrderItem(order.Id);
    oi2.OB_enablement__c = 'Y';
    oi2.OB_Old_Enablement__c = 'N';
    oi2.NE__Parent_Order_Item__c = oi.Id;
    oi2.NE__ProdId__c = prod1.id;
    oi2.NE__Action__c = 'Remove';
    insert oi2;

    NE__OrderItem__c oi1 = OB_TestDataFactory.getOrderItem(order.Id);
    oi1.OB_enablement__c = 'Y';
    oi1.OB_Old_Enablement__c = 'N';
    oi1.NE__Parent_Order_Item__c = oi.Id;
    oi1.NE__ProdId__c = prod2.id;
    oi1.NE__Action__c = 'Add';
    insert oi1;
   
    OB_TrackingUtility.ErrorList error = new OB_TrackingUtility.ErrorList();
    error.code = '';
    error.description = '';

    List<OB_TrackingUtility.ErrorList> errorsList = new List<OB_TrackingUtility.ErrorList>();
    errorsList.add(error);


    OB_TrackingUtility.CodiciConvenzioni codConv = new OB_TrackingUtility.CodiciConvenzioni();
    codConv.companyCode = 'companyCode';
    codConv.companyName = 'JCB';								
    codConv.code        = 'code';										
    codConv.causaleRifiuto ='causaleRifiuto';
    codConv.startDate = '2011-11-13';
    codConv.endDate = '2011-11-13';
    codConv.status	= 'Refused';

    OB_TrackingUtility.CodiciConvenzioni codConv1 = new OB_TrackingUtility.CodiciConvenzioni();
    codConv1.companyCode = 'companyCode';
    codConv1.companyName = 'UPI';								
    codConv1.code        = 'code';										
    codConv1.causaleRifiuto ='causaleRifiuto';
    codConv1.startDate = '2011-11-13';
    codConv1.endDate = '2011-11-13';
    codConv1.status	= 'Refused';

    List<OB_TrackingUtility.CodiciConvenzioni> codConvList = new List<OB_TrackingUtility.CodiciConvenzioni>();
    codConvList.add(codConv);
    codConvList.add(codConv1);

    


    OB_TrackingUtility.TermsIdInformation termInfo = new OB_TrackingUtility.TermsIdInformation();    
    termInfo.terminalId = '1234234';
    termInfo.model = 'model';
    termInfo.connectionType = 'connectionType';
    termInfo.modality = 'modality';
    termInfo.modelDescription = 'modelDescription';
    termInfo.release = 'release';
    termInfo.releaseDescription = 'releaseDescription';
    termInfo.status = 'Installed';
    termInfo.reasonOfRejection = '';
    termInfo.installationDate = '2011-11-13';
    termInfo.uninstallationDate = '';
    termInfo.agreementCodes = codConvList; //List
    termInfo.errors = errorsList; //List

    List<OB_TrackingUtility.TermsIdInformation> termsInfoList = new List<OB_TrackingUtility.TermsIdInformation>();
    termsInfoList.add(termInfo);

    
   

    OB_TrackingUtility.puntoVendita pV = new OB_TrackingUtility.puntoVendita();
    //pV.itemId = '';
    pV.PVCode = '1234567';
    pV.startDate = '2011-11-13';
    pV.endDate = '';
    pV.reasonOfClosure = '';
    //pV.tipo = '';
    pV.ctiCode = 'ctiCode';
    pV.StabiCode = 'StabiCode';
    pV.siaPVCode = 'siaPVCode';
    pV.siaProgressiveCode = 'siaProgressiveCode';
    pV.siaMerchantCode = 'siaMerchantCode';
    pV.assistanceNumber = 'assistanceNumber';
    //pV.dataInizioAttivita = '2011-11-13';
    pv.terminalInformation = termsInfoList; //List
    pv.changes = null;

    List<OB_TrackingUtility.puntoVendita> pVList = new List<OB_TrackingUtility.puntoVendita>();
    pVList.add(pV);

    OB_TrackingUtility.GT gT = new OB_TrackingUtility.GT();
    gT.source = 'MONETICA';
    gT.gtCompanyCode = 'companyCode';
    gT.errors = null; //List
    gT.PVCodes = pVList; //List
    //gT.statoProvisioning = '';

    List<OB_TrackingUtility.GT> gTList = new List<OB_TrackingUtility.GT>();
    gTList.add(gT);



    
    
   
    Test.startTest();    
    List<NE__OrderItem__c> listOi = [SELECT OB_isNotIntegrated__c from NE__OrderItem__c where NE__OrderId__c = :order.id];
   
    OB_TrackingOrderMaintenance.enablementAgreedCode(order.id , codConvList, termInfo.terminalId , termInfo.errors);
     System.assertEquals(false, listOi.get(0).OB_isNotIntegrated__c);  
 
   
    Test.stopTest();




  }


@isTest
  public static void enablementTerminal_test4 ( ){

    NE__Order_Header__c oh =  OB_TestDataFactory.getOrderHeader();
    insert oh;
    // NE__Order__c or =   new NE__order__C();//OB_TestDataFactory.getOrder(oh);
    // or.NE__Order_Header__c= oh.Id;
    // insert or;

    // NE__OrderItem__c oi = OB_TestDataFactory.getOrderItem(or.Id);
    // oi.OB_enablement__c = 'N';
    // oi.OB_Old_Enablement__c = 'Y';
    // insert oi;

    // NE__OrderItem__c oi1 = OB_TestDataFactory.getOrderItem(or.Id);
    // oi1.OB_enablement__c = 'Y';
    // oi1.OB_Old_Enablement__c = 'N';
    // insert oi1;


    // NE__Order_Header__c oh = OB_TestDataFactory.getOrderHeader();
    // oh.OB_Main_Process__c = 'Maintenance';
    // insert oh;
    NE__Order__c order = OB_TestDataFactory.getOrder(oh);
    insert Order;

    NE__Product__c prod =OB_TestDataFactory.getProduct( );
    prod.RecordTypeId = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.POS_RT ).getRecordTypeId( );
    NE__Product__c prod1 =OB_TestDataFactory.getProduct( );
    prod1.RecordTypeId = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.ACQUIRING_RT ).getRecordTypeId( );
    prod1.OB_Codice_sfdc__c ='JCB';
    insert prod;
    insert prod1;

    
    NE__OrderItem__c oi = OB_TestDataFactory.getOrderItem(order.Id);
    oi.NE__ProdId__c = prod.id;
    oi.OB_TermId__c ='1234234';
    insert oi;

    NE__OrderItem__c oi2 = OB_TestDataFactory.getOrderItem(order.Id);
    oi2.OB_enablement__c = 'N';
    oi2.OB_Old_Enablement__c = 'Y';
    oi2.NE__Parent_Order_Item__c = oi.Id;
    oi2.NE__ProdId__c = prod1.id;
    oi2.NE__Action__c = 'Remove';
    insert oi2;

   
   
    OB_TrackingUtility.ErrorList error = new OB_TrackingUtility.ErrorList();
    error.code = '';
    error.description = '';

    List<OB_TrackingUtility.ErrorList> errorsList = new List<OB_TrackingUtility.ErrorList>();
    errorsList.add(error);


    OB_TrackingUtility.CodiciConvenzioni codConv = new OB_TrackingUtility.CodiciConvenzioni();
    codConv.companyCode = 'companyCode';
    codConv.companyName = 'JCB';								
    codConv.code        = 'code';										
    codConv.causaleRifiuto ='causaleRifiuto';
    codConv.startDate = '2011-11-13';
    codConv.endDate = '2011-11-13';
    codConv.status	= 'Refused';

   

    List<OB_TrackingUtility.CodiciConvenzioni> codConvList = new List<OB_TrackingUtility.CodiciConvenzioni>();
    codConvList.add(codConv);
    

    


    OB_TrackingUtility.TermsIdInformation termInfo = new OB_TrackingUtility.TermsIdInformation();    
    termInfo.terminalId = '1234234';
    termInfo.model = 'model';
    termInfo.connectionType = 'connectionType';
    termInfo.modality = 'modality';
    termInfo.modelDescription = 'modelDescription';
    termInfo.release = 'release';
    termInfo.releaseDescription = 'releaseDescription';
    termInfo.status = 'Installed';
    termInfo.reasonOfRejection = '';
    termInfo.installationDate = '2011-11-13';
    termInfo.uninstallationDate = '';
    termInfo.agreementCodes = codConvList; //List
    termInfo.errors = errorsList; //List

    List<OB_TrackingUtility.TermsIdInformation> termsInfoList = new List<OB_TrackingUtility.TermsIdInformation>();
    termsInfoList.add(termInfo);

    
   

    OB_TrackingUtility.puntoVendita pV = new OB_TrackingUtility.puntoVendita();
    //pV.itemId = '';
    pV.PVCode = '1234567';
    pV.startDate = '2011-11-13';
    pV.endDate = '';
    pV.reasonOfClosure = '';
    //pV.tipo = '';
    pV.ctiCode = 'ctiCode';
    pV.StabiCode = 'StabiCode';
    pV.siaPVCode = 'siaPVCode';
    pV.siaProgressiveCode = 'siaProgressiveCode';
    pV.siaMerchantCode = 'siaMerchantCode';
    pV.assistanceNumber = 'assistanceNumber';
    //pV.dataInizioAttivita = '2011-11-13';
    pv.terminalInformation = termsInfoList; //List
    pv.changes = null;

    List<OB_TrackingUtility.puntoVendita> pVList = new List<OB_TrackingUtility.puntoVendita>();
    pVList.add(pV);

    OB_TrackingUtility.GT gT = new OB_TrackingUtility.GT();
    gT.source = 'MONETICA';
    gT.gtCompanyCode = 'companyCode';
    gT.errors = null; //List
    gT.PVCodes = pVList; //List
    //gT.statoProvisioning = '';

    List<OB_TrackingUtility.GT> gTList = new List<OB_TrackingUtility.GT>();
    gTList.add(gT);



    
    
   
    Test.startTest();  
    List<NE__OrderItem__c> listOi = [SELECT OB_isNotIntegrated__c from NE__OrderItem__c where NE__OrderId__c = :order.id];
   
    OB_TrackingOrderMaintenance.enablementAgreedCode(order.id , codConvList, termInfo.terminalId , termInfo.errors);
     System.assertEquals(false, listOi.get(0).OB_isNotIntegrated__c);  
   
    Test.stopTest();




  }



  
   @isTest
  public static void updateAssetDate_Test7 ( ){

      Id rtMerchant       = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId(); 
    Account myMastMerchant  = new Account(Name='TEST',
                                          RecordTypeId=rtMerchant,
                                          OB_Employees_Number__c='Minore di 10',
                                          OB_VAT_Not_Present__c=true, 
                                          OB_DescriptionVATNotPresent__c='description', 
                                          NE__Fiscal_code__c='RSSMRA80A01F205X',
                                          OB_BypassValidation__c=true,
                                          OB_Status__c='Active'); 

  
    insert myMastMerchant;
      Id accountBankRecordId   = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Bank').getRecordTypeId(); 
    account bankAccount   = new Account(Name='TEST',
                                        RecordTypeId=accountBankRecordId,
                                        OB_Employees_Number__c='Minore di 10',
                                        OB_VAT_Not_Present__c=true, 
                                        OB_DescriptionVATNotPresent__c='description', 
                                        NE__Fiscal_code__c='RSSMRA80A01F205X',
                                        OB_BypassValidation__c=true,
                                        OB_Status__c='Active');   
     insert  bankAccount;
    NE__Service_Point__c servicePoint = new NE__Service_Point__c();
    insert servicePoint;
    NE__Order_Header__c orderHeader = new NE__Order_Header__c(OB_ProposerABI__c=bankAccount.Id ,NE__AccountId__c=myMastMerchant.Id, OB_Main_Process__c = 'Maintenance', OB_Sub_Process__c = 'variazione operativa', OB_Business_Model_Acquiring__c = 'Bancario');
    insert orderHeader;
     NE__Order__c testOrder = OB_TestDataFactory.getOrder( );
     testOrder.OB_Service_Point__c = servicePoint.id;
     testOrder.NE__Order_Header__c = orderHeader.id;
    insert testOrder;
    id rtProductGTRoot          = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.TERMINALE).getRecordTypeId(); 
    NE__Product__c productGTRoot = new NE__Product__c(RecordTypeId = rtProductGTRoot, OB_Codice_sfdc__c = 'SMPOS_CASSA', Name = 'SmartPOS Cassa', OB_Contract_Type__c = 'Contratto POS;Modulo Off Commercial', OB_Business_Model_POS__c = 'Diretto;Trilaterale Nuovo');
    insert productGTRoot;
    list< NE__OrderItem__c > orderItemsList = new list<NE__OrderItem__c>( );

    id rtProductGTRoot1          = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get('Pagobancomat').getRecordTypeId(); 
    NE__Product__c productGTRoot1 = new NE__Product__c(RecordTypeId = rtProductGTRoot1);
    insert productGTRoot1;

    NE__OrderItem__c testOrderItem = OB_TestDataFactory.getOrderItem( testOrder.Id );
    testOrderItem.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem.OB_CustomerCode__c = 'TEST';
    testOrderItem.OB_ShopCode__c = 'TEST';
    testOrderItem.NE__ProdId__c  = productGTRoot.id;
    testOrderItem.OB_TermId__c = '4444333221';
    testOrderItem.NE__Action__c = 'Remove';
    testOrderItem.NE__Account__c = myMastMerchant.id;

  
    insert testOrderItem;

    NE__OrderItem__c testOrderItem3 = OB_TestDataFactory.getOrderItem(testOrder.Id);
    testOrderItem3.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem3.OB_CustomerCode__c = 'TEST';
    testOrderItem3.OB_ShopCode__c = 'TEST';
    testOrderItem3.NE__ProdId__c = productGTRoot1.id;
    testOrderItem3.NE__Action__c='Add'; 
    orderItemsList.add(testOrderItem3);

    NE__OrderItem__c testOrderItem2 = OB_TestDataFactory.getOrderItem(testOrder.Id);
    testOrderItem2.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem2.OB_CustomerCode__c = 'TEST';
    testOrderItem2.OB_ShopCode__c = 'TEST';
    testOrderItem2.NE__Parent_Order_Item__c = testOrderItem.Id;
    orderItemsList.add(testOrderItem2);

    insert orderItemsList;


    list< NE__OrderItem__c > orderItemsList1 = new list< NE__OrderItem__c >( );

    NE__OrderItem__c testOrderItem1 = OB_TestDataFactory.getOrderItem( testOrder.Id );
    testOrderItem1.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem1.OB_CustomerCode__c = 'TEST';
    testOrderItem1.OB_ShopCode__c = 'TEST';
    testOrderItem1.NE__Root_Order_Item__c = testOrderItem2.Id;
    orderItemsList1.add(testOrderItem1);
    NE__OrderItem__c testOrderItem4 = OB_TestDataFactory.getOrderItem( testOrder.Id );
    testOrderItem4.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem4.OB_CustomerCode__c = 'TEST';
    testOrderItem4.OB_ShopCode__c = 'TEST';
    testOrderItem4.NE__Root_Order_Item__c = testOrderItem2.Id;
    orderItemsList1.add( testOrderItem4 );
    insert orderItemsList1;
    list< NE__OrderItem__c > orderItemsList2 = new list< NE__OrderItem__c >( );
    NE__OrderItem__c testOrderItem5 = OB_TestDataFactory.getOrderItem( testOrder.Id );
    testOrderItem5.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem5.OB_CustomerCode__c = 'TEST';
    testOrderItem5.OB_ShopCode__c = 'TEST';
    testOrderItem5.NE__Root_Order_Item__c = testOrderItem3.Id;
    orderItemsList2.add( testOrderItem5 );
    NE__OrderItem__c testOrderItem6 = OB_TestDataFactory.getOrderItem( testOrder.Id );
    testOrderItem6.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
    testOrderItem6.OB_CustomerCode__c = 'TEST';
    testOrderItem6.OB_ShopCode__c = 'TEST';
    testOrderItem6.NE__Root_Order_Item__c = testOrderItem3.Id;
    orderItemsList2.add( testOrderItem6 );
    insert orderItemsList2;

    Map<Id, Asset> mapAsset = new Map<Id,Asset>();
    Asset asset1 = new Asset( OB_ShopCode__c = 'shopCode',  OB_GT__c = 'GT', OB_CustomerCode__c = 'customerCode', Name = 'SmartPOS', NE__Status__c = 'Active', NE__Action__c = 'None');
    insert asset1;
    mapAsset.put(asset1.id, asset1);
    Asset asset = new Asset(NE__AssetItemEnterpriseId__c = asset1.Id, OB_ShopCode__c = 'shopCode',  OB_GT__c = 'GT', OB_CustomerCode__c = 'customerCode', Name = 'SmartPOS', NE__Status__c = 'Active', NE__Action__c = 'None');
    insert asset;
   mapAsset.put(asset.id, asset);
   OB_TrackingUtility.CodiciConvenzioni codConv = new OB_TrackingUtility.CodiciConvenzioni();
    codConv.companyCode = 'companyCode';
    codConv.companyName = 'companyName';                                
    codConv.code        = 'code';                                       
    codConv.causaleRifiuto ='causaleRifiuto';
    codConv.startDate = '2011-11-13';
    codConv.endDate = '';
    codConv.status  = 'Activated';

    List<OB_TrackingUtility.CodiciConvenzioni> codConvList = new List<OB_TrackingUtility.CodiciConvenzioni>();
    codConvList.add(codConv);
    //Start Noemi Infantino
    OB_TrackingUtility.ErrorList error = new OB_TrackingUtility.ErrorList();
    error.code = '';
    error.description = '';
    List<OB_TrackingUtility.ErrorList> errorsList = new List<OB_TrackingUtility.ErrorList>();
    errorsList.add(error);
   
    //Finish Noemi Infantino

    OB_TrackingUtility.TermsIdInformation termInfo = new OB_TrackingUtility.TermsIdInformation();    
    termInfo.terminalId = testOrderItem.OB_TermId__c;
    termInfo.model = 'model';
    termInfo.connectionType = 'connectionType';
    termInfo.modality = 'modality';
    termInfo.modelDescription = 'modelDescription';
    termInfo.release = 'release';
    termInfo.releaseDescription = 'releaseDescription';
    termInfo.status = 'Refused';
    termInfo.reasonOfRejection = '';
    termInfo.installationDate = '';
    termInfo.uninstallationDate = '2011-11-13';
    termInfo.agreementCodes = codConvList; //List
    termInfo.errors = errorsList; //List                                                //Noemi Infantino

    List<OB_TrackingUtility.TermsIdInformation> termsInfoList = new List<OB_TrackingUtility.TermsIdInformation>();
    termsInfoList.add(termInfo);


    OB_TrackingUtility.puntoVendita pV = new OB_TrackingUtility.puntoVendita();
    //pV.itemId = '';
    pV.PVCode = '1234567';
    pV.startDate = '2011-11-13';
    pV.endDate = '';
    pV.reasonOfClosure = '';
    //pV.tipo = '';
    pV.ctiCode = 'ctiCode';
    pV.StabiCode = 'StabiCode';
    pV.siaPVCode = 'siaPVCode';
    pV.siaProgressiveCode = 'siaProgressiveCode';
    pV.siaMerchantCode = 'siaMerchantCode';
    pV.assistanceNumber = 'assistanceNumber';
    //pV.dataInizioAttivita = '2011-11-13';
    pv.terminalInformation = termsInfoList; //List
    pv.changes = null;

    List<OB_TrackingUtility.puntoVendita> pVList = new List<OB_TrackingUtility.puntoVendita>();
    pVList.add(pV);

    OB_TrackingUtility.GT gT = new OB_TrackingUtility.GT();
    gT.source = 'MONETICA';
    gT.gtCompanyCode = 'companyCode';
    gT.errors = null; //List
    gT.PVCodes = pVList; //List
    //gT.statoProvisioning = '';

    List<OB_TrackingUtility.GT> gTList = new List<OB_TrackingUtility.GT>();
    gTList.add(gT);



    
    // OB_TrackingUtility.TrackingOrderRequestMaintenance trackingOrderRequest = new OB_TrackingUtility.TrackingOrderRequestMaintenance();
    // trackingOrderRequest.orderId = testOrder.id;
    // //trackingOrderRequest.Acquiring = acquiringList;
    // trackingOrderRequest.GT = gTList;
    String orderid= testOrder.id;
    Test.startTest();
    List<NE__OrderItem__c> listOi = [SELECT OB_isNotIntegrated__c from NE__OrderItem__c where NE__OrderId__c = :orderid];
    System.assertEquals(false, listOi.get(0).OB_isNotIntegrated__c);
    OB_TrackingOrderMaintenance.updateAssetDate(termsInfoList, orderid, mapAsset);
    
 
    //OB_TrackingOrderMaintenance.isAcquiringAcquiring(acquiringList);
    //OB_TrackingUtility.updateVasItems(oiList,changesList,'','','','',listLog);
    Test.stopTest();

  }

    @isTest
  public static void OB_TrackingOrderMaintenance_Test6(){
    List<Account> accList = new List<Account>();
    List<NE__OrderItem__c> oiList = new List<NE__OrderItem__c>();
    Id rtMerchant       = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId(); 
    Account myMastMerchant  = new Account(Name='TEST',
                                          RecordTypeId=rtMerchant,
                                          OB_Employees_Number__c='Minore di 10',
                                          OB_VAT_Not_Present__c=true, 
                                          OB_DescriptionVATNotPresent__c='description', 
                                          NE__Fiscal_code__c='RSSMRA80A01F205X',
                                          OB_BypassValidation__c=true,
                                          OB_Status__c='Active'); 

    Id accountBankRecordId   = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Bank').getRecordTypeId(); 
    Account bankAccount   = new Account(Name='TEST',
                                        RecordTypeId=accountBankRecordId,
                                        OB_Employees_Number__c='Minore di 10',
                                        OB_VAT_Not_Present__c=true, 
                                        OB_DescriptionVATNotPresent__c='description', 
                                        NE__Fiscal_code__c='RSSMRA80A01F205X',
                                        OB_BypassValidation__c=true,
                                        OB_Status__c='Active');   
    accList.add(myMastMerchant);
    accList.add(bankAccount);
    insert accList;
    NE__Service_Point__c servicePoint = new NE__Service_Point__c();
    insert servicePoint;
    NE__Order_Header__c orderHeader = new NE__Order_Header__c(OB_ProposerABI__c=bankAccount.Id ,NE__AccountId__c=myMastMerchant.Id, OB_Main_Process__c = 'Maintenance', OB_Sub_Process__c = 'sostituzione terminali', OB_Business_Model_Acquiring__c = 'Bancario');
    insert orderHeader;
    NE__Order__c configuration = new NE__Order__c(NE__AccountId__c=myMastMerchant.Id, OB_Service_Point__c = servicePoint.Id,NE__Order_Header__c=orderHeader.Id, OB_MCC__c = '0001', OB_MCCL2__c = '5631', OB_GT__c = 'Nexi', OB_PBSettlementMethod__c = 'PB Settlement Method', OB_InternationalSettlementMethod__c = 'International Settlement Method', OB_ReceiptCity__c = 'MILANO', OB_ReceiptHeader__c='Sweet Years', OB_Report_Type__c = 'Punto Vendita', OB_ShopSign__c = 'Sweet Years');
    insert configuration;

    //OrderItem ACQUIRING
      Id rtProductAcqRoot           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.ACQUIRING).getRecordTypeId(); 
    NE__Product__c productAcqRoot = new NE__Product__c(OB_Acquirer__c='NEXI', RecordTypeId =rtProductAcqRoot, OB_Codice_sfdc__c = 'VISAMASTERCARD', Name = 'Visa/Mastercard', OB_Contract_Type__c = 'Contratto Acquiring');                                                                         //Noemi Infantino
    insert productAcqRoot;
    NE__OrderItem__c orderItemAcqRoot = new NE__OrderItem__c(NE__Qty__c=10 ,NE__OrderId__c=configuration.id, NE__Action__c = 'Add', NE__ProdId__c = productAcqRoot.id, NE__Service_Point__c = servicePoint.Id, NE__Account__c = myMastMerchant.Id , OB_FulfilmentStatus__c = 'Completed');
    orderItemAcqRoot.NE__AssetItemEnterpriseId__c = orderItemAcqRoot.id;
    insert orderItemAcqRoot;
    oiList.add(orderItemAcqRoot);
    //OrderItem GT
    Id rtProductGTRoot          = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.TERMINALE).getRecordTypeId(); 
    NE__Product__c productGTRoot = new NE__Product__c(RecordTypeId = rtProductGTRoot, OB_Codice_sfdc__c = 'SMPOS_CASSA', Name = 'SmartPOS Cassa', OB_Contract_Type__c = 'Contratto POS;Modulo Off Commercial', OB_Business_Model_POS__c = 'Diretto;Trilaterale Nuovo');
    insert productGTRoot;
    NE__OrderItem__c orderItemGTRoot = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__Action__c = 'Add', OB_GT__c = 'MONETICA', OB_TermId__c = '4444333221', NE__ProdId__c = productGTRoot.id, NE__Status__c = 'PENDING', OB_FulfilmentStatus__c = 'Completed');
    orderItemGTRoot.NE__AssetItemEnterpriseId__c = orderItemGTRoot.id;
    insert orderItemGTRoot;

    
    oiList.add(orderItemGTRoot);
    NE__Order_Item_Attribute__c attrGTRoot1 = new NE__Order_Item_Attribute__c();
    attrGTRoot1.Name = 'TermId';
    attrGTRoot1.NE__Order_Item__c = orderItemGTRoot.id;
    
    insert attrGTRoot1;
    NE__Order_Item_Attribute__c attrGTRoot2 = new NE__Order_Item_Attribute__c();
    attrGTRoot2.Name = 'modello';
    attrGTRoot2.NE__Order_Item__c = orderItemGTRoot.id;
    
    insert attrGTRoot2;
    NE__Order_Item_Attribute__c attrGTRoot3 = new NE__Order_Item_Attribute__c();
    attrGTRoot3.Name = 'release';
    attrGTRoot3.NE__Order_Item__c = orderItemGTRoot.id;
   
    insert attrGTRoot3;
    NE__Order_Item_Attribute__c attrGTRoot4 = new NE__Order_Item_Attribute__c();
    attrGTRoot4.Name = 'modalitaCollegamento';
    attrGTRoot4.NE__Order_Item__c = orderItemGTRoot.id;
   
    insert attrGTRoot4;
    NE__Order_Item_Attribute__c attrGTRoot5 = new NE__Order_Item_Attribute__c();
    attrGTRoot5.Name = 'descrizioneModello';
    attrGTRoot5.NE__Order_Item__c = orderItemGTRoot.id;
    
    insert attrGTRoot5;
    NE__Order_Item_Attribute__c attrGTRoot6 = new NE__Order_Item_Attribute__c();
    attrGTRoot6.Name = 'descrizioneRelease';
    attrGTRoot6.NE__Order_Item__c = orderItemGTRoot.id;
 
    insert attrGTRoot6;
    NE__Order_Item_Attribute__c attrGTRoot7 = new NE__Order_Item_Attribute__c();
    attrGTRoot7.Name = 'descrizioneConnessione';
    attrGTRoot7.NE__Order_Item__c = orderItemGTRoot.id;
  
    insert attrGTRoot7;
    NE__Order_Item_Attribute__c attrGTRoot8 = new NE__Order_Item_Attribute__c();
    attrGTRoot8.Name = 'Progressivo SIA';
    attrGTRoot8.NE__Order_Item__c = orderItemGTRoot.id;
    
    insert attrGTRoot8;
    NE__Order_Item_Attribute__c attrGTRoot9 = new NE__Order_Item_Attribute__c();
    attrGTRoot9.Name = 'Codice Stabilimento SIA';
    attrGTRoot9.NE__Order_Item__c = orderItemGTRoot.id;
   
    insert attrGTRoot9;
    NE__Order_Item_Attribute__c attrGTRoot10 = new NE__Order_Item_Attribute__c();
    attrGTRoot10.Name = 'Codice SIA';
    attrGTRoot10.NE__Order_Item__c = orderItemGTRoot.id;
    
    insert attrGTRoot10;
    Id rtProductGT           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.TERMINALE).getRecordTypeId(); 
    NE__Product__c productGT = new NE__Product__c(RecordTypeId = rtProductGT, OB_Codice_sfdc__c = 'INST', Name = 'Installazione pos', OB_Contract_Type__c = 'Installazione pos', OB_Contract_Description__c = 'Installazione pos');
    insert productGT;
    NE__OrderItem__c orderItemGT = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__Parent_Order_Item__c = orderItemGTRoot.id, NE__Action__c = 'Add', NE__ProdId__c = productGT.id , OB_FulfilmentStatus__c = 'Completed');
    orderItemGT.NE__AssetItemEnterpriseId__c= orderItemGT.id;
    insert orderItemGT;

    //Item Acquiring Child
    Id rtProductAcq           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.ACQUIRING).getRecordTypeId(); 
    NE__Product__c productAcq = new NE__Product__c(RecordTypeId = rtProductAcq, OB_Acquirer__c='NEXI', OB_Codice_sfdc__c = 'VISAMASTERCARD', Name = 'Visa/Mastercard', OB_Contract_Type__c = 'Contratto Acquiring', OB_Offer__c ='PERSONALIZZATA;START;XPAY_FULL');
    insert productAcq;
    NE__OrderItem__c orderItemAcq = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__ProdId__c = productAcq.id, NE__Action__c = 'Add', NE__Parent_Order_Item__c = orderItemGTRoot.id, OB_FulfilmentStatus__c = 'Completed'); 
    orderItemAcq.NE__AssetItemEnterpriseId__c =orderItemAcq.id;
    insert orderItemAcq;
    Id rtProductPric           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.PRICING).getRecordTypeId(); 
    NE__Product__c productPric = new NE__Product__c(RecordTypeId = rtProductPric, OB_Codice_sfdc__c = 'MAE_PRE', Name = 'MAESTRO CONSUMER PREPAID', OB_Contract_Type__c = 'Contratto Acquiring');
    insert productPric;
    NE__OrderItem__c orderItemPric = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__ProdId__c = productPric.id, NE__Action__c = 'Add', NE__Parent_Order_Item__c = orderItemAcq.id, OB_FulfilmentStatus__c = 'Completed'); 
    orderItemPric.NE__AssetItemEnterpriseId__c =orderItemPric.id;
    insert orderItemPric;

    //ADD ITEM TO CONFIGURATION
    Id rtProductPB    = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.PAGOBANCOMAT).getRecordTypeId(); 
        NE__Product__c productPB    = new NE__Product__c(OB_Acquirer__c=OB_EnrichOrder.NEXI, RecordTypeId =rtProductPB, OB_Codice_sfdc__c = 'PAGOBANCOMAT' );
        insert productPB;
    NE__OrderItem__c pagobancomat = New NE__OrderItem__c(NE__Qty__c=1 ,NE__OrderId__c=configuration.id, NE__Action__c = 'None', NE__ProdId__c = productPB.id, OB_FulfilmentStatus__c = 'Completed');            
        insert pagobancomat;

    Id rtProductVAS   = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.VAS).getRecordTypeId(); 
    NE__Product__c productRootVAS   = new NE__Product__c(RecordTypeId = rtProductVAS, OB_Codice_sfdc__c = 'PELLEGRINI',OB_Acquirer__c='NEXI');
        insert productRootVAS;
    NE__OrderItem__c rootVas = New NE__OrderItem__c(NE__Qty__c=1 ,NE__OrderId__c=configuration.id, NE__Action__c = 'None', OB_FulfilmentStatus__c = 'Completed');   
    rootVas.NE__AssetItemEnterpriseId__c        =rootVas.id;
        insert rootVas;
    oiList.add(rootVas);
    NE__Product__c productVAS   = new NE__Product__c(RecordTypeId = rtProductVAS, OB_Codice_sfdc__c = 'PELLEGRINI',OB_Acquirer__c='NEXI');
        insert productVAS;
    NE__OrderItem__c vas = New NE__OrderItem__c(NE__Qty__c=1 ,NE__OrderId__c=configuration.id, NE__Action__c = 'Add', OB_FulfilmentStatus__c = 'Completed');        
    vas.NE__AssetItemEnterpriseId__c    =vas.id;
        insert vas;
    oiList.add(vas);
    NE__Product__c product1    = new NE__Product__c(OB_Acquirer__c=OB_EnrichOrder.NEXI , RecordTypeId =rtProductPric );
        product1.OB_Codice_sfdc__c = 'ALB_AUTO';
        insert product1;

        NE__OrderItem__c orderItem1 = new NE__OrderItem__c();
        orderItem1.NE__Qty__c     = 1;
        orderItem1.NE__OrderId__c = configuration.id;
        orderItem1.NE__ProdId__c  = product1.id;
    orderItem1.NE__Action__c = 'Add';
    orderItem1.OB_FulfilmentStatus__c = 'Completed';
    orderItem1.NE__Parent_Order_Item__c = orderItemAcq.id;
    orderItem1.NE__Parent_Order_Item__c = orderItemAcq.id;
    orderItem1.NE__AssetItemEnterpriseId__c = orderItem1.id;
        insert orderItem1;

    //orderItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.ACQUIRING && orderItem.NE__ProdId__r.OB_Acquirer__c!=OB_EnrichOrder.NEXI
    NE__Product__c productNotNexi    = new NE__Product__c(OB_Acquirer__c='AMEX' , RecordTypeId =rtProductAcqRoot, OB_Codice_sfdc__c = 'AMEX' );
        insert productNotNexi;

    NE__OrderItem__c orderItemNotNexi = new NE__OrderItem__c();
    orderItemNotNexi.NE__Qty__c     = 1;
        orderItemNotNexi.NE__OrderId__c = configuration.id;
        orderItemNotNexi.NE__ProdId__c  = productNotNexi.id;
    orderItemNotNexi.NE__Action__c = 'None';
    orderItemNotNexi.OB_FulfilmentStatus__c = 'Completed';
    orderItemNotNexi.NE__Parent_Order_Item__c = null;
    orderItemNotNexi.OB_FulfilmentStatus__c = 'Completed';
    orderItemNotNexi.NE__AssetItemEnterpriseId__c= orderItemNotNexi.id;
        insert orderItemNotNexi;

    NE__Product__c productNotNexiPricing   = new NE__Product__c(OB_Acquirer__c='AMEX' , RecordTypeId =rtProductPric, OB_Codice_sfdc__c = 'PRICING' );
        insert productNotNexiPricing;
    NE__OrderItem__c orderItemNotNexiPric = new NE__OrderItem__c();
    orderItemNotNexiPric.NE__Qty__c     = 1;
        orderItemNotNexiPric.NE__OrderId__c = configuration.id;
        orderItemNotNexiPric.NE__ProdId__c  = productNotNexiPricing.id;
    orderItemNotNexiPric.NE__Action__c = 'None';
    orderItemNotNexiPric.OB_FulfilmentStatus__c = 'Completed';
    orderItemNotNexiPric.NE__Parent_Order_Item__c = orderItemNotNexi.id;
    orderItemNotNexiPric.NE__AssetItemEnterpriseId__c= orderItemNotNexiPric.id;
        insert orderItemNotNexiPric;
    
    
    //ASSET
    Asset asset = new Asset(NE__AssetItemEnterpriseId__c = orderItemGTRoot.Id, OB_ShopCode__c = 'shopCode', OB_GT__c = 'GT', OB_CustomerCode__c = 'customerCode', Name = 'SmartPOS');
    insert asset;
    NE__AssetItemAttribute__c attr1 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.TERMID, NE__Asset__c = asset.id);
    insert attr1;
    NE__AssetItemAttribute__c attr2 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.MODELLO, NE__Asset__c = asset.id);
    insert attr2;
    NE__AssetItemAttribute__c attr3 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.RELEASE, NE__Asset__c = asset.id);
    insert attr3;
    NE__AssetItemAttribute__c attr4 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.MODCOLLEGAMENTO, NE__Asset__c = asset.id);
    insert attr4;
    NE__AssetItemAttribute__c attr5 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.DMODELLO, NE__Asset__c = asset.id);
    insert attr5;
    NE__AssetItemAttribute__c attr6 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.DRELEASE, NE__Asset__c = asset.id);
    insert attr6;
    NE__AssetItemAttribute__c attr7 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.DCONNESSIONE, NE__Asset__c = asset.id);
    insert attr7;
    NE__AssetItemAttribute__c attr8 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.PROGRESSIVOSIA, NE__Asset__c = asset.id);
    insert attr8;
    NE__AssetItemAttribute__c attr9 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.CODICESTABILIMENTOSIA, NE__Asset__c = asset.id);
    insert attr9;
    NE__AssetItemAttribute__c attr10 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.CODICESIA, NE__Asset__c = asset.id);
    insert attr10;

    //LOV
    NE__Lov__c lovMCC2 = new NE__Lov__c();
    lovMCC2.NE__Type__c   = 'mcc';
    lovMCC2.NE__Value3__c = 'L2';
    lovMCC2.OB_Value4__c  = configuration.OB_MCCL2__c;
    lovMCC2.NE__Value2__c = configuration.OB_MCCL2__c;
    insert lovMCC2;
    System.debug('@@@lovMCC2 '+lovMCC2);
    NE__Lov__c lov = new NE__Lov__c();
    lov.NE__Type__c     ='TRACKING';
    lov.NE__Sub_Type__c = 'TIPOLOGICHE';
    lov.NE__Value2__c   = 'DINERS';
    lov.NE__Value1__c   = '12';
    insert lov;

    OB_TrackingUtility.ErrorList error1 = new OB_TrackingUtility.ErrorList();

     List<OB_TrackingUtility.ErrorList> errorsList1 = new List<OB_TrackingUtility.ErrorList>();
      OB_TrackingUtility.ErrorList error2 = new OB_TrackingUtility.ErrorList();
    error2.code = '';
    error2.description = '';

    
   

    List<OB_TrackingUtility.ErrorList> errorsList2 = new List<OB_TrackingUtility.ErrorList>();
    errorsList2.add(error2);
    

    OB_TrackingUtility.Changes change = new OB_TrackingUtility.Changes();
    change.externalId = rootVas.id; //TERMINALE
    change.result = 'OK';
    change.errors = null; //List

   
  
    List<OB_TrackingUtility.Changes> changesList = new List<OB_TrackingUtility.Changes>();
    changesList.add(change);

    
    
    OB_TrackingUtility.CodiciConvenzioni codConv = new OB_TrackingUtility.CodiciConvenzioni();
    codConv.companyCode = 'companyCode';
    codConv.companyName = 'companyName';                                
    codConv.code        = 'code';                                       
    codConv.causaleRifiuto ='causaleRifiuto';
    codConv.startDate = '2011-11-13';
    codConv.endDate = '';
    codConv.status  = 'Active';

    List<OB_TrackingUtility.CodiciConvenzioni> codConvList = new List<OB_TrackingUtility.CodiciConvenzioni>();
    codConvList.add(codConv);

    OB_TrackingUtility.TermsIdInformation termInfo = new OB_TrackingUtility.TermsIdInformation();    
    termInfo.terminalId = orderItemGTRoot.OB_TermId__c;
    termInfo.model = 'model';
    termInfo.connectionType = 'connectionType';
    termInfo.modality = 'modality';
    termInfo.modelDescription = 'modelDescription';
    termInfo.release = 'release';
    termInfo.releaseDescription = 'releaseDescription';
    termInfo.status = 'Pending';
    termInfo.reasonOfRejection = '';
    termInfo.installationDate = '2011-11-13';
    termInfo.uninstallationDate = '';
    termInfo.agreementCodes = codConvList; //List
    termInfo.errors = null; //List

    List<OB_TrackingUtility.TermsIdInformation> termsInfoList = new List<OB_TrackingUtility.TermsIdInformation>();
    termsInfoList.add(termInfo);

    OB_TrackingUtility.ErrorList error = new OB_TrackingUtility.ErrorList();
    error.code = '';
    error.description = '';

    
   

    List<OB_TrackingUtility.ErrorList> errorsList = new List<OB_TrackingUtility.ErrorList>();
    errorsList.add(error);
   

    OB_TrackingUtility.puntoVendita pV = new OB_TrackingUtility.puntoVendita();
    //pV.itemId = '';
    pV.PVCode = servicePoint.id;
    pV.startDate = '2011-11-13';
    pV.endDate = '';
    pV.reasonOfClosure = '';
    //pV.tipo = '';
    pV.ctiCode = 'ctiCode';
    //NEXI Kinga Fornal, kinga.fornal@accenture.com,  08.08.20119 test fix START
    pV.StabiCode = 'StabiCode';
    pV.siaPVCode = 'pVCode';
    pV.siaProgressiveCode = 'progCode';
    pV.siaMerchantCode = 'merchCode';
    pV.assistanceNumber = 'assistanceNumber';
    //pV.dataInizioAttivita = '2011-11-13';
    pv.terminalInformation = termsInfoList; //List
    pv.changes = changesList;

    List<OB_TrackingUtility.puntoVendita> pVList = new List<OB_TrackingUtility.puntoVendita>();
    pVList.add(pV);

    OB_TrackingUtility.GT gT = new OB_TrackingUtility.GT();
    gT.source = 'MONETICA';
    gT.gtCompanyCode = 'companyCode';
    gT.errors = errorsList; //List
    gT.PVCodes = pVList; //List
    //gT.statoProvisioning = '';

    List<OB_TrackingUtility.GT> gTList = new List<OB_TrackingUtility.GT>();
    gTList.add(gT);

    OB_TrackingUtility.Acquiring acquiring = new OB_TrackingUtility.Acquiring();
    acquiring.source = 'NEXI';
    acquiring.companyCode = 'companyCode';
    acquiring.errori = null;
    acquiring.PVCodes = pVList;

    List<OB_TrackingUtility.Acquiring> acquiringList = new List<OB_TrackingUtility.Acquiring>();
    acquiringList.add(acquiring);

    OB_TrackingUtility.TrackingOrderRequestMaintenance trackingOrderRequest = new OB_TrackingUtility.TrackingOrderRequestMaintenance();
    trackingOrderRequest.orderId = configuration.id;
    trackingOrderRequest.Acquiring = acquiringList;
    trackingOrderRequest.GT = gTList;

    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();
    req.requestURI = '/TrackingOrderMaintenance/*'; 
    req.httpMethod = 'POST';
    RestContext.request = req;
    String json = JSON.serialize(trackingOrderRequest);
    RestContext.request.requestBody =  Blob.valueof(json);
    RestContext.response = res;

    List<OB_LogRequest__c> listLog = new List<OB_LogRequest__c>();
    OB_LogRequest__c log = OB_TestDataFactory.getLogRequest();
    insert log;
    OB_LogRequest__c log1 = OB_TestDataFactory.getLogRequest();
    insert log1;
    listLog.add(log);
     listLog.add(log1);
    Test.startTest();
    OB_TrackingUtility.TrackingOrderResponseMaintenance response = OB_TrackingOrderMaintenance.trackOrderMaintenance();
    // OB_TrackingOrderMaintenance.isAcquiringVas(acquiringList);
    // OB_TrackingOrderMaintenance.isAcquiringTerminal(acquiringList, true);
    // OB_TrackingOrderMaintenance.isAcquiringTerminal(acquiringList, false);
    // OB_TrackingOrderMaintenance.updateLogRequest(configuration.id);
    //OB_TrackingUtility.updateVasItems(oiList,changesList,'','','','',listLog);
    System.assertEquals( 500, response.httpStatus);
    Test.stopTest();
    }



    @isTest
  public static void OB_TrackingOrderMaintenance_Test7(){
    List<Account> accList = new List<Account>();
    List<NE__OrderItem__c> oiList = new List<NE__OrderItem__c>();
    Id rtMerchant       = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId(); 
    Account myMastMerchant  = new Account(Name='TEST',
                                          RecordTypeId=rtMerchant,
                                          OB_Employees_Number__c='Minore di 10',
                                          OB_VAT_Not_Present__c=true, 
                                          OB_DescriptionVATNotPresent__c='description', 
                                          NE__Fiscal_code__c='RSSMRA80A01F205X',
                                          OB_BypassValidation__c=true,
                                          OB_Status__c='Active'); 

    Id accountBankRecordId   = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Bank').getRecordTypeId(); 
    Account bankAccount   = new Account(Name='TEST',
                                        RecordTypeId=accountBankRecordId,
                                        OB_Employees_Number__c='Minore di 10',
                                        OB_VAT_Not_Present__c=true, 
                                        OB_DescriptionVATNotPresent__c='description', 
                                        NE__Fiscal_code__c='RSSMRA80A01F205X',
                                        OB_BypassValidation__c=true,
                                        OB_Status__c='Active');   
    accList.add(myMastMerchant);
    accList.add(bankAccount);
    insert accList;
    NE__Service_Point__c servicePoint = new NE__Service_Point__c();
    insert servicePoint;
    NE__Order_Header__c orderHeader = new NE__Order_Header__c(OB_ProposerABI__c=bankAccount.Id ,NE__AccountId__c=myMastMerchant.Id, OB_Main_Process__c = 'Maintenance', OB_Sub_Process__c = 'variazione economica', OB_Business_Model_Acquiring__c = 'Bancario');
    insert orderHeader;
    NE__Order__c configuration = new NE__Order__c(NE__AccountId__c=myMastMerchant.Id, OB_Service_Point__c = servicePoint.Id,NE__Order_Header__c=orderHeader.Id, OB_MCC__c = '0001', OB_MCCL2__c = '5631', OB_GT__c = 'Nexi', OB_PBSettlementMethod__c = 'PB Settlement Method', OB_InternationalSettlementMethod__c = 'International Settlement Method', OB_ReceiptCity__c = 'MILANO', OB_ReceiptHeader__c='Sweet Years', OB_Report_Type__c = 'Punto Vendita', OB_ShopSign__c = 'Sweet Years');
    insert configuration;

    //OrderItem ACQUIRING
      Id rtProductAcqRoot           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.ACQUIRING).getRecordTypeId(); 
    NE__Product__c productAcqRoot = new NE__Product__c(OB_Acquirer__c='', RecordTypeId =rtProductAcqRoot, OB_Codice_sfdc__c = 'VISAMASTERCARD', Name = 'Visa/Mastercard', OB_Contract_Type__c = 'Contratto Acquiring');
    insert productAcqRoot;
    NE__OrderItem__c orderItemAcqRoot = new NE__OrderItem__c(NE__Qty__c=10 ,NE__OrderId__c=configuration.id, NE__Action__c = 'Add', NE__ProdId__c = productAcqRoot.id, NE__Service_Point__c = servicePoint.Id, NE__Account__c = myMastMerchant.Id , OB_FulfilmentStatus__c = 'Completed');
    orderItemAcqRoot.NE__AssetItemEnterpriseId__c = orderItemAcqRoot.id;
    insert orderItemAcqRoot;
    oiList.add(orderItemAcqRoot);
    //OrderItem GT
    Id rtProductGTRoot          = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.TERMINALE).getRecordTypeId(); 
    NE__Product__c productGTRoot = new NE__Product__c(RecordTypeId = rtProductGTRoot, OB_Codice_sfdc__c = 'SMPOS_CASSA', Name = 'SmartPOS Cassa', OB_Contract_Type__c = 'Contratto POS;Modulo Off Commercial', OB_Business_Model_POS__c = 'Diretto;Trilaterale Nuovo');
    insert productGTRoot;
    NE__OrderItem__c orderItemGTRoot = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__Action__c = 'Add', OB_GT__c = 'MONETICA', OB_TermId__c = '4444333221', NE__ProdId__c = productGTRoot.id, NE__Status__c = 'PENDING', OB_FulfilmentStatus__c = 'Completed');
    orderItemGTRoot.NE__AssetItemEnterpriseId__c = orderItemGTRoot.id;
    insert orderItemGTRoot;

    
    oiList.add(orderItemGTRoot);
    NE__Order_Item_Attribute__c attrGTRoot1 = new NE__Order_Item_Attribute__c();
    attrGTRoot1.Name = 'TermId';
    attrGTRoot1.NE__Order_Item__c = orderItemGTRoot.id;
    
    insert attrGTRoot1;
    NE__Order_Item_Attribute__c attrGTRoot2 = new NE__Order_Item_Attribute__c();
    attrGTRoot2.Name = 'modello';
    attrGTRoot2.NE__Order_Item__c = orderItemGTRoot.id;
    
    insert attrGTRoot2;
    NE__Order_Item_Attribute__c attrGTRoot3 = new NE__Order_Item_Attribute__c();
    attrGTRoot3.Name = 'release';
    attrGTRoot3.NE__Order_Item__c = orderItemGTRoot.id;
   
    insert attrGTRoot3;
    NE__Order_Item_Attribute__c attrGTRoot4 = new NE__Order_Item_Attribute__c();
    attrGTRoot4.Name = 'modalitaCollegamento';
    attrGTRoot4.NE__Order_Item__c = orderItemGTRoot.id;
   
    insert attrGTRoot4;
    NE__Order_Item_Attribute__c attrGTRoot5 = new NE__Order_Item_Attribute__c();
    attrGTRoot5.Name = 'descrizioneModello';
    attrGTRoot5.NE__Order_Item__c = orderItemGTRoot.id;
    
    insert attrGTRoot5;
    NE__Order_Item_Attribute__c attrGTRoot6 = new NE__Order_Item_Attribute__c();
    attrGTRoot6.Name = 'descrizioneRelease';
    attrGTRoot6.NE__Order_Item__c = orderItemGTRoot.id;
 
    insert attrGTRoot6;
    NE__Order_Item_Attribute__c attrGTRoot7 = new NE__Order_Item_Attribute__c();
    attrGTRoot7.Name = 'descrizioneConnessione';
    attrGTRoot7.NE__Order_Item__c = orderItemGTRoot.id;
  
    insert attrGTRoot7;
    NE__Order_Item_Attribute__c attrGTRoot8 = new NE__Order_Item_Attribute__c();
    attrGTRoot8.Name = 'Progressivo SIA';
    attrGTRoot8.NE__Order_Item__c = orderItemGTRoot.id;
    
    insert attrGTRoot8;
    NE__Order_Item_Attribute__c attrGTRoot9 = new NE__Order_Item_Attribute__c();
    attrGTRoot9.Name = 'Codice Stabilimento SIA';
    attrGTRoot9.NE__Order_Item__c = orderItemGTRoot.id;
   
    insert attrGTRoot9;
    NE__Order_Item_Attribute__c attrGTRoot10 = new NE__Order_Item_Attribute__c();
    attrGTRoot10.Name = 'Codice SIA';
    attrGTRoot10.NE__Order_Item__c = orderItemGTRoot.id;
    
    insert attrGTRoot10;
    Id rtProductGT           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.TERMINALE).getRecordTypeId(); 
    NE__Product__c productGT = new NE__Product__c(RecordTypeId = rtProductGT, OB_Codice_sfdc__c = 'INST', Name = 'Installazione pos', OB_Contract_Type__c = 'Installazione pos', OB_Contract_Description__c = 'Installazione pos');
    insert productGT;
    NE__OrderItem__c orderItemGT = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__Parent_Order_Item__c = orderItemGTRoot.id, NE__Action__c = 'Add', NE__ProdId__c = productGT.id , OB_FulfilmentStatus__c = 'Completed');
    orderItemGT.NE__AssetItemEnterpriseId__c= orderItemGT.id;
    insert orderItemGT;

    //Item Acquiring Child
    Id rtProductAcq           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.ACQUIRING).getRecordTypeId(); 
    NE__Product__c productAcq = new NE__Product__c(RecordTypeId = rtProductAcq, OB_Acquirer__c='NEXI', OB_Codice_sfdc__c = 'VISAMASTERCARD', Name = 'Visa/Mastercard', OB_Contract_Type__c = 'Contratto Acquiring', OB_Offer__c ='PERSONALIZZATA;START;XPAY_FULL');
    insert productAcq;
    NE__OrderItem__c orderItemAcq = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__ProdId__c = productAcq.id, NE__Action__c = 'Add', NE__Parent_Order_Item__c = orderItemGTRoot.id, OB_FulfilmentStatus__c = 'Completed'); 
    orderItemAcq.NE__AssetItemEnterpriseId__c =orderItemAcq.id;
    insert orderItemAcq;
    Id rtProductPric           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.PRICING).getRecordTypeId(); 
    NE__Product__c productPric = new NE__Product__c(RecordTypeId = rtProductPric, OB_Codice_sfdc__c = 'MAE_PRE', Name = 'MAESTRO CONSUMER PREPAID', OB_Contract_Type__c = 'Contratto Acquiring');
    insert productPric;
    NE__OrderItem__c orderItemPric = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__ProdId__c = productPric.id, NE__Action__c = 'Add', NE__Parent_Order_Item__c = orderItemAcq.id, OB_FulfilmentStatus__c = 'Completed'); 
    orderItemPric.NE__AssetItemEnterpriseId__c =orderItemPric.id;
    insert orderItemPric;

    //ADD ITEM TO CONFIGURATION
    Id rtProductPB    = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.PAGOBANCOMAT).getRecordTypeId(); 
        NE__Product__c productPB    = new NE__Product__c(OB_Acquirer__c=OB_EnrichOrder.NEXI, RecordTypeId =rtProductPB, OB_Codice_sfdc__c = 'PAGOBANCOMAT' );
        insert productPB;
    NE__OrderItem__c pagobancomat = New NE__OrderItem__c(NE__Qty__c=1 ,NE__OrderId__c=configuration.id, NE__Action__c = 'None', NE__ProdId__c = productPB.id, OB_FulfilmentStatus__c = 'Completed');            
        insert pagobancomat;

    Id rtProductVAS   = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.VAS).getRecordTypeId(); 
    NE__Product__c productRootVAS   = new NE__Product__c(RecordTypeId = rtProductVAS, OB_Codice_sfdc__c = 'PELLEGRINI',OB_Acquirer__c='NEXI');
        insert productRootVAS;
    NE__OrderItem__c rootVas = New NE__OrderItem__c(NE__Qty__c=1 ,NE__OrderId__c=configuration.id, NE__Action__c = 'None', OB_FulfilmentStatus__c = 'Completed');   
    rootVas.NE__AssetItemEnterpriseId__c        =rootVas.id;
        insert rootVas;
    oiList.add(rootVas);
    NE__Product__c productVAS   = new NE__Product__c(RecordTypeId = rtProductVAS, OB_Codice_sfdc__c = 'PELLEGRINI',OB_Acquirer__c='NEXI');
        insert productVAS;
    NE__OrderItem__c vas = New NE__OrderItem__c(NE__Qty__c=1 ,NE__OrderId__c=configuration.id, NE__Action__c = 'Add', OB_FulfilmentStatus__c = 'Completed');        
    vas.NE__AssetItemEnterpriseId__c    =vas.id;
        insert vas;
    oiList.add(vas);
    NE__Product__c product1    = new NE__Product__c(OB_Acquirer__c=OB_EnrichOrder.NEXI , RecordTypeId =rtProductPric );
        product1.OB_Codice_sfdc__c = 'ALB_AUTO';
        insert product1;

        NE__OrderItem__c orderItem1 = new NE__OrderItem__c();
        orderItem1.NE__Qty__c     = 1;
        orderItem1.NE__OrderId__c = configuration.id;
        orderItem1.NE__ProdId__c  = product1.id;
    orderItem1.NE__Action__c = 'Add';
    orderItem1.OB_FulfilmentStatus__c = 'Completed';
    orderItem1.NE__Parent_Order_Item__c = orderItemAcq.id;
    orderItem1.NE__Parent_Order_Item__c = orderItemAcq.id;
    orderItem1.NE__AssetItemEnterpriseId__c = orderItem1.id;
        insert orderItem1;

    //orderItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.ACQUIRING && orderItem.NE__ProdId__r.OB_Acquirer__c!=OB_EnrichOrder.NEXI
    NE__Product__c productNotNexi    = new NE__Product__c(OB_Acquirer__c='AMEX' , RecordTypeId =rtProductAcqRoot, OB_Codice_sfdc__c = 'AMEX' );
        insert productNotNexi;

    NE__OrderItem__c orderItemNotNexi = new NE__OrderItem__c();
    orderItemNotNexi.NE__Qty__c     = 1;
        orderItemNotNexi.NE__OrderId__c = configuration.id;
        orderItemNotNexi.NE__ProdId__c  = productNotNexi.id;
    orderItemNotNexi.NE__Action__c = 'None';
    orderItemNotNexi.OB_FulfilmentStatus__c = 'Completed';
    orderItemNotNexi.NE__Parent_Order_Item__c = null;
    orderItemNotNexi.OB_FulfilmentStatus__c = 'Completed';
    orderItemNotNexi.NE__AssetItemEnterpriseId__c= orderItemNotNexi.id;
        insert orderItemNotNexi;

    NE__Product__c productNotNexiPricing   = new NE__Product__c(OB_Acquirer__c='AMEX' , RecordTypeId =rtProductPric, OB_Codice_sfdc__c = 'PRICING' );
        insert productNotNexiPricing;
    NE__OrderItem__c orderItemNotNexiPric = new NE__OrderItem__c();
    orderItemNotNexiPric.NE__Qty__c     = 1;
        orderItemNotNexiPric.NE__OrderId__c = configuration.id;
        orderItemNotNexiPric.NE__ProdId__c  = productNotNexiPricing.id;
    orderItemNotNexiPric.NE__Action__c = 'None';
    orderItemNotNexiPric.OB_FulfilmentStatus__c = 'Completed';
    orderItemNotNexiPric.NE__Parent_Order_Item__c = orderItemNotNexi.id;
    orderItemNotNexiPric.NE__AssetItemEnterpriseId__c= orderItemNotNexiPric.id;
        insert orderItemNotNexiPric;
    
    
    //ASSET
    Asset asset = new Asset(NE__AssetItemEnterpriseId__c = orderItemGTRoot.Id, OB_ShopCode__c = 'shopCode', OB_GT__c = 'GT', OB_CustomerCode__c = 'customerCode', Name = 'SmartPOS');
    insert asset;
    NE__AssetItemAttribute__c attr1 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.TERMID, NE__Asset__c = asset.id);
    insert attr1;
    NE__AssetItemAttribute__c attr2 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.MODELLO, NE__Asset__c = asset.id);
    insert attr2;
    NE__AssetItemAttribute__c attr3 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.RELEASE, NE__Asset__c = asset.id);
    insert attr3;
    NE__AssetItemAttribute__c attr4 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.MODCOLLEGAMENTO, NE__Asset__c = asset.id);
    insert attr4;
    NE__AssetItemAttribute__c attr5 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.DMODELLO, NE__Asset__c = asset.id);
    insert attr5;
    NE__AssetItemAttribute__c attr6 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.DRELEASE, NE__Asset__c = asset.id);
    insert attr6;
    NE__AssetItemAttribute__c attr7 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.DCONNESSIONE, NE__Asset__c = asset.id);
    insert attr7;
    NE__AssetItemAttribute__c attr8 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.PROGRESSIVOSIA, NE__Asset__c = asset.id);
    insert attr8;
    NE__AssetItemAttribute__c attr9 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.CODICESTABILIMENTOSIA, NE__Asset__c = asset.id);
    insert attr9;
    NE__AssetItemAttribute__c attr10 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.CODICESIA, NE__Asset__c = asset.id);
    insert attr10;

    //LOV
    NE__Lov__c lovMCC2 = new NE__Lov__c();
    lovMCC2.NE__Type__c   = 'mcc';
    lovMCC2.NE__Value3__c = 'L2';
    lovMCC2.OB_Value4__c  = configuration.OB_MCCL2__c;
    lovMCC2.NE__Value2__c = configuration.OB_MCCL2__c;
    insert lovMCC2;
    System.debug('@@@lovMCC2 '+lovMCC2);
    NE__Lov__c lov = new NE__Lov__c();
    lov.NE__Type__c     ='TRACKING';
    lov.NE__Sub_Type__c = 'TIPOLOGICHE';
    lov.NE__Value2__c   = 'DINERS';
    lov.NE__Value1__c   = '12';
    insert lov;

    OB_TrackingUtility.ErrorList error1 = new OB_TrackingUtility.ErrorList();

     List<OB_TrackingUtility.ErrorList> errorsList1 = new List<OB_TrackingUtility.ErrorList>();
      OB_TrackingUtility.ErrorList error2 = new OB_TrackingUtility.ErrorList();
    error2.code = '';
    error2.description = '';

    
   

    List<OB_TrackingUtility.ErrorList> errorsList2 = new List<OB_TrackingUtility.ErrorList>();
    errorsList2.add(error2);
    

    OB_TrackingUtility.Changes change = new OB_TrackingUtility.Changes();
    change.externalId = rootVas.id; //TERMINALE
    change.result = 'KO';
    change.errors = errorsList2; //List

   
  
    List<OB_TrackingUtility.Changes> changesList = new List<OB_TrackingUtility.Changes>();
    changesList.add(change);

    
    
    OB_TrackingUtility.CodiciConvenzioni codConv = new OB_TrackingUtility.CodiciConvenzioni();
    codConv.companyCode = 'companyCode';
    codConv.companyName = 'companyName';                                
    codConv.code        = 'code';                                       
    codConv.causaleRifiuto ='causaleRifiuto';
    codConv.startDate = '2011-11-13';
    codConv.endDate = '';
    codConv.status  = 'Active';

    List<OB_TrackingUtility.CodiciConvenzioni> codConvList = new List<OB_TrackingUtility.CodiciConvenzioni>();
    codConvList.add(codConv);

    OB_TrackingUtility.TermsIdInformation termInfo = new OB_TrackingUtility.TermsIdInformation();    
    termInfo.terminalId = orderItemGTRoot.OB_TermId__c;
    termInfo.model = 'model';
    termInfo.connectionType = 'connectionType';
    termInfo.modality = 'modality';
    termInfo.modelDescription = 'modelDescription';
    termInfo.release = 'release';
    termInfo.releaseDescription = 'releaseDescription';
    termInfo.status = 'Pending';
    termInfo.reasonOfRejection = '';
    termInfo.installationDate = '2011-11-13';
    termInfo.uninstallationDate = '';
    termInfo.agreementCodes = codConvList; //List
    termInfo.errors = null; //List

    List<OB_TrackingUtility.TermsIdInformation> termsInfoList = new List<OB_TrackingUtility.TermsIdInformation>();
    termsInfoList.add(termInfo);

    OB_TrackingUtility.ErrorList error = new OB_TrackingUtility.ErrorList();
    error.code = '';
    error.description = '';

    
   

    List<OB_TrackingUtility.ErrorList> errorsList = new List<OB_TrackingUtility.ErrorList>();
    errorsList.add(error);
   

    OB_TrackingUtility.puntoVendita pV = new OB_TrackingUtility.puntoVendita();
    //pV.itemId = '';
    pV.PVCode = servicePoint.id;
    pV.startDate = '2011-11-13';
    pV.endDate = '';
    pV.reasonOfClosure = '';
    //pV.tipo = '';
    pV.ctiCode = 'ctiCode';
    //NEXI Kinga Fornal, kinga.fornal@accenture.com,  08.08.20119 test fix START
    pV.StabiCode = 'StabiCode';
    pV.siaPVCode = 'pVCode';
    pV.siaProgressiveCode = 'progCode';
    pV.siaMerchantCode = 'merchCode';
    pV.assistanceNumber = 'assistanceNumber';
    //pV.dataInizioAttivita = '2011-11-13';
    pv.terminalInformation = termsInfoList; //List
    pv.changes = changesList;

    List<OB_TrackingUtility.puntoVendita> pVList = new List<OB_TrackingUtility.puntoVendita>();
    pVList.add(pV);

    OB_TrackingUtility.GT gT = new OB_TrackingUtility.GT();
    gT.source = 'MONETICA';
    gT.gtCompanyCode = 'companyCode';
    gT.errors = errorsList; //List
    gT.PVCodes = pVList; //List
    //gT.statoProvisioning = '';

    List<OB_TrackingUtility.GT> gTList = new List<OB_TrackingUtility.GT>();
    gTList.add(gT);

    OB_TrackingUtility.Acquiring acquiring = new OB_TrackingUtility.Acquiring();
    acquiring.source = 'NEXI';
    acquiring.companyCode = 'companyCode';
    acquiring.errori = null;
    acquiring.PVCodes = pVList;

    List<OB_TrackingUtility.Acquiring> acquiringList = new List<OB_TrackingUtility.Acquiring>();
    acquiringList.add(acquiring);

    OB_TrackingUtility.TrackingOrderRequestMaintenance trackingOrderRequest = new OB_TrackingUtility.TrackingOrderRequestMaintenance();
    trackingOrderRequest.orderId = configuration.id;
    trackingOrderRequest.Acquiring = acquiringList;
    trackingOrderRequest.GT = gTList;

    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();
    req.requestURI = '/TrackingOrderMaintenance/*'; 
    req.httpMethod = 'POST';
    RestContext.request = req;
    String json = JSON.serialize(trackingOrderRequest);
    RestContext.request.requestBody =  Blob.valueof(json);
    RestContext.response = res;

    List<OB_LogRequest__c> listLog = new List<OB_LogRequest__c>();
    OB_LogRequest__c log = OB_TestDataFactory.getLogRequest();
    insert log;
    OB_LogRequest__c log1 = OB_TestDataFactory.getLogRequest();
    insert log1;
    listLog.add(log);
     listLog.add(log1);
    Test.startTest();
    OB_TrackingUtility.TrackingOrderResponseMaintenance response = OB_TrackingOrderMaintenance.trackOrderMaintenance();
    // OB_TrackingOrderMaintenance.isAcquiringVas(acquiringList);
    // OB_TrackingOrderMaintenance.isAcquiringTerminal(acquiringList, true);
    // OB_TrackingOrderMaintenance.isAcquiringTerminal(acquiringList, false);
    // OB_TrackingOrderMaintenance.updateLogRequest(configuration.id);
    //OB_TrackingUtility.updateVasItems(oiList,changesList,'','','','',listLog);
    System.assertEquals( 400, response.httpStatus);
    Test.stopTest();
    }

    //Start Noemi Infantino


 @isTest
    public static void OB_TrackingOrderMaintenance_Test_NI(){
        List<Account> accList = new List<Account>();
        List<NE__OrderItem__c> oiList = new List<NE__OrderItem__c>();
        Id rtMerchant       = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId(); 
        Account myMastMerchant  = new Account(Name='TEST',
                                            RecordTypeId=rtMerchant,
                                            OB_Employees_Number__c='Minore di 10',
                                            OB_VAT_Not_Present__c=true, 
                                            OB_DescriptionVATNotPresent__c='description', 
                                            NE__Fiscal_code__c='RSSMRA80A01F205X',
                                            OB_BypassValidation__c=true,
                                            OB_Status__c='Active'); 

        Id accountBankRecordId   = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Bank').getRecordTypeId(); 
        Account bankAccount   = new Account(Name='TEST',
                                            RecordTypeId=accountBankRecordId,
                                            OB_Employees_Number__c='Minore di 10',
                                            OB_VAT_Not_Present__c=true, 
                                            OB_DescriptionVATNotPresent__c='description', 
                                            NE__Fiscal_code__c='RSSMRA80A01F205X',
                                            OB_BypassValidation__c=true,
                                            OB_Status__c='Active');   
        accList.add(myMastMerchant);
        accList.add(bankAccount);
        insert accList;
        NE__Service_Point__c servicePoint = new NE__Service_Point__c();
        insert servicePoint;
        NE__Order_Header__c orderHeader = new NE__Order_Header__c(OB_ProposerABI__c=bankAccount.Id ,NE__AccountId__c=myMastMerchant.Id, OB_Main_Process__c = 'Maintenance', OB_Sub_Process__c = 'variazione operativa', OB_Business_Model_Acquiring__c = 'Bancario');
        insert orderHeader;
        NE__Order__c configuration = new NE__Order__c(NE__AccountId__c=myMastMerchant.Id, OB_Service_Point__c = servicePoint.Id,NE__Order_Header__c=orderHeader.Id, OB_MCC__c = '0001', OB_MCCL2__c = '5631', OB_GT__c = 'Nexi', OB_PBSettlementMethod__c = 'PB Settlement Method', OB_InternationalSettlementMethod__c = 'International Settlement Method', OB_ReceiptCity__c = 'MILANO', OB_ReceiptHeader__c='Sweet Years', OB_Report_Type__c = 'Punto Vendita', OB_ShopSign__c = 'Sweet Years');
        insert configuration;

        //OrderItem ACQUIRING
        Id rtProductAcqRoot           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.ACQUIRING).getRecordTypeId(); 
        NE__Product__c productAcqRoot = new NE__Product__c(OB_Acquirer__c='', RecordTypeId =rtProductAcqRoot, OB_Codice_sfdc__c = 'VISAMASTERCARD', Name = 'Visa/Mastercard', OB_Contract_Type__c = 'Contratto Acquiring');
        insert productAcqRoot;
        NE__OrderItem__c orderItemAcqRoot = new NE__OrderItem__c(NE__Qty__c=10 ,NE__OrderId__c=configuration.id, NE__Action__c = 'Add', NE__ProdId__c = productAcqRoot.id, NE__Service_Point__c = servicePoint.Id, NE__Account__c = myMastMerchant.Id , NE__Status__c = 'Active', OB_FulfilmentStatus__c = 'Completed', NE__Parent_Order_Item__c = null);
        NE__OrderItem__c orderItemAcqRoot2 = new NE__OrderItem__c(NE__Qty__c=10 ,NE__OrderId__c=configuration.id, NE__Action__c = 'None', NE__ProdId__c = productAcqRoot.id, NE__Service_Point__c = servicePoint.Id, NE__Account__c = myMastMerchant.Id , NE__Status__c = 'Active', OB_FulfilmentStatus__c = 'Completed', NE__Parent_Order_Item__c = null);
        NE__OrderItem__c orderItemAcqRoot2_Child = new NE__OrderItem__c(NE__Qty__c=10 ,NE__OrderId__c=configuration.id, NE__Action__c = 'None', NE__ProdId__c = productAcqRoot.id, NE__Service_Point__c = servicePoint.Id, NE__Account__c = myMastMerchant.Id , NE__Status__c = 'Active', OB_FulfilmentStatus__c = 'Completed', NE__Parent_Order_Item__c =orderItemAcqRoot2.Id );
        
        insert orderItemAcqRoot;
        insert orderItemAcqRoot2;
        insert orderItemAcqRoot2_Child;
        orderItemAcqRoot.NE__AssetItemEnterpriseId__c = orderItemAcqRoot.id;
        update orderItemAcqRoot;
        oiList.add(orderItemAcqRoot);
        //OrderItem GT
        Id rtProductGTRoot          = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.TERMINALE).getRecordTypeId(); 
        NE__Product__c productGTRoot = new NE__Product__c(RecordTypeId = rtProductGTRoot, OB_Codice_sfdc__c = 'SMPOS_CASSA', Name = 'SmartPOS Cassa', OB_Contract_Type__c = 'Contratto POS;Modulo Off Commercial', OB_Business_Model_POS__c = 'Diretto;Trilaterale Nuovo');
        insert productGTRoot;
        NE__OrderItem__c orderItemGTRoot = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__Action__c = 'Add', OB_GT__c = 'MONETICA', OB_TermId__c = '4444333221', NE__ProdId__c = productGTRoot.id, NE__Status__c = 'PENDING', OB_FulfilmentStatus__c = 'Completed');
        orderItemGTRoot.NE__AssetItemEnterpriseId__c = orderItemGTRoot.id;
        insert orderItemGTRoot;

        
        oiList.add(orderItemGTRoot);
        NE__Order_Item_Attribute__c attrGTRoot1 = new NE__Order_Item_Attribute__c();
        attrGTRoot1.Name = 'TermId';
        attrGTRoot1.NE__Order_Item__c = orderItemGTRoot.id;
        
        insert attrGTRoot1;
        NE__Order_Item_Attribute__c attrGTRoot2 = new NE__Order_Item_Attribute__c();
        attrGTRoot2.Name = 'modello';
        attrGTRoot2.NE__Order_Item__c = orderItemGTRoot.id;
        
        insert attrGTRoot2;
        NE__Order_Item_Attribute__c attrGTRoot3 = new NE__Order_Item_Attribute__c();
        attrGTRoot3.Name = 'release';
        attrGTRoot3.NE__Order_Item__c = orderItemGTRoot.id;
    
        insert attrGTRoot3;
        NE__Order_Item_Attribute__c attrGTRoot4 = new NE__Order_Item_Attribute__c();
        attrGTRoot4.Name = 'modalitaCollegamento';
        attrGTRoot4.NE__Order_Item__c = orderItemGTRoot.id;
    
        insert attrGTRoot4;
        NE__Order_Item_Attribute__c attrGTRoot5 = new NE__Order_Item_Attribute__c();
        attrGTRoot5.Name = 'descrizioneModello';
        attrGTRoot5.NE__Order_Item__c = orderItemGTRoot.id;
        
        insert attrGTRoot5;
        NE__Order_Item_Attribute__c attrGTRoot6 = new NE__Order_Item_Attribute__c();
        attrGTRoot6.Name = 'descrizioneRelease';
        attrGTRoot6.NE__Order_Item__c = orderItemGTRoot.id;
    
        insert attrGTRoot6;
        NE__Order_Item_Attribute__c attrGTRoot7 = new NE__Order_Item_Attribute__c();
        attrGTRoot7.Name = 'descrizioneConnessione';
        attrGTRoot7.NE__Order_Item__c = orderItemGTRoot.id;
    
        insert attrGTRoot7;
        NE__Order_Item_Attribute__c attrGTRoot8 = new NE__Order_Item_Attribute__c();
        attrGTRoot8.Name = 'Progressivo SIA';
        attrGTRoot8.NE__Order_Item__c = orderItemGTRoot.id;
        
        insert attrGTRoot8;
        NE__Order_Item_Attribute__c attrGTRoot9 = new NE__Order_Item_Attribute__c();
        attrGTRoot9.Name = 'Codice Stabilimento SIA';
        attrGTRoot9.NE__Order_Item__c = orderItemGTRoot.id;
    
        insert attrGTRoot9;
        NE__Order_Item_Attribute__c attrGTRoot10 = new NE__Order_Item_Attribute__c();
        attrGTRoot10.Name = 'Codice SIA';
        attrGTRoot10.NE__Order_Item__c = orderItemGTRoot.id;
        
        insert attrGTRoot10;
        Id rtProductGT           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.TERMINALE).getRecordTypeId(); 
        NE__Product__c productGT = new NE__Product__c(RecordTypeId = rtProductGT, OB_Codice_sfdc__c = 'INST', Name = 'Installazione pos', OB_Contract_Type__c = 'Installazione pos', OB_Contract_Description__c = 'Installazione pos');
        insert productGT;
        NE__OrderItem__c orderItemGTroot2 = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__Action__c = 'None', NE__ProdId__c = productGT.id , OB_FulfilmentStatus__c = 'Completed', NE__Status__c='Active');

        NE__OrderItem__c orderItemGT = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__Parent_Order_Item__c = orderItemGTRoot.id, NE__Action__c = 'Add', NE__ProdId__c = productGT.id , OB_FulfilmentStatus__c = 'Completed');
        NE__OrderItem__c orderItemGT2 = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__Parent_Order_Item__c = orderItemGTroot2.id, NE__Action__c = 'None', NE__ProdId__c = productGT.id , OB_FulfilmentStatus__c = 'Completed', NE__Status__c='Active');
        orderItemGT.NE__AssetItemEnterpriseId__c= orderItemGT.id;
        insert orderItemGT;
        insert orderItemGT2;
        insert orderItemGTroot2;

        //Item Acquiring Child
        Id rtProductAcq           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.ACQUIRING).getRecordTypeId(); 
        NE__Product__c productAcq = new NE__Product__c(RecordTypeId = rtProductAcq, OB_Acquirer__c='NEXI', OB_Codice_sfdc__c = 'VISAMASTERCARD', Name = 'Visa/Mastercard', OB_Contract_Type__c = 'Contratto Acquiring', OB_Offer__c ='PERSONALIZZATA;START;XPAY_FULL');
        insert productAcq;
        NE__OrderItem__c orderItemAcq = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__ProdId__c = productAcq.id, NE__Action__c = 'Add', NE__Parent_Order_Item__c = orderItemGTRoot.id, OB_FulfilmentStatus__c = 'Completed'); 
        orderItemAcq.NE__AssetItemEnterpriseId__c =orderItemAcq.id;
        insert orderItemAcq;
        Id rtProductPric           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.PRICING).getRecordTypeId(); 
        NE__Product__c productPric = new NE__Product__c(RecordTypeId = rtProductPric, OB_Codice_sfdc__c = 'MAE_PRE', Name = 'MAESTRO CONSUMER PREPAID', OB_Contract_Type__c = 'Contratto Acquiring');
        insert productPric;
        NE__OrderItem__c orderItemPric = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__ProdId__c = productPric.id, NE__Action__c = 'Add', NE__Parent_Order_Item__c = orderItemAcq.id, OB_FulfilmentStatus__c = 'Completed'); 
        orderItemPric.NE__AssetItemEnterpriseId__c =orderItemPric.id;
        insert orderItemPric;

        //ADD ITEM TO CONFIGURATION
        Id rtProductPB    = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.PAGOBANCOMAT).getRecordTypeId(); 
            NE__Product__c productPB    = new NE__Product__c(OB_Acquirer__c=OB_EnrichOrder.NEXI, RecordTypeId =rtProductPB, OB_Codice_sfdc__c = 'PAGOBANCOMAT' );
            insert productPB;
        NE__OrderItem__c pagobancomat = New NE__OrderItem__c(NE__Qty__c=1 ,NE__OrderId__c=configuration.id, NE__Action__c = 'None', NE__ProdId__c = productPB.id, OB_FulfilmentStatus__c = 'Completed');    
        pagobancomat.NE__AssetItemEnterpriseId__c =pagobancomat.id;     
            insert pagobancomat;

        Id rtProductVAS   = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.VAS).getRecordTypeId(); 
        NE__Product__c productRootVAS   = new NE__Product__c(RecordTypeId = rtProductVAS, OB_Codice_sfdc__c = 'PELLEGRINI',OB_Acquirer__c='NEXI');
            insert productRootVAS;
        NE__OrderItem__c rootVas = New NE__OrderItem__c(NE__Qty__c=1 ,NE__OrderId__c=configuration.id, NE__Action__c = 'None', OB_FulfilmentStatus__c = 'Completed');   
        rootVas.NE__AssetItemEnterpriseId__c        =rootVas.id;
            insert rootVas;
        oiList.add(rootVas);
        NE__Product__c productVAS   = new NE__Product__c(RecordTypeId = rtProductVAS, OB_Codice_sfdc__c = 'PELLEGRINI',OB_Acquirer__c='NEXI');
            insert productVAS;
        NE__OrderItem__c vas = New NE__OrderItem__c(NE__Qty__c=1 ,NE__OrderId__c=configuration.id, NE__Action__c = 'Add', OB_FulfilmentStatus__c = 'Completed');        
        vas.NE__AssetItemEnterpriseId__c    =vas.id;
            insert vas;
        oiList.add(vas);
        NE__Product__c product1    = new NE__Product__c(OB_Acquirer__c=OB_EnrichOrder.NEXI , RecordTypeId =rtProductPric );
            product1.OB_Codice_sfdc__c = 'ALB_AUTO';
            insert product1;

            NE__OrderItem__c orderItem1 = new NE__OrderItem__c();
            orderItem1.NE__Qty__c     = 1;
            orderItem1.NE__OrderId__c = configuration.id;
            orderItem1.NE__ProdId__c  = product1.id;
        orderItem1.NE__Action__c = 'Add';
        orderItem1.OB_FulfilmentStatus__c = 'Completed';
        orderItem1.NE__Parent_Order_Item__c = orderItemAcq.id;
        orderItem1.NE__Parent_Order_Item__c = orderItemAcq.id;
        orderItem1.NE__AssetItemEnterpriseId__c = orderItem1.id;
            insert orderItem1;

        //orderItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.ACQUIRING && orderItem.NE__ProdId__r.OB_Acquirer__c!=OB_EnrichOrder.NEXI
        NE__Product__c productNotNexi    = new NE__Product__c(OB_Acquirer__c='AMEX' , RecordTypeId =rtProductAcqRoot, OB_Codice_sfdc__c = 'AMEX' );
            insert productNotNexi;

        NE__OrderItem__c orderItemNotNexi = new NE__OrderItem__c();
        orderItemNotNexi.NE__Qty__c     = 1;
            orderItemNotNexi.NE__OrderId__c = configuration.id;
            orderItemNotNexi.NE__ProdId__c  = productNotNexi.id;
        orderItemNotNexi.NE__Action__c = 'None';
        orderItemNotNexi.OB_FulfilmentStatus__c = 'Completed';
        orderItemNotNexi.NE__Parent_Order_Item__c = null;
        orderItemNotNexi.OB_FulfilmentStatus__c = 'Completed';
        orderItemNotNexi.NE__AssetItemEnterpriseId__c= orderItemNotNexi.id;
            insert orderItemNotNexi;


        NE__Product__c productNotNexiPricing   = new NE__Product__c(OB_Acquirer__c='AMEX' , RecordTypeId =rtProductPric, OB_Codice_sfdc__c = 'PRICING' );
            insert productNotNexiPricing;
        NE__OrderItem__c orderItemNotNexiPric = new NE__OrderItem__c();
        orderItemNotNexiPric.NE__Qty__c     = 1;
            orderItemNotNexiPric.NE__OrderId__c = configuration.id;
            orderItemNotNexiPric.NE__ProdId__c  = productNotNexiPricing.id;
        orderItemNotNexiPric.NE__Action__c = 'None';
        orderItemNotNexiPric.OB_FulfilmentStatus__c = 'Completed';
        orderItemNotNexiPric.NE__Parent_Order_Item__c = orderItemNotNexi.id;
        orderItemNotNexiPric.NE__AssetItemEnterpriseId__c= orderItemNotNexiPric.id;
            insert orderItemNotNexiPric;
            //insert oiList;
        
        
        
        //ASSET
        Asset asset = new Asset(NE__AssetItemEnterpriseId__c = orderItemGTRoot.Id, OB_ShopCode__c = 'shopCode', OB_GT__c = 'GT', OB_CustomerCode__c = 'customerCode', Name = 'SmartPOS');
        insert asset;
        NE__AssetItemAttribute__c attr1 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.TERMID, NE__Asset__c = asset.id);
        insert attr1;
        NE__AssetItemAttribute__c attr2 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.MODELLO, NE__Asset__c = asset.id);
        insert attr2;
        NE__AssetItemAttribute__c attr3 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.RELEASE, NE__Asset__c = asset.id);
        insert attr3;
        NE__AssetItemAttribute__c attr4 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.MODCOLLEGAMENTO, NE__Asset__c = asset.id);
        insert attr4;
        NE__AssetItemAttribute__c attr5 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.DMODELLO, NE__Asset__c = asset.id);
        insert attr5;
        NE__AssetItemAttribute__c attr6 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.DRELEASE, NE__Asset__c = asset.id);
        insert attr6;
        NE__AssetItemAttribute__c attr7 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.DCONNESSIONE, NE__Asset__c = asset.id);
        insert attr7;
        NE__AssetItemAttribute__c attr8 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.PROGRESSIVOSIA, NE__Asset__c = asset.id);
        insert attr8;
        NE__AssetItemAttribute__c attr9 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.CODICESTABILIMENTOSIA, NE__Asset__c = asset.id);
        insert attr9;
        NE__AssetItemAttribute__c attr10 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.CODICESIA, NE__Asset__c = asset.id);
        insert attr10;

        //LOV
        NE__Lov__c lovMCC2 = new NE__Lov__c();
        lovMCC2.NE__Type__c   = 'mcc';
        lovMCC2.NE__Value3__c = 'L2';
        lovMCC2.OB_Value4__c  = configuration.OB_MCCL2__c;
        lovMCC2.NE__Value2__c = configuration.OB_MCCL2__c;
        insert lovMCC2;
        System.debug('@@@lovMCC2 '+lovMCC2);
        NE__Lov__c lov = new NE__Lov__c();
        lov.NE__Type__c     ='TRACKING';
        lov.NE__Sub_Type__c = 'TIPOLOGICHE';
        lov.NE__Value2__c   = 'DINERS';
        lov.NE__Value1__c   = '12';
        insert lov;

        OB_TrackingUtility.ErrorList error1 = new OB_TrackingUtility.ErrorList();

        List<OB_TrackingUtility.ErrorList> errorsList1 = new List<OB_TrackingUtility.ErrorList>();
        

        OB_TrackingUtility.Changes change = new OB_TrackingUtility.Changes();
        change.externalId = rootVas.id; //TERMINALE
        change.result = 'OK';
        change.errors = errorsList1; //List

    
    
        List<OB_TrackingUtility.Changes> changesList = new List<OB_TrackingUtility.Changes>();
        changesList.add(change);

        
        
        OB_TrackingUtility.CodiciConvenzioni codConv = new OB_TrackingUtility.CodiciConvenzioni();
        codConv.companyCode = 'companyCode';
        codConv.companyName = 'companyName';                                
        codConv.code        = 'code';                                       
        codConv.causaleRifiuto ='causaleRifiuto';
        codConv.startDate = '2011-11-13';
        codConv.endDate = '';
        codConv.status  = 'Active';

        List<OB_TrackingUtility.CodiciConvenzioni> codConvList = new List<OB_TrackingUtility.CodiciConvenzioni>();
        codConvList.add(codConv);

        OB_TrackingUtility.TermsIdInformation termInfo = new OB_TrackingUtility.TermsIdInformation();    
        termInfo.terminalId = orderItemGTRoot.OB_TermId__c;
        termInfo.model = 'model';
        termInfo.connectionType = 'connectionType';
        termInfo.modality = 'modality';
        termInfo.modelDescription = 'modelDescription';
        termInfo.release = 'release';
        termInfo.releaseDescription = 'releaseDescription';
        termInfo.status = 'Pending';
        termInfo.reasonOfRejection = '';
        termInfo.installationDate = '2011-11-13';
        termInfo.uninstallationDate = '';
        termInfo.agreementCodes = codConvList; //List
        termInfo.errors = null; //List

        List<OB_TrackingUtility.TermsIdInformation> termsInfoList = new List<OB_TrackingUtility.TermsIdInformation>();
        termsInfoList.add(termInfo);

        OB_TrackingUtility.ErrorList error = new OB_TrackingUtility.ErrorList();
        error.code = '';
        error.description = '';

        
    

        List<OB_TrackingUtility.ErrorList> errorsList = new List<OB_TrackingUtility.ErrorList>();
        errorsList.add(error);
    

        OB_TrackingUtility.puntoVendita pV = new OB_TrackingUtility.puntoVendita();
        //pV.itemId = '';
        pV.PVCode = servicePoint.id;
        pV.startDate = '2011-11-13';
        pV.endDate = '';
        pV.reasonOfClosure = '';
        //pV.tipo = '';
        pV.ctiCode = 'ctiCode';
        pV.StabiCode = 'StabiCode';
        pV.siaPVCode = 'siaPVCode';
        pV.siaProgressiveCode = 'siaProgressiveCode';
        pV.siaMerchantCode = 'siaMerchantCode';
        pV.assistanceNumber = 'assistanceNumber';
        //pV.dataInizioAttivita = '2011-11-13';
        pv.terminalInformation = termsInfoList; //List
        pv.changes = changesList;

        List<OB_TrackingUtility.puntoVendita> pVList = new List<OB_TrackingUtility.puntoVendita>();
        pVList.add(pV);

        OB_TrackingUtility.GT gT = new OB_TrackingUtility.GT();
        gT.source = 'MONETICA';
        gT.gtCompanyCode = 'companyCode';
        gT.errors = null; //List
        gT.PVCodes = pVList; //List
        //gT.statoProvisioning = '';

        List<OB_TrackingUtility.GT> gTList = new List<OB_TrackingUtility.GT>();
        gTList.add(gT);

        

        OB_TrackingUtility.Acquiring acquiring = new OB_TrackingUtility.Acquiring();
        acquiring.source = 'NEXI';
        acquiring.companyCode = 'companyCode';
        acquiring.errori = null;
        acquiring.PVCodes = pVList;

        List<OB_TrackingUtility.Acquiring> acquiringList = new List<OB_TrackingUtility.Acquiring>();
        acquiringList.add(acquiring);

        OB_TrackingUtility.TrackingOrderRequestMaintenance trackingOrderRequest = new OB_TrackingUtility.TrackingOrderRequestMaintenance();
        trackingOrderRequest.orderId = configuration.id;
        trackingOrderRequest.Acquiring = acquiringList;
        trackingOrderRequest.GT = gTList;

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/TrackingOrderMaintenance/*'; 
        req.httpMethod = 'POST';
        RestContext.request = req;
        String json = JSON.serialize(trackingOrderRequest);
        RestContext.request.requestBody =  Blob.valueof(json);
        RestContext.response = res;


        List<OB_LogRequest__c> listLog = new List<OB_LogRequest__c>();
        OB_LogRequest__c log = OB_TestDataFactory.getLogRequest();
        listLog.add(log);
        Test.startTest();
        OB_TrackingUtility.TrackingOrderResponseMaintenance response = OB_TrackingOrderMaintenance.trackOrderMaintenance();
        OB_TrackingOrderMaintenance.isAcquiringVas(acquiringList);
        OB_TrackingOrderMaintenance.isAcquiringTerminal(acquiringList, true);
        OB_TrackingOrderMaintenance.isAcquiringTerminal(acquiringList, false);
        OB_TrackingOrderMaintenance.updateLogRequest(configuration.id);
        OB_TrackingOrderMaintenance.updateVasItems(oiList,changesList,'','','','',listLog);
        System.assertEquals( 500, response.httpStatus);
        Test.stopTest();
    }







    @isTest
    public static void OB_TrackingOrderMaintenance_Test_NI2(){
        List<Account> accList = new List<Account>();
        List<NE__OrderItem__c> oiList = new List<NE__OrderItem__c>();
        Id rtMerchant       = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId(); 
        Account myMastMerchant  = new Account(Name='TEST',
                                            RecordTypeId=rtMerchant,
                                            OB_Employees_Number__c='Minore di 10',
                                            OB_VAT_Not_Present__c=true, 
                                            OB_DescriptionVATNotPresent__c='description', 
                                            NE__Fiscal_code__c='RSSMRA80A01F205X',
                                            OB_BypassValidation__c=true,
                                            OB_Status__c='Active'); 

        Id accountBankRecordId   = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Bank').getRecordTypeId(); 
        Account bankAccount   = new Account(Name='TEST',
                                            RecordTypeId=accountBankRecordId,
                                            OB_Employees_Number__c='Minore di 10',
                                            OB_VAT_Not_Present__c=true, 
                                            OB_DescriptionVATNotPresent__c='description', 
                                            NE__Fiscal_code__c='RSSMRA80A01F205X',
                                            OB_BypassValidation__c=true,
                                            OB_Status__c='Active');   
        accList.add(myMastMerchant);
        accList.add(bankAccount);
        insert accList;
        NE__Service_Point__c servicePoint = new NE__Service_Point__c();
        insert servicePoint;
        NE__Order_Header__c orderHeader = new NE__Order_Header__c(OB_ProposerABI__c=bankAccount.Id ,NE__AccountId__c=myMastMerchant.Id, OB_Main_Process__c = 'Maintenance', OB_Sub_Process__c = 'variazione operativa', OB_Business_Model_Acquiring__c = 'Bancario');
        insert orderHeader;
        NE__Order__c configuration = new NE__Order__c(NE__AccountId__c=myMastMerchant.Id, OB_Service_Point__c = servicePoint.Id,NE__Order_Header__c=orderHeader.Id, OB_MCC__c = '0001', OB_MCCL2__c = '5631', OB_GT__c = 'Nexi', OB_PBSettlementMethod__c = 'PB Settlement Method', OB_InternationalSettlementMethod__c = 'International Settlement Method', OB_ReceiptCity__c = 'MILANO', OB_ReceiptHeader__c='Sweet Years', OB_Report_Type__c = 'Punto Vendita', OB_ShopSign__c = 'Sweet Years');
        insert configuration;

        //OrderItem ACQUIRING
        Id rtProductAcqRoot           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.ACQUIRING).getRecordTypeId(); 
        NE__Product__c productAcqRoot = new NE__Product__c(OB_Acquirer__c='', RecordTypeId =rtProductAcqRoot, OB_Codice_sfdc__c = 'VISAMASTERCARD', Name = 'Visa/Mastercard', OB_Contract_Type__c = 'Contratto Acquiring');
        insert productAcqRoot;
        NE__OrderItem__c orderItemAcqRoot = new NE__OrderItem__c(NE__Qty__c=10 ,NE__OrderId__c=configuration.id, NE__Action__c = 'Add', NE__ProdId__c = productAcqRoot.id, NE__Service_Point__c = servicePoint.Id, NE__Account__c = myMastMerchant.Id , NE__Status__c = 'Active', OB_FulfilmentStatus__c = 'Completed', NE__Parent_Order_Item__c = null);
        NE__OrderItem__c orderItemAcqRoot2 = new NE__OrderItem__c(NE__Qty__c=10 ,NE__OrderId__c=configuration.id, NE__Action__c = 'None', NE__ProdId__c = productAcqRoot.id, NE__Service_Point__c = servicePoint.Id, NE__Account__c = myMastMerchant.Id , NE__Status__c = 'Active', OB_FulfilmentStatus__c = 'Completed', NE__Parent_Order_Item__c = null);
        NE__OrderItem__c orderItemAcqRoot2_Child = new NE__OrderItem__c(NE__Qty__c=10 ,NE__OrderId__c=configuration.id, NE__Action__c = 'None', NE__ProdId__c = productAcqRoot.id, NE__Service_Point__c = servicePoint.Id, NE__Account__c = myMastMerchant.Id , NE__Status__c = 'Active', OB_FulfilmentStatus__c = 'Completed', NE__Parent_Order_Item__c =orderItemAcqRoot2.Id );
        
        insert orderItemAcqRoot;
        insert orderItemAcqRoot2;
        insert orderItemAcqRoot2_Child;
        orderItemAcqRoot.NE__AssetItemEnterpriseId__c = orderItemAcqRoot.id;
        update orderItemAcqRoot;
        oiList.add(orderItemAcqRoot);
        //OrderItem GT
        Id rtProductGTRoot          = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.TERMINALE).getRecordTypeId(); 
        NE__Product__c productGTRoot = new NE__Product__c(RecordTypeId = rtProductGTRoot, OB_Codice_sfdc__c = 'SMPOS_CASSA', Name = 'SmartPOS Cassa', OB_Contract_Type__c = 'Contratto POS;Modulo Off Commercial', OB_Business_Model_POS__c = 'Diretto;Trilaterale Nuovo');
        insert productGTRoot;
        NE__OrderItem__c orderItemGTRoot = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__Action__c = 'Add', OB_GT__c = 'MONETICA', OB_TermId__c = '4444333221', NE__ProdId__c = productGTRoot.id, NE__Status__c = 'PENDING', OB_FulfilmentStatus__c = 'Completed');
        orderItemGTRoot.NE__AssetItemEnterpriseId__c = orderItemGTRoot.id;
        insert orderItemGTRoot;

        
        oiList.add(orderItemGTRoot);
        NE__Order_Item_Attribute__c attrGTRoot1 = new NE__Order_Item_Attribute__c();
        attrGTRoot1.Name = 'TermId';
        attrGTRoot1.NE__Order_Item__c = orderItemGTRoot.id;
        
        insert attrGTRoot1;
        NE__Order_Item_Attribute__c attrGTRoot2 = new NE__Order_Item_Attribute__c();
        attrGTRoot2.Name = 'modello';
        attrGTRoot2.NE__Order_Item__c = orderItemGTRoot.id;
        
        insert attrGTRoot2;
        NE__Order_Item_Attribute__c attrGTRoot3 = new NE__Order_Item_Attribute__c();
        attrGTRoot3.Name = 'release';
        attrGTRoot3.NE__Order_Item__c = orderItemGTRoot.id;
    
        insert attrGTRoot3;
        NE__Order_Item_Attribute__c attrGTRoot4 = new NE__Order_Item_Attribute__c();
        attrGTRoot4.Name = 'modalitaCollegamento';
        attrGTRoot4.NE__Order_Item__c = orderItemGTRoot.id;
    
        insert attrGTRoot4;
        NE__Order_Item_Attribute__c attrGTRoot5 = new NE__Order_Item_Attribute__c();
        attrGTRoot5.Name = 'descrizioneModello';
        attrGTRoot5.NE__Order_Item__c = orderItemGTRoot.id;
        
        insert attrGTRoot5;
        NE__Order_Item_Attribute__c attrGTRoot6 = new NE__Order_Item_Attribute__c();
        attrGTRoot6.Name = 'descrizioneRelease';
        attrGTRoot6.NE__Order_Item__c = orderItemGTRoot.id;
    
        insert attrGTRoot6;
        NE__Order_Item_Attribute__c attrGTRoot7 = new NE__Order_Item_Attribute__c();
        attrGTRoot7.Name = 'descrizioneConnessione';
        attrGTRoot7.NE__Order_Item__c = orderItemGTRoot.id;
    
        insert attrGTRoot7;
        NE__Order_Item_Attribute__c attrGTRoot8 = new NE__Order_Item_Attribute__c();
        attrGTRoot8.Name = 'Progressivo SIA';
        attrGTRoot8.NE__Order_Item__c = orderItemGTRoot.id;
        
        insert attrGTRoot8;
        NE__Order_Item_Attribute__c attrGTRoot9 = new NE__Order_Item_Attribute__c();
        attrGTRoot9.Name = 'Codice Stabilimento SIA';
        attrGTRoot9.NE__Order_Item__c = orderItemGTRoot.id;
    
        insert attrGTRoot9;
        NE__Order_Item_Attribute__c attrGTRoot10 = new NE__Order_Item_Attribute__c();
        attrGTRoot10.Name = 'Codice SIA';
        attrGTRoot10.NE__Order_Item__c = orderItemGTRoot.id;
        
        insert attrGTRoot10;
        Id rtProductGT           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.TERMINALE).getRecordTypeId(); 
        NE__Product__c productGT = new NE__Product__c(RecordTypeId = rtProductGT, OB_Codice_sfdc__c = 'INST', Name = 'Installazione pos', OB_Contract_Type__c = 'Installazione pos', OB_Contract_Description__c = 'Installazione pos');
        insert productGT;
        NE__OrderItem__c orderItemGTroot2 = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__Action__c = 'None', NE__ProdId__c = productGT.id , OB_FulfilmentStatus__c = 'Completed', NE__Status__c='Active');

        NE__OrderItem__c orderItemGT = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__Parent_Order_Item__c = orderItemGTRoot.id, NE__Action__c = 'Add', NE__ProdId__c = productGT.id , OB_FulfilmentStatus__c = 'Completed');
        NE__OrderItem__c orderItemGT2 = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__Parent_Order_Item__c = orderItemGTroot2.id, NE__Action__c = 'None', NE__ProdId__c = productGT.id , OB_FulfilmentStatus__c = 'Completed', NE__Status__c='Active');
        orderItemGT.NE__AssetItemEnterpriseId__c= orderItemGT.id;
        insert orderItemGT;
        insert orderItemGT2;
        insert orderItemGTroot2;

        //Item Acquiring Child
        Id rtProductAcq           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.ACQUIRING).getRecordTypeId(); 
        NE__Product__c productAcq = new NE__Product__c(RecordTypeId = rtProductAcq, OB_Acquirer__c='NEXI', OB_Codice_sfdc__c = 'VISAMASTERCARD', Name = 'Visa/Mastercard', OB_Contract_Type__c = 'Contratto Acquiring', OB_Offer__c ='PERSONALIZZATA;START;XPAY_FULL');
        insert productAcq;
        NE__OrderItem__c orderItemAcq = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__ProdId__c = productAcq.id, NE__Action__c = 'Add', NE__Parent_Order_Item__c = orderItemGTRoot.id, OB_FulfilmentStatus__c = 'Completed'); 
        orderItemAcq.NE__AssetItemEnterpriseId__c =orderItemAcq.id;
        insert orderItemAcq;
        Id rtProductPric           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.PRICING).getRecordTypeId(); 
        NE__Product__c productPric = new NE__Product__c(RecordTypeId = rtProductPric, OB_Codice_sfdc__c = 'MAE_PRE', Name = 'MAESTRO CONSUMER PREPAID', OB_Contract_Type__c = 'Contratto Acquiring');
        insert productPric;
        NE__OrderItem__c orderItemPric = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__ProdId__c = productPric.id, NE__Action__c = 'Add', NE__Parent_Order_Item__c = orderItemAcq.id, OB_FulfilmentStatus__c = 'Completed'); 
        orderItemPric.NE__AssetItemEnterpriseId__c =orderItemPric.id;
        insert orderItemPric;

        //ADD ITEM TO CONFIGURATION
        Id rtProductPB    = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.PAGOBANCOMAT).getRecordTypeId(); 
            NE__Product__c productPB    = new NE__Product__c(OB_Acquirer__c=OB_EnrichOrder.NEXI, RecordTypeId =rtProductPB, OB_Codice_sfdc__c = 'PAGOBANCOMAT' );
            insert productPB;
        NE__OrderItem__c pagobancomat = New NE__OrderItem__c(NE__Qty__c=1 ,NE__OrderId__c=configuration.id, NE__Action__c = 'None', NE__ProdId__c = productPB.id, OB_FulfilmentStatus__c = 'Completed');    
        pagobancomat.NE__AssetItemEnterpriseId__c =pagobancomat.id;     
            insert pagobancomat;

        Id rtProductVAS   = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.VAS).getRecordTypeId(); 
        NE__Product__c productRootVAS   = new NE__Product__c(RecordTypeId = rtProductVAS, OB_Codice_sfdc__c = 'PELLEGRINI',OB_Acquirer__c='NEXI');
            insert productRootVAS;
        NE__OrderItem__c rootVas = New NE__OrderItem__c(NE__Qty__c=1 ,NE__OrderId__c=configuration.id, NE__Action__c = 'None', OB_FulfilmentStatus__c = 'Completed');   
        rootVas.NE__AssetItemEnterpriseId__c        =rootVas.id;
            insert rootVas;
        oiList.add(rootVas);
        NE__Product__c productVAS   = new NE__Product__c(RecordTypeId = rtProductVAS, OB_Codice_sfdc__c = 'PELLEGRINI',OB_Acquirer__c='NEXI');
            insert productVAS;
        NE__OrderItem__c vas = New NE__OrderItem__c(NE__Qty__c=1 ,NE__OrderId__c=configuration.id, NE__Action__c = 'Add', OB_FulfilmentStatus__c = 'Completed');        
        vas.NE__AssetItemEnterpriseId__c    =vas.id;
            insert vas;
        oiList.add(vas);
        NE__Product__c product1    = new NE__Product__c(OB_Acquirer__c=OB_EnrichOrder.NEXI , RecordTypeId =rtProductPric );
            product1.OB_Codice_sfdc__c = 'ALB_AUTO';
            insert product1;

            NE__OrderItem__c orderItem1 = new NE__OrderItem__c();
            orderItem1.NE__Qty__c     = 1;
            orderItem1.NE__OrderId__c = configuration.id;
            orderItem1.NE__ProdId__c  = product1.id;
        orderItem1.NE__Action__c = 'Add';
        orderItem1.OB_FulfilmentStatus__c = 'Completed';
        orderItem1.NE__Parent_Order_Item__c = orderItemAcq.id;
        orderItem1.NE__Parent_Order_Item__c = orderItemAcq.id;
        orderItem1.NE__AssetItemEnterpriseId__c = orderItem1.id;
            insert orderItem1;

        //orderItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.ACQUIRING && orderItem.NE__ProdId__r.OB_Acquirer__c!=OB_EnrichOrder.NEXI
        NE__Product__c productNotNexi    = new NE__Product__c(OB_Acquirer__c='AMEX' , RecordTypeId =rtProductAcqRoot, OB_Codice_sfdc__c = 'AMEX' );
            insert productNotNexi;

        NE__OrderItem__c orderItemNotNexi = new NE__OrderItem__c();
        orderItemNotNexi.NE__Qty__c     = 1;
            orderItemNotNexi.NE__OrderId__c = configuration.id;
            orderItemNotNexi.NE__ProdId__c  = productNotNexi.id;
        orderItemNotNexi.NE__Action__c = 'None';
        orderItemNotNexi.OB_FulfilmentStatus__c = 'Completed';
        orderItemNotNexi.NE__Parent_Order_Item__c = null;
        orderItemNotNexi.OB_FulfilmentStatus__c = 'Completed';
        orderItemNotNexi.NE__AssetItemEnterpriseId__c= orderItemNotNexi.id;
            insert orderItemNotNexi;

        NE__Product__c productNotNexiPricing   = new NE__Product__c(OB_Acquirer__c='AMEX' , RecordTypeId =rtProductPric, OB_Codice_sfdc__c = 'PRICING' );
            insert productNotNexiPricing;
        NE__OrderItem__c orderItemNotNexiPric = new NE__OrderItem__c();
        orderItemNotNexiPric.NE__Qty__c     = 1;
            orderItemNotNexiPric.NE__OrderId__c = configuration.id;
            orderItemNotNexiPric.NE__ProdId__c  = productNotNexiPricing.id;
        orderItemNotNexiPric.NE__Action__c = 'None';
        orderItemNotNexiPric.OB_FulfilmentStatus__c = 'Completed';
        orderItemNotNexiPric.NE__Parent_Order_Item__c = orderItemNotNexi.id;
        orderItemNotNexiPric.NE__AssetItemEnterpriseId__c= orderItemNotNexiPric.id;
            insert orderItemNotNexiPric;
        //insert oiList;
        
        
        //ASSET
        Asset asset = new Asset(NE__AssetItemEnterpriseId__c = orderItemGTRoot.Id, OB_ShopCode__c = 'shopCode', OB_GT__c = 'GT', OB_CustomerCode__c = 'customerCode', Name = 'SmartPOS');
        insert asset;
        NE__AssetItemAttribute__c attr1 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.TERMID, NE__Asset__c = asset.id);
        insert attr1;
        NE__AssetItemAttribute__c attr2 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.MODELLO, NE__Asset__c = asset.id);
        insert attr2;
        NE__AssetItemAttribute__c attr3 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.RELEASE, NE__Asset__c = asset.id);
        insert attr3;
        NE__AssetItemAttribute__c attr4 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.MODCOLLEGAMENTO, NE__Asset__c = asset.id);
        insert attr4;
        NE__AssetItemAttribute__c attr5 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.DMODELLO, NE__Asset__c = asset.id);
        insert attr5;
        NE__AssetItemAttribute__c attr6 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.DRELEASE, NE__Asset__c = asset.id);
        insert attr6;
        NE__AssetItemAttribute__c attr7 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.DCONNESSIONE, NE__Asset__c = asset.id);
        insert attr7;
        NE__AssetItemAttribute__c attr8 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.PROGRESSIVOSIA, NE__Asset__c = asset.id);
        insert attr8;
        NE__AssetItemAttribute__c attr9 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.CODICESTABILIMENTOSIA, NE__Asset__c = asset.id);
        insert attr9;
        NE__AssetItemAttribute__c attr10 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.CODICESIA, NE__Asset__c = asset.id);
        insert attr10;

        //LOV
        NE__Lov__c lovMCC2 = new NE__Lov__c();
        lovMCC2.NE__Type__c   = 'mcc';
        lovMCC2.NE__Value3__c = 'L2';
        lovMCC2.OB_Value4__c  = configuration.OB_MCCL2__c;
        lovMCC2.NE__Value2__c = configuration.OB_MCCL2__c;
        insert lovMCC2;
        System.debug('@@@lovMCC2 '+lovMCC2);
        NE__Lov__c lov = new NE__Lov__c();
        lov.NE__Type__c     ='TRACKING';
        lov.NE__Sub_Type__c = 'TIPOLOGICHE';
        lov.NE__Value2__c   = 'DINERS';
        lov.NE__Value1__c   = '12';
        insert lov;

        OB_TrackingUtility.ErrorList error1 = new OB_TrackingUtility.ErrorList();

        List<OB_TrackingUtility.ErrorList> errorsList1 = new List<OB_TrackingUtility.ErrorList>();
        

        OB_TrackingUtility.Changes change = new OB_TrackingUtility.Changes();
        change.externalId = rootVas.id; //TERMINALE
        change.result = 'OK';
        change.errors = errorsList1; //List

    
    
        List<OB_TrackingUtility.Changes> changesList = new List<OB_TrackingUtility.Changes>();
        changesList.add(change);

        
        
        OB_TrackingUtility.CodiciConvenzioni codConv = new OB_TrackingUtility.CodiciConvenzioni();
        codConv.companyCode = 'companyCode';
        codConv.companyName = 'companyName';                                
        codConv.code        = 'code';                                       
        codConv.causaleRifiuto ='causaleRifiuto';
        codConv.startDate = '2011-11-13';
        codConv.endDate = '';
        codConv.status  = 'Active';

        List<OB_TrackingUtility.CodiciConvenzioni> codConvList = new List<OB_TrackingUtility.CodiciConvenzioni>();
        codConvList.add(codConv);

        OB_TrackingUtility.TermsIdInformation termInfo = new OB_TrackingUtility.TermsIdInformation();    
        termInfo.terminalId = orderItemGTRoot.OB_TermId__c;
        termInfo.model = 'model';
        termInfo.connectionType = 'connectionType';
        termInfo.modality = 'modality';
        termInfo.modelDescription = 'modelDescription';
        termInfo.release = 'release';
        termInfo.releaseDescription = 'releaseDescription';
        termInfo.status = 'Pending';
        termInfo.reasonOfRejection = '';
        termInfo.installationDate = '2011-11-13';
        termInfo.uninstallationDate = '';
        termInfo.agreementCodes = codConvList; //List
        termInfo.errors = null; //List

        List<OB_TrackingUtility.TermsIdInformation> termsInfoList = new List<OB_TrackingUtility.TermsIdInformation>();
        termsInfoList.add(termInfo);

        OB_TrackingUtility.ErrorList error = new OB_TrackingUtility.ErrorList();
        error.code = '';
        error.description = '';

        
    

        List<OB_TrackingUtility.ErrorList> errorsList = new List<OB_TrackingUtility.ErrorList>();
        errorsList.add(error);
    

        OB_TrackingUtility.puntoVendita pV = new OB_TrackingUtility.puntoVendita();
        //pV.itemId = '';
        pV.PVCode = servicePoint.id;
        pV.startDate = '2011-11-13';
        pV.endDate = '';
        pV.reasonOfClosure = '';
        //pV.tipo = '';
        pV.ctiCode = 'ctiCode';
        pV.StabiCode = 'StabiCode';
        pV.siaPVCode = 'siaPVCode';
        pV.siaProgressiveCode = 'siaProgressiveCode';
        pV.siaMerchantCode = 'siaMerchantCode';
        pV.assistanceNumber = 'assistanceNumber';
        //pV.dataInizioAttivita = '2011-11-13';
        pv.terminalInformation = termsInfoList; //List
        pv.changes = changesList;

        List<OB_TrackingUtility.puntoVendita> pVList = new List<OB_TrackingUtility.puntoVendita>();
        pVList.add(pV);

        OB_TrackingUtility.GT gT = new OB_TrackingUtility.GT();
        gT.source = 'MONETICA';
        gT.gtCompanyCode = 'companyCode';
        gT.errors = null; //List
        gT.PVCodes = pVList; //List
        //gT.statoProvisioning = '';

        List<OB_TrackingUtility.GT> gTList = new List<OB_TrackingUtility.GT>();
        gTList.add(gT);

        OB_TrackingUtility.Acquiring acquiring = new OB_TrackingUtility.Acquiring();
        acquiring.source = 'NEXI';
        acquiring.companyCode = 'companyCode';
        acquiring.errori = null;
        acquiring.PVCodes = pVList;

        List<OB_TrackingUtility.Acquiring> acquiringList = new List<OB_TrackingUtility.Acquiring>();
        //acquiringList.add(acquiring);

        OB_TrackingUtility.TrackingOrderRequestMaintenance trackingOrderRequest = new OB_TrackingUtility.TrackingOrderRequestMaintenance();
        trackingOrderRequest.orderId = configuration.id;
        trackingOrderRequest.Acquiring = acquiringList;
        trackingOrderRequest.GT = gTList;

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/TrackingOrderMaintenance/*'; 
        req.httpMethod = 'POST';
        RestContext.request = req;
        String json = JSON.serialize(trackingOrderRequest);
        RestContext.request.requestBody =  Blob.valueof(json);
        RestContext.response = res;

        List<OB_LogRequest__c> listLog = new List<OB_LogRequest__c>();
        OB_LogRequest__c log = OB_TestDataFactory.getLogRequest();
        listLog.add(log);
        Test.startTest();
        OB_TrackingUtility.TrackingOrderResponseMaintenance response = OB_TrackingOrderMaintenance.trackOrderMaintenance();
        OB_TrackingOrderMaintenance.isAcquiringVas(acquiringList);
        OB_TrackingOrderMaintenance.isAcquiringTerminal(acquiringList, true);
        OB_TrackingOrderMaintenance.isAcquiringTerminal(acquiringList, false);
        OB_TrackingOrderMaintenance.updateLogRequest(configuration.id);
        OB_TrackingOrderMaintenance.updateVasItems(oiList,changesList,'','','','',listLog);
        System.assertEquals( 500, response.httpStatus);
        Test.stopTest();
    }





    @isTest
     public static void OB_TrackingOrderMaintenance_Test_NI3_error(){
        List<Account> accList = new List<Account>();
        List<NE__OrderItem__c> oiList = new List<NE__OrderItem__c>();
        Id rtMerchant       = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId(); 
        Account myMastMerchant  = new Account(Name='TEST',
                                            RecordTypeId=rtMerchant,
                                            OB_Employees_Number__c='Minore di 10',
                                            OB_VAT_Not_Present__c=true, 
                                            OB_DescriptionVATNotPresent__c='description', 
                                            NE__Fiscal_code__c='RSSMRA80A01F205X',
                                            OB_BypassValidation__c=true,
                                            OB_Status__c='Active'); 

        Id accountBankRecordId   = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Bank').getRecordTypeId(); 
        Account bankAccount   = new Account(Name='TEST',
                                            RecordTypeId=accountBankRecordId,
                                            OB_Employees_Number__c='Minore di 10',
                                            OB_VAT_Not_Present__c=true, 
                                            OB_DescriptionVATNotPresent__c='description', 
                                            NE__Fiscal_code__c='RSSMRA80A01F205X',
                                            OB_BypassValidation__c=true,
                                            OB_Status__c='Active');   
        accList.add(myMastMerchant);
        accList.add(bankAccount);
        insert accList;
        NE__Service_Point__c servicePoint = new NE__Service_Point__c();
        insert servicePoint;
        NE__Order_Header__c orderHeader = new NE__Order_Header__c(OB_ProposerABI__c=bankAccount.Id ,NE__AccountId__c=myMastMerchant.Id, OB_Main_Process__c = 'Maintenance', OB_Sub_Process__c = 'variazione operativa', OB_Business_Model_Acquiring__c = 'Bancario');
        insert orderHeader;
        NE__Order__c configuration = new NE__Order__c(NE__AccountId__c=myMastMerchant.Id, OB_Service_Point__c = servicePoint.Id,NE__Order_Header__c=orderHeader.Id, OB_MCC__c = '0001', OB_MCCL2__c = '5631', OB_GT__c = 'Nexi', OB_PBSettlementMethod__c = 'PB Settlement Method', OB_InternationalSettlementMethod__c = 'International Settlement Method', OB_ReceiptCity__c = 'MILANO', OB_ReceiptHeader__c='Sweet Years', OB_Report_Type__c = 'Punto Vendita', OB_ShopSign__c = 'Sweet Years');
        insert configuration;

        //OrderItem ACQUIRING
        Id rtProductAcqRoot           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.ACQUIRING).getRecordTypeId(); 
        NE__Product__c productAcqRoot = new NE__Product__c(OB_Acquirer__c='', RecordTypeId =rtProductAcqRoot, OB_Codice_sfdc__c = 'VISAMASTERCARD', Name = 'Visa/Mastercard', OB_Contract_Type__c = 'Contratto Acquiring');
        insert productAcqRoot;
        NE__OrderItem__c orderItemAcqRoot = new NE__OrderItem__c(NE__Qty__c=10 ,NE__OrderId__c=configuration.id, NE__Action__c = 'Add', NE__ProdId__c = productAcqRoot.id, NE__Service_Point__c = servicePoint.Id, NE__Account__c = myMastMerchant.Id , NE__Status__c = 'Active', OB_FulfilmentStatus__c = 'Completed', NE__Parent_Order_Item__c = null);
        NE__OrderItem__c orderItemAcqRoot2 = new NE__OrderItem__c(NE__Qty__c=10 ,NE__OrderId__c=configuration.id, NE__Action__c = 'None', NE__ProdId__c = productAcqRoot.id, NE__Service_Point__c = servicePoint.Id, NE__Account__c = myMastMerchant.Id , NE__Status__c = 'Active', OB_FulfilmentStatus__c = 'Completed', NE__Parent_Order_Item__c = null);
        NE__OrderItem__c orderItemAcqRoot2_Child = new NE__OrderItem__c(NE__Qty__c=10 ,NE__OrderId__c=configuration.id, NE__Action__c = 'None', NE__ProdId__c = productAcqRoot.id, NE__Service_Point__c = servicePoint.Id, NE__Account__c = myMastMerchant.Id , NE__Status__c = 'Active', OB_FulfilmentStatus__c = 'Completed', NE__Parent_Order_Item__c =orderItemAcqRoot2.Id );
        
        insert orderItemAcqRoot;
        insert orderItemAcqRoot2;
        insert orderItemAcqRoot2_Child;
        orderItemAcqRoot.NE__AssetItemEnterpriseId__c = orderItemAcqRoot.id;
        update orderItemAcqRoot;
        oiList.add(orderItemAcqRoot);
        //OrderItem GT
        Id rtProductGTRoot          = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.TERMINALE).getRecordTypeId(); 
        NE__Product__c productGTRoot = new NE__Product__c(RecordTypeId = rtProductGTRoot, OB_Codice_sfdc__c = 'SMPOS_CASSA', Name = 'SmartPOS Cassa', OB_Contract_Type__c = 'Contratto POS;Modulo Off Commercial', OB_Business_Model_POS__c = 'Diretto;Trilaterale Nuovo');
        insert productGTRoot;
        NE__OrderItem__c orderItemGTRoot = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__Action__c = 'Add', OB_GT__c = 'MONETICA', OB_TermId__c = '4444333221', NE__ProdId__c = productGTRoot.id, NE__Status__c = 'PENDING', OB_FulfilmentStatus__c = 'Completed');
        orderItemGTRoot.NE__AssetItemEnterpriseId__c = orderItemGTRoot.id;
        insert orderItemGTRoot;

        
        oiList.add(orderItemGTRoot);
        NE__Order_Item_Attribute__c attrGTRoot1 = new NE__Order_Item_Attribute__c();
        attrGTRoot1.Name = 'TermId';
        attrGTRoot1.NE__Order_Item__c = orderItemGTRoot.id;
        
        insert attrGTRoot1;
        NE__Order_Item_Attribute__c attrGTRoot2 = new NE__Order_Item_Attribute__c();
        attrGTRoot2.Name = 'modello';
        attrGTRoot2.NE__Order_Item__c = orderItemGTRoot.id;
        
        insert attrGTRoot2;
        NE__Order_Item_Attribute__c attrGTRoot3 = new NE__Order_Item_Attribute__c();
        attrGTRoot3.Name = 'release';
        attrGTRoot3.NE__Order_Item__c = orderItemGTRoot.id;
    
        insert attrGTRoot3;
        NE__Order_Item_Attribute__c attrGTRoot4 = new NE__Order_Item_Attribute__c();
        attrGTRoot4.Name = 'modalitaCollegamento';
        attrGTRoot4.NE__Order_Item__c = orderItemGTRoot.id;
    
        insert attrGTRoot4;
        NE__Order_Item_Attribute__c attrGTRoot5 = new NE__Order_Item_Attribute__c();
        attrGTRoot5.Name = 'descrizioneModello';
        attrGTRoot5.NE__Order_Item__c = orderItemGTRoot.id;
        
        insert attrGTRoot5;
        NE__Order_Item_Attribute__c attrGTRoot6 = new NE__Order_Item_Attribute__c();
        attrGTRoot6.Name = 'descrizioneRelease';
        attrGTRoot6.NE__Order_Item__c = orderItemGTRoot.id;
    
        insert attrGTRoot6;
        NE__Order_Item_Attribute__c attrGTRoot7 = new NE__Order_Item_Attribute__c();
        attrGTRoot7.Name = 'descrizioneConnessione';
        attrGTRoot7.NE__Order_Item__c = orderItemGTRoot.id;
    
        insert attrGTRoot7;
        NE__Order_Item_Attribute__c attrGTRoot8 = new NE__Order_Item_Attribute__c();
        attrGTRoot8.Name = 'Progressivo SIA';
        attrGTRoot8.NE__Order_Item__c = orderItemGTRoot.id;
        
        insert attrGTRoot8;
        NE__Order_Item_Attribute__c attrGTRoot9 = new NE__Order_Item_Attribute__c();
        attrGTRoot9.Name = 'Codice Stabilimento SIA';
        attrGTRoot9.NE__Order_Item__c = orderItemGTRoot.id;
    
        insert attrGTRoot9;
        NE__Order_Item_Attribute__c attrGTRoot10 = new NE__Order_Item_Attribute__c();
        attrGTRoot10.Name = 'Codice SIA';
        attrGTRoot10.NE__Order_Item__c = orderItemGTRoot.id;
        
        insert attrGTRoot10;
        Id rtProductGT           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.TERMINALE).getRecordTypeId(); 
        NE__Product__c productGT = new NE__Product__c(RecordTypeId = rtProductGT, OB_Codice_sfdc__c = 'INST', Name = 'Installazione pos', OB_Contract_Type__c = 'Installazione pos', OB_Contract_Description__c = 'Installazione pos');
        insert productGT;
        NE__OrderItem__c orderItemGTroot2 = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__Action__c = 'None', NE__ProdId__c = productGT.id , OB_FulfilmentStatus__c = 'Completed', NE__Status__c='Active');

        NE__OrderItem__c orderItemGT = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__Parent_Order_Item__c = orderItemGTRoot.id, NE__Action__c = 'Add', NE__ProdId__c = productGT.id , OB_FulfilmentStatus__c = 'Completed');
        NE__OrderItem__c orderItemGT2 = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__Parent_Order_Item__c = orderItemGTroot2.id, NE__Action__c = 'None', NE__ProdId__c = productGT.id , OB_FulfilmentStatus__c = 'Completed', NE__Status__c='Active');
        orderItemGT.NE__AssetItemEnterpriseId__c= orderItemGT.id;
        insert orderItemGT;
        insert orderItemGT2;
        insert orderItemGTroot2;

        //Item Acquiring Child
        Id rtProductAcq           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.ACQUIRING).getRecordTypeId(); 
        NE__Product__c productAcq = new NE__Product__c(RecordTypeId = rtProductAcq, OB_Acquirer__c='NEXI', OB_Codice_sfdc__c = 'VISAMASTERCARD', Name = 'Visa/Mastercard', OB_Contract_Type__c = 'Contratto Acquiring', OB_Offer__c ='PERSONALIZZATA;START;XPAY_FULL');
        insert productAcq;
        NE__OrderItem__c orderItemAcq = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__ProdId__c = productAcq.id, NE__Action__c = 'Add', NE__Parent_Order_Item__c = orderItemGTRoot.id, OB_FulfilmentStatus__c = 'Completed'); 
        orderItemAcq.NE__AssetItemEnterpriseId__c =orderItemAcq.id;
        insert orderItemAcq;
        Id rtProductPric           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.PRICING).getRecordTypeId(); 
        NE__Product__c productPric = new NE__Product__c(RecordTypeId = rtProductPric, OB_Codice_sfdc__c = 'MAE_PRE', Name = 'MAESTRO CONSUMER PREPAID', OB_Contract_Type__c = 'Contratto Acquiring');
        insert productPric;
        NE__OrderItem__c orderItemPric = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__ProdId__c = productPric.id, NE__Action__c = 'Add', NE__Parent_Order_Item__c = orderItemAcq.id, OB_FulfilmentStatus__c = 'Completed'); 
        orderItemPric.NE__AssetItemEnterpriseId__c =orderItemPric.id;
        insert orderItemPric;

        //ADD ITEM TO CONFIGURATION
        Id rtProductPB    = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.PAGOBANCOMAT).getRecordTypeId(); 
            NE__Product__c productPB    = new NE__Product__c(OB_Acquirer__c=OB_EnrichOrder.NEXI, RecordTypeId =rtProductPB, OB_Codice_sfdc__c = 'PAGOBANCOMAT' );
            insert productPB;
        NE__OrderItem__c pagobancomat = New NE__OrderItem__c(NE__Qty__c=1 ,NE__OrderId__c=configuration.id, NE__Action__c = 'None', NE__ProdId__c = productPB.id, OB_FulfilmentStatus__c = 'Completed');    
        pagobancomat.NE__AssetItemEnterpriseId__c =pagobancomat.id;     
            insert pagobancomat;

        Id rtProductVAS   = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.VAS).getRecordTypeId(); 
        NE__Product__c productRootVAS   = new NE__Product__c(RecordTypeId = rtProductVAS, OB_Codice_sfdc__c = 'PELLEGRINI',OB_Acquirer__c='NEXI');
            insert productRootVAS;
        NE__OrderItem__c rootVas = New NE__OrderItem__c(NE__Qty__c=1 ,NE__OrderId__c=configuration.id, NE__Action__c = 'None', OB_FulfilmentStatus__c = 'Completed');   
        rootVas.NE__AssetItemEnterpriseId__c        =rootVas.id;
            insert rootVas;
        oiList.add(rootVas);
        NE__Product__c productVAS   = new NE__Product__c(RecordTypeId = rtProductVAS, OB_Codice_sfdc__c = 'PELLEGRINI',OB_Acquirer__c='NEXI');
            insert productVAS;
        NE__OrderItem__c vas = New NE__OrderItem__c(NE__Qty__c=1 ,NE__OrderId__c=configuration.id, NE__Action__c = 'Add', OB_FulfilmentStatus__c = 'Completed');        
        vas.NE__AssetItemEnterpriseId__c    =vas.id;
            insert vas;
        oiList.add(vas);
        NE__Product__c product1    = new NE__Product__c(OB_Acquirer__c=OB_EnrichOrder.NEXI , RecordTypeId =rtProductPric );
            product1.OB_Codice_sfdc__c = 'ALB_AUTO';
            insert product1;

            NE__OrderItem__c orderItem1 = new NE__OrderItem__c();
            orderItem1.NE__Qty__c     = 1;
            orderItem1.NE__OrderId__c = configuration.id;
            orderItem1.NE__ProdId__c  = product1.id;
        orderItem1.NE__Action__c = 'Add';
        orderItem1.OB_FulfilmentStatus__c = 'Completed';
        orderItem1.NE__Parent_Order_Item__c = orderItemAcq.id;
        orderItem1.NE__Parent_Order_Item__c = orderItemAcq.id;
        orderItem1.NE__AssetItemEnterpriseId__c = orderItem1.id;
            insert orderItem1;

        //orderItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.ACQUIRING && orderItem.NE__ProdId__r.OB_Acquirer__c!=OB_EnrichOrder.NEXI
        NE__Product__c productNotNexi    = new NE__Product__c(OB_Acquirer__c='AMEX' , RecordTypeId =rtProductAcqRoot, OB_Codice_sfdc__c = 'AMEX' );
            insert productNotNexi;

        NE__OrderItem__c orderItemNotNexi = new NE__OrderItem__c();
        orderItemNotNexi.NE__Qty__c     = 1;
            orderItemNotNexi.NE__OrderId__c = configuration.id;
            orderItemNotNexi.NE__ProdId__c  = productNotNexi.id;
        orderItemNotNexi.NE__Action__c = 'None';
        orderItemNotNexi.OB_FulfilmentStatus__c = 'Completed';
        orderItemNotNexi.NE__Parent_Order_Item__c = null;
        orderItemNotNexi.OB_FulfilmentStatus__c = 'Completed';
        orderItemNotNexi.NE__AssetItemEnterpriseId__c= orderItemNotNexi.id;
            insert orderItemNotNexi;


        NE__Product__c productNotNexiPricing   = new NE__Product__c(OB_Acquirer__c='AMEX' , RecordTypeId =rtProductPric, OB_Codice_sfdc__c = 'PRICING' );
            insert productNotNexiPricing;
        NE__OrderItem__c orderItemNotNexiPric = new NE__OrderItem__c();
        orderItemNotNexiPric.NE__Qty__c     = 1;
            orderItemNotNexiPric.NE__OrderId__c = configuration.id;
            orderItemNotNexiPric.NE__ProdId__c  = productNotNexiPricing.id;
        orderItemNotNexiPric.NE__Action__c = 'None';
        orderItemNotNexiPric.OB_FulfilmentStatus__c = 'Completed';
        orderItemNotNexiPric.NE__Parent_Order_Item__c = orderItemNotNexi.id;
        orderItemNotNexiPric.NE__AssetItemEnterpriseId__c= orderItemNotNexiPric.id;
            insert orderItemNotNexiPric;
            //insert oiList;
        
        
        
        //ASSET
        Asset asset = new Asset(NE__AssetItemEnterpriseId__c = orderItemGTRoot.Id, OB_ShopCode__c = 'shopCode', OB_GT__c = 'GT', OB_CustomerCode__c = 'customerCode', Name = 'SmartPOS');
        insert asset;
        NE__AssetItemAttribute__c attr1 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.TERMID, NE__Asset__c = asset.id);
        insert attr1;
        NE__AssetItemAttribute__c attr2 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.MODELLO, NE__Asset__c = asset.id);
        insert attr2;
        NE__AssetItemAttribute__c attr3 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.RELEASE, NE__Asset__c = asset.id);
        insert attr3;
        NE__AssetItemAttribute__c attr4 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.MODCOLLEGAMENTO, NE__Asset__c = asset.id);
        insert attr4;
        NE__AssetItemAttribute__c attr5 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.DMODELLO, NE__Asset__c = asset.id);
        insert attr5;
        NE__AssetItemAttribute__c attr6 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.DRELEASE, NE__Asset__c = asset.id);
        insert attr6;
        NE__AssetItemAttribute__c attr7 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.DCONNESSIONE, NE__Asset__c = asset.id);
        insert attr7;
        NE__AssetItemAttribute__c attr8 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.PROGRESSIVOSIA, NE__Asset__c = asset.id);
        insert attr8;
        NE__AssetItemAttribute__c attr9 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.CODICESTABILIMENTOSIA, NE__Asset__c = asset.id);
        insert attr9;
        NE__AssetItemAttribute__c attr10 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.CODICESIA, NE__Asset__c = asset.id);
        insert attr10;

        //LOV
        NE__Lov__c lovMCC2 = new NE__Lov__c();
        lovMCC2.NE__Type__c   = 'mcc';
        lovMCC2.NE__Value3__c = 'L2';
        lovMCC2.OB_Value4__c  = configuration.OB_MCCL2__c;
        lovMCC2.NE__Value2__c = configuration.OB_MCCL2__c;
        insert lovMCC2;
        System.debug('@@@lovMCC2 '+lovMCC2);
        NE__Lov__c lov = new NE__Lov__c();
        lov.NE__Type__c     ='TRACKING';
        lov.NE__Sub_Type__c = 'TIPOLOGICHE';
        lov.NE__Value2__c   = 'DINERS';
        lov.NE__Value1__c   = '12';
        insert lov;

        OB_TrackingUtility.ErrorList error = new OB_TrackingUtility.ErrorList();
        error.code = 'qw';
        error.description = 'qw';
        List<OB_TrackingUtility.ErrorList> errorsList = new List<OB_TrackingUtility.ErrorList>();
        errorsList.add(error);
        

        OB_TrackingUtility.Changes change = new OB_TrackingUtility.Changes();
        change.externalId = rootVas.id; //TERMINALE
        change.result = 'OK';
        change.errors = errorsList; //List

    
    
        List<OB_TrackingUtility.Changes> changesList = new List<OB_TrackingUtility.Changes>();
        changesList.add(change);

     
        
        
        OB_TrackingUtility.CodiciConvenzioni codConv = new OB_TrackingUtility.CodiciConvenzioni();
        codConv.companyCode = 'companyCode';
        codConv.companyName = 'companyName';                                
        codConv.code        = 'code';                                       
        codConv.causaleRifiuto ='causaleRifiuto';
        codConv.startDate = '2011-11-13';
        codConv.endDate = '';
        codConv.status  = 'Active';

        List<OB_TrackingUtility.CodiciConvenzioni> codConvList = new List<OB_TrackingUtility.CodiciConvenzioni>();
        codConvList.add(codConv);

        OB_TrackingUtility.TermsIdInformation termInfo = new OB_TrackingUtility.TermsIdInformation();    
        termInfo.terminalId = orderItemGTRoot.OB_TermId__c;
        termInfo.model = 'model';
        termInfo.connectionType = 'connectionType';
        termInfo.modality = 'modality';
        termInfo.modelDescription = 'modelDescription';
        termInfo.release = 'release';
        termInfo.releaseDescription = 'releaseDescription';
        termInfo.status = 'Pending';
        termInfo.reasonOfRejection = '';
        termInfo.installationDate = '2011-11-13';
        termInfo.uninstallationDate = '';
        termInfo.agreementCodes = codConvList; //List
        termInfo.errors = errorsList; //List

        List<OB_TrackingUtility.TermsIdInformation> termsInfoList = new List<OB_TrackingUtility.TermsIdInformation>();
        termsInfoList.add(termInfo);


        
    

   
    

        OB_TrackingUtility.puntoVendita pV = new OB_TrackingUtility.puntoVendita();
        //pV.itemId = '';
        pV.PVCode = servicePoint.id;
        pV.startDate = '2011-11-13';
        pV.endDate = '';
        pV.reasonOfClosure = '';
        //pV.tipo = '';
        pV.ctiCode = 'ctiCode';
        pV.StabiCode = 'StabiCode';
        pV.siaPVCode = 'siaPVCode';
        pV.siaProgressiveCode = 'siaProgressiveCode';
        pV.siaMerchantCode = 'siaMerchantCode';
        pV.assistanceNumber = 'assistanceNumber';
        //pV.dataInizioAttivita = '2011-11-13';
        pv.terminalInformation = termsInfoList; //List
        pv.changes = changesList;

        List<OB_TrackingUtility.puntoVendita> pVList = new List<OB_TrackingUtility.puntoVendita>();
        pVList.add(pV);

        OB_TrackingUtility.GT gT = new OB_TrackingUtility.GT();
        gT.source = 'MONETICA';
        gT.gtCompanyCode = 'companyCode';
        gT.errors = errorsList; //List
        gT.PVCodes = pVList; //List
        //gT.statoProvisioning = '';

        List<OB_TrackingUtility.GT> gTList = new List<OB_TrackingUtility.GT>();
        gTList.add(gT);

        

        OB_TrackingUtility.Acquiring acquiring = new OB_TrackingUtility.Acquiring();
        acquiring.source = 'NEXI';
        acquiring.companyCode = 'companyCode';
        acquiring.errori = errorsList;
        acquiring.PVCodes = pVList;

        List<OB_TrackingUtility.Acquiring> acquiringList = new List<OB_TrackingUtility.Acquiring>();
        acquiringList.add(acquiring);

        OB_TrackingUtility.TrackingOrderRequestMaintenance trackingOrderRequest = new OB_TrackingUtility.TrackingOrderRequestMaintenance();
        trackingOrderRequest.orderId = configuration.id;
        trackingOrderRequest.Acquiring = acquiringList;
        trackingOrderRequest.GT = gTList;

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/TrackingOrderMaintenance/*'; 
        req.httpMethod = 'POST';
        RestContext.request = req;
        String json = JSON.serialize(trackingOrderRequest);
        RestContext.request.requestBody =  Blob.valueof(json);
        RestContext.response = res;


        List<OB_LogRequest__c> listLog = new List<OB_LogRequest__c>();
        OB_LogRequest__c log = OB_TestDataFactory.getLogRequest();
        listLog.add(log);
        Test.startTest();
        OB_TrackingUtility.TrackingOrderResponseMaintenance response = OB_TrackingOrderMaintenance.trackOrderMaintenance();
        OB_TrackingOrderMaintenance.isAcquiringVas(acquiringList);
        OB_TrackingOrderMaintenance.isAcquiringTerminal(acquiringList, true);
        OB_TrackingOrderMaintenance.isAcquiringTerminal(acquiringList, false);
        OB_TrackingOrderMaintenance.updateLogRequest(configuration.id);
        OB_TrackingOrderMaintenance.updateVasItems(oiList,changesList,'','','','',listLog);
        System.assertEquals( 500, response.httpStatus);
        Test.stopTest();
    }



    
@isTest
  public static void OB_TrackingOrderMaintenance_Test6_Error(){
    List<Account> accList = new List<Account>();
    List<NE__OrderItem__c> oiList = new List<NE__OrderItem__c>();
    Id rtMerchant       = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId(); 
    Account myMastMerchant  = new Account(Name='TEST',
                                          RecordTypeId=rtMerchant,
                                          OB_Employees_Number__c='Minore di 10',
                                          OB_VAT_Not_Present__c=true, 
                                          OB_DescriptionVATNotPresent__c='description', 
                                          NE__Fiscal_code__c='RSSMRA80A01F205X',
                                          OB_BypassValidation__c=true,
                                          OB_Status__c='Active'); 

    Id accountBankRecordId   = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Bank').getRecordTypeId(); 
    Account bankAccount   = new Account(Name='TEST',
                                        RecordTypeId=accountBankRecordId,
                                        OB_Employees_Number__c='Minore di 10',
                                        OB_VAT_Not_Present__c=true, 
                                        OB_DescriptionVATNotPresent__c='description', 
                                        NE__Fiscal_code__c='RSSMRA80A01F205X',
                                        OB_BypassValidation__c=true,
                                        OB_Status__c='Active');   
    accList.add(myMastMerchant);
    accList.add(bankAccount);
    insert accList;
    NE__Service_Point__c servicePoint = new NE__Service_Point__c();
    insert servicePoint;
    NE__Order_Header__c orderHeader = new NE__Order_Header__c(OB_ProposerABI__c=bankAccount.Id ,NE__AccountId__c=myMastMerchant.Id, OB_Main_Process__c = 'Maintenance', OB_Sub_Process__c = 'sostituzione terminali', OB_Business_Model_Acquiring__c = 'Bancario');
    insert orderHeader;
    NE__Order__c configuration = new NE__Order__c(NE__AccountId__c=myMastMerchant.Id, OB_Service_Point__c = servicePoint.Id,NE__Order_Header__c=orderHeader.Id, OB_MCC__c = '0001', OB_MCCL2__c = '5631', OB_GT__c = 'Nexi', OB_PBSettlementMethod__c = 'PB Settlement Method', OB_InternationalSettlementMethod__c = 'International Settlement Method', OB_ReceiptCity__c = 'MILANO', OB_ReceiptHeader__c='Sweet Years', OB_Report_Type__c = 'Punto Vendita', OB_ShopSign__c = 'Sweet Years');
    insert configuration;

    //OrderItem ACQUIRING
      Id rtProductAcqRoot           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.ACQUIRING).getRecordTypeId(); 
    NE__Product__c productAcqRoot = new NE__Product__c(OB_Acquirer__c='NEXI', RecordTypeId =rtProductAcqRoot, OB_Codice_sfdc__c = 'VISAMASTERCARD', Name = 'Visa/Mastercard', OB_Contract_Type__c = 'Contratto Acquiring');
    insert productAcqRoot;
    NE__OrderItem__c orderItemAcqRoot = new NE__OrderItem__c(NE__Qty__c=10 ,NE__OrderId__c=configuration.id, NE__Action__c = 'Add', NE__ProdId__c = productAcqRoot.id, NE__Service_Point__c = servicePoint.Id, NE__Account__c = myMastMerchant.Id , OB_FulfilmentStatus__c = 'Completed');
    orderItemAcqRoot.NE__AssetItemEnterpriseId__c = orderItemAcqRoot.id;
    insert orderItemAcqRoot;
    oiList.add(orderItemAcqRoot);
    //OrderItem GT
    Id rtProductGTRoot          = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.TERMINALE).getRecordTypeId(); 
    NE__Product__c productGTRoot = new NE__Product__c(RecordTypeId = rtProductGTRoot, OB_Codice_sfdc__c = 'SMPOS_CASSA', Name = 'SmartPOS Cassa', OB_Contract_Type__c = 'Contratto POS;Modulo Off Commercial', OB_Business_Model_POS__c = 'Diretto;Trilaterale Nuovo');
    insert productGTRoot;
    NE__OrderItem__c orderItemGTRoot = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__Action__c = 'Add', OB_GT__c = 'MONETICA', OB_TermId__c = '4444333221', NE__ProdId__c = productGTRoot.id, NE__Status__c = 'PENDING', OB_FulfilmentStatus__c = 'Completed');
    orderItemGTRoot.NE__AssetItemEnterpriseId__c = orderItemGTRoot.id;
    insert orderItemGTRoot;

    
    oiList.add(orderItemGTRoot);
    NE__Order_Item_Attribute__c attrGTRoot1 = new NE__Order_Item_Attribute__c();
    attrGTRoot1.Name = 'TermId';
    attrGTRoot1.NE__Order_Item__c = orderItemGTRoot.id;
    
    insert attrGTRoot1;
    NE__Order_Item_Attribute__c attrGTRoot2 = new NE__Order_Item_Attribute__c();
    attrGTRoot2.Name = 'modello';
    attrGTRoot2.NE__Order_Item__c = orderItemGTRoot.id;
    
    insert attrGTRoot2;
    NE__Order_Item_Attribute__c attrGTRoot3 = new NE__Order_Item_Attribute__c();
    attrGTRoot3.Name = 'release';
    attrGTRoot3.NE__Order_Item__c = orderItemGTRoot.id;
   
    insert attrGTRoot3;
    NE__Order_Item_Attribute__c attrGTRoot4 = new NE__Order_Item_Attribute__c();
    attrGTRoot4.Name = 'modalitaCollegamento';
    attrGTRoot4.NE__Order_Item__c = orderItemGTRoot.id;
   
    insert attrGTRoot4;
    NE__Order_Item_Attribute__c attrGTRoot5 = new NE__Order_Item_Attribute__c();
    attrGTRoot5.Name = 'descrizioneModello';
    attrGTRoot5.NE__Order_Item__c = orderItemGTRoot.id;
    
    insert attrGTRoot5;
    NE__Order_Item_Attribute__c attrGTRoot6 = new NE__Order_Item_Attribute__c();
    attrGTRoot6.Name = 'descrizioneRelease';
    attrGTRoot6.NE__Order_Item__c = orderItemGTRoot.id;
 
    insert attrGTRoot6;
    NE__Order_Item_Attribute__c attrGTRoot7 = new NE__Order_Item_Attribute__c();
    attrGTRoot7.Name = 'descrizioneConnessione';
    attrGTRoot7.NE__Order_Item__c = orderItemGTRoot.id;
  
    insert attrGTRoot7;
    NE__Order_Item_Attribute__c attrGTRoot8 = new NE__Order_Item_Attribute__c();
    attrGTRoot8.Name = 'Progressivo SIA';
    attrGTRoot8.NE__Order_Item__c = orderItemGTRoot.id;
    
    insert attrGTRoot8;
    NE__Order_Item_Attribute__c attrGTRoot9 = new NE__Order_Item_Attribute__c();
    attrGTRoot9.Name = 'Codice Stabilimento SIA';
    attrGTRoot9.NE__Order_Item__c = orderItemGTRoot.id;
   
    insert attrGTRoot9;
    NE__Order_Item_Attribute__c attrGTRoot10 = new NE__Order_Item_Attribute__c();
    attrGTRoot10.Name = 'Codice SIA';
    attrGTRoot10.NE__Order_Item__c = orderItemGTRoot.id;
    
    insert attrGTRoot10;
    Id rtProductGT           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.TERMINALE).getRecordTypeId(); 
    NE__Product__c productGT = new NE__Product__c(RecordTypeId = rtProductGT, OB_Codice_sfdc__c = 'INST', Name = 'Installazione pos', OB_Contract_Type__c = 'Installazione pos', OB_Contract_Description__c = 'Installazione pos');
    insert productGT;
    NE__OrderItem__c orderItemGT = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__Parent_Order_Item__c = orderItemGTRoot.id, NE__Action__c = 'Add', NE__ProdId__c = productGT.id , OB_FulfilmentStatus__c = 'Completed');
    orderItemGT.NE__AssetItemEnterpriseId__c= orderItemGT.id;
    insert orderItemGT;

    //Item Acquiring Child
    Id rtProductAcq           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.ACQUIRING).getRecordTypeId(); 
    NE__Product__c productAcq = new NE__Product__c(RecordTypeId = rtProductAcq, OB_Acquirer__c='NEXI', OB_Codice_sfdc__c = 'VISAMASTERCARD', Name = 'Visa/Mastercard', OB_Contract_Type__c = 'Contratto Acquiring', OB_Offer__c ='PERSONALIZZATA;START;XPAY_FULL');
    insert productAcq;
    NE__OrderItem__c orderItemAcq = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__ProdId__c = productAcq.id, NE__Action__c = 'Add', NE__Parent_Order_Item__c = orderItemGTRoot.id, OB_FulfilmentStatus__c = 'Completed'); 
    orderItemAcq.NE__AssetItemEnterpriseId__c =orderItemAcq.id;
    insert orderItemAcq;
    Id rtProductPric           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.PRICING).getRecordTypeId(); 
    NE__Product__c productPric = new NE__Product__c(RecordTypeId = rtProductPric, OB_Codice_sfdc__c = 'MAE_PRE', Name = 'MAESTRO CONSUMER PREPAID', OB_Contract_Type__c = 'Contratto Acquiring');
    insert productPric;
    NE__OrderItem__c orderItemPric = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__ProdId__c = productPric.id, NE__Action__c = 'Add', NE__Parent_Order_Item__c = orderItemAcq.id, OB_FulfilmentStatus__c = 'Completed'); 
    orderItemPric.NE__AssetItemEnterpriseId__c =orderItemPric.id;
    insert orderItemPric;

    //ADD ITEM TO CONFIGURATION
    Id rtProductPB    = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.PAGOBANCOMAT).getRecordTypeId(); 
        NE__Product__c productPB    = new NE__Product__c(OB_Acquirer__c=OB_EnrichOrder.NEXI, RecordTypeId =rtProductPB, OB_Codice_sfdc__c = 'PAGOBANCOMAT' );
        insert productPB;
    NE__OrderItem__c pagobancomat = New NE__OrderItem__c(NE__Qty__c=1 ,NE__OrderId__c=configuration.id, NE__Action__c = 'None', NE__ProdId__c = productPB.id, OB_FulfilmentStatus__c = 'Completed');            
        insert pagobancomat;

    Id rtProductVAS   = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.VAS).getRecordTypeId(); 
    NE__Product__c productRootVAS   = new NE__Product__c(RecordTypeId = rtProductVAS, OB_Codice_sfdc__c = 'PELLEGRINI',OB_Acquirer__c='NEXI');
        insert productRootVAS;
    NE__OrderItem__c rootVas = New NE__OrderItem__c(NE__Qty__c=1 ,NE__OrderId__c=configuration.id, NE__Action__c = 'None', OB_FulfilmentStatus__c = 'Completed');   
    rootVas.NE__AssetItemEnterpriseId__c        =rootVas.id;
        insert rootVas;
    oiList.add(rootVas);
    NE__Product__c productVAS   = new NE__Product__c(RecordTypeId = rtProductVAS, OB_Codice_sfdc__c = 'PELLEGRINI',OB_Acquirer__c='NEXI');
        insert productVAS;
    NE__OrderItem__c vas = New NE__OrderItem__c(NE__Qty__c=1 ,NE__OrderId__c=configuration.id, NE__Action__c = 'Add', OB_FulfilmentStatus__c = 'Completed');        
    vas.NE__AssetItemEnterpriseId__c    =vas.id;
        insert vas;
    oiList.add(vas);
    NE__Product__c product1    = new NE__Product__c(OB_Acquirer__c=OB_EnrichOrder.NEXI , RecordTypeId =rtProductPric );
        product1.OB_Codice_sfdc__c = 'ALB_AUTO';
        insert product1;

        NE__OrderItem__c orderItem1 = new NE__OrderItem__c();
        orderItem1.NE__Qty__c     = 1;
        orderItem1.NE__OrderId__c = configuration.id;
        orderItem1.NE__ProdId__c  = product1.id;
    orderItem1.NE__Action__c = 'Add';
    orderItem1.OB_FulfilmentStatus__c = 'Completed';
    orderItem1.NE__Parent_Order_Item__c = orderItemAcq.id;
    orderItem1.NE__Parent_Order_Item__c = orderItemAcq.id;
    orderItem1.NE__AssetItemEnterpriseId__c = orderItem1.id;
        insert orderItem1;

    //orderItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.ACQUIRING && orderItem.NE__ProdId__r.OB_Acquirer__c!=OB_EnrichOrder.NEXI
    NE__Product__c productNotNexi    = new NE__Product__c(OB_Acquirer__c='AMEX' , RecordTypeId =rtProductAcqRoot, OB_Codice_sfdc__c = 'AMEX' );
        insert productNotNexi;

    NE__OrderItem__c orderItemNotNexi = new NE__OrderItem__c();
    orderItemNotNexi.NE__Qty__c     = 1;
        orderItemNotNexi.NE__OrderId__c = configuration.id;
        orderItemNotNexi.NE__ProdId__c  = productNotNexi.id;
    orderItemNotNexi.NE__Action__c = 'None';
    orderItemNotNexi.OB_FulfilmentStatus__c = 'Completed';
    orderItemNotNexi.NE__Parent_Order_Item__c = null;
    orderItemNotNexi.OB_FulfilmentStatus__c = 'Completed';
    orderItemNotNexi.NE__AssetItemEnterpriseId__c= orderItemNotNexi.id;
        insert orderItemNotNexi;

    NE__Product__c productNotNexiPricing   = new NE__Product__c(OB_Acquirer__c='AMEX' , RecordTypeId =rtProductPric, OB_Codice_sfdc__c = 'PRICING' );
        insert productNotNexiPricing;
    NE__OrderItem__c orderItemNotNexiPric = new NE__OrderItem__c();
    orderItemNotNexiPric.NE__Qty__c     = 1;
        orderItemNotNexiPric.NE__OrderId__c = configuration.id;
        orderItemNotNexiPric.NE__ProdId__c  = productNotNexiPricing.id;
    orderItemNotNexiPric.NE__Action__c = 'None';
    orderItemNotNexiPric.OB_FulfilmentStatus__c = 'Completed';
    orderItemNotNexiPric.NE__Parent_Order_Item__c = orderItemNotNexi.id;
    orderItemNotNexiPric.NE__AssetItemEnterpriseId__c= orderItemNotNexiPric.id;
        insert orderItemNotNexiPric;
    
    
    //ASSET
    Asset asset = new Asset(NE__AssetItemEnterpriseId__c = orderItemGTRoot.Id, OB_ShopCode__c = 'shopCode', OB_GT__c = 'GT', OB_CustomerCode__c = 'customerCode', Name = 'SmartPOS');
    insert asset;
    NE__AssetItemAttribute__c attr1 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.TERMID, NE__Asset__c = asset.id);
    insert attr1;
    NE__AssetItemAttribute__c attr2 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.MODELLO, NE__Asset__c = asset.id);
    insert attr2;
    NE__AssetItemAttribute__c attr3 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.RELEASE, NE__Asset__c = asset.id);
    insert attr3;
    NE__AssetItemAttribute__c attr4 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.MODCOLLEGAMENTO, NE__Asset__c = asset.id);
    insert attr4;
    NE__AssetItemAttribute__c attr5 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.DMODELLO, NE__Asset__c = asset.id);
    insert attr5;
    NE__AssetItemAttribute__c attr6 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.DRELEASE, NE__Asset__c = asset.id);
    insert attr6;
    NE__AssetItemAttribute__c attr7 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.DCONNESSIONE, NE__Asset__c = asset.id);
    insert attr7;
    NE__AssetItemAttribute__c attr8 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.PROGRESSIVOSIA, NE__Asset__c = asset.id);
    insert attr8;
    NE__AssetItemAttribute__c attr9 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.CODICESTABILIMENTOSIA, NE__Asset__c = asset.id);
    insert attr9;
    NE__AssetItemAttribute__c attr10 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.CODICESIA, NE__Asset__c = asset.id);
    insert attr10;

    //LOV
    NE__Lov__c lovMCC2 = new NE__Lov__c();
    lovMCC2.NE__Type__c   = 'mcc';
    lovMCC2.NE__Value3__c = 'L2';
    lovMCC2.OB_Value4__c  = configuration.OB_MCCL2__c;
    lovMCC2.NE__Value2__c = configuration.OB_MCCL2__c;
    insert lovMCC2;
    System.debug('@@@lovMCC2 '+lovMCC2);
    NE__Lov__c lov = new NE__Lov__c();
    lov.NE__Type__c     ='TRACKING';
    lov.NE__Sub_Type__c = 'TIPOLOGICHE';
    lov.NE__Value2__c   = 'DINERS';
    lov.NE__Value1__c   = '12';
    insert lov;

    OB_TrackingUtility.ErrorList error1 = new OB_TrackingUtility.ErrorList();

     List<OB_TrackingUtility.ErrorList> errorsList1 = new List<OB_TrackingUtility.ErrorList>();
      OB_TrackingUtility.ErrorList error2 = new OB_TrackingUtility.ErrorList();
    error2.code = '';
    error2.description = '';

    
   

    List<OB_TrackingUtility.ErrorList> errorsList2 = new List<OB_TrackingUtility.ErrorList>();
    errorsList2.add(error2);
    

    OB_TrackingUtility.Changes change = new OB_TrackingUtility.Changes();
    change.externalId = rootVas.id; //TERMINALE
    change.result = '';
    change.errors = null; //List

   
  
    List<OB_TrackingUtility.Changes> changesList = new List<OB_TrackingUtility.Changes>();
    changesList.add(change);

    
    
    OB_TrackingUtility.CodiciConvenzioni codConv = new OB_TrackingUtility.CodiciConvenzioni();
    codConv.companyCode = 'companyCode';
    codConv.companyName = 'companyName';                                
    codConv.code        = 'code';                                       
    codConv.causaleRifiuto ='causaleRifiuto';
    codConv.startDate = '2011-11-13';
    codConv.endDate = '';
    codConv.status  = 'Active';

    List<OB_TrackingUtility.CodiciConvenzioni> codConvList = new List<OB_TrackingUtility.CodiciConvenzioni>();
    codConvList.add(codConv);

    OB_TrackingUtility.TermsIdInformation termInfo = new OB_TrackingUtility.TermsIdInformation();    
    termInfo.terminalId = orderItemGTRoot.OB_TermId__c;
    termInfo.model = 'model';
    termInfo.connectionType = 'connectionType';
    termInfo.modality = 'modality';
    termInfo.modelDescription = 'modelDescription';
    termInfo.release = 'release';
    termInfo.releaseDescription = 'releaseDescription';
    termInfo.status = 'Pending';
    termInfo.reasonOfRejection = '';
    termInfo.installationDate = '2011-11-13';
    termInfo.uninstallationDate = '';
    termInfo.agreementCodes = codConvList; //List
    termInfo.errors = null; //List

    List<OB_TrackingUtility.TermsIdInformation> termsInfoList = new List<OB_TrackingUtility.TermsIdInformation>();
    termsInfoList.add(termInfo);

    OB_TrackingUtility.ErrorList error = new OB_TrackingUtility.ErrorList();
    error.code = '';
    error.description = '';

    
   

    List<OB_TrackingUtility.ErrorList> errorsList = new List<OB_TrackingUtility.ErrorList>();
    errorsList.add(error);
   

    OB_TrackingUtility.puntoVendita pV = new OB_TrackingUtility.puntoVendita();
    //pV.itemId = '';
    pV.PVCode = servicePoint.id;
    pV.startDate = '2011-11-13';
    pV.endDate = '';
    pV.reasonOfClosure = '';
    //pV.tipo = '';
    pV.ctiCode = 'ctiCode';
    //NEXI Kinga Fornal, kinga.fornal@accenture.com,  08.08.20119 test fix START
    pV.StabiCode = 'StabiCode';
    pV.siaPVCode = 'pVCode';
    pV.siaProgressiveCode = 'progCode';
    pV.siaMerchantCode = 'merchCode';
    pV.assistanceNumber = 'assistanceNumber';
    //pV.dataInizioAttivita = '2011-11-13';
    pv.terminalInformation = termsInfoList; //List
    pv.changes = changesList;

    List<OB_TrackingUtility.puntoVendita> pVList = new List<OB_TrackingUtility.puntoVendita>();
    pVList.add(pV);

    OB_TrackingUtility.GT gT = new OB_TrackingUtility.GT();
    gT.source = 'MONETICA';
    gT.gtCompanyCode = 'companyCode';
    gT.errors = errorsList; //List
    gT.PVCodes = pVList; //List
    //gT.statoProvisioning = '';

    List<OB_TrackingUtility.GT> gTList = new List<OB_TrackingUtility.GT>();
    gTList.add(gT);

    OB_TrackingUtility.Acquiring acquiring = new OB_TrackingUtility.Acquiring();
    acquiring.source = 'NEXI';
    acquiring.companyCode = 'companyCode';
    acquiring.errori = null;
    acquiring.PVCodes = pVList;

    List<OB_TrackingUtility.Acquiring> acquiringList = new List<OB_TrackingUtility.Acquiring>();
    acquiringList.add(acquiring);

    OB_TrackingUtility.TrackingOrderRequestMaintenance trackingOrderRequest = new OB_TrackingUtility.TrackingOrderRequestMaintenance();
    trackingOrderRequest.orderId = configuration.id;
    trackingOrderRequest.Acquiring = acquiringList;
    trackingOrderRequest.GT = gTList;

    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();
    req.requestURI = '/TrackingOrderMaintenance/*'; 
    req.httpMethod = 'POST';
    RestContext.request = req;
    String json = JSON.serialize(trackingOrderRequest);
    RestContext.request.requestBody =  Blob.valueof(json);
    RestContext.response = res;

    List<OB_LogRequest__c> listLog = new List<OB_LogRequest__c>();
    OB_LogRequest__c log = OB_TestDataFactory.getLogRequest();
    insert log;
    OB_LogRequest__c log1 = OB_TestDataFactory.getLogRequest();
    insert log1;
    listLog.add(log);
     listLog.add(log1);
    Test.startTest();
    OB_TrackingUtility.TrackingOrderResponseMaintenance response = OB_TrackingOrderMaintenance.trackOrderMaintenance();
    // OB_TrackingOrderMaintenance.isAcquiringVas(acquiringList);
    // OB_TrackingOrderMaintenance.isAcquiringTerminal(acquiringList, true);
    // OB_TrackingOrderMaintenance.isAcquiringTerminal(acquiringList, false);
    // OB_TrackingOrderMaintenance.updateLogRequest(configuration.id);
    //OB_TrackingUtility.updateVasItems(oiList,changesList,'','','','',listLog);
    System.assertEquals( 500, response.httpStatus);
    Test.stopTest();
    }

@isTest
public static void updateAssetItemAttribute_Test(){

Set<Id> assetId= new Set<id>();
Id productRT         = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.TERMINALE).getRecordTypeId(); 
    NE__Product__c product = new NE__Product__c(RecordTypeId = productRT, OB_Codice_sfdc__c = 'SMPOS_CASSA', Name = 'SmartPOS Cassa', OB_Contract_Type__c = 'Contratto POS;Modulo Off Commercial', OB_Business_Model_POS__c = 'Diretto;Trilaterale Nuovo');
    insert product;

    NE__Order_Header__c OH = OB_TestDataFactory.getOrderHeader();
    insert OH;

    NE__Order__c order = OB_TestDataFactory.getOrder();
    insert order;

    NE__OrderItem__c oi = OB_TestDataFactory.getOrderItem(order.id);
    insert oi;

    

 Asset asset = new Asset(NE__ProdId__c=product.id, OB_ShopCode__c = 'shopCode', OB_GT__c = 'GT', OB_CustomerCode__c = 'customerCode', Name = 'SmartPOS');
    insert asset;



    NE__AssetItemAttribute__c attr2 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.MODELLO, NE__Asset__c = asset.id);
    insert attr2;
    NE__AssetItemAttribute__c attr3 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.RELEASE, NE__Asset__c = asset.id);
    insert attr3;
    NE__AssetItemAttribute__c attr5 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.DMODELLO, NE__Asset__c = asset.id);
    insert attr5;
    NE__AssetItemAttribute__c attr6 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.DRELEASE, NE__Asset__c = asset.id);
    insert attr6;
    NE__AssetItemAttribute__c attr7 = new NE__AssetItemAttribute__c(Name = OB_TrackingOrderMaintenance.DCONNESSIONE, NE__Asset__c = asset.id);
    insert attr7;
    

assetId.add(asset.id);
Test.startTest();
   OB_TrackingOrderMaintenance.updateAssetItemAttribute(assetId,'','','','','','');
   List<NE__OrderItem__c> listOi = [SELECT OB_isNotIntegrated__c from NE__OrderItem__c where NE__OrderId__c = : order.Id];
    System.assertEquals(false, listOi.get(0).OB_isNotIntegrated__c);
    
    Test.stopTest();

   

    //Finish Noemi Infantino



}







}