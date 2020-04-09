/**
 * Created by adrian.dlugolecki on 24.05.2019.
 */
({
    /**
     *@author Joanna Mielczarek <joanna.mielczarek@accenture.com>
     *@date 18/06/2019
     *@description Method splits CreatedDate field on init
     *@history 18/06/2019 Method created
     */
    doInit : function( component, event, helper )
    {
        let createdDate = component.get( "v.tableRow" ).newContact.CreatedDate;
        if ( !$A.util.isEmpty( createdDate ) )
        {
            let dateArray = createdDate.split( 'T' );
            component.set( "v.createdDate", dateArray[0] );
        }
        helper.setDisabledFieldsForTitolareEfettivo( component );//NEXI-229 Grzegorz Banach <grzegorz.banach@accenture.com> 24/07/2019
    },

    /**
     *@author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
     *@date 28/05/2019
     *@description Method fire OB_LEV006_ContactDataTableEvent when clicked on modify button
     *@history 28/05/2019 Method created
               18/06/2019 Joanna Mielczarek <joanna.mielczarek@accenture.com>
               Changed logic of method to just setting Boolean value to control showing modal - modifying
     */
    modifyRow : function(component,event,helper)
    {
        component.set( "v.isModifying", true );
    },

    /**
     *@author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
     *@date 28/05/2019
     *@description Method fire OB_LEV006_ContactDataTableEvent when clicked on delete button
     *@history 28/05/2019 Method created
               13/06/2019 NEXI-60 Joanna Mielczarek <joanna.mielczarek@accenture.com>
               Changed logic of method to just setting Boolean value to control showing modal - removing
     */
    deleteRow : function(component,event,helper)
    {
        component.set( "v.isRemoving", true );
    },

    /**
     *@author Joanna Mielczarek <joanna.mielczarek@accenture.com>
     *@date 13/06/2019
     *@description Method is handler for OB_LEV000_ModalEvent & set params to OB_LEV006_ContactDataTableEvent
     *@history 13/06/2019 Method created - NEXI-60
     */
    modalEventHandler : function ( component, event, helper )
    {
        event.stopPropagation( );

        if ( !event.getParam( "isCancelButtonClicked" ) )
        {
            component.set( "v.tableRow.actionType", "Eliminato" );
            component.set( "v.tableRow.newContact.Id", "" );

            let actionEvent = component.getEvent( "rowTableActionEvent" );
            actionEvent.setParam( "actionType", "Eliminato" );
            actionEvent.setParam( "recordId", "" );
            actionEvent.fire( );
        }
        component.set( "v.isRemoving", false );
        component.set( "v.isModifying", false );
    },

    /**
     *@author Joanna Mielczarek <joanna.mielczarek@accenture.com>
     *@date 18/06/2019
     *@description Method is handler for OB_LEV006_TEContactEvent
     *@history 18/06/2019 Method created - NEXI-60
     */
    modifyingEventHandler: function ( component, event, helper )
    {
        component.set( "v.tableRow.actionType", event.getParam( "logRequestType" ) );
        component.set( "v.tableRow.newContact", JSON.parse( event.getParam( "inContactJson" ) ) );
        component.set( "v.isModifying", false );
    }
})