({
    createComponent : function(component, event) {
        $A.createComponent(
            "c:modalLookupWithPagination",
            {
                "aura:id": "modal",
                "objectString":component.get("v.objectString"),
                "type":component.get("v.type"),
                "input":component.get("v.objectDataMap.pv.OB_MCC_Description__c"),
                "mapOfSourceFieldTargetField":component.get("v.mapOfSourceFieldTargetField"),
                "mapLabelColumns":component.get("v.mapLabelColumns"),
                "objectDataMap":component.get("v.objectDataMap"),
                "messageIsEmpty":component.get("v.messageIsEmpty"),
                "orderBy":component.get("v.orderBy"),
                "modalHeader": component.get("v.modalHeader")
                
            },
            function(newModal, status, errorMessage){
                if (status === "SUCCESS") {
                    var body = component.get("v.body");
                    body.push(newModal);
                    component.set("v.body", body);
                    
                    
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                }
                    else if (status === "ERROR") {
                        console.log("Error: " + errorMessage);
                    }
            }
        ); 
    },
    
    enableRetrieveServicePointHelper : function(component, event) {  
        
        var objectDataMap 	= component.get("v.objectDataMap");
        //component.set("v.hideNewButton", true);
        
        if (objectDataMap.pv != undefined)
        {
            var zipcode     	= objectDataMap.pv.NE__Zip_Code__c;
            //elena.preteni 8/2/1o hide MCC L1
            var MCCdescription  = 'ALL';
            //objectDataMap.pv.OB_MCC_Description__c;
            //elena.preteni 8/2/1o hide MCC L1
            var ecomm 			= null;
            var annualRevenue   = objectDataMap.merchant.OB_Annual_Revenue__c;
            var nomeInsegna     = objectDataMap.pv.Name;
            var zipcodeId       = component.find("zipcode");
            
            console.log("--------------------------------------------");
            console.log("ENABLE RETRIEVE PV: zipcode:        "+zipcode);
            console.log("ENABLE RETRIEVE PV: annualRevenue:  "+annualRevenue);
            console.log("ENABLE RETRIEVE PV: MCCdescription: "+MCCdescription);
            console.log("ENABLE RETRIEVE PV: nomeInsegna:    "+nomeInsegna);
            
            
            
            //	ECOMMERCE NOT EMPTY
            if (component.find("ecommerce")!=undefined)
            {
                console.log("ENABLE RETRIEVE PV: component.find(ecommerce): "+component.find("ecommerce"));
                ecomm = component.find("ecommerce").get("v.checked");
                console.log("ENABLE RETRIEVE PV checked: ecomm: "+ecomm);
                
                // if (ecomm==true)
                // {	
                // 	component.set("v.hideNewButton", false);
                // 	console.log("ENABLE RETRIEVE PV: ecomm true");
                
                // }
                
                // //ecomm	== false 
                // else 
                // { 
                if(annualRevenue == "da_0_a_350K"   || annualRevenue == "da_350_a_600K" ||
                   annualRevenue == "da_600_a_960K" || annualRevenue == "da_960K_a_2Mio")
                    
                {	
                    
                    if (ecomm==true)
                    {	
                        component.set("v.hideNewButton", false);
                        component.set("v.hideInputCap",   true);
                        console.log("ENABLE RETRIEVE PV: ecomm true");
                        $A.util.removeClass(zipcodeId , 'slds-has-error flow_required');
                        component.set("v.errorCap", false);
                        component.set("v.objectDataMap.pv.NE__Zip_Code__c", "");
                        /*@@ANDERA MORITTU: DISABLE ZIPCODE WHILE ECOMM IS CHECKED*/
                        let zipcodeValue = component.find('zipcode'); 
                        zipcodeValue.set('v.disabled', true);
                        
                    }
                    else //ecom == false
                    {  
                        
                        $A.util.removeClass(zipcodeId , 'slds-has-error flow_required');
                        component.set("v.errorCap",    false);
                        component.set("v.hideInputCap",false);
                        component.set("v.objectDataMap.pv.OB_Ecommerce__c", false);
                        /*@@ANDERA MORITTU: DISABLE ZIPCODE WHILE ECOMM IS CHECKED*/
                        let zipcodeValue = component.find('zipcode');
                        zipcodeValue.set('v.disabled', false);
                        ecomm = component.find("ecommerce");
                        ecomm.set('v.disabled', false);
                        
                        if (zipcode!=undefined && zipcode!=null && zipcode!='' && zipcode.length==5 && onlyNumber(zipcode) !='ERROR' )
                        {
                            //  MAKE VISIBLE THE BUTTON
                            component.set("v.hideNewButton", false);
                            console.log("ENABLE RETRIEVE PV: annualrevenue low, cap ok");
                            
                            
                        }
                        
                        else 
                        {
                            //  ZIP CODE EMPTY
                            //  MAKE HIDDEN THE BUTTON
                            component.set("v.hideNewButton", true);
                            console.log("ENABLE RETRIEVE PV: cap ko");
                        }
                        
                    }
                }
                
                else 
                {
                    if(annualRevenue == "da_2Mio_a_3Mio" || annualRevenue == "oltre_3Mio")
                    {	
                        //elena.preteni 8/2/19 hide Mcc L1
                        // && (MCCdescription!=undefined && MCCdescription!=null && MCCdescription!='')
                        //elena.preteni 8/2/19 hide Mcc L1
                        if ((zipcode!=undefined && zipcode!=null && zipcode!='' && zipcode.length==5)
                           )
                        {
                            //  MAKE VISIBLE THE BUTTON
                            component.set("v.hideNewButton", false);
                            console.log("ENABLE RETRIEVE PV: ecomm true or false");
                            
                        }
                        
                        else if (ecomm==true)
                        {	
                            component.set("v.hideNewButton", false);
                            console.log("ENABLE RETRIEVE PV: ecomm true");
                            $A.util.removeClass(zipcodeId , 'slds-has-error flow_required');
                            component.set("v.errorCap", false);
                            component.set("v.objectDataMap.pv.NE__Zip_Code__c", "");
                            component.set("v.objectDataMap.pv.OB_MCC_Description__c", "");
                            
                        }
                        
                            else 
                            {
                                //  ZIP CODE EMPTY
                                //  MAKE HIDDEN THE BUTTON
                                component.set("v.hideNewButton", true);
                                console.log("ENABLE RETRIEVE PV: cap ko & MCC ko");
                            }
                    }
                    else
                    {
                        //  ZIP CODE EMPTY
                        //  MAKE HIDDEN THE BUTTON
                        component.set("v.hideNewButton", true);
                        console.log("ENABLE RETRIEVE PV: cap ko & MCC ko");
                    }
                    
                    
                    
                }
                
                console.log("ENABLE RETRIEVE PV: hidenewbutton: "+component.get("v.hideNewButton"));   
                //}
            }
        }
    },
    
    
    
    removeRedBorder: function (component, event , helper){
        
        var tipologia = component.get("v.objectDataMap.pv.OB_MCC_Description__c");
        var tipologiaId = component.find("typologySP").get("v.value");
        
        try{
            //GET THE CURRENT ID FROM INPUT 
            var currentId = event.target.id; 
            console.log("current id IN HELPER SP is: " + currentId);
        }
        catch(err){
            console.log('err.message: ' + err.message);
        }
        //RECREATE THE SAME ID OF ERROR MESSAGE
        var errorId = 'errorId'+ currentId;
        
        
        if(document.getElementById(errorId)!=null){
            console.log("errorID . " + errorId);
            document.getElementById(errorId).remove();
        }
        
        
        if (tipologiaId != ''){		 		           
            $A.util.removeClass(component.find('typologySP') , 'slds-has-error flow_required');
        }    
    },
    getServicePointMIP: function(component , zipcodeSelected , MCCSelected){
        console.log('zipcodeSelected: ' + zipcodeSelected);
        console.log('MCCSelected: '     + MCCSelected);
        var request = $A.get("e.c:OB_ContinuationRequest");
        var objectDataMap = component.get("v.objectDataMap");
        console.log('siamo nel completeProvincia, stampo la request: '+ JSON.stringify(request));
        //req.setBody('{"AcquiringCompanies": [{"companyCode": \"'+param[0]+'\","processor": \"'+param[1]+'\"}],"POSCompanies":[{"gtCompanyCode":\"'+param[2]+'\","gtCode": \"'+param[3]+'\"}],"merchantCategoryCode": \"'+param[4]+'\","postalCode": \"'+param[5]+'\","isEcommerce": \"'+param[6]+'\"}');
        // var companyCode = objectDataMap.pv,
        // 	processor = objectDataMap.pv, 
        // 	POSCompanies = objectDataMap.pv,
        // 	gtCompanyCode = objectDataMap.pv,
        // 	gtCode               = objectDataMap.pv,
        // 	merchantCategoryCode = MCCSelected,
        // 	postalCode           = zipcodeSelected,
        // 	isEcommerce=true;
        var merchantCategoryCode = '5541',
            postalCode           = '42011',
            companyCode          = '004015723',
            processor            = 'EQUENS',
            gtCompanyCode        = '',
            gtCode               = '',
            isEcommerce=false;
        request.setParams({
            methodName   : "retriveServicePoint",
            methodParams : [ companyCode, processor , gtCompanyCode , gtCode , merchantCategoryCode , postalCode , isEcommerce ],
            
            callback : function(result) {
                console.log('RISULTATO: ' + result);
                //console.log('RISULTATO CONVERT : '+ result.replace(/&quot;/g, '"'));
                
                
                
                
            }
            
        });
        
        request.fire();
    }	,
    getLovLeve3 : function(component , event , objectDataMap){
        var actionGetLovLeve3= component.get("c.retrieveLovLevel3");
        var lovIdSelected = objectDataMap.lookupLov;
        var level = component.get('v.level');
        var input2 = component.find('inputMCCdescription2').getElement();
        console.log('lovIdSelected: ' + lovIdSelected);
        console.log('level in get lov: ' + level);
        console.log('level 2: ' + JSON.stringify(objectDataMap.order.OB_MCC_Description__c));
        actionGetLovLeve3.setParams({lovIdSelected : lovIdSelected});
        actionGetLovLeve3.setCallback(this, function(response) {
            
            var state = response.getState();
            console.log('state lovIdSelected: ' + state);
            if (state === "SUCCESS") {
                
                var response = response.getReturnValue();
                console.log('response lovIdSelected: ' + response);
                //level 3 is not empty
                if(objectDataMap.order.OB_MCC_Description__c && !(objectDataMap.order2.OB_MCC_Description__c))
                {
                    if(response==true){
                        component.set('v.showLevel3'  , true);
                        component.set('v.objectDataMap.isL3Required' , true);
                    }else if(response==false){
                        component.set('v.showLevel3'  , false);
                        component.set('v.objectDataMap.isL3Required' , false);
                    }
                }
                console.log('objectDataMap.order.OB_MCC_Description__c: ' + objectDataMap.order.OB_MCC_Description__c);
                console.log('objectDataMap.order2.OB_MCC_Description__c: ' + objectDataMap.order2.OB_MCC_Description__c);
                
            } else if (state === "INCOMPLETE") {
                // do something
            } else if (state === "ERROR") {
                var errors = response.getError();
                
                if (errors) {
                    
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                    
                } else {
                    console.log("Unknown error");
                }
                
            }
        });
        $A.enqueueAction(actionGetLovLeve3);
    },

    /*  @Author : Morittu Andrea 
        @Date :  12-Jul-19
        @Task: F2WAVE2-95
    */

    getTypologyValuesHelper : function(component, action) {
        return new Promise(function(resolve, reject){
		    var action = component.get("c.getServicePointTypologyValues_SP");
			action.setCallback(this, function(response){
			    if(response.getState() === 'SUCCESS'){
					var tempMap = [];
				    var responseMap = response.getReturnValue();

				    //	START 	micol.ferrari 29/01/2019 - UAT_SETUP_02_R1F1
				    //	TO ROLLBACK: DECOMMENT THE FOR LOOP AND DELETE THE EXPLICIT FISICO PUSH 
				    /*giovanni spinelli 19/02/2019--> 	change value from Fisico to POS Fisico
				    									when also virtuale will be available into
				    									catalog, decomment for loop.
				    									Value in picklsit is changed!!
				    */								
				    //STOP Andrea Saracini 29/04/2019 - enable Virtual Service Point
				    for ( var key in responseMap) {
				    	tempMap.push({value : responseMap[key],key : key});
				    }
				    //STOP Andrea Saracini 29/04/2019 - enable Virtual Service Point
			
				    component.set("v.objectDataMap.pv.OB_MCC__c","0001");
				    //	 END 	micol.ferrari 29/01/2019 - UAT_SETUP_02_R1F1
				    console.log("typologyList= "
                            + JSON.stringify(component.get("v.typologyList")));
                    resolve(tempMap);
			    } else {
				      reject();
			    }
			});
			$A.enqueueAction(action);
		 });
    }
})