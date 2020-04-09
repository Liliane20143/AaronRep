({

	testBtn : function(component, event, helper) {
		console.log('testtttttttttttttttt');
	},

	retrieveFieldsLabel : function(component, event, helper) {

		console.log('retrieveFieldsLabel start');
		try{
            var action = component.get('c.retriveInformationTree');
        
            var listOfFields = component.get("v.fieldsToShow"); 
      	     var ObjectToShow = component.get("v.ObjectToShow"); 
            var queryType = component.get("v.queryType"); 
      	    var parentidretrived = component.get("v.recordparentid"); 
        

            //console.log('**************************** parentid is '+parentidretrived);


           // console.log('retrieveFieldsLabel value retrived');
        }	
        catch(err)
        {
	       console.log(err);
        }
//(list<string> fieldsToRetrive, string SObjectToRetrive, string queryType, string parentid)
        action.setParams({ 
            "fieldsToRetrive" : listOfFields,
            "offerid" : parentidretrived

        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var valueReturns = response.getReturnValue();
                var myMap = new Map(); 
                var result = JSON.parse( valueReturns );
                //console.log("@@@result: ", result);
                try{
                	var fieldReturned  = result.listOfField;

                	var columnsToset = new Array(0);
                	/*	var row = new Object();
            			row ['label'] = $A.get("$Label.c.OB_Name");
					    row ['type'] =  fieldReturned[0].fieldTypebel;
					    row ['fieldName'] = 'Name';
					    row['initialWidth'] = 100;
                	columnsToset.push(row);*/
					for (var i = 0; i < fieldReturned.length; i++) { 
						var row = new Object();
						//var cellAttributes = {};
						//cellAttributes.alignment = 'right';				
						//console.log(' fieldReturned[i].label is '+  fieldReturned[i].fielLabel );
                        //if it's enablement, set an empty label
                        
						if(fieldReturned[i].fielLabel == 'Enablement'){
							row ['label'] = fieldReturned[i].fielLabel;
						    row ['type'] =  fieldReturned[i].fieldType;
						    row ['fieldName'] = 'OB_enablement__c';
                            row['initialWidth'] = 40;
						   // row ['cellAttributes'] =  cellAttributes;
							
						}
						if(fieldReturned[i].fielLabel == 'Nome asset'){ //changeLabel
							row ['label'] = 'POS';
						    row ['type'] =  fieldReturned[0].fieldType;
						    row ['fieldName'] = 'Name';
                            row['initialWidth'] = 300;
                        }
                        // start antonio.vatrano 28/03/2019 cons-194
                        if((fieldReturned[i].fielLabel).toLowerCase() == 'data inizio'){ //changeLabel
                            // START MORITTU ANDREA 24-Sept-2019 - PRODOB_469 
                            row ['label'] = $A.get("$Label.c.OB_StartValidityDate");
                            // END MORITTU END 24-Sept-2019 - PRODOB_469 
						    row ['type'] =  fieldReturned[0].fieldType;
						    row ['fieldName'] = 'NE__StartDate__c';
                            row['initialWidth'] = 150;
                        }
                         // end antonio.vatrano 28/03/2019 cons-194
                        // START MORITTU ANDREA 24-Sept-2019 - PRODOB_469 
                        if((fieldReturned[i].fielLabel).toLowerCase() == 'data disinstallazione'){
                            row ['label'] = $A.get("$Label.c.OB_EndValidityDate");
						    row ['type'] =  fieldReturned[0].fieldType;
						    row ['fieldName'] = 'NE__StartDate__c';
                            row['initialWidth'] = 150;
                        }
                        //giovanni spinelli - start - 11/10/2019 - change label
                        else if( fieldReturned[i].fielLabel == 'Data di installazione' ){
                            row ['label'] = $A.get("$Label.c.OB_MAINTENANCE_INSTALLATIONDATE");
						    row ['type'] =  'date';
						    row ['fieldName'] = 'InstallDate';
                            row['initialWidth'] = 150;
                        }
                        //giovanni spinelli - end - 11/10/2019 - change label
						else{
							row ['label'] =  fieldReturned[i].fielLabel;
							row ['type'] =  fieldReturned[i].fieldType;
                            row ['fieldName'] =  fieldReturned[i].fieldName;
                        }  
                        if(fieldReturned[i].fieldName == 'NE__Status__c'){

                        }else {
                            columnsToset.push(row);
                        }
                        // END MORITTU ANDREA 24-Sept-2019 - PRODOB_469 
					}

					
					//francesca.ribezzi - adding a new action column displaying an edit button:
					/* var rowBtn = new Object();
				 	rowBtn ['label'] =  'Azioni';
				    rowBtn ['fieldName'] =  'Azioni';
				    rowBtn ['type'] =  'button';
				    rowBtn['typeAttributes'] = {label: 'Modifica', variant: 'Neutral', name: 'editRecord'};
                    columnsToset.push(rowBtn);*/

                    /* ANDREA MORITTU START 24-Sept-2019 - PRODOB_469  */
                    /* ANDREA MORITTU START 08-Oct-2019 - EVO_MISALIGNMENT_DEPLOY_MAINTENANCE */
                    var actions = [
                        { label: $A.get("$Label.c.OB_Details"), name: 'attributeBtn', 'iconName': 'utility:zoomin' },
                        { label:  $A.get("$Label.c.OB_ActiveServices_Label"), name: 'innerObjects', 'iconName': 'utility:zoomin' }
                        
                    ];
                    /* ANDREA MORITTU END 08-Oct-2019 - EVO_MISALIGNMENT_DEPLOY_MAINTENANCE */
 
				    var rowBtn = new Object();
				 	rowBtn ['label'] =  '';
				    rowBtn ['fieldName'] =  'Azioni';  //changeLabel
                    rowBtn ['type'] =  'action';
                    /* Doris D. 27/02/2019 --------------- CHANGE 'utility:search' TO 'utility:threedots'-----------*/
				    rowBtn['typeAttributes'] = {name: 'attributeBtn', alternativeText: 'Show Details', iconClass: 'searchIcon', 'rowActions' : actions 
                    };
                    /* ANDREA MORITTU END 24-Sept-2019 - PRODOB_469  */
				     var cellAttributes = {};
				    cellAttributes.alignment = 'right';
				    rowBtn['cellAttributes'] = cellAttributes;
				    columnsToset.push(rowBtn);

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


					//console.log('columnsToset ', columnsToset );

					component.set('v.tableColumns',columnsToset);
					
					//component.set('v.dataToShow',result.dataToShow);
                    // setting data to diplay
                    var objetToShow = result.dataToShow; // retrive from the wrapper the data to show
                    var dataToShow = new Array(0);
                    var childFound = false;
                    // for each object to sho
                    for (var i = 0; i < objetToShow.length; i++) {
                        var rowdata = new Object();
                        rowdata['Id']= objetToShow[i].obj['Id']; // set the default field "Id"
                        // for each columns to show
                        for (var j = 0; j < columnsToset.length; j++) {
                            // set the field columns with the value retrived from the object
                            rowdata [columnsToset[j].fieldName] = objetToShow[i].obj[columnsToset[j].fieldName];
                        }
                        //francesca.ribezzi: if it is enablement field, this sets it to blank:
                         rowdata[columnsToset[1].fieldName] = ''; 
                          rowdata[columnsToset[1].typeAttributes] = {}; 
                        // check if the object has a child object
                        var listofchildren = objetToShow[i].listOfChild;
                        // for all child
                        if(listofchildren) {
                            childFound = true;
                            var children = new Array(0);
                            for (var k = 0; k < listofchildren.length; k++) {
                                var rowdatachild = new Object();
                                // set the default value for id, and the first field settend into the list
                                rowdatachild['Id']=  listofchildren[k].Id; //objetToShow[i].obj['Id'];
                               
                                rowdatachild[columnsToset[0].fieldName] = listofchildren[k].NE__ProdId__r.Name;
                                rowdatachild[columnsToset[1].fieldName] = listofchildren[k].OB_enablement__c; 
                                if(listofchildren[k].OB_enablement__c == 'N'){
                                	rowdatachild[columnsToset[1].fieldName] = 'X';
                                }else if(listofchildren[k].OB_enablement__c == 'Y'){
                                	rowdatachild[columnsToset[1].fieldName] =  "✔";
                                }
                                // ANDREA MORITTU START
                                else if(listofchildren[k]) {
                                    row ['label'] = $A.get("$Label.c.OB_StartValidityDate");
                                    row ['type'] =  fieldReturned[0].fieldType;
                                    row ['fieldName'] = 'NE__StartDate__c';
                                    row['initialWidth'] = 150;
                                }
                              
                                  	
                                // set all the other field to blank
                                 for (var j =2; j < columnsToset.length; j++) {
                                     rowdatachild[columnsToset[j].fieldName] = '';
                                }
                                children.push(rowdatachild);
                            }
                            // Set the child property 
                           // console.log("children: ", children);
                           /* var prodNameChildList = [];
                            for(var x = 0; x<children.length; x++){
                            	prodNameChildList.push(children[x].Name.NE__ProdId__r.Name);
                            }
                            console.log("prodNameChildList: ", prodNameChildList);*/
                            rowdata['_children'] = children; //prodNameChildList;
                        }
                        dataToShow.push(rowdata);
                    }
                   // console.log("@dataToShow tree: ", dataToShow);


                    /* ANDREA MORITTU START 24-Sept-2019 - PRODOB_469  */
                   if(!$A.util.isUndefined(dataToShow) && !$A.util.isEmpty(dataToShow)) {
                       for(let i in dataToShow) {
                           for(let key in dataToShow[i]) {
                            console.log('###key is :: ' + key);
                                switch (key) {
                                    case 'OB_GT__c':
                                        if(dataToShow[i][key] == 'MONETICA') {
                                            dataToShow[i][key] = 'NEXI';
                                        }	
                                        break;
                                    case 'InstallDate':
                                        key = 'Data Attivazione';
                                        break;
                                    case 'NE__EndDate__c':
                                        key = 'Data Disattivazione';
                                        break;
                                }
                           }
                       }
                   }
                /* ANDREA MORITTU END 24-Sept-2019 - PRODOB_469  */



                    component.set('v.dataToShow',dataToShow);
                /* ANDREA MORITTU START 24-Sept-2019 - Commenting broken code
                    if(childFound){
                      component.set('v.gridExpandedRows',dataToShow[0]['Name']);   //dataToShow[0]['Name']
                    }
                 ANDREA MORITTU END 24-Sept-2019 - Commenting broken code */

                    //francesca.ribezzi - test getting all checkIcon:
                    var checkIcons = document.getElementsByClassName('checkIconClass');
                   // console.log("checkIcons js: "+ JSON.stringify(checkIcons));

                    //component.set('v.gridExpandedRows',

                    // ANDREA MORITTU START - 24-Sept-2019 - Change attribute
                    var datasize = dataToShow.length;
                    // ANDREA MORITTU END - 24-Sept-2019 - Change attribute

                    if( datasize == 0 ){
                
                        var cmpTarget = component.find('table');
                        $A.util.addClass(cmpTarget, 'slds-hide');
                         component.set('v.showTable',false);

                    }
                         //francesca.ribezzi - firing event to father cmp:
                        var showLabelEvent = component.getEvent("showLabelEvent");
				        showLabelEvent.setParams({showLabel: (datasize != 0)});
				        showLabelEvent.fire();
                       //  console.log("showLabel: ", showLabel);
					// select by default the first element
					/*var maxRow =   component.get('v.MaxRowSelection');
                    if( maxRow != 0) {
                        try{
                        var  selectedRow = [result.dataToShow[0].Id];
                        // set default on table
                        var tabella = component.find("table");
    					tabella.set('v.selectedRows',selectedRow);
                        // set selected parameter on component , to filetr other related component
                        component.set('v.selectedRow',result.dataToShow[0].Id);
                        }
                        catch(err){
                            // no data showed, so nothing is selected
                        }
                    }*/
                    //francesca.ribezzi - getting user license:
                    this.getUserLicense(component, event);
                }
                catch(err){
                	console.log(err);
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
            "terminalid" : rowId,
            "proposerABI" :component.get("v.proposerABI")// '05696'// TODO: waiting for real value
        });

           action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                try{

                    var valueReturns = response.getReturnValue();
                    var result = JSON.parse( valueReturns );
                  //  console.log('Enablements result is '+ result);
                    if(result ){
                    //      console.log('Enablements result.length is '+ result.length);
                        if(result.length != 0){
                            component.get('c.EnablementsFound', true);
                            EnablementsData = [0];
                            for (var i = 0; i < result.length; i++) { 
                                var row = new Object();
                      //          console.log('Enablements  result[i].name is '+ result[i].name);
                        //        console.log('Enablements  result[i].icon is '+ result[i].icon);
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
    
    editRecord: function(component,row){
    	console.log('into editRecord');  
    	//console.log('selected row: '+ JSON.stringify(row));
    	component.set("v.row", row);
    	component.set("v.showModal", true);  
    	
    },
    
    getAssetAttribute: function(component,row){
    	console.log("assetID? " + row.Id);
    	var action = component.get("c.getAssetAttributeServer");
        action.setParams({
            assetId: row.Id
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
               // console.log("itemAttributes? ", response.getReturnValue());

            	component.set("v.itemAttributesColumns",  [{ label: $A.get("$Label.c.OB_Name"), fieldName: 'Name', type: 'text'},  { label: $A.get("$Label.c.OB_Value"), fieldName: 'NE__Value__c', type: 'text'}]);
            	component.set("v.itemAttributes",  response.getReturnValue());
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
    
    getUserLicense: function(component,event){
    	var userId =  $A.get("$SObjectType.CurrentUser.Id");
    	var tableColumns = component.get("v.tableColumns");
        var action = component.get("c.getUserLicenseServer");
        action.setParams({
            userId: userId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
           // console.log("userWrap? ", response.getReturnValue());
              //  component.set("v.currentUser",  response.getReturnValue().user);
                if(!response.getReturnValue().isCommunity){
                	var row = new Object();
            			row ['label'] =  'ABI';
						row ['type'] =  'text';
						row ['fieldName'] =  'OB_ProposerABI__r.OB_ABI__c';
					 tableColumns.push(row);
					 component.set("v.tableColumns", tableColumns);
				}  
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
    } ,

    /*
    *   Author      :   Morittu Andrea
    *   Date        :   24-Sept-2019
    *   Tas         :   PRODOB_469
    *   Description :   Method Used to Build new modal of 'Active Services' button
    * 
    */
    grabInnerObject : function(component, row) {
        try {
            if(!$A.util.isUndefinedOrNull(row)) {
                let dataList = row._children;
                component.set("v.itemAttributesColumns",  [
                    { label: $A.get("$Label.c.OB_Name"), fieldName: 'Name', type: 'text'},  
                    { label: $A.get("$Label.c.OB_MAINTENANCE_ENABLEMENTS_MODAL_TITLE"), fieldName: 'OB_enablement__c', type: 'text'
                }] );//Simone Misani WN-598 10/10/2019
                component.set("v.itemAttributes",  dataList);
                component.set("v.showModal", true);  
            }
        } catch (exc) {
            console.log('An error has occured : ' + exc.message );
        }
    },


})