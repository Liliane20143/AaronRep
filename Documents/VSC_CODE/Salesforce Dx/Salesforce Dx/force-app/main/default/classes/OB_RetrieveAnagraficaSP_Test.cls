@isTest
public class OB_RetrieveAnagraficaSP_Test {



    @isTest
    public static void getServicePoint_test() {

        NE__Service_Point__c sp = new NE__Service_Point__c();
        Account acc = new Account();
        acc.Name = 'Test';
        //acc.Description  = 'Test';
        acc.NE__E_mail__c  = 'test@null.it';
        acc.OB_Employees_Number__c = 'Minore di 10';
        acc.NE__VAT__c  = '12345678901';
        acc.NE__Fiscal_code__c= '12345678901';
        acc.OB_VAT_Not_Present__c = false;
        insert acc;
        sp.Name = 'Test SP';
        sp.NE__Account__c = acc.Id;
        insert sp;

        Test.startTest();
        OB_RetrieveAnagraficaSPController.getServicePoint(sp.id);
        Test.stopTest();

        
    }


    @isTest  
    private static void updateServicePointTest() 
    { 
       Account acc = new Account();
        acc.Name = 'Test';
        //acc.Description  = 'Test';
        acc.NE__E_mail__c  = 'test@null.it';
        acc.OB_Employees_Number__c = 'Minore di 10';
        acc.NE__VAT__c  = '12345678901';
        acc.NE__Fiscal_code__c= '12345678901';
        acc.OB_VAT_Not_Present__c = false;
        insert acc;
        
        NE__Service_Point__c sp = new NE__Service_Point__c(Name = 'Test SP', NE__Account__c = acc.Id);        
        insert sp;
        ExternalSourceMapping__c esm = new ExternalSourceMapping__c();
        esm.OB_Service_Point_ID__c = sp.id;
        esm.OB_CustomerCodeClientCode__c = '3334';
        esm.OB_Source__c = 'EQUENS';
        insert esm;
        System.debug(sp.Id);
        System.debug(OB_UtilityConstants.NEWRESPONSESERVICEPOINT);
        Test.startTest();
        OB_RetrieveAnagraficaSPController.updateServicePoint(String.valueOf(sp.Id), '{"shopName":"insegna","receiptHeader":"insegnascontrino","receiptLocation":"indirizzoscontrino","type":"FISICO","merchantCategoryCode":"7894","address":{"street":"VIAIVNOVEMBRE","civicNumber":"4","careOf":"centrocommercialeItalMark","postalCode":"14100","city":"Assago","province":"MI","country":"ITA"},"acquiringDetails":[{"acquiringCode":"5555","companyCode":"3334","moto":true,"processor":"EQUENS","activityStartDate":"2018-06-25","updatedDate":"2018-06-25","pricingType":"STANDARD","eCommerceType":"OneClick","distinctiveServices":{"isCarRental":true,"isHotel":true},"settlementMethods":[{"mode":"NETTO","schema":"00"}],"abiCondi":["9876"]}],"posDetails":[{"gtCompanyCode":"3334","gtSalePointCode":"2222","gtCode":"NEXI","agreementCodes":[{"code":"AMEX","processor":"EQUENS"}]}]}');
        Test.stopTest();
    }

    @isTest
    public static void updateServicePointTest2(){
        Account acc = new Account(Name='Test Name', NE__Fiscal_code__c='VRDFNC90P01D969G', OB_VAT_Not_Present__c=true); 
        acc.OB_Employees_Number__c = 'Minore di 10';
        //insert acc;
        NE__Service_Point__c sp = new NE__Service_Point__c(Name = 'Test SP', NE__Account__c = acc.Id);        
        insert sp;
        System.debug(sp.Id);
        System.debug(OB_UtilityConstants.NEWRESPONSESERVICEPOINT);
        Test.startTest();
        OB_RetrieveAnagraficaSPController.updateServicePoint(String.valueOf(sp.Id), '{"shopName":"insegna","receiptHeader":"insegnascontrino","receiptLocation":"indirizzoscontrino","type":"VIRTUALE","merchantCategoryCode":"7894","address":{"street":"VIAIVNOVEMBRE","civicNumber":"4","careOf":"centrocommercialeItalMark","postalCode":"14100","city":"Assago","province":"MI","country":"ITA"},"acquiringDetails":[{"acquiringCode":"5555","companyCode":"3333","moto":true,"processor":"EQUENS","activityStartDate":"2018-06-25","updatedDate":"2018-06-25","pricingType":"STANDARD","eCommerceType":"OneClick","distinctiveServices":{"isCarRental":true,"isHotel":true},"settlementMethods":[{"mode":"NETTO","schema":"00"}],"abiCondi":["9876"]}],"posDetails":[{"gtCompanyCode":"3334","gtSalePointCode":"2222","gtCode":"NEXI","agreementCodes":[{"code":"AMEX","processor":"EQUENS"}]}]}');
        Test.stopTest();
    }


    @isTest
    public static void picklist_values_test() {

        String strReport = 'VIRTUALE';
        String object_name = 'Account';
        String field_name = 'Name';
        String[] values = new String[]{'ExternalSourceMapping__c', 'OB_Service_Point_Type__c'};
        String[] types = new String[]{object_name};

        Test.startTest();
        OB_RetrieveAnagraficaSPController retrieveSP = new OB_RetrieveAnagraficaSPController();
        //retrieveSP.picklist_values(object_name, field_name);
        Test.stopTest();

        
    }
    
}