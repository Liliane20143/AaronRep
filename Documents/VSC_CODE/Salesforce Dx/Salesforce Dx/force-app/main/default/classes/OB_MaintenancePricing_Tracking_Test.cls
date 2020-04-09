@isTest
global class OB_MaintenancePricing_Tracking_Test {


    @testSetup 
        static void createOrderAndOrderItems(){  
        Id recordTypeIdAcquiring = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByDeveloperName().get('Acquiring').getRecordTypeId();
        Id recordTypeIdBancomat = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByDeveloperName().get('Pagobancomat').getRecordTypeId();
        Id recordTypeIdPos = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByDeveloperName().get('Terminali').getRecordTypeId();
        Id recordTypeIdVas = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByDeveloperName().get('Vas').getRecordTypeId();
        Id recordTypeIdPricing = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByDeveloperName().get('Pricing').getRecordTypeId();
        Id recordTypeIdProductAcquiring = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get('Acquiring').getRecordTypeId();
        Id recordTypeIdProductPos = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get('Terminali').getRecordTypeId();        

        NE__Order_Header__c oh = new NE__Order_Header__c();
        oh.OB_Sub_Process__c = OB_UtilityConstants.HEADER_SUBPROCESS_ECONOMICA;
        oh.NE__Type__c = 'ChangeOrder';
        insert oh; 
        //commission model order
        NE__Order__c modelCommissionOrder = new NE__Order__c();     
        modelCommissionOrder.NE__Order_Header__c = oh.Id;
        modelCommissionOrder.OB_Model_Changed__c = true; 
        insert modelCommissionOrder;         

        NE__Product__c visaMastercard = OB_TestDataFactory.getProduct( );
        visaMastercard.OB_Codice_sfdc__c = 'VISAMASTERCARD';
        visaMastercard.RecordTypeId = recordTypeIdProductAcquiring;
        insert visaMastercard;

        NE__Product__c posProduct = OB_TestDataFactory.getProduct( );
        posProduct.RecordTypeId = recordTypeIdProductPos;
        insert posProduct;

		NE__OrderItem__c vMorderItem = OB_TestDataFactory.getOrderItem( modelCommissionOrder.Id );
		vMorderItem.NE__Root_Order_Item__c = null;
        vMorderItem.NE__ProdId__c = visaMastercard.Id;
        vMorderItem.RecordTypeId = recordTypeIdAcquiring;
		insert vMorderItem;

        NE__OrderItem__c visaChild = OB_TestDataFactory.getOrderItem( modelCommissionOrder.Id);
		visaChild.NE__Root_Order_Item__c = vMorderItem.Id;
        visaChild.RecordTypeId = recordTypeIdPricing;
        visaChild.NE__ProdId__c = visaMastercard.Id;
        visaChild.NE__Action__c = 'Change';
		insert visaChild;
        //END - model changes process //

        //pricing variation order
        NE__Order__c pricingOrder = new NE__Order__c();     
        pricingOrder.NE__Order_Header__c = oh.Id;
        pricingOrder.OB_Model_Changed__c = false; 
        insert pricingOrder; 

        NE__OrderItem__c pos = OB_TestDataFactory.getOrderItem( pricingOrder.Id );
		pos.NE__Root_Order_Item__c = null;
        pos.RecordTypeId = recordTypeIdPos;
        pos.NE__ProdId__c = posProduct.Id;
        pos.OB_TermId__c = '00444999';
       // testOrderItem9.NE__ProdId__c = product.Id;
        pos.NE__Action__c = 'Change';
		insert pos;

		NE__OrderItem__c childPos = OB_TestDataFactory.getOrderItem( pricingOrder.Id );
		childPos.NE__Root_Order_Item__c = pos.Id;
        childPos.RecordTypeId = recordTypeIdPricing;
		insert childPos;

		NE__OrderItem__c vMorderItem2 = OB_TestDataFactory.getOrderItem( pricingOrder.Id );
		vMorderItem2.NE__Root_Order_Item__c = null;
        vMorderItem2.NE__ProdId__c = visaMastercard.Id;
        vMorderItem2.RecordTypeId = recordTypeIdAcquiring;
		insert vMorderItem2;

        NE__OrderItem__c visaChild2 = OB_TestDataFactory.getOrderItem( pricingOrder.Id);
		visaChild2.NE__Root_Order_Item__c = vMorderItem.Id;
        visaChild2.RecordTypeId = recordTypeIdPricing;
        visaChild2.NE__ProdId__c = visaMastercard.Id;
        visaChild2.NE__Action__c = 'Change';
		insert visaChild2;

        NE__OrderItem__c visaChildPricing = OB_TestDataFactory.getOrderItem( pricingOrder.Id);
		visaChildPricing.NE__Root_Order_Item__c = vMorderItem2.Id;
        visaChildPricing.RecordTypeId = recordTypeIdPricing;
        visaChildPricing.NE__ProdId__c = visaMastercard.Id;
        visaChildPricing.NE__Action__c = 'Change';
		insert visaChildPricing;

    }
    /*******************************************************************************
    Purpose:  Method tests trackMaintenancePricingOrder

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       ?                   ?             Created    -
    1.1       Kinga Fornal        07/08/2019    Updated    changed the request json
    ********************************************************************************/
    @isTest static void testModelChangesSuccess() {
        String modelChangesOrderId = '';
        String pricingOrder = '';
        List<NE__Order__c> orders = [SElect id,OB_Model_Changed__c from NE__Order__c LIMIT 2];
        for(NE__Order__c order : orders){
            if(order.OB_Model_Changed__c){
                modelChangesOrderId = order.Id;
            }else{
                pricingOrder = order.Id;
            }
        }

        List<NE__OrderItem__c> orderItems = [
            Select id, NE__OrderId__c,
                NE__OrderId__r.NE__Order_Header__r.OB_Sub_Process__c,
                NE__OrderId__r.OB_Model_Changed__c,
                OB_StartValidationDate__c,
                NE__StartDate__c,
                NE__Root_Order_Item__c,
                RecordType.DeveloperName,
                NE__Root_Order_Item__r.OB_StartValidationDate__c,
                NE__Root_Order_Item__r.RecordType.DeveloperName,
                NE__ProdId__c, 
                NE__ProdId__r.OB_Codice_sfdc__c,
                OB_FulfilmentStatus__c,
                NE__OrderId__r.OB_FulfilmentStatus__c,
                OB_Tech_Outcome_Equens__c,
                NE__OrderId__r.NE__Order_Header__c, 
                OB_Tech_Outcome_Monetica__c,
                NE__ProdId__r.OB_Acquirer__c,
                OB_Processor__c,
                NE__ProdId__r.RecordType.DeveloperName,
                OB_TermId__c
                from NE__OrderItem__c 
                where NE__OrderId__c IN :orders];
    
        String termId= '';
        String visaId= '';
        for(NE__OrderItem__c o : orderItems){ 
            if(o.OB_TermId__c != null){
                 termId = o.OB_TermId__c;     
            }
            if(o.NE__ProdId__r.RecordType.DeveloperName == 'Acquiring'){
                visaId = o.Id;
            }

        }

      RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/MaintenancePricingTrackingOrder';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        Test.startTest();
        //NEXI Kinga Fornal <kinga.fornal@accenture.com>, 09/08/2019 Code Coverage Fix START
        req.requestBody = Blob.valueof( '{"orderId":"'+modelChangesOrderId+'",' +
                '"GT":[{"statoProvisioning":null,"source":"MONETICA",' +
                '"PVCodes":[{"tipo":null,"terminalInformation":[{"terminalId":"'+termId+'","status":"Pending",' +
                '"pricingChange":[{ "status": "Changed", "startDate": "2018-01-01"}],' +
                '"errors":null,"agreementCodes":[]}],"startDate":"2011-11-13",' +
                '"PVCode":"a191l000000bQ7TAAU","itemId":null,' +
                '"changes":[{"result":"OK","externalId":"'+visaId+'","errors":[]}],' +
                '"assistanceNumber":"assistanceNumber"}],"errors":null}],' +
                '"Acquiring":[{"source":"NEXI",' +
                '"PVCodes":[{"tipo":null,"terminalInformation":[{"terminalId":"'+termId+'","status":"Pending",' +
                '"pricingChange":[{ "status": "Changed", "startDate": "2018-01-01"}],' +
                '"errors":null,"agreementCodes":[]}],"startDate":"2011-11-13",' +
                '"PVCode":"a191l000000bQ7TAAU","itemId":null,' +
                '"changes":[{"result":"OK","externalId":"'+visaId+'","errors":[]}],' +
                '"assistanceNumber":"assistanceNumber"}],"errori":null}]}');
        RestContext.request = req;
        RestContext.response= res;
        OB_TrackingUtility.TrackingOrderResponseMaintenance response = OB_MaintenancePricing_Tracking.trackMaintenancePricingOrder();
        Test.stopTest();

        System.assertEquals(400, response.httpStatus); //francesca.ribezzi 19/09/19 changing to 400
        //NEXI Kinga Fornal <kinga.fornal@accenture.com>, 09/08/2019 Code Coverage Fix STOP
    }

   @isTest static void testModelChangesFailed() {
        String modelChangesOrderId = '';
        String pricingOrder = '';
        List<NE__Order__c> orders = [SElect id,OB_Model_Changed__c from NE__Order__c LIMIT 2];
        for(NE__Order__c order : orders){
            if(order.OB_Model_Changed__c){
                modelChangesOrderId = order.Id;
            }else{
                pricingOrder = order.Id;
            }
        }

        List<NE__OrderItem__c> orderItems = [
            Select id, NE__OrderId__c,
                NE__OrderId__r.NE__Order_Header__r.OB_Sub_Process__c,
                NE__OrderId__r.OB_Model_Changed__c,
                OB_StartValidationDate__c,
                NE__StartDate__c,
                NE__Root_Order_Item__c,
                RecordType.DeveloperName,
                NE__Root_Order_Item__r.OB_StartValidationDate__c,
                NE__Root_Order_Item__r.RecordType.DeveloperName,
                NE__ProdId__c, 
                NE__ProdId__r.OB_Codice_sfdc__c,
                OB_FulfilmentStatus__c,
                NE__OrderId__r.OB_FulfilmentStatus__c,
                OB_Tech_Outcome_Equens__c,
                NE__OrderId__r.NE__Order_Header__c, 
                OB_Tech_Outcome_Monetica__c,
                NE__ProdId__r.OB_Acquirer__c,
                OB_Processor__c,
                NE__ProdId__r.RecordType.DeveloperName,
                OB_TermId__c
                from NE__OrderItem__c 
                where NE__OrderId__c IN :orders];
    
        String termId= '';
        String visaId= '';
        for(NE__OrderItem__c o : orderItems){ 
            if(o.OB_TermId__c != null){
                 termId = o.OB_TermId__c;     
            }
            if(o.NE__ProdId__r.RecordType.DeveloperName == 'Acquiring'){
                visaId = o.Id;
            }

        }

      RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/MaintenancePricingTrackingOrder';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        Test.startTest();
        req.requestBody = Blob.valueof('{ "orderId": "'+modelChangesOrderId+'", "Acquiring": [ { "source": "Equens", "companyCode": "string", "PVCodes": [ { "PVCode": "string", "startDate": "2018-06-25", "endDate": "2018-06-25", "reasonOfClosure": "string", "changes": [ { "externalId": "'+visaId+'", "result": "KO", "errors": [ { "code": "", "description": "" } ] } ] } ] } ], "GT": [ { "source": "Monetica", "errors": [ { "code": "", "description": "" } ], "gtCompanyCode": "string", "PVCodes": [ { "ctiCode": "cti code", "StabiCode": "string", "siaMerchantCode": "string", "siaPVCode": "string", "siaProgressiveCode": "string", "assistanceNumber": "string", "startDate": "2018-06-25", "terminalInformation": [ { "terminalId": "'+termId+'", "errors": [ { "code": "", "description": "" } ], "model": "model", "modelDescription": "model description", "release": "release", "releaseDescription": "string", "connectionType": "string", "modality": "string", "status": "Installed", "reasonOfRejection": "string", "installationDate": "2018-06-25", "uninstallationDate": "2018-06-25", "agreementCodes": [ { "status": "Activated", "companyCode": "string", "companyName": "string", "code": "string", "startDate": "2018-06-25", "endDate": "2018-06-25" } ], "pricingChange": { "status": "Changed", "startDate": "2018-01-01", "errors": [ { "code": "", "description": "" } ] } } ] } ] } ] }');
        RestContext.request = req;
        RestContext.response= res;
        OB_MaintenancePricing_Tracking.trackMaintenancePricingOrder();  
        Test.stopTest(); 

}
  @isTest static void testFailed() {

      RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/MaintenancePricingTrackingOrder';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        Test.startTest();
        req.requestBody = Blob.valueof('{ "orderId": "", "Acquiring": [ { "source": "Equens", "companyCode": "string", "PVCodes": [ { "PVCode": "string", "startDate": "2018-06-25", "endDate": "2018-06-25", "reasonOfClosure": "string", "changes": [ { "externalId": "", "result": "OK", "errors": [ { "code": "", "description": "" } ] } ] } ] } ], "GT": [ { "source": "Monetica", "errors": [ { "code": "", "description": "" } ], "gtCompanyCode": "string", "PVCodes": [ { "ctiCode": "cti code", "StabiCode": "string", "siaMerchantCode": "string", "siaPVCode": "string", "siaProgressiveCode": "string", "assistanceNumber": "string", "startDate": "2018-06-25", "terminalInformation": [ { "terminalId": "", "errors": [ { "code": "", "description": "" } ], "model": "model", "modelDescription": "model description", "release": "release", "releaseDescription": "string", "connectionType": "string", "modality": "string", "status": "Installed", "reasonOfRejection": "string", "installationDate": "2018-06-25", "uninstallationDate": "2018-06-25", "agreementCodes": [ { "status": "Activated", "companyCode": "string", "companyName": "string", "code": "string", "startDate": "2018-06-25", "endDate": "2018-06-25" } ], "pricingChange": { "status": "Changed", "startDate": "2018-01-01", "errors": [ { "code": "", "description": "" } ] } } ] } ] } ] }');
        RestContext.request = req;
        RestContext.response= res;
        OB_MaintenancePricing_Tracking.trackMaintenancePricingOrder();  
        Test.stopTest();   
  }

  @isTest static void testFailed500() {

      RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/MaintenancePricingTrackingOrder';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        Test.startTest();
        req.requestBody = Blob.valueof('{{ "orderId": "", "Acquiring": [ { "source": "Equens", "companyCode": "string", "PVCodes": [ { "PVCode": "string", "startDate": "2018-06-25", "endDate": "2018-06-25", "reasonOfClosure": "string", "changes": [ { "externalId": "", "result": "OK", "errors": [ { "code": "", "description": "" } ] } ] } ] } ], "GT": [ { "source": "Monetica", "errors": [ { "code": "", "description": "" } ], "gtCompanyCode": "string", "PVCodes": [ { "ctiCode": "cti code", "StabiCode": "string", "siaMerchantCode": "string", "siaPVCode": "string", "siaProgressiveCode": "string", "assistanceNumber": "string", "startDate": "2018-06-25", "terminalInformation": [ { "terminalId": "", "errors": [ { "code": "", "description": "" } ], "model": "model", "modelDescription": "model description", "release": "release", "releaseDescription": "string", "connectionType": "string", "modality": "string", "status": "Installed", "reasonOfRejection": "string", "installationDate": "2018-06-25", "uninstallationDate": "2018-06-25", "agreementCodes": [ { "status": "Activated", "companyCode": "string", "companyName": "string", "code": "string", "startDate": "2018-06-25", "endDate": "2018-06-25" } ], "pricingChange": { "status": "Changed", "startDate": "2018-01-01", "errors": [ { "code": "", "description": "" } ] } } ] } ] } ] }');
        RestContext.request = req;
        RestContext.response= res;
        OB_MaintenancePricing_Tracking.trackMaintenancePricingOrder();  
        Test.stopTest();   
  }


    /*******************************************************************************
    Purpose:  Method tests trackMaintenancePricingOrder

    History
    --------
    VERSION   AUTHOR              DATE          DETAIL     Description
    1.0       ?                   ?             Created    -
    1.1       Kinga Fornal        07/08/2019    Updated    changed the request json
    ********************************************************************************/
    @isTest static void testPricingSuccess() {
     String modelChangesOrderId = '';
        String pricingOrder = '';
        List<NE__Order__c> orders = [SElect id,OB_Model_Changed__c from NE__Order__c LIMIT 2];
        for(NE__Order__c order : orders){
            if(order.OB_Model_Changed__c){
                modelChangesOrderId = order.Id;
            }else{
                pricingOrder = order.Id;
            }
        }

        List<NE__OrderItem__c> orderItems = [
            Select id, NE__OrderId__c,
                NE__OrderId__r.NE__Order_Header__r.OB_Sub_Process__c,
                NE__OrderId__r.OB_Model_Changed__c,
                OB_StartValidationDate__c,
                NE__StartDate__c,
                NE__Root_Order_Item__c,
                RecordType.DeveloperName,
                NE__Root_Order_Item__r.OB_StartValidationDate__c,
                NE__Root_Order_Item__r.RecordType.DeveloperName,
                NE__ProdId__c, 
                NE__ProdId__r.OB_Codice_sfdc__c,
                OB_FulfilmentStatus__c,
                NE__OrderId__r.OB_FulfilmentStatus__c,
                OB_Tech_Outcome_Equens__c,
                NE__OrderId__r.NE__Order_Header__c, 
                OB_Tech_Outcome_Monetica__c,
                NE__ProdId__r.OB_Acquirer__c,
                OB_Processor__c,
                NE__ProdId__r.RecordType.DeveloperName,
                OB_TermId__c
                from NE__OrderItem__c 
                where NE__OrderId__c IN :orders];
    
        String termId= '';
        String visaId= '';
        for(NE__OrderItem__c o : orderItems){ 
            if(o.OB_TermId__c != null){
                 termId = o.OB_TermId__c;     
            }
            if(o.NE__ProdId__r.RecordType.DeveloperName == 'Acquiring'){
                visaId = o.Id;
            }

        }

      RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/MaintenancePricingTrackingOrder';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        Test.startTest();
        //NEXI Kinga Fornal <kinga.fornal@accenture.com>, 09/08/2019 Code Coverage Fix START
        req.requestBody =  Blob.valueof( '{"orderId":"'+pricingOrder+'",' +
                '"GT":[{"statoProvisioning":null,"source":"MONETICA",' +
                '"PVCodes":[{"tipo":null,"terminalInformation":[{"terminalId":"'+termId+'","status":"Pending",' +
                '"pricingChange":[{ "status": "Changed", "startDate": "2018-01-01"}],' +
                '"errors":null,"agreementCodes":[]}],"startDate":"2011-11-13",' +
                '"PVCode":"a191l000000bQ7TAAU","itemId":null,' +
                '"changes":[{"result":"OK","externalId":"'+visaId+'","errors":[]}],' +
                '"assistanceNumber":"assistanceNumber"}],"errors":null}],' +
                '"Acquiring":[{"source":"NEXI",' +
                '"PVCodes":[{"tipo":null,"terminalInformation":[{"terminalId":"'+termId+'","status":"Pending",' +
                '"pricingChange":[{ "status": "Changed", "startDate": "2018-01-01"}],' +
                '"errors":null,"agreementCodes":[]}],"startDate":"2011-11-13",' +
                '"PVCode":"a191l000000bQ7TAAU","itemId":null,' +
                '"changes":[{"result":"OK","externalId":"'+visaId+'","errors":[]}],' +
                '"assistanceNumber":"assistanceNumber"}],"errori":null}]}');
        RestContext.request = req;
        RestContext.response= res;
        OB_TrackingUtility.TrackingOrderResponseMaintenance response = OB_MaintenancePricing_Tracking.trackMaintenancePricingOrder();
        Test.stopTest();

        System.assertEquals(400, response.httpStatus);  //francesca.ribezzi 19/09/19 changing to 400
        //NEXI Kinga Fornal <kinga.fornal@accenture.com>, 09/08/2019 Code Coverage Fix
    }
   @isTest static void createWrapperClass() {
    OB_TrackingUtility.puntoVendita pvCodes= new  OB_TrackingUtility.puntoVendita();
        pvCodes.ctiCode     =                'Test';  
        pvCodes.StabiCode    =                'Test';      
        pvCodes.PVCode        =               'Test';      
        pvCodes.siaMerchantCode=                 'Test';  
        pvCodes.siaPVCode       =                'Test';  
        pvCodes.siaProgressiveCode=             'Test';   
        pvCodes.assistanceNumber   =            'Test';   
        pvCodes.startDate           =          'Test';  
        


    OB_TrackingUtility.CodiciConvenzioni ac = new OB_TrackingUtility.CodiciConvenzioni();
        ac.status         = 'Test';   
        ac.companyCode    = 'Test';         
        ac.companyName    = 'Test';          
        ac.code           = 'Test';     
        ac.startDate      = 'Test';          
        ac.endDate        = 'Test';      

    OB_TrackingUtility.TermsIdInformation ti = new OB_TrackingUtility.TermsIdInformation();   
        ti.terminalId           = 'Test';
        ti.model                = 'Test';
        ti.modelDescription     = 'Test'; 
        ti.release              = 'Test'; 
        ti.releaseDescription   = 'Test'; 
        ti.connectionType       = 'Test'; 
        ti.modality             = 'Test'; 
        ti.status               = 'Test'; 
        ti.reasonOfRejection    = 'Test'; 
        ti.installationDate     = 'Test'; 
        ti.uninstallationDate   = 'Test'; 

    OB_TrackingUtility.GT gt = new OB_TrackingUtility.GT();   
       gt.source              ='Test'; 
       gt.gtCompanyCode        ='Test'; 

    OB_TrackingUtility.ErrorList error = new OB_TrackingUtility.ErrorList();   
        error.code = 'test';
        error.description = 'test';
   }
   /*******************************************************************************
    Purpose:  Method tests the pricing process 

    History

    1.0       Francesca Ribezzi       19/09/2019    Created    
    ********************************************************************************/
@isTest static void testPricingSuccess_2() {
        String modelChangesOrderId = '';
        String pricingOrder = '';
        List<NE__Order__c> orders = [SElect id,OB_Model_Changed__c from NE__Order__c WHERE OB_Model_Changed__c = false limit 1];
        
        if(orders.size() > 0){
           pricingOrder = orders[0].Id;
        } 
     

        List<NE__OrderItem__c> orderItems = [
            Select id, NE__OrderId__c,
                NE__OrderId__r.NE__Order_Header__r.OB_Sub_Process__c,
                NE__OrderId__r.OB_Model_Changed__c,
                OB_StartValidationDate__c,
                NE__StartDate__c,
                NE__Root_Order_Item__c,
                RecordType.DeveloperName,
                NE__Root_Order_Item__r.OB_StartValidationDate__c,
                NE__Root_Order_Item__r.RecordType.DeveloperName,
                NE__ProdId__c, 
                NE__ProdId__r.OB_Codice_sfdc__c,
                OB_FulfilmentStatus__c,
                NE__OrderId__r.OB_FulfilmentStatus__c,
                OB_Tech_Outcome_Equens__c,
                NE__OrderId__r.NE__Order_Header__c, 
                OB_Tech_Outcome_Monetica__c,
                NE__ProdId__r.OB_Acquirer__c,
                OB_Processor__c,
                NE__ProdId__r.RecordType.DeveloperName,
                OB_TermId__c
                from NE__OrderItem__c 
                where NE__OrderId__c = :pricingOrder];
    
        String termId= '';
        String visaId= '';
        for(NE__OrderItem__c o : orderItems){ 
            if(o.OB_TermId__c != null){
                 termId = o.OB_TermId__c;     
            }
            if(o.NE__ProdId__r.RecordType.DeveloperName == 'Acquiring'){
                visaId = o.Id;
            }

        }

      RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/MaintenancePricingTrackingOrder';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        Test.startTest();
        req.requestBody = Blob.valueof('{ "orderId": "'+pricingOrder+'", "Acquiring": [ { "source": "Equens", "companyCode": "string", "PVCodes": [ { "PVCode": "string", "startDate": "2018-06-25", "endDate": "2018-06-25", "reasonOfClosure": "string", "changes": [ { "externalId": "'+visaId+'", "result": "KO", "errors": [ { "code": "", "description": "" } ] } ] } ] } ], "GT": [ { "source": "Monetica", "errors": [ { "code": "", "description": "" } ], "gtCompanyCode": "string", "PVCodes": [ { "ctiCode": "cti code", "StabiCode": "string", "siaMerchantCode": "string", "siaPVCode": "string", "siaProgressiveCode": "string", "assistanceNumber": "string", "startDate": "2018-06-25", "terminalInformation": [ { "terminalId": "'+termId+'", "errors": [ { "code": "", "description": "" } ], "model": "model", "modelDescription": "model description", "release": "release", "releaseDescription": "string", "connectionType": "string", "modality": "string", "status": "Installed", "reasonOfRejection": "string", "installationDate": "2018-06-25", "uninstallationDate": "2018-06-25", "agreementCodes": [ { "status": "Activated", "companyCode": "string", "companyName": "string", "code": "string", "startDate": "2018-06-25", "endDate": "2018-06-25" } ], "pricingChange": { "status": "Changed", "startDate": "2018-01-01", "errors": [ { "code": "", "description": "" } ] } } ] } ] } ] }');
        RestContext.request = req;
        RestContext.response= res;
        OB_MaintenancePricing_Tracking.trackMaintenancePricingOrder();  
        Test.stopTest(); 


   }
    /*******************************************************************************
    Purpose:  Method tests updateStartDateEquensAndStatus 

    History

    1.0       Francesca Ribezzi       19/09/2019    Created    
    ********************************************************************************/
@isTest 
static void updateStartDateEquensAndStatus_Test() {
  String modelChangesOrderId = '';
        List<NE__Order__c> orders = [SElect id,OB_Model_Changed__c from NE__Order__c WHERE OB_Model_Changed__c = true limit 1];
        
        if(orders.size() > 0){
           modelChangesOrderId = orders[0].Id;
        } 

    List<NE__OrderItem__c> orderItems = [
            Select id, NE__OrderId__c,
                NE__OrderId__r.NE__Order_Header__r.OB_Sub_Process__c,
                NE__OrderId__r.OB_Model_Changed__c,
                OB_StartValidationDate__c,
                NE__StartDate__c,
                NE__Root_Order_Item__c,
                RecordType.DeveloperName,
                NE__Root_Order_Item__r.OB_StartValidationDate__c,
                NE__Root_Order_Item__r.RecordType.DeveloperName,
                NE__ProdId__c, 
                NE__ProdId__r.OB_Codice_sfdc__c,
                OB_FulfilmentStatus__c,
                NE__OrderId__r.OB_FulfilmentStatus__c,
                OB_Tech_Outcome_Equens__c,
                NE__OrderId__r.NE__Order_Header__c, 
                OB_Tech_Outcome_Monetica__c,
                NE__ProdId__r.OB_Acquirer__c,
                OB_Processor__c,
                NE__ProdId__r.RecordType.DeveloperName,
                OB_TermId__c
                from NE__OrderItem__c 
                where NE__OrderId__c = :modelChangesOrderId];

        String termId= '';
        String visaId= '';
        for(NE__OrderItem__c o : orderItems){ 
            if(o.OB_TermId__c != null){
                 termId = o.OB_TermId__c;     
            }
            if(o.NE__ProdId__r.RecordType.DeveloperName == 'Acquiring'){
                visaId = o.Id;
            }

        }
        Test.startTest();
            OB_MaintenancePricing_Tracking.updateStartDateEquensAndStatus('OK', visaId,  orderItems, '', null);
        Test.stopTest();

    } 
    /*******************************************************************************
    Purpose:  Method tests updateEquensAcqAndVasOrderItems  

    History

    1.0       Francesca Ribezzi       19/09/2019    Created    
    ********************************************************************************/
    @isTest 
    static void updateEquensAcqAndVasOrderItems_Test() {
        Map<String, Boolean> externalIdMissingFieldsMap = new    Map<String, Boolean>();
        Map<String, String> externalIdResultMap = new Map<String, String>();
        String modelChangesOrderId = '';
        List<NE__Order__c> orders = [SElect id,OB_Model_Changed__c from NE__Order__c WHERE OB_Model_Changed__c = true limit 1];
        
        if(orders.size() > 0){
           modelChangesOrderId = orders[0].Id;
        } 

    List<NE__OrderItem__c> orderItems = [
            Select id, NE__OrderId__c,
                NE__OrderId__r.NE__Order_Header__r.OB_Sub_Process__c,
                NE__OrderId__r.OB_Model_Changed__c,
                OB_StartValidationDate__c,
                NE__StartDate__c,
                NE__Root_Order_Item__c,
                RecordType.DeveloperName,
                NE__Root_Order_Item__r.OB_StartValidationDate__c,
                NE__Root_Order_Item__r.RecordType.DeveloperName,
                NE__ProdId__c, 
                NE__ProdId__r.OB_Codice_sfdc__c,
                OB_FulfilmentStatus__c,
                NE__OrderId__r.OB_FulfilmentStatus__c,
                OB_Tech_Outcome_Equens__c,
                NE__OrderId__r.NE__Order_Header__c, 
                OB_Tech_Outcome_Monetica__c,
                NE__ProdId__r.OB_Acquirer__c,
                OB_Processor__c,
                NE__ProdId__r.RecordType.DeveloperName,
                OB_TermId__c
                from NE__OrderItem__c 
                where NE__OrderId__c = :modelChangesOrderId];

        String termId= '';
        String visaId= '';
        for(NE__OrderItem__c o : orderItems){ 
            if(o.OB_TermId__c != null){
                 termId = o.OB_TermId__c;     
                 externalIdMissingFieldsMap.put(termId, false);
                 externalIdResultMap.put(termId, 'OK');
            }
            if(o.NE__ProdId__r.RecordType.DeveloperName == 'Acquiring'){
                visaId = o.Id;
            }

        }
        Test.startTest();
            OB_MaintenancePricing_Tracking.updateEquensAcqAndVasOrderItems(externalIdMissingFieldsMap,externalIdResultMap, orderItems,'');
        Test.stopTest();

    }  

    /*******************************************************************************
    Purpose:  Method tests updateEquensAcqAndVasOrderItems  
    History
    1.0       Micol Ferrari      13/11/2019    Created    
    ********************************************************************************/
    @isTest 
    static void rollBackmodify_Test()
    { 

        List<NE__Order__c> orders = [SElect id,OB_Model_Changed__c from NE__Order__c WHERE OB_Model_Changed__c = true limit 1];

        List<NE__OrderItem__c> orderItems = [
            SELECT id, NE__OrderId__c,
                NE__OrderId__r.NE__Order_Header__r.OB_Sub_Process__c,
                NE__OrderId__r.OB_Model_Changed__c,
                OB_StartValidationDate__c,
                NE__StartDate__c,
                NE__Root_Order_Item__c,
                RecordType.DeveloperName,
                NE__Root_Order_Item__r.OB_StartValidationDate__c,
                NE__Root_Order_Item__r.RecordType.DeveloperName,
                NE__ProdId__c, 
                NE__ProdId__r.OB_Codice_sfdc__c,
                OB_FulfilmentStatus__c,
                NE__OrderId__r.OB_FulfilmentStatus__c,
                OB_Tech_Outcome_Equens__c,
                NE__OrderId__r.NE__Order_Header__c, 
                OB_Tech_Outcome_Monetica__c,
                NE__ProdId__r.OB_Acquirer__c,
                OB_Processor__c,
                NE__ProdId__r.RecordType.DeveloperName,
                OB_TermId__c,
                NE__Action__c
                FROM NE__OrderItem__c 
                WHERE NE__OrderId__c = :orders[0].Id];
        
        Test.startTest();
            OB_MaintenancePricing_Tracking.rollBackmodify(orderItems);
        Test.stopTest();
        
    }

    /*******************************************************************************
    Purpose:  Method tests updateEquensAcqAndVasOrderItems  
    History
    1.0       Micol Ferrari      13/11/2019    Created    
    ********************************************************************************/
    @isTest 
    static void cloneOrderItemFailed_Test()
    { 
        List<NE__Order__c> orders = [SElect id,OB_Model_Changed__c from NE__Order__c WHERE OB_Model_Changed__c = true limit 1];

        List<NE__OrderItem__c> orderItems = [
            SELECT id, NE__OrderId__c,
                NE__OrderId__r.NE__Order_Header__r.OB_Sub_Process__c,
                NE__OrderId__r.OB_Model_Changed__c,
                OB_StartValidationDate__c,
                NE__StartDate__c,
                NE__Root_Order_Item__c,
                RecordType.DeveloperName,
                NE__Root_Order_Item__r.OB_StartValidationDate__c,
                NE__Root_Order_Item__r.RecordType.DeveloperName,
                NE__ProdId__c, 
                NE__ProdId__r.OB_Codice_sfdc__c,
                OB_FulfilmentStatus__c,
                NE__OrderId__r.OB_FulfilmentStatus__c,
                OB_Tech_Outcome_Equens__c,
                NE__OrderId__r.NE__Order_Header__c, 
                OB_Tech_Outcome_Monetica__c,
                NE__ProdId__r.OB_Acquirer__c,
                OB_Processor__c,
                NE__ProdId__r.RecordType.DeveloperName,
                OB_TermId__c,
                NE__Action__c
                FROM NE__OrderItem__c 
                WHERE NE__OrderId__c = :orders[0].Id];
        
        Test.startTest();
            OB_MaintenancePricing_Tracking.cloneOrderItemFailed(orderItems.get(0));
        Test.stopTest();
    }

    /*******************************************************************************
    Purpose:  Method tests updateEquensAcqAndVasOrderItems  
    History
    1.0       Micol Ferrari      13/11/2019    Created    
    ********************************************************************************/
    @isTest 
    static void rollBackCommisisonModel_Test()
    { 
        Id recordTypeIdProductCommissione = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get('Commissione').getRecordTypeId();
        Id recordTypeIdProductPCI = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get('PCI').getRecordTypeId();
        Id recordTypeIdPricing = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByDeveloperName().get('Pricing').getRecordTypeId();
        
        NE__Product__c commissioneProduct = OB_TestDataFactory.getProduct( );
        commissioneProduct.RecordTypeId = recordTypeIdProductCommissione;
        NE__Product__c PCIProduct = OB_TestDataFactory.getProduct( );
        PCIProduct.RecordTypeId = recordTypeIdProductPCI;
        insert new List<NE__Product__c>{commissioneProduct,PCIProduct};

        NE__Order_Header__c oh2 = new NE__Order_Header__c();
        oh2.OB_Sub_Process__c = OB_UtilityConstants.HEADER_SUBPROCESS_ECONOMICA;
        oh2.NE__Type__c = 'ChangeOrder';
        insert oh2; 

        NE__Order__c order = new NE__Order__c();     
        order.NE__Order_Header__c = oh2.Id;
        insert order; 

        NE__OrderItem__c commissioneOI = OB_TestDataFactory.getOrderItem( order.Id);
        commissioneOI.RecordTypeId = recordTypeIdPricing;
        commissioneOI.NE__ProdId__c = commissioneProduct.Id;
        commissioneOI.NE__Action__c = 'Add';

        NE__OrderItem__c PCIoi = OB_TestDataFactory.getOrderItem( order.Id);
        PCIoi.RecordTypeId = recordTypeIdPricing;
        PCIoi.NE__ProdId__c = PCIProduct.Id;
        PCIoi.NE__Action__c = 'Remove';
		insert new List<NE__OrderItem__c>{commissioneOI,PCIoi};
        
        List<NE__OrderItem__c> orderItems = [
            SELECT id, NE__OrderId__c,
                NE__OrderId__r.NE__Order_Header__r.OB_Sub_Process__c,
                NE__OrderId__r.OB_Model_Changed__c,
                OB_StartValidationDate__c,
                NE__StartDate__c,
                NE__Root_Order_Item__c,
                RecordType.DeveloperName,
                NE__Root_Order_Item__r.OB_StartValidationDate__c,
                NE__Root_Order_Item__r.RecordType.DeveloperName,
                NE__ProdId__c, 
                NE__ProdId__r.OB_Codice_sfdc__c,
                OB_FulfilmentStatus__c,
                NE__OrderId__r.OB_FulfilmentStatus__c,
                OB_Tech_Outcome_Equens__c,
                NE__OrderId__r.NE__Order_Header__c, 
                OB_Tech_Outcome_Monetica__c,
                NE__ProdId__r.OB_Acquirer__c,
                OB_Processor__c,
                NE__ProdId__r.RecordType.DeveloperName,
                OB_TermId__c,
                NE__Action__c
                FROM NE__OrderItem__c 
                WHERE NE__OrderId__c = :order.Id];
        
        Test.startTest();
            OB_MaintenancePricing_Tracking.rollBackCommisisonModel(orderItems,'test');
        Test.stopTest();
    }

    /*******************************************************************************
    Purpose:  Method tests updateEquensAcqAndVasOrderItems  
    History
    1.0       Micol Ferrari      13/11/2019    Created    
    ********************************************************************************/
    @isTest 
    static void updateAttrubute_Test()
    { 
        List<NE__Order__c> orders = [SElect id,OB_Model_Changed__c from NE__Order__c WHERE OB_Model_Changed__c = true limit 1];

        List<NE__OrderItem__c> orderItems = [
            SELECT id, NE__OrderId__c,
                NE__OrderId__r.NE__Order_Header__r.OB_Sub_Process__c,
                NE__OrderId__r.OB_Model_Changed__c,
                OB_StartValidationDate__c,
                NE__StartDate__c,
                NE__Root_Order_Item__c,
                RecordType.DeveloperName,
                NE__Root_Order_Item__r.OB_StartValidationDate__c,
                NE__Root_Order_Item__r.RecordType.DeveloperName,
                NE__ProdId__c, 
                NE__ProdId__r.OB_Codice_sfdc__c,
                OB_FulfilmentStatus__c,
                NE__OrderId__r.OB_FulfilmentStatus__c,
                OB_Tech_Outcome_Equens__c,
                NE__OrderId__r.NE__Order_Header__c, 
                OB_Tech_Outcome_Monetica__c,
                NE__ProdId__r.OB_Acquirer__c,
                OB_Processor__c,
                NE__ProdId__r.RecordType.DeveloperName,
                OB_TermId__c,
                NE__Action__c
                FROM NE__OrderItem__c 
                WHERE NE__OrderId__c = :orders[0].Id];
        orderItems.get(0).OB_Tech_Outcome_Equens__c = 'KO';
        NE__Order_Item_Attribute__c oia1 = new NE__Order_Item_Attribute__c(NE__Order_Item__c = orderItems.get(0).Id,NE__Value__c='test',NE__Old_Value__c='test0' );
        insert oia1;
        Test.startTest();
            OB_MaintenancePricing_Tracking.updateAttrubute(orderItems);
        Test.stopTest();
    }

    /*******************************************************************************
    Purpose:  Method tests updateEquensAndMoneticaOrderItems  
    History
    1.0       Francesca Ribezzi     19/11/2019    Created    
    ********************************************************************************/
    @isTest 
    static void updateEquensAndMoneticaOrderItems_Test()
    { 
        OB_MaintenancePricing_Tracking.finalResultObj finalResponseEq = new OB_MaintenancePricing_Tracking.finalResultObj();
        OB_MaintenancePricing_Tracking.finalResultObj finalResponseMonetica = new OB_MaintenancePricing_Tracking.finalResultObj();
        OB_MaintenancePricing_Tracking.finalResultObj finalRespObj = new OB_MaintenancePricing_Tracking.finalResultObj();   
        NE__Order__c o = new Ne__Order__c();
        insert o;
        Test.startTest();
            OB_MaintenancePricing_Tracking.updateEquensAndMoneticaOrderItems(finalResponseEq, finalResponseMonetica, o.Id);
        Test.stopTest();

    }
}