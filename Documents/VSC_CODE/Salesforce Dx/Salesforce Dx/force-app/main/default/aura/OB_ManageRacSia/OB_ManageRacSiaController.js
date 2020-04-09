({
    
    /*------------------------------------------------------------
    Author:         Andrea Saracini
    Company:        Accenture Tecnology
    Description:    Call helper functions
    Inputs:         component, event, helper
    History:
    <Date>          <Authors Name>      <Brief Description of Change>
    2019-03-13      Andrea Saracini     Creator
    ------------------------------------------------------------*/
    doInit: function (component, event, helper) {
        component.set("v.siaIsValid", false);
        //D.F. _ 18-03-2019 _ ManageRacSia v4 _ START
        var mntn = component.get("v.isMaintenance");
        if(mntn){
            helper.checkSiaCodeByIban(component, event);
        }
        //D.F. _ END
        
    },
    onChangeAttributeValueTerminal: function(component, event, helper){
		helper.onChangeAttributeValueTerminalHelper(component, event);
	},
	applyRacSiaController: function(component, event, helper){
		helper.applyRacSiaHelper(component, event); 
    },
	resetRacSiaController: function(component, event, helper){
        component.set("v.Spinner", true);
		helper.resetRacSiaHelper(component, event);
    },
    //D.F. _ 18-03-2019 _ ManageRacSia v4 _ START
    showModal: function(component, event, helper) {
    	component.set("v.showModal", true);
    },
    closeModal: function(component, event, helper) {
    	component.set("v.showModal", false);
    },
    getSelectedSiaCode: function(component, event, helper) {
        component.set("v.Spinner", true);
        helper.getSelectedOption(component, event);
    },
    //D.F. _ END
    /*
    *@author francesca.ribezzi
    *@date 31/07/2019
    *@task checkRedBorder - setting red border to empty required fields - WN-211
    *@history 31/07/2019 Method created
    */
   checkRedBorder: function(component, event, helper){
        helper.handleRedBorderErrors(component,event);
    },
   /*
    *@author francesca.ribezzi
    *@date 31/07/2019
    *@task callHandleRedBorderErrors - setting red border to empty required fields - WN-211
    *@history 31/07/2019 Method created
    */
   callHandleRedBorderErrors: function(component, event, helper){
        helper.handleRedBorderErrors(component,event);
    },
    
})