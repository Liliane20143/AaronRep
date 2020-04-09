/*
Andrea Morittu, 25/07/2018
*/
@isTest
public class OB_ProvinceService_Test {

    @isTest
    public static void callServiceTest(){
        String response = '<response> <errormessage/> <indexsize>7978</indexsize> <originalinput>ver</originalinput> <match>false</match> <time>0</time> <format>comune</format> <items> <key>7984</key> <value>verona</value> </items> <items> <key>7985</key> <value>veronella</value> </items> <items> <key>7983</key> <value>velo veronese</value> </items> <items> <key>7919</key> <value>cerro veronese</value> </items> <items> <key>7930</key> <value>gazzo veronese</value> </items> <items> <key>7955</key> <value>rivoli veronese</value> </items> <items> <key>7911</key> <value>caprino veronese</value> </items> <items> <key>7916</key> <value>cavaion veronese</value> </items> <items> <key>7959</key> <value>rovere\' veronese</value> </items> <items> <key>7953</key> <value>povegliano veronese</value> </items> </response>';
        Test.startTest();
        OB_ProvinceService ob_ps = new OB_ProvinceService();
        ob_ps.callService(response);
        Test.stopTest();
    }
    /*
    @isTest
    public static void callService_Test(){
    	
        Test.startTest();
        
        String url;
		Test.setMock(HttpCalloutMock.class, new MockGeneratorOB_ProvinceService());	
        OB_ProvinceService ps = new OB_ProvinceService();  
		Map<String,String> response = ps.callService(String.valueOf(OB_UtilityCallingServices.callServiceUtil('callout:OB_Postel_Autocomplete'+url,'GET')));
        
        Test.stopTest(); 
    }*/
}