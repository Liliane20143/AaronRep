({
	/*
    * @author elena.preteni
    * @date 22/07/2019
    * @description  doInit
    */
	doInit : function(component, event, helper){
		var orderHeaderId = component.get('v.recordId');
		console.log('orderHeaderId'+orderHeaderId);
		var action = component.get( "c.checkButtonsVisible" );
		action.setParams({"orderHeaderId" : orderHeaderId}); 
		action.setCallback(this, function(response) {
			if ( response.getState( ) === "SUCCESS" )
			{
				console.log(JSON.stringify(response.getReturnValue()));
				var responseMap = response.getReturnValue();
				console.log(responseMap['isOperation']);
				console.log(responseMap['isOperationSetup']);
				console.log(responseMap['showButtonFlow']);
				component.set("v.isOperation",responseMap['isOperation']);
				component.set("v.isOperationSetup",responseMap['isOperationSetup']);
				component.set('v.showButtonFlow',responseMap['showButtonFlow']);
				console.log(responseMap['OB_StartApprovalProcess__c']);
				console.log(responseMap['OB_In_Approvazione_a__c']);
				console.log(responseMap['OB_Rejection_Reason__c']);

				if((responseMap['OB_StartApprovalProcess__c'] == "false") && (responseMap['OB_In_Approvazione_a__c'] == "Controlli Operativi" || responseMap['OB_In_Approvazione_a__c'] == "Controlli AML" || responseMap['OB_In_Approvazione_a__c'] =="Controlli Sicurezza") && (responseMap['OB_Rejection_Reason__c'] != "Rifiuto definitivo" && !$A.util.isEmpty(responseMap['OB_Rejection_Reason__c']))) //NEXI-355 Marta Stempien <marta.stempien@accenture.com> 03/10/2019 Added isEmpty responseMap['OB_Rejection_Reason__c']
				{
					component.set("v.resubmit",true);
				} 
				helper.getHistoricWizards(component, event, helper);
			}else if(state === "ERROR"){
				console.log('Error');
			}
		});

		
		$A.enqueueAction( action );
		 
		
	},
		
	/*
    * @author elena.preteni
    * @date 22/07/2019
    * @description  Resume Flow
    */
   resumeTheFlow : function (component, event, helper)
   {
	   var orderHeaderId = component.get('v.recordId');
	   var action = component.get( "c.changeOwnerForApprovalProcess" );
	   action.setParams({"orderHeaderId" : component.get("v.recordId")}); 
	   action.setCallback(this, function(response) {
		   if ( response.getState( ) === "SUCCESS" )
		   {
			   console.log( "Owner Order was updated." );
			   var historicWizard 	= component.get("v.historicWizard");
			   console.log("historicWizard: " + JSON.stringify(historicWizard));
			   var historicWizardId = historicWizard[0].Id;
			   console.log("historicWizardId: " + historicWizardId);

			   helper.setOrderStatusToDraftIncompleteOrder( component );
		   
			   $A.createComponent(
				   "bit2flow:dynWizardMain",
				   {
					   "params": "objectType=bit2flow__Historic_Wizard_Data__c,wizardConfigurationId=,displayMenu="+false+",sourceVF="+false+",showMainToast="+false,
					   "recordId": historicWizardId
				   },
				   function(newCmp, status, errorMessage)
				   {
					   console.log("status: "+status);
					   if (status === "SUCCESS" && newCmp.isValid()) 
					   {
						   console.log()
						   var body = component.get("v.body");
						   body.push(newCmp);
						   console.log('body is: '  + body);
						   component.set("v.body", body);
					   }
					   else if (status === "INCOMPLETE")
					   {
						   this.showMessage("error",$A.get("$Label.bit2flow.b2f_State_incomplete"),false);
					   }
					   else if (status === "ERROR") 
					   {
						   this.showMessage("error","Error: " + errorMessage,false);
					   }
				   }.bind(this)     
			   );

			   component.set("v.showResumeFlow",true);
			   component.set("v.showButtonFlow",false);
			   
		   }  
	   });
	   $A.enqueueAction( action );
		
   },
   /*
    * @author elena.preteni
    * @date 22/07/2019
    * @description  approvalProcess
    */
	approvalProcess : function(component,event,helper){

		var orderHeaderId = component.get("v.recordId")
		var action = component.get("c.submitApprovalProcess");
		action.setParams({ orderHeaderId : orderHeaderId });
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				console.log("******approvalProcessStart");
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams
				({
					type: "Success",
					title: $A.get("$Label.c.OB_MAINTENANCE_TOAST_OPERATIONSUCCESSFULL"),
					message: "  ",
					mode: "dismissible"
				});
				toastEvent.fire();
				component.set("v.resubmitDisabled",true);
			}
			else 
			{
				console.log("Failed with state: " + state);
			}
		});
		$A.enqueueAction(action);
	},
})