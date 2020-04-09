/**
* @author Raffaele Fioratto
* @date Creation 17/10/2018
* @description BT_AdminCnt - Apex controller for BT_Admin Lightning Component
*/

public class BT_AdminCnt {

    /**
    * @author Raffaele Fioratto
    * @date 17/10/2018
    * @description Returns a list of all fields for object BT_ConfigSimulator with 'BT_' in the API Name prefix
    * @return List<String> - The list of API Names of the fields
    */
    private static List<String> constructListOfBtFields(Boolean includeFormulas) {
        Map<String, Schema.SObjectField> fieldMap = BT_ConfigSimulator__c.sObjectType.getDescribe().Fields.getMap();
        List<String> fieldsList = new List<String>();
        for (String fieldApiName : fieldMap.keySet()) {
            if (fieldApiName.startsWith('bt_') && (includeFormulas || !fieldMap.get(fieldApiName).getDescribe().isCalculated())) {
                fieldsList.add(fieldApiName);
            }
        }
        return fieldsList;
    }

    /**
    * @author Raffaele Fioratto
    * @date 17/10/2018
    * @description Loads a BT_ConfigSimulator__c record associated with Bank Account related to Operator User
    * @return BT_ConfigSimulator__c - The record to display in the Lightning component
    *
    */
    @AuraEnabled
    public static BT_ConfigSimulator__c loadRecord() {
        return loadRecord(false);
    }

    /**
    * @author Raffaele Fioratto
    * @date 18/10/2018
    * @description Loads a BT_ConfigSimulator__c record associated with Bank Account related to Operator User
    * @param includeFormula - Boolean query also the read-only fields from the record
    * @return BT_ConfigSimulator__c - The record to display in the Lightning component
    *
    */
    public static BT_ConfigSimulator__c loadRecord(Boolean includeFormulas) {
        User runningUser = [SELECT AccountId FROM User WHERE Id = :UserInfo.getUserId()];
        String query = String.format('SELECT {0} FROM BT_ConfigSimulator__c WHERE BT_Account__c = {1} ORDER BY SystemModstamp DESC', new List<String>{String.join(constructListOfBtFields(includeFormulas), ','), '\'' + runningUser.AccountId + '\''});
        BT_ConfigSimulator__c config;
        List<BT_ConfigSimulator__c> configs = Database.query(query);
        if (!configs.isEmpty()) {
            if (configs.size() > 1) {
                System.debug(LoggingLevel.WARN, 'More than 1 record found for object BT_ConfigSimulator__c for the account: '+ runningUser.AccountId +'. Actually page will take the most recent one');
            }
            config = configs.get(0);
        } else {
            System.debug(LoggingLevel.ERROR, 'No record found for object BT_ConfigSimulator__c for the account: '+ runningUser.AccountId);
            AuraHandledException exc = new AuraHandledException('Nessun record di configurazione trovato per questo ABI!');
            exc.setMessage('Nessun record di configurazione trovato per questo ABI!');
            throw exc;
        }
        return config;
    }

    public static List<BT_ConfigSimulator__c> loadReferralRecords(Boolean includeFormulas, Decimal negotiated, String mode) {
        User runningUser = [SELECT AccountId FROM User WHERE Id = :UserInfo.getUserId()];
        String query = String.format('SELECT {0} FROM BT_ConfigSimulator__c WHERE BT_Account__c = {1} AND BT_NegoziatoAnnuoMin__c <= {2} AND BT_NegoziatoAnnuoMax__c >= {2} AND BT_Tipo__c = {3} ORDER BY BT_Priorita__c ASC, SystemModstamp DESC', 
            new List<String>{String.join(constructListOfBtFields(includeFormulas), ','), '\'' + runningUser.AccountId + '\'', String.valueOf(negotiated), '\'' + mode + '\''});

        List<BT_ConfigSimulator__c> configs = Database.query(query);

        if (configs.isEmpty()) {
            System.debug(LoggingLevel.ERROR, 'No record found for object BT_ConfigSimulator__c for the account: '+ runningUser.AccountId);
            AuraHandledException exc = new AuraHandledException('Nessun record di configurazione trovato per questo ABI!');
            exc.setMessage('Nessun record di configurazione trovato per questo ABI!');
        }

        return configs;
    }

    /**
    * @author Raffaele Fioratto
    * @date 17/10/2018
    * @description Saves a BT_ConfigSimulator__c record associated with Bank Account related to Operator User
    * @param BT_ConfigSimulator__c - The record modified in the Lightning component
    * @return void - Nothing
    *
    */
    @AuraEnabled
    public static void saveRecord(BT_ConfigSimulator__c record) {
        update record;
    }
}