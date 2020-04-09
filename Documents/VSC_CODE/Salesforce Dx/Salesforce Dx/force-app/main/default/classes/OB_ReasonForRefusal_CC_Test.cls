@isTest
public class OB_ReasonForRefusal_CC_Test {
    @isTest
	public static void getTargetProcessStep_Test() {

		String processId;
		
		ProcessInstanceStep process = new ProcessInstanceStep();

		OB_ReasonForRefusal_CC.getTargetProcessStep(processId);
	}

	//saveRejectReason
	@isTest
	public static void saveRejectReason_Test() { //NE__Order_Header__c
		String targetObjectId;
		String comments;
		String selectedReason;
		NE__Order_Header__c oh = new NE__Order_Header__c();
		insert oh;
		targetObjectId = String.valueOf(oh.id);

		OB_ReasonForRefusal_CC.saveRejectReason(targetObjectId, comments, selectedReason );
	}


	@isTest
	public static void saveRejectReason_Test1() { //OB_LogRequest__c
		String targetObjectId;
		String comments;
		String selectedReason;
		OB_LogRequest__c lr = new OB_LogRequest__c();
		insert lr;
		targetObjectId = String.valueOf(lr.id);

		OB_ReasonForRefusal_CC.saveRejectReason(targetObjectId, comments, selectedReason );
	}

	//getRejectionReasonList

	@isTest
	public static void getRejectionReasonList_Test() { 

		List<String> options = new List<String>();
		OB_ReasonForRefusal_CC.getRejectionReasonList();
	}

	@isTest
	public static void getLogRequestRejectReason_Test() { 
		OB_LogRequest__c request = new OB_LogRequest__c();
		request.OB_RejectReason__c = System.Label.OB_MAINTENANCE_LOGREQUEST_STATUS_DEFINITIVELY_REFUSED;
		insert request;

		OB_ReasonForRefusal_CC.getLogRequestRejectReason(request.id);
	}

}