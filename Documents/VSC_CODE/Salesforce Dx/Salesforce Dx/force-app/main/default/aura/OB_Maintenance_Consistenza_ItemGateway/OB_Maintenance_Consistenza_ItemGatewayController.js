({
    doInit : function(component, event, helper) {
        var objectMap = component.get("v.gatewaytItem");
        var gatewaytItemAttribute = component.get("v.gatewaytItem").NE__Order_Item_Attributes__r;
        var listOfItemsByRoot 		= [];
        if(gatewaytItemAttribute!= undefined && gatewaytItemAttribute.records.length>0){ //antonio.vatrano 31/07/2019 fix error add condition in if
        	component.set("v.gatewaytItemAttribute",gatewaytItemAttribute.records);
        }
        if(objectMap.NE__Order_Items_Conf__r != undefined) 
        {
            console.log("@Into first if");
            if(typeof(objectMap.NE__Order_Items_Conf__r.records) !== undefined)
            {
                console.log("@Into second if");
                listOfItemsByRoot 	= objectMap.NE__Order_Items_Conf__r.records;
            }
            else
            {
                listOfItemsByRoot 	= objectMap.NE__Order_Items_Conf__r;
            }
        }
        if(listOfItemsByRoot!=null && listOfItemsByRoot!=undefined)
        {
            // component.set("v.showEnablement",true);
            console.log("@listOfItemsByRoot : " + JSON.stringify(listOfItemsByRoot));
            var listOfEnablements = [];
            var itemRoot = {};
            // for(itemRoot in listOfItemsByRoot)
            var isNotOperation = component.get("v.isNotOperation");
            var isAdd = component.get("v.gatewaytItem").NE__Action__c == 'Add';
            for( var itemRoot = 0; itemRoot<listOfItemsByRoot.length; itemRoot++)
            {
                console.log("@hasOwnProperty itemFromRoot : " + JSON.stringify(Object.getOwnPropertyNames(listOfItemsByRoot[itemRoot])));
                console.log("@itemFromRoot : " + JSON.stringify(listOfItemsByRoot[itemRoot]));
                if(listOfItemsByRoot[itemRoot].OB_enablement__c!=null && typeof listOfItemsByRoot[itemRoot].OB_enablement__c!="undefined")
                    {
                        console.log("@OB_enablement__c : " + listOfItemsByRoot[itemRoot].OB_enablement__c);
                        console.log("@OB_Old_Enablement__c : " + listOfItemsByRoot[itemRoot].OB_Old_Enablement__c);
                        
                        
                        listOfItemsByRoot[itemRoot].disabledStart = true;
                        listOfItemsByRoot[itemRoot].disabledEnd = true;
                        listOfItemsByRoot[itemRoot].showStart = false;
                        listOfItemsByRoot[itemRoot].showEnd = false;

                        if(listOfItemsByRoot[itemRoot].OB_enablement__c!=listOfItemsByRoot[itemRoot].OB_Old_Enablement__c || isAdd)
                        {	listOfItemsByRoot[itemRoot].showEnablement=true;
                            
                            if(listOfItemsByRoot[itemRoot].NE__ProdId__r.OB_Acquirer__c=='NEXI'){
                                listOfItemsByRoot[itemRoot].isNexi = true;
                            }

                            if(listOfItemsByRoot[itemRoot].OB_enablement__c=="Y"){
                                listOfItemsByRoot[itemRoot].showStart = true;
                            } else{
                                listOfItemsByRoot[itemRoot].showEnd = true;
                            }
                            if(isNotOperation){
                                if(listOfItemsByRoot[itemRoot].OB_enablement__c=="Y")
                                {
                                    listOfItemsByRoot[itemRoot].disabledStart = false;
                                    listOfItemsByRoot[itemRoot].disabledEnd = true;
                                }
                                else
                                {
                                    listOfItemsByRoot[itemRoot].disabledStart = true;
                                    listOfItemsByRoot[itemRoot].disabledEnd = false;
                                }
                            }
                            
                            // listOfEnablements.push(listOfItemsByRoot[itemRoot]);
                            // console.log("@currentEnablement : " + listOfItemsByRoot[itemRoot]);
                        }

                        listOfEnablements.push(listOfItemsByRoot[itemRoot]);
                    }
            }
            component.set("v.enablements",listOfEnablements);
            console.log("@enablements : " + JSON.stringify(component.get("v.enablements")));
        }
        var itemId = component.get("v.gatewaytItem.Id");
        component.set("v.itemId",itemId);
        console.log(component.get("v.isNotOperation"));
        var actionRetrieve = component.get("c.retrieveStatus");
        actionRetrieve.setParams({
            itemId : itemId
        });
        actionRetrieve.setCallback(this, function(response)
        {
            var state = response.getState();
            if (state === "SUCCESS") 
            {
              
               var res = response.getReturnValue();
               console.log( res.NE__Status__c);
               if(res.NE__Status__c=='Completed'){ // antonio.vatrano 29/07/2019 f2wave2-153
                    component.set("v.itemHasBeenUpdated",true); // antonio.vatrano 29/07/2019 f2wave2-153
               }

            } 
            else if (state === "INCOMPLETE")
            {
                //do something
            }
            else if (state === "ERROR") 
            {
                var errors = response.getError();
                if (errors) 
                {
                    if (errors[0] && errors[0].message) 
                    {
                        console.log("OB_Maintenance_Consistenza_Log_RequestController.js : doInit : Error message: "
                            + errors[0].message);
                    }
                }
                else 
                {
                    console.log("OB_Maintenance_Consistenza_Log_RequestController.js : doInit : *UNKNOW ERROR*");
                }
            }
        });
        $A.enqueueAction(actionRetrieve);
    },
    save : function(component, event, helper){
        // var startDate = component.find("startDateInt").get("v.value");
        // var endDate = component.find("endDateInt").get("v.value");
        var action = component.find("actionGateway").get("v.value");
        var itemId = event.getSource().get("v.name");
        console.log('action',typeof action);
        console.log('id',typeof itemId);
        var enablementsList = [];
        enablementsList = component.get("v.enablements");        
		for(var singleEnab in enablementsList)//Simone Misani 16/07/2019 F2WAVE2-153
		{
			var singleId = enablementsList[singleEnab].Id;
			if(component.find(singleId)!=undefined)
			{
				var inputValue = component.find(singleId).get("v.value");
				if(enablementsList[singleEnab].OB_enablement__c == "Y")
				{
					enablementsList[singleEnab].NE__StartDate__c = inputValue;
				}
				else
				{
					enablementsList[singleEnab].NE__EndDate__c = inputValue;
				}
			}
			delete enablementsList[singleEnab].attributes ;
			delete enablementsList[singleEnab].disabledEnd ;
			delete enablementsList[singleEnab].disabledStart ;
			delete enablementsList[singleEnab].showStart ;
			delete enablementsList[singleEnab].showEnd ;
			delete enablementsList[singleEnab].showEnablement ;
			delete enablementsList[singleEnab].isNexi ;
		}
        var actionSave = component.get("c.saveOrderItemGateway");
        actionSave.setParams({
            action : action,
            itemId : itemId,
            enablements : enablementsList
        });
        actionSave.setCallback(this, function(response)
        {
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                console.log(state);
                /* ANDREA MORITTU START 18-Jul-19 F2WAVE2 - 154 - Added Success Message*/
                var type;
                var title;
                var message;
                var updateIsDone = response.getReturnValue();
                if(updateIsDone) {
                    type     = 'Success'
                    title    = $A.get("$Label.c.OB_MAINTENANCE_TOAST_OPERATIONSUCCESSFULL");
                    message  = ' ';

                    // IF item has been updated successfully, disable save button
                    component.set('v.itemHasBeenUpdated', true);

                    
                } else {
                    type     = 'Error'
                    title    = 'Servizio Momentaneamente non disponibile';
                    message  = ' ';
                }
                helper.launchToast(component , event , helper , type , title , message);
                /* ANDREA MORITTU END 18-Jul-19 F2WAVE2 - 154 - Added Success Message*/

            } 
            else if (state === "INCOMPLETE")
            {
                //do something
            }
            else if (state === "ERROR") 
            {
                var errors = response.getError();
                if (errors) 
                {
                    if (errors[0] && errors[0].message) 
                    {
                        console.log("OB_Maintenance_Consistenza_Log_RequestController.js : save : Error message: "
                            + errors[0].message);
                    }
                }
                else 
                {
                    console.log("OB_Maintenance_Consistenza_Log_RequestController.js : save : *UNKNOW ERROR*");
                }
            }
        });
        $A.enqueueAction(actionSave);
    }
})