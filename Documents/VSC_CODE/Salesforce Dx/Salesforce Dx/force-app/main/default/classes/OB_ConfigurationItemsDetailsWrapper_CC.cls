public without sharing class OB_ConfigurationItemsDetailsWrapper_CC {

    @auraEnabled 
    public static Map<String,object>  getWorkItemsId (String confId){
        Map<String,object> returnListUtility = new Map<String,object>();
        System.debug('CONFID: '+ confId);
        try{
           //Id approvalRequestId = [SELECT Id , processinstance.targetobjectId FROM ProcessInstanceWorkitem WHERE processinstance.targetobjectId =:confId limit 1].Id;
        ProcessInstanceWorkitem processInstanceWorkitem = [SELECT Id , processinstance.targetobjectId FROM ProcessInstanceWorkitem WHERE processinstance.targetobjectId =:confId limit 1];
        //System.debug('approvalRequestId' + approvalRequestId);
        String currentURL = OB_ContinuationController.getVFBaseURL();

       // returnListUtility.put('approvalRequestId'   , approvalRequestId);
        returnListUtility.put('approvalRequestId'   , processInstanceWorkitem.Id);
        returnListUtility.put('currentURL'          , currentURL);
        //get user profile - giovanni spinelli 21/03/2019 start
        User contextUser = null;
		String userId = UserInfo.getUserId();
		List<User> listOfUsers = [	SELECT 	Id,
											Name,
											ContactId,
											ProfileId,
											OB_CAB__c,
											Profile.Name,
											Profile.UserLicense.Name,
											Contact.Account.OB_ABI__c 
									FROM User 
									WHERE Id=: userId 
									LIMIT 1];

        //  START   micol.ferrari@accenture.com 11/04/2019 - R1F2-11 - RETRIEVE CUSTOM METADATA RECORD
        String approveRejectConfigurationApproval = System.Label.OB_ApproveRejectConfigurationApproval;
        List<OB_ConfigurationInformation__mdt> listOfConfigurationInformation = [SELECT Id,QualifiedApiName,OB_String_Value__c
                                                                                FROM OB_ConfigurationInformation__mdt 
                                                                                WHERE QualifiedApiName =: approveRejectConfigurationApproval
                                                                                LIMIT 1];
        String profilesAvailable = null;
        if (!listOfConfigurationInformation.isEmpty())
        {
            profilesAvailable = listOfConfigurationInformation.get(0).OB_String_Value__c;
        }
        //  END     micol.ferrari@accenture.com 11/04/2019 - R1F2-11 - RETRIEVE CUSTOM METADATA RECORD

		if (!listOfUsers.isEmpty()) 
		{
			contextUser = listOfUsers.get(0);

            //  START   micol.ferrari@accenture.com 11/04/2019 - R1F2-11 - RETRIEVE CUSTOM METADATA RECORD  
            if (profilesAvailable.contains(contextUser.Profile.Name))  
            {
                returnListUtility.put('showButtons', true);
            }     
            else
            {
                returnListUtility.put('showButtons', false);
            }  
            //  END     micol.ferrari@accenture.com 11/04/2019 - R1F2-11 - RETRIEVE CUSTOM METADATA RECORD
		}
        //get user profile - giovanni spinelli 21/03/2019 start
        System.debug('CURRENT URL: '+currentURL );
        System.debug('returnListUtility: '+returnListUtility ); 
        }
         catch(Exception ecc)
		{
			System.debug('Generic Error accenpt approval: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
		}
        
        return returnListUtility;
    }
    /*****************************************************************
    Purpose:  method to approve an approval request                                                        
    History                                                            
    --------                                                           
    VERSION  AUTHOR             DATE           DETAIL          Description
    1.0      ?                  Created           ?                ?
    1.1    francesca.ribezzi    06/12/19         Edit            adding textAreaMessage as parameter           
    *****************************************************************/
    //submit approval request
    @auraEnabled 
    public static String submitApprovalRequestMethod (String confId, String textAreaMessage){
        //Class used for Approving Record
        System.debug('INTO APPROVAL REQUEST');
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        Id resultApprovalRequestId ;
        req.setComments(textAreaMessage);  //francesca.ribezzi 06/12/19 - PERF-25 - setting comments
        try{
            //Approve or Reject Record
            req.setAction('Approve');
            
            //Getting Work Item Id
            ProcessInstanceWorkitem pItem = [SELECT Id ,processinstanceId, processinstance.targetobjectId FROM ProcessInstanceWorkitem WHERE processinstance.targetobjectId =:confId];

            req.setWorkitemId(pItem.Id);
            // Submit the request for approval
            Approval.ProcessResult result = Approval.process(req);

            resultApprovalRequestId = [     SELECT Id , processinstance.targetobjectId ,StepStatus 
                                            FROM ProcessInstanceStep 
                                            WHERE processinstance.targetobjectId =:confId AND StepStatus ='Approved' AND processinstanceId=:pItem.processinstanceId limit 1].Id;
            System.debug('ID RETURN '+resultApprovalRequestId );
        }
        catch(Exception ecc)
		{
			System.debug('Generic Error accenpt approval: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
		}
        
        return String.valueOf(resultApprovalRequestId) ;
    }
    //04/03/2019 giovanni spinelli - method to reject an approva request
    //10/06/2019 giovanni spinelli - align method from master
    @auraEnabled 
    public static String rejectApprovalRequestMethod (String confId , String textAreaMessage){
        System.debug('INTO REJECT APPROVAL REQUEST');
        System.debug('textAreaMessage: ' + textAreaMessage);
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        Id resultApprovalRequestId ;
        //set comments with value in text area fro front-end
        req.setComments(textAreaMessage);
        try{
            //Approve or Reject Record
            req.setAction('Reject');
            
            //Getting Work Item Id
            ProcessInstanceWorkitem pItem = [SELECT Id ,processinstanceId, processinstance.targetobjectId FROM ProcessInstanceWorkitem WHERE processinstance.targetobjectId =:confId];

            req.setWorkitemId(pItem.Id);
            // Submit the request for approval
            Approval.ProcessResult result = Approval.process(req);

            resultApprovalRequestId = [     SELECT Id , processinstance.targetobjectId ,StepStatus 
                                            FROM ProcessInstanceStep 
                                            WHERE processinstance.targetobjectId =:confId AND StepStatus ='Rejected' AND processinstanceId=:pItem.processinstanceId limit 1].Id;
            System.debug('ID RETURN '+resultApprovalRequestId );

        }
        catch(Exception ecc)
		{
			System.debug('Generic Error reject approval: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
		}
        return String.valueOf(resultApprovalRequestId) ;

    }

    /*****************************************************************
    Purpose:  RI-26 - CHECK IF CURRENT USER IS MEMBER OF THE APPROVAL QUEUE                                                          
    History                                                            
    --------                                                           
    VERSION  AUTHOR             DATE           DETAIL          Description
    1.0      gianluigi.virga    19/04/2019     Created         CSR: 
    *****************************************************************/
    @AuraEnabled
    public static boolean checkUserOwnership(String confId){
        if (String.isBlank(confId)){
            return false;
        }
        try{
            String userId = UserInfo.getUserId();
            List<NE__Order__c> listOfConfOwner = [SELECT OwnerId FROM NE__Order__c WHERE Id=: confId LIMIT 1];
            if(listOfConfOwner.isEmpty()){
                return false;
            }
            Id confOwner = listOfConfOwner.get(0).OwnerId;
            List<Group> listOfQueue = [SELECT Id
                                        FROM Group 
                                        WHERE type = 'Queue' AND Id =: confOwner
                                        LIMIT 1]; 
            if(listOfQueue.isEmpty()){
                return false;
            }
            Id queue = listOfQueue.get(0).Id;
            List<GroupMember> listOfQueueMember = [SELECT Id FROM GroupMember WHERE UserOrGroupId =: userId AND GroupId =: queue LIMIT 1];
            if(!listOfQueueMember.isEmpty()){
                return true;
            }else{
                return false;
            }
        }catch(Exception ecc){
            System.debug(LoggingLevel.ERROR, 'Exception in checkUserOwnership: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
            return false;
        }
    }
    //  END gianluigi.virga 19/04/2019 - RI-26

}