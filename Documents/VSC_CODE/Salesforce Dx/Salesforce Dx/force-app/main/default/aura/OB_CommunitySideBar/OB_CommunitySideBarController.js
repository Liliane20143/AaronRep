({
	doInit : function(component, event, helper){
		console.log('Entrato doInit OB_Community');
		helper.getSidebarLinks(component, event, helper);
		//var playButtonCarousel = document.getElementsByClassName('slds-button slds-button_icon slds-button_icon-border-filled slds-button_icon-x-small');
		//console.log('playButtonCarousel is ' + playButtonCarousel);
		var disableAutoplay= '?autoPlay=0';
		var autoplayIsDisabled = encodeURI(disableAutoplay);
		component.set("v.disableAutoplay", autoplayIsDisabled);
		
		var x = document.getElementsByTagName("iframe");
		console.log('video is : ' + JSON.stringify(x));	
		},
	
	jsLoaded : function (component, event, helper) {
	},
	
	openModalCurrentImage : function(component,event,helper)
	{	
		var clickId 			= event.getSource().get("v.class");
		component.set("v.currentImage",clickId);
		component.set("v.showPituresModal", true);
		
		var objtLov = {};
		objtLov 	= component.get("v.objectLov");
		console.log('objtLov.NE__Value2__c is : ' + objtLov.NE__Value2__c);
	},
	closeModalCurrentImage : function(component,event,helper)
	{
		component.set("v.showPituresModal",false);
		component.set("v.currentImage","");
	}
})