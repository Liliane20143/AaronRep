({
	fireAction_Helper : function(component, event, helper) {
		
		
		var filterString = event.getSource().get('v.value');
		console.log('filterString: ' +JSON.stringify(filterString.orderType) );
		console.log('table info:' +JSON.stringify(component.get('v.tableInformationList')) );
		var myBaseURL = component.get('v.myBaseURL');
		var url ;
		/*
		create boolen to open differnt tabs
		*/
		var openGestisciPratiche = false;
		filterString.valueStatus=='Draft - approved pricing' || filterString.valueStatus=='Draft - rejected pricing' || filterString.valueStatus=='Draft - incomplete order' ? openGestisciPratiche = true : openGestisciPratiche;

		var openConsultaPratiche = false;
		filterString.valueStatus=='Order to be completed'||filterString.valueStatus=='Missing information' || filterString.valueStatus=='Printed quote'? openConsultaPratiche = true : openConsultaPratiche; //gianluigi.virga added 'Printed quote' status to consulta pratiche
		
		var openStoricoVariazioni = false;
		filterString.valueStatus=='Rifiutato - Da risottomettere'? openStoricoVariazioni = true : openStoricoVariazioni;

		var openRichiesteDaApprovare= false;
		filterString.valueStatus=='Economic conditions approval' || filterString.valueStatus=='Bank verification' ? openRichiesteDaApprovare = true : openRichiesteDaApprovare;
		console.log('openGestisciPratiche: ' + openGestisciPratiche);
		console.log('openConsultaPratiche: ' + openConsultaPratiche);
		if(openGestisciPratiche){
			/*
			OPEN GESTISCI PRATICHE TAB
			pass 'filterString.valueStatus' because it is used in a query
			pass also the order status to check if it is maintenance or setup
			*/
			url =myBaseURL+'/s/ob-items-final-approve-status';
			window.open(url+'?filter=' + encodeURI(filterString.valueStatus) +'_'+filterString.orderType );
		}
		if(openConsultaPratiche){
			/*
			OPEN CONSULTA PRATICHE TAB
			pass 'filterString.nameStatus' because it is used to filter the report 
			*/
			url =myBaseURL+'/s/consulta-pratiche';
			window.open(url+'?filter=' + encodeURI(filterString.nameStatus));
		}
		if(openStoricoVariazioni){
			/*
			OPEN STORICO VARIAZIONI TAB
			pass 'filterString.nameStatus' because it is used to filter the report
			*/
			url =myBaseURL+'/s/ob-maintenance-requests-report-abi';
			window.open(url+'?filter=' + encodeURI(filterString.nameStatus));
			
		}
		if(openRichiesteDaApprovare){
			/*
			OPEN STORICO VARIAZIONI TAB
			pass 'filterString.valueStatus' because it is used in a query
			pass also the order status to check if it is maintenance or setup
			*/
			url =myBaseURL+'/s/ob-items-to-approve';
			window.open(url+'?filter=' + encodeURI(filterString.valueStatus) +'_'+filterString.orderType );
		}
	},
	hideToAdmin : function(component){
		
		var action = component.get("c.hideToAdmin_Apex");
		action.setCallback(this, function (response) {
			var state = response.getState();
			console.log("hide?: ", response.getReturnValue());
			if (state === "SUCCESS") {
				component.set('v.hideToAdmin', response.getReturnValue());
			} else if (state === "ERROR") {
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
	}
})