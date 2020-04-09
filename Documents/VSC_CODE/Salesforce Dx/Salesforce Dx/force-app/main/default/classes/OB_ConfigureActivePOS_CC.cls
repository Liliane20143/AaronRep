public with sharing class OB_ConfigureActivePOS_CC {

    /*------------------------------------------------------------
    Author:        Daniele Gandini
    Company:       Accenture Tecnology
    Description:   Clone items under POS before the remove action
    Date:          09/05/2019
   ------------------------------------------------------------*/
    @AuraEnabled
	public static String getTerminalsId(String posId){
    System.debug('@@@ In config cls: ' + posId); 
        String terminalId;
        List <NE__OrderItem__c> terminalIdList = [SELECT    Id, OB_TermId__c
                                                            FROM 
                                                            NE__OrderItem__c
                                                            WHERE
                                                            Id = :posId];
        System.debug('@@@ terminalIdList' + terminalIdList);
        if(!terminalIdList.isEmpty() && !(terminalIdList.size()>1)){ 
            terminalId = terminalIdList[0].OB_TermId__c;
            System.debug('@@@ terminalIdList in return term ' + terminalId);
            return terminalId;
        }else{
            System.debug('@@@ terminalIdList in return null ' + terminalId);
            return null;
        }
    }
    /*******************************************************************************
    Purpose:  Cancel order method
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Andrea Saracini         14/05/2019      Created         Method
    ********************************************************************************/
    @AuraEnabled
    public static Boolean cancelOrderOperation(String orderId){ //21/06/19 francesca.ribezzi changing paramenter 
        Boolean toReturn = true;
        System.debug('### orderId: '+orderId);
        try{
            if (!String.isBlank(orderId)){
                NE.OrderSummaryButtonExtension.cancelButton(orderId);
            }
        } 
        catch (Exception e){
            System.debug('Exception: ' +e.getMessage() + ' at line ' + e.getLineNumber());
            toReturn = false;
        }
        return toReturn;
    }
}