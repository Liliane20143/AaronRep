/**
 * Created by dilorenzo on 22/01/2019.
 */
/**
 * Lightning component controller utility class for Plc_CustomLookup
 *
 * @author  Francesco Bigoni
 * @version 1.0
 * @description Contains a set of utilities used in order to simulate a lookup custom field
 * @testedIn  Plc_CustomLookupTest
 * @uses Plc_CustomLookup
 * @code
 * @history
 * 2018-06-21 : Francesco Bigoni - Original
 */
    public with sharing class Plc_CustomLookupCnt {
        
        /**
         * Method that retrieves a list of record based on given parameters
         *
         * @code 01
         *
         * @param  searchKeyWord    The string to compare with the name. The results names contain this specific string
         * @param  objectName       The name of the API object on which make the query
         * @param  additionalFields The additional fields to query on the given objects (The caller of the method must be sure that the selected object contains the
         *                          given fields)
         * @param  whereCondition   Additional where condition to filter more specific results
         *
         * @return                  A list of sObjects that matches the filters
         */
        @AuraEnabled
        public static Map<String, Object> fetchLookUpValues(String searchKeyWord, String objectName, List<String> additionalFieldsToQuery,
            												String whereCondition, Integer limitSize, Boolean searchWithSosl) {

            Map<String, Object> response = new Map<String, Object>();

            try {

                List<sObject> lstOfRecords = new List<sObject>();
                String sQuery;
                String searchKey;
                //If SOSL is enabled with the attrubite, then perform a SOSL search otherwise perform a SOQL query
                if(searchWithSosl){
                    if(String.isNotBlank(searchKeyWord) && searchKeyWord.length() >1){
                        searchKey = '*' + searchKeyWord + '*';
                        sQuery = 'FIND \'' + searchKey + '\' IN ALL FIELDS RETURNING ' + objectName + '(Id, Name' + (additionalFieldsToQuery.isEmpty() ? '' : ', ' + String.join(additionalFieldsToQuery, ', ')) +
                            + (String.isBlank(whereCondition)? '' : ' WHERE ' + whereCondition) + ')';
                        List<List<SObject>> searchList = Search.query(sQuery);
                        lstOfRecords = searchList[0];
                    }
                } else{
                    searchKey = '%' + searchKeyWord + '%';
                    // Create a Dynamic SOQL Query For Fetch Record List with arbitrary limit
                    sQuery =  'SELECT Id, Name' + (additionalFieldsToQuery.isEmpty() ? '' : ', ' + String.join(additionalFieldsToQuery, ', ')) +
                        ' FROM ' + ObjectName +
                        ' WHERE ' + (String.isBlank(whereCondition)? '' : whereCondition) +
                        ' LIMIT ' + limitSize;

                    lstOfRecords = Database.query(sQuery);
                }

                response.put('returnList', lstOfRecords);
                response.put('error', false);

            } catch(Exception e){

                response.put('error', true);
                response.put('errorMsg', '[ERR:CL-00D0102] ' + e.getMessage());
            }

            return response;
        }

        
        /**
         * Method that retrieves the specific record of a given Id. It is used if the record to show in the
         * CustomLookup component is fixed and based on an Id (initID attribute)
         *
         * @code 02
         *
         * @param  recordId   The id of the record to describe
         * @param  objectName The name of the API object on which make the query
         * @param  additionalFieldsToQuery Additional fields to get from query
         * @return            The sObject identified by the specific ID populated with the name
         */
        @AuraEnabled
        public static Map<String, Object> getRecordById(Id recordId, String objectName, List<String> additionalFieldsToQuery){

            Map<String, Object> response = new Map<String, Object>();
            List<sObject> returnList = new List<sObject>();

            try {
                String sQuery = 'SELECT Id, Name' + (additionalFieldsToQuery.isEmpty() ? '' : ', ' + String.join(additionalFieldsToQuery, ', ')) +
                    ' FROM ' + objectName +
                    ' WHERE Id = \'' + recordId + '\'';

                returnList = Database.query(sQuery);
                response.put('returnList', returnList);
                response.put('error', false);

            } catch(Exception e){
                response.put('error', true);
                response.put('errorMsg', '[ERR:CL-00D0202] ' + e.getMessage());
            }
            return response;
        }

    }