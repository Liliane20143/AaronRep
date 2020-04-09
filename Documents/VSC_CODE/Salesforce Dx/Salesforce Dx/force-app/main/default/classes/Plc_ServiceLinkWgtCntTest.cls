/** 
 * @author Francesco Bigoni
 * @date Creation 07/05/2019
 * @version 1.0
 * @description Plc_ServiceLinkWgtCnt test class
 */
@isTest
public class Plc_ServiceLinkWgtCntTest {

    /**
    * @author Francesco Bigoni
    * @date Creation 07/05/2019
    * @version 1.0
    * @description Test of the method retrieveTranslationMap
    */
    @isTest
    static void retrieveTranslationMapTestOk() { 
        //Starting test
        Test.startTest();
        Map<String, String> response = Plc_ServiceLinkWgtCnt.retrieveTranslationsMap();
        //Stopping test
        Test.stopTest();
        System.assert(response != null);
    }

    /**
    * @author Francesco Bigoni
    * @date Creation 07/05/2019
    * @version 1.0
    * @description Test Ok of the method retrievePropertiesMap
    */
    @isTest
    static void retrievePropertiesMapTestOk() {

        Map<String, Object> configMap = new Map<String, Object>();
        Map<Object, Object> property = new Map<Object, Object>();
        property.put('customPermission', 'test');
        configMap.put('test', property);

        //Starting test
        Test.startTest();
        Map<String, Object> response = Plc_ServiceLinkWgtCnt.retrievePropertiesMap(configMap);
        //Stopping test
        Test.stopTest();

        System.assert(response.get('error') == false);
    }

    /**
    * @author Francesco Bigoni
    * @date Creation 07/05/2019
    * @version 1.0
    * @description Test Ko of the method retrievePropertiesMap
    */
    @isTest
    static void retrievePropertiesMapTestKo() {

        Map<String, Object> configMap = new Map<String, Object>();
        configMap.put('test', '');

        //Starting test
        Test.startTest();
        Map<String, Object> response = Plc_ServiceLinkWgtCnt.retrievePropertiesMap(configMap);
        //Stopping test
        Test.stopTest();

        System.assert(response.get('error') == true);
    }
}