/**
 * ***************************************************************************************
 *     * @Author abdoulaye.diop@/webresults.it
 *     * @date  29/04/2019
 *     * @description Wizard Controller for Plc_OverallStockPercentageWgtCnt LW Component
 * ***************************************************************************************
 **/
public with sharing class Plc_OverallStockPercentageWgtCnt {
    
    /** 
     * @Author AD
     * @date  29/04/2019
     * @description Method used in order to calculate the percentage
     * @param none
     **/
    @AuraEnabled
    public static Map<String, String> getPercentage(String developerName){
        String pos = 'POS';
        String installed = Plc_Constants.B2S_StockSerials2.B2S_Status_Installed;
        String receivedFailure = Plc_Constants.B2S_StockSerials2.B2S_Status_ReceivedFailure;
        String decommissioned = Plc_Constants.B2S_StockSerials2.B2S_Status_Decommissioned;
        String toBeDecommissioned = Plc_Constants.B2S_StockSerials2.B2S_Status_ToBeDecommissioned;
        String tamperedWith = Plc_Constants.B2S_StockSerials2.B2S_Status_TamperedWith;
        String irrecoverable = Plc_Constants.B2S_StockSerials2.B2S_Status_Irrecoverable;
        String newStatus = Plc_Constants.B2S_StockSerials2.B2S_Status_New;
        String available = Plc_Constants.B2S_StockSerials2.B2S_Status_Available;
        String withdrawn = Plc_Constants.B2S_StockSerials2.B2S_Status_Withdrawn;
        String fittizio = '000_001';
        String percentuale999 = '999%';
        Map<String, String> response = new Map<String, String>();

        // calculate the percentage
        try {
            List<String> statusNumeratorList = new List<String>{installed,decommissioned,toBeDecommissioned,tamperedWith,irrecoverable,newStatus};
        
            Decimal numerator = Database.countQuery('SELECT COUNT() FROM Bit2Shop__Stock_Serials2__c WHERE Bit2Shop__Status__c NOT IN :statusNumeratorList AND Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Subcategory__c = :pos AND Bit2Shop__Warehouse_Id__r.Bit2Shop__Dealer_Id__r.Plc_Alias__c != :fittizio AND Bit2Shop__Warehouse_Id__r.Plc_IsActive__c != false AND (NOT Bit2Shop__Warehouse_Id__r.Plc_Alias__c LIKE :percentuale999)');
            System.debug('#### numerator '+ numerator);
            
            Decimal denominator = Database.countQuery('SELECT COUNT() FROM Bit2Shop__Stock_Serials2__c WHERE Bit2Shop__Status__c =: installed' +' AND Bit2Shop__Product_Stock_Id__r.Bit2Shop__External_Catalog_Item_Id__r.Plc_Subcategory__c = :pos');
            System.debug('#### denominator '+ denominator);

            if (denominator == 0) {
                response.put('percentage', 'error');
            } else {
                Decimal percent = (numerator / denominator)*100;
                system.debug(percent);
                /*system.debug('@@@@@ PECENT: '+percent);
                system.debug('@@@@@ NUMBER : '+numerator);
                system.debug('@@@@@ DEN: '+denominator);*/
                Decimal percentScale = percent.setScale(1);
                String percentage = String.valueOf(percentScale);
            	response.put('percentage', percentage);
            }
        } catch (Exception e) {
            System.debug('#### error '+ e.getMessage() + ' ' + e.getCause());
            response.put('percentage', 'error');
        }

        // get the report id
        try {
            List<Report> reports = [SELECT Id FROM Report WHERE DeveloperName = :developerName];
            System.debug('#### reports '+ JSON.serialize(reports));
            if (reports.isEmpty()) {
                response.put('reportId', null);
            } else {
                response.put('reportId', reports[0].Id+'');
            }            
        } catch (Exception e) {
            response.put('reportId', null);
            System.debug('#### error '+ e.getCause() + ' ' + e.getStackTraceString() + e.getMessage());
        }
        System.debug('#### response '+ JSON.serialize(response));
        return response;         
    }
}