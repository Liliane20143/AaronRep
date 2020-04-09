({
    fireShowModalEvent : function(component, event) {
        component.set("v.spinner", true);
        var objectDataMap = component.get("v.objectDataMap");
        //console.log("objectDataMap after getSelectedrow" + JSON.stringify(objectDataMap));
        var lovs = component.get("v.lovs");
        if(lovs != null){
            component.set("v.lovs", []);
        }
        //   component.set("v.showModal", false);
        //   var showModal = component.get("v.showModal");
        
        var showModalEvent = component.getEvent("showModalEvent");
        //NEXI-122 Monika Kocot monika.kocot@accenture.com, 28/06/2019 Start fix bug with infinity loading spinner
        showModalEvent.setParams({'objectDataMap': objectDataMap });
         //NEXI-122 Monika Kocot monika.kocot@accenture.com, 28/06/2019 STOP
        showModalEvent.fire();
        // $A.util.addClass(modal, 'hideModal'); 
        var modal = component.find("modal");
        modal.destroy();
    },
    getLovs : function(component, event) {
        component.set("v.spinner", true);
        component.set("v.currentPage", 1);
        var lovs = component.get("v.lovs");
        if(lovs != null){
            component.set("v.lovs", []);
        }
        var type = component.get("v.type");
        var subType = component.get("v.subType");
        var level   = component.get("v.level");
       // alert(component.get('v.lookupLov'));
        //var lookupLov = component.get('v.objectDataMap.lookupLov');
        var lookupLov = component.get('v.lookupLov');
        console.log('lookupLov:  ' + lookupLov + ', level: ' + level);
        var input = component.get("v.input");
        var ascDesc = component.get("v.ascDesc");
        // console.log("input getLovs" + input);
        var mapOfSourceFieldTargetField = component.get("v.mapOfSourceFieldTargetField");
        var mapLabelColumns = component.get("v.mapLabelColumns");
        var orderBy = component.get("v.orderBy");
        var inputFieldForLike = component.get("v.inputFieldForLike");
        var subTypeField = component.get("v.subTypeField");
        //  console.log("subTypeField: " + subTypeField);
        var action = component.get("c.getLovsByType");
        action.setParams({type : type,
                          subType: subType,
                          subTypeField: subTypeField,
                          input : input,
                          mapOfSourceFieldTargetField : mapOfSourceFieldTargetField,
                          mapLabelColumns : mapLabelColumns,
                          orderBy: orderBy,
                          ascDesc: ascDesc,
                          inputFieldForLike: inputFieldForLike,
                          level:level,
                          lookupLov:lookupLov});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                //console.log("RESPONSE " + JSON.stringify(response.getReturnValue()));
                if(response.getReturnValue().length > 0){
                    component.set("v.lovs", response.getReturnValue()); 
                    component.set("v.messageIsEmpty", "");
                    this.sortData(component, component.get("v.sortedBy"), component.get("v.sortedDirection"));
                    
                }else{
                    component.set("v.messageIsEmpty", "nessun record trovato.");
                    component.set("v.lovs", response.getReturnValue()); 
                }
                component.set("v.spinner", false);
                console.log('RESPONSE LOVS:  ' + JSON.stringify(response.getReturnValue()));
            }
            else if (state === "INCOMPLETE") {
                // do something
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
    createColumns : function(component) {
        //mappa composta da FieldName e Label:
        var mapLabelColumns = component.get("v.mapLabelColumns");
        console.log('map columns ' + JSON.stringify(component.get('v.mapLabelColumns')));
        var columns = [];
        var level = component.get('v.level');
        console.log('level in modal Lookup: ' + component.get('v.level'));
        //ciclo for mappa
        for(var key in mapLabelColumns){
            columns.push({"label": mapLabelColumns[key],"fieldName": key, "type": "text", "sortable": true});
            //GIOVANNI SPINELLI 20/11/2018 - SHOW A SECOND COLUMN IN MCC LEVEL 3
            // if(level == 'L3'){
            //     columns.push({"label": mapLabelColumns[key],"fieldName": key, "type": "text", "sortable": true});
            // }
          //  console.log("nel ciclo for" + JSON.stringify(columns));
        }
        //end for
        /*
        component.set('v.mycolumns', [
            {label: 'Item Id', fieldName: 'Name', type: 'text'},
            {label: 'Item Name', fieldName: 'NE__Type__c', type: 'text'},
            {label: 'Prod Name', fieldName: 'Id', type: 'text'}
        ]);
        */
        component.set('v.mycolumns', columns);
      //  console.log("mycolumns" + JSON.stringify(component.get('v.mycolumns')));
        // this.createMap(component);
    },   
    
    /*
    createOptions : function(component){
        var mapLabelColumns = component.get("v.mapLabelColumns");
        var options = [];
        //ciclo for mappa
        for(var key in mapLabelColumns){
            if(mapLabelColumns.size == 1){
                component.set("v.orderBy", key);
                component.set("v.showOrderBy", true);
            }else{ 
                options.push({"value": key,"label": mapLabelColumns[key]});
                console.log("nel ciclo for delle options" + options);
                component.set('v.labelOptions', options);
            }
        }
    },
    createOptionsAscDesc: function(component) {
        var options = [
            { value: "Asc", label: "Asc" },
            { value: "Desc", label: "Desc" }
        ];
        component.set("v.ascDescOptions", options);
        
    },*/
    createMap : function(component) {
        var currentPage = component.get("v.currentPage");
        var recordToDisplay = component.get("v.recordToDisplay");
        var listaTOT = component.get("v.lovs");
      //  console.log("listaTOT results: " + JSON.stringify(listaTOT.Name));
       // console.log("listaTOT.length: " + listaTOT.length);
      //  console.log("divisione: " + listaTOT.length/recordToDisplay);
        var pages = Math.ceil(listaTOT.length/recordToDisplay);
        component.set("v.pages", pages);
        //numero pagine equivale al numero delle liste da creare
        var mappa = {};
        for(var i = 1; i<= pages; i++){
            var array = [];
            if(listaTOT.length < recordToDisplay){
                mappa[i] = listaTOT;
                component.set("v.currentList", mappa[currentPage]);
                
            }else{
                for(var j = 0; j < recordToDisplay; j++){
                    array.push(listaTOT[j]);
                    //shift rimuove il primo elemento dell'array
                    //listaTOT.shift();
                }
                component.set("v.currentList", array);
                
             //   console.log("currentList TO CHECK"+ JSON.stringify(component.get("v.currentList
                
                listaTOT=  listaTOT.slice(recordToDisplay);
             //   console.log("slice: " + JSON.stringify(listaTOT.slice(5)));
                mappa[i] = array;
              //  console.log("mappa: " + JSON.stringify(mappa));
                component.set("v.mappa", mappa);
                var mappa = component.get("v.mappa");
            }
        }
        
        this.createColumns(component);
    },
    sortData: function (component, fieldName, sortDirection) {
        var data = component.get("v.lovs");
        var reverse = sortDirection !== 'asc';
        data.sort(this.sortBy(fieldName, reverse))
        component.set("v.lovs", data);
        this.createMap(component); 
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

    getCabForApproverLevel : function(component, event){

        var CAB = component.get("v.cabStringValues");
        var ABI  = component.get("v.type");
        var subType = component.get("v.subType");
        var ABIvalue = component.get("v.ABIvalue");
        var input = component.get("v.input");
        console.log('CAB is: ' + CAB );
        console.log('ABI is: ' + ABI );
        console.log('subType is: '+ subType);
        console.log('ABIvalue is: ' + ABIvalue);
        console.log('input is: ' + input);


        var action = component.get("c.getCabForApproverLevelServer");
        action.setParams({
            ABI : ABI,
            CAB : CAB,
            subType: subType,
            ABIvalue : ABIvalue,
            input : input
         });

        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //Start antonio.vatrano 03/05/2019 R1F2-72
                if(response.getReturnValue()){
                    component.set("v.lovs", response.getReturnValue()); 
                    component.set("v.messageIsEmpty", "");
                    this.sortData(component, component.get("v.sortedBy"), component.get("v.sortedDirection"));
                    
                }else{
                    component.set("v.messageIsEmpty", "Nessun record trovato.");
                    component.set("v.lovs", []); 
                }
                //End antonio.vatrano 03/05/2019 R1F2-72
            }
            else if (state === "INCOMPLETE") {
                // do something
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

        // optionally set storable, abortable, background flag here

        // A client-side action could cause multiple events, 
        // which could trigger other events and 
        // other server-side action calls.
        // $A.enqueueAction adds the server-side action to the queue.
        $A.enqueueAction(action);
    }
    
    
})