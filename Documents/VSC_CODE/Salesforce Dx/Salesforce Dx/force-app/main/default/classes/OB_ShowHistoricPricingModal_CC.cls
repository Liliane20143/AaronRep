/*
    simone.misani@accenture.com START ON 10/04/2019 --
    -- THIS CLASS QUERY ALL CONFIGURATION ITEM RELATED  
        TO THE CONTEXT PRODUCT AND SHOW 'EM IN A TABLE 
        ID NEW DEVELOP : ####INSERISCI QUI CIO' CHE TI PASSO TESTA DI PIGNA!!!!!!--
*/

public without sharing class OB_ShowHistoricPricingModal_CC {

    public class WrapperOrder {
        @AuraEnabled 
        public String name            {get;set;}
        @AuraEnabled
        public String   installationDate     {get;set;}  //simone misani  add format for date. 13/05/2019
        @AuraEnabled 
        public String  agreed          {get;set;}  //masoud zaribaf 13/05/2019   set agreed as a string
        @AuraEnabled 
        public String variation       {get;set;}
        @AuraEnabled 
        public String prodName        {get;set;}
        @AuraEnabled 
        public String termId          {get;set;}
        @AuraEnabled 
        public String id          {get;set;}   //shaghayegh.tofighian 17/05/2019 changed Id to id
    }
    //Start---Simone.misani@accenture.com add where conditions.-06/05/2019 R1F2-91
    @AuraEnabled
    public static List<WrapperOrder> retriveInfo(String prodId, String offerId){
        //start------simone misani 16/05/2019 R1F2-133
        String orderConfigId;
        String idAsset;
        List<NE__OrderItem__c> listItem = new List<NE__OrderItem__c>();
        List<Asset> listOrderConfigFromAsset= [SELECT   id, 
                                                    name, 
                                                    NE__Order_Config__c  
                                                    FROM Asset  
                                                    WHERE id =: offerId ];
        
        if(!listOrderConfigFromAsset.isEmpty()){
            Asset orderconfig = listOrderConfigFromAsset.get(0);
            orderConfigId = orderconfig.NE__Order_Config__c;
        }

        List<Asset> listfromAsset = [   SELECT      id, 
                                                    name, 
                                                    NE__Order_Config__c  
                                        FROM        Asset  
                                        WHERE       NE__Order_Config__c  =:  orderConfigId
                                                    AND NE__ProdId__c =: prodId];
        if(!listfromAsset.isEmpty()){
            Asset configToAsset = listfromAsset.get(0);
            idAsset = configToAsset.id;
        }                            
        //end------simone misani 16/05/2019 R1F2-133
        if(!String.isEmpty(prodId)) {
 
            //Start---simone.misani 10/05/2019 R1F2-91-bis
             //Start--simone misani  add format for date. 13/05/2019
             /* Start Masoud zaribaf 13/05/2019 Modify query */
                listItem = [SELECT  NE__OrderId__r.name,
                                    NE__OrderId__c, //shaghayegh.tofighian 17/05/2019 add
                                    OB_StartValidationDate__c,
                                    NE__OrderId__r.OB_AgreedChanges__c,
                                    NE__StartDate__c, 
                                    NE__OrderId__r.OB_Variation__c 
                            FROM    NE__OrderItem__c 
                            WHERE   NE__AssetItemEnterpriseId__c=: idAsset //simone misani 16/05/2019 R1F2-133
                           
                            AND NE__OrderId__r.NE__Order_Header__r.OB_Sub_Process__c ='variazione economica'
                            AND NE__OrderId__r.NE__Type__c = 'ChangeOrder'
                            ORDER BY NE__OrderId__r.name DESC,OB_StartValidationDate__c DESC ];
                               /* end Masoud zaribaf 13/05/2019 Modify query */
            //End--simone misani  add format for date. 13/05/2019
            //End---simone.misani 10/05/2019 R1F2-91
        }
        // 
        //                 ORDER BY NE__OrderId__r.name DESC,OB_StartValidationDate__c DESC  AND NE__AssetItemEnterpriseId__c =: offerId
        //END---Simone.misani@accenture.com add where conditions.-06/05/2019 R1F2-91
        system.debug('listItem: '+listItem);
            List<WrapperOrder> listOrder =new List<WrapperOrder>();
        try{
            
            if(!listItem.isEmpty()){
                for(NE__OrderItem__c ordI : listItem){ 
                                     
                    WrapperOrder orderItem = new WrapperOrder();
                    // START shaghayegh.tofighian 17/05/2019 
                    string baseUrl = getBaseURl();
                    orderItem.id= baseUrl +'/'+ordI.NE__OrderId__c;
                    orderItem.name= ordI.NE__OrderId__r.name;
                    // END shaghayegh.tofighian 17/05/2019 
                    //simone misani  add format for date. 13/05/2019                              
                    orderItem.installationDate=String.isBlank(String.valueOf(ordI.OB_StartValidationDate__c)) ? ordI.NE__StartDate__c.format('dd-MM-yyyy') : ordI.OB_StartValidationDate__c.format('dd-MM-yyyy'); //simone misani  add format for date. 13/05/2019  
                    orderItem.agreed=(ordI.NE__OrderId__r.OB_AgreedChanges__c == true) ? 'Concordata' : 'N/a';   /* Masoud zaribaf 13/05/2019 Modify concordata */
                    orderItem.variation=ordI.NE__OrderId__r.OB_Variation__c;
                     //simone misani  add format for date. 13/05/2019          
                listOrder.add(orderItem);
                }
                
                
            }
        System.debug('inide showHistoricPicingModal list is :' + listOrder);
    }catch(Exception e ){
        System.debug('an error has occured: '+e.getmessage() + 'at the following line: '+e.getLineNumber());
    }
        return listOrder;
    }


    @AuraEnabled
	public static string getBaseURl(){
		String StringaUrl = OB_ContinuationController.getVFBaseURL();
		return StringaUrl;
	}
   

}