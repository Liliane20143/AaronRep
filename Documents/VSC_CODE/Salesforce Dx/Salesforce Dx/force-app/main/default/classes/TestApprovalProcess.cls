public with sharing class TestApprovalProcess {

	@AuraEnabled
	public static void  startApprovalProcess() {

		list<user> listusers = new list<user>();
		listusers = [SELECT contact.account.ob_abi__c, contact.account.name, ob_cab__c FROM user WHERE id=: UserInfo.getUserId() LIMIT 1];
		User contextuser = !listusers.isEmpty() ? listusers.get(0) : null;

		if (contextuser!=null)
		{
            
			String rolename = contextuser.contact.account.name+' Partner Manager';
            System.debug('rolename: ' + rolename);
			map<id,user> mapapprovers = new Map<ID, user>([SELECT id FROM user WHERE ob_cab__c =: contextuser.ob_cab__c AND userrole.name =:rolename ]);
			
			system.debug(mapapprovers);

		 	NE__Order__c conf = new Ne__Order__c(NE__Description__c='test approval process');
			insert conf;

			// Create an approval request for the configuration
		    List<Approval.ProcessSubmitRequest> requests = new List<Approval.ProcessSubmitRequest>();

		    List<Id> listOfApprovers = new List<Id>();
		    listOfApprovers.addAll(mapapprovers.keySet());
		    

		    //	TEST CLONE - NOT ALLOWED INSERT
		    /*Id myId = listOfApprovers.get(0);

		    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
			req1.setComments('Prova approval process.');
		    req1.setObjectId(conf.id);

		    // Submit on behalf of a specific submitter
		    //req1.setSubmitterId(contextuser.Id); 
		    
		    // Submit the record to specific process and skip the criteria evaluation
		    req1.setProcessDefinitionNameOrId('Test_Community_Approval_2');
		    req1.setSkipEntryCriteria(true);
			
			req1.setNextApproverIds(new Id[] { myid });

			Approval.ProcessResult result = Approval.process(req1);
		    system.debug('Result: '+result);

		    Id processInstanceId = result.getInstanceId();
		    List<ProcessInstanceWorkitem> listOfWI = new List<ProcessInstanceWorkitem>();
			listOfWI = [SELECT Id, ProcessInstanceId,ActorId FROM ProcessInstanceWorkitem WHERE ProcessInstanceId =: processInstanceId];
			System.debug('PIWI: '+listOfWI);

			List<ProcessInstanceWorkitem> listOfWIToInsert 	= new List<ProcessInstanceWorkitem>();
			ProcessInstanceWorkitem currentPiwi 			= new ProcessInstanceWorkitem();
			if (!listOfWI.isEmpty() && listOfWI.size()>0 && listOfApprovers.size()>1)
			{
				ProcessInstanceWorkitem piwi = listOfWI.get(0);
				for (Id currentApprover : listOfApprovers)
				{ 
					if (currentApprover != myId)
					{
						currentPiwi = new ProcessInstanceWorkitem(ProcessInstanceId=piwi.ProcessInstanceId,ActorId=currentApprover,OriginalActorId=piwi.ActorId);
						//currentPiwi = piwi.clone(false,false,false,false);
						//currentPiwi.OriginalActorId = currentApprover;
						listOfWIToInsert.add(currentPiwi);
					}
				}
				insert listOfWIToInsert;
			}*/

			//	NOT ALLOWED DELETE
		    for (Id myid : listOfApprovers)
			{
				Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
  			    req1.setComments('Prova approval process.');
			    req1.setObjectId(conf.id);
   
			    // Submit on behalf of a specific submitter
			    //req1.setSubmitterId(contextuser.Id); 
			    
			    // Submit the record to specific process and skip the criteria evaluation
			    req1.setProcessDefinitionNameOrId('Test_Community_Approval_2');
			    req1.setSkipEntryCriteria(true);
				
				req1.setNextApproverIds(new Id[] { myid });
				requests.add(req1);
			}
		    
		    // Submit the approval request for the configuration
		    List<Approval.ProcessResult> result = Approval.process(requests);
		    system.debug('Result: '+result);


		    //	RETRIEVE PROCESS ISTANCES JUST CREATED IF MORE THAN ONE
		   	if (requests.size()>1)
		    {
		    	Id processInstanceId = null;

		    	List<Id> listOfProcessInstanceIds = new List<Id>();
	    		for (Approval.ProcessResult singleResult : result)
		    	{
		    		listOfProcessInstanceIds.add(singleResult.getInstanceId());
		    	}

		    	//	RETRIEVE PROCESSINSTANCE
		    	List<ProcessInstance> listOfProcessInstance = new List<ProcessInstance>();
		    	listOfProcessInstance = [SELECT Id,ProcessDefinitionId,Status FROM ProcessInstance WHERE Id IN: listOfProcessInstanceIds ORDER BY CreatedDate DESC];

		    	if (!listOfProcessInstance.isEmpty() && listOfProcessInstance.size()>0)
		    	{
		    		//List<Id> listOfNewWorkItemIds = new List<Id>();
		    		//for (Approval.ProcessResult singleResult : result)
			    	//{
			    	//	listOfNewWorkItemIds.add(singleResult.getNewWorkitemIds().get(0));
			    	//}
		    		processInstanceId = listOfProcessInstance.get(0).Id;

		    		Map<Id,ProcessInstance> mapOfProcessInstancetoDelete 	= new Map<Id,ProcessInstance>();
		    		List<ProcessInstanceWorkitem> listToUpdate 				= new List<ProcessInstanceWorkitem>();
					List<ProcessInstanceWorkitem> listOfWI 					= new List<ProcessInstanceWorkitem>();
					listOfWI = [SELECT Id, ProcessInstanceId FROM ProcessInstanceWorkitem WHERE ProcessInstanceId IN: listOfProcessInstance];
					//listOfWI = [SELECT Id, ProcessInstanceId FROM ProcessInstanceWorkitem WHERE Id IN: listOfNewWorkItemIds ORDER BY CreatedDate DESC];					

					if (!listOfWI.isEmpty() && listOfWI.size()>0)
					{
						//processInstanceId = listOfWI.get(0).ProcessInstanceId;
						for (ProcessInstanceWorkitem piwi : listOfWI)
						{
							piwi.ProcessInstanceId = processInstanceId;
							listToUpdate.add(piwi);
						}
						update listToUpdate;

						for (ProcessInstance proIns : listOfProcessInstance)
						{
							if (proIns.Id != processInstanceId)
							{
								//proIns.ProcessDefinitionId = '04a9E0000004O8u';
								proIns.Status = 'Pending';
								mapOfProcessInstancetoDelete.put(proIns.Id,proIns);
							}
						}
						delete mapOfProcessInstancetoDelete.values();
					}
		    	}
		    }
		}
	}
}