({
    /**
    *@author Grzegorz Banach <grzegorz.banach@accenture.com>
    *@date 23/07/2019
    *@task NEXI-229
    *@description Method sets the fields that should be disabled during the edit of Executor
    *@history 23/07/2019 Method created
    */
    setDisabledFieldsForTitolareEfettivo : function( component )
    {
        let disabledFields = {
            FirstName           : true,
            LastName            : true,
            OB_Fiscal_Code__c   : true,
            OB_Birth_Date__c    : true
        };
        component.set( "v.disabledFields", disabledFields );
    },
})