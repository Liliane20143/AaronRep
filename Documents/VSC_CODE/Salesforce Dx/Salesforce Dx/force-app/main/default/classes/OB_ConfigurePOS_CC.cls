public without sharing class OB_ConfigurePOS_CC { 

/*
    @Author     :    Morittu Andrea
    @Date       :      2019.05.07
    @Task       :      ID_Stream_6_Subentro
    @History    :  02-Aug-2019 - Removing query on configuration item.§
                    Return old asset (For let them be migrated)
*/


    @AuraEnabled
    //public static List<NE__OrAssderItem__c> getOldAssetServer (String offerAssetId) {
    public static List<Asset> getOldAssetServer (String offerAssetId) {
        System.debug('INSIDE OB_ConfigurePOS_CC.getOldAssetServer');
        List<NE__OrderItem__c> oldItems = new List<NE__OrderItem__c>();
        List<Asset> oldConfigurationId = new List<Asset>();
        if(!String.isBlank(offerAssetId))  {
            oldConfigurationId = [SELECT  Id, 
                                Name, 
                                NE__Order_Config__c, 
                                NE__Bundle_Configuration__c, 
                                NE__ProdId__r.RecordType.DeveloperName, 
                                NE__Status__c, 
                                OB_TermId__c,
                                NE__StartDate__c
                        FROM    Asset 
                        WHERE   NE__Bundle_Configuration__c  =: offerAssetId                        
                        AND     NE__ProdId__r.RecordType.DeveloperName = 'Terminali'
                        AND     NE__Status__c = 'Active' // ANDREA MORITTU - 02-Aug-2019 --> Change Status FROM != null TO == 'Active'
                        AND     NE__StartDate__c != null ];
                        
            
            /*if(!oldConfigurationId.isEmpty()) {
                String oldOrderId = oldConfigurationId.get(0).NE__Order_Config__c;
                oldItems = [SELECT  Id, 
                                    Name, 
                                    NE__ProdId__r.RecordType.DeveloperName,
                                    NE__ProdId__r.Name, 
                                    NE__Status__c, 
                                    NE__StartDate__c,
                                    OB_TermId__c
                            FROM    NE__OrderItem__c 
                            WHERE   NE__OrderId__c =: oldOrderId
                            AND     NE__ProdId__r.RecordType.DeveloperName = 'Terminali'
                            AND     NE__Status__c = 'Active' 
                            AND     NE__StartDate__c != null ];
            }*/
        }
        //return oldItems;
        return oldConfigurationId;
    }

/*
    @Author:    Gandini Daniele
    @Date:      2019.05.21
    @Task:      Sostituzione
*/
    @AuraEnabled
    public static List<String> getShowPosReplacement(List<String> idOrderItemList){
        List<String> idList = new  List<String>();
        List<NE__OrderItem__c> orderItemList = [SELECT Id, NE__ProdId__r.OB_Codice_sfdc__c 
                                                FROM NE__OrderItem__c
                                                WHERE Id IN :idOrderItemList
                                                AND NE__ProdId__r.OB_Codice_sfdc__c = :OB_UtilityCOnstants.M_POS];

        System.debug('orderItemList: ' + orderItemList);
        
        if(!orderItemList.isEmpty()){
            for(NE__OrderItem__c singleItem : orderItemList){
                idList.add(singleItem.Id);
            }
        }
        System.debug('idList: ' + idList);
        return idList;       
    }
}