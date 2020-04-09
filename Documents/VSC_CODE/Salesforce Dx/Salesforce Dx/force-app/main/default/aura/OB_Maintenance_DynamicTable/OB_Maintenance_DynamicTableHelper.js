({
	retrieveFieldsLabel : function(component, event, helper) {

		console.log('retrieveFieldsLabel start');
		try{
            var action = component.get('c.retriveInformation');
        
            var listOfFields = component.get("v.fieldsToShow"); 
      	     var ObjectToShow = component.get("v.ObjectToShow"); 
            var queryType = component.get("v.queryType"); 
      	    var parentidretrived = component.get("v.recordparentid"); 
      	   /*  console.log('listOfFields are ',listOfFields); 

            console.log('**************************** parentid is '+parentidretrived);


            console.log('retrieveFieldsLabel value retrived');*/
        }	
        catch(err)
        {
	       console.log(err);
        }
//(list<string> fieldsToRetrive, string SObjectToRetrive, string queryType, string parentid)
        action.setParams({ 
            "fieldsToRetrive" : listOfFields,
            "SObjectToRetrive" : ObjectToShow,
			"queryType" : queryType,
            "parentid" : parentidretrived,
            "proposerABI": component.get("v.proposerABI"), //'05696'//TODO: waiting for real value
            //START elena.preteni 07/05/2019 add bundleConfiguration
            "bundleConfiguration": component.get("v.bundleConfiguration")
            //END elena.preteni 07/05/2019
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var valueReturns = response.getReturnValue();
                var myMap = new Map(); 
                var result = JSON.parse( valueReturns );
                try{
                    var fieldReturned  = result.listOfField;                    
                	var columnsToset = new Array(0);
					for (var i = 0; i < fieldReturned.length; i++) { 
                        var row = new Object();
					   if(fieldReturned[i].fielLabel != 'Nome asset'){
                            row ['label'] =  fieldReturned[i].fielLabel;
						    row ['fieldName'] =  fieldReturned[i].fieldName;
						    row ['type'] =  fieldReturned[i].fieldType;
					    }
					    else if(fieldReturned[i].fielLabel == 'Nome asset'){
					    	var labelName;
					    	if(component.get("v.queryType") == "VAS"){
                                labelName = 'VAS';
                                if($A.util.isEmpty(fieldReturned[i].dataToShow) || $A.util.isUndefined(fieldReturned[i].dataToShow) ) {
                                    component.set('v.VASresult', null ); //francesca.ribezzi 10/10/19 -WN-599 - fixing setting by adding 'v.' 
                                }
					    	}
					    	else if(component.get("v.queryType") == "ACQUIRING"){
                                // ANDREA MORITTU START 27-Sept-2019  - EVO_PRODOB_469
                                if($A.util.isEmpty(fieldReturned[i].dataToShow) || $A.util.isUndefined(fieldReturned[i].dataToShow) ) {
                                    component.set('v.ACQUIRINGresult', null);
                                } 

                                if(fieldReturned[i].fielLabel == 'Nome asset'){
                                    row ['label'] =  fieldReturned[i].fielLabel;
                                    row ['fieldName'] =  fieldReturned[i].fieldName;
                                    row ['type'] =  fieldReturned[i].fieldType;
                                }
                                if(fieldReturned[i].fielLabel == 'InstallDate'){
                                    row ['label'] =  'Data di Attivazione';
                                    row ['fieldName'] =  fieldReturned[i].fieldName;
                                    row ['type'] =  fieldReturned[i].fieldType;
                                }
                                if(fieldReturned[i].fieldName == 'NE__EndDate__c'){
                                    row ['label'] =  'Data di Disattivazione';
                                    row ['fieldName'] =  fieldReturned[i].fieldName;
                                    row ['type'] =  fieldReturned[i].fieldType;
                                }
                                labelName =  'Nome Asset';
                                // ANDREA MORITTU END 27-Sept-2019  - EVO_PRODOB_469					    	}
					    	} else if(component.get("v.queryType") == "OFFER"){
					    		labelName = 'Tipo Offerta';
                            }
                            else if(component.get("v.queryType") == "PAGOBANCOMAT"){
                                labelName = 'Pagobancomat';
                                if(fieldReturned[i].fielLabel == 'InstallDate'){
                                    row ['label'] =  'Data di Attivazione';
                                    row ['fieldName'] =  fieldReturned[i].fieldName;
                                    row ['type'] =  fieldReturned[i].fieldType;
                                }
                                if(fieldReturned[i].fieldName == 'NE__EndDate__c'){
                                    row ['label'] =  'Data di Disattivazione';
                                    row ['fieldName'] =  fieldReturned[i].fieldName;
                                    row ['type'] =  fieldReturned[i].fieldType;
                                }
                            }
                            //START Andrea Saracini 16/05/2019 Card No Present
                            else if(component.get("v.queryType") == "APM"){
					    		labelName = 'APM';
                            }
                            else if(component.get("v.queryType") == "INTEGRAZIONE"){
					    		labelName = 'Modalità di Integrazione';
                            }
                            //STOP Andrea Saracini 16/05/2019 Card No Present
							row ['label'] = labelName;
						    row ['type'] =  fieldReturned[0].fieldType;
						    row ['fieldName'] = 'Name';
						    row['initialWidth'] = 300;
                        }
                        // ANDREA MORITTU START 24-Sept 2019 - Hiding Status column - PRODOB_469
                        if(component.get("v.queryType") == "ACQUIRING"){
                            // CARDS ACCEPTED
                            if(fieldReturned[i].fielLabel.toLowerCase() == 'data di installazione'){
                                // START MORITTU ANDREA 24-Sept-2019 - PRODOB_469 
                                row['label'] = $A.get("$Label.c.OB_StartValidityDate");
                                // END MORITTU END 24-Sept-2019 - PRODOB_469 
                                // START Simone Misani WN-609 15/10/2019 
                                row ['type'] = fieldReturned[i].fieldType;
                                row ['fieldName'] = fieldReturned[i].fieldName;
                                row['initialWidth'] = 150;
                            }
                            if(fieldReturned[i].fielLabel.toLowerCase() == 'data disinstallazione') {
                                row ['label'] = 'data disattivazione';
                                row ['type'] =  fieldReturned[i].fieldType;
                                row ['fieldName'] = fieldReturned[i].fieldName;
                                row['initialWidth'] = 150;
                            }
                              // END Simone Misani WN-609 15/10/2019
                        }
                        // THIS EMPTY IF/ ELSE IF NEED TO REJECT RENDERING INSIDE DATA TABLE
                        // IF YOU DON'T PUSH IT INSIDE THE COLUMN, LIGHTNING DATA TABLE REJECT TO 
                        // RENDER IT. 
                        console.log('field returned: ',fieldReturned[i].fieldName);
                        if(  fieldReturned[i].fieldName == 'NE__Status__c'){

                        }else if(fieldReturned[i].fieldName == 'OB_MCCL2__c') {

                        }
                      	//  Giovanni Spinelli START REMOVE NE__Order_Config FROM DATA TABLE 
                      	else if( fieldReturned[i].fieldName == 'NE__Order_Config__c' ){

                        } 
                      	//  Giovanni Spinelli END REMOVE NE__Order_Config FROM DATA TABLE 
                        else if((fieldReturned[i].fieldName) == 'OB_MCC__c'){
                            
                            let data = result.dataToShow;
                            console.log('data: ' , data);
                            let typeAttributes = {};

                           
                            row['label'] = $A.get("$Label.c.MCCCode");
                            row ['type'] =  'text';
                            row ['fieldName'] = 'OB_MCC__c';
                            row['initialWidth'] = 125;
                            columnsToset.push(row);

                            // BUTTON INFO
                            let actionRow = new Object();
                            let  action = new Object();
                            action['name'] = 'show_mcc_description';
                            action['title'] = $A.get("$Label.c.OB_CustomShow") + ' ' + $A.get("$Label.c.OB_MCC_DescriptionL3");
                            action['iconName'] = 'utility:info_alt'
                            action['variant'] = 'bare';
                            action['disabled'] = false;
                            action['class'] = 'infoMCCdiv';
                            action['iconClass'] = 'info_ALT_icon';
                            $A.get("$Label.c.OB_StartValidityDate");
                            // actionRow['label'] = 'Descrizione MCC';
                            actionRow['type'] = 'button-icon';
                            actionRow['fixedWidth'] = 60;


                            actionRow['typeAttributes'] = action;
                            columnsToset.push(actionRow);

                                
                        }
                        
                        else {
                              columnsToset.push(row);
                        }
                        // ANDREA MORITTU END 24-Sept 2019 - Hiding Status column - PRODOB_469
					}
					
					
					//francesca.ribezzi - pushing fields like this just for now..waiting for real ones!!
				/* 	if(component.get("v.queryType") == "OFFER"){
						var listOfTempFields = ['Codice SIA'];
						for(var i = 1; i<listOfTempFields.length; i++){
							var row = {};
							row['label'] = listOfTempFields[i];
							 columnsToset.push(row);
						}
						var row = {};
						row['label'] = listOfTempFields[0];
						columnsToset.splice(1,0,row);
						
					}
				   if(component.get("v.queryType") == "ACQUIRING"){
						var listOfTempFields = ['Commissioni'];
						for(var i = 0; i<listOfTempFields.length; i++){
							var row = {};
							row['label'] = listOfTempFields[i];
							 columnsToset.push(row);
						}
					}*/
				    
					//francesca.ribezzi - adding 2 action column2 displaying two btns for offer table:
					//console.log("queryType: " + component.get("v.queryType") + "isFromServicePoint: " + component.get("v.isFromServicePoint"));
					/*if(component.get("v.queryType") == "OFFER" && component.get("v.isFromServicePoint") == false){
					
					
						var rowBtn1 = new Object();
					 	rowBtn1 ['label'] =  '';
					    rowBtn1 ['fieldName'] =  'Modifica Offerta';
					    rowBtn1 ['type'] =  'button';
					    rowBtn1['typeAttributes'] = {label: 'Modifica Offerta', variant: 'Neutral', name: 'editOffer'};
					    
					    columnsToset.push(rowBtn1);
					    
						var rowBtn2 = new Object();
					 	rowBtn2 ['label'] =  '';
					    rowBtn2 ['fieldName'] =  'Pricing';
					    rowBtn2['type'] =  'button';
					    rowBtn2['typeAttributes'] = {label: 'Pricing', variant: 'brand', name: 'pricing'};
					    
					    columnsToset.push(rowBtn2);
				    }*/
				   //adding a detail btn for every table, except the offer one
				   if(component.get("v.queryType") != "OFFER"){
                       // START MORITTU ANDREA 24-Sept-2019 - PRODOB_469 
                    let actions = [
                        { label: $A.get("$Label.c.OB_Details"), name: 'attributeBtn' },
                        { label:  $A.get("$Label.c.OB_ActiveServices_Label"), name: 'innerObjects' }
                    ];
                    // END MORITTU ANDREA 24-Sept-2019 - PRODOB_469 

					     var rowBtn = new Object();
					 	rowBtn ['label'] =  '';
					    rowBtn ['fieldName'] =  'action';
                        rowBtn ['type'] =  'button-icon';
                        /* Doris D. 27/02/2019 --------------- CHANGE 'utility:search' TO 'utility:threedots'-----------*/
					    rowBtn['typeAttributes'] = {iconName:  'utility:threedots', variant: 'container', name: 'attributeBtn', alternativeText: 'search', iconClass: 'searchIcon'};//{label:  $A.get("$Label.c.OB_Details"), variant: 'Neutral', name: 'attributeBtn'};
					    var cellAttributes = {};
					    cellAttributes.alignment = 'right';
					    rowBtn['cellAttributes'] =cellAttributes;
					    columnsToset.push(rowBtn);
				    }
                    var activateEnablementsButton = component.get("v.TerminalEnablementsViewActivate"); 
                   // if( activateEnablementsButton ){
                       /*   var actions = [
                         { label: 'Show details', name: 'show_details' },
                        
                    ], 
                    fetchData = {
                        Id : 'Id',
                        
                    };
                    columnsToset.push({ type: 'action', typeAttributes: { rowActions: actions } }); */
                    //    columnsToset.push ({label: 'View', type: 'button', initialWidth: 135, typeAttributes: { label: 'Enablements', name: 'view_Enablements', title: 'Click to View Enablements'}} );
                    //}

                    // to remove START
                    /*var row = new Object();
                        row ['label'] =  'Id';
                        row ['fieldName'] =  'Id';
                        row ['type'] =  'Text';
                        columnsToset.push(row);*/
                    // TO REMOVE END


                //	console.log('columnsToset ',columnsToset );
                    // ANDREA MORITTU START 2019-24-Sept
					component.set('v.tableColumns',columnsToset);
					//if(component.get("v.queryType") == "ACQUIRING"){
						console.log('@@@dataToShow',result);
                    //}
                    	if(component.get("v.queryType") == "VAS"){
                            component.set('v.VASresult',result); //francesca.ribezzi 10/10/19 -WN-599 - setting this list so that 'no data' message is not shown when it comes to Vas datatable
					
                        }
                    //ANDREA MORITTU START 23-Sept-2019 - PRODOB_469
                    let dataToShow = [];
                    dataToShow = result.dataToShow;
                    //ANDREA MORITTU END 23-Sept-2019 - PRODOB_469
					component.set('v.dataToShow',dataToShow);
					//francesca.ribezzi - getting user license:
                    if(component.get("v.queryType") == "OFFER"){
                    	this.getUserLicense(component, event, result); 
                    }

                    
                    //end parent try

                }
                catch(err){
                	console.log(err.message);
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);    
	},


    updateEnablements : function(component, event, helper, rowId) {
         var action = component.get('c.retriveEnablements');
           action.setParams({ 
            "terminalid" : rowId
        });

           action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                try{

                    var valueReturns = response.getReturnValue();
                    var result = JSON.parse( valueReturns );
                    //console.log('Enablements result is '+ result);
                    if(result ){
                    //      console.log('Enablements result.length is '+ result.length);
                        if(result.length != 0){
                            component.get('c.EnablementsFound', true);
                            EnablementsData = [0];
                            for (var i = 0; i < result.length; i++) { 
                                var row = new Object();
                                //console.log('Enablements  result[i].name is '+ result[i].name);
                                //console.log('Enablements  result[i].icon is '+ result[i].icon);
                                 row ['name'] =  result[i].name;
                                row ['icon'] =   result[i].icon;
                                EnablementsData.push(row);
                            }
                            component.get('c.EnablementsData', EnablementsData);
                        }
                        else{
                            component.get('c.EnablementsFound', false);
                        }
                      
                    }
               
                

                }
                catch(err){
                    component.get('c.EnablementsFound', false);
                    console.log(err);
                }
            } else if (state === "ERROR") {
                component.get('c.EnablementsFound', false);
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);    

    },
    getUserLicense: function(component,event, result){
    	var userId =  $A.get("$SObjectType.CurrentUser.Id");
    	var tableColumns = component.get("v.tableColumns");
        var action = component.get("c.getUserLicenseServer");
        action.setParams({
            userId: userId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            	var userWrap = response.getReturnValue();
            	console.log("@@@userWrap?? " + JSON.stringify(userWrap));
            	// component.set("v.currentUser",  response.getReturnValue().user);
                //console.log("userWrap? ", userWrap);            
                //if it is not partner community, showing abi column on offer table
                if(!userWrap.isCommunity && component.get("v.queryType") == "OFFER"){
                	var row = new Object();
            			row ['label'] =  'ABI';
						row ['type'] =  'text';
						row ['fieldName'] =  'OB_ProposerABI__r.OB_ABI__c';
					 tableColumns.push(row);
					 component.set("v.tableColumns", tableColumns);
				}  
				this.sendEvent(component,event, userWrap.isCommunity, result);
            } else if (state === "INCOMPLETE") {
                // do something
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

        $A.enqueueAction(action);
    },

    sendEvent: function(component,event, isCommunity, result){   
    	console.log("into sendEvent");
        var datasize = result.dataToShow.length;
        if( datasize == 0 ){
            var cmpTarget = component.find('table');
            $A.util.addClass(cmpTarget, 'slds-hide');
             component.set('v.showTable',false);
        }

		// select by default the first element
		var maxRow =   component.get('v.MaxRowSelection');
        if( maxRow != 0) {
            try{
                //francesca.ribezzi 22/03/19 checking is dataToShow list is greater than 0!!
                if(result.dataToShow.length>0){
            var  selectedRow = [result.dataToShow[0].Id];
            // set default on table
            var tabella = component.find("table");
			tabella.set('v.selectedRows',selectedRow);
            // set selected parameter on component , to filetr other related component
            component.set('v.selectedRow',result.dataToShow[0].Id);
            var offerAssetId;
            var offerAsset;
            }
            if(component.get("v.queryType") == "OFFER" && result.dataToShow.length > 0){
            	offerAssetId =  result.dataToShow[0].Id;
            	offerAsset =  result.dataToShow[0];
            	 console.log("offerAssetId: "+ offerAssetId);
            }
            
           //francesca.ribezzi - firing event to father cmp:
           console.log("before calling showLabelEvent");
        
            var showLabelEvent = component.getEvent("showLabelEvent");
	        showLabelEvent.setParams({
	        	showLabel: (datasize != 0),
	        	offerAssetId: offerAssetId,
	        	offerAsset: offerAsset,
	        	isCommunity: isCommunity,
	        	currentUser: component.get("v.currentUser")
	        });
	           console.log("showLabel: " + (datasize != 0) + " offerAsset: " + offerAsset + " isCommunity: " + isCommunity + "currentUser"+ JSON.stringify(component.get("v.currentUser")));
	        showLabelEvent.fire();
	       
            }
            catch(err){
                // no data showed, so nothing is selected
            }
        }
    },
    
    getAssetAttribute: function(component,row){
    //	console.log("assetID? " + row.Id);
    	var action = component.get("c.getAssetAttributeServer");
        action.setParams({
            assetId: row.Id
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //console.log("itemAttributes? ", response.getReturnValue());

                component.set("v.itemAttributesColumns",  [{ label: $A.get("$Label.c.OB_Name"), fieldName: 'Name', type: 'text'},  { label: $A.get("$Label.c.OB_Value"), fieldName: 'NE__Value__c', type: 'text'}]);
                // ANDREA MORITTU START 23-Sept-2019 - PRODOB_469
                let assetList =  [];
                assetList = response.getReturnValue();
                // ANDREA MORITTU END 23-Sept-2019 - PRODOB_469
            	component.set("v.itemAttributes",  assetList);
            	component.set("v.showModal", true);  
            } else if (state === "INCOMPLETE") {
                // do something
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

        $A.enqueueAction(action);
    
    },


    wait : function(ms) {

   var start = new Date().getTime();
   var end = start;
   while(end < start + ms) {
   end = new Date().getTime();
  }
},

    /**
     * 
     * Author Morittu Andrea
     * Date 27-Sept-2019
     * Task PRODOB_469
     * Description Method used to build the mcc modal
    **/

    buildMCCmodal : function(component, event, row) {
        let lovList = component.get('v.mccLOVSList');
        if(!$A.util.isUndefinedOrNull(lovList) && !$A.util.isUndefinedOrNull(row)) {

            let milliSecondsToWait = 4000;
            let secondToWait = milliSecondsToWait / 1000;
            let mcc = new Object();
            for(let index in lovList) {
                if(lovList[index].NE__Value2__c == row.OB_MCC__c) {
                    mcc.code = row.OB_MCC__c;
                    mcc.description = lovList[index].Name;
                    break;
                }
            }
            component.set('v.MCCobj', mcc);
        }
    },
})