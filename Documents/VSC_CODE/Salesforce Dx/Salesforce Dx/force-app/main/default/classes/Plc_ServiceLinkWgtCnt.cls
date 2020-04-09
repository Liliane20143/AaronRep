/** 
 * @author FB
 * @date Creation 03/05/2019 
 * @description Controller of lightning component Plc_ServiceLinkWgt
 * @errorcode
 *
 */
public class Plc_ServiceLinkWgtCnt {

    /**
     * Method used in order to get some different system labels
     *
     * @code 01
     *
     * @return A map containing pairs Api Name/Label
     */
    @AuraEnabled
    public static Map<String, String> retrieveTranslationsMap(){

        Map<String, String> response = new Map<String,String>();
        //Put translations here...
        return response;
    }

    /**
     * Method used in order to get some utils and context data
     *
     * @code 02
     * 
     * @return Utils and context data
     */
    @AuraEnabled
    public static Map<String, Object> retrievePropertiesMap(Map<String, Object> configMap){

        Map<String, Object> response = new Map<String, Object>();
        response.put('error', false);
        //List<ServiceLinkWrp> serviceLinkItemWrpList = new List<ServiceLinkWrp>();
        //Set<String> categoriesSet = new Set<String>();

        try {

            /* [START]
             * Assigning visibility according to custom permission
             * ----------------------------------------------------------------------------------------------------------------------------------- */

            for (String key : configMap.keySet()) {
                String customPermission = (String)((Map<Object, Object>)configMap.get(key)).get('customPermission');
                ((Map<Object, Object>)configMap.get(key)).put('isVisible', 
                    FeatureManagement.checkPermission(customPermission));
            }

            /* [END]
             * Assigning visibility according to custom permission
             * ----------------------------------------------------------------------------------------------------------------------------------- */

            //Returning data to client
            response.put('configMap', configMap);

        } catch (Exception e) {
            System.debug(e.getMessage() + ' ' + e.getStackTraceString());
            response.put('error', true);
            response.put('errorMsg', e.getMessage());
        }
        return response;
    }
}