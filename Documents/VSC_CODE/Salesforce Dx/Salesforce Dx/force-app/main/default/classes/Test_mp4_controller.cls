public class Test_mp4_controller {
     @AuraEnabled
    public static NE__Lov__c lovName(String name){
        NE__Lov__c testLov = new NE__Lov__c();
        testLov= [SELECT id , Name , NE__Type__c , NE__Value1__c FROM NE__Lov__c WHERE Name =: name ];
        return testLov;
    }

}