/**
 * Created by grzegorz.banach on 03.06.2019.
 */
({
    /**
    * @author Joanna Mielczarek <joanna.mielczarek@accenture.com>
    * @date 22/06/2019
    * @task NEXI-59
    * @description Method close modal with form
    */
    closeModal : function ( component, event, helper )
    {
        component.set( "v.showTEmodal", false );
        console.log( 'Close modal : created contact has the same fiscal code' );
    }
})