({
    /**
     * @author Grzegorz Banach <grzegorz.banach@accenture.com>
     * @date 09/05/2019
     * @description method sets an attribute responsible for Document modal visibility
     * @Task: NEXI-30
     **/

    openDocumentInfoModal : function( component, event, helper )
    {
        component.set( "v.isDocumentInfoModalVisible", true );
    },

    handleDocumentInfoEvent : function( component, event, helper )
    {
        helper.handleDocumentInfoEvent( component, event )
    },

})