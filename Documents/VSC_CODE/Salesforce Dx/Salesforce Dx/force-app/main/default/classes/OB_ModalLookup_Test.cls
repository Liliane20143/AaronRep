@isTest
public class OB_ModalLookup_Test {

	@isTest
	public static void getLovsByTypeTest(){

		String type = ''; 
		String subType = 'subType'; 
		String subTypeField = 'NE__Sub_Type__c';
		String input = '';
		Map<String,String> mapOfSourceFieldTargetField = new Map<String,String>();
		mapOfSourceFieldTargetField.put('myKey', 'Name');
		Map<String,String> mapLabelColumns = new Map<String,String>();
		mapLabelColumns.put('NE__Country__c', 'myValue');
		String orderBy = 'NE__Sequence__c';
		String ascDesc = 'DESC'; 
		String inputFieldForLike = '';
		String level = '';
		String lookupLov = '';
		Test.startTest();
		ModalLookupController.getLovsByType(type, subType, subTypeField, input, mapOfSourceFieldTargetField, mapLabelColumns, orderBy, ascDesc, inputFieldForLike, level, lookupLov);
		Test.stopTest();
	}

	@isTest
	public static void getLovsByTypeTest1(){

		String type = ''; 
		String subType = 'subType'; 
		String subTypeField = 'NE__Sub_Type__c';
		String input = '';
		Map<String,String> mapOfSourceFieldTargetField = new Map<String,String>();
		mapOfSourceFieldTargetField.put('myKey', 'Name');
		Map<String,String> mapLabelColumns = new Map<String,String>();
		mapLabelColumns.put('NE__Country__c', 'myValue');
		String orderBy = 'NE__Sequence__c';
		String ascDesc = 'DESC'; 
		String inputFieldForLike = '';
		String level = 'L1';
		String lookupLov = '';
		Test.startTest();
		ModalLookupController.getLovsByType(type, subType, subTypeField, input, mapOfSourceFieldTargetField, mapLabelColumns, orderBy, ascDesc, inputFieldForLike, level, lookupLov);
		Test.stopTest();
	}

	@isTest
	public static void getLovsByTypeTest2(){

		String type = ''; 
		String subType = 'subType'; 
		String subTypeField = 'NE__Sub_Type__c';
		String input = '';
		Map<String,String> mapOfSourceFieldTargetField = new Map<String,String>();
		mapOfSourceFieldTargetField.put('myKey', 'Name');
		Map<String,String> mapLabelColumns = new Map<String,String>();
		mapLabelColumns.put('NE__Country__c', 'myValue');
		String orderBy = 'NE__Sequence__c';
		String ascDesc = 'DESC'; 
		String inputFieldForLike = '';
		String level = 'L2';
		String lookupLov = '';
		Test.startTest();
		ModalLookupController.getLovsByType(type, subType, subTypeField, input, mapOfSourceFieldTargetField, mapLabelColumns, orderBy, ascDesc, inputFieldForLike, level, lookupLov);
		Test.stopTest();
	}

	@isTest
	public static void getLovsByTypeTest3(){

		String type = ''; 
		String subType = 'subType'; 
		String subTypeField = 'NE__Sub_Type__c';
		String input = '';
		Map<String,String> mapOfSourceFieldTargetField = new Map<String,String>();
		mapOfSourceFieldTargetField.put('myKey', 'Name');
		Map<String,String> mapLabelColumns = new Map<String,String>();
		mapLabelColumns.put('NE__Country__c', 'myValue');
		String orderBy = 'NE__Sequence__c';
		String ascDesc = 'DESC'; 
		String inputFieldForLike = '';
		String level = 'L3';
		String lookupLov = '';
		Test.startTest();
		ModalLookupController.getLovsByType(type, subType, subTypeField, input, mapOfSourceFieldTargetField, mapLabelColumns, orderBy, ascDesc, inputFieldForLike, level, lookupLov);
		Test.stopTest();
	}

	@isTest
	public static void getLovsByTypeTest_Input(){

		String type = ''; 
		String subType = 'subType'; 
		String subTypeField = 'NE__Sub_Type__c';
		String input = 'input test';
		Map<String,String> mapOfSourceFieldTargetField = new Map<String,String>();
		mapOfSourceFieldTargetField.put('myKey', 'Name');
		Map<String,String> mapLabelColumns = new Map<String,String>();
		mapLabelColumns.put('NE__Country__c', 'myValue');
		String orderBy = 'NE__Sequence__c';
		String ascDesc = 'DESC'; 
		String inputFieldForLike = '';
		String level = '';
		String lookupLov = '';
		Test.startTest();
		ModalLookupController.getLovsByType(type, subType, subTypeField, input, mapOfSourceFieldTargetField, mapLabelColumns, orderBy, ascDesc, inputFieldForLike, level, lookupLov);
		Test.stopTest();
	}


	@isTest
	public static void getLovsByTypeTest_InputL1(){

		String type = ''; 
		String subType = 'subType'; 
		String subTypeField = 'NE__Sub_Type__c';
		String input = 'input test';
		Map<String,String> mapOfSourceFieldTargetField = new Map<String,String>();
		mapOfSourceFieldTargetField.put('myKey', 'Name');
		Map<String,String> mapLabelColumns = new Map<String,String>();
		mapLabelColumns.put('NE__Country__c', 'myValue');
		String orderBy = 'NE__Sequence__c';
		String ascDesc = 'DESC'; 
		String inputFieldForLike = '';
		String level = 'L1';
		String lookupLov = '';
		Test.startTest();
		ModalLookupController.getLovsByType(type, subType, subTypeField, input, mapOfSourceFieldTargetField, mapLabelColumns, orderBy, ascDesc, inputFieldForLike, level, lookupLov);
		Test.stopTest();
	}

	@isTest
	public static void getLovsByTypeTest_InputL2(){

		String type = ''; 
		String subType = 'subType'; 
		String subTypeField = 'NE__Sub_Type__c';
		String input = 'input test';
		Map<String,String> mapOfSourceFieldTargetField = new Map<String,String>();
		mapOfSourceFieldTargetField.put('myKey', 'Name');
		Map<String,String> mapLabelColumns = new Map<String,String>();
		mapLabelColumns.put('NE__Country__c', 'myValue');
		String orderBy = 'NE__Sequence__c';
		String ascDesc = 'DESC'; 
		String inputFieldForLike = '';
		String level = 'L2';
		String lookupLov = '';
		Test.startTest();
		ModalLookupController.getLovsByType(type, subType, subTypeField, input, mapOfSourceFieldTargetField, mapLabelColumns, orderBy, ascDesc, inputFieldForLike, level, lookupLov);
		Test.stopTest();
	}

	@isTest
	public static void getLovsByTypeTest_InputL3(){

		String type = ''; 
		String subType = 'subType'; 
		String subTypeField = 'NE__Sub_Type__c';
		String input = 'input test';
		Map<String,String> mapOfSourceFieldTargetField = new Map<String,String>();
		mapOfSourceFieldTargetField.put('myKey', 'Name');
		Map<String,String> mapLabelColumns = new Map<String,String>();
		mapLabelColumns.put('NE__Country__c', 'myValue');
		String orderBy = 'NE__Sequence__c';
		String ascDesc = 'DESC'; 
		String inputFieldForLike = '';
		String level = 'L3';
		String lookupLov = '';
		Test.startTest();
		ModalLookupController.getLovsByType(type, subType, subTypeField, input, mapOfSourceFieldTargetField, mapLabelColumns, orderBy, ascDesc, inputFieldForLike, level, lookupLov);
		Test.stopTest();
	}
}