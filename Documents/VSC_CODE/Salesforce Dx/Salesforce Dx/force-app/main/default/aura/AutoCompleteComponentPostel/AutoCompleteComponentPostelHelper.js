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
    },

    /**
    * @author Marta Stempien <marta.stempien@accenture.com>
    * @date 24/09/2019
    * @task NEXI-348
    * @description Method checks if checkbox is checked - if yes assigns legale valuse to administrative
    */
    checkboxChanged: function (component, isEqual)
    {
        var isMaintenanceAnagrafica = component.get("v.isMaintenanceAnagrafica");
        //START francesca.ribezzi - R1F3-106 - 24/09/19 - adding a dynamic node:
        var merchant = 'merchant';
        if(isMaintenanceAnagrafica){
            merchant = 'acc';
        }
        //END francesca.ribezzi - R1F3-106 - 24/09/19
        if(isEqual)
        {
            //francesca.ribezzi - R1F3-106 - 24/09/19 - adding a dynamic node :
            component.set('v.objectDataMap.isLegalEqualAdm',true);
            component.set("v.isEqualsAddress", true);
            let objectDataMap = component.get("v.objectDataMap");
            if(objectDataMap[merchant] != undefined){ // antonio.vatrano 25/09/2019 r1f3-107
                objectDataMap[merchant].OB_Administrative_Office_City__c =    !$A.util.isEmpty(objectDataMap[merchant].OB_Legal_Address_City__c) ? objectDataMap[merchant].OB_Legal_Address_City__c : null;
                objectDataMap[merchant].OB_Administrative_Office_Street__c = !$A.util.isEmpty(objectDataMap[merchant].OB_Legal_Address_Street__c) ? objectDataMap[merchant].OB_Legal_Address_Street__c : null;
                objectDataMap[merchant].OB_Administrative_Office_Street_number__c = !$A.util.isEmpty(objectDataMap[merchant].OB_Legal_Address_Street_Number__c) ? objectDataMap[merchant].OB_Legal_Address_Street_Number__c : null;
                objectDataMap[merchant].OB_Administrative_Office_Country_Code__c = !$A.util.isEmpty(objectDataMap[merchant].OB_Legal_Address_Country_Code__c) ? objectDataMap[merchant].OB_Legal_Address_Country_Code__c : null;
                objectDataMap[merchant].OB_Administrative_Office_Country__c = !$A.util.isEmpty(objectDataMap[merchant].OB_Legal_Address_Country__c) ? objectDataMap[merchant].OB_Legal_Address_Country__c : null;
                objectDataMap[merchant].OB_Administrative_Office_Hamlet__c = !$A.util.isEmpty(objectDataMap[merchant].OB_Legal_Address_Hamlet__c) ? objectDataMap[merchant].OB_Legal_Address_Hamlet__c : null;
                objectDataMap[merchant].OB_Administrative_Office_Address_Details__c = !$A.util.isEmpty(objectDataMap[merchant].OB_Legal_Address_Detail__c) ? objectDataMap[merchant].OB_Legal_Address_Detail__c : null;
                objectDataMap[merchant].OB_Administrative_Office_ZIP__c = !$A.util.isEmpty(objectDataMap[merchant].OB_Legal_Address_ZIP__c) ? objectDataMap[merchant].OB_Legal_Address_ZIP__c : null;
                objectDataMap[merchant].OB_Administrative_Office_State__c = !$A.util.isEmpty(objectDataMap[merchant].OB_Legal_Address_State__c) ? objectDataMap[merchant].OB_Legal_Address_State__c : null;
                objectDataMap[merchant].OB_Administrative_Office_State_Code__c = !$A.util.isEmpty(objectDataMap[merchant].OB_Legal_Address_State_Code__c) ? objectDataMap[merchant].OB_Legal_Address_State_Code__c : null;
            }// antonio.vatrano 25/09/2019 r1f3-107
        }
        else
        {
            component.set('v.objectDataMap.isLegalEqualAdm',false);
            component.set("v.isEqualsAddress", false);
        }
    }
})