({
    createComponentModal : function(component, event) {
        console.log("INTO HELPER METHOD OF MODAL 2");
        $A.createComponent(
            "c:modalLookupWithPagination",
            {
                "aura:id": "modal",
                "objectString":component.get("v.objectString"),
                "type":component.get("v.type"),
                "subType":component.get("v.subType"),
                "input":component.get("v.inputField"),
                "mapOfSourceFieldTargetField":component.get("v.mapOfSourceFieldTargetField"),
                "mapLabelColumns":component.get("v.mapLabelColumns"),
                "objectDataMap":component.get("v.objectDataMap"),
                "messageIsEmpty":component.get("v.messageIsEmpty"),
                "orderBy":component.get("v.orderBy")
            },
            function(newModal, status, errorMessage){
                if (status === "SUCCESS") {
                    var body = component.get("v.body");
                    body.push(newModal);
                    component.set("v.body", body);
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                }
                    else if (status === "ERROR") {
                        console.log("Error: " + errorMessage);
                    }
            }
        ); 
    },
    removeRedBorderZipCodeEE: function (component, event , helper){
    	var sectionName = component.get("v.addressMapping.sectionName");
    	if(sectionName == undefined || sectionName == null)
    		sectionName='';
    	console.log('sectionName'+sectionName);
        var errorId = 'errorIdzipcodeEE'+sectionName;
        //REMOVE ERROR MESSAGE
        $A.util.removeClass(document.getElementById("zipcodeEE"+sectionName), 'slds-has-error');
        $A.util.addClass(document.getElementById("zipcodeEE"+sectionName), 'slds-input');
       if(document.getElementById(errorId)!=null){
    	   console.log("errorID . " + errorId);
            document.getElementById(errorId).remove();
        }
        
    },
    removeRedBorderPresso: function (component, event , helper){
    	var sectionName = component.get("v.addressMapping.sectionName");
    	if(sectionName == undefined || sectionName == null)
    		sectionName='';
    	console.log('sectionName'+sectionName);
        var errorId = 'errorIdpresso'+sectionName;
        //REMOVE ERROR MESSAGE
        $A.util.removeClass(document.getElementById("presso"+sectionName), 'slds-has-error');
        $A.util.addClass(document.getElementById("presso"+sectionName), 'slds-input');
       if(document.getElementById(errorId)!=null){
    	   console.log("errorID . " + errorId);
            document.getElementById(errorId).remove();
        }
        
    }
})