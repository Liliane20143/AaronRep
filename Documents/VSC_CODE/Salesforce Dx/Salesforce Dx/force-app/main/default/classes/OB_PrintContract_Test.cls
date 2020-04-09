/*
Andrea Morittu, 03/08/2018
Classe da testare : PrintContractController
*/

@isTest
public class OB_PrintContract_Test {

	@isTest
		static void getContractsTest(){
			
			Account acc = new Account();
			acc.Name = 'Test';
			//acc.Description  = 'Test';
			acc.NE__E_mail__c  = 'test@null.it';
			acc.OB_Employees_Number__c = 'Minore di 10';
			acc.NE__VAT__c  = '12345678901';
			acc.NE__Fiscal_code__c= '12345678901';
			acc.OB_VAT_Not_Present__c = false;
			insert acc;
			
			List<Contract> cnts = new List<Contract>();
			
			Contract cnt = new Contract();
			cnt.Name = 'contract test';
			cnt.AccountId = acc.Id;
			//insert cnt;
			
			cnts.add(cnt);

			PrintContractController.getContracts(acc.Id);
		}
}