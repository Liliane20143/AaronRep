({
   
    doInit : function(component, event , helper)
    {   
        
        console.log('loaded resource fiscalCode');  
        /* inizializzo la Static Resource 
        jQuery("document").ready(function(){
           
        }  */
        component.set("v.objectDataMap.BillingProfile1.OB_Bank_Account_Type__c" , "Credit");
        component.set("v.objectDataMap.BillingProfile2.OB_Bank_Account_Type__c" , "Debit");
     
        /*  console.log("sono del doInit");
        var nextButton = document.getElementsByClassName('slds-button slds-button--brand');
        console.log("nextButton :"+nextButton);
        for (var i = 0; i < nextButton.length; i++) 
        {
            //console.log("NextButton disabled before setAttribute "+nextButton[i].disabled);
            nextButton[i].setAttribute("disabled","");
            nextButton[i].disabled = false;
            
        } */
    },
    
     closeModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "False"  
        component.set("v.isOpen", false);
    },
    
    handleClick : function(component, event, helper){
        console.log('sono nel js' );
        
        //boolean to open the Modal table
        component.set("v.isOpen", true);
        
        var fiscalCode = component.get("v.codiceFiscale");
        var action = component.get("c.listAcc");
        
        var accountList = component.get("v.accountList");
        console.log("accountList : " + accountList);
        fiscalCode = fiscalCode.trim();
        console.log("fiscal code input: " + fiscalCode);
        component.set('v.triggleSpinner', true);
        action.setParams({fiscalCode : fiscalCode});
        action.setCallback(this, function(response) 
                           {
                               var state = response.getState();
                               if (state === "SUCCESS") {
                                component.set("v.triggleSpinner", false);
                                   console.log("RESPONSE " + JSON.stringify(response.getReturnValue()));
                                   //controllo sulla non presenza di un cliente legato al codice fiscale
                                   
                                   if(response.getReturnValue().length === 0){
                                       console.log("sta funzionando l'alert");
                                       component.set("v.showError", true);
                                       
                                       //slds-show -->   Mostra l'elemento impostando la proprietà di visualizzazione su block
                                       //slds-hide -->   nasconde un elemento dalla pagina impostando la visualizzazione corretta a none
                                       
                                       $A.util.removeClass(document.getElementById("contenitoreMessage"), 'slds-hide');
                                       $A.util.addClass(document.getElementById("contenitoreMessage"), 'slds-show'); 
                                       console.log("mostro il messaggio");

                                   }else{
                                       component.set("v.showError", false);

                                   }
                                   
                                   
                                   
                                   component.set("v.accountList", response.getReturnValue()); 
                                    var accountList = component.get("v.accountList");
                                   console.log("mostro v.accountList: ",JSON.stringify(accountList));
                                   component.set('v.columns', [
                                       {label: $A.get("$Label.NE.name"),fieldName: 'Name',   type: 'text'},
                                       {label: $A.get("$Label.c.FiscalCode"),fieldName: 'NE__Fiscal_code__c', type: 'text'},
                                       {label: $A.get("$Label.NE.VAT"),fieldName: 'NE__VAT__c', type: 'text'}
                                       
                                   ]);
                               }
                               else if (state === "INCOMPLETE") {
                                   // do something
                               }
                                   else if (state === "ERROR") {
                                       var errors = response.getError();
                                       if (errors) {
                                           if (errors[0] && errors[0].message) {
                                               console.log("Error message: " + 
                                                           errors[0].message);
                                           }
                                       } else {
                                           console.log("Unknown error");
                                       }
                                   }
                           });
        $A.enqueueAction(action);
    }, 
    
    getSelectedAccount : function(component, event, helper)
    {
        var selectedRows = event.getParam('selectedRows');
        var nextButton = document.getElementsByClassName('slds-button slds-button--brand');
              
        
        if(selectedRows.length===1)
        {
			//close modal  after select a service point
            component.set("v.isOpen", false);	
            
            var objectDataMap = component.get("v.objectDataMap");
            component.get("v.objectDataMap.merchant.Name");
            console.log("la selectedRows è: " + JSON.stringify(selectedRows));
            var a = selectedRows[selectedRows.length-1];
            console.log("il nome di a è: " + a.Name);
            console.log("il fiscal code è:: " + a.NE__Fiscal_code__c);
            console.log("il VAT è: " + a.NE__VAT__c);
            console.log("l'ID è: " + a.Id);
            //comunico con il flusso
            objectDataMap.merchant.Id=a.Id;
            console.log("ID del objDataMap è : " + objectDataMap.merchant.Id );
            objectDataMap.merchant.Name = a.Name;
            objectDataMap.merchant.NE__Fiscal_code__c = a.NE__Fiscal_code__c;
            objectDataMap.merchant.NE__VAT__c = a.NE__VAT__c;
            component.set("v.objectDataMap" , objectDataMap );
            console.log("l'objectdataMap è : " + JSON.stringify(objectDataMap));
        }
        if(selectedRows.length===0){
            component.set("v.objectDataMap.merchant.Name" , "");
            component.set("v.objectDataMap.merchant.NE__Fiscal_code__c" , "");
            component.set("v.objectDataMap.merchant.NE__VAT__c" , "");
            component.set("v.objectDataMap.merchant.Id" , "");
        }
    }
 

})