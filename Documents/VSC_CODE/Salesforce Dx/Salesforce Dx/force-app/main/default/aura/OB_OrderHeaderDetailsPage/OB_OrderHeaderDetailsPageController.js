({
	doInit : function(component, event, helper)
	{
        // Start AV 21/02/2019 retrieve field of configuration OB_ShowAttachedDocumentations__c to show or not to show Documents
        helper.showDocuments(component, event, helper);
        helper.checkRejectReasons(component, event, helper);
        // END AV 21/02/2019 retrieve field of configuration OB_ShowAttachedDocumentations__c to show or not to show Documents
        var singleConf; //francesca.ribezzi 18/11/19 - PROD-94 - singleConf var decl moved here 
		var labelErrorMessage = $A.get("$Label.c.OB_InsufficientPrivilegesLabel");
		var labelErrorMessageTitle =$A.get("$Label.c.OB_InsufficientprivilegesTitleLabel");
		//account UBI --> incollalo valsabbina
        var action = component.get("c.getInfo_apex");
        var recordId = component.get("v.recordId");
        action.setParams
        ({
            orderHeaderId_value : recordId
        });
        action.setCallback(this, function(response)
        {
            if (response.getState() === "SUCCESS")
            {   
                console.log('Success in helper:getInfo_helper');
                
                var responseMap = response.getReturnValue();
                component.set('v.historicWizard',responseMap);
                console.log('responseMap in helper.getInfo_helper: ' + JSON.stringify(responseMap));
                
                if(!$A.util.isEmpty(responseMap.contextAccount))
                {
                    component.set("v.contextAccount", responseMap['contextAccount'][0]);
                    console.log('contextAccount in helper.getInfo_helper: ' + JSON.stringify(responseMap['contextAccount'][0]));
                }
                
                if(!$A.util.isEmpty(responseMap.esecutore))
                {
                    component.set("v.esecutore", responseMap['esecutore'][0]);
                    console.log('esecutore in helper.getInfo_helper: ' + JSON.stringify(responseMap['esecutore'][0]));
                }   

                if(!$A.util.isEmpty(responseMap.titolariEffettivi))
                {
                    component.set("v.titolariEffettivi", responseMap['titolariEffettivi']);
                    console.log('titolariEffettivi in helper.getInfo_helper: ' + JSON.stringify(responseMap['titolariEffettivi']));
                }

                if(!$A.util.isEmpty(responseMap.configurations))
                {
                    component.set("v.configurations", responseMap['configurations']);
                    console.log('configurations in helper.getInfo_helper: ' + JSON.stringify(responseMap['configurations']));
                    console.log('configurations in helper.getInfo_helper: ' + JSON.stringify(component.get("v.configurations")));
                    singleConf = responseMap['configurations'][0];
                     //Start antonio.vatrano 29/05/2019 r1f2_160
                    if ( singleConf.NE__Order_Header__r.OB_Main_Process__c == 'Setup' &&
                        (singleConf.OB_FulfilmentStatus__c == 'Draft' ||
                        (singleConf.OB_FulfilmentStatus__c == 'Pending' &&
                        singleConf.OB_ApprovalStatus__c =='Rigettato BIO')))
                    {
                        component.set("v.canBecancelled", true);
                    }
                     //END antonio.vatrano 29/05/2019 r1f2_160
                }
                component.set("v.afterLoadParentComponent",true);

                /*START andrea.morittu 23/01/2019*/
                if(!$A.util.isEmpty(responseMap.orderHeaders))
                {
                    component.set("v.orderHeader", responseMap['orderHeaders'][0]);
                    console.log('orderHeader in helper.getInfo_helper: ' + JSON.stringify(responseMap['orderHeaders'][0]));
                    //STaRT - elena.preteni 22/07/2019 hide button 
                    console.log('orderHeader in helper.getInfo_helper operation'+responseMap['orderHeaders'][0].CreatedBy.Profile.Name);
                    if(responseMap['orderHeaders'][0].CreatedBy.Profile.Name == 'Operation'){
                        component.set("v.isOperationSetup",true);
                    }
                    //END - elena.preteni 22/07/2019 hide button 
                }

                if( $A.util.isUndefined(component.get("v.orderHeader")) || $A.util.isEmpty(component.get("v.orderHeader")) )
                {
                	component.set('v.showError', true);
                	
                	component.set("v.showTitleErrorMessage" , labelErrorMessageTitle);
                	console.log('labelErrorMessageTitle is: ' + labelErrorMessageTitle);
                	component.set("v.showErrorMessage" , labelErrorMessage);
                	console.log('----------------- label error is: ' + labelErrorMessage);
                }
                /*END andrea.morittu 23/01/2019*/

                //Start simone.misani 07/03/2019 - Condition for show button
                //START gianluigi.virga 22/07/2019 - PRODOB-86 - Add bankOrderStatus conditions in the if statement
                var bankOrderStatus = responseMap['configurations'][0].OB_Bank_OrderStatus__c;
                var orderStatusDraftRejectedPricing = $A.get("$Label.c.OB_OrderStatusDraftRejectedPricing");
                var orderStatusApprovedPricing = $A.get("$Label.c.OB_OrderStatusApprovedPricing");
                var orderStatusEconomicApproval = $A.get("$Label.c.OB_OrderStatusEconomicConditionsApproval");//francesca.ribezzi 13/11/19 - PROD-79 - adding a new condition
                //Start giovanni spinelli 01/08/2019 PRODDOB-400
                var exitFlow = !$A.util.isEmpty(component.get("v.orderHeader"))? component.get("v.orderHeader.OB_ExitFlow__c") : false; //francesca.ribezzi 13/09/19 - R1F3-48 - adding OB_ExitFlow to check whether to show or not the ResumeFlow button
                var orderStatusDraftIncompleteOrder = $A.get("$Label.c.OB_OrderStatusDraftIncompleteOrder");
                //start gianluigi virga 24/09/2019 add if condition
                var printedQuote = $A.get("$Label.c.OB_PrintedQuoteStatus"); //francesca.ribezzi 28/10/19 - if exitFlow is false --> show Resume Flow Btn  
                var isBankOrderStatusOk = (bankOrderStatus != orderStatusDraftRejectedPricing && bankOrderStatus != orderStatusApprovedPricing && bankOrderStatus != orderStatusDraftIncompleteOrder && bankOrderStatus != orderStatusEconomicApproval);
                var isCancelled = (singleConf.OB_FulfilmentStatus__c == 'Cancelled'); //francesca.ribezzi 18/11/19 - PROD-94 - check on cancelled status
                if(( !$A.util.isEmpty(responseMap.historicWizardData) && isBankOrderStatusOk && !isCancelled && !exitFlow) || bankOrderStatus == printedQuote){ //francesca.ribezzi 13/09/19 - R1F3-48 - adding OB_ExitFlow
                //end gianluigi virga 24/09/2019 add if condition
                //end giovanni spinelli 01/08/2019 PRODDOB-400
                //END gianluigi.virga 22/07/2019 - PRODOB-86
                    console.log("ifresponsce");
                    component.set('v.showButtonFlow',true);
                }
                //end simone.misani 07/03/2019 - Condition for show button
                
                //Start 	andrea.saracini 25/02/2019 - set asset attribute
                console.log('@@@@@@@@response map: '+ JSON.stringify(responseMap));
                if(!$A.util.isUndefined(responseMap.currentAsset) || !$A.util.isEmpty(responseMap.currentAsset) )
                {
                    // DG - 26/03/2019 - CONS-216 - Added asset
                    component.set("v.asset", responseMap['currentAsset'][0]);
                //Start 	SIMONE MISANI + ANDREA MORITTU 21/03/2019 FIX CONS-206
                    try
                    {
                         //Start antonio.vatrano prodob_293 26/06/2019 change condition
                        if(responseMap.currentAsset[0].NE__Order_Config__r.NE__Order_Header__r.OB_Main_Process__c == 'Maintenance' &&
                            (responseMap.currentAsset[0].NE__Order_Config__r.OB_FulfilmentStatus__c == 'Draft' || 
                            (responseMap.currentAsset[0].NE__Order_Config__r.OB_FulfilmentStatus__c == 'Pending' &&
                            responseMap.currentAsset[0].NE__Order_Config__r.OB_ApprovalStatus__c =='Rigettato BIO'))&&
                            $A.util.isUndefined(responseMap.existingLogReq))
                             //END antonio.vatrano prodob_293  26/06/2019 change condition
                        {
                            component.set("v.canBecancelled", true);
                            console.log('v.canBecancelled: '+component.get("v.canBecancelled"));    
                        }
                    }
                    catch (err)
                    {
                        console.log(err.message);
                    }
                }
                //END 	andrea.saracini 25/02/2019 - set asset attribute
                //Start antonio.vatrano perf52 13-12-2019
                if(!$A.util.isEmpty(responseMap.canBeCancelled) )
                {
                    if(responseMap.canBeCancelled[0])
                    {
                        component.set("v.canBecancelled", true);
                        console.log('v.canBecancelled: '+component.get("v.canBecancelled"));    
                    }
                }
                //Start antonio.vatrano perf52 13-12-2019
            }
            else if (response.getState() === "INCOMPLETE")
            {
                console.log('incomplete'); 
            }
            else if (response.getState() === "ERROR") 
            {
                var errors = response.getError();
                if (errors) 
                { 
                    if (errors[0] && errors[0].message) 
                    {
                        console.log("Error message: " + errors[0].message);
                    }
                }
                else 
                {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
	},

	openModal : function(component, event, helper)
	{
		component.set("v.isOpen", true);
	},

	closeModal : function(component, event, helper)
	{
		component.set("v.isOpen", false);
	},

	handleSectionToggle: function (component, event, helper) 
	{
        var openSections = event.getParam('openSections');

        if (openSections.length === 0) 
        {
            component.set("v.activeSectionsMessage", "All sections are closed");
        } 
        else 
        {
        	component.set("v.activeSectionsMessage", "Open sections: " + openSections.join(', '));
        }
    },

    accordion : function(component, event, helper)
	{
		console.log('ciao');
	},

    openActionWindow : function(component, event, helper) 
    {
        console.log('I am un opebaction');
        component.set("v.loadme", false);
        console.log('riga 91');
         var configurationId = event.getSource().get("v.name");
         component.set("v.confId", configurationId);
         console.log(configurationId + 'openaction configurationId dellevento');
         console.log(JSON.stringify(component.get("v.confId")) + ' open actionconfId settato');
         component.set("v.showConfigurationDetails", false);
         component.set("v.loadchild", true);
         console.log('eccomi');
    },

    backtopreviouspage : function(component, event, helper) 
    {
        console.log('before showConfigurationDetails '+ JSON.stringify(component.get("v.showConfigurationDetails")));
        component.set("v.showConfigurationDetails", true);
        console.log(' after showConfigurationDetails' + JSON.stringify(component.get("v.showConfigurationDetails")));


    },

    //START 	andrea.saracini 25/02/2019 - Cancell Order
    callCancelOrderController : function(component, event, helper)
	{
        component.set("v.spinner", true); 
		helper.cancelOrder(component, event, helper);
    },
    //END 	andrea.saracini 25/02/2019 - Cancell Order

    /*
    * @author simone.misani
    * @date 07/03/2019
    * @description  Resume Flow
    * @history 07/05/2019 <joanna.mielczarek@accenture.com> calls method from helper to set order statuses
    */
    resumeTheFlow : function (component, event, helper)
    {
        //GIOVANNI SPINELLI - START -  RESUME FLOW ONLY IF IS THE SAME USER OR DIFFERENT USER BUT AFTER 60 MINUTES
        var orderHeaderId = component.get('v.recordId');
        var configuration = component.get("v.configurations")[0];
        var orderId = configuration.Id;
        console.log('CONFIGURATION ID: ' + orderId);
        var actionCheckValidityFlow = component.get( "c.checkValidityFlow" );
        actionCheckValidityFlow.setParams({"orderId" : orderId});
        actionCheckValidityFlow.setCallback(this, function(response) {
            console.log('STATE IN checkValidityFlow: ' + response.getState( ));
            console.log('RESPONSE IN checkValidityFlow: ' , response.getReturnValue( ));
            if ( response.getState( ) === "SUCCESS" )
            {
                var response = response.getReturnValue( );
                var openFlow = response['openFlow'];
                var userName = response['userName'];
                if(openFlow == 'true'){
                   //FIRE WIZARD
                   helper.changeOwnerHelper(component);
                   
                }else{
                   //DONT'T FIRE WIZARD
                   helper.fireToast(component , userName);
                }
            }
            else
            {
                let errors = response.getError();
                let message = 'Unknown error';
                if (errors && Array.isArray(errors) && errors.length > 0)
                {
                    message = errors[0].message;
                }
                console.log( "Exception during resumeTheFlow: " +  message );
            }
        });
            $A.enqueueAction( actionCheckValidityFlow );
        //GIOVANNI SPINELLI - END -  RESUME FLOW ONLY IF IS THE SAME USER OR OTHER USER BUT AFTER 60 MINUTES

        
    },
    //START gianluigi.virga 17/09/2019 - UX Print quote
    resumeQuote : function (component, event, helper){
        console.log('%%%IN resumeQuote');
        Promise.all([
            helper.retrieveHistoricWizardData_Helper(component, event, helper)
        ]).then(function(response) {
            helper.setOrderStatusToDraft( component, event );
		    var alreadyClicked = component.get("v.alreadyClicked");
		    if(!alreadyClicked){
			    component.set("v.alreadyClicked", true);
			    helper.changeOrderStatus(component,event,helper);
            } 
        }).catch(
            function(error){
                console.log(error);
            }
        );
    },
    //END gianluigi.virga 17/09/2019 - UX Print quote

    /*
    *   Author  :   Morittu Andrea
    *   Date    :   11-Oct-2019
    *   Task    :   EVO_PRODOB_450
    *   Descrip :   Function of 'Detail location' button
    */
    servicePointModalAction : function(component, event, helper) {
        helper.servicePointModalAction_Helper(component, event);
    }
})