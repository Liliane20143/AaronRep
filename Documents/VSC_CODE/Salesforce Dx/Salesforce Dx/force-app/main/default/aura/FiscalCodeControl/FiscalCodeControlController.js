({
    doInit: function(component, event, helper) {
        
        var objectDataMap = component.get("v.objectDataMap");
        console.log("objectDataMap: "+ JSON.stringify(objectDataMap));
        var FiscalCode = component.get("v.objectDataMap.merchant.NE__Fiscal_code__c");
        console.log("objectDataMap FiscalCode: "+ FiscalCode);
        
        var nextButton = document.getElementsByClassName('slds-button slds-button--brand');
        console.log("nextButton: "+ JSON.stringify(nextButton));
        for(var i = 0; i < nextButton.length; i++){
            console.log('sono nel fiscal code control');
            console.log('backButton[j] :'+nextButton[i].textContent);
            if(nextButton[i].textContent == "Next >"){  
                console.log('sono nel next button');
                nextButton[i].setAttribute("onclick","");
                nextButton[i].onclick = function(){
                    if(FiscalCode != null){
                        document.getElementById("hiddenFiscal").dispatchEvent(new Event('blur'));
                    }
                } 
            }
        }  
        
    }
})