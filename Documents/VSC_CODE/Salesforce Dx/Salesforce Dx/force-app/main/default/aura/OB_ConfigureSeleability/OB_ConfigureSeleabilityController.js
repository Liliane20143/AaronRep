({
	doInit: function(component, event, helper){
		helper.getAbiList(component, event);
		console.log("### selectedABI: "+component.get("v.selectedABI"));
	},
	
	handleAbiSelection: function (component, event, helper){
		var selectedABIList = event.getParam("value");
		console.log('### selectedABIList: '+selectedABIList);
		console.log('### activeAbiList: '+component.get("v.activeABIList"));
	},

	inheritSelectedABI: function(component,event,helper){
		/*get param from event and set in selectedABI attribute in order to send it to fra's component*/
		var data = event.getParam("data");

		if(data.type === "ABISelected"){
			console.log('### data: '+JSON.stringify(data));
			console.log('### param from appEvt:',data.items);
			console.log('### data.items: '+JSON.stringify(data.items));
			component.set("v.selectedABI",data.items);
        }
	},

	handleEnableOffer: function(component, event, helper){
		component.set("v.enableOfferClicked", true);
	},
	
	backToNexiOffers: function (component, event, helper){       
        component.set("v.renderSeleability", false);
		component.set("v.renderOffers", true);
		$A.get('e.force:refreshView').fire();      
	}

})