({
	cancel : function(component, event, helper)
	{
		component.set("v.FlowStep", $A.get("$Label.c.OB_MAINTENANCE_STEP_SUMMARY"));
		console.log("FlowStep : "+component.get("v.FlowStep"));
		console.log("modifyServicePointId"+component.get("v.modifyServicePointId"));
	},

	init : function(component, event, helper)
	{
		// Setting maintenance variable to true for hiding time input 
		component.set("v.isFromMaintenance", true);
		console.log("@@@@@@@@ Mainten maintenanceEnvironment is : " + component.get("v.isFromMaintenance"));
		var days= [$A.get("$Label.c.OB_Monday"),$A.get("$Label.c.OB_Tuesday"),$A.get("$Label.c.OB_Wednesday"),$A.get("$Label.c.OB_Thursday"),$A.get("$Label.c.OB_Friday"),$A.get("$Label.c.OB_Saturday"),$A.get("$Label.c.OB_Sunday")];
        component.set("v.days",days);
        helper.initFunction(component,event,helper);
    },

    /**
    * @author Damian Krzyzaniak <damian.krzyzaniak@accenture.com>
    * @date 24.06.2019
    * @description Method for correct behaviour of checkbox and its inputfield - it resets after dechecking and stay checked after modifying lookup fields in modal OB_LCP006_MCCSearchController
    * @history 24.06.2019 <damian.krzyzaniak@accenture.com> created
    **/
    saveCheckboxInsegnaStatus: function( component, event, helper )
    {
        if( component.find( "ShopSignCheck" ).get( "v.checked" ) )
        {
            component.set( "v.isCheckedCheckboxInsegna", true );
        }
        else
        {
            component.set( "v.isCheckedCheckboxInsegna", false );
        }
        helper.writableShopSign( component, event, helper);
    },

    /**
    * @author Damian Krzyzaniak <damian.krzyzaniak@accenture.com>
    * @date 24.06.2019
    * @description Method for correct behaviour of checkbox and its inputfield - it resets after dechecking and stay checked after modifying lookup fields in modal OB_LCP006_MCCSearchController
    * @history 24.06.2019 <damian.krzyzaniak@accenture.com> created
    **/
    saveCheckboxInsegnaScontrinoStatus : function( component, event, helper )
    {
        if( component.find( "ShopSignHeaderCheck" ).get( "v.checked" ) )
        {
            component.set( "v.isCheckedCheckboxInsegnaScontrino", true );
        }
        else
        {
            component.set( "v.isCheckedCheckboxInsegnaScontrino", false );
        }
        helper.writableShopSignHeader( component, event, helper);
    },

    /**
    * @author Damian Krzyzaniak <damian.krzyzaniak@accenture.com>
    * @date 24.06.2019
    * @description Method for correct behaviour of checkbox and its inputfield - it resets after dechecking and stay checked after modifying lookup fields in modal OB_LCP006_MCCSearchController
    * @history 24.06.2019 <damian.krzyzaniak@accenture.com> created
    **/
    saveCheckboxLocalitaScontrinoStatus : function( component, event, helper )
    {
        if( component.find( "ShopSignCityCheck" ).get( "v.checked" ) )
        {
            component.set( "v.isCheckedCheckboxLocalitaScontrino", true );
        }
        else
        {
            component.set( "v.isCheckedCheckboxLocalitaScontrino", false );
        }
        helper.writableShopSignCity( component, event, helper);
    },

     /**
     * @author Wojciech Szuba <wojciech.szuba@accenture.com>
     * @date 10/07/2019
     * @description Method for correct behaviour of checkbox and its inputfield - it resets after dechecking and stay checked after modifying lookup fields in modal OB_LCP006_MCCSearchController
     * @history 10/07/2019 <wojciech.szuba@accenture.com> Created
     **/
    saveCheckboxSettlementMethodStatus : function( component, event, helper ){
         if( component.get( "v.isCheckedCheckboxSettlementMethod") )
         {
             component.set( "v.isCheckedCheckboxSettlementMethod", true );
         }
         else
         {
             component.set( "v.isCheckedCheckboxSettlementMethod", false );
         }
         helper.writableSettlementMethod( component, event, helper);
    },

    /**
    * @author Wojciech Szuba <wojciech.szuba@accenture.com>
    * @date 10/07/2019
    * @description Method for correct behaviour of picklist - it prevents value from reseting after changing modal
    * @history 10/07/2019 <wojciech.szuba@accenture.com> Created
    **/
    saveSettlementMethodStatus : function( component, event, helper ){
         if( !$A.util.isUndefinedOrNull( component.get( "v.isCheckedCheckboxSettlementMethod") )  )
         {
             component.set( "v.SettlementMethodValue", component.get( "v.objectDataMap.esm.OB_InternationalSettlementMethod__c") );
         }
    },

	saveDraftCustom  : function(component,event,helper)
	{
    	console.log('saveDraftCustom');
		component.set("v.changeLocation",true);
		component.find("OB_ReceiptCity__c").set("v.value",'');
		component.find("OB_ReceiptHeader__c").set("v.value",'');
		component.find("OB_ShopSign").set("v.value",'');
		// NEXI-180 Wojciech Szuba <wojciech.szuba@accenture.com>, 11/07/2019, START
		if(!$A.util.isUndefinedOrNull( component.get("v.objectDataMap.esm.OB_InternationalSettlementMethod__c" ) ) )
		{
		    component.find("OB_InternationalSettlementMethod__c").set("v.value",'');
		}
		component.set( "v.isCheckedCheckboxSettlementMethod", false );
		// NEXI-180 Wojciech Szuba <wojciech.szuba@accenture.com>, 11/07/2019, STOP
        //NEXI-110 24.06.2019 <damian.krzyzaniak@accenture.com> START reseting checkboxes
        component.set( "v.isCheckedCheckboxInsegna", false );
        component.set( "v.isCheckedCheckboxInsegnaScontrino", false );
        component.set( "v.isCheckedCheckboxLocalitaScontrino", false );
        //NEXI-110 24.06.2019 damian.krzyzaniak@accenture.com STOP
		component.set( "v.isMCCDisabled", true ); // NEXI-81 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 27/05/2019
	},

	updateSelectedRows :function(component,event,helper)
	{
		var selectedRows = event.getParam('selectedRows');
        console.log('aaaa selectedRows are '+JSON.stringify(selectedRows));
        var listToModify = [];
		component.set('v.listPuntiVenditaToModify',selectedRows);
		// Start AV 28/02/2019 ANAG-119
		if(selectedRows.length > 0)
		{
			component.find("refresh").set("v.disabled",false);
		    // helper.setOldMCCValue( component, selectedRows ); // NEXI-81 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 12/06/2019
		}
		else
		{
			component.find("refresh").set("v.disabled",true);
			// helper.clearMCCModal( component, false ); // NEXI-81 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 12/06/2019
		}
		// END AV 28/02/2019 ANAG-119	
	},

	closeModalConfirm : function(component,event,helper)
	{
	 	console.log('inside closeModalConfirm');
	 	component.set("v.isSpinner",true);//NEXI-180 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 12/07/2019
	 	component.set("v.changeLocation",false);
	 	var odm = component.get("v.objectDataMap");
	 	var listToModify = component.get('v.listPuntiVenditaToModify');
        console.log('listToModify --> '+ JSON.stringify(listToModify));
        var MCCNewMap = new Map();
	 	for(var i=0;i< listToModify.length;i++)
	 	{
	 		console.log('listToModify[i].OB_ShopSign__c -->'+listToModify[i].OB_ShopSign__c);
	 		if(component.find("ShopSignCheck").get("v.checked"))
	 		{
	 			listToModify[i].OB_ShopSign__c = component.find("OB_ShopSign").get("v.value");
	 		}
	 		if(component.find("ShopSignHeaderCheck").get("v.checked"))
	 		{
	 			listToModify[i].OB_ReceiptHeader__c = component.find("OB_ReceiptHeader__c").get("v.value");
	 		}	
	 		if(component.find("ShopSignCityCheck").get("v.checked"))
	 		{
	 			listToModify[i].OB_ReceiptCity__c = component.find("OB_ReceiptCity__c").get("v.value");
	 		}
	 		// NEXI-180 Wojciech Szuba <wojciech.szuba@accenture.com>, 10/07/2019, START
	 		if(!$A.util.isUndefinedOrNull( component.get( "v.isCheckedCheckboxSettlementMethod" ) ) && component.get("v.isCheckedCheckboxSettlementMethod") ){
                listToModify[i].OB_InternationalSettlementMethod__c = component.get("v.SettlementMethodValue");
            }
	 		// NEXI-180 Wojciech Szuba <wojciech.szuba@accenture.com>, 10/07/2019, STOP
	 		// NEXI-81 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 07/06/2019 START
            if ( !$A.util.isEmpty( component.get( "v.MCCL2input" ) ) )
            {
                listToModify[i].OB_MCCL2__c = helper.setMCCvalue( component.get( "v.selectedMCCL2" ), component.get( "v.MCCL2input") );
                MCCNewMap[listToModify[i].Id+'_MCC2']=listToModify[i].OB_MCCL2__c;
            }
            if ( !$A.util.isEmpty( component.get( "v.MCCL3input" ) ) )
            {
                listToModify[i].OB_MCC__c = helper.setMCCvalue( component.get( "v.selectedMCCL3" ), component.get( "v.MCCL3input" ) );
                MCCNewMap[listToModify[i].Id+'_MCC']=listToModify[i].OB_MCC__c;
            }
            // NEXI-81 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 07/06/2019 STOP
         }

         component.set('v.MCCNewMap',MCCNewMap);
		 component.set('v.listPuntiVenditaToModify',listToModify);
		 console.log('listToModify --> '+ JSON.stringify(listToModify));
		 var listServPoint = component.get("v.ListOfServicePoint");
		 console.log('listServPoint pre change--> '+ listServPoint);
		 for(var i=0;i< listToModify.length;i++)
		 {
			for(var j=0;j<listServPoint.length;j++)
			{
				console.log('listServPoint[j].Id --> '+listServPoint[j].Id);
				console.log('listToModify[i].Id --> '+listToModify[i].Id);
				if(listServPoint[j].Id==listToModify[i].Id)
				{
					listServPoint[j]=listToModify[i];
				}
			}
		 }
		 //NEXI-180 Wojciech Szuba <wojciech.szuba@accenture.com>, 15.07.2019, START
		 let action = component.get( "c.merchantAndAssetCheck" );
         action.setParams
         ({
             accountId : $A.util.isEmpty( odm.servicePointResponsible.AccountId ) ? odm.pv.NE__Account__c : odm.servicePointResponsible.AccountId, // NEXI-360 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 10/10/2019
             mappingListJson : JSON.stringify(listServPoint)
         });
         action.setCallback( this, function( response )
         {
            let state = response.getState( );
            if ( state === 'SUCCESS' )
            {
                let result = response.getReturnValue( );
                if ( component.get('v.fromShortCutSP') && 'ACCREDITO AL NETTO DELLE COMMISSIONI'.toUpperCase() === component.get("v.objectDataMap.esm.OB_InternationalSettlementMethod__c").toUpperCase() && result.assetCheck )
                {
                    component.set("v.isAnyAssetRelated", true);
                }
                if ( result.merchantCheck )
                {
                    if ( !$A.util.isEmpty( component.get( "v.MCCL2input" ) ) && component.get( "v.MCCL2input" ) != 'ALBERGHI' ) //NEXI-330 Kinga Fornal <kinga.fornal@gmail.com> 17/09/2019
                    {
                        helper.showToast( component, event, '', $A.get( "$Label.c.OB_WrongMCCL2NonAlberghi" ), 'error' );
                    }
                    else
                    {
                        component.set("v.ListOfServicePointUpdated",listServPoint);
                        component.set("v.isListOfServicePointDIV", false);
                        component.set("v.isListOfServicePointUpdatedDIV", true);
                    }
                }
                else
                {
                    console.log( 'OB_Maintenance_EditServicePoint_Ctr.merchantCheck: Response return value equals false' );
                    component.set( "v.ListOfServicePointUpdated",listServPoint );
                    component.set( "v.isListOfServicePointDIV", false );
                    component.set( "v.isListOfServicePointUpdatedDIV", true );
                }
            }
            else
            {
                console.log( 'OB_Maintenance_EditServicePoint_Ctr.merchantCheck: Response failed' );
                helper.showToast( component, event, $A.get( "$Label.c.OB_ServerErrorHeader" ), $A.get( "$Label.c.OB_ServerLogicFailed" ), 'error' );
            }
            component.set("v.isSpinner",false);//NEXI-180 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 12/07/2019
        });
        $A.enqueueAction(action);
		//NEXI-180 Wojciech Szuba <wojciech.szuba@accenture.com>, 15.07.2019, STOP
		console.log('listServPoint post change--> '+ JSON.stringify(listServPoint));
	 },

	closeModalCancel : function(component,event,helper)
	{
	 	var odm = component.get("v.objectDataMap");
	 	component.set("v.changeLocation",false);
	 	component.set("v.isListOfServicePointDIV", true);
		component.set("v.isListOfServicePointUpdatedDIV", false);
		component.set('v.listPuntiVenditaToModify',[]);
		component.set('v.ListOfServicePointUpdated',[]);
		component.set('v.objectDataMap.errorFamily.ErrorNameSign',false);
		component.set('v.objectDataMap.errorFamily.ErrorNameHeaderReceipt',false);
		component.set('v.objectDataMap.errorFamily.ErrorNameCityReceipt',false);
		component.find("OB_ShopSign").set("v.value",odm.esm.OB_ShopSign__c);
	 	component.find("OB_ReceiptHeader__c").set("v.value",odm.esm.OB_ReceiptHeader__c);
	 	component.find("OB_ReceiptCity__c").set("v.value",odm.esm.OB_ReceiptCity__c);

	 	// helper.clearMCCModal( component, true ); // NEXI-81 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 07/06/2019
	},

	save : function(component, event, helper)
	{
		try
		{
            //Start antonio.vatrano 19/07/2019 wn-144
            let newData = [];
            let oldData = [];
            //Start antonio.vatrano 19/07/2019 wn-144
            var flowData = component.get("v.FlowData");
            var listMissingFields = [];
            var listMissingFieldsAddress = [];
            console.log('save clicked');
            component.find("save").set("v.disabled",true);  //francesca.ribezzi 11/11/19 - PROD-66 - disable/enable btn to avoid duplicates
            var oldFlowdata = component.get("v.oldInfo");
            var objectDataMap = component.get('v.objectDataMap');
            if(objectDataMap.pv.NE__Province__c=='')
            {
                listMissingFieldsAddress.push( $A.get("$Label.c.OB_Address_Province"));
            }
            if(objectDataMap.pv.NE__City__c=='')
            {
                objectDataMap.pv.NE__Postal_Code__c='';
                listMissingFieldsAddress.push( $A.get("$Label.c.OB_Address_City"));
            }
            if(objectDataMap.pv.NE__Street__c=='')
            {
                listMissingFieldsAddress.push( $A.get("$Label.c.OB_Address_Street"));
            }
            if(objectDataMap.pv.OB_Street_Number__c=='')
            {
                listMissingFieldsAddress.push( $A.get("$Label.c.OB_Address_Street_Number"));
            }
            if(objectDataMap.pv.NE__Postal_Code__c=='')
            {
                listMissingFieldsAddress.push( $A.get("$Label.c.OB_Address_PostalCode"));
            }
            if(listMissingFieldsAddress.length>0)
            {
                listMissingFields.push(listMissingFieldsAddress);
            }
            /* ANDREA MORITTU START 2019.05.15 - BugFix R1F2-47*/
            if($A.util.isEmpty(objectDataMap.pv.OB_Start_Seasonal__c) && !$A.util.isEmpty(objectDataMap.pv.OB_End_Seasonal__c)) {
                listMissingFields.push( $A.get("$Label.c.OB_Start_SeasonalLabel"));
            } else if(!$A.util.isEmpty(objectDataMap.pv.OB_Start_Seasonal__c) && $A.util.isEmpty(objectDataMap.pv.OB_End_Seasonal__c)) {
                listMissingFields.push( $A.get("$Label.c.OB_End_SeasonalLabel"));
            }
            /* ANDREA MORITTU END 2019.05.15 - BugFix R1F2-47*/

            console.log('oldFlowdata --> '+ JSON.stringify(oldFlowdata));
            console.log('objectDataMap --> ' +objectDataMap);
            //start 15/04/2019 antonio.vatrano antonio.vatrano@accenture.com shortCut maintenance for referents: add if(!fromShortCutReferents)
            var nameValue  = "";
            var emailValue = "";
            var phoneValue = "";
            var fromShortCutReferents = component.get("v.fromShortCutReferents");
            if(!fromShortCutReferents)
            {
                nameValue  = component.find('Name').get("v.value");
                emailValue = component.find('OB_Email__c').get("v.value");
                phoneValue = component.find('OB_Mobile_Phone_Number__c').get("v.value");
            }
            else
            {
                nameValue  = objectDataMap.pv.Name;
                emailValue = objectDataMap.pv.OB_Email__c;
                phoneValue = objectDataMap.pv.OB_Mobile_Phone_Number__c;
            }
		    //end 15/04/2019 antonio.vatrano antonio.vatrano@accenture.com shortCut maintenance for referents: add if(!fromShortCutReferents)

            // Start antonio.vatrano 04/04/2019 skip referents if from shortcut
            var adminRespNameValue 		= "";
            var adminRespSurnameValue 	= "";
            var adminRespMobileValue 	= "";
            var adminRespEmailValue 	= "";
            var servPointRespNameValue 		= "";
            var servPointRespSurnameValue 	= "";
            var servPointRespEmailValue 	= "";
            var servPointRespMobileValue 	= "";
            var techRefNameValue 		= "";
            var techRefSurnameValue 	= "";
            var techRefEmailValue 		= "";
            var techRefMobileValue 		= ""; //NEXI-76 Zuzanna Urban <z.urban@accenture.com> 14/06/2019, fix end
            // start antonio.vatrano 16/04/2019 save only changes of context contact
            var fromShortCutSP = component.get("v.fromShortCutSP");
            var fromShortCutReferents = component.get("v.fromShortCutReferents");
            if( !fromShortCutSP )
            {
                if(!fromShortCutReferents)
                {
                    if(component.get('v.objectDataMap').administrativeResponsible!=undefined && component.get('v.objectDataMap').administrativeResponsible.LastName != undefined && component.get('v.objectDataMap').administrativeResponsible.LastName != "") //NEXI-76 Zuzanna Urban <z.urban@accenture.com> 14/06/2019, check Referente
                    {
                        adminRespNameValue   = component.find('OB_ServicePointAdminResponsibleFirstName').get("v.value");
                        adminRespSurnameValue   = component.find('OB_ServicePointAdminResponsibleLastName').get("v.value");
                        adminRespMobileValue   = component.find('OB_ServicePointAdminResponsibleMobile').get("v.value");
                        adminRespEmailValue   = component.find('OB_ServicePointAdminResponsibleEmail').get("v.value");
                    }
                    if(component.get('v.objectDataMap').servicePointResponsible!=undefined && component.get('v.objectDataMap').servicePointResponsible.LastName != undefined && component.get('v.objectDataMap').servicePointResponsible.LastName != "") //NEXI-76 Zuzanna Urban <z.urban@accenture.com> 14/06/2019, check Referente
                    {
                        servPointRespNameValue   = component.find('OB_ServicePointResponsibleFirstName').get("v.value");
                        servPointRespSurnameValue   = component.find('OB_ServicePointResponsibleLastName').get("v.value");
                        servPointRespEmailValue   = component.find('OB_ServicePointResponsibleEmail').get("v.value");
                        servPointRespMobileValue   = component.find('OB_ServicePointResponsibleMobile').get("v.value");
                    }
                    if(component.get('v.objectDataMap').technicalReferent!=undefined && component.get('v.objectDataMap').technicalReferent.LastName != undefined && component.get('v.objectDataMap').technicalReferent.LastName != "") //NEXI-76 Zuzanna Urban <z.urban@accenture.com> 14/06/2019, check Referente
                    {
                        techRefNameValue   = component.find('OB_TechnicalReferentFirstName').get("v.value");
                        techRefSurnameValue   = component.find('OB_TechnicalReferentLastName').get("v.value");
                        techRefEmailValue   = component.find('OB_TechnicalReferentEmail').get("v.value");
                        techRefMobileValue   = component.find('OB_TechnicalReferentMobile').get("v.value");
                    }
                }
                else
                {
                    var contactId = component.get("v.shortcutContactId");
                    //START NEXI-105 06/06/2019 z.urban@accenture.com Change logic for lookup
                    var servicePointResponsible = component.get('v.objectDataMap').servicePointResponsible;
                    var servicePointAdminResponsible = component.get('v.objectDataMap').administrativeResponsible;
                    var technicalReferent =  component.get('v.objectDataMap').technicalReferent;
                    //STOP NEXI-105 06/06/2019 z.urban@accenture.com Change logic for lookup
                    if(component.get('v.objectDataMap').administrativeResponsible!=undefined && contactId == servicePointAdminResponsible && component.get('v.objectDataMap').administrativeResponsible.LastName != undefined && component.get('v.objectDataMap').administrativeResponsible.LastName != "") //NEXI-76 Zuzanna Urban <z.urban@accenture.com> 14/06/2019, check Referente
                    {
                        adminRespNameValue   = component.find('OB_ServicePointAdminResponsibleFirstName').get("v.value");
                        adminRespSurnameValue   = component.find('OB_ServicePointAdminResponsibleLastName').get("v.value");
                        adminRespMobileValue   = component.find('OB_ServicePointAdminResponsibleMobile').get("v.value");
                        adminRespEmailValue   = component.find('OB_ServicePointAdminResponsibleEmail').get("v.value");
                    }
                    else
                    {
                        if(component.get('v.objectDataMap').administrativeResponsible) //NEXI-105 06/06/2019 z.urban@accenture.com Change logic for lookup
                        {
                            adminRespNameValue   = component.get('v.objectDataMap').administrativeResponsible.FirstName;
                            adminRespSurnameValue   = component.get('v.objectDataMap').administrativeResponsible.LastName;
                            adminRespMobileValue   = component.get('v.objectDataMap').administrativeResponsible.Email;
                            adminRespEmailValue   = component.get('v.objectDataMap').administrativeResponsible.MobilePhone;
                        }
                    }
                    if(component.get('v.objectDataMap').servicePointResponsible!=undefined && contactId == servicePointResponsible && component.get('v.objectDataMap').servicePointResponsible.LastName != undefined && component.get('v.objectDataMap').servicePointResponsible.LastName != "") //NEXI-76 Zuzanna Urban <z.urban@accenture.com> 14/06/2019, check Referente
                    {
                        servPointRespNameValue   = component.find('OB_ServicePointResponsibleFirstName').get("v.value");
                        servPointRespSurnameValue   = component.find('OB_ServicePointResponsibleLastName').get("v.value");
                        servPointRespEmailValue   = component.find('OB_ServicePointResponsibleEmail').get("v.value");
                        servPointRespMobileValue   = component.find('OB_ServicePointResponsibleMobile').get("v.value");
                    }
                    else
                    {
                        if(component.get('v.objectDataMap').servicePointResponsible) //NEXI-76 Zuzanna Urban <z.urban@accenture.com> 14/06/2019, change logic
                        {
                            servPointRespNameValue   = component.get('v.objectDataMap').servicePointResponsible.FirstName;
                            servPointRespSurnameValue   = component.get('v.objectDataMap').servicePointResponsible.LastName;
                            servPointRespEmailValue   = component.get('v.objectDataMap').servicePointResponsible.Email;
                            servPointRespMobileValue   = component.get('v.objectDataMap').servicePointResponsible.MobilePhone;
                        }
                    }
                    if(component.get('v.objectDataMap').technicalReferent!=undefined && contactId ==technicalReferent && component.get('v.objectDataMap').technicalReferent.LastName != undefined && component.get('v.objectDataMap').technicalReferent.LastName != "") //NEXI-76 Zuzanna Urban <z.urban@accenture.com> 14/06/2019, change logic
                    {
                        techRefNameValue   = component.find('OB_TechnicalReferentFirstName').get("v.value");
                        techRefSurnameValue   = component.find('OB_TechnicalReferentLastName').get("v.value");
                        techRefEmailValue   = component.find('OB_TechnicalReferentEmail').get("v.value");
                        techRefMobileValue   = component.find('OB_TechnicalReferentMobile').get("v.value");
                    }
                    else
                    {
                        if(component.get('v.objectDataMap').technicalReferent) //NEXI-76 Zuzanna Urban <z.urban@accenture.com> 14/06/2019, change logic
                        {
                            techRefNameValue   = component.get('v.objectDataMap').technicalReferent.FirstName;
                            techRefSurnameValue   = component.get('v.objectDataMap').technicalReferent.LastName;
                            techRefEmailValue   = component.get('v.objectDataMap').technicalReferent.Email;
                            techRefMobileValue   = component.get('v.objectDataMap').technicalReferent.MobilePhone;
                        }
                    }
                }
            }
            else
            {
                //START NEXI-105 06/06/2019 z.urban@accenture.com Change logic for lookup
                if(component.get('v.objectDataMap').administrativeResponsible!=undefined)
                {
                    adminRespNameValue   = component.get('v.objectDataMap').administrativeResponsible.FirstName;
                    adminRespSurnameValue   = component.get('v.objectDataMap').administrativeResponsible.LastName;
                    adminRespMobileValue   = component.get('v.objectDataMap').administrativeResponsible.Email;
                    adminRespEmailValue   = component.get('v.objectDataMap').administrativeResponsible.MobilePhone;
                }
                if(component.get('v.objectDataMap').servicePointResponsible != undefined)
                {
                    servPointRespNameValue   = component.get('v.objectDataMap').servicePointResponsible.FirstName;
                    servPointRespSurnameValue   = component.get('v.objectDataMap').servicePointResponsible.LastName;
                    servPointRespEmailValue   = component.get('v.objectDataMap').servicePointResponsible.Email;
                    servPointRespMobileValue   = component.get('v.objectDataMap').servicePointResponsible.MobilePhone;
                }
                if(component.get('v.objectDataMap').technicalReferent != undefined)
                {
                    techRefNameValue   = component.get('v.objectDataMap').technicalReferent.FirstName;
                    techRefSurnameValue   = component.get('v.objectDataMap').technicalReferent.LastName;
                    techRefEmailValue   = component.get('v.objectDataMap').technicalReferent.Email;
                    techRefMobileValue   = component.get('v.objectDataMap').technicalReferent.MobilePhone;
                }
                //STOP NEXI-105 06/06/2019 z.urban@accenture.com Change logic for lookup
            }
            // end antonio.vatrano 04/04/2019 skip referents if from shortcut
            // End antonio.vatrano 16/04/2019 save only changes of context contact

            // ***********************Start AV 24_12_2018***************Show required fields = null || undefined******

            var listServicePoint = [];
            //start 15/04/2019 antonio.vatrano antonio.vatrano@accenture.com shortCut maintenance for referents: add if(!fromShortCutReferents)
            if( !fromShortCutReferents )
            {
                if( nameValue == null || nameValue == '' || nameValue == undefined )
                {
                    listServicePoint.push( $A.get("$Label.c.OB_Location"));
                }
                if( emailValue==null || emailValue=='' || emailValue==undefined )
                {
                    listServicePoint.push(component.get("v.ServicePointFieldsLabel.OB_Email__c"));
                }
                if( phoneValue==null || phoneValue=='' || phoneValue==undefined )
                {
                    listServicePoint.push(component.get("v.ServicePointFieldsLabel.OB_Mobile_Phone_Number__c"));
                }
                if(listServicePoint.length>0)
                {
                    listMissingFields.push($A.get("$Label.c.OB_MAINTENANCE_SERVICEPOINTEDIT_SECTION1")+": "+listServicePoint);
                }
            }
            //end 15/04/2019 antonio.vatrano antonio.vatrano@accenture.com shortCut maintenance for referents: add if(!fromShortCutReferents)
            // Start antonio.vatrano 04/04/2019 skip referents if from shortcut
            if(!fromShortCutSP)
            {
                if( (component.get('v.objectDataMap').administrativeResponsible!=undefined && component.find("addRespAmm") == "undefined") || component.get("v.isNewRA") == true) //NEXI-76 Zuzanna Urban <z.urban@accenture.com> 14/06/2019, check validation
                {
                    var listServicePointAdminResponsible = [];
                    var hasAtLeastOneError = false;
                    if( adminRespNameValue == null || adminRespNameValue == '' || adminRespNameValue == undefined )
                    {
                        listServicePointAdminResponsible.push($A.get("$Label.c.OB_MAINTENANCE_REFERENTNAME"));
                        hasAtLeastOneError = true;
                    }
                    if( adminRespSurnameValue == null || adminRespSurnameValue == '' || adminRespSurnameValue == undefined )
                    {
                        listServicePointAdminResponsible.push($A.get("$Label.c.OB_MAINTENANCE_REFERENTSURNAME"));
                        hasAtLeastOneError = true;
                    }
                    if( adminRespMobileValue == null || adminRespMobileValue=='' || adminRespMobileValue == undefined )
                    {
                        listServicePointAdminResponsible.push($A.get("$Label.c.OB_MAINTENANCE_REFERENTPHONE"));
                        hasAtLeastOneError = true;
                    }
                    if( adminRespEmailValue == null || adminRespEmailValue == '' || adminRespEmailValue == undefined )
                    {
                        listServicePointAdminResponsible.push($A.get("$Label.c.OB_MAINTENANCE_REFERENTEMAIL"));
                        hasAtLeastOneError = true;
                    }
                    if ( hasAtLeastOneError )
                    {
                        listMissingFields.push($A.get("$Label.c.OB_MAINTENANCE_ADMINISTRATIVE_OFFICER")+": "+listServicePointAdminResponsible);
                    }
                }
                if(( component.get('v.objectDataMap').servicePointResponsible!=undefined && component.find("addRespPuntoVend") == "undefined" ) || component.get("v.isNewRPV") == true ) //NEXI-76 Zuzanna Urban <z.urban@accenture.com> 14/06/2019, check validation
                {
                    var listServicePointResponsible = [];
                    var hasAtLeastOneError = false;
                    if( servPointRespNameValue == null || servPointRespNameValue=='' || servPointRespNameValue==undefined )
                    {
                        listServicePointResponsible.push($A.get("$Label.c.OB_MAINTENANCE_REFERENTNAME"));
                        hasAtLeastOneError = true;
                    }
                    if( servPointRespSurnameValue==null || servPointRespSurnameValue=='' || servPointRespSurnameValue==undefined )
                    {
                        listServicePointResponsible.push($A.get("$Label.c.OB_MAINTENANCE_REFERENTSURNAME"));
                        hasAtLeastOneError = true;
                    }
                    if( servPointRespEmailValue==null || servPointRespEmailValue=='' || servPointRespEmailValue==undefined )
                    {
                        listServicePointResponsible.push($A.get("$Label.c.OB_MAINTENANCE_REFERENTEMAIL"));
                        hasAtLeastOneError = true;
                    }
                    if( servPointRespMobileValue==null || servPointRespMobileValue=='' || servPointRespMobileValue==undefined )
                    {
                        listServicePointResponsible.push($A.get("$Label.c.OB_MAINTENANCE_REFERENTPHONE"));
                        hasAtLeastOneError = true;
                    }
                    if (hasAtLeastOneError)
                    {
                        listMissingFields.push($A.get("$Label.c.OB_MAINTENANCE_SERVICEPOINT_REFERENT")+": "+listServicePointResponsible);
                    }
                }
                if((component.get('v.objectDataMap').technicalReferent != undefined && component.find("addRefTech") == "undefined" ) || component.get("v.isNewRT") == true ) //NEXI-76 Zuzanna Urban <z.urban@accenture.com> 14/06/2019, check validation
                {
                    var listTechnicalReferent =[];
                    var hasAtLeastOneError = false;
                    if( techRefNameValue == null || techRefNameValue == '' || techRefNameValue == undefined )
                    {
                        listTechnicalReferent.push($A.get("$Label.c.OB_MAINTENANCE_REFERENTNAME"));
                        hasAtLeastOneError = true;
                    }
                    if( techRefSurnameValue == null || techRefSurnameValue=='' || techRefSurnameValue == undefined )
                    {
                        listTechnicalReferent.push($A.get("$Label.c.OB_MAINTENANCE_REFERENTSURNAME"));
                        hasAtLeastOneError = true;
                    }
                    if( techRefEmailValue == null || techRefEmailValue=='' || techRefEmailValue == undefined )
                    {
                        listTechnicalReferent.push($A.get("$Label.c.OB_MAINTENANCE_REFERENTEMAIL"));
                        hasAtLeastOneError = true;
                    }
                    if( techRefMobileValue == null || techRefMobileValue == '' || techRefMobileValue == undefined )
                    {
                        listTechnicalReferent.push($A.get("$Label.c.OB_MAINTENANCE_REFERENTPHONE"));
                        hasAtLeastOneError = true;
                    }
                    if (hasAtLeastOneError)
                    {
                        listMissingFields.push($A.get("$Label.c.OB_MAINTENANCE_TECHNICAL_REFERENT")+": "+listTechnicalReferent);
                    }
                }
            }
            // End antonio.vatrano 04/04/2019 skip referents if from shortcut
            console.log('****MISSING FIELDS: '+ listMissingFields);
            component.set('v.missingfields',listMissingFields);

            // ***********************End AV 24_12_2018***************Show required fields = null || undefined******

            let newFlowdataServPoint = objectDataMap.pv;
            newFlowdataServPoint.Name = nameValue;
            newFlowdataServPoint.OB_Email__c = emailValue;
            newFlowdataServPoint.OB_Mobile_Phone_Number__c = phoneValue;
            console.log('newFlowdataServPoint --> ' + JSON.stringify(newFlowdataServPoint));

            let newFlowdataServPointResp = null;
            let newFlowdataAdminResp = null;
            let newFlowdataTechRef = null;
            console.log('oldFlowdata: '+JSON.stringify(oldFlowdata));

            //NEXI-187 18/07/2019 Grzegorz Banach <grzegorz.banach@accenture.com> fix for referents START
            let servicePointResponsibleContact = objectDataMap.servicePointResponsible;
            if( !$A.util.isEmpty( servicePointResponsibleContact ) && !$A.util.isEmpty( servicePointResponsibleContact.LastName ) ) //NEXI-105 06/06/2019 z.urban@accenture.com Change logic for lookup
            {
                newFlowdataServPointResp = servicePointResponsibleContact; //NEXI-105 06/06/2019 z.urban@accenture.com Change logic for lookup
                //NEXI-187 18/07/2019 Grzegorz Banach <grzegorz.banach@accenture.com> fix for referents STOP
                newFlowdataServPointResp.FirstName = servPointRespNameValue;
                newFlowdataServPointResp.LastName = servPointRespSurnameValue;
                newFlowdataServPointResp.Email = servPointRespEmailValue;
                newFlowdataServPointResp.MobilePhone = servPointRespMobileValue;
                console.log('newFlowdataServPointResp --> ' +JSON.stringify(newFlowdataServPointResp));
            }

            //NEXI-187 18/07/2019 Grzegorz Banach <grzegorz.banach@accenture.com> fix for referents START
            let administrativeResponsibleContact = objectDataMap.administrativeResponsible;
            if( !$A.util.isEmpty( administrativeResponsibleContact ) && !$A.util.isEmpty( administrativeResponsibleContact.LastName ) ) //NEXI-105 06/06/2019 z.urban@accenture.com Change logic for lookup
            {
                //	micol.ferrari 27/12/2018
                newFlowdataAdminResp = administrativeResponsibleContact; //NEXI-105 06/06/2019 z.urban@accenture.com Change logic for lookup
                //NEXI-187 18/07/2019 Grzegorz Banach <grzegorz.banach@accenture.com> fix for referents STOP
                newFlowdataAdminResp.FirstName = adminRespNameValue;
                newFlowdataAdminResp.LastName = adminRespSurnameValue;
                newFlowdataAdminResp.Email = adminRespEmailValue;
                newFlowdataAdminResp.MobilePhone = adminRespMobileValue;
                //	micol.ferrari 27/12/2018
                console.log('newFlowdataAdminResp --> ' +JSON.stringify(newFlowdataAdminResp));
            }

            //NEXI-187 18/07/2019 Grzegorz Banach <grzegorz.banach@accenture.com> fix for referents START
            let technicalReferentContact = objectDataMap.technicalReferent;
            if( !$A.util.isEmpty( technicalReferentContact ) && !$A.util.isEmpty( technicalReferentContact.LastName ) ) //NEXI-105 06/06/2019 z.urban@accenture.com Change logic for lookup
            {
                //	micol.ferrari 27/12/2018
                newFlowdataTechRef = technicalReferentContact; //NEXI-105 06/06/2019 z.urban@accenture.com Change logic for lookup
                //NEXI-187 18/07/2019 Grzegorz Banach <grzegorz.banach@accenture.com> fix for referents STOP
                newFlowdataTechRef.FirstName = techRefNameValue;
                newFlowdataTechRef.LastName = techRefSurnameValue;
                newFlowdataTechRef.Email = techRefEmailValue;
                newFlowdataTechRef.MobilePhone = techRefMobileValue;
                //	micol.ferrari 27/12/2018
                console.log('newFlowdataTechRef --> ' +JSON.stringify(newFlowdataTechRef));
            }

            let oldObject = {};
            let newObject = {};
            let externalSourceMAppingObject = {};
            oldObject['pv'] = oldFlowdata.pv;
			//START NEXI-105 06/06/2019 z.urban@accenture.com Change logic for lookup
            if(newFlowdataServPointResp != null && oldFlowdata.servicePointResponsible == null)
            {
                oldObject['servicePointResponsible'] = component.get('v.objectDataMap').servicePointResponsible;
                //	micol.ferrari 27/12/2018
                oldObject['servicePointResponsible'].FirstName = 'Nuovo Responsabile Punto Vendita';
                oldObject['servicePointResponsible'].LastName = '';
                oldObject['servicePointResponsible'].Email = '';
                oldObject['servicePointResponsible'].MobilePhone = '';
            }
            else
            {
                oldObject['servicePointResponsible'] = oldFlowdata.servicePointResponsible;
            }
            //	micol.ferrari 27/12/2018
            if(newFlowdataAdminResp != null && oldFlowdata.administrativeResponsible == null)
            {
                oldObject['administrativeResponsible'] = component.get('v.objectDataMap').administrativeResponsible;
                //	micol.ferrari 27/12/2018
                oldObject['administrativeResponsible'].FirstName = 'Nuovo Responsabile Amministrativo';
                oldObject['administrativeResponsible'].LastName = '';
                oldObject['administrativeResponsible'].Email = '';
                oldObject['administrativeResponsible'].MobilePhone = '';
            }
            else
            {
                oldObject['administrativeResponsible'] = oldFlowdata.administrativeResponsible;
            }
            //	micol.ferrari 27/12/2018
            if(newFlowdataTechRef!=null  && oldFlowdata.technicalReferent == null )
            {
                console.log('newFlowdataTechRef check--->'+JSON.stringify(newFlowdataTechRef));
                oldObject['technicalReferent'] =component.get('v.objectDataMap').technicalReferent;
                //	micol.ferrari 27/12/2018
                oldObject['technicalReferent'].FirstName = 'Nuovo Referente Tecnico';
                oldObject['technicalReferent'].LastName = '';
                oldObject['technicalReferent'].Email = '';
                oldObject['technicalReferent'].MobilePhone = '';
            }
            else
            {
                console.log('@@@@ newFlowdataTechRef: ' + JSON.stringify(newFlowdataTechRef));
                oldObject['technicalReferent'] = oldFlowdata.technicalReferent;
            }
            console.log('oldObject technicalReferent: '+ JSON.stringify(oldFlowdata));
            //start antonio.vatrano wn 144 22/07/2019
            let tmplistOfSourceMapping = oldFlowdata.listOfSourceMapping;
            for(let k in tmplistOfSourceMapping){
                delete tmplistOfSourceMapping[k].attributes;
            }
            oldObject['listOfSourceMapping'] = tmplistOfSourceMapping;
            //End antonio.vatrano wn 144 22/07/2019
            //	micol.ferrari 27/12/2018 - KEEP CALM AND BE CAREFUL WITH THE SEQUENCE OF THE NODES IN THE JSON
            //	OLD AND NEW MUST HAVE THE SAME ORDER
           //Start antonio.vatrano 19/07/2019 wn-144
            newObject['pv'] = newFlowdataServPoint;
            newObject['servicePointResponsible'] =  oldObject['servicePointResponsible'];
            newObject['administrativeResponsible'] =oldObject['administrativeResponsible'];
            newObject['technicalReferent'] = oldObject['technicalReferent'];
            //End antonio.vatrano 19/07/2019 wn-144
            //STOP NEXI-105 06/06/2019 z.urban@accenture.com Change logic for lookup
            //NEXI-298 Marta Stempien <marta.stempien@accenture.com> 11/09/2019 Start
            let listServicePointsNewNotInt = !$A.util.isEmpty(JSON.parse(JSON.stringify(component.get("v.ListOfServicePointUpdated")))) ? JSON.parse(JSON.stringify(component.get("v.ListOfServicePointUpdated"))) : tmplistOfSourceMapping;
            let listServicePointsNew = !$A.util.isEmpty(JSON.parse(JSON.stringify(component.get("v.ListOfServicePointUpdated")))) ? JSON.parse(JSON.stringify(component.get("v.ListOfServicePointUpdated"))) : tmplistOfSourceMapping;
            let MCCNewMap = component.get('v.MCCNewMap');

            if(listServicePointsNew == null || listServicePointsNew.length == 0) // antonio.vatrano 29/07/2019 f2wave2-168
            {
                newObject['listOfSourceMapping'] = tmplistOfSourceMapping;
            }
            else
            {
                for(let key in listServicePointsNewNotInt)
                {
                    // NEXI-261 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 14/08/2019 START null checks
                    for( let i=0 ; i < oldFlowdata.listOfSourceMapping.length ; i++ )
                    {
                        if(listServicePointsNewNotInt[key].Id == oldFlowdata.listOfSourceMapping[i].Id)
                            {
                            if( !$A.util.isUndefined(listServicePointsNewNotInt[key]['OB_ShopSign__c']))
                            {
                                listServicePointsNewNotInt[key]['OB_ShopSign__c'] = oldFlowdata.listOfSourceMapping[i]['OB_ShopSign__c'];
                            }
                            if( !$A.util.isUndefined(listServicePointsNewNotInt[key]['OB_ReceiptHeader__c']))
                            {
                                listServicePointsNewNotInt[key]['OB_ReceiptHeader__c']  = oldFlowdata.listOfSourceMapping[i]['OB_ReceiptHeader__c'];
                            }
                            if( !$A.util.isUndefined(listServicePointsNewNotInt[key]['OB_ReceiptCity__c']))
                            {
                                listServicePointsNewNotInt[key]['OB_ReceiptCity__c']  = oldFlowdata.listOfSourceMapping[i]['OB_ReceiptCity__c'];
                            }
                            if(  !$A.util.isUndefined( listServicePointsNew[key]['OB_InternationalSettlementMethod__c'] ) )
                            {
                                listServicePointsNew[key]['OB_InternationalSettlementMethod__c']  = oldFlowdata.listOfSourceMapping[i]['OB_InternationalSettlementMethod__c'];
                            }
                            if ( !$A.util.isEmpty( component.get( "v.MCCL3input" ) ) && !$A.util.isEmpty( component.get( "v.MCCL2input" ) ) )
                            {
                                if( !$A.util.isUndefined( listServicePointsNewNotInt[key]['OB_MCC__c'] )
                                    && !$A.util.isUndefined( MCCNewMap[listServicePointsNewNotInt[key].Id+'_MCC'] ) ) // NEXI-274 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 26/08/2019
                                {
                                    listServicePointsNewNotInt[key]['OB_MCC__c'] = MCCNewMap[listServicePointsNewNotInt[key].Id+'_MCC'].split(' - ')[0];
                                }
                                else
                                {
                                     listServicePointsNewNotInt[key]['OB_MCC__c']  = oldObject['listOfSourceMapping'][key]['OB_MCC__c'];
                                }
                                if( !$A.util.isUndefined( listServicePointsNewNotInt[key]['OB_MCCL2__c'] )
                                    && !$A.util.isUndefined( MCCNewMap[listServicePointsNewNotInt[key].Id+'_MCC2'] ) ) // NEXI-274 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 26/08/2019
                                {
                                    listServicePointsNewNotInt[key]['OB_MCCL2__c']  = MCCNewMap[listServicePointsNewNotInt[key].Id+'_MCC2'].split(' - ')[0];
                                }
                                else
                                {
                                    listServicePointsNewNotInt[key]['OB_MCCL2__c']  = oldObject['listOfSourceMapping'][key]['OB_MCC__c'];
                                }
                            }
                            else
                            {
                                listServicePointsNewNotInt[key]['OB_MCC__c']  = oldObject['listOfSourceMapping'][key]['OB_MCC__c'];
                                listServicePointsNewNotInt[key]['OB_MCCL2__c'] = oldObject['listOfSourceMapping'][key]['OB_MCCL2__c'];
                            }
                            if( !$A.util.isUndefined( listServicePointsNew[key]['OB_MCC__c'] ))
                            {
                                listServicePointsNew[key]['OB_MCC__c']  = oldObject['listOfSourceMapping'][key]['OB_MCC__c'];
                            }
                            if( !$A.util.isUndefined( listServicePointsNew[key]['OB_MCCL2__c'] ))
                            {
                                listServicePointsNew[key]['OB_MCCL2__c'] = oldObject['listOfSourceMapping'][key]['OB_MCCL2__c'];
                            }
                            //NEXI-298 Marta Stempien <marta.stempien@accenture.com> 11/09/2019 Stop
                        }
                    }
                    // NEXI-261 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 14/08/2019 STOP
                }

                newObject['listOfSourceMapping'] = listServicePointsNew;  //NEXI-298 Marta Stempien <marta.stempien@accenture.com> 11/09/2019
                console.log('OBJECT TO SAVE: ' + JSON.stringify(newObject));
            }
            console.log('oldObject administrativeResponsible: '+ JSON.stringify(newObject['administrativeResponsible']));
            console.log('oldObject: '+ JSON.stringify(oldObject));
            console.log('newObject: '+ JSON.stringify(newObject));
            //start 15/04/2019 antonio.vatrano antonio.vatrano@accenture.com shortCut maintenance for referents: add if(!fromShortCutReferents)
            //NEXI-298 Marta Stempien <marta.stempien@accenture.com> 11/09/2019 Deleted unnecessary code
            let openingTimeValue;
            let closingTimeValue;
            let breakStartTimeValue;
            let breakEndTimeValue;

            if(!fromShortCutReferents)
            {
                //ANDREA START 27.12/18
                console.log("@@@ openingTime is: " 		+ 		component.get("v.openingTimeValue"));
                console.log("@@@ closingTime is: " 		+ 		component.get("v.closingTimeValue"));
                console.log("@@@ breakStartTime is: " 	+ 		component.get("v.breakStartTimeValue"));
                console.log("@@@ breakEndTime is: " 	+ 		component.get("v.breakEndTimeValue"));

                openingTimeValue 		= component.get("v.openingTimeValue");
                closingTimeValue 		= component.get("v.closingTimeValue");
                breakStartTimeValue 	= component.get("v.breakStartTimeValue");
                breakEndTimeValue 		= component.get("v.breakEndTimeValue");
            }
            else
            {
                openingTimeValue 		= objectDataMap.pv.OB_Opening_Time__c;
                closingTimeValue 		= objectDataMap.pv.OB_Ending_Time__c;
                breakStartTimeValue 	= objectDataMap.pv.OB_Break_Start_Time__c;
                breakEndTimeValue 		= objectDataMap.pv.OB_Break_End_Time__c;
            }
             //end 15/04/2019 antonio.vatrano antonio.vatrano@accenture.com shortCut maintenance for referents: add if(!fromShortCutReferents)
            let timeError = component.get("v.timesHaveError");
            console.log('@@@@@@@@@@@@@@@@@@ timeError is:     ' + timeError);

			let listErrorTimeTables = [];
			if(timeError) {
				listErrorTimeTables.push('ERRORE');
				listMissingFields.push(listErrorTimeTables);
			}
			else
			{
                //Start antonio.vatrano 24/04/2019 wn144
                if(openingTimeValue) {
                    newObject.pv.OB_Opening_Time__c 	= openingTimeValue;
                }else {
                    delete newObject.pv.OB_Opening_Time__c;
                }
                if(closingTimeValue){
                    newObject.pv.OB_Ending_Time__c 		= closingTimeValue;
                }
                else{
                    delete  newObject.pv.OB_Ending_Time__c;
                }
                if(breakStartTimeValue){
                    newObject.pv.OB_Break_Start_Time__c = breakStartTimeValue;
                }
                else {
                    delete newObject.pv.OB_Break_Start_Time__c;
                }
                if(breakEndTimeValue){
                    newObject.pv.OB_Break_End_Time__c 	= breakEndTimeValue;
                }
                else{
                    delete newObject.pv.OB_Break_End_Time__c;
                }
                //Start antonio.vatrano 24/04/2019 wn144
			}
       	    //ANDREA END 27.12/18
            // check if something has changed
            let oldJSON = JSON.stringify(oldObject);
            let newJSON = JSON.stringify(newObject);
            //Start antonio.vatrano 19/07/2019 wn-144
            if (newJSON != oldJSON){
                newData.push(newJSON);
                oldData.push(oldJSON);
            }
            //End antonio.vatrano 19/07/2019 wn-144
            if(listMissingFields.length>0)
            {
                let mexerror = $A.get("$Label.c.OB_MAINTENANCEMISSINGFIELDS")+" "+listMissingFields;
                helper.showToast(component, event, $A.get("$Label.c.OB_MAINTENANCE_ERROR"),mexerror,'error');
            }
            else
            {
                //Start antonio.vatrano 19/07/2019 wn-144
                console.log('newFlowdataServPointResp'+JSON.stringify(newFlowdataServPointResp));
                console.log('newFlowdataAdminResp'+JSON.stringify(newFlowdataAdminResp));
                console.log('newFlowdataTechRef'+JSON.stringify(newFlowdataTechRef));
                //NEXI-298 Marta Stempien <marta.stempien@accenture.com> 11/09/2019 Start
                //END - elena.preteni 23/07/2019 WN-144 log request for MCC and others changed first two conditions
                let newObjectNotIntegrated = {};
                newObjectNotIntegrated['pv'] = oldObject['pv'];
                newObjectNotIntegrated['servicePointResponsible'] = newFlowdataServPointResp;
                newObjectNotIntegrated['administrativeResponsible'] =newFlowdataAdminResp;
                newObjectNotIntegrated['technicalReferent'] = newFlowdataTechRef;
                newObjectNotIntegrated['listOfSourceMapping'] = listServicePointsNewNotInt;
                if (!newFlowdataServPointResp){
                    newObjectNotIntegrated['servicePointResponsible'] = oldFlowdata.servicePointResponsible
                }
                if (!newFlowdataTechRef){
                    newObjectNotIntegrated['technicalReferent'] = oldFlowdata.technicalReferent
                }
                if (!newFlowdataAdminResp){
                    newObjectNotIntegrated['administrativeResponsible'] = oldFlowdata.administrativeResponsible
                }

                let jsonNewObjectNotIntegrated = JSON.stringify(newObjectNotIntegrated);
                if (oldJSON != jsonNewObjectNotIntegrated){
                    newData.push(JSON.stringify(newObjectNotIntegrated));
                    oldData.push(oldJSON);

                    if (JSON.stringify(oldObject['listOfSourceMapping']) != JSON.stringify(listServicePointsNew)){
                        let parseFlowData = JSON.parse(flowData);
                        parseFlowData.docRequired = true;
                        flowData = JSON.stringify(parseFlowData);
                    }
                }
               //NEXI-298 Marta Stempien <marta.stempien@accenture.com> 11/09/2019 Stop
                let isChangeData = oldData.length > 0 && newData.length > 0 ;
                if(isChangeData){
                    helper.saveDataHelper(component,event,oldData, newData, flowData);
                }else{
                    component.find("save").set("v.disabled",false);  //francesca.ribezzi 11/11/19 - PROD-66 - disable/enable btn to avoid duplicates
                    helper.showToast(component, event, $A.get("$Label.c.OB_MAINTENANCE_NOERROR"), $A.get("$Label.c.OB_MAINTENANCE_ERROR_NODATACHANGE"), 'error');
                }
                //End antonio.vatrano 19/07/2019 wn-144
            }
	    }
	    catch(err)
	    {
			console.log('err.message save button: ' + err.message);
		}
	},

	modify : function(component, event, helper)
	{
		helper.modify(component);
	},

	showTable:function(component, event, helper)
	{
		$A.util.addClass(component.find("accordionPuntiVendita"), 'slds-show');
		$A.util.removeClass(component.find("accordionPuntiVendita"), 'slds-hide');
		helper.formalCheck(component, event, helper);
	},

	formalCheck : function(component, event, helper)
	{
		//start 15/04/2019 antonio.vatrano antonio.vatrano@accenture.com shortCut maintenance for referents: add if(!fromShortCutReferents)
		var fromShortCutReferents = component.get("v.fromShortCutReferents");
		if(!fromShortCutReferents){
			if(component.find("OB_ShopSign")!= undefined && component.find("OB_ShopSign").get("v.value")!='')
			{
				component.find("OB_ShopSign").set("v.disabled",false);
			}
			if(component.find("OB_ReceiptHeader__c")!= undefined && component.find("OB_ReceiptHeader__c").get("v.value")!='')
			{
				component.find("OB_ReceiptHeader__c").set("v.disabled",false);
			}
			if(component.find("OB_ReceiptCity__c")!= undefined &&  component.find("OB_ReceiptCity__c").get("v.value")!='')
			{
				component.find("OB_ReceiptCity__c").set("v.disabled",false);
			}
		}	
		//End 15/04/2019 antonio.vatrano antonio.vatrano@accenture.com shortCut maintenance for referents: add if(!fromShortCutReferents)	
		helper.formalCheck(component, event, helper);
	},

	addRespPv : function(component, event, helper)
	{
		component.set("v.servPointResp", true);
		component.set("v.cancelToShowRespPv", true);
        component.set("v.isNewRPV", true); //NEXI-76 Zuzanna Urban <z.urban@accenture.com> 14/06/2019, create new contact
	},

	addRefTech :function(component, event, helper)
	{
		component.set("v.techRef", true);
		component.set("v.cancelToShowRefTech", true);
        component.set("v.isNewRT", true); //NEXI-76 Zuzanna Urban <z.urban@accenture.com> 14/06/2019, create new contact
	},

	addRespAmm : function(component, event, helper)
	{
		component.set("v.adminResp", true);
		component.set("v.cancelToShowAdminResp", true);
        component.set("v.isNewRA", true); //NEXI-76 Zuzanna Urban <z.urban@accenture.com> 14/06/2019, create new contact
	},

	cancelRespPv :function(component, event, helper)
	{
		component.set("v.servPointResp", false);
        component.set("v.isNewRPV", false); //NEXI-76 Zuzanna Urban <z.urban@accenture.com> 14/06/2019, create new contact
		component.find("addRespPuntoVend").set("v.disabled",false);
		helper.emptyRespPv( component ); //NEXI-76 Zuzanna Urban <z.urban@accenture.com> 14/06/2019, change logic
	},

	cancelRefTech :function(component, event, helper)
	{
		component.set("v.techRef", false);
        component.set("v.isNewRT", false); //NEXI-76 Zuzanna Urban <z.urban@accenture.com>, change logic
		component.find("addRefTech").set("v.disabled",false);
		helper.emptyRefTech( component ); //NEXI-76 Zuzanna Urban <z.urban@accenture.com>, change logic
	},

	cancelRespAmm : function(component, event, helper)
	{
		component.set("v.adminResp", false);
        component.set("v.isNewRA", false); //NEXI-76 Zuzanna Urban <z.urban@accenture.com>, change logic
		component.find("addRespAmm").set("v.disabled",false);
		helper.emptyRespAmm( component ); //NEXI-76 Zuzanna Urban <z.urban@accenture.com>, change logic
	},

	cancelModify : function(component, event, helper)
	{
		helper.initFunction(component,event,helper);
		component.set("v.status","VIEW");
        //NEXI-76 Zuzanna Urban <z.urban@accenture.com> START, change logic
		component.set("v.isNewRPV", false);
		component.set("v.isNewRA", false);
		component.set("v.isNewRT", false);
		//NEXI-76 Zuzanna Urban <z.urban@accenture.com> STOP, change logic
        //START NEXI-75 30/05/2019 z.urban@accenture.com close buttons
        component.set( "v.servPointResp", false );
        component.set( "v.adminResp", false );
        component.set( "v.techRef", false );
        //STOP NEXI-75 30/05/2019 z.urban@accenture.com close buttons
		//start 15/04/2019 antonio.vatrano antonio.vatrano@accenture.com shortCut maintenance for referents: add if(!fromShortCutReferents)
		var fromShortCutReferents = component.get("v.fromShortCutReferents");
		if(!fromShortCutReferents)
		{
			component.find("OB_Mobile_Phone_Number__c").set("v.disabled", true);
			component.find("OB_Email__c").set("v.disabled", true);
			component.find("Name").set("v.disabled", true);

            //	START 	micol.ferrari 27/12/2018 - IF WE DON'T HAVE THE BUTTON, WE CAN'T SET IT TO DISABLED
			if (typeof component.find("addRespPuntoVend") !== "undefined") //NEXI-76 Zuzanna Urban <z.urban@accenture.com> 14/06/2019, fix add
            {
            	component.find("addRespPuntoVend").set("v.disabled",true); //NEXI-76 Zuzanna Urban <z.urban@accenture.com> 14/06/2019, fix add
            }
            if (typeof component.find("addRespAmm") !== "undefined")
			{
				component.find("addRespAmm").set("v.disabled",true);
			}
			if (typeof component.find("addRefTech") !== "undefined")
			{
				component.find("addRefTech").set("v.disabled",true);
			}
		}

       	//	END 	micol.ferrari 27/12/2018 - IF WE DON'T HAVE THE BUTTON, WE CAN'T SET IT TO DISABLED

        component.set("v.isToSave",false);
        component.set('v.listPuntiVenditaToModify',[]);
        component.set("v.ListOfServicePointUpdated",[]);
		component.set("v.isListOfServicePointDIV", true);
		component.set("v.isListOfServicePointUpdatedDIV", false);
		component.find("cancelModify").set("v.disabled",true);
		// Start antonio.vatrano 04/04/2019 skip referents if from shortcut
		// Start antonio.vatrano 16/04/2019 disable input only of context contact
		var fromShortCutReferents = component.get("v.fromShortCutReferents");
		//NEXI-195 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 11/07/2019 Delete field disabling
		// End antonio.vatrano 04/04/2019 skip referents if from shortcut
		// End antonio.vatrano 16/04/2019 disable input only of context contact
		//	micol.ferrari 21/12/2018
		//start 15/04/2019 antonio.vatrano antonio.vatrano@accenture.com shortCut maintenance for referents: add if(!fromShortCutReferents)
		if( !fromShortCutReferents )
		{
			component.find("refresh").set("v.disabled",true);
		}
	},

	mandatoryField : function(component, event, helper)
	{
		helper.mandatoryField(component, event, helper);
	},

    //NEXI-65 Wojciech Kucharek <wojciech.kucharek@accenture.com> 19/05/2019 START
    cancelUpload : function(component, event, helper)
    {
        console.log('cancel upload & remove log request');
        // NEXI-143 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 12/07/2019 START
        component.set( "v.isListOfServicePointDIV", false );
        component.set( "v.isListOfServicePointUpdatedDIV", true );
        // NEXI-143 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 12/07/2019 STOP
        helper.removeLogRequest(component,event);
    },

    closeModal : function(component, event, helper)
    {
        console.log('confirm in document upload');
        helper.whenDocumentsUploaded(component, event);
    },
    //NEXI-65 Wojciech Kucharek <wojciech.kucharek@accenture.com> 19/05/2019 STOP

	/* Doris D.   25/03/2019 ------------- START*/
	openTooltip : function (component,event,helper)
	{
		component.set("v.showMessageModify", true);

	},

	closeTooltip: function (component,event,helper)
	{
		component.set("v.showMessageModify", false);
	},

	openTooltipCancelButton : function (component,event,helper)
	{
		component.set("v.showMessage", true);
	},

	closeTooltipCancelButton: function (component,event,helper)
	{
		component.set("v.showMessage", false);
	},
    /* Doris D.   25/03/2019 ------------- END*/
    // START - elena.preteni WN-101 salva in bozza 13/07/2019
    saveAsDraft : function(component, event, helper)
    {
    	var logId = component.get("v.saveLogRequest");
    	console.log("logrequestid: "+ logId);
    	try
    	{
    		var action = component.get ("c.saveDraft");
    		action.setParams({ "logId" : logId});
    		action.setCallback(this, $A.getCallback(function (response) {
    			var state = response.getState();
    			if (state === "SUCCESS") {
    				try{
    					var navEvt = $A.get("e.force:navigateToSObject");
    					navEvt.setParams({"recordId": logId,"slideDevName": "detail"});
    					console.log("OB_Maintenance_EditNewExecutor_intermediateController.js : navEvt : " + navEvt);

    					navEvt.fire();

    				}
    				catch(err){
    					console.log('err.message navEvt : ' + err.message);
    				}
    				console.log("@@@@@LOG REQUEST UPDATE");
    			}
    			else if (state === "ERROR") {
    				var errors = response.getError();
    				console.error(errors);
    			}
    		}));
    		$A.enqueueAction(action);
    	}
    	catch(err2){
    		console.log("@@@@@LOG REQUEST not UPDATE");
    	}
    },
    // END - elena.preteni WN-101 salva in bozza 13/07/2019

     /**
    * @author Wojciech Szuba, <wojciech.szuba@accenture.com>
    * @date 12/07/2019
    * @description Method is handler from warning modla on settlement procedure change
    */
    handleAttenzioneModalEvent : function( component, event )
    {
        let cancelBtnClicked = event.getParam( "isCancelButtonClicked" );
        if ( $A.util.isUndefinedOrNull( cancelBtnClicked ) || typeof cancelBtnClicked != 'boolean' )
        {
           return;
        }

        component.set( "v.isAnyAssetRelated", false );
        if ( cancelBtnClicked )
        {
            component.set("v.changeLocation",true);
        }
    }
})