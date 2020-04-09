/*
Copyright 2017 OpFocus, Inc

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation 
files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, 
modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the 
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE 
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR 
IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.		
*/
@isTest
public class OB_LightningLookup_Test {

	@isTest
	public static void getRecordsTest1()
	{
		Contact c = new Contact(LastName = 'ln', MobilePhone = '1234567890');
		insert c;
		String sObjectName = 'Contact'; 
		String valueFieldName = 'FirstName';
		String displayedFieldName = 'CreatedDate'; 
		String otherFields = ''; 
		String whereClause = 'LastName = \'ln\'';
		Test.startTest();
		LightningLookupController.getRecords(sObjectName, valueFieldName, displayedFieldName, otherFields, whereClause);
		Test.stopTest();
	}

	@isTest
	public static void getRecordsTest2()
	{
		Contact c = new Contact(LastName = 'ln', MobilePhone = '1234567890');
		insert c;
		String sObjectName = 'Contact'; 
		String valueFieldName = 'FirstName';
		String displayedFieldName = 'CreatedDate'; 
		String otherFields = ''; 
		String whereClause = 'LastName = \'a\'';
		try
		{
			Test.startTest();
			LightningLookupController.getRecords(sObjectName, valueFieldName, displayedFieldName, otherFields, whereClause);
			Test.stopTest();
		}
		catch(AuraHandledException e)
		{
            System.debug(e.getMessage());
        }
	}

	@isTest
	public static void getRecordsTest3()
	{
		String sObjectName = ''; 
		String valueFieldName = '';
		String displayedFieldName = ''; 
		String otherFields = ''; 
		String whereClause = '';
		Test.startTest(); 
		LightningLookupController.getRecords(sObjectName, valueFieldName, displayedFieldName, otherFields, whereClause);
		Test.stopTest();
	}

	@isTest
	public static void getRecordsTest4()
	{
		String sObjectName = 'Contact'; 
		String valueFieldName = 'FirstName';
		String displayedFieldName = 'CreatedDate'; 
		String otherFields = 'asd'; 
		String whereClause = '';
		try
		{
			Test.startTest();
			LightningLookupController.getRecords(sObjectName, valueFieldName, displayedFieldName, otherFields, whereClause);
			Test.stopTest();
		}
		catch(AuraHandledException e)
		{
            System.debug(e.getMessage());
        }
	}

	

 //   //@isTest
	//public static void getHelpTextTest1()
	//{
	//	String field = 'FirstName\\.LastName';
 //       Test.startTest();
	//	LightningLookupController.getHelpText(field);
	//	Test.stopTest();
	//} 

	@isTest
	public static void getHelpTextTest2()
	{
		String field = 'LastName\\.test';
		try
		{
			Test.startTest();
			LightningLookupController.getHelpText(field);
			Test.stopTest();
		}
		catch(AuraHandledException e)
		{
            System.debug(e.getMessage());
        }
	}



	@isTest
	public static void getReference()
	{
		String field = 'LastName\\.test';
		try
		{
			Test.startTest();
			LightningLookupController.getReference(field);
			Test.stopTest();
		}
		catch(AuraHandledException e)
		{
            System.debug(e.getMessage());
        }
	}


	@isTest
	public static void getFieldValue()
	{
		Account acc  = new Account();
		String obj   = 'Account';
		String objId = acc.id;
		String label = 'label_test';
		try
		{
			Test.startTest();
			LightningLookupController.getFieldValue(obj,  objId,  label);
			Test.stopTest();
		}
		catch(AuraHandledException e)
		{
            System.debug(e.getMessage());
        }
	}




	/*static testMethod void myTest1() {

		Account acct = new Account(Name = 'Test Account');
		insert acct;
		LightningLookupController.LookupRecords res = LightningLookupController.getRecords('Account', '', 'Name', '', 'Name like \'test%\'');
		System.assertEquals(null,res);
		res = LightningLookupController.getRecords('Account', 'Id', '', '', 'Name like \'test%\'');
		System.assertEquals(null,res);
		res = LightningLookupController.getRecords('Account', 'Id', '', 'CreatedDate', 'Name like \'test%\'');
		System.assertEquals(null,res);
		res = LightningLookupController.getRecords('Account', '', '', 'CreatedDate', 'Name like \'test%\'');
		System.assertEquals(null,res);
		res = LightningLookupController.getRecords('Account', 'Id', 'Name', 'CreatedDate', 'Name like \'test%\'');
		System.assertEquals(1,res.lstDisplay.size());
		System.assertEquals(1,res.lstValue.size());
		System.assertEquals(1,res.lstRecords.size());
		res = LightningLookupController.getRecords('Account', 'Id', 'Name', 'CreatedDate', 'Name like \'hufdehf%\'');
		System.assertEquals(1,res.lstDisplay.size());
		System.assertEquals(1,res.lstValue.size());
		System.assertEquals(1,res.lstRecords.size());
		System.assertEquals('No records found!',res.lstDisplay[0]);
		String s = LightningLookupController.getHelpText('Account.Name');
		s = LightningLookupController.getReference('Account.OwnerId');
		System.assertEquals('User',s);
		res = LightningLookupController.getFieldValue('Account', acct.Id, 'Name');
		System.assertEquals(acct.Name,res.lstDisplay[0]);
		System.assertEquals(acct.Id,res.lstValue[0]);
		System.assertEquals(1, res.lstRecords.size());
	}	*/
}