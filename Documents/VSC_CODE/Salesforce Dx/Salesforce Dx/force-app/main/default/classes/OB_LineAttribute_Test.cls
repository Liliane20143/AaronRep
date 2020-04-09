@isTest
public class OB_LineAttribute_Test {

    @isTest
    public static void OB_LineAttributeControllerTest(){
        NE__Order__c ord = new NE__Order__c();
        ApexPages.StandardController ctr = new ApexPages.StandardController(ord);
        Test.startTest();
        LineAttributeController lac = new LineAttributeController(ctr);
        Test.stopTest();
    }
    
    @isTest
    public static void getConfigItemAttributeTest(){
        List<NE__OrderItem__c> orderItems = new List<NE__OrderItem__c>();
        Test.startTest();
        LineAttributeController.getConfigItemAttribute(orderItems);
        Test.stopTest();
    }
}