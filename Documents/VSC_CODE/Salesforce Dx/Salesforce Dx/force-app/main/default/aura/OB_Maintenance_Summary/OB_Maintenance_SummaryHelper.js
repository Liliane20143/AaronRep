({
	buildData : function(component, helper) 
	{
		try
		{
			var data        = [];
			var pageNumber  = component.get("v.currentPageNumber");
			var pageSize    = component.get("v.pageSize")-1;
			var allData     = component.get("v.ListOfServicePoint");
			console.log('ALL DATA: ' + JSON.stringify(allData));
			var x           = (pageNumber-1)*pageSize;
			var totalPages  = (allData.length - allData.length%pageSize)/pageSize;
			if(allData.length%pageSize != 0)
			{
				totalPages++;
			}
			component.set("v.totalPages", totalPages);
			console.log('totalPages in builddata: ' + totalPages);
			//creating data-table data
			for(; x<=(pageNumber)*pageSize; x++)
			{
				if(allData[x])
				{
					data.push(allData[x]);
					console.log('DATA IN HELPER: ' +JSON.stringify(data[x]));
					console.log('X VALUE: ' +x);
				}
			} 
			//SET LIST OF 5 RECORDS TO DISPLAY
			component.set("v.data", data);
			helper.generatePageList(component, pageNumber);
		}
		catch(err) 
		{
			console.log('err.message: ' + err.message);
		} 
	},
	/*
	 * this function generate page list
	 * */
	generatePageList : function(component, pageNumber)
	{
		//pageNumber = parseInt(pageNumber);
		try
		{
			var pageList    = [];
			var totalPages  = component.get("v.totalPages");
			console.log('totalPages in generatePageList: ' + totalPages);
			console.log('pageSize in generatePageList: ' + component.get('v.pageSize'));

			if(pageNumber > 3 && pageNumber < totalPages - 1)
			{
				for(var i = pageNumber - 2; (i < pageNumber + 3) && (i < totalPages + 1); i++)
				{
					pageList.push(i);
				}
			}
			else if(pageNumber < 4)
			{
				for(var i = 1; i < totalPages - 1; i++)
				{
					pageList.push(i);
				}
			}   
			else
			{
				for(var i = totalPages - 4; i < totalPages + 1; i++)
				{
					pageList.push(i);
				}
			}
			component.set("v.pageList", pageList);
			console.log('NUMBER OF PAGE: ' + component.get('v.pageList'));
		}
		catch(err) 
		{
			console.log('err.message: ' + err.message);
		} 
	},

	sortData: function (component, fieldName, sortDirection)
	{
        var data = component.get("v.data");
        var reverse = sortDirection !== 'asc';
        data.sort(this.sortBy(fieldName, reverse))
        component.set("v.data", data);
    },

    sortBy: function (field, reverse, primer)
    {
        var key = primer ? function(x) {return primer(x[field])} : function(x) {return x[field]};
        reverse = !reverse ? 1 : -1;
        return function (a, b)
        {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    },

    checkIdServicePoint: function (component, helper,selectedRow,selectedServicePoint,hasServicePoint)
    {
    	selectedRow = [selectedServicePoint];
        var tabella = component.find("servicePointTable");
        tabella.set("v.selectedRows", selectedRow);
        var currentData = component.get('v.data');
        for(var i=0; i<currentData.length;i++)
        {
            console.log('CURRENT DATA: '+ JSON.stringify(currentData[i].Id));
            console.log('SELECTED ROW: ' + selectedRow);
            var currentPage = component.get('v.currentPageNumber');
            if(currentData[i].Id != selectedRow)
            {
                component.set('v.hasServicePoint' , false);
                console.log('CURRENT PAGE: ' + component.get('v.currentPageNumber'));
            }
            else if(currentData[i].Id == selectedRow)
            {
                component.set('v.hasServicePoint' , true);
                break;
            }
        }
        this.switchPages(component, helper,selectedRow,selectedServicePoint);
    },

    switchPages:function (component, helper,selectedRow,selectedServicePoint)
    {
        var hasServicePoint= component.get('v.hasServicePoint');
    	console.log('BOOLEAN PAGE: ' + hasServicePoint);
        //if the current page hasn't the specific service point-->switch to next page and do againthe control
		if(hasServicePoint==false)
        {
            var pageNumber = component.get("v.currentPageNumber");
            component.set("v.currentPageNumber", pageNumber+1);
            this.buildData(component, this);
            this.checkIdServicePoint(component, helper,selectedRow,selectedServicePoint,hasServicePoint)
        }
        console.log('CURRENT PAGE final: ' + component.get('v.currentPageNumber'));
        console.log('PAGE LIST: ' + component.get('v.pageList'));
        //component.set('v.hasServicePoint' , hasServicePoint);
	},
	
	/*
	*	Author		:	Morittu Andrea
	*	Date		:	28-Aug-2019
	*	Description	:	 UX.194 - Filter Function
	*/
	filterResult_Helper : function (component, event, helper) {
		component.set('v.servicePointList', []);
		// WRAPPER BUILDING
		var resultMatches = [];
		var singleServicePoint = {};
		singleServicePoint.result;

		const listOfSpoints 	= component.get('v.data');

		if( $A.util.isEmpty(component.find('Name').get('v.value')) && $A.util.isEmpty(component.find('OB_AddressFormula__c').get('v.value'))  ) {
			helper.clearFilterAction(component, event, helper);
		} else {
			let servicePointName = component.find('Name').get('v.value');
			let addressInput = component.find('OB_AddressFormula__c').get('v.value');
			resultMatches = listOfSpoints;
			
			if( !$A.util.isEmpty(servicePointName) ) {

				resultMatches = resultMatches.filter(ServicePoint => {
					return ServicePoint['Name'].toLowerCase().includes(servicePointName.toLowerCase());
				});
			}

			if( !$A.util.isEmpty(addressInput) ) {
				resultMatches = resultMatches.filter(ServicePoint => {
					return ServicePoint['OB_AddressFormula__c'].toLowerCase().includes(addressInput.toLowerCase());
				});
			}

			if(resultMatches.length == 0) {
				component.set('v.data', listOfSpoints);
				component.set('v.showFilteredDataTable', false);
				
				component.find('Name').set('v.value', '');
				component.find('OB_AddressFormula__c').set('v.value', '');

				let title       =   '';
				let message     =   $A.get("$Label.c.OB_NoDataFoundLabel");
				let type        =   'warning';

				this.showToast(component, event,title, message, type)

			} else {
				component.set('v.servicePointList', resultMatches);
				component.set('v.showFilteredDataTable', true);
			}
		}		
	},

	/*
    *   Author      :   Morittu Andrea
    *   Date        :   02-Sep-2019
    *   Description :   Clear research
    */
   clearFilterAction : function(component, event, helper) {
	const listOfSpoints 	= component.get('v.data');

	component.set('v.data', listOfSpoints);
	component.set('v.showFilteredDataTable', false);
	
	component.find('Name').set('v.value', '');
	component.find('OB_AddressFormula__c').set('v.value', '');
	},

	/*
    *   Author      :   Morittu Andrea
    *   Date        :   03-Sep-2019
    *   Description :   Show toast function
    */
   showToast: function (component, event,title, message, type) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			"title": title,
			"message": message,
			"type": type
		});
		toastEvent.fire();
	},
	/**
	*@author Giovanni Spinelli <spinelli.giovanni@accenture.com>
	*@date 20/03/2018
	*@description Method to set action in data table
	*@params -
	*@return 
	*/
	getRowActions: function (component, row, doneCallback) {
		var actions = [{
			'label': $A.get("$Label.c.OB_Details"),
			'iconName': 'utility:zoomin',
			'name': 'show_details'
		},
		{
			'label': $A.get("$Label.c.OB_NewAgreement"),
			'iconName': 'utility:add',
			'name': 'fire_flow'
		},
		//giovanni spinelli - 07/10/2019 - start drop down menu in maintenance for var.coba
		{
			'label': $A.get("$Label.c.OB_MAINTENANCE_ACTIONS_VARCOBA"),
			'iconName': 'utility:edit',
			'name': 'Var.CoBa'
		}
		//giovanni spinelli - 07/10/2019 - end drop down menu in maintenance for var.coba
		];
		
		setTimeout($A.getCallback(function () {
			doneCallback(actions);
		}), 200);

	},
	/*
		@Author	: Morittu Andrea
		@Date 	: 2019.05.07
		@Task	: ID_Stream_6_Subentro
	*/
	destroyWholeComponentHelper : function(component,event, helper) {
		debugger;
		var merchantTakeOverEvent = $A.get("e.c:OB_DestroyMaintenanceSummary");

		var merchantTakeOver = 	event.getParam("merchantTakeoverProcess");
		var bodyAttribute =	event.getParam("bodyAttribute");
		if(!$A.util.isEmpty(merchantTakeOver) && merchantTakeOver) {
			var mainComponentDiv = !$A.util.isUndefined(component.find("mainComponentDiv")) ? component.find("mainComponentDiv") : null;
			mainComponentDiv.destroy();

		}
		if(!$A.util.isUndefined(component.find("removeEntireSection"))) {
			component.find("removeEntireSection").destroy();
		}
		component.set("v.showBit2Flow", merchantTakeOver );
		component.find("ServicePointDataTableDIV").destroy();
	},	
	
})