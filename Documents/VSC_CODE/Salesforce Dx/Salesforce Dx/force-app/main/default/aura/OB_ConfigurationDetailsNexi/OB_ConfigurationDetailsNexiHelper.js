({
    retrieveMatrixParameterRows: function(component, event)
    {
    	console.log("into retrieveMatrixParameterRows");
        var matrixParameter = component.get('v.matrixParameter');
        console.log("matrixParameterId: " + matrixParameter.Id);
        var offerName =  component.get('v.offer').Name;
        var abi = component.get('v.selectedABI').Name;
        var action = component.get("c.getRowsByMatrixParameterId");
        action.setParams
        ({
            matrixParameter: matrixParameter,
            offerName: offerName,
            abi: abi
        });
        action.setCallback(this, function(response)
        {
            var state = response.getState();
            if (state === "SUCCESS")
            {
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

                for(var i = 0; i< parentChildrenRows.length; i++)
                {
                    parentChildrenRows[i].children.sort(function(a,b)
                    {
                        var tempChild = a.OB_Family__r.Name.localeCompare(b.OB_Family__r.Name);
                        var obj = {'Commissione' : 0, 'da' : 1, 'a': 2};
                        var aName = a.OB_DynamicPropertyDefinition__r.Name;
                        var bName = b.OB_DynamicPropertyDefinition__r.Name;

                        if(tempChild == 0)
                        {
                            if(obj.hasOwnProperty(aName) && obj.hasOwnProperty(bName))
                            {
                                tempChild = (obj[aName] < obj[bName] ? -1 : (obj[aName] > obj[bName] ? 1 : 0));
                            }
                        }
                        return tempChild
                    });
                }

                component.set("v.parentChildrenRows",parentChildrenRows);
                console.log("parentChildrenRows def: " , parentChildrenRows);
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

    //inserting into DB a new matrix parameter row, identical to the one we choose to clone it with:
    cloneRow: function(component, rowToClone, index, event)
    {
        var parentChildrenRows = component.get("v.parentChildrenRows");
        var rowParent = rowToClone.parent;
        var rowChildren = rowToClone.children;
        var clonedRows;
		var action = component.get("c.insertCloneRow");
 		action.setParams({
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
                var parentCloneId =rowToClone.parent.Id; // rowToClone.children[0].OB_SelfLookup__c;
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
                        if(clonedRows[i].OB_Codici__c =='COMMISSIONE4' || clonedRows[i].OB_Codici__c =='A1' || clonedRows[i].OB_Codici__c =='A2'){
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
            } else if (state === "INCOMPLETE")
            {
                // do something
            } else if (state === "ERROR")
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
    },

    //calling the server-side to save all the changes we make on the list of matrix parameter rows:
    saveRows: function(component, event)
    {
        var parentChildrenRows = component.get("v.parentChildrenRows");
        var newRow = component.get("v.newRow");
        console.log("newRow: " , newRow);
        var rows = [];
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
            rowList: rows
        });
        action.setCallback(this, function(response)
        {
            var state = response.getState();
            if (state === "SUCCESS")
            {
                console.log("saveRows From server: ", response.getReturnValue());
                this.retrieveMatrixParameterRows(component, event);
                component.set("v.spinner", false);
                this.showSuccessToast(component, event);
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
	 }
})