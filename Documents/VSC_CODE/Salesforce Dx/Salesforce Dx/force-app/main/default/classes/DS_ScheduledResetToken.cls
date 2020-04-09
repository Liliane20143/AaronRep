global class DS_ScheduledResetToken implements Schedulable {
    global void execute(SchedulableContext ctx) {
        List<RecordType> productsRT = [SELECT ID From RecordType where Name = 'Offer Variation Token' AND sObjectType = 'Account' LIMIT 1];
        List<Account> l =  [SELECT Id, 
                 DS_Token_Totali__c,
                 DS_Token_Usati__c,
                 DS_Token_per_Mese__c
             FROM Account
             WHERE recordTypeID = :productsRT[0].Id];
        
        for (Account obj: l){
            obj.DS_Token_Totali__c = obj.DS_Token_per_Mese__c;
            obj.DS_Token_Usati__c = 0;
        }
        
        for (Account obj: l){
            update obj;
        }
    }
    
}