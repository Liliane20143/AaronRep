/*******************************************************************************
Purpose:  Class is test for OB_LCC000_Iban
Parameters: -
Returns: -

History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0         Adrian Dlugolecki       16/05/2019      Created         NEXI-33
********************************************************************************/
@isTest
public with sharing class OB_LCC000_Iban_Test
{
    /*******************************************************************************
    Purpose:  Method test componentInit method for admin user
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       13/05/2019      Created         NEXI-33
    ********************************************************************************/
    @isTest
    private static void componentInitTest( )
    {
        Id adminProfileId = OB_TestDataFactory.getSystemAdministratorProfile( ).Id;
        User systemAdminUser = [ SELECT Id FROM User WHERE ProfileId = :adminProfileId AND IsActive = true LIMIT 1 ];
        System.runAs( systemAdminUser )
        {
            System.assertEquals( true, OB_LCC000_Iban.componentInit( ) );
        }
    }

    /*******************************************************************************
    Purpose:  Class that contain all data created in core data method
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       13/05/2019      Created         NEXI-33
    1.1         Joanna Mielczarek       02/07/2019      Modified        NEXI-157 removed code associated with order item
    ********************************************************************************/
    private class DataWrapper
    {
        NE__Billing_Profile__c bBillingProfile;
        List<Asset> aAssets;
    }

    /*******************************************************************************
    Purpose:  Method create all required data
    Parameters: -
    Returns: DataWrapper

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       13/05/2019      Created         NEXI-33
    1.1         Joanna Mielczarek       02/07/2019      Modified        NEXI-157 removed code associated with order item
    ********************************************************************************/
    private static DataWrapper dataPreparation( )
    {
        OB_Integration_Configuration__c configuration = new OB_Integration_Configuration__c( );
        configuration.Name = 'DEV1';
        configuration.OB_CAsigned_name__c = '';
        configuration.OB_Client_ID__c = '631edaf5-d79a-43b8-8753-1dd64e8e210f';
        configuration.OB_Client_Secret__c = '1b332dad-0b9f-4745-87b1-01c4f5d1a292';
        configuration.OB_Domain__c = 'dev1';
        configuration.OB_Grant_Type__c = 'client_credentials';
        configuration.OB_Timeout_Continuation__c = '30';
        configuration.OB_Timestamp__c = '154392275757575';
        configuration.OB_Token_1__c = 'eyJ0eXAiOiJKV1QiLCJjdHkiOiJKV1QiLCJhbGciOiJSU0EtT0FFUCIsImVuYyI6IkExMjhDQkMtSFMyNTYifQ.Lgw6lqjmOIWy4dPRJmvIyKQBht9BlMDATRylNS1nJGeDePjmvfSxgeZbRzMnu89snNTh9b6SzxsPVUMsgDJ4klsUT81GuFU-sPe4u_zBss5y9jvXe8KwuU5zXDm7ElY_jYUqHKaWaLpCpkfq8UwGcJ_VL7TDJ7m7_eWAc67P';
        configuration.OB_Token_2__c = 'gPl_TKmk2ggdSoRnvQqC9FF2ywLGPtYj_6kKea5esiQlrfmmgtJUy2kcjeUS8YOtxw3X63q-ehEYEvPwQ_eZ9Mpr09DuKtlnOQCsOqBCle60zxNZpiWsyOmmT_Z4Diy2CjaN84u9uIUT-9cea4cdKgEMXTJpqhD5MGHaegt8m-DKKA.pnvamAYqa8kZ_uDcM2tAnQ.ox1twscMrBYAHxrob9WYAgzLu76VDEIKNT5xZgm53kkwmzRqs2lPkBp92';
        configuration.OB_Token_3__c = 'eTSNiQC0mvmjuu2JL0K3h5XLwTUgjHsBW90uAj8oBEnubLcjzb_bQLi5kBTuCmZmIYmVaO3PNl4-RTzWpKcmm6ICa53xxcU_N81mzi_QM9meGrPOOH9YsCJuwPDvacSDg6-XfgHUvqelmSSHKbJBR_-A12b8WjyrFFTHzthFQp36h2Q9kovuYAwukbDTaakh6OOtpxw7zzROB4hM5k2kLRkiNRBg6zslcYytx5tXHnZzZLsZO73cSsD8mG_iRmT';
        configuration.OB_Token_4__c = 'gkR6gY0FEswxXWrbVrGdVtLxNwNctoqwWtxBiDfzJgA30byG0N6TM4IBfnt6c58VtAlqOUpsB_Qm3TbDk4SF3NtGTxOuaT-TgRyWQkt5_Dq-XatnL9W_RtNcnuOruhImP-X6zc9m6lYDQ98TArn-4ADOWpZpB8vOx6-bDrOxr-OG5uQ6V5FymfSZI5K24QXxuiofZzvPfhJzsS_4fpNkCUGPGhQCr_KTmqMMqgmzfRcErX23RRh6uFo0Hm2ohXH';
        configuration.OB_Token_5__c = 'LZTWscVQ1OZl9qDSMA9vFJle-WWxoxhfXdQeD9ePZ41werIqxkf6nZp6sAm3wwKVnSnLVVBstnAXFOTbGfzzX8LQJOrfs8R1jvoOa9ylLpPoBQwdkkR9MeE7pjMAfbebqJh2BX8Xx-MzB5CVkyxPPNchDkidvPUA8UW4EkZQWvDLElUKhAChy9J5TyYkYWvbRgrx4fDgZ5QPZ00-afJYiK1uHfR7botM4xm5hR_04R3XdCCnCicShD2XLN6doaG';
        configuration.OB_Token_6__c = 't6Gzv14CU1S-rN9zA9FCO7PDBywCWfzR2G8tzud0rUq_JnBTBCJFfDu01ki82TR78Od1dbM0iLpVcNJMMEMTFi_Csh3tdXM_yPiE07009WrFiWl29goM8VPlQxbmLmsqg-bWCNAVKZqutqMavqnRjJN2q3EkJbGfut9Ghc0OUae4wXDwbwvh3dijaaftSuaY0xuCVuqbopiPfS4_y5VSztt5gai1rpW0NSO3_D1pSA9Ikvfl1DipbN1tk529J_0';
        configuration.OB_Token_7__c = 'NXsfUdKgf3ADwJPcNPb2pVafkyfqr-R4xn44bnaIuOyG5firipGOROVColCMkwyL0nRYSf40CYG.KpiIzQP0btC54uMB-gvw8Q';
        insert configuration;
        DataWrapper result = new DataWrapper( );

        Account aAccount = OB_TestDataFactory.getAccount( );
        insert aAccount;

        NE__Billing_Profile__c bilingProfileForAssets = OB_TestDataFactory.getBillingProfile( aAccount.Id );
        bilingProfileForAssets.OB_CountryCode__c = 'IT';
        bilingProfileForAssets.OB_EuroControlCode__c = '64';
        bilingProfileForAssets.OB_CINCode__c = 'G';
        bilingProfileForAssets.OB_ABICode__c = '03138';
        bilingProfileForAssets.OB_CABCode__c = '12300';
        bilingProfileForAssets.OB_Bank_Account_Number__c = '000241351661';
        insert bilingProfileForAssets;

        NE__Service_Point__c sServicePoint = OB_TestDataFactory.getServicePoint( );
        insert sServicePoint;

        Set<Id> assetsIds = new Set<Id>( );
        Asset aAsset = OB_TestDataFactory.getAsset( );
        aAsset.NE__Service_Point__c = sServicePoint.Id;
        aAsset.NE__BillingProf__c = bilingProfileForAssets.Id;
        aAsset.OB_RAC_SIA__c = '1';
        insert aAsset;
        assetsIds.add( aAsset.Id );

        NE__Billing_Profile__c bBilingProfile = OB_TestDataFactory.getBillingProfile( aAccount.Id );
        bBilingProfile.OB_CountryCode__c = 'IT';
        bBilingProfile.OB_EuroControlCode__c = '31';
        bBilingProfile.OB_CINCode__c = 'Q';
        bBilingProfile.OB_ABICode__c = '03138';
        bBilingProfile.OB_CABCode__c = '12300';
        bBilingProfile.OB_Bank_Account_Number__c = '000000000000';
        insert bBilingProfile;
        bBilingProfile =
        [
                SELECT OB_IBAN__c,
                        NE__Account__c
                FROM NE__Billing_Profile__c
                WHERE Id = :bBilingProfile.Id
        ];
        bBilingProfile.Id = null;
        result.bBillingProfile = bBilingProfile;
        result.aAssets = OB_LCC000_Iban.refreshAssets( assetsIds );
        return result;
    }

    /*******************************************************************************
    Purpose:  Method test saveCoBaAndIntegrate. Happy flow
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       13/05/2019      Created         NEXI-33
    ********************************************************************************/
    @isTest
    private static void saveCoBaAndIntegrateTest( )
    {
        DataWrapper coreData = dataPreparation( );
        Test.setMock( HttpCalloutMock.class, new MockGeneratorOB_UtilityCallingServices( ) );
        Test.startTest( );
        OB_LCC000_Iban.OB_CoBaOutputWrapper resultWrapper = OB_LCC000_Iban.saveCoBaAndIntegrate( coreData.bBillingProfile, coreData.aAssets );
        Test.stopTest( );
        System.assert( resultWrapper.result );
    }

    /*******************************************************************************
    Purpose:  Method test saveCoBaAndIntegrate. when iban codes are the same
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       15/05/2019      Created         NEXI-33
    ********************************************************************************/
    @isTest
    private static void saveCoBaAndIntegrateSameIbanTest( )
    {
        DataWrapper coreData = dataPreparation( );
        List<NE__Billing_Profile__c> bBillingProfiles = [ SELECT Id,NE__Account__c,OB_IBAN__c FROM NE__Billing_Profile__c ];
        for ( NE__Billing_Profile__c bBillingProfile : bBillingProfiles )
        {
            bBillingProfile.OB_CountryCode__c = 'IT';
            bBillingProfile.OB_EuroControlCode__c = '64';
            bBillingProfile.OB_CINCode__c = 'G';
            bBillingProfile.OB_ABICode__c = '03138';
            bBillingProfile.OB_CABCode__c = '12300';
            bBillingProfile.OB_Bank_Account_Number__c = '000241351661';
        }
        update bBillingProfiles;
        bBillingProfiles = [ SELECT Id,NE__Account__c,OB_IBAN__c FROM NE__Billing_Profile__c ];
        Test.startTest( );
        OB_LCC000_Iban.OB_CoBaOutputWrapper resultWrapper = OB_LCC000_Iban.saveCoBaAndIntegrate( bBillingProfiles.get( 0 ), coreData.aAssets );
        Test.stopTest( );
        System.assert( !resultWrapper.result );
    }

    /*******************************************************************************
    Purpose:  Method test saveCoBaAndIntegrate. Null test
    Parameters: -
    Returns: -

    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Adrian Dlugolecki       15/05/2019      Created         NEXI-33
    ********************************************************************************/
    @isTest
    private static void saveCoBaAndIntegrateNullTest( )
    {
        Test.startTest( );
        OB_LCC000_Iban.OB_CoBaOutputWrapper resultWrapper = OB_LCC000_Iban.saveCoBaAndIntegrate( null, null );
        Test.stopTest( );
        System.assert( !resultWrapper.result );
    }
}