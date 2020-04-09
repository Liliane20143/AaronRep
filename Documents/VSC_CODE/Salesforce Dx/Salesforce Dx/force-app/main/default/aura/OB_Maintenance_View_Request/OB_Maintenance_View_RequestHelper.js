({
	doInit : function(component, event, helper) {
		// this.booleanValueListToCheckHelper(component, event, helper);

		var action = component.get('c.retrieveLogRequest');

		var recordid = component.get("v.recordId");
		action.setParams({ 
			"logRequestId" : recordid
		});
		
		//enqueue Action
		action.setCallback(this, $A.getCallback(function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var valueReturns = response.getReturnValue();
				var result = JSON.parse( valueReturns );
				console.log(' method valueReturns is ',valueReturns);
				console.log(' method result is ',result);
				console.log(' method result Status is ',result.requestStatus);
				//START - elena.preteni 24/06/2019 coba logic for Log request
				var cobaShow;
				if(result[0]!=undefined){
					cobaShow=true;
				}else{
					cobaShow=false;
				}
				if(!cobaShow){
				//END - elena.preteni 24/06/2019 coba logic for Log request

				    //NEXI-240 Marlena Lukomska-Rogala <m.lukomska-rogala@accenture.com> 31/07/2019 START
				    if($A.util.isEmpty(result.errorMessage) && !$A.util.isEmpty(result) && !$A.util.isEmpty(result.oldData))
				    {
				        component.set('v.isChangeMerchant', result.changeMerchant);
				        component.set('v.isChangeServicePoint', result.changeServicePoint);
				        component.set('v.objectType', result.oldData[0].objecType);
				        component.set('v.companyCode', result.companyCode);
				        component.set('v.servicePointCode', result.servicePointCode);
				        //francesca.ribezzi 19/08/19  - F2WAVE2-176 - setting source attribute
                        component.set('v.source', result.source);
                    }
                    //NEXI-240 Marlena Lukomska-Rogala <m.lukomska-rogala@accenture.com> 31/07/2019 STOP
					if(result.requestStatus == $A.get("$Label.c.OB_MAINTENANCE_LOGREQUEST_STATUS_DRAFT")){
						component.set("v.isDraft", true);
					}

					if(result.errorOccurred ){
						// show toasst
						this.showToast(component, event, helper,$A.get("$Label.c.OB_MAINTENANCE_TOASTERROR"), result.errorMessage, "error");
					}
					else
					{
						console.log(' method result.errorOccurred is '+result.errorOccurred);
						console.log(' method result.oldData is '+JSON.stringify(result.oldData));
						console.log(' method result.newData is '+result.newData);

						// Start AV 21_12_18 view details of service point

						if (result.oldData[0].objecType == "NE__Service_Point__c"){
							console.log("*******there is a SP");
						}
						// End AV 21_12_18 view details of service point
						// Start AV 20_12_18 for Time Format
						console.log(JSON.stringify(result.oldData[0].listOfRow));
						for(var k in result.oldData[0].listOfRow){
							if( result.oldData[0].listOfRow[k]['apiname'] == 'OB_Opening_Time__c'       ||
								result.oldData[0].listOfRow[k]['apiname'] == 'OB_Break_End_Time__c'     ||
								result.oldData[0].listOfRow[k]['apiname'] == 'OB_Ending_Time__c'        ||
								result.oldData[0].listOfRow[k]['apiname'] == 'OB_Break_Start_Time__c'       ){
								var valueTmpOld = result.oldData[0].listOfRow[k]['value'];
								if(valueTmpOld != null){
									result.oldData[0].listOfRow[k]['value'] = (result.oldData[0].listOfRow[k]['value']).substring(0, 5);
								}
							}
						}

						for(var k in result.newData[0].listOfRow){
							if( result.newData[0].listOfRow[k]['apiname'] == 'OB_Opening_Time__c'       ||
								result.newData[0].listOfRow[k]['apiname'] == 'OB_Break_End_Time__c'     ||
								result.newData[0].listOfRow[k]['apiname'] == 'OB_Ending_Time__c'        ||
								result.newData[0].listOfRow[k]['apiname'] == 'OB_Break_Start_Time__c'       ){
								var valueTmpNew = result.newData[0].listOfRow[k]['value'];
								if(valueTmpNew != null){
									result.newData[0].listOfRow[k]['value'] = (result.newData[0].listOfRow[k]['value']).substring(0, 5);
								}
							}
						}

                        //NEXI-136 wojciech.kucharek@accenture.com 01/07/2019 START
                        result.oldData = helper.addMissingFieldsInCollection(component, event, result.newData, result.oldData);
                        result.newData = helper.addMissingFieldsInCollection(component, event, result.oldData, result.newData);
                        //NEXI-136 wojciech.kucharek@accenture.com 01/07/2019 STOP
                        //NEXI-91 wojciech.kucharek@accenture.com 21/06/2019 START
                        component.set('v.logRequestType', result.logRequestType);
                        //NEXI-91 wojciech.kucharek@accenture.com 21/06/2019 STOP
                        //NEXI-91 grzegorz.banach@accenture.com 17/06/2019 START
                        let showAction = false;
                        let showRole = false;

                        if (result.logRequestType == 'Maintenance of location referents')
                        {
                            showAction = true;
                            showRole = true;
                        }
                        else if (result.logRequestType == 'Maintenance of data of actual owners')
                        {
                            showAction = true;
                        }

                        component.set( 'v.showRole', showRole ); // NEXI-138 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 28/06/2019
                        component.set( 'v.showAction', showAction ); // NEXI-138 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 28/06/2019

                        for (let objectIdx=0; objectIdx<result.oldData.length; objectIdx++)
                        {
                            if ( !showAction && !(result.logRequestType == 'Maintenance of esecutore') ) // NEXI-168 Marta Stempien <marta.stempien@accenture.com> Added !(result.logRequestType == 'Maintenance of esecutore') to condition, 05/07/2019
                            {
                                break;
                            }
                            if ( !( result.oldData[objectIdx].objecType == 'Contact' ) )
                            {
                                continue;
                            }

                            let action =  helper.calculateAction( component, event, result.oldData[objectIdx], result.newData[objectIdx] );
                            // NEXI-138 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 28/06/2019 START
                            result.oldData[objectIdx].action = action;
                            result.newData[objectIdx].action = action;
                            // NEXI-138 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 28/06/2019 STOP
                    }
                    //NEXI-91 grzegorz.banach@accenture.com 17/06/2019 STOP

                    //NEXI-228 Grzegorz Banach <grzegorz.banach@accenture.com> 22/07/2019 START
                    for ( let loopObject of result.newData )
                    {
                        if ( loopObject.listOfRow.length === 1 && loopObject.listOfRow[0].apiname === 'OB_Contact_State__c' && loopObject.listOfRow[0].value === 'Inactive')
                        {
                            loopObject.contactStateChange = true;
                        }
                    }
                    //NEXI-228 Grzegorz Banach <grzegorz.banach@accenture.com> 22/07/2019 STOP
					//NEXI-130 Joanna Mielczarek <joanna.mielczarek@accenture.com> 28/06/2019 START
                    let oldDataWithoutDescriptionField = [];
                    for ( let loopObject of result.oldData )
                    {
                        let oldDataFieldList = JSON.parse(JSON.stringify(loopObject));
                        let howManyDeleted = 0;
                        for ( let x = 0; x< loopObject.listOfRow.length ;x++)
                        {
                            if ( loopObject.listOfRow[x].apiname === 'Description' )
                            {
                                let place = x-howManyDeleted;
                                oldDataFieldList.listOfRow.splice(place,1);
                                howManyDeleted++;
                            }
                        }
                        oldDataWithoutDescriptionField.push( oldDataFieldList );
                    }

                    let newDataWithoutDescriptionField = [];
                    for ( let loopObject of result.newData )
                    {
                        let newDataFieldList = JSON.parse(JSON.stringify(loopObject));
                        let howManyDeleted = 0;
                        for ( let x = 0; x< loopObject.listOfRow.length ;x++ )
                        {
                            if ( loopObject.listOfRow[x].apiname === 'Description' )
                            {
                                let place = x-howManyDeleted;
                                newDataFieldList.listOfRow.splice(place,1);
                                howManyDeleted++;
                            }
                        }
                        newDataWithoutDescriptionField.push( newDataFieldList );
                    }
                    // End AV 20_12_18 for Time Format
                    component.set( "v.oldData", oldDataWithoutDescriptionField );
                     component.set( "v.newData", newDataWithoutDescriptionField );
                    //NEXI-130 Joanna Mielczarek <joanna.mielczarek@accenture.com> 28/06/2019 STOP
					component.set("v.logStatus", result.requestStatus);
					component.set("v.isInternalUser", result.isInternalUser);
					//component.set("v.test", true);

				}

				}
				//START - elena.preteni 24/06/2019 coba logic for Log request
				else if (cobaShow){
					component.set("v.isCoba", result[0].isCoba);
					component.set("v.wrapperCoba",result);
				}
				//END - elena.preteni 24/06/2019 coba logic for Log request
			}
			else if (state === "ERROR") {
				var errors = response.getError();
				this.showToast(component, event, helper,$A.get("$Label.c.OB_MAINTENANCE_TOASTERROR"),''+errors, "error");
				console.error(errors);
			}
		}));
		$A.enqueueAction(action);

		//15-01-2019--S.P.--CHECK CURRENT PROFILE IS AVAIABLE TO ACCEPT OR REJECT LOG REQUEST--START
		var action2 = component.get('c.checkProfile');
		action2.setCallback(this, function(response){
			var state = response.getState();
			if (state === "SUCCESS") 
			{
				var bool = response.getReturnValue();
				console.log('@@@@@RESPONSE boolean '+response.getReturnValue());
				component.set('v.isOperation', bool);
			} 
			else if (state === "INCOMPLETE")
			{
				//do something
			}
			else if (state === "ERROR") 
			{
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) 
					{
						console.log("Error message: " + 
							errors[0].message);
					}
				} 
				else 
				{
					console.log("Unknown error");
				}
			}
		});
		
		$A.enqueueAction(action2);
		// 15-01-2019--S.P.--CHECK CURRENT PROFILE IS AVAIABLE TO ACCEPT OR REJECT LOG REQUEST--END
		//START - salvatore.pianura - 03/05/2019 - GET LOG REQUEST TO CHECK OB_SIAToBeApproved__c AND OB_EquensMoneticaToBeApproved__c
		var getLogRequestAction = component.get("c.getLogRequest");
		console.log('@Into getLogRequest()');
		getLogRequestAction.setParams({"logRequestId" : recordid});
		getLogRequestAction.setCallback(this,function (response) 
		{
			var state = response.getState();
			if (state === "SUCCESS")
			{
				var returnLogRequest = response.getReturnValue();
				component.set("v.currentLogRequest",returnLogRequest);
				console.log("currentLogRequest: "+JSON.stringify(component.get("v.currentLogRequest")));
			}
			else if(state === "INCOMPLETE")
			{
				//do something
			}
			else if(state === "ERROR")
			{
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) 
					{
						console.log("Error message: " + errors[0].message);
					}
				} 
				else 
				{
					console.log("Unknown error");
				}
			}
		});
		$A.enqueueAction(getLogRequestAction);
		//END - salvatore.pianura - 03/05/2019 - GET LOG REQUEST TO CHECK OB_SIAToBeApproved__c AND OB_EquensMoneticaToBeApproved__c
	},

	rejectLogRequest : function(component, event, helper) {
		var action = component.get('c.rejectLogRequest');

		var recordid = component.get('v.recordId');
		// var rejectReason = component.get('v.RejectReason');
		var rejectReason = component.get('v.rejectreason');
		console.log("rejectReason: "+JSON.stringify(rejectReason));
// Start AV Defect #00001577 switch field OB_RejectReason__c --> OB_Rejection_Comments__c
		action.setParams({ 
			"logRequestId" : recordid,
			"rejectComments" : rejectReason
		});
// Start AV Defect #00001577 switch field OB_RejectReason__c --> OB_Rejection_Comments__c
		action.setCallback(this, $A.getCallback(function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var valueReturns = response.getReturnValue();
				if(valueReturns){
					this.showToast(component, event, helper,$A.get("$Label.c.OB_MAINTENANCE_TOASTERROR"),''+valueReturns, "error");
				}
				else{
					component.set("v.showRejectModal",false);
					this.showToast(component, event, helper,$A.get("$Label.c.OB_MAINTENANCE_TOAST_OPERATIONSUCCESSFULL"),'', "success");
					//var switchOnload =  component.get('v.switchOnload');
					//component.set('v.switchOnload',!switchOnload);
					component.set('v.logStatus','hide');
					$A.get('e.force:refreshView').fire();
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				this.showToast(component, event, helper,$A.get("$Label.c.OB_MAINTENANCE_TOASTERROR"),''+errors, "error");
				console.error(errors);
			}
		}));
		$A.enqueueAction(action);

	},
	showToast: function (component, event, helper,title, message, type) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			"title": title,
			"message": message,
			"type": type
		});
		toastEvent.fire();
	},

    /**
    *@author Grzegorz Banach <grzegorz.banach@accenture.com>
    *@date 19/06/2019
    *@description Method reconstructs the action type basing on the log request list item content
    *@history 19/06/2019 Method created
    *@returns String
    */
    calculateAction : function(component,event,oldListItem,newListItem)
    {
        if ( $A.util.isEmpty( oldListItem.objectId ) && $A.util.isEmpty( newListItem.objectId ) )
            {
            return 'Add';
        }

        if ( !$A.util.isEmpty( oldListItem.objectId ) && $A.util.isEmpty( newListItem.objectId ) )
        {
            //NEXI-91 wojciech.kucharek@accenture.com 21/06/2019 START
            if( component.get('v.logRequestType') == 'Variazione dati del Service Point' )
            {
                component.set('v.showCurrentContacSection', false);
            }
            //NEXI-91 wojciech.kucharek@accenture.com 21/06/2019 STOP
            return 'Remove';
        }

        for (let fieldIdx=0; fieldIdx<oldListItem.listOfRow.length; fieldIdx++)
        {
            let oldDataFieldVal = oldListItem.listOfRow[fieldIdx].value;
            let newDataFieldVal = newListItem.listOfRow[fieldIdx].value;

            if ( oldDataFieldVal != newDataFieldVal && oldListItem.listOfRow[fieldIdx].apiname != 'Description' )
            {
                return 'Change';
            }
        }

        return 'None';
    },

    /**
    *@author Wojciech Kucharek <wojciech.kucharek@accenture.com>
    *@date 01/07/2019
    *@description Method check if field from one collection is in second collection
    *@history 01/07/2019 Method created
    *@returns Boolean
    */
    checkIfInCollection : function(component, event, item, collection)
    {
        var isInCollection = false;
        for(var i =0; i < collection.listOfRow.length; i++){
            if(collection.listOfRow[i]['apiname'] == item['apiname']){
                isInCollection = true;
                break;
            }
        }
        return isInCollection;
    },

    /**
    *@author Wojciech Kucharek <wojciech.kucharek@accenture.com>
    *@date 01/07/2019
    *@description Method add missing fields to collection if this fields are in other collection
    *@history 01/07/2019 Method created
    *@returns updated collection of new fields
    */
    addMissingFieldsInCollection: function(component, event, fromCollection, toCollection)
    {
        for( var loopOverObject = 0; loopOverObject < fromCollection.length; loopOverObject++ )
        {
            for ( var loopOverElements = 0; loopOverElements < fromCollection[loopOverObject].listOfRow.length; loopOverElements++)
            {
                var inNewData = this.checkIfInCollection(component, event, fromCollection[loopOverObject].listOfRow[loopOverElements], toCollection[loopOverObject]);
                if(!inNewData)
                {
                    toCollection[loopOverObject].listOfRow.push({
                        apiname : fromCollection[loopOverObject].listOfRow[loopOverElements]['apiname'],
                        datatype : fromCollection[loopOverObject].listOfRow[loopOverElements]['datatype'],
                        sequence : fromCollection[loopOverObject].listOfRow[loopOverElements]['sequence'],
                        label : fromCollection[loopOverObject].listOfRow[loopOverElements]['label'],
                        value : ''
                    });
                }
            }
        }

        //NEXI-237 Wojciech Kucharek <wojciech.kucharek@accenture.com> 24/07/2019 START
        for( let objectIndex = 0; objectIndex < toCollection.length; objectIndex++)
        {
            let sortedBySequence = [];
            let sortedByApiName =[];
            for( let elementIndex = 0; elementIndex < toCollection[objectIndex].listOfRow.length; elementIndex++)
            {
                if( toCollection[objectIndex].listOfRow[elementIndex]['sequence'] < 100)
                {
                    sortedBySequence.push( toCollection[objectIndex].listOfRow[elementIndex] );
                }
                else{
                    sortedByApiName.push( toCollection[objectIndex].listOfRow[elementIndex] );
                }
            }

            sortedBySequence.sort((a,b) => (a['sequence'] > b['sequence']) ? 1: -1);
            sortedByApiName.sort((a,b) => (a['apiname'] > b['apiname']) ? 1: -1);
            let sortedListOfRow = sortedBySequence.concat(sortedByApiName);
            toCollection[objectIndex].listOfRow = sortedListOfRow.slice(0);
        }
        //NEXI-237 Wojciech Kucharek <wojciech.kucharek@accenture.com> 24/07/2019 STOP
        return toCollection;
    }
})