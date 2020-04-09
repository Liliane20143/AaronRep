({
	getField_helper : function(component, event, helper) 
	{
		console.log('I am in getField_helper');
		var getField    = component.get("c.getFieldUserLogged");

		var columns	 	= 'Id';
		if (component.get("v.listFixNameFilters")!=null && component.get("v.listFixNameFilters")!='')
		{
			columns     += ',' + component.get("v.listFixNameFilters");
		}
		console.log('columns:' + columns); 
		getField.setParams({ columns : columns}); 
		getField.setCallback(this, function(response) 
		{
			var state = response.getState();
			if (state === "SUCCESS") 
			{
				component.set("v.recordUser",response.getReturnValue());
				this.getReport_helper(component);
			}  
			else if (state === "ERROR")
			{
				var errors = response.getError();
				if (errors) 
				{
					if (errors[0] && errors[0].message)
					{
						console.log("Error message: " + 
								 errors[0].message);
					}
				}
				else
				{
					console.log("Unknown error");
				}
			}
		});
		$A.enqueueAction(getField); 
	},

	// getAbiCab_helper : function(component)
	// {
	// 	console.log('I am in getAbiCab_helper');
	// 	var getAbiCab = component.get("c.getAbiCabUserLogged");
	// 	getAbiCab.setCallback(this, function(response)
	// 	{
	// 		var state = response.getState();
	// 		console.log("Nel Callback getAbiCabUserLogged");
	// 		if (state === "SUCCESS") 
	// 		{
	// 			console.log('User with ABI, CAB:' +JSON.stringify(response.getReturnValue()));
	// 			var abi = '';
	// 			if( !$A.util.isUndefined(response.getReturnValue().Account))
	// 			{
	// 				abi = response.getReturnValue().Account.OB_ABI__c;
	// 				if(!$A.util.isUndefined(abi) && !$A.util.isEmpty(abi))
	// 				{
	// 					component.set("v.ABI", abi);
	// 					var cab = response.getReturnValue().OB_CAB__c;
	// 					if(!$A.util.isEmpty(cab) && !$A.util.isUndefined(cab))
	// 					{
	// 						component.set("v.CAB", cab);
	// 					}
	// 					else
	// 					{
	// 						//console.log('ABI, CAB non trovati');
	// 						component.set("v.ABI", "");
	// 					}
	// 					this.getReport_helper(component);
	// 				}
	// 			}
	// 		}
	// 		else if (state === "ERROR")
	// 		{
	// 			var errors = response.getError();
	// 			if (errors)
	// 			{
	// 				if (errors[0] && errors[0].message) 
	// 				{
	// 					console.log("Error message: " + errors[0].message);
	// 				}
	// 			}
	// 			else
	// 			{
	// 				console.log("Unknown error");
	// 			}
	// 		}
	// 	});
	// 	$A.enqueueAction(getAbiCab); 
	// },

	getReport_helper: function(component) 
	{ 
		console.log('I am in getReport_helper '+component.get("v.reportName"));
		var getReportId = component.get("c.getReport");
		getReportId.setParams({ reportName : component.get("v.reportName")});
		getReportId.setCallback(this, function(response) 
		{
			var state = response.getState();
			console.log("Nel Callback getReportId");
			if (state === "SUCCESS") 
			{
				console.log('User Report Id:' + JSON.stringify(response.getReturnValue().Id));
				component.set("v.reportId",response.getReturnValue().Id);
				console.log("getReportId: "+component.get("v.reportId"));
				console.log('reportRealName: ' + response.getReturnValue().Name);
				component.set("v.reportRealName",response.getReturnValue().Name);
				this.getSessionId_helper(component);
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
		$A.enqueueAction(getReportId);
	},

	getSessionId_helper : function(component) 
	{    
		var getSessionId = component.get("c.getSessionId");
		
		getSessionId.setCallback(this, function(resp)
		{
			var state = resp.getState();
			console.log("Nel Callback getSessionId");
			if (state === "SUCCESS")
			{
				console.log('User Session Id:'+ resp.getReturnValue());
				component.set("v.sessionId",resp.getReturnValue());
				this.getReportFilters(component);
				//this.setDataTable(component);
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
		$A.enqueueAction(getSessionId); 
	},

	exportDataTable : function(component) 
	{
		console.log('I am in exportDataTable');
		var sessionId   = component.get("v.sessionId");
		var reportId    = component.get("v.reportId");
		var filters     = component.get("v.filters");
		var xmlHttp 	= new XMLHttpRequest();
		var url 		= '../services/data/v43.0/analytics/reports/'+reportId;
		//var filters = this.setFilters(component);
		console.log('url: ' + url);
		xmlHttp.open( "POST",url, true ); 
		xmlHttp.setRequestHeader('Authorization', 'Bearer ' + sessionId);
		xmlHttp.setRequestHeader('Content-Type', 'application/json');
		xmlHttp.setRequestHeader('Accept', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
		xmlHttp.responseType = 'arraybuffer'; 
								
		xmlHttp.onload = function () 
		{ 
			console.log("onload");
			console.log(xmlHttp.readyState);
			console.log(xmlHttp.status);
			if (xmlHttp.readyState === 4 && xmlHttp.status === 200)
			{                              
				// `blob` response
				console.log(this.response);
				try
				{ 
					const blob = new Blob([this.response],{type: 'application/octet-stream'});
					const a = window.document.createElement('a');
					a.href = window.URL.createObjectURL(blob, {type: 'data:attachment/xlsx'});
					a.download = 'report_'+Date.now()+'.xlsx';
					document.body.appendChild(a);
					a.click();
					document.body.removeChild(a);
				}
				catch(err)
				{
					console.log('Error:'+error);
				}
			} 
		};
		xmlHttp.send(JSON.stringify(filters));
		console.log("Request sent");
	},

	setFilters : function(component,event,helper)
	{
		console.log('I am in setFilters');
		component.set("v.currentPageNumber ", 1);
		var listFilters 	= component.get("v.listFilters");
		console.log('listFilters: '+listFilters);
		var filters 		= component.get("v.filters");				
		var templateFilters =  {"reportMetadata": {
		// "reportBooleanFilter" : "1 OR 2",
			}
		}
		console.log('filters:'+JSON.stringify(filters));
		console.log('list Filters:'+JSON.stringify(listFilters));
		/*
		for(var filter in filters.reportMetadata.reportFilters){
			var type = filters.reportMetadata.reportFilters[filter].type;
			var find =false;
			var tempFilter; 
			for(var newFilter in listFilters){
				console.log('Column 1:'+filters.reportMetadata.reportFilters[filter].column);
				console.log('Column 2:'+listFilters[newFilter].column);
				tempFilter = listFilters[newFilter];
				if(filters.reportMetadata.reportFilters[filter].column == listFilters[newFilter].column){
					find = true;
					if( type != "picklist"){
						var value = listFilters[newFilter].value;
						console.log('label:'+ JSON.stringify(listFilters[newFilter]));
						console.log('value:'+value);
						filters.reportMetadata.reportFilters[filter].value = listFilters[newFilter].value;
					}
					
				}
			}
			if(find==false && tempFilter.type != "picklist"){ 
				var len = filters.reportMetadata.reportFilters.length; 
				filters.reportMetadata.reportFilters[len]={
					"column": tempFilter.column,
					"isRunPageEditable": true,
					"operator": "equals",
					"value": tempFilter.value,
					"label" : tempFilter.label,
					"type" : tempFilter.type,
					"filterValues" : tempFilter.filterValues 
				};
			}
		}
		*/
		for(var newFilter in listFilters)
		{
			var found = false;
			for(var filter in filters.reportMetadata.reportFilters)
			{
				console.log('Column 1:' + filters.reportMetadata.reportFilters[filter].column);
				console.log('Column 2:' + listFilters[newFilter].column);
				if(filters.reportMetadata.reportFilters[filter].column == listFilters[newFilter].column)
				{
					found = true;
					if(listFilters[newFilter].value != undefined)
					{
						var value = listFilters[newFilter].value;
						console.log('label:'+ JSON.stringify(listFilters[newFilter]));
						console.log('value:'+value);
						filters.reportMetadata.reportFilters[filter].value = listFilters[newFilter].value;
					}
					console.log('Value:'+filters.reportMetadata.reportFilters[filter].value);
				}
				var valueOfFilter = filters.reportMetadata.reportFilters[filter];
				if(valueOfFilter.value === undefined || valueOfFilter.value == '')
				{ 
					valueOfFilter.value = '';
					filters.reportMetadata.reportFilters.splice(filter,filter);
				}
			}
			if(found == false && listFilters[newFilter].value != '' && listFilters[newFilter].value != undefined)
			{
				var stringValues = '';
				var len = filters.reportMetadata.reportFilters.length;
				filters.reportMetadata.reportFilters[len] = 
				{
					"column"			: listFilters[newFilter].column,
					"isRunPageEditable"	: true,
					"operator"			: "equals",
					"value"				: listFilters[newFilter].value,
					"label" 			: listFilters[newFilter].label,
					"type" 				: listFilters[newFilter].type,
					"filterValues" 		: listFilters[newFilter].filterValues,
				}; 
				// if(listFilters[newFilter].type === 'picklist')
				// {
				// 	stringValues = listFilters[newFilter].filterValues.map(item => item.name);
				// 	filters.reportMetadata.reportFilters[len].stringValues = stringValues;
				// }
			}
			// console.log('@Value: '+filters.reportMetadata.reportFilters[filter].value);
			
		}
		/*
		var templateFilters =  { 
			"reportMetadata": {            
			   // "reportBooleanFilter" : "1 OR 2",
			}
		}
		
		var reportFilters = [];
		for(var filter in listFilters){
			if(filters[filter].type != 'picklist' ){
				reportFilters.push({column:filters[filter].column,
									isRunPageEditable :true,
									operator:"equals",
									value: filters[filter].value
									})
			}
		}
		
		
		templateFilters.reportMetadata.reportFilters = reportFilters;
		*/
		templateFilters.reportMetadata.reportFilters = filters.reportMetadata.reportFilters;
		console.log('Array filter:'+JSON.stringify(templateFilters));
		component.set("v.filters",templateFilters);
	},
	/*
	 * this function will build table data
	 * based on current page selection
	 * */ 
	buildData : function(component, helper) 
	{
		var data        = [];
		var pageNumber  = component.get("v.currentPageNumber");
		var pageSize    = component.get("v.pageSize");
		var allData     = component.get("v.allData");
		var x           = (pageNumber-1)*pageSize;
		var totalPages  = (allData.length - allData.length%pageSize)/pageSize;
		if(allData.length%pageSize != 0)
		{
			totalPages++;
		}
		component.set("v.totalPages", totalPages);
		//creating data-table data
		for(; x<=(pageNumber)*pageSize; x++)
		{
			if(allData[x])
			{
				data.push(allData[x]);
			}
		} 
		component.set("v.data", data);
		helper.generatePageList(component, pageNumber);
	},
	/*
	 * this function generate page list
	 * */
	generatePageList : function(component, pageNumber)
	{
		//pageNumber = parseInt(pageNumber);
		var pageList    = [];
		var totalPages  = component.get("v.totalPages");
		console.log('totalPages in generatePageList: ' + totalPages);
		if(pageNumber > 3 && pageNumber < totalPages - 1)
		{
			for(var i = pageNumber - 2; (i < pageNumber + 3) && (i < totalPages + 1); i++)
			{
				pageList.push(i);
			}
		}
		else if(pageNumber <= 4)
		{
			for(var i = 1; i < totalPages + 1; i++) //mettere totalPages + 1	
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
	},

	setDataTable : function(component)
	{
		console.log('I am uisetdatatable');
		var sessionId   = component.get("v.sessionId");
		var filters     = component.get("v.filters");
		for(var filter in filters.reportMetadata.reportFilters)
		{
			delete filters.reportMetadata.reportFilters[filter]['label'];
			delete filters.reportMetadata.reportFilters[filter]['type']; 
			delete filters.reportMetadata.reportFilters[filter]['filterValues'];
		}
		var xmlHttp = new XMLHttpRequest();
		var url     = '../services/data/v43.0/analytics/reports/'+component.get("v.reportId");
		console.log('url: ' + url);
		xmlHttp.open( "POST",url, true ); 
		xmlHttp.setRequestHeader('Authorization', 'Bearer ' + sessionId);
		xmlHttp.setRequestHeader('Content-Type', 'application/json');							
		xmlHttp.onload = function () { 
			console.log("onload");
			console.log('@@@@ xmlHttp.readyState' + xmlHttp.readyState);
			console.log('@@@@ xmlHttp.status' + xmlHttp.status);
			if (xmlHttp.readyState === 4 && xmlHttp.status === 200) 
			{                              
				// `blob` response
				try
				{
					var report 	= JSON.parse(this.response);
					// console.log('report in setDataTable: ' + this.response);
					var cols 	= [];
					var data 	= [];

					for(var col in report.reportExtendedMetadata.detailColumnInfo)
					{
						var field 		= report.reportExtendedMetadata.detailColumnInfo[col];
                        console.log('#field: '+JSON.stringify(field));
						//	START	micol.ferrari 19/11/2018
						var str 		= field.label;
						var arraysplit 	= [];
						arraysplit 		= str.split(":");
						var arraysize 	= arraysplit.length;
						var labeltxt 	= "";
						if (arraysplit.length>0)
						{
							labeltxt = arraysplit[arraysize-1].trim(); 
						}
						if (field.isLookup)
						{
							//cols.push({label: field.label , fieldName: col+'_Url', type: 'url', sortable: false, typeAttributes: { label:{ fieldName: col} , target:'_blank'} });
							cols.push({label: labeltxt , fieldName: col+'_Url', type: 'url', sortable: false, typeAttributes: { label:{ fieldName: col} , target:'_blank'} });
						}
						else   
						{
							//cols.push({label: field.label , fieldName: col , type: 'text'});	
							cols.push({label: labeltxt , fieldName: col , type: 'text'});								
						}
						//	END		micol.ferrari 19/11/2018
					}
					component.set('v.columns',cols);
					for(var row in report.factMap['T!T'].rows)
					{
						var r = {};
						for(var col in report.factMap['T!T'].rows[row].dataCells)
						{
							var attribute 	= cols[col].fieldName;
							var type 		= cols[col].type;
							if(type == 'url')
							{
								 
								var sPageURL = window.location.href.substring(0,window.location.href.lastIndexOf("/"));
								var typeAttributes 	= cols[col].typeAttributes.label.fieldName;
								r[attribute] 		= sPageURL+'/detail/'+report.factMap['T!T'].rows[row].dataCells[col].value;
								r[typeAttributes] 	= report.factMap['T!T'].rows[row].dataCells[col].label;
							}                               
							else
							{
								r[attribute] = report.factMap['T!T'].rows[row].dataCells[col].label;
							}
						} 
						data.push(r);
					}
					component.set('v.allData',data);
				}
				catch(err)
				{
					console.log('Error:'+error);
				}
			}
		};
		xmlHttp.send(JSON.stringify(filters));
		console.log("Request sent");
	},

	getReportFilters : function(component)
	{
		var sessionId   = component.get("v.sessionId");
		var xmlHttp     = new XMLHttpRequest();
		var url         = '../services/data/v43.0/analytics/reports/'+component.get("v.reportId")+'/describe';
		console.log(url);
		xmlHttp.open( "GET",url, true ); 
		xmlHttp.setRequestHeader('Authorization', 'Bearer ' + sessionId);
		xmlHttp.setRequestHeader('Content-Type', 'application/json');	
		console.log('## before xmlHttp.onload');
		xmlHttp.onload = function () 
		{ 
			console.log("onload");
			console.log(xmlHttp.readyState);
			console.log(xmlHttp.status);
			if (xmlHttp.readyState === 4 && xmlHttp.status === 200)
			{                              
				// `blob` response
				try
				{
					var report              = JSON.parse(this.response);
					var listFilters         = [];
					var listFiltersTypes    = report.reportTypeMetadata.categories[0].columns;
					console.log("# fix: "+component.get("v.listFixNameFilters"));
					var listFixNameFilters  = component.get("v.listFixNameFilters").split(",");
					var userObj             = component.get("v.recordUser");
					console.log(this.response);                    
					for(var filterName in listFixNameFilters)
					{
						for (var filter in listFiltersTypes)
						{
							var filterNameLast 	= listFixNameFilters[filterName].split('.');
							filterNameLast 		= filterNameLast.slice(-1).pop();
							var arrFilter 		= filter.split('.');
							var filterLast 		= arrFilter.slice(-1).pop();
							console.log('## listFiltersTypes[filter].filterValues '+JSON.stringify(listFiltersTypes[filter].filterValues));
							if(filterLast == filterNameLast)
							{
								var value = userObj[filterLast];
								report.reportMetadata.reportFilters.push({
									"column"			: filter,
									"isRunPageEditable"	: false,
									"operator"			: "equals",
									"value"				: value,
									"label" 			: listFiltersTypes[filter].label,
									"type" 				: listFiltersTypes[filter].dataType,
									"filterValues" 		: listFiltersTypes[filter].filterValues
								})
							}
						}
					}
					var listNameFilters = component.get("v.listNameFilters").split(",");;
					for(var filterName in listNameFilters) 
					{
						for (var filter in listFiltersTypes)
						{
							var filterNameLast  = listNameFilters[filterName].split('.');
							filterNameLast      = filterNameLast.slice(-1).pop();
							var arrFilter       = filter.split('.');
							var filterLast      = arrFilter.slice(-1).pop();
							if(filterLast == filterNameLast)
							{
								var stringValues = '';
								
								if(listFiltersTypes[filter].dataType === 'picklist')
								{
									stringValues = listFiltersTypes[filter].filterValues.map(item => item.name);
									//var nameString = stringValues.join(',');
									console.log('## stringValues '+stringValues);
								}
								
								listFilters.push({
									"column"			: filter,
									"isRunPageEditable"	: true,
									"operator"			: "equals",
									"value"				: "",
									"label" 			: listFiltersTypes[filter].label,
									"type" 				: listFiltersTypes[filter].dataType,
									"filterValues" 		: listFiltersTypes[filter].filterValues,
									"stringValues" 		: stringValues
								})
							}
						}
					}
					component.set("v.listFilters",listFilters);
					console.log("##### "+JSON.stringify(listFilters));
					component.set("v.filters",report);
					console.log("##### filters :"+JSON.stringify(report));
				}
				catch(err)
				{
					console.log('Error:'+err);
					console.log('## 4');
				}
			}
		};
		xmlHttp.send(null);
		console.log("Request Getfilters sent");	
	}
})