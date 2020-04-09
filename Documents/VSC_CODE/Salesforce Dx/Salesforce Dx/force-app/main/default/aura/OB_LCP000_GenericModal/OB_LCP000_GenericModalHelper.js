({
    /**
     * @author Grzegorz Banach <grzegorz.banach@accenture.com>
     * @date 07/05/2019
     * @description The method fires the modal event
     * @params Boolean isCancelBtnClicked - defines if Cancel Button has been clicked
     * @task: NEXI-30
    **/
    fireModalEvent : function( component, isCancelBtnClicked )
    {
        if ( $A.util.isUndefinedOrNull( isCancelBtnClicked ) )
        {
            return;
        }

        let modalEvent = component.getEvent( "modalEvent" );
        modalEvent.setParams({
           "isCancelButtonClicked" : isCancelBtnClicked
        });
        modalEvent.fire( );
    }
})