({
    doInit: function(component, event, helper) {
        console.log("parent aura:id " + component.find("item1"));
        var back = document.getElementsByClassName('slds-button slds-button--neutral'); 
        var objectDataMap = component.get("v.objectDataMap");
        var fieldControlFiscalCode = new Map();
        
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
        
        //var fiscalCode = component.get("v.objectDataMap.merchant.NE__Fiscal_code__c");
        var nextButton = document.getElementsByClassName('slds-button slds-button--brand');
        var fiscalCodeCmp ;
        var unbindFiscalCode;
        
        
        for(var i = 0; i < nextButton.length; i++){
            console.log('backButton[i] :'+nextButton[i].textContent);
            var myDiv;
            var sex;
            var nascita;
            var giornoNascita;
            var meseNascita;
            var annoNascita;
            var cognome,nome;
            var errorCustomLabel;
            var frameNascita;
            if(nextButton[i].textContent == "Next >"){  
                nextButton[i].setAttribute("onmouseover","");
                nextButton[i].onmouseover = function(){
                    console.log('onmouseover next button');
                }
                nextButton[i].setAttribute("onclick","");
                nextButton[i].onclick = function(){
                    console.log('onclick next button');
                    var frame=document.getElementsByClassName('slds-grid slds-wrap sectionColsContainer')[0];
                    console.log('frame ' + frame.textContent);
                    var frameComponent = frame.getElementsByClassName('slds-input');
                    frameNascita = frame.getElementsByClassName('slds-input input');
                    for(var i=0;i<frameNascita.length;i++){
                       console.log('frameNascita id ' + frameNascita[i].getAttribute('id')); 
                    }
                    
                    
                    for(var j = 0; j <frameComponent.length ; j++){
                        console.log('frameComponent id ' + frameComponent[j].getAttribute('id'));
                        if(frameComponent[j].getAttribute('id') == "input:merchant:NE__Fiscal_code__c"){
                            fiscalCodeCmp = frameComponent[j];
                            fiscalCodeCmp.className= 'slds-input';
                            var fiscalCode= frameComponent[j].value;
                        }
                        
                        if(frameComponent[j].getAttribute('id') == "input:unbind:UNBIND5"){
                            unbindFiscalCode =frameComponent[j];
                            unbindFiscalCode.value='';
                            
                        }
                        
                        if(frameComponent[j].getAttribute('id') == "input:unbind:UNBIND8"){
                            sex =frameComponent[j].value; 
                            if(sex!=null && sex!=""){
                             fieldControlFiscalCode.set("sex",sex);
                            }
                            
                        }
                        
                        /*if(frameComponent[j].getAttribute('id') == "input:unbind:UNBIND9"){
                            giornoNascita =frameComponent[j].value;      
                        }
                        
                        if(frameComponent[j].getAttribute('id') == "input:unbind:UNBIND10"){
                            meseNascita =frameComponent[j].value;      
                        }
                        
                        if(frameComponent[j].getAttribute('id') == "input:unbind:UNBIND11"){
                            annoNascita =frameComponent[j].value;      
                        } */
                        
                        if(frameComponent[j].getAttribute('id') == "input:unbind:UNBIND12"){
                            cognome =frameComponent[j].value;  
                            if(cognome !=null && cognome!=""){
                             fieldControlFiscalCode.set("cognome",cognome);
                            }
                        }
                        
                        if(frameComponent[j].getAttribute('id') == "input:unbind:UNBIND13"){
                            nome =frameComponent[j].value; 
                            console.log("nome value " + nome);
                            if((nome !=null) && (nome != "")){
                             fieldControlFiscalCode.set("nome",nome);
                            }
                        }
                        
                        if(frameComponent[j].getAttribute('id') == frameNascita[0].getAttribute('id')){
                            var nascita= frameComponent[j].value;
                            if(nascita !=null && nascita!= "" ){
                            var splitNascita = nascita.split("-");
                            giornoNascita = splitNascita[2];
                            meseNascita = splitNascita[1];
                            annoNascita = splitNascita[0];  
                            console.log('nascita split ' + giornoNascita + " " + meseNascita + " " +  annoNascita);
                            fieldControlFiscalCode.set("giorno",giornoNascita);
                            fieldControlFiscalCode.set("mese", meseNascita);
                            fieldControlFiscalCode.set("anno",annoNascita);
                        }
                        }
                    }
                    
                    if(document.getElementById('errorId') != null){
                        document.getElementById('errorId').remove();
                    }
                    
                    
                    if( fiscalCode!= null && ControllaCF(fiscalCode,fieldControlFiscalCode) != null){
                        
                        console.log('Risult of function Javascript :' +  ControllaCF(fiscalCode,fieldControlFiscalCode));
                        fiscalCodeCmp.className= 'slds-has-error slds-input';
                        
                        //fiscalCodeCmp.after( ControllaCF(fiscalCode));
                        
                        myDiv = document.createElement('div');
                        myDiv.setAttribute('id','errorId');
                        myDiv.setAttribute('style','color:red;');
                        if(ControllaCF(fiscalCode,fieldControlFiscalCode) ==1){
                            errorCustomLabel = $A.get("$Label.c.FiscalCodeLengthError");
                        }else if(ControllaCF(fiscalCode,fieldControlFiscalCode) == 2){
                            errorCustomLabel = $A.get("$Label.c.FiscalCodeCharactersError");
                        }else if (ControllaCF(fiscalCode,fieldControlFiscalCode) == 3){
                            errorCustomLabel = $A.get("$Label.c.FiscalCodeFormattingError");
                        }else{
                            errorCustomLabel = ControllaCF(fiscalCode,fieldControlFiscalCode);
                            console.log('error result : ' + errorCustomLabel);
                        }
                        var errorMessage = document.createTextNode(errorCustomLabel);
                        myDiv.appendChild(errorMessage);
                        fiscalCodeCmp.after(myDiv);
         
                    }
                    if( fiscalCode!= null && ControllaCF(fiscalCode,fieldControlFiscalCode) == null){
                        unbindFiscalCode.value ='NextFiscal'; 
                        component.set("v.objectDataMap.unbind.UNBIND5", unbindFiscalCode.value);
                        component.set("v.objectDataMap",objectDataMap);
                        
                        unbindFiscalCode.dispatchEvent(new Event('blur'));
                        
                    }
                    console.log("objectDataMap after control "+ JSON.stringify(objectDataMap));
                    
                } 
            }
        }  
        
    }
})