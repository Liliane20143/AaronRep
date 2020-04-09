({
    getMatrixParameterByBundle: function(component, event)
    {
        var bundle = component.get("v.bundle");
        console.log("bundle: "+ JSON.stringify(bundle));
        //START francesca.ribezzi 10/06/19 
        var goToSaleabilityForBank = component.get("v.goToSaleabilityForBank");
        var bankABI = component.get("v.bankABI");
        //END francesca.ribezzi 10/06/19
        var action = component.get("c.getMatrixParameterByOffer");
        action.setParams({
            bundle: bundle,
            isPricingForBank: goToSaleabilityForBank,
            abi: bankABI
        });
        action.setCallback(this, function(response)
        {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("Map of Matrix param From server: ", response.getReturnValue());
                var matrixParameterMap = response.getReturnValue();
               // component.set("v.matrixParameterMap", matrixParameterMap);
                var matrixParameterList = [];
                for(var key in matrixParameterMap){
                    var tempObj = {};
                    tempObj.recordType = key;
                    tempObj.matrixParameters = matrixParameterMap[key];
                    //davide.franzini - 05/07/2019 - START
                    if(tempObj.recordType != null && tempObj.recordType != 'null'){
                        matrixParameterList.push(tempObj);
                    }else{
                        tempObj.recordType = 'Offer';
                        matrixParameterList.push(tempObj);
                    }
                    //davide.franzini - 05/07/2019 - END
                }
                console.log("matrixParameterList: ", matrixParameterList); 
                component.set("v.matrixParameterList", matrixParameterList);
            }
            else
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
    //START francesca.ribezzi 17/06/19 adding checkForInProgressApexJobs function:
    checkForInProgressApexJobs: function(component, event){
        var message = '';
        var type = '';
        var matrixParameterList = component.get("v.matrixParameterList");
        var cleanMatrixList = [];
        for(var i in matrixParameterList){
            cleanMatrixList = cleanMatrixList.concat(matrixParameterList[i].matrixParameters);
        }
        var action = component.get("c.searchForApexJobs");
     /*   action.setParams({
            matrixParameters: cleanMatrixList
        });*/
        action.setCallback(this, function(response)
        {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('@@@isCompleted? ' + response.getReturnValue());
                if(response.getReturnValue()){
                    this.callCloneMatrixHelper(component, event, cleanMatrixList);
                }else{
                    message = $A.get("$Label.c.OB_UnderwayProcess");
                    type = 'warning';
                    this.showToast(component, event, message, type);
                }
      
            }
            else
            {
                var errors = response.getError();
                if (errors)
                {
                    if (errors[0] && errors[0].message)
                    {
                        message = 'L operazione è fallita. Contattare l amministratore';
                        type = 'error';
                        this.showToast(component, event, message, type);
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
    //END francesca.ribezzi 17/06/19



    callCloneMatrixHelper : function(component, event, cleanMatrixList)
    {
        var matrixParameterList = component.get("v.matrixParameterList");
        var completedMap = component.get("v.completedMap");
      /*  var cleanMatrixList = [];
        for(var i in matrixParameterList){
            cleanMatrixList = cleanMatrixList.concat(matrixParameterList[i].matrixParameters);
        }*/
        var service = 'ABI';   //davide.franzini - WN-216 - 30/07/2019 added service parameter
        var message = '';
        var type = '';
        var tempList = [];
        var tempMap = {};
        console.log('## completedMap: ',completedMap);
        console.log('## clenMatrix: ',cleanMatrixList);
        var action = component.get("c.cloneMatrixParameterServer");
        action.setParams({
            matrixParameters: cleanMatrixList,
            matrixIdAbiListmap: completedMap,
            service: service    //davide.franzini - WN-216 - 30/07/2019 added service parameter
        });
        action.setCallback(this, function(response)
        {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('@@@isOkSize? ' + response.getReturnValue());
                //START francesca.ribezzi 17/06/19
                if(response.getReturnValue()){
                    message = 'L operazione è avvenuta con successo';
                    type = 'success';
                }else if(!response.getReturnValue()){
                    message = $A.get("$Label.c.OB_MaxSelectedABI");
                    type = 'warning';
                }else if(response.getReturnValue() == null){
                    message = $A.get("$Label.c.OB_OperationFailedLabel"); 
                    type = 'error';
                }
                //END francesca.ribezzi 17/06/19
               this.showToast(component, event, message, type);
            }
            else
            {
                var errors = response.getError();
                if (errors)
                {
                    if (errors[0] && errors[0].message)
                    {
                        message = $A.get("$Label.c.OB_OperationFailedLabel");
                        type = 'error';
                        this.showToast(component, event, message, type);
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

    showToast: function(component,event, message, type){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: '',
            message:  message,
            duration: '5000',
            key: 'info_alt',
            type: type,
            mode: 'pester'
        });
        toastEvent.fire();
    },
    /*******************************************************************************
    Purpose: clone matrix param in matrix params rows 
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Andrea Saracini         27/05/2019      Created         Method
    ********************************************************************************/
    callCloneMatrixRowsHelper : function(component, event){
        var matrixParams = component.get("{!v.matrixParameterList}");
        console.log("matrixParameterList: "+ matrixParams);
        var action = component.get("c.cloneMatrixParameterRowsServer");
        component.set("{!v.spinner}", true);
        action.setParams({
            matrixParameters: JSON.stringify(matrixParams)
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('success: '+state);
            }
            else{
                var errors = response.getError();
                if (errors){
                    if (errors[0] && errors[0].message){
                        console.log("Error message: " +errors[0].message);
                    }
                }
                else{
                    console.log("Unknown error");
                }
            }
            component.set("{!v.spinner}", false);
        });
        $A.enqueueAction(action);
    },

     /*******************************************************************************
    Purpose: call server to update active bank field on matrix parameter rows
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         francesca.ribezzi       10/06/2019      Created         Method
    ********************************************************************************/
   callUpdateActiveBankMatrixRowsHelper : function(component, event){
    var matrixParams = component.get("v.matrixParameterList");
    console.log("matrixParameterList: ", matrixParams);
    //davide.franzini - F2WAVE-117 - 11/07/2019 - START
    var message = '';
    var type = '';
    //davide.franzini - F2WAVE-117 - 11/07/2019 - END

    var cleanMatrixList = [];
    for(var i in matrixParams){
        cleanMatrixList = cleanMatrixList.concat(matrixParams[i].matrixParameters);
    }
    console.log("cleanMatrixList: ", cleanMatrixList);

    var action = component.get("c.updateActiveBankMatrixParameterRows");
    component.set("v.spinner", true);
    action.setParams({
        matrixParameters: cleanMatrixList
    });
    action.setCallback(this, function(response){
        var state = response.getState();
        if (state === "SUCCESS") {
            console.log('success: '+state);
            //davide.franzini - F2WAVE-117 - 11/07/2019 - START
            message = $A.get("$Label.c.OB_MAINTENANCE_TOAST_OPERATIONSUCCESSFULL");
            type = 'success';
            this.showToast(component, event, message, type);
            //davide.franzini - F2WAVE-117 - 11/07/2019 - END
        }
        else{
            var errors = response.getError();
            if (errors){
                if (errors[0] && errors[0].message){
                    console.log("Error message: " +errors[0].message);
                }
            }
            else{
                console.log("Unknown error");
            }
            //davide.franzini - F2WAVE-117 - 11/07/2019 - START
            message = $A.get("$Label.c.OB_OperationFailedLabel"); 
            type = 'error';
            this.showToast(component, event, message, type);
            //davide.franzini - F2WAVE-117 - 11/07/2019 - END
        }
        component.set("v.spinner", false);
    });
    $A.enqueueAction(action);
},

    /*******************************************************************************
    Purpose: call Server to deactivate offer when configuration is rejected by Bank Admin
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         davide.franzni          11/07/2019      Created         Method
    ********************************************************************************/
    rejectConfigurationHelper : function(component, event){
        var abi = component.get("v.bankABI");
        var offer = component.get("v.bundle.Id");
        var action = component.get("c.deactivateOffer");
        //davide.franzini - F2WAVE-117 - 11/07/2019 - START
        var message = '';
        var type = '';
        //davide.franzini - F2WAVE-117 - 11/07/2019 - END
        component.set("v.spinner", true);
        action.setParams({
            abi: abi,
            offer: offer
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('success: '+state);
                //davide.franzini - F2WAVE-117 - 11/07/2019 - START
                message = $A.get("$Label.c.OB_MAINTENANCE_TOAST_OPERATIONSUCCESSFULL");
                type = 'success';
                this.showToast(component, event, message, type);
                //davide.franzini - F2WAVE-117 - 11/07/2019 - END
            }
            else{
                var errors = response.getError();
                if (errors){
                    if (errors[0] && errors[0].message){
                        console.log("Error message: " +errors[0].message);
                    }
                }
                else{
                    console.log("Unknown error");
                }
                //davide.franzini - F2WAVE-117 - 11/07/2019 - START
                message = $A.get("$Label.c.OB_OperationFailedLabel"); 
                type = 'error';
                this.showToast(component, event, message, type);
                //davide.franzini - F2WAVE-117 - 11/07/2019 - END
            }
            component.set("v.spinner", false);
        });
        $A.enqueueAction(action);

    },

})