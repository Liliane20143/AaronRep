({
    /**
     * @author Marlena Lukomska-Rogala <m.lukomska-rogala@accenture.com>
     * @date: 28/06/2019
     * @description: The method handles the checkFiscalCodeModal event
     * @params: component, event
     * @task: NEXI-124
    **/
     handleCheckFiscalCodeEvent : function( component, event )
        {
            let cancelButtonClicked = event.getParam( "isCancelButtonClicked" );
            if ( $A.util.isUndefinedOrNull( cancelButtonClicked ) || typeof cancelButtonClicked != 'boolean' )
            {
               return;
            }
            if ( cancelButtonClicked )
            {
                component.set("v.isOpen", false);
            }
            else
            {
                $A.get('e.force:refreshView').fire();
            }
     }
  })