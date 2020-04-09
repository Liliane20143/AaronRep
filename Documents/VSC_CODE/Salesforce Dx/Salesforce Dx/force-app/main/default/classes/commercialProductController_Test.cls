@isTest
public class commercialProductController_Test {

    /*******************************************************************************
    Purpose:  Setup data method
    
    History
    --------
    VERSION   AUTHOR               DATE          DETAIL     Description
    1.0       Daniele Gandini   17/06/2019    Setup method
    ********************************************************************************/
    @TestSetup 
    static void makeData(){  

        System.debug('TestSetup!');
 
        Id TerminaliRT = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByName().get('Terminali').getRecordTypeId();

        // NE__Product__c product1 = new NE__Product__c(Name = 'TestProduct');
        NE__Product__c product1 = OB_TestDataFactory.getProduct();
        product1.OB_Contract_Type__c = 'Contratto POS;Modulo Off Commercial';
        product1.OB_Codice_sfdc__c = 'codiceSfdc';
        insert product1;
        System.debug('@@@ product1: ' + product1);

        NE__Order_Header__c orderHeader1 = OB_TestDataFactory.getOrderHeader();
        orderHeader1.OB_Business_Model_Acquiring__c = 'Bancario';
        orderHeader1.OB_Business_Model_POS__c = 'Trilaterale Nuovo';
        orderHeader1.OB_Main_Process__c = OB_UtilityConstants.Setup;
        orderHeader1.OB_Sub_Process__c = OB_UtilityConstants.HEADER_SUBPROCESS_ECONOMICA ; 
        insert orderHeader1;
        System.debug('@@@ orderHeader1: ' + orderHeader1);

        NE__Order__c order1 = OB_TestDataFactory.getOrder(); 
        order1.NE__Order_Header__c = orderHeader1.Id;
        insert order1;
        System.debug('@@@ order1: ' + order1);

        NE__OrderItem__c orderItem1 = OB_TestDataFactory.getOrderItem(order1.Id);
        orderItem1.NE__Action__c = OB_UtilityConstants.ORDERITEM_ACTION_ADD;
        orderItem1.NE__ProdId__c = product1.Id;
        orderItem1.RecordTypeId = TerminaliRT;
        insert orderItem1;
        System.debug('Action: ' + JSON.serialize(orderItem1));
                
    }

    @isTest
    public static void getMapDocIdTest() {

        Test.startTest();
        commercialProductController.getMapDocId();
        Test.stopTest();
    }


    @isTest
    public static void getContractListTest() {

        // <daniele.gandini@accenture.com> - 17/06/2019 - OB_Contract_Type__c modified - start
        NE__Product__c prod1 = new NE__Product__c(Name = 'test 1',
        OB_Contract_Type__c = 'Contratto Acquiring');
        insert prod1;
         // <daniele.gandini@accenture.com> - 17/06/2019 - OB_Contract_Type__c modified - end


        List<OB_Contract__c> listaContract = new List<OB_Contract__c>();

        OB_Contract__c contract1 = new OB_Contract__c();
        contract1.OB_Typology__c = 'Offerta';
        contract1.OB_Contract_Type__c = prod1.OB_Contract_Type__c;
        contract1.OB_Template_Name__c = 'Contratto unico acquiring';
        contract1.OB_Modello_di_Business_Acquiring__c = 'Bancario';
        contract1.OB_Description_contract__c = 'description';
        contract1.OB_Modello_di_business_POS__c = 'Trilaterale Nuovo';
        contract1.OB_Order_Type__c = 'Setup';
        listaContract.add(contract1);


        OB_Contract__c contract2 = new OB_Contract__c();
        contract2.OB_Typology__c = 'Terminale';
        contract2.OB_Contract_Type__c = 'Contratto Acquiring';
        contract2.OB_Template_Name__c = 'Contratto unico acquiring';
        contract2.OB_Modello_di_Business_Acquiring__c = 'Bancario';
        contract2.OB_Description_contract__c = 'description';
        contract2.OB_Modello_di_business_POS__c = 'Trilaterale Nuovo';
        contract2.OB_Order_Type__c = 'Setup';
        listaContract.add(contract2);


        OB_Contract__c contract3 = new OB_Contract__c();
        contract3.OB_Typology__c = 'Famiglia POS';
        contract3.OB_Contract_Type__c = 'Contratto Acquiring';
        contract3.OB_Template_Name__c = 'Contratto unico acquiring';
        contract3.OB_Modello_di_Business_Acquiring__c = 'Bancario';
        contract3.OB_Description_contract__c = 'description';
        contract3.OB_Modello_di_business_POS__c = 'Trilaterale Nuovo';
        contract3.OB_Order_Type__c = 'Setup';
        listaContract.add(contract3);


        OB_Contract__c contract4 = new OB_Contract__c();
        contract4.OB_Typology__c = 'Pricing';
        contract4.OB_Contract_Type__c = 'Contratto Acquiring';
        contract4.OB_Template_Name__c = 'Contratto unico acquiring';
        contract4.OB_Modello_di_Business_Acquiring__c = 'Bancario';
        contract4.OB_Description_contract__c = 'description';
        contract4.OB_Modello_di_business_POS__c = 'Trilaterale Nuovo';
        contract4.OB_Order_Type__c = 'Setup';
        listaContract.add(contract4);


        OB_Contract__c contract5 = new OB_Contract__c();
        contract5.OB_Typology__c = 'Estensione GT NEXI';
        contract5.OB_Contract_Type__c = 'Contratto Acquiring';
        contract5.OB_Template_Name__c = 'Contratto unico acquiring';
        contract5.OB_Modello_di_Business_Acquiring__c = 'Bancario';
        contract5.OB_Description_contract__c = 'description';
        contract5.OB_Modello_di_business_POS__c = 'Trilaterale Nuovo';
        contract5.OB_Order_Type__c = 'Setup';
        listaContract.add(contract5);


        OB_Contract__c contract6 = new OB_Contract__c();
        contract6.OB_Typology__c = 'Estensione GT OTHER';
        contract6.OB_Contract_Type__c = 'Contratto Acquiring';
        contract6.OB_Template_Name__c = 'Contratto unico acquiring';
        contract6.OB_Modello_di_Business_Acquiring__c = 'Bancario';
        contract6.OB_Description_contract__c = 'description';
        contract6.OB_Modello_di_business_POS__c = 'Trilaterale Nuovo';
        contract6.OB_Order_Type__c = 'Setup';
        listaContract.add(contract6);

        insert listaContract;
        System.debug('listaContract: ' + listaContract);

        // <daniele.gandini@accenture.com> - 17/06/2019 - new data fro test calss - start

        Id orderId =  [SELECT Id FROM NE__Order__c LIMIT 1].Id;
        System.debug('Id dellordine: ' + orderId);

         List<NE__OrderItem__c> orderItems = [  SELECT  NE__ProdId__r.OB_Contract_Type__c, NE__Action__c, NE__Root_Order_Item__r.NE__ProdId__r.OB_Contract_Type__c,
                                                        NE__OrderId__r.NE__Order_Header__r.OB_Business_Model_Acquiring__c,RecordType.Name,
                                                        NE__OrderId__r.NE__Order_Header__r.OB_Business_Model_POS__c,
                                                        NE__OrderId__r.NE__Order_Header__r.OB_Main_Process__c,
                                                        NE__OrderId__r.NE__Order_Header__r.OB_Sub_Process__c,
                                                        NE__ProdId__r.Name,
                                                        NE__ProdId__r.OB_Codice_sfdc__c
                                                FROM    NE__OrderItem__c 
                                                WHERE   NE__OrderId__c =:orderId
                                                        ];
        for(NE__OrderItem__c item : orderItems)
        {
            item.NE__Action__c = 'Add';
        }
        update orderItems;

        System.debug('orderItems in setup' + JSON.serialize(orderItems));

        Map<String, String> contractsMap = new Map<String, String>();
        //contractsMap.put(contract3.OB_Template_Name__c + ' - ' + orderItems[0].NE__ProdId__r.Name + '__' + orderItems[0].NE__ProdId__r.OB_Codice_sfdc__c, contract3.id);

        Test.startTest();
        Map<String, String> mapFromMethod = commercialProductController.getContractList(orderId);
        Test.stopTest();
        System.assertEquals(contractsMap, mapFromMethod);

        // <daniele.gandini@accenture.com> - 17/06/2019 - new data fro test calss - end

        
    }
    /*
	* Author : Giovanni Spinelli
	* Date : 08/05/2019
	* Description : Test Method to coverage commercialProductController.deprecateContracts().
	*/
    @isTest
    public static void deprecateContracts_test(){
        List<String> idsList = new List<String>();
        idsList.add('test');

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
        Test.setMock(HttpCalloutMock.class, new MockMakeGetCalloutController());
        Test.startTest();
        commercialProductController.deprecateContracts('','','',idsList);
        Test.stopTest();
    }
    @isTest
    public static void executeQueryOnBankProfile_test(){
        Test.startTest();
        commercialProductController.executeQueryOnBankProfile();
        Test.stopTest();
    }

}