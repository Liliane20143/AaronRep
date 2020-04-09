/*------------------------------------------------------------ 
Author:         Davide Franzini
Company:        Accenture Technology
Description:    Configure Matrix Parameter Row Saleability
Inputs:         
History:        
<Date>          <Authors Name>      <Brief Description of Change>
------------------------------------------------------------*/
public without sharing class OB_MPR_Saleability_CC {

    @AuraEnabled
    public static ABIresults getAvailableABI(String offerId){
        Map<String,String> abiMap = new Map<String,String>();
        List<String> activeAbiList = new List<String>();
        List<String> availableAbiList = new List<String>();
        Map<String,String> activeABIMap = new Map<String,String>();
        Map<String,String> availableABIMap = new Map<String,String>();
        ABIresults abiRes = new ABIresults();

        //davide.franzini - F2WAVE2-108 - query changed on MP -  START
        AggregateResult[] offerGroupedResults = [SELECT OB_ABI__c 
                                            FROM NE__Matrix_Parameter__c 
                                            WHERE OB_Offerta__c = :offerId 
                                                AND RecordType.DeveloperName = 'OB_PriceBankABI'
                                            GROUP BY OB_ABI__c];
        
        for (AggregateResult ar : offerGroupedResults){
            System.debug('### agg result activeAbi: ' + ar.get('OB_ABI__c'));
            String abi = (String)ar.get('OB_ABI__c');
            if(abi != null && abi != ''){
                activeAbiList.add(abi);
            }
            abiMap.put(abi,abi);
        }
        //davide.franzini - F2WAVE2-108 - query changed on MP -  END

        AggregateResult[] accountGroupedResults = [SELECT Name, 
                                                    OB_ABI__c 
                                            FROM Account 
                                            WHERE RecordType.DeveloperName = :OB_UtilityConstants.BANK
                                            GROUP BY OB_ABI__c, Name];

        for (AggregateResult ar : accountGroupedResults){
            System.debug('### agg result available Bank Name: '+ar.get('Name'));
            System.debug('### agg result availableAbi: '+ar.get('OB_ABI__c'));
            String abi = (String)ar.get('OB_ABI__c');
            String name = (String)ar.get('Name');
            availableAbiList.add(abi);

            if(activeAbiList != null && activeAbiList.contains(abi)){
                activeABIMap.put(abi, name);
            }else{
                availableABIMap.put(abi, name);
            }

        }

        

        abiRes.availableAbi = availableABIMap;
        abiRes.activeAbi = activeABIMap;
        system.debug('### response Map ABI: '+abiRes);
        return abiRes;

    }

    public class ABIresults {
        @AuraEnabled
        public Map<String,String> availableAbi {get;set;}
        @AuraEnabled
        public Map<String,String> activeAbi {get;set;}
    }

}