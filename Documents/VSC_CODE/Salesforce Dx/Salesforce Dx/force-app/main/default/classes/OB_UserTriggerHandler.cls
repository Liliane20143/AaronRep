public class OB_UserTriggerHandler 
{
	public static void addQueueToUser(Map<Id, user> oldUserMap ,Map<Id, user> newUserMap,Boolean isUpdate){
		try
		{
			List<User> userList = [SELECT Id ,Contact.Account.OB_ABI__c,Contact.Account.RecordType.DeveloperNAme,Contact.Account.Name,profile.name,profile.UserLicense.Name,profileId FROM User WHERE  Id IN: newUserMap.keyset()];
			Map<Id, user> userMapToRemove = new Map<Id, user>();
			//START - 16.04.2019 - FixOnUserTrigger - Salvatore Pianura <salvatore.pianura@accenture.com> - Change groupMapToRemove from Map<Id,Id> to Map<String,String> to set a concatenate string in the map
			Map<String, String> groupMapToRemove = new Map<String, String>();
			//END - 16.04.2019 - FixOnUserTrigger - Salvatore Pianura <salvatore.pianura@accenture.com> - Change groupMapToRemove from Map<Id,Id> to Map<String,String> to set a concatenate string in the map
			//START - 16.04.2019 - FixOnUserTrigger - Salvatore Pianura <salvatore.pianura@accenture.com> - Get list of GroupMembers related to updated users
			List<GroupMember> groupMemberList = [	SELECT GroupId,
													Id,
													UserOrGroupId,
													Group.Name
													FROM GroupMember
													WHERE UserOrGroupId 
													IN: newUserMap.keyset()];
			//END - 16.04.2019 - FixOnUserTrigger - Salvatore Pianura <salvatore.pianura@accenture.com> - Get list of GroupMembers related to updated users
			List<Group> groupList = [SELECT Id,Name FROM Group WHERE Type = 'Queue'];
			List<GroupMember> groupMemberToInsert = new List<GroupMember>();
			List<GroupMember> groupMemberToDelete = new List<GroupMember>();
			for(User newUser : userList )
			{
				if (newUser.profile.UserLicense.Name == Label.OB_License_PartnerCommunity )
				{
					//15.04.2019 - Salvatore Pianura <salvatore.pianura@accenture.com> - Check if, after update, the profile name is changed from a nexi partner approver L1/L2/L3
					if(isUpdate && ((newUser.profile.Name!=Label.OB_NexiPartnerApproverL1 && oldUserMap.get(newUser.Id).ProfileId!=newUser.ProfileId)||
									(newUser.profile.Name!=Label.OB_NexiPartnerApproverL2 && oldUserMap.get(newUser.Id).ProfileId!=newUser.ProfileId)||
									(newUser.profile.Name!=Label.OB_NexiPartnerApproverL3 && oldUserMap.get(newUser.Id).ProfileId!=newUser.ProfileId)))
					{
						userMapToRemove.put(newUser.ID,newUser);
						/*15.04.2019 - Salvatore Pianura <salvatore.pianura@accenture.com> - 
						Check if the group name contain one of these strings. If is true, put the group in the group list when remove the group member*/
						String apprPricingGeneralQueue 	= newUser.Contact.Account.OB_ABI__c + OB_UtilityConstants.APPROVAZIONE_PRICING;
						String apprBIOGeneralQueue 		= newUser.Contact.Account.OB_ABI__c + OB_UtilityConstants.APPROVAZIONE_BIO;
						/*START - 16.04.2019 - FixOnUserTrigger - Salvatore Pianura <salvatore.pianura@accenture.com> - 
						Use a counter to concatenate with the user id and set that like key in the map, to not overwrite the map when existing two group members with the same UserOrGroupId*/
						Integer myIndex = 0;
						for (GroupMember singleGroupMember : groupMemberList)
						{
							if (singleGroupMember.Group.Name.contains(apprPricingGeneralQueue) || singleGroupMember.Group.Name.contains(apprBIOGeneralQueue) )
							{
								String indexConcat = String.valueOf(myIndex)+';'+newUser.Id;
								groupMapToRemove.put(indexConcat,singleGroupMember.Group.Id);
								myIndex++;
							}
						}
						/*END - 16.04.2019 - FixOnUserTrigger - Salvatore Pianura <salvatore.pianura@accenture.com> - 
						Use a counter to concatenate with the user id and set that like key in the map, to not overwrite the map when existing two group members with the same UserOrGroupId*/
					}
					if ((isUpdate 	&& (	newUser.profile.name == Label.OB_NexiPartnerApproverL1 ||
											newUser.profile.name == Label.OB_NexiPartnerApproverL2 ||
											newUser.profile.name == Label.OB_NexiPartnerApproverL3)
                        				&& 	oldUserMap.get(newUser.Id).ProfileId!=newUser.profileId) || 
						(!isUpdate 	&& ( 	newUser.profile.name == Label.OB_NexiPartnerApproverL1 ||
											newUser.profile.name == Label.OB_NexiPartnerApproverL2 || 
											newUser.profile.name == Label.OB_NexiPartnerApproverL3)))
						//R1F2_RP_004 21.03.2019 Z. Urban <z.urban@accenture.com> Change profiles
						//15.04.2019 - Salvatore Pianura <salvatore.pianura@accenture.com> - Remove RecodType 'Bank' filter
					{
						for (Group singleGroup : groupList)
						{
							String stringConcat;
                            // 	micol.ferrari 19/11/2018
							stringConcat = getConcatAbiApprovazione( newUser, singleGroup.Name);//R1F2_RP_004 21.03.2019 Z. Urban <z.urban@accenture.com> Add string concat method
							if (singleGroup.Name == stringConcat)
							{
								GroupMember tmpGroupMember = new GroupMember(UserOrGroupId=newUser.id , GroupId=singleGroup.id);
								groupMemberToInsert.add(tmpGroupMember);
							}
						}
					}
				}
			}
			if(userMapToRemove.size() > 0)
			{
				//START - 16.04.2019 - FixOnUserTrigger - Salvatore Pianura <salvatore.pianura@accenture.com> - Iterate the list of keys of map thot contains the ids of GroupMembers
				for (String userId : groupMapToRemove.keySet())
				{					
					for(GroupMember groupMember : groupMemberList)
					{
						if (userId.contains(groupMember.UserOrGroupId) && groupMapToRemove.get(userId).contains(groupMember.GroupId))
						{
						groupMemberToDelete.add(groupMember);

					}
				}
			}
				//giovanni spinelli 16/04/2019 delete group member linked with user - end
			}
			//START - elena.preteni 28/5/19 R1F2-90 SSO assegnazione alle code
			OB_UserTriggerHandler.dmlExecution(JSON.serialize(groupMemberToInsert),JSON.serialize(groupMemberToDelete));
			//START - elena.preteni 28/5/19 R1F2-90 SSO assegnazione alle code
		}
		catch(DmlException ecc)
		{
			System.debug('[E] OB_ExternalSourceMappingTriggerHandler.updateMerchant '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
		}
	}

     /**
     * @author Z. Urban <z.urban@accenture.com>
     * @date 21/03/2019
     * @description R1F2_RP_004 Method contact Abi and approvazione for profiles 
     * @params User newUserToQueue, String singleGroupName
     * @return String
     */
		/**
     * @author Salvatore Pianura <salvatore.pianuira@accenture.com>
     * @date 16/04/2019
     * @description Method contact Abi and approvazione for profiles V 2.0
     * @params User newUserToQueue, String singleGroupName
     * @return String
     */
    private static String getConcatAbiApprovazione( User newUserToQueue, String singleGroupName )
    {
        String concatAbiApprovazione;
        
        if ( newUserToQueue.profile.name == Label.OB_NexiPartnerApproverL1 )
        {
             concatAbiApprovazione = newUserToQueue.Contact.Account.OB_ABI__c + OB_UtilityConstants.APPROVAZIONE_PRICING;
        }
        if ( newUserToQueue.profile.name == Label.OB_NexiPartnerApproverL2 )
        {
             concatAbiApprovazione = newUserToQueue.Contact.Account.OB_ABI__c + OB_UtilityConstants.APPROVAZIONE_PRICING_L2;
        }
        if ( newUserToQueue.profile.name == Label.OB_NexiPartnerApproverL3 )
        {
           String substringGroup = (singleGroupName).substring((singleGroupName).length() - 3);
           if (substringGroup == OB_UtilityConstants.BIO)
           {
			   //15.04.2019 - Salvatore Pianura <salvatore.pianura@accenture.com> - Concatenate the right string with current ABI
               concatAbiApprovazione = newUserToQueue.Contact.Account.OB_ABI__c + OB_UtilityConstants.APPROVAZIONE_BIO;
           }
           else
           {
               concatAbiApprovazione = newUserToQueue.Contact.Account.OB_ABI__c + OB_UtilityConstants.APPROVAZIONE_PRICING_L3;
           }
        }
        return concatAbiApprovazione;
    }

		/**
     * @author Elena Preteni <elena.preteni@accenture.com>
     * @date 28/05/2019
     * @description Method to add user to queue
     * @params String jsStringInsert, String jsStringDelete
     * @return void
     */

	@future
    public static void dmlExecution(String jsStringInsert, String jsStringDelete){
        System.debug('in dmlExecution');
        List<GroupMember> toDelete = (List<GroupMember>) JSON.deserialize(jsStringDelete, List<GroupMember>.class);
        List<GroupMember> toInsert = (List<GroupMember>) JSON.deserialize(jsStringInsert, List<GroupMember>.class);
        System.debug('toDelete'+toDelete);
        System.debug('toInsert'+toInsert);

        if(toDelete.size() > 0)
		{
			delete toDelete;
		}
		if(toInsert.size() > 0)
		{
			insert toInsert;
	 	}
    }
		/**
     * @author Simone Misani <Simone.misani@accenture.com>
     * @date 19/06/2019
     * @description Method to add user with license = partner Community add in a public group for the Initial Submitters in a Approval Process. 
     * @params Map<Id, user> oldUserMap ,Map<Id, user> newUserMap,Boolean isInsert
     * @return void
     */

	
    public static void userApprovalProcess(Map<Id, user> oldUserMap ,Map<Id, user> newUserMap,Boolean isInsert){
		List<GroupMember> GMlist = new List<GroupMember>();
		List<User> userList = [	SELECT 	id,
										Name, 
										Username, 
										Profile.UserLicense.Name 
								FROM	User 
								WHERE 	Id IN: newUserMap.keyset()];
		System.debug('userList:'+userList);
		List<Group> approvlGroupList =[SELECT id,DeveloperName FROM Group WHERE DeveloperName ='OB_ApprovalPartner'];
		System.debug('approvlGroupList:'+approvlGroupList);
		if(!userList.isEmpty()){
			if(!approvlGroupList.isEmpty()){
				Group appGroup = approvlGroupList.get(0);
				for(User newUser : userList ){
					if(newUser.profile.UserLicense.Name == Label.OB_License_PartnerCommunity ){
						GroupMember GM = new GroupMember();
						GM.GroupId = appGroup.Id;
						GM.UserOrGroupId = newUser.Id;
						GMList.add(GM);      
					}
				}
			}
		}
		//Start antonio.vatrano prodob-359
		if(!GMList.isEmpty()){
			//insert GMList;
			if(!Test.isRunningTest()){
				OB_UserTriggerHandler.insertGM(JSON.serialize(GMList));
			}
		}
	}
	@future
    public static void insertGM(String jsStringInsert){
		List<GroupMember> toInsert = (List<GroupMember>) JSON.deserialize(jsStringInsert, List<GroupMember>.class);
        System.debug('@@toInsert: '+toInsert);
		insert toInsert;
	}
	//End antonio.vatrano prodob-359
}