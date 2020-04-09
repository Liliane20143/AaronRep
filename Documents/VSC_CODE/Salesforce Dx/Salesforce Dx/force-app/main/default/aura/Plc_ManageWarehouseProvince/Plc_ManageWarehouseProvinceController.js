({	    
    /**
     * @description initialize the component
     */
	doInit : function(component, event, helper) {

        // Added by FB on 29th March, 2019
		helper.retrieveTranslationsMap(component, helper);

		var action = component.get('c.getPickListValues');
		action.setParams({'nameField': 'Plc_Province__c'});
		action.setCallback(this, function(response){
			if(response.getState() == "SUCCESS"){
                //refreshWareHouseList
                component.set("v.provinces", response.getReturnValue());
               	helper.initWareHouses(component, '');
			}
		});
		$A.enqueueAction(action);
    },
    
    /**
     * @description refresh the list of warehouses when a province is selected
     */
    refreshWarehouses : function(component, event, helper){
        helper.initWareHouses(component, component.get('v.searchKey'));
        helper.handleRefreshWarehouses(component);
    },

    /**
     * @description function used to filter the list of warehouse
     */
    filterWareHouse : function(component, event, helper){
        helper.handleFilterWareHouse(component);
	},

    /**
     * @description function used to assigned a warehouse to province
     */
    selectWarehouse : function(component, event, helper){
		Promise.resolve(helper.handleSelectWarehouse(component, event)).then(() => helper.handleSumPercentage(component));
	},

    /**
     * @description function used to remove a warehouse assigned to province
     */
    removeWarehouse : function(component, event, helper){
        Promise.resolve(helper.handleRemoveWarehouseAssignedToProvince(component, event)).then(() => helper.handleSumPercentage(component));
	},

    /**
     * @description function used to calculate the percent sum
     */
    sumPercentage : function(component, event, helper){
        helper.handleSumPercentage(component, event);
    },

    /**
     * @description function used to save the list of Plc_WarehouseProvince__c
     */
    save : function(component, event, helper){
        helper.handleSave(component);
    },

    /**
     * @description function used to cancel the operation and return the user to the previous page
     */
    cancel : function(component, event, helper){
        //history.back();
        window.history.go(-2);
    }
    
})