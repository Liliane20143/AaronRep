/**
 * @author Abdoulaye & Moussa
 * @date Creation 28/01/2019
 * @version 1.0
 * @description Plc_CustomLookupCntTest test of the class Plc_CustomLookupCnt.
 */
@isTest
public class Plc_CustomLookupCntTest {
    
    @testSetup
    static void setup(){
        Account account = Plc_TestFactory.createAccountSupplier('Name');
        insert account;
    }
    
    /**
     * @author Abdoulaye & Moussa
     * @date Creation 28/01/2019
    * @Modify 14/03/2019 by Mame Diarra
     * @version 1.0
     * @description test of the method fetchLookUpValues.
     */
    @isTest
    static void fetchLookUpValuesOKTest(){
        String searchKeyWord='e';
        String objectName='Account';
        List<String> additionalFieldsToQuery= new List<String>();
        String whereCondition='Plc_Alias__c';
        Integer limitSize=2;
        Boolean searchWithSosl=true;
        Test.startTest();
            Map<String, Object> reponse=Plc_CustomLookupCnt.fetchLookUpValues(searchKeyWord,objectName,additionalFieldsToQuery,
                                                                              whereCondition,limitSize,true);
            Map<String, Object> reponse2=Plc_CustomLookupCnt.fetchLookUpValues(searchKeyWord,objectName,additionalFieldsToQuery,
                                                                              whereCondition,limitSize,false);
        Test.stopTest();
    }
    
    /**
     * @author Abdoulaye & Moussa
     * @date Creation 29/01/2019
     * @version 1.0
     * @description test of the method fetchLookUpValues.
     */
    @isTest
    static void fetchLookUpValuesKOTest(){
        String searchKeyWord='test';
        String objectName='test';
        List<String> additionalFieldsToQuery= new List<String>();
        String whereCondition='test';
        Integer limitSize=2;
        Boolean searchWithSosl=true;
        Test.startTest();
            Map<String, Object> reponse=Plc_CustomLookupCnt.fetchLookUpValues(searchKeyWord,objectName,additionalFieldsToQuery,
                                                                              whereCondition,limitSize,true);
        Test.stopTest();
    }
    
    /**
     * @author Abdoulaye & Moussa
     * @date Creation 28/01/2019
     * @version 1.0
     * @description test of the method getRecordById.
     */
    @isTest
    static void getRecordByIdOKTest(){
        Id recordId=([SELECT Id FROM Account LIMIT 1]).Id;
        String objectName='Account';
        List<String> additionalFieldsToQuery= new List<String>();
        Test.startTest();
            Map<String, Object> reponse=Plc_CustomLookupCnt.getRecordById(recordId,objectName,additionalFieldsToQuery);
        Test.stopTest();
    }

    /**
     * @author Abdoulaye & Moussa
     * @date Creation 29/01/2019
     * @version 1.0
     * @description test execption of the method getRecordById.
     */
    @isTest
    static void getRecordByIdKOTest(){
        Id recordId=([SELECT Id FROM Account LIMIT 1]).Id;
        String objectName='test';
        List<String> additionalFieldsToQuery= new List<String>();
        Test.startTest();
            Map<String, Object> reponse=Plc_CustomLookupCnt.getRecordById(recordId,objectName,additionalFieldsToQuery);
        Test.stopTest();
    }
}