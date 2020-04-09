public with sharing class StockOrderExtension {
 private final NE__Order_Header__c stockOrder;
 
    public StockOrderExtension (ApexPages.StandardController stdController) {
    	this.stockOrder = (NE__Order_Header__c) stdController.getRecord();
    }
    
    public String getConfiguration(){
        //Marco Lago 03/09/2018
        List<NE__Order__c> configurationsList = [select Id from NE__Order__c where NE__Order_Header__c=: stockOrder.Id];
        if(configurationsList.size() > 0)
        	return configurationsList[0].Id;
        else return null;
    }
}