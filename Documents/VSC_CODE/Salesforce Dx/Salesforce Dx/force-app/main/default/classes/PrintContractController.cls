public with sharing class PrintContractController {
    @AuraEnabled
    public static List<Contract> getContracts(String accountId){
        List<Contract> cntList = [select id , AccountId ,  Status , ContractTerm , StartDate
                                 from contract
                                 where AccountId=: accountId];
        return cntList;
    }
}