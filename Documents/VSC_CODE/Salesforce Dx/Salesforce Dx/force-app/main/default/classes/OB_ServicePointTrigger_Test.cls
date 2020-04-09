/**************************************************************
* Date Created       : 19/11/2018  
* Author             : Doris Tatiana
* Class name to test : OB_Service_PointTrigger
***************************************************************
*/

@isTest 
public with sharing class OB_ServicePointTrigger_Test {
	
	@isTest
	 public static void test_ServicePointTrigger() {

		NE__Service_Point__c sp1 = new NE__Service_Point__c(Name = 'name test',
															OB_Service_Point_Name__c= 'services Points test',
															OB_BypassValidation__c = false);
		insert sp1;

		NE__Service_Point__c sp2 = new NE__Service_Point__c(Name = '09qwert',
															OB_Service_Point_Name__c= 'services Points',
															OB_BypassValidation__c = false);
		sp1.Name = sp2.Name;
 		update sp1;
	 }

}