@isTest
public class OB_TrackingOrder_Test {

    @isTest
    public static void trackOrderTest()
    {
         RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        // req.requestURI = '/services/apexrest/abc/xyz/';
        // req.httpMethod  = 'POST';
        RestContext.response = res;
        RestContext.request = req;
        try{
          Test.startTest();
            OB_Trackingorder.trackOrder();
            Test.stopTest();
        } catch(Exception e)
        {
           system.debug(e);
        }
    }

    //questo test non manda il metodo in eccezione se la riga:
    //request = (OB_TrackingOrder.TrackingOrderRequest)JSON.deserializeUntyped(req);
    //viene sostituita con la riga
    //request = (OB_TrackingOrder.TrackingOrderRequest)JSON.deserialize(req,OB_TrackingOrder.TrackingOrderRequest.class);

    @isTest
    public static void test_constructors()
    {
        Test.startTest();
        //String codiciConvenzioniString = '{ "idItemSalesforce": "test", "dataInizio": "test", "dataFine": "test", "companyName": "test", "companyCode": "test", "codiceConvenzione": "test", "causaleRifiuto": "test" }';
        //OB_TrackingOrder.CodiciConvenzioni codiciConvenzioniObject = (OB_TrackingOrder.CodiciConvenzioni)JSON.deserialize(codiciConvenzioniString, OB_TrackingOrder.CodiciConvenzioni.class);
        OB_TrackingOrder.CodiciConvenzioni codiciConvenzioniObject = new OB_TrackingOrder.CodiciConvenzioni();
        codiciConvenzioniObject.idItemSalesforce = 'test';
        codiciConvenzioniObject.companyCode = 'test';
        codiciConvenzioniObject.companyName = 'test';
        codiciConvenzioniObject.codiceConvenzione = 'test';
        codiciConvenzioniObject.causaleRifiuto = 'test';
        codiciConvenzioniObject.dataInizio = 'test';
        codiciConvenzioniObject.dataFine = 'test';


/*#############################################    AV   ##################################################*/
        OB_TrackingOrder.TermsIdInformation TermsIdInfo = new OB_TrackingOrder.TermsIdInformation();
        //TermsIdInfo.termId = 'test';
        TermsIdInfo.modello = 'test';
        TermsIdInfo.release = 'test';
        TermsIdInfo.modalitaCollegamento = 'test';
        TermsIdInfo.descrizioneModello = 'test';
        TermsIdInfo.descrizioneRelease = 'test';
        TermsIdInfo.descrizioneConnessione = 'test';
        TermsIdInfo.statoInstallazione = 'test';
        TermsIdInfo.causaleRifiuto = 'test';
        TermsIdInfo.dataInstallazione = 'test';
        TermsIdInfo.dataDisinstallazione = 'test';



/*#############################################    AV   ##################################################*/


        Test.stopTest();
    }


        @isTest
        public static void test_constructors_2()
        {
            Test.startTest();
            OB_TrackingOrder.Acquiring acquiring      = new OB_TrackingOrder.Acquiring();
            OB_TrackingOrder.GT gt                    = new OB_TrackingOrder.GT();
            OB_TrackingOrder.puntoVendita puntVendita = new OB_TrackingOrder.puntoVendita();
            OB_TrackingOrder.ErrorList    errorList   = new OB_TrackingOrder.ErrorList();
            puntVendita.causaleCessazione     = 'test';
            //puntVendita.numeroVerde           = 'test';
            puntVendita.dataInizioAttivita    = '2018-01-01';
            puntVendita.codiceStabilimentoSIA = 'test';
            puntVendita.codiceProgressivoSIA  ='test';
            puntVendita.codiceSIA             = 'test';
            gt.statoProvisioning              = 'test';
            errorList.codice                  = 'test';
            errorList.descrizione             = 'test';
            Test.stopTest();
        }

	//METHOD FOR ACQUIRING IF
	@isTest
	public static void getTrackingOrderTest(){

        List<Account> accList = new List<Account>();
        Id rtMerchant           = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId();
        Account myMastMerchant  = new Account(  Name='TEST',
                                                RecordTypeId=rtMerchant,
                                                OB_Employees_Number__c='Minore di 10',
                                                OB_VAT_Not_Present__c=true,
                                                OB_DescriptionVATNotPresent__c='description',
                                                NE__Fiscal_code__c='RSSMRA80A01F205X',
                                                OB_BypassValidation__c=true,
                                                OB_Status__c='Active');

        Id accountBankRecordId          = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Bank').getRecordTypeId();
        Account bankAccount     = new Account(  Name='TEST',
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
        NE__Billing_Profile__c billProf = new NE__Billing_Profile__c();
        String iban = 'IT26D0511611703000000002340';
        billProf.NE__Iban__c = iban;
        billProf.OB_ABICode__c = '05116';
        billProf.OB_CABCode__c = '11703';
        billProf.OB_CINCode__c = 'D';
        billProf.OB_Bank_Account_Number__c  = '000000002340';
        billProf.OB_EuroControlCode__c  = '26';
        billProf.OB_CountryCode__c = 'IT';
        billProf.OB_BypassValidation__c = false;
        billProf.NE__Account__c = myMastMerchant.Id;
        insert billProf;

        NE__Service_Point__c servicePoint1 = new NE__Service_Point__c();
        insert servicePoint1;
        NE__Order_Header__c orderHeader = new NE__Order_Header__c(OB_ProposerABI__c=bankAccount.Id ,NE__AccountId__c=myMastMerchant.Id, OB_Main_Process__c = 'Setup' );
        insert orderHeader;
        System.debug('ORDER HEADER: ' +orderHeader );
        NE__Order__c configuration = new NE__Order__c(NE__AccountId__c=myMastMerchant.Id ,OB_Service_Point__c = servicePoint1.Id,NE__Order_Header__c=orderHeader.Id, OB_MCCL2__c = 'test');
        insert configuration;

        Id rtProductGTRoot   = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.TERMINALE).getRecordTypeId(); 
        NE__Product__c productGTRoot = new NE__Product__c(RecordTypeId = rtProductGTRoot, OB_Codice_sfdc__c = 'SMPOS_CASSA', Name = 'SmartPOS Cassa', OB_Contract_Type__c = 'Contratto POS;Modulo Off Commercial', OB_Business_Model_POS__c = 'Diretto;Trilaterale Nuovo');
        insert productGTRoot;
        NE__OrderItem__c orderItemGTRoot = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__Action__c = 'Add', OB_GT__c = 'MONETICA', OB_TermId__c = '21021990', NE__ProdId__c = productGTRoot.id, NE__Status__c = 'PENDING', OB_FulfilmentStatus__c = 'Pending', OB_Tech_Outcome_Monetica__c = 'OK');
        insert orderItemGTRoot;

        OB_TrackingOrder.TrackingOrderRequest requestTracking   = new OB_TrackingOrder.TrackingOrderRequest();

        NE__OrderItem__c orderItem = New NE__OrderItem__c(NE__Qty__c=10 ,NE__OrderId__c=configuration.id);

        insert orderItem;



        /*#############################################    AV   ##################################################*/

        NE__Order_Item_Attribute__c attr1 = new NE__Order_Item_Attribute__c();
        attr1.Name = 'TermId';
        attr1.NE__Order_Item__c = orderItem.id;
        insert attr1;
        NE__Order_Item_Attribute__c attr2 = new NE__Order_Item_Attribute__c();
        attr2.Name = 'modello';
        attr2.NE__Order_Item__c = orderItem.id;
        insert attr2;
        NE__Order_Item_Attribute__c attr3 = new NE__Order_Item_Attribute__c();
        attr3.Name = 'release';
        attr3.NE__Order_Item__c = orderItem.id;
        insert attr3;
        NE__Order_Item_Attribute__c attr4 = new NE__Order_Item_Attribute__c();
        attr4.Name = 'modalitaCollegamento';
        attr4.NE__Order_Item__c = orderItem.id;
        insert attr4;
        NE__Order_Item_Attribute__c attr5 = new NE__Order_Item_Attribute__c();
        attr5.Name = 'descrizioneModello';
        attr5.NE__Order_Item__c = orderItem.id;
        insert attr5;
        NE__Order_Item_Attribute__c attr6 = new NE__Order_Item_Attribute__c();
        attr6.Name = 'descrizioneRelease';
        attr6.NE__Order_Item__c = orderItem.id;
        insert attr6;
        NE__Order_Item_Attribute__c attr7 = new NE__Order_Item_Attribute__c();
        attr7.Name = 'descrizioneConnessione';
        attr7.NE__Order_Item__c = orderItem.id;
        insert attr7;
        NE__Order_Item_Attribute__c attr8 = new NE__Order_Item_Attribute__c();
        attr8.Name = 'Progressivo SIA';
        attr8.NE__Order_Item__c = orderItem.id;
        insert attr8;
        NE__Order_Item_Attribute__c attr9 = new NE__Order_Item_Attribute__c();
        attr9.Name = 'Codice Stabilimento SIA';
        attr9.NE__Order_Item__c = orderItem.id;
        insert attr9;
        NE__Order_Item_Attribute__c attr10 = new NE__Order_Item_Attribute__c();
        attr10.Name = 'Codice SIA';
        attr10.NE__Order_Item__c = orderItem.id;
        insert attr10;

        /*#############################################    AV   ##################################################*/


        OB_Bank_Profile__c bp = new OB_Bank_Profile__c();
        bp.OB_Bank__c=bankAccount.Id;
        bp.OB_Service_Type__c = 'Acquiring';
        bp.OB_Business_Model_POS__c = 'Bilaterale';
        bp.OB_Circuit__c = 'JCB';
        bp.OB_Other_Acquirer__c = 'Amex';
        bp.OB_Applicant_RAC_Code_SIA__c = 'Banca';
        bp.OB_Terminal_Id_Generator__c = 'Banca';
        bp.OB_Technical_component_invoicing__c = 'TecMarket(servizio fatturazione per conto terzi)';
        bp.OB_GT__c = 'Nexi';
        bp.OB_Processor__c = 'SIA SMAC';
        bp.OB_Bilateral_Pricing__c = 'SI';
        bp.OB_Sending_Contract_to_Nexi__c = 'SI';
        bp.OB_SME_Factory__c = 'SI';
        insert bp;

        Datetime dataInizio = Datetime.newInstance(1960, 2, 17);
        Datetime dataCessazione = Datetime.newInstance(1962, 2, 17);
        String request = '{"idOrdineSfdc": "'+configuration.id+'","Acquiring": [{"sistemaSorgente": "EQUENS","codiceSocieta": "1114558","puntiVendita": [{"itemId": "'+orderItem.Id+'","codicePuntoVendita": "3249896","dataInizio": "2011-11-13","dataCessazione": "2011-11-14","causaleCessazione": "","tipo": ""}],"errori": []}]}';
        requestTracking = (OB_TrackingOrder.TrackingOrderRequest)JSON.deserialize(request, OB_TrackingOrder.TrackingOrderRequest.class);

        RestContext.request = new RestRequest();
        RestContext.request.requestBody =  Blob.valueof(request);
        RestContext.response   = new RestResponse();
        Id rtProduct           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.ACQUIRING).getRecordTypeId();
        NE__Product__c product = new NE__Product__c(OB_Acquirer__c=OB_EnrichOrder.NEXI , RecordTypeId =rtProduct );
        product.OB_Codice_sfdc__c = OB_EnrichOrder.ALBERGIAUTONOLEGGI;
        insert product;

        /*#############################################    DD 23/01/2019   DEBUT ##################################################*/

        Id rtProduct1              = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.PAGOBANCOMAT).getRecordTypeId();
        NE__Product__c product1    = new NE__Product__c(OB_Acquirer__c = OB_EnrichOrder.NEXI , RecordTypeId = rtProduct1 );
        product1.OB_Codice_sfdc__c = OB_EnrichOrder.MOTO;
        insert product1;

        Id rtProduct2              = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.VAS).getRecordTypeId();
        NE__Product__c product2    = new NE__Product__c(OB_Acquirer__c = OB_EnrichOrder.NEXI , RecordTypeId = rtProduct2 );
        product1.OB_Codice_sfdc__c = OB_EnrichOrder.ALBERGIAUTONOLEGGI;
        insert product2;

        //OB_EnrichOrder.COMMISSIONE
        Id rtProduct3              = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.COMMISSIONE).getRecordTypeId();
        NE__Product__c product3    = new NE__Product__c(OB_Acquirer__c = OB_EnrichOrder.NEXI , RecordTypeId = rtProduct3 );
        product1.OB_Codice_sfdc__c = OB_EnrichOrder.MOTO;
        insert product3;


        NE__OrderItem__c orderItem1 = new NE__OrderItem__c();
        orderItem1.NE__Qty__c       = 10 ;
        orderItem1.NE__OrderId__c   = configuration.id;
        orderItem1.NE__ProdId__c    = product1.id;
        insert orderItem1;

        NE__OrderItem__c orderItem2 = new NE__OrderItem__c();
        orderItem2.NE__Qty__c       = 10 ;
        orderItem2.NE__OrderId__c   = configuration.id;
        orderItem2.NE__ProdId__c    = product2.id;
        insert orderItem2;

        NE__OrderItem__c orderItem3 = new NE__OrderItem__c();
        orderItem3.NE__Qty__c       = 10 ;
        orderItem3.NE__OrderId__c   = configuration.id;
        orderItem3.NE__ProdId__c    = product3.id;
        insert orderItem3;


        /*#############################################    DD 23/01/2019   FIN ##################################################*/

        orderItem.NE__OrderId__c    = requestTracking.idOrdineSfdc ;
        orderItem.OB_TermId__c      = '123456';//text field
        orderItem.OB_Terminal_Id__c = '123456';
        orderItem.NE__ProdId__c     = product.Id;
        orderItem.OB_Processor__c   = requestTracking.Acquiring[0].sistemaSorgente;

        update orderItem;

        //---------------------------- DD     ---------------------------//

        List<NE__OrderItem__c> orderItems = new List<NE__OrderItem__c> ();
        orderItems.add(orderItem1);
        orderItems.add(orderItem);
        orderItems.add(orderItem2);
        orderItems.add(orderItem3);

        //---------------------------- DD Fin ---------------------------//

        List<ExternalSourceMapping__c> extList = new List<ExternalSourceMapping__c>();
        NE__Service_Point__c servicePoint2     = new NE__Service_Point__c();
        insert servicePoint2;

        ExternalSourceMapping__c ext3 = new ExternalSourceMapping__c(   OB_Merchant_ID__c = configuration.NE__AccountId__c,
                                                                        OB_Service_Point_ID__c = servicePoint2.Id,
                                                                        OB_CustomerCodeClientCode__c = 'TEST'  );
        Account accExt  = new Account(  Name='TEST',
                                                RecordTypeId=rtMerchant,
                                                OB_Employees_Number__c='Minore di 10',
                                                OB_VAT_Not_Present__c=true,
                                                OB_DescriptionVATNotPresent__c='description',
                                                NE__Fiscal_code__c='RSSMRA80A01F205X',
                                                OB_BypassValidation__c=true,
                                                OB_Status__c='Active');
        insert accExt;
        ExternalSourceMapping__c ext2 = new ExternalSourceMapping__c(   OB_Merchant_ID__c=accExt.Id,
            OB_Service_Point_ID__c=servicePoint2.Id ,
             OB_CustomerCodeClientCode__c='TEST' );
        extList.add(ext2);
        extList.add(ext3);
        insert extList;
        System.debug('EXTERNAL LIST: '     + extList);
        System.debug('REQUEST ACQUIRING: ' + requestTracking.Acquiring);


        NE__Lov__c lovMCC2 = new NE__Lov__c();
        lovMCC2.ne__type__c   = 'mcc';
        lovMCC2.NE__Value3__c = 'L2';
        lovMCC2.OB_Value4__c  = configuration.OB_MCCL2__c;
        insert lovMCC2;

        NE__Lov__c lov = new NE__Lov__c();
        lov.NE__Type__c     ='TRACKING';
        lov.NE__Sub_Type__c = 'TIPOLOGICHE';
        lov.NE__Value2__c   = 'DINERS';
        lov.NE__Value1__c   = '12';
        insert lov;

		list<NE__Lov__c> lovs = new List<NE__Lov__c>();
		lovs.add(lovMCC2);
		lovs.add(lov);

		OB_Integration_Configuration__c integrationConfig = new OB_Integration_Configuration__c();
		integrationConfig.OB_Token_1__c = '';
		integrationConfig.Name = 'DEV1';
		integrationConfig.OB_timestamp__c = '300000';
		insert integrationConfig;


  //Create a new OB_TrackingOrder.CodiciConvenzioni for GT and for Acquiring

        OB_TrackingOrder.CodiciConvenzioni ccGT = new OB_TrackingOrder.CodiciConvenzioni();
        ccGT.idItemSalesforce = 'idItemSalesforceValueGT';
        ccGT.companyCode = 'companyCodeValueGT';
        ccGT.companyName = 'companyNameValueGT';
        ccGT.codiceConvenzione = 'codiceConvenzioneValueGT';
        ccGT.causaleRifiuto = 'causaleRifiutoValueGT';
        ccGT.dataInizio = 'dataInizioValueGT';
        ccGT.dataFine = 'dataFineValueGT';
        List<OB_TrackingOrder.CodiciConvenzioni> ccGTList = new List<OB_TrackingOrder.CodiciConvenzioni>();
        ccGTList.add(ccGT);

        OB_TrackingOrder.CodiciConvenzioni ccAcquiring = new OB_TrackingOrder.CodiciConvenzioni();
        ccAcquiring.idItemSalesforce = 'idItemSalesforceValueAcquiring';
        ccAcquiring.companyCode = 'companyCodeValueAcquiring';
        ccAcquiring.companyName = 'companyNameValueAcquiring';
        ccAcquiring.codiceConvenzione = 'codiceConvenzioneValueAcquiring';
        ccAcquiring.causaleRifiuto = 'causaleRifiutoValueAcquiring';
        ccAcquiring.dataInizio = 'dataInizioValueAcquiring';
        ccAcquiring.dataFine = 'dataFineValueAcquiring';
        List<OB_TrackingOrder.CodiciConvenzioni> ccAcquiringList = new List<OB_TrackingOrder.CodiciConvenzioni>();
        ccAcquiringList.add(ccAcquiring);

        OB_TrackingOrder.TermsIdInformation tiiGT = new OB_TrackingOrder.TermsIdInformation();
        tiiGT.termId = 'OB_TermId__c';
        tiiGT.modello = 'modelloValueGT';
        tiiGT.release = 'releaseValueGT';
        tiiGT.modalitaCollegamento = 'modalitaCollegamentoValueGT';
        tiiGT.descrizioneModello = 'descrizioneModelloValueGT';
        tiiGT.descrizioneRelease = 'descrizioneReleaseValueGT';
        tiiGT.descrizioneConnessione = 'descrizioneConnessioneValueGT';
        tiiGT.statoInstallazione = 'statoInstallazioneValueGT';
        tiiGT.causaleRifiuto = 'statoInstallazioneValueGT';
        tiiGT.dataInstallazione = 'dataInstallazioneValueGT';
        tiiGT.dataDisinstallazione = 'dataDisinstallazioneValueGT';
        tiiGT.codiciconvenzioni = ccGTList;
        List<OB_TrackingOrder.TermsIdInformation> tiiGTList = new List<OB_TrackingOrder.TermsIdInformation>();
        tiiGTList.add(tiiGT);

        OB_TrackingOrder.TermsIdInformation tiiAcquiring = new OB_TrackingOrder.TermsIdInformation();
        tiiAcquiring.termId = 'OB_TermId__c';
        tiiAcquiring.modello = 'modelloValueAcquiring';
        tiiAcquiring.release = 'releaseValueAcquiring';
        tiiAcquiring.modalitaCollegamento = 'modalitaCollegamentoValueAcquiring';
        tiiAcquiring.descrizioneModello = 'descrizioneModelloValueAcquiring';
        tiiAcquiring.descrizioneRelease = 'descrizioneReleaseValueAcquiring';
        tiiAcquiring.descrizioneConnessione = 'descrizioneConnessioneValueAcquiring';
        tiiAcquiring.statoInstallazione = 'statoInstallazioneValueAcquiring';
        tiiAcquiring.causaleRifiuto = 'statoInstallazioneValueAcquiring';
        tiiAcquiring.dataInstallazione = 'dataInstallazioneValueAcquiring';
        tiiAcquiring.dataDisinstallazione = 'dataDisinstallazioneValueAcquiring';
        tiiAcquiring.codiciconvenzioni = ccAcquiringList;
        List<OB_TrackingOrder.TermsIdInformation> tiiAcquiringList = new List<OB_TrackingOrder.TermsIdInformation>();
        tiiAcquiringList.add(tiiAcquiring);

        /*OB_TrackingOrder.ErrorList erroriGT = new OB_TrackingOrder.ErrorList();
        erroriGT.codice = 'codiceValueGT';
        erroriGT.descrizione = 'descrizioneValueGT';
        List<OB_TrackingOrder.ErrorList> erroriGTList = new List<OB_TrackingOrder.ErrorList>();
        erroriGTList.add(erroriGT);

        OB_TrackingOrder.ErrorList erroriAcquiring = new OB_TrackingOrder.ErrorList();
        erroriAcquiring.codice = 'codiceValueAcquiring';
        erroriAcquiring.descrizione = 'descrizioneValueAcquiring';
        List<OB_TrackingOrder.ErrorList> erroriAcquiringList = new List<OB_TrackingOrder.ErrorList>();
        erroriAcquiringList.add(erroriAcquiring);*/

        OB_TrackingOrder.puntoVendita pvGT = new OB_TrackingOrder.puntoVendita();
        pvGT.itemId = 'itemIdValueGT';
        pvGT.codicePuntoVendita = 'codicePuntoVenditaValueGT';
        pvGT.dataInizio = 'dataInizioValueGT';
        pvGT.dataCessazione = 'dataCessazioneValueGT';
        pvGT.causaleCessazione = 'causaleCessazioneValueGT';
        pvGT.tipo = 'Fisico';
        pvGT.codiceCTI = 'codiceCTIValueGT';
        pvGT.codiceStabilimento = 'codiceStabilimentoValueGT';
        pvGT.codiceStabilimentoSIA = 'codiceStabilimentoSIAValueGT';
        pvGT.codiceProgressivoSIA = 'codiceProgressivoSIAValueGT';
        pvGT.codiceSIA = 'codiceSIAValueGT';
        pvGT.numeroAssistenzaPOS = 'numeroAssistenzaPOSValueGT';
        pvGT.dataInizioAttivita = 'dataInizioAttivitaValueGT';
        pvGT.termsIdInformations = tiiGTList;
        List<OB_TrackingOrder.puntoVendita> pvGTList = new List<OB_TrackingOrder.puntoVendita>();
        pvGTList.add(pvGT);

        OB_TrackingOrder.puntoVendita pvAcquiring = new OB_TrackingOrder.puntoVendita();
        pvAcquiring.itemId = 'itemIdValueAcquiring';
        pvAcquiring.codicePuntoVendita = 'codicePuntoVenditaValueAcquiring';
        pvAcquiring.dataInizio = 'dataInizioValueAcquiring';
        pvAcquiring.dataCessazione = 'dataCessazioneValueAcquiring';
        pvAcquiring.causaleCessazione = 'causaleCessazioneValueAcquiring';
        pvAcquiring.tipo = 'Fisico';
        pvAcquiring.codiceCTI = 'codiceCTIValueAcquiring';
        pvAcquiring.codiceStabilimento = 'codiceStabilimentoValueAcquiring';
        pvAcquiring.codiceStabilimentoSIA = 'codiceStabilimentoSIAValueAcquiring';
        pvAcquiring.codiceProgressivoSIA = 'codiceProgressivoSIAValueAcquiring';
        pvAcquiring.codiceSIA = 'codiceSIAValueAcquiring';
        pvAcquiring.numeroAssistenzaPOS = 'numeroAssistenzaPOSValueAcquiring';
        pvAcquiring.dataInizioAttivita = 'dataInizioAttivitaValueAcquiring';
        pvAcquiring.termsIdInformations = tiiAcquiringList;
        List<OB_TrackingOrder.puntoVendita> pvAcquiringList = new List<OB_TrackingOrder.puntoVendita>();
        pvAcquiringList.add(pvAcquiring);


        OB_TrackingOrder.puntoVendita pvAcquiringEcommerce = new OB_TrackingOrder.puntoVendita();
        pvAcquiringEcommerce.itemId = 'itemIdValueAcquiring';
        pvAcquiringEcommerce.codicePuntoVendita = 'codicePuntoVenditaValueAcquiring';
        pvAcquiringEcommerce.dataInizio = 'dataInizioValueAcquiring';
        pvAcquiringEcommerce.dataCessazione = 'dataCessazioneValueAcquiring';
        pvAcquiringEcommerce.causaleCessazione = 'causaleCessazioneValueAcquiring';
        pvAcquiringEcommerce.tipo = 'MOTO';
        pvAcquiringEcommerce.codiceCTI = 'codiceCTIValueAcquiring';
        pvAcquiringEcommerce.codiceStabilimento = 'codiceStabilimentoValueAcquiring';
        pvAcquiringEcommerce.codiceStabilimentoSIA = 'codiceStabilimentoSIAValueAcquiring';
        pvAcquiringEcommerce.codiceProgressivoSIA = 'codiceProgressivoSIAValueAcquiring';
        pvAcquiringEcommerce.codiceSIA = 'codiceSIAValueAcquiring';
        pvAcquiringEcommerce.numeroAssistenzaPOS = 'numeroAssistenzaPOSValueAcquiring';
        pvAcquiringEcommerce.dataInizioAttivita = 'dataInizioAttivitaValueAcquiring';
        pvAcquiringEcommerce.termsIdInformations = tiiAcquiringList;
        pvAcquiringList.add(pvAcquiringEcommerce);


        OB_TrackingOrder.GT gt = new OB_TrackingOrder.GT();
        gt.sistemaSorgente = 'sistemaSorgenteValueGT';
        gt.statoProvisioning = 'statoProvisioningValueGT';
        gt.codiceCliente = 'codiceClienteValueGT';
        gt.errori = null;
        gt.puntiVendita = pvGTList;
        List<OB_TrackingOrder.GT> gtList = new List<OB_TrackingOrder.GT>();
        gtList.add(gt);

        OB_TrackingOrder.Acquiring acquiring = new OB_TrackingOrder.Acquiring();
        acquiring.sistemaSorgente = 'sistemaSorgenteValueAcquiring';
        acquiring.codiceSocieta = 'codiceSocietaValueAcquiring';
        acquiring.errori = null;
        acquiring.puntiVendita = pvAcquiringList;
        List<OB_TrackingOrder.Acquiring> acquiringList = new List<OB_TrackingOrder.Acquiring>();
        acquiringList.add(acquiring);

        OB_TrackingOrder.TrackingOrderRequest tor = new OB_TrackingOrder.TrackingOrderRequest();
        tor.idOrdineSfdc = configuration.id;
        tor.Acquiring = acquiringList;
        tor.GT = gtList;




		Test.startTest();
            OB_TrackingOrder.TrackingOrderResponse response =  OB_TrackingOrder.getTrackingOrder(requestTracking);
            OB_TrackingOrder.TrackingOrderResponse  expectedResponse = new   OB_TrackingOrder.TrackingOrderResponse();
            Integer status = 200;
            expectedResponse.httpMessage = 'OK';
            expectedResponse.httpStatus = status;
            System.assertEquals(JSON.Serialize(expectedResponse), JSON.Serialize(response));
        Test.stopTest();
	}

    @isTest
    public static void getTrackingOrderTest2(){
        NE__Lov__c lov = new NE__Lov__c();
        lov.NE__Sub_Type__c = 'TIPOLOGICHE';
        lov.NE__Type__c = 'TRACKING';
        lov.NE__Value1__c = 'NE__Value1__c';
        lov.NE__Value2__c = 'NE__Value2__c';
        insert lov;
        Id rtProduct = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.PRICING).getRecordTypeId(); 
        NE__Product__c prod = new NE__Product__c();
        prod.OB_Acquirer__c = OB_EnrichOrder.NEXI; 
        prod.RecordTypeId = rtProduct;
        insert prod;
        NE__Order_Header__c oh = new NE__Order_Header__c();
        oh.OB_Business_Model_Acquiring__c = 'Diretto';
        oh.OB_Main_Process__c = 'Maintenance';
        insert oh;
        NE__Order__c ord = new NE__Order__c();
        ord.NE__Order_Header__c = oh.id;
        insert ord;
        NE__OrderItem__c oi = new NE__OrderItem__c();
        oi.NE__Status__c = 'Completed';
        oi.NE__ProdId__c = prod.id;
        oi.NE__OrderId__c = ord.id;
        oi.NE__Qty__c = 1;
        oi.OB_TermId__c = 'OB_TermId__c';
        insert oi;
        NE__Order_Item_Attribute__c oiaTermId = new NE__Order_Item_Attribute__c();
        oiaTermId.Name = 'TermId';
        oiaTermId.NE__Order_Item__c = oi.id;
        insert oiaTermId;
        NE__Order_Item_Attribute__c oiaModello = new NE__Order_Item_Attribute__c();
        oiaModello.Name = 'modello';
        oiaModello.NE__Order_Item__c = oi.id;
        insert oiaModello;
        NE__Order_Item_Attribute__c oiaRelease = new NE__Order_Item_Attribute__c();
        oiaRelease.Name = 'release';
        oiaRelease.NE__Order_Item__c = oi.id;
        insert oiaRelease;
        NE__Order_Item_Attribute__c oiaModalitaCollegamento = new NE__Order_Item_Attribute__c();
        oiaModalitaCollegamento.Name = 'modalitaCollegamento';
        oiaModalitaCollegamento.NE__Order_Item__c = oi.id;
        insert oiaModalitaCollegamento;
        NE__Order_Item_Attribute__c oiaDescrizioneModello = new NE__Order_Item_Attribute__c();
        oiaDescrizioneModello.Name = 'Descrizione Modello';
        oiaDescrizioneModello.NE__Order_Item__c = oi.id;
        insert oiaDescrizioneModello;
        NE__Order_Item_Attribute__c oiaDescrizioneRelease = new NE__Order_Item_Attribute__c();
        oiaDescrizioneRelease.Name = 'Descrizione Release';
        oiaDescrizioneRelease.NE__Order_Item__c = oi.id;
        insert oiaDescrizioneRelease;
        NE__Order_Item_Attribute__c oiaDescrizioneConnessione = new NE__Order_Item_Attribute__c();
        oiaDescrizioneConnessione.Name = 'Descrizione Connessione';
        oiaDescrizioneConnessione.NE__Order_Item__c = oi.id;
        insert oiaDescrizioneConnessione;
        NE__Order_Item_Attribute__c oiaProgressivoSIA = new NE__Order_Item_Attribute__c();
        oiaProgressivoSIA.Name = 'Progressivo SIA';
        oiaProgressivoSIA.NE__Order_Item__c = oi.id;
        insert oiaProgressivoSIA;
        NE__Order_Item_Attribute__c oiaCodiceStabilimentoSIA = new NE__Order_Item_Attribute__c();
        oiaCodiceStabilimentoSIA.Name = 'Codice Stabilimento SIA';
        oiaCodiceStabilimentoSIA.NE__Order_Item__c = oi.id;
        insert oiaCodiceStabilimentoSIA;
        NE__Order_Item_Attribute__c oiaCodiceSIA = new NE__Order_Item_Attribute__c();
        oiaCodiceSIA.Name = 'Codice SIA';
        oiaCodiceSIA.NE__Order_Item__c = oi.id;
        insert oiaCodiceSIA;

        //Create a new OB_TrackingOrder.CodiciConvenzioni for GT and for Acquiring

        OB_TrackingOrder.CodiciConvenzioni ccGT = new OB_TrackingOrder.CodiciConvenzioni();
        ccGT.idItemSalesforce = 'idItemSalesforceValueGT';
        ccGT.companyCode = 'companyCodeValueGT';
        ccGT.companyName = 'companyNameValueGT';
        ccGT.codiceConvenzione = 'codiceConvenzioneValueGT';
        ccGT.causaleRifiuto = 'causaleRifiutoValueGT';
        ccGT.dataInizio = 'dataInizioValueGT';
        ccGT.dataFine = 'dataFineValueGT';
        List<OB_TrackingOrder.CodiciConvenzioni> ccGTList = new List<OB_TrackingOrder.CodiciConvenzioni>();
        ccGTList.add(ccGT);

        OB_TrackingOrder.CodiciConvenzioni ccAcquiring = new OB_TrackingOrder.CodiciConvenzioni();
        ccAcquiring.idItemSalesforce = 'idItemSalesforceValueAcquiring';
        ccAcquiring.companyCode = 'companyCodeValueAcquiring';
        ccAcquiring.companyName = 'companyNameValueAcquiring';
        ccAcquiring.codiceConvenzione = 'codiceConvenzioneValueAcquiring';
        ccAcquiring.causaleRifiuto = 'causaleRifiutoValueAcquiring';
        ccAcquiring.dataInizio = 'dataInizioValueAcquiring';
        ccAcquiring.dataFine = 'dataFineValueAcquiring';
        List<OB_TrackingOrder.CodiciConvenzioni> ccAcquiringList = new List<OB_TrackingOrder.CodiciConvenzioni>();
        ccAcquiringList.add(ccAcquiring);

        OB_TrackingOrder.TermsIdInformation tiiGT = new OB_TrackingOrder.TermsIdInformation();
        tiiGT.termId = 'OB_TermId__c';
        tiiGT.modello = 'modelloValueGT';
        tiiGT.release = 'releaseValueGT';
        tiiGT.modalitaCollegamento = 'modalitaCollegamentoValueGT';
        tiiGT.descrizioneModello = 'descrizioneModelloValueGT';
        tiiGT.descrizioneRelease = 'descrizioneReleaseValueGT';
        tiiGT.descrizioneConnessione = 'descrizioneConnessioneValueGT';
        tiiGT.statoInstallazione = 'statoInstallazioneValueGT';
        tiiGT.causaleRifiuto = 'statoInstallazioneValueGT';
        tiiGT.dataInstallazione = 'dataInstallazioneValueGT';
        tiiGT.dataDisinstallazione = 'dataDisinstallazioneValueGT';
        tiiGT.codiciconvenzioni = ccGTList;
        List<OB_TrackingOrder.TermsIdInformation> tiiGTList = new List<OB_TrackingOrder.TermsIdInformation>();
        tiiGTList.add(tiiGT);

        OB_TrackingOrder.TermsIdInformation tiiAcquiring = new OB_TrackingOrder.TermsIdInformation();
        tiiAcquiring.termId = 'OB_TermId__c';
        tiiAcquiring.modello = 'modelloValueAcquiring';
        tiiAcquiring.release = 'releaseValueAcquiring';
        tiiAcquiring.modalitaCollegamento = 'modalitaCollegamentoValueAcquiring';
        tiiAcquiring.descrizioneModello = 'descrizioneModelloValueAcquiring';
        tiiAcquiring.descrizioneRelease = 'descrizioneReleaseValueAcquiring';
        tiiAcquiring.descrizioneConnessione = 'descrizioneConnessioneValueAcquiring';
        tiiAcquiring.statoInstallazione = 'statoInstallazioneValueAcquiring';
        tiiAcquiring.causaleRifiuto = 'statoInstallazioneValueAcquiring';
        tiiAcquiring.dataInstallazione = 'dataInstallazioneValueAcquiring';
        tiiAcquiring.dataDisinstallazione = 'dataDisinstallazioneValueAcquiring';
        tiiAcquiring.codiciconvenzioni = ccAcquiringList;
        List<OB_TrackingOrder.TermsIdInformation> tiiAcquiringList = new List<OB_TrackingOrder.TermsIdInformation>();
        tiiAcquiringList.add(tiiAcquiring);

        /*OB_TrackingOrder.ErrorList erroriGT = new OB_TrackingOrder.ErrorList();
        erroriGT.codice = 'codiceValueGT';
        erroriGT.descrizione = 'descrizioneValueGT';
        List<OB_TrackingOrder.ErrorList> erroriGTList = new List<OB_TrackingOrder.ErrorList>();
        erroriGTList.add(erroriGT);

        OB_TrackingOrder.ErrorList erroriAcquiring = new OB_TrackingOrder.ErrorList();
        erroriAcquiring.codice = 'codiceValueAcquiring';
        erroriAcquiring.descrizione = 'descrizioneValueAcquiring';
        List<OB_TrackingOrder.ErrorList> erroriAcquiringList = new List<OB_TrackingOrder.ErrorList>();
        erroriAcquiringList.add(erroriAcquiring);*/

        OB_TrackingOrder.puntoVendita pvGT = new OB_TrackingOrder.puntoVendita();
        pvGT.itemId = 'itemIdValueGT';
        pvGT.codicePuntoVendita = 'codicePuntoVenditaValueGT';
        pvGT.dataInizio = 'dataInizioValueGT';
        pvGT.dataCessazione = 'dataCessazioneValueGT';
        pvGT.causaleCessazione = 'causaleCessazioneValueGT';
        pvGT.tipo = 'Fisico';
        pvGT.codiceCTI = 'codiceCTIValueGT';
        pvGT.codiceStabilimento = 'codiceStabilimentoValueGT';
        pvGT.codiceStabilimentoSIA = 'codiceStabilimentoSIAValueGT';
        pvGT.codiceProgressivoSIA = 'codiceProgressivoSIAValueGT';
        pvGT.codiceSIA = 'codiceSIAValueGT';
        pvGT.numeroAssistenzaPOS = 'numeroAssistenzaPOSValueGT';
        pvGT.dataInizioAttivita = 'dataInizioAttivitaValueGT';
        pvGT.termsIdInformations = tiiGTList;
        List<OB_TrackingOrder.puntoVendita> pvGTList = new List<OB_TrackingOrder.puntoVendita>();
        pvGTList.add(pvGT);

        OB_TrackingOrder.puntoVendita pvAcquiring = new OB_TrackingOrder.puntoVendita();
        pvAcquiring.itemId = 'itemIdValueAcquiring';
        pvAcquiring.codicePuntoVendita = 'codicePuntoVenditaValueAcquiring';
        pvAcquiring.dataInizio = 'dataInizioValueAcquiring';
        pvAcquiring.dataCessazione = 'dataCessazioneValueAcquiring';
        pvAcquiring.causaleCessazione = 'causaleCessazioneValueAcquiring';
        pvAcquiring.tipo = 'Fisico';
        pvAcquiring.codiceCTI = 'codiceCTIValueAcquiring';
        pvAcquiring.codiceStabilimento = 'codiceStabilimentoValueAcquiring';
        pvAcquiring.codiceStabilimentoSIA = 'codiceStabilimentoSIAValueAcquiring';
        pvAcquiring.codiceProgressivoSIA = 'codiceProgressivoSIAValueAcquiring';
        pvAcquiring.codiceSIA = 'codiceSIAValueAcquiring';
        pvAcquiring.numeroAssistenzaPOS = 'numeroAssistenzaPOSValueAcquiring';
        pvAcquiring.dataInizioAttivita = 'dataInizioAttivitaValueAcquiring';
        pvAcquiring.termsIdInformations = tiiAcquiringList;
        List<OB_TrackingOrder.puntoVendita> pvAcquiringList = new List<OB_TrackingOrder.puntoVendita>();
        pvAcquiringList.add(pvAcquiring);


        OB_TrackingOrder.puntoVendita pvAcquiringEcommerce = new OB_TrackingOrder.puntoVendita();
        pvAcquiringEcommerce.itemId = 'itemIdValueAcquiring';
        pvAcquiringEcommerce.codicePuntoVendita = 'codicePuntoVenditaValueAcquiring';
        pvAcquiringEcommerce.dataInizio = 'dataInizioValueAcquiring';
        pvAcquiringEcommerce.dataCessazione = 'dataCessazioneValueAcquiring';
        pvAcquiringEcommerce.causaleCessazione = 'causaleCessazioneValueAcquiring';
        pvAcquiringEcommerce.tipo = 'MOTO';
        pvAcquiringEcommerce.codiceCTI = 'codiceCTIValueAcquiring';
        pvAcquiringEcommerce.codiceStabilimento = 'codiceStabilimentoValueAcquiring';
        pvAcquiringEcommerce.codiceStabilimentoSIA = 'codiceStabilimentoSIAValueAcquiring';
        pvAcquiringEcommerce.codiceProgressivoSIA = 'codiceProgressivoSIAValueAcquiring';
        pvAcquiringEcommerce.codiceSIA = 'codiceSIAValueAcquiring';
        pvAcquiringEcommerce.numeroAssistenzaPOS = 'numeroAssistenzaPOSValueAcquiring';
        pvAcquiringEcommerce.dataInizioAttivita = 'dataInizioAttivitaValueAcquiring';
        pvAcquiringEcommerce.termsIdInformations = tiiAcquiringList;
        pvAcquiringList.add(pvAcquiringEcommerce);


        OB_TrackingOrder.GT gt = new OB_TrackingOrder.GT();
        gt.sistemaSorgente = 'sistemaSorgenteValueGT';
        gt.statoProvisioning = 'statoProvisioningValueGT';
        gt.codiceCliente = 'codiceClienteValueGT';
        gt.errori = null;
        gt.puntiVendita = pvGTList;
        List<OB_TrackingOrder.GT> gtList = new List<OB_TrackingOrder.GT>();
        gtList.add(gt);

        OB_TrackingOrder.Acquiring acquiring = new OB_TrackingOrder.Acquiring();
        acquiring.sistemaSorgente = 'sistemaSorgenteValueAcquiring';
        acquiring.codiceSocieta = 'codiceSocietaValueAcquiring';
        acquiring.errori = null;
        acquiring.puntiVendita = pvAcquiringList;
        List<OB_TrackingOrder.Acquiring> acquiringList = new List<OB_TrackingOrder.Acquiring>();
        acquiringList.add(acquiring);

        OB_TrackingOrder.TrackingOrderRequest tor = new OB_TrackingOrder.TrackingOrderRequest();
        tor.idOrdineSfdc = ord.id;
        tor.Acquiring = acquiringList;
        tor.GT = gtList;







        // OB_TrackingOrder.TermsIdInformation tiiAcquiring = new OB_TrackingOrder.TermsIdInformation();

        // //String requestTrackingString = '{ "idOrdineSfdc": "' + ord.id + '", "Acquiring": [ { "sistemaSorgente": "sistemaSorgenteValue", "codiceSocieta": "codiceSocietaValue", "errori": [ { "codice": "codiceValue", "descrizione": "descrizioneValue" } ], "puntiVendita": [ { "itemId": "itemIdValue", "codicePuntoVendita": "codicePuntoVenditaValue", "dataInizio": "dataInizioValue", "dataCessazione": "dataCessazioneValue", "causaleCessazione": "causaleCessazioneValue", "tipo": "tipoValue", "codiceCTI": "codiceCTIValue", "codiceStabilimento": "codiceStabilimentoValue", "codiceStabilimentoSIA": "codiceStabilimentoSIAValue", "codiceProgressivoSIA": "codiceProgressivoSIAValue", "codiceSIA": "codiceSIAValue", "numeroAssistenzaPOS": "numeroAssistenzaPOSValue", "dataInizioAttivita": "dataInizioAttivitavalue", "termsIdInformations": [ { "termId": "termIdValue", "modello": "modelloValue", "release": "releaseValue", "modalitaCollegamento": "modalitaCollegamentoValue", "descrizioneModello": "descrizioneModelloValue", "descrizioneRelease": "descrizioneReleaseValue", "descrizioneConnessione": "descrizioneConnessioneValue", "statoInstallazione": "statoInstallazioneValue", "causaleRifiuto": "causaleRifiutoValue", "dataInstallazione": "dataInstallazioneValue", "dataDisinstallazione": "dataDisinstallazioneValue", "codiciconvenzioni": [ { "idItemSalesforce": "idItemSalesforceValue", "companyCode": "companyCodeValue", "companyName": "companyNameValue", "codiceConvenzione": "codiceConvenzioneValue", "causaleRifiuto": "causaleRifiutoValue", "dataInizio": "dataInizioValue", "dataFine": "dataFineValue" } ] } ] } ] } ], "GT": [ { "sistemaSorgente": "sistemaSorgenteValue", "statoProvisioning": "statoProvisioningValue", "codiceCliente": "codiceClienteValue", "errori": [ { "codice": "codiceValue", "descrizione": "descrizioneValue" } ], "puntiVendita": [ { "itemId": "itemIdValue", "codicePuntoVendita": "codicePuntoVenditaValue", "dataInizio": "dataInizioValue", "dataCessazione": "dataCessazioneValue", "causaleCessazione": "causaleCessazioneValue", "tipo": "tipoValue", "codiceCTI": "codiceCTIValue", "codiceStabilimento": "codiceStabilimentoValue", "codiceStabilimentoSIA": "codiceStabilimentoSIAValue", "codiceProgressivoSIA": "codiceProgressivoSIAValue", "codiceSIA": "codiceSIAValue", "numeroAssistenzaPOS": "numeroAssistenzaPOSValue", "dataInizioAttivita": "dataInizioAttivitavalue", "termsIdInformations": [ { "termId": "termIdValue", "modello": "modelloValue", "release": "releaseValue", "modalitaCollegamento": "modalitaCollegamentoValue", "descrizioneModello": "descrizioneModelloValue", "descrizioneRelease": "descrizioneReleaseValue", "descrizioneConnessione": "descrizioneConnessioneValue", "statoInstallazione": "statoInstallazioneValue", "causaleRifiuto": "causaleRifiutoValue", "dataInstallazione": "dataInstallazioneValue", "dataDisinstallazione": "dataDisinstallazioneValue", "codiciconvenzioni": [ { "idItemSalesforce": "idItemSalesforceValue", "companyCode": "companyCodeValue", "companyName": "companyNameValue", "codiceConvenzione": "codiceConvenzioneValue", "causaleRifiuto": "causaleRifiutoValue", "dataInizio": "dataInizioValue", "dataFine": "dataFineValue" } ] } ] } ] } ] }';
        // OB_TrackingOrder.TrackingOrderRequest requestTracking  = (OB_TrackingOrder.TrackingOrderRequest)JSON.deserialize(requestTrackingString, OB_TrackingOrder.TrackingOrderRequest.class);
        // List<Acquiring> acquirings = new List<Acquiring>();
        // acquirings.add(new Acquiring(sistemaSorgente = "sistemaSorgenteValue", ));
        List<Account> accList   = new List<Account>();
        Id accountBankRecordId  = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Bank').getRecordTypeId();
        Account bankAccount     = new Account(  Name = 'TEST',
                                                RecordTypeId = accountBankRecordId,
                                                OB_Employees_Number__c = 'Minore di 10',
                                                OB_VAT_Not_Present__c = true,
                                                OB_DescriptionVATNotPresent__c = 'description',
                                                NE__Fiscal_code__c = 'RSSMRA80A01F205X',
                                                OB_BypassValidation__c = true,
                                                OB_Status__c = 'Active');
        Id rtMerchant2          = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId();
        Account myMastMerchant2 = new Account(  Name = 'TEST',
                                                RecordTypeId = rtMerchant2,
                                                OB_Employees_Number__c = 'Minore di 10',
                                                OB_VAT_Not_Present__c = true,
                                                OB_DescriptionVATNotPresent__c = 'description',
                                                NE__Fiscal_code__c = 'RSSMRA80A01F205X',
                                                OB_BypassValidation__c = true,
                                                OB_Status__c = 'Active');

        accList.add(myMastMerchant2);
        accList.add(bankAccount);
        insert accList;
        NE__Service_Point__c servicePoint1 = new NE__Service_Point__c();
        insert servicePoint1;
        NE__Order_Header__c orderHeader = new NE__Order_Header__c(OB_ProposerABI__c=bankAccount.Id ,NE__AccountId__c=myMastMerchant2.Id, OB_Main_Process__c = 'Setup' );
        insert orderHeader;
        NE__Order__c configuration = new NE__Order__c(NE__AccountId__c=myMastMerchant2.Id ,OB_Service_Point__c = servicePoint1.Id,NE__Order_Header__c=orderHeader.Id,OB_MCCL2__c = 'test');
        insert configuration;
        NE__OrderItem__c orderItem2 = New NE__OrderItem__c(NE__Qty__c=10 ,NE__OrderId__c=configuration.id);
        insert orderItem2;


        /*#############################################    AV   ##################################################*/

        NE__Order_Item_Attribute__c attr1 = new NE__Order_Item_Attribute__c();
        attr1.Name = 'TermId';
        attr1.NE__Order_Item__c = orderItem2.id;
        insert attr1;
        NE__Order_Item_Attribute__c attr2 = new NE__Order_Item_Attribute__c();
        attr2.Name = 'modello';
        attr2.NE__Order_Item__c = orderItem2.id;
        insert attr2;
        NE__Order_Item_Attribute__c attr3 = new NE__Order_Item_Attribute__c();
        attr3.Name = 'release';
        attr3.NE__Order_Item__c = orderItem2.id;
        insert attr3;
        NE__Order_Item_Attribute__c attr4 = new NE__Order_Item_Attribute__c();
        attr4.Name = 'modalitaCollegamento';
        attr4.NE__Order_Item__c = orderItem2.id;
        insert attr4;
        NE__Order_Item_Attribute__c attr5 = new NE__Order_Item_Attribute__c();
        attr5.Name = 'descrizioneModello';
        attr5.NE__Order_Item__c = orderItem2.id;
        insert attr5;
        NE__Order_Item_Attribute__c attr6 = new NE__Order_Item_Attribute__c();
        attr6.Name = 'descrizioneRelease';
        attr6.NE__Order_Item__c = orderItem2.id;
        insert attr6;
        NE__Order_Item_Attribute__c attr7 = new NE__Order_Item_Attribute__c();
        attr7.Name = 'descrizioneConnessione';
        attr7.NE__Order_Item__c = orderItem2.id;
        insert attr7;
        NE__Order_Item_Attribute__c attr8 = new NE__Order_Item_Attribute__c();
        attr8.Name = 'Progressivo SIA';
        attr8.NE__Order_Item__c = orderItem2.id;
        insert attr8;
        NE__Order_Item_Attribute__c attr9 = new NE__Order_Item_Attribute__c();
        attr9.Name = 'Codice Stabilimento SIA';
        attr9.NE__Order_Item__c = orderItem2.id;
        insert attr9;
        NE__Order_Item_Attribute__c attr10 = new NE__Order_Item_Attribute__c();
        attr10.Name = 'Codice SIA';
        attr10.NE__Order_Item__c = orderItem2.id;
        insert attr10;

        /*#############################################    AV   ##################################################*/



        OB_Bank_Profile__c bp = new OB_Bank_Profile__c();
        bp.OB_Bank__c                           = bankAccount.Id;
        bp.OB_Service_Type__c                   = 'Acquiring';
        bp.OB_Business_Model_POS__c             = 'Bilaterale';
        bp.OB_Circuit__c                        = 'JCB';
        bp.OB_Other_Acquirer__c                 = 'Amex';
        bp.OB_Applicant_RAC_Code_SIA__c         = 'Banca';
        bp.OB_Terminal_Id_Generator__c          = 'Banca';
        bp.OB_Technical_component_invoicing__c  = 'TecMarket(servizio fatturazione per conto terzi)';
        bp.OB_GT__c                             = 'Nexi';
        bp.OB_Processor__c                      = 'SIA SMAC';
        bp.OB_Bilateral_Pricing__c              = 'SI';
        bp.OB_Sending_Contract_to_Nexi__c       = 'SI';
        bp.OB_SME_Factory__c                    = 'SI';
        insert bp;
        //      System.debug('QUERY BANK PROFILE: '+[SELECT id,OB_Business_Model_Acquiring__c FROM OB_Bank_Profile__c where OB_Bank__c =:bankAccount.Id]);
        Datetime dataInizio     = Datetime.newInstance(1960, 2, 17);
        Datetime dataCessazione = Datetime.newInstance(1962, 2, 17);
        //String request = '{"idOrdineSfdc": "'+configuration.id+'","Acquiring": [{"sistemaSorgente": "EQUENS","codiceSocieta": "1114558","puntiVendita": [{"itemId": "'+orderItem2.Id+'","codicePuntoVendita": "3249896","dataInizio": "2011-11-13","dataCessazione": "2011-11-14","causaleCessazione": "","tipo": ""}],"errori": []}] , "GT" : [ { "termsIdInformation": [ { "termId": "test", "statoInstallazione": "test", "release": "test", "modello": "test", "modalitaCollegamento": "test", "descrizioneRelease": "test", "descrizioneModello": "test", "descrizioneConnessione": "test", "dataInstallazione": "test", "dataDisinstallazione": "test", "codiciconvenzioni": [ { "idItemSalesforce": "test", "dataInizio": "test", "dataFine": "test", "companyName": "test", "companyCode": "test", "codiceConvenzione": "test", "causaleRifiuto": "test" } ], "causaleRifiuto": "test" } ], "statoProvisioning": "test", "sistemaSorgente": "test", "puntiVendita": [{ "termsIdInformations" :"[{"termId" : "'+orderItem2.Id+'"}]"  , "tipo": "test", "numeroVerde": "test", "itemId": "'+orderItem2.Id+'", "dataInizioAttivita": "test", "dataInizio": "test", "dataCessazione": "test", "codiceStabilimentoSIA": "test", "codiceSIA": "test", "codicePuntoVendita": "test", "codiceProgressivoSIA": "test", "codiceCTI": "test", "causaleCessazione": "test" } ], "errori": [ { "descrizione": "test", "codice": "test" } ], "codiceCliente": "test" } ]}';
        //String request = '{"idOrdineSfdc": "'+configuration.id+'","Acquiring": [{"sistemaSorgente": "EQUENS","codiceSocieta": "1114558","puntiVendita": [{"itemId" :"'+orderItem2.Id+'","codicePuntoVendita": "3249896","dataInizio": "1990-05-12","dataCessazione": "1991-05-12","causaleCessazione": "Test","tipo": "FISICO"}],"errori": []}],"GT" : [{"sistemaSorgente":"NEXI","statoProvisioning":"","codiceCliente" : "12345678","puntiVendita":[{"codiceCTI":"CTI","codiceStabilimento":"1234","codiceProgressivoSIA" : "","codiceStabilimentoSIA":"","codiceSIA" :"","numeroVerde"  :"","dataInizioAttivita":"","tipo":"","termIdInformations" :{"termId" :"'+orderItem2.Id+'","modello" : "test","release" : "test","modalitaCollegament" : "","descrizioneModello" : "","descrizioneRelease" : "","descrizioineConnessione" : "","statoInstallazione" :"","causaleRifiuto" :"","dataDisintallazione" : "","codiciConvenzioni":{"idItemSalesforce" :"","companyCode" : "","companyName" :"","codiceConvenzione" : "1234","causaleRifiuto" :"","dataInizio" :"","dataFine" : ""}}}],"errori": []}] }';
        String request = '{"idOrdineSfdc":"'+configuration.id+'","Acquiring":[{"sistemaSorgente":"EQUENS","codiceSocieta":"1114558","puntiVendita":[{"itemId":"'+orderItem2.Id+'","codicePuntoVendita":"3249896","dataInizio":"1990-05-12","dataCessazione":"1991-05-12","causaleCessazione":"Test","tipo":"FISICO"}],"errori":[]}],"GT":[{"sistemaSorgente":"NEXI","statoProvisioning":"Installato","codiceCliente":"12345678","puntiVendita":[{"codiceCTI":"CTI","codiceStabilimento":"1234","codiceProgressivoSIA":"666","codiceStabilimentoSIA":"666","codiceSIA":"666","numeroVerde":"1234","dataInizio":"12-12-2000","dataInizioAttivita":"","tipo":"","termIdInformation":[{"termId":"'+orderItem2.Id+'","modello":"test","release":"test","modalitaCollegament":"","descrizioneModello":"","descrizioneRelease":"","descrizioineConnessione":"","statoInstallazione":"","causaleRifiuto":"","dataDisintallazione":"","codiciConvenzioni":[{"idItemSalesforce":"","companyCode":"","companyName":"","codiceConvenzione":"1234","causaleRifiuto":"","dataInizio":"","dataFine":""}]}]}],"errori":[]}]}';
        //String request   = '{"idOrdineSfdc":"'+configuration.id+'","GT":[{"sistemaSorgente":"NEXI","statoProvisioning":"Installato","codiceCliente":"12345678","puntiVendita":[{"codiceCTI":"CTI","codiceStabilimento":"1234","codiceProgressivoSIA":"666","codiceStabilimentoSIA":"666","codiceSIA":"666","numeroVerde":"1234","dataInizio":"12-12-2000","dataInizioAttivita":"","tipo":"","termIdInformation":[{"termId":"'+orderItem2.Id+'","modello":"test","release":"test","modalitaCollegament":"","descrizioneModello":"","descrizioneRelease":"","descrizioineConnessione":"","statoInstallazione":"","causaleRifiuto":"","dataDisintallazione":"","codiciConvenzioni":[{"idItemSalesforce":"","companyCode":"","companyName":"","codiceConvenzione":"1234","causaleRifiuto":"","dataInizio":"","dataFine":""}]}]}],"errori":[]}]}';

        RestContext.request = new RestRequest();
        RestContext.request.requestBody =  Blob.valueof(request);

    //  requestTracking = (OB_TrackingOrder.TrackingOrderRequest)JSON.deserialize(request, OB_TrackingOrder.TrackingOrderRequest.class);
    //  Id rtProduct2   = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.TERMINALE).getRecordTypeId();
    //  NE__Product__c product2 = new NE__Product__c(RecordTypeId =rtProduct2 );
    //  insert product2;
    //  orderItem2.NE__OrderId__c    = requestTracking.idOrdineSfdc;
    //  orderItem2.NE__ProdId__c     = product2.Id;
    //  orderItem2.OB_TermId__c      = orderItem2.Id;//text field);
    //    orderItem2.OB_Terminal_Id__c = orderItem2.Id;
        update orderItem2;
        List<ExternalSourceMapping__c> extList = new List<ExternalSourceMapping__c>();
        //System.debug('requestTracking: ' + requestTracking);
        //ExternalSourceMapping__c ext = new ExternalSourceMapping__c(OB_Merchant_ID__c=configuration.NE__AccountId__c ,
        //  OB_Service_Point_ID__c = configuration.OB_Service_Point__c,
        //  OB_ServicePointCodeShopCode__c='test' ,
        //  OB_Source__c=requestTracking.GT[0].sistemaSorgente,
        //  OB_Conventioncode__c=requestTracking.GT[0].puntiVendita[0].termIdInformation[0].codiciConvenzioni[0].codiceConvenzione,
        //   OB_CustomerCodeClientCode__c='TEST');
        //System.debug('GT ARRAY: '+requestTracking.GT[0].codiceCliente);
        Id rtMerchant3  = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId();
        Account acc3    = new Account(  Name='TEST',
                                                    RecordTypeId=rtMerchant3,
                                                    OB_Employees_Number__c='Minore di 10',
                                                    OB_VAT_Not_Present__c=true,
                                                    OB_DescriptionVATNotPresent__c='description',
                                                    NE__Fiscal_code__c='RSSMRA80A01F205X',
                                                    OB_BypassValidation__c=true,
                                                    OB_Status__c='Active');
        insert acc3;
        NE__Service_Point__c servicePoint2 = new NE__Service_Point__c();
        insert servicePoint2;
        ExternalSourceMapping__c ext2 = new ExternalSourceMapping__c(OB_Merchant_ID__c=acc3.Id , OB_CustomerCodeClientCode__c='' , OB_Source__c='',OB_Service_Point_ID__c=servicePoint2.Id);
        //extList.add(ext);
        extList.add(ext2);
        insert extList;

        System.debug('IF CONDITION GT: ' +orderItem2.NE__ProdId__c);

        NE__Order_Item_Attribute__c orderItemAttribute = new NE__Order_Item_Attribute__c(Name = 'Terminal Id', NE__Order_Item__c = orderItem2.id);
        insert orderItemAttribute;

        NE__Lov__c lovMCC2 = new NE__Lov__c();
        lovMCC2.ne__type__c   = 'mcc';
        lovMCC2.ne__value3__c = 'L2';
        lovMCC2.OB_Value4__c  = configuration.OB_MCCL2__c;
        insert lovMCC2;

        Test.startTest();
        try
        {
			OB_TrackingOrder.getTrackingOrder(tor);
		}
		catch(Exception e)
		{
			System.debug('Generic exception');
		}
		Test.stopTest();
		}

    // @isTest
    // public static void getTrackingOrderTestForIfGT()
    // {
    //  Test.startTest();
    //  OB_TrackingOrder.getTrackingOrder();
    //  Test.stopTest();
    // }



    //METHOD FOR IF GT
    @isTest
    public static void getTrackingOrderTest_2(){

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

        NE__Service_Point__c sp  = new NE__Service_Point__c();
        sp.OB_MCC__c   ='2345';
        sp.NE__City__c = 'Yaounde';
        insert sp;

        NE__Lov__c lov = new NE__Lov__c();
        lov.NE__Sub_Type__c = 'TIPOLOGICHE';
        lov.NE__Type__c = 'TRACKING';
        lov.NE__Value1__c = 'NE__Value1__c';
        lov.NE__Value2__c = 'NE__Value2__c';
        insert lov;

        NE__Lov__c lov2 = new NE__Lov__c();
        lov2.NE__Sub_Type__c = 'TIPOLOGICHE';
        lov2.NE__Type__c = 'mcc';
        lov2.NE__Value1__c = 'NE__Value1__c';
        lov2.NE__Value2__c = '00';
        lov2.ne__value3__c = 'L2';
        insert lov2;
        //francesca.ribezzi 09/09/19 changing recordtype from pricing to terminali:
        Id rtProduct = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.TERMINALE).getRecordTypeId(); 
        NE__Product__c prod = new NE__Product__c();
        prod.OB_Acquirer__c = OB_EnrichOrder.NEXI; 
        prod.RecordTypeId = rtProduct;
        insert prod;
        NE__Product__c prod2 = new NE__Product__c();
        prod2.OB_Acquirer__c = OB_EnrichOrder.NEXI; 
        prod2.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'NE__Product__c' AND DeveloperName = 'Terminali' LIMIT 1].id;
        insert prod2;
        NE__Product__c prodMoto = new NE__Product__c();
        prod2.OB_Acquirer__c = OB_EnrichOrder.NEXI; 
        prod2.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'NE__Product__c' AND DeveloperName = 'Terminali' LIMIT 1].id;
        prod2.name = 'Moto';
        insert prodMoto;
        NE__Order_Header__c oh = new NE__Order_Header__c();
        oh.OB_Business_Model_Acquiring__c = 'Diretto';
        oh.OB_Main_Process__c = 'Setup';
        insert oh;
        NE__Order__c ord = new NE__Order__c();
        ord.NE__AccountId__c = acc.id;
        ord.NE__BillAccId__c = acc.Id;
        ord.NE__ServAccId__c = acc.Id;
        ord.NE__Order_Header__c = oh.id;
        ord.OB_Service_Point__c = sp.id;
        ord.OB_MCCL2__c = '00';
        ord.OB_GT__c = 'Nexi';
        ord.OB_FulfilmentStatus__c = 'Sent';
        insert ord;
        NE__OrderItem__c oi = new NE__OrderItem__c();
        oi.RecordTypeId =[SELECT Id FROM RecordType WHERE sObjectType = 'NE__OrderItem__c' AND DeveloperName = 'Terminali' LIMIT 1].id;
        oi.OB_GT__c = 'MONETICA';
        oi.NE__Status__c = 'Completed';
        oi.NE__ProdId__c = prod.id;
        oi.NE__OrderId__c = ord.id;
        oi.NE__Qty__c = 1;
        oi.OB_TermId__c = 'OB_TermId__c';
        insert oi;
        NE__OrderItem__c oiMoto = new NE__OrderItem__c();
        oiMoto.RecordTypeId =[SELECT Id FROM RecordType WHERE sObjectType = 'NE__OrderItem__c' AND DeveloperName = 'Terminali' LIMIT 1].id;
      //  oiMoto.OB_GT__c = 'MONETICA';
        oiMoto.NE__Status__c = 'Completed';
        oiMoto.NE__ProdId__c = prodMoto.id;
        oiMoto.NE__OrderId__c = ord.id;
        oiMoto.NE__Qty__c = 1;
        oiMoto.OB_TermId__c = 'OB_TermId__c';
        insert oiMoto;
        Id rtProductGTRoot          = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.TERMINALE).getRecordTypeId(); 
        NE__Product__c productGTRoot = new NE__Product__c(RecordTypeId = rtProductGTRoot, OB_Codice_sfdc__c = 'SMPOS_CASSA', Name = 'SmartPOS Cassa', OB_Contract_Type__c = 'Contratto POS;Modulo Off Commercial', OB_Business_Model_POS__c = 'Diretto;Trilaterale Nuovo');
        insert productGTRoot;
        NE__OrderItem__c orderItemGTRoot = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = ord.id, NE__Action__c = 'Add', OB_GT__c = 'MONETICA', OB_TermId__c = '21021990', NE__ProdId__c = productGTRoot.id, NE__Status__c = 'PENDING', OB_FulfilmentStatus__c = 'Pending', OB_Tech_Outcome_Monetica__c = 'OK');
        insert orderItemGTRoot;




        NE__Order_Item_Attribute__c oiaTermId = new NE__Order_Item_Attribute__c();
        oiaTermId.Name = 'TermId';
        oiaTermId.NE__Order_Item__c = oi.id;
        insert oiaTermId;
        NE__Order_Item_Attribute__c oiaModello = new NE__Order_Item_Attribute__c();
        oiaModello.Name = 'modello';
        oiaModello.NE__Order_Item__c = oi.id;
        insert oiaModello;
        NE__Order_Item_Attribute__c oiaRelease = new NE__Order_Item_Attribute__c();
        oiaRelease.Name = 'release';
        oiaRelease.NE__Order_Item__c = oi.id;
        insert oiaRelease;
        NE__Order_Item_Attribute__c oiaModalitaCollegamento = new NE__Order_Item_Attribute__c();
        oiaModalitaCollegamento.Name = 'modalitaCollegamento';
        oiaModalitaCollegamento.NE__Order_Item__c = oi.id;
        insert oiaModalitaCollegamento;
        NE__Order_Item_Attribute__c oiaDescrizioneModello = new NE__Order_Item_Attribute__c();
        oiaDescrizioneModello.Name = 'Descrizione Modello';
        oiaDescrizioneModello.NE__Order_Item__c = oi.id;
        insert oiaDescrizioneModello;
        NE__Order_Item_Attribute__c oiaDescrizioneRelease = new NE__Order_Item_Attribute__c();
        oiaDescrizioneRelease.Name = 'Descrizione Release';
        oiaDescrizioneRelease.NE__Order_Item__c = oi.id;
        insert oiaDescrizioneRelease;
        NE__Order_Item_Attribute__c oiaDescrizioneConnessione = new NE__Order_Item_Attribute__c();
        oiaDescrizioneConnessione.Name = 'Descrizione Connessione';
        oiaDescrizioneConnessione.NE__Order_Item__c = oi.id;
        insert oiaDescrizioneConnessione;
        NE__Order_Item_Attribute__c oiaProgressivoSIA = new NE__Order_Item_Attribute__c();
        oiaProgressivoSIA.Name = 'Progressivo SIA';
        oiaProgressivoSIA.NE__Order_Item__c = oi.id;
        insert oiaProgressivoSIA;
        NE__Order_Item_Attribute__c oiaCodiceStabilimentoSIA = new NE__Order_Item_Attribute__c();
        oiaCodiceStabilimentoSIA.Name = 'Codice Stabilimento SIA';
        oiaCodiceStabilimentoSIA.NE__Order_Item__c = oi.id;
        insert oiaCodiceStabilimentoSIA;
        NE__Order_Item_Attribute__c oiaCodiceSIA = new NE__Order_Item_Attribute__c();
        oiaCodiceSIA.Name = 'Codice SIA';
        oiaCodiceSIA.NE__Order_Item__c = oi.id;
        insert oiaCodiceSIA;

        //Create a new OB_TrackingOrder.CodiciConvenzioni for GT and for Acquiring

        OB_TrackingOrder.CodiciConvenzioni ccGT = new OB_TrackingOrder.CodiciConvenzioni();
        ccGT.idItemSalesforce = 'idItemSalesforceValueGT';
        ccGT.companyCode = 'companyCodeValueGT';
        ccGT.companyName = 'companyNameValueGT';
        ccGT.codiceConvenzione = 'codiceConvenzioneValueGT';
        ccGT.causaleRifiuto = 'causaleRifiutoValueGT';
        ccGT.dataInizio = '2019-04-03';
        ccGT.dataFine = '2019-04-03';
        List<OB_TrackingOrder.CodiciConvenzioni> ccGTList = new List<OB_TrackingOrder.CodiciConvenzioni>();
        ccGTList.add(ccGT);

        OB_TrackingOrder.CodiciConvenzioni ccAcquiring = new OB_TrackingOrder.CodiciConvenzioni();
        ccAcquiring.idItemSalesforce = 'idItemSalesforceValueAcquiring';
        ccAcquiring.companyCode = 'companyCodeValueAcquiring';
        ccAcquiring.companyName = 'companyNameValueAcquiring';
        ccAcquiring.codiceConvenzione = 'codiceConvenzioneValueAcquiring';
        ccAcquiring.causaleRifiuto = 'causaleRifiutoValueAcquiring';
        ccAcquiring.dataInizio = '2019-04-03';
        ccAcquiring.dataFine = '2019-04-03';
        List<OB_TrackingOrder.CodiciConvenzioni> ccAcquiringList = new List<OB_TrackingOrder.CodiciConvenzioni>();
        ccAcquiringList.add(ccAcquiring);

        OB_TrackingOrder.TermsIdInformation tiiGT = new OB_TrackingOrder.TermsIdInformation();
        tiiGT.termId = '21021990';
        tiiGT.modello = 'modelloValueGT';
        tiiGT.release = 'releaseValueGT';
        tiiGT.modalitaCollegamento = 'modalitaCollegamentoValueGT';
        tiiGT.descrizioneModello = 'descrizioneModelloValueGT';
        tiiGT.descrizioneRelease = 'descrizioneReleaseValueGT';
        tiiGT.descrizioneConnessione = 'descrizioneConnessioneValueGT';
        tiiGT.statoInstallazione = 'Installato';
        tiiGT.causaleRifiuto = 'statoInstallazioneValueGT';
        tiiGT.dataInstallazione = '2019-04-03';
        tiiGT.dataDisinstallazione = '2019-04-03';
        tiiGT.codiciconvenzioni = ccGTList;
        List<OB_TrackingOrder.TermsIdInformation> tiiGTList = new List<OB_TrackingOrder.TermsIdInformation>();
        tiiGTList.add(tiiGT);

        OB_TrackingOrder.TermsIdInformation tiiAcquiring = new OB_TrackingOrder.TermsIdInformation();
        tiiAcquiring.termId = 'OB_TermId__c';
        tiiAcquiring.modello = 'modelloValueAcquiring';
        tiiAcquiring.release = 'releaseValueAcquiring';
        tiiAcquiring.modalitaCollegamento = 'modalitaCollegamentoValueAcquiring';
        tiiAcquiring.descrizioneModello = 'descrizioneModelloValueAcquiring';
        tiiAcquiring.descrizioneRelease = 'descrizioneReleaseValueAcquiring';
        tiiAcquiring.descrizioneConnessione = 'descrizioneConnessioneValueAcquiring';
        tiiAcquiring.statoInstallazione = 'statoInstallazioneValueAcquiring';
        tiiAcquiring.causaleRifiuto = 'statoInstallazioneValueAcquiring';
        tiiAcquiring.dataInstallazione = '2019-04-03';
        tiiAcquiring.dataDisinstallazione = '2019-04-03';
        tiiAcquiring.codiciconvenzioni = ccAcquiringList;
        List<OB_TrackingOrder.TermsIdInformation> tiiAcquiringList = new List<OB_TrackingOrder.TermsIdInformation>();
        tiiAcquiringList.add(tiiAcquiring);

        /*OB_TrackingOrder.ErrorList erroriGT = new OB_TrackingOrder.ErrorList();
        erroriGT.codice = 'codiceValueGT';
        erroriGT.descrizione = 'descrizioneValueGT';
        List<OB_TrackingOrder.ErrorList> erroriGTList = new List<OB_TrackingOrder.ErrorList>();
        erroriGTList.add(erroriGT);

        OB_TrackingOrder.ErrorList erroriAcquiring = new OB_TrackingOrder.ErrorList();
        erroriAcquiring.codice = 'codiceValueAcquiring';
        erroriAcquiring.descrizione = 'descrizioneValueAcquiring';
        List<OB_TrackingOrder.ErrorList> erroriAcquiringList = new List<OB_TrackingOrder.ErrorList>();
        erroriAcquiringList.add(erroriAcquiring);*/

        OB_TrackingOrder.puntoVendita pvGT = new OB_TrackingOrder.puntoVendita();
        pvGT.itemId = 'itemIdValueGT';
        pvGT.codicePuntoVendita = 'codicePuntoVenditaValueGT';
        pvGT.dataInizio = '2019-04-03';
        pvGT.dataCessazione = '2019-04-03';
        pvGT.causaleCessazione = 'causaleCessazioneValueGT';
        pvGT.tipo = 'Fisico';
        pvGT.codiceCTI = 'CT';
        pvGT.codiceStabilimento = 'codiceStabilimentoValueGT';
        pvGT.codiceStabilimentoSIA = 'codiceStabilimentoSIAValueGT';
        pvGT.codiceProgressivoSIA = 'codiceProgressivoSIAValueGT';
        pvGT.codiceSIA = 'codiceSIAValueGT';
        pvGT.numeroAssistenzaPOS = 'numeroAssistenzaPOSValueGT';
        pvGT.dataInizioAttivita = '2019-04-03';
        pvGT.termsIdInformations = tiiGTList;
        List<OB_TrackingOrder.puntoVendita> pvGTList = new List<OB_TrackingOrder.puntoVendita>();
        pvGTList.add(pvGT);

        OB_TrackingOrder.puntoVendita pvAcquiring = new OB_TrackingOrder.puntoVendita();
        pvAcquiring.itemId = 'itemIdValueAcquiring';
        pvAcquiring.codicePuntoVendita = 'codicePuntoVenditaValueAcquiring';
        pvAcquiring.dataInizio = 'dataInizioValueAcquiring';
        pvAcquiring.dataCessazione = 'dataCessazioneValueAcquiring';
        pvAcquiring.causaleCessazione = 'causaleCessazioneValueAcquiring';
        pvAcquiring.tipo = 'Fisico';
        pvAcquiring.codiceCTI = 'codiceCTIValueAcquiring';
        pvAcquiring.codiceStabilimento = 'codiceStabilimentoValueAcquiring';
        pvAcquiring.codiceStabilimentoSIA = 'codiceStabilimentoSIAValueAcquiring';
        pvAcquiring.codiceProgressivoSIA = 'codiceProgressivoSIAValueAcquiring';
        pvAcquiring.codiceSIA = 'codiceSIAValueAcquiring';
        pvAcquiring.numeroAssistenzaPOS = 'numeroAssistenzaPOSValueAcquiring';
        pvAcquiring.dataInizioAttivita = 'dataInizioAttivitaValueAcquiring';
        pvAcquiring.termsIdInformations = tiiAcquiringList;
        List<OB_TrackingOrder.puntoVendita> pvAcquiringList = new List<OB_TrackingOrder.puntoVendita>();
        pvAcquiringList.add(pvAcquiring);

        OB_TrackingOrder.GT gt = new OB_TrackingOrder.GT();
        gt.sistemaSorgente = 'sistemaSorgenteValueGT';
        gt.statoProvisioning = 'statoProvisioningValueGT';
        gt.codiceCliente = 'codiceClienteValueGT';
        gt.errori = null;
        gt.puntiVendita = pvGTList;
        List<OB_TrackingOrder.GT> gtList = new List<OB_TrackingOrder.GT>();
        gtList.add(gt);

        OB_TrackingOrder.Acquiring acquiring = new OB_TrackingOrder.Acquiring();
        acquiring.sistemaSorgente = 'sistemaSorgenteValueAcquiring';
        acquiring.codiceSocieta = 'codiceSocietaValueAcquiring';
        acquiring.errori = null;
        acquiring.puntiVendita = pvAcquiringList;
        List<OB_TrackingOrder.Acquiring> acquiringList = new List<OB_TrackingOrder.Acquiring>();
        acquiringList.add(acquiring);

        OB_TrackingOrder.TrackingOrderRequest tor = new OB_TrackingOrder.TrackingOrderRequest();
        tor.idOrdineSfdc = ord.id;
        tor.Acquiring = acquiringList;
        tor.GT = gtList;







        // OB_TrackingOrder.TermsIdInformation tiiAcquiring = new OB_TrackingOrder.TermsIdInformation();

        // //String requestTrackingString = '{ "idOrdineSfdc": "' + ord.id + '", "Acquiring": [ { "sistemaSorgente": "sistemaSorgenteValue", "codiceSocieta": "codiceSocietaValue", "errori": [ { "codice": "codiceValue", "descrizione": "descrizioneValue" } ], "puntiVendita": [ { "itemId": "itemIdValue", "codicePuntoVendita": "codicePuntoVenditaValue", "dataInizio": "dataInizioValue", "dataCessazione": "dataCessazioneValue", "causaleCessazione": "causaleCessazioneValue", "tipo": "tipoValue", "codiceCTI": "codiceCTIValue", "codiceStabilimento": "codiceStabilimentoValue", "codiceStabilimentoSIA": "codiceStabilimentoSIAValue", "codiceProgressivoSIA": "codiceProgressivoSIAValue", "codiceSIA": "codiceSIAValue", "numeroAssistenzaPOS": "numeroAssistenzaPOSValue", "dataInizioAttivita": "dataInizioAttivitavalue", "termsIdInformations": [ { "termId": "termIdValue", "modello": "modelloValue", "release": "releaseValue", "modalitaCollegamento": "modalitaCollegamentoValue", "descrizioneModello": "descrizioneModelloValue", "descrizioneRelease": "descrizioneReleaseValue", "descrizioneConnessione": "descrizioneConnessioneValue", "statoInstallazione": "statoInstallazioneValue", "causaleRifiuto": "causaleRifiutoValue", "dataInstallazione": "dataInstallazioneValue", "dataDisinstallazione": "dataDisinstallazioneValue", "codiciconvenzioni": [ { "idItemSalesforce": "idItemSalesforceValue", "companyCode": "companyCodeValue", "companyName": "companyNameValue", "codiceConvenzione": "codiceConvenzioneValue", "causaleRifiuto": "causaleRifiutoValue", "dataInizio": "dataInizioValue", "dataFine": "dataFineValue" } ] } ] } ] } ], "GT": [ { "sistemaSorgente": "sistemaSorgenteValue", "statoProvisioning": "statoProvisioningValue", "codiceCliente": "codiceClienteValue", "errori": [ { "codice": "codiceValue", "descrizione": "descrizioneValue" } ], "puntiVendita": [ { "itemId": "itemIdValue", "codicePuntoVendita": "codicePuntoVenditaValue", "dataInizio": "dataInizioValue", "dataCessazione": "dataCessazioneValue", "causaleCessazione": "causaleCessazioneValue", "tipo": "tipoValue", "codiceCTI": "codiceCTIValue", "codiceStabilimento": "codiceStabilimentoValue", "codiceStabilimentoSIA": "codiceStabilimentoSIAValue", "codiceProgressivoSIA": "codiceProgressivoSIAValue", "codiceSIA": "codiceSIAValue", "numeroAssistenzaPOS": "numeroAssistenzaPOSValue", "dataInizioAttivita": "dataInizioAttivitavalue", "termsIdInformations": [ { "termId": "termIdValue", "modello": "modelloValue", "release": "releaseValue", "modalitaCollegamento": "modalitaCollegamentoValue", "descrizioneModello": "descrizioneModelloValue", "descrizioneRelease": "descrizioneReleaseValue", "descrizioneConnessione": "descrizioneConnessioneValue", "statoInstallazione": "statoInstallazioneValue", "causaleRifiuto": "causaleRifiutoValue", "dataInstallazione": "dataInstallazioneValue", "dataDisinstallazione": "dataDisinstallazioneValue", "codiciconvenzioni": [ { "idItemSalesforce": "idItemSalesforceValue", "companyCode": "companyCodeValue", "companyName": "companyNameValue", "codiceConvenzione": "codiceConvenzioneValue", "causaleRifiuto": "causaleRifiutoValue", "dataInizio": "dataInizioValue", "dataFine": "dataFineValue" } ] } ] } ] } ] }';
        // OB_TrackingOrder.TrackingOrderRequest requestTracking  = (OB_TrackingOrder.TrackingOrderRequest)JSON.deserialize(requestTrackingString, OB_TrackingOrder.TrackingOrderRequest.class);
        // List<Acquiring> acquirings = new List<Acquiring>();
        // acquirings.add(new Acquiring(sistemaSorgente = "sistemaSorgenteValue", ));
        List<Account> accList   = new List<Account>();
        Id accountBankRecordId  = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Bank').getRecordTypeId();
        Account bankAccount     = new Account(  Name = 'TEST',
                                                RecordTypeId = accountBankRecordId,
                                                OB_Employees_Number__c = 'Minore di 10',
                                                OB_VAT_Not_Present__c = true,
                                                OB_DescriptionVATNotPresent__c = 'description',
                                                NE__Fiscal_code__c = 'RSSMRA80A01F205X',
                                                OB_BypassValidation__c = true,
                                                OB_Status__c = 'Active');
        Id rtMerchant2          = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId();
        Account myMastMerchant2 = new Account(  Name = 'TEST',
                                                RecordTypeId = rtMerchant2,
                                                OB_Employees_Number__c = 'Minore di 10',
                                                OB_VAT_Not_Present__c = true,
                                                OB_DescriptionVATNotPresent__c = 'description',
                                                NE__Fiscal_code__c = 'RSSMRA80A01F205X',
                                                OB_BypassValidation__c = true,
                                                OB_Status__c = 'Active');

        accList.add(myMastMerchant2);
        accList.add(bankAccount);
        insert accList;
        NE__Service_Point__c servicePoint1 = new NE__Service_Point__c();
        insert servicePoint1;
        NE__Order_Header__c orderHeader = new NE__Order_Header__c(OB_ProposerABI__c=bankAccount.Id ,NE__AccountId__c=myMastMerchant2.Id, OB_Main_Process__c = 'Setup' );
        insert orderHeader;
        NE__Order__c configuration = new NE__Order__c(NE__AccountId__c=myMastMerchant2.Id ,OB_Service_Point__c = servicePoint1.Id,NE__Order_Header__c=orderHeader.Id,OB_MCCL2__c = 'test');
        insert configuration;
        NE__OrderItem__c orderItem2 = New NE__OrderItem__c(NE__Qty__c=10 ,NE__OrderId__c=configuration.id);
        insert orderItem2;


        /*#############################################    AV   ##################################################*/

        NE__Order_Item_Attribute__c attr1 = new NE__Order_Item_Attribute__c();
        attr1.Name = 'TermId';
        attr1.NE__Order_Item__c = orderItem2.id;
        insert attr1;
        NE__Order_Item_Attribute__c attr2 = new NE__Order_Item_Attribute__c();
        attr2.Name = 'modello';
        attr2.NE__Order_Item__c = orderItem2.id;
        insert attr2;
        NE__Order_Item_Attribute__c attr3 = new NE__Order_Item_Attribute__c();
        attr3.Name = 'release';
        attr3.NE__Order_Item__c = orderItem2.id;
        insert attr3;
        NE__Order_Item_Attribute__c attr4 = new NE__Order_Item_Attribute__c();
        attr4.Name = 'modalitaCollegamento';
        attr4.NE__Order_Item__c = orderItem2.id;
        insert attr4;
        NE__Order_Item_Attribute__c attr5 = new NE__Order_Item_Attribute__c();
        attr5.Name = 'descrizioneModello';
        attr5.NE__Order_Item__c = orderItem2.id;
        insert attr5;
        NE__Order_Item_Attribute__c attr6 = new NE__Order_Item_Attribute__c();
        attr6.Name = 'descrizioneRelease';
        attr6.NE__Order_Item__c = orderItem2.id;
        insert attr6;
        NE__Order_Item_Attribute__c attr7 = new NE__Order_Item_Attribute__c();
        attr7.Name = 'descrizioneConnessione';
        attr7.NE__Order_Item__c = orderItem2.id;
        insert attr7;
        NE__Order_Item_Attribute__c attr8 = new NE__Order_Item_Attribute__c();
        attr8.Name = 'Progressivo SIA';
        attr8.NE__Order_Item__c = orderItem2.id;
        insert attr8;
        NE__Order_Item_Attribute__c attr9 = new NE__Order_Item_Attribute__c();
        attr9.Name = 'Codice Stabilimento SIA';
        attr9.NE__Order_Item__c = orderItem2.id;
        insert attr9;
        NE__Order_Item_Attribute__c attr10 = new NE__Order_Item_Attribute__c();
        attr10.Name = 'Codice SIA';
        attr10.NE__Order_Item__c = orderItem2.id;
        insert attr10;

        /*#############################################    AV   ##################################################*/


        OB_Bank_Profile__c bp = new OB_Bank_Profile__c();
        bp.OB_Bank__c                           = bankAccount.Id;
        bp.OB_Service_Type__c                   = 'Acquiring';
        bp.OB_Business_Model_POS__c             = 'Bilaterale';
        bp.OB_Circuit__c                        = 'JCB';
        bp.OB_Other_Acquirer__c                 = 'Amex';
        bp.OB_Applicant_RAC_Code_SIA__c         = 'Banca';
        bp.OB_Terminal_Id_Generator__c          = 'Banca';
        bp.OB_Technical_component_invoicing__c  = 'TecMarket(servizio fatturazione per conto terzi)';
        bp.OB_GT__c                             = 'Nexi';
        bp.OB_Processor__c                      = 'SIA SMAC';
        bp.OB_Bilateral_Pricing__c              = 'SI';
        bp.OB_Sending_Contract_to_Nexi__c       = 'SI';
        bp.OB_SME_Factory__c                    = 'SI';
        insert bp;
        //      System.debug('QUERY BANK PROFILE: '+[SELECT id,OB_Business_Model_Acquiring__c FROM OB_Bank_Profile__c where OB_Bank__c =:bankAccount.Id]);
        Datetime dataInizio     = Datetime.newInstance(1960, 2, 17);
        Datetime dataCessazione = Datetime.newInstance(1962, 2, 17);
        //String request = '{"idOrdineSfdc": "'+configuration.id+'","Acquiring": [{"sistemaSorgente": "EQUENS","codiceSocieta": "1114558","puntiVendita": [{"itemId": "'+orderItem2.Id+'","codicePuntoVendita": "3249896","dataInizio": "2011-11-13","dataCessazione": "2011-11-14","causaleCessazione": "","tipo": ""}],"errori": []}] , "GT" : [ { "termsIdInformation": [ { "termId": "test", "statoInstallazione": "test", "release": "test", "modello": "test", "modalitaCollegamento": "test", "descrizioneRelease": "test", "descrizioneModello": "test", "descrizioneConnessione": "test", "dataInstallazione": "test", "dataDisinstallazione": "test", "codiciconvenzioni": [ { "idItemSalesforce": "test", "dataInizio": "test", "dataFine": "test", "companyName": "test", "companyCode": "test", "codiceConvenzione": "test", "causaleRifiuto": "test" } ], "causaleRifiuto": "test" } ], "statoProvisioning": "test", "sistemaSorgente": "test", "puntiVendita": [{ "termsIdInformations" :"[{"termId" : "'+orderItem2.Id+'"}]"  , "tipo": "test", "numeroVerde": "test", "itemId": "'+orderItem2.Id+'", "dataInizioAttivita": "test", "dataInizio": "test", "dataCessazione": "test", "codiceStabilimentoSIA": "test", "codiceSIA": "test", "codicePuntoVendita": "test", "codiceProgressivoSIA": "test", "codiceCTI": "test", "causaleCessazione": "test" } ], "errori": [ { "descrizione": "test", "codice": "test" } ], "codiceCliente": "test" } ]}';
        //String request = '{"idOrdineSfdc": "'+configuration.id+'","Acquiring": [{"sistemaSorgente": "EQUENS","codiceSocieta": "1114558","puntiVendita": [{"itemId" :"'+orderItem2.Id+'","codicePuntoVendita": "3249896","dataInizio": "1990-05-12","dataCessazione": "1991-05-12","causaleCessazione": "Test","tipo": "FISICO"}],"errori": []}],"GT" : [{"sistemaSorgente":"NEXI","statoProvisioning":"","codiceCliente" : "12345678","puntiVendita":[{"codiceCTI":"CTI","codiceStabilimento":"1234","codiceProgressivoSIA" : "","codiceStabilimentoSIA":"","codiceSIA" :"","numeroVerde"  :"","dataInizioAttivita":"","tipo":"","termIdInformations" :{"termId" :"'+orderItem2.Id+'","modello" : "test","release" : "test","modalitaCollegament" : "","descrizioneModello" : "","descrizioneRelease" : "","descrizioineConnessione" : "","statoInstallazione" :"","causaleRifiuto" :"","dataDisintallazione" : "","codiciConvenzioni":{"idItemSalesforce" :"","companyCode" : "","companyName" :"","codiceConvenzione" : "1234","causaleRifiuto" :"","dataInizio" :"","dataFine" : ""}}}],"errori": []}] }';
        //String request = '{"idOrdineSfdc":"'+configuration.id+'","Acquiring":[{"sistemaSorgente":"EQUENS","codiceSocieta":"1114558","puntiVendita":[{"itemId":"'+orderItem2.Id+'","codicePuntoVendita":"3249896","dataInizio":"1990-05-12","dataCessazione":"1991-05-12","causaleCessazione":"Test","tipo":"FISICO"}],"errori":[]}],"GT":[{"sistemaSorgente":"NEXI","statoProvisioning":"Installato","codiceCliente":"12345678","puntiVendita":[{"codiceCTI":"CTI","codiceStabilimento":"1234","codiceProgressivoSIA":"666","codiceStabilimentoSIA":"666","codiceSIA":"666","numeroVerde":"1234","dataInizio":"12-12-2000","dataInizioAttivita":"","tipo":"","termIdInformation":[{"termId":"'+orderItem2.Id+'","modello":"test","release":"test","modalitaCollegament":"","descrizioneModello":"","descrizioneRelease":"","descrizioineConnessione":"","statoInstallazione":"","causaleRifiuto":"","dataDisintallazione":"","codiciConvenzioni":[{"idItemSalesforce":"","companyCode":"","companyName":"","codiceConvenzione":"1234","causaleRifiuto":"","dataInizio":"","dataFine":""}]}]}],"errori":[]}]}';
        String request   = '{"idOrdineSfdc":"'+configuration.id+'","GT":[{"sistemaSorgente":"NEXI","statoProvisioning":"Installato","codiceCliente":"12345678","puntiVendita":[{"codiceCTI":"CTI","codiceStabilimento":"1234","codiceProgressivoSIA":"666","codiceStabilimentoSIA":"666","codiceSIA":"666","numeroVerde":"1234","dataInizio":"12-12-2000","dataInizioAttivita":"","tipo":"","termIdInformation":[{"termId":"'+orderItemGTRoot.Id+'","modello":"test","release":"test","modalitaCollegament":"","descrizioneModello":"","descrizioneRelease":"","descrizioineConnessione":"","statoInstallazione":"","causaleRifiuto":"","dataDisintallazione":"","codiciConvenzioni":[{"idItemSalesforce":"","companyCode":"","companyName":"","codiceConvenzione":"1234","causaleRifiuto":"","dataInizio":"","dataFine":""}]}]}],"errori":[]}]}';

        RestContext.request = new RestRequest();
        RestContext.request.requestBody =  Blob.valueof(request);

    //  requestTracking = (OB_TrackingOrder.TrackingOrderRequest)JSON.deserialize(request, OB_TrackingOrder.TrackingOrderRequest.class);
    //  Id rtProduct2   = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.TERMINALE).getRecordTypeId();
    //  NE__Product__c product2 = new NE__Product__c(RecordTypeId =rtProduct2 );
    //  insert product2;
    //  orderItem2.NE__OrderId__c    = requestTracking.idOrdineSfdc;
    //  orderItem2.NE__ProdId__c     = product2.Id;
    //  orderItem2.OB_TermId__c      = orderItem2.Id;//text field);
    //    orderItem2.OB_Terminal_Id__c = orderItem2.Id;
        update orderItem2;
        List<ExternalSourceMapping__c> extList = new List<ExternalSourceMapping__c>();
        //System.debug('requestTracking: ' + requestTracking);
        //ExternalSourceMapping__c ext = new ExternalSourceMapping__c(OB_Merchant_ID__c=configuration.NE__AccountId__c ,
        //  OB_Service_Point_ID__c = configuration.OB_Service_Point__c,
        //  OB_ServicePointCodeShopCode__c='test' ,
        //  OB_Source__c=requestTracking.GT[0].sistemaSorgente,
        //  OB_Conventioncode__c=requestTracking.GT[0].puntiVendita[0].termIdInformation[0].codiciConvenzioni[0].codiceConvenzione,
        //   OB_CustomerCodeClientCode__c='TEST');
        //System.debug('GT ARRAY: '+requestTracking.GT[0].codiceCliente);
        Id rtMerchant3  = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId();
        Account acc3    = new Account(  Name='TEST',
                                                    RecordTypeId=rtMerchant3,
                                                    OB_Employees_Number__c='Minore di 10',
                                                    OB_VAT_Not_Present__c=true,
                                                    OB_DescriptionVATNotPresent__c='description',
                                                    NE__Fiscal_code__c='RSSMRA80A01F205X',
                                                    OB_BypassValidation__c=true,
                                                    OB_Status__c='Active');
        insert acc3;
        NE__Service_Point__c servicePoint2 = new NE__Service_Point__c();
        insert servicePoint2;
        ExternalSourceMapping__c ext2 = new ExternalSourceMapping__c(OB_Merchant_ID__c=acc3.Id , OB_CustomerCodeClientCode__c='' , OB_Source__c='EQUENS',OB_Service_Point_ID__c=servicePoint2.Id);
        //extList.add(ext);
        extList.add(ext2);
        insert extList;

        System.debug('IF CONDITION GT: ' +orderItem2.NE__ProdId__c);

        NE__Order_Item_Attribute__c orderItemAttribute = new NE__Order_Item_Attribute__c(Name = 'Terminal Id', NE__Order_Item__c = orderItem2.id);
        insert orderItemAttribute;

        NE__Lov__c lovMCC2 = new NE__Lov__c();
        lovMCC2.ne__type__c   = 'mcc';
        lovMCC2.ne__value3__c = 'L2';
        lovMCC2.OB_Value4__c  = configuration.OB_MCCL2__c;
        insert lovMCC2;

                    //ExternalSourceMapping__c servicePointEquens = [select id,OB_ServicePointCodeShopCode__c  from ExternalSourceMapping__c where OB_Source__c = 'EQUENS' AND OB_Service_Point_ID__c =:servicePointId];


        Test.startTest();
        try
        {
            OB_TrackingOrder.getTrackingOrder(tor);
        }
        catch(Exception e)
        {
            System.debug('Generic exception');
        }
        Test.stopTest();
        }

////////////////////////////////////////////////////////////////.....GT......
@isTest
    public static void getTrackingOrderTest_3(){

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

        NE__Service_Point__c sp  = new NE__Service_Point__c();
        sp.OB_MCC__c   ='2345';
        sp.NE__City__c = 'Yaounde';
        insert sp;

        NE__Lov__c lov = new NE__Lov__c();
        lov.NE__Sub_Type__c = 'TIPOLOGICHE';
        lov.NE__Type__c = 'TRACKING';
        lov.NE__Value1__c = 'NE__Value1__c';
        lov.NE__Value2__c = 'NE__Value2__c';
        insert lov;

        NE__Lov__c lov2 = new NE__Lov__c();
        lov2.NE__Sub_Type__c = 'TIPOLOGICHE';
        lov2.NE__Type__c = 'mcc';
        lov2.NE__Value1__c = 'NE__Value1__c';
        lov2.NE__Value2__c = '00';
        lov2.ne__value3__c = 'L2';
        insert lov2;
        Id rtProduct = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.TERMINALE).getRecordTypeId(); 
        NE__Product__c prod = new NE__Product__c();
        prod.OB_Acquirer__c = OB_EnrichOrder.NEXI; 
        prod.RecordTypeId = rtProduct;
        insert prod;
        NE__Product__c prod2 = new NE__Product__c();
        prod2.OB_Acquirer__c = OB_EnrichOrder.NEXI; 
        prod2.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'NE__Product__c' AND DeveloperName = 'Terminali' LIMIT 1].id;
        insert prod2;

        NE__Order_Header__c oh = new NE__Order_Header__c();
        oh.OB_Business_Model_Acquiring__c = 'Diretto';
        oh.OB_Main_Process__c = 'Setup';
        insert oh;
        NE__Order__c ord = new NE__Order__c();
        ord.NE__AccountId__c = acc.id;
        ord.NE__BillAccId__c = acc.Id;
        ord.NE__ServAccId__c = acc.Id;
        ord.NE__Order_Header__c = oh.id;
        ord.OB_Service_Point__c = sp.id;
        ord.OB_MCCL2__c = '00';
        ord.OB_GT__c = 'MONETICA';
        ord.OB_FulfilmentStatus__c = 'Sent';
        insert ord;
        NE__OrderItem__c oi = new NE__OrderItem__c();
        oi.RecordTypeId =[SELECT Id FROM RecordType WHERE sObjectType = 'NE__OrderItem__c' AND DeveloperName = 'Terminali' LIMIT 1].id;
        oi.OB_GT__c = 'MONETICA';
        oi.NE__Status__c = 'Completed';
        oi.NE__ProdId__c = prod.id;
        oi.NE__OrderId__c = ord.id;
        oi.NE__Qty__c = 1;
        oi.OB_TermId__c = 'OB_TermId__c';
        insert oi;

        Id rtProductGTRoot          = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.TERMINALE).getRecordTypeId(); 
        NE__Product__c productGTRoot = new NE__Product__c(RecordTypeId = rtProductGTRoot, OB_Codice_sfdc__c = 'SMPOS_CASSA', Name = 'SmartPOS Cassa', OB_Contract_Type__c = 'Contratto POS;Modulo Off Commercial', OB_Business_Model_POS__c = 'Diretto;Trilaterale Nuovo');
        insert productGTRoot;
        NE__OrderItem__c orderItemGTRoot = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = ord.id, NE__Action__c = 'Add', OB_GT__c = 'MONETICA', OB_TermId__c = '21021990', NE__ProdId__c = productGTRoot.id, NE__Status__c = 'PENDING', OB_FulfilmentStatus__c = 'Pending', OB_Tech_Outcome_Monetica__c = 'OK');
        insert orderItemGTRoot;
        NE__Order_Item_Attribute__c oiaTermId = new NE__Order_Item_Attribute__c();
        oiaTermId.Name = 'TermId';
        oiaTermId.NE__Order_Item__c = orderItemGTRoot.id;
        insert oiaTermId;
        NE__Order_Item_Attribute__c oiaModello = new NE__Order_Item_Attribute__c();
        oiaModello.Name = 'modello';
        oiaModello.NE__Order_Item__c = orderItemGTRoot.id;
        insert oiaModello;
        NE__Order_Item_Attribute__c oiaRelease = new NE__Order_Item_Attribute__c();
        oiaRelease.Name = 'release';
        oiaRelease.NE__Order_Item__c = orderItemGTRoot.id;
        insert oiaRelease;
        NE__Order_Item_Attribute__c oiaModalitaCollegamento = new NE__Order_Item_Attribute__c();
        oiaModalitaCollegamento.Name = 'modalitaCollegamento';
        oiaModalitaCollegamento.NE__Order_Item__c = orderItemGTRoot.id;
        insert oiaModalitaCollegamento;
        NE__Order_Item_Attribute__c oiaDescrizioneModello = new NE__Order_Item_Attribute__c();
        oiaDescrizioneModello.Name = 'Descrizione Modello';
        oiaDescrizioneModello.NE__Order_Item__c = orderItemGTRoot.id;
        insert oiaDescrizioneModello;
        NE__Order_Item_Attribute__c oiaDescrizioneRelease = new NE__Order_Item_Attribute__c();
        oiaDescrizioneRelease.Name = 'Descrizione Release';
        oiaDescrizioneRelease.NE__Order_Item__c = orderItemGTRoot.id;
        insert oiaDescrizioneRelease;
        NE__Order_Item_Attribute__c oiaDescrizioneConnessione = new NE__Order_Item_Attribute__c();
        oiaDescrizioneConnessione.Name = 'Descrizione Connessione';
        oiaDescrizioneConnessione.NE__Order_Item__c = orderItemGTRoot.id;
        insert oiaDescrizioneConnessione;
        NE__Order_Item_Attribute__c oiaProgressivoSIA = new NE__Order_Item_Attribute__c();
        oiaProgressivoSIA.Name = 'Progressivo SIA';
        oiaProgressivoSIA.NE__Order_Item__c = orderItemGTRoot.id;
        insert oiaProgressivoSIA;
        NE__Order_Item_Attribute__c oiaCodiceStabilimentoSIA = new NE__Order_Item_Attribute__c();
        oiaCodiceStabilimentoSIA.Name = 'Codice Stabilimento SIA';
        oiaCodiceStabilimentoSIA.NE__Order_Item__c = orderItemGTRoot.id;
        insert oiaCodiceStabilimentoSIA;
        NE__Order_Item_Attribute__c oiaCodiceSIA = new NE__Order_Item_Attribute__c();
        oiaCodiceSIA.Name = 'Codice SIA';
        oiaCodiceSIA.NE__Order_Item__c = orderItemGTRoot.id;
        insert oiaCodiceSIA;

        //Create a new OB_TrackingOrder.CodiciConvenzioni for GT and for Acquiring

        OB_TrackingOrder.CodiciConvenzioni ccGT = new OB_TrackingOrder.CodiciConvenzioni();
        ccGT.idItemSalesforce = 'idItemSalesforceValueGT';
        ccGT.companyCode = 'companyCodeValueGT';
        ccGT.companyName = 'companyNameValueGT';
        ccGT.codiceConvenzione = 'codiceConvenzioneValueGT';
        ccGT.causaleRifiuto = 'causaleRifiutoValueGT';
        ccGT.dataInizio = '2019-04-03';
        ccGT.dataFine = '2019-04-03';
        List<OB_TrackingOrder.CodiciConvenzioni> ccGTList = new List<OB_TrackingOrder.CodiciConvenzioni>();
        ccGTList.add(ccGT);

        OB_TrackingOrder.TermsIdInformation tiiGT = new OB_TrackingOrder.TermsIdInformation();
        tiiGT.termId = '21021990';
        tiiGT.modello = 'modelloValueGT';
        tiiGT.release = 'releaseValueGT';
        tiiGT.modalitaCollegamento = 'modalitaCollegamentoValueGT';
        tiiGT.descrizioneModello = 'descrizioneModelloValueGT';
        tiiGT.descrizioneRelease = 'descrizioneReleaseValueGT';
        tiiGT.descrizioneConnessione = 'descrizioneConnessioneValueGT';
        tiiGT.statoInstallazione = 'Installato';
        tiiGT.causaleRifiuto = 'statoInstallazioneValueGT';
        tiiGT.dataInstallazione = '2019-04-03';
        tiiGT.dataDisinstallazione = '2019-04-03';
        tiiGT.codiciconvenzioni = ccGTList;
        List<OB_TrackingOrder.TermsIdInformation> tiiGTList = new List<OB_TrackingOrder.TermsIdInformation>();
        tiiGTList.add(tiiGT);
        OB_TrackingOrder.ErrorList errore = new OB_TrackingOrder.ErrorList();

        List<OB_TrackingOrder.ErrorList> erroriList = new List<OB_TrackingOrder.ErrorList>();
      //  erroriList.add(errore);



        /*OB_TrackingOrder.ErrorList erroriGT = new OB_TrackingOrder.ErrorList();
        erroriGT.codice = 'codiceValueGT';
        erroriGT.descrizione = 'descrizioneValueGT';
        List<OB_TrackingOrder.ErrorList> erroriGTList = new List<OB_TrackingOrder.ErrorList>();
        erroriGTList.add(erroriGT);

        OB_TrackingOrder.ErrorList erroriAcquiring = new OB_TrackingOrder.ErrorList();
        erroriAcquiring.codice = 'codiceValueAcquiring';
        erroriAcquiring.descrizione = 'descrizioneValueAcquiring';
        List<OB_TrackingOrder.ErrorList> erroriAcquiringList = new List<OB_TrackingOrder.ErrorList>();
        erroriAcquiringList.add(erroriAcquiring);*/

        OB_TrackingOrder.puntoVendita pvGT = new OB_TrackingOrder.puntoVendita();
        pvGT.itemId = 'itemIdValueGT';
        pvGT.codicePuntoVendita = 'codicePuntoVenditaValueGT';
        pvGT.dataInizio = '2019-04-03';
        pvGT.dataCessazione = '2019-04-03';
        pvGT.causaleCessazione = 'causaleCessazioneValueGT';
        pvGT.tipo = 'Fisico';
        pvGT.codiceCTI = 'CT';
        pvGT.codiceStabilimento = 'codiceStabilimentoValueGT';
        pvGT.codiceStabilimentoSIA = 'codiceStabilimentoSIAValueGT';
        pvGT.codiceProgressivoSIA = 'codiceProgressivoSIAValueGT';
        pvGT.codiceSIA = 'codiceSIAValueGT';
        pvGT.numeroAssistenzaPOS = 'numeroAssistenzaPOSValueGT';
        pvGT.dataInizioAttivita = '2019-04-03';
        pvGT.termsIdInformations = tiiGTList;
        List<OB_TrackingOrder.puntoVendita> pvGTList = new List<OB_TrackingOrder.puntoVendita>();
        pvGTList.add(pvGT);

        OB_TrackingOrder.GT gt = new OB_TrackingOrder.GT();
        gt.sistemaSorgente = 'sistemaSorgenteValueGT';
        gt.statoProvisioning = 'statoProvisioningValueGT';
        gt.codiceCliente = 'codiceClienteValueGT';
        gt.errori = null;
        gt.puntiVendita = pvGTList;
        List<OB_TrackingOrder.GT> gtList = new List<OB_TrackingOrder.GT>();
        gtList.add(gt);
        gt.errori = erroriList;
        OB_TrackingOrder.TrackingOrderRequest tor = new OB_TrackingOrder.TrackingOrderRequest();
        tor.idOrdineSfdc = ord.id;
        tor.GT = gtList;
        // OB_TrackingOrder.TermsIdInformation tiiAcquiring = new OB_TrackingOrder.TermsIdInformation();

        // //String requestTrackingString = '{ "idOrdineSfdc": "' + ord.id + '", "Acquiring": [ { "sistemaSorgente": "sistemaSorgenteValue", "codiceSocieta": "codiceSocietaValue", "errori": [ { "codice": "codiceValue", "descrizione": "descrizioneValue" } ], "puntiVendita": [ { "itemId": "itemIdValue", "codicePuntoVendita": "codicePuntoVenditaValue", "dataInizio": "dataInizioValue", "dataCessazione": "dataCessazioneValue", "causaleCessazione": "causaleCessazioneValue", "tipo": "tipoValue", "codiceCTI": "codiceCTIValue", "codiceStabilimento": "codiceStabilimentoValue", "codiceStabilimentoSIA": "codiceStabilimentoSIAValue", "codiceProgressivoSIA": "codiceProgressivoSIAValue", "codiceSIA": "codiceSIAValue", "numeroAssistenzaPOS": "numeroAssistenzaPOSValue", "dataInizioAttivita": "dataInizioAttivitavalue", "termsIdInformations": [ { "termId": "termIdValue", "modello": "modelloValue", "release": "releaseValue", "modalitaCollegamento": "modalitaCollegamentoValue", "descrizioneModello": "descrizioneModelloValue", "descrizioneRelease": "descrizioneReleaseValue", "descrizioneConnessione": "descrizioneConnessioneValue", "statoInstallazione": "statoInstallazioneValue", "causaleRifiuto": "causaleRifiutoValue", "dataInstallazione": "dataInstallazioneValue", "dataDisinstallazione": "dataDisinstallazioneValue", "codiciconvenzioni": [ { "idItemSalesforce": "idItemSalesforceValue", "companyCode": "companyCodeValue", "companyName": "companyNameValue", "codiceConvenzione": "codiceConvenzioneValue", "causaleRifiuto": "causaleRifiutoValue", "dataInizio": "dataInizioValue", "dataFine": "dataFineValue" } ] } ] } ] } ], "GT": [ { "sistemaSorgente": "sistemaSorgenteValue", "statoProvisioning": "statoProvisioningValue", "codiceCliente": "codiceClienteValue", "errori": [ { "codice": "codiceValue", "descrizione": "descrizioneValue" } ], "puntiVendita": [ { "itemId": "itemIdValue", "codicePuntoVendita": "codicePuntoVenditaValue", "dataInizio": "dataInizioValue", "dataCessazione": "dataCessazioneValue", "causaleCessazione": "causaleCessazioneValue", "tipo": "tipoValue", "codiceCTI": "codiceCTIValue", "codiceStabilimento": "codiceStabilimentoValue", "codiceStabilimentoSIA": "codiceStabilimentoSIAValue", "codiceProgressivoSIA": "codiceProgressivoSIAValue", "codiceSIA": "codiceSIAValue", "numeroAssistenzaPOS": "numeroAssistenzaPOSValue", "dataInizioAttivita": "dataInizioAttivitavalue", "termsIdInformations": [ { "termId": "termIdValue", "modello": "modelloValue", "release": "releaseValue", "modalitaCollegamento": "modalitaCollegamentoValue", "descrizioneModello": "descrizioneModelloValue", "descrizioneRelease": "descrizioneReleaseValue", "descrizioneConnessione": "descrizioneConnessioneValue", "statoInstallazione": "statoInstallazioneValue", "causaleRifiuto": "causaleRifiutoValue", "dataInstallazione": "dataInstallazioneValue", "dataDisinstallazione": "dataDisinstallazioneValue", "codiciconvenzioni": [ { "idItemSalesforce": "idItemSalesforceValue", "companyCode": "companyCodeValue", "companyName": "companyNameValue", "codiceConvenzione": "codiceConvenzioneValue", "causaleRifiuto": "causaleRifiutoValue", "dataInizio": "dataInizioValue", "dataFine": "dataFineValue" } ] } ] } ] } ] }';
        // OB_TrackingOrder.TrackingOrderRequest requestTracking  = (OB_TrackingOrder.TrackingOrderRequest)JSON.deserialize(requestTrackingString, OB_TrackingOrder.TrackingOrderRequest.class);
        // List<Acquiring> acquirings = new List<Acquiring>();
        // acquirings.add(new Acquiring(sistemaSorgente = "sistemaSorgenteValue", ));
        List<Account> accList   = new List<Account>();
        Id accountBankRecordId  = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Bank').getRecordTypeId();
        Account bankAccount     = new Account(  Name = 'TEST',
                                                RecordTypeId = accountBankRecordId,
                                                OB_Employees_Number__c = 'Minore di 10',
                                                OB_VAT_Not_Present__c = true,
                                                OB_DescriptionVATNotPresent__c = 'description',
                                                NE__Fiscal_code__c = 'RSSMRA80A01F205X',
                                                OB_BypassValidation__c = true,
                                                OB_Status__c = 'Active');
        Id rtMerchant2          = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId();
        Account myMastMerchant2 = new Account(  Name = 'TEST',
                                                RecordTypeId = rtMerchant2,
                                                OB_Employees_Number__c = 'Minore di 10',
                                                OB_VAT_Not_Present__c = true,
                                                OB_DescriptionVATNotPresent__c = 'description',
                                                NE__Fiscal_code__c = 'RSSMRA80A01F205X',
                                                OB_BypassValidation__c = true,
                                                OB_Status__c = 'Active');

        accList.add(myMastMerchant2);
        accList.add(bankAccount);
        insert accList;
        NE__Service_Point__c servicePoint1 = new NE__Service_Point__c();
        insert servicePoint1;
        NE__Order_Header__c orderHeader = new NE__Order_Header__c(OB_ProposerABI__c=bankAccount.Id ,NE__AccountId__c=myMastMerchant2.Id, OB_Main_Process__c = 'Setup' );
        insert orderHeader;
        NE__Order__c configuration = new NE__Order__c(NE__AccountId__c=myMastMerchant2.Id ,OB_Service_Point__c = servicePoint1.Id,NE__Order_Header__c=orderHeader.Id,OB_MCCL2__c = 'test');
        insert configuration;
        NE__OrderItem__c orderItem2 = New NE__OrderItem__c(NE__Qty__c=10 ,NE__OrderId__c=configuration.id);
        insert orderItem2;

        /*#############################################    AV   ##################################################*/

        NE__Order_Item_Attribute__c attr1 = new NE__Order_Item_Attribute__c();
        attr1.Name = 'TermId';
        attr1.NE__Order_Item__c = orderItem2.id;
        insert attr1;
        NE__Order_Item_Attribute__c attr2 = new NE__Order_Item_Attribute__c();
        attr2.Name = 'modello';
        attr2.NE__Order_Item__c = orderItem2.id;
        insert attr2;
        NE__Order_Item_Attribute__c attr3 = new NE__Order_Item_Attribute__c();
        attr3.Name = 'release';
        attr3.NE__Order_Item__c = orderItem2.id;
        insert attr3;
        NE__Order_Item_Attribute__c attr4 = new NE__Order_Item_Attribute__c();
        attr4.Name = 'modalitaCollegamento';
        attr4.NE__Order_Item__c = orderItem2.id;
        insert attr4;
        NE__Order_Item_Attribute__c attr5 = new NE__Order_Item_Attribute__c();
        attr5.Name = 'descrizioneModello';
        attr5.NE__Order_Item__c = orderItem2.id;
        insert attr5;
        NE__Order_Item_Attribute__c attr6 = new NE__Order_Item_Attribute__c();
        attr6.Name = 'descrizioneRelease';
        attr6.NE__Order_Item__c = orderItem2.id;
        insert attr6;
        NE__Order_Item_Attribute__c attr7 = new NE__Order_Item_Attribute__c();
        attr7.Name = 'descrizioneConnessione';
        attr7.NE__Order_Item__c = orderItem2.id;
        insert attr7;
        NE__Order_Item_Attribute__c attr8 = new NE__Order_Item_Attribute__c();
        attr8.Name = 'Progressivo SIA';
        attr8.NE__Order_Item__c = orderItem2.id;
        insert attr8;
        NE__Order_Item_Attribute__c attr9 = new NE__Order_Item_Attribute__c();
        attr9.Name = 'Codice Stabilimento SIA';
        attr9.NE__Order_Item__c = orderItem2.id;
        insert attr9;
        NE__Order_Item_Attribute__c attr10 = new NE__Order_Item_Attribute__c();
        attr10.Name = 'Codice SIA';
        attr10.NE__Order_Item__c = orderItem2.id;
        insert attr10;

        /*#############################################    AV   ##################################################*/


        OB_Bank_Profile__c bp = new OB_Bank_Profile__c();
        bp.OB_Bank__c                           = bankAccount.Id;
        bp.OB_Service_Type__c                   = 'Acquiring';
        bp.OB_Business_Model_POS__c             = 'Bilaterale';
        bp.OB_Circuit__c                        = 'JCB';
        bp.OB_Other_Acquirer__c                 = 'Amex';
        bp.OB_Applicant_RAC_Code_SIA__c         = 'Banca';
        bp.OB_Terminal_Id_Generator__c          = 'Banca';
        bp.OB_Technical_component_invoicing__c  = 'TecMarket(servizio fatturazione per conto terzi)';
        bp.OB_GT__c                             = 'Nexi';
        bp.OB_Processor__c                      = 'SIA SMAC';
        bp.OB_Bilateral_Pricing__c              = 'SI';
        bp.OB_Sending_Contract_to_Nexi__c       = 'SI';
        bp.OB_SME_Factory__c                    = 'SI';
        insert bp;
        //      System.debug('QUERY BANK PROFILE: '+[SELECT id,OB_Business_Model_Acquiring__c FROM OB_Bank_Profile__c where OB_Bank__c =:bankAccount.Id]);
        Datetime dataInizio     = Datetime.newInstance(1960, 2, 17);
        Datetime dataCessazione = Datetime.newInstance(1962, 2, 17);
        //String request = '{"idOrdineSfdc": "'+configuration.id+'","Acquiring": [{"sistemaSorgente": "EQUENS","codiceSocieta": "1114558","puntiVendita": [{"itemId": "'+orderItem2.Id+'","codicePuntoVendita": "3249896","dataInizio": "2011-11-13","dataCessazione": "2011-11-14","causaleCessazione": "","tipo": ""}],"errori": []}] , "GT" : [ { "termsIdInformation": [ { "termId": "test", "statoInstallazione": "test", "release": "test", "modello": "test", "modalitaCollegamento": "test", "descrizioneRelease": "test", "descrizioneModello": "test", "descrizioneConnessione": "test", "dataInstallazione": "test", "dataDisinstallazione": "test", "codiciconvenzioni": [ { "idItemSalesforce": "test", "dataInizio": "test", "dataFine": "test", "companyName": "test", "companyCode": "test", "codiceConvenzione": "test", "causaleRifiuto": "test" } ], "causaleRifiuto": "test" } ], "statoProvisioning": "test", "sistemaSorgente": "test", "puntiVendita": [{ "termsIdInformations" :"[{"termId" : "'+orderItem2.Id+'"}]"  , "tipo": "test", "numeroVerde": "test", "itemId": "'+orderItem2.Id+'", "dataInizioAttivita": "test", "dataInizio": "test", "dataCessazione": "test", "codiceStabilimentoSIA": "test", "codiceSIA": "test", "codicePuntoVendita": "test", "codiceProgressivoSIA": "test", "codiceCTI": "test", "causaleCessazione": "test" } ], "errori": [ { "descrizione": "test", "codice": "test" } ], "codiceCliente": "test" } ]}';
        //String request = '{"idOrdineSfdc": "'+configuration.id+'","Acquiring": [{"sistemaSorgente": "EQUENS","codiceSocieta": "1114558","puntiVendita": [{"itemId" :"'+orderItem2.Id+'","codicePuntoVendita": "3249896","dataInizio": "1990-05-12","dataCessazione": "1991-05-12","causaleCessazione": "Test","tipo": "FISICO"}],"errori": []}],"GT" : [{"sistemaSorgente":"NEXI","statoProvisioning":"","codiceCliente" : "12345678","puntiVendita":[{"codiceCTI":"CTI","codiceStabilimento":"1234","codiceProgressivoSIA" : "","codiceStabilimentoSIA":"","codiceSIA" :"","numeroVerde"  :"","dataInizioAttivita":"","tipo":"","termIdInformations" :{"termId" :"'+orderItem2.Id+'","modello" : "test","release" : "test","modalitaCollegament" : "","descrizioneModello" : "","descrizioneRelease" : "","descrizioineConnessione" : "","statoInstallazione" :"","causaleRifiuto" :"","dataDisintallazione" : "","codiciConvenzioni":{"idItemSalesforce" :"","companyCode" : "","companyName" :"","codiceConvenzione" : "1234","causaleRifiuto" :"","dataInizio" :"","dataFine" : ""}}}],"errori": []}] }';
        //String request = '{"idOrdineSfdc":"'+configuration.id+'","Acquiring":[{"sistemaSorgente":"EQUENS","codiceSocieta":"1114558","puntiVendita":[{"itemId":"'+orderItem2.Id+'","codicePuntoVendita":"3249896","dataInizio":"1990-05-12","dataCessazione":"1991-05-12","causaleCessazione":"Test","tipo":"FISICO"}],"errori":[]}],"GT":[{"sistemaSorgente":"NEXI","statoProvisioning":"Installato","codiceCliente":"12345678","puntiVendita":[{"codiceCTI":"CTI","codiceStabilimento":"1234","codiceProgressivoSIA":"666","codiceStabilimentoSIA":"666","codiceSIA":"666","numeroVerde":"1234","dataInizio":"12-12-2000","dataInizioAttivita":"","tipo":"","termIdInformation":[{"termId":"'+orderItem2.Id+'","modello":"test","release":"test","modalitaCollegament":"","descrizioneModello":"","descrizioneRelease":"","descrizioineConnessione":"","statoInstallazione":"","causaleRifiuto":"","dataDisintallazione":"","codiciConvenzioni":[{"idItemSalesforce":"","companyCode":"","companyName":"","codiceConvenzione":"1234","causaleRifiuto":"","dataInizio":"","dataFine":""}]}]}],"errori":[]}]}';
       /* String request   = '{"idOrdineSfdc":"'+configuration.id+'","GT":[{"sistemaSorgente":"NEXI","statoProvisioning":"Installato","codiceCliente":"12345678","puntiVendita":[{"codiceCTI":"CTI","codiceStabilimento":"1234","codiceProgressivoSIA":"666","codiceStabilimentoSIA":"666","codiceSIA":"666","numeroVerde":"1234","dataInizio":"12-12-2000","dataInizioAttivita":"","tipo":"","termIdInformation":[{"termId":"'+orderItemGTRoot.OB_TermId__c+'","modello":"test","release":"test","modalitaCollegament":"","descrizioneModello":"","descrizioneRelease":"","descrizioineConnessione":"","statoInstallazione":"","causaleRifiuto":"","dataDisintallazione":"","codiciConvenzioni":[{"idItemSalesforce":"","companyCode":"","companyName":"","codiceConvenzione":"1234","causaleRifiuto":"","dataInizio":"","dataFine":""}]}]}],"errori":[]}]}';

        RestContext.request = new RestRequest();
        RestContext.request.requestBody =  Blob.valueof(request);*/

    //  requestTracking = (OB_TrackingOrder.TrackingOrderRequest)JSON.deserialize(request, OB_TrackingOrder.TrackingOrderRequest.class);
    //  Id rtProduct2   = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.TERMINALE).getRecordTypeId();
    //  NE__Product__c product2 = new NE__Product__c(RecordTypeId =rtProduct2 );
    //  insert product2;
    //  orderItem2.NE__OrderId__c    = requestTracking.idOrdineSfdc;
    //  orderItem2.NE__ProdId__c     = product2.Id;
    //  orderItem2.OB_TermId__c      = orderItem2.Id;//text field);
    //    orderItem2.OB_Terminal_Id__c = orderItem2.Id;
        update orderItem2;
        List<ExternalSourceMapping__c> extList = new List<ExternalSourceMapping__c>();
        //System.debug('requestTracking: ' + requestTracking);
        //ExternalSourceMapping__c ext = new ExternalSourceMapping__c(OB_Merchant_ID__c=configuration.NE__AccountId__c ,
        //  OB_Service_Point_ID__c = configuration.OB_Service_Point__c,
        //  OB_ServicePointCodeShopCode__c='test' ,
        //  OB_Source__c=requestTracking.GT[0].sistemaSorgente,
        //  OB_Conventioncode__c=requestTracking.GT[0].puntiVendita[0].termIdInformation[0].codiciConvenzioni[0].codiceConvenzione,
        //   OB_CustomerCodeClientCode__c='TEST');
        //System.debug('GT ARRAY: '+requestTracking.GT[0].codiceCliente);
        Id rtMerchant3  = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId();
        Account acc3    = new Account(  Name='TEST',
                                                    RecordTypeId=rtMerchant3,
                                                    OB_Employees_Number__c='Minore di 10',
                                                    OB_VAT_Not_Present__c=true,
                                                    OB_DescriptionVATNotPresent__c='description',
                                                    NE__Fiscal_code__c='RSSMRA80A01F205X',
                                                    OB_BypassValidation__c=true,
                                                    OB_Status__c='Active');
        insert acc3;
        NE__Service_Point__c servicePoint2 = new NE__Service_Point__c();
        insert servicePoint2;
        ExternalSourceMapping__c ext2 = new ExternalSourceMapping__c(OB_Merchant_ID__c=acc3.Id , OB_CustomerCodeClientCode__c='' , OB_Source__c='EQUENS',OB_Service_Point_ID__c=servicePoint2.Id);
        //extList.add(ext);
        extList.add(ext2);
        insert extList;

        System.debug('IF CONDITION GT: ' +orderItem2.NE__ProdId__c);

        NE__Order_Item_Attribute__c orderItemAttribute = new NE__Order_Item_Attribute__c(Name = 'Terminal Id', NE__Order_Item__c = orderItem2.id);
        insert orderItemAttribute;

        NE__Lov__c lovMCC2 = new NE__Lov__c();
        lovMCC2.ne__type__c   = 'mcc';
        lovMCC2.ne__value3__c = 'L2';
        lovMCC2.OB_Value4__c  = configuration.OB_MCCL2__c;
        insert lovMCC2;

                    //ExternalSourceMapping__c servicePointEquens = [select id,OB_ServicePointCodeShopCode__c  from ExternalSourceMapping__c where OB_Source__c = 'EQUENS' AND OB_Service_Point_ID__c =:servicePointId];


        Test.startTest();
        try
        {
          	OB_TrackingOrder.TrackingOrderResponse response =  OB_TrackingOrder.getTrackingOrder(tor);
            OB_TrackingOrder.TrackingOrderResponse  expectedResponse = new   OB_TrackingOrder.TrackingOrderResponse();
            Integer status = 200;
             expectedResponse.httpMessage = 'OK';
            expectedResponse.httpStatus = status;
            System.assertEquals(JSON.Serialize(expectedResponse), JSON.Serialize(response));
        }
        catch(Exception e)
        {
            System.debug('Generic exception');
        }
        Test.stopTest();
        }

////////////////////////////////////////////////////////////////.....GT......

        @isTest
        public static void OB_TrackingOrderTest(){
            Test.startTest();
            OB_TrackingOrder to = new OB_TrackingOrder();
            Test.stopTest();
        }

        // @isTest
        // public static void trackOrder_Test(){
        //  Test.startTest();
        //  OB_TrackingOrder.TrackingOrderResponse response = new OB_TrackingOrder.TrackingOrderResponse();
        //  Test.setMock(HttpCalloutMock.class, new MockMakeGetCalloutController());
        //  OB_TrackingOrder.trackOrder();
        //  Test.stopTest();
        // }



        @isTest
        public static void updateExternalMapping_Test(){

            Id rtMerchant       = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId();
            Account merchant    = new Account();
            merchant.Name                          = 'TEST';
            merchant.RecordTypeId                  = rtMerchant;
            merchant.OB_Employees_Number__c        = 'Minore di 10';
            merchant.OB_VAT_Not_Present__c         = true;
            merchant.OB_DescriptionVATNotPresent__c= 'description';
            merchant.NE__Fiscal_code__c            = 'RSSMRA80A01F205X';
            merchant.OB_BypassValidation__c        = true;
            merchant.OB_Status__c                  = 'Active';

            NE__Service_Point__c sp = new NE__Service_Point__c();
            insert sp;
            String merchantId  = merchant.Id;
            String servicePointId = sp.id;
            String mcc         = '4722';
            String shopSign    = '';
            Boolean isMoto     = false;
            String pricingType = '';

            ExternalSourceMapping__c extSource = new ExternalSourceMapping__c();
            extSource.OB_Merchant_ID__c            = merchantId ;
            extSource.OB_Service_Point_ID__c       = servicePointId;
            extSource.OB_CustomerCodeClientCode__c = 'CCCC_EQUENS' ;
            extSource.OB_MCC__c                    = mcc;
            extSource.OB_ShopSign__c               = shopSign;
            extSource.OB_Pricing__c                = pricingType;
            extSource.OB_isMoTo__c                 = false;
            //extSource.OB_ServicePointCodeShopCode__c = 'abcde';

            insert extSource;

            List<ExternalSourceMapping__c> externalMapping   = new List<ExternalSourceMapping__c> ();
            externalMapping.add(extSource);
            System.debug('externalMapping ----> ' + externalMapping);

            Map<String,ExternalSourceMapping__c> extNewMap = new Map<String,ExternalSourceMapping__c> ();
            extNewMap.put(extSource.OB_CustomerCodeClientCode__c,  extSource);
            //extNewMap.put(extSource.OB_ServicePointCodeShopCode__c,extSource);


            Test.startTest();
            //OB_TrackingOrder.updateExternalMapping(extNewMap, merchant.Id, sp.Id , MCC , shopSign , isMoto , pricingType);
            Test.stopTest();
        }




        @isTest
        public static void acquaringItemsToUpdateManagement_Test(){

            String obFulfilmentStatus = 'FAILED';
            String codiceSocieta      = '' ;
            String codicePuntoVendita = '';
            String dataInizio         = '';
            String dataCessazione     = '';

            Id rtProduct              = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.PRICING).getRecordTypeId();
            NE__Product__c product    = new NE__Product__c(OB_Acquirer__c=OB_EnrichOrder.NEXI , RecordTypeId =rtProduct );
            product.OB_Codice_sfdc__c = 'ALB_AUTO';
            insert product;
            NE__Order_Header__c orderHeader = new NE__Order_Header__c( OB_Main_Process__c = 'Setup' );
            insert orderHeader;
            NE__Order__c configuration      = new NE__Order__c(NE__Order_Header__c=orderHeader.Id);
            insert configuration;

            NE__OrderItem__c pagobancomatListElement = New NE__OrderItem__c(NE__Qty__c=10 ,NE__OrderId__c=configuration.id);
            insert pagobancomatListElement;

            NE__OrderItem__c orderItem = new NE__OrderItem__c();
            orderItem.NE__Qty__c     = 5;
            orderItem.NE__OrderId__c = configuration.id;
            orderItem.NE__ProdId__c  = product.id;
            insert orderItem;
            Id rtProductAcqRoot           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.ACQUIRING).getRecordTypeId(); 
            NE__Product__c productAcqRoot = new NE__Product__c(OB_Acquirer__c='NEXI', RecordTypeId =rtProductAcqRoot, OB_Codice_sfdc__c = 'VISAMASTERCARD', Name = 'Visa/Mastercard', OB_Contract_Type__c = 'Contratto Acquiring');
            insert productAcqRoot;
            NE__OrderItem__c orderItemAcqRoot = new NE__OrderItem__c(NE__Qty__c=1 ,NE__OrderId__c=configuration.id, NE__Action__c = 'Add', NE__ProdId__c = productAcqRoot.id);
            insert orderItemAcqRoot;
            List<NE__OrderItem__c> acquiringNexiList   = new List<NE__OrderItem__c>();
            acquiringNexiList.add(orderItemAcqRoot);

            Map<Id,List<NE__OrderItem__c>> mapChildOI = new Map<Id,List<NE__OrderItem__c>>();
            mapChildOI.put(pagobancomatListElement.id, acquiringNexiList);
            List<NE__OrderItem__c> itemToUpdateList  = new List<NE__OrderItem__c>();
            itemToUpdateList.add(orderItem);

            Test.startTest();
            OB_TrackingOrder.acquaringItemsToUpdateManagement(configuration, acquiringNexiList, obFulfilmentStatus, codiceSocieta, codicePuntoVendita, dataInizio, dataCessazione, mapChildOI, itemToUpdateList);
            Test.stopTest();
        }

        @isTest
        public static void gtItemsToUpdateManagement_Test()
        {

            String obFulfilmentStatus = 'COMPLETED';
            Id rtProduct = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.PRICING).getRecordTypeId();
            NE__Product__c product = new NE__Product__c();
                product.OB_Acquirer__c = 'AMEX';
                product.RecordTypeId = rtProduct;
                product.OB_Codice_sfdc__c = 'ALB_AUTO';
            insert product;
            product = [SELECT Id, RecordTypeId,RecordType.DeveloperName, OB_Acquirer__c, OB_Codice_sfdc__c FROM NE__Product__c WHERE Id = :product.Id LIMIT 1 ];
            System.debug('@@@@@product.id: ' + product.id);

            NE__Order_Header__c orderHeader = new NE__Order_Header__c(OB_Main_Process__c = 'Setup');
            insert orderHeader;

            NE__Order__c configuration = new NE__Order__c(NE__Order_Header__c = orderHeader.Id);
            insert configuration;

            NE__OrderItem__c pagobancomatListElement = new NE__OrderItem__c();
                pagobancomatListElement.NE__Qty__c = 10;
                pagobancomatListElement.NE__OrderId__c = configuration.id;
            pagobancomatListElement.RecordTypeId = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.PAGOBANCOMAT).getRecordTypeId();
            insert pagobancomatListElement;

            Id rtProductPB    = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.PAGOBANCOMAT).getRecordTypeId(); 
            NE__Product__c productPB    = new NE__Product__c(OB_Acquirer__c=OB_EnrichOrder.NEXI, RecordTypeId =rtProductPB, OB_Codice_sfdc__c = 'PAGOBANCOMAT' );
            insert productPB;
            NE__OrderItem__c pagobancomat = New NE__OrderItem__c(NE__Qty__c=1 ,NE__OrderId__c=configuration.id, NE__Action__c = 'None', NE__ProdId__c = productPB.id);			
            insert pagobancomat;




			NE__OrderItem__c orderItem = new NE__OrderItem__c();
				orderItem.NE__Qty__c = 5;
				orderItem.NE__OrderId__c = configuration.id;
				orderItem.NE__ProdId__c  = product.id;
				orderitem.RecordTypeId = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.TERMINALE).getRecordTypeId();
			insert orderItem;

			NE__OrderItem__c orderItem1 = new NE__OrderItem__c();
			orderitem1.NE__Description__c = 'orderitem1';
			orderItem1.NE__Qty__c = 6;
			orderItem1.NE__OrderId__c = configuration.id;
			orderItem1.NE__ProdId__c  = product.id;
			orderItem1.RecordTypeId = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.PAGOBANCOMAT).getRecordTypeId();
			insert orderItem1;

			NE__OrderItem__c orderItem2 = new NE__OrderItem__c();
			orderItem2.NE__Qty__c = 6;
			orderItem2.NE__OrderId__c = configuration.id;
			orderItem2.NE__ProdId__c  = product.id;
			orderItem2.RecordTypeId = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.VAS).getRecordTypeId();
			insert orderitem2;

			List<NE__OrderItem__c> itemList = new List<NE__OrderItem__c>();
			itemlist.add(orderitem2);

			orderItem = [SELECT ID, NE__Qty__c, NE__ProdId__r.RecordTypeId, NE__ProdId__r.RecordType.DeveloperName, NE__ProdId__r.OB_Acquirer__c, NE__ProdId__r.OB_Codice_sfdc__c, NE__OrderId__c FROM NE__OrderItem__c WHERE NE__Qty__c = 5 LIMIT 1];

			OB_Integration_Configuration__c integrationConfig = new OB_Integration_Configuration__c();
			integrationConfig.OB_Token_1__c = '';
			integrationConfig.Name = 'name';
			insert integrationConfig;

            System.debug('@@@@@orderItem.NE__ProdId__c: ' + orderItem.NE__ProdId__r.OB_Acquirer__c);

			List<NE__OrderItem__c> pagobancomatList   = new List<NE__OrderItem__c>();
			pagobancomatList.add(pagobancomatListElement);
			pagobancomatList.add(orderItem1);
	pagobancomatList.add(pagobancomat);
			Map<Id,List<NE__OrderItem__c>> mapChildOI = new Map<Id,List<NE__OrderItem__c>>();
			//mapChildOI.put(pagobancomatListElement.id, pagobancomatList);v

            NE__OrderItem__c orderItem6 = new NE__OrderItem__c();
				orderItem6.NE__Qty__c = 5;
				orderItem6.NE__OrderId__c = configuration.id;
				orderItem6.NE__ProdId__c  = product.id;
				orderItem6.RecordTypeId = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.TERMINALE).getRecordTypeId();
			insert orderItem6;
            			List<NE__OrderItem__c> orderItemList   = new List<NE__OrderItem__c>();
			orderItemList.add(orderItem6);
			mapChildOI.put(pagobancomat.id, itemlist);
            		mapChildOI.put(orderItem.id, orderItemList);
            OB_TrackingOrder.CodiciConvenzioni codiciConvenzioniObject = new OB_TrackingOrder.CodiciConvenzioni();
            codiciConvenzioniObject.idItemSalesforce  = 'test';
            codiciConvenzioniObject.companyCode       = 'test';
            codiciConvenzioniObject.companyName       = 'test';
            codiciConvenzioniObject.codiceConvenzione = 'test';
            codiciConvenzioniObject.causaleRifiuto    = 'test';
            codiciConvenzioniObject.dataInizio        = '1960-2-17';
            codiciConvenzioniObject.dataFine          = '1960-2-17';

            Map<String, OB_TrackingOrder.CodiciConvenzioni> codiciConvenzione = new Map<String, OB_TrackingOrder.CodiciConvenzioni>();
            codiciConvenzione.put(product.OB_Codice_sfdc__c , codiciConvenzioniObject );

			Map<String,NE__OrderItem__c> rootVasList = new Map<String,NE__OrderItem__c>();
			rootVasList.put(product.OB_Codice_sfdc__c, orderItem2);

			List<NE__OrderItem__c> itemToUpdateList  = new List<NE__OrderItem__c>();
			// itemToUpdateList.add(orderItem);
			Boolean pagobancomatFlag = true;

			List<NE__OrderItem__c> acquiringNexiList = new List<NE__OrderItem__c>();
			OB_TrackingOrder.TrackingOrderRequest request = new OB_TrackingOrder.TrackingOrderRequest();
			OB_TrackingOrder.GT gt = new OB_TrackingOrder.GT();
			OB_TrackingOrder.puntoVendita pvGT = new OB_TrackingOrder.puntoVendita();
			List<OB_TrackingOrder.GT> gtList = new List<OB_TrackingOrder.GT>();
			List<OB_TrackingOrder.puntoVendita> pvGTList = new List<OB_TrackingOrder.puntoVendita>();
			List<OB_TrackingOrder.TermsIdInformation> terminalList = new List<OB_TrackingOrder.TermsIdInformation>();
			pvGT.itemId = 'itemIdValueGT';
			pvGT.codicePuntoVendita = 'codicePuntoVenditaValueGT';
			pvGT.dataInizio = '2019-04-03';
			pvGT.dataCessazione = '2019-04-03';
			pvGT.causaleCessazione = 'causaleCessazioneValueGT';
			pvGT.tipo = 'Fisico';
			pvGT.codiceCTI = 'CT';
			pvGT.codiceStabilimento = 'codiceStabilimentoValueGT';
			pvGT.codiceStabilimentoSIA = 'codiceStabilimentoSIAValueGT';
			pvGT.codiceProgressivoSIA = 'codiceProgressivoSIAValueGT';
			pvGT.codiceSIA = 'codiceSIAValueGT';
			pvGT.numeroAssistenzaPOS = 'numeroAssistenzaPOSValueGT';
			pvGT.dataInizioAttivita = '2019-04-03';
			pvGT.termsIdInformations = terminalList;

			pvGTList.add(pvGT);

			gt.sistemaSorgente = 'sistemaSorgenteValueGT';
			gt.statoProvisioning = 'statoProvisioningValueGT';
			gt.codiceCliente = 'codiceClienteValueGT';
			gt.errori = null;
			gt.puntiVendita = pvGTList;
			gtList.add(gt);

			OB_TrackingOrder.TermsIdInformation TermsIdInfo = new OB_TrackingOrder.TermsIdInformation();
			TermsIdInfo.modello = 'test';
			TermsIdInfo.release = 'test';
			TermsIdInfo.modalitaCollegamento = 'test';
			TermsIdInfo.descrizioneModello = 'test';
			TermsIdInfo.descrizioneRelease = 'test';
			TermsIdInfo.descrizioneConnessione = 'test';
			TermsIdInfo.statoInstallazione = 'test';
			TermsIdInfo.causaleRifiuto = 'test';
			TermsIdInfo.dataInstallazione = 'test';
			TermsIdInfo.dataDisinstallazione = 'test';
			terminalList.add(TermsIdInfo);


			Test.startTest();
			OB_TrackingOrder.gtItemsToUpdateManagement(configuration, orderItem, 'Failed', mapChildOI, pagobancomatList, codiciConvenzione, rootVasList, itemToUpdateList, false, acquiringNexiList,false,request);
     		Test.stopTest();
		}
	


        @isTest
        public static void checkErrors_Test()
        {
            OB_TrackingOrder.ErrorList errore = new OB_TrackingOrder.ErrorList();
            errore.codice      = 'test';
            errore.descrizione = 'test';
            List<OB_TrackingOrder.ErrorList> erroriList = new List<OB_TrackingOrder.ErrorList>();
            erroriList.add(errore);

            //OB_TrackingOrder.ErrorList errore = new OB_TrackingOrder.ErrorList();
            //errore.codice      = 'test';
            //errore.descrizione = 'test';
            //List<OB_TrackingOrder.ErrorList> errori = new List<OB_TrackingOrder.ErrorList>();
            //errori.add(errore);

            OB_TrackingOrder.Acquiring acquiringObject = new OB_TrackingOrder.Acquiring();
            acquiringObject.sistemaSorgente = '1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890';
            acquiringObject.codiceSocieta   = 'test';
            acquiringObject.errori          = erroriList;
            //List<puntoVendita> puntiVendita

            OB_TrackingOrder.GT   gtObject = new OB_TrackingOrder.GT();
            gtObject.sistemaSorgente     = '123456123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890';
            gtObject.statoProvisioning   = 'test';
            gtObject.codiceCliente       = 'test';
            gtObject.errori              = erroriList;


           //:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

            Id rtProduct              = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.PRICING).getRecordTypeId();
            NE__Product__c product    = new NE__Product__c(OB_Acquirer__c=OB_EnrichOrder.NEXI , RecordTypeId =rtProduct );
            product.OB_Codice_sfdc__c = 'ALB_AUTO';
            insert product;
            NE__Order_Header__c orderHeader = new NE__Order_Header__c( OB_Main_Process__c = 'Setup' );
            insert orderHeader;
            NE__Order__c configuration      = new NE__Order__c(NE__Order_Header__c=orderHeader.Id);
            insert configuration;

            NE__OrderItem__c pagobancomatListElement = New NE__OrderItem__c(NE__Qty__c=10 ,NE__OrderId__c=configuration.id);
            insert pagobancomatListElement;

            NE__OrderItem__c orderItem = new NE__OrderItem__c();
            orderItem.NE__Qty__c     = 5;
            orderItem.NE__OrderId__c = configuration.id;
            orderItem.NE__ProdId__c  = product.id;
            insert orderItem;

            NE__OrderItem__c orderItemChild = new NE__OrderItem__c();
            orderItemChild.NE__Qty__c     = 5;
            orderItemChild.NE__OrderId__c = configuration.id;
            orderItemChild.NE__ProdId__c  = product.id;
            insert orderItemChild;
     
            List<NE__OrderItem__c> acquiringNexiList = new List<NE__OrderItem__c>();
            acquiringNexiList.add(pagobancomatListElement);

            List<NE__OrderItem__c> acquiringNexiListChildren = new List<NE__OrderItem__c>();
            acquiringNexiListChildren.add(orderItemChild);

            Map<Id,List<NE__OrderItem__c>> mapChildOI = new Map<Id,List<NE__OrderItem__c>>();
            mapChildOI.put(pagobancomatListElement.id, acquiringNexiListChildren);

            Map<String,NE__OrderItem__c> mapTermId = new Map<String,NE__OrderItem__c>();

            List<NE__OrderItem__c> pagobancomatList  = new List<NE__OrderItem__c>();
            pagobancomatList.add(orderItem);
            List<OB_TrackingOrder.Acquiring> acquiringList = new List<OB_TrackingOrder.Acquiring>();
            acquiringList.add(acquiringObject);
            List<OB_TrackingOrder.GT> GTArray = new List<OB_TrackingOrder.GT>();
            GTArray.add(gtObject);
            Map<String,Object> acquiringArguments = new Map<String,Object> ();
            acquiringArguments.put('configuration', configuration);
            acquiringArguments.put('acquiringNexiList', acquiringNexiList);
            acquiringArguments.put('mapChildOI', mapChildOI);
            Map<String,Object> gtArguments = new Map<String,Object>();
            gtArguments.put('mapTermId', mapTermId);
            gtArguments.put('pagobancomatList', pagobancomatList);
            Integer responseStatus = 2;
            List<NE__OrderItem__c> itemToUpdateList  = new List<NE__OrderItem__c>();
            itemToUpdateList.add(orderItem);

            Test.startTest();
            OB_TrackingOrder.checkErrors(acquiringList, null, acquiringArguments, gtArguments); //g.v. 27/11/2019 - removed responseStatus and itemToUpdateList arguments
            OB_TrackingOrder.checkErrors(null, GTArray, acquiringArguments, gtArguments); //g.v. 27/11/2019 - removed responseStatus and itemToUpdateList arguments
            Test.stopTest();
        }


      @isTest
    public static void updateServicePointInfoTest()
    {
      OB_TrackingOrder.CodiciConvenzioni ccGT = new OB_TrackingOrder.CodiciConvenzioni();
    ccGT.idItemSalesforce = 'idItemSalesforceValueGT';
    ccGT.companyCode = 'companyCodeValueGT';
    ccGT.companyName = 'companyNameValueGT';
    ccGT.codiceConvenzione = 'codiceConvenzioneValueGT'; 
    ccGT.causaleRifiuto = 'causaleRifiutoValueGT';
    ccGT.dataInizio = 'dataInizioValueGT';
    ccGT.dataFine = 'dataFineValueGT';
    List<OB_TrackingOrder.CodiciConvenzioni> ccGTList = new List<OB_TrackingOrder.CodiciConvenzioni>();
    ccGTList.add(ccGT);

    OB_TrackingOrder.TermsIdInformation tiiGT = new OB_TrackingOrder.TermsIdInformation();
    tiiGT.termId = 'OB_TermId__c';                    
    tiiGT.modello = 'modelloValueGT';                    
    tiiGT.release = 'releaseValueGT';                  
    tiiGT.modalitaCollegamento = 'modalitaCollegamentoValueGT';            
    tiiGT.descrizioneModello = 'descrizioneModelloValueGT';
    tiiGT.descrizioneRelease = 'descrizioneReleaseValueGT';            
    tiiGT.descrizioneConnessione = 'descrizioneConnessioneValueGT';            
    tiiGT.statoInstallazione = 'statoInstallazioneValueGT';              
    tiiGT.causaleRifiuto = 'statoInstallazioneValueGT';                
    tiiGT.dataInstallazione = 'dataInstallazioneValueGT';                
    tiiGT.dataDisinstallazione = 'dataDisinstallazioneValueGT';            
    tiiGT.codiciconvenzioni = ccGTList;
    List<OB_TrackingOrder.TermsIdInformation> tiiGTList = new List<OB_TrackingOrder.TermsIdInformation>();
    tiiGTList.add(tiiGT);
      
    OB_TrackingOrder.puntoVendita pvGT = new OB_TrackingOrder.puntoVendita();
    pvGT.itemId = 'itemIdValueGT';
    pvGT.codicePuntoVendita = 'codicePuntoVenditaValueGT';
    pvGT.dataInizio = 'dataInizioValueGT';
    pvGT.dataCessazione = 'dataCessazioneValueGT';
    pvGT.causaleCessazione = 'causaleCessazioneValueGT';
    pvGT.tipo = 'Fisico';
    pvGT.codiceCTI = 'CTIValGT';
    pvGT.codiceStabilimento = 'MANVACA';
    pvGT.codiceStabilimentoSIA = '123';
    pvGT.codiceProgressivoSIA = '456';
    pvGT.codiceSIA = '789';
    pvGT.numeroAssistenzaPOS = 'numeroAssistenzaPOSValueGT';
    pvGT.dataInizioAttivita = 'dataInizioAttivitaValueGT';
    pvGT.termsIdInformations = tiiGTList;

        Id productTerminaleRecordTypeId  = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.TERMINALE).getRecordTypeId();

    NE__Product__c prod = new NE__Product__c();
        prod.Name = 'prod'; 
        prod.RecordTypeId = productTerminaleRecordTypeId;
        insert prod;

    NE__Order_Header__c oh = new NE__Order_Header__c();
    oh.OB_Business_Model_Acquiring__c = 'Diretto';
    oh.OB_Main_Process__c = 'Maintenance';
    insert oh;

    NE__Order__c ord = new NE__Order__c();
    ord.NE__Order_Header__c = oh.id;
    insert ord;

    NE__OrderItem__c oi = new NE__OrderItem__c();
        oi.NE__Status__c  = 'Pending';
        oi.NE__ProdId__c  = prod.id;
        oi.NE__OrderId__c = ord.id;
        oi.NE__Qty__c     = 1;
        oi.OB_TermId__c   = 'OB_TermId__c';
    oi.OB_FulfilmentStatus__c = 'Pending';
        insert oi;

    NE__Order_Item_Attribute__c itemAttr1 = new NE__Order_Item_Attribute__c();
    itemAttr1.Name = 'Progressivo SIA';
    itemAttr1.NE__Order_Item__c = oi.id;
    insert itemAttr1;
    NE__Order_Item_Attribute__c itemAttr2 = new NE__Order_Item_Attribute__c();
    itemAttr2.Name = 'Codice Stabilimento SIA';
    itemAttr2.NE__Order_Item__c = oi.id;
    insert itemAttr2;
    NE__Order_Item_Attribute__c itemAttr3 = new NE__Order_Item_Attribute__c();
    itemAttr3.Name = 'Codice SIA';
    itemAttr3.NE__Order_Item__c = oi.id;
    insert itemAttr3;

    List<NE__OrderItem__c> orderitemlist = [SELECT Id, 
                             NE__ProdId__r.RecordType.DeveloperName, 
                               OB_FulfilmentStatus__c,
                             (SELECT Name FROM NE__Order_Item_Attributes__r)
                         FROM   NE__OrderItem__c
                        WHERE  Id = :oi.id];
        List<OB_TrackingOrder.puntoVendita> puntiVendita = new List<OB_TrackingOrder.puntoVendita>();
    puntiVendita.add(pvGT);
  
    Test.startTest();
        OB_TrackingOrder.updateServicePointInfo(orderitemlist, puntiVendita,ord);
        Test.stopTest();
    }

    @isTest
    public static void conventionCodeManagementTest()
    {
        NE__Order_Header__c oh = new NE__Order_Header__c();
        oh.OB_Business_Model_Acquiring__c = 'Diretto';
        oh.OB_Main_Process__c = 'Maintenance';
        insert oh;
        NE__Order__c ord = new NE__Order__c();
        ord.NE__Order_Header__c = oh.id;
        insert ord;
        NE__OrderItem__c oi = new NE__OrderItem__c();
        oi.NE__Status__c = 'Completed';
        oi.NE__OrderId__c = ord.id;
        oi.NE__Qty__c = 1;
        oi.OB_TermId__c = 'OB_TermId__c';
        insert oi;
        Map<String, NE__OrderItem__c> mapTermId = new Map<String, NE__OrderItem__c>();
        mapTermId.put('OB_TermId__c', oi);
        List<NE__OrderItem__c> oiList = new List<NE__OrderItem__c>();
        oiList.add(oi);

        NE__Service_Point__c sp = new NE__Service_Point__c();
        insert sp;
        ExternalSourceMapping__c esm = new ExternalSourceMapping__c();
        insert esm;
        ExternalSourceMapping__c esmEquens = new ExternalSourceMapping__c();
        esmEquens.OB_Source__c = 'EQUENS';
        esmEquens.OB_Service_Point_ID__c = sp.id;
        insert esmEquens;
        ExternalSourceMapping__c esmMonetica = new ExternalSourceMapping__c();
        esmMonetica.OB_Source__c = 'MONETICA';
        esmMonetica.OB_Service_Point_ID__c = sp.id;
        insert esmMonetica;


        Test.startTest();
        OB_TrackingOrder.conventionCodeManagement(true, true, false, false, esm, oiList, sp.id, mapTermId,'');
        OB_TrackingOrder.conventionCodeManagement(true, false, true, false, esm, oiList, sp.id, mapTermId,'');
        OB_TrackingOrder.conventionCodeManagement(false, true, false, true, esm, oiList, sp.id, mapTermId,'');
        Test.stopTest();
    }


     @isTest
    public static void updateGTItemsOkMonetica_Test()
    {
        NE__Order_Header__c oh = new NE__Order_Header__c();
        oh.OB_Business_Model_Acquiring__c = 'Diretto';
        oh.OB_Main_Process__c = 'Maintenance';
        insert oh;
        NE__Order__c ord = new NE__Order__c();
        ord.NE__Order_Header__c = oh.id;
        insert ord;
        NE__OrderItem__c oi = new NE__OrderItem__c();
        oi.NE__Status__c = 'Completed';
        oi.NE__OrderId__c = ord.id;
        oi.NE__Qty__c = 1;
        oi.OB_TermId__c = 'OB_TermId__c';
        insert oi;
        Map<String, NE__OrderItem__c> mapTermId = new Map<String, NE__OrderItem__c>();
        mapTermId.put('OB_TermId__c', oi);
        List<NE__OrderItem__c> oiList = new List<NE__OrderItem__c>();
        oiList.add(oi);
        NE__OrderItem__c oi2 = new NE__OrderItem__c();
        oi2.NE__Status__c = 'Completed';
        oi2.NE__OrderId__c = ord.id;
        oi2.NE__Qty__c = 1;
        oi2.OB_TermId__c = 'OB_TermId__c';
        insert oi2;
        NE__Service_Point__c sp = new NE__Service_Point__c();
        insert sp;
        ExternalSourceMapping__c esm = new ExternalSourceMapping__c();
        insert esm;
        ExternalSourceMapping__c esmEquens = new ExternalSourceMapping__c();
        esmEquens.OB_Source__c = 'EQUENS';
        esmEquens.OB_Service_Point_ID__c = sp.id;
        insert esmEquens;
        ExternalSourceMapping__c esmMonetica = new ExternalSourceMapping__c();
        esmMonetica.OB_Source__c = 'MONETICA';
        esmMonetica.OB_Service_Point_ID__c = sp.id;
        insert esmMonetica;
        OB_TrackingOrder.puntoVendita pV = new OB_TrackingOrder.puntoVendita();
        //pV.itemId = '';
        pV.codicePuntoVendita = sp.id;
        pV.dataInizio = '2011-11-13';
        pV.dataCessazione = '';
        pV.causaleCessazione = '';
        //pV.tipo = '';
        pV.codiceCTI = 'ctiCode';
        pV.codiceStabilimento = 'StabiCode';
        pV.codiceStabilimentoSIA = '12345';
        pV.codiceProgressivoSIA = '1234567';
        pV.codiceSIA = '123';
        pV.numeroAssistenzaPOS = 'assistanceNumber';
        //pV.dataInizioAttivita = '2011-11-13';
        pv.termsIdInformations = null; //List
        pv.termsIdInformations = null; //List
        String monetica = 'MONETICA';
        OB_TrackingOrder.GT gT = new OB_TrackingOrder.GT();
        gT.sistemaSorgente = 'MONETICA';
        gT.codiceCliente = 'companyCode';
        gT.errori = null; //List
        gT.puntiVendita = null; //List
        gT.statoProvisioning = 'test';




        Id rtProductPB    = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.PAGOBANCOMAT).getRecordTypeId(); 
        NE__Product__c productPB    = new NE__Product__c(OB_Acquirer__c=OB_EnrichOrder.NEXI, RecordTypeId =rtProductPB, OB_Codice_sfdc__c = 'PAGOBANCOMAT' );
        insert productPB;
        NE__OrderItem__c pagobancomat = New NE__OrderItem__c(NE__Qty__c=1 ,NE__OrderId__c=ord.id, NE__Action__c = 'None', NE__ProdId__c = productPB.id);			
        insert pagobancomat;
        List<NE__OrderItem__c> pagoList = new List<NE__OrderItem__c>();
        pagoList.add(pagobancomat);
        Id rtProductPric           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.PRICING).getRecordTypeId(); 
        NE__Product__c productPric = new NE__Product__c(RecordTypeId = rtProductPric, OB_Codice_sfdc__c = 'MAE_PRE', Name = 'MAESTRO CONSUMER PREPAID', OB_Contract_Type__c = 'Contratto Acquiring');
        insert productPric;
        NE__OrderItem__c orderItemPric = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = ord.id, NE__ProdId__c = productPric.id, NE__Action__c = 'Add', NE__Parent_Order_Item__c = pagobancomat.id);  
        insert orderItemPric;
                NE__OrderItem__c orderItemPric2 = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = ord.id, NE__ProdId__c = productPric.id, NE__Action__c = 'Add', NE__Parent_Order_Item__c = pagobancomat.id);  
        insert orderItemPric2;
        List<NE__OrderItem__c> childOrderItems = new List<NE__OrderItem__c>();
        childOrderItems.add(orderItemPric);
              List<NE__OrderItem__c> childOrderItems2 = new List<NE__OrderItem__c>();
        childOrderItems2.add(orderItemPric2);
        Map<id, List<NE__OrderItem__c>> mapChildOI = new  Map<id, List<NE__OrderItem__c>>();
        mapChildOI.put(pagobancomat.Id, childOrderItems);
       mapChildOI.put(oi2.Id, childOrderItems2);

        NE__Order_Item_Attribute__c attrGTRoot8 = new NE__Order_Item_Attribute__c();
        attrGTRoot8.Name = 'Progressivo SIA';
        attrGTRoot8.NE__Order_Item__c = pagobancomat.id;
        insert attrGTRoot8;
        NE__Order_Item_Attribute__c attrGTRoot9 = new NE__Order_Item_Attribute__c();
        attrGTRoot9.Name = 'Codice Stabilimento SIA';
        attrGTRoot9.NE__Order_Item__c = pagobancomat.id;
        insert attrGTRoot9;
        NE__Order_Item_Attribute__c attrGTRoot10 = new NE__Order_Item_Attribute__c();
        attrGTRoot10.Name = 'Codice SIA';
        attrGTRoot10.NE__Order_Item__c = pagobancomat.id;
        insert attrGTRoot10;


        Test.startTest();
            OB_TrackingOrder.updateGTItemsOkMonetica(mapTermId, mapChildOI,pagoList, pV, monetica, gT, ord);
        Test.stopTest();
    }
    @isTest
    public static void checkAllRejected_Test()
    {
         NE__Order_Header__c oh = new NE__Order_Header__c();
        oh.OB_Business_Model_Acquiring__c = 'Diretto';
        oh.OB_Main_Process__c = 'Maintenance';
        insert oh;
        NE__Order__c ord = new NE__Order__c();
        ord.NE__Order_Header__c = oh.id;
        insert ord;
        NE__OrderItem__c oi = new NE__OrderItem__c();
        oi.NE__Status__c = 'Completed';
        oi.NE__OrderId__c = ord.id;
        oi.NE__Qty__c = 1;
        oi.OB_TermId__c = 'OB_TermId__c';
        insert oi;
        Map<String, NE__OrderItem__c> mapTermId = new Map<String, NE__OrderItem__c>();
        mapTermId.put('OB_TermId__c', oi);
        OB_TrackingOrder.TermsIdInformation termInfo = new OB_TrackingOrder.TermsIdInformation();    
        termInfo.termId = oi.OB_TermId__c;
        termInfo.modello = 'model';
        termInfo.release = 'connectionType';
        termInfo.modalitaCollegamento = 'modality';
        termInfo.descrizioneModello = 'modelDescription';
        termInfo.descrizioneRelease = 'release';
        termInfo.descrizioneConnessione = 'releaseDescription';
        termInfo.statoInstallazione = 'Pending';
        termInfo.causaleRifiuto = '';
        termInfo.dataInstallazione = '2011-11-13';
        termInfo.dataDisinstallazione = '';
        termInfo.codiciconvenzioni = null; //List
        List<OB_TrackingOrder.TermsIdInformation > termList = new List<OB_TrackingOrder.TermsIdInformation >();
        termList.add(termInfo);
        //(Map<String,NE__OrderItem__c> mapTermId,List<TermsIdInformation> termsIdInformations ){

        Test.startTest();
           Boolean toReturn = OB_TrackingOrder.checkAllRejected(mapTermId,termList);
           System.assertEquals(true, toReturn);
        Test.stopTest();

    }
 @isTest
    public static void errorStringFormatter_Test()
    {
        OB_TrackingOrder.ErrorList error = new OB_TrackingOrder.ErrorList();
        error.codice = '';
        error.descrizione = '';

        List<OB_TrackingOrder.ErrorList> errorsList = new List<OB_TrackingOrder.ErrorList>();
        errorsList.add(error);

        //(Boolean isAcquiring,List<ErrorList> errorList){
        Test.startTest();
            String errorResp = OB_TrackingOrder.errorStringFormatter(true,errorsList);
            System.assertEquals( 'Acquiring errors : \r codice :  \r errore : ', errorResp);
        Test.stopTest();
    }
    //START gianluigi.virga 28/06/2019
    @isTest
    public static void updateResponseTest()
    {
        NE__Order_Header__c oh = new NE__Order_Header__c();
        insert oh;
        NE__Order__c ord = new NE__Order__c();
        ord.NE__Order_Header__c = oh.id;
        insert ord;
        String message = 'OK';
        String id = ord.id;
        Integer status = 200;
        Test.startTest();
            OB_TrackingOrder.updateResponse(id, message, status);
        Test.stopTest();
    }
    //END gianluigi.virga
    
    //START gianluigi.virga 03/07/2019
    @isTest
    public static void OB_TrackingOrder_Test(){
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
        NE__Order_Header__c orderHeader = new NE__Order_Header__c(OB_ProposerABI__c=bankAccount.Id ,NE__AccountId__c=myMastMerchant.Id, OB_Main_Process__c = 'Setup', OB_Sub_Process__c = 'variazione operativa', OB_Business_Model_Acquiring__c = 'Bancario');
        insert orderHeader;
        NE__Order__c configuration = new NE__Order__c(NE__AccountId__c=myMastMerchant.Id, OB_Service_Point__c = servicePoint.Id,NE__Order_Header__c=orderHeader.Id, OB_MCC__c = '0001', OB_MCCL2__c = '5631', OB_GT__c = 'Nexi', OB_PBSettlementMethod__c = 'PB Settlement Method', OB_InternationalSettlementMethod__c = 'International Settlement Method', OB_ReceiptCity__c = 'MILANO', OB_ReceiptHeader__c='Sweet Years', OB_Report_Type__c = 'Punto Vendita', OB_ShopSign__c = 'Sweet Years');
        insert configuration;

        //OrderItem ACQUIRING
        Id rtProductAcqRoot           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.ACQUIRING).getRecordTypeId(); 
        NE__Product__c productAcqRoot = new NE__Product__c(OB_Acquirer__c='NEXI', RecordTypeId =rtProductAcqRoot, OB_Codice_sfdc__c = 'VISAMASTERCARD', Name = 'Visa/Mastercard', OB_Contract_Type__c = 'Contratto Acquiring');
        insert productAcqRoot;
        NE__OrderItem__c orderItemAcqRoot = new NE__OrderItem__c(NE__Qty__c=10 ,NE__OrderId__c=configuration.id, NE__Action__c = 'Add', NE__ProdId__c = productAcqRoot.id, NE__Service_Point__c = servicePoint.Id, NE__Account__c = myMastMerchant.Id);
        insert orderItemAcqRoot;

        //OrderItem GT
        Id rtProductGTRoot          = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.TERMINALE).getRecordTypeId(); 
        NE__Product__c productGTRoot = new NE__Product__c(RecordTypeId = rtProductGTRoot, OB_Codice_sfdc__c = 'SMPOS_CASSA', Name = 'SmartPOS Cassa', OB_Contract_Type__c = 'Contratto POS;Modulo Off Commercial', OB_Business_Model_POS__c = 'Diretto;Trilaterale Nuovo');
        insert productGTRoot;
        NE__OrderItem__c orderItemGTRoot = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__Action__c = 'Add', OB_GT__c = 'MONETICA', OB_TermId__c = '21021990', NE__ProdId__c = productGTRoot.id, NE__Status__c = 'PENDING', OB_FulfilmentStatus__c = 'Pending', OB_Tech_Outcome_Monetica__c = 'OK');
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
        NE__OrderItem__c orderItemGT = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__Parent_Order_Item__c = orderItemGTRoot.id, NE__Action__c = 'Add', NE__ProdId__c = productGT.id, OB_Tech_Outcome_Monetica__c = 'OK');
        insert orderItemGT;

        //Item Acquiring Child
        Id rtProductAcq           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.ACQUIRING).getRecordTypeId(); 
        NE__Product__c productAcq = new NE__Product__c(RecordTypeId = rtProductAcq, OB_Acquirer__c='NEXI', OB_Codice_sfdc__c = 'VISAMASTERCARD', Name = 'Visa/Mastercard', OB_Contract_Type__c = 'Contratto Acquiring', OB_Offer__c ='PERSONALIZZATA;START');
        insert productAcq;
        NE__OrderItem__c orderItemAcq = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__ProdId__c = productAcq.id, NE__Action__c = 'Add', NE__Parent_Order_Item__c = orderItemGTRoot.id);  
        insert orderItemAcq;
        Id rtProductPric           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.PRICING).getRecordTypeId(); 
        NE__Product__c productPric = new NE__Product__c(RecordTypeId = rtProductPric, OB_Codice_sfdc__c = 'MAE_PRE', Name = 'MAESTRO CONSUMER PREPAID', OB_Contract_Type__c = 'Contratto Acquiring');
        insert productPric;
        NE__OrderItem__c orderItemPric = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__ProdId__c = productPric.id, NE__Action__c = 'Add', NE__Parent_Order_Item__c = orderItemAcq.id);  
        insert orderItemPric;

        //ADD ITEM TO CONFIGURATION
        Id rtProductPB    = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.PAGOBANCOMAT).getRecordTypeId(); 
            NE__Product__c productPB    = new NE__Product__c(OB_Acquirer__c=OB_EnrichOrder.NEXI, RecordTypeId =rtProductPB, OB_Codice_sfdc__c = 'PAGOBANCOMAT' );
            insert productPB;
        NE__OrderItem__c pagobancomat = New NE__OrderItem__c(NE__Qty__c=1 ,NE__OrderId__c=configuration.id, NE__Action__c = 'None', NE__ProdId__c = productPB.id);			
            insert pagobancomat;

        Id rtProductVAS   = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.VAS).getRecordTypeId(); 
        NE__Product__c productRootVAS   = new NE__Product__c(RecordTypeId = rtProductVAS, OB_Codice_sfdc__c = 'PELLEGRINI');
            insert productRootVAS;
        NE__OrderItem__c rootVas = New NE__OrderItem__c(NE__Qty__c=1 ,NE__OrderId__c=configuration.id, NE__Action__c = 'None');			
            insert rootVas;
        NE__Product__c productVAS   = new NE__Product__c(RecordTypeId = rtProductVAS, OB_Codice_sfdc__c = 'PELLEGRINI');
            insert productVAS;
        NE__OrderItem__c vas = New NE__OrderItem__c(NE__Qty__c=1 ,NE__OrderId__c=configuration.id, NE__Action__c = 'Add');			
            insert vas;

        NE__Product__c product1    = new NE__Product__c(OB_Acquirer__c=OB_EnrichOrder.NEXI , RecordTypeId =rtProductPric );
            product1.OB_Codice_sfdc__c = 'ALB_AUTO';
            insert product1;

            NE__OrderItem__c orderItem1 = new NE__OrderItem__c();
            orderItem1.NE__Qty__c     = 1;
            orderItem1.NE__OrderId__c = configuration.id;
            orderItem1.NE__ProdId__c  = product1.id;
        orderItem1.NE__Action__c = 'Add';
        orderItem1.NE__Parent_Order_Item__c = orderItemAcq.id;
            insert orderItem1;

        //orderItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.ACQUIRING && orderItem.NE__ProdId__r.OB_Acquirer__c!=OB_EnrichOrder.NEXI
        NE__Product__c productNotNexi    = new NE__Product__c(OB_Acquirer__c='AMEX' , RecordTypeId =rtProductAcqRoot, OB_Codice_sfdc__c = 'AMEX' );
            insert productNotNexi;

        NE__OrderItem__c orderItemNotNexi = new NE__OrderItem__c();
        orderItemNotNexi.NE__Qty__c     = 1;
            orderItemNotNexi.NE__OrderId__c = configuration.id;
            orderItemNotNexi.NE__ProdId__c  = productNotNexi.id;
        orderItemNotNexi.NE__Action__c = 'None';
        orderItemNotNexi.NE__Parent_Order_Item__c = null;
            insert orderItemNotNexi;

        NE__Product__c productNotNexiPricing   = new NE__Product__c(OB_Acquirer__c='AMEX' , RecordTypeId =rtProductPric, OB_Codice_sfdc__c = 'PRICING' );
            insert productNotNexiPricing;
        NE__OrderItem__c orderItemNotNexiPric = new NE__OrderItem__c();
        orderItemNotNexiPric.NE__Qty__c     = 1;
            orderItemNotNexiPric.NE__OrderId__c = configuration.id;
            orderItemNotNexiPric.NE__ProdId__c  = productNotNexiPricing.id;
        orderItemNotNexiPric.NE__Action__c = 'None';
        orderItemNotNexiPric.NE__Parent_Order_Item__c = orderItemNotNexi.id;
            insert orderItemNotNexiPric;

        //ASSET
        Asset asset = new Asset(NE__AssetItemEnterpriseId__c = orderItemGTRoot.Id, OB_ShopCode__c = 'shopCode',	OB_GT__c = 'GT', OB_CustomerCode__c = 'customerCode', Name = 'SmartPOS');
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
        
        OB_TrackingOrder.CodiciConvenzioni codConv = new OB_TrackingOrder.CodiciConvenzioni();
        codConv.companyCode = 'companyCode';
        codConv.companyName = 'companyName';								
        codConv.codiceConvenzione        = 'code';										
        codConv.causaleRifiuto ='causaleRifiuto';
        codConv.dataInizio = '2011-11-13';
        codConv.dataFine = '';

        List<OB_TrackingOrder.CodiciConvenzioni> codConvList = new List<OB_TrackingOrder.CodiciConvenzioni>();
        codConvList.add(codConv);

        OB_TrackingOrder.TermsIdInformation termInfo = new OB_TrackingOrder.TermsIdInformation();    
        termInfo.termId = orderItemGTRoot.OB_TermId__c;
        termInfo.modello = 'model';
        termInfo.release = 'connectionType';
        termInfo.modalitaCollegamento = 'modality';
        termInfo.descrizioneModello = 'modelDescription';
        termInfo.descrizioneRelease = 'release';
        termInfo.descrizioneConnessione = 'releaseDescription';
        termInfo.statoInstallazione = 'Pending';
        termInfo.causaleRifiuto = '';
        termInfo.dataInstallazione = '2011-11-13';
        termInfo.dataDisinstallazione = '';
        termInfo.codiciconvenzioni = codConvList; //List

        List<OB_TrackingOrder.TermsIdInformation> termsInfoList = new List<OB_TrackingOrder.TermsIdInformation>();
        termsInfoList.add(termInfo);

        OB_TrackingOrder.ErrorList error = new OB_TrackingOrder.ErrorList();
        error.codice = '';
        error.descrizione = '';

        List<OB_TrackingOrder.ErrorList> errorsList = new List<OB_TrackingOrder.ErrorList>();
        errorsList.add(error);

        OB_TrackingOrder.puntoVendita pV = new OB_TrackingOrder.puntoVendita();
        //pV.itemId = '';
        pV.codicePuntoVendita = servicePoint.id;
        pV.dataInizio = '2011-11-13';
        pV.dataCessazione = '';
        pV.causaleCessazione = '';
        //pV.tipo = '';
        pV.codiceCTI = 'ctiCode';
        pV.codiceStabilimento = 'StabiCode';
        pV.codiceStabilimentoSIA = 'siaPVCode';
        pV.codiceProgressivoSIA = 'siaProgressiveCode';
        pV.codiceSIA = 'siaMerchantCode';
        pV.numeroAssistenzaPOS = 'assistanceNumber';
        //pV.dataInizioAttivita = '2011-11-13';
        pv.termsIdInformations = termsInfoList; //List

        List<OB_TrackingOrder.puntoVendita> pVList = new List<OB_TrackingOrder.puntoVendita>();
        pVList.add(pV);

        OB_TrackingOrder.GT gT = new OB_TrackingOrder.GT();
        gT.sistemaSorgente = 'MONETICA';
        gT.codiceCliente = 'companyCode';
        gT.errori = null; //List
        gT.puntiVendita = pVList; //List
        gT.statoProvisioning = 'test';

        List<OB_TrackingOrder.GT> gTList = new List<OB_TrackingOrder.GT>();
        gTList.add(gT);

        OB_TrackingOrder.Acquiring acquiring = new OB_TrackingOrder.Acquiring();
        acquiring.sistemaSorgente = 'NEXI';
        acquiring.codiceSocieta = 'companyCode';
        acquiring.errori = null;
        acquiring.puntiVendita = pVList;

        List<OB_TrackingOrder.Acquiring> acquiringList = new List<OB_TrackingOrder.Acquiring>();
        acquiringList.add(acquiring);

        OB_TrackingOrder.TrackingOrderRequest trackingOrderRequest = new OB_TrackingOrder.TrackingOrderRequest();
        trackingOrderRequest.idOrdineSfdc = configuration.id;
        trackingOrderRequest.Acquiring = acquiringList;
        trackingOrderRequest.GT = gTList;

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/TrackingOrder/*'; 
        req.httpMethod = 'POST';
        RestContext.request = req;
        String json = JSON.serialize(trackingOrderRequest);
        RestContext.request.requestBody =  Blob.valueof(json);
        RestContext.response = res;

        Test.startTest();
        OB_TrackingOrder.TrackingOrderResponse response = OB_TrackingOrder.trackOrder();
        Test.stopTest();
        }

    @isTest
    public static void OB_TrackingOrder_Test2(){
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
        NE__Order_Header__c orderHeader = new NE__Order_Header__c(OB_ProposerABI__c=bankAccount.Id ,NE__AccountId__c=myMastMerchant.Id, OB_Main_Process__c = 'Setup', OB_Sub_Process__c = 'variazione operativa', OB_Business_Model_Acquiring__c = 'Bancario');
        insert orderHeader;
        NE__Order__c configuration = new NE__Order__c(NE__AccountId__c=myMastMerchant.Id, OB_Service_Point__c = servicePoint.Id,NE__Order_Header__c=orderHeader.Id, OB_MCC__c = '0001', OB_MCCL2__c = '5631', OB_GT__c = 'Nexi', OB_PBSettlementMethod__c = 'PB Settlement Method', OB_InternationalSettlementMethod__c = 'International Settlement Method', OB_ReceiptCity__c = 'MILANO', OB_ReceiptHeader__c='Sweet Years', OB_Report_Type__c = 'Punto Vendita', OB_ShopSign__c = 'Sweet Years');
        insert configuration;

        //OrderItem ACQUIRING
        Id rtProductAcqRoot           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.ACQUIRING).getRecordTypeId(); 
        NE__Product__c productAcqRoot = new NE__Product__c(OB_Acquirer__c='NEXI', RecordTypeId =rtProductAcqRoot, OB_Codice_sfdc__c = 'VISAMASTERCARD', Name = 'Visa/Mastercard', OB_Contract_Type__c = 'Contratto Acquiring');
        insert productAcqRoot;
        NE__OrderItem__c orderItemAcqRoot = new NE__OrderItem__c(NE__Qty__c=10 ,NE__OrderId__c=configuration.id, NE__Action__c = 'Add', NE__ProdId__c = productAcqRoot.id, NE__Service_Point__c = servicePoint.Id, NE__Account__c = myMastMerchant.Id);
        insert orderItemAcqRoot;

        //OrderItem GT
        Id rtProductGTRoot          = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.TERMINALE).getRecordTypeId(); 
        NE__Product__c productGTRoot = new NE__Product__c(RecordTypeId = rtProductGTRoot, OB_Codice_sfdc__c = 'SMPOS_CASSA', Name = 'SmartPOS Cassa', OB_Contract_Type__c = 'Contratto POS;Modulo Off Commercial', OB_Business_Model_POS__c = 'Diretto;Trilaterale Nuovo');
        insert productGTRoot;
        NE__OrderItem__c orderItemGTRoot = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__Action__c = 'Add', OB_GT__c = 'MONETICA', OB_TermId__c = '21021990', NE__ProdId__c = productGTRoot.id, NE__Status__c = 'PENDING', OB_FulfilmentStatus__c = 'Pending');
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
        NE__OrderItem__c orderItemGT = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__Parent_Order_Item__c = orderItemGTRoot.id, NE__Action__c = 'Add', NE__ProdId__c = productGT.id);
        insert orderItemGT;

        //Item Acquiring Child
        Id rtProductAcq           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.ACQUIRING).getRecordTypeId(); 
        NE__Product__c productAcq = new NE__Product__c(RecordTypeId = rtProductAcq, OB_Acquirer__c='NEXI', OB_Codice_sfdc__c = 'VISAMASTERCARD', Name = 'Visa/Mastercard', OB_Contract_Type__c = 'Contratto Acquiring', OB_Offer__c ='PERSONALIZZATA;START');
        insert productAcq;
        NE__OrderItem__c orderItemAcq = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__ProdId__c = productAcq.id, NE__Action__c = 'Add', NE__Parent_Order_Item__c = orderItemGTRoot.id);  
        insert orderItemAcq;
        Id rtProductPric           = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.PRICING).getRecordTypeId(); 
        NE__Product__c productPric = new NE__Product__c(RecordTypeId = rtProductPric, OB_Codice_sfdc__c = 'MAE_PRE', Name = 'MAESTRO CONSUMER PREPAID', OB_Contract_Type__c = 'Contratto Acquiring');
        insert productPric;
        NE__OrderItem__c orderItemPric = new NE__OrderItem__c(NE__Qty__c = 1, NE__OrderId__c = configuration.id, NE__ProdId__c = productPric.id, NE__Action__c = 'Add', NE__Parent_Order_Item__c = orderItemAcq.id);  
        insert orderItemPric;

        //ADD ITEM TO CONFIGURATION
        Id rtProductPB    = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.PAGOBANCOMAT).getRecordTypeId(); 
            NE__Product__c productPB    = new NE__Product__c(OB_Acquirer__c=OB_EnrichOrder.NEXI, RecordTypeId =rtProductPB, OB_Codice_sfdc__c = 'PAGOBANCOMAT' );
            insert productPB;
        NE__OrderItem__c pagobancomat = New NE__OrderItem__c(NE__Qty__c=1 ,NE__OrderId__c=configuration.id, NE__Action__c = 'None', NE__ProdId__c = productPB.id);			
            insert pagobancomat;

        Id rtProductVAS   = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(OB_EnrichOrder.VAS).getRecordTypeId(); 
        NE__Product__c productRootVAS   = new NE__Product__c(RecordTypeId = rtProductVAS, OB_Codice_sfdc__c = 'PELLEGRINI');
            insert productRootVAS;
        NE__OrderItem__c rootVas = New NE__OrderItem__c(NE__Qty__c=1 ,NE__OrderId__c=configuration.id, NE__Action__c = 'None');			
            insert rootVas;
        NE__Product__c productVAS   = new NE__Product__c(RecordTypeId = rtProductVAS, OB_Codice_sfdc__c = 'PELLEGRINI');
            insert productVAS;
        NE__OrderItem__c vas = New NE__OrderItem__c(NE__Qty__c=1 ,NE__OrderId__c=configuration.id, NE__Action__c = 'Add');			
            insert vas;

        NE__Product__c product1    = new NE__Product__c(OB_Acquirer__c=OB_EnrichOrder.NEXI , RecordTypeId =rtProductPric );
            product1.OB_Codice_sfdc__c = 'ALB_AUTO';
            insert product1;

            NE__OrderItem__c orderItem1 = new NE__OrderItem__c();
            orderItem1.NE__Qty__c     = 1;
            orderItem1.NE__OrderId__c = configuration.id;
            orderItem1.NE__ProdId__c  = product1.id;
        orderItem1.NE__Action__c = 'Add';
        orderItem1.NE__Parent_Order_Item__c = orderItemAcq.id;
            insert orderItem1;

        //orderItem.NE__ProdId__r.RecordType.DeveloperName == OB_EnrichOrder.ACQUIRING && orderItem.NE__ProdId__r.OB_Acquirer__c!=OB_EnrichOrder.NEXI
        NE__Product__c productNotNexi    = new NE__Product__c(OB_Acquirer__c='AMEX' , RecordTypeId =rtProductAcqRoot, OB_Codice_sfdc__c = 'AMEX' );
            insert productNotNexi;

        NE__OrderItem__c orderItemNotNexi = new NE__OrderItem__c();
        orderItemNotNexi.NE__Qty__c     = 1;
            orderItemNotNexi.NE__OrderId__c = configuration.id;
            orderItemNotNexi.NE__ProdId__c  = productNotNexi.id;
        orderItemNotNexi.NE__Action__c = 'None';
        orderItemNotNexi.NE__Parent_Order_Item__c = null;
            insert orderItemNotNexi;

        NE__Product__c productNotNexiPricing   = new NE__Product__c(OB_Acquirer__c='AMEX' , RecordTypeId =rtProductPric, OB_Codice_sfdc__c = 'PRICING' );
            insert productNotNexiPricing;
        NE__OrderItem__c orderItemNotNexiPric = new NE__OrderItem__c();
        orderItemNotNexiPric.NE__Qty__c     = 1;
            orderItemNotNexiPric.NE__OrderId__c = configuration.id;
            orderItemNotNexiPric.NE__ProdId__c  = productNotNexiPricing.id;
        orderItemNotNexiPric.NE__Action__c = 'None';
        orderItemNotNexiPric.NE__Parent_Order_Item__c = orderItemNotNexi.id;
            insert orderItemNotNexiPric;

        //ASSET
        Asset asset = new Asset(NE__AssetItemEnterpriseId__c = orderItemGTRoot.Id, OB_ShopCode__c = 'shopCode',	OB_GT__c = 'GT', OB_CustomerCode__c = 'customerCode', Name = 'SmartPOS');
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
        
        OB_TrackingOrder.CodiciConvenzioni codConv = new OB_TrackingOrder.CodiciConvenzioni();
        codConv.companyCode = 'companyCode';
        codConv.companyName = 'companyName';								
        codConv.codiceConvenzione        = 'code';										
        codConv.causaleRifiuto ='causaleRifiuto';
        codConv.dataInizio = '2011-11-13';
        codConv.dataFine = '';

        List<OB_TrackingOrder.CodiciConvenzioni> codConvList = new List<OB_TrackingOrder.CodiciConvenzioni>();
        codConvList.add(codConv);

        OB_TrackingOrder.TermsIdInformation termInfo = new OB_TrackingOrder.TermsIdInformation();    
        termInfo.termId = orderItemGTRoot.OB_TermId__c;
        termInfo.modello = 'model';
        termInfo.release = 'connectionType';
        termInfo.modalitaCollegamento = 'modality';
        termInfo.descrizioneModello = 'modelDescription';
        termInfo.descrizioneRelease = 'release';
        termInfo.descrizioneConnessione = 'releaseDescription';
        termInfo.statoInstallazione = 'Pending';
        termInfo.causaleRifiuto = '';
        termInfo.dataInstallazione = '2011-11-13';
        termInfo.dataDisinstallazione = '';
        termInfo.codiciconvenzioni = codConvList; //List

        List<OB_TrackingOrder.TermsIdInformation> termsInfoList = new List<OB_TrackingOrder.TermsIdInformation>();
        termsInfoList.add(termInfo);

        OB_TrackingOrder.ErrorList error = new OB_TrackingOrder.ErrorList();
        error.codice = '';
        error.descrizione = '';

        List<OB_TrackingOrder.ErrorList> errorsList = new List<OB_TrackingOrder.ErrorList>();
        errorsList.add(error);

        OB_TrackingOrder.puntoVendita pV = new OB_TrackingOrder.puntoVendita();
        //pV.itemId = '';
        pV.codicePuntoVendita = servicePoint.id;
        pV.dataInizio = '2011-11-13';
        pV.dataCessazione = '';
        pV.causaleCessazione = '';
        //pV.tipo = '';
        pV.codiceCTI = 'ctiCode';
        pV.codiceStabilimento = 'StabiCode';
        pV.codiceStabilimentoSIA = 'siaPVCode';
        pV.codiceProgressivoSIA = 'siaProgressiveCode';
        pV.codiceSIA = 'siaMerchantCode';
        pV.numeroAssistenzaPOS = 'assistanceNumber';
        //pV.dataInizioAttivita = '2011-11-13';
        pv.termsIdInformations = null; //List

        List<OB_TrackingOrder.puntoVendita> pVList = new List<OB_TrackingOrder.puntoVendita>();
        pVList.add(pV);

        OB_TrackingOrder.GT gT = new OB_TrackingOrder.GT();
        gT.sistemaSorgente = 'MONETICA';
        gT.codiceCliente = 'companyCode';
        gT.errori = null; //List
        gT.puntiVendita = pVList; //List
        gT.statoProvisioning = 'test';

        List<OB_TrackingOrder.GT> gTList = new List<OB_TrackingOrder.GT>();
        gTList.add(gT);

        OB_TrackingOrder.Acquiring acquiring = new OB_TrackingOrder.Acquiring();
        acquiring.sistemaSorgente = 'NEXI';
        acquiring.codiceSocieta = 'companyCode';
        acquiring.errori = null;
        acquiring.puntiVendita = pVList;

        List<OB_TrackingOrder.Acquiring> acquiringList = new List<OB_TrackingOrder.Acquiring>();
        acquiringList.add(acquiring);

        OB_TrackingOrder.TrackingOrderRequest trackingOrderRequest = new OB_TrackingOrder.TrackingOrderRequest();
        trackingOrderRequest.idOrdineSfdc = configuration.id;
        trackingOrderRequest.Acquiring = acquiringList;
        trackingOrderRequest.GT = gTList;

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/TrackingOrder/*'; 
        req.httpMethod = 'POST';
        RestContext.request = req;
        String json = JSON.serialize(trackingOrderRequest);
        RestContext.request.requestBody =  Blob.valueof(json);
        RestContext.response = res;

        Test.startTest();
        OB_TrackingOrder.TrackingOrderResponse response = OB_TrackingOrder.trackOrder();
        Test.stopTest();
        }
}