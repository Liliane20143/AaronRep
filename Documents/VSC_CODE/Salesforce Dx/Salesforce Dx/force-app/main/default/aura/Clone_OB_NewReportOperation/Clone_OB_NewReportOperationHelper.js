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
		//console.log('columns:' + columns); 
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
						//console.log("Error message: " + 
								//  errors[0].message);
					}
				}
				else
				{
					//console.log("Unknown error");
				}
			}
		});
		$A.enqueueAction(getField); 
	},

	// getAbiCab_helper : function(component)
	// {
	// 	//console.log('I am in getAbiCab_helper');
	// 	var getAbiCab = component.get("c.getAbiCabUserLogged");
	// 	getAbiCab.setCallback(this, function(response)
	// 	{
	// 		var state = response.getState();
	// 		//console.log("Nel Callback getAbiCabUserLogged");
	// 		if (state === "SUCCESS") 
	// 		{
	// 			//console.log('User with ABI, CAB:' +JSON.stringify(response.getReturnValue()));
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
	// 						////console.log('ABI, CAB non trovati');
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
	// 					//console.log("Error message: " + errors[0].message);
	// 				}
	// 			}
	// 			else
	// 			{
	// 				//console.log("Unknown error");
	// 			}
	// 		}
	// 	});
	// 	$A.enqueueAction(getAbiCab); 
	// },

	getReport_helper: function(component) 
	{ 
		//console.log('I am in getReport_helper '+component.get("v.reportName"));
		var getReportId = component.get("c.getReport");
		getReportId.setParams({ reportName : component.get("v.reportName")});
		getReportId.setCallback(this, function(response) 
		{
			var state = response.getState();
			//console.log("Nel Callback di getReport_helper");
			if (state === "SUCCESS") 
			{
				//console.log('User Report Id:' + JSON.stringify(response.getReturnValue().Id));
				component.set("v.reportId",response.getReturnValue().Id);
				//console.log("getReportId: "+component.get("v.reportId"));
				//console.log('reportRealName: ' + response.getReturnValue().Name);
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
						//console.log("Error message: " + errors[0].message);
					}
				}
				else
				{
					//console.log("Unknown error");
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
			//console.log("Nel Callback getSessionId");
			if (state === "SUCCESS")
			{
				////console.log('User Session Id:'+ resp.getReturnValue());
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
						//console.log("Error message: " + errors[0].message);
					}
				}
				else
				{
					//console.log("Unknown error");
				}
			}
		});
		$A.enqueueAction(getSessionId); 
	},

	exportDataTable : function(component) 
	{
		//console.log('I am in exportDataTable');
		// var sessionId   = component.get("v.sessionId");
		// var reportId    = component.get("v.reportId");
		// var action = component.get("c.makeGetCallout");
		// action.setParams({
		// 				  "url" :''						  
		// 				});
						
		// action.setCallback(this, function(resp)
		// {
			// var state = resp.getState();
			// //console.log("Nel Callback di exportDataTable");
			// if (state === "SUCCESS")
			// {
				// //console.log('Response Report in getFilteredReport: '+ resp.getReturnValue());
				var data 	=component.get("v.allData");
				////console.log('data...--> '+ data);

				var cols 	= component.get("v.columns");
				var stringCols = '';
				var stringData = '';

				for(var col in cols)
				{					
					if(col > 0){
					stringCols += ';'; 	

					}
					stringCols 	 += cols[col].label;

				}
				stringCols += '\n';
				
				stringData = stringCols;
				for(var row in data)
				{
					for(var col in cols)
					{
						if(col > 0)
						{
							stringData += ';'; 
						}
						var fieldName = cols[col].fieldName;
						if(fieldName.includes('__lookup')){
							fieldName = fieldName.replace('_Url','');
						}		
						
						stringData 	+= data[row][fieldName];

					} 
					stringData += '\n';  
				}
									
				// ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####     
		        var hiddenElement      = document.createElement('a');
		        hiddenElement.href     = 'data:text/csv;charset=utf-8,' + encodeURI(stringData);
		        hiddenElement.target   = '_self'; // 
		        hiddenElement.download = 'Report.csv';  // CSV file Name* you can change it.[only name not .csv] 
		        document.body.appendChild(hiddenElement); // Required for FireFox browser
		        hiddenElement.click(); // using click() js function to download csv file 


				// try
				// {
				// 	var report 	= JSON.parse(resp.getReturnValue());
				// 	//component.set("v.listFilters",JSON.parse(resp.getReturnValue().reportTypeMetadata.categories[0].columns));
				// 	//console.log('component.get("v.listFilters"): ' + component.get("v.listFilters"));
				// 	// //console.log('report in setDataTable: ' + this.response); 
				// 	var cols 	= [];
				// 	var data 	= [];

				// 	for(var col in report.reportExtendedMetadata.detailColumnInfo)
				// 	{
				// 		var field 		= report.reportExtendedMetadata.detailColumnInfo[col];
				// 		//	START	micol.ferrari 19/11/2018
				// 		var str 		= field.label;
				// 		var arraysplit 	= [];
				// 		arraysplit 		= str.split(":");
				// 		var arraysize 	= arraysplit.length;
				// 		var labeltxt 	= "";
				// 		if (arraysplit.length>0)
				// 		{
				// 			labeltxt = arraysplit[arraysize-1].trim(); 
				// 		}
				// 		if (field.name.includes("__lookup"))

				// 		{
							
				// 			//cols.push({label: field.label , fieldName: col+'_Url', type: 'url', sortable: false, typeAttributes: { label:{ fieldName: col} , target:'_blank'} });
				// 			cols.push({label: labeltxt , fieldName: col+'_Url', type: 'url', sortable: false, typeAttributes: { label:{ fieldName: col} , target:'_blank'} });
						   
				// 		}
				// 		else   
				// 		{
				// 			//cols.push({label: field.label , fieldName: col , type: 'text'});	
				// 			cols.push({label: labeltxt , fieldName: col , type: 'text'});								
				// 		}
				// 		//	END		micol.ferrari 19/11/2018
				// 	}
				// 	component.set('v.columns',cols.reverse());
				// 	for(var row in report.factMap['T!T'].rows)
				// 	{
				// 		var r = {};
				// 		for(var col in report.factMap['T!T'].rows[row].dataCells)
				// 		{
				// 			var attribute 	= cols[col].fieldName;
				// 			var type 		= cols[col].type;
				// 			if(type == 'url')
				// 			{
				// 				var typeAttributes 	= cols[col].typeAttributes.label.fieldName;
				// 				r[attribute] 		= '/'+report.factMap['T!T'].rows[row].dataCells[col].value;
				// 				r[typeAttributes] 	= report.factMap['T!T'].rows[row].dataCells[col].label;
				// 			}                               
				// 			else
				// 			{
				// 				r[attribute] = report.factMap['T!T'].rows[row].dataCells[col].label;
				// 			}
				// 		} 
				// 		data.push(r);
				// 	}
				// 	component.set('v.allData',data);
				// }
				// catch(err)
				// {
				// 	//console.log('Error:'+error);
				// }
		// 	}
		// });
		// $A.enqueueAction(action);
		// //console.log("Request sent");

		/*var filters     = component.get("v.filters");
		//console.log("FILTERS ---> " + JSON.stringify(filters));
		var xmlHttp 	= new XMLHttpRequest();
		var url 		= '/services/data/v43.0/analytics/reports/'+reportId;
		//var filters = this.setFilters(component);
		//console.log('url: ' + url);
		xmlHttp.open( "POST",url, true ); 
		xmlHttp.setRequestHeader('Authorization', 'Bearer ' + sessionId);
		xmlHttp.setRequestHeader('Content-Type', 'application/json');
		xmlHttp.setRequestHeader('Accept', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
		xmlHttp.responseType = 'arraybuffer'; 
								
		xmlHttp.onload = function () 
		{ 
			//console.log("onload");
			//console.log(xmlHttp.readyState);
			//console.log(xmlHttp.status);
			if (xmlHttp.readyState === 4 && xmlHttp.status === 200)
			{                              
				// `blob` response
				//console.log(this.response);
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
					//console.log('Error:'+error);
				}
			} 
		};
		xmlHttp.send(JSON.stringify(filters));
		//console.log("Request sent"); */
	},

	exportAPIdataTable : function(component){
		//console.log('Export data table.');
		//this.setFilters(component);
		//this.setFilters(component);
		
		var filters = component.get("v.listFilters");
		console.log("export list filter: "+ JSON.stringify(filters));

		// filters.groupingsDown = $A.util.isUndefinedOrNull(filters.groupingsDown) ? [] : filters.groupingsDown;
		// filters.groupingsAcross = $A.util.isUndefinedOrNull(filters.groupingsAcross) ? [] : filters.groupingsAcross;

		// delete filters.customSummaryFormula;
		// delete filters.currencyCode;
		// delete filters.detailColumns;		

		// for (var reportFilter in filters.reportFilters){
		// 	delete filters.reportFilters[reportFilter]['filterValues'];
		// 	delete filters.reportFilters[reportFilter]['label'];
		// 	delete filters.reportFilters[reportFilter]['type'];
		// }

		var templateFilters =  {"reportMetadata": filters }; 
		//consolee.log("templateFilters: "+templateFilters);
		templateFilters = JSON.stringify(templateFilters);

		templateFilters = templateFilters.replace('DESCENDING', 'Desc' ).replace('ASCENDENDING','Asc').replace('__lookup','');
		
		var action   = component.get("c.makeAPICall");
		var reportId = component.get("v.reportId");

		action.setParams({	'url': '/services/data/v43.0/analytics/reports/'+reportId,
						  	'filtersAPI': templateFilters});

		action.setCallback(this, function(response)
		{ 
			var state = response.getState();
			//console.log("Nel Callback action exportAPIdataTable" );
			if (state === "SUCCESS")
			{
				
				try
                {									
					var link = document.createElement("a"); 
					link.href = 'data:application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;base64,' + response.getReturnValue();
					link.style = "visibility:hidden";
					link.download = 'report_'+Date.now()+'.xlsx';

					document.body.appendChild(link);
					link.click();
					document.body.removeChild(link);

                }
                catch(err)
                {
                    //console.log('Error:'+error);
                }
				
			}    
			else if (state === "ERROR")
			{
				var errors = response.getError();
				if (errors)
				{
					if (errors[0] && errors[0].message)
					{
						//console.log("Error message: " + errors[0].message);
					}
				}
				else
				{
					//console.log("Unknown error");
				}
			}
		});
		$A.enqueueAction(action); 

	},


	

	setFilters : function(component)
	{

		//console.log('I am in setFilters');

		var listFilters 	= component.get("v.listFilters");
		var filters 		= component.get("v.filters"); 

		filters.reportFilters = $A.util.isUndefinedOrNull(filters.reportFilters) ? [] : filters.reportFilters;
		
		for(var newFilter in listFilters)
		{
			var found = false;
			for(var filter in filters.reportFilters)
			{
				if(filters.reportFilters[filter].column == listFilters[newFilter].column)
				{
					found = true;
					if(!$A.util.isUndefinedOrNull(listFilters[newFilter].value) && !$A.util.isEmpty(listFilters[newFilter].value))
					{
						var value = listFilters[newFilter].value;
						filters.reportFilters[filter].value = listFilters[newFilter].value;
					}
				}
			}
			var value = listFilters[newFilter].value;
			if(found == false && !$A.util.isEmpty(value) && !$A.util.isUndefinedOrNull(value) )
			{
				var len = filters.reportFilters.length;
				filters.reportFilters[len] = 
				{
					"column"			: listFilters[newFilter].column, 
					"isRunPageEditable"	: true,
					"operator"			: "equals",
					"value"				: value,
					"label" 			: listFilters[newFilter].label,
					"type" 				: listFilters[newFilter].type,
					"filterValues" 		: listFilters[newFilter].filterValues,
				}; 
			
			}
			
		}
		////console.log('Array filter:'+JSON.stringify(filters));
		component.set("v.filters",filters);
	},


	/*
	 * this function will build table data
	 * based on current page selection
	 * */ 
	buildData : function(component, helper, so) 
	{
		//console.log('');
		//console.log('');

		var data        = [];
		var caso= so;
		var pageNumber  = component.get("v.currentPageNumber");
		var pageSize    = component.get("v.pageSize");
		var allData     = component.get("v.allData");
		var sortDate    = component.get("v.listFilters");
		if(sortDate.length > 0){
			var x           = (pageNumber-1)*pageSize;
			var totalPages  = Math.ceil((sortDate.length - sortDate.length%pageSize)/pageSize);
			if(sortDate.length%pageSize != 0)
			{
				totalPages++;
			}
			component.set("v.totalPages", totalPages);
			//creating data-table data
			for(; x<=(pageNumber)*pageSize; x++)
			{
				if(sortDate[x])
				{
					data.push(sortDate[x]);
				}
			} 
			component.set("v.data", data);
			helper.generatePageList(component, pageNumber);

	}
	else{
		var x           = (pageNumber-1)*pageSize;
		var totalPages  = Math.ceil((allData.length - allData.length%pageSize)/pageSize);
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
		
		
	}
	
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
		else if(pageNumber < 4)
		{
			for(var i = 1; i < totalPages + 1; i++)
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
		component.set("v.showSpinner","false");
		component.set("v.pageList", pageList);
		
		
		
	},
	
	
	setDataTable : function(component)
	{
		//console.log('I am in setDataTable in helper');
		var test="";
		var reportIdString = component.get("v.reportId");
		var filters = JSON.stringify(component.get("v.listFilters"));
		//console.log('listFilters: '+ JSON.stringify(filters));
		var action = component.get("c.getFilteredReport");
		
		action.setParams({
						  "reportId" : reportIdString, 
						  "listFilters": filters
						});
						
		action.setCallback(this, function(resp)
		{
			var state = resp.getState();
			//console.log("Nel Callback di setDataTable");
			if (state === "SUCCESS")
			{
				////console.log('Response Report in getFilteredReport: '+ JSON.parse(resp.getReturnValue()));
				// //console.log('Response Report typeOf: '+ typeof(resp.getReturnValue()));
				try
				{
					var b= resp.getReturnValue().charAt(0);
					//console.log('primo carattere'+b);
					if(b == '{'){
						test= JSON.parse(resp.getReturnValue());
						component.set("v.response", test);
						////console.log("test vediamo primo graffa: "+test);
					}
					var a = resp.getReturnValue().charAt(0);
					if(a == '['){
						////console.log("ERRORRR: "+ test);
						var report 	= component.get("v.response") ;
						//console.log('test vediamo quadra: '+report);
					}
					else{
						////console.log('Response Report in getFilteredReport: '+JSON.parse(resp.getReturnValue()));
				
					var report 	= JSON.parse(resp.getReturnValue());
					
					//console.log("@@@@@in try:");
					}
					// //console.log('Response Report in getFilteredReport: '+JSON.parse(resp.getReturnValue()));
				
					// var report 	= JSON.parse(resp.getReturnValue());
					
					// //console.log("@@@@@in try:");
					var cols 	= [];
					var data 	= [];

					for(var col in report.reportExtendedMetadata.detailColumnInfo)
					{
						var field 		= report.reportExtendedMetadata.detailColumnInfo[col];
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
						if (field.name.includes("__lookup"))

						{
							cols.push({label: labeltxt , fieldName: col+'_Url', type: 'url', sortable: true, typeAttributes: { label:{ fieldName: col} , target:'_blank'} }); 
						}
						else   
						{	
							cols.push({label: labeltxt , fieldName: col , type: 'text',sortable: true});								
						}
						//	END		micol.ferrari 19/11/2018
					}
					component.set('v.columns',cols.reverse());
					////console.log('Columns ---> '+ JSON.stringify(component.get('v.columns'))); //_____ DD _____//
					for(var row in report.factMap['T!T'].rows)
					{
						var r = {};
						for(var col in report.factMap['T!T'].rows[row].dataCells)
						{
							var attribute 	= cols[col].fieldName;
							var type 		= cols[col].type;
							if(type == 'url')
							{ 
								var typeAttributes 	= cols[col].typeAttributes.label.fieldName;
								r[attribute] 		= '/'+report.factMap['T!T'].rows[row].dataCells[col].value;
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
					//console.log('Error:'+err.message);
				}
			}
		});
		$A.enqueueAction(action);
		//console.log("Request sent");
	},

	getReportFilters : function(component)
	{
		
		var sessionIdVar   = component.get("v.sessionId");
		//console.log('sessionId: ' + component.get("v.reportId"));
		var action = component.get("c.getDescribeReport");
		action.setParams({ 
			reportId : component.get("v.reportId") 
		});

		action.setCallback(this, function(resp)
		{
			var state = resp.getState();
			//console.log("Nel Callback di getReportFilters");
			if (state === "SUCCESS")
			{
				//console.log(' Success di  getReportFilter');
				//console.log('Response Report: '+ resp.getReturnValue());
				try
				{
					//console.log('Nel try di  getReportFilter');
					var report              = JSON.parse(resp.getReturnValue());
					var listFilters         = [];
					var listFiltersTypes    = report.reportTypeMetadata.categories[0].columns;
					var listFixNameFilters = null;
					if(!$A.util.isEmpty(component.get("v.listFixNameFilters")))
					{
						//console.log("# fix: "+component.get("v.listFixNameFilters"));
						listFixNameFilters  = component.get("v.listFixNameFilters").split(",");
					}	
					var userObj             = component.get("v.recordUser");
					////console.log('Prima del for'+component.get("v.recordUser"));
					//console.log('Before  for  '+ listFixNameFilters);    
					if(listFixNameFilters!= null){                
						for(var filterName in listFixNameFilters)
						{
						
							for (var filter in listFiltersTypes)
							{
								
								var filterNameLast 	= listFixNameFilters[filterName].split('.');
								filterNameLast 		= filterNameLast.slice(-1).pop();
								var arrFilter 		= filter.split('\.');
								var filterLast 		= arrFilter.slice(-1).pop();
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
					}
					//console.log('After for');
					var listNameFilters = null;
					if(listNameFilters!= null){
						var listNameFilters = component.get("v.listNameFilters").split(",");
					
						//console.log(listNameFilters);
					
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
									var stringValues = null;
									
									if(listFiltersTypes[filter].dataType === 'PICKLIST_DATA')
									{
										stringValues = listFiltersTypes[filter].filterValues.map(item => item.name);
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
					}
					component.set("v.listFilters",listFilters);
					//console.log("##### "+JSON.stringify(listFilters));
					//console.log("##### "+JSON.stringify(report));
					component.set("v.filters",report.reportMetadata);
				}
				catch(err)
				{
					//console.log('Error:'+err);
					//console.log('## 4');
				}
			}    
			else if (state === "ERROR")
			{
				var errors = resp.getError();
				if (errors)
				{
					if (errors[0] && errors[0].message)
					{
						//console.log("Error message: " + errors[0].message);
					}
				}
				else
				{
					//console.log("Unknown error");
				}
			}
		});
		$A.enqueueAction(action);
		
	},
	
	
	sortData: function (component,helper, fieldName, sortDirection) {
		//console.log('helper');
		
		var data = component.get("v.allData");
		var datafilter = component.get("v.listFilters");
		//console.log("dataFilter"+datafilter);
		if(datafilter == ""){
			var reverse = sortDirection !== 'asc';
			data.sort(this.sortBy(fieldName, reverse));
			this.buildData(component, helper, data);
			//component.set("v.data", data);
		}
		else{
			var reverse = sortDirection !== 'asc';
			datafilter.sort(this.sortBy(fieldName, reverse));
			this.buildData(component, helper, datafilter);
			//component.set("v.data", data);
		}
    },
    
    sortBy: function (field, reverse, primer) {
        var key = primer ?
            function(x) {return primer(x[field])} :
        function(x) {return x[field]};
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
	},
	
	filterDataTable: function(component, event,helper){
		var field = component.find("valueFilter").get("v.value");
        console.log('@@@field: '+field);
        ////console.log('i am in filterName');
        var data = component.get("v.allData");
            //  term = component.get("v.filterName"),
			//  results = data, regex;
			// var newData = JSON.parse(data);
			// //console.log('@@@@'+data[0]);
			var results = [];
				for (var i = 0; i < data.length; i++) {
					var str = JSON.stringify(data[i]).toLowerCase();
					var str2 = field.toLowerCase();
					if(str.includes(str2)){
						results.push(data[i]);	
					}
				}
				var toastEvent = $A.get("e.force:showToast");
    	    toastEvent.setParams({
    	        "type": "Error",
    	        "mode": "dismissible",
    	        "message": 'non ci sono record'
			});
			if(results.length == 0){
				toastEvent.fire(); 

			}
			
		
		if(typeof(field) !=undefined && field != null && field!=""){
			component.set("v.currentPageNumber", 1);
			component.set("v.listFilters",results);
			this.buildData(component, helper);
			//console.log("> di 0");
		}
		else{
			component.set("v.currentPageNumber", 1);
			component.set("v.listFilters",data);
			this.buildData(component, helper);
			//console.log("vuoto");
		}
			
			
		// component.set("v.listFilters",results);
		// this.buildData(component, helper);
    	
	}
})