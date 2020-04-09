({
    doInit : function (component, event, helper) {
        var objectDataMap = component.get("v.objectDataMap" );
        console.log("object data map in search mobile: " + JSON.stringify(objectDataMap));
        //  STRAT antonio.vatrano 05/12/2019 PERF - 2
        // component.set("v.objectDataMap.Referente_TecnicoPV.Id", '');
        // component.set("v.objectDataMap.Responsabile_Amm_PV.Id", '');
        // component.set("v.objectDataMap.Responsabile_PV.Id", '');
        //  END antonio.vatrano 05/12/2019 PERF - 2
    },

    filterByContactPhone : function (component, event, helper) { 
        
        var objectDataMap = component.get("v.objectDataMap" );
        var addressMapp   = component.get("v.addressMapping");
        var inputPhone = component.find("inputPhone").get("v.value");
        var addressMappPosition   = addressMapp.position;
        console.log("addressMapping : " + addressMapp);
        /*SETTAGGIO VARIABILE BOOLEANA PER  MOSTRARE TABELLA AL CLICK DEL BOTTONE SEARCH  Referente_Tecnico_PV*/
        //**GIOVANNI SPINELLI 05/10/2018 START**//
        //DEFECT SIT131**MAKE EDITABLE THE FIELD
        /*
          BECAUSE OF THIS COMPONENT IS USED THREE TIME IN THE SAME PAGE
          IT SETTED A VALUE OF ADDRESS MAPPING TO UNDESTEND IN WHICH
          CASE WE ARE
         */
        if(component.get("v.input")!='' && addressMappPosition== 'ReferenteTecnico' )
        {
            //THE UNBIND HAS A DEFAULT VALUE TO PERMIT TO GO TO NEXT STEP   
            //DELETE THE DEFAULT VALUE AND REPLACE WITH NEW VALUE
            //position : ReferenteTecnico
            document.querySelectorAll('input[id$="input:unbind:DisableInputReferenteTecnico"]')[0].value='';
            //document.getElementById('input:unbind:DisableInputReferenteTecnico').value='';
            objectDataMap.unbind.DisableInputReferenteTecnico='PHONE3'
            console.log("objectDataMap.unbind.DisableInputReferenteTecnico ; " + objectDataMap.unbind.DisableInputReferenteTecnico);
           document.querySelectorAll('input[id$="input:unbind:DisableInputReferenteTecnico"]')[0].value='';
        }
        else if(component.get("v.input")!='' && addressMappPosition== 'ResponsabileAmministrativo')
        {
            //position : ResponsabileAmministrativo 
             document.querySelectorAll('input[id$="input:unbind:DisableInputResponsabileAmministrativo"]')[0].value='';
            objectDataMap.unbind.DisableInputResponsabileAmministrativo='PHONE2'
            document.querySelectorAll('input[id$="input:unbind:DisableInputResponsabileAmministrativo"]')[0].dispatchEvent(new Event('blur'));;
            //document.getElementById('input:unbind:DisableInputResponsabileAmministrativo').dispatchEvent(new Event('blur'));
        }
        else if(component.get("v.input")!='' && addressMappPosition== 'ResponsabilePuntoVendita')
        {
            //position : ResponsabilePuntoVendita
            document.querySelectorAll('input[id$="input:unbind:DisableInputResponsabilePuntoVendita2"]')[0].value=''; 
            objectDataMap.unbind.DisableInputResponsabilePuntoVendita2='PHONE1'
            document.querySelectorAll('input[id$="input:unbind:DisableInputResponsabilePuntoVendita2"]')[0].value='';
        }
        
        //**GIOVANNI SPINELLI 05/10/2018 END**//
        
        var addressMapp = component.get("v.addressMapping");
        console.log("addressMap in search phone is: " + addressMapp);
        var RTDeveloperName = addressMapp.RTDeveloperName;
        var objectDataNode = addressMapp.objectDataNode;
        console.log('RTDeveloperName is: ' + RTDeveloperName + '---- ' +  'my objdatanode is:'  + objectDataNode);
        console.log("objectDataMap for Service Point search:"+JSON.stringify(objectDataMap));

        var merchantId = objectDataMap.merchant.Id;

        var bankId = objectDataMap.actualBank;
        let servicePointId = objectDataMap.pv.Id; //NEXI-102 Zuzanna Urban 28/05/2019 Take service point to where condition
        var searchInputCMP = component.find('inputPhone');
		component.set("v.showSection" , true );
        
        var searchInput = searchInputCMP.get("v.value");
		var methodSearch = component.get("c.serverFilterByContactPhone");
		console.log('@@@ my input is: ' + searchInput);
        
        //**ANDREA MORITTU 18/10/2018 START**//
		/* LOGICA PER IGNORARE IL +39 o IL 0039 */
		var input_cleared = null;
        if (searchInput!= undefined && searchInput!=null && searchInput!='') {
            if(searchInput.length >= 4 && searchInput.substring(0,4) == '0039') {
                input_cleared = searchInput.substring(4,searchInput.length-1);
            } else if(searchInput.length >= 3 && searchInput.substring(0,3) == '+39'){
                input_cleared= searchInput.substring(3,searchInput.length-1);
            }else if(searchInput.length >=0){
            	input_cleared= searchInput;
        	} 
        }
        
        console.log('PARAMS: ');
        
        console.log('input_cleared '	+	input_cleared);
        console.log('merchantId '		+ 	merchantId);
        console.log('bankId '			+	bankId);
        console.log('RTDeveloperName '	+	RTDeveloperName);
        console.log('servicePointId '	+	servicePointId); //NEXI-102 Zuzanna Urban 28/05/2019 Take service point to where condition
        methodSearch.setParams({ inputCel : input_cleared, merchantId : merchantId, bankId : bankId, servicePointId : servicePointId, RTDeveloperName : RTDeveloperName}); //NEXI-102 Zuzanna Urban 28/05/2019 Take service point to where condition
        methodSearch.setCallback(this, function(response) {
            var state = response.getState();
			if(state ==="SUCCESS"){
                console.log('objectdatamap OB_SearchMobile '    +   JSON.stringify(objectDataMap));
                console.log('The response is OK');
                var contactList = response.getReturnValue();
                console.log('contactList: ' + contactList + 'length: ' + contactList);
                //**ANDREA MORITTU 18/10/2018 END**//
                //IF THERE IS A CONTACT WITH THE PHONE INPUT
                if (contactList!=null)
                {
                    component.set("v.hasMessage" , false); 
	                if(contactList.length < 1){
	                    console.log('The result lenght is: ' + contactList);
                        
	                    return;
	                } else if(contactList.length == 1 ) {
	                    
	                    console.log('@@@ contactList size is:  ' + contactList.length + ' contactList.FirstName ' +  contactList[0].FirstName);
	                    objectDataMap[objectDataNode].FirstName = contactList[0].FirstName;
	                    console.log('@@@ contactList size is:  ' + contactList.length + ' contactList.LastName ' +  contactList[0].LastName);
	                    objectDataMap[objectDataNode].LastName = contactList[0].LastName;
	                    console.log('@@@  contactList size is:  ' + contactList.length + ' contactList.Email ' +  contactList[0].Email);
	                    objectDataMap[objectDataNode].Email = contactList[0].Email;
	                    console.log('@@@ contactList size is:  ' + contactList.length + ' contactList.MobilePhone ' +  contactList[0].MobilePhone);
                        objectDataMap[objectDataNode].MobilePhone = contactList[0].MobilePhone;

                        // Doris Dongmo - fix HomePhone and Phone for contact step P.Vendita - 04/06/2019 - Start 
                        objectDataMap[objectDataNode].Phone     = contactList[0].MobilePhone;
                        objectDataMap[objectDataNode].HomePhone = contactList[0].MobilePhone;
                        // Doris Dongmo - fix HomePhone and Phone for contact step P.Vendita - 04/06/2019 - End 
						
	                    console.log('@@@ objectdataMap is populated with : ' + JSON.stringify(objectDataMap));
	                    objectDataMap[objectDataNode].RecordTypeId = contactList[0].RecordTypeId;

                        objectDataMap[objectDataNode].Id = contactList[0].Id;
                        console.log('@@@ obj id:  ' + objectDataMap[objectDataNode].Id + ' contactList.id ' +  contactList[0].Id);
	                }
                }
                else
                //IF THERE ISN'T A CONTACT WITH THE PHONE INPUT
                {

                    component.set("v.hasMessage" , true); 
                    //giovanni spinelli - showToast - 21/03/2019 - start
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({

                        "type" 		: 'warning',
                        "message"	: $A.get("$Label.c.OB_NoContactPhone")
                    });
                    toastEvent.fire();
                     //giovanni spinelli - showToast - 21/03/2019 - end
                    component.set("v.messagetoshow" , $A.get("$Label.c.OB_NoContactPhone"));
                    //CLEAR THE INPUT IF THEY ARE ALREADY COMPILED WITH A PREVIOUS RESEARCH
                    
                    //CLEAR EACH ID IN ACCORDING TO THE SECTION
                    if(addressMappPosition== 'ReferenteTecnico' )
                    {
                        objectDataMap.Referente_TecnicoPV.FirstName  ='';
                        objectDataMap.Referente_TecnicoPV.Email      ='';
                        objectDataMap.Referente_TecnicoPV.LastName   ='';
                        objectDataMap.Referente_TecnicoPV.MobilePhone=inputPhone; // SET THE FIELD PHONE WITH THE VALUE OF THE RESEARCH*/
                        // Doris Dongmo - fix HomePhone and Phone for contact step P.Vendita - 04/06/2019 - Start 
                        objectDataMap.Referente_TecnicoPV.Phone      =inputPhone;
                        objectDataMap.Referente_TecnicoPV.HomePhone  =inputPhone;
                        // Doris Dongmo - fix HomePhone and Phone for contact step P.Vendita - 04/06/2019 - End 
                        
                    }
                    else if(addressMappPosition== 'ResponsabileAmministrativo')
                    {
                        objectDataMap.Responsabile_Amm_PV.Id           = '';  
                        objectDataMap.Responsabile_Amm_PV.FirstName    = '';  
                        objectDataMap.Responsabile_Amm_PV.Email        = '';
                        objectDataMap.Responsabile_Amm_PV.LastName     = '';
                        objectDataMap.Responsabile_Amm_PV.MobilePhone  = inputPhone;// SET THE FIELD PHONE WITH THE VALUE OF THE RESEARCH
                        // Doris Dongmo - fix HomePhone and Phone for contact step P.Vendita - 04/06/2019 - Start 
                        objectDataMap.Responsabile_Amm_PV.Phone        = inputPhone;
                        objectDataMap.Responsabile_Amm_PV.HomePhone    = inputPhone;
                        // Doris Dongmo - fix HomePhone and Phone for contact step P.Vendita - 04/06/2019 - End 
                    }
                    if(addressMappPosition== 'ResponsabilePuntoVendita')
                    {
                        objectDataMap.Responsabile_PV.Id          = '';
                        objectDataMap.Responsabile_PV.FirstName   = '';
                        objectDataMap.Responsabile_PV.Email       = '';
                        objectDataMap.Responsabile_PV.LastName    = '';
                        objectDataMap.Responsabile_PV.MobilePhone = inputPhone;// SET THE FIELD PHONE WITH THE VALUE OF THE RESEARCH
                        // Doris Dongmo - fix HomePhone and Phone for contact step P.Vendita - 04/06/2019 - Start 
                        objectDataMap.Responsabile_PV.Phone       = inputPhone;
                        objectDataMap.Responsabile_PV.HomePhone   = inputPhone;
                        // Doris Dongmo - fix HomePhone and Phone for contact step P.Vendita - 04/06/2019 - End 
                    }
                    
                }

                //  SET UNBIND TO SHOW FIELDS
                objectDataMap.unbind.PV_Contacts = RTDeveloperName;
                component.set('v.objectDataMap', objectDataMap);
                component.set("v.searchResult", contactList);

                //  DISPATCH EVENT 
                document.querySelectorAll('input[id$="input:unbind:PV_Contacts"]')[0].dispatchEvent(new Event('blur'));;
                //document.getElementById('input:unbind:PV_Contacts').dispatchEvent(new Event('blur'));
                
            } else if(state === "INCOMPLETE"){
                console.log('state is: ' + state);
            } else if (state === "ERROR") {
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
        
        $A.enqueueAction(methodSearch);
    },

    validatePhone : function (component, event, helper) {
        var inputPhone = component.find("inputPhone").get("v.value");
        if(onlyNumberPhone(inputPhone)=='ERROR')
        {
            component.set("v.disabledButton" , true);
            // console.log("INTO CHECK NUMBER");
            component.set("v.ErrorBooleanPhone",true);
            $A.util.addClass(component.find('inputPhone') , 'slds-has-error flow_required');
            component.set("v.ErrorMessagePhone" , $A.get("$Label.c.MinFiveMaxTenDigitLength"))  ;
            // if( document.getElementById('errorIdphone'))
            // {
            //     document.getElementById('errorIdphone').remove();
            // }
            // //BLOCK THE STEP TO GO AT STEP 2
            // component.set("v.objectDataMap.errorFamily.errorPhone", true);
        }
        
        else
        {
            component.set("v.disabledButton" , false);
            //REMOVE ERROR MESSAGE AND RED BORDER WHEN I ENTER A CORRECT PHONE NUMBER
            // console.log("INTO CHECK NUMBER 1");
            component.set("v.ErrorBooleanPhone",false);
            // helper.removeRedBorder(component, event);
            // //UNLOCK THE STEP TO GO AT STEP 2
            // component.set("v.objectDataMap.errorFamily.errorPhone" , false);
        }
    },
    validatePhoneChange : function (component, event, helper) {
        var inputPhone = component.find("inputPhone").get("v.value");
        console.log("phone length: " + inputPhone.length);
        if(inputPhone.length>5)
        {
            if( onlyNumberPhone(inputPhone)=='ERROR'  )
            {
                component.set("v.disabledButton" , true);
                // console.log("INTO CHECK NUMBER");
                component.set("v.ErrorBooleanPhone",true);
                $A.util.addClass(component.find('inputPhone') , 'slds-has-error flow_required');
                component.set("v.ErrorMessagePhone" , $A.get("$Label.c.MinFiveMaxTenDigitLength"))  ;
                
            }
            
            else
            {
                component.set("v.disabledButton" , false);
                component.set("v.ErrorBooleanPhone",false);
                $A.util.removeClass(component.find('inputPhone') , 'slds-has-error flow_required');
                
            } 
        }
        else
        {
            component.set("v.disabledButton" , true);
            component.set("v.ErrorBooleanPhone",false);
            $A.util.removeClass(component.find('inputPhone') , 'slds-has-error flow_required');
        }
        
    },
    closeBanner: function (component, event, helper) {
        component.set("v.hasMessage" , false);
    }
})