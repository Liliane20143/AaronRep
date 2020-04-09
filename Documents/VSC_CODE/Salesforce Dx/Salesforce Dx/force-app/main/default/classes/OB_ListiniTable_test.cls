/*
Controller class name : OB_ListiniTableController
Doris Tatiana, 05/11/2018
*/
@isTest
public class OB_ListiniTable_test {

	@isTest
	public static void getListini_test() {

		Decimal pageSize   = 2;
		Decimal pageNumber = 4;


        NE__Matrix_Parameter__c matrix = new NE__Matrix_Parameter__c();
        //matrix.recordType.DeveloperName = 'OB_PriceList';
        //insert matrix;

		Test.startTest();
		OB_ListiniTableController.getListini(pageSize,pageNumber);
		Test.stopTest();

		
	}


	@isTest
	public static void searchListiniServer_test() {
		
		Decimal pageSize   = 3;
		Decimal pageNumber = 1;
		String  name ='test name';
		String fromDate = String.valueOf(Datetime.newInstance(1990, 11, 21));
		String toDate   = String.valueOf(Datetime.newInstance(1960, 2, 19));

		//Integer pSize = (Integer)pageSize;
  //      Integer offset = ((Integer)pageNumber - 1) * pSize;
  //      Integer totalRows = 0;

		Test.startTest();
		OB_ListiniTableController.searchListiniServer(pageSize, pageNumber, name, fromDate, toDate);
		Test.stopTest();

		
	}

    @isTest
    public static void searchListiniServer_test2() 
    {
        Decimal pageSize   = 3;
        Decimal pageNumber = 1;
        String  name ='test name';
        String fromDate = '2019-01-01';
        String toDate   = '2021-09-09';

        Test.startTest();
        OB_ListiniTableController.searchListiniServer(pageSize, pageNumber, name, fromDate, toDate);
        Test.stopTest();    
    }

	@isTest
	public static void creaListinoServer_test() {
		//(Decimal pageSize, Decimal pageNumber,String name, String fromDate, String toDate)

		Decimal pageSize   = 2;
		Decimal pageNumber = 3;
		String  name       = 'test name';
		String fromDate  = String.valueOf(Datetime.newInstance(2018, 11, 21));
		String toDate    = String.valueOf(Datetime.newInstance(1998, 2, 19));
		Date startDate     = Date.newInstance(2018, 11, 21);


		NE__Bundle__c bundle = new NE__Bundle__c( Name 								= 'test',
												  NE__Configuration_Type__c 		= 'Free',
												  NE__BaseRecurringCharge__c		= 12.00,
												  NE__RecurringChargeFrequency__c 	= 'Annual',
												  NE__Start_Date__c 				= system.now(),
												  NE__End_Date__c 					= system.now().addDays(1));
      	insert bundle;

		NE__Matrix_Parameter__c listino = new NE__Matrix_Parameter__c( 
      															  NE__Active__c     = false,
      															  NE__Start_Date__c = startDate,
      															  Name              = '	LISTINO PCI', 
      															  OB_Offerta__c 	= bundle.Id,
      															  RecordTypeId 		= Schema.SObjectType.NE__Matrix_Parameter__c.getRecordTypeInfosByName().get('OB_PriceList').getRecordTypeId()
);
      
        List<NE__Matrix_Parameter__c> listiniList  = new  List<NE__Matrix_Parameter__c>();
        listiniList.add(listino);
        insert listiniList;
        //(Decimal pageSize, Decimal pageNumber,String name, String fromDate, String toDate)
		Test.startTest();
		OB_ListiniTableController.creaListinoServer(pageSize, pageNumber, name, fromDate, toDate);
		Test.stopTest();

		
	}


	@isTest
	public static void deleteListinoServer_test() {

		Decimal pageSize   = 6;
		Decimal pageNumber = 6;
		Date fromDate = Date.newInstance(2018, 11, 21);

        NE__Bundle__c bundle = new NE__Bundle__c( Name 								= 'test',
												  NE__Configuration_Type__c 		= 'Free',
												  NE__BaseRecurringCharge__c		= 12.00,
												  NE__RecurringChargeFrequency__c 	= 'Annual',
												  NE__Start_Date__c 				= system.now(),
												  NE__End_Date__c 					= system.now().addDays(1));
      	insert bundle;
      	NE__Matrix_Parameter__c listinoToDelete = new NE__Matrix_Parameter__c( 
      															  Name 				= 'test',
      															  OB_Offerta__c 	= bundle.Id,
      															  RecordTypeId 		= Schema.SObjectType.NE__Matrix_Parameter__c.getRecordTypeInfosByName().get('OB_PriceList').getRecordTypeId()
);
      	//OB_PriceList
      	insert listinoToDelete;

      	NE__Matrix_Parameter__c listino = new NE__Matrix_Parameter__c( 
      															  NE__Active__c     = false,
      															  NE__Start_Date__c = fromDate,
      															  Name              = '	LISTINO PCI', 
      															  OB_Offerta__c 	= bundle.Id,
      															  RecordTypeId 		= Schema.SObjectType.NE__Matrix_Parameter__c.getRecordTypeInfosByName().get('OB_PriceList').getRecordTypeId()
);
      
        List<NE__Matrix_Parameter__c> listiniList  = new  List<NE__Matrix_Parameter__c>();
        listiniList.add(listino);
        insert listiniList;



		Test.startTest();
		OB_ListiniTableController.deleteListinoServer(pageSize, pageNumber,listinoToDelete);
		Test.stopTest();

		
	}
}