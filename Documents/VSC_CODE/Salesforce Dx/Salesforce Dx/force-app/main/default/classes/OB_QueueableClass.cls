public class OB_QueueableClass implements Queueable, Database.AllowsCallouts
{
	public final String data;

	public OB_QueueableClass(String input)
	{
		data = input;
	} 


	public void execute(QueueableContext context) 
	{
		try
		{
			System.debug('@Execute callSubmit() in OB_QueueableClass');
			OB_UtilityCallingServices.callSubmit(data);
		}
		catch(Exception ecc)
		{
			System.debug('[EXCE] OB_QueueableClass '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
		}
	}

}