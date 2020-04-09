({
    /*------------------------------------------------------------
    Author:         Andrea Saracini
    Company:        Accenture Tecnology
    Description:    get all service point of the Merchant
    Inputs:         component, event
    History:
    <Date>          <Authors Name>      <Brief Description of Change>
    2019-03-22      Andrea Saracini     Creator
    ------------------------------------------------------------*/
	myServicePointCode: function(component, event){
        //davide.franzini - 19/07/2019 - F2WAVE2-145 - added bundleConfiguration name
        //davide.franzini - 06/09/2019 - WN-369 - commmission name added
        component.set("v.columns", [
            {label: 'TIPO OFFERTA', fieldName: 'offerName', type: 'text'},
            {label: 'COMMISSIONE', fieldName: 'Name', type: 'text'},
            {label: 'START DATE', fieldName: 'NE__StartDate__c', type: 'date'},
            {label: 'DATA ULTIMA MODIFICA', fieldName: 'LastModifiedDate', type: 'date'},
            {label: 'STATO', fieldName: 'NE__Status__c', type: 'text'},
            {label: 'CODICE MCC', fieldName: 'OB_MCC__c', type: 'text'},
            {label: 'CODICE COMMISIONALE', fieldName: 'OB_ServicePointCode__c', type: 'text'}
        ]);
		var objectDataString = component.get("v.objectDataMap");					
		var action = component.get("c.myOrderItem");
		action.setParams({ 
			objectDataString: JSON.stringify(objectDataString),
		});
		action.setCallback(this, function(response){
			var state = response.getState();
			console.log("state: "+state);			 
			if (state === "SUCCESS"){
                var resp = response.getReturnValue();
                if(resp != null && resp.length>0){
                    console.log("SERVICE POINT CODE: ",resp);
                    //davide.franzini - F2WAVE2-145 - 19/07/2019 - START
                    for(var i=0; i<resp.length;i++){
                        resp[i].offerName = resp[i].NE__Bundle_Configuration__r.Name;
                    }
                    //davide.franzini - F2WAVE2-145 - 19/07/2019 - END
                    component.set("v.codeList", resp);
                    component.set("v.showError", false);                                                                    
                }
                else{
                    component.set("v.showError", true);
                }
                component.set("v.isModalOpen", true);  						
			}
			else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }			
		});
		$A.enqueueAction(action);
    },
    /*------------------------------------------------------------
    Author:         Andrea Saracini
    Company:        Accenture Tecnology
    Description:    update code
    Inputs:         component, event
    History:
    <Date>          <Authors Name>      <Brief Description of Change>
    2019-03-22      Andrea Saracini     Creator
    ------------------------------------------------------------*/
	updateServicePointCode: function(component, event){        
        var objectDataString = component.get("v.objectDataMap");
        var bundleAssetId = component.get("v.bundleAssetId");
        var currentAsset = component.get("v.assetSelected");
        console.log('### assetSelected: ',currentAsset);
        var action = component.get("c.updateConventionalCode");
        var asset = JSON.parse(currentAsset);
        asset = asset[0];
        var srcConf = asset['NE__Order_Config__c'];
		action.setParams({
            objectDataString: JSON.stringify(objectDataString),
            sourceConf: srcConf,
            bundleAssetId: bundleAssetId
        });
		action.setCallback(this, function(response){
			var state = response.getState();
			console.log("state: "+state);			 
			if (state === "SUCCESS"){
                /*davide.franzini _ 08/05/2019 _ START*/
                component.set("v.Spinner", false);
                component.set("v.pricingCloned", true);
                /*davide.franzini _ 08/05/2019 _ END*/
                var resp = response.getReturnValue();
                if(resp != null && resp != 'null'){
                    console.log("SERVICE POINT CODE: "+resp);
                    component.set('v.searchByConvCode', resp);
                    //START  francesca.ribezzi 09/10/19 WN-551 setting isConventionCodeOk
                    component.set('v.isConventionCodeOk', true); 
                    var searchInputConvCodeId = component.find('searchInputConvCodeId');
                    $A.util.removeClass(searchInputConvCodeId, "slds-has-error");
                    //END  francesca.ribezzi 09/10/19 WN-551
                }					
			}
			else if (state === "ERROR"){
                component.set("v.Spinner", false); 
                var errors = response.getError();
                console.error(errors);
            }			
		});
		$A.enqueueAction(action);
    },

     /*
    *@author francesca.ribezzi
    *@date  09/10/2019
    *@task  setting red border to empty required fields - WN-551
	*@history  09/10/2019 Method created
    */
   handleRedBorderErrors: function(component, event){
    var searchInputConvCodeId = component.find('searchInputConvCodeId');
    var conventionCodeValue = component.find('searchInputConvCodeId').get("v.value");
    var isNotEmpty = (!$A.util.isEmpty(conventionCodeValue));
	var isConventionCodeOk = component.get("v.isConventionCodeOk");
        if(isNotEmpty && isConventionCodeOk){	
            $A.util.removeClass(searchInputConvCodeId, "slds-has-error");
        }else{
            $A.util.addClass(searchInputConvCodeId, "slds-has-error");
        }
    },
})