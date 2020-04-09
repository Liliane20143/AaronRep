@isTest
public with sharing class OB_ConfigurazioniTableCABController_Test {
    
    @isTest
    public static void getConfigurazioni_Test() {
        Decimal pageSize = 10;
        Decimal pageNumber = 1;
        String nameOfferta = 'offerta Test';  
        String abi = '05116';
        String cab = '11207';
        
        Id recordTypeIdOfferta = Schema.SObjectType.NE__Matrix_Parameter_Row__c.getRecordTypeInfosByName().get('OB_PriceBankCAB').getRecordTypeId();
        System.debug(recordTypeIdOfferta);
        NE__Bundle__c offerta = new NE__Bundle__c(Name = nameOfferta, NE__BaseRecurringCharge__c=10, NE__RecurringChargeFrequency__c='Annual', NE__Start_Date__c=Datetime.valueOf('2017-07-21 00:00:00'));
        List<NE__Matrix_Parameter_Row__c> rowList = new List<NE__Matrix_Parameter_Row__c> ();
        NE__Matrix_Parameter_Row__c     rowParent = new NE__Matrix_Parameter_Row__c( OB_ABI_BANCA__c = abi, OB_CAB__c=cab, RecordTypeId = recordTypeIdOfferta);
        NE__Matrix_Parameter__c   matrixParameter = new NE__Matrix_Parameter__c();
        insert offerta;
        matrixParameter.OB_Offerta__c = offerta.Id;
        insert matrixParameter;
        rowParent.NE__Matrix_Parameter__c = matrixParameter.id;
        insert rowParent;
        
        
        OB_ConfigurazioniTableCABController.getConfigurazioni(pageSize, pageNumber, nameOfferta, abi, cab);
    }
    
    @isTest
    public static void searchConfigurazioni_Test() {
        
        Decimal pageSize = 10;
        Decimal pageNumber = 1;
        String nameOfferta = 'offerta Test';  
        String abi = '05116';
        String cab = '11207';
        
        String startDate = '2017-07-21T00:00:00.000Z';
        String endDate = '2017-07-21T00:00:00.000Z'; 
                
        Id recordTypeIdOfferta = Schema.SObjectType.NE__Matrix_Parameter_Row__c.getRecordTypeInfosByName().get('OB_PriceBankCAB').getRecordTypeId();
        System.debug(recordTypeIdOfferta);
        NE__Bundle__c offerta = new NE__Bundle__c(Name = nameOfferta, NE__BaseRecurringCharge__c=10, NE__RecurringChargeFrequency__c='Annual', NE__Start_Date__c=Datetime.valueOf('2017-07-21 00:00:00'));
        List<NE__Matrix_Parameter_Row__c> rowList = new List<NE__Matrix_Parameter_Row__c> ();
        NE__Matrix_Parameter_Row__c     rowParent = new NE__Matrix_Parameter_Row__c( OB_ABI_BANCA__c = abi, OB_CAB__c=cab, RecordTypeId = recordTypeIdOfferta);
        NE__Matrix_Parameter__c   matrixParameter = new NE__Matrix_Parameter__c();
        insert offerta;
        matrixParameter.OB_Offerta__c = offerta.Id;
        insert matrixParameter;
        rowParent.NE__Matrix_Parameter__c = matrixParameter.id;
        insert rowParent;
        
        List<String> schemaPrezzi = new List<String>{'Diretto','Bilaterale'};
        List<String> modello = new List<String>{'Bancario'}; 
        
        OB_ConfigurazioniTableCABController.searchConfigurazioniServer2(pageSize, pageNumber, '', startDate, endDate, nameOfferta, '', schemaPrezzi, modello, abi, cab);
    }
    
    @isTest
    public static void creaConfigurazioneServer_Test() {
        
        Decimal pageSize = 10;
        Decimal pageNumber = 1;
        String nameOfferta = 'offerta Test';  
        String abi = '05116';
        String cab = '11207';
        
        Datetime startDate = Datetime.valueOf('2017-07-21 00:00:00');
        Datetime endDate = Datetime.valueOf('2018-07-21 00:00:00'); 
                
        Id recordTypeIdOfferta = Schema.SObjectType.NE__Matrix_Parameter_Row__c.getRecordTypeInfosByName().get('OB_PriceBankCAB').getRecordTypeId();
        System.debug(recordTypeIdOfferta);
        NE__Bundle__c offerta = new NE__Bundle__c(Name = nameOfferta, NE__BaseRecurringCharge__c=10, NE__RecurringChargeFrequency__c='Annual', NE__Start_Date__c=Datetime.valueOf('2017-07-21 00:00:00'));
        List<NE__Matrix_Parameter_Row__c> rowList = new List<NE__Matrix_Parameter_Row__c> ();
        NE__Matrix_Parameter_Row__c     rowParent = new NE__Matrix_Parameter_Row__c( OB_ABI_BANCA__c = abi, OB_CAB__c=cab, RecordTypeId = recordTypeIdOfferta);
        NE__Matrix_Parameter__c   matrixParameter = new NE__Matrix_Parameter__c();
        insert offerta;
        matrixParameter.OB_Offerta__c = offerta.Id;
        insert matrixParameter;
        rowParent.NE__Matrix_Parameter__c = matrixParameter.id;
        insert rowParent;
        
        List<String> schemaPrezzi = new List<String>{'Diretto','Bilaterale'};
        List<String> modello = new List<String>{'Bancario'}; 
         
        //OB_ConfigurazioniTableCABController.creaConfigurazioneServer(pageSize, pageNumber, '', startDate, endDate, offerta.Id, '', schemaPrezzi, modello, abi, cab);
    }
}