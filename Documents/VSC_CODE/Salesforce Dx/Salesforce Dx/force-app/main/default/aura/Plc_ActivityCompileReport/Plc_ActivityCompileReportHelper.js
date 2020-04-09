/**
 * Created by dilorenzo on 01/02/2019.
 */
({
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
    retrieveRecords: function(component, helper) {
        helper.showSpinner(component, 'main-spinner');

        var action99 = component.get('c.retrieveInfoStockSerial');
            action99.setParams({
                stockSerialId: component.get('v.recordId')
            });

            action99.setCallback(this, function(response) {
                var result = response.getReturnValue();
                component.set('v.propertiesMap.stockSerial', result.stockSerial);
                component.set('v.propertiesMap.StockSerialName', result.StockSerialName);
                component.set('v.propertiesMap.ActivityName', result.ActivityName);
                helper.hideSpinner(component, 'main-spinner');
            });
            helper.setAvailableOptions(component,helper);

            $A.enqueueAction(action99);
    },
    /* Sets available options for Stock Serial 2 picklists */
    setAvailableOptions: function(component,helper) {
        var action2 = component.get('c.picklistValuesStatus');

        action2.setCallback(this, function(res) {
            if(component.isValid() && res.getState() === "SUCCESS") {
                var result = res.getReturnValue();


                var itemsStatus = [];
                Object
                .keys(result.statusAvailableOptionsMap)
                .forEach(function(key) {
                    let newStatusOption = {};
                    newStatusOption.value = key;
                    newStatusOption.label = result.statusAvailableOptionsMap[key];
                    itemsStatus.push(newStatusOption);
                });
                component.set("v.optionsStatusPk", itemsStatus);

             }else if(component.isValid() && res.getState() === "INCOMPLETE") {
                 console.log("Error: " + res.getError()[0].message);

             }else if(component.isValid() && res.getState() === "ERROR"){
                 console.log("Unknown error: "+res.getError()[0].message);
             }
        });

        var action3 = component.get('c.picklistValuesTag');//picklistValuesTag

        action3.setCallback(this, function(res) {
            if(component.isValid() && res.getState() === "SUCCESS") {
                var result = res.getReturnValue();

                var itemsTag = [];
                Object
                .keys(result.tagAvailableOptionsMap)
                .forEach(function(key) {
                    let newStatusOption = {};
                    newStatusOption.value = key;
                    newStatusOption.label = result.tagAvailableOptionsMap[key];
                    itemsTag.push(newStatusOption);
                });
                component.set("v.optionsTagPk", itemsTag);

             }else if(component.isValid() && res.getState() === "INCOMPLETE") {
                 console.log("Error: " + res.getError()[0].message);

             }else if(component.isValid() && res.getState() === "ERROR"){
                 console.log("Unknown error: "+res.getError()[0].message);
             }
        });

        $A.enqueueAction(action2);
        $A.enqueueAction(action3);
    },
    handleStatusSelected: function (component, event) {
        var selectedOptionValue = component.get('v.selectedStatus');

        component.set('v.enableSaveArea',false);

        //get CS for status
        var actionTag = component.get('c.getCS4TagLk');
        actionTag.setCallback(this, function(response){
            if(component.isValid() && response !== null && response.getState() == 'SUCCESS'){
                //saving custom setting to attribute
                component.set('v.statusSS4Tag', response.getReturnValue());

                this.handleTagPk(component, event);

                console.debug('STATUS SELECTED: ' + component.get('v.selectedStatus'));//StatusSelected
                console.debug('STATUS 4 TAG: ' + component.get('v.statusSS4Tag'));//tempCS4Tag
            }
            else if(component.isValid() && res.getState() === "INCOMPLETE") {
                console.log("Error: " + res.getError()[0].message);

            }else if(component.isValid() && res.getState() === "ERROR"){
                console.log("Unknown error: "+res.getError()[0].message);
            }
        });
        $A.enqueueAction(actionTag);
    },
    handleTagPk: function (component, event) {
        var selectedOptionValue = component.get('v.selectedTag');

        if(component.get('v.selectedStatus') == component.get('v.statusSS4Tag')){

            //abilito la picklist TAG
            var tempSelectedTag = component.get('v.selectedTag')

            component.set('v.enableTagArea',true);

            if(component.get('v.isTagSelected')){
               component.set('v.enableSaveArea',true);
            }
        }
        else{
            component.set('v.selectedTag', '');
            component.set('v.enableTagArea',false);
            component.set('v.enableSaveArea',true);
        }
    },
    handleTagSelected: function (component, event) {

        var selectedOptionValue = component.get('v.selectedTag');
    },
    statusValuePicklist: function(component) {
        var action2 = component.get('c.picklistValuesStatus');

        action2.setCallback(this, function(res) {
            if(component.isValid() && res.getState() === "SUCCESS") {
                var result = res.getReturnValue();

                var tempValuesMap = result;

             }else if(component.isValid() && res.getState() === "INCOMPLETE") {
                 console.log("Error: " + res.getError()[0].message);
             }else if(component.isValid() && res.getState() === "ERROR"){
                 console.log("Unknown error: "+res.getError()[0].message);
             }

        });

        var action3 = component.get('c.picklistValuesTag');

        action3.setCallback(this, function(res) {
            if(component.isValid() && res.getState() === "SUCCESS") {
                var result = res.getReturnValue();

                var tempValuesMapTag = result;
                console.log('Result: ',tempValuesMapTag);

             } else if(component.isValid() && res.getState() === "INCOMPLETE") {
                 console.log("Error: " + res.getError()[0].message);

             } else if(component.isValid() && res.getState() === "ERROR"){
                 console.log("Unknown error: "+res.getError()[0].message);
             }

        });

        $A.enqueueAction(action2);
        $A.enqueueAction(action3);
    },

   saveStatusSS2: function(component, helper) {
       helper.showSpinner(component, 'activity-spinner');
       var selectedOptionValue = component.get('v.selectedStatus');
       var selectedTagValue = component.get('v.selectedTag');

       //update status SS2
       if(selectedOptionValue == 'Available'){

           var action = component.get('c.updateSS2');

           action.setParams({
               ss2: component.get('v.propertiesMap').stockSerial,
               newStatus: component.get('v.selectedStatus'),
               valueTag: ''
           });
           action.setCallback(this, function(response){
                var result = response.getReturnValue();
                var state = response.getState();

                if (component.isValid() && state === 'SUCCESS'  && !result.error) {

                    this.editStatusActivity(component,'AUTO', helper);

                    } else if (component.isValid() && 
                           (response.getState() === 'ERROR' || result.error)){
                    if(result) {
                        helper.showToast('', result.errorMsg, 'warning', 'sticky');
                    }
                }

                //In this case before applying redirect logic 
                //the event is triggered to drive external actions
                if (component.get('v.closeModal')) {
                    helper.fireEvent();
                }
                //
                helper.redirectToObject(component, component.get("v.recordId"));

           });
           $A.enqueueAction(action);
       }
       else if(selectedOptionValue == component.get('v.statusSS4Tag')){

           var action = component.get('c.updateSS2');

           action.setParams({
               ss2: component.get('v.propertiesMap').stockSerial,
               newStatus: component.get('v.selectedStatus'),
               valueTag: component.get('v.selectedTag')
           });

           action.setCallback(this, function(response){
                var result = response.getReturnValue();
                var state = response.getState();
                if (component.isValid() && state === 'SUCCESS'  && !result.error) {
                    this.editStatusActivity(component,'MAN', helper);
                    // this.editStatusActivity(component,'AUTO', helper);

                } else if (component.isValid() && 
                           (response.getState() === 'ERROR' || result.error)){
                    if(result) {
                        helper.showToast('', result.errorMsg, 'warning', 'sticky');
                    }
                }

                //In this case before applying redirect logic 
                //the event is triggered to drive external actions
                // if (component.get('v.closeModal')) {
                //     helper.fireEvent();
                // }
                //
                // helper.redirectToObject(component, component.get("v.recordId"));
           });

           $A.enqueueAction(action);
       } else {
            this.editStatusActivity(component,'MAN', helper);
       }
   },

    /* Redirects to a given id object page*/
    redirectToObject: function(component, recordId){

        if (!component.get('v.closeModal')) {
            var navEvt = $A.get('e.force:navigateToSObject');
            navEvt.setParams({
              'recordId': recordId,
              'slideDevName': 'detail',
            });
            navEvt.fire();
        } else {
            component.set('v.hideComponent', true);
        }
    },
    /* Redirects to a given id object page*/
    redirectToFillReport: function(component,recordId,ltgComponentName){

        component.find('navService').navigate({
            type: 'standard__component',
            attributes: {
                componentName: ltgComponentName
            },
            state: {
                "c__recordId": component.get('v.recordId')
            }
        });
    },
    editActivityPClick: function(component, helper){
        helper.showRecordEdit(component, helper);
    },
    showRecordEdit: function(component, helper){
        component.set('v.showActivityEdit', true);
    },
    editStatusActivity: function(component, operation, helper){
        var action = component.get('c.lastActivityPClickCreated');

        action.setParams({
            stockSerialId: component.get('v.recordId'),
            newStatusSelected: component.get('v.selectedStatus')
        });
        
        action.setCallback(this, function(response){

            var result = response.getReturnValue();
            var state = response.getState();

            if (component.isValid() && state === 'SUCCESS'  && !result.error) {

                component.set('v.activityId', result.activityId);

                if(operation == 'MAN'){
                    this.editActivityPClick(component, helper);
                } else {
                   helper.showToast('', $A.get('$Label.c.Plc_LightningComponentStockSerialUpdateUpdatedSerialSuccessMessage'), 'success');
                }

            } else if (component.isValid() && 
                       (response.getState() === 'ERROR' || result.error)){
                if(result) {
                    helper.showToast('', result.errorMsg, 'warning', 'sticky');
                }
            }
        });
        $A.enqueueAction(action);
    },
    fireEvent: function(component, helper) {
        var evt = $A.get("e.c:Plc_ActivityCompileReportEvt");
        evt.fire();
    }
})