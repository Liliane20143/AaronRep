public with sharing class Plc_StockOrderPrintLabelCnt {

    public Bit2Shop__StockOrder__c so {get; set;}
    public List<Bit2Shop__Shipment_Line_Item__c> soli {get; set;}
    public String urlLogo {get; set;}
    public String idFromCsv {get; set;}
    public List<List<String>> barcodesList {get; set;}
/**
 * Plc_StockOrderPrintLabelCnt description
 * @param  controller controller description: Use the standard controller to get the Id.
 * @return            return description: Return the value get from the query.
 */ 

    // The index for supported characters.
    //static String keys = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-. $/+%*';//Code39
    //static String keys = ' !"#$%&§()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[§]^_`abcdefghijklmnopqrstuvwxyz{|}~';//Code128
    static String keys = ' !\"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~';//Code128

    String startCodeB = '11010010000';//A'11010000100';//B 11010010000//code for START character
    String stopChar = '11000111010';//code for STOP character
    String lastChar = '11';//code for last character

    // The binary representation of each character, 11 bits each.
    static String[] values = new String[] {
        '11011001100','11001101100','11001100110','10010011000','10010001100','10001001100','10011001000','10011000100','10001100100','11001001000',
        '11001000100','11000100100','10110011100','10011011100','10011001110','10111001100','10011101100','10011100110','11001110010','11001011100',
        '11001001110','11011100100','11001110100','11101101110','11101001100','11100101100','11100100110','11101100100','11100110100','11100110010',
        '11011011000','11011000110','11000110110','10100011000','10001011000','10001000110','10110001000','10001101000','10001100010','11010001000',
        '11000101000','11000100010','10110111000','10110001110','10001101110','10111011000','10111000110','10001110110','11101110110','11010001110',
        '11000101110','11011101000','11011100010','11011101110','11101011000','11101000110','11100010110','11101101000','11101100010','11100011010',
        '11101111010','11001000010','11110001010','10100110000','10100001100','10010110000','10010000110','10000101100','10000100110','10110010000',
        '10110000100','10011010000','10011000010','10000110100','10000110010','11000010010','11001010000','11110111010','11000010100','10001111010',
        '10100111100','10010111100','10010011110','10111100100','10011110100','10011110010','11110100100','11110010100','11110010010','11011011110',
        '11011110110','11110110110','10101111000','10100011110','10001011110','10111101000','10111100010','11110101000','11110100010','10111011110',
        '10111101110','11101011110','11110101110','11010000100','11010010000','11010011100','11000111010','11'
        };
    public Plc_StockOrderPrintLabelCnt(ApexPages.StandardController controller){
        String id = ApexPages.currentPage().getParameters().get('Id');
    
        List<Bit2Shop__StockOrder__c> stockOrder = [SELECT id FROM Bit2Shop__StockOrder__c WHERE id = :id LIMIT 1];
        so = stockOrder.get(0);

      /*  List<WorkOrder> workOrder = [SELECT id, Plc_Abi__c, Plc_Cti__c, Plc_CustomerCare__c FROM WorkOrder WHERE Id = :id LIMIT 1];
        wo = workOrder.get(0);

        List <ContentDocument> listLogo = [SELECT id, Title,LatestPublishedVersionId FROM ContentDocument WHERE Title =: wo.Plc_Abi__c LIMIT 1];
        
        if(!listLogo.isEmpty()){
            urlLogo = listLogo.get(0).LatestPublishedVersionId;
            System.debug('### IMG: ' + urlLogo);
        }else{
            urlLogo = '';
        }*/

        List<Bit2Shop__Shipment_Line_Item__c> StockOrderLI = [SELECT Id,Plc_StockSerial__c,
        Bit2Shop__Shipment_Id__r.Bit2Shop__Sub_Type__c,
        Bit2Shop__Shipment_Line_Item__c.Plc_Alias__c, 
        Bit2Shop__Product_Stock_Id__r.Plc_ProductSku__c, 
        Bit2Shop__Product_Stock_Id__r.Bit2Shop__Product_Description__c,
        Plc_StockSerial__r.Plc_Manufacturer__c, 
        Plc_StockSerial__r.Plc_EncodedSerialNumber__c 
        FROM Bit2Shop__Shipment_Line_Item__c 
        WHERE Bit2Shop__Shipment_Id__r.Bit2Shop__Stock_Order_Id__c = :id 
        AND Bit2Shop__Shipment_Id__r.Bit2Shop__Sub_Type__c = 'Inbound' 
        AND Plc_StockSerial__c != '' ];

        //[START MOD 2019-08-05] @Author:Luca Belometti @Description: Get only Unique value from field Plc_StockSerial__c
        Map<String, Bit2Shop__Shipment_Line_Item__c> uniqueStockSerial = new map<String, Bit2Shop__Shipment_Line_Item__c>();
        for(Bit2Shop__Shipment_Line_Item__c record: StockOrderLI) {
            if(!uniqueStockSerial.containsKey(record.Plc_StockSerial__c)) {
            uniqueStockSerial.put(record.Plc_StockSerial__c, record);
            }
        }
        Bit2Shop__Shipment_Line_Item__c[] uniqueList = uniqueStockSerial.values();
        //[END MOD 2019-08-05] @Author:Luca Belometti @Description: Get only Unique value from field Plc_StockSerial__c
        if(StockOrderLI.size() > 0){
                system.debug('### Size maggiore di zero');
                soli = uniqueList;
        }
        System.debug('### Size Stock Order Line Item: ' + soli);
        barcodesList = new List<List<String>>();
        for (Bit2Shop__Shipment_Line_Item__c values : uniqueList ) {
            barcodesList.add(getBarCodeBars(values));
        }
    }

    public String[] getBarCodeBars(Bit2Shop__Shipment_Line_Item__c valuesFound) {

        String sourceCodeValue = valuesFound.Plc_StockSerial__r.Plc_EncodedSerialNumber__c;
        Boolean shouldCheckDigit = true;

        System.debug('### Source: ' + sourceCodeValue);

        return generateCode128(sourceCodeValue, shouldCheckDigit).split('');

     }

     // Returns a string in case we also want to debug the output.
    String generateCode128(String source, Boolean checkDigit) {
        // Output
        String[] result = new String[0];

        Integer index,
        indexTemp,
        total = 0;  // For Checksum calculation

        // Avoid System.NullPointerException
        source = source == null? '': source;
        //source = 'BDCpp102';//for Test FDL

        // Start character is START B
        //result.add(values[keys.indexOf('*')]);
        result.add(startcodeB);

        // For each character in source
        Integer position=1;
        for(String sourceChar: source.split('')) {

            // Valid character, add to checksum and output bits
            if((index = keys.indexOf(sourceChar)) > -1 ) { //&& position != 3
                System.debug('### FDL index: ' + index);
                System.debug('### FDL position: ' + position);
                result.add(values[index]);
                indexTemp = index * position;
                total += indexTemp;
                System.debug('### FDL chart 2 digit: ' + index + ' TOTAL: ' + total);
            }
            position++;
        }
        total +=104;//for checkSum typeB. Comment this line if is type A

        // Add the check digit
        if(checkDigit) {
            System.debug('### Dentr CheckSum: ' + values[Math.mod(total, 103)]);
            result.add(values[Math.mod(total, 103)]);
        }
        // Add the stop character
        //result.add(values[keys.indexOf('*')]);
        result.add(stopChar);
        result.add(lastChar);

        // Join as string
        return String.join(result,'');
    }

}