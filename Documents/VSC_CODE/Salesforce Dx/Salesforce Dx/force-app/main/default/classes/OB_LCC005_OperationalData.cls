/*****************************************************************
Name: OB_LCC005_OperationalData
Copyright © 2019 ITC
============================================================
Purpose:  Class handles init of 'OB_OperationalDataStep' component
Test class: OB_LCC005_OperationalData_Test

History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0         Joanna Mielczarek       07/05/2019      Created         NEXI-20_order_status_handleLogic
********************************************************************************/
global without sharing class OB_LCC005_OperationalData
{

    /*******************************************************************************
	Purpose:  Method calls method of setting Nexi and Bank Order Status from OB_Order_ChangeStatus
    Parameters: Map<String, Object> data
    Returns: -

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         Joanna Mielczarek       07/05/2019      Created         NEXI-20_order_status_handleLogic
	2.0         Joanna Mielczarek       05/06/2019      Modified        NEXI-99 added update of Order
 	********************************************************************************/
    @AuraEnabled
    global static void setOrderStatusDraftIncompleteOrder( Map<String, Object> data )
    {
        String orderToUpdateId;

        try
        {
            orderToUpdateId = String.valueOf( bit2flow.B2FUtils.getJSONValue( data, 'Configuration', 'Id' ) );
        }
        catch ( Exception eException )
        {
            System.debug( LoggingLevel.ERROR, 'Exception during deserialize Map : ' + eException );
        }

        List<NE__Order__c> ordersToUpdate = new List<NE__Order__c>( );
        for ( NE__Order__c loopOrder: [ SELECT Id, OB_FulfilmentStatus__c FROM NE__Order__c WHERE Id = :orderToUpdateId ] )
        {
            ordersToUpdate.add( OB_Order_ChangeStatus.setOrderStatusDraftIncompleteOrder( loopOrder, true, false, false ) );
        }

        OB_Order_ChangeStatus.updateOrdersStatus( ordersToUpdate );
    }
}