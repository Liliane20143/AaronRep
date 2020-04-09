/**
 * Created by adrian.dlugolecki on 14.06.2019.
 */
({
    init : function(component, event, helper)
    {
        console.log('OB_LCP006_Maintenance_Titolari_Effettivi init start');
        let newContact = component.get( "v.newContact" );
        let oldContact = component.get( "v.oldContact" );
        oldContact = JSON.parse( JSON.stringify( oldContact ) );
        component.set( "v.newContact", oldContact );
        newContact = oldContact;
        let objectDataMap = {};
        objectDataMap.titolariEffettivoContact = newContact;
        component.set("v.objectDataMap",objectDataMap);
        helper.initHandler(component);
        component.set("v.postelComponentParamsContactAddress", helper.setAddressMappingContactAddress());
        component.set("v.postelComponentParamsAddressDocRelease", helper.setAddressMappingDocReleaseAddress());
        component.set("v.postelComponentParamsBirthAddress", helper.setAddressMappingBirthAddress());
        component.set("v.postelComponentParamsCitizenship", helper.setAddressMappingCitizenship());
        component.set("v.postelComponentParamsFiscalCode", helper.setAddressMappingFiscalCode());
    },

    saveHandler : function(component, event, helper)
    {
        let oldContactJSON = JSON.stringify(component.get("v.oldContact"));
        let newContactJSON = JSON.stringify(component.get("v.newContact"));

        if(oldContactJSON == newContactJSON)
        {
            helper.showToast( $A.get("$Label.c.OB_MAINTENANCE_ERROR") , $A.get("$Label.c.OB_MAINTENANCE_ERROR_NODATACHANGE"), 'error');
        }
        else
        {
            helper.saveLogic(component);
        }
    }
})