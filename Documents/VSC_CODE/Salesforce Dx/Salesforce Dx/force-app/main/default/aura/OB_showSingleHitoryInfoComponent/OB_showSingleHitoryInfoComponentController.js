({
    doInit : function(component, event, helper) {
        var wizardPendingMap = component.get("v.pendingWizardsMap");
        var currentKey = component.get("v.currentKey");
        console.log("currentKey:"+currentKey);
        console.log("Map in singleHistoryInfo:"+JSON.stringify(wizardPendingMap));
        var currentHistoryInfos = wizardPendingMap[currentKey];
        console.log("currentHistoryInfo"+JSON.stringify(currentHistoryInfos));
        component.set("v.currentHistoryInfos",currentHistoryInfos);
        
        
    },
    resumeWizard : function(cmp,event,helper){
        var showWizardEvent = cmp.getEvent("showWizardEvent");
        var currentKey = cmp.get("v.currentKey");
        var currentHistory = event.getSource().get("v.name");
        //var currentHistory = cmp.get("v.currentHistoryInfo.Id");
        console.log("history that i will pass:"+JSON.stringify(currentHistory));
        showWizardEvent.setParams({
            wizardId : currentKey,
            historyId : currentHistory.Id
        });
        showWizardEvent.fire();
        /*
        var wizardId = cmp.get("v.currentKey");
        var objectType = cmp.get("v.objectType");
        var recordId = cmp.get("v.recordID");
        $A.createComponent(
            "c:runMerchantWizard",
            {
                "wizardId": wizardId
            },
            
            function(newCmp, status, errorMessage){
                if (status === "SUCCESS") {
                    var body = cmp.get("v.body");
                    body.push(newCmp);
                    cmp.set("v.body", body);
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                }
                    else if (status === "ERROR") {
                        console.log("Error: " + errorMessage);
                    }
            }     
        );
        */
    }
})