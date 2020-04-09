@isTest
public  class OB_Maintenance_Serialize_Anagrafica_Test {

    @isTest
    public static void SerializeWrapperMerchantTest(){
        OB_Maintenance_Serialize_Anagrafica.SerializeWrapperMerchant SerializeWrapperMerchant = new OB_Maintenance_Serialize_Anagrafica.SerializeWrapperMerchant();
        OB_Maintenance_Serialize_Anagrafica.CompanyCodes CompanyCodes = new OB_Maintenance_Serialize_Anagrafica.CompanyCodes();
        OB_Maintenance_Serialize_Anagrafica.CompanyChanges CompanyChanges = new OB_Maintenance_Serialize_Anagrafica.CompanyChanges();
        OB_Maintenance_Serialize_Anagrafica.Phones Phones = new OB_Maintenance_Serialize_Anagrafica.Phones();
        OB_Maintenance_Serialize_Anagrafica.ContactExecutor ContactExecutor = new OB_Maintenance_Serialize_Anagrafica.ContactExecutor();
        OB_Maintenance_Serialize_Anagrafica.PersonalDocuments PersonalDocuments = new OB_Maintenance_Serialize_Anagrafica.PersonalDocuments();                                
                                        
    }

    @isTest
    public static void SerializeWrapperServicePointTest(){
        OB_Maintenance_Serialize_Anagrafica.SerializeWrapperServicePoint SerializeWrapperServicePoint = new OB_Maintenance_Serialize_Anagrafica.SerializeWrapperServicePoint();
        OB_Maintenance_Serialize_Anagrafica.SalesPointChanges SalesPointChanges = new OB_Maintenance_Serialize_Anagrafica.SalesPointChanges();
        OB_Maintenance_Serialize_Anagrafica.CompanyChanges CompanyChanges = new OB_Maintenance_Serialize_Anagrafica.CompanyChanges();
        OB_Maintenance_Serialize_Anagrafica.SalesPointCodes SalesPointCodes = new OB_Maintenance_Serialize_Anagrafica.SalesPointCodes();
        OB_Maintenance_Serialize_Anagrafica.OpeningTimes OpeningTimes = new OB_Maintenance_Serialize_Anagrafica.OpeningTimes();
        OB_Maintenance_Serialize_Anagrafica.OpeningDays OpeningDays = new OB_Maintenance_Serialize_Anagrafica.OpeningDays();                                
                                        
    }

    @isTest
    public static void SerializeWrapperCobaTest(){
        OB_Maintenance_Serialize_Anagrafica.SerializeWrapperCoba SerializeWrapperCoba = new OB_Maintenance_Serialize_Anagrafica.SerializeWrapperCoba();
        OB_Maintenance_Serialize_Anagrafica.CobaCodes CobaCodes = new OB_Maintenance_Serialize_Anagrafica.CobaCodes();
        OB_Maintenance_Serialize_Anagrafica.BankAccountDetails BankAccountDetails = new OB_Maintenance_Serialize_Anagrafica.BankAccountDetails();                          
                                        
    }

    /*******************************************************************************
    Purpose: Method checks value of 'atecoCode' if value is equal to '0000'
    then transcode to null
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Michal Targiel       11/07/2019        Created            NEXI-119
    ********************************************************************************/
    @isTest static void getMerchantWithAtecoCodeEqual0000ReturnNullTest( )
    {
        OB_Maintenance_Serialize_Anagrafica.SerializeWrapperMerchant SerializeWrapperMerchant = new OB_Maintenance_Serialize_Anagrafica.SerializeWrapperMerchant( );
        SerializeWrapperMerchant.companyChanges.atecoCode = '0000';
        System.assertEquals( null, SerializeWrapperMerchant.companyChanges.atecoCode );
    }

    /*******************************************************************************
     Purpose: Method checks value of 'atecoCode' if value is not equal '0000'
     then return the same atecoCode
     History
     --------
     VERSION     AUTHOR                  DATE            DETAIL          Description
     1.0         Michal Targiel       11/07/2019        Created            NEXI-119
    ********************************************************************************/
    @isTest static void getMerchantWithAtecoCodeNotEqual0000ReturnSameAtecoCodeTest( )
    {
        OB_Maintenance_Serialize_Anagrafica.SerializeWrapperMerchant SerializeWrapperMerchant = new OB_Maintenance_Serialize_Anagrafica.SerializeWrapperMerchant( );
        SerializeWrapperMerchant.companyChanges.atecoCode = '1234';
        System.assertEquals( '1234', SerializeWrapperMerchant.companyChanges.atecoCode );
    }


}