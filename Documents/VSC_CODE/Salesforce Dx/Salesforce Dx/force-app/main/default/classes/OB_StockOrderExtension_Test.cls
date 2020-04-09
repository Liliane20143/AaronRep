@isTest
public class OB_StockOrderExtension_Test {
    @isTest 
    public static void getConfiguration1(){
        NE__Order_Header__c so = new NE__Order_Header__c();
        ApexPages.StandardController stdController  = new ApexPages.StandardController(so);
        Test.startTest();
        StockOrderExtension soe = new StockOrderExtension(stdController);
        soe.getConfiguration();
        Test.stopTest();
    }
    
     @isTest 
    public static void getConfiguration2(){
        NE__Order_Header__c so = new NE__Order_Header__c();
        insert so;
        NE__Order__c no = new NE__Order__c(NE__Order_Header__c = so.id);
        insert no;
        ApexPages.StandardController stdController  = new ApexPages.StandardController(so);
        Test.startTest();
        StockOrderExtension soe = new StockOrderExtension(stdController);
        soe.getConfiguration();
        Test.stopTest();
    }
}