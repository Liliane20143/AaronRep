global class OB_ReasonForRefusal_CC  {
    
    @AuraEnabled
    global static ProcessInstanceStep getTargetProcessStep(String processId)
    {
        try
        {
            System.debug('processId: ' + processId);
           List<ProcessInstanceStep> processInstanceStepList = [SELECT ProcessInstance.TargetObjectId, ProcessInstance.Status,ProcessInstance.TargetObject.Type
                    											FROM ProcessInstanceStep 
                    											where id =:processId];
            if(!processInstanceStepList.isEmpty()){
                return processInstanceStepList[0];
            }
            return null;
            
        }
        catch(Exception e)
        {
            System.debug('Exception in OB_SaveRejectReason at line ' + e.getLineNumber() + '. Message: ' + e.getMessage());
            return null;
        }
    }
    
    
    @AuraEnabled
    global static String saveRejectReason(String targetObjectId, String comments, String selectedReason)
    {
        //String sobjectType = targetObjectId.getSObjectType().getDescribe().getName();
        Schema.SObjectType sobjectType = Id.valueOf(targetObjectId).getSObjectType();
        String sobjectName = sobjectType.getDescribe().getName();
        System.debug('sobject name ---> '+ sobjectName);        
        
        String queryStr = ''; 
        
        // START	salvatore.pianura 18/03/2019 - R1F2 MultiPV - Rollback acquiring approval process on Order Header
        //	START	micol.ferrari 15/03/2019 - R1F2 MultiPV 7.7 - The Acquiring Approval Process has been moved from Order Header to Configuration
        if(sobjectName == 'NE__Order_Header__c'){
            queryStr += 'select OB_Rejection_Reason__c, OB_Rejection_Comments__c ' ;  
        }
        //  if(sobjectName == 'NE__Order__c'){
        //     queryStr += 'select OB_Rejection_Reason__c, OB_Rejection_Comments__c ' ;  
        // }
        //	END 	micol.ferrari 15/03/2019 - R1F2 MultiPV 7.7 - The Acquiring Approval Process has been moved from Order Header to Configuration
         // END	salvatore.pianura 18/03/2019 - R1F2 MultiPV - Rollback acquiring approval process on Order Header
        else if (sobjectName == 'OB_LogRequest__c'){
            queryStr += 'select OB_RejectReason__c ';
        }
        queryStr += 'from '+ sobjectName + ' where id = '+'\''+ targetObjectId +'\''+ ' limit 1';
        System.debug('queryStr ---> ' + queryStr);

        sObject sobjectToSave = DataBase.query(queryStr); 
           
        System.debug('sobjectToSave ---> ' + sobjectToSave);
        if(sobjectName == 'NE__Order_Header__c'){
           updateRejectRequest((NE__Order_Header__c)sobjectToSave, comments, selectedReason);
        }        
        else if (sobjectName == 'OB_LogRequest__c'){
           updateRejectRequest((OB_LogRequest__c)sobjectToSave, selectedReason);
        }
        
        return sobjectName;
    }
    
    
    private static void updateRejectRequest(OB_LogRequest__c logRequest, String selectedReason ){
        System.debug('Selected Reason: '+selectedReason);
         
        if(retrieveUserProfile() ==  'Approvatore Risk Evaluation'){ 
            //definitive reject
            selectedReason = 'Rifiuto definitivo ';            
        }
        logRequest.OB_RejectReason__c = selectedReason;       
         System.debug('selectedReason :::: '+ logRequest.OB_RejectReason__c);   
        update logRequest;
  
    }
    private static void updateRejectRequest(NE__Order_Header__c oh, String comments, String selectedReason ){
        System.debug('I am in updateRejectRequest ç_ç');	
        oh.OB_Rejection_Comments__c = comments;
        System.debug('Selected Reason: '+selectedReason);
        oh.OB_Rejection_Reason__c = selectedReason;
        update oh;
    }
    @AuraEnabled
    public static List<String> getRejectionReasonList(){
        List<String> options = new List<String>();
        // START	salvatore.pianura 18/03/2019 - R1F2 MultiPV - Rollback acquiring approval process on Order Header
        Schema.DescribeFieldResult fieldResult = NE__Order_Header__c.OB_Rejection_Reason__c.getDescribe();
        // Schema.DescribeFieldResult fieldResult = NE__Order__c.OB_Rejection_Reason__c.getDescribe();
        // END	salvatore.pianura 18/03/2019 - R1F2 MultiPV - Rollback acquiring approval process on Order Header
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: ple) {
            options.add(f.getLabel());
        }
        return options;
    }
    //	END 	micol.ferrari 15/03/2019 - R1F2 MultiPV 7.7 - The Acquiring Approval Process has been moved from Order Header to Configuration

    @AuraEnabled
    public static String retrieveUserProfile()
    {
        String profileToReturn = null;
        List<User> listOfUsers = [  SELECT Id, Profile.Name 
        FROM User 
        WHERE Id =: UserInfo.getUserId() 
        LIMIT 1];
        if (!listOfUsers.isEmpty())
        {
            profileToReturn = listOfUsers.get(0).Profile.Name;
        }

        return profileToReturn;
    }
//START gianluigi.virga 22/03/2019 - Check if the reject reason is equals to "Rifiuto definitivo"
    @AuraEnabled
    global static boolean getLogRequestRejectReason(String targetObjectId)
    {
        System.debug('$$$targetObjectId ---> '+ targetObjectId);
        Schema.SObjectType sobjectType = Id.valueOf(targetObjectId).getSObjectType();
        String sobjectName = sobjectType.getDescribe().getName();
        System.debug('$$$sobject name ---> '+ sobjectName);
        Boolean reject = false;
        try
        {
            if(sobjectName == 'OB_LogRequest__c'){
                OB_LogRequest__c request = [select OB_RejectReason__c from OB_LogRequest__c where id = : targetObjectId limit 1];
                System.debug('$$$OB_RejectReason__c ---> '+ request.OB_RejectReason__c);
                if(request != null){
                    if(request.OB_RejectReason__c == System.Label.OB_MAINTENANCE_LOGREQUEST_STATUS_DEFINITIVELY_REFUSED){
                        reject = true;
                    }
                }
            }else if(sobjectName == 'NE__Order_Header__c'){//Simone Misani 30/10/2019 PROD-15 START 
                NE__Order_Header__c request = [select OB_Rejection_Reason__c from NE__Order_Header__c where id = : targetObjectId limit 1];
                System.debug('$$$OB_RejectReason__c ---> '+ request.OB_Rejection_Reason__c);
                if(request != null){
                    if(request.OB_Rejection_Reason__c == System.Label.OB_MAINTENANCE_LOGREQUEST_STATUS_DEFINITIVELY_REFUSED){
                        reject = true;
                    }
                }

            }//Simone Misani 30/10/2019 PROD-15 END
        }
        catch(Exception e)
        {
            System.debug('$$$Exception in OB_ReasonForRefusal..getLogRequestRejectReason at line ' + e.getLineNumber() + '. Message: ' + e.getMessage());
        }
        System.debug('$$$reject in OB_ReasonForRefusal.getLogRequestRejectReason---> '+ reject);
        return reject;
    } 
//END gianluigi.virga 22/03/2019
}