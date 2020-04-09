({
	callApexMethod : function(cmp,methodName,params){
        console.log('callApexMethod');
    	return new Promise($A.getCallback(function(resolve, reject) {
    		var action = cmp.get("c."+methodName);
    		if (params) action.setParams(params);
	        action.setCallback(this, function(response) {
	            var state = response.getState();
	            if (state === "SUCCESS") {
                    console.log('RESOLVED');
	            	resolve(response.getReturnValue());
	            }
                else reject( response.getError() );
                console.log('REJECTED');
	        });
	        $A.enqueueAction(action);
    	}));
    },
    runBatch : function (cmp, helper,params) {
        cmp.set("v.batchStatus", "");
        var timer = setInterval(myTimer, 5000);
        function myTimer() {
            helper.getBatchData(cmp, helper, timer);
        }

        var action = cmp.get("c.runBatchByName");
        action.setParams({batchName:params});
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if (response.getReturnValue()){
                    helper.showSuccessMessage("Batch started");
                    helper.getBatchData(cmp, helper);
                }else{
                    helper.showErrorMessage("Error while starting batch");
                }
            }
            else {
            }
        });
        $A.enqueueAction(action);
    
    }, 
    stopBatch: function (cmp, helper, params) {
        cmp.set("v.batchStatus", "");
        var action = cmp.get("c.stopBatch");
        action.setParams({ schedulerName: params });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if (response.getReturnValue()) {
                    helper.showSuccessMessage("Batch stopped");
                    helper.getBatchData(cmp, helper);
                } else {
                    helper.showErrorMessage("Error while stopping batch");
                }
            }
            else {
            }
        });
        $A.enqueueAction(action);

    },
    setOldTransactionsColumns:function(cmp){
        var columns = [
            {label:'Date',fieldName:'CreatedDate',type:'date',typeAttributes: {
                    year: 'numeric',
                    month: 'numeric',
                    day: 'numeric',
                    hour: '2-digit',
                    minute: '2-digit'
                }
            },
            {label:'Status',fieldName:'Plc_ResponseStatus__c',type:'text'},
            {label:'Result',fieldName:'Plc_RequestBody__c',type:'text'},
            {label:'Total Execution Time',fieldName:'Plc_TotalExecutionTime__c',type:'number'}
        ];
        cmp.set("v.columns",columns);
    },
    getBatchData : function(cmp,helper,timer)
    {
        console.log('getBatchData');
        helper.retrieveTranslationMap(cmp, helper);
        if (cmp.get("v.batchName") != null && cmp.get("v.batchName") != undefined && cmp.get("v.batchName")!= ''){
            helper.getBatchStatus(cmp, helper,timer);
            helper.getOldExecutionsStatuses(cmp, helper);
        }else{
            cmp.set("v.batchExecutions", []);
        }
    },
    getBatchStatus : function(cmp,helper,timer)
    {
        cmp.set("v.batchStatus","");
        helper.callApexMethod(cmp, "getBatchStatus", { schedulerName: cmp.get("v.batchName")}).then(function(batchStatus){
            cmp.set("v.batchStatus",batchStatus);
            if (timer != null && timer != undefined && batchStatus == cmp.get("v.translationMap.Idle") ){
                clearInterval(timer);
            }
		},function(error){
			console.log(error);
			helper.showErrorMessage("Error while fetching batch status");
		});
    },
    getOldExecutionsStatuses : function(cmp,helper)
    {
        console.log('getOldExecutionsStatuses BATCHNAME: ' + cmp.get("v.batchName"));
        helper.callApexMethod(cmp, "getBatchExecutionsStatuses", { schedulerName: cmp.get("v.batchName")}).then(function(batchExecutions){
            console.log(batchExecutions.length);
            cmp.set("v.batchExecutions",batchExecutions);
        },function(error){
            console.log(error);
            helper.showErrorMessage("Error while fetching old batch execution statuses");
        });
    },
    showSuccessMessage: function(message){
        var showToast = $A.get("e.force:showToast");
        showToast.setParams({
            'title' : '',
            'type': 'success',
            'message' : message
        });
        showToast.fire();
    },
    showErrorMessage: function(message){
        var showToast = $A.get("e.force:showToast");
        showToast.setParams({
            'title' : '',
            'type': 'error',
            'message' : message
        });
        showToast.fire();
    },
    getAvailableBatch: function (cmp,event,helper) {
        
        console.log('Inside Get Available Batch');
        var action = cmp.get("c.getBatchAvailable");
        var batchItems = [];
        var schedulabilityItems = {};
        console.log('Before CallBack');
        action.setCallback(this,function(response){
            var state = response.getState();
            console.log("INSIDE CALLBACK ");
            if (state === "SUCCESS") {
                var result = response.getReturnValue();

                if (!result.hasOwnProperty('errorList')) {
                    Object.keys(result.itemBatch).forEach(function (key) {
                        batchItems.push({ label: key, value: result.itemBatch[key] });
                        schedulabilityItems[result.itemBatch[key]] = result.schedulableData[key];
                    });
                    console.log('MAPTEST: '+JSON.stringify(schedulabilityItems));
                    cmp.set("v.availableBatches", batchItems);
                    cmp.set("v.schedulabilityMap", schedulabilityItems);

                    var pageRef = cmp.get("v.pageReference");
                    //Check if the parameter entered in the URL is a valid batch
                    if (pageRef.state.c__batchToLaunch != undefined && pageRef.state.c__batchToLaunch != null && pageRef.state.c__batchToLaunch != '') {
                        var find = false;
                        Object.keys(result.itemBatch).forEach(function (key) {
                            if (result.itemBatch[key] == pageRef.state.c__batchToLaunch) {
                                find = true;
                                cmp.set("v.selectedBatch", result.itemBatch[key]);
                                cmp.set("v.schedulability", schedulabilityItems[result.itemBatch[key]]);
                            }
                        });

                        if (find == true) {
                            cmp.set("v.batchName", pageRef.state.c__batchToLaunch);
                            cmp.set("v.isSelectedBatch", true);
                            cmp.set("v.batchName", pageRef.state.c__batchToLaunch);
                            helper.getBatchData(cmp,helper);

                        } else {
                            helper.showToast('Access unauthorized','The user is not enabled to use this batch or not exist','','sticky');
                        }
                    }

                }else{
                    helper.showToast('Access unauthorized', 'The user not has any permission to launch a batch','', 'sticky');
                }

            }
            else {
                console.log("ERRORE! "+response.getError());
            }

        });
        $A.enqueueAction(action);
    },
    setSelectedBatch: function (cmp, event, helper) {
        // Inserire qui il sistema di aggiornamento del nome della variabile che consente il lancio del batch
            var selectedMenuItemValue = event.getParam("value");

            console.log("Batch Selezionato: " + selectedMenuItemValue);
            var schedulabilityMap = cmp.get('v.schedulabilityMap');


            cmp.set("v.batchName", selectedMenuItemValue);
            cmp.set("v.isSelectedBatch", true);
            cmp.set("v.selectedBatch", selectedMenuItemValue);
            cmp.set("v.schedulability", schedulabilityMap[selectedMenuItemValue]);
            cmp.set("v.showScheduler", false);
            helper.getBatchData(cmp,helper);

    },
    removeSelectedBatch: function (cmp, event, helper) {
        // Inserire qui il sistema di aggiornamento del nome della variabile che consente il lancio del batch
        cmp.set("v.batchName", '');
        cmp.set("v.isSelectedBatch", false);    
        cmp.set("v.batchExecutions",[]);
    },
    /* Shows a custom message defined by parameters */
    showToast: function (title, message, type, mode) {
        // show toast message
        // mode
        // sticky: it stays on screen until user action
        // dismissable: it disappears after some time automatically
        var toastEvent = $A.get('e.force:showToast');
        toastEvent.setParams({
            'title': title,
            'message': message,
            'type': type,
            'mode': mode || 'dismissable',
            'duration': 3000
        });
        toastEvent.fire();
    },
    retrieveTranslationMap: function (cmp,helper){
        var action = cmp.get("c.retrieveTranslationMap");
        action.setCallback(this, function (response) {
            var state = response.getState();
            var items = [];
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                cmp.set('v.translationMap.SelecttheBatchthatyouwanttolaunch', result.SelecttheBatchthatyouwanttolaunch);
                cmp.set('v.translationMap.Status', result.Status);
                cmp.set('v.translationMap.Last10executions', result.Last10executions);
                cmp.set('v.translationMap.Runbatch', result.Runbatch);
                cmp.set('v.translationMap.Stopbatch', result.Stopbatch);
                cmp.set('v.translationMap.Accessunauthorized', result.Accessunauthorized);
                cmp.set('v.translationMap.Theuserisnotenabledtousethisbatchornotexist', result.Theuserisnotenabledtousethisbatchornotexist);
                cmp.set('v.translationMap.Nooldexecutionsinfoavailable', result.Nooldexecutionsinfoavailable);
                cmp.set('v.translationMap.Idle', result.Idle);
                cmp.set('v.translationMap.Running', result.Running);

                var days = [];
                days.push(
                    { label: result.Monday, value: 'Monday'},
                    { label: result.Tuesday, value: 'Tuesday' },
                    { label: result.Wednesday, value: 'Wednesday' },
                    { label: result.Thursday, value: 'Thursday' },
                    { label: result.Friday, value: 'Friday' },
                    { label: result.Saturday, value: 'Saturday' },
                    { label: result.Sunday, value: 'Sunday' }
                    );
                
                cmp.set("v.daysAvailable", days);
                
                //Da valorizzare con i giorni disponibili
                var daysAvailableMonthly = [];
                for(var i = 1 ; i<32 ; i++){
                    daysAvailableMonthly.push({ label: "" + i + "", value: "" + i + "" });
                }
                daysAvailableMonthly.push({ label: 'last', value: 'L' });

                cmp.set("v.availableDaysNumber", daysAvailableMonthly);
                //Da valorizzare con le ore disponibili
                var hoursAvailable = [];

                for(var i = 0 ; i<10 ; i++){
                    hoursAvailable.push({ label: "0" + i + ":00", value: "0" + i + "" });
                }
                for (var i = 0; i < 10; i++) {
                    hoursAvailable.push({ label: "1" + i + ":00", value: "1" + i + "" });
                }
                for (var i = 0; i < 4; i++) {
                    hoursAvailable.push({ label: "2" + i + ":00", value: "2" + i + "" });
                }
                cmp.set("v.hourAvailable", hoursAvailable);
                
                cmp.set('v.translationMap.Monday', result.Monday);
                cmp.set('v.translationMap.Tuesday', result.Tuesday);
                cmp.set('v.translationMap.Wednesday', result.Wednesday);
                cmp.set('v.translationMap.Thursday', result.Thursday);
                cmp.set('v.translationMap.Friday', result.Friday);
                cmp.set('v.translationMap.Saturday', result.Saturday);
                cmp.set('v.translationMap.Sunday', result.Sunday);

            }
            else {
                console.log("ERRORE! " + response.getError());
            }

        });
        $A.enqueueAction(action);
    },
    getSelected: function (cmp,event,helper) {

        var selected = event.getParam('value');
        cmp.set("v.selectedForCronoTime", selected);

    },
    getSelectedHour: function (cmp, event, helper) {

        var selected = event.getParam('value');
        cmp.set("v.selectedHour", selected);

    },
    getSelectedDayOfTheMonth: function (cmp, event, helper) {
        var selected = event.getParam('value');
        cmp.set("v.selectedDayForMonthly", selected);

    },
    showScheduler: function (cmp, event, helper) {

        cmp.set("v.showScheduler", true);
        cmp.set("v.selectedHour", '');
        cmp.set("v.selectedDayForMonthly", '');

    },
    hideScheduler: function (cmp, event, helper) {

        cmp.set("v.showScheduler", false);
        cmp.set("v.selectedHour", '');
        cmp.set("v.selectedDayForMonthly", '');

    },
    setJob: function (cmp, event, helper) {

        var schedulabilityMap = cmp.get("v.schedulabilityMap");
        var schedulerName = cmp.get("v.selectedBatch");
        var selectedForCronoTime = cmp.get("v.selectedForCronoTime");
        var cronoTime;
        var hourSelected = cmp.get('v.selectedHour');

        console.log('hourSelected: ' + hourSelected);
        console.log('selectedForCronoTime' + selectedForCronoTime);

        if (schedulabilityMap[schedulerName] == 'Weekly'){


            if (selectedForCronoTime == '' || selectedForCronoTime == null || selectedForCronoTime == undefined) {

                helper.showToast('Complete all mandatory fields', 'Select at least one day', '', 'sticky');
                return;
            }
            if (hourSelected == null || hourSelected == undefined || hourSelected==''){

                helper.showToast('Complete all mandatory fields', 'Select preferred time to schedule batch ', '', 'sticky');
                return;
            }

            var mapDay = {};
            mapDay.Monday = 'MON';
            mapDay.Tuesday = 'TUE';
            mapDay.Wednesday = 'WED';
            mapDay.Thursday = 'THU';
            mapDay.Friday = 'FRI';
            mapDay.Saturday = 'SAT';
            mapDay.Sunday = 'SUN';

            var hourSelected = cmp.get('v.selectedHour');

            cronoTime = '0 0 '+hourSelected+' 0 ? * ';

            var first = true;
            selectedForCronoTime.forEach(element => {
                if(first){
                    cronoTime = cronoTime +mapDay[element];
                    first=false;
                }else{
                    cronoTime = cronoTime+','+mapDay[element];
                }
            });
            
            /*
            var action = cmp.get("c.setSchedulable");
            action.setParams({ schedulerName: schedulerName , cronoTime: cronoTime});
            action.setCallback(this, function (response) {

            });
            $A.enqueueAction(action);
            */
            console.log('CronoTime: ' + cronoTime);
        }else{
            var hourSelected = cmp.get('v.selectedHour');
            var selectedDaysForMonthly = cmp.get('v.selectedDayForMonthly');


            if (selectedDaysForMonthly == '' || selectedDaysForMonthly == null || selectedDaysForMonthly == undefined) {

                helper.showToast('Complete all mandatory fields', 'Select a day to schedule batch', '', 'sticky');
                return;
            }
            if (hourSelected == null || hourSelected == undefined || hourSelected == '') {

                helper.showToast('Complete all mandatory fields', 'Select preferred time to schedule batch ', '', 'sticky');
                return;
            }

            
            cronoTime = '0 0 ' + hourSelected + ' ' + selectedDaysForMonthly + ' 0 ? * ';
            console.log('CronoTime: ' + cronoTime);
            /*
            var action = cmp.get("c.setSchedulable");
            action.setParams({ schedulerName: schedulerName , cronoTime: cronoTime});
            action.setCallback(this, function (response) {

            });
            $A.enqueueAction(action);
            */
        }
        
    }


})