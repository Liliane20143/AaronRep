/*****************************************************************
Name: SearchMerchantByFiscalCode_Test
Copyright © 2016 ITC
============================================================
Purpose:  Class tests SearchMerchantByFiscalCode listAcc method
History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0      Monika Kocot           14/06/2019         Created             ---
********************************************************************************/

@isTest
public with sharing class SearchMerchantByFiscalCode_Test {

    /*******************************************************************************
    Purpose:  Method tests SearchMerchantByFiscalCode listAcc method,
              checks if returned NE__Fiscal_code__c of returned object
              is as expected when fiscalCode is not empty.
    Parameters: -
    Returns: -
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0      Monika Kocot            19/06/2019         Created             ---
    ********************************************************************************/
    @isTest
    public static void listAccTestFiscalCodeisNotEmpty(){

        Id recordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Merchant').getRecordTypeId();
        Account bankOwner = new Account();
        bankOwner.Name                   = 'Test';
        bankOwner.NE__E_mail__c          = 'test@null.it';
        bankOwner.OB_Employees_Number__c = 'Minore di 10';
        bankOwner.NE__VAT__c             = '12345678901';
        bankOwner.NE__Fiscal_code__c     = '12345678901';
        bankOwner.OB_VAT_Not_Present__c  =  false;
        bankOwner.OB_ABI__c              = '12345';
        bankOwner.OB_ATECO__c            = '1234567';
        bankOwner.OB_Legal_Form__c       = 'A100';
        bankOwner.RecordTypeId = recordTypeIdAcc;
        insert bankOwner;

        Test.startTest();
        List<Account> resultAccounts = SearchMerchantByFiscalCode.listAcc(bankOwner.NE__Fiscal_code__c,bankOwner.NE__VAT__c );
        Test.stopTest();

        System.assertEquals(resultAccounts.get(0).NE__Fiscal_code__c,bankOwner.NE__Fiscal_code__c);
    }
        /*******************************************************************************
    Purpose:  Method tests SearchMerchantByFiscalCode listAcc method,
              checks if returned NE__Fiscal_code__c of returned object
              is as expected when fiscalCode is empty.
    Parameters: -
    Returns: -
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0      Monika Kocot            19/06/2019         Created             ---
    ********************************************************************************/
    @isTest
    public static void listAccTestFiscalCodeisEmpty(){

        String inputFiscalCode = '';

        Id recordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Merchant').getRecordTypeId();
        Account bankOwner = new Account();
        bankOwner.Name                   = 'Test';
        bankOwner.NE__E_mail__c          = 'test@null.it';
        bankOwner.OB_Employees_Number__c = 'Minore di 10';
        bankOwner.NE__VAT__c             = '12345678901';
        bankOwner.NE__Fiscal_code__c     = '12345678901';
        bankOwner.OB_VAT_Not_Present__c  =  false;
        bankOwner.OB_ABI__c              = '12345';
        bankOwner.OB_ATECO__c            = '1234567';
        bankOwner.OB_Legal_Form__c       = 'A100';
        bankOwner.RecordTypeId = recordTypeIdAcc;
        insert bankOwner;

        Test.startTest();
        List<Account> resultAccounts = SearchMerchantByFiscalCode.listAcc(inputFiscalCode,bankOwner.NE__VAT__c );
        Test.stopTest();

        System.assertEquals(resultAccounts.get(0).NE__Fiscal_code__c,bankOwner.NE__Fiscal_code__c);

    }

}