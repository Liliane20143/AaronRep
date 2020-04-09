/*
*   antonio.vatrano, antonio.vatrano@accenture.com
*   15/04/2019
*   test class for OB_Maintenance_Shortcut_Referents_CC
*/
@isTest
public class OB_Maintenance_Shortcut_Referents_Test {
/*
*   antonio.vatrano, antonio.vatrano@accenture.com
*   15/04/2019
*   test of method OB_Maintenance_Shortcut_Referents_CC.retrieveData(String contactId);
*/
    @isTest
    public static void retrieveDataTest(){
        OB_Maintenance_Shortcut_Referents_CC.SearchResultWrapper wrap1 = new OB_Maintenance_Shortcut_Referents_CC.SearchResultWrapper();
        wrap1.acc=null;
        wrap1.errorMessage='test';
        wrap1.listOfServicePoint= null;
        wrap1.executor= null;
        wrap1.selectedServicePoint = '';
        wrap1.selectedServicePointExt = '';
        wrap1.executorModifiedAllowed = true;
        wrap1.lovList = null;
        wrap1.outcome = '';
        wrap1.legalOffice = null;
        wrap1.selectedMerchantExt = '';
		wrap1.selectedMerchantAsset = '';
		wrap1.selectedServicePointAsset = '';
		wrap1.selectedAsset = null;
		wrap1.selectServicePointListId = null;
        //NEXI-76 Zuzanna Urban <z.urban@accenture.com> 14/06/2019 START, new logic for contacts
        NE__Service_Point__c sp = new NE__Service_Point__c();
        insert sp;
        Id rtRefPV = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Referente_Punto_Vendita').getRecordTypeId();
        Contact cont = new Contact ();
        cont.FirstName = 'Test';
        cont.LastName = 'Test';
        cont.Email = 'test@test.test';
        cont.MobilePhone = '123456789';
        cont.RecordTypeId = rtRefPV;
        cont.OB_Service_Point__c = sp.id;
        insert cont;
        System.assertNotEquals( null, OB_Maintenance_Shortcut_Referents_CC.retrieveData(cont.id));
        //NEXI-76 Zuzanna Urban <z.urban@accenture.com> 14/06/2019 STOP, new logic for contacts
    }
}