public with sharing class flowInCartController {
    
    @AuraEnabled
    public static String getSiteDetail(){
        return Site.getSiteType();
    }
    
    
}