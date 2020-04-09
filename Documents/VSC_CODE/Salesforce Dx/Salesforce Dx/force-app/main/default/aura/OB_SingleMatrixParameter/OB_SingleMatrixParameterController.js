({
    doInit : function(component, event, helper) {
        //console.log("single matrix: "+ JSON.stringify(component.get("v.matrixParameter")));
        var abiListForSingleMatrix = component.get("v.abiListForSingleMatrix");
        var activeABIList = component.get("v.activeABIList"); 
        var availableABIList = component.get("v.availableABIList");
        /*for(var key in abiListForSingleMatrix){
            var tempABIopt = {};
            tempABIopt.value = abiListForSingleMatrix[key];
            tempABIopt.label = abiListForSingleMatrix[key];

            activeABIList.push(tempABIopt);
        //   availableABIList.push(tempABIopt);
        }*/
        console.log('data: ',component.get("v.data"));
        console.log('columns: ',component.get("v.columns"));
        console.log('availableABIList: ',availableABIList)
        //francesca.ribezzi 12/06/19 setting selectedRows:
        component.set("v.selectedRows", component.get("v.data"));
        //davide.franzini - F2WAVE2-108 - 09/07/2019 - default checkbox to false removed - START
        //START francesca.ribezzi 03/07/19 - F2WAVE2-16 - setting checkbox as unchecked by default:
         //component.set("v.matrixParameter.OB_ActiveBank__c", false);
         //component.set("v.matrixParameter.NE__Active__c", false);
         //END francesca.ribezzi 03/07/19 - F2WAVE2-16
         //davide.franzini - F2WAVE2-108 - 09/07/2019 - default checkbox to false removed - END
      /* component.set("v.availableABIList", availableABIList);*/

         //START francesca.ribezzi 19/06/19 setting OB_ActiveBank__c default value
  /*       var matrixParameter = component.get("v.matrixParameter");
         var isActive = component.get("v.matrixParameter.NE__Active__c");
         var isPricingForBank = component.get("v.isPricingForBank");
         if(isActive && isPricingForBank){
            component.set("v.matrixParameter.OB_ActiveBank__c", isActive);
         }*/
         //END francesca.ribezzi 19/06/19 

    },

    inheritSelectedABI: function(component, event, helper) {

    },

    handleActivateMatrix: function(component, event, helper) {
       var matrixParameter = component.get("v.matrixParameter");
       var active = event.currentTarget.checked;
       //START francesca.ribezzi 10/06/19 checking if we are in pricing per bank, then using OB_ActiveBank__c instead of NE__Active__c:
       var isPricingForBank = component.get("v.isPricingForBank");
       var activeField = isPricingForBank? 'OB_ActiveBank__c' : 'NE__Active__c';
       console.log("which active field? " + activeField); 
       component.set("v.matrixParameter."+activeField, active);
       console.log("single matrix: "+ component.get("v.matrixParameter."+activeField));
       //START francesca.ribezzi 10/06/19  
     },

     handleChangeAllCheckbox: function(component, event, helper) {
        var setAll = event.getParam("value");
        //START francesca.ribezzi 10/06/19 checking if we are in pricing per bank, then using OB_ActiveBank__c instead of NE__Active__c:
       var isPricingForBank = component.get("v.isPricingForBank");
       var activeField = isPricingForBank? 'OB_ActiveBank__c' : 'NE__Active__c';
       console.log("which active field? " + activeField); 
       component.set("v.matrixParameter."+activeField, setAll);
       //START francesca.ribezzi 10/06/19  
     },

     showABIdetails: function(component, event, helper) {
        var abiListForSingleMatrix = component.get("v.abiListForSingleMatrix");
        //TODO:  pass abi list to dueling picklist component
        var showABIlist = component.get("v.showABIlist");
        component.set("v.showABIlist", !showABIlist);
     },


    getSelectedAbi: function(component, event, helper) {
        var selectedRows = event.getParam('selectedRows');
        var selectedRowsAttribute = component.get("v.selectedRows");
        var selectedBankList = component.get("v.selectedBankList");
         
        for (var i = 0; i < selectedRows.length; i++){

           selectedRowsAttribute.push(selectedRows[i]);
        }
        console.log("selectedRowsAttribute: ", selectedRowsAttribute);
  
        component.set("v.selectedBankList", selectedRowsAttribute);
    
        console.log("selectedBankList: ", selectedBankList);
     /*   component.set("v.selectedBankList", selectedBankList);*/
    },

     cancelClickedABI: function(component, event, helper) {
        component.set("v.input", ''); 
        component.set("v.showAbiModal", false);
        component.set("v.selectedBankList", {});
        component.set("v.selectedRows", []);
        component.set("v.abiList", []);
  
      },

      closeModal: function(component, event, helper) {
        component.set("v.showABIlist", false); 
    
  
      },
})