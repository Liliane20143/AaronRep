/**
 * @author Abdoulaye & Moussa
 * @date Creation 06/12/2018
 * @version 1.0
 * @description Test of PLC TermIdsServices Rest WebService.
 */
@isTest
public class Plc_TermIdsServicesTest {
        
        @TestSetup
        static void setup(){
        Plc_TestFactory.initProcessClickPackage();
    
        Account account = Plc_TestFactory.createAccountSupplier('Name');
        insert account;
        /* Dummy dealer and warehouse */
        Plc_TestFactory.createWarehouseFake();
        /*** */

        Bit2Shop__Dealer__c dealerParent = Plc_TestFactory.createDealerParent('dealerParent', account,'01234567891');
        insert dealerParent;
        Bit2Shop__Dealer__c dealerChild = Plc_TestFactory.createDealerChild('dealer', account,'0123456789', dealerParent);
        dealerChild.Plc_Repairer__c = true;
        insert dealerChild;
        Bit2Shop__Warehouse__c bit2ShopWarehouse = Plc_TestFactory.createWarehouse('WH1', 'Repaired', 'Nexi','WH0001', dealerChild);
        bit2ShopWarehouse.Plc_Alias__c='00789654123654789';
        insert bit2ShopWarehouse;
        Plc_Solution__c plcSolution = Plc_TestFactory.createSolution('00541237896541230');
        insert plcSolution;
        Plc_WarehouseSolution__c plcWarehouseSolution = Plc_TestFactory.createWarehouseSolution('WHSL1',plcSolution,bit2ShopWarehouse);
        plcWarehouseSolution.Plc_Alias__c='00789654123654789';
        insert plcWarehouseSolution;

        Plc_TermId__c plcTermId = Plc_TestFactory.createTermId('55245846');
        plcTermId.Plc_TermIdCode__c='55245846';
        plcTermId.Plc_Alias__c='5524584600';
        insert plcTermId;
        
        Bit2Shop__Stock_Serials2__c bnit2ShopStockSerials2= Plc_TestFactory.createStockSerial2(bit2ShopWarehouse,'New');
        bnit2ShopStockSerials2.Plc_Property__c='N';
        bnit2ShopStockSerials2.Plc_TermId__c=plcTermId.Id;
        insert bnit2ShopStockSerials2;

        }


        /**
        * @author Abdoulaye & Moussa & Mame Diarra
        * @date Creation 10/12/2018
        * @Modification : Khalidou I. Sow BA on 08/04/2019
        * @version 1.0
        * @description Test of the method termIdsCheck when request contains an unique InformazioniMatricolaRequestBody.
        */
        @isTest
        static void termIdsCheckTestWhenInformazioniMatricolaRequestBody(){
            
                Plc_Wrappers.InformazioniMatricolaRequestBody infMatReqBody1 = Plc_WsTestFactory.createInformazioniMatricolaRequestBody('1234567980');
                Plc_Wrappers.InformazioniMatricolaRequestBody infMatReqBody2 = Plc_WsTestFactory.createInformazioniMatricolaRequestBody('55245846');
        
                Test.startTest();
                    Plc_ServiceWs.ServiceResponse response1= Plc_TermIdsServices.termIdsCheck(infMatReqBody1,'sourceLegacySystem');
                    Plc_ServiceWs.ServiceResponse response2= Plc_TermIdsServices.termIdsCheck(infMatReqBody2,'MONETICA');
                    Plc_ServiceWs.ServiceResponse response3= Plc_TermIdsServices.termIdsCheck(infMatReqBody2,'WSICT');
                Test.stopTest();
                System.assert(response1.outcomeCode == '208');
                System.assertEquals(response2.outcomeCode ,response3.outcomeCode);


        }

        /**
        * @author Abdoulaye & Moussa & Mame Diarra
        * @date Creation 10/12/2018
        * @version 1.0
        * @description Test of the method termIdsCheck when request contains a list of InformazioniMatricolaRequestBody.
        */
        @isTest
        static void termIdsCheckTestWhenInformazioniMatricolaRequest(){

            Plc_Wrappers.InformazioniMatricolaRequestBody infMatReqBody1 = Plc_WsTestFactory.createInformazioniMatricolaRequestBody('55245846');
            Plc_Wrappers.InformazioniMatricolaRequestBody infMatReqBody2 = Plc_WsTestFactory.createInformazioniMatricolaRequestBody('152458462');
            Plc_Wrappers.InformazioniMatricolaRequest infMatReq = new Plc_Wrappers.InformazioniMatricolaRequest();
            infMatReq.request.add(infMatReqBody1);
            infMatReq.request.add(infMatReqBody2);
            Test.startTest();
            Plc_ServiceWs.ServiceResponse response1= Plc_TermIdsServices.termIdsCheck(infMatReq,'MONETICA');
            Plc_ServiceWs.ServiceResponse response2= Plc_TermIdsServices.termIdsCheck(infMatReq,'WSICT');
            Test.stopTest();
        }
       
        /**
        * @author Mame Diarra
        * @date Creation 16/01/2019
        * @Modification : Khalidou I. Sow BA on 08/04/2019
        * @version 1.0
        * @description Test of the method termIdsUpdate.
        */
        @isTest 
        static void termIdsUpdateTestOK(){

            Plc_Wrappers.AggiornaTermIdRequestBody requestBody= new Plc_Wrappers.AggiornaTermIdRequestBody();
            requestBody.oldTermId='5524584600';
            requestBody.newTermId='66356956';

            Test.startTest();
                Plc_ServiceWs.ServiceResponse serviceResponse= Plc_TermIdsServices.termIdsUpdate(requestBody);
                requestBody.oldTermId='55245846';
                Plc_ServiceWs.ServiceResponse serviceResponse2= Plc_TermIdsServices.termIdsUpdate(requestBody);
            Test.stopTest();
            System.assert(serviceResponse.outcomeCode == '200');
            System.assert(serviceResponse2.outcomeCode == '206');

        }
    
 }