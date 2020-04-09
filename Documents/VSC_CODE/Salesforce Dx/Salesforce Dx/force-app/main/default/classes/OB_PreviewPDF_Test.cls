@isTest
private class OB_PreviewPDF_Test 
{
	@isTest static void testPreviewPDF() 
	{
		Test.startTest();
		OB_PreviewPDF_CC preview = new OB_PreviewPDF_CC();
		Test.setCurrentPageReference(new PageReference('Page.OB_PreviewPDF'));
		System.currentPageReference().getParameters().put('fu', 'test');
		
		String fileUrlTest= preview.fileUrl;
		Test.stopTest();
	}
}