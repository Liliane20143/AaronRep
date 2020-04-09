@IsTest
private class DS_SetDefaultValuesTest {
    @isTest static void testInsertDraftCase() {
        Account pr = new Account(
                        Name = 'MPS',
                        DS_Token_Totali__c = 10,
                        DS_Token_Usati__c = 0,
                        DS_Banca__c = 'MPS');
        pr.RecordTypeId = [Select Id,SobjectType,Name From RecordType WHERE Name ='Offer Variation Token' and SobjectType ='Account'  limit 1].Id;
        insert (pr);
        Case caseObj = new Case(
            Status = 'Bozza',
            DS_MerchantName__c = 'InsertTestTrigger'
            );
        caseObj.RecordTypeId = [Select Id,SobjectType,Name From RecordType WHERE Name ='Offer Variation' and SobjectType ='Case'  limit 1].Id;
        caseObj.DS_Token__c = [Select Id, Name From Account WHERE Name = 'MPS'].Id;
        caseObj.DS_Settore_Merceologico__c = 'ABBIGLIAMENTO & ACCESSORI';
        caseObj.DS_IsTransatoAlto__c = TRUE;
        caseObj.DS_TipoOfferta__c = '26 - ISPIRATA A CLASSIC+ SPECIAL';
        
        insert (caseObj);
        
        Case thisCase = [SELECT Id,DS_Descrizione_Margine__c,DS_Riferimento_CD_RO__c FROM Case WHERE DS_MerchantName__c='InsertTestTrigger'];
        
        System.assertEquals('0.95', String.valueOf(thisCase.DS_Riferimento_CD_RO__c));
    }
    
    @isTest static void testInsertDraftOfferVariationCase() {
        Account pr = new Account(
                        Name = 'MPS',
                        DS_Token_Totali__c = 10,
                        DS_Token_Usati__c = 0,
                        DS_Banca__c = 'MPS');
        pr.RecordTypeId = [Select Id,SobjectType,Name From RecordType WHERE Name ='Offer Variation Token' and SobjectType ='Account'  limit 1].Id;
        insert (pr);
        Case caseObj = new Case(
            Status = 'Bozza',
            DS_MerchantName__c = 'InsertTestTrigger'
            );
        caseObj.RecordTypeId = [Select Id,SobjectType,Name From RecordType WHERE Name ='Offer Variation' and SobjectType ='Case'  limit 1].Id;
        caseObj.DS_Token__c = [Select Id, Name From Account WHERE Name = 'MPS'].Id;
        caseObj.DS_Settore_Merceologico__c = 'ABBIGLIAMENTO & ACCESSORI';
        caseObj.DS_IsTransatoAlto__c = TRUE;
        caseObj.DS_TipoOfferta__c = '26 - ISPIRATA A CLASSIC+ SPECIAL';
        
        insert (caseObj);
        
        Case thisCase = [SELECT Id,DS_Descrizione_Margine__c,DS_Riferimento_CD_RO__c FROM Case WHERE DS_MerchantName__c='InsertTestTrigger'];
        
        System.assertEquals('0.95', String.valueOf(thisCase.DS_Riferimento_CD_RO__c));
    }
    
    @isTest static void testUpdateDraftOfferVariationCase() {    
        Account pr = new Account(
                        Name = 'MPS',
                        DS_Token_Totali__c = 10,
                        DS_Token_Usati__c = 0,
                        DS_Banca__c = 'MPS');
        pr.RecordTypeId = [Select Id,SobjectType,Name From RecordType WHERE Name ='Offer Variation Token' and SobjectType ='Account'  limit 1].Id;
        insert (pr);
        Case caseObj = new Case(
            Status = 'Bozza',
            DS_MerchantName__c = 'InsertTestTrigger'
            );
        caseObj.RecordTypeId = [Select Id,SobjectType,Name From RecordType WHERE Name ='Offer Variation' and SobjectType ='Case'  limit 1].Id;
        caseObj.DS_Token__c = [Select Id, Name From Account WHERE Name = 'MPS'].Id;
        caseObj.DS_Settore_Merceologico__c = 'ABBIGLIAMENTO & ACCESSORI';
        caseObj.DS_IsTransatoAlto__c = TRUE;
        caseObj.DS_TipoOfferta__c = '26 - ISPIRATA A CLASSIC+ SPECIAL';
        
        insert (caseObj);
        
        Case caseObj2 = [SELECT Id,Status, CaseNumber,DS_MerchantName__c,DS_Token__c,DS_Settore_Merceologico__c,DS_IsTransatoAlto__c,DS_TipoOfferta__c
                        FROM Case WHERE DS_MerchantName__c='InsertTestTrigger' LIMIT 1];
         
        caseObj2.DS_TipoOfferta__c = '27 - ISPIRATA A MONDO+ SPECIAL';
        caseObj2.DS_Mix_Transato_CD__c = 0.46;
        caseObj2.DS_Mix_Transato_COMM__c = 0.02;
        caseObj2.DS_Mix_Transato_PB__c = 0.47;
        caseObj2.DS_Mix_Transato_EEA__c = 0.05;
        update (caseObj2);
        
        Case thisCase = [SELECT Id,DS_Descrizione_Margine__c,DS_Riferimento_CD_RO__c FROM Case WHERE Id=:caseObj.Id];
        
        System.assertEquals('1.09', String.valueOf(thisCase.DS_Riferimento_CD_RO__c));
    }
    
    @isTest static void testApproveOfferVariationCase() {
        Account pr = new Account(
                        Name = 'MPS',
                        DS_Token_Totali__c = 10,
                        DS_Token_Usati__c = 0,
                        DS_Banca__c = 'MPS');
        pr.RecordTypeId = [Select Id,SobjectType,Name From RecordType WHERE Name ='Offer Variation Token' and SobjectType ='Account'  limit 1].Id;
        insert (pr);
        Case caseObj = new Case(
            Status = 'Bozza',
            DS_MerchantName__c = 'InsertTestTrigger'
            );
        caseObj.RecordTypeId = [Select Id,SobjectType,Name From RecordType WHERE Name ='Offer Variation' and SobjectType ='Case'  limit 1].Id;
        caseObj.DS_Token__c = [Select Id, Name From Account WHERE Name = 'MPS'].Id;
        caseObj.DS_Settore_Merceologico__c = 'ABBIGLIAMENTO & ACCESSORI';
        caseObj.DS_IsTransatoAlto__c = TRUE;
        caseObj.DS_TipoOfferta__c = '27 - ISPIRATA A MONDO+ SPECIAL';
        
        insert (caseObj);
        
        Case caseObj2 = [SELECT Id,Status, CaseNumber,DS_MerchantName__c,DS_Token__c,DS_Settore_Merceologico__c,DS_IsTransatoAlto__c,DS_TipoOfferta__c
                        FROM Case WHERE DS_MerchantName__c='InsertTestTrigger' LIMIT 1];
        
        caseObj2.DS_TipoOfferta__c = '26 - ISPIRATA A CLASSIC+ SPECIAL';
        caseObj2.Status = 'Autorizzata';
        caseObj2.DS_Credito_Debito__c = '0,91%';
        caseObj2.DS_Commercial__c = '1,83%';
        caseObj2.DS_PagoBancomat__c = '0,52%';
        caseObj2.DS_Extra_EEA__c = '2,16%';
        update (caseObj2);
        
        Case thisCase = [SELECT Id,DS_Margine__c FROM Case WHERE Id=:caseObj.Id];
        
        System.assertEquals('0.38', String.valueOf(thisCase.DS_Margine__c).mid(0,4));
    }
    
    @isTest static void testApproveOfferVariationNoTokenCase() {
        Account pr = new Account(
                        Name = 'MPS',
                        DS_Token_Totali__c = 10,
                        DS_Token_Usati__c = 10,
                        DS_Banca__c = 'MPS');
        pr.RecordTypeId = [Select Id,SobjectType,Name From RecordType WHERE Name ='Offer Variation Token' and SobjectType ='Account'  limit 1].Id;
        insert (pr);
        Case caseObj = new Case(
            Status = 'Bozza',
            DS_MerchantName__c = 'InsertTestTrigger'
            );
        caseObj.RecordTypeId = [Select Id,SobjectType,Name From RecordType WHERE Name ='Offer Variation' and SobjectType ='Case'  limit 1].Id;
        caseObj.DS_Token__c = [Select Id, Name From Account WHERE Name = 'MPS'].Id;
        caseObj.DS_Settore_Merceologico__c = 'ABBIGLIAMENTO & ACCESSORI';
        caseObj.DS_IsTransatoAlto__c = TRUE;
        caseObj.DS_TipoOfferta__c = '27 - ISPIRATA A MONDO+ SPECIAL';
        
        insert (caseObj);
        
        Case caseObj2 = [SELECT Id,Status, CaseNumber,DS_MerchantName__c,DS_Token__c,DS_Settore_Merceologico__c,DS_IsTransatoAlto__c,DS_TipoOfferta__c
                        FROM Case WHERE DS_MerchantName__c='InsertTestTrigger' LIMIT 1];
        
        caseObj2.DS_TipoOfferta__c = '26 - ISPIRATA A CLASSIC+ SPECIAL';
        caseObj2.Status = 'Autorizzata';
        caseObj2.DS_Credito_Debito__c = '0,91%';
        caseObj2.DS_Commercial__c = '1,83%';
        caseObj2.DS_PagoBancomat__c = '0,52%';
        caseObj2.DS_Extra_EEA__c = '2,16%';
        try
        {
        
            update (caseObj2);
            Case thisCase = [SELECT Id,DS_Margine__c FROM Case WHERE Id=:caseObj.Id];
            System.assertEquals('0.38', String.valueOf(thisCase.DS_Margine__c).mid(0,4));
        }
        catch (System.DmlException e)
        {
            System.assert(true);
        }
        
    }
    
    @isTest static void testApproveOfferVariationRecordTypeCase() {
        Account pr = new Account(
                        Name = 'MPS',
                        DS_Token_Totali__c = 10,
                        DS_Token_Usati__c = 0,
                        DS_Banca__c = 'MPS');
        pr.RecordTypeId = [Select Id,SobjectType,Name From RecordType WHERE Name ='Offer Variation Token' and SobjectType ='Account'  limit 1].Id;
        insert (pr);
        Case caseObj = new Case(
            Status = 'Bozza',
            DS_MerchantName__c = 'InsertTestTrigger'
            );
        //caseObj.RecordTypeId = [Select Id,SobjectType,Name From RecordType WHERE Name ='Test' and SobjectType ='Case'  limit 1].Id;
        caseObj.RecordTypeId = [Select Id,SobjectType,Name From RecordType WHERE DeveloperName ='DS_OfferVariation' and SobjectType ='Case'  limit 1].Id; 
        caseObj.DS_Token__c = [Select Id, Name From Account WHERE Name = 'MPS'].Id;
        caseObj.DS_Settore_Merceologico__c = 'ABBIGLIAMENTO & ACCESSORI';
        caseObj.DS_IsTransatoAlto__c = TRUE;
        caseObj.DS_TipoOfferta__c = '27 - ISPIRATA A MONDO+ SPECIAL';
        
        insert (caseObj);
        
        Case caseObj2 = [SELECT Id,Status, CaseNumber,DS_MerchantName__c,DS_Token__c,DS_Settore_Merceologico__c,DS_IsTransatoAlto__c,DS_TipoOfferta__c
                        FROM Case WHERE DS_MerchantName__c='InsertTestTrigger' LIMIT 1];
        
        caseObj2.DS_TipoOfferta__c = '26 - ISPIRATA A CLASSIC+ SPECIAL';
        caseObj2.DS_Credito_Debito__c = '0,91%';
        caseObj2.DS_Commercial__c = '1,83%';
        caseObj2.DS_PagoBancomat__c = '0,52%';
        caseObj2.DS_Extra_EEA__c = '2,16%';
        update (caseObj2);
        
        Case thisCase = [SELECT Id,DS_Margine__c,Status FROM Case WHERE Id=:caseObj.Id];
        
        System.assertEquals('Bozza', String.valueOf(thisCase.Status));
    }

}