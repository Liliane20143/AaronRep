/*****************************************************************
Name: OB_ConfigOfferProductsSellingCC_Test
Purpose:  Class tests OB_ConfigOfferProductsSellingCC class

History
--------
VERSION     AUTHOR                  DATE            DETAIL          
1.0      francesca.ribezzi        17/06/2019       created            
********************************************************************************/
@isTest
public class OB_ConfigOfferProductsSellingCC_Test { 
  @testSetup
    static void setupData(){
        NE__Catalog__c catalogo = new NE__Catalog__c(Name='Catalogo_Nexi');
        insert catalogo;  
        Id RecordTypeIdProd = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get('Terminali').getRecordTypeId();
        NE__Product__c prod = new NE__Product__c( );
		prod.Name = 'prod';
        prod.RecordTypeId = RecordTypeIdProd;
		insert prod;
		NE__Catalog_Item__c catItem = new NE__Catalog_Item__c( );
        catItem.NE__Catalog_Id__c = catalogo.id;
		catItem.NE__ProductId__c = prod.id;
		insert catItem;


        NE__Bundle__c offerta  = new NE__Bundle__c(Name='Test Offerta', NE__BaseRecurringCharge__c=1, NE__RecurringChargeFrequency__c='Annual', NE__Catalog__c=catalogo.Id, NE__Start_Date__c=System.now().addDays(-1), NE__End_Date__c=System.now().addDays(1), NE__Active__c = true);
        insert offerta;
        Id RecordTypeIdMatrix= Schema.SObjectType.NE__Matrix_Parameter__c.getRecordTypeInfosByName().get('OB_PriceNexi').getRecordTypeId();
        NE__Matrix_Parameter__c matrixParameter   = new NE__Matrix_Parameter__c(NE__Active__c = true, OB_ActiveBank__c = true, NE__Start_Date__c = Date.newInstance(2018, 2, 9), OB_Offerta__c=offerta.Id, OB_ABI__c = '05116', OB_Componente__c = catItem.id, RecordTypeId = RecordTypeIdMatrix); //davide.franzini - 11/07/2019 - F2WAVE-117 - ABI and ActiveBank added
        insert matrixParameter;
        NE__Matrix_Parameter__c matrixParameter2   = new NE__Matrix_Parameter__c(NE__Active__c = true, OB_ActiveBank__c = true, NE__Start_Date__c = Date.newInstance(2018, 2, 9), OB_Offerta__c=offerta.Id, OB_ABI__c = '05116', OB_Componente__c = catItem.id);  //davide.franzini - 11/07/2019 - F2WAVE-117 - ABI and activeBank added
        insert matrixParameter2;
        //davide.franzini - 11/07/2019 - F2WAVE2-117 - START
        NE__Matrix_Parameter__c mpOffer   = new NE__Matrix_Parameter__c(NE__Active__c = true, OB_ActiveBank__c = true, NE__Start_Date__c = Date.newInstance(2018, 2, 9), OB_Offerta__c=offerta.Id, OB_ABI__c = '05116', OB_Componente__c = null, RecordTypeId = RecordTypeIdMatrix);
        insert mpOffer;
        //davide.franzini - 11/07/2019 - F2WAVE2-117 - END
        NE__Matrix_Parameter_Row__c row        = new NE__Matrix_Parameter_Row__c(NE__Matrix_Parameter__c=matrixParameter.Id, OB_ABI_BANCA__c='05116');
        insert row;
        Id RecordTypeIdRow = Schema.SObjectType.NE__Matrix_Parameter_Row__c.getRecordTypeInfosByName().get('OB_PriceNexi').getRecordTypeId();
        NE__Matrix_Parameter_Row__c row2        = new NE__Matrix_Parameter_Row__c(NE__Matrix_Parameter__c=matrixParameter.Id, OB_ABI_BANCA__c=null, RecordTypeId = RecordTypeIdRow, OB_SelfLookup__c = row.Id); 
        insert row2;
        NE__Matrix_Parameter_Row__c row3        = new NE__Matrix_Parameter_Row__c(NE__Matrix_Parameter__c=matrixParameter.Id, OB_ABI_BANCA__c=null, RecordTypeId = RecordTypeIdRow ); 
        insert row3;
    }
 @isTest
    public static void getMatrixParameterByOffer_Test() {
       List<NE__Matrix_Parameter__c> matrixParameterList = [SELECT id, OB_Offerta__c, OB_ActiveBank__c, OB_ABI__c, RecordTypeId from NE__Matrix_Parameter__c LIMIT 10]; //davide.franzini - 11/07/2019 - F2WAVE-117 - ABI and activeBank added
        NE__Bundle__c offer = [SELECT Id FROM NE__Bundle__c LIMIT 1];
        String abi = '05116'; 
        Map<String, List<NE__Matrix_Parameter__c>> matchingList = new Map<String, List<NE__Matrix_Parameter__c>>();
        matchingList.put('Terminali', matrixParameterList);
         
        Test.startTest();
           Map<String, List<NE__Matrix_Parameter__c>> recordTypeMatrixParametersMap = OB_ConfigOfferProductsSellingCC.getMatrixParameterByOffer(offer,false,abi);
           List<String> idTest = new  List<String>();
           List<String> idController = new  List<String>();
           for(NE__Matrix_Parameter__c  singleME: matchingList.get('Terminali')){
               idTest.add(singleME.Id);
           }
           if(recordTypeMatrixParametersMap.get('Terminali') != null){
                for(NE__Matrix_Parameter__c  singleMEC: recordTypeMatrixParametersMap.get('Terminali')){
                    idController.add(singleMEC.Id);
                }
           }

           
           
           //System.assertEquals(idTest, idController);
        Test.stopTest();

        
    }
    @isTest
    public static void cloneMatrixParameterServer_Test() {
        List<NE__Matrix_Parameter__c> matrixParameterList = 
        [
            SELECT id, Name,OB_ABI__c, NE__Active__c, OB_ActiveBank__c, NE__End_Date__c,
            NE__Start_Date__c,OB_ModelloAcquiring__c, OB_SchemaPrezzi__c, OB_Componente__c, OB_Componente__r.NE__Product_Name__c,
            OB_Componente__r.NE__Item_Header__c, OB_Listino__r.Name,OB_Componente__r.NE__ProductId__r.RecordType.DeveloperName,
            OB_MainMP__c,OB_Offerta__c,OB_ABIcatItemIdBundleId__c
            from NE__Matrix_Parameter__c 
            LIMIT 10];
        List<String> abiList = new List<String>();
        abiList.add('05116');
        abiList.add('03138');
        Map<String,List<String>> matrixIdAbiListmap = new Map<String,List<String>>();
        for(NE__Matrix_Parameter__c m : matrixParameterList){
            matrixIdAbiListmap.put(m.Id, abiList);
        }
        Test.startTest();
            //davide.franzini - WN-216 - 31/07/2019 - START
            String service = 'ABI';
            Boolean isOk = OB_ConfigOfferProductsSellingCC.cloneMatrixParameterServer(matrixParameterList,  matrixIdAbiListmap, service);
            //davide.franzini - WN-216 - 31/07/2019 - END
            System.assertEquals(isOk, true);
         Test.stopTest();
        
    }


  @isTest
    public static void updateActiveBankMatrixParameterRows_Test() {
        List<NE__Matrix_Parameter__c> matrixParameterList = 
        [
            SELECT id, OB_ABI__c, OB_ActiveBank__c, OB_Offerta__c 
            from NE__Matrix_Parameter__c LIMIT 10]; //davide.franzini - 11/07/2019 - F2WAVE-117 - ABI, activeBank and offer added
        Test.startTest();
            boolean isOk = OB_ConfigOfferProductsSellingCC.updateActiveBankMatrixParameterRows(matrixParameterList);
             System.assertEquals(isOk, true);
        Test.stopTest();
    }
     @isTest
    public static void updateActiveBankMatrixParameterRowsKO_Test() {
        Test.startTest();
            List<NE__Matrix_Parameter__c> mprList = new List<NE__Matrix_Parameter__c>();
            boolean isOk = OB_ConfigOfferProductsSellingCC.updateActiveBankMatrixParameterRows(mprList);
             System.assertEquals(isOk, false);
        Test.stopTest();
    }
    @isTest
    public static void searchForApexJobs_Test() {
        OB_JobStorage__c job = new OB_JobStorage__c();
        job.Name = '123123_Test';
        insert job;
       Test.startTest();
            boolean isOk = OB_ConfigOfferProductsSellingCC.searchForApexJobs();
            System.assertEquals(isOk, true);
        Test.stopTest();
    }

    //davide.franzini - 02/07/2019 - START
    @isTest
    public static void cloneMatrixParameterRowsServer_Test() {
        DateTime startDateTime =DateTime.newInstance(2017, 10, 28, 23, 59, 59);
        DateTime endDateTime = startDateTime.addDays(10);
        NE__bundle__c bundle = new NE__bundle__c(Name ='Test Name', NE__RecurringChargeFrequency__c='Monthly', NE__Start_Date__c=startDateTime, NE__End_Date__c=endDateTime );
        List<NE__bundle__c> bundleOffers = new List<NE__bundle__c>();
        bundleOffers.add(bundle);
        insert bundleOffers;
        String abi = '05116'; //davide.franzini - 11/07/2019 - F2WAVE2-117
        NE__Matrix_Parameter__c mp = new NE__Matrix_Parameter__c(
            OB_Offerta__c = bundle.Id,
            OB_ABI__c = abi
            );
        insert mp;
        NE__Matrix_Parameter_Row__c mpr = new NE__Matrix_Parameter_Row__c(
            NE__Matrix_Parameter__c = mp.Id,
            OB_ABI_BANCA__c = abi
        );
        insert mpr;
        //davide.franzini - 11/07/2019 - F2WAVE2-117 - START
        NE__Matrix_Parameter_Row__c mprChild = new NE__Matrix_Parameter_Row__c(
            NE__Matrix_Parameter__c = mp.Id,
            OB_ABI_BANCA__c = abi,
            OB_SelfLookup__c = mpr.Id
        );
        insert mprChild;
        //davide.franzini - 11/07/2019 - F2WAVE2-117 - END 
        List<Object> matrixParams = new List<Object>();
        Map<String,Object> matrixMap = new Map<String, Object>();
        matrixMap.put('Id',mp.Id);
        matrixParams.add(matrixMap);
        Map<String, Object> matrixParam = new Map<String, Object>();
        matrixParam.put('matrixParameters',matrixParams);
        List<Object> matrixParamsList = new List<Object>();
        matrixParamsList.add(matrixParam);
        String matrixParamsListString = JSON.serialize(matrixParamsList);
        Test.startTest();
        OB_ConfigOfferProductsSellingCC.cloneMatrixParameterRowsServer(matrixParamsListString);
        Test.stopTest();
    }
    //davide.franzini - 02/07/2019 - END
    //davide.franzini - 11/07/2019 - F2WAVE2-117 - START
    @isTest
    public static void deactivateOffer_Test() {
        List<NE__Bundle__c> offer = [SELECT Id FROM NE__Bundle__c WHERE Name = 'Test Offerta'];
        String offerId = offer.get(0).Id;
        Test.startTest();
        OB_ConfigOfferProductsSellingCC.deactivateOffer('05116',offerId);
        Test.stopTest();
    }
    //davide.franzini - 11/07/2019 - F2WAVE2-117 - END

}