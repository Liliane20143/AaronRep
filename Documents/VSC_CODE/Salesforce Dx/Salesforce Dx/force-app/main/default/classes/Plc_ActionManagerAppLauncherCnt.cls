/**
 * *************************************************
 *     * @Author nunzio.capasso@/webresults.it
 *     * @date  25/02/2019 17:41
 *     * @description Plc_ActionManagerAppLauncherCmp apex controller
 *     * @errorcode [ERR:CL-08CYYZZ]
 *     * @Modified by
 *   ***********************************************
 **/
public with sharing class Plc_ActionManagerAppLauncherCnt {

    //error constants
    private static final String NO_ACTIONTYPE = 'No actionType';
    private static final String NO_OBJECT_TO_MATCH = 'no object to match';

    //ActionType constants
    private static final String ASSIGN = 'assign';
    private static final String GOODS_RECEIVING = 'goodsReceiving';
    private static final String TAKE_IN_CHARGE = 'takeInCharge';
    private static final String DL_MANAGEMENT = 'dlManagement';
    private static final String SERIAL_MERGE_UNDEFINED = 'serialMergeFromUndefined';
    private static final String FILL_REPORT = 'fillReport';
    private static final String SERIAL_CENSUS = 'serialsCensus';
    private static final String MANAGE_WAREHOUSE_PROVINCE = 'manageWarehouseProvince';
    private static final String QUANTITY_CONSOLIDATION = 'productStockConsolidation';

    //componentName constants
    public static final String PLC_GOODS_RECEIVING_COMPONENT = 'Plc_GoodsReceiving';
    public static final String PLC_FILTERCMP_COMPONENT = 'Plc_FilterCmp';
    public static final String PLC_GOODS_DISTRIBUTION_LIST_COMPONENT = 'Plc_GoodsDistributionList';
    public static final String PLC_SERIAL_MERGE_UNDEFINED_COMPONENT = 'Plc_StockSerialsMergeFromUndefined';
    public static final String PLC_FILL_REPORT_COMPONENT = 'Plc_ActivityCompileReport';
    public static final String PLC_SERIAL_CENSUS_COMPONENT = 'Plc_StockSerialsImportUpload';
    public static final String PLC_MANAGE_WAREHOUSE_PROVINCE = 'Plc_ManageWarehouseProvince';
    public static final String PLC_QUANTITY_CONSOLIDATION = 'Plc_ProductStockConsolidation';

    /**
     * *************************************************
     *     * @Author nunzio.capasso@/webresults.it
     *     * @date  26/02/2019 15:04
     *     * @description url parameters wrapper
     *     * @Modified by
     *   ***********************************************
     **/
    public class UrlParameters {
        String objId { get; set ; }
        String actionType { get; set; }
        String additionalParameters { get; set; }
    }

    /**
     * *************************************************
     *     * @Author nunzio.capasso@/webresults.it
     *     * @date  26/02/2019 14:55
     *     * @param parameters serialized "UrlParameters" class
     *     * @description methods that on "Action Manager" button click
     *     checks if the connected app\cmp can be launched
     *     * @return "OK" if check is positive else an error message
     *     * @Modified by
     *   ***********************************************
     **/
    @AuraEnabled
    public static Map<String, Object> compatibilityCheck(String parameters) {
        Map<String, Object> result = new Map<String, Object>();
        System.debug('#### [time] START: ' + System.Datetime.now());

        if (String.isEmpty(parameters)) {
            result.put('result', 'ERROR: parameters can not be empty.');
            return result;
        }

        //FB 20191029 NEXIPLC-745 [START]
        result.put('error', false);
        //FB 20191029 NEXIPLC-745 [END]

        try {
            UrlParameters urlData = (UrlParameters) JSON.deserialize(parameters, UrlParameters.class);

            result.put('objId', urlData.objId);
            result.put('actionType', urlData.actionType);
            result.put('additionalParameters', urlData.additionalParameters);

            if (String.isNotBlank(urlData.actionType)) {

                if (String.isNotBlank(urlData.objId)) {

                    Id idx = (Id) urlData.objId;
                    String objApiName = idx.getSobjectType().getDescribe().getName();
                    String query = 'SELECT Id FROM ' + String.escapeSingleQuotes(objApiName) + ' WHERE Id =:idx';
                    List<SObject> sobjectType = Database.query(query);

                    System.debug('\n\n@@@@@query : ' + query + '\n\n');
                    System.debug('\n\n@@@@@sobjectType List : ' + sobjectType + '\n\n');
                    System.debug('\n\n@@@@@Id: ' + urlData.objId + ' '
                            + 'actionType: ' + urlData.actionType + ' ' + 'objApiName: ' + objApiName + '\n\n');

                    switch on sobjectType[0] {
                        when Account a {

                            if (urlData.actionType.equalsIgnoreCase('placeHolder')) {
                                result.put('result', '');

                            } else {
                                result.put('result', NO_ACTIONTYPE + ' for ' + sobjectType);
                                return result;
                            }

                        }
                        when Bit2Shop__Stock_Serials2__c s {

                            if (urlData.actionType.equalsIgnoreCase(SERIAL_MERGE_UNDEFINED)) {

                                result.put('result', Plc_StockSerialsMergeFromUndefinedCnt.preCheckSerial(s));
                                result.put('componentName', PLC_SERIAL_MERGE_UNDEFINED_COMPONENT);
                            } else if (urlData.actionType.equalsIgnoreCase(FILL_REPORT)){

                                result.put('result', Plc_ActivityCompileReportCnt.preCheckSerial(s));
                                result.put('componentName', PLC_FILL_REPORT_COMPONENT);
                            } else {
                                result.put('result', NO_ACTIONTYPE + ' for ' + sobjectType);
                                return result;
                            }

                        }
                        when Bit2Shop__StockOrder__c o {

                            if (urlData.actionType.equalsIgnoreCase(ASSIGN)) {

                                String precheckResult = Plc_StockOrderApxAct.precheckOrderBeforeAssign(o);
                                if (String.isBlank(precheckResult)) {
                                    Plc_StockOrderApxAct.assign(o, null);
                                }

                                result.put('result', precheckResult);
                            } else if (urlData.actionType.equalsIgnoreCase(TAKE_IN_CHARGE)) {

                                result.put('result', Plc_StockOrderApxAct.takeCharge(o, null));
                            } else if (urlData.actionType.equalsIgnoreCase(GOODS_RECEIVING)) {

                                result.put('result', Plc_GoodsReceivingCnt.grantAccess(o));
                                result.put('componentName', PLC_GOODS_RECEIVING_COMPONENT);
                            } else {
                                result.put('result', NO_ACTIONTYPE + ' for ' + sobjectType);
                                return result;
                            }

                        }
                        when Bit2Shop__Warehouse__c w {

                            if (urlData.actionType.equalsIgnoreCase('placeHolder')) {
                                result.put('result', '');

                            } else {
                                result.put('result', NO_ACTIONTYPE + ' for ' + sobjectType);
                                return result;
                            }

                        }
                        when Bit2Shop__Shipment__c sh {

                            if (urlData.actionType.equalsIgnoreCase(GOODS_RECEIVING)) {
                                result.put('result', Plc_GoodsReceivingCnt.grantAccess(sh));
                                result.put('componentName', PLC_GOODS_RECEIVING_COMPONENT);
                            } else {
                                result.put('result', NO_ACTIONTYPE + ' for ' + sobjectType);
                                return result;
                            }

                        }
                        when else {
                            result.put('result', NO_OBJECT_TO_MATCH);
                            return result;
                        }
                    }
                } else {
                    if (urlData.actionType.equalsIgnoreCase(DL_MANAGEMENT)) {

                        result.put('result', null);
                        result.put('componentName', PLC_GOODS_DISTRIBUTION_LIST_COMPONENT);
                    } else if (urlData.actionType.equalsIgnoreCase(SERIAL_CENSUS)) {

                        result.put('result', null);
                        result.put('componentName', PLC_SERIAL_CENSUS_COMPONENT);

                    } else if (urlData.actionType.equalsIgnoreCase(MANAGE_WAREHOUSE_PROVINCE)) {

                        result.put('result', Plc_ManageWarehouseProvinceCnt.preCheck());
                        result.put('componentName', PLC_MANAGE_WAREHOUSE_PROVINCE);

                    } else if (urlData.actionType.equalsIgnoreCase(QUANTITY_CONSOLIDATION)) {
                        result.put('result', Plc_ProductStockConsolidationCnt.preCheck());
                        result.put('componentName', PLC_QUANTITY_CONSOLIDATION);
                    }
                }
            }

            System.debug('#### [time] END: ' + System.Datetime.now());
            
            if (String.isBlank(String.valueOf(result.get('result')))) {

                result.put('result', Label.Plc_ActionManagerSuccessMessage);
                System.debug('\n\n@@@@@resultIfEmpty : ' + result + '\n\n');
                return result;
            }

            System.debug('\n\n@@@@@result : ' + result + '\n\n');
            return result;

        } catch (Exception e) {
            String errorMessage = '\n\n@@@@@compatibilityCheck Error ' + Label.Plc_ActionManagerErrorMessage
                    + '\n' + ' : ' + e.getCause() + ' : ' + e.getMessage() + ' : '
                    + e.getLineNumber() + ' : ' + e.getStackTraceString();
            System.debug(LoggingLevel.ERROR, errorMessage);
            // return null;

            //FB 20191029 NEXIPLC-745 [START]
            result.put('error', true);
            result.put('errorMessage', '[ERR:CL-08C0101] Error: ' + e.getMessage());
            return result;
            //FB 20191029 NEXIPLC-745 [END]
        }

    }

}