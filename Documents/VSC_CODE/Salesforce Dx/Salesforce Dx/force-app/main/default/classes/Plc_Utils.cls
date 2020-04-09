/**
 * Plc_Utils - Utils class
 * 
 * @author Tanzi Gabriele Giovanni
 * @author Kebe Dam
 * @description
 * @testedIn
 * @uses
 * @errorcode [ERR:CL-002YYZZ]
 */
public with sharing class Plc_Utils {

    /** String containing all hexadecimal characters */
    private static final String HEX_CHARS = '0123456789abcdefABCDEF';
    /** Email regular expression */
    public static final String EMAIL_REGEX = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
    /** Object containing map of fieds */
    public static FieldMapList fieldMapList {
        get{

            if(fieldMapList != null){
                return fieldMapList;
            }
            String myUrl = PageReference.forResource('Plc_FieldValidationJSON').getUrl();
            System.debug('MYTEST1'+myUrl);
            PageReference pg = new PageReference(myUrl + '/JSON/FieldValidationJSON.json');
            String jsonString = '';
            if(!Test.isRunningTest()){

                jsonString = pg.getContent().toString();
            } else {

                jsonString = '{' +
                            '   "objectFieldListMap": [' +
                            '       {   ' +
                            '           "parentField": "workOrderDetail",' +
                            '           "fieldList":[' +
                            '               "requestType",' +
                            '               "status",' +
                            '               "dealerAlias",' +
                            '               "warehouseAlias",' +
                            '               "abi",' +
                            '               "startDate",' +
                            '               "bankDescription",' +
                            '               "businessName",' +
                            '               "siaCode",' +
                            '               "accountLegacyId",' +
                            '               "shopLegacyId",' +
                            '               "signboard",' +
                            '               "address",' +
                            '               "postalCode",' +
                            '               "locality",' +
                            '               "province",' +
                            '               "prefix",' +
                            '               "phone",' +
                            '               "mail",' +
                            '               "cti",' +
                            '               "supportPhoneNumber"' +
                            '           ]' +
                            '       },' +
                            '       {' +
                            '           "parentField": "workOrderLineItemDetail",' +
                            '           "fieldList":[' +
                            '               "operationType",' +
                            '               "status",' +
                            '               "generationDate",' +
                            '               "resourceAlias"' +
                            '           ]' +
                            '       }' +
                            '   ],' +
                            '   "listFieldListMap": [' +
                            '       {' +
                            '           "parentField": "workOrderLineItem",' +
                            '           "fieldList":[' +
                            '               "workOrderLineItemLegacyId",' +
                            '               "workOrderLineItemDetail"' +
                            '           ]' +
                            '       }' +
                            '   ],' +
                            '   "fieldLengthList": [' +
                            '       {' +
                            '           "label": "requestType",' +
                            '           "maxLength": 18' +
                            '       },' +
                            '       {' +
                            '           "label": "status",' +
                            '           "maxLength": 30' +
                            '       },' +
                            '       {' +
                            '           "label": "category",' +
                            '           "maxLength": 30' +
                            '       },' +
                            '       {' +
                            '           "label": "dealerAlias",' +
                            '           "maxLength": 25' +
                            '       },' +
                            '       {' +
                            '           "label": "warehouseAlias",' +
                            '           "maxLength": 25' +
                            '       },' +
                            '       {' +
                            '           "label": "abi",' +
                            '           "maxLength": 5' +
                            '       },' +
                            '       {' +
                            '           "label": "bankDescription",' +
                            '           "maxLength": 250' +
                            '       },' +
                            '       {' +
                            '           "label": "businessName",' +
                            '           "maxLength": 50' +
                            '       },' +
                            '       {' +
                            '           "label": "siaCode",' +
                            '           "maxLength": 30' +
                            '       },' +
                            '       {' +
                            '           "label": "accountLegacyId",' +
                            '           "maxLength": 30' +
                            '       },' +
                            '       {' +
                            '           "label": "shopLegacyId",' +
                            '           "maxLength": 30' +
                            '       },' +
                            '       {' +
                            '           "label": "signboard",' +
                            '           "maxLength": 50' +
                            '       },' +
                            '       {' +
                            '           "label": "address",' +
                            '           "maxLength": 250' +
                            '       },' +
                            '       {' +
                            '           "label": "postalCode",' +
                            '           "maxLength": 5' +
                            '       },' +
                            '       {' +
                            '           "label": "locality",' +
                            '           "maxLength": 30' +
                            '       },' +
                            '       {' +
                            '           "label": "province",' +
                            '           "maxLength": 30' +
                            '       },' +
                            '       {' +
                            '           "label": "prefix",' +
                            '           "maxLength": 10' +
                            '       },' +
                            '       {' +
                            '           "label": "phone",' +
                            '           "maxLength": 15' +
                            '       },' +
                            '       {' +
                            '           "label": "mail",' +
                            '           "maxLength": 50' +
                            '       },' +
                            '       {' +
                            '           "label": "cti",' +
                            '           "maxLength": 50' +
                            '       },' +
                            '       {' +
                            '           "label": "supportPhoneNumber",' +
                            '           "maxLength": 50' +
                            '       },' +
                            '       {' +
                            '           "label": "operationType",' +
                            '           "maxLength": 18' +
                            '       },' +
                            '       {' +
                            '           "label": "generationDate",' +
                            '           "maxLength": 25' +
                            '       },' +
                            '       {' +
                            '           "label": "notes",' +
                            '           "maxLength": 250' +
                            '       },' +
                            '       {' +
                            '           "label": "resourceAlias",' +
                            '           "maxLength": 25' +
                            '       },' +
                            '       {' +
                            '           "label": "workOrderLineItemLegacyId",' +
                            '           "maxLength": 25' +
                            '       },' +
                            '       {' +
                            '           "label": "startDate",' +
                            '           "maxLength": 25' +
                            '       },' +
                            '       {' +
                            '           "label": "endDate",' +
                            '           "maxLength": 25' +
                            '       },' +
                            '       {' +
                            '           "label": "vatNumber",' +
                            '           "maxLength": 11' +
                            '       },' +
                            '       {' +
                            '           "label": "fiscalCode",' +
                            '           "maxLength": 16' +
                            '       },' +
                            '       {' +
                            '           "label": "ctiType",' +
                            '           "maxLength": 30' +
                            '       },' +
                            '       {' +
                            '           "label": "openingTime",' +
                            '           "maxLength": 250' +
                            '       },' +
                            '       {' +
                            '           "label": "referent",' +
                            '           "maxLength": 50' +
                            '       },' +
                            '       {' +
                            '           "label": "notes",' +
                            '           "maxLength": 250' +
                            '       }' +
                            '   ]' +
                            '}';
            }
            fieldMapList = parseFieldMapList(jsonString);
            System.debug('###fieldMapList: ' + JSON.serialize(fieldMapList));
            return fieldMapList;
        }
        set;
    }
    /** Map containing max length for each field */
    public static Map<String, Integer> fieldLengthMap {
        get{

            if(fieldLengthMap != null){

                return fieldLengthMap;
            }
            fieldLengthMap = new Map<String, Integer>();
            for(Field field : fieldMapList.fieldLengthList){

                fieldLengthMap.put(field.label, field.maxLength);
            }
            return fieldLengthMap;
        }
        set;
    }
    /** Map containing list of required fields of innerObjects */
    public static Map<String, List<String>> objectFieldListMap {
        get{

            if(objectFieldListMap != null){

                return objectFieldListMap;
            }

            if(fieldLengthMap == null){

                fieldLengthMap = new Map<String, Integer>();
            }

            objectFieldListMap = new Map<String, List<String>>();
            for(FieldListMap fieldListMap : fieldMapList.objectFieldListMap){

                if(!objectFieldListMap.containsKey(fieldListMap.parentField)){

                    objectFieldListMap.put(fieldListMap.parentField, new List<String>());
                }  
                for(String field : fieldListMap.fieldList){

                    objectFieldListMap.get(fieldListMap.parentField).add(field);
                }
            }
            return objectFieldListMap;
        }
        set;
    }
    /** Map containing list of required fields of innerlists */
    public static Map<String, List<String>> listFieldListMap {
        get{

            if(listFieldListMap != null){

                return listFieldListMap;
            }

            if(fieldLengthMap == null){

                fieldLengthMap = new Map<String, Integer>();
            }

            listFieldListMap = new Map<String, List<String>>();
            for(FieldListMap fieldListMap : fieldMapList.listFieldListMap){

                if(!listFieldListMap.containsKey(fieldListMap.parentField)){

                    listFieldListMap.put(fieldListMap.parentField, new List<String>());
                }  
                for(String field : fieldListMap.fieldList){

                    listFieldListMap.get(fieldListMap.parentField).add(field);
                }
            }
            return listFieldListMap;
        }
        set;
    }
    /** Map containing list of required fields of innerObjects */
    //public static Map<String, List<String>> objectFieldListMap = new Map<String, List<String>>{
    //    'workOrderDetail' => new List<String>{'requestType','status','category',
    //                                        'dealerAlias','warehouseAlias','abi',
    //                                        'bankDescription','businessName',
    //                                        'siaCode','accountLegacyId','shopLegacyId','signboard',
    //                                        'address','postalCode','locality','province','prefix',
    //                                        'phone','mail','cti','supportPhoneNumber'},
    //    'workOrderLineItemDetail'=> new List<String>{'operationType','status', 'generationDate', 'notes'}
    //};

    ///** Map containing list of required fields of innerlists */
    //public static Map<String, List<String>> listFieldListMap = new Map<String, List<String>>{
    //    'workOrderLineItem'=> new List<String>{'workOrderLineItemLegacyId','workOrderLineItemDetail'}
    //};

    /**
     * retrieves map of sObject recordtypes, if is needed to retrieve singular recordType use getRecordTypeId() method on map value
     * @param  sObjectType API name of sObject of wich recordTypes are needed
     * @return             map of sObject recordtypes, deveplopername as key
     */
    public static Map<String, Schema.RecordTypeInfo> getSObjectTypeRecordTypeMap(String sObjectType){

        System.debug('getSObjectTypeRecordTypeMap - START');
        Map<String, Schema.RecordTypeInfo> recordTypeMap = Schema.getGlobalDescribe().get(sObjectType).getDescribe().getRecordTypeInfosByDeveloperName();
        return recordTypeMap;
    }

    /**
     * retrieves a RecordType id by developer name
     * @param  developerName API name of the a record type of the sObject
     * @param  sObjectType   API name of the sObject 
     * @return               the id of the recordtype
     */
    public static Id getRecordTypeId(String developerName, String sObjectType) {
        return Schema.getGlobalDescribe().get(sObjectType).getDescribe()
               .getRecordTypeInfosByDeveloperName()                                             
               .get(developerName)
               .getRecordTypeId();
    }

    /**
     * [isValid description]
     * @param  payload   serialized Json
     * @param  fieldList list of required fields
     * @return           Boolean - if all required fields are filled returns true otherwise returns false
     */
    public static String isValid(object payload, List<String> fieldList){

        String serialized = JSON.serialize(payload);
        Map<String,Object> payloadMap =  (Map<String,Object>) JSON.deserializeUntyped(serialized);
        System.debug('objectFieldListMap: ' + objectFieldListMap.keySet());
        System.debug('listFieldListMap: ' + listFieldListMap.keySet());
        System.debug('fieldList: ' + fieldList);
        System.debug('payloadMap.keySet(): ' + payloadMap.keySet());
        /** cicles list of first level of required fields*/
        for(String field : fieldList){

            /** if field is an object */
            if(objectFieldListMap.containsKey(field)){

                System.debug('field: ' + field);
                Map<String,Object> innerPayloadMap =  (Map<String,Object>)payloadMap.get(field);
                System.debug('innerPayloadMap: ' + innerPayloadMap);
                if(innerPayloadMap == null){

                    return field + ' is blank or null.';
                }
                for(String innerField : objectFieldListMap.get(field)){
                    /** iterate over each object's field */
                    System.debug('innerField: ' + innerField);
                    System.debug('innerPayloadMap.get(innerField): ' + innerPayloadMap.get(innerField));
                    if(innerPayloadMap.get(innerField) == '' ||
                       innerPayloadMap.get(innerField) == null){

                        System.debug('is not valid');
                        return innerField + ' is blank or null.';
                    } else if(fieldLengthMap.containsKey(innerField)){ 
                        
                        if(fieldLengthMap.get(innerField) < String.valueOf(innerPayloadMap.get(innerField)).length()) {

                            System.debug('is not valid');
                            return innerField + ' is longer than expected.';
                        }
                    }                   
                }
            }/** if field is a list */ 
            else if(listFieldListMap.containsKey(field)){

                System.debug('field: ' + field);
                List<Object> innerPayloadMap =  (List<Object>)payloadMap.get(field);
                System.debug('innerPayloadMap: ' + innerPayloadMap);
                /** iterate over each object */
                if(innerPayloadMap.isEmpty()){

                    return field + ' is blank or null.';
                }
                for(Object innerObject : innerPayloadMap){

                    Map<String,Object> innerObjectPayloadMap =  (Map<String,Object>)innerObject;
                    for(String innerField : listFieldListMap.get(field)){
                        /** iterate over each object's field */
                        System.debug('innerObjectPayloadMapinnerField: ' + innerField);
                        System.debug('innerObjectPayloadMap.get(innerField): ' + innerObjectPayloadMap.get(innerField));
                        if(objectFieldListMap.containsKey(innerField)){
                            /** if field is an object */
                            Map<String,Object> innerListObjectPayloadMap =  (Map<String,Object>)innerObjectPayloadMap.get(innerField);
                            if(innerListObjectPayloadMap == null){

                                return innerField + ' is blank or null.';
                            }
                            for(String innerListObjectField : objectFieldListMap.get(innerField)){
                                /** iterate over each object's field */
                                System.debug('innerListObjectField: ' + innerListObjectField);
                                System.debug('innerListObjectPayloadMap.get(innerListObjectField): ' + innerListObjectPayloadMap.get(innerListObjectField));
                                if(innerListObjectPayloadMap.get(innerListObjectField) == '' ||
                                   innerListObjectPayloadMap.get(innerListObjectField) == null){

                                    System.debug('is not valid');
                                    return innerListObjectField + ' is blank or null.';
                                } else if(fieldLengthMap.containsKey(innerListObjectField)){ 
                                    
                                    if(fieldLengthMap.get(innerListObjectField) < String.valueOf(innerListObjectPayloadMap.get(innerListObjectField)).length()){

                                        System.debug('is not valid');
                                        return innerListObjectField + ' is longer than expected.';
                                    }
                                }                   
                            }
                        }else {
                            /** if field is of simple type */
                            if(innerObjectPayloadMap.get(innerField) == '' ||
                               innerObjectPayloadMap.get(innerField) == null){

                                System.debug('is not valid');
                                return innerField + ' is blank or null.';
                            }else if(fieldLengthMap.containsKey(innerField)){
                                
                                if(fieldLengthMap.get(innerField) < String.valueOf(innerObjectPayloadMap.get(innerField)).length()){

                                    System.debug('is not valid');
                                    return innerField + ' is longer than expected.';
                                }
                            }                    
                        }
                    }
                }
            } 
            /** if field is of simple type */
            else {
                System.debug('field: ' + field);
                System.debug('field: ' + field + ' fieldLengthMap.get(field): ' + fieldLengthMap.get(field));
                if(payloadMap.get(field) == '' ||
                   payloadMap.get(field) == null){

                    System.debug('is not valid');
                    return field + ' is blank or null.';
                } else if(fieldLengthMap.containsKey(field)){
                    
                    if(fieldLengthMap.get(field) < String.valueOf(payloadMap.get(field)).length()){

                        System.debug('is not valid');
                        return field + ' is longer than expected.';
                    }
                }
            }
        }
        System.debug('is valid');
        return null;
    }

    public  String getRecordTypeNameById(String sObjectType, String recordTypeId){

        return Schema.getGlobalDescribe().get(sObjectType).getDescribe()
               .getRecordTypeInfosById()                                             
               .get(recordTypeId)
               .getName();
    }

    /**
     * This method checks whether current user can access to given dealer features (such as taking in charge its 
     * stock orders) looking inside related public group (using also hierachy roles). Used in Plc_StockOrderApxAct and
     * Plc_GoodsReceivingCnt
     *
     * @author FB
     * @date Creation 15/03/2018
     * 
     * @param  dealer Dealer of which current user permission must be checked
     * @return        True if current user is part of dealer group
     */
    public static Boolean isCurrentUserDealerGroupMember(String dealerId) {

        //Getting the group which a particular dealer referres to
        List<Bit2Shop__Dealer__c> destinationDealersList = [
                SELECT Id, Bit2Shop__Group_Id__c
                FROM Bit2Shop__Dealer__c
                WHERE Id = :dealerId
        ];

        if (destinationDealersList.isEmpty() || destinationDealersList.get(0).Bit2Shop__Group_Id__c == null) {
            return false;
        }

        Bit2Shop__Dealer__c destinationDealer = destinationDealersList.get(0);

        //Getting group members records and groups current user belongs to
        Set<Id> authorizedUsersAndGroupsSet = new Set<Id>();
        //Getting first level group members 
        for (GroupMember gm : [
                SELECT Id, GroupId,
                        UserOrGroupId
                FROM GroupMember
                WHERE GroupId = :destinationDealer.Bit2Shop__Group_Id__c
        ]) {

            authorizedUsersAndGroupsSet.add(gm.UserOrGroupId);
        }
        //Getting second level group members 
        for (GroupMember gm : [
                SELECT Id, GroupId,
                        UserOrGroupId
                FROM GroupMember
                WHERE GroupId IN :authorizedUsersAndGroupsSet
        ]) {

            authorizedUsersAndGroupsSet.add(gm.UserOrGroupId);
        }

        //Gettting User roles for users that are group members 
        Set<Id> bottomUserRolesSet = new Set<Id>();
        for (User u : [
                SELECT Id, UserRoleId
                FROM User
                WHERE Id IN :authorizedUsersAndGroupsSet
        ]) {
            bottomUserRolesSet.add(u.UserRoleId);
        }

        //Getting parent roles
        Set<Id> parentUserRolesSet = new Set<Id>();
        parentUserRolesSet = retrieveAboveRoles(bottomUserRolesSet);

        for (User managerUser : [
                SELECT Id, UserRoleId
                FROM User
                WHERE UserRoleId IN :parentUserRolesSet
        ]) {
            authorizedUsersAndGroupsSet.add(managerUser.Id);
        }

        return authorizedUsersAndGroupsSet.contains(UserInfo.getUserId());
    }

    /**
     * Used to retrieve the list of roles above given roles
     * 
     * @author FB
     * @date Creation 15/03/2018
     * 
     * @param  bottomUserRolesSet Contains the list of bottom user roles 
     * @return                    A set containing the roles above given users roles
     */
    public static Set<Id> retrieveAboveRoles(Set<Id> bottomUserRolesSet) {
        Set<Id> aboveUserRolesSet = new Set<Id>();
        Map<Id, UserRole> userRolesMap = new Map<Id, UserRole>([SELECT Id, Name, ParentRoleId FROM UserRole]);

        for (Id bottomUserRoleId : bottomUserRolesSet) {
            retrieveAboveRoles(userRolesMap, aboveUserRolesSet, bottomUserRoleId);
        }

        return aboveUserRolesSet;
    }

    /**
     * Private helper method used for recursion
     * 
     * @author FB
     * @date Creation 15/03/2018
     * 
     * @param  userRolesMap      Map containing user roles
     * @param  aboveUserRolesSet Temporary set with calculated roles
     * @param  currentUserRoleId Current user role to check
     * @return                   A set containing the roles above given users
     */
    private static void retrieveAboveRoles(Map<Id, UserRole> userRolesMap, Set<Id> aboveUserRolesSet, Id currentUserRoleId) {

        if (!(!userRolesMap.containsKey(currentUserRoleId) || userRolesMap.get(currentUserRoleId).ParentRoleId == null)) {
            aboveUserRolesSet.add(userRolesMap.get(currentUserRoleId).ParentRoleId);
            retrieveAboveRoles(userRolesMap, aboveUserRolesSet, userRolesMap.get(currentUserRoleId).ParentRoleId);
        }
    }

    /*
     * Singleton used in order to get an instance of ProductStockQuantities
     */
    private static ProductStockQuantities productStockQties_ns;
    public static ProductStockQuantities productStockQties {
        get {
            if (productStockQties_ns == null) productStockQties_ns = new ProductStockQuantities();
            return productStockQties_ns;
        }
    }
    /*
     * Wrapper class used in order to retrieve product stocks without sharing rules  
     */
    public without sharing class ProductStockQuantities {

        /**
         * Updates quantities in Product Stocks of given Stock Serials
         *
         * @author FB
         * @date Creation 22/01/2018
         * 
         * @param  oldStockSerialsMap Map containing existing stock serials before update (Id to Bit2Shop__Stock_Serials2__c record)
         * @param  newStockSerialsMap Map containing new and updated stock serials (Id to Bit2Shop__Stock_Serials2__c record)
         * @return                    Map with serials id to errors (if any)
         */
        public Map<String, List<String>> updateProductStockQuantities(Map<String, Bit2Shop__Stock_Serials2__c> oldStockSerialsMap,
                                                                      Map<String, Bit2Shop__Stock_Serials2__c> newStockSerialsMap) {

            //Initializing needed collections
            Map<String, List<String>> stockSerialIdToErrorsMap = new Map<String, List<String>>();
            Map<String, List<String>> productStockIdToSerialIdsMap = new Map<String, List<String>>();
            Set<String> productStockToUpdateSet = new Set<String>();

            //Getting Product Stock from old serials
            for (String key : oldStockSerialsMap.keySet()) {
                productStockToUpdateSet.add(oldStockSerialsMap.get(key).Bit2Shop__Product_Stock_Id__c);
            }

            //Getting Product Stock from new serials
            for (String key : newStockSerialsMap.keySet()) {
                productStockToUpdateSet.add(newStockSerialsMap.get(key).Bit2Shop__Product_Stock_Id__c);
            }

            Map<String, Bit2Shop__Product_Stock__c> productStockToUpdateMap = new Map<String, Bit2Shop__Product_Stock__c>(
                [SELECT Id,
                      Bit2Shop__Stock_Qty__c,
                      Plc_UsableQty__c,
                      Plc_WithdrawnQty__c
                 FROM Bit2Shop__Product_Stock__c    
                 WHERE Id IN :productStockToUpdateSet
                 FOR UPDATE]
            );

            for (String newSerialKey : newStockSerialsMap.keySet()) {
                
                Bit2Shop__Stock_Serials2__c newStockSerial = newStockSerialsMap.get(newSerialKey);
                String newProductStockId = newStockSerial.Bit2Shop__Product_Stock_Id__c;

                if (oldStockSerialsMap.containsKey(newSerialKey)) {
                    //Getting old Serial Stock current data
                    Bit2Shop__Stock_Serials2__c oldStockSerial = oldStockSerialsMap.get(newSerialKey);
                    String oldProductStockId = oldStockSerial.Bit2Shop__Product_Stock_Id__c;

                    if (productStockToUpdateMap.containsKey(oldProductStockId)) {
                        //A Product Stock can be referred to 1 or n serials
                        if (productStockIdToSerialIdsMap.containsKey(oldProductStockId)){
                            productStockIdToSerialIdsMap.get(oldProductStockId).add(oldStockSerial.Id);
                        } else {
                            productStockIdToSerialIdsMap.put(oldProductStockId, new List<String>{oldStockSerial.Id});
                        }
                        
                        //Getting old quantities
                        Decimal oldStockQty = productStockToUpdateMap.get(oldProductStockId).Bit2Shop__Stock_Qty__c;
                        Decimal oldUsableQty = productStockToUpdateMap.get(oldProductStockId).Plc_UsableQty__c;
                        Decimal oldWithdrawnQty = productStockToUpdateMap.get(oldProductStockId).Plc_WithdrawnQty__c;
                        //Setting Stock Quantity
                        oldStockQty = (oldStockQty == null) ? 0 : oldStockQty - 1;
                        //Setting Usable Quantity if status is Available 
                        if (oldStockSerial.Bit2Shop__Status__c == 'Available') {
                            oldUsableQty = (oldUsableQty == null) ? 1 : oldUsableQty - 1;
                        }
                        //Setting Withdrawn Quantity if status is Withdrawn 
                        if (oldStockSerial.Bit2Shop__Status__c == 'Withdrawn') {
                            oldWithdrawnQty = (oldWithdrawnQty == null) ? 1 : oldWithdrawnQty - 1;
                        }

                        //Setting evaluated quantities back to records
                        productStockToUpdateMap.get(oldProductStockId).Bit2Shop__Stock_Qty__c = oldStockQty;
                        productStockToUpdateMap.get(oldProductStockId).Plc_UsableQty__c = oldUsableQty;
                        productStockToUpdateMap.get(oldProductStockId).Plc_WithdrawnQty__c = oldWithdrawnQty;
                    }
                } 

                if (productStockToUpdateMap.containsKey(newProductStockId)) {
                    //A Product Stock can be referred to 1 or n serials
                    if (productStockIdToSerialIdsMap.containsKey(newProductStockId)){
                        productStockIdToSerialIdsMap.get(newProductStockId).add(newStockSerial.Id);
                    } else {
                        productStockIdToSerialIdsMap.put(newProductStockId, new List<String>{newStockSerial.Id});
                    }
                    //Getting current quantities
                    Decimal stockQty = productStockToUpdateMap.get(newProductStockId).Bit2Shop__Stock_Qty__c;
                    Decimal usableQty = productStockToUpdateMap.get(newProductStockId).Plc_UsableQty__c;
                    Decimal withdrawnQty = productStockToUpdateMap.get(newProductStockId).Plc_WithdrawnQty__c; 
                    //Setting Stock Quantity
                    stockQty = (stockQty == null) ? 1 : stockQty + 1;
                    //Setting Usable Quantity if status is Available 
                    if (newStockSerial.Bit2Shop__Status__c == 'Available') {
                        usableQty = (usableQty == null) ? 1 : usableQty + 1;
                    }
                    //Setting Withdrawn Quantity if status is Withdrawn 
                    if (newStockSerial.Bit2Shop__Status__c == 'Withdrawn') {
                        withdrawnQty = (withdrawnQty == null) ? 1 : withdrawnQty + 1;
                    }

                    //Setting evaluated quantities back to records
                    productStockToUpdateMap.get(newProductStockId).Bit2Shop__Stock_Qty__c = stockQty;
                    productStockToUpdateMap.get(newProductStockId).Plc_UsableQty__c = usableQty;
                    productStockToUpdateMap.get(newProductStockId).Plc_WithdrawnQty__c = withdrawnQty;
                }
            }
            //Saving results and setting errors (if any)
            List<Database.SaveResult> updateResults = Database.update(productStockToUpdateMap.values(), false);

            for (Database.SaveResult updateResult : updateResults) {
                for (String serialStockId : productStockIdToSerialIdsMap.get(updateResult.getId())) {
                    if (!updateResult.isSuccess()) {
                        if (stockSerialIdToErrorsMap.containsKey(serialStockId)) {
                            stockSerialIdToErrorsMap.get(serialStockId).add('Warning: ' + updateResult.getErrors()[0].getMessage());
                        } else {
                            stockSerialIdToErrorsMap.put(serialStockId, new List<String>{'Warning: ' + updateResult.getErrors()[0].getMessage()});
                        }
                    }
                }
            }

            return stockSerialIdToErrorsMap;
        }

    }

    public class FieldMapList {
        public List<FieldListMap> objectFieldListMap;
        public List<FieldListMap> listFieldListMap;
        public List<Field> fieldLengthList;
    }
    public static FieldMapList parseFieldMapList(String json) {
        return (FieldMapList) System.JSON.deserialize(json, FieldMapList.class);
    }
    public class Field {
        public String label;
        public Integer maxLength;
    }
    public class FieldListMap {
        public String parentField;
        public List<String> fieldList;
    }

    public static boolean checkCrudObjectPermission (String salesforceObject, String typology){
        Schema.DescribeSObjectResult[] descResult = Schema.describeSObjects( new String[]{salesforceObject});
        if(typology=='SOQL'){
           return descResult[0].isAccessible();
        }
        else if(typology.equalsIgnoreCase('DELETE')){
           return descResult[0].isDeletable();
        }
        else if(typology=='UPDATE'){
           return descResult[0].isUpdateable();
        }
        else if(typology=='INSERT'){
           return descResult[0].isCreateable();
        }
        return false;
    }

    public static String checkCrudFieldPermission (String objectName , List<String> fieldsToCheck, String tipology){
        String resultFound;
        System.debug('checkCrudFieldPermission');
        
        SObjectType objectType = Schema.getGlobalDescribe().get(objectName);
        Map<String,Schema.SObjectField> mfields = objectType.getDescribe().fields.getMap();
        
        for(String fields : fieldsToCheck){
           Schema.DescribeFieldResult fieldCrud = mfields.get(fields.toLowerCase()).getDescribe();
            tipology = tipology.toUpperCase();
            switch on tipology {
                when  'INSERT' {
                            System.debug('checkCrudFieldPermission INSERT');
                    if(!fieldCrud.isCreateable()){
                        resultFound = (String.isNotBlank(resultFound) ? resultFound+' , '+fieldCrud.getName() : fieldCrud.getName() );
                    }
                }
                when  'UPDATE' {
                            System.debug('checkCrudFieldPermission UPDATE');

                    if(!fieldCrud.isUpdateable()){
                        resultFound = (String.isNotBlank(resultFound) ? resultFound+' , '+fieldCrud.getName() : fieldCrud.getName() );
                    }                
                }
                when  'UPSERT' {
                            System.debug('checkCrudFieldPermission UPSERT');

                    if(!fieldCrud.isUpdateable() || !fieldCrud.isCreateable()){
                        resultFound = (String.isNotBlank(resultFound) ? resultFound+' , '+fieldCrud.getName() : fieldCrud.getName() );
                    }                
                }
            }
        }
        if(resultFound != null){
            resultFound = 'checkCrudFieldPermission [ERR-CL00E100]: '+resultFound+' fields are not Updateable or Createable for the Object '+objectName+' with profileId: '+System.UserInfo.getProfileId();
        }
        return resultFound;
    }

    /**
    * @Emanuele Campese
    * @date 22/09/2019
    * @description Utility method to retrieve api name of all fields on a object
    */

    public static String getAllFieldsApiNameFromObject (String objectName){
        SObjectType objectType = Schema.getGlobalDescribe().get(objectName);
        Map<String,Schema.SObjectField> mfields = objectType.getDescribe().fields.getMap();
        String allFieldsApiNames = null;
        for(String apiNameField : mfields.keySet()){
            allFieldsApiNames = (String.isBlank(allFieldsApiNames) ? apiNameField : allFieldsApiNames+','+apiNameField);
        }
        return allFieldsApiNames;
    }


    /**
    * @Giampaolo Mei
    * @date 14/02/2019
    * @description Utility class for creation structure configuration item, shipments, shipments line item inbound and outbound
    */

    private static Plc_ShipmentsUtils shipmentsUtils_ns;
    public static Plc_ShipmentsUtils shipmentsUtils {
        get {
            if (shipmentsUtils_ns == null) shipmentsUtils_ns = new Plc_ShipmentsUtils();
            return shipmentsUtils_ns;
        }
    }

    public without sharing class Plc_ShipmentsUtils {
        Savepoint sp = Database.setSavepoint();
        
        public void createProductSerialStructure(List<Bit2Shop__Stock_Serials2__c> selectedProductSerial, NE__Order__c configurationToCreate, Bit2Shop__StockOrder__c stockOrderToCreate,Boolean toClose) {
            //raggruppo i product serial per modello
            try{
                Map<Id, List<Bit2Shop__Stock_Serials2__c>> modelIdToProductSerial = new Map<Id, List<Bit2Shop__Stock_Serials2__c>>();
                for (Bit2Shop__Stock_Serials2__c pS : selectedProductSerial) {
                    if (modelIdToProductSerial.containsKey(pS.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__c)) {
                        modelIdToProductSerial.get(pS.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__c).add(pS);
                    } else {
                        modelIdToProductSerial.put(pS.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__c, new List<Bit2Shop__Stock_Serials2__c>());
                        modelIdToProductSerial.get(pS.Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__c).add(pS);
                    }
                }
                System.debug('Plc_GoodsHandlingCnt modelIdToProductSerial: ' + modelIdToProductSerial);
                
                // Parametri per gestione catena chiusa o aperta
                String configurationItemStatus = Plc_Constants.NE_OrderItem.NE_Status_Pending;
                String shipmentStatus = Plc_Constants.B2S_Shipment.B2S_Status_Pending;
                Date shipmentDate = null;
                Date shipmentCloseDate = null;
                String sliStatus = Plc_Constants.B2S_ShipmentLineItem.B2S_Status_Pending;
                String sliReceivedStatus = '';
                Date sliDate = null;
                if(toClose) {
                    configurationItemStatus = Plc_Constants.NE_OrderItem.NE_Status_Completed;
                    shipmentStatus = Plc_Constants.B2S_Shipment.B2S_Status_Closed;
                    shipmentDate = System.today();
                    shipmentCloseDate = System.today();
                    sliStatus = Plc_Constants.B2S_ShipmentLineItem.B2S_Status_Closed;
                    sliReceivedStatus = Plc_Constants.B2S_ShipmentLineItem.B2S_ReceivedStatus_Received;
                    sliDate = System.today();
                }

                //creo un configuration item per ogni modello di prodotto a seriale
                Map<Id, NE__OrderItem__c> modelIdToConfigurationItem = new Map<Id, NE__OrderItem__c>();
                List<NE__OrderItem__c> configurationsItemToCreate = new List<NE__OrderItem__c>();
                for (Id model : modelIdToProductSerial.keySet()) {
                    NE__OrderItem__c configurationItem = new NE__OrderItem__c(
                            RecordTypeId = Plc_Utils.getRecordTypeId(Plc_Constants.NE_OrderItem.RecordType_Standard,
                                    NE__OrderItem__c.SObjectType.getDescribe().name),
                            NE__OrderId__c = configurationToCreate.Id,
                            NE__Qty__c = 1,
                            NE__Status__c = configurationItemStatus,
                            NE__Account__c = stockOrderToCreate.Bit2Shop__Holding_Id__c,
                            Bit2Shop__Required_Serial__c = true
                    );
                    configurationsItemToCreate.add(configurationItem);
                    modelIdToConfigurationItem.put(model, configurationItem);
                }
                System.debug('Plc_GoodsHandlingCnt configurationsItemToCreate: ' + configurationsItemToCreate);
                insert configurationsItemToCreate;

                //creo uno shipment per ogni modello di prodotto a seriale
                Map<Id, Bit2Shop__Shipment__c> modelIdToShipment = new Map<Id, Bit2Shop__Shipment__c>();
                Map<Id, Bit2Shop__Shipment__c> modelIdToShipmentInbound = new Map<Id, Bit2Shop__Shipment__c>();
                List<Bit2Shop__Shipment__c> shipmentsToCreate = new List<Bit2Shop__Shipment__c>();
                for (Id model : modelIdToProductSerial.keySet()) {
                    //outbound
                    Bit2Shop__Shipment__c shipment = new Bit2Shop__Shipment__c(
                            RecordTypeId = Plc_Utils.getRecordTypeId(Plc_Constants.B2S_Shipment.RecordType_OutboundShipment,
                                    Bit2Shop__Shipment__c.SObjectType.getDescribe().name),
                            Bit2Shop__Status__c = shipmentStatus,
                            //Bit2Shop__Expected_Delivery_Date__c     = endDate,
                            Bit2Shop__Close_Date__c                 = shipmentCloseDate,
                            Bit2Shop__Date__c = shipmentDate,
                            Bit2Shop__Shipped_Quantity__c = modelIdToProductSerial.get(model).size(),
                            Bit2Shop__Stock_Order_Id__c = stockOrderToCreate.Id,
                            Bit2Shop__Sub_Type__c = Plc_Constants.B2S_Shipment.B2S_Subtype_Outbound,
                            Bit2Shop__Type__c = Plc_Constants.B2S_Shipment.B2S_Type_Final,
                            Bit2Shop__Configuration_Item_Id__c = modelIdToConfigurationItem.get(model).Id,
                            Bit2Shop__Shipment_Document_Number__c = 'Doc_' + modelIdToConfigurationItem.get(model).Id,
                            OwnerId = stockOrderToCreate.OwnerId
                    );
                    System.debug('Plc_GoodsHandlingCnt modelIdToProductSerial.get(model).size(): ' + modelIdToProductSerial.get(model).size());
                    shipmentsToCreate.add(shipment);
                    modelIdToShipment.put(model, shipment);

                    //inbound
                    Bit2Shop__Shipment__c shipmentInbound = new Bit2Shop__Shipment__c(
                            RecordTypeId = Plc_Utils.getRecordTypeId(Plc_Constants.B2S_Shipment.RecordType_InboundShipment,
                                    Bit2Shop__Shipment__c.SObjectType.getDescribe().name),
                            Bit2Shop__Status__c = shipmentStatus,
                            //Bit2Shop__Expected_Delivery_Date__c     = endDate,
                            Bit2Shop__Close_Date__c                 = shipmentCloseDate,
                            Bit2Shop__Date__c = shipmentDate,
                            Bit2Shop__Shipped_Quantity__c = modelIdToProductSerial.get(model).size(),
                            Bit2Shop__Stock_Order_Id__c = stockOrderToCreate.Id,
                            Bit2Shop__Sub_Type__c = Plc_Constants.B2S_Shipment.B2S_Subtype_Inbound,
                            Bit2Shop__Type__c = Plc_Constants.B2S_Shipment.B2S_Type_Final,
                            Bit2Shop__Configuration_Item_Id__c = modelIdToConfigurationItem.get(model).Id,
                            Bit2Shop__Shipment_Document_Number__c = 'Doc_' + modelIdToConfigurationItem.get(model).Id,
                            OwnerId = stockOrderToCreate.OwnerId
                    );
                    System.debug('Plc_GoodsHandlingCnt modelIdToProductSerial.get(model).size(): ' + modelIdToProductSerial.get(model).size());
                    shipmentsToCreate.add(shipmentInbound);
                    modelIdToShipmentInbound.put(model, shipmentInbound);
                }
                System.debug('shipmentsToCreate: ' + shipmentsToCreate);
                insert shipmentsToCreate;

                //creo lo shipment line item di tipo prodotto, uno per ogni modello di prodotto a seriale
                Map<Id, Bit2Shop__Shipment_Line_Item__c> modelIdToShipmentLineItem = new Map<Id, Bit2Shop__Shipment_Line_Item__c>();
                Map<Id, Bit2Shop__Shipment_Line_Item__c> modelIdToShipmentLineItemInbound = new Map<Id, Bit2Shop__Shipment_Line_Item__c>();
                List<Bit2Shop__Shipment_Line_Item__c> shipmentLineItemsToCreate = new List<Bit2Shop__Shipment_Line_Item__c>();

                //recupero tutti i product stock nel warehouse di destinazione che esitono rispetto ai modelli selezionati
                List<Bit2Shop__Product_Stock__c> productStockInDestinationForSerial = [SELECT Id, Bit2Shop__External_Catalog_Item_Id__c FROM Bit2Shop__Product_Stock__c WHERE Bit2Shop__Warehouse_Id__c = :stockOrderToCreate.Bit2Shop__Destination_Warehouse_Id__c AND Bit2Shop__External_Catalog_Item_Id__c IN:modelIdToProductSerial.keySet()];
                System.debug('productStockInDestinationForSerial: ' + productStockInDestinationForSerial);
                //li raggruppo per modello
                Map<Id, List<Bit2Shop__Product_Stock__c>> modelIdToProductStockInDestinationForSerial = new Map<Id, List<Bit2Shop__Product_Stock__c>>();
                for (Bit2Shop__Product_Stock__c pS : productStockInDestinationForSerial) {
                    if (modelIdToProductStockInDestinationForSerial.containsKey(pS.Bit2Shop__External_Catalog_Item_Id__c)) {
                        modelIdToProductStockInDestinationForSerial.get(pS.Bit2Shop__External_Catalog_Item_Id__c).add(pS);
                    } else {
                        modelIdToProductStockInDestinationForSerial.put(pS.Bit2Shop__External_Catalog_Item_Id__c, new List<Bit2Shop__Product_Stock__c>());
                        modelIdToProductStockInDestinationForSerial.get(pS.Bit2Shop__External_Catalog_Item_Id__c).add(pS);
                    }
                }
                System.debug('modelIdToProductStockInDestinationForSerial: ' + modelIdToProductStockInDestinationForSerial);
                //creo i product stock che non esistono
                Map<Id, String> modelIdToModelNameProductStockToCreate = new Map<Id, String>();
                for (Id model : modelIdToProductSerial.keySet()) {
                    if (!modelIdToProductStockInDestinationForSerial.containsKey(model)) {
                        modelIdToModelNameProductStockToCreate.put(model, modelIdToProductSerial.get(model).get(0).Bit2Shop__Product_Stock_Id__r.Name);
                    }
                }
                List<Bit2Shop__Product_Stock__c> productStockCreated = createProductStock(modelIdToModelNameProductStockToCreate, stockOrderToCreate.Bit2Shop__Destination_Warehouse_Id__c, 0);
                for (Bit2Shop__Product_Stock__c pS : productStockCreated) {
                    modelIdToProductStockInDestinationForSerial.put(pS.Bit2Shop__External_Catalog_Item_Id__c, new List<Bit2Shop__Product_Stock__c>());
                    modelIdToProductStockInDestinationForSerial.get(pS.Bit2Shop__External_Catalog_Item_Id__c).add(pS);
                }

                System.debug('modelIdToProductSerial >> ' + modelIdToProductSerial);

                //FB 18-06-2019: Optmizing [START]
                String recordTypeSliProduct = Plc_Utils.getRecordTypeId(Plc_Constants.B2S_ShipmentLineItem.RecordType_Product, Bit2Shop__Shipment_Line_Item__c.SObjectType.getDescribe().name);
                String recordTypeSliSerial = Plc_Utils.getRecordTypeId(Plc_Constants.B2S_ShipmentLineItem.RecordType_Serial, Bit2Shop__Shipment_Line_Item__c.SObjectType.getDescribe().name);
                //FB 18-06-2019: Optmizing [END]
                
                for (Id model : modelIdToProductSerial.keySet()) {
                    //outbound
                    Bit2Shop__Shipment_Line_Item__c sli = new Bit2Shop__Shipment_Line_Item__c(
                            RecordTypeId = recordTypeSliProduct,
                            Bit2Shop__Type__c = Plc_Constants.B2S_ShipmentLineItem.B2S_Type_Product,
                            Bit2Shop__Status__c = sliStatus,
                            Bit2Shop__Requested_Quantity__c = modelIdToProductSerial.get(model).size(),
                            Bit2Shop__Transfer_Detail_Id__c = stockOrderToCreate.Plc_TransferDetail__c,
                            Bit2Shop__Date__c               = sliDate,
                            //Bit2Shop__Received_Quantity__c  = modelIdToShipment.get(model).Bit2Shop__Shipped_Quantity__c,
                            Bit2Shop__Shipment_Id__c = modelIdToShipment.get(model).Id,
                            Bit2Shop__Product_Stock_Id__c = modelIdToProductSerial.get(model).get(0).Bit2Shop__Product_Stock_Id__c
                    );
                    shipmentLineItemsToCreate.add(sli);
                    modelIdToShipmentLineItem.put(model, sli);

                    //inbound
                    Bit2Shop__Shipment_Line_Item__c sliInbound = new Bit2Shop__Shipment_Line_Item__c(
                            RecordTypeId = recordTypeSliProduct,
                            Bit2Shop__Type__c = Plc_Constants.B2S_ShipmentLineItem.B2S_Type_Product,
                            Bit2Shop__Status__c = sliStatus,
                            Bit2Shop__Requested_Quantity__c = modelIdToProductSerial.get(model).size(),
                            Bit2Shop__Transfer_Detail_Id__c = stockOrderToCreate.Plc_TransferDetail__c,
                            Bit2Shop__Date__c               = sliDate,
                            Bit2Shop__Received_Quantity__c  = toClose ? modelIdToProductSerial.get(model).size() : null,
                            Bit2Shop__Shipment_Id__c = modelIdToShipmentInbound.get(model).Id,
                            Bit2Shop__Product_Stock_Id__c = modelIdToProductStockInDestinationForSerial.get(model).get(0).Id
                    );
                    shipmentLineItemsToCreate.add(sliInbound);
                    modelIdToShipmentLineItemInbound.put(model, sliInbound);
                }
                System.debug('Plc_GoodsHandlingCnt shipmentLineItemsToCreate: ' + shipmentLineItemsToCreate);
                insert shipmentLineItemsToCreate;

                //creo gli Shipment line items di tipo Serial, uno per ogni prodotto a seriale
                List<Bit2Shop__Shipment_Line_Item__c> shipmentLineItemsSerialToCreate = new List<Bit2Shop__Shipment_Line_Item__c>();
                for (Id model : modelIdToProductSerial.keySet()) {
                    for (Bit2Shop__Stock_Serials2__c pS : modelIdToProductSerial.get(model)) {
                        //Outbound
                        Bit2Shop__Shipment_Line_Item__c sli = new Bit2Shop__Shipment_Line_Item__c(
                                RecordTypeId = recordTypeSliSerial,
                                Bit2Shop__Type__c = Plc_Constants.B2S_ShipmentLineItem.B2S_Type_Serial,
                                Bit2Shop__Status__c = sliStatus,
                                Bit2Shop__Transfer_Detail_Id__c = stockOrderToCreate.Plc_TransferDetail__c,
                                Bit2Shop__Date__c               = sliDate,
                                //Bit2Shop__Received_Quantity__c  = 1,
                                Bit2Shop__Shipment_Id__c = modelIdToShipment.get(model).Id,
                                Bit2Shop__Product_Stock_Id__c = pS.Bit2Shop__Product_Stock_Id__c,
                                Bit2Shop__Target_Line_Item__c = modelIdToShipmentLineItem.get(model).Id,
                                Bit2Shop__Requested_Quantity__c = 1,
                                Bit2Shop__Received_Status__c = sliReceivedStatus,
                                Plc_StockSerial__c = pS.Id
                        );
                        shipmentLineItemsSerialToCreate.add(sli);

                        //Inbound
                        Bit2Shop__Shipment_Line_Item__c sliInbound = new Bit2Shop__Shipment_Line_Item__c(
                                RecordTypeId = recordTypeSliSerial,
                                Bit2Shop__Type__c = Plc_Constants.B2S_ShipmentLineItem.B2S_Type_Serial,
                                Bit2Shop__Status__c = sliStatus,
                                Bit2Shop__Transfer_Detail_Id__c = stockOrderToCreate.Plc_TransferDetail__c,
                                Bit2Shop__Date__c               = sliDate,
                                Bit2Shop__Received_Quantity__c  = toClose ? 1 : null,
                                Bit2Shop__Shipment_Id__c = modelIdToShipmentInbound.get(model).Id,
                                Bit2Shop__Product_Stock_Id__c = modelIdToProductStockInDestinationForSerial.get(model).get(0).Id,
                                Bit2Shop__Target_Line_Item__c = modelIdToShipmentLineItemInbound.get(model).Id,
                                Bit2Shop__Requested_Quantity__c = 1,
                                Bit2Shop__Received_Status__c = sliReceivedStatus,
                                Plc_StockSerial__c = pS.Id
                        );
                        shipmentLineItemsSerialToCreate.add(sliInbound);
                    }
                }
                System.debug('Plc_GoodsHandlingCnt shipmentLineItemsSerialToCreate: ' + shipmentLineItemsSerialToCreate);
                insert shipmentLineItemsSerialToCreate;

                addProductStockLookupToShipment(stockOrderToCreate.Id);
            }catch(Exception ex){
                Database.rollback(sp);
                throw new Plc_Exception(ex,'');
            }

        }

        public void createProductQuantityStructure(List<Bit2Shop__Product_Stock__c> selectedProductQuantity, NE__Order__c configurationToCreate, Bit2Shop__StockOrder__c stockOrderToCreate,Boolean toClose) {
            // Parametri per gestione catena chiusa o aperta
            String configurationItemStatus = Plc_Constants.NE_OrderItem.NE_Status_Pending;
            String shipmentStatus = Plc_Constants.B2S_Shipment.B2S_Status_Pending;
            Date shipmentDate = null;
            Date shipmentCloseDate = null;
            String sliStatus = Plc_Constants.B2S_ShipmentLineItem.B2S_Status_Pending;
            Date sliDate = null;
            if(toClose) {
                configurationItemStatus = Plc_Constants.NE_OrderItem.NE_Status_Completed;
                shipmentStatus = Plc_Constants.B2S_Shipment.B2S_Status_Closed;
                shipmentDate = System.today();
                shipmentCloseDate = System.today();
                sliStatus = Plc_Constants.B2S_ShipmentLineItem.B2S_Status_Closed;
                sliDate = System.today();
            }
            
            //creo un configuration item per ogni prodotto a quantità
            Map<Id, NE__OrderItem__c> productIdToConfigurationItem = new Map<Id, NE__OrderItem__c>();
            List<NE__OrderItem__c> otherConfigurationsItemToCreate = new List<NE__OrderItem__c>();
            for (Bit2Shop__Product_Stock__c pS : selectedProductQuantity) {
                NE__OrderItem__c configurationItem = new NE__OrderItem__c(
                        RecordTypeId = Plc_Utils.getRecordTypeId(Plc_Constants.NE_OrderItem.RecordType_Standard,
                                NE__OrderItem__c.SObjectType.getDescribe().name),
                        NE__OrderId__c = configurationToCreate.Id,
                        NE__Qty__c = 1,
                        NE__Status__c = configurationItemStatus,
                        NE__Account__c = stockOrderToCreate.Bit2Shop__Holding_Id__c,
                        Bit2Shop__Required_Serial__c = false
                );
                otherConfigurationsItemToCreate.add(configurationItem);
                productIdToConfigurationItem.put(pS.Id, configurationItem);
            }
            insert otherConfigurationsItemToCreate;

            //creo uno shipment per ogni prodotto a quantità
            Map<Id, Bit2Shop__Shipment__c> productIdToShipment = new Map<Id, Bit2Shop__Shipment__c>();
            Map<Id, Bit2Shop__Shipment__c> productIdToShipmentInbound = new Map<Id, Bit2Shop__Shipment__c>();
            List<Bit2Shop__Shipment__c> otherShipmentsToCreate = new List<Bit2Shop__Shipment__c>();
            for (Bit2Shop__Product_Stock__c pS : selectedProductQuantity) {
                //outbound
                Bit2Shop__Shipment__c shipment = new Bit2Shop__Shipment__c(
                        RecordTypeId = Plc_Utils.getRecordTypeId(Plc_Constants.B2S_Shipment.RecordType_OutboundShipment,
                                Bit2Shop__Shipment__c.SObjectType.getDescribe().name),
                        Bit2Shop__Status__c = shipmentStatus,
                        //Bit2Shop__Expected_Delivery_Date__c     = endDate,
                        Bit2Shop__Close_Date__c                 = shipmentCloseDate,
                        Bit2Shop__Date__c = shipmentDate,
                        Bit2Shop__Shipped_Quantity__c = pS.Bit2Shop__Shipped_Qty__c,
                        Bit2Shop__Stock_Order_Id__c = stockOrderToCreate.Id,
                        Bit2Shop__Sub_Type__c = Plc_Constants.B2S_Shipment.B2S_Subtype_Outbound,
                        Bit2Shop__Type__c = Plc_Constants.B2S_Shipment.B2S_Type_Final,
                        Bit2Shop__Configuration_Item_Id__c = productIdToConfigurationItem.get(pS.Id).Id,
                        Bit2Shop__Shipment_Document_Number__c = 'Doc_' + productIdToConfigurationItem.get(pS.Id).Id,
                        OwnerId = stockOrderToCreate.OwnerId
                );
                otherShipmentsToCreate.add(shipment);
                productIdToShipment.put(pS.Id, shipment);

                //inbound
                Bit2Shop__Shipment__c shipmentInbound = new Bit2Shop__Shipment__c(
                        RecordTypeId = Plc_Utils.getRecordTypeId(Plc_Constants.B2S_Shipment.RecordType_InboundShipment,
                                Bit2Shop__Shipment__c.SObjectType.getDescribe().name),
                        Bit2Shop__Status__c = shipmentStatus,
                        //Bit2Shop__Expected_Delivery_Date__c     = endDate,
                        Bit2Shop__Close_Date__c                 = shipmentCloseDate,
                        Bit2Shop__Date__c = shipmentDate,
                        Bit2Shop__Shipped_Quantity__c = pS.Bit2Shop__Shipped_Qty__c,
                        Bit2Shop__Stock_Order_Id__c = stockOrderToCreate.Id,
                        Bit2Shop__Sub_Type__c = Plc_Constants.B2S_Shipment.B2S_Subtype_Inbound,
                        Bit2Shop__Type__c = Plc_Constants.B2S_Shipment.B2S_Type_Final,
                        Bit2Shop__Configuration_Item_Id__c = productIdToConfigurationItem.get(pS.Id).Id,
                        Bit2Shop__Shipment_Document_Number__c = 'Doc_' + productIdToConfigurationItem.get(pS.Id).Id,
                        OwnerId = stockOrderToCreate.OwnerId
                );
                otherShipmentsToCreate.add(shipmentInbound);
                productIdToShipmentInbound.put(pS.Id, shipmentInbound);
            }
            System.debug('otherShipmentsToCreate: ' + otherShipmentsToCreate);
            insert otherShipmentsToCreate;

            //creo lo Shipment line items di tipo Prodotto, uno per ogni prodotto a quantità
            List<Bit2Shop__Shipment_Line_Item__c> shipmentLineItemsQuantityToCreate = new List<Bit2Shop__Shipment_Line_Item__c>();

            //recupero tutti i product stock nel warehouse di destinazione che esitono rispetto ai modelli selezionati
            Map<Id, String> modelIdToModelNameForProductQuantitySelected = new Map<Id, String>();
            for (Bit2Shop__Product_Stock__c pS : selectedProductQuantity) {
                modelIdToModelNameForProductQuantitySelected.put(pS.Bit2Shop__External_Catalog_Item_Id__c, pS.Name);
            }
            List<Bit2Shop__Product_Stock__c> productStockInDestinationForQuantity = [SELECT Id, Bit2Shop__External_Catalog_Item_Id__c FROM Bit2Shop__Product_Stock__c WHERE Bit2Shop__Warehouse_Id__c = :stockOrderToCreate.Bit2Shop__Destination_Warehouse_Id__c AND Bit2Shop__External_Catalog_Item_Id__c IN:modelIdToModelNameForProductQuantitySelected.keySet()];
            System.debug('productStockInDestinationForQuantity: ' + productStockInDestinationForQuantity);
            //li raggruppo per modello
            Map<Id, List<Bit2Shop__Product_Stock__c>> modelIdToProductStockInDestinationForQuantity = new Map<Id, List<Bit2Shop__Product_Stock__c>>();
            for (Bit2Shop__Product_Stock__c pS : productStockInDestinationForQuantity) {
                if (modelIdToProductStockInDestinationForQuantity.containsKey(pS.Bit2Shop__External_Catalog_Item_Id__c)) {
                    modelIdToProductStockInDestinationForQuantity.get(pS.Bit2Shop__External_Catalog_Item_Id__c).add(pS);
                } else {
                    modelIdToProductStockInDestinationForQuantity.put(pS.Bit2Shop__External_Catalog_Item_Id__c, new List<Bit2Shop__Product_Stock__c>());
                    modelIdToProductStockInDestinationForQuantity.get(pS.Bit2Shop__External_Catalog_Item_Id__c).add(pS);
                }
            }
            System.debug('modelIdToProductStockInDestinationForQuantity: ' + modelIdToProductStockInDestinationForQuantity);

            //creo i product stock che non esistono
            Map<Id, String> modelIdToModelNameProductStockToCreate = new Map<Id, String>();
            for (Id model : modelIdToModelNameForProductQuantitySelected.keySet()) {
                if (!modelIdToProductStockInDestinationForQuantity.containsKey(model)) {
                    modelIdToModelNameProductStockToCreate.put(model, modelIdToModelNameForProductQuantitySelected.get(model));
                }
            }
            List<Bit2Shop__Product_Stock__c> productStockCreated = createProductStock(modelIdToModelNameProductStockToCreate, stockOrderToCreate.Bit2Shop__Destination_Warehouse_Id__c, 0);
            for (Bit2Shop__Product_Stock__c pS : productStockCreated) {
                modelIdToProductStockInDestinationForQuantity.put(pS.Bit2Shop__External_Catalog_Item_Id__c, new List<Bit2Shop__Product_Stock__c>());
                modelIdToProductStockInDestinationForQuantity.get(pS.Bit2Shop__External_Catalog_Item_Id__c).add(pS);
            }


            for (Bit2Shop__Product_Stock__c pS : selectedProductQuantity) {
                //Outbound
                Bit2Shop__Shipment_Line_Item__c sli = new Bit2Shop__Shipment_Line_Item__c(
                        RecordTypeId = Plc_Utils.getRecordTypeId(Plc_Constants.B2S_ShipmentLineItem.RecordType_Product,
                                Bit2Shop__Shipment_Line_Item__c.SObjectType.getDescribe().name),
                        Bit2Shop__Type__c = Plc_Constants.B2S_ShipmentLineItem.B2S_Type_Product,
                        Bit2Shop__Status__c = sliStatus,
                        Bit2Shop__Transfer_Detail_Id__c = stockOrderToCreate.Plc_TransferDetail__c,
                        Bit2Shop__Date__c               = sliDate,
                        //Bit2Shop__Received_Quantity__c  = pS.Bit2Shop__Shipped_Qty__c,
                        Bit2Shop__Shipment_Id__c = productIdToShipment.get(pS.Id).Id,
                        Bit2Shop__Requested_Quantity__c = pS.Bit2Shop__Shipped_Qty__c,
                        Bit2Shop__Product_Stock_Id__c = pS.Id
                        //Bit2Shop__Target_Line_Item__c   = modelIdToShipmentLineItem.get(model).Id,
                        //Plc_StockSerial__c              = pS.Id
                );
                shipmentLineItemsQuantityToCreate.add(sli);

                //Inbound
                Bit2Shop__Shipment_Line_Item__c sliInbound = new Bit2Shop__Shipment_Line_Item__c(
                        RecordTypeId = Plc_Utils.getRecordTypeId(Plc_Constants.B2S_ShipmentLineItem.RecordType_Product,
                                Bit2Shop__Shipment_Line_Item__c.SObjectType.getDescribe().name),
                        Bit2Shop__Type__c = Plc_Constants.B2S_ShipmentLineItem.B2S_Type_Product,
                        Bit2Shop__Status__c = sliStatus,
                        Bit2Shop__Transfer_Detail_Id__c = stockOrderToCreate.Plc_TransferDetail__c,
                        Bit2Shop__Date__c               = sliDate,
                        Bit2Shop__Received_Quantity__c  = toClose ? pS.Bit2Shop__Shipped_Qty__c : null,
                        Bit2Shop__Shipment_Id__c = productIdToShipmentInbound.get(pS.Id).Id,
                        Bit2Shop__Requested_Quantity__c = pS.Bit2Shop__Shipped_Qty__c,
                        Bit2Shop__Product_Stock_Id__c = modelIdToProductStockInDestinationForQuantity.get(pS.Bit2Shop__External_Catalog_Item_Id__c).get(0).Id
                        //Bit2Shop__Target_Line_Item__c   = modelIdToShipmentLineItem.get(model).Id,
                        //Plc_StockSerial__c              = pS.Id
                );
                shipmentLineItemsQuantityToCreate.add(sliInbound);
            }
            insert shipmentLineItemsQuantityToCreate;

            addProductStockLookupToShipment(stockOrderToCreate.Id);
        }

        public List<Bit2Shop__Product_Stock__c> createProductStock(Map<Id, String> modelIdToModelNameProductStockToCreate, Id warehouse, Integer quantity) {
            System.debug('Plc_UtilityShipmentCreation createProductStock start');
            List<Bit2Shop__Product_Stock__c> productStockToCreate = new List<Bit2Shop__Product_Stock__c>();

            List<B2WExtCat__External_Catalog_Item__c> externalcatalog = [
                    SELECT Id,B2WExtCat__External_Catalog_Item_Name__c
                    FROM B2WExtCat__External_Catalog_Item__c
                    WHERE Id IN :modelIdToModelNameProductStockToCreate.keySet()
            ];
            Map<Id, String> catalogIdNameMap = new Map<Id, String>();

            for (B2WExtCat__External_Catalog_Item__c ext : externalcatalog) {
                catalogIdNameMap.put(ext.Id, ext.B2WExtCat__External_Catalog_Item_Name__c);
            }

            System.debug('catalogIdNameMap >> ' + catalogIdNameMap);

            for (Id i : modelIdToModelNameProductStockToCreate.keySet()) {
                Bit2Shop__Product_Stock__c newPS = new Bit2Shop__Product_Stock__c();
                newPS.Name = catalogIdNameMap.get(i);
                newPS.Bit2Shop__External_Catalog_Item_Id__c = i;
                newPS.Bit2Shop__Warehouse_Id__c = warehouse;
                newPS.Bit2Shop__Stock_Qty__c = 0;
                productStockToCreate.add(newPS);

                System.debug('newPS >> ' + newPS);
            }

            insert productStockToCreate;
            return productStockToCreate;
        }

        public Boolean addProductStockLookupToShipment(String stockOrderId) {
            System.debug('Plc_UtilityShipmentCreation::addProductStockLookupToStockOrder Invoked');

            try {
                List<Bit2Shop__Shipment_Line_Item__c> sliList = [
                        SELECT Id,
                                Bit2Shop__Shipment_Id__c,
                                Bit2Shop__Product_Stock_Id__c
                        FROM Bit2Shop__Shipment_Line_Item__c
                        WHERE Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__c = :stockOrderId
                ];

                Map<Id, Bit2Shop__Shipment__c> shipmentsToUpdate = new Map<Id, Bit2Shop__Shipment__c>();
                for (Bit2Shop__Shipment_Line_Item__c sli : sliList) {

                    shipmentsToUpdate.put(sli.Bit2Shop__Shipment_Id__c, new Bit2Shop__Shipment__c(Id = sli.Bit2Shop__Shipment_Id__c,
                            Plc_ProductStock__c = sli.Bit2Shop__Product_Stock_Id__c)
                    );
                }

                System.debug('shipmentsToUpdate >> ' + shipmentsToUpdate);
                update shipmentsToUpdate.values();
                return true;

            } catch (Exception e) {

                String errorMessage = 'Error in : ' + e.getMessage() + ' at line: ' + e.getLineNumber() + ' stack trace: ' + e.getStackTraceString();
                System.debug(errorMessage);
                return false;
            }

        }

    }


}