/*
Andrea Morittu, 25/07/2018
*/

@isTest
public class OB_DistrictService_Test {

	@isTest
    public static void callServiceTest(){
        String response = '<response> <errormessage/> <indexsize>7978</indexsize> <originalinput>ver</originalinput> <match>false</match> <time>0</time> <format>comune</format> <items> <key>7984</key> <value>verona</value> </items> <items> <key>7985</key> <value>veronella</value> </items> <items> <key>7983</key> <value>velo veronese</value> </items> <items> <key>7919</key> <value>cerro veronese</value> </items> <items> <key>7930</key> <value>gazzo veronese</value> </items> <items> <key>7955</key> <value>rivoli veronese</value> </items> <items> <key>7911</key> <value>caprino veronese</value> </items> <items> <key>7916</key> <value>cavaion veronese</value> </items> <items> <key>7959</key> <value>rovere\' veronese</value> </items> <items> <key>7953</key> <value>povegliano veronese</value> </items> </response>';
        Test.startTest();
        OB_DistrictService ob_ds = new OB_DistrictService();
        ob_ds.callService(response);
        Test.stopTest();
    }

}