@isTest
public class OB_StradaService_Test {
	
	@isTest
	static void callService(){
        
        String response = '<response> <errorMessage/> <indexSize>1937</indexSize> <originalInput>col</originalInput> <match>false</match> <time>0</time> <format>STRADA</format> <strada flagMulticap="false"> <value>VIA COLBRICON</value> <idfrazione>0</idfrazione> <label/> <key>69948637</key> <listaCap> <cap>37126</cap> </listaCap> </strada> <strada flagMulticap="false"> <value>VIA COLOMBARA</value> <idfrazione>0</idfrazione> <label/> <key>69948936</key> <listaCap> <cap>37137</cap> </listaCap> </strada> <strada flagMulticap="false"> <value>VIA ARE COLTRI</value> <idfrazione>30039</idfrazione> <label>QUINTO</label> <key>70038223</key> <listaCap> <cap>37142</cap> </listaCap> </strada> <strada flagMulticap="false"> <value>VIA COL BRICON</value> <idfrazione>0</idfrazione> <label/> <key>69948522</key> <listaCap> <cap>37126</cap> </listaCap> </strada> <strada flagMulticap="false"> <value>VIA COL DI LANA</value> <idfrazione>0</idfrazione> <label/> <key>69948579</key> <listaCap> <cap>37124</cap> </listaCap> </strada> <strada flagMulticap="false"> <value>VIALE DEI COLLI</value> <idfrazione>0</idfrazione> <label/> <key>69948693</key> <listaCap> <cap>37128</cap> </listaCap> </strada> <strada flagMulticap="false"> <value>VIA COLLI BERICI</value> <idfrazione>0</idfrazione> <label/> <key>69948751</key> <listaCap> <cap>37132</cap> </listaCap> </strada> <strada flagMulticap="false"> <value>VICOLO COLOMBINE</value> <idfrazione>0</idfrazione> <label/> <key>69948992</key> <listaCap> <cap>37129</cap> </listaCap> </strada> <strada flagMulticap="false"> <value>VIA COLLI EUGANEI</value> <idfrazione>0</idfrazione> <label/> <key>69948810</key> <listaCap> <cap>37132</cap> </listaCap> </strada> <strada flagMulticap="false"> <value>VIA DELLA COLLINA</value> <idfrazione>30039</idfrazione> <label>QUINTO</label> <key>70038932</key> <listaCap> <cap>37142</cap> </listaCap> </strada> </response>';
        Test.startTest();
		
			//Test.setMock(HttpCalloutMock.class, new MockGeneratorOB_StradaService());	
			OB_StradaService ob_ss = new OB_StradaService();  
			ob_ss.callService(response);
			
		Test.stopTest(); 
    }
    
}