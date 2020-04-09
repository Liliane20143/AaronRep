/**************************************************************
* Date Created       : 12/11/2018  
* Author             : Doris Tatiana
* Class name to test : OB_OrderHeaderTrigger
***************************************************************
*/
@isTest
public class OB_OrderHeaderTrigger_Test
{

    static testmethod void test_OrderHeaderTrigger_1( )
    {

        Test.startTest( );
        //	micol.ferrari 04/11/2019 - INSERT CUSTOM SETTING FOR DISABLE TRIGGER - START
        OB_TriggerSupport__c triggerSupport = new OB_TriggerSupport__c( );
        triggerSupport.Name = 'OB_DisableTriggers';
        triggerSupport.OB_DisableAll__c = false;
        triggerSupport.OB_DisableOrderHeaderTrigger__c = false;
        insert triggerSupport;
        //	micol.ferrari 04/11/2019 - INSERT CUSTOM SETTING FOR DISABLE TRIGGER - STOP
        NE__Order_Header__c currentOrder = new NE__Order_Header__c ( );
        NE__Order_Header__c currentOrder1 = new NE__Order_Header__c ( );
        Test.stopTest( );
    }


/**************************************************************
* Date Created       : 29/10/2019  
* Author             : simone misani
* Class name  : OB_OrderHeaderTrigger_Test.test_OrderHeaderTrigger_2
***************************************************************
*/
	
	static testmethod void test_OrderHeaderTrigger_2( )
    {

        Test.startTest( );
        //	micol.ferrari 04/11/2019 - INSERT CUSTOM SETTING FOR DISABLE TRIGGER - START
        OB_TriggerSupport__c triggerSupport = new OB_TriggerSupport__c( );
        triggerSupport.Name = 'OB_DisableTriggers';
        triggerSupport.OB_DisableAll__c = false;
        triggerSupport.OB_DisableOrderHeaderTrigger__c = false; 
        insert triggerSupport;
        //	micol.ferrari 04/11/2019 - INSERT CUSTOM SETTING FOR DISABLE TRIGGER - STOP
        NE__Order_Header__c currentOrder1 = new NE__Order_Header__c ( );
		insert currentOrder1;
		update currentOrder1;
        List<NE__Order_Header__c> oh = [SELECT id FROM NE__Order_Header__c where id =:currentOrder1.id];

        Boolean orhVuoto = (oh.isEmpty());
        System.assertEquals(false, orhVuoto);
        Test.stopTest( );
    }
}