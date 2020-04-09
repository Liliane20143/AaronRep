/**
 * Created by joanna.mielczarek on 27.05.2019.
 */
({
    /**
    * @author Joanna Mielczarek
    * @date 29/05/2019
    * @description Method sets Boolean value to true and handle opening modal
    * @history 29/05/2019 <joanna.mielczarek@accenture.com> created
    **/
    openModalMCCL2: function( component, event, helper )
    {
        component.set( "v.level", "L2" );
        component.set( "v.isMCCModalOpen", true );
    },

    /**
    * @author Joanna Mielczarek
    * @date 29/05/2019
    * @description Method sets Boolean value to true and handle opening modal
    * @history 29/05/2019 <joanna.mielczarek@accenture.com> created
    **/
    openModalMCCL3: function( component, event, helper )
    {
        component.set( "v.level", "L3" );
        component.set( "v.isMCCModalOpen", true );
    },

    /**
    * @author Joanna Mielczarek
    * @date 29/05/2019
    * @description Method changes Boolean value depends to checking and unchecking checkbox
    * @history 29/05/2019 <joanna.mielczarek@accenture.com> created
    * @history 25/06/2019 <damian.krzyzaniak@accenture.com> added reseting of fields after dechecking checkbox
    **/
    writableMCC: function( component, event, helper )
    {
        if( component.find( "MCCCheck" ).get( "v.checked" ) )
        {
            component.set( "v.isMCCDisabled", false );
            component.set( "v.isChecked", true );
        }
        else
        {
            component.set( "v.isMCCDisabled", true );
            component.set( "v.isChecked", false );
            //NEXI-110 24.06.2019 damian.krzyzaniak@accenture.com START
            component.set( "v.MCCL2input",'');
            component.set( "v.MCCL3input",'');
            //NEXI-110 24.06.2019 damian.krzyzaniak@accenture.com STOP
        }
    }
})