/**
 * Created by Joanna Mielczarek <joanna.mielczarek@accenture.com> on 27.05.2019.
 */
({
    /**
    * @author Joanna Mielczarek
    * @date 29/05/2019
    * @description Initial method
    * @history 29/05/2019 <joanna.mielczarek@accenture.com> created - NEXI-81
    **/
    doInit: function( component, event, helper )
    {
        component.set( "v.spinner", true );
        component.set( "v.searchInput", $A.get("$Label.c.OB_Search") + '...' );

        let mccL2 = component.get( "v.mccL2" );
        let mccL3 = component.get( "v.mccL3" );
        let mccL3response = component.get( "v.mccL3response" );
        let level = component.get( "v.level" );
        let mccL2input = component.get( "v.MCCL2input" );
        let mccL3input = component.get( "v.MCCL3input" );

        if ( !$A.util.isEmpty( mccL2input ) && $A.util.isEmpty( mccL3input )  )
        {
            if ( level == "L2" )
            {
                helper.getTabData( component, mccL2 );
            }
            else if ( level == "L3" )
            {
                helper.getTabData( component, mccL3response );
            }
        }
        else if ( $A.util.isEmpty( mccL2input ) && !$A.util.isEmpty( mccL3input ) )
        {
            if ( level == "L2" )
            {
                helper.getLov( component, event, "", "L2", "" );
            }
            else if ( level == "L3" )
            {
                helper.getTabData( component, mccL3 );
            }
        }
        else
        {
            if ( level === "L2" )
            {
                helper.getTabData( component, mccL2 );
            }
            else if ( level === "L3" )
            {
                helper.getTabData( component, mccL3 );
            }
        }
    },

    /**
    * @author Joanna Mielczarek
    * @date 29/05/2019
    * @description Method calls helper - handles closing modal
    * @history 29/05/2019 <joanna.mielczarek@accenture.com> created - NEXI-81
    **/
    closeModal: function( component, event, helper )
    {
        helper.close( component );
    },

    /**
    * @author Joanna Mielczarek
    * @date 29/05/2019
    * @description Method calls helper - handles pagination
    * @history 29/05/2019 <joanna.mielczarek@accenture.com> created - NEXI-81
    **/
    navigate: function( component, event, helper )
    {
        helper.changePage( component, event );
    },

    /**
    * @author Joanna Mielczarek
    * @date 29/05/2019
    * @description -
    * @history 29/05/2019 <joanna.mielczarek@accenture.com> created - NEXI-81
    **/
    searchLovs: function( component, event, helper )
    {
        helper.getLovFromSearch( component );
    },

    /**
    * @author Joanna Mielczarek
    * @date 29/05/2019
    * @description Method calls helper - handles setting value of selected row to input value
    * @history 29/05/2019 <joanna.mielczarek@accenture.com> created - NEXI-81
    **/
    getSelectedRow: function( component, event, helper )
    {
        helper.setSelectedRow( component, event );
    }
})