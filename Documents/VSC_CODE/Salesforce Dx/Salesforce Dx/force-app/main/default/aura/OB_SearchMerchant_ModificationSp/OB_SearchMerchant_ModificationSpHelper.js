({
	normalisationPv : function(component , helper , event ) {
		console.log("HELPER METHOD");
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
    console.log("OBJ PV BEFOR SUCCESS IS : " + JSON.stringify(objectDataMap.pv));
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
                                        console.log("OBJ PV 2 IS : " + JSON.stringify(objectDataMap.pv));
                                        
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
        
	},

  /*saveServicePointData : function(component ,step , data , key , targetObjectKey , method ,  stepsDefinition , dynamicWizardWrapper ){
            console.log("INTO HELPER SAVEeeeee");
             
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
                                       //var unbind = document.getElementById("input:unbind:UNBIND4");
                                       /*component.set("v.objectDataMap.unbind.UNBIND4", 'Next');
                                   document.getElementById("input:unbind:UNBIND4").value= 'Next'; 
                                   if(document.getElementById('input:unbind:UNBIND4')!= null){
                                      document.getElementById('input:unbind:UNBIND4').dispatchEvent(new Event('blur'));
                                   }
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

  },*/
  setErrore : function(listaId , customLabel, errorId ){
               listaId.className="slds-has-error flow_required";
               
               

                myDiv = document.createElement('div');
                myDiv.setAttribute('id',errorId);
                myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');

                var errorCustomLabel = customLabel;
                var errorMessage = document.createTextNode(errorCustomLabel);
                myDiv.appendChild(errorMessage);
                listaId.after(myDiv);
                

    },
})