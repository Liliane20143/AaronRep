public with sharing class LineAttributeController {
    //ApexPages.currentPage().getParameters().get( 
    public Set<String> orderItemSetId;
    public List<NE__OrderItem__c> oiLIst {get;set;}
    private final NE__Order__c o;
    public LineAttributeController(ApexPages.StandardController stdController){
        this.o = (NE__Order__c)stdController.getRecord();
        
        System.debug(o);
		
		System.debug(o.NE__Order_Items__r);
       /* orderItemSetId = new Set<String>();
        for(NE__OrderItem__c oi: o.NE__Order_Items__r)
			orderItemSetId.add(oi.Id);*/
		
		oiList = [select id, Name, NE__ProdName__c,NE__OrderId__c, (SELECT id, Name, NE__Value__c FROM NE__Order_Item_Attributes__r) FROM NE__OrderItem__c WHERE NE__OrderId__c = :o.id ];
		
		
        
    }
    
    public class itemsAttributes{
        
        
    }
    

    public static List<NE__Order_Item_Attribute__c> getConfigItemAttribute(List<NE__OrderItem__c> orderItems){
      
        //List<NE__Order_Item_Attribute__c> itemAttributes= [SELECT Id, Name, NE__Value__c FROM NE__Order_Item_Attribute__c WHERE NE__Order_Item__c IN : orderItemSetId];
		
		
     
        return null;
    }

}