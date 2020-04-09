({
    backToSearch : function(component, event, helper)
    {
        if(component.get("v.showPriceSummary"))
        {
            component.set("v.showPriceSummary", false);
        }else
        {
            component.set("v.FlowStep", $A.get("$Label.c.OB_MAINTENANCE_STEP_SEARCH"));
        }



		  if(component.get("v.showPriceSummary")){
			  component.set("v.showPriceSummary", false);
		  }else{
				component.set("v.FlowStep", $A.get("$Label.c.OB_MAINTENANCE_STEP_SEARCH"));
		  }
		  
		  var assetSummaryCmp = component.find("priceSummary1");
		  if(assetSummaryCmp === null){
		  	assetSummaryCmp = component.find("priceSummary2");
		  }
		  console.log(" component summary found " + JSON.stringify(assetSummaryCmp));
		  assetSummaryCmp.destroyFlowCart();
		  //call clear cart:
		  var clearCartEvent = $A.get("e.NE:Bit2win_Event_ApplyPenalty");  
		  clearCartEvent.setParams({
			   "action": "clearCart" 
		  });
		  clearCartEvent.fire();


	},

	 init : function(component, event, helper) 
	 {
	    try
	    {	

			var flowdata = component.get("v.FlowData");
			//ET 18-12-18
			var JSONDeserialized; 
			if(typeof flowdata == 'object'){
				//START francesca.ribezzi 22/03/19 removing spinner if there's no service point:
	            if( JSONDeserialized.listOfServicePoint.length == 0){
		                component.set('v.spinner',false);
		                var spinCmp = component.find("spinnerComponent");
		                var spinCmp2 = component.find("spinnerId");
		                //console.log( 'spinCmp ' + spinCmp);
		                $A.util.removeClass(spinCmp, "slds-show");
		                $A.util.addClass(spinCmp, "slds-hide");
		                $A.util.removeClass(spinCmp2, "slds-show");
		                $A.util.addClass(spinCmp2, "slds-hide");
		            }
		            //END francesca.ribezzi 
			JSONDeserialized = JSON.stringify(flowdata);
			//JSONDeserialized = JSONDeserialized.split("\"").join("\\");
			console.log('@@typeof if --> ' + JSONDeserialized); //ET 18-12-18 add log 
			//JSONDeserialized = JSON.stringify(JSON.parse(JSONDeserialized));
			//console.log('@@typeof if2 --> ' + JSON.stringify(JSONDeserialized)); //ET 18-12-18 add log 
			}
			else
			{
				JSONDeserialized = JSON.parse(flowdata); 
				console.log('@@typeof else ' + JSON.stringify(JSONDeserialized));
				  if( JSONDeserialized.listOfServicePoint.length == 0){
					                component.set('v.spinner',false);
					                var spinCmp = component.find("spinnerComponent");
					                var spinCmp2 = component.find("spinnerId");
					                //console.log( 'spinCmp ' + spinCmp);
					                $A.util.removeClass(spinCmp, "slds-show");
					                $A.util.addClass(spinCmp, "slds-hide");
					                $A.util.removeClass(spinCmp2, "slds-show");
					                $A.util.addClass(spinCmp2, "slds-hide");
					            }
			}   
			//END ET 18-12-18 
			console.log("InternalUser: " + component.get("v.InternalUser"));
			console.log("UserWrapper summary: " + component.get("v.UserWrapper"));
			console.log('flowdata -->' +flowdata); 
			// var JSONDeserialized = JSON.parse(flowdata);
			var AccountData = JSONDeserialized.acc;
			console.log("AccountData?? ", AccountData);
			component.set("v.AccountData",AccountData);
			var selectedServicePoint = JSONDeserialized.selectedServicePoint;
			  
			
			var ListOfServicePoint = JSONDeserialized.listOfServicePoint;

			//LIST OF LOVS TO GET MCC CODES LEVEL 2 AND THEIR DESCRIPTIONS
			// var listOfLovsL2 = JSONDeserialized.lovList;
			// console.log("listOfLovsL2 : " + JSON.stringify(listOfLovsL2));

			// var mcc;
			// var mccl2descr;
			// console.log("@ListOfServicePoint : " + JSON.stringify(ListOfServicePoint));
			// console.log("@service point MCCL : " + ListOfServicePoint[0].ExternalSourceMapping__r);

			
				// var json;
				// var mccL2Tmp;
				// for(var key in ListOfServicePoint)
				// {
				//    json = ListOfServicePoint[key]["ExternalSourceMapping__r"];
				//    console.log("@Key in service point : " + JSON.stringify(json));
				//    if(json && json.records[0])
				//    	{
				// 	   	mccL2Tmp = json.records[0].OB_MCCL2__c;
				// 	   	console.log("mccL2Tmp : " + json.records[0].OB_MCCL2__c);
				//    	}
				//   	mcc = ListOfServicePoint[key]['OB_MCC__c'] +' - '+ ListOfServicePoint[key]['OB_MCC_Description__c'];
				// 		  ListOfServicePoint[key]['OB_MCC__c'] = mcc;

				// 	for(var i=0;i<listOfLovsL2.length;i++)
				// 	{

				// 		if(listOfLovsL2[i].NE__Value2__c && listOfLovsL2[i].NE__Value2__c == mccL2Tmp)
				// 		{
				// 			console.log("@NE__Value2__c : " + listOfLovsL2[i].NE__Value2__c);
				// 			mccl2descr = mccL2Tmp + ' - '+ listOfLovsL2[i].Name; 
				// 			//TEMPORANEY FIELD TO SHOW MCC CODE WITH RELATIVE DESCRIPTION
				// 			ListOfServicePoint[key]['OB_CIG__c'] = mccl2descr; 
				// 		}
				// 	}
				// }
			}
			catch(err)
			{
				console.log('ERROR MESSAGE DO INIT SUMMARY: ' + err.message);

			}
			

			console.log('listofservicepoint '+JSON.stringify(ListOfServicePoint));
			component.set("v.ListOfServicePoint",ListOfServicePoint);//Math.ceil(listaTOT.length/recordToDisplay);
			//alert();
			component.set("v.allData",ListOfServicePoint);
			/* cmp.set('v.ServicePointColumns', [
				// Other column data here
				 { label: 'Name', fieldName: 'Name', type: 'text' },
				 { label: 'Name', fieldName: 'NE__City__c', type: 'text' },
				 { label: 'Name', fieldName: 'NE__Province__c', type: 'text' },
				 { label: 'Name', fieldName: 'NE__Street__c', type: 'text' },
				 { label: 'Name', fieldName: 'NE__Zip_Code__c', type: 'text' },
				 { label: 'Name', fieldName: 'OB_MCC__c', type: 'text' },
				 { label: 'Name', fieldName: 'OB_Typology__c', type: 'text' }
			]); */
			 var actions = [
				{ label: 'edit', name: 'edit' }           
			], 
			fetchData = {
				Id : 'Id',
	   
			};
			 var ViewMode = component.get("v.ViewMode");  

			// 	START 	micol.ferrari	22/12/2018 - MAIN_47_R1F1
			if('READONLY' == ViewMode )
			{
				component.set('v.ServicePointColumns', [
					//giovanni spinelli change label 02/10/2019	
					{label: $A.get("$Label.c.OB_MAINTENANCE_LOCATION")	        , fieldName: 'Name'             		, type: 'text',"sortable": true	},
					{label: $A.get("$Label.c.OB_Address")    	    , fieldName: 'OB_AddressFormula__c'     , type: 'text'					}
					// {label: $A.get("$Label.c.City")    	            , fieldName: 'NE__City__c'      , type: 'text'					},
					// {label: $A.get("$Label.c.OB_Address_State")   	, fieldName: 'NE__Province__c'  , type: 'text'					},
					// {label: $A.get("$Label.c.Street")             	, fieldName: 'NE__Street__c'    , type: 'text'					},
					// {label: $A.get("$Label.c.PostalCode")	          , fieldName: 'NE__Zip_Code__c'  , type: 'text'					}	   
				]);  		  
			}
			else
			{
				//giovanni spinelli - 27/09/2019 start -add new column with dropdown menu
				var rowActions = helper.getRowActions.bind(this, component);
			  	component.set('v.ServicePointColumns', [
					//giovanni spinelli change label 02/10/2019
					{label: $A.get("$Label.c.OB_MAINTENANCE_LOCATION")          , fieldName: 'Name'             		, type: 'text',"sortable": true	},
					{label: $A.get("$Label.c.OB_Address")    	    , fieldName: 'OB_AddressFormula__c'     , type: 'text'					},
					{ label: $A.get("$Label.c.OB_MAINTENANCE_ACTIONS"), type: 'action',  typeAttributes:{ rowActions: rowActions } , name: 'Modify_Service_point', title: 'ModifyEnablements'}
					//giovanni spinelli - 27/09/2019 end -add new column with dropdown menu
					
					//07/10/2019 - giovanni spinelli momentarily comment this code - start 
					/*{label: $A.get("$Label.c.OB_MAINTENANCE_ACTIONS"), type: 'button', initialWidth: 135, typeAttributes: { label: $A.get("$Label.c.OB_Details"), name: 'Modify_Service_point', title: 'ModifyEnablements'}},
					{
                        label: $A.get("$Label.c.OB_MAINTENANCE_ACTIONS_VARCOBA"),
                        type: 'button',
                        initialWidth: 135,
                        typeAttributes:
                        {
                            label: $A.get("$Label.c.OB_MAINTENANCE_ACTIONS_VARCOBA"),
                            name: 'Var.CoBa',
                            title: ''
                        }
                    }*/ //NEXI-33 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 07/05/2019
					//07/10/2019 - giovanni spinelli momentarily comment this code - start 
				]); 
			}
			// if('READONLY' == ViewMode ){
			// 	component.set('v.ServicePointColumns', [
		
			// 		  {label: $A.get("$Label.c.OB_Location")	        , fieldName: 'Name'             , type: 'text',"sortable": true	},
			// 		  {label: $A.get("$Label.c.City")    	            , fieldName: 'NE__City__c'      , type: 'text'					},
			// 		  {label: $A.get("$Label.c.OB_Address_State")   	, fieldName: 'NE__Province__c'  , type: 'text'					},
			// 		  {label: $A.get("$Label.c.Street")             	, fieldName: 'NE__Street__c'    , type: 'text'					},
			// 		  {label: $A.get("$Label.c.PostalCode")	          , fieldName: 'NE__Zip_Code__c'  , type: 'text'					}
			// 		  // {label: $A.get("$Label.c.OB_MCC_Description")		, fieldName: 'OB_MCC__c'		, type: 'text'					},   
			// 		  // {label: $A.get("$Label.c.OB_MCC_DescriptionL2")	, fieldName: 'OB_CIG__c'		, type: 'text'					}
			// 		  // {label: 'Tipologia', fieldName: 'OB_Typology__c', type: 'text'},
						   
			// 	  ]);  
			  
			// }
			// else{
			////alert($A.get("$Label.c.OB_Location"));
			//   component.set('v.ServicePointColumns', [
		
			// 		  {label: $A.get("$Label.c.OB_Location")          , fieldName: 'Name'             , type: 'text',"sortable": true	},//$A.get("$Label.c.OB_Location")
			// 		  {label: $A.get("$Label.c.City")               	, fieldName: 'NE__City__c'      , type: 'text'					},
			// 		  {label: $A.get("$Label.c.OB_Address_State")   	, fieldName: 'NE__Province__c'  , type: 'text'					},
			// 		  {label: $A.get("$Label.c.Street")             	, fieldName: 'NE__Street__c'    , type: 'text'					},
			// 		  {label: $A.get("$Label.c.PostalCode")	          , fieldName: 'NE__Zip_Code__c'  , type: 'text'					},
			// 		  // {label: $A.get("$Label.c.OB_MCC_Description")		, fieldName: 'OB_MCC__c'		, type: 'text'					},
			// 		  // {label: $A.get("$Label.c.OB_MCC_DescriptionL2")	, fieldName: 'OB_CIG__c'		, type: 'text'					},
			// 		  // {label: 'Tipologia', fieldName: 'OB_Typology__c', type: 'text'},
			// 		 {label: $A.get("$Label.c.OB_MAINTENANCE_ACTIONS"), type: 'button', initialWidth: 135, typeAttributes: { label: $A.get("$Label.c.OB_Details"), name: 'Modify_Service_point', title: 'ModifyEnablements'}}

			// 	  ]); 
		 
			// 		//  { type: 'action', typeAttributes: { rowActions: actions } },
			// }
			// check if the search has filtered for a specific service point
			// 	END 	micol.ferrari	22/12/2018 - MAIN_47_R1F1

						  


			var  selectedRow = [];
			console.log('DATA SERVICE POINT DOINIT: ' + JSON.stringify(component.get('v.data')));
			console.log('selectedServicePoint doInit: ' + selectedServicePoint);
			if( selectedServicePoint){
				//SHOW A SPECIFIC SERVICE POINT 
				var hasServicePoint= component.get('v.hasServicePoint');
				selectedRow = [selectedServicePoint];
				var tabella = component.find("servicePointTable");
				tabella.set("v.selectedRows", selectedRow);
				//alert('do init: ' + hasServicePoint);
				 helper.checkIdServicePoint(component, helper,selectedRow,selectedServicePoint,hasServicePoint);
				 //console.log('BOOLEAN FROM HELPRE: ' + hasServicePoint);
				//if the current page has the specific service point
				// if(hasServicePoint==true)
				// {
				//   alert('true');
				// }
				// //if the current page hasn't the specific service point-->switch to next page and do againthe control

				// else if(hasServicePoint==false)
				// {
				//   //alert('false');
				//   var pageNumber = component.get("v.currentPageNumber");
				//   component.set("v.currentPageNumber", pageNumber+1);
				//   helper.buildData(component, helper);
				//   helper.checkIdServicePoint(component, helper,selectedRow,hasServicePoint,selectedServicePoint)
				//   //alert('after felper false');
				// }
				// console.log('CURRENT PAGE final: ' + component.get('v.currentPageNumber'));

				// console.log('PAGE LIST: ' + component.get('v.pageList'));
				

			}
			else{  

			  try{
					//SHOW THE DEFAUT SERVICE POINT(FIRST VALUE)
					selectedRow = [ListOfServicePoint[0].Id];
					//START francesca.ribezzi 12/06/19 - bugfix R1F2-244
					if(!$A.util.isEmpty(component.get("v.recordId"))){
						var recordId = component.get("v.recordId");
						selectedRow = recordId;
					}
					//START francesca.ribezzi 12/06/19 
					console.log('aaaa selectedRow is '+selectedRow);
					var tabella = component.find("servicePointTable");
					tabella.set("v.selectedRows", selectedRow);
					
				  }
				  catch(err){

					// no service point found

					
				  
				  }
			}
			
			console.log('@@@selectedRow? ' + JSON.stringify(selectedRow)); //ET 13-12
			component.set("v.ServicePointSelectedRow",''+selectedRow); // TBD selezionare coma da mail 
			 if(ListOfServicePoint){
			  if(ListOfServicePoint.length == 0  ) {
				  var cmpTarget = component.find('ServicePointDataTableDIV');
				  $A.util.addClass(cmpTarget, 'slds-hide');
				  component.set('v.showTable',false);
				}
			}

			var switchOnload =  component.get('v.switchOnload');
			component.set('v.switchOnload',!switchOnload);
			 // var selectedRowsIds = [];
		 //   var dataTable = component.find("servicePointTable");
		 //   dataTable.set("v.selectedRows", selectedRowsIds);
		 //START gianluigi.virga 08/01/2020 - PROD-366 - Added missing code and deleted duplicate init function
		 //davide.franzini - 27/06/2019 - F2WAVE2-45 - START
		var commUser = component.get('c.isCommunityUser');
        commUser.setCallback(this, function(response){
			var state = response.getState();
			if(state === 'SUCCESS')
			{
                //Performance parameter string generated
                var parametersStr	=	'accId='+component.get('v.AccountData.Id')+';activatePreLoad=true;preLoadOnly=true;programsToLoad=;activatePostCheckout=false';
                /*
                if(response.getReturnValue() == true){
                    component.set("v.lightningFromVF",'lightningFromVF=true;');
                }else{
                    component.set("v.lightningFromVF",'lightningFromVF=false;');
                }
                */
                if(response.getReturnValue() == true)
                    parametersStr	+=	';lightningFromVF=true';
                else
                    parametersStr	+=	';lightningFromVF=false';
                    
                component.set("v.lightningFromVF",parametersStr);
            }
            else if (state === "ERROR") 
		    {
		        var errors = response.getError();
		        if (errors) 
		        {
		            if (errors[0] && errors[0].message) 
		            {
						console.log("Error message: " + errors[0].message);
		            }
		        } 
		        else 
		        {
		            console.log("Unknown error");
		        }
		    }
        });
		$A.enqueueAction(commUser);
		//davide.franzini - 24/06/2019 - F2WAVE2-45 - END
		//END gianluigi.virga 08/01/2020 - PROD-366 - Added missing code and deleted duplicate init function
	},

//     init : function(component, event, helper)
//     {
//         try
//         {
//             var flowdata = component.get("v.FlowData");
//             //ET 18-12-18
//             var JSONDeserialized;
//             if(typeof flowdata == 'object')
//             {
//                 //START francesca.ribezzi 22/03/19 removing spinner if there's no service point:
//                 if( JSONDeserialized.listOfServicePoint.length == 0)
//                 {
//                     component.set('v.spinner',false);
//                     var spinCmp = component.find("spinnerComponent");
//                     var spinCmp2 = component.find("spinnerId");
//                     $A.util.removeClass(spinCmp, "slds-show");
//                     $A.util.addClass(spinCmp, "slds-hide");
//                     $A.util.removeClass(spinCmp2, "slds-show");
//                     $A.util.addClass(spinCmp2, "slds-hide");
//                 }
//                 //END francesca.ribezzi
//                 JSONDeserialized = JSON.stringify(flowdata);
//                 console.log('@@typeof if --> ' + JSONDeserialized); //ET 18-12-18 add log
//             }
//             else
//             {
//                 JSONDeserialized = JSON.parse(flowdata);
//                 console.log('@@typeof else ' + JSON.stringify(JSONDeserialized));
//                 if( JSONDeserialized.listOfServicePoint.length == 0)
//                 {
//                     component.set('v.spinner',false);
//                     var spinCmp = component.find("spinnerComponent");
//                     var spinCmp2 = component.find("spinnerId");
//                     $A.util.removeClass(spinCmp, "slds-show");
//                     $A.util.addClass(spinCmp, "slds-hide");
//                     $A.util.removeClass(spinCmp2, "slds-show");
//                     $A.util.addClass(spinCmp2, "slds-hide");
//                 }
//             }
//             //END ET 18-12-18
//             console.log("InternalUser: " + component.get("v.InternalUser"));
//             console.log("UserWrapper summary: " + component.get("v.UserWrapper"));
//             console.log('flowdata -->' +flowdata);
//             var AccountData = JSONDeserialized.acc;
//             console.log("AccountData?? ", AccountData);
//             component.set("v.AccountData",AccountData);
//             var selectedServicePoint = JSONDeserialized.selectedServicePoint;
//             var ListOfServicePoint = JSONDeserialized.listOfServicePoint;
//         }
//         catch(err)
//         {
//             console.log('ERROR MESSAGE DO INIT SUMMARY: ' + err.message);
//         }

//         console.log('listofservicepoint '+JSON.stringify(ListOfServicePoint));
//         component.set("v.ListOfServicePoint",ListOfServicePoint);//Math.ceil(listaTOT.length/recordToDisplay);
//         component.set("v.allData",ListOfServicePoint);
//         var actions =
//         [
//             { label: 'edit', name: 'edit' }
//         ],
//         fetchData =
//         {
//             Id : 'Id',
//         };
//         var ViewMode = component.get("v.ViewMode");

//         // 	START 	micol.ferrari	22/12/2018 - MAIN_47_R1F1
//         if('READONLY' == ViewMode )
//         {
//             component.set('v.ServicePointColumns',
//             [
//                 {label: $A.get("$Label.c.OB_Location")	        , fieldName: 'Name'             		, type: 'text',"sortable": true	},
//                 {label: $A.get("$Label.c.OB_Address")    	    , fieldName: 'OB_AddressFormula__c'     , type: 'text'					}
//             ]);
//         }
//         else
//         {
// 			//giovanni spinelli - 27/09/2019 start -add new column with dropdown menu
// 			var rowActions = helper.getRowActions.bind(this, component);
//             component.set('v.ServicePointColumns',
//             [
//                 {label: $A.get("$Label.c.OB_Location")          , fieldName: 'Name'             		, type: 'text',"sortable": true	},
//                 {label: $A.get("$Label.c.OB_Address")    	    , fieldName: 'OB_AddressFormula__c'     , type: 'text'					},
//                 { label: $A.get("$Label.c.OB_MAINTENANCE_ACTIONS"), type: 'action',  typeAttributes:{ rowActions: rowActions } , name: 'Modify_Service_point', title: 'ModifyEnablements'}
// 			]);
// 			//giovanni spinelli - 27/09/2019 end -add new column with dropdown menu
//         }
//         var  selectedRow = [];
//         console.log('DATA SERVICE POINT DOINIT: ' + JSON.stringify(component.get('v.data')));
//         console.log('selectedServicePoint doInit: ' + selectedServicePoint);
//         if( selectedServicePoint)
//         {
//             //SHOW A SPECIFIC SERVICE POINT
//             var hasServicePoint= component.get('v.hasServicePoint');
//             selectedRow = [selectedServicePoint];
//             var tabella = component.find("servicePointTable");
//             tabella.set("v.selectedRows", selectedRow);
//             helper.checkIdServicePoint(component, helper,selectedRow,selectedServicePoint,hasServicePoint);
//         }
//         else
//         {
//             try
//             {
//                 //SHOW THE DEFAUT SERVICE POINT(FIRST VALUE)
//                 selectedRow = [ListOfServicePoint[0].Id];
//                 console.log('aaaa selectedRow is '+selectedRow);
//                 var tabella = component.find("servicePointTable");
//                 tabella.set("v.selectedRows", selectedRow);
//             }
//             catch(err)
//             {
//             //TODO: add error handling
//             }
//         }

//         console.log('@@@selectedRow? ' + JSON.stringify(selectedRow)); //ET 13-12
//         component.set("v.ServicePointSelectedRow",''+selectedRow); // TBD selezionare coma da mail
//         if(ListOfServicePoint)
//         {
//             if(ListOfServicePoint.length == 0  )
//             {
//                 var cmpTarget = component.find('ServicePointDataTableDIV');
//                 $A.util.addClass(cmpTarget, 'slds-hide');
//                 component.set('v.showTable',false);
//             }
//         }

//         var switchOnload =  component.get('v.switchOnload');
// 		component.set('v.switchOnload',!switchOnload);
		
// 		//davide.franzini - 27/06/2019 - F2WAVE2-45 - START
// 		var commUser = component.get('c.isCommunityUser');
//         commUser.setCallback(this, function(response){
// 			var state = response.getState();
// 			if(state === 'SUCCESS')
// 			{
//                 //Performance parameter string generated
//                 var parametersStr	=	'accId='+component.get('v.AccountData.Id')+';activatePreLoad=true;preLoadOnly=true;programsToLoad=;activatePostCheckout=false';
//                 /*
//                 if(response.getReturnValue() == true){
//                     component.set("v.lightningFromVF",'lightningFromVF=true;');
//                 }else{
//                     component.set("v.lightningFromVF",'lightningFromVF=false;');
//                 }
//                 */
//                 if(response.getReturnValue() == true)
//                     parametersStr	+=	';lightningFromVF=true';
//                 else
//                     parametersStr	+=	';lightningFromVF=false';
                    
//                 component.set("v.lightningFromVF",parametersStr);
//             }
//             else if (state === "ERROR") 
// 		    {
// 		        var errors = response.getError();
// 		        if (errors) 
// 		        {
// 		            if (errors[0] && errors[0].message) 
// 		            {
// 						console.log("Error message: " + errors[0].message);
// 		            }
// 		        } 
// 		        else 
// 		        {
// 		            console.log("Unknown error");
// 		        }
// 		    }
//         });
// 		$A.enqueueAction(commUser);
// 		//davide.franzini - 24/06/2019 - F2WAVE2-45 - END

//     },

	initServicePointTable : function(component, event, helper)
	{

	},
	/**
	*@author Giovanni Spinelli <spinelli.giovanni@accenture.com>
	*@date 20/03/2018
	*@description Method to manage action in datatable
	*@params -
	*@return 
	*@version 2.0 : every time I fire a flow, always pass fiscal code as filter 
	*/
	handleRowAction: function (component, event, helper)  {
		var action = event.getParam('action');
		var row = event.getParam('row');
		var flowData = JSON.parse( component.get('v.FlowData') );
		var fiscalCode = flowData.acc.NE__Fiscal_code__c;
		//filter aways contains the merchant fiscal code
		var filter = 'FC_'+fiscalCode  + '_SP_' + row.Id;
		//if user is Nexi Partner Approver L2 add _CAB_ in url
		//giovanni spinelli - start - 02/10/2019 add filter cab if user is L2 or L3
		if( component.get('v.userProfile') == 'Nexi Partner Approver L2' || component.get('v.userProfile') == 'Nexi Partner Approver L3'){
			var filterCAB = '_CAB_'+flowData.userWrapper.cab;
			filter = filter + filterCAB;
		}
		//giovanni spinelli - end - 02/10/2019 add filter cab if user is L2 or L3
		var myBaseURL = component.get( 'v.myBaseURL');
        switch (action.name) {
            case 'show_details':
                component.set("v.modifyServicePointId",row.Id );
		 		component.set("v.FlowStep", $A.get("$Label.c.OB_MAINTENANCE_STEP_EDITSERVICEPOINT"));
                break;
            case 'fire_flow':
				window.open( myBaseURL + '/s/ob-catalogo-nuovo-contratto?filter='+filter , '_self');
				break;
			//giovanni spinelli 07/1072019 add var.coba in dropdown menu
			case 'Var.CoBa':
                component.set("v.modifyServicePointId",row.Id );//NEXI-366 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 10/10/2019 fix regresion
				component.set("v.FlowStep", $A.get("$Label.c.OB_MAINTENANCE_ACTIONS_VARCOBA"));
				break;//g.s add break
			//giovanni spinelli 07/1072019 end var.coba in dropdown menu
		}
	},
		
	//07/10/2019 - giovanni spinelli momentarily comment this code - start 
	/*handleRowAction: function (component, event, helper)
	{
        var action = event.getParam('action');
        var row = event.getParam('row');
        console.log('ROW IS '+row);
        console.log('ROW.id  IS '+row.Id);
        //NEXI-33 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 07/05/2019 Start add if for my action Var.CoBa
        component.set("v.modifyServicePointId",row.Id );
        if(action.name == "Modify_Service_point")
        {
            component.set("v.FlowStep", $A.get("$Label.c.OB_MAINTENANCE_STEP_EDITSERVICEPOINT"));
        }
        else if(action.name == "Var.CoBa")
        {
            component.set("v.FlowStep", $A.get("$Label.c.OB_MAINTENANCE_ACTIONS_VARCOBA"));
        }
        //NEXI-33 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 07/05/2019 Stop
	},*/
	//07/10/2019 - giovanni spinelli momentarily comment this code - end 
	modifyAccount : function(component, event, helper)
	{
		  component.set("v.FlowStep", $A.get("$Label.c.OB_MAINTENANCE_STEP_EDITACCOUNT"));
	},

	modifyExecutor : function(component, event, helper)
	{
		  component.set("v.FlowStep", $A.get("$Label.c.OB_MAINTENANCE_STEP_EXECUTOR"));
	},

    updateSelectedRow :  function(component, event, helper)
    {
        var selectedRows = event.getParam('selectedRows');
        console.log('aaaa selectedRows.Id is '+selectedRows[0].Id);
        var switchOnload =  component.get('v.switchOnload');
        component.set('v.ServicePointSelectedRow',''+selectedRows[0].Id);
        component.set('v.switchOnload',!switchOnload);
    },

    handleMaintenanceEvent:  function(component, event, helper)
    {
        var showPriceSummary = event.getParam("showPriceSummary");
        component.set("v.showPriceSummary", showPriceSummary);
        var goToFlowCart = event.getParam("goToFlowCart");
        component.set("v.goToFlowCart", goToFlowCart);
    },


    //GIOVANNI SPINELLI 15/12/2018-START METHODS TO PAGINATION
    onFirst  :  function(component, event, helper)
    {
        component.set("v.currentPageNumber", 1);
        helper.buildData(component, helper);
    },

    onPrev :  function(component, event, helper)
    {
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber-1);
        helper.buildData(component, helper);
    },

    onNext : function(component, event, helper)
    {
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber+1);
        helper.buildData(component, helper);
    },

    onLast: function(component, event, helper)
    {
        component.set("v.currentPageNumber", component.get("v.totalPages"));
        helper.buildData(component, helper);
    },

    processMe: function(component, event, helper)
    {
        component.set("v.currentPageNumber", parseInt(event.target.name));
        helper.buildData(component, helper);
    },

    changeData : function(component, event, helper)
    {
        helper.buildData(component, helper);
    },

    //GIOVANNI SPINELLI 15/12/2018-END METHODS TO PAGINATION
    updateColumnSorting : function(component, event, helper)
    {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        console.log('FIELD NAME: ' + fieldName + 'SORTDIRECTION: ' + sortDirection);
        component.set("v.sortedBy", fieldName);
        component.set("v.sortedDirection", sortDirection);
        helper.sortData(component, fieldName, sortDirection);
    },

    handleSpinnerEvent : function(component,event)
    {
        var spinCmp = component.find("spinnerComponent");
        console.log( 'spinCmp ' + spinCmp);
        $A.util.toggleClass(spinCmp, "slds-hide");
        console.log("into handleSpinnerEvent");
        var spinner = event.getParam("spinner");
        console.log("hide spinner from event: " + spinner);
        var spinCmp2 = component.find("spinnerId");
	//Start Masoud zaribaf-02/05/2019-RI-2
	$A.util.addClass(spinCmp2, "slds-hide");
	$A.util.removeClass(spinCmp2, "slds-show");
	//End Masoud zaribaf-02/05/2019 -RI-2
    },

	handleEngineEvent: function(component,event)
	{
        console.log("into handleEngineEvent");
        var destroyEngine = event.getParam("destroyEngine");
        if(destroyEngine)
        {
            var coreEngine = component.find('coreEngine');
            console.log("coreEngine: " , coreEngine);
            coreEngine.destroy();
        }
	},

	handleBackSet: function(component,event)
	{
		//disable previous button
		var value = event.getParam("hideBackButton");
		component.set('v.goToFlowCart' , value);
	},
	
	getServicePointId : function(component,event)
	{
		var servicePointId = event.getParam("servicePointId");
		console.log('servicePointId is: ' + servicePointId);
		var servicePointList = [];
		var tabella = component.find("servicePointTable");
		if(tabella != undefined )
		{
			console.log('var tabella  is: ' + tabella);
			servicePointList.push(servicePointId); 
			tabella.set("v.selectedRows",servicePointList);
		}
	},

	/*
	*	Author		:	Morittu Andrea
	*	Date		:	28-Aug-2019
	*	Description	:	UX.194 - Filter Function 
	*/
	filterResultController : function (component, event, helper) {
		helper.filterResult_Helper(component, event, helper);
	},

	/*
	*	Author		:	Morittu Andrea
	*	Date		:	28-Aug-2019
	*	Description	:	UX.194 - Clear Filter Function 
	*/
	resetResearch : function(component, event, helper) {
		helper.clearFilterAction(component, event, helper);
	},
	/**
	*@author Giovanni Spinelli <spinelli.giovanni@accenture.com>
	*@date 20/03/2018
	*@description Method to fire flow
	*@params -
	*@return
	*@version 2.0 : every time I fire a flow, always pass fiscal code as filter 
	*/
	fireFlow: function (component, event, helper) {
		//filter is always the merchant fiscal code
		var flowData = JSON.parse(component.get('v.FlowData')),
			fiscalCode = flowData.acc.NE__Fiscal_code__c,
			filter = 'FC_' + fiscalCode,
			myBaseURL = component.get('v.myBaseURL');
		//giovanni spinelli -  start - 02/10/2019 - add cab to url if user is L2 or L3
		if( component.get('v.userProfile') == 'Nexi Partner Approver L2' || component.get('v.userProfile') == 'Nexi Partner Approver L3'){
		
			var filterCAB = '_CAB_'+flowData.userWrapper.cab;
			filter = filter + filterCAB;
		}
		//giovanni spinelli -  end - 02/10/2019 - add cab to url if user is L2 or L3
		window.open(myBaseURL + '/s/ob-catalogo-nuovo-contratto?filter=' + filter, '_self');

	},
	/*ANDREA.MORITTU START 2019.05.06 - ID_Stream_6_Subentro*/
	destroyWholeComponent : function(component,event, helper) {
		helper.destroyWholeComponentHelper(component, event, helper);
	}
	/*ANDREA.MORITTU END 2019.05.06 - ID_Stream_6_Subentro*/

})