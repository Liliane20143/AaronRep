({
	/*
	*	Author	:	Morittu Andrea
	*	Date	:	11-Oct-2019
	*	Task	:	EVO_PRODOB_450
	*	Descr	:	Component initialization
	*/
	doInit_helper : function(component, event) {
		let orderHeaderId = component.get('v.orderHeaderId');

		this.buildServicePointData(component, event, orderHeaderId);
	},

	/*
	*	Author	:	Morittu Andrea
	*	Date	:	11-Oct-2019
	*	Task	:	EVO_PRODOB_450
	*	Descr	:	retrieve service Point and Contact data
	*/
	buildServicePointData : function(component, event, orderHeaderId) {
		try {
			var action = component.get("c.getServicePointInfo_Server");
			action.setParams({ orderHeaderId : orderHeaderId });

			action.setCallback(this, function(response) {
				var state = response.getState();
				if (state === "SUCCESS") {
					if(!$A.util.isUndefinedOrNull(response.getReturnValue())) {
						let servicePointResult = response.getReturnValue()['mainServicePoint'];
							if(!$A.util.isUndefinedOrNull(servicePointResult.OB_Opening_Time__c) ) {
								servicePointResult.OB_Opening_Time__c = $A.localizationService.formatDateTimeUTC(servicePointResult.OB_Opening_Time__c, "MMMM dd yyyy, hh:mm:ss");
								let formattedTime = (servicePointResult.OB_Opening_Time__c).substring( (servicePointResult.OB_Opening_Time__c).length - 8)
								servicePointResult.OB_Opening_Time__c = formattedTime;
							}
							if(!$A.util.isUndefinedOrNull(servicePointResult.OB_Ending_Time__c)) {
								servicePointResult.OB_Ending_Time__c = $A.localizationService.formatDateTimeUTC(servicePointResult.OB_Ending_Time__c, "HH:mm");

								let formattedTime = (servicePointResult.OB_Ending_Time__c).substring( (servicePointResult.OB_Ending_Time__c).length - 8)
								servicePointResult.OB_Ending_Time__c = formattedTime;
							}
							if(!$A.util.isUndefinedOrNull(servicePointResult.OB_Break_Start_Time__c)) {
								servicePointResult.OB_Break_Start_Time__c = $A.localizationService.formatDateTimeUTC(servicePointResult.OB_Break_Start_Time__c, "HH:mm");

								let formattedTime = (servicePointResult.OB_Break_Start_Time__c).substring( (servicePointResult.OB_Break_Start_Time__c).length - 8)
								servicePointResult.OB_Break_Start_Time__c = formattedTime;
							}
							if(!$A.util.isUndefinedOrNull(servicePointResult.OB_Break_End_Time__c)) {
								servicePointResult.OB_Break_End_Time__c = $A.localizationService.formatDateTimeUTC(servicePointResult.OB_Break_End_Time__c, "HH:mm");

								let formattedTime = (servicePointResult.OB_Break_End_Time__c).substring( (servicePointResult.OB_Break_End_Time__c).length - 8)
								servicePointResult.OB_Break_End_Time__c = formattedTime;
							}
						component.set('v.servicePointResult' , servicePointResult);

						let contactList = [];
						let contactResult = new Object();
						contactResult['refPV']		= [] ;
						contactResult['respAmm']	= [] ;
						contactResult['refTec']		= [] ;
						console.log('Response is : ' + JSON.stringify(response.getReturnValue()));
						if(!$A.util.isUndefinedOrNull(response.getReturnValue()['mainServicePointReferent'])) {
							contactResult['refPV'] = response.getReturnValue()['mainServicePointReferent'];
						}
						if(!$A.util.isUndefinedOrNull(response.getReturnValue()['technicalReferent'])) {
							contactResult['respAmm'] = response.getReturnValue()['technicalReferent'];
						}
						if(!$A.util.isUndefinedOrNull(response.getReturnValue()['administrativeResponsible'])) {
							contactResult['refTec'] = response.getReturnValue()['administrativeResponsible'];
						}
						component.set('v.contactResult', contactResult);

						// component.set('v.labelObj.refPV',Referente_Punto_Vendita );
						// component.set('v.labelObj.refPV',Referente_Tecnico );
						// component.set('v.labelObj.refPV',Responsabile_Amministrativo );
					}
					this.buildTimesTable(component, event );
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
		} catch(e) {
			console.log('An error has occured inside buildServicePointData : ' + e.message);
		}
	},

	/*
	*	Author	:	Morittu Andrea
	*	Date	:	11-Oct-2019
	*	Task	:	EVO_PRODOB_450
	*	Descr	:	Show/Hide Spinner function
	*/
	showOrHideSpinner : function(component, event ) {
		let spinner = component.find('spinnerSP');
		$A.util.toggleClass(spinner, "slds-hide");
	},

	/*
	*	Author	:	Morittu Andrea
	*	Date	:	11-Oct-2019
	*	Task	:	EVO_PRODOB_450
	*	Descr	:	Create days table
	*/
	buildTimesTable : function(component, event) {
		try {
			var days= [$A.get("$Label.c.OB_Monday"),$A.get("$Label.c.OB_Tuesday"),$A.get("$Label.c.OB_Wednesday"),$A.get("$Label.c.OB_Thursday"),$A.get("$Label.c.OB_Friday"),$A.get("$Label.c.OB_Saturday"),$A.get("$Label.c.OB_Sunday")];
			var daysEn = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
			component.set("v.days", days);
		
			var listOpenMorning = [true, true, true, true, true, true, true];
			var listOpenAfternoon = [true, true, true, true, true, true, true];

			var mapIdOptionOpeningTime = {};
			debugger;
			for(var i = 0; i < days.length; i++){
				var stringI = i.toString();
				
				var todayMorning = 'v.servicePointResult.OB_Opening_' + daysEn[i] + '_Morning__c';
				var todayMorningValue = component.get(todayMorning);
				var todayAfternoon =  'v.servicePointResult.OB_Opening_' + daysEn[i] + '_Afternoon__c'; 
				var todayAfternoonValue = component.get(todayAfternoon);

				mapIdOptionOpeningTime[stringI+'m'] = 'OB_Opening_' + daysEn[i] + '_Morning__c';
				mapIdOptionOpeningTime[stringI+'p'] =  'OB_Opening_' + daysEn[i] + '_Afternoon__c';
			
				if(todayMorningValue){
					listOpenMorning[i] = true;

				}else{
					listOpenMorning[i] = false;
				}
				if(todayAfternoonValue){

					listOpenAfternoon[i] = true;

				}else{
					listOpenAfternoon[i] = false;
				}
			
				
			}
			component.set('v.listOpenMorning', listOpenMorning);
			component.set('v.listOpenAfternoon', listOpenAfternoon);
			component.set("v.mapIdOptionOpeningTime", mapIdOptionOpeningTime);
			this.showOrHideSpinner(component, event );
		} catch (e) {
			console.log('An error has occured inside buildTimesTable: ' +  e.message);
		}
	},

	/*
	*	Author	:	Morittu Andrea
	*	Date	:	11-Oct-2019
	*	Task	:	EVO_PRODOB_450
	*	Descr	:	close modal on cancel buttons
	*/
	servicePointModalAction_helper : function(component, event) {
		let whichButton = event.getSource().get('v.name');
		switch (whichButton) {
			case $A.get("$Label.c.OB_Cancel"):
				component.set('v.showServicePointModal', false);
			break; 
		}
	},
})