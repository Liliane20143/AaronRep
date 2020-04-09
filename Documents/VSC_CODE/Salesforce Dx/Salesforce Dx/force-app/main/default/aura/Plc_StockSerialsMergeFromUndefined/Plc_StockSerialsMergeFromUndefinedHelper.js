/**
 * Created by dilorenzo on 22/01/2019.
 */
({
    /* Initialize a new data service record to save */
    initNewSS2: function(component, event) {
        component.find("childOrderRecordCreator").getNewRecord(
            "Bit2Shop__Stock_Serials2__c", // objectApiName
            component.get("v.newSS2Id"), // recordTypeId- childOrderRecordTypeId
            true, // skip cache?
            $A.getCallback(function() {
                var rec = component.get("v.otherModelToSearch");//newChildOrder
                //var error = component.get("v.newChildOrderError");
                //if(error || (rec === null)) {

                    //console.log("Error initializing record template: " + error);

                //}else {
                 //  alert("Record template initialized: " + rec.sObjectType);
                //}
            })
        );
    },
    /* Showing warning area function */
    showWarningArea: function(component) {
        component.set('v.propertiesMap.showWarningArea', true);
    },
    /* Hiding warning area function */
    hideWarningArea: function(component) {
        component.set('v.propertiesMap.showWarningArea', false);
    },
    showToast: function(title, message, type, mode) {
        /* show toast message
         * mode
         * sticky: it stays on screen until user action
         * dismissable: it disappears after some time automatically
         */
        var toastEvent = $A.get('e.force:showToast');
        toastEvent.setParams({
            'title': title,
            'message': message,
            'type': type,
            'mode': mode || 'dismissable',
            'duration': 5000
        });
        toastEvent.fire();
    },
/*
    upsertExpenseRadio : function(component,updRecord,newVal) {
        alert('HELPER: ' + updRecord + ' NEW VAL: ' + newVal);
        var action10 = component.get("c.saveNewSS2str");
        action10.setParams({
            recordToUpdate: updRecord,
            newModelVal: newVal
        });
     // if (callback) {'recordToUpdate': updRecord,
       //   action.setCallback(this, callback);
     // }
        $A.enqueueAction(action10);
    },
    upsertExpensePicklist : function(component,updRecord,newVal) {
        alert('HELPER' + updRecord);
            var action11 = component.get("c.saveNewSS2");
            action11.setParams({
                recordToUpdate: updRecord,
                newModelVal: newVal
        });
        // if (callback) {
        //   action.setCallback(this, callback);
        // }
        $A.enqueueAction(action11);
    },
*/
    retrieveRecords: function(component, helper) {

        var action99 = component.get('c.retrieveInfoStockSerial');
            action99.setParams({
                        stockSerialId: component.get('v.recordId')
            });

            action99.setCallback(this, function(response) {
                var result = response.getReturnValue();

                component.set('v.propertiesMap.stockSerial', result.stockSerial);
            });

            $A.enqueueAction(action99);
    },
    setAvailableOptions: function(component,helper,statusAvailableOptionsMap) {

        var statusOptions = [];

        /*Object
            .keys(statusAvailableOptionsMap)
            .forEach(function(key) {
                let newStatusOption = {};
                newStatusOption.value = key;
                newStatusOption.label = statusAvailableOptionsMap[key];
                statusOptions.push(newStatusOption);
            });
*/
        component.set('v.propertiesMap.statusOptions', statusOptions);
    },
    searchModelIndefiniti : function(component, helper, event) {

 //
  //   var compEvent = cmp.getEvent("updateEvent");
  //   compEvent.fire();

  /*      var updateFlag = true;
        console.log("updateFlag" + updateFlag);
        var appEvent = $A.get("e.c:updateFieldEvent");
        appEvent.setParams({
            updateFlag:updateFlag
        });
        appEvent.fire(); */
//
        var currentRecordId = component.get('v.recordId');
        var serialCodeInsert = component.get('v.serialCode');

        var currentSS2 = component.get('v.propertiesMap.stockSerial');

        var action1 = component.get('c.retrieveInfoStockSerialIndefiniti');
        action1.setParams({
            searchSerial: serialCodeInsert
        });

        action1.setCallback(this, function(res){
            if(component.isValid() && res.getState() === "SUCCESS") {

                var result = res.getReturnValue().stockSerialIndef;
                var serialCode8Char = serialCodeInsert.slice(-8);
                var model_Serial_Identic = false;

                if((!res.getReturnValue().error) && (res.getReturnValue().stockSerialIndef.Plc_Model__c === currentSS2.Plc_Model__c) && ((res.getReturnValue().stockSerialIndef.Plc_EncodedSerialNumber__c === serialCodeInsert) || (res.getReturnValue().stockSerialIndef.Plc_ManufacturerSerialNumber__c === serialCodeInsert) || (res.getReturnValue().stockSerialIndef.Plc_DllSerialNumber__c === serialCodeInsert) || (res.getReturnValue().stockSerialIndef.Plc_EncodedSerialNumber__c === serialCode8Char))){
                    model_Serial_Identic = true;
                    component.set('v.identicModelSerial', true);
                }

                //per test SS2 identici
                //model_Serial_Identic = true;
                //component.set('v.identicModelSerial', true);

                if((!res.getReturnValue().error) && (model_Serial_Identic === true)){
                    console.log('CONDIZIONE IDENTICI ' + model_Serial_Identic);
                    console.log('Automatic Saving');

                    component.set('v.StockSerialIndefiniti', result);
                    component.set('v.propertiesMap.stockSerialIndef', result);

                    this.hideWarningArea(component);

                    this.saveRadio(component, helper);
                }
                else if((!res.getReturnValue().error) && (model_Serial_Identic === false)){
                    console.log('CONDIZIONE NON IDENTICI');

                    this.hideWarningArea(component);

                    component.set('v.enableSearchArea', true);
                    component.set('v.valueRadioButtonIndefinito', result.Plc_Model__c);
                    component.set('v.StockSerialIndefiniti', result);
                    component.set('v.propertiesMap.stockSerialIndef', result);

                    console.log('Enable search area',component.get('v.enableSearchArea'));
                }else{
                    //component.set('v.showErrorModal', true);
                    this.showWarningArea(component);
                }

            }else if(component.isValid() && res.getState() === "INCOMPLETE") {
                console.log("Error: " + res.getError()[0].message);

            }else if(component.isValid() && res.getState() === "ERROR"){
                console.log("Sono qui Unknown error: "+res.getError()[0].message);

            }
        });
        $A.enqueueAction(action1);
    },
    updateMainSS2 : function(component, helper, event) {

         var action100 = component.get('c.updateMainSS2');

            action100.setParams({
                idSS2: component.get('v.propertiesMap').Id
            });

            action100.setCallback(this, function(res){
                if(component.isValid() && res.getState() === "SUCCESS") {
                    var result = res.getReturnValue();

                    console.log('Result',result);

                }else if(component.isValid() && res.getState() === "INCOMPLETE") {
                    console.log("Error: " + res.getError()[0].message);

                }else if(component.isValid() && res.getState() === "ERROR"){
                    console.log("Sono qui Unknown error: "+res.getError()[0].message);

                }

                });
                $A.enqueueAction(action100);

    //updateWithCurrentModel
    },
    updateIndispSS2 : function(component, helper, event) {

         var action101 = component.get('c.updateIndispSS2');

            action101.setParams({
                idSS2: component.get('v.StockSerialIndefiniti').Id
            });

            action101.setCallback(this, function(res){
                if(component.isValid() && res.getState() === "SUCCESS") {
                    var result = res.getReturnValue();

                    console.log('Result',result);

                }else if(component.isValid() && res.getState() === "INCOMPLETE") {
                    console.log("Error: " + res.getError()[0].message);

                }else if(component.isValid() && res.getState() === "ERROR"){
                    console.log("Sono qui Unknown error: "+res.getError()[0].message);

                }

            });
            $A.enqueueAction(action101);
        },
    saveRadio : function(component, helper){
        //propertiesMap selected
        var newVal = '';
        var isFlaggedRadioButton = component.get('v.flagRadioButton');
        var isPicklistUsed = false;

        if(component.get('v.otherModelToSearch.Id') == ''){
            isPicklistUsed = false;
        }
        else if(!component.get('v.otherModelToSearch.Id') == ''){
             isPicklistUsed = true;
             //component.set('v.radioToAble', false);
             //component.set('v.radioToAbleIndef', false);
        }

         if((!component.get('v.radioToAbleIndef')) && (component.get('v.radioToAble')) && (isPicklistUsed === false)){
             //component.set('v.radioToAbleIndef', false);
            console.log('Radio Init selected');
            helper.showSpinner(component, 'main-spinner');

                 var action100 = component.get('c.updateMainSS2');

                 action100.setParams({
                     ss2: component.get('v.propertiesMap').stockSerial,
                     ss2Indef: component.get('v.StockSerialIndefiniti')
                 });

                 action100.setCallback(this, function(res){
                    helper.hideSpinner(component, 'main-spinner');
                     if(component.isValid() && res.getState() === "SUCCESS") {
                         var result = res.getReturnValue();

                         console.log('Result',result);

                         this.redirectToObject(component.get('v.recordId'));
                         $A.get("e.force:refreshView").fire();
                         window.location.href = '/'+ component.get('v.recordId');

                     }else if(component.isValid() && res.getState() === "INCOMPLETE") {
                         console.log("Error: " + res.getError()[0].message);

                     }else if(component.isValid() && res.getState() === "ERROR"){
                         console.log("Sono qui Unknown error: "+res.getError()[0].message);
                     }
                 });
                 $A.enqueueAction(action100);
                 //helper.updateMainSS2(component);
         }
         else if((component.get('v.radioToAbleIndef'))&& (!component.get('v.radioToAble')) && (isPicklistUsed === false)){
             //{!v.StockSerialIndefiniti.Plc_Model__c} selected
             console.log('Radio Undef selected');
             helper.showSpinner(component, 'main-spinner');

                 var action101 = component.get('c.updateIndispSS2');

                 action101.setParams({
                     ss2: component.get('v.propertiesMap').stockSerial,
                     //ss2: component.get('v.propertiesMap').stockSerialIndef
                     ss2Indef: component.get('v.StockSerialIndefiniti')
                 });

                 action101.setCallback(this, function(res){
                    helper.hideSpinner(component, 'main-spinner');
                     if(component.isValid() && res.getState() === "SUCCESS") {
                        var result = res.getReturnValue();

                        console.log('Result',result);

                        this.redirectToObject(component.get('v.recordId'));
                        $A.get("e.force:refreshView").fire();
                        window.location.href = '/'+ component.get('v.recordId');

                     }else if(component.isValid() && res.getState() === "INCOMPLETE") {
                         console.log("Error: " + res.getError()[0].message);

                     }else if(component.isValid() && res.getState() === "ERROR"){
                         console.log("Sono qui Unknown error: "+res.getError()[0].message);
                     }

                     });
                     $A.enqueueAction(action101);
                 //helper.updateIndispSS2(component);
         }
         else if((!component.get('v.radioToAbleIndef')) && (!component.get('v.radioToAble')) && (isPicklistUsed === true)){
         //{!v.StockSerialIndefiniti.Plc_Model__c} selected
         console.log('Lookup selected');
         helper.showSpinner(component, 'main-spinner');
/*
              var action103 = component.get('c.updateIndispSS2');

              action103.setParams({
                  ss2: component.get('v.propertiesMap').stockSerial,
                  ss2Indef: component.get('v.otherModelToSearch')
              });
              */
              var action103 = component.get('c.updateIndispLkSS2');

              action103.setParams({
                ss2: component.get('v.propertiesMap').stockSerial,
                ss2Indef: component.get('v.StockSerialIndefiniti'),
                modelLookup: component.get('v.otherModelToSearch')
              });

              action103.setCallback(this, function(res){
                helper.hideSpinner(component, 'main-spinner');
                  if(component.isValid() && res.getState() === "SUCCESS") {
                      var result = res.getReturnValue();

                      console.log('Result',result);

                      this.redirectToObject(component.get('v.recordId'));
                      $A.get("e.force:refreshView").fire();
                      window.location.href = '/'+ component.get('v.recordId');

                  }else if(component.isValid() && res.getState() === "INCOMPLETE") {
                      console.log("Error: " + res.getError()[0].message);

                  }else if(component.isValid() && res.getState() === "ERROR"){
                      console.log("Sono qui Unknown error: "+res.getError()[0].message);

                  }

                  });
                  $A.enqueueAction(action103);
              //helper.updateIndispSS2(component);
         }
        else if((!component.get('v.radioToAbleIndef')) && (!component.get('v.radioToAble')) && (component.get('v.identicModelSerial')) && (isPicklistUsed === false)){
             console.log('Identic Model e serial Auto saving');
             //component.set('v.radioToAbleIndef', false);
             helper.showSpinner(component, 'main-spinner');
             var action102 = component.get('c.updateMainSS2');

             action102.setParams({
                 ss2: component.get('v.propertiesMap').stockSerial,
                 ss2Indef: component.get('v.StockSerialIndefiniti')
             });

             action102.setCallback(this, function(res){
                helper.hideSpinner(component, 'main-spinner');
                 if(component.isValid() && res.getState() === "SUCCESS") {
                     var result = res.getReturnValue();

                     console.log('Result',result);

                     this.redirectToObject(component.get('v.recordId'));
                     $A.get("e.force:refreshView").fire();
                     window.location.href = '/'+ component.get('v.recordId');

                 }else if(component.isValid() && res.getState() === "INCOMPLETE") {
                     console.log("Error: " + res.getError()[0].message);

                 }else if(component.isValid() && res.getState() === "ERROR"){
                     console.log("Sono qui Unknown error: "+res.getError()[0].message);
                 }
             });


            var title = 'Success';
            var type = 'success';
            var mode = 'sticky';

            helper.showToast(title,$A.get('$Label.c.Plc_LightningComponentStockSerialsMergeFromUndefinedIdenticModelESerial'),type,mode);

            $A.enqueueAction(action102);
            //helper.updateMainSS2(component);
        }
        else if((!component.get('v.radioToAbleIndef')) && (!component.get('v.radioToAble')) && (!component.get('v.identicModelSerial')) && (!component.get('v.usePickList'))){
            console.log('ERROR');
            //Select at least a model

            var title = 'Error';
            var type = 'error';
            var mode = 'sticky';

            helper.showToast(title,$A.get('$Label.c.Plc_LightningComponentStockSerialsMergeFromUndefinedMessageSelectOneValue'),type,mode);
        }
         else if(((component.get('v.radioToAbleIndef')) || (component.get('v.radioToAble'))) && (isPicklistUsed === true)){
            console.log('ERROR radio e Lookup');
            //Select only one model

            var title = 'Error';
            var type = 'error';
            var mode = 'sticky';

            helper.showToast(title,$A.get('$Label.c.Plc_LightningComponentStockSerialsMergeFromUndefinedMessageSelectOnlyOneVal'),type,mode);
        }
        else{
            var title = 'Error';
            var type = 'error';
            var mode = 'sticky';

            helper.showToast(title,'Unknown Error',type,mode);
        }

    },
    /* Redirects to a given id object page*/
    redirectToObject: function(recordId){
        var navEvt = $A.get('e.force:navigateToSObject');
        navEvt.setParams({
          'recordId': recordId,
          'slideDevName': 'detail',
        });
        console.log('REDIRECT');
        navEvt.fire();
    },

    /* Gets from server a map that contains pairs api name/label. Used in order to get translations */
    retrieveTranslationsMap: function(component, helper) {
		var action = component.get('c.retrieveTranslationMap');
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === 'SUCCESS') {
                var result = response.getReturnValue();

                //Setting translation for stock serial fields
                component.set('v.translationMap.Id', result.Id);
                component.set('v.translationMap.Name', result.Name);
                component.set('v.translationMap.Plc_EncodedSerialNumber__c', result.Plc_EncodedSerialNumber__c);
                component.set('v.translationMap.Plc_ManufacturerSerialNumber__c', result.Plc_ManufacturerSerialNumber__c);
                component.set('v.translationMap.Plc_DllSerialNumber__c', result.Plc_DllSerialNumber__c);
                component.set('v.translationMap.Plc_DepreciationDuration__c', result.Plc_DepreciationDuration__c);
                component.set('v.translationMap.Plc_DepreciationPercentage__c', result.Plc_DepreciationPercentage__c);
                component.set('v.translationMap.Plc_DepreciationCompleted__c', result.Plc_DepreciationCompleted__c);
                component.set('v.translationMap.Plc_VoiceCode__c', result.Plc_VoiceCode__c);
                component.set('v.translationMap.Plc_Pin__c', result.Plc_Pin__c);
                component.set('v.translationMap.Plc_Puk1__c', result.Plc_Puk1__c);
                component.set('v.translationMap.Plc_Puk2__c', result.Plc_Puk2__c);
                component.set('v.translationMap.Plc_Note__c', result.Plc_Note__c);
                component.set('v.translationMap.Bit2Shop__Product_Stock_Id__c', result.Bit2Shop__Product_Stock_Id__c);
                component.set('v.translationMap.Bit2Shop__Shipment_Date__c', result.Bit2Shop__Shipment_Date__c);
                component.set('v.translationMap.Plc_FirstInstallationDate__c', result.Plc_FirstInstallationDate__c);
                component.set('v.translationMap.Plc_PurchaseDate__c', result.Plc_PurchaseDate__c);
                component.set('v.translationMap.Bit2Shop__Purchase_Price__c', result.Bit2Shop__Purchase_Price__c);
                component.set('v.translationMap.Plc_PurchaseWarrantyStartDate__c', result.Plc_PurchaseWarrantyStartDate__c);
                component.set('v.translationMap.Plc_PurchaseWarrantyEndDate__c', result.Plc_PurchaseWarrantyEndDate__c);
                component.set('v.translationMap.Plc_LastRepairCost__c', result.Plc_LastRepairCost__c);
                component.set('v.translationMap.Plc_RepairWarrantyStartDate__c', result.Plc_RepairWarrantyStartDate__c);
                component.set('v.translationMap.Plc_RepairWarrantyEndDate__c', result.Plc_RepairWarrantyEndDate__c);
                component.set('v.translationMap.Plc_RentalStartDate__c', result.Plc_RentalStartDate__c);
                component.set('v.translationMap.Plc_RentalEndDate__c', result.Plc_RentalEndDate__c);
                component.set('v.translationMap.Plc_PTSCode__c', result.Plc_PTSCode__c);
                component.set('v.translationMap.Plc_PcipedModel__c', result.Plc_PcipedModel__c);
                component.set('v.translationMap.Plc_PCIPEDLetterOfApproval__c', result.Plc_PCIPEDLetterOfApproval__c);
                component.set('v.translationMap.Plc_PcipedApprovalNumber__c', result.Plc_PcipedApprovalNumber__c);
                component.set('v.translationMap.Plc_PcipedVersion__c', result.Plc_PcipedVersion__c);
                component.set('v.translationMap.Plc_PcipedExpiryDate__c', result.Plc_PcipedExpiryDate__c);
                component.set('v.translationMap.Plc_Manufacturer__c', result.Plc_Manufacturer__c);
                component.set('v.translationMap.Bit2Shop__Warehouse_Id__c', result.Bit2Shop__Warehouse_Id__c);
                component.set('v.translationMap.Bit2Shop__Status__c', result.Bit2Shop__Status__c);
                component.set('v.translationMap.Plc_Status2__c', result.Plc_Status2__c);
            }
        });
        $A.enqueueAction(action);
    },
    /* Showing spinner function */
    showSpinner: function(component, spinnerName) {
        $A.util.removeClass(component.find(spinnerName), 'slds-hide');
    },
    /* Hiding loading spinner function */
    hideSpinner: function(component, spinnerName) {
        $A.util.addClass(component.find(spinnerName), 'slds-hide');
    },
})