/**
 * Created by liverani on 29/01/2019.
 */
({ 
    closeModalSuccess: function (component) {
        console.log(`closeModal --> start`);

        let modalType = component.get('v.modalType');

        if (modalType == 'success') {
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": component.get("v.objectId"),
                "slideDevName": "related"
            });
            navEvt.fire();
            //this.refreshData(component, 'initialize');
        } else {
            //component.set('v.showModal', false);
            window.history.go(-1);
            window.close();
        }

        console.log(`closeModal --> end`);
    },

    /* Showing spinner function */
    showSpinner: function(component, spinnerName) {
        $A.util.removeClass(component.find(spinnerName), 'slds-hide');
    },
    /* Hiding loading spinner function */
    hideSpinner: function(component, spinnerName) {
        $A.util.addClass(component.find(spinnerName), 'slds-hide');
    },
    /* Close modal function*/
    closeModal: function(component, helper, modalName) { 
        var cmpTarget = component.find(modalName);
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
    },
    /* Hide modal function*/
    openModal: function(component, helper, modalName) {
        var cmpTarget = component.find(modalName);
        var cmpBack = component.find('Modalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open'); 
    },


    // FB 20190627 NEXIPLC-589 [START]
    handleFilterResult: function(component, event, helper) {
        if (event.getParam('actionType') === 'hideModal') {
            //window.location.href="/lightning/n/wrts_prcgvr__ServiceCatalogLtg";
            var listId = [];
            window.history.go(-1);
            window.close();
        } else if (event.getParam('actionType') === 'sendCsvResults') {
            //component.set('v.showUploadCsvModal', false);

            let stockSerialFromCSV = event.getParam("searchResultsEvt").stockSerialFromCSV;
            var contactMap = event.getParam("searchResultsEvt").additionalData.contactMap;
            var serialIdToTechnicianMap = event.getParam("searchResultsEvt").additionalData.serialIdToTechnicianMap;

            let objectId, availableSelectedList, withdrawnSelectedList, availableList, withdrawnList, tabFocused;

            objectId = event.getParam("row") != null ? event.getParam("row").Id : '';

            availableSelectedList = component.get('v.availableSelectedList');
            withdrawnSelectedList = component.get('v.withdrawnSelectedList');
            availableList = component.get('v.availableList');
            withdrawnList = component.get('v.withdrawnList');
            tabFocused = component.get('v.tabFocused');

            var availableListMap = {};
            var withdrawnListMap = {};

            availableList.forEach(function(item, index) {
                item.index = index;
                availableListMap[item.Id] = item;
            });

            withdrawnList.forEach(function(item, index) {
                item.index = index;
                withdrawnListMap[item.Id] = item;
            });

            var availableSelectedListMap = {};
            var withdrawnSelectedListMap = {};

            availableSelectedList.forEach(function(item, index) {
                item.index = index;
                availableSelectedListMap[item.Id] = item;
            });

            withdrawnSelectedList.forEach(function(item, index) {
                item.index = index;
                withdrawnSelectedListMap[item.Id] = item;
            });

            var indexesToRemove = [];
            var listId = [];

            if (tabFocused == 'WithdrawnManagement') {

                stockSerialFromCSV.forEach(function(serial) {
                    var technicianName;
                    var technicianId;
                    
                    if (component.get("v.technicianSelected")) {
                        technicianId = component.get("v.technicianSelected").Id;
                        technicianName = component.get("v.technicianSelected").Name;
                    } else {
                     
                        
                        var recordId = serial.Id;
                        listId.push(serial.Id);
                    }
                    
                });

                console.log(availableSelectedList);
                component.set("v.idList", listId);

                component.set("v.availableSelectedList", availableSelectedList);

                indexesToRemove.sort(function(a, b) { return b - a; });
                for (var i = 0; i < indexesToRemove.length; i++) {
                    availableList.splice(indexesToRemove[i], 1);
                }
                component.set("v.availableList", availableList);

            } else if (tabFocused == 'AvailableManagement') {
                stockSerialFromCSV.forEach(function(serial) {
                    if (withdrawnListMap.hasOwnProperty(serial.Id)) {
                        withdrawnListMap[serial.Id].newTechnician = '';
                        withdrawnListMap[serial.Id].technicianName = '';
                        withdrawnListMap[serial.Id].selected = true;
                        withdrawnSelectedList.push(withdrawnListMap[serial.Id]);
                        indexesToRemove.push(withdrawnListMap[serial.Id].index);
                    } else {
                        if (!withdrawnSelectedListMap.hasOwnProperty(serial.Id)) {
                            var withdrawnSerial = {}
                            withdrawnSerial.newTechnician = '';
                            withdrawnSerial.technicianName = '';
                            withdrawnSerial.selected = true;
                            withdrawnSerial.Id = serial.Id;
                            withdrawnSerial.productSKU = serial.Plc_ProductSku__c;
                            withdrawnSerial.model = serial.Plc_Model__c;
                            withdrawnSerial.manufacturer = serial.Plc_Manufacturer__c;
                            withdrawnSerial.encodedSerialNumber = serial.Plc_EncodedSerialNumber__c;
                            withdrawnSerial.manufacturerSerialNumber = serial.Plc_ManufacturerSerialNumber__c;
                            withdrawnSerial.dllSerialNumber = serial.Plc_DllSerialNumber__c;
                            withdrawnSerial.status = serial.Bit2Shop__Status__c;
                            withdrawnSelectedList.push(withdrawnSerial);
                        }
                    }
                });

                component.set("v.withdrawnSelectedList", withdrawnSelectedList);

                indexesToRemove.sort(function(a, b) { return b - a; });
                for (var i = 0; i < indexesToRemove.length; i++) {
                    withdrawnList.splice(indexesToRemove[i], 1);
                }
                
                component.set("v.withdrawnList", withdrawnList);
     
            }
            component.set("v.idStringValue", listId.toString());
    
            var url1 = '/apex/Plc_StockSerialPrintLabel?id=' +listId[0] +'&idValueToCheck='+ listId.join(',');
            window.open(url1);
        }

    }
})