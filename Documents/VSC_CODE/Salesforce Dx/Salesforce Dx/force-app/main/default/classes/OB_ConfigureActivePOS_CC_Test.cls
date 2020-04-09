@isTest
public class OB_ConfigureActivePOS_CC_Test
{

/*
    @   Author  :   Morittu Andrea
    @   Date    :   18-Jul-19
    @   Task    :   Covering Catalog Classes (Branch Name)
*/
    @isTest
    public static void getTerminalsId( )
    {
        // RETURN METHOD : 
        String idPOS;

        // RECORD TYPE ID:
        // PRODUCT RECORD TYPE:
        Id recTypeTerminaliProduct = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.POS_RT ).getRecordTypeId( );

        // ITEM RECORD TYPE
        Id recTypeTerminaliItem = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByDeveloperName( ).get( OB_UtilityConstants.POS_RT ).getRecordTypeId( );

        // MAIN ORDER HEADER
        NE__Order_Header__c orderHeader = OB_TestDataFactory.getOrderHeader( );
        insert orderHeader;

        // CONFIGURATION
        NE__Order__c orderTest = OB_TestDataFactory.getOrder( orderHeader );
        insert orderTest;

        // PRODUCT
        NE__Product__c productTest = OB_TestDataFactory.getProduct( );
        productTest.OB_Codice_sfdc__c = OB_UtilityCOnstants.M_POS;
        productTest.RecordTypeId = recTypeTerminaliProduct;
        insert productTest;

        // CONFIGURATIONITEMS
        List<NE__OrderItem__c> orderItemList = new List<NE__OrderItem__c>( );
        for ( Integer i = 0; i < 10; i++ )
        {
            NE__OrderItem__c orderItem = OB_TestDataFactory.getOrderItem( orderTest.Id );
            orderItem.NE__ProdId__c = productTest.Id;
            orderItem.RecordTypeId = recTypeTerminaliItem;
            orderItem.OB_TermId__c = 'test';
            if ( Math.mod( 2, 2 ) == 0 )
            {
                orderItem.NE__Action__c = 'Add';
            }
            else
            {
                orderItem.NE__Action__c = 'Remove';
            }
            orderItemList.add( orderItem );
        }
        insert orderItemList;
        idPOS = orderItemList.get( 0 ).Id;

        // RUN TEST
        Test.startTest( );
        // IF COVERAGE
        String returns = OB_ConfigureActivePOS_CC.getTerminalsId( idPOS );
        system.assertEquals( orderItemList.get( 0 ).OB_TermId__c, returns );//Roland Nieznanski <roland.nieznanski@accenture.com> 25/09/2019 add assertion
        // ELSE COVERAGE
        Test.stopTest( );
    }

/*******************************************************************************
    Purpose:  Check for return null
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0        Roland Nieznanski         25/09/2019      Created         Method
    ********************************************************************************/
    @isTest
    private static void getTerminalsIdNullTest( )
    {
        String NoPOS = null;
        String returnNull = OB_ConfigureActivePOS_CC.getTerminalsId( NoPOS );
        system.assertEquals( null, returnNull );
    }
    
/*
    @   Author  :   Morittu Andrea
    @   Date    :   18-Jul-19
    @   Task    :   Covering Catalog Classes (Branch Name)
*/
    @isTest
    public static void cancelOrderOperation_Test() {
        // RETURN METHOD : 
        Boolean returningBooleanMethod;
        
        // MAIN ORDER HEADER
        NE__Order_Header__c orderHeader = OB_TestDataFactory.getOrderHeader();
        insert orderHeader;
        
        // CONFIGURATION
        NE__Order__c orderTest = OB_TestDataFactory.getOrder(orderHeader);
        insert orderTest;
        String posId = orderTest.Id;
        
        // RUN TEST
        Test.startTest();
            // TRY BLOCK
           Boolean returns =  OB_ConfigureActivePOS_CC.cancelOrderOperation(posId);
        Test.stopTest();
        system.assert( returns );//Roland Nieznanski <roland.nieznanski@accenture.com> 25/09/2019 add assertion
        
    }
    
    
    /*******************************************************************************
    Purpose:  Check for exception
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0        Roland Nieznanski         25/09/2019      Created         Method
    ********************************************************************************/
    @isTest
    private static void cancelOrderOperationIncorrectIDTest( )
    {
        Test.startTest( );
        Boolean returns = OB_ConfigureActivePOS_CC.cancelOrderOperation( 'Test' );
        Test.stopTest( );
        system.assert( !returns );
    }
}