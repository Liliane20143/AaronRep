global without sharing class OB_PreviewPDF_CC
{
	public static final Map <String,String> docIds = new Map <String,String>();
	
	global transient String fileUrl
	{
		get
		{	
			String fileUrl = System.currentPageReference().getParameters().get('fu');
 			return fileUrl;
		}
	}

}