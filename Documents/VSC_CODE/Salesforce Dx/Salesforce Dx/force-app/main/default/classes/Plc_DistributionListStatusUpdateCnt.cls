/** 
 * @author Andrea Motta
 * @author FB
 * @date Creation 18/12/2018 
 * @description Plc_DistributionListStatusUpdateCnt - Apex controller for lightning component Plc_DistributionListStatusUpdate
 * @errorcode [ERR:CL-031YYZZ]
 *
 * 2019-03-05 FB - Refactoring and adding new logics such as data rollback
 * 
 */
public without sharing class Plc_DistributionListStatusUpdateCnt {

    /**
     * @author Andrea Motta
     * @author FB
     * @date Creation 18/12/2018
     * @version 1.0
     * @description Update distribution list status
     */
    @AuraEnabled
    public static Map<String, Object> updateStatus(Id dlId) {
        
        Map<String, Object> response = new Map<String, Object>();        
        Map<String, String> statusPicklistValuesMap = retrieveActivePickListValues('Plc_DistributionList__c', 'Plc_Status__c');
        response.put('error', false);
        Savepoint sp = Database.setSavepoint();

        try {

            if(FeatureManagement.checkPermission(Plc_Constants.CustomPermission.PlcConfirmDistributionList) ) {
                Plc_DistributionList__c dl = [SELECT Id, Plc_Status__c 
                                              FROM Plc_DistributionList__c 
                                              WHERE Id = :dlId LIMIT 1];

                if (dl.Plc_Status__c  == 'Closed') {

                    response.put('error', true);
                    response.put('errorMsg', Label.Plc_LightningComponentDistributionListStatusUpdateKoStatusTransition
                                             .replace('{0}', '\'' + statusPicklistValuesMap.get('Closed') + '\'')
                                             .replace('{1}', '\'' + statusPicklistValuesMap.get('Requested') + '\''));
                } else if (dl.Plc_Status__c  == 'Requested') {

                    response.put('error', true);
                    response.put('errorMsg', Label.Plc_LightningComponentDistributionListStatusUpdateKoAlreadyRequested
                                             .replace('{0}', '\'' + statusPicklistValuesMap.get('Requested') + '\''));
                } else {
                    //Getting distribution list items
                    List<Plc_DistributionListItem__c> dliToUpdate = retrieveDistributionListItems(dl.Id);

                    if(!dliToUpdate.isEmpty()) {

                        //Iterating on distribution list items
                        for(Plc_DistributionListItem__c dli : dliToUpdate) {

                            //Setting new status
                            dli.Plc_Status__c = 'Requested';
                            //Setting origin dealer according to item warehouse
                            if (dli.Plc_OriginWarehouse__c != null) {

                                if (dli.Plc_OriginWarehouse__r.Bit2Shop__Dealer_Id__c != null) {
                                    dli.Plc_OriginDealer__c = dli.Plc_OriginWarehouse__r.Bit2Shop__Dealer_Id__c;
                                } else {
                                    throw new Plc_Exception('Unable to set origin dealer because the related field is null on record [' + dli.Plc_OriginWarehouse__c + ']');
                                }
                                
                            } else {
                                throw new Plc_Exception('Unable to set origin dealer because the related field is null on record [' + dli.Id +']');
                            }
                        }

                        update dliToUpdate;
                        //Update distribution list status to Requested
                        dl.Plc_Status__c = 'Requested';
                        update dl;

                    } else {
                        throw new Plc_Exception(Label.Plc_LightningComponentDistributionListStatusUpdateKoNoDraftItemFound);
                    }
                }
            } else {
                throw new Plc_Exception(Label.Plc_AllAllUserForbiddenOperation);
            }
            
        } catch(Exception e) {
            Database.rollback(sp);
            response.put('error', true);
            response.put('errorMsg', '[ERR:CL-0310101] ' + e.getMessage());
        }
        return response;
    }

    /**
     * @author Andrea Motta
     * @date Creation 21/12/2018
     * @version 1.0
     * @description Get distribution list items related to the distribution list
     */
    private static List<Plc_DistributionListItem__c> retrieveDistributionListItems(Id dlId) {

        List<Plc_DistributionListItem__c> dliList = [SELECT Id, Plc_Product__c, Plc_RequestedQty__c, Plc_DestinationWarehouse__c, Plc_OriginWarehouse__c,
                                                            Plc_OriginWarehouse__r.Bit2Shop__Dealer_Id__c
                                                     FROM Plc_DistributionListItem__c 
                                                     WHERE Plc_DistributionList__c = :dlId AND
                                                           Plc_Status__c = 'Draft'];
        return dliList;
    }

    /**
     * Retrieves a map containing the picklist values of specified field/object
     *
     * @param  sObjectType Name of object from which getting the field
     * @param  fieldName   Name of the field from which getting values
     * @return             Map containing pairs picklist values Api Name/Label
     */
    private Static Map<String, String> retrieveActivePickListValues(String sObjectType, 
                                                                    String fieldName) {

        Map<String, String> picklistMapToReturn = new Map<String, String>();
        Schema.DescribeFieldResult objectFieldMap = Schema.getGlobalDescribe()
                                                    .get(sObjectType)
                                                    .getDescribe()
                                                    .fields.getMap()
                                                    .get(fieldName)
                                                    .getDescribe();

        for (Schema.PicklistEntry picklistEntry : objectFieldMap.getPicklistValues()) {
            if (picklistEntry.isActive()) {
                picklistMapToReturn.put(picklistEntry.getValue(), picklistEntry.getLabel());
            }
        }
        return picklistMapToReturn;
    }
}