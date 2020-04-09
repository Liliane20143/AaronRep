/**
     * @author Abdoulaye & Moussa
     * @date Creation 03/01/2019
     * @version 1.0
     * @description Test of PLC Plc_WorkOrderPrintLabelController.
     */
@isTest
public class Plc_WorkOrderPrintLabelCntTest {

    @TestSetup
    static void setup(){
                
        TriggerSettings__c setting = new TriggerSettings__c();
        setting.WorkOrderTrigger__c = System.now();
        insert setting;
        
        Plc_TestFactory.initProcessClickPackage();  
    }
    
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 07/01/2019
    * @version 1.0
    * @description Test of the constructor.
    */
    
    @isTest
    static void testConstructorOk(){

     WorkOrder wo =new WorkOrder();
        wo.Plc_Abi__c='abi';
        wo.Plc_Cti__c='cti';
        wo.Plc_FiscalCode__c='85415250';
        wo.Plc_BankDescription__c='desc';
        wo.Plc_LegacyAccountId__c='az45ed4deef';
        wo.Plc_SiaCode__c='874489'; 
        wo.Plc_LegacyServicePointId__c='a78456aadee';
        wo.Plc_ServicePoint__c='ded8c6dds';
        wo.Plc_CustomerCare__c='customerCare';          
        insert wo;
                
        ContentVersion contentVersion=new ContentVersion(
        Title='abi',
        PathOnClient='path',
        VersionData=Blob.valueOf('v1')
         );
        insert contentVersion;

        WorkOrderLineItem newWorkOrderLineItem=new WorkOrderLineItem(
        WorkOrderId=wo.Id,
        Plc_OperationType__c='NoOperation'
        );
        insert newWorkOrderLineItem;
        
        PageReference myVfPage = Page.Plc_WorkOrderPrintLabel;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('Id',wo.Id);

        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(wo);
        Plc_WorkOrderPrintLabelCnt workOrderPrintLabelController=new Plc_WorkOrderPrintLabelCnt(sc);
        Test.stopTest();        
    }
    
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 07/01/2019
    * @version 1.0
    * @description Test of the constructor with bad values.
    */
    @isTest
    static void testConstructorAndEmptyContentDoc(){
        
     WorkOrder wo =new WorkOrder();
        wo.Plc_Abi__c='abi';
        wo.Plc_Cti__c='cti';
        wo.Plc_FiscalCode__c='85415250';
        wo.Plc_BankDescription__c='desc';
        wo.Plc_LegacyAccountId__c='az45ed4deef';
        wo.Plc_SiaCode__c='874489'; 
        wo.Plc_LegacyServicePointId__c='a78456aadee';
        wo.Plc_ServicePoint__c='ded8c6dds';
        wo.Plc_CustomerCare__c='customerCare';
        insert wo;
        
        PageReference myVfPage = Page.Plc_WorkOrderPrintLabel;
        Test.setCurrentPage(myVfPage);
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('Id',wo.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(wo);
        Plc_WorkOrderPrintLabelCnt workOrderPrintLabelController=new Plc_WorkOrderPrintLabelCnt(sc);
        Test.stopTest();        
    }

}