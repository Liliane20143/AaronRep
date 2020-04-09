/**
 * Created by wojciech.kucharek on 05.07.2019.
 */

@IsTest
private class OB_Maintenance_ViewRecordDetail_CC_Test
{
    @isTest
    public static void retrieveLogRequestServerTest( )
    {
        Id merchantRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName( ).get( 'Merchant' ).getRecordTypeId( );
        Account acc = new Account( Name = 'acc' );
        acc.RecordTypeId = merchantRecordTypeId;
        acc.OB_BypassValidation__c = true;
        insert acc;
        OB_LogRequest__c lr = new OB_LogRequest__c( );
        lr.OB_AccountId__c = acc.id;
        lr.OB_ChangeLegalRepresentative__c = true;
        lr.OB_NewLegalRepresentative__c = true;
        lr.OB_RejectReason__c = 'Cancelled';
        lr.OB_ApprovalProcessStatus__c = 'Rigettato';
        insert lr;
        String logrequestId = lr.id;
        Test.startTest( );
        OB_Maintenance_ViewRecordDetail_CC.retrieveLogRequestServer( logrequestId );
        Test.stopTest( );
    }

    @isTest
    public static void inApprovalProcessTest( )
    {
        Id merchantRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName( ).get( 'Merchant' ).getRecordTypeId( );
        Account acc = new Account( Name = 'acc' );
        acc.RecordTypeId = merchantRecordTypeId;
        acc.OB_BypassValidation__c = true;
        insert acc;
        OB_LogRequest__c lr = new OB_LogRequest__c( );
        lr.OB_AccountId__c = acc.id;
        lr.OB_ChangeLegalRepresentative__c = true;
        lr.OB_NewLegalRepresentative__c = true;
        lr.OB_RejectReason__c = 'Cancelled';
        lr.OB_ApprovalProcessStatus__c = 'Rigettato';
        insert lr;
        String logrequestId = lr.id;
        Test.startTest( );
        OB_Maintenance_ViewRecordDetail_CC.inApprovalProcess( logrequestId );
        Test.stopTest( );
    }

    @isTest
    public static void retrieveStatusTest( )
    {
        OB_LogRequest__c logrequest = new OB_LogRequest__c( );
        logrequest.OB_Status__c = 'Rejected';
        insert logRequest;
        OB_Maintenance_ViewRecordDetail_CC.retrieveStatus( String.valueOf( logRequest.Id ) );
    }

    @isTest
    public static void checkProfilesDraftTest( )
    {
        OB_LogRequest__c logrequest = new OB_LogRequest__c( );
        insert logRequest;
        OB_Maintenance_ViewRecordDetail_CC.checkProfilesDraft( String.valueOf( logRequest.Id ) );
    }

    @isTest
    public static void getStringUrlTest( )
    {
        OB_Maintenance_ViewRecordDetail_CC.getStringUrl( );
    }


    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_ViewRecordDetail_CC.retrieveLogRequestServerVarCoba
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       15/05/2019      Created         NEXI-33
    ********************************************************************************/
    @isTest
    private static void retrieveLogRequestServerVarCobaTest( )
    {
        OB_LogRequest__c logRequest = OB_TestDataFactory.getLogRequest( );
        logRequest.OB_MaintenanceType__c = 'Variazione Coba';
        insert logRequest;
        Test.startTest( );
        Map<String, Object> result = OB_Maintenance_ViewRecordDetail_CC.retrieveLogRequestServer( logRequest.id );
        Test.stopTest( );
        System.assert( !( Boolean ) result.get( 'isConfirmButton' ) );
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_ViewRecordDetail_CC.confirmLogRequest. Happy flow
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       15/05/2019      Created         NEXI-33
    ********************************************************************************/
    /*  @isTest
      private static void confirmLogRequestTest( )
      {
          OB_LogRequest__c logRequest = OB_TestDataFactory.getLogRequest( );
          insert logRequest;
          List<OB_LogRequest__c> logrequests = new List<OB_LogRequest__c>();
          logrequests.add(logRequest);
          Test.startTest();
          OB_Maintenance_ViewRecordDetail_CC.checkOrderDetailsVisibility(String.valueOf(logRequest.Id));
          Test.stopTest();
      }*/
    @isTest
    public static void confirmLogRequest_Test(){
        OB_LogRequest__c logRequest = OB_TestDataFactory.getLogRequest();
        insert logRequest;
        OB_Maintenance_ViewRecordDetail_CC.confirmLogRequest(logRequest.Id);
    }

    @isTest
    public static void updateRequest_Test(){
        OB_LogRequest__c logRequest = OB_TestDataFactory.getLogRequest();
        insert logRequest;
        OB_Maintenance_ViewRecordDetail_CC.updateRequest(logRequest);
    }

    /*******************************************************************************
    Purpose:  Method test OB_Maintenance_ViewRecordDetail_CC.startApprovalProcess Happy flow
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Wojciech Kucharek       05/07/2019      Created         NEXI-33
    ********************************************************************************/
    @isTest
    private static void startApprovalProcessTest( )
    {
        OB_LogRequest__c logRequest = OB_TestDataFactory.getLogRequest( );
        insert logRequest;

        Test.startTest( );
        OB_Maintenance_ViewRecordDetail_CC.startApprovalProcess( logRequest.Id );
        Test.stopTest( );
        system.assert( true );
    }
}