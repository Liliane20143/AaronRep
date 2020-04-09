/**
 * Created by adrian.dlugolecki on 09.07.2019.
 */
@isTest
public with sharing class OB_LCC008_ChangeCompanyData_Test
{
    /*******************************************************************************
    Purpose:  Method test OB_LCC008_ChangeCompanyData.retrieveDataForEditAccount method with proper data
    Parameters: -
    Returns: -
 
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       09/07/2019      Created         NEXI-178
    ********************************************************************************/
    @isTest
    private static void initComponentTest( )
    {
        Account aAccount = OB_TestDataFactory.getAccount( );
        insert aAccount;
        OB_LCC008_ChangeCompanyData.InitOutputWrapper result = OB_LCC008_ChangeCompanyData.retrieveDataForEditAccount( aAccount.id );
        System.assert( !result.isError );
    }

    /*******************************************************************************
    Purpose:  Method test OB_LCC008_ChangeCompanyData.retrieveDataForEditAccount method with bad data
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       09/07/2019      Created         NEXI-178
    ********************************************************************************/
    @isTest
    private static void initComponentBadDataTest( )
    {
        OB_LCC008_ChangeCompanyData.InitOutputWrapper result = OB_LCC008_ChangeCompanyData.retrieveDataForEditAccount( null );
        System.assert( result.isError );
    }

}