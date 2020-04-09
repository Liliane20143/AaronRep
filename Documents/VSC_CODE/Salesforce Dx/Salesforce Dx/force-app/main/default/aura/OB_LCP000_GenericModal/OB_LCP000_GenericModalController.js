({
    /**
     * @author Grzegorz Banach <grzegorz.banach@accenture.com>
     * @date 07/05/2019
     * @description The method handles Cancel button click
     * @task: NEXI-30
    **/
    clickCancel : function( component, event, helper )
    {
        helper.fireModalEvent( component, true );
    },

    /**
     * @author Grzegorz Banach <grzegorz.banach@accenture.com>
     * @date 07/05/2019
     * @description The method handles Save/Proceed button click
     * @task: NEXI-30
    **/
    clickSaveOrProceed : function( component, event, helper )
    {
        helper.fireModalEvent( component, false );
    }
})