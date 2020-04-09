({
    doInit : function(component, event, helper) {
        console.log(component.get("v.recordId"));
        var action = component.get("c.getActiveAssets");
        action.setParams({
            "servicePointId": component.get("v.recordId")
            
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();  //simone.misani@accenture.com 03/05/2019 RI-34 
                var responseParsed= JSON.parse(res);
                component.set("v.attributeList",responseParsed.orderItemAttributeList);
                component.set("v.posList",responseParsed.wpList);
                component.set("v.pagoList",responseParsed.pagoList);
                component.set("v.vasList",responseParsed.vasList);
                //START----- simone.misani RI-34 03/05/2019  create variables for sort Acquiring. 
                var acquiringListVM =responseParsed.acquiringListVM;
                var acquiringList = responseParsed.acquiringList;
                var listAcquiring = acquiringListVM.concat(acquiringList);
                component.set("v.acquiringList",listAcquiring);
                //END----- simone.misani RI-34 03/05/2019  create variables for sort Acquiring.
                component.set("v.enablementsList",responseParsed.enablememntsList);
                component.set("v.bundleIdMap",responseParsed.bundleIdMap);
                component.set("v.mapItem",responseParsed.mapItemAssetId);
                component.set("v.mapAbi",responseParsed.mapAbi);
                component.set("v.accountName",responseParsed.account);
                component.set("v.mapAssetConfig",responseParsed.mapAssetConfig);
                component.set("v.mapAssetBundleConfig",responseParsed.mapAssetBundleConfig);//simone.misani@accenture.com 03/05/2019 RI-34                
                helper.setColumns(component, event, helper);  //simone.misani@accenture.com 03/05/2019 RI-34                   
                component.set("v.showTable",(responseParsed.profileName == 'Operation')? true : false); // antonio.vatrano antonio.vatrano@accenture.com set visibility of component for operation
            } 
            else if (state === "INCOMPLETE") {
            } 
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                            errors[0].message);
                    }
                } else {
                    console.log("****Unknown error");
                }
            }
        });
        
        $A.enqueueAction(action);
    },
    /*Simone Misani 
    simone.misani@accenture.com
    function for select  Button Datatable
    RI-34 
    03/05/2019*/
    showofferOrAttributes : function(component, event, helper){
        var eventId = event.getParam('action').name;
        console.log("ççç"+JSON.stringify(eventId));
        if(eventId == 'showOffer'){
            helper.showOffer(component,event,helper);
        }else if(eventId == 'showAttribute'){
            helper.showAttribute(component,event,helper);
        }else if(eventId == 'showEnablements'){          
            helper.showEnablements(component,event,helper);
            component.set('v.isToshowEnablements', true);
        }
    },
   
    filter : function (component, event, helper) {
        var mapFilter = helper.createMapFilter(component, event, helper);
        var posListFiltered = helper.filterPos(component, mapFilter);
        var pagobancomatListFiltered = helper.filterPagoBancomat(component, mapFilter);
        var acquiringListFiltered = helper.filterAcquaring(component, mapFilter);
        var posToFilter = component.get("v.posList");
        var pagobancomatToFilter = component.get("v.pagoList");
        var acquiringToFilter = component.get("v.acquiringList");
        var isFiltered = false;
        for(var k in mapFilter){
            if(mapFilter[k]){
                isFiltered = true;
            }
        }
        component.set("v.isFiltered", isFiltered);
        if(isFiltered){
            component.set("v.posListFiltered",posListFiltered);
            component.set("v.pagobancomatListFiltered",pagobancomatListFiltered);
            component.set("v.acquiringListFiltered",acquiringListFiltered);
        } else {
            component.set("v.posListFiltered",posToFilter);
            component.set("v.pagobancomatListFiltered",pagobancomatToFilter);
            component.set("v.acquiringListFiltered",acquiringToFilter);
        }
    }
})