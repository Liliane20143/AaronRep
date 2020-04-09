@isTest
public class OB_RunWizard_CC_Test{

	@isTest
	public static void getWizardIdFromAPINameTest(){

		bit2flow__Wizard_Definition__c wd = new bit2flow__Wizard_Definition__c();
		wd.bit2flow__Name__c = 'name';
		wd.bit2flow__Description__c = 'descr';
		wd.bit2flow__Label__c = 'label';
		insert wd;
		Attachment att = new Attachment();
		att.parentId = wd.Id;
		att.name = 'name';
		att.body = Blob.valueOf('body');
		insert att;
		Test.startTest();
		OB_RunWizard_CC.getWizardIdFromAPIName(wd.bit2flow__Name__c);
		Test.stopTest();	
	} 
}