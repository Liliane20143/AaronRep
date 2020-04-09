({ 
    /* Function used to create buttons configuration */ 
    createConfig: function() {
        var config = {
                Plc_SerialCensus: {
                    label: $A.get('$Label.c.Plc_SerialsCensus'),
                    url: '/lightning/cmp/c__Plc_StockSerialsImportUpload',
                    customPermission: 'Plc_SerialsCensus',
                    iconName: 'standard:record'
                },
                Plc_SerialsUpdate: {
                    label: $A.get('$Label.c.Plc_SerialsUpdate'),
                    url: '/lightning/cmp/c__Plc_StockSerialsImportUpload?c__additionalParameter={\"isEditMode\":\"true\"}',
                    customPermission: 'Plc_SerialsUpdate',
                    iconName: 'standard:record_update'
                },
                Plc_StocksManagement: {
                    label: $A.get('$Label.c.Plc_StocksManagement'),
                    url: '/lightning/cmp/c__Plc_StocksManagement',
                    customPermission: 'Plc_StocksManagement',
                    iconName: 'standard:people'
                },
                Plc_GoodsHandling: {
                    label: $A.get('$Label.c.Plc_GoodsHandling'),
                    url: '/lightning/cmp/c__Plc_GoodsHandling',
                    customPermission: 'Plc_GoodsHandling',
                    iconName: 'standard:partners'
                },
                Plc_RetrieveWorkOrderList: {
                    label: $A.get('$Label.c.Plc_AllAllSearchLabel')+' Work Order',
                    url: '/lightning/cmp/c__Plc_RetrieveWorkOrderList',
                    customPermission: 'Plc_RetrieveWorkOrderList',
                    iconName: 'standard:work_order'
                },
                Plc_StockOrderUploadCsvCmp: {
                    label: $A.get('$Label.c.Plc_AllAllPrintStockSerialsLabelFromCsv'),
                    url: '/lightning/cmp/c__Plc_StockOrderUploadCsvCmp',
                    customPermission: 'Plc_PrintStockSerialsLabelFromCsv',
                    iconName: 'standard:display_text'
                }
            };

        return config;
    },
    /* Shows a custom message defined by parameters */
    showToast: function(title, message, type, mode) {
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
    /* Showing spinner function */
    showSpinner: function(component, spinnerName) {
        $A.util.removeClass(component.find(spinnerName), 'slds-hide');
    },
    /* Hiding loading spinner function */
    hideSpinner: function(component, spinnerName) {
        $A.util.addClass(component.find(spinnerName), 'slds-hide');
    },
    /* Close modal function*/
    closeModal: function(component, modalName){ 
        var cmpTarget = component.find(modalName);
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
    },
    /* Hide modal function*/
    openModal: function(component, modalName) {
        var cmpTarget = component.find(modalName);
        var cmpBack = component.find('Modalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open'); 
    },
    /* Redirects to a given id object page*/
    redirectToObject: function(objectId) {
        var navEvt = $A.get('e.force:navigateToSObject');
        navEvt.setParams({
          'recordId': objectId,
          'slideDevName': 'detail',
        });
        navEvt.fire();
    },
    /* Gets from server a map that contains pairs api name/label. Used in order to get translations */
    retrieveTranslationsMap: function(component, helper) {
        var action = component.get('c.retrieveTranslationsMap');

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === 'SUCCESS') {
                var result = response.getReturnValue();
                //setting translations
                //......
            }
        });
        $A.enqueueAction(action);
    },
    /* Gets from server a map of config and context data */
    retrievePropertiesMap: function(component, helper) {

        var action = component.get("c.retrievePropertiesMap");

        helper.showSpinner(component, 'main-spinner');

        action.setParams({  
            configMap: helper.createConfig()
        });


        action.setCallback(this, function(response) {

            var result = response.getReturnValue();
            var state = response.getState();

            if (component.isValid() && state === "SUCCESS"  && !result.error) {
                var result = response.getReturnValue();
                
                helper.buildData(component, helper, result.configMap);

            }  else if (component.isValid() && (response.getState() === "ERROR" || result.error)){
                if (result) {
                    helper.showToast($A.get('$Label.c.Plc_AllAllError'), result.errorMsg, 'warning', 'sticky');
                    console.error(result.errorMsg);
                }
            }
            helper.hideSpinner(component, 'main-spinner');
        });
        $A.enqueueAction(action);    
    },
    /* Main function to build represented data */
    buildData: function(component, helper, configMap) {

        console.log(configMap);
        var itemsList = [];

        Object
            .keys(configMap)
            .forEach(function(key) {
                if (configMap[key].isVisible) {
                    let item = {}
                    item.label = configMap[key].label;
                    item.url = configMap[key].url;
                    item.iconName = configMap[key].iconName;
                    itemsList.push(item);
                }
            });

        console.log(itemsList);
        // var categoriesMap = {};
        // var tempLabels = {};

        // categoriesSet
        //     .forEach(function(category) {
        //         categoriesMap[category] = {};
        //         categoriesMap[category] = [];
        //     });

        // serviceLinkWrpList
        //     .forEach(function(serviceLink) {

        //         let customLabel = serviceLink.label
        //                           .substring(0, serviceLink.label.length - 1)
        //                           .replace('Label', 'Label.c')
        //                           .substr(2);

        //         let labelReference = $A.getReference(customLabel);
        //         component.set("v.propertiesMap.tempLabelAttr", labelReference);
        //         serviceLink.label = component.get('v.propertiesMap.tempLabelAttr');
        //         categoriesMap[serviceLink.category].push(serviceLink);
        //     });

        // Object
        //     .keys(categoriesMap)
        //     .forEach(function(key) {
        //         let category = {};
        //         category.label = key;
        //         category.serviceLinks = categoriesMap[key];

        //         itemsList.push(category);
        //     });

        component.set('v.itemsList', itemsList);
    }
})