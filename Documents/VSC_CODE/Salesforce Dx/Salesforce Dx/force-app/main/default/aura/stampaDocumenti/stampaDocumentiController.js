({
	doInit : function(component, event, helper)
	{
		var documentsList = ["Contratto Trilaterale POS", "Contratto Acquaring", "Convenzionamento AMEX", "Modulo Sottoscrizione VAS"];
        console.log('*****doInit');
        component.set("v.objectDataMap.allCheckedCreate",'');
        component.invocationCallbacks = {};
        var orderId = component.get("v.objectDataMap.Configuration.Id");
        //START - elena.preteni 19/07/2019 no documents to generate ABI CAB selection F3
        if(component.get("v.objectDataMap.isOperation") && component.get("v.objectDataMap.isSetup"))
        {
            var messageGenerate=component.find("messageError1");
            $A.util.removeClass(messageGenerate,'slds-hide');
        }
        else
        {
        //END - elena.preteni 19/07/2019 no documents to generate ABI CAB selection F3
            var action = component.get("c.getContractList");
            //LUBRANO 2019/02/23 -- send info if document list is empty 
            console.log('******printing Action: '+ action);
            action.setParams({ orderId : orderId });  
            action.setCallback(this, function (response){
                var state = response.getState();
                if (state === "SUCCESS")
                {
                    //START gianluigi.virga 24/09/2019 - retrieve all contracts from firenet
                    //giovanni spinelli start 07/05/2019 call helper method
                    /*var contractsIdList = [],
                    contractIdMap   = component.get('v.objectDataMap.contractsIdGenerated');
                    //save only id in a list
                    for(var ids in contractIdMap)
                    {
                        contractsIdList.push(contractIdMap[ids]);
                    }
                    //if list isn't empty call helper to deprecate contractwith this id
                    if(contractsIdList && contractsIdList.length >0 )
                    {
                        helper.deprecateAllContracts(component ,contractsIdList );
                    }*/
                    //giovanni spinelli end 07/05/2019 call helper method
                    //END gianluigi.virga 24/09/2019
                    var myResponse=response.getReturnValue();
                    component.set("v.mapRecordId", myResponse);
                    console.log("mapRecordId parent: " +JSON.stringify(component.get("v.mapRecordId")));
                    var myList =[];
                    for(var k in myResponse){
                        myList.push(k);
                    }
                    if(myList.length!=0)
                    {
                        component.set("v.documentsList", myList);
                        var mapDocumentList= new Map();
                        var loadDoc= false;
                        for(var i=0; i<myList.length;i++)
                        {
                            //giovanni spinelli 10/04/2019 - add split method and pass value in map - start
                            var keySplitted = myList[i].split('__')[0];
                            mapDocumentList[keySplitted] =  loadDoc;
                            //giovanni spinelli 10/04/2019 - add split method and pass value in map - end
                        }
                        console.log("mapDocumentList: " +JSON.stringify(mapDocumentList));
                        component.set("v.myMap", mapDocumentList);
                    }else
                    {
                        console.log('messageError1');
                        var messageGenerate=component.find("messageError1");
                        $A.util.removeClass(messageGenerate,'slds-hide');
                    }
                }
                else if (state === "INCOMPLETE")
                {
                    // do something
                }
                else if (state === "ERROR")
                {
                    var errors = response.getError();
                    if (errors)
                    {
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
            $A.enqueueAction(action);
        }  // elena.preteni 19/07/2019 no documents to generate ABI CAB selection F3

    },

    checkAllTrue : function(component, event)
    {
        var changedMap=event.getParam("value");
        var allTrue = false;
        var listChecked = [];
        for(var key in changedMap)
        {
            listChecked.push(changedMap[key]);
        }
        if(listChecked.includes(false))
        {
            component.set("v.objectDataMap.allCheckedCreate",'false');
        }
        else
        {
            component.set("v.objectDataMap.allCheckedCreate",'true');
        }
        console.log("**********allcheckedCreate : " +JSON.stringify(component.get("v.objectDataMap.allCheckedCreate")));
    }
})