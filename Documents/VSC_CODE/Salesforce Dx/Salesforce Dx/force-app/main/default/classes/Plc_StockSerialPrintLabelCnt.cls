/**
 * Created by dilorenzo on 31/12/2018.
 */

public with sharing class Plc_StockSerialPrintLabelCnt {

    public List<Bit2Shop__Stock_Serials2__c> stockSerWO {get; set;}
    public List<List<String>> barcodesList {get; set;}
    public String imageUrl{get;set;}


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

    public Plc_StockSerialPrintLabelCnt(ApexPages.StandardController controller){
        String id = ApexPages.currentPage().getParameters().get('Id');
        if (ApexPages.currentPage().getParameters().get('idValueToCheck') != null) {
            list<String> id1 = (ApexPages.currentPage().getParameters().get('idValueToCheck').split(','));   
            stockSerWO = [SELECT id, Bit2Shop__Product_Stock_Id__r.Plc_ProductSku__c, Plc_Manufacturer__c, Plc_EncodedSerialNumber__c,Bit2Shop__Product_Stock_Id__r.Bit2Shop__Product_Description__c
            FROM Bit2Shop__Stock_Serials2__c WHERE Id IN :id1];            
        }
        


        if (ApexPages.currentPage().getParameters().get('idValueToCheck') == null) {
            stockSerWO = [SELECT id, Bit2Shop__Product_Stock_Id__r.Plc_ProductSku__c, Plc_Manufacturer__c, Plc_EncodedSerialNumber__c,Bit2Shop__Product_Stock_Id__r.Bit2Shop__Product_Description__c
            FROM Bit2Shop__Stock_Serials2__c WHERE Id = :id]; 
        }


   //     stockSerWO = [SELECT id, Bit2Shop__Product_Stock_Id__r.Plc_ProductSku__c, Plc_Manufacturer__c, Plc_EncodedSerialNumber__c,Bit2Shop__Product_Stock_Id__r.Bit2Shop__Product_Description__c
         //   FROM Bit2Shop__Stock_Serials2__c WHERE Id IN :id1];

        //CS per URL servizio, Non usato
        //imageUrl='https://www.barcodesinc.com/generator/image.php?code=' + stockSerWO.get(0).Plc_EncodedSerialNumber__c + '&style=68&type=C128B&width=200&height=50&xres=1&font=3';

        System.debug('### Stock Serial 2: ' + stockSerWO);

        barcodesList = new List<List<String>>();
        for (Bit2Shop__Stock_Serials2__c stockSerial : stockSerWO ) {
            barcodesList.add(getBarCodeBars(stockSerial));
        }

    }

     public String[] getBarCodeBars(Bit2Shop__Stock_Serials2__c serial) {

        String sourceCodeValue = serial.Plc_EncodedSerialNumber__c;
        Boolean shouldCheckDigit = true;

        System.debug('### Stock Serial 2: ' + stockSerWO);
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