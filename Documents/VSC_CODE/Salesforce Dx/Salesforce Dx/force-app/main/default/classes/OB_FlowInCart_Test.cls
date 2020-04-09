@isTest
public class OB_FlowInCart_Test {

    @isTest
    static void getSiteDetailTest(){
        Test.startTest();
        String outputString = flowInCartController.getSiteDetail();
        Test.stopTest();
    }
}