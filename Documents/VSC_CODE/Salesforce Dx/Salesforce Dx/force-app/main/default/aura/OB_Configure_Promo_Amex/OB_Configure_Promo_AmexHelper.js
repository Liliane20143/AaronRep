({
	/*
	* 	Author		:	Morittu	Andrea
	*	Date		:	05-Sept-2019
	*	Description	:	DO INIT
*/
	doInitHelper : function(component,event, helper) {
        try {
			this.buildTableScaffolding(component, event)
			.then( function(wrapperObj) {
				console.log(wrapperObj);
				helper.toggleSpinner(component, event);
			}).catch(
				function(error) {
				component.set("v.status" ,error ) ; 
				console.log(error);
			});
        } catch(e) {
            console.log('An error has occured : ' + e.message);
        }
	},

	/*
		*   Author      :   Morittu Andrea
		*   Date        :   05-Sept-2019
        *   Task        :   BACKLOG-143 
        *   Description :   Function used to retrieve data and set it into lightning data table
	*/
	buildTableScaffolding : function(component, event) {
			return new Promise(function(resolve, reject) { 
				console.log('inside buildTableScaffolding');

						var action = component.get("c.retrieveConventionCodes_Server");
				
						action.setCallback(this, function(response) {
							var state = response.getState();
							if (state === "SUCCESS") {
								let wrapperObj = response.getReturnValue();
								component.set('v.wrapperOutcome' , wrapperObj);

								var actions = [
									{ label: $A.get("$Label.c.OB_Edit"), name: $A.get("$Label.c.OB_Edit"), iconClass : 'edit_icon' , variant : 'bare',  iconName: 'utility:edit' }, 
									{ label: $A.get("$Label.c.OB_Delete"), name: $A.get("$Label.c.OB_Delete"), iconClass : 'delete_icon' ,  id : 'DELETE' , iconName: 'utility:delete' } ];


									/* ANDREA MORITTU START 14-11-2019 - BACKLOG_143 ADDING CSS FIXES */
									component.set('v.parametersColumns', [
										{ label: $A.get("$Label.c.OB_Promo_Offer_Name_Label"), fieldName: 'OB_Promo_Offer_Name_Loyalty__c', initialWidth : 240, type: 'text' },
										{ label: $A.get("$Label.c.OB_Loyalty_Code_Label"), fieldName: 'OB_LoyaltyCode__c', initialWidth : 140,  type: 'text' },
										{ label: $A.get("$Label.c.OB_Additional_Text_Label"), fieldName: 'OB_Additional_Text__c',initialWidth : 140, type: 'text' },
										{ label: $A.get("$Label.c.OB_Commission_Label"), fieldName: 'OB_Commission__c', initialWidth : 140, type: 'text' },
										{ label: $A.get("$Label.c.OB_Loyalty_Code_Label"), fieldName: 'OB_LoyaltyCode__c', type: 'text', initialWidth : 140, },
										{ label: $A.get("$Label.c.OB_Active") , fieldName: 'OB_Active__c', type: 'boolean', initialWidth : 80 },
										
										
										// { label: 'Created By', fieldName: 'CreatedBy.Name', type: 'text' },
										{ label: $A.get("$Label.c.OB_MAINTENANCE_VALIDITYSTARTDATE"), fieldName: 'OB_Start_Date__c', type: 'date' },
										{ label: $A.get("$Label.c.OB_Validity_End_Date"), fieldName: 'OB_End_Date__c', type: 'date' },
										{ type: 'action', typeAttributes: { rowActions: actions } }
									]);
									/* ANDREA MORITTU END 14-11-2019 - BACKLOG_143 ADDING CSS FIXES */
									resolve(wrapperObj);
							} else if (state === "INCOMPLETE") {
								
							}
							else if (state === "ERROR") {
								var errors = response.getError();
								if (errors) {
									reject(errors[0]);
									if (errors[0] && errors[0].message) {
										console.log("Error message: " + 
												errors[0].message);
									}
								} else {
									console.log("Unknown error");
								}
							}
						});
						$A.enqueueAction(action);
					
		});
		
	},
	
	/*
		*   Author      :   Morittu Andrea
		*   Date        :   05-Sept-2019
        *   Task        :   BACKLOG-143 
        *   Description :   Function fired on edit record. It grabs all the old values and set them into inputs
	*/
	populateInputModal : function(component, event, row, whichButton) {
		if(!$A.util.isUndefined(row)) { 
			if(whichButton == $A.get("$Label.c.OB_Edit")) {
				component.find('OB_Promo_Offer_Name_Loyalty__c').set('v.value' , row.OB_Promo_Offer_Name_Loyalty__c );
				component.find('OB_LoyaltyCode__c').set('v.value' , row.OB_LoyaltyCode__c );
				component.find('OB_Additional_Text__c').set('v.value' , row.OB_Additional_Text__c );
				component.find('OB_Commission__c').set('v.value' , row.OB_Commission__c );
				component.find('OB_Start_Date__c').set('v.value' , row.OB_Start_Date__c  );
				component.find('OB_End_Date__c').set('v.value' , row.OB_End_Date__c  );
				component.find('OB_Active__c').set('v.checked' , row.OB_Active__c == true ? 'true' : 'false' );
			} else if(whichButton == $A.get("$Label.c.OB_Delete")) {
				component.find('OB_Promo_Offer_Name_Loyalty__c').set('v.value' , row.OB_Promo_Offer_Name_Loyalty__c );
				component.find('OB_LoyaltyCode__c').set('v.value' , row.OB_LoyaltyCode__c );
				component.find('OB_Additional_Text__c').set('v.value' , row.OB_Additional_Text__c );
				component.find('OB_Commission__c').set('v.value' , row.OB_Commission__c );
				component.find('OB_Start_Date__c').set('v.value' , row.OB_Start_Date__c  );
				component.find('OB_End_Date__c').set('v.value' , row.OB_End_Date__c  );
				component.find('OB_Active__c').set('v.checked' , row.OB_Active__c == true ? 'true' : 'false' );

				component.find('OB_Promo_Offer_Name_Loyalty__c').set('v.disabled' , 'true' );
				component.find('OB_LoyaltyCode__c').set('v.disabled' , 'true' );
				component.find('OB_Additional_Text__c').set('v.disabled' , 'true');
				component.find('OB_Commission__c').set('v.disabled' , 'true' );
				component.find('OB_Start_Date__c').set('v.disabled' , 'true' );
				component.find('OB_End_Date__c').set('v.disabled' , 'true' );
				component.find('OB_Active__c').set('v.disabled' , 'true' );
			}

		} else {
			throw 'Something went wrong : Row data is Missing';
		}
		helper.toggleSpinner(component, event);
	},

	/*
		*   Author      :   Morittu Andrea
		*   Date        :   05-Sept-2019
        *   Task        :   BACKLOG-143 
        *   Description :   Check if the inputs are correct or not
	*/
	checkData : function(component, event, oldRow, whichOperation) {

		try {

			let newRow = new Object();
			if(Object.keys(oldRow).length > 0  ) {
				
				newRow.Id = oldRow.Id;
			}
				newRow.OB_Start_Date__c 				= component.find('OB_Start_Date__c').get('v.value');
				newRow.OB_Promo_Offer_Name_Loyalty__c 	= component.find('OB_Promo_Offer_Name_Loyalty__c').get('v.value');
				newRow.OB_Additional_Text__c 			= component.find('OB_Additional_Text__c').get('v.value');
				newRow.OB_Commission__c 				= component.find('OB_Commission__c').get('v.value');
				newRow.OB_LoyaltyCode__c 				= component.find('OB_LoyaltyCode__c').get('v.value');
				newRow.OB_Active__c 					= component.find('OB_Active__c').get('v.checked');
				newRow.OB_Start_Date__c 				= component.find('OB_Start_Date__c').get('v.value');
				newRow.OB_End_Date__c 					= component.find('OB_End_Date__c').get('v.value');

			var message 	= '';
			var title		= '';
			var duration	= '';
			var mode 		= '';
			var type 		= '';


			console.log('whichOperation is  : '  + whichOperation);
			if(whichOperation ==  $A.get("$Label.c.OB_Create") ) {
				let tempMapError = new Map();

				// IF THERE'S A BLANK FIELD -> ERROR
				for (const [key, value] of Object.entries(newRow)) {
					console.log('key is :' + key);
					console.log('value is: ' + value);
					if($A.util.isUndefined(value) ||  $A.util.isEmpty(value)) {
						tempMapError.set(key, value);
					}
				}

				if(tempMapError.size > 0 ) { 
					title  = 'I seguenti campi sono obbligatori : ';
					var iterator = tempMapError[Symbol.iterator]();
					let index = 1;
					for (let [key, value] of iterator) {
						message += (index++) + ') ' + key + ', ';
					}
					let duration = 60000;
					let mode = 'dismissible';
					let type = 'error';

					this.showToast(component, event, message, title, duration, mode, type);
				} else {
					this.performOperationsServer(component, event, newRow, whichOperation )
				}
			}
			else if(whichOperation == $A.get("$Label.c.OB_Edit")) {
				

				

				if( ((oldRow.OB_Promo_Offer_Name_Loyalty__c).toLowerCase() == (newRow.OB_Promo_Offer_Name_Loyalty__c).toLowerCase() ) && 
					((oldRow.OB_Additional_Text__c).toLowerCase()          == (newRow.OB_Additional_Text__c).toLowerCase() ) &&
					((oldRow.OB_Commission__c).toLowerCase()               == (newRow.OB_Commission__c).toLowerCase() ) &&  
					((oldRow.OB_LoyaltyCode__c).toLowerCase()              == (newRow.OB_LoyaltyCode__c).toLowerCase() )  &&
					(oldRow.OB_Active__c                   				   == newRow.OB_Active__c ) &&
					/* ANDREA MORITTU START 14-11-2019 - ADDING LOGIC ON BACKLOG 143 */
					(oldRow.OB_Active__c.OB_Start_Date__c 				   == newRow.OB_Start_Date__c)
					// ANDREA MORITTU 2019-11-18 -> DELETING LOGIC ON END DATE ( END DATE WON'T BE A MANDATORY INPUT) // 
					/* ANDREA MORITTU END 14-11-2019 - ADDING LOGIC ON BACKLOG 143 */
				) {
					message = $A.get("$Label.c.OB_MAINTENANCE_ERROR_NODATACHANGE");
					title;
					duration = 3000;
					mode = 'pester';
					type = 'error';

					this.showToast(component, event, message, title, duration, mode, type);
				} else {
					this.performOperationsServer(component, event, newRow, whichOperation);
				}
			} else if (whichOperation == $A.get("$Label.c.OB_Delete")) {
				this.performOperationsServer(component, event, newRow, whichOperation);
			}
		} catch (exc) {
			console.log('An error has occured : ' + exc.message);
		}
	},

	/*
		*   Author      :   Morittu Andrea
		*   Date        :   05-Sept-2019
        *   Task        :   BACKLOG-143 
        *   Description :   Show Toast Function
	*/
	showToast : function(component, event, message, title, duration, mode, type) {
		var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: title,
            message:  message,
            duration: duration,
            key: 'info_alt',
            type: type,
            mode: mode
        });
        toastEvent.fire();
	},

	/*
		*   Author      :   Morittu Andrea
		*   Date        :   05-Sept-2019
        *   Task        :   BACKLOG-143 
        *   Description :   insert / create / delete records (Centralized Function for all DML)
	*/
	performOperationsServer : function (component, event, row, whichAction) {
		console.log('performOperationsServer fired!');
		console.log('row is : ' + JSON.stringify(row));
		var action = component.get("c.performOperation_Server");
		let tempObj = {};
		tempObj.bankAbi = component.get("v.wrapperOutcome.userABI");
		tempObj.currentRecord = row;
		tempObj.actionType = whichAction;

		console.log(component.get("v.wrapperOutcome.userABI"));
		action.setParams({ tempWrapper : tempObj });

		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				let message = $A.get("$Label.c.OB_MAINTENANCE_TOAST_OPERATIONSUCCESSFULL");
				let title = '';
				let duration = 3000;
				let mode = 'pester';
				let type = 'success';
				component.set('v.showModal' , false);
				this.showToast(component, event, message, title, duration, mode, type);

				// REFRESH LIGHTNING DATA TABLE
				this.buildTableScaffolding(component, event);
				
			} else if (state === "INCOMPLETE") {
				
			}
			else if (state === "ERROR") {
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						console.log("Error message: " + 
									errors[0].message);
					}
				} else {
					console.log("Unknown error");
				}
			}
		});
		$A.enqueueAction(action);
	},

	/*
		*   Author      :   Morittu Andrea
		*   Date        :   05-Sept-2019
        *   Task        :   BACKLOG-143 
        *   Description :   Activate / Deactivate spinner
	*/
	toggleSpinner: function (component, event) {
        try {
			var spinner = component.find('spinner');
			if(component.find('spinner').get('v.class') == 'slds-hide') {
				$A.util.removeClass(spinner, 'slds-hide');
			} else {
				$A.util.addClass(spinner, 'slds-hide');
			}
    	} catch(e) {
    		console.log('Exception: ' + e.message);
    	}
	},

})