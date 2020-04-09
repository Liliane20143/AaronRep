/**
 * Created by dilorenzo on 27/02/2019.
 */

public with sharing class Plc_ActivityPrintReportCnt {


    public List<wrts_prcgvr__Activity__c> activityToPrint {get; set;}
    public Map<String,wrts_prcgvr__Activity__c> activityToPrintMap {get; set;}


    public static List<String> activityFields {get; set;}



    public Plc_ActivityPrintReportCnt(ApexPages.StandardController controller){
        String id = ApexPages.currentPage().getParameters().get('id');

        activityFields = new List<String>{
        'Id', 'Plc_Note__c', 'Plc_AccessoriesRestoration__c', 'Plc_BackFlapAccessory__c', 'Plc_BaseAccessory__c', 'Plc_BaseForMobilePos__c',
        'Plc_BatteryAccessory__c', 'Plc_Bluetooth__c', 'Plc_BrokenOrExhaustedBattery__c', 'Plc_CarPowerSupplyAccessory__c', 'Plc_ChipReader__c', 'Plc_ConnectionIssue__c',
        'Plc_ContactlessReader__c', 'Plc_Display__c', 'Plc_WiFi__c', 'Plc_SoftwareLoss__c', 'Plc_ReleaseNotUpdatable__c', 'Plc_ReaderMagneticBand__c', 'Plc_PrinterFlapAccessory__c',
        'Plc_Printer__c', 'Plc_PowerSupplyAccessory__c', 'Plc_PowerSupply__c', 'Plc_PosDoesNotTurnOn__c', 'Plc_PinPad__c', 'Plc_PhoneCableAccessory__c',
        'Plc_Keyboard__c', 'Plc_EthernetCableAccessory__c', 'Plc_EsteticDefect__c', 'Plc_ECRConnectionCableAccessory__c', 'Plc_SecurityBlock__c', 'Plc_StockSerial2__r.Bit2Shop__Transfer_Order_Id__r.Plc_WorkOrder__r.WorkOrderNumber',
        'Plc_ChecklistExecuted__c', 'Plc_StockSerial2__r.Plc_Model__c', 'Plc_StockSerial2__r.Plc_ProductSku__c','Plc_StockSerial2__r.Plc_TermId_r.Plc_TermIdCode_c', 'Plc_StockSerial2__r.Plc_Manufacturer__c', 'Plc_ActivityReportDateReportFault__c',
        'Plc_WorkType__c', 'Plc_StockSerial2__r.Plc_ManufacturerSerialNumber__c', 'Plc_StockSerial2__r.Plc_EncodedSerialNumber__c, wrts_prcgvr__Description__c'
        };

            List<wrts_prcgvr__Activity__c> activityToPrintList = [SELECT Id, Plc_Note__c, Plc_AccessoriesRestoration__c, Plc_BackFlapAccessory__c, Plc_BaseAccessory__c, Plc_BaseForMobilePos__c,
            Plc_BatteryAccessory__c, Plc_Bluetooth__c, Plc_BrokenOrExhaustedBattery__c, Plc_CarPowerSupplyAccessory__c, Plc_ChipReader__c, Plc_ConnectionIssue__c,
            Plc_ContactlessReader__c, Plc_Display__c, Plc_WiFi__c, Plc_SoftwareLoss__c, Plc_ReleaseNotUpdatable__c, Plc_ReaderMagneticBand__c, Plc_PrinterFlapAccessory__c,
            Plc_Printer__c, Plc_PowerSupplyAccessory__c, Plc_PowerSupply__c, Plc_PosDoesNotTurnOn__c, Plc_PinPad__c, Plc_PhoneCableAccessory__c,
            Plc_StockSerial2__r.Plc_ManufacturerSerialNumber__c, Plc_StockSerial2__r.Plc_EncodedSerialNumber__c, Wrts_prcgvr__Description__c,
            Plc_Keyboard__c, Plc_EthernetCableAccessory__c, Plc_EsteticDefect__c, Plc_ECRConnectionCableAccessory__c, Plc_SecurityBlock__c, Plc_StockSerial2__r.Bit2Shop__Transfer_Order_Id__r.Plc_WorkOrder__r.WorkOrderNumber,
            Plc_ChecklistExecuted__c, Plc_StockSerial2__r.Plc_Model__c, Plc_StockSerial2__r.Plc_ProductSku__c, Plc_StockSerial2__r.Plc_TermId__r.Plc_TermIdCode__c, Plc_StockSerial2__r.Plc_Manufacturer__c, Plc_ActivityReportDateReportFault__c, Plc_WorkType__c
            FROM wrts_prcgvr__Activity__c
            WHERE Id = :id];




        if(activityToPrintList.size() > 0){
            activityToPrint = activityToPrintList;

           /* activityToPrintMap = new Map<String,wrts_prcgvr__Activity__c>();
            activityToPrintMap.put('Plc_Bluetooth__c', activityToPrintList.get(0));
            //activityToPrintMap.put('Plc_Printer__c', activityToPrintList.get(0));

            mapLabel= new Map<String, String>();
            mapValue = new Mapp<String, String>();


            for(String tempIterator : activityFields){
                String label4Iterator = 'activityToPrintList.get(0).' +tempIterator;
                String field4Iterator = 'activityToPrintList.get(0).' +tempIterator;

                mapLabel.put(tempIterator,activityToPrintList.get(0).Plc_Bluetooth__c);
                mapValue.put(tempIterator,field4Iterator);
            }
*/



        }
        System.debug('### Map for field: ' + activityToPrintMap);


    }
}