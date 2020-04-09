/**
 * Created by adrian.dlugolecki on 07.05.2019.
 */
({
    /**
    * @author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
    * @date 13/05/2019
    * @description Method executed on component init. Prepare table definition and search for related rac sia codes
    */
    init : function(component, event, helper)
    {
        component.set('v.tableColumns',
        [
            {label: $A.get("$Label.c.OB_Pos"), fieldName: 'pos', type: 'text'},
            {label: $A.get("$Label.c.OB_TerminalIdLabel"), fieldName: 'termId', type: 'text'},
            {label: "IBAN", fieldName: 'iban',type: 'text'},
            {label: $A.get("$Label.c.OB_AccountHolderLabel"),fieldName: 'intestata', type: 'text'},
            {label: $A.get("$Label.c.OB_MAINTENANCE_INSTALLATIONDATE"),fieldName: 'startDate', type: 'date'},
            {label: $A.get("$Label.c.OB_MAINTENANCESTATUSFIELDLABEL"),fieldName: 'status', type: 'text'}
        ]);
        if($A.util.isUndefinedOrNull(component.get("v.modifyServicePointId")) )
        {
            component.set("v.modifyServicePointId",component.get("v.recordId"));
            component.set("v.isBackVisible",false);
        }
        helper.searchRacSia(component);
        component.set("v.isSpinner",false);
    },

    backToSearch : function(component, event, helper)
    {
        helper.backToSearch(component);
    },

    searchRacSia : function (component, event, helper)
    {
       component.set("v.isSearchDone",false);
       helper.searchAsset(component); // NEXI-157 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 02/07/2019 changed method name
    },

    reRenderTable : function (component, event, helper)
    {
        helper.wrapAssetData(component,component.get("v.rawRacRelatedAssets")); // NEXI-157 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 02/07/2019 changed method and param name
    }
})