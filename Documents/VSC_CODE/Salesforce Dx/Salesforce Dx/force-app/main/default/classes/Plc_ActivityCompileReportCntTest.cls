/**
 * @author Mame Diarra
 * @date Creation 05/02/2019
 * @Modify 28/02/2019 by Mame Diarra
 * @version 1.0
 * @description Test of PLC ActivityCompileReportCnt.
 */
@isTest
public class Plc_ActivityCompileReportCntTest {

    @TestSetup
    static void setup(){

        Plc_TestFactory.initProcessClickPackage();
        
        Account account = Plc_TestFactory.createAccountSupplier('Name');
        insert account;
        

        
        Bit2Shop__Dealer__c parentDealer = Plc_TestFactory.createDealerParent('Parent Dealer',account,'Alias');
        insert parentDealer;

        Bit2Shop__Dealer__c childDealer = Plc_TestFactory.createDealerChild('dealer', account,'12345',parentDealer);
        childDealer.Plc_Repairer__c = true;
        insert childDealer;

        Bit2Shop__Dealer__c childDealer2 = Plc_TestFactory.createDealerChild('dealer2', account,'123456',parentDealer);
        childDealer2.Plc_Repairer__c = true;
        insert childDealer2;

        Bit2Shop__Warehouse__c bit2ShopWarehouse = Plc_TestFactory.createWarehouse('Warehouse Name','','Nexi','000001NEXI', childDealer);
        bit2ShopWarehouse.Plc_Tipology__c = 'Repaired';
        insert bit2ShopWarehouse;

        Bit2Shop__Warehouse__c bit2ShopWarehouse2 = Plc_TestFactory.createWarehouse('Warehouse2 Name','','Aspiag','0001NEXI', childDealer2);
        bit2ShopWarehouse2.Plc_Tipology__c = 'Repaired';
        insert bit2ShopWarehouse2;

        Plc_Solution__c plcSolution = Plc_TestFactory.createSolution('00541237896541230');
        insert plcSolution;

        B2WExtCat__External_Catalog__c b2WExtCatExtCatalog = Plc_TestFactory.createExtCatalog('Cat Name');
        insert b2WExtCatExtCatalog;
        
        B2WExtCat__External_Catalog_Item__c b2wExtCatExtCat = Plc_TestFactory.createExtCatalogItem('Cat Item Name',b2WExtCatExtCatalog,'Test', 'Process');
        b2wExtCatExtCat.Plc_Alias__c ='00541237896541230';    
        insert b2wExtCatExtCat;

        Bit2Shop__Product_Stock__c bit2ShopProductStock1 = Plc_TestFactory.createProductStock(b2wExtCatExtCat, bit2ShopWarehouse);
        bit2ShopProductStock1.Plc_UsableQty__c = 5;
        bit2ShopProductStock1.Plc_WithdrawnQty__c = 3; 
        insert bit2ShopProductStock1;

        Plc_TermId__c plcTermId = Plc_TestFactory.createTermId('55245846');
        insert plcTermId;
        
        Bit2Shop__Stock_Serials2__c bnit2ShopStockSerials2= Plc_TestFactory.createStockSerial2(bit2ShopWarehouse,'New');
        insert bnit2ShopStockSerials2;

        Bit2Shop__Stock_Serials2__c bnit2ShopStockSerials2B= Plc_TestFactory.createStockSerial2(bit2ShopWarehouse2,'To be verified');
        insert bnit2ShopStockSerials2B;
        
        wrts_prcgvr__Activity__c activity=new wrts_prcgvr__Activity__c(); 
        activity.wrts_prcgvr__ObjectId__c=''+bnit2ShopStockSerials2.Id;
        activity.Plc_StatusStockSerial__c=bnit2ShopStockSerials2.Bit2Shop__Status__c;
        //activity.RecordTypeId='0121j0000000EVJAA2';
        insert activity;
        
        
        Plc_SystemSettings__c plsSysSetting= new Plc_SystemSettings__c(); 
        plsSysSetting.Plc_StatusPicklistValueForSS2__c='test';
        plsSysSetting.Plc_DaysForCalculatingConsumption__c=2;
        plsSysSetting.Plc_PurchaseWarrantyMonthsDelay__c=2;
        //plsSysSetting.Plc_RTReportActivity__c='0121j0000000EVJAA2';
        insert plsSysSetting;
    }
     
   /**
    * @author Mame Diarra
    * @date Creation 05/02/2019
    * @version 1.0
    * @description Test of the method retrieveInfoStockSerial.
    */
    @isTest
    static void retrieveInfoStockSerialTest(){
        
        Bit2Shop__Stock_Serials2__c stockSerialId=[SELECT  Id FROM Bit2Shop__Stock_Serials2__c LIMIT 1];
        // Start test
        Test.startTest();
        Map<String, Object> result=Plc_ActivityCompileReportCnt.retrieveInfoStockSerial('');
        Map<String, Object> result2=Plc_ActivityCompileReportCnt.retrieveInfoStockSerial(''+stockSerialId.Id);
        // Stop test
        Test.stopTest();
    }
    
   /**
    * @author Mame Diarra
    * @date Creation 11/02/2019
    * @version 1.0
    * @description Test of the method picklistValuesStatus.
    */
    @isTest
    static void picklistValuesStatusTest(){
        System.debug('MYA '+Plc_SystemSettings__c.getInstance().Plc_StatusPicklistValueForSS2__c);
         // Start test
        Test.startTest();
        Map<String,Object> result=Plc_ActivityCompileReportCnt.picklistValuesStatus();
        // Stop test
        Test.stopTest();
    }
    
   /**
    * @author Mame Diarra
    * @date Creation 11/02/2019
    * @version 1.0
    * @description Test of the method picklistValuesTag.
    */
    @isTest
    static void picklistValuesTagTest(){
        
         // Start test
        Test.startTest();
        Map<String,Object> result=Plc_ActivityCompileReportCnt.picklistValuesTag();
        // Stop test
        Test.stopTest();
    }

   /**
    * @author Mame Diarra
    * @date Creation 11/02/2019
    * @version 1.0
    * @description Test of the method updateSS2.
    */
    @isTest
    static void updateSS2Test(){
        Bit2Shop__Stock_Serials2__c ss2 = [SELECT  Id,Bit2Shop__Status__c,Plc_Tag__c FROM Bit2Shop__Stock_Serials2__c LIMIT 1];
        String newStatus='New';
        String valueTag='';

         // Start test
        Test.startTest();
        Plc_ActivityCompileReportCnt.updateSS2(ss2,newStatus,valueTag);
        // Stop test
        Test.stopTest();
    }
    
   /**
    * @author Mame Diarra
    * @date Creation 11/02/2019
    * @version 1.0
    * @description Test of the method getCS4TagLk.
    */
    @isTest
    static void getCS4TagLkTest(){
        
        // Start test
        Test.startTest();
        String valueStatus4Tag=Plc_ActivityCompileReportCnt.getCS4TagLk();
        // Stop test
        Test.stopTest();
    }
    
   /**
    * @author Adoulaye DIOP
    * @date Creation 19/02/2019
    * @version 1.0
    * @description Test of the method updateSS2 when Bit2Shop__Stock_Serials2__c ss2, String newStatus.
    */
    @isTest
    static void updateSS2FDLTest(){
        
        // Repaired
        Bit2Shop__Stock_Serials2__c ss2 = [SELECT Id, Bit2Shop__Status__c FROM Bit2Shop__Stock_Serials2__c LIMIT 1];
        String newStatus = 'New';
        
        Test.startTest();
        Plc_ActivityCompileReportCnt.updateSS2FDL(ss2, newStatus);
        Test.stopTest();
    }
    
   /**
    * @author Moussa FOFANA
    * @date Creation 25/02/2019
    * @version 1.0
    * @description Test of the method lastActivityPClickCreated
    * @params String (Bit2Shop__Stock_Serials2__c) Id
    */
    @isTest
    static void lastActivityPClickCreatedTest(){

        Bit2Shop__Stock_Serials2__c ss2 = [SELECT Id FROM Bit2Shop__Stock_Serials2__c LIMIT 1];
        
        Test.startTest();
        Map<String, Object> response = Plc_ActivityCompileReportCnt.lastActivityPClickCreated(''+ss2.Id,'New');
        Test.stopTest();
        
        List<wrts_prcgvr__Activity__c> listActivityPCss2 = [SELECT Id,wrts_prcgvr__ObjectId__c, LastModifiedDate
        FROM wrts_prcgvr__Activity__c
        WHERE RecordTypeId = :Plc_Utils.getRecordTypeId(Plc_Constants.WRPG_Activity.RecordType_PlcReport,
                wrts_prcgvr__Activity__c.SObjectType.getDescribe().name) AND wrts_prcgvr__ObjectId__c = :ss2.Id
        ORDER BY LastModifiedDate DESC NULLS LAST];
        
        System.assertEquals(1,listActivityPCss2.size());
    }
    
   /**
    * @author Moussa FOFANA
    * @date Creation 25/02/2019
    * @version 1.0
    * @description Test of the method updateStatusSS2
    * @params List<String>
    */
    @isTest
    static void updateStatusSS2Test(){

        Bit2Shop__Stock_Serials2__c ss2 = [SELECT Id FROM Bit2Shop__Stock_Serials2__c LIMIT 1];
        String newStatusSelected='New';
        List<String> idSS2=new List<String>{ss2.Id};
        
        Test.startTest();
            Plc_ActivityCompileReportCnt.updateStatusSS2(idSS2);
        Test.stopTest();
    }

   /**
    * @author Khalidou I. Sow BA
    * @date Creation 05/04/2019
    * @version 1.0
    * @description Test of the method preCheckSerial
    * @params Bit2Shop__Stock_Serials2__c
    */
    @isTest
    static void preCheckSerialTest(){

        List<Bit2Shop__Stock_Serials2__c> ss2 = [SELECT Id FROM Bit2Shop__Stock_Serials2__c];
        
        Test.startTest();
            String returnedString = Plc_ActivityCompileReportCnt.preCheckSerial(ss2[0]);
            String returnedString2 = Plc_ActivityCompileReportCnt.preCheckSerial(ss2[1]);
        Test.stopTest();
        //System.assert(returnedString == null);
        //System.assert(returnedString2 == 'Serial must be in "To be verified" status: ID [' + ss2[1].Id + ']');

    }
}