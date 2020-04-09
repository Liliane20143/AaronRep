/**
 * Created by adrian.dlugolecki on 23.05.2019.
 */
({
    doInit : function(component,event,helper)
    {
        if ( $A.util.isEmpty( component.get( "v.tableData" ) ) )
        {
            helper.makeInit(component);
        }
    }
})