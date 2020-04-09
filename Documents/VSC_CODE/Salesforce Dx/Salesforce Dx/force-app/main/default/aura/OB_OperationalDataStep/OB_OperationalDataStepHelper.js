/**
 * Created by Joanna Mielczarek <joanna.mielczarek@accenture.com> on 07.05.2019.
 */
({
    /**
    *@author Joanna Mielczarek <joanna.mielczarek@accenture.com>
    *@date 07/05/2019
    *@description Method calls 'setOrderStatusDraftIncompleteOrder' from 'OB_OperationalDataStep_CC'
    *@history 07/05/2019 Method created
    */
    makeInit: function( component )
    {
        let objectDataMap = component.get( "v.objectDataMap" );
        let action = component.get( "c.setOrderStatusDraftIncompleteOrder" );
        action.setParam( "data", objectDataMap );
        action.setCallback( this, function( response ) {
            if ( response.getState( ) === "SUCCESS" )
            {
                console.log( "Nexi/Bank Order Status was updated." );
            }
            else
            {
                let errors = response.getError();
                if ( errors && errors[0].message )
                {
                    console.log( "Exception during update Nexi/Bank Order Status: " + errors[0].message );
                }
            }
        });
        $A.enqueueAction( action );
    }
})