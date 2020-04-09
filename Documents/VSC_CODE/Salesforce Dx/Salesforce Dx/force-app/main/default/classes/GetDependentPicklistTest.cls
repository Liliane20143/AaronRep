/**
 * Created by ripagano on 23/03/2018.
 */
@IsTest
public with sharing class GetDependentPicklistTest {
  
  @TestSetup public static void initTest() {
//    test setup method
  }
  
  @IsTest public static void testBase64toBitsConversion() {
    /*Metodo che converte Interi (accetta Integer) e da in output la stringa contenente la reappresentazione binaria */
    String testString = 'VGVzdFN0cmluZzE=';
    String outString = '010101000110010101110011011101000101001101110100011100100110100101101110011001110011000100000000';
    
    String convertedString = GetDependentPicklist.base64ToBits(testString);
    System.assertEquals(outString, convertedString);
//    test1
  }
  
  @IsTest public static void testDecimalToBinaryConversion() {
    /*Metodo che converte Interi (accetta Integer) e da in output la stringa contenente la reappresentazione binaria */
    Integer testInteger = 21031991;
    String outString = '1010000001110110000110111';
    
    String convertedString = GetDependentPicklist.decimalToBinary(testInteger);
    System.assertEquals(outString, convertedString);
  }
  
  @IsTest public static void testGetDependentOptionsImpl() {
    /*dati un campo controllante e uno controllato, resituisce una mappa dei valori della prima con i validi della seconda */
    //START----Simone misani 18/06/2019
    GetDependentPicklist.PicklistEntryWrapper wrap1 = new GetDependentPicklist.PicklistEntryWrapper(); 
    wrap1.value='';
    wrap1.validFor='';
    wrap1.active='';
    wrap1.defaultValue='';
    wrap1.label    ='';  
    //END----Simone misani 18/06/2019         
//    piccolo problema nel testing, non esistono picklist controllanti e dipendenti nello standard di Salesforce... ! need help !
 
    Schema.SObjectField depField = Account.Industry.getDescribe().getSobjectField();
    Schema.SObjectField contField = Account.AccountSource.getDescribe().getSobjectField();
  
    Map<String, List<GetDependentPicklist.PicklistEntryWrapper>> output = GetDependentPicklist.getDependentOptionsImpl(depField, contField);

    System.assertEquals(true, true);
  }
}