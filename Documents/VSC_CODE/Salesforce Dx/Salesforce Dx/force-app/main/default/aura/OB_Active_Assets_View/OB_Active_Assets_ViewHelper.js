({
    performSearchOnServer : function(component, event, helper,wrapper ){
        console.log('performSearchOnServer start');
         try{
            var action = component.get('c.search');
            action.setParams({ "jsonWrap" : wrapper });//simone.misani@accenture.com 03/05/2019 RI-34 
            action.setCallback(this, $A.getCallback(function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var valueReturns = response.getReturnValue();
                    var result = JSON.parse( valueReturns );
                    if(result.outcome == $A.get("$Label.c.OB_MAINTENANCE_NOERROR")){
                        console.log('no error on outcome');
                        component.set("v.FlowData",valueReturns);
                        component.set("v.FlowStep", $A.get("$Label.c.OB_MAINTENANCE_STEP_SUMMARY"));
                        component.set("v.showOffer", true);
                    }
                    else{//simone.misani@accenture.com 03/05/2019 RI-34 
                        console.log('error on outcome'); 
                        this.showToast(component, event, helper,$A.get("$Label.c.OB_MAINTENANCE_TOASTERROR"), result.errorMessage, "error");
                    }
                }
                else if (state === "ERROR") {//simone.misani@accenture.com 03/05/2019 RI-34 
                    var errors = response.getError();
                    console.error(errors);
                }
            }));
            $A.enqueueAction(action);   
        }
        catch(err) {//simone.misani@accenture.com 03/05/2019 RI-34 
                console.log ('SEARCH ERROR EXCEPTION:'+ err);
        } 
    },
    /*simone.misani@accenture.com 
    03/05/2019 
    RI-34 */
    showToast: function (component, event, helper,title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    },
    // Start antonio.vatrano 08/04/2019 function to filter all fields
    createMapFilter : function(component, event, helper){
        // Start simone.misani 03/05/2019  Add filter RI-34
        var valueabi = component.find("abi").get("v.value");
        var valueterminalId = component.find("terminalId").get("v.value");
        var valuecodiceRacSia = component.find("codiceRacSia").get("v.value");
        var valuecodiceMonetica = component.find("codiceMonetica").get("v.value");
        var valuecodiceStabilimento= component.find("codiceStabilimento").get("v.value");
        var valuecodiceSocieta = component.find("codiceSocieta").get("v.value");
        var valuecodicePV = component.find("codicePV").get("v.value");
        var valueBusinessModel = component.find("BusinessModel").get("v.value");
        
        var mapValueFilter = new Map();
        if(valueabi)
        mapValueFilter["abi"] = valueabi;
        if(valueterminalId)
            mapValueFilter["termId"] = valueterminalId;
        if(valuecodiceRacSia)
            mapValueFilter["codiceSia"] = valuecodiceRacSia;
        if(valuecodiceMonetica)
            mapValueFilter["clientId"] = valuecodiceMonetica; // antonio.vatrano 24/06/2019 ri-108
        if(valuecodiceStabilimento)
            mapValueFilter["codiceStab"] = valuecodiceStabilimento;
        if(valuecodiceSocieta)
            mapValueFilter["codiceSocieta"] = valuecodiceSocieta;
        if(valuecodicePV)
            mapValueFilter["codicePv"] = valuecodicePV;
        if(valueBusinessModel)
            mapValueFilter["businessModel"] = valueBusinessModel;
        // END simone.misani 03/05/2019  Add filter RI-34
        return mapValueFilter;
    },
    /*simone.misani@accenture.com 
    03/05/2019 
    RI-34 
    Function for input filter */
    booleanFilter : function (item, mapValue){
        for(var k in mapValue){
            if(item[k] != mapValue[k]){
                return false;
            }
        }
        return true;
    },
    /*simone.misani@accenture.com 
    03/05/2019 
    RI-34 
    Function for input filter to pos */
    filterPos : function (component, mapfilter){
        var posToFilter = component.get("v.posList");
        var posFiltered = [];
        for(var k in posToFilter){
            var rightPos = this.booleanFilter (posToFilter[k], mapfilter);
            if(rightPos){
                posFiltered.push(posToFilter[k]);
            }
        }
        return posFiltered;
    },
     /*simone.misani@accenture.com 
    03/05/2019 
    RI-34 
    Function for input filter to PagoBancomat */
    filterPagoBancomat : function (component, mapfilter){
        var pagobancomatToFilter = component.get("v.pagoList");
        var pagobancomatFiltered = [];
        for(var k in pagobancomatToFilter){
            var rightPago = this.booleanFilter (pagobancomatToFilter[k], mapfilter);
            if(rightPago){
                pagobancomatFiltered.push(pagobancomatToFilter[k]);
            }
        }
        return pagobancomatFiltered;
    },
     /*simone.misani@accenture.com 
    03/05/2019 
    RI-34 
    Function for input filter to Acquiring */
    filterAcquaring : function (component, mapfilter){
        var acquiringToFilter = component.get("v.acquiringList");
        var acquiringFiltered = [];
        for(var k in acquiringToFilter){
            var rightAcquiring = this.booleanFilter (acquiringToFilter[k], mapfilter);
            if(rightAcquiring){
                acquiringFiltered.push(acquiringToFilter[k]);
            }
        }
        return acquiringFiltered;
    },
    // End antonio.vatrano 08/04/2019 function to filter all fields
     /*simone.misani@accenture.com 
    03/05/2019 
    RI-34 
    Function for button for showOffer  */
    showOffer: function(component, event, helper){
        console.log("show offer");
        // var eventId = event.getSource().get("v.value");
        var eventId = event.getParam('row').id;
        var AccountName      =  component.get("v.accountName");
        var VatNumber        =  '';
        var ServicePoint     =  '';
        var SIACode          =  '';
        var SiaEstablishment =  '';
        var TerminalId       =  '';
        var url =  '';
        var app =  '';
        var InternalUser = true;  
        var MoneticaCustomerCode = '';
        var MoneticaEstablishmentCode = '';
        var ABI = JSON.parse(JSON.stringify(component.get("v.mapAbi")[eventId]));
        var wrapper = {AccountName:AccountName, VatNumber:VatNumber, ServicePoint:ServicePoint,SIACode : SIACode, SiaEstablishment: SiaEstablishment,TerminalId: TerminalId, url: url, app: app, MoneticaCustomerCode : MoneticaCustomerCode, MoneticaEstablishmentCode : MoneticaEstablishmentCode, ABI : ABI };
        var JSONwrap =  JSON.stringify(wrapper);
        component.set("v.proposerABI",ABI);
        for(var key in component.get("v.mapAssetBundleConfig")){
            if(key ==eventId ){
                component.set("v.bundleConfiguration",component.get("v.mapAssetBundleConfig")[key]);
            }	
        }
        this.performSearchOnServer(component, event, helper,JSONwrap);
    },
    /*simone.misani@accenture.com 
    03/05/2019 
    RI-34 
    Function for button for showAttribute  */
    showAttribute: function(component, event, helper){
        component.set("v.attributeColumns", [
            {label: 'Nome', fieldName: 'Name',type: 'text'},
            {label: 'Valore', fieldName: 'Value',type: 'text'}		// antonio.vatrano 17/04/2019 bugfix RI-5 
            ]);
        console.log('showDetails');
        var eventId = event.getParam('row').id;
        var methodValue = component.get("v.mapItem")[eventId] == 'Asset'?'getAttributes':'getAttributesItem';
        var action = component.get("c."+methodValue);
        action.setParams({"orderItemId": eventId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                res = JSON.parse(res);		// antonio.vatrano 17/04/2019 bugfix RI-5 
                component.set("v.attributesList",res);
                component.set("v.isToShowAttribute",true);
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
                    console.log("****Unknown error");
                }
            }
        });
        
        $A.enqueueAction(action);
        
    },
        /* simone.misani@accenture.con function to create colum for datatable.
            RI-34
            03/05/2019
        */
    setColumns : function(component, event, helper){
        // Start simone.misani@accenture.com  add colum for dfeect Ri-34
        component.set("v.columnsPos", [
            { type: "button",typeAttributes: {iconName: 'utility:search',label: '',disabled: false,value: 'id',name:'showOffer'}},
            { type: "url", fieldName:'baseUrl',typeAttributes: { label:{ fieldName: 'orderNamePos'}}},
            { type: "button",typeAttributes: {iconName: 'utility:chevrondown',label: '',disabled: false,value: 'id',name:'showEnablements'}},
            { label: $A.get('$Label.c.OB_Pagobancomat') ,type: 'text'},
            { label: $A.get('$Label.c.OB_Pos'), fieldName: 'prodName',type: 'text'},
            { label: $A.get('$Label.c.OB_Termi_Id'),type: 'button',typeAttributes: {label:{fieldName: 'termId'} ,name:'showAttribute'},cellAttributes: {class:'textBold'}},

            { label: $A.get('$Label.c.OB_Property') , fieldName: 'terminalProprietaValue',type: 'text'}, //Masoud zaribaf  Modify label  for last part of defect Ri-34 09/05/2019
            { label: $A.get('$Label.c.OB_SiaCode'), fieldName: 'codiceSia',type: 'text'},
            { label: $A.get('$Label.c.OB_MAINTENANCE_INSTALLATIONDATE'), fieldName: 'dataInstallazione',type: 'text'},		
            { label: $A.get('$Label.c.OB_MAINTENANCE_ABI'), fieldName: 'abi',type: 'text'},	
            { label: $A.get('$Label.c.OB_MAINTENANCE_MONETICA_CUSTOMER_CODE'), fieldName: 'clientId',type: 'text'},	//simone misani 24/05/2019 R1F2-194
            { label: $A.get('$Label.c.OB_establishment_Code'), fieldName: 'codiceStab',type: 'text'},	
            { label: $A.get('$Label.c.OB_MAINTENANCE_CONVENTIONCODE'), fieldName: 'codiceConv',type: 'text'},	
            { label: $A.get('$Label.c.OB_GT'), fieldName: 'gtPos',type: 'text'},	
            { label: $A.get('$Label.c.OB_MAINTENANCESTATUSFIELDLABEL'), fieldName: 'stato',type: 'text'},
            { cellAttributes: {iconName: 'utility:record', class:{fieldName: 'color'}}}
            ]);
        component.set("v.columnsPago", [
            {type: "button", typeAttributes: {iconName: 'utility:search',label: '',disabled: false,value: 'id', name:'showOffer'}},
            {label: $A.get('$Label.c.OB_Pagobancomat') ,type: 'text'},
            {label: $A.get('$Label.c.OB_MAINTENANCE_ABI'), fieldName: 'abi',type: 'text'},	
            {label: $A.get('$Label.c.OB_MAINTENANCESTATUSFIELDLABEL') , fieldName: 'stato',type: 'text'}
            	
            ]);
        component.set("v.columnsAcquiring", [
            {type: "button", typeAttributes: {iconName: 'utility:search',label: '',disabled: false,value: 'id', name:'showOffer'}},
            {label: $A.get('$Label.c.OB_CircuitsAcquiring'), fieldName: 'prodName',type: 'text'},
            {label: $A.get('$Label.c.OB_MAINTENANCE_ABI'), fieldName: 'abi',type: 'text'},	
            {label: $A.get('$Label.c.OB_Processor_code'), fieldName: 'codiceSocieta',type: 'text'},	
            {label: $A.get('$Label.c.OB_pvCode'), fieldName: 'codicePv',type: 'text', cellAttributes: {class:'textBold'}},
            {label: $A.get('$Label.c.OB_MCC_Code'), fieldName: 'mcc',type: 'text'},	
            {label: $A.get('$Label.c.OB_ActivationDate'), fieldName: 'dataInstallazione',type: 'text'},	
            {label: $A.get('$Label.c.OB_Disactivation_Date'), fieldName: 'dataDinstallazione',type: 'text'},	
            {label: $A.get('$Label.c.OB_Processor'), fieldName: 'processor',type: 'text'},
            {label: $A.get('$Label.c.OB_BusinessModel'), fieldName: 'businessModel',type: 'text'},		
            {label: $A.get('$Label.c.OB_MAINTENANCESTATUSFIELDLABEL'), fieldName: 'stato',type: 'text'},
            {cellAttributes: {iconName: 'utility:record', class:{fieldName: 'color'}}},
            ]);
        component.set("v.columnsVas", [
            {type: "button", typeAttributes: {iconName: 'utility:search',label: '',disabled: false,value: 'id', name:'showOffer'}},
            {label: $A.get('$Label.c.OB_Vas'), fieldName: 'prodName',type: 'text'},
            {label: $A.get('$Label.c.OB_MAINTENANCE_ABI'), fieldName: 'abi',type: 'text'},		
            {label: $A.get('$Label.c.OB_MAINTENANCESTATUSFIELDLABEL'), fieldName: 'stato',type: 'text'},
            {cellAttributes: {iconName: 'utility:record', class:{fieldName: 'color'}}},
            ]);

            component.set("v.columnsEnablementsAcquiring", [
               
                {label: $A.get('$Label.c.OB_CircuitsAcquiring'), fieldName: 'enablementName',type: 'text'},
                {label: $A.get('$Label.c.OB_MAINTENANCESTATUSFIELDLABEL'), fieldName: 'flag',type: 'text'},
                {label: $A.get('$Label.c.OB_ActivationDate'), fieldName: 'dataAcquiring',type: 'text'},
                ]);
            
            component.set("v.columnsEnablementsVas", [
            
                {label: $A.get('$Label.c.OB_Vas'), fieldName: 'enablementName',type: 'text'},
                {label: $A.get('$Label.c.OB_MAINTENANCESTATUSFIELDLABEL'), fieldName: 'flag',type: 'text'},
                {label: $A.get('$Label.c.OB_ActivationDate'), fieldName: 'dataVas',type: 'text'},
                ]);
    

                    // END simone.misani@accenture.com  add colum for dfeect Ri-34
    },
         /* simone.misani@accenture.con function for  view Enablements.
            RI-34
            03/05/2019
        */
    showEnablements : function(component, event, helper){
        var eventId = event.getParam('row').id;
		console.log('eventId showEnablements: ',eventId);
		var listToView=[];
		var action = component.get("c.getEnablements");
        action.setParams({
            "assetId": eventId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {				
				var res = response.getReturnValue();                
                var responseParsed= JSON.parse(res);				
                component.set("v.enablementsListToView",responseParsed.enablememntsList);	
                component.set("v.enablementsListToViewVas",responseParsed.enablememntsListVas);    		
				
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
                    console.log("****Unknown error");
                }
            }
        });
        
        $A.enqueueAction(action);
    },
})