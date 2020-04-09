public class OB_FilterWrapper{
	public String column;	//NE__Order_Header__c.OB_CAB__c
	public Boolean isRunPageEditable;
	public String operator;	//equals
	public String value;	//
	public String label;	//CAB
	public String type;	//STRING_DATA
	public List<cls_filterValues> filterValues;
	public List<String> stringValues = null;	//
	
	public class cls_filterValues {
		public String name;			
		public String label;
	}
	
	public static List<OB_FilterWrapper> parse(String json){
		return (List<OB_FilterWrapper>) System.JSON.deserialize(json, List<OB_FilterWrapper>.class);
	}
}