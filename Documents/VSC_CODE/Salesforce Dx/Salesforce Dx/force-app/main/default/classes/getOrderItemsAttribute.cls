public with sharing class getOrderItemsAttribute
{

    /*******************************************************************************
	Purpose:  Method selects OrderItems and OrderItems Attributes with given Order Id
    Parameters: -
    Returns: List<NE__OrderItem__c

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         ?                       ?               ?               ?
	2.0         Joanna Mielczarek       25/04/2019      Updated         added IF statement to correct returning list
 	********************************************************************************/
    @AuraEnabled
    public static List<NE__OrderItem__c> getLineAttributes( String orderId )
    {
        List<NE__OrderItem__c> orderItems =
        [
                select id, Name, NE__ProdName__c,NE__OrderId__c,
                ( SELECT id, Name, NE__Value__c FROM NE__Order_Item_Attributes__r )
                FROM NE__OrderItem__c
                WHERE NE__OrderId__c = :orderId
        ];

        // R1F2_RP_000 <joanna.mielczarek@accenture.com> 25/04/2019 START
        if ( !orderItems.isEmpty( ) )
        {
            return orderItems;
        }
        return new List<NE__OrderItem__c>( );
        // R1F2_RP_000 <joanna.mielczarek@accenture.com> 25/04/2019 START
    }
}