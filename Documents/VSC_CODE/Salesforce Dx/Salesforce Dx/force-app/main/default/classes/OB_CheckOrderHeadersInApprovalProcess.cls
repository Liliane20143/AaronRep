global class OB_CheckOrderHeadersInApprovalProcess implements Schedulable 
{
	global void execute(SchedulableContext sc) 
	{
		//CHECK THE ORDER HEADERS IN APPROVAL REQUEST
		List<NE__Order_Header__c> listOfOrderHeaders = [SELECT 	Id, Name, OB_In_Approvazione_a__c, OB_AcquiringApproval__c, OB_StartApprovalProcess__c 
														FROM 	NE__Order_Header__c
														WHERE 	OB_In_Approvazione_a__c 	= 'Controlli AML' 
														AND 	OB_AcquiringApproval__c 	= false
														AND 	OB_StartApprovalProcess__c 	= true];

		System.debug('OB_CheckOrdersInApprovalProcess : listOfOrderHeaders : ' + listOfOrderHeaders);

		if(listOfOrderHeaders.size()>0)
		{
			//SEND EMAIL TO ALL AML PROFILES WITH A LINK TO APPROVAL REQUEST'S REPORT
			OB_SendEmailToUsers.execute(sc);
		}
	}
}