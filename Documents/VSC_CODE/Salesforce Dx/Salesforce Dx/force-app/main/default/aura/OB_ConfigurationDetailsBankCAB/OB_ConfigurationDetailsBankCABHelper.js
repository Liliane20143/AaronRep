({
    retrieveMatrixParameterRows: function(component, event) { //,clonedRows, parentCloneId
    	console.log("into retrieveMatrixParameterRows");
        var matrixParameter = component.get('v.matrixParameter');
        console.log("matrixParameterId: " + matrixParameter.Id);
        //var matrixParameterId = matrixParameter.Id;
        var offerName =  component.get('v.offer').Name;
        var action = component.get("c.getRowsByMatrixParameterId");
        action.setParams({
            matrixParameter: matrixParameter,
            offerName: offerName
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("From server retrieveMatrixParameterRows: ", response.getReturnValue());
                var  rows= response.getReturnValue();
                var parentChildrenRows = [];
                var parents = [];
                var children = [];
                var childrenTempList =  [];
                for(var i = 0; i< rows.length; i++){
                	 if($A.util.isEmpty(rows[i].OB_SelfLookup__c)){
                		 parents.push(rows[i]);
                	 }else{
                		 console.log("it's a child");
                		 children.push(rows[i]);
                	 }
                 }
                for(var j = 0; j<parents.length; j++){
                	var cloneId = '';
                	parentChildrenRows.push({
            				"parent": parents[j],
            				"children":[],
            				"cloneId":cloneId
                	});

                	for(var k = 0; k<children.length; k++){
                		console.log("children[k].OB_SelfLookup__c: " + children[k].OB_SelfLookup__c);
                		console.log("parents[j].Id: " + parents[j].Id);
                		if(children[k].OB_SelfLookup__c ==parents[j].Id){
                			console.log("it's a match");
                			//console.log("children found per parent: " +k);
                			parentChildrenRows[j].children.push(children[k]);
                		}
                	}
                	//childrenTempList = [];
                }  
                component.set("v.parentChildrenRows",parentChildrenRows);
                console.log("parentChildrenRows def: " , parentChildrenRows);
                component.set("v.spinner", false);
                //this.handleRowsAttributes(component, event);
            //    this.getFamiliesForChildrenRows(component, event);
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
    
    getFamiliesForChildrenRows: function(component, event) {
    	console.log("into getFamiliesForChildrenRows");
        var parentChildrenRows = component.get('v.parentChildrenRows');
        var products = [];
 
    	for(var i = 0; i< parentChildrenRows.length; i++){
    		for(var j = 0; j< parentChildrenRows[i].children.length; j++){
	    		if(products.length == 0){
	    			products.push({"Id" : parentChildrenRows[i].children[j].OB_Product__c});
	    		}else{
		    		for(var k= 0; k<products.length; k++){
		    			if(parentChildrenRows[i].children[j].OB_Product__c != products[k].Id){
		    				products.push({"Id" : parentChildrenRows[i].children[j].OB_Product__c});
		    			}	
		    		}	
		    	}
	    	}
    	}
        var action = component.get("c.getFamiliesForChildrenRowsServer");
        action.setParams({
            products: products
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("From server getFamiliesForChildrenRows: ", response.getReturnValue());
                component.set("v.childrenRowsfamilies", response.getReturnValue());
                
               // this.retrieveAttributesForChildren(component, event);
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
    
   /* retrieveAttributesForChildren: function(component, event) {
    	console.log("into retrieveAttributesForChildren");
    	var childrenRowsfamilies = component.get("v.childrenRowsfamilies");
        var families = [];
        var parentChildrenRows  = component.get("v.parentChildrenRows");
        for (var i = 0; i < childrenRowsfamilies.length; i++) {
            families.push({
                "Id": childrenRowsfamilies[i].NE__FamilyId__c
            });
        }
    	var action = component.get("c.getChildrenAttributes");
        action.setParams({
        	families : families
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("children attributes from server: ", response.getReturnValue());
                var attributes = response.getReturnValue();
     
                 for(var i = 0; i<parentChildrenRows.length; i++){
                	for(var j = 0; j<parentChildrenRows[i].children.length; j++){
                		//console.log("into children for");
                		//console.log("into childrenRowsfamilies for");
                			if(parentChildrenRows[i].children[j].OB_Product__c == childrenRowsfamilies[k].NE__ProdId__c){
                			//console.log("it's the same product!");
                				for(var y = 0; y<attributes.length; y++){
                				//console.log("inside attributes for!");
            						//console.log("it's the same family!");
            						parentChildrenRows[i].attributes.push(attributes[y]);
                	
                				}
                	
                		}
                	}
                }
                console.log("parentChildrenRows after seeting attributes: " , parentChildrenRows);
                component.set("v.parentChildrenRows", parentChildrenRows);
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
    },*/
    
    
    //creating a new attributes list where keys are  formed by API fieldname and values are their own values:
  /*  handleRowsAttributes: function(component, event) {
        var rows = component.get("v.rows");
        var attributes = [];
        var mapLabelField = {};
        //	mapLabelField["Massimale"] = OB_Massimale__c;

        for (var i = 0; i < rows.length; i++) {
            attributes.push({
                itemId: rows[i].Id,
                OB_Massimale__c: rows[i].OB_Massimale__c,
                OB_Minimo__c: rows[i].OB_Minimo__c,
                OB_Massimo__c: rows[i].OB_Massimo__c,
                OB_Soglia_Max_Approvazione__c: rows[i].OB_Soglia_Max_Approvazione__c,
                OB_Soglia_Min_Approvazione__c: rows[i].OB_Soglia_Min_Approvazione__c,
                OB_Valore_Default__c: rows[i].OB_Valore_Default__c,
                readonly: true
            });
        }
        component.set("v.attributes", attributes);
        component.set("v.spinner", false);
    },*/
    
    //inserting into DB a new matrix parameter row, identical to the one we choose to clone it with:
    cloneRow: function(component, rowToClone, index, event) {
        var parentChildrenRows = component.get("v.parentChildrenRows");
       
        //THIS PART IS USED FOR CLONING ROW IN JS:  
       /*
        var clonedRows = JSON.parse(JSON.stringify(rowToClone));
        //setting the cloneId attribute as the row's Id this new cloned row comes from:
        clonedRows.cloneId = rowToClone.parent.Id;
    
        clonedRows.parent.Id = '';
        clonedRows.parent.NE__Start_Date__c = null;
        clonedRows.parent.NE__End_Date__c = null;
        var children = [];
       // parentChildrenRows[parseInt(index)].parent.push(clonedRows.parent);
       
     //  parentChildrenRows.splice(index, 0, clonedRows.parent);
        for(var i = 0; i<clonedRows.children.length; i++){
        	clonedRows.children[i].NE__Start_Date__c = null;
        	clonedRows.children[i].NE__End_Date__c = null;
        	clonedRows.children[i].Id = '';
        	clonedRows.children[i].OB_SelfLookup__c = '';
        	children.push(clonedRows.children[i]);
        	//parentChildrenRows[parseInt(index)].children.push(clonedRows.children[i]);
        //	parentChildrenRows.splice(index, 0, clonedRows.children[i]);
        }
    
        
        parentChildrenRows.unshift({
                				"parent": clonedRows.parent,
                				"children":children,
                				"cloneId": clonedRows.cloneId
                			});

        component.set("v.parentChildrenRows", parentChildrenRows);
        component.set("v.spinner", false);
        */
        //END JS PART
        var rowParent = rowToClone.parent;
        var rowChildren = rowToClone.children;
        var clonedRows;
		var action = component.get("c.insertCloneRow");
 		action.setParams({
            rowParent: rowParent,
            rowChildren : rowChildren
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("From server cloneRow: ", response.getReturnValue());
                clonedRows = response.getReturnValue();
                var parentCloneId =rowToClone.parent.Id; // rowToClone.children[0].OB_SelfLookup__c;
                // this.retrieveMatrixParameterRows(component, event, clonedRows, parentCloneId);
                var children = [];
                var parent;
                for(var i = 0; i< clonedRows.length; i++){
            	   if($A.util.isEmpty(clonedRows[i].OB_SelfLookup__c)){
            		  parent = clonedRows[i];
            	   }else{
            	      children.push(clonedRows[i]);
            		   console.log("it's a child");
            		 
            	   }
                } 
                parentChildrenRows.unshift({
        				"parent": parent,
        				"children":children,
        				"cloneId": rowToClone.parent.Id
        			});
        		component.set("v.parentChildrenRows", parentChildrenRows);
                component.set("v.spinner", false);
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
    //calling the server-side to save all the changes we make on the list of matrix parameter rows:
    saveRows: function(component, event) {
        var parentChildrenRows = component.get("v.parentChildrenRows");
        var rows = [];
        for(var i = 0; i<parentChildrenRows.length; i++){
        	for(var j = 0; j<parentChildrenRows[i].children.length; j++){
	        	rows.push(parentChildrenRows[i].parent);
	        	rows.push(parentChildrenRows[i].children[j]);
        	}
        }
        console.log("rows: ", rows);
        var action = component.get("c.updateRows");
        action.setParams({
            rows: rows,
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("From server: ", response.getReturnValue());
                //component.set("v.rows", response.getReturnValue());
                //this.handleRowsAttributes(component, event);
               // component.set("v.disableNewCardBtn", false);
                this.retrieveMatrixParameterRows(component, event);
                component.set("v.spinner", false);
                //document.getElementById("createNewRowBtn").disabled = false;
                //document.getElementById("createNewRowBtn").classList.remove('disabledBtn');
                //toast goes here:
                this.showSuccessToast(component, event);
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

    showSuccessToast: function(component, event) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: '',
            message: 'Records saved successfully',
            //messageTemplateData: [name],
            duration: '5000',
            key: 'info_alt',
            type: 'success',
            mode: 'dismissible'
        });
        toastEvent.fire();
    },

    getCatalogItemsByProductId: function(component, event) {
        console.log("into getCatalogItemsByProductId");
        var matrixParameter = component.get("v.matrixParameter");
        var productName = matrixParameter.Name;
        var action = component.get("c.getCatalogItemsByProductIdServer");
        action.setParams({
            productName: productName
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("catalogItems From server: ", response.getReturnValue());
                component.set("v.catalogItems", response.getReturnValue());
                component.set("v.SearchKeyWord", '');
                component.set("v.Message", '');
				component.set("v.listOfSearchRecords", []);		
				component.set("v.families", []);	
				component.set("v.attributesAndNewRows", []);						           
                //component.set("v.showEmptyCard", true);
                component.set("v.showAttributesCard", true);
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
    //TO DO: CHANGE THIS FUNCTION! ONLY USED TO TEST:
   /* getCatalogItems: function(component, event) {
        console.log("into getCatalogItems");
        var rows = component.get("v.rows");
        var catalogs = [];
        var componente;
        var action = component.get("c.getCommercialProducts");
        action.setParams({
            rows: rows
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("catalogItems From server: ", response.getReturnValue());
                component.set("v.catalogItems", response.getReturnValue());
                component.set("v.showEmptyCard", true);
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
    },*/

    insertNewRows: function(component, event) {
        console.log("into insertNewRows");
        var newRows = component.get("v.newRows");
        var newRow = component.get("v.newRow");
        console.log("row parent??" + JSON.stringify(newRow));
        var attributesAndNewRows = component.get("v.attributesAndNewRows");
        //var productId = component.get("v.productId");
        var matrixParameterId = component.get("v.matrixParameter").Id;
       // var componente = component.get("v.OB_Componente__c");
        var action = component.get("c.insertNewRowsServer");
        action.setParams({
            newRows: newRows,
            newRow: newRow,
            matrixParameterId: matrixParameterId,
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("new rows From server: ", response.getReturnValue());
                //component.set("v.newRow", null);
                component.set("v.showEmptyCard", false);
              //  var defaultNewRow = {'sobjectType':'NE__Matrix_Parameter_Row__c', 'OB_Massimale__c':'0', 'OB_Massimo__c':'0','OB_Minimo__c':'0', 'OB_Soglia_Max_Approvazione__c':'0','OB_Soglia_Min_Approvazione__c' : '0','OB_Valore_Default__c' :'0', 'OB_SelfLookup__c' : '', 'OB_Product__c' : ''};
                //component.set("v.newRow", defaultNewRow);
              //  component.set("v.catalogItems", response.getReturnValue());
                component.set("v.SearchKeyWord", '');
                component.set("v.Message", '');
				component.set("v.listOfSearchRecords", []);		
				component.set("v.families", []);	
                component.set("v.attributesAndNewRows", []);
                this.retrieveMatrixParameterRows(component, event);
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
    getFamilies: function(component, event, catalogItem) { //NE__ProductId__c!!
        console.log("into getFamilies");
        console.log("productId into getFamilies: " + catalogItem.NE__ProductId__c);
        var action = component.get("c.getFamiliesServer");
        action.setParams({
            productId: catalogItem.NE__ProductId__c
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("productFamilies from server: ", response.getReturnValue());
                //component.set("v.newRow", null);
                var productFamilies = response.getReturnValue();
                component.set("v.families", productFamilies);
                var families = [];
                for (var i = 0; i < productFamilies.length; i++) {
                    families.push({
                        "Id": productFamilies[i].NE__FamilyId__c
                    });
                }

                this.retrieveAttributesFromFamilies(component, event, families);
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

    retrieveAttributesFromFamilies: function(component, event, families) {
        console.log("into retrieveAttributesFromFamilies ");
        console.log("families are: ", families);
        var productFamilies = component.get("v.families");
        var matrixParameter = component.get("v.matrixParameter");
        var attributesAndNewRows = [];
        var newRows = [];
        var productId = component.get("v.newRow").OB_Product__c;
        console.log("productId to pass to newRows.."+ productId);
        var action = component.get("c.retrieveAttributesFromFamilies");
        action.setParams({
            families: families
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("attributes from server: ", response.getReturnValue());
                //component.set("v.newRow", null);
                component.set("v.attributesList", response.getReturnValue());
                 var attributesList = component.get("v.attributesList");
                 //  listaOrderItems.push({'sobjectType':'OrderItem__c', 'Gift__c': gift.Id,'Quantity__c':'1', 'Gift__r':gift});
                for(var i = 0; i<attributesList.length; i++){
                	//var tempRow = component.get("v.tempRow");
                	//newRows.push(tempRow);
                	newRows.push({'sobjectType':'NE__Matrix_Parameter_Row__c', 'OB_DynamicPropertyDefinition__c':'', 'OB_Family__c': '', 'OB_ReadOnly__c':'false', 'OB_Massimale__c':'0', 'OB_Massimo__c':'0','OB_Minimo__c':'0', 'OB_Soglia_Max_Approvazione__c':'0','OB_Soglia_Min_Approvazione__c' : '0','OB_Valore_Default__c' :'0', 'OB_SelfLookup__c' : '', 'OB_Product__c' : productId, 'NE__Start_Date__c' : '', 'NE__End_Date__c' : '', 'NE__Active__c':'','NE__Matrix_Parameter__r':'', 'OB_Sequence__c':'', 'OB_Codici__c' : ''});
                	newRows[i].OB_DynamicPropertyDefinition__c = attributesList[i].NE__PropId__c;
                	newRows[i].OB_Family__c = attributesList[i].NE__FamilyId__c;
                	attributesAndNewRows.push({
	            		"attribute":attributesList[i],
	            		"newRow": newRows[i],
	            		"readOnly": 'false'
            	  	}); 	
                }  
                component.set("v.attributesAndNewRows", attributesAndNewRows);
                console.log("attributesAndNewRows Test: ", attributesAndNewRows);
                component.set("v.newRows", newRows);
                component.set("v.attributeSpinner", false);
                component.set("v.showAttributesCard", true);

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
    
    searchHelper : function(component, event) {
		
      var searchText = component.get('v.SearchKeyWord');
      var action = component.get('c.getCatalogItems');
      action.setParams({searchText: searchText});
      action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === 'SUCCESS') {
          var products = response.getReturnValue();
            console.log("products found: ", products);
             // if storeResponse size is equal 0 ,display No Result Found... message on screen.    
	        if (products.length == 0) {
	        	var message = $A.get("$Label.c.OB_NoResultMsg");
	            component.set("v.Message", message);
	        } else {
	            component.set("v.Message", '');
	            //component.set("v.catalogItems", products);
	        }
          component.set("v.listOfSearchRecords", products);
        }
      });
      $A.enqueueAction(action);
    },
    
    deleteRowServer: function(component, event, selectedRow) {
    	var parentChildrenRows = component.get("v.parentChildrenRows");
    	var index = component.get("v.indexRowToDelete");
	    var action = component.get('c.deleteSelectedRow');
	    var listToDelete = [];  
	    listToDelete.push(selectedRow.parent);
        for(var i = 0; i<selectedRow.children.length; i++){
	        listToDelete.push(selectedRow.children[i]);
	    }
        console.log("listToDelete: " , listToDelete);
	    action.setParams({listToDelete: listToDelete});
	    action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === 'SUCCESS') {
        	 //response.getReturnValue();
        	parentChildrenRows.splice(parseInt(index), 1);
        	component.set("v.parentChildrenRows", parentChildrenRows);
        	component.set("v.spinner", false);
  
	    }else if (state === "INCOMPLETE") {
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

})