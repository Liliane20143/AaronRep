({
    /*
    *	Author		:	Morittu Andrea
    *	Date		:	20-11-2019
    *	Task		:	EVO_PRODOB_480
    *	Description :   DoInit Component 
    */
    doInit_Helper : function(component, event) {
        let objDataMap = component.get('v.objectDataMap');
        console.log('OBJECT DATA MAP INSIDE EXECUTOR CHECKBOXES : ' + JSON.stringify(objDataMap));
    },
    
    /*
    *	Author		:	Morittu Andrea
    *	Date		:	20-11-2019
    *	Task		:	EVO_PRODOB_480
    *	Description	:   Grab value from checkboxes and store them into objectDataMap
    */
    onChangeCheckboxes_Helper : function(component, event) {
        try {
            let PEP = component.find('OB_PEP__c').get('v.checked');
            let skipCadastralCode = component.find('OB_SkipCadastralCodeCheck__c').get('v.checked');
            
            component.set('v.objectDataMap.legale_rappresentante.OB_PEP__c',PEP );
            component.set('v.objectDataMap.legale_rappresentante.OB_SkipCadastralCodeCheck__c', skipCadastralCode);
        } catch(e) {
            console.log('An error has occured : ' + e.message);
        }
    }
})