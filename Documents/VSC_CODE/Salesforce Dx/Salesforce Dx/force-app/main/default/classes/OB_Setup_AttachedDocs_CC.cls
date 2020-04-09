/*********************************************************************
Name:  OB_Setup_AttachedDocs_CC
======================================================================                                                                                                 
History                                                                                     
    AUTHOR             
    ANTONIO     		
    VATRANO
**********************************************************************/
public without sharing class OB_Setup_AttachedDocs_CC {

    @AuraEnabled
    public static Map<String, Map<String,map<String,String>>> getProductDocumentsServer(String orderId,String orderHeaderId, String ateco, String legalForm, String merchantId, String abi){
        Map<String,String> toReturn = new Map<String,String>();
        List<NE__OrderItem__c> orderItems = OB_Utility.getOrderItems(orderId);
        List<OB_Special_Category_Configuration__c> listSpecialCategory = OB_Utility.getSpecialCategory();
        Set<String> businessModel = new Set<String>();
        Set<String> setClientType = new Set<String>();
        List<String> listClientType = new List<String>();
        List<OB_Product_Document__c> listDocuments = new List<OB_Product_Document__c>();
        String mainProcess = '';
        String mcc;

        List<NE__Order__c> orders = [SELECT id, OB_MCC__c FROM NE__Order__c WHERE Id =:orderId LIMIT 1];
        if(!orders.isEmpty()){
            mcc =  orders.get(0).OB_MCC__c;
        } 
        system.debug('@@MCC: '+mcc);    
        if(!orderItems.isEmpty()){
            for(NE__OrderItem__c orderItem: orderItems)
            {
                if(mainProcess=='')
                {
                    mainProcess = orderItem.NE__OrderId__r.NE__Order_Header__r.OB_Main_Process__c;
                }
                businessModel.add(orderItem.NE__OrderId__r.NE__Order_Header__r.OB_Business_Model_Acquiring__c);
                businessModel.add(orderItem.NE__OrderId__r.NE__Order_Header__r.OB_Business_Model_POS__c);
            }
        }
        system.debug('mainProcess: '+mainProcess);
        system.debug('@@listSpecialCategory: '+listSpecialCategory);
        setClientType = OB_UtilityCallingServices.getClientTypeSet(listSpecialCategory,orderItems,mcc,ateco,legalForm,merchantId,null,abi,mainProcess);
        listClientType.addAll(setClientType);
        system.debug('clientTypes: '+listClientType);
        List<OB_Product_Document__c> listAllDocuments = OB_Utility.getAllDocuments(listClientType, mainProcess);
        for(OB_Product_Document__c doc :listAllDocuments){
            for(String b :businessModel){
                system.debug('businessModel: ' +b);
                if(doc.OB_Business_Model__c.contains(b)){
                    listDocuments.add(doc);
                }
            }
        }
        System.debug('@@documents  ' + listDocuments);
        Map<String, OB_Utility.Documents> myMap= OB_Utility.getDocumentsFromFilenet(orderHeaderId);
       Map<String, Map<String,map<String,String>>> mapdist = mapDocumentDistrinct(listDocuments);
        System.debug('mapdist: '+mapdist);
      
        
        checkNeedBio(orderId, abi, listDocuments);
        return mapdist;
    }
    public static Map<String, Map<String,map<String,String>>> mapDocumentDistrinct ( List<OB_Product_Document__c> listDocuments ){
        Map<String, Map<String,map<String,String>>> toReturn = new Map<String, Map<String,map<String,String>>>();
        Map<String,map<String,String>> mapMerchant= new Map<String,map<String,String>>();
        Map<String,map<String,String>> mapServicePoint= new Map<String,map<String,String>>();
        for(OB_Product_Document__c doc : listDocuments)
        {
            Map<String,String> details= new Map<String,String>();
            details.put('ID','');
            details.put('TYPOLOGY',doc.OB_Document_Typology__c);
            details.put('MULTIPLE',String.valueof(doc.OB_Multiple_upload__c));

            if(doc.Related_To__c== 'Merchant')
            {
                mapMerchant.put(doc.OB_Description__c, details);
            }else{
                mapServicePoint.put(doc.OB_Description__c, details);
            }  
        }
        toReturn.put('MERCHANT',mapMerchant);
        toReturn.put('SERVICEPOINT',mapServicePoint);
        return toReturn;
    }


    public static void checkNeedBio(String orderId, String abi, List<OB_Product_Document__c> listDocuments){
        List<OB_Bank_Profile__c> listBankProfile = [SELECT Id, OB_NeedBIO__c FROM OB_Bank_Profile__c WHERE OB_Bank__r.OB_ABI__c = :abi limit 1];
        if (!listBankProfile.isEmpty())
        {
            boolean needBio = listBankProfile.get(0).OB_NeedBIO__c;
            system.debug('@@@@@@@@@@@OB_NeedBIO__c: '+needBio);
            if(needBio && !listDocuments.isEmpty())
            {
                NE__Order__c o = [Select id, OB_AdditionalDocumentationRequired__c from NE__Order__c where id = :orderId limit 1];
                system.debug('Order in BIO : '+o);
                if(listDocuments.size()==1 && listDocuments[0].OB_Document_Typology__c.equalsIgnoreCase('CONTRATTO FIRMATO')){
                    o.OB_CheckApprovalProcessAcquiring__c = true;
                }
                o.OB_AdditionalDocumentationRequired__c = true;
                upsert o;   
                system.debug('Order in BIO after update: '+o);
            }
        }
    }
  
    @AuraEnabled
    public static void updateDocReqTrue (String orderHeaderId, Boolean isToTriggered){
        NE__Order_Header__c oh = [SELECT Id,OB_AdditionalDocumentationRequired__c 
                                    FROM NE__Order_Header__c 
                                    WHERE Id =:orderHeaderId];
        System.debug('OB_AdditionalDocumentationRequired__c first: ' +oh.OB_AdditionalDocumentationRequired__c);
        System.debug('OH: ' +oh);
        System.debug('isToTriggered; '+isToTriggered);
        if(isToTriggered){
            oh.OB_AdditionalDocumentationRequired__c = true;
            System.debug('OB_AdditionalDocumentationRequired__c is true: ' +oh.OB_AdditionalDocumentationRequired__c);
        }
        else{
            oh.OB_AdditionalDocumentationRequired__c = false;
        }
        upsert oh;
    }

    
}