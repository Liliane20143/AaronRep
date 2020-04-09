/*
    *   Author      :   Morittu Andrea
    *   Date        :   07-Nov-2019
    *   Task        :   BACKLOG-143 
    *   Description :   Class used to create record as admin users
*/
public without sharing class OB_Configure_Promo_Amex_Controller {
    
/*
    *   Author      :   Morittu Andrea
    *   Date        :   07-Nov-2019
    *   Task        :   BACKLOG-143 
    *   Description :   wrapper class used to easily disaplay data in javascript 
*/
    @TestVisible
    public class WrapperOutcome {
        @AuraEnabled
        public List<OB_Convention_Code__c> conventionCodes {get;set;}
        @AuraEnabled
        public Boolean hasError;
        @AuraEnabled
        public String errorMessage;
        @AuraEnabled
        public String userABI;
        public WrapperOutcome() {
            conventionCodes = new List<OB_Convention_Code__c>();
        }
    }
	
/*
    *   Author      :   Morittu Andrea
    *   Date        :   07-Nov-2019
    *   Task        :   BACKLOG-143 
    *   Description :   Method to retrieve server data to populate lightning data table 
*/
    @AuraEnabled    
    public static WrapperOutcome retrieveConventionCodes_Server() {
        WrapperOutcome wrapper = new WrapperOutcome();
        try {
            Boolean isAdmin = true;
            String currentUserId = UserInfo.getUserId();
            String ABI = [SELECT Id, OB_ABI__c FROM User WHERE Id =: currentUserId ].OB_ABI__c;
            
            wrapper.userABI = ABI;
            List<OB_Convention_Code__c> conventionCodes = OB_Utility.retrieveConventionCodes(ABI, isAdmin);
            
            if(!conventionCodes.isEmpty() ) {
            	wrapper.conventionCodes = conventionCodes;
            } else {
                wrapper.hasError = true;
                wrapper.errorMessage = Label.OB_NoDataFoundLabel;
            }
        } catch(OB_Utility.applicationException exc) {
            System.debug('An error has occured : ' + exc.getMessage());
        }
        return wrapper;
    }

/*
    *   Author      :   Morittu Andrea
    *   Date        :   07-Nov-2019
    *   Task        :   BACKLOG-143 
    *   Description :   Centralized method to dynamically perform an insert, a delete or an update DML
*/
    @AuraEnabled
    public static Boolean performOperation_Server(Object tempWrapper) {
        System.debug('tempWrapper is : ' + tempWrapper);
        try {
            if(tempWrapper != null)  {
                Map<String, Object> tempMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(tempWrapper)) ;
                System.debug('tempMap is : ' + tempMap) ;

                if(String.valueOf(tempMap.get('actionType')) == System.Label.OB_Create ) {
                    String rec = JSON.serialize(tempMap.get('currentRecord'));
                    
                    String bankAbi = String.valueOf(tempMap.get('bankAbi'));

                    List<Account> bankAcc = [SELECT Id, Name, RecordType.DeveloperName FROM Account Where RecordType.DeveloperName = 'Bank' AND OB_ABI__c =: bankAbi];
                    NE__Product__c amexProduct = getAmexProduct();
                    if(bankAcc.size() > 0) {
                        OB_Convention_Code__c currentRecord =(OB_Convention_Code__c) JSON.deserialize(rec , OB_Convention_Code__c.class );
                        currentRecord.OB_Bank__c = bankAcc.get(0).Id;
                        currentRecord.OB_Product__c = amexProduct.Id;
                        System.debug('current record is : ' + currentRecord);
                        createRecord(currentRecord);
                    }
                } else if(String.valueOf(tempMap.get('actionType')) == System.Label.OB_Edit ) {
                    String rec = JSON.serialize(tempMap.get('currentRecord'));
                    
                    OB_Convention_Code__c currentRecord =(OB_Convention_Code__c) JSON.deserialize(rec , OB_Convention_Code__c.class );
                    System.debug('EDIT RECIRD : ' + currentRecord);

                        editRecord(currentRecord);
                }
                else if(String.valueOf(tempMap.get('actionType')) == System.Label.OB_Delete ) {
                    String rec = JSON.serialize(tempMap.get('currentRecord'));
                    
                    OB_Convention_Code__c currentRecord =(OB_Convention_Code__c) JSON.deserialize(rec , OB_Convention_Code__c.class );
                    System.debug('EDIT RECIRD : ' + currentRecord);

                        deleteRecord(currentRecord);
                }
            }
        } catch (OB_Utility.applicationException exc) {
            System.debug(' An error has occured : ' + exc.getMessage());
        }
        return false;
    }

/*
    *   Author      :   Morittu Andrea
    *   Date        :   07-Nov-2019
    *   Task        :   BACKLOG-143 
    *   Description :   private method to nsert a record
*/
    @TestVisible
    private static void createRecord( OB_Convention_Code__c currentRecord ) {
        try {
            insert currentRecord;
        } catch(DMLException exc) {
            System.debug('Insert Failed : ' + exc.getMessage());
        }
    }

/*
    *   Author      :   Morittu Andrea
    *   Date        :   07-Nov-2019
    *   Task        :   BACKLOG-143 
    *   Description :   private method to edit a record
*/
    @TestVisible
    private static void editRecord( OB_Convention_Code__c currentRecord ) {
        try {
            update currentRecord;
        } catch(DMLException exc) {
            System.debug('Update Failed : ' + exc.getMessage());
        }
    }

/*
    *   Author      :   Morittu Andrea
    *   Date        :   07-Nov-2019
    *   Task        :   BACKLOG-143 
    *   Description :   private method to delete a record
*/
    @TestVisible
    private static void deleteRecord( OB_Convention_Code__c currentRecord ) {
        try {
            delete currentRecord;
        } catch(DMLException exc) {
            System.debug('Update Failed : ' + exc.getMessage());
        }
    }

/*
    *   Author      :   Morittu Andrea
    *   Date        :   07-Nov-2019
    *   Task        :   BACKLOG-143 
    *   Description :   retrieve amex product
*/
    @TestVisible
    private static NE__Product__c getAmexProduct() {
        NE__Product__c toReturn = new NE__Product__c();
        List<NE__Product__c> amexPRODUCTS = [  SELECT  Id, 
                                                Name 
                                        FROM    NE__Product__c 
                                        WHERE   Name =: OB_UtilityConstants.AMEX_PRODUCT_NAME
                                        AND     RecordType.DeveloperName =: OB_UtilityConstants.PRODUCT_RECORDTYPE_ACQUIRING 
                                        LIMIT 1
                                    ];

        if(!amexPRODUCTS.isEmpty() && amexPRODUCTS.size() > 0 )  {
            toReturn =  amexPRODUCTS.get(0);
        } else {
            throw new OB_Utility.applicationException('There\'s no AMEX product in current org, please, check the data');
        }
        return toReturn;
    }
    
}