trigger DS_UseToken on Case (after update) {

    Map<ID, RecordType> caseRTMap = New Map<ID, RecordType>([Select ID, Name From RecordType Where sObjectType = 'Case']);

    for (Case obj: trigger.new){
        if(!caseRTMap.get(obj.recordTypeID).name.containsIgnoreCase('Offer Variation'))
            continue;
            
        if (obj.IsClosed && obj.Status == 'Autorizzata')
        {
            List<RecordType> productsRT = [SELECT ID From RecordType where Name = 'Offer Variation Token' AND sObjectType = 'Account' LIMIT 1];
            List<Account> l = 
                    [SELECT Id, 
                            DS_Token_Totali__c,
                            DS_Token_Usati__c
                     FROM Account
                     WHERE Id = :obj.DS_Token__c
                     AND recordTypeID = :productsRT[0].Id
                     LIMIT 1];
    
            l[0].DS_Token_Usati__c = l[0].DS_Token_Usati__c + 1;
            update (l[0]);
        }
    }

}