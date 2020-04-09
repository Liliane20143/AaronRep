({
    /**
    *@author Joanna Mielczarek <joanna.mielczarek@accenture.com>
    *@task NEXI-286
    *@date 06/09/2019
    *@description Method sets fields for lightning:recordForm
    */
	doInit : function(component, event, helper)
	{
	    component.set( "v.orderFields", [ 'NE__Order_Header__c' ] );
    },

    /**
    *@author Joanna Mielczarek <joanna.mielczarek@accenture.com>
    *@task NEXI-286
    *@date 06/09/2019
    *@description Method calls creating objectDataMap
    */
    loadDocuments: function( component, event, helper )
    {
        //Start antonio.vatrano 28/09/2019 r1f3-97
        helper.createObjectDataMap(component, event); 
        //End antonio.vatrano 28/09/2019 r1f3-97
    }
})