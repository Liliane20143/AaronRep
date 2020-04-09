@isTest
public class OB_Order_List_Controller_Test {


	// @isTest
	// public static void getColumns_test() {

		
	// 	String reportName = 'Account_Creati_nell_anno'; 
	// 	String ABI = '05116'; 
	// 	String CAB = '11703';
	// 	//Report report = new Report();
	// 	//insert report;
	// 	Test.startTest();
	// 	OB_Order_List_Controller.getColumns(reportName , ABI , CAB  );
	// 	Test.stopTest();

	// }	
	


	// @isTest
	// public static void getTabularReportResponse_test() {

	// 	Test.startTest();
	// 	String reportName = 'Account_Creati_nell_anno';
	// 	String abi = '05116'; 
	// 	String cab = '11703';
	// 	// fieldDef
	// 	String fieldName  = 'Name';
    //     String fieldLabel = 'Name';
    //     String dataType   = '';

    //     //fieldData
    //     String fieldValue   =  'Name';
    //     // String fieldLabel   =  '';
    //     // String dataType     =  '';       
    //     Boolean isHyperLink =  false; 

    //     // Id reportId  = [SELECT DeveloperName FROM Report where DeveloperName =:reportName LIMIT 1].Id;

	// 	// List<Report> reportList = new List<Report>();
	// 	// reportList = [SELECT DeveloperName FROM Report where DeveloperName =:reportName LIMIT 1];
	// 	// //Report reportTest = new Report();
	// 	// Id reportId  = reportList.get(0).id;

	// 	 OB_Order_List_Controller.getTabularReportResponse(reportName,abi , cab);
	// 	Test.stopTest();

	// }
	@isTest
	public static void tabularReportResponse_test() {
		Test.startTest();
		String reportName = 'Account_Creati_nell_anno';
		String abi = '05116'; 
		String cab = '11703';
		OB_Order_List_Controller.fieldDef fieldDefObj= new OB_Order_List_Controller.fieldDef();
		fieldDefObj.fieldName = 'test';
		fieldDefObj.fieldLabel ='test2';
		fieldDefObj.dataType =  'test3';
		OB_Order_List_Controller.fieldData fieldDataObj= new OB_Order_List_Controller.fieldData();
		fieldDataObj.fieldValue = 'test';
		fieldDataObj.fieldLabel = 'test2';
		fieldDataObj.dataType   = 'test3';
		OB_Order_List_Controller.tabularReportResponse orderListClass= new OB_Order_List_Controller.tabularReportResponse();
		orderListClass.reportFields = new List<OB_Order_List_Controller.fieldDef>();
		orderListClass.fieldDataList = new List<List<OB_Order_List_Controller.fieldData>>();
		
		Test.stopTest();
	}


	@isTest
	public static void getReport_test() {

		String reportName = 'NewReport';
		
		List<Report> reportList = [SELECT DeveloperName FROM Report where DeveloperName =: reportName];
	
		Test.startTest();		
			//OB_Order_List_Controller.getReport(reportName);
		Test.stopTest();

	}

	@isTest
	public static void getSessionId_test() {

		Test.startTest();
		OB_Order_List_Controller.getSessionId();
		Test.stopTest();

	}


	@isTest
	public static void getAbiCabUserLogged_test() {

		Test.startTest();
		OB_Order_List_Controller.getAbiCabUserLogged();
		Test.stopTest();

	}


	@isTest
	public static void getFieldUserLogged_test() {

		String columns = 'Id, Account.OB_ABI__c';
		Profile profile1 = [ SELECT Id  FROM Profile WHERE Name = 'System Administrator' ];

		User user = new User( LastName 			= 'test',
							  Alias 			= 'test13',
							  Email 			= 'test13@test.com',
							  Username 			= 'test13@test13.it',
							  CommunityNickname = 'tests',
							  ProfileId 		=  profile1.Id,
							  EmailEncodingKey 	= 'ISO-8859-1',
							  TimeZoneSidKey 	= 'Europe/Rome',
							  LocaleSidKey 		= 'it_IT',
							  LanguageLocaleKey = 'en_US' );
		insert user;

		Test.startTest();
		OB_Order_List_Controller.getFieldUserLogged(columns);
		Test.stopTest();

	}
	@isTest
	public static void getFieldUserLogged_testCatch() {

		String columns = '';
		Profile profile1 = [ SELECT Id  FROM Profile WHERE Name = 'System Administrator' ];

		User user = new User( LastName 			= 'test',
							  Alias 			= 'test13',
							  Email 			= 'test13@test.com',
							  Username 			= 'test13@test13.it',
							  CommunityNickname = 'tests',
							  ProfileId 		=  profile1.Id,
							  EmailEncodingKey 	= 'ISO-8859-1',
							  TimeZoneSidKey 	= 'Europe/Rome',
							  LocaleSidKey 		= 'it_IT',
							  LanguageLocaleKey = 'en_US' );
		insert user;

		Test.startTest();
		OB_Order_List_Controller.getFieldUserLogged(columns);
		Test.stopTest();

	}


//getFieldMetaData

	@isTest
	public static void getFieldMetaData_test() {

		Schema.DescribeSObjectResult dsor = Account.sObjectType.getDescribe();
		Set<String> fields = new Set<String>{'Name','NE__Fiscal_code__c','NE__VAT__c'};//'Name','NE__Fiscal_code__c','NE__VAT__c')

		Test.startTest();
		OB_Order_List_Controller.getFieldMetaData(dsor, fields);
		Test.stopTest();

	}

}