({
    retrieveMatrixParameterRows: function(component, event)
    {
    	console.log("into retrieveMatrixParameterRows");
        var matrixParameter = component.get('v.matrixParameter');
        console.log("matrixParameterId: " + matrixParameter.Id);
        var offerName =  component.get('v.offer').Name;
        var action = component.get("c.getRowsByMatrixParameterId");
        action.setParams
        ({
            matrixParameter: matrixParameter,
            offerName: offerName
        });
        action.setCallback(this, function(response)
        {
            var state = response.getState();
            if (state === "SUCCESS")
            {
                console.log("From server retrieveMatrixParameterRows: ", response.getReturnValue());
                var  rows= response.getReturnValue();
                var parentChildrenRows = [];
                var parents = [];
                var children = [];
                var childrenTempList =  [];
                for(var i = 0; i< rows.length; i++)
                {
                	 if($A.util.isEmpty(rows[i].OB_SelfLookup__c))
                	 {
                		 parents.push(rows[i]);
                	 }
                	 else
                	 {
                		 children.push(rows[i]);
                	 }
                 }
                for(var j = 0; j<parents.length; j++)
                {
                	var cloneId = '';
                	parentChildrenRows.push
                	({
            				"parent": parents[j],
            				"children":[],
            				"cloneId":cloneId
                	});

                	for(var k = 0; k<children.length; k++)
                	{
                        if(children[k].OB_SelfLookup__c ==parents[j].Id)
                        {
                            //15/02/19 adding bottom line to markup:
                            if(children[k].OB_Codici__c =='COMMISSIONE4' || children[k].OB_Codici__c =='A1' || children[k].OB_Codici__c =='A2' )
                            {
                                children[k].addLine = true;
                            }
                            else
                            {
                                children[k].addLine = false;
                            }
                			parentChildrenRows[j].children.push(children[k]);
                		}
                	}
                }
                parentChildrenRows.sort(function(a, b)
                {
                    return a.parent.OB_Sequence__c == b.parent.OB_Sequence__c ? 0 : +(a.parent.OB_Sequence__c > b.parent.OB_Sequence__c) || -1;
                });
                 
                for(var i = 0; i< parentChildrenRows.length; i++)
                {
                    parentChildrenRows[i].children.sort(function(a,b)
                    {
                        var tempChild = a.OB_Family__r.Name.localeCompare(b.OB_Family__r.Name);
                        var obj = {'Commissione' : 0, 'da' : 1, 'a': 2};
                        var aName = a.OB_DynamicPropertyDefinition__r.Name;
                        var bName = b.OB_DynamicPropertyDefinition__r.Name;


                        if(tempChild == 0){
                            if(obj.hasOwnProperty(aName) && obj.hasOwnProperty(bName)){
                                tempChild = (obj[aName] < obj[bName] ? -1 : (obj[aName] > obj[bName] ? 1 : 0));
                            }
                        }
                        return tempChild;
                    });
                }

                component.set("v.parentChildrenRows",parentChildrenRows);
                console.log("parentChildrenRows def: " , parentChildrenRows);
                component.set("v.spinner", false);

                //CHECK THIS FUNCTION: problemi di scalabilità
            }
            else if (state === "INCOMPLETE")
            {
                // do something
            }
            else if (state === "ERROR")
            {
                var errors = response.getError();
                if (errors)
                {
                    if (errors[0] && errors[0].message)
                    {
                        console.log("Error message: " +errors[0].message);
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
    
    getFamiliesForChildrenRows: function(component, event)
    {
    	console.log("into getFamiliesForChildrenRows");
        var parentChildrenRows = component.get('v.parentChildrenRows');
        var products = [];
 
    	for(var i = 0; i< parentChildrenRows.length; i++)
    	{
    		for(var j = 0; j< parentChildrenRows[i].children.length; j++)
    		{
	    		if(products.length == 0)
	    		{
	    			products.push({"Id" : parentChildrenRows[i].children[j].OB_Product__c});
	    		}
	    		else
	    		{
		    		for(var k= 0; k<products.length; k++)
		    		{
		    			if(parentChildrenRows[i].children[j].OB_Product__c != products[k].Id)
		    			{
		    				products.push({"Id" : parentChildrenRows[i].children[j].OB_Product__c});
		    			}	
		    		}	
		    	}
	    	}
    	}
        var action = component.get("c.getFamiliesForChildrenRowsServer");
        action.setParams
        ({
            products: products
        });
        action.setCallback(this, function(response)
        {
            var state = response.getState();
            if (state === "SUCCESS")
            {
                console.log("From server getFamiliesForChildrenRows: ", response.getReturnValue());
                component.set("v.childrenRowsfamilies", response.getReturnValue());
            }
            else if (state === "INCOMPLETE")
            {
                // do something
            }
            else if (state === "ERROR")
            {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message)
                    {
                        console.log("Error message: " +errors[0].message);
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
    
    //inserting into DB a new matrix parameter row, identical to the one we choose to clone it with:
    cloneRow: function(component, rowToClone, index, event)
    {
        var parentChildrenRows = component.get("v.parentChildrenRows");
        //END JS PART
        var rowParent = rowToClone.parent;
        var rowChildren = rowToClone.children;
        var clonedRows;
		var action = component.get("c.insertCloneRow");
 		action.setParams
 		({
            rowParent: rowParent,
            rowChildren : rowChildren
        });
        action.setCallback(this, function(response)
        {
            var state = response.getState();
            if (state === "SUCCESS")
            {
                console.log("From server cloneRow: ", response.getReturnValue());
                clonedRows = response.getReturnValue();
                var parentCloneId =rowToClone.parent.Id;
                var children = [];
                var parent;
                for(var i = 0; i< clonedRows.length; i++)
                {
                    if($A.util.isEmpty(clonedRows[i].OB_SelfLookup__c))
                    {
                        parent = clonedRows[i];
                    }
                    else
                    {
                        //15/02/19 adding bottom line to markup:
                        if(clonedRows[i].OB_Codici__c =='COMMISSIONE4' || clonedRows[i].OB_Codici__c =='A1' || clonedRows[i].OB_Codici__c =='A2' )
                        {
                            clonedRows[i].addLine = true;
                        }
                        else
                        {
                            clonedRows[i].addLine = false;
                        }
                        children.push(clonedRows[i]);
                        console.log("it's a child");
                    }
                } 
                parentChildrenRows.unshift
                ({
                    "parent": parent,
                    "children":children,
                    "cloneId": rowToClone.parent.Id
                });
                component.set("v.parentChildrenRows", parentChildrenRows);
                component.set("v.spinner", false);
            }
            else if (state === "INCOMPLETE")
            {
                // do something
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
        $A.enqueueAction(action);
    },

    //calling the server-side to save all the changes we make on the list of matrix parameter rows:
    saveRows: function(component, event)
    {
        var parentChildrenRows = component.get("v.parentChildrenRows");
        var rows = [];
        console.log("matrix parameter" + JSON.stringify(component.get("v.matrixParameter")));
        console.log("OB_Componente__c" + JSON.stringify(component.get("v.matrixParameter").OB_Componente__c));
        var itemHeader = ''+component.get('v.matrixParameter').OB_Componente__r.NE__Item_Header__c;
        component.set("v.itemHeader", itemHeader);
        var itemHeaderAttr = component.get("v.itemHeader");
        console.log("itemHeaderAttr: " + itemHeaderAttr);
        console.log("itemHeader: " + itemHeader);
        for(var i = 0; i<parentChildrenRows.length; i++)
        {
        	rows.push(parentChildrenRows[i].parent);
        	for(var j = 0; j<parentChildrenRows[i].children.length; j++)
        	{
	        	rows.push(parentChildrenRows[i].children[j]);
        	}
        }  
        console.log("rows: ", rows);
        var action = component.get("c.updateRows");
        action.setParams
        ({
            rowList: rows,
            itemHeader: itemHeaderAttr
        });
        action.setCallback(this, function(response)
        {
            var state = response.getState();
            if (state === "SUCCESS")
            {
                console.log("saveRows From server: ", response.getReturnValue());
                //toast goes here:
                this.showSuccessToast(component, event);
                //not calling retrive anymore cause it's going back to OB_ConfigurazioniTable cmp:
                var event = $A.get("e.force:navigateToComponent");
			    event.setParams
			    ({
			        componentDef : "c:OB_ConfigurazioniTable",
			        componentAttributes :
			        {
			        	offerta: component.get("v.offer")
			        }	
			    });
			    event.fire();
            }
            else if (state === "INCOMPLETE")
            {
                // do something
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
        $A.enqueueAction(action);
    },

    showSuccessToast: function(component, event)
    {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams
        ({
            title: '',
            message: 'Records saved successfully',
            duration: '5000',
            key: 'info_alt',
            type: 'success',
            mode: 'dismissible'
        });
        toastEvent.fire();
    },

    getCatalogItemsByProductId: function(component, event)
    {
        console.log("into getCatalogItemsByProductId");
        var matrixParameter = component.get("v.matrixParameter");
        var productName = matrixParameter.Name;
        var action = component.get("c.getCatalogItemsByProductIdServer");
        action.setParams
        ({
            productName: productName
        });
        action.setCallback(this, function(response)
        {
            var state = response.getState();
            if (state === "SUCCESS")
            {
                console.log("catalogItems From server: ", response.getReturnValue());
                component.set("v.catalogItems", response.getReturnValue());
                component.set("v.SearchKeyWord", '');
                component.set("v.Message", '');
                component.set("v.listOfSearchRecords", []);
                component.set("v.families", []);
                component.set("v.attributesAndNewRows", []);
                component.set("v.showAttributesCard", true);
            }
            else if (state === "INCOMPLETE")
            {
                // do something
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
        $A.enqueueAction(action);
    },

    insertNewRows: function(component, event)
    {
        console.log("into insertNewRows");
        var newRows = component.get("v.newRows");
        var newRow = component.get("v.newRow");
        console.log("row parent??" + JSON.stringify(newRow));
        var attributesAndNewRows = component.get("v.attributesAndNewRows");
        var matrixParameterId = component.get("v.matrixParameter").Id;
        var matrixParameter = component.get("v.matrixParameter");
        var action = component.get("c.insertNewRowsServer");
        action.setParams
        ({
            newRows: newRows,
            newRow: newRow,
            matrixParameterId: matrixParameterId,
            matrixParameter: matrixParameter
        });
        action.setCallback(this, function(response)
        {
            var state = response.getState();
            if (state === "SUCCESS")
            {
                console.log("new rows From server: ", response.getReturnValue());
                component.set("v.showEmptyCard", false);
                component.set("v.SearchKeyWord", '');
                component.set("v.Message", '');
                component.set("v.listOfSearchRecords", []);
                component.set("v.families", []);
                component.set("v.attributesAndNewRows", []);
                this.retrieveMatrixParameterRows(component, event);
            }
            else if (state === "INCOMPLETE")
            {
                // do something
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
        $A.enqueueAction(action);
    },

    getFamilies: function(component, event, catalogItem) { //NE__ProductId__c!!
        console.log("into getFamilies");
        console.log("productId into getFamilies: " + catalogItem.NE__ProductId__c);
        var action = component.get("c.getFamiliesServer");
        action.setParams
        ({
            productId: catalogItem.NE__ProductId__c
        });
        action.setCallback(this, function(response)
        {
            var state = response.getState();
            if (state === "SUCCESS")
            {
                console.log("productFamilies from server: ", response.getReturnValue());
                var productFamilies = response.getReturnValue();
                component.set("v.families", productFamilies);
                var families = [];
                for (var i = 0; i < productFamilies.length; i++)
                {
                    families.push
                    ({
                        "Id": productFamilies[i].NE__FamilyId__c
                    });
                }
                this.retrieveAttributesFromFamilies(component, event, families);
            }
            else if (state === "INCOMPLETE")
            {
                // do something
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
        $A.enqueueAction(action);
    },

    retrieveAttributesFromFamilies: function(component, event, families)
    {
        console.log("into retrieveAttributesFromFamilies ");
        console.log("families are: ", families);
        var productFamilies = component.get("v.families");
        var matrixParameter = component.get("v.matrixParameter");
        var attributesAndNewRows = [];
        var newRows = [];
        var productId = component.get("v.newRow").OB_Product__c;
        console.log("productId to pass to newRows.."+ productId);
        var action = component.get("c.retrieveAttributesFromFamilies");
        action.setParams
        ({
            families: families
        });
        action.setCallback(this, function(response)
        {
            var state = response.getState();
            if (state === "SUCCESS")
            {
                console.log("attributes from server: ", response.getReturnValue());
                component.set("v.attributesList", response.getReturnValue());
                var attributesList = component.get("v.attributesList");
                for(var i = 0; i<attributesList.length; i++)
                {
                	newRows.push({'sobjectType':'NE__Matrix_Parameter_Row__c', 'OB_DynamicPropertyDefinition__r':'', 'OB_Family__c': '', 'OB_ReadOnly__c':'false', 'OB_Massimale__c':'', 'OB_Massimo__c':'','OB_Minimo__c':'', 'OB_Soglia_Max_Approvazione__c':'','OB_Soglia_Min_Approvazione__c' : '','OB_Valore_Default__c' :'','OB_MaxThresholdL3__c' :'','OB_MaxThresholdL2__c' :'','OB_MinThresholdL3__c' :'','OB_MinThresholdL2__c' :'', 'OB_SelfLookup__c' : '', 'OB_Product__c' : productId, 'NE__Start_Date__c' : '', 'NE__End_Date__c' : '', 'NE__Active__c':'','NE__Matrix_Parameter__r':'', 'OB_Sequence__c':''});
                	newRows[i].OB_DynamicPropertyDefinition__c = attributesList[i].NE__PropId__c;
                	newRows[i].OB_Family__c = attributesList[i].NE__FamilyId__c;
                	attributesAndNewRows.push
                	({
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
            } else if (state === "INCOMPLETE")
            {
                // do something
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
        $A.enqueueAction(action);
    },
    
    searchHelper : function(component, event)
    {
        var searchText = component.get('v.SearchKeyWord');
        var itemHeader = ''+component.get('v.matrixParameter').OB_Componente__r.NE__Item_Header__c;

        var action = component.get('c.getCatalogItems');
        action.setParams
        ({
            searchText: searchText,
            itemHeader: itemHeader
        });
        action.setCallback(this, function(response)
        {
            var state = response.getState();
            if (state === 'SUCCESS')
            {
                var products = response.getReturnValue();
                console.log("products found: ", products);
                if (products.length == 0)
                {
                    var message = $A.get("$Label.c.OB_NoResultMsg");
                    component.set("v.Message", message);
                }
                else
                {
                    component.set("v.Message", '');
                }
                component.set("v.listOfSearchRecords", products);
            }
        });
        $A.enqueueAction(action);
    },
    
    deleteRowServer: function(component, event, selectedRow)
    {
    	var parentChildrenRows = component.get("v.parentChildrenRows");
    	var index = component.get("v.indexRowToDelete");
	    var action = component.get('c.deleteSelectedRow');
	    var listToDelete = [];  
	    listToDelete.push(selectedRow.parent);
        for(var i = 0; i<selectedRow.children.length; i++)
        {
	        listToDelete.push(selectedRow.children[i]);
	    }
        console.log("listToDelete: " , listToDelete);
	    action.setParams({listToDelete: listToDelete});
	    action.setCallback(this, function(response)
	    {
            var state = response.getState();
            if (state === 'SUCCESS')
            {
                parentChildrenRows.splice(parseInt(index), 1);
                component.set("v.parentChildrenRows", parentChildrenRows);
                component.set("v.spinner", false);
            }
            else
            {
                var errors = response.getError();
                if (errors)
                {
                    if (errors[0] && errors[0].message)
                    {
                        console.log("Error message: " + errors[0].message);
                    }
                } else
                {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
	 }
})