/**
 * @author Abdoulaye & Moussa
 * @date Creation 06/12/2018
 * @version 1.0
 * @description Test of PLC ServiceWs Rest WebService.
 */
@isTest
public class Plc_ServiceWsTest {
    
    @TestSetup
    static void setup(){

        Plc_WorkOrderConfiguration__c workOrderConfiguration = new  Plc_WorkOrderConfiguration__c();
        workOrderConfiguration.Plc_IntegrationName__c           =   'Installation';
        workOrderConfiguration.Plc_EligibleOperationTypes__c    =   'ToInstall';
        workOrderConfiguration.Plc_NeedsCalculation__c          =   true;
        workOrderConfiguration.Plc_NeedsReservation__c          =   true;
        insert workOrderConfiguration;

        Plc_SystemSettings__c settings = new Plc_SystemSettings__c();
        settings.Plc_WsMoneticaInMaintenance__c         =   true;
        settings.Plc_DaysForCalculatingConsumption__c   =   30;
        settings.Plc_PurchaseWarrantyMonthsDelay__c     =   5;
        settings.Plc_WsWsictInMaintenance__c            =   true;
        insert settings;


    }
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 06/12/2018
    * @version 1.0
    * @description Test of the method  isResourceChanged.
    */
    @isTest
    static void isResourceChangedTest(){
        
        Account acc = Plc_TestFactory.createAccountSupplier('Name');
        Long requestTimestamp=10L;
        
        // Start test
        Test.startTest();
        Plc_ServiceWs.isResourceChanged(acc,requestTimestamp);
        // Stop test
        Test.stopTest();
    }

    /**
    * @author Abdoulaye & Moussa
    * @date Creation 06/12/2018
    * @Modify 27/02/2019 by Mame Diarra
    * @version 1.0
    * @description Test of the method  isWriteInMaintenance.
    */
    @isTest
    static void isInMaintenanceTest(){
        
        Test.startTest();

            Plc_SystemSettings__c settings = Plc_SystemSettings__c.getOrgDefaults();

            //if sourceExtSystem equals MONETICA
            Boolean response= Plc_ServiceWs.isInMaintenance('M');
            System.assertEquals(response,true);

            //if sourceExtSystem equals WSICT
            Boolean response2= Plc_ServiceWs.isInMaintenance('W');
            System.assertEquals(response2,true);

            //sourceExtSystem Not MONETICA AND not WSICT
            Boolean response3= Plc_ServiceWs.isInMaintenance('');
            System.assertEquals(response3,false);

        Test.stopTest();
    }

    /**
    * @author Abdoulaye & Moussa
    * @date Creation 06/12/2018
    * @version 1.0
    * @description Test of Class WresponseClass.
    */
    @isTest
    static void wResponseClassTest(){
        
        // Start test
        Test.startTest();
        Plc_ServiceWs.WsResponse wresponse1=new Plc_ServiceWs.WsResponse();
        System.assertEquals(wresponse1.result.outcomeCode,'200');

        Plc_ServiceWs.WsResponse wresponse2=new Plc_ServiceWs.WsResponse('600');
        System.assertEquals(wresponse2.result.outcomeCode,'600');

        Plc_ServiceWs.WsResponse wresponse3=new Plc_ServiceWs.WsResponse('602',System.Label.Plc_ApexClass200UserFeedback);
        System.assertEquals(wresponse3.result.outcomeCode,'602');


            // Stop test
        Test.stopTest();
    }

    /**
    * @author Abdoulaye & Moussa
    * @date Creation 06/12/2018
    * @version 1.0
    * @description Test of Class WsMaintenanceResponse.
    */
    @isTest
    static void wsMaintenanceResponseTest(){
        
        // Start test
        Test.startTest();
        Plc_ServiceWs.WsMaintenanceResponse wsMaintenanceResponse=new Plc_ServiceWs.WsMaintenanceResponse();
        // Stop test
        Test.stopTest();
    }

    /**
    * @author Abdoulaye & Moussa
    * @date Creation 06/12/2018
    * @version 1.0
    * @description Test of Class WsSingleResponse.
    */
    @isTest
    static void wsSingleResponseTest(){
        
        // Start test
        Test.startTest();
        Plc_ServiceWs.WsSingleResponse wsSingleResponse1=new Plc_ServiceWs.WsSingleResponse();
        System.assertEquals(wsSingleResponse1.result.outcomeCode,'200');

        Plc_ServiceWs.WsSingleResponse wsSingleResponse2=new Plc_ServiceWs.WsSingleResponse('600');
        System.assertEquals(wsSingleResponse2.result.outcomeCode,'600');

        Plc_ServiceWs.WsSingleResponse wsSingleResponse3=new Plc_ServiceWs.WsSingleResponse('602',System.Label.Plc_ApexClass200UserFeedback);
        System.assertEquals(wsSingleResponse3.result.outcomeCode,'602');


        // Stop test
        Test.stopTest();
    }

    /**
    * @author Abdoulaye & Moussa
    * @date Creation 06/12/2018
    * @version 1.0
    * @description Test of Class WsMultipleResponse.
    */
    @isTest
    static void WsMultipleResponseTest(){
        
        // Start test
        Test.startTest();
        Plc_ServiceWs.WsMultipleResponse wsMultipleResponse1=new Plc_ServiceWs.WsMultipleResponse();
        System.assertEquals(wsMultipleResponse1.result.outcomeCode,'200');

        Plc_ServiceWs.WsMultipleResponse wsMultipleResponse2=new Plc_ServiceWs.WsMultipleResponse('600');
        System.assertEquals(wsMultipleResponse2.result.outcomeCode,'600');
        // Stop test
        Test.stopTest();
    }

    /**
    * @author Abdoulaye & Moussa
    * @date Creation 06/12/2018
    * @version 1.0
    * @description Test of Class ServiceResponse.
    */
    @isTest
    static void ServiceResponseTest(){
        
        // Start test
        Test.startTest();
        Plc_ServiceWs.ServiceResponse serviceResponse=new Plc_ServiceWs.ServiceResponse();
        serviceResponse.outcomeCode='';
        // Stop test
        Test.stopTest();
    }

    /**
    * @author Abdoulaye & Moussa & Mame Diarra
    * @date Creation 31/12/2018
    * @version 1.0
    * @description Test of the Method traceWsCall.
    * @params:RestRequest, WsResponse, Datetime.
    */
    @isTest
    static void traceWsCallTest(){
        
       RestRequest restRequest = RestContext.request;
       Plc_ServiceWs.WsResponse response = new Plc_ServiceWs.WsResponse('604', 'Erreur');
       Datetime initTimestamp = Datetime.now();
       String recordLink ='test';
        // Start test
        Test.startTest();
        try{
        Plc_ServiceWs.traceWsCall(restRequest,response,initTimestamp);
        }catch(Exception e){
            e.getMessage();
        }
        // Stop test
        Test.stopTest();
    }
    
    /**
    * @author Abdoulaye & Moussa & Mame Diarra
    * @date Creation 31/12/2018
    * @version 1.0
    * @description Test of the Method traceWsCall.
    * @params:RestRequest, WsResponse, Datetime,Integer,Integer.

    */
    @isTest
    static void traceWsCallWithFiveParametersTest(){
        
       RestRequest restRequest = RestContext.request;
       Plc_ServiceWs.WsResponse response = new Plc_ServiceWs.WsResponse('604', 'Erreur');
       Datetime initTimestamp = Datetime.now();
       Integer executionTimeStep1=2;
       Integer executionTimeStep2=4;  
       String recordLink ='test';
        // Start test
        Test.startTest();
        try{
        Plc_ServiceWs.traceWsCall(restRequest,response,initTimestamp,executionTimeStep1,executionTimeStep2,recordLink, '');
        }catch(Exception e){
           e.getMessage();
        }
        // Stop test
        Test.stopTest();
    }
    
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 23/01/2019
    * @version 1.0
    * @description Test of the method  getWorkOrderConfigurationMap.
    */
    @isTest
    static void getWorkOrderConfigurationMapTest(){
        // Start test
        Test.startTest();
        Map<String, Plc_WorkOrderConfiguration__c> workOrderConfigurationMap=Plc_ServiceWs.getWorkOrderConfigurationMap();
        // Stop test
        Test.stopTest();
    } 
    
    /**
    * @author Mame Diarra
    * @date Creation 05/02/2019
    * @version 1.0
    * @description Test of the method  isResourceChanged.
    */
    @isTest
    static void getIsResourceChangedTest(){
        SObject obj = new Account();
        Long requestTimestamp=62362313;
        // Start test
        Test.startTest();
        Boolean response=Plc_ServiceWs.isResourceChanged(obj,requestTimestamp);
        // Stop test
        Test.stopTest();
    }
}