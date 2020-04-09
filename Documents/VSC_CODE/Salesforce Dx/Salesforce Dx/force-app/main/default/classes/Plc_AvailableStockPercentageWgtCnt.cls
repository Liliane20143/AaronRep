/**
 * **************************************************************************************
 *     * @Author abdoulaye.diop@/webresults.it
 *     * @date  17/04/2019
 *     * @description Wizard Controller for Plc_AvailableStockPercentageWgt LW Component
 * **************************************************************************************
 **/
public with sharing class Plc_AvailableStockPercentageWgtCnt {

    /** 
     * @Author AD
     * @date  17/04/2019
     * @description Method used in order to get  all the POS serials for the status given
     * @param none
     **/
     
    @AuraEnabled()
    public static Map<String, String> getAllSerialsByStatusList(String developerName){
        Map<String, String> response = new Map<String, String>();
        Integer count = 0;
        String pos = 'POS';
        String installed = Plc_Constants.B2S_StockSerials2.B2S_Status_Installed;
        String available = Plc_Constants.B2S_StockSerials2.B2S_Status_Available;
        String withdrawn = Plc_Constants.B2S_StockSerials2.B2S_Status_Withdrawn;
        String fittizio = '000_001';
        String alias = '999%';

        // calculate the percentage
        try { 
            Decimal stockWithInstalled = Database.countQuery('SELECT COUNT() FROM Bit2Shop__Stock_Serials2__c WHERE Bit2Shop__Status__c = :installed AND' + 
                                                                ' Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Subcategory__c = :pos');

            Decimal stockExcludInstalled = Database.countQuery('SELECT COUNT() FROM Bit2Shop__Stock_Serials2__c WHERE (Bit2Shop__Status__c =:available OR '+
                                                               ' Bit2Shop__Status__c = :withdrawn) AND Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Subcategory__c =:pos AND '+
                                                               ' Bit2Shop__Warehouse_Id__r.Plc_IsActive__c != false AND'+                                                                    
                                                               ' Bit2Shop__Product_Stock_Id__c NOT IN ( SELECT ID from Bit2Shop__Product_Stock__c WHERE Bit2Shop__Warehouse_Id__r.Plc_Alias__c LIKE :alias OR Bit2Shop__Warehouse_Id__r.Plc_Alias__c =: fittizio)');
            
            if (stockWithInstalled == 0) {
                response.put('percentage', 'error');
            } else {
                Decimal percent =   (stockExcludInstalled / stockWithInstalled)*100;
                Decimal percentScale = percent.setScale(1);
                String percentage = String.valueOf(percentScale);
                //percentage = '123.9';
            	response.put('percentage', percentage);
            }
        } catch (Exception e) {
            response.put('percentage', 'error');
            System.debug('#### error '+ e.getMessage() + ' ' + e.getCause());
        }

        // get the report id
        try {
            List<Report> reports = [SELECT Id FROM Report WHERE DeveloperName = :developerName];
            if (reports.isEmpty()) {
                response.put('reportId', null);
            } else {
                response.put('reportId', reports[0].Id+'');
            }            
        } catch (Exception e) {
            response.put('reportId', null);
            System.debug('#### error '+ e.getCause() + ' ' + e.getStackTraceString() + e.getMessage());
        }
        System.debug('response: ' + response);
        return response;  
    }
}