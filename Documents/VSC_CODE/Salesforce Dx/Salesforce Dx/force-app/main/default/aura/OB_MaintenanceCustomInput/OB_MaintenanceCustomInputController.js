({
    doInit : function(component, event, helper) {
        var objectDataMap = component.get("v.objectDataMap");
        if(objectDataMap.merchant.OB_Annual_Revenue__c == 0){
            component.set("v.objectDataMap.merchant.OB_Annual_Revenue__c", "");
        }
        if(objectDataMap.merchant.OB_Annual_Negotiated__c == 0){
            component.set("v.objectDataMap.merchant.OB_Annual_Negotiated__c", "");
        }
        //START shagheygh.tofighian 20/05/2019 R1F2-63
        var employees = component.get('v.objectDataMap.merchant.OB_Employees_Number__c');
        console.log('employees: '+employees);
        component.find('employeesNumber').set('v.value',employees );
        //END shagheygh.tofighian 20/05/2019 R1F2-63
        helper.getEmployeesNumberPicklistValues(component , helper , event );
        //component.set("v.valuePreviousEmplNumb" , (objectDataMap.merchant.OB_Employees_Number__c).replace(/_/g, ' ')); 
    },

    // //****METHOD TO CONTROL TTHE NEGATIVE VALUE OF ANNUAL REVENUE****//
    validateAnnualRevenue: function(component, event, helper) { 
        var annualRevenueValue = component.find("annualRevenue")!=undefined?component.find("annualRevenue").get("v.value"):null; 
        console.log('annualRevenueValue: ' + annualRevenueValue);
        var currentId = component.find("annualRevenue").get("v.id");
        //giovanni spinelli 18/02/2019
        console.log('CURRENT ID: ' + currentId);
        var currentIdValue = component.find(currentId).get('v.value');
        console.log('currentIdValue: ' + currentIdValue);
        
        //giovanni spinelli 18/02/2019 control if annual negotiated isn't greater than annual revenue - start
        if(currentIdValue < 0) {
            $A.util.addClass(component.find(currentId) , 'slds-has-error flow_required');
            component.set("v.ErrorBoolean"+currentId,true);
            component.set("v.ErrorMessage"+currentId , $A.get("$Label.c.OB_AnnualRevenueNotValid"))  ;
            component.set("v.objectDataMap.errorFamily.errorAnnualRevenueNegotiated", true);
        } else {
            if(currentId=='annualNegotiated'){
                
                if(component.find('annualRevenue')){
                    //convert string in number
                    var numberAnnualRevenue 	= Number(component.find('annualRevenue').get('v.value'));
                    var numberAnnualNegotiated 	= Number(currentIdValue);
                    if( numberAnnualRevenue < numberAnnualNegotiated){
                        $A.util.addClass(component.find(currentId) , 'slds-has-error flow_required');
                        component.set("v.ErrorBoolean"+currentId,true);
                        component.set("v.ErrorMessage"+currentId , $A.get("$Label.c.OB_AnnualValueNotValid"))  ;//<--CHANGE LABEL
                        component.set("v.objectDataMap.errorFamily.errorAnnualRevenueNegotiated", true);
                        // alert('fail');
                    } else {
                        //success
                        $A.util.removeClass(component.find(currentId) , 'slds-has-error flow_required');
                        component.set("v.ErrorBoolean"+currentId,false);
                        component.set("v.ErrorBoolean"+currentId , '')  ;
                        component.set("v.objectDataMap.errorFamily.errorAnnualRevenueNegotiated", false);
                        /*remove red border and error message from annual revenue if it is greater than 0
                        else set true the boolean to stay in page*/
                        if(numberAnnualRevenue>=0){
                            $A.util.removeClass(component.find('annualRevenue') , 'slds-has-error flow_required');
                            component.set("v.ErrorBooleanannualRevenue",false);
                        }else{
                            component.set("v.objectDataMap.errorFamily.errorAnnualRevenueNegotiated", true);
                        }
                    }
                }
            }
            if(currentId=='annualRevenue'){
                var annualNegotiated =  component.find('annualNegotiated');
                if(!$A.util.isUndefinedOrNull(annualNegotiated)) {
                    //convert string in number
                    var  numberAnnualNegotiated = Number(component.find('annualNegotiated').get('v.value'));
                    var  numberAnnualRevenue	= Number(currentIdValue);
                    if(numberAnnualNegotiated > numberAnnualRevenue){
                        //error
                        $A.util.addClass(component.find(currentId) , 'slds-has-error flow_required');
                        component.set("v.ErrorBoolean"+currentId,true);
                        component.set("v.ErrorMessage"+currentId , $A.get("$Label.c.OB_AnnualValueNotValid"))  ;//<--CHANGE LABEL
                        component.set("v.objectDataMap.errorFamily.errorAnnualRevenueNegotiated", true);
                    }else{
                        //success
                        $A.util.removeClass(component.find(currentId) , 'slds-has-error flow_required');
                        component.set("v.ErrorBoolean"+currentId,false);
                        component.set("v.ErrorBoolean"+currentId , '')  ;
                        component.set("v.objectDataMap.errorFamily.errorAnnualRevenueNegotiated", false);
                        /*remove red border and error message from annual negotiated if it is greater than 0
                        else set true the boolean to stay in page*/
                        if(numberAnnualNegotiated>=0){
                            $A.util.removeClass(component.find('annualNegotiated') , 'slds-has-error flow_required');
                            component.set("v.ErrorBooleanannualNegotiated",false);
                        }else{
                            component.set("v.objectDataMap.errorFamily.errorAnnualRevenueNegotiated", true);
                        } 
                    }
                }
                
            }
        }
        helper.removeRedBorder(component, event, helper); 
    },
    //**********METHOT TO REMOVE THE RED BORDER**********//
	removeRedBorder: function(component, event, helper) {
		
		helper.removeRedBorder(component, event, helper);
		//************************************METHOD FOR FORMAL CONTROL OF NAME MERCHANT-START**********************************//
		//THE FOLLOWING METHOD STARTS ONLY WHEN I HAVE ON DISPLAY THE NAME FIELD//
		if(component.find('name'))
		{
			var name = component.find('name')!=undefined?component.find('name').get("v.value"):null;
			//CREATE A DIV WITH A CUSTOM ERROR MESSAGE
			var myDiv;
			myDiv = document.createElement('div');
			var errorMessage = document.createTextNode($A.get("$Label.c.errorSpecialCharacter")); 
			console.log("error message: " + JSON.stringify(errorMessage));
			myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
			myDiv.setAttribute('id','customErrorIdName');
			myDiv.appendChild(errorMessage);
			var idTest;
			//IF THERE IS THE INPUT
		   if(component.find('name'))
		   {
			   idTest  = component.find('name').getElement();
		   }
			//WRONG CHARACTER
			if(specialCharacter(name)=='ERROR' && name.length>0  )
			{
				$A.util.addClass(component.find('name') , 'slds-has-error flow_required');
				//ADD THE ERROR MESSAGE
				if(!document.getElementById('customErrorIdName')){
					 idTest.after(myDiv);
				}
				//BOOLEANT TO REST IN PAGE
				component.set("v.objectDataMap.errorFamily.errorNameMerchant", true);
			}
			//RIGHT CHARACTER
			else if(specialCharacter(name)==null || name.length==0)
			{
				// $A.util.removeClass(component.find('name') , 'slds-has-error flow_required');
				 if(!$A.util.isEmpty(document.getElementById('customErrorIdName'))){  //francesca.ribezzi 15/11/19 - PROD-107 - using util.isEmpty 
					document.getElementById('customErrorIdName').remove();
				 }
				component.set("v.objectDataMap.errorFamily.errorNameMerchant", false);
				 
			}
		}
		//************************************METHOD FOR FORMAL CONTROL OF NAME MERCHANT-END**********************************//
    }, 
    
    //**********METHOD TO SET THE PICKLIST VALUE INTO OBJDATAMAP**********//
	setPickListValue: function(component, event, helper) {
		var objectDataMap = component.get("v.objectDataMap");
		var employeesNumber  = component.find("employeesNumber").get("v.value");
		objectDataMap.merchant.OB_Employees_Number__c  = employeesNumber;
		
		  
		helper.removeBorderPicklist(component, event, helper);
		//************************************************//
	}
})