/**
 * @author Shahid Khan
 * @date Creation 04/03/2019
 
 * @version 1.0
 * @description Test of Plc_ActivityPrintReportCnt.
 */
 @isTest
 public class Plc_ActivityPrintReportCntTest {
     
    @TestSetup
    static void setup(){
    
        Account account = Plc_TestFactory.createAccountSupplier('Name');
        insert account;
        
        wrts_prcgvr__Activity__c act = new wrts_prcgvr__Activity__c();
        
        act.Plc_Note__c = 'test not';
        act.Plc_AccessoriesRestoration__c = true;
        act.Plc_BackFlapAccessory__c = true;
        act.Plc_BaseAccessory__c = true;
        act.Plc_BaseForMobilePos__c = true;
        act.Plc_BatteryAccessory__c = true;
        act.Plc_Bluetooth__c = true;
        act.Plc_BrokenOrExhaustedBattery__c =true;
        act.Plc_CarPowerSupplyAccessory__c = true;
        act.Plc_ChipReader__c = true;
        act.Plc_ConnectionIssue__c = true;
        act.Plc_ContactlessReader__c = true;
        act.Plc_SoftwareLoss__c = true;
        act.Plc_ReleaseNotUpdatable__c = true;
        
        insert act;
    }
    @isTest
    static void activityTest(){  
    
       wrts_prcgvr__Activity__c ac = [select id,Plc_Note__c,Plc_AccessoriesRestoration__c,Plc_BackFlapAccessory__c,Plc_BaseAccessory__c,
       Plc_BaseForMobilePos__c,Plc_BatteryAccessory__c,Plc_Bluetooth__c,Plc_BrokenOrExhaustedBattery__c,Plc_CarPowerSupplyAccessory__c,
       Plc_ChipReader__c,Plc_ConnectionIssue__c,Plc_ContactlessReader__c,Plc_SoftwareLoss__c,Plc_ReleaseNotUpdatable__c From wrts_prcgvr__Activity__c limit 1];
       
       ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(ac);
       ApexPages.currentPage().getParameters().put('Id',ac.id);
       Plc_ActivityPrintReportCnt cnt = new Plc_ActivityPrintReportCnt(sc);
    
    }
  }