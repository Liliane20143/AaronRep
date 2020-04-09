/**
 * Created by dilorenzo on 01/02/2019.
 */
({
    doInit : function (component,event,helper) {
        if (!component.get('v.skipInit')) {
            if (!component.get('v.recordId')) {
                var pageRef = component.get("v.pageReference");
                component.set('v.recordId', pageRef.state.c__objectId);
            }
            helper.retrieveRecords(component, helper);
        }
    },
    handleSelectedStatus : function (component,event,helper) {
        helper.handleStatusSelected(component);
    },
    handleSelectedTag : function (component,event,helper) {
        helper.handleTagSelected(component);
    },
    saveStatus : function (component,event,helper) {
        helper.saveStatusSS2(component, helper);
    },
    backSS2Page : function(component, event, helper){
        helper.redirectToObject(component, component.get("v.recordId"));
    },
    isTagSelected : function (component, event, helper){
        component.set('v.isTagSelected', true);
        component.set('v.enableSaveArea',false);
        helper.handleTagPk(component, event);
        component.set('v.isTagSelected', false);
    },
    handleRecordUpdated: function (component, event, helper) {

        //In this case before applying redirect logic 
        //the event is triggered to drive external actions
        if (component.get('v.closeModal')) {
            helper.fireEvent();
        }
        //
        
        helper.showToast('', 'Activity has been correctly updated', 'success');
        helper.redirectToObject(component, component.get('v.activityId'));
        // $A.get('e.force:refreshView').fire();
    },
    handleRefreshComponent: function (component, event, helper) {
        component.set('v.hideComponent', false);
        component.set('v.showActivityEdit', false);
        component.set('v.selectedStatus', '');
        component.set('v.selectedTag', '');
        component.set('v.enableTagArea', false);
        helper.retrieveRecords(component, helper);
    },
    save : function(component, event, helper) {
        component.find("edit").get("e.recordSave").fire();
    }
})