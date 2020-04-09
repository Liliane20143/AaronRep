/**
 * @author Abdoulaye & Moussa
 * @date Creation 06/12/2018
 * @version 1.0
 * @description Test of PLC RestCalloutUtlTest Rest WebService.
 */
@isTest
public class Plc_RestCalloutUtlTest {
    
    
    @testSetup
    static void setup(){
        Plc_TestFactory.initProcessClickPackage();
        Account account = Plc_TestFactory.createAccountSupplier('Name');
        insert account;
        Bit2Shop__Dealer__c bit2ShopDealer = Plc_TestFactory.createDealer('dealer', account,'1234567');
        bit2ShopDealer.Plc_Repairer__c=true;
        insert bit2ShopDealer;
        Bit2Shop__Warehouse__c bit2ShopWarehouse = Plc_TestFactory.createWarehouse('1NEXI', 'Repaired', '', '000001NEXI', bit2ShopDealer);
        //bit2ShopWarehouse.Plc_CoverageIndex__c=1;
        insert bit2ShopWarehouse;

        OB_EnvironmentConfiguration__c environmentConfiguration = new OB_EnvironmentConfiguration__c();
        environmentConfiguration.Name = 'CURRENTORG';
        environmentConfiguration.OB_CurrentOrg__c = 'DEV1';
        insert environmentConfiguration;

        OB_Integration_Configuration__c configuration = new OB_Integration_Configuration__c();
        configuration.Name = 'DEV1';
        configuration.OB_CAsigned_name__c = '';
        configuration.OB_Client_ID__c = '631edaf5-d79a-43b8-8753-1dd64e8e210f';
        configuration.OB_Client_Secret__c = '1b332dad-0b9f-4745-87b1-01c4f5d1a292';
        configuration.OB_Domain__c = 'dev1';
        configuration.OB_Grant_Type__c = 'client_credentials';
        configuration.OB_Timeout_Continuation__c = '30';
        configuration.OB_Timestamp__c = '154392275757575';
        configuration.OB_Token_1__c = 'eyJ0eXAiOiJKV1QiLCJjdHkiOiJKV1QiLCJhbGciOiJSU0EtT0FFUCIsImVuYyI6IkExMjhDQkMtSFMyNTYifQ.Lgw6lqjmOIWy4dPRJmvIyKQBht9BlMDATRylNS1nJGeDePjmvfSxgeZbRzMnu89snNTh9b6SzxsPVUMsgDJ4klsUT81GuFU-sPe4u_zBss5y9jvXe8KwuU5zXDm7ElY_jYUqHKaWaLpCpkfq8UwGcJ_VL7TDJ7m7_eWAc67P';
        configuration.OB_Token_2__c = 'gPl_TKmk2ggdSoRnvQqC9FF2ywLGPtYj_6kKea5esiQlrfmmgtJUy2kcjeUS8YOtxw3X63q-ehEYEvPwQ_eZ9Mpr09DuKtlnOQCsOqBCle60zxNZpiWsyOmmT_Z4Diy2CjaN84u9uIUT-9cea4cdKgEMXTJpqhD5MGHaegt8m-DKKA.pnvamAYqa8kZ_uDcM2tAnQ.ox1twscMrBYAHxrob9WYAgzLu76VDEIKNT5xZgm53kkwmzRqs2lPkBp92';
        configuration.OB_Token_3__c = 'eTSNiQC0mvmjuu2JL0K3h5XLwTUgjHsBW90uAj8oBEnubLcjzb_bQLi5kBTuCmZmIYmVaO3PNl4-RTzWpKcmm6ICa53xxcU_N81mzi_QM9meGrPOOH9YsCJuwPDvacSDg6-XfgHUvqelmSSHKbJBR_-A12b8WjyrFFTHzthFQp36h2Q9kovuYAwukbDTaakh6OOtpxw7zzROB4hM5k2kLRkiNRBg6zslcYytx5tXHnZzZLsZO73cSsD8mG_iRmT';
        configuration.OB_Token_4__c = 'gkR6gY0FEswxXWrbVrGdVtLxNwNctoqwWtxBiDfzJgA30byG0N6TM4IBfnt6c58VtAlqOUpsB_Qm3TbDk4SF3NtGTxOuaT-TgRyWQkt5_Dq-XatnL9W_RtNcnuOruhImP-X6zc9m6lYDQ98TArn-4ADOWpZpB8vOx6-bDrOxr-OG5uQ6V5FymfSZI5K24QXxuiofZzvPfhJzsS_4fpNkCUGPGhQCr_KTmqMMqgmzfRcErX23RRh6uFo0Hm2ohXH';
        configuration.OB_Token_5__c = 'LZTWscVQ1OZl9qDSMA9vFJle-WWxoxhfXdQeD9ePZ41werIqxkf6nZp6sAm3wwKVnSnLVVBstnAXFOTbGfzzX8LQJOrfs8R1jvoOa9ylLpPoBQwdkkR9MeE7pjMAfbebqJh2BX8Xx-MzB5CVkyxPPNchDkidvPUA8UW4EkZQWvDLElUKhAChy9J5TyYkYWvbRgrx4fDgZ5QPZ00-afJYiK1uHfR7botM4xm5hR_04R3XdCCnCicShD2XLN6doaG';
        configuration.OB_Token_6__c = 't6Gzv14CU1S-rN9zA9FCO7PDBywCWfzR2G8tzud0rUq_JnBTBCJFfDu01ki82TR78Od1dbM0iLpVcNJMMEMTFi_Csh3tdXM_yPiE07009WrFiWl29goM8VPlQxbmLmsqg-bWCNAVKZqutqMavqnRjJN2q3EkJbGfut9Ghc0OUae4wXDwbwvh3dijaaftSuaY0xuCVuqbopiPfS4_y5VSztt5gai1rpW0NSO3_D1pSA9Ikvfl1DipbN1tk529J_0';
        configuration.OB_Token_7__c = 'NXsfUdKgf3ADwJPcNPb2pVafkyfqr-R4xn44bnaIuOyG5firipGOROVColCMkwyL0nRYSf40CYG.KpiIzQP0btC54uMB-gvw8Q';

        insert configuration;

        Plc_TermId__c plcTerm = Plc_TestFactory.createTermId('55245846');
        insert plcTerm;

        Bit2Shop__Stock_Serials2__c stockSerial = Plc_TestFactory.createStockSerial2(bit2ShopWarehouse, 'Repaired');
        stockSerial.Plc_TermId__c=plcTerm.Id;
        insert stockSerial;
        
        insert new OB_Integration_Configuration__c(OB_Token_1__c = null, OB_timestamp__c = String.valueof(DateTime.now().getTime()), Name = 'DEVPOS');
    }
    
    /**
     * @author Abdoulaye & Moussa
     * @date Creation 18/12/2018
     * @version 1.0
     * @description Test of the method  run.
    */
    @isTest()
    static void runTest(){
        
        Plc_RestCalloutUtl restCallout = new Plc_RestCalloutUtl();
        Bit2Shop__Stock_Serials2__c stockSerial2 = [SELECT Id, Plc_TermId__r.Plc_TermIdCode__c FROM Bit2Shop__Stock_Serials2__c LIMIT 1];
        String termId = stockSerial2.Plc_TermId__r.Plc_TermIdCode__c;
        System.debug('TermId : ' + termId);
        
        String endpoint = 'https://intapi.nexi.it/salesforce/ms/legacy/WSict/services/sf/InformazioniMatricolaService?TERM_ID=' + termId;
        String payloadJson = '';
        String flowCode = 'SFDCtoWSI_02';
        Boolean isGet = true;
        String clientId = '46FD38FEC2B0EACE614BDB01E1E5CE63852CF826255789E7D8AD529D4E9D2102';
        String clientSecret = '86A91673E95A5E914B6FA917B8DA4969DA0217252045FD7711D791663E4D7979';

        String responseTest = '{"result": true,"data": {"termId": "55245846","codMatr": "14227WL22036417","codsia": "313302600002","ragSoc": "TRATTORIA AL GIARDINETTO DI Z","piva": "00150060317","inse": "TRATTORIA AL GIARDINETTO","ind": "VIA MATTEOTTI, 54","prov": "GO","loc": "CORMONS","cap": "34071","prefTel": "0481","numTel": "60257","storico": [{"attDate": "2004-10-29 14:40:49","codMatr": "41100192"},{"attDate": "2007-02-01 09:42:42","codMatr": "006945602453"},{"attDate": "2011-10-01 08:04:43","codMatr": "003225700149"},{"attDate": "2011-10-14 08:04:42","codMatr": "003242712319"},{"attDate": "2012-01-16 15:42:07","codMatr": "11348WL60305644"},{"attDate": "2015-10-24 08:00:46","codMatr": "14227WL22036417"}]}}';
        
        /******************** test *******************/
        String token = OB_UtilityCallingServices.checkToken();
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPoint);
        if(!isGet) {
           request.setMethod('POST');
        } else {
           request.setMethod('GET');
        }

        request.setHeader(OB_UtilityConstants.AUTH, OB_UtilityConstants.PREFIX + token);
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('MessageId', String.valueOf(Datetime.now()));//REFACTOR: must be update with Hash code creating method 
        request.setHeader('FlowCode', flowCode);
        request.setHeader('TransmissionDate', Datetime.now().format('yyyy-MM-dd-hh.mm.ss.SSS'));
        request.setHeader('CLIENT_ID', clientId);
        request.setHeader('CLIENT_SECRET', clientSecret);

        if (!isGet) request.setBody(payloadJson);

        //Datetime initTimestamp = Datetime.now();
        //String processingTime = Plc_WsUtils.addTimeValue('Init', initTimestamp.format(Plc_WsUtils.TIMESTAMP_FORMAT));
        //HttpResponse response = http.send(request);
        //Datetime endTimestamp = Datetime.now();
        /******************** test *******************/
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Plc_MockHttpResponseGenerator());
        restCallout.run(endpoint, payloadJson, flowCode, isGet, clientId, clientSecret);
        Test.stopTest();
    }

    /**
     * @author Abdoulaye & Moussa
     * @date Creation 18/12/2018
     * @version 1.0
     * @description Test of the method  run with isGet.
     */
    @isTest
    static void runIsGetTest(){
        
        Plc_RestCalloutUtl restCalloutUtl =new Plc_RestCalloutUtl();

        Test.startTest();
        restCalloutUtl.run('endPoint','payloadJson','flowCode',true,'clientId','clientSecret');
        Test.stopTest();
    }

    /*global class YourHttpCalloutMockImpl implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest req) {
            HttpResponse response = http.send(req);
            System.debug('test req '+ req);
        }
    }*/
}