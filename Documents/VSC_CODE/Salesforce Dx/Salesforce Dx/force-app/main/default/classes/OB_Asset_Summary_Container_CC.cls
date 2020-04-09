public with sharing class OB_Asset_Summary_Container_CC {
       @AuraEnabled 
    public static Map<String, List<Object>> getAccount(String servicePointsId_value)
    {
        System.debug('I am in getInfo_apex: '+servicePointsId_value);
        try 
        {
            //List<User> listOfUsers = [SELECT Id,Name,Profile.Name,Contact.Account.OB_ABI__c,OB_ABI__c FROM User WHERE Id=:Userinfo.getUserId()];
            Map<String, List<Object>> returnedMap = new Map<String, List<Object>>();             

            list<NE__Service_Point__c> servicePoints = [SELECT  Id,
                                                        		Name, 
                                                                OB_Typology__c,
                                                                OB_Service_Point_Name__c, 
                                                                NE__Country__c, 
                                                                NE__Province__c, 
                                                                OB_Break_End_Time__c, 
                                                                OB_Opening_Time__c, 
                                                                OB_Break_Start_Time__c, 
                                                                OB_Ending_Time__c, 
                                                                NE__Street__c, 
                                                                OB_Street_Number__c,  
                                                                NE__City__c, 
                                                                NE__Zip_Code__c, 
                                                                OB_Opening_Monday_Morning__c,
                                                                OB_Opening_Monday_Afternoon__c,
                                                                OB_Opening_Tuesday_Morning__c,
                                                                OB_Opening_Tuesday_Afternoon__c,
                                                                OB_Opening_Thursday_Morning__c,
                                                                OB_Opening_Thursday_Afternoon__c,
                                                                OB_Opening_Wednesday_Morning__c,
                                                                OB_Opening_Wednesday_Afternoon__c,
                                                                OB_Opening_Friday_Morning__c,
                                                                OB_Opening_Friday_Afternoon__c,
                                                                OB_Opening_Saturday_Morning__c,
                                                                OB_Opening_Saturday_Afternoon__c,
                                                                OB_Opening_Sunday_Morning__c,
                                                                OB_Opening_Sunday_Afternoon__c                               
                                                            FROM NE__Service_Point__c
                                                            WHERE Id=:servicePointsId_value ];
            
            List<Account> listOfAccounts = [SELECT Id,
                                            Name,
                                            NE__Status__c,
                                            NE__Fiscal_code__c,
                                            Description,
                                            NE__VAT__c,
                                            OB_New_Name__c,
                                            OB_VAT_Not_Present__c, 
                                            OB_DescriptionVATNotPresent__c,
                                            NE__E_mail__c,
                                            Phone, 
                                            OB_Legal_Form__c,
                                            OB_Year_constitution_company__c,
                                            OB_No_Profit_Class__c,
                                            OB_No_Profit_Recipient_Class__c,
                                            OB_No_Profit_Recipient_Other__c, 
                                            OB_Legal_Address_Hamlet__c,
                                            OB_Legal_Address_Detail__c,
                                            OB_Legal_Address_City__c,
                                            OB_Legal_Address_Country__c,
                                            OB_Legal_Address_Country_Code__c,
                                            OB_Legal_Address_Name__c,
                                            OB_Legal_Address_Street_Number__c,
                                            OB_Legal_Address_State__c,
                                            OB_Legal_Address_State_Code__c,
                                            OB_Legal_Address_Street__c,
                                            OB_Legal_Address_ZIP__c,
                                            OB_ABI__c
                                            FROM  Account
                                            WHERE  Id IN (SELECT NE__Account__c FROM NE__Service_Point__c WHERE Id=:servicePointsId_value )];
                                            
          
            if (!servicePoints.isEmpty() && !listOfAccounts.isEmpty())  
            {                                       
                List<Contact> contacts =    [SELECT Id, OB_Service_Point__c, FirstName, LastName, Phone, Email, RecordType.Name 
                                            FROM Contact 
                                            WHERE OB_Service_Point__c=:servicePoints.get(0).Id];
                
                returnedMap.put('contextAccount', listOfAccounts);
                returnedMap.put('contextServicePoint', servicePoints);
                returnedMap.put('contacts', contacts);

                System.debug('returnedMap: ' + JSON.serialize(returnedMap));
                System.debug('Success in getInfo_apex');

                
                
            }
            return returnedMap;
        }
        catch(Exception e)
        {
            System.debug('Exception in getAccount at line ' + e.getLineNumber() +'. Error message: ' + e.getMessage());
            return null;
        }
    }

}