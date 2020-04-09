({	
	//simone Misani add event on function 16/04/2019
	getField_helper : function(component, event, helper) {

		console.log('I am in getField_helper');
		var getField    = component.get("c.getFieldUserLogged");
//Start    simone.misani 25/03/2019 - R1F2_RP_014 - Use CustomMetadata for controll
		getField.setCallback(this, function(response) {			
			var state = response.getState();
			if (state === "SUCCESS") {
				if(response.getReturnValue()!= null ){
					var mapFields = response.getReturnValue();
					var user = mapFields['user'];
					var fields=mapFields['fields'];
					component.set("v.recordUser",user);
					component.set("v.filterTofilters",fields);
					console.log("fields: "+component.get("v.filterTofilters"));
					console.log("recordUser: "+JSON.stringify(response.getReturnValue()));
					//simone Misani add event on function 16/04/2019
					this.getBaseURLFromApex(component, event);
				}else{
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
							title: '',
							message: $A.get($Label.c.OB_ErrorTypeUser),
							duration: '5000',
							key: 'info_alt',
							type: 'error',
							mode: 'dismissible'
					});
					toastEvent.fire();
				}
				//this.getReport_helper(component);
	//END    simone.misani 25/03/2019 - R1F2_RP_014 - Use CustomMetadata for controll
			}  
			else if (state === "ERROR"){
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message){
						console.log("Error message: " + 
								errors[0].message);
					}
				}
				else{
					console.log("Unknown error");
				}
			}
		});		
		$A.enqueueAction(getField); 
	},
//simone Misani add event on function 16/04/2019
	getBaseURLFromApex : function(component, event) {
		var getBaseURL    = component.get("c.getBaseURl");
		getBaseURL.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var myBaseURL = response.getReturnValue();
				component.set("v.myBaseURL",myBaseURL);
				console.log('myBaseURL: ' + myBaseURL);
				this.getReport_helper(component, event);
			}  
			else if (state === "ERROR"){
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message){
						console.log("Error message: " + 
								errors[0].message);
					}
				}
				else{
					console.log("Unknown error");
				}
			}
		});
		
		$A.enqueueAction(getBaseURL); 
	},

	getReport_helper: function(component, event) {

		var getReportId = component.get("c.getReport");
		getReportId.setParams({ reportName : component.get("v.reportName")});
		getReportId.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS"){				
				component.set("v.reportId",response.getReturnValue().Id);
				console.log("getReportId: "+component.get("v.reportId"));
				component.set("v.reportRealName",response.getReturnValue().Name);				
				this.getSessionId_helper(component, event);
			}    
			else if (state === "ERROR"){
				var errors = response.getError();
				if (errors){
					if (errors[0] && errors[0].message){
						console.log("Error message: " + errors[0].message);
					}
				}
				else{
					console.log("Unknown error");
				}
			}
		});		
		$A.enqueueAction(getReportId);
	},

	getSessionId_helper : function(component,event){	    
		var getSessionId = component.get("c.getSessionId");
		console.log("getSessionId: "+JSON.stringify(getSessionId));
		getSessionId.setCallback(this, function(resp){		
			var state = resp.getState();		
			if (state === "SUCCESS"){					
				component.set("v.sessionId",resp.getReturnValue());
				console.log("ifSuccess: "+resp.getReturnValue());
				try{
					this.getReportFilters(component, event);
				} catch(e) {
					console.log('error is :' + e.getMessage + ' at line ' + error.getLine());
				}
			}    
			else if (state === "ERROR"){			
				var errors = response.getError();
				if (errors){				
					if (errors[0] && errors[0].message){					
						console.log("Error message: " + errors[0].message);
					}
				}
				else{			
					console.log("Unknown error");
				}
			}
		});
		$A.enqueueAction(getSessionId); 
	},	

	exportDataTable : function(component){		
		var data = null;
		var mylist = component.get("v.listFilters");
		console.log("myList: "+JSON.stringify(mylist));
		if (mylist.length>0){			
			data 	=component.get("v.listFilters");
		}
		else {
			data 	=component.get("v.allData");
		}
		if(mylist[0]== ""){
			data = null;
		}
		var cols 	= component.get("v.columns");
		var stringCols = '';
		var stringData = '';
		for(var col in cols){							
			if(col > 0){
				stringCols += ';';
			}
			stringCols 	 += cols[col].label;
		}
		stringCols += '\n';		
		stringData = stringCols;
		for(var row in data){		
			for(var col in cols){			
				if(col > 0){				
					stringData += ';'; 
				}
				var fieldName = cols[col].fieldName;
				if(fieldName.includes('_Url')){
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
	},

	setFilters : function(component){
		console.log('I am in setFilters');
		var listFilters 	= component.get("v.listFilters");
		var filters 		= component.get("v.filters");
		filters.reportFilters = $A.util.isUndefinedOrNull(filters.reportFilters) ? [] : filters.reportFilters;		
		for(var newFilter in listFilters){		
			var found = false;
			for(var filter in filters.reportFilters){			
				if(filters.reportFilters[filter].column == listFilters[newFilter].column){				
					found = true;
					if(!$A.util.isUndefinedOrNull(listFilters[newFilter].value) && !$A.util.isEmpty(listFilters[newFilter].value)){		
						var value = listFilters[newFilter].value;
						filters.reportFilters[filter].value = listFilters[newFilter].value;
					}
				}
			}
			var value = listFilters[newFilter].value;
			if(found == false && !$A.util.isEmpty(value) && !$A.util.isUndefinedOrNull(value) ){			
				var len = filters.reportFilters.length;
				filters.reportFilters[len] ={ 				
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
		component.set("v.filters",filters);
	},


	/*
	Simone Misani
	 * this function will build table data
	 * based on current page selection
	 * */ 
	buildData : function(component, helper){
		var data        = [];
		var pageNumber  = component.get("v.currentPageNumber");
		var pageSize    = component.get("v.pageSize");
		var allData     = component.get("v.allData");
		var sortDate    = component.get("v.listFilters");
		if(sortDate.length > 0){
			console.log("maggiore di 0");
			var x           = (pageNumber-1)*pageSize;
			var totalPages  = Math.ceil((sortDate.length - sortDate.length%pageSize)/pageSize);
			if(sortDate.length%pageSize != 0){			
				totalPages++;
			}
			component.set("v.totalPages", totalPages);
			for(; x<=(pageNumber)*pageSize; x++){				
				if(sortDate[x]){					
					data.push(sortDate[x]);
				}
			} 
			component.set("v.data", data);
			this.generatePageList(component, pageNumber);
		}
		else{
			var x           = (pageNumber-1)*pageSize;
			var totalPages  = Math.ceil((allData.length - allData.length%pageSize)/pageSize);
			if(allData.length%pageSize != 0){		
				totalPages++;
			}
			component.set("v.totalPages", totalPages);
			//creating data-table data
			for(; x<=(pageNumber)*pageSize; x++){				
				if(allData[x]){				
					data.push(allData[x]);
				}
			} 		
			component.set("v.data", data);			
			this.generatePageList(component, pageNumber);
				
		}	
	},

	/*
	Simone Misani
	 * this function generate page list
	 * */
	generatePageList : function(component, pageNumber){	
		console.log("sono in generatePageList");
		
		var pageList    = [];
		var totalPages  = component.get("v.totalPages");
		console.log('totalPages in generatePageList: ' + totalPages);
		if(pageNumber > 3 && pageNumber < totalPages - 1){		
			for(var i = pageNumber - 2; (i < pageNumber + 3) && (i < totalPages + 1); i++){			
				pageList.push(i);
			}
		}
		else if(pageNumber < 4 || pageNumber == 4){ // PRODOB-74,Doris Dongmo <doris.tatiana.dongmo@accenture.com>,08/04/2019 - Add pageNumber == 4
		
			for(var i = 1; i < totalPages + 1; i++){
			
				pageList.push(i);
			}
		}   
		else{		
			for(var i = totalPages - 4; i < totalPages + 1; i++){			
				pageList.push(i);
			}
		}
		component.set("v.showSpinner","false");
		component.set("v.pageList", pageList);			
	},	
	
	setDataTable : function(component){		
		var respons="";
		var reportIdString = component.get("v.reportId");
		var filters = component.get("v.valueFiltered");		
		var action = component.get("c.getFilteredReport");			
		action.setParams({
						  "reportId" : reportIdString, 
						  "listFilters": filters
						});						
		action.setCallback(this, function(resp){		
			var state = resp.getState();			
			if (state === "SUCCESS"){
				try{				
					var includeBrackets= resp.getReturnValue().charAt(0);					
					if(includeBrackets == '{'){
						respons= JSON.parse(resp.getReturnValue());
						component.set("v.response", respons);
					}
					var roundBrackest = resp.getReturnValue().charAt(0);					
					if(roundBrackest == '['){					
						var report 	= component.get("v.response") ;
					}
					else{
						console.log('Response Report in getFilteredReport: '+JSON.parse(resp.getReturnValue()));				
					var report 	= JSON.parse(resp.getReturnValue());
					
					}					
					var cols 	= [];
					var data 	= [];
					var data1 	= [];	
					var namercolum='';		//Simone.misani AND Masoud Zaribaf R1F2-110 09/05/2019	
					var index = 0;		//antonio.vatrano r1f2-200-140 30/05/2019
					for(var col in report.reportExtendedMetadata.detailColumnInfo){		
						var field 		= report.reportExtendedMetadata.detailColumnInfo[col];
						var buckets = {};
						// START antonio.vatrano r1f2-200-140 30/05/2019
						var maxlength = this.retriveMaxLength(report, index);
                        var initialWH =0;
                        if(maxlength==5){
                            initialWH = maxlength*12;
						} 
						else{
							initialWH = maxlength*10;
						}
                       	// END antonio.vatrano r1f2-200-140 30/05/2019
						for(var x in report.reportMetadata.buckets){							
							var buck= report.reportMetadata.buckets[x];
							if(buck.sourceColumnName.includes(".Name")){
								buckets[buck.devloperName] = buck.sourceColumnName;
							}
						}						
						//	START	micol.ferrari 19/11/2018
						var str 		= field.label;						
						var arraysplit 	= [];
						arraysplit 		= str.split(":");						
						var arraysize 	= arraysplit.length;
						var labeltxt 	= "";		                   
						if (arraysplit.length>0){						
							labeltxt = arraysplit[arraysize-1].trim(); 							
						}	
						//giovanni spinelli 07/06/2019 comment first if to make bucket not link					
						/*if(buckets.hasOwnProperty(field.name)){	
							// antonio.vatrano r1f2-200-140 30/05/2019 add initialWidth
							cols.push({label: labeltxt,initialWidth: initialWH, fieldName: buckets[field.name]+'_Url', type: 'url', sortable: true, typeAttributes: { label:{ fieldName: col} , target:'_blank'} }); 							
						}else*/ if (field.name.includes(".Name")){
													
							cols.push({label: labeltxt, initialWidth: initialWH, fieldName: col+'_Url', type: 'url', sortable: true, typeAttributes: { label:{ fieldName: col} , target:'_blank'} }); 							
						}
						else{ 
							// antonio.vatrano r1f2-200-140 30/05/2019 add initialWidth						
							cols.push({label: labeltxt, initialWidth: initialWH, fieldName: col , type: 'text',sortable: true});								
						}
						//	END		micol.ferrari 19/11/2018
						index++;// antonio.vatrano r1f2-200-140 30/05/2019 add initialWidth 
					}							
					component.set('v.columns',cols.reverse());					
					for(var row in report.factMap['T!T'].rows){					
						var r = {};
						var w = {};
						for(var col in report.factMap['T!T'].rows[row].dataCells){						
							var attribute 	= cols[col].fieldName;							
							var type 		= cols[col].type;							
							var url = component.get("v.myBaseURL");
							if(type == 'url'){							 
								var typeAttributes 	= cols[col].typeAttributes.label.fieldName;
								r[attribute] 		= url+"/"+report.factMap['T!T'].rows[row].dataCells[col].value;
								r[typeAttributes] 	= report.factMap['T!T'].rows[row].dataCells[col].label;								
							}                               
							else{							
								r[attribute] = report.factMap['T!T'].rows[row].dataCells[col].label;
								w[attribute ]= report.factMap['T!T'].rows[row].dataCells[col].value;
							}
						} 
						data.push(r);
						data1.push(w);
					}				
					component.set('v.allData',data);
					/*
					giovanni spinelli - start 
					date: 15/07/2019
					get filter from url if 'consulta pratiche' is opend from home page button
					*/
					try{
						var url = window.location.href;       
						console.log('url: ' + url);
						var urlSplit = url.split('filter=')[1];
						console.log('urlSplit: ' + urlSplit);
						if(urlSplit){
							var filterValue = urlSplit.replace(/\+/g , ' ');
							console.log('filterValue: '+filterValue);
							component.set('v.clear' , filterValue);//show filter value in input
							this.filterDataTable(component, event,this,filterValue);
						}	
					}catch(err){
						console.log('ERROR: '+err.message);
					}
					//giovanni spinelli - end
					 this.sortData(component, helper, namercolum, sortDirection);		//Simone.misani AND Masoud Zaribaf R1F2-110 09/05/2019				
				}
				catch(err){			
				}
			}
		
		});	
		$A.enqueueAction(action);
	},

	/*
		*@author Simone Misani <simone.misani@accenture.com>
		*@date 16/04/2019
		*@description Modify thi method for add three custom metadata for user current. add call method apex that return a map<string,String>. This map conteins  abi-filed e cab-field (filed change on different Table-report). 
		*@history 16/04/2019 Method created
	*/ 
	getReportFilters : function(component, event){		
		var action = component.get("c.getCurrentReport");
		var reportId = component.get("v.reportId");
        action.setParams({ reportId : reportId });
        action.setCallback(this, function(response) {
            var state = response.getState();
			debugger;		
			if (state === "SUCCESS") {
				var currentReportMap = {};
				currentReportMap = response.getReturnValue();
				var sessionIdVar   = component.get("v.sessionId");
				var action = component.get("c.getDescribeReport");			
				action.setParams({ 
					reportId : component.get("v.reportId") 
					
				});						
				//Strat    simone.misani 25/03/2019 - R1F2_RP_014 - Use CustomMetadata for controll ABI and CAB and Multi-Cab
				action.setCallback(this, function(resp){
					var state = resp.getState();					
					if (state === "SUCCESS"){
						try{							
							var report              = JSON.parse(resp.getReturnValue());					
							var listFilters         = [];
							var listFiltersTypes    = report.reportTypeMetadata.categories[0].columns;
							var filterTofilters 		= null;
							var userObj        			= component.get("v.recordUser");
							filterTofilters=component.get("v.filterTofilters");
							if(!$A.util.isEmpty(currentReportMap.ABI)){
								if(filterTofilters == 'ABI'){	
									report.reportMetadata.reportFilters =[];
									var value = userObj['OB_ABI__c'];
									var filter = currentReportMap.ABI;
										report.reportMetadata.reportFilters.push({
											"column"						: filter,
											"isRunPageEditable"	: false,
											"operator"					: "equals",
											"value"							: value,
											"label" 						: listFiltersTypes[filter].label,
											"type" 							: listFiltersTypes[filter].dataType,
											"filterValues" 			: listFiltersTypes[filter].filterValues
										});							
								}
							}
							if(!$A.util.isEmpty(currentReportMap.CAB)){
								if(filterTofilters == 'CAB'||filterTofilters== 'MULTICAB'){
									report.reportMetadata.reportFilters =[];	
									var valueABI = userObj['OB_ABI__c'];
									var valueCAB = userObj['OB_CAB__c'];									
									valueCAB= valueCAB.replace(/;/g,",");
									var filterAbi = currentReportMap.ABI;
									var filterCab = currentReportMap.CAB;					
									report.reportMetadata.reportFilters.push({
											"column"						: filterAbi,
											"isRunPageEditable"				: false,
											"operator"						: "equals",
											"value"							: valueABI,
											"label" 						: listFiltersTypes[filterAbi].label,
											"type" 							: listFiltersTypes[filterAbi].dataType,
											"filterValues" 			: listFiltersTypes[filterAbi].filterValues
										})			
									report.reportMetadata.reportFilters.push({
										"column"							: filterCab,
										"isRunPageEditable"					: false,
										"operator"							: "equals",
										"value"								: valueCAB,
										"label" 							: listFiltersTypes[filterCab].label,
										"type" 								: listFiltersTypes[filterCab].dataType,
										"filterValues" 						: listFiltersTypes[filterCab].filterValues
									})
										}						
											//END    simone.misani 25/03/2019 - R1F2_RP_014 - Use CustomMetadata for controll ABI and CAB and Multi-Cab											
								var valuefilt = JSON.stringify(report.reportMetadata.reportFilters);								
								component.set("v.listFilters",listFilters);								
								component.set("v.valueFiltered",valuefilt);
								component.set("v.filters",report.reportMetadata.reportFilters);
								
								
							}
						}
						catch(err){						
							console.log('Error:'+err);
							console.log('## 4');
						}
					}    
					else if (state === "ERROR"){					
						var errors = resp.getError();
						if (errors){						
							if (errors[0] && errors[0].message){							
								console.log("Error message: " + errors[0].message);
							}
						}
						else{						
							console.log("Unknown error");
						}
					}
		
				});
				$A.enqueueAction(action);
			}
			else if (state === "INCOMPLETE") {

			}
			else if (state === "ERROR") {
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
	//Simone Misani delete  the comment  and console log
	
	sortData: function (component,helper, fieldName, sortDirection) {
		
		var data = component.get("v.allData");
		var datafilter = component.get("v.listFilters");	
		var field = fieldName.split("_Url");
		console.log("field split: "+field);
		console.log("sortDirection: "+ field[0]);
		if(datafilter == ""){
			var reverse = sortDirection !== 'asc';
			data.sort(this.sortBy(component,field[0], reverse));
			this.buildData(component, helper, data);
		}
		else{
			var reverse = sortDirection !== 'asc';
			datafilter.sort(this.sortBy(component,field[0], reverse));
			this.buildData(component, helper, datafilter);
		}
    },
    /*Simone Misani function sort table */
    sortBy: function (component, field, reverse) {		
		var fieldReport = field.toLowerCase();			
		var filedData= fieldReport.includes("date");		
		if(!filedData){
			var key = function(x) {return x[field].toLowerCase()};
			reverse = !reverse ? 1 : -1;		
			return function (filedA, fieldB) {
				return filedA = key(filedA), fieldB = key(fieldB), reverse * ((filedA > fieldB) - (fieldB > filedA));			
			}		
		}
		else{			
			var key =function(x) {return x[field]};
			reverse = !reverse ? 1 : -1;			
			return function (filedA, fieldB) {				
				if(key(filedA).includes('/')){
					var mydataA = key(filedA).split('/');
					var mydataB = key(fieldB).split('/');				
					mydataA = (mydataA[1] + "-" + mydataA[0] + "-" + mydataA[2])
					mydataB = (mydataB[1] + "-" + mydataB[0] + "-" + mydataB[2])
					var dataA= new Date(mydataA);
					var dataB= new Date(mydataB);
					dataA = dataA.getTime();
					dataB = dataB.getTime();
					return filedA =dataA, fieldB = dataB, reverse * ((filedA > fieldB) - (fieldB > filedA));
				}
				else{
					var mydataA = key(filedA).split('-');
					var mydataB = key(fieldB).split('-');
					mydataA = (mydataA[1] + "-" + mydataA[0] + "-" + mydataA[2])
					mydataB = (mydataB[1] + "-" + mydataB[0] + "-" + mydataB[2])
					var dataA= new Date(mydataA);
					var dataB= new Date(mydataB);
					dataA = dataA.getTime();
					dataB = dataB.getTime();
					return filedA =dataA, fieldB = dataB, reverse * ((filedA > fieldB) - (fieldB > filedA));
				}
			}			
		}
	},
	/*1.0 Simone Misani function filter table 
	  2.0	giovanni spinelli - start 
			date: 15/07/2019
			change method signature
	*/
	filterDataTable: function(component, event,helper,field){
		
		try {
			var data = component.get("v.allData");
			var results = [];
			/*for (var i = 0; i < data.length; i++) {
				var str = JSON.stringify(data[i]).toLowerCase();
				console.log('stringa 1: ' , str);
				var str2 = field.toLowerCase();
				if (str.includes(str2) ) {
					results.push(data[i]);
				}
			}*/
			var inputValue = field.toLowerCase();
			for (var i = 0; i < data.length; i++) {
				for (var nameField in data[i]) {
					var valueField = data[i][nameField].toLowerCase();
					if (valueField.includes(inputValue) && !valueField.includes('http')) {
						results.push(data[i]);
						break;
					}
				}
			}
			if (results.length != 0) {
				if (typeof (field) != undefined && field != null && field != "") {
					component.set("v.currentPageNumber", 1);
					component.set("v.listFilters", results);
					this.buildData(component, helper);
				}
				else {
					component.set("v.currentPageNumber", 1);
					component.set("v.listFilters", data);
					this.buildData(component, helper);
				}
			}
			else {
				component.set("v.error", true);
				component.set("v.currentPageNumber", 1);
				component.set("v.listFilters", "");
				this.buildData(component, helper);
			}
		} catch (err) {
			console.log('error in filterDataTable: '+err.message);
		}
		  	
	},
	/*Simone Misani function clare table */
	tableClear : function(component, event, helper){		
        var data = component.get("v.allData");
		component.set("v.currentPageNumber", 1);
		component.set("v.pageSize", 10);
		component.set("v.listFilters",data);
		this.buildData(component, helper);
	},
	//  START antonio.vatrano r1f2-200-140 30/05/2019 
	retriveMaxLength : function(report, index){
        var factMap = report.factMap;
        var factMapRows = factMap['T!T'];
        var singleRow = factMapRows.rows;
        var maxlength = 0;
        for (var singleCol in singleRow){
            var a = singleRow[singleCol];
            var b = a['dataCells'];
            var sizeRow = b.length-1;
            var myValue = b[sizeRow-index];
            var myLength = myValue['label'];
            if(maxlength< myLength.length){
                maxlength = myLength.length;
            }
        }
        return maxlength;
	}
	//  END antonio.vatrano r1f2-200-140 30/05/2019 
})