/**
 * Created by ripagano on 08/03/2018.
 * This class return a map of the following structure:
 * Keys: values of the controlling picklist
 * Values: all valid values of the dependent picklist
 *
 * If no dependencies are specified, the values associated with the keys will be empty
 */

public with sharing class GetDependentPicklist {
  public static Map<String, List<PicklistEntryWrapper>> getDependentOptionsImpl(Schema.SObjectField depField, Schema.SObjectField ctrlField) {
// validFor property cannot be accessed via a method or a property,
// so we need to serialize the PicklistEntry object and then deserialize into a wrapper.
    List<Schema.PicklistEntry> contrEntries = ctrlField.getDescribe().getPicklistValues();
    List<PicklistEntryWrapper> depEntries =
      GetDependentPicklist.wrapPicklistEntries(depField.getDescribe().getPicklistValues());

// Setup returning container - Map<ControllingValue, List<DependentValues>>
    Map<String, List<PicklistEntryWrapper>> objResults = new Map<String, List<PicklistEntryWrapper>>();
    List<String> controllingValues = new List<String>();
    
    for (Schema.PicklistEntry ple : contrEntries) {
      String value = ple.getValue();
      objResults.put(value, new List<PicklistEntryWrapper>());
      controllingValues.add(value);
    }
    
    for (PicklistEntryWrapper plew : depEntries) {
      String value = plew.value;
      String validForBits = base64ToBits(plew.validFor);
      for (Integer i = 0; i < validForBits.length(); i++) {
//        For each bit, in order : if 1 add label to list of all valid values of the dependent for the corresponding controlling value.
        String bit = validForBits.mid(i, 1);
        if (bit == '1') {
          objResults.get(controllingValues.get(i)).add(plew);
        }
      }
    }
    
    return objResults;
  }

// Convert decimal to binary representation (alas, Apex has no native method :-(
//    eg. 4 => '100', 19 => '10011', etc.
// Method: Divide by 2 repeatedly until 0. At each step note the remainder (0 or 1).
// These, in reverse order, are the binary.
  public static String decimalToBinary(Integer val) {
    String bits = '';
    while (val > 0) {
      Integer remainder = Math.mod(val, 2);
      val = Integer.valueOf(Math.floor(val / 2));
      bits = String.valueOf(remainder) + bits;
    }
    return bits;
  }

//  Conversion from string base64 to Binary representation in bits
// e.g. 'gAAA' => '100000000000000000000'
  public static String base64ToBits(String validFor) {
    if (String.isEmpty(validFor)) return '';
    
    String validForBits = '';
    
    for (Integer i = 0; i < validFor.length(); i++) {
      String thisChar = validFor.mid(i, 1);
      Integer val = base64Chars.indexOf(thisChar);
      String bits = decimalToBinary(val).leftPad(6, '0');
      validForBits += bits;
    }
    
    return validForBits;
  }
  
  
  private static final String base64Chars = '' +
    'ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
    'abcdefghijklmnopqrstuvwxyz' +
    '0123456789+/';
  
  
  private static List<PicklistEntryWrapper> wrapPicklistEntries(List<Schema.PicklistEntry> PLEs) {
    return (List<PicklistEntryWrapper>)
      JSON.deserialize(JSON.serialize(PLEs), List<PicklistEntryWrapper>.class);
  }
  
  public class PicklistEntryWrapper {
    public String active {get; set;}
    public String defaultValue {get; set;}
    public String label {get; set;}
    public String value {get; set;}
    public String validFor {get; set;}
  }
}