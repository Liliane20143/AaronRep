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
			var MCCdescription  = objectDataMap.pv.OB_MCC_Description__c;
			var ecomm 			= null;
			var annualRevenue   = objectDataMap.merchant.OB_Annual_Revenue__c;
			var nomeInsegna     = objectDataMap.pv.Name;
			
			console.log("--------------------------------------------");
			console.log("ENABLE RETRIEVE PV: zipcode: "+zipcode);
			console.log("ENABLE RETRIEVE PV: annualRevenue: "+annualRevenue);
			console.log("ENABLE RETRIEVE PV: MCCdescription: "+MCCdescription);
			console.log("ENABLE RETRIEVE PV: nomeInsegna: "+nomeInsegna);
			
			
			
			//	ECOMMERCE NOT EMPTY
			if (component.find("ecommerce")!=undefined)
			{
				console.log("ENABLE RETRIEVE PV: component.find(ecommerce): "+component.find("ecommerce"));
				ecomm = component.find("ecommerce").get("v.checked");
				console.log("ENABLE RETRIEVE PV checked: ecomm: "+ecomm);

				if (ecomm==true)
				{	
					component.set("v.hideNewButton", false);
					console.log("ENABLE RETRIEVE PV: ecomm true");

				}

				//ecomm	== false 
				else 
				{ 
					if(annualRevenue == "da_0_a_350K"   || annualRevenue == "da_350_a_600K" ||
					 	   annualRevenue == "da_600_a_960K" || annualRevenue == "da_960K_a_2Mio")
					{
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

				   	else 
				   	{
				   		if(annualRevenue == "da_2Mio_a_3Mio" || annualRevenue == "oltre_3Mio")
					    {
																
						    if ((zipcode!=undefined && zipcode!=null && zipcode!='' && zipcode.length==5)
								&& (MCCdescription!=undefined && MCCdescription!=null && MCCdescription!=''))
						    {
								//  MAKE VISIBLE THE BUTTON
							    component.set("v.hideNewButton", false);
							    console.log("ENABLE RETRIEVE PV: ecomm true or false");

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
				}
			}
		}
	},



	removeRedBorder: function (component, event , helper){

		var tipologia = component.get("v.objectDataMap.pv.OB_MCC_Description__c");
		var tipologiaId = component.find("typologySP").get("v.value");

	    try{
	           //GET THE CURRENT ID FROM INPUT 
	           var currentId = event.target.id; 
	           console.log("current id is: " + currentId);
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
	 



})