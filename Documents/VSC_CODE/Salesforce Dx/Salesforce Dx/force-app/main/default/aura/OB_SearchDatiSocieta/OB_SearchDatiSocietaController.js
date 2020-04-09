({
    doInit : function(component, event , helper)
    {   
        //console.log("cmp.getElements(): ", component.getElements());
        
        //*********Variable to done an new Order  ******//
        var newOrder = component.get("v.objectDataMap.merchant.ShowButtonSP");
        if(newOrder !=null){
            component.set("v.showNewOrder",newOrder);
            component.set("v.hideFiscalCode",newOrder);
            component.set("v.objectDataMap.pv",{});
            component.set("v.objectDataMap.Configuration",{});
            component.set("v.objectDataMap.OrderHeader",{});
            component.set("v.objectDataMap.merchant.ShowButtonSP",null);
        }
        
        
        var appEvent = $A.get("e.c:OB_EventNextButton");
        var stepName = component.find("stepId").get("v.value");
        appEvent.setParams({"idStep" : stepName  });
        appEvent.fire();
        
        //**********METHOD TO RETRIEVE THE USER AND BANK ID**********//
        
        /*component.set("v.objectDataMap.BillingProfile1.OB_Bank_Account_Type__c" , "Credit");
		component.set("v.objectDataMap.BillingProfile2.OB_Bank_Account_Type__c" , "Debit");*/
        var actionGetBankId = component.get("c.getBankIdByUser");
        component.set("v.nameVat" , $A.get("$Label.NE.VAT"));
        var bankId = component.get("v.bankId");
        //var objectDataMap = component.get("v.objectDataMap");
        // action.setParams({userId : userId});
        actionGetBankId.setCallback(this, function(response) 
                                    {
                                        var state = response.getState();
                                        console.log("the state is: " + state);
                                        if (state === "SUCCESS") {
                                            
                                            component.set( "v.bankId",  response.getReturnValue());
                                            console.log("il bank Id is: " + component.get("v.bankId"));
                                            
                                        } else if (state === "INCOMPLETE") 
                                        {
                                            // do something
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
        $A.enqueueAction(actionGetBankId);
        
        //**********METHOD TO RETRIEVE THE ANNUAL REVENUE VALUE**********//
        
        var actionGetAnnualRevenueValues = component.get("c.getAnnualRevenueValues");
        var objectDataMap = component.get("v.objectDataMap");
        console.log("the vat not present into doInit is: " + objectDataMap.merchant.VAT_Not_Present__c);
        actionGetAnnualRevenueValues.setCallback(this, function(response) 
                                                 {
                                                     var state = response.getState();
                                                     if (state === "SUCCESS") {
                                                         var pickListValue = response.getReturnValue();
                                                         console.log("the picklistvalue is: " + pickListValue);
                                                         component.set( "v.annualRevenueList",  response.getReturnValue());
                                                         console.log("the annualRevenueList is: " + component.get("v.annualRevenueList"));
                                                         var test = component.get(" v.annualRevenueList");
                                                         
                                                         //**********METHOD TO RETRIEVE THE ANNUAL REVENUE VALUE WHEN USE PREVIOUS BUTTON**********//
                                                         if(objectDataMap.merchant.OB_Annual_Revenue__c=='Minore uguale di Euro 2.000.000,00')
                                                         {
                                                             document.getElementById(0).checked=true;
                                                         }else if(objectDataMap.merchant.OB_Annual_Revenue__c=='Maggiore di Euro 2.000.000,00')
                                                         {
                                                             document.getElementById(1).checked=true;
                                                         }
                                                     } 
                                                     else if (state === "INCOMPLETE") 
                                                     {
                                                         // do something
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
                                                             } else 
                                                             {
                                                                 console.log("Unknown error");
                                                             }
                                                         }
                                                 });
        $A.enqueueAction(actionGetAnnualRevenueValues);  
        
        
        
        //**********PREVIOUS BUTTON**********//
        var back = document.getElementsByClassName('slds-button slds-button--neutral'); 
        var objectDataMap = component.get("v.objectDataMap");
        
        for(var j = 0; j < back.length; j++){
            if(back[j].textContent == "< Previous"){  
                back[j].setAttribute("onclick","");
                back[j].onclick = function(){
                    if(document.getElementById("hiddenField")!= null){
                        document.getElementById("hiddenField").dispatchEvent(new Event('blur'));
                    }
                } 
            }
        }
        
        // call Event for set the aura:id of step in context
        //var appEvent = $A.get("e.c:appEvent");
        
        
        
        //appEvent.setParams({"idStep":component.find("step_container")});
        
        //var objectDataMap = component.get("v.objectDataMap");
    },
    //**********METHOT TO HAVE THE UPPERCASE INTO FISCAL CODE INPUT**********//
    
    upperCaseMethod:function(component, event , helper){
        var str = component.find('fiscalCode').get("v.value");
        var res = str.toUpperCase();
        component.find('fiscalCode').set("v.value" , res);
    },
    
    //**********METHOT WHEN I SEARCH A FISCAL CODE**********//
    handleClick: function(component, event , helper)
    {     
        //method to search the merchant
        component.set( "v.toggleSpinner" , true);
        
        var objectDataMap = component.get("v.objectDataMap");
        var fiscalCode = component.get("v.objectDataMap.merchant.NE__Fiscal_code__c");
        var bankId     = component.get("v.bankId");
        component.set("v.ErrorBooleanFiscalCode " , false);
        var fieldControlFiscalCode = new Map(); 
        
        
        
        //**********FISCAL CODE CONTROL START**********//
        if( fiscalCode!= null && ControllaCF(fiscalCode , fieldControlFiscalCode) != null){
            
            var changeClass = component.find('fiscalCode');
            console.log("try to print changeClass:  " + changeClass);
            $A.util.addClass(changeClass , 'errorClass');
            
            component.set("v.ErrorMessageFiscalCode",ControllaCF(fiscalCode , fieldControlFiscalCode));
            component.set("v.ErrorBooleanFiscalCode",true);
            console.log('Risult of function Javascript :' +  ControllaCF(fiscalCode , fieldControlFiscalCode));
            // fiscalCodeCmp.className= 'slds-has-error slds-input';
            
            //fiscalCodeCmp.after( ControllaCF(fiscalCode));
            
            /* myDiv = document.createElement('div');
						myDiv.setAttribute('id','errorId');
						myDiv.setAttribute('style','color:red;');*/
            if(ControllaCF(fiscalCode , fieldControlFiscalCode ) == 1){
                component.set("v.ErrorMessageFiscalCode" , $A.get("$Label.c.FiscalCodeLengthError"))  ;
                var changeClass = component.find('input-1');
                $A.util.addClass(changeClass , 'errorClass');
                component.set( "v.toggleSpinner" , false);
            }
            
            if(ControllaCF(fiscalCode , fieldControlFiscalCode) == 2){
                component.set("v.ErrorMessageFiscalCode" , $A.get("$Label.c.FiscalCodeCharactersError"));
                component.set( "v.toggleSpinner" , false);
            }
            
            if(ControllaCF(fiscalCode , fieldControlFiscalCode) == 3){
                component.set("v.ErrorMessageFiscalCode" , $A.get("$Label.c.FiscalCodeFormattingError"));
                component.set( "v.toggleSpinner" , false);
            }
            /*var errorMessage = document.createTextNode(errorCustomLabel);
						myDiv.appendChild(errorMessage);
						fiscalCodeCmp.after(myDiv);*/
            
        }else{
            //**********FISCAL CODE CONTROL END**********//
            var radioButtons2 =document.getElementById(0);
            //var radioButtons2= component.getGlobalId('0');
            console.log("the first button is: "+ JSON.stringify(radioButtons2));
            radioButtons2.checked=false;
            var radioButtons =document.getElementById(1);
            console.log("the second button is: "+ JSON.stringify(radioButtons));
            radioButtons.checked=false;
            
            var changeClass = component.find('fiscalCode');
            $A.util.removeClass(changeClass , 'errorClass');
            component.set("v.hideField" ,  false);
            var action = component.get("c.listAcc");
            fiscalCode = fiscalCode.trim();
            action.setParams({fiscalCode : fiscalCode , bankId : bankId});
            //action.setParams({bankId : bankId});
            console.log("fiscal code input: " + fiscalCode);
            console.log("the bank id is:: " + bankId);
            action.setCallback(this, function(response) 
                               {
                                   var state = response.getState();
                                   console.log("the state is: " + state);
                                   console.log("RESPONSE " + JSON.stringify(response.getReturnValue())); 
                                   
                                   if (state === "SUCCESS") {
                                       console.log("INTO SUCCESS STATE OF CLICK");
                                       component.set( "v.toggleSpinner" , false);
                                       console.log("RESPONSE " + JSON.stringify(response.getReturnValue()));    
                                       
                                       /*if(objectDataMap.merchant.OB_Annual_Revenue__c=='Minore uguale di Euro 2.000.000,00')
								   {
									   console.log("the objectDataMap.merchant.OB_Annual_Revenue__c is: "+ objectDataMap.merchant.OB_Annual_Revenue__c);
									   console.log("im into the second if");
									   var radioButtons2 =document.getElementById('0');
									   console.log("the second button is: "+ radioButtons2);
									   radioButtons2.removeAttribute('checked');
								   }else if(objectDataMap.merchant.OB_Annual_Revenue__c=='Maggiore di Euro 2.000.000,00'){
									   var radioButtons =document.getElementById('1');
									   console.log("the objectDataMap.merchant.OB_Annual_Revenue__c is: "+ objectDataMap.merchant.OB_Annual_Revenue__c);
									   radioButtons.removeAttribute('checked');
								   }*/
                                       var merchantNotSelected = response.getReturnValue()[0];
                                       var hideVat = component.find("vat2");
                                       var hideVatLabel= component.find("vatLabel"); 
                                       var vatValue = component.find("vat").get("v.value" );
                                       console.log("the selected recrt type is: " + JSON.stringify(merchantNotSelected.RecordTypeId));
                                       if(merchantNotSelected.Id==null){
                                           //**********IF THE ACCOUNT LIST IS EMPTY**********//
                                           component.set("v.objectDataMap.pv",{});
                                           objectDataMap.merchant.RecordTypeId=merchantNotSelected.RecordTypeId;
                                           objectDataMap.merchant.OB_New_Bank__c=merchantNotSelected.OB_New_Bank__c;
                                           console.log("INTO THE STATE SUCCESS WHEN THE ACC LIST IS NULL");
                                           component.set( "v.toggleSpinner" , false);
                                           component.set("v.disabledVat" , true);
                                           //component.set("v.showOtherInput" , true);
                                           component.set("v.hideField" ,  true);
                                           //console.log("the disabled vat is: " + component.get("v.disabledVat") );
                                           //console.log("the hide fielt is: " + component.get("v.hideField") );
                                           component.set("v.showButtons", false);
                                           
                                           objectDataMap.merchant.Id = null;
                                           var blankInput = document.getElementById('name');
                                           var blankInput2 = document.getElementById('vat');
                                           blankInput.value='';
                                           blankInput2.value='';
                                           console.log("the object data map ID is: " + JSON.stringify(objectDataMap.merchant.Id));
                                           component.set("v.showErrorIfNoMerchant" , true);
                                           
                                           /****SET VAT AND ANNUAL REVENUE INPUT IF INSERT A NEW FISCAL CODE*****/
                                           
                                           if(vatValue!='')
                                           {
                                               console.log("INTO THE SECOND CLICK");
                                               objectDataMap.merchant.OB_DescriptionVATNotPresent__c='';
                                               component.find("vat").set("v.value" , '');
                                               component.find("vatInput").set("v.checked" , false);
                                               component.set( "v.showModal" , false);
                                               $A.util.addClass(hideVat , 'slds-show');
                                               $A.util.removeClass(hideVat , 'slds-hide');
                                               $A.util.addClass(hideVatLabel , 'slds-show');
                                               $A.util.removeClass(hideVatLabel , 'slds-hide');
                                           }
                                       }
                                       else
                                       {
                                           /***IF THE ACCOUNT LIST ISN'T EMPTY***/
                                            component.set("v.showErrorIfNoMerchant" , false);
                                            component.set("v.hideField" ,  true);
                                           //if the searched merchant hasn't the vat//
                                           if(merchantNotSelected.OB_DescriptionVATNotPresent__c !='' &&  merchantNotSelected.OB_DescriptionVATNotPresent__c !=undefined)
                                           {
                                               var hideVat = component.find("vat2");
                                               var hideVatLabel= component.find("vatLabel"); 
                                               component.set( "v.showModal" , true);
                                              
                                               //**set read only name merchant and vat**//
                                               component.set("v.hideField" ,  true);
                                               $A.util.addClass(hideVat , 'slds-hide');
                                               $A.util.removeClass(hideVat , 'slds-show');
                                               $A.util.addClass(hideVatLabel , 'slds-hide');
                                               objectDataMap.merchant.OB_DescriptionVATNotPresent__c = merchantNotSelected.OB_DescriptionVATNotPresent__c ;
                                           }
                                           else 
                                           {
                                               //if the searched merchant has the vat//
                                               component.set("v.accountList", response.getReturnValue());  
                                               //component.set("v.hideField" ,  false);
                                               component.set("v.disabledVat" , true);
                                               component.set( "v.showModal" , false);
                                               document.getElementById("vatInput").checked=false;    
                                               
                                               $A.util.addClass(hideVat , 'slds-show');
                                               $A.util.removeClass(hideVat , 'slds-hide');
                                               $A.util.addClass(hideVatLabel , 'slds-show');
                                               $A.util.removeClass(hideVatLabel , 'slds-hide');
                                               console.log("the objectDataMap is" + JSON.stringify(objectDataMap));
                                           }
                                           console.log("the merchantNotSelected id is: " + JSON.stringify(merchantNotSelected));
                                           console.log("the merchantNotSelected annual revenue is: " + JSON.stringify(merchantNotSelected.OB_Annual_Revenue__c));
                                           //****set the input with values in DB****//
                                           objectDataMap.merchant.Name 				   =  merchantNotSelected.Name;
                                           objectDataMap.merchant.NE__Fiscal_code__c   =  merchantNotSelected.NE__Fiscal_code__c;
                                           objectDataMap.merchant.NE__VAT__c           =  merchantNotSelected.NE__VAT__c;
                                           objectDataMap.merchant.Id                   =  merchantNotSelected.Id;
                                           objectDataMap.merchant.OB_Annual_Revenue__c =  merchantNotSelected.OB_Annual_Revenue__c;
                                           //****autocomplete the radio input annual revenure****//
                                           if(objectDataMap.merchant.OB_Annual_Revenue__c=='Minore uguale di Euro 2.000.000,00')
                                           {
                                               document.getElementById(0).checked=true;
                                           }
                                           else if(objectDataMap.merchant.OB_Annual_Revenue__c=='Maggiore di Euro 2.000.000,00')
                                           {
                                               document.getElementById(1).checked=true;
                                           }
                                           
                                           document.getElementById("name").value   = objectDataMap.merchant.Name ;
                                           document.getElementById("vat").value    = objectDataMap.merchant.NE__VAT__c ;
                                           
                                           component.set("v.objectDataMap" , objectDataMap );
                                           //SHOW THE BUTTONS OF SEARCH AND NEW SERVICE POINT//
                                           component.set("v.showButtons", true);
                                           var hideVatInput= component.find("vatInput"); 
                                           hideVatInput.disabled = true;
                                           
                                           //component.set("v.hideFiscalCode", true);
                                       }
                                       
                                       
                                   }
                                   else if (state === "INCOMPLETE") 
                                   {
                                       // do something
                                       component.set( "v.toggleSpinner" , false);
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
                                           } else 
                                           {
                                               console.log("Unknown error");
                                           }
                                       }
                               });
            $A.enqueueAction(action);
            
            
        }
    },
    //**********METHOT TO REMOVE THE RED BORDER**********//
    removeRedBorder: function(component, event, helper) {
        var changeClass = component.find('fiscalCode');
        if($A.util.hasClass(changeClass , 'errorClass'))
        {
            $A.util.removeClass(changeClass , 'errorClass');
            component.set("v.ErrorMessageFiscalCode" , '');
        }
    },
    //**********METHOT WHEN I SELECT A RADIO BUTTON**********//
    getSelectedOption : function(component, event, helper) {
        
        console.log(" selected value: "+event.target.value);
        var selectedValue = event.target.value;
        
        var objectDataMap = component.get("v.objectDataMap");
        console.log(" objectDataMap merchant"+JSON.stringify(objectDataMap));
        objectDataMap.merchant.OB_Annual_Revenue__c = selectedValue;
        component.set("v.objectDataMap", objectDataMap);
        console.log(" objectDataMap con l'annual revenue "+JSON.stringify(objectDataMap));
        
    },
    //**********METHOT WHEN I GO BACK WITH PREVIOUS AND FIRE THE ONBLUR EVENT**********//
    clearForm: function(component, event, helper) {
        
        component.set( "v.showOtherInput ", true);
        component.set( "v.showButtons ", true);
        var objectDataMap = component.get("v.objectDataMap");
        console.log("the objdatamap after previous is: " + JSON.stringify(objectDataMap) );
        //IF THERE ISN'T THE VAT//
        if(objectDataMap.merchant.VAT_Not_Present__c==true){
            console.log("if of clearForm");
            component.set( "v.showModal" , true);
            component.set("v.hideField"  , false);
            component.set("v.disabledVat" , false);
            var hideVat = component.find("vat2");
            var hideVatLabel= component.find("vatLabel"); 
            $A.util.addClass(hideVat , 'slds-hide');
            $A.util.removeClass(hideVat , 'slds-show');
            $A.util.addClass(hideVatLabel , 'slds-hide');
            document.getElementById("vatInput").checked=true;
            
        }else{
            console.log("else of clearForm");
            component.set( "v.showModal" , false);
        }
        
        
        /*     if(objectDataMap.merchant.OB_Annual_Revenue__c!=''){
			console.log("the objectDataMap.merchant.OB_Annual_Revenue__c is: "+ objectDataMap.merchant.OB_Annual_Revenue__c);
					 var radioButtons =document.getElementById('0');
					console.log('buuuhhhh'+radioButtons);
					radioButtons.setAttribute('checked',true);
				   // radioButtons.checked=true;
		   
			console.log("the radioButtons length is : "+ radioButtons.length );
		  /*  for(var i = 0; i < radioButtons.length; i++){
				radioButtons[i].checked=true;
				console.log("radioButtons" + JSON.stringify(radioButtons[i]) );
			}
			//changeClass.checked=true;}
		}*/
        
        
    },
    //**********METHOT OF VAT CHECKBOX **********//
    vatCheck: function(component, event, helper) {
        
        var objectDataMap = component.get("v.objectDataMap");
        var vatInput= document.getElementById("vatInput");
        console.log("the vat Input is: " + vatInput.checked);
        var hideVat = component.find("vat2");
        var hideVatLabel= component.find("vatLabel"); 
        //IF I CHECK THE CHECKBOX//
        if(vatInput.checked){
            component.set( "v.showModal" , true);
            objectDataMap.merchant.VAT_Not_Present__c=true;
            $A.util.addClass(hideVat , 'slds-hide');
            $A.util.removeClass(hideVat , 'slds-show');
            $A.util.addClass(hideVatLabel , 'slds-hide');
            
        }
        else
            //IF I DONT CHECK THE CHECKBOX//
        {
            objectDataMap.merchant.VAT_Not_Present__c=false;
            console.log("into the checkbox else");
            component.set( "v.showModal" , false);
            $A.util.addClass(hideVat , 'slds-show');
            $A.util.removeClass(hideVat , 'slds-hide');
            $A.util.addClass(hideVatLabel , 'slds-show');
            $A.util.removeClass(hideVatLabel , 'slds-hide');
            objectDataMap.merchant.OB_DescriptionVATNotPresent__c='';
            console.log("THE VAT INTO UNCHECKED IS: " +  objectDataMap.merchant.NE__VAT__c) ;
            component.find("vat").set("v.value" , '');
            
        }
        
        //console.log("the merchant objDataMpa is: " + JSON.stringify(objectDataMap.merchant));
        
        
        
        
        var appEvent = $A.get("e.c:OB_EventNextButton");
        var stepName = component.find("stepId").get("v.value");
        var childCmp = component.get("v.showModal");
        appEvent.setParams({"idStep" : stepName , "ChildCmp1" : childCmp});
        
        console.log("the showModal in the vatCheck method is: " + component.get("v.showModal"));
        appEvent.fire();
        
        
        
        
    },
    
    beforeNext: function(component, event, helper) {
        var objectDataMap = component.get("v.objectDataMap");
        var contatore = 0;
        console.log("the objectDataMap.pv into before next is:" + JSON.stringify(objectDataMap.pv));
        /** BLOCK THE NEXT BUTTON IF THERE ISN'T A SERVICE POINT SELECTED**/
        if(objectDataMap.pv.Name=="")
        {
            component.set( "v.showPvErrorMessage", true);
            contatore++;
        }
        var listAuraId = document.getElementsByClassName('flow_required');
        document.getElementById("input:unbind:UNBIND4").value=""; 
        var objectDataMap = component.get("v.objectDataMap");
        for(var k=0;k<15;k++){
            var errorId ="errorId" + k;
            if(document.getElementById(errorId) != null){
                document.getElementById(errorId).remove();
            }
        }
        // var fieldMap = new Map();
        /* contatore for empty input required */
        
        var myDiv;
        console.log("the description is: " + component.get("v.objectDataMap.merchant.OB_DescriptionVATNotPresent__c"));
        
        console.log("the listAuraId is: " + listAuraId.length);
        for(var i=0;i<listAuraId.length;i++){
            var errorId = 'errorId' + i;
            listAuraId[i].className="flow_required";
            var listaId = listAuraId[i];
            var valueInput = (listAuraId[i].value).trim();
            var errorCustomLabel;
            if(valueInput === "" || component.get("v.objectDataMap.merchant.OB_DescriptionVATNotPresent__c")===""){
                
                errorCustomLabel = $A.get("$Label.c.Mandatory_Fields");
                helper.setErrore(listaId,errorCustomLabel,errorId,contatore);
                contatore++;
                component.set("v.ErrorMessageFiscalCode" , $A.get("$Label.c.FiscalCodeFormattingError"));
                /* listAuraId[i].className="slds-has-error flow_required";
                
                myDiv = document.createElement('div');
                myDiv.setAttribute('id',errorId);
                myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
                //component.set("v.ErrorMessageFiscalCode" , $A.get("$Label.c.FiscalCodeFormattingError"));
               
                var errorMessage = document.createTextNode(errorCustomLabel);
                myDiv.appendChild(errorMessage);
                listAuraId[i].after(myDiv);
                contatore++;*/
                
            }
            else if(valueInput !== "")
            {
                console.log("INTO THE ELSE IF OF FORMAL CONTROL");
                var showModal = component.get("v.showModal");
                console.log("the showModal vat is: " + showModal);
                console.log("the listAuraId vat is: " + listAuraId[i].getAttribute('id'));
                
                if(showModal !=true && listAuraId[i].getAttribute('id') == 'vat'){
                    
                    var fieldControlFiscalCode = new Map(); 
                    if( valueInput!= null && ControllaCF(valueInput,fieldControlFiscalCode) != null){
                        
                        if(ControllaCF(valueInput,fieldControlFiscalCode) ==1){
                            errorCustomLabel = $A.get("$Label.c.FiscalCodeLengthError");
                        }else if(ControllaCF(valueInput,fieldControlFiscalCode) == 2){
                            errorCustomLabel = $A.get("$Label.c.FiscalCodeCharactersError");
                        }else if (ControllaCF(valueInput,fieldControlFiscalCode) == 3){
                            errorCustomLabel = $A.get("$Label.c.FiscalCodeFormattingError");
                        }else{
                            
                        }
                        
                        helper.setErrore(listaId,errorCustomLabel,errorId,contatore);
                        contatore++;
                        
                        /*console.log('Risult of function Javascript :' +  ControllaCF(valueInput,fieldControlFiscalCode));
                        listAuraId[i].className="slds-has-error flow_required";
                        
                        //fiscalCodeCmp.after( ControllaCF(fiscalCode));
                        
                        myDiv = document.createElement('div');
                        myDiv.setAttribute('id',errorId);
                        myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;' );
                        
                        var errorMessage = document.createTextNode(errorCustomLabel);
                        myDiv.appendChild(errorMessage);
                        listAuraId[i].after(myDiv);
                        contatore++;*/
                        
                    }
                    
                }
                //myDiv = document.createElement('div');
                //myDiv.setAttribute('id',errorId);
                //myDiv.setAttribute('style','color:rgb(194, 57, 52); position: absolute;  z-index: 1; ');
                
                if(listAuraId[i].getAttribute('id') == 'mcc'){
                    
                    if(isNaN(valueInput) || valueInput.includes(" ")){
                        /*listAuraId[i].className="slds-has-error flow_required";
                       
                        var errorMessage = document.createTextNode(errorCustomLabel);
                        myDiv.appendChild(errorMessage);
                        listAuraId[i].after(myDiv);
                        contatore++;*/
                        errorCustomLabel = $A.get("$Label.c.MCC_Error_Message");
                        helper.setErrore(listaId,errorCustomLabel,errorId,contatore);
                        contatore++;
                        
                    } 
                    
                }
                if(component.get("v.objectDataMap.merchant.NE__VAT__c") =="")
                {
                    //check if the input into  company type is correct//
                    console.log("failed to insert the type");
                    /*listAuraId[i].className="slds-has-error flow_required";
                    
                    var errorMessage = document.createTextNode(errorCustomLabel);
                    myDiv.appendChild(errorMessage);
                    listAuraId[i].after(myDiv);
                    contatore++;*/
                    errorCustomLabel = $A.get("$Label.c.Not_Valid_Company_Type");
                    helper.setErrore(listaId,errorCustomLabel,errorId,contatore);
                    contatore++;
                }
                
                //helper call from normalisation of addresses
                
                //helper.normalisationPv(component , helper , event );
                //console.log("obj pv in controller : " + JSON.stringify(objectDataMap.pv));
                
                
                //****************************************************************************************************************************//
                //***************************************************************HELPER METHOD***********************************************//
                
                var field = 'norma';
                
                //*****GET THE INPUT VALUE AND TRANSFORM THE SPACE IN %20****//
                var provincia    = encodeURI(document.getElementById("provincia").value);
                var cap          = encodeURI(document.getElementById("Zipcode").value);
                var comune       = encodeURI(document.getElementById("comune").value);
                var frazione     = encodeURI(document.getElementById("frazione").value);
                var via          = encodeURI(document.getElementById("strada").value);
                var civico       = encodeURI(document.getElementById("civico").value);
                var url = '/doNormJSON?provincia='+provincia+ '&cap='+cap+'&localita='+comune+'&localitaaggiuntiva='+frazione+'&indirizzo='+encodeURI(via+civico);
                
                console.log("AFTER URL" + url);
                
                var objectDataMap = component.get("v.objectDataMap");
                console.log("OBJ PV BEFORE SUCCESS IS : " + JSON.stringify(objectDataMap.pv));
                var action = component.get("c.getReturnNormalisation");
                action.setParams({"url" : url , "field" : field });
                action.setCallback(this, function(response) 
                                   {
                                       var state = response.getState();
                                       console.log("the helper state of normalisationPis: " + state);  
                                       if (state === "SUCCESS")
                                       {
                                           console.log("helepr response ---> "+ JSON.stringify(response.getReturnValue()));
                                           var response = response.getReturnValue();
                                           
                                           for (var valueMap in response)
                                           {
                                               console.log("for helper datiPostali: " + JSON.stringify(response[valueMap].DatiPostali));
                                               
                                               //****SET OBJDATA MAP WITH THE VALUE FROM POSTEL****//
                                               //using the inverse method to delete %20//
                                               objectDataMap.pv.NE__City__c    = decodeURI(response[valueMap].DatiPostali.ComuneUfficiale);
                                               objectDataMap.pv.NE__Province__c= decodeURI(response[valueMap].Descrizioni.Provincia);
                                               objectDataMap.pv.OB_District__c= decodeURI(response[valueMap].DatiPostali.FrazioneUfficiale);
                                               objectDataMap.pv.NE__Street__c  = decodeURI(response[valueMap].DatiPostali.ViaCompletaUfficiale);
                                               objectDataMap.pv.OB_Street_Number__c =decodeURI(response[valueMap].DatiPostali.CivicoPostale);
                                               //****CONTROL IF THE POSTALCODE INPUT IS THE SAME OF POSTEL FISCAL CODE****///
                                               if(cap == response[valueMap].DatiPostali.CAP){
                                                   objectDataMap.pv.NE__Postal_Code__c= decodeURI(response[valueMap].DatiPostali.CAP);
                                               }
                                               component.set("v.objectDataMap" , objectDataMap);
                                               console.log("OBJ PV IS : " + JSON.stringify(objectDataMap.pv));
                                               //this.saveServicePointData(step , data , key , targetObjectKey , method ,  stepsDefinition , dynamicWizardWrapper);
                                               
                                               
                                           }
                                       } 
                                       else if (state === "INCOMPLETE") 
                                       {
                                           // do something
                                           component.set( "v.toggleSpinner" , false);
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
                $A.enqueueAction(action);
                
                //****************************************************************************************************************************//
                //****************************************************************************************************************************//
                
                
                if(component.get("v.objectDataMap.pv.NE__Province__c") == null){
                    // messaggio di errore
                    console.log('la normalizazzione dell indirizzo non è andato a buon fine');
                    //contatore++;
                }
                
                //console.log("obj pv in controller : " + JSON.stringify(objectDataMap.pv));
            }
            
        }
        
        console.log('length of contatore ' + contatore);
        
        if(contatore == 0){
            console.log("INTO CONTATORE==0");
            var step=1; 
            var data = {};
            var key='Object';
            data[key] = component.get("v.objectDataMap");
            console.log("the data key is: " + JSON.stringify(data['Object']) + " AND THE OBJ IS: " + JSON.stringify(component.get("v.objectDataMap")));
            var targetObjectKey = component.get("v.objectKey");
            var method = 'createConfiguration'; 
            var stepsDefinition= null;
            var dynamicWizardWrapper = null;
            //chiamo helper
            // helper.saveServicePointData( component , step , data , key , targetObjectKey , method ,  stepsDefinition , dynamicWizardWrapper);
            var action = component.get("c.insertData");
            console.log("HO CHIAMATO IL METODO");
            action.setParams({"step" : step , "data" : data , "targetObjectKey" : targetObjectKey ,"method" : method , "stepsDefinition":stepsDefinition , "dynamicWizardWrapper" : dynamicWizardWrapper });
            action.setCallback(this, function(response) 
                               {
                                   var state = response.getState();
                                   console.log("THE STATE OF CONTATORE ==0 IS: " + state);
                                   if (state === "SUCCESS")
                                   {
                                       console.log("RESPONSE BEFORE NEXT " + JSON.stringify(response.getReturnValue()));
                                       component.set("v.objectDataMap",response.getReturnValue());
                                       
                                   }
                                   
                                   else if (state === "INCOMPLETE") 
                                   {
                                       // do something
                                       component.set( "v.toggleSpinner" , false);
                                   }
                                       else if (state === "ERROR") 
                                       {
                                           console.log('ERROR IN CONTATORE ZERO');
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
            
            $A.enqueueAction(action);
            component.set("v.objectDataMap.unbind.UNBIND4", 'Next');
            document.getElementById("input:unbind:UNBIND4").value= 'Next'; 
            if(document.getElementById('input:unbind:UNBIND4')!= null){
                document.getElementById('input:unbind:UNBIND4').dispatchEvent(new Event('blur'));
            }
            
        }
    },
    //**********METHOD TO RETRIEVE AN ATTRIBUTE FROM A CHILD COMPONENT**********//
    //when I click a button into child component, the error message disappears  //
    handleErrorEvent: function(component, event, helper) {
        console.log("INTO THE PARENT EVENT");
        var value = event.getParam("showPvErrorMessage");
        component.set( "v.showPvErrorMessage", false);
    }
    
    
    
})