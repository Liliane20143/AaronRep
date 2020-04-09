/*****************************************************************
Name:  OB_QueueableClassTracking
============================================================
Purpose:  Queueable for update OB_FulfilmentStatus__c  to the OrderItem in Completed or not
============================================================
History
-------                                                            
VERSION  		AUTHOR         		DATE           	DETAIL           Description
VERSION  		AUTHOR         		DATE           	DETAIL         Description
1.0          	Simone Misani     20/09/2019      Created           Creation of the  class
*****************************************************************/

public class OB_QueueableClassTracking implements Queueable, Database.AllowsCallouts
{
    
    public final String data;

    public OB_QueueableClassTracking(String input)
	{
		data = input;
	}


    public void execute(QueueableContext context) 
	{

        System.debug('I AM IN A QUEUEABLE CLASS TRACKING ');
        Boolean isFirstPos = true;
        Boolean isAddPos= false;
        String mainProcess = '';
         String subProcess = '';
        List<NE__OrderItem__c> listOrderItemUpdate = new  List<NE__OrderItem__c>();
        String confId;
		try
		{
            //OB_Maintenance_Flow_Override.updateOrderItemActionNone(data);

            List<NE__OrderItem__c> orederItemList = [   SELECT  Id, 
                                                                NE__ProdId__r.Name, 
                                                                NE__ProdId__r.RecordType.DeveloperName,  
                                                                NE__Action__c, 
                                                                OB_FulfilmentStatus__c,
                                                                OB_GT__c,
                                                                NE__OrderId__r.NE__Order_Header__r.OB_Main_Process__c,
                                                                NE__OrderId__r.NE__Order_Header__r.OB_Sub_Process__c,
                                                                NE__Parent_Order_Item__c,
                                                                NE__ProdId__r.OB_Acquirer__c,
                                                                NE__OrderId__c,
                                                                (SELECT id,OB_FulfilmentStatus__c,NE__Action__c  From NE__Parent_Order_Item__r )                 
                                                        FROM    NE__orderitem__c
                                                        WHERE   NE__OrderId__r.NE__Order_Header__c = : data];

            System.debug('orederItemList: '+orederItemList);

            if(orederItemList.isEmpty()){
                return;
            }

           
            for (NE__OrderItem__c oi : orederItemList){
                if(oi.NE__ProdId__r.RecordType.DeveloperName == OB_UtilityConstants.POS_RT && (oi.NE__Action__c == OB_UtilityConstants.ORDERITEM_ACTION_NONE|| oi.NE__Action__c == OB_UtilityConstants.REMOVE_ACTION )){
                    isFirstPos = false; 
                    mainProcess = oi.NE__OrderId__r.NE__Order_Header__r.OB_Main_Process__c; 
                    subProcess = oi.NE__OrderId__r.NE__Order_Header__r.OB_Sub_Process__c;             
                }
            }
            if (mainProcess == OB_UtilityConstants.SETUP){

                return;
            }
            if(isFirstPos || subProcess == OB_UtilityConstants.HEADER_SUBPROCESS_ECONOMICA){
                OB_Maintenance_Flow_Override.updateOrderItemActionNone(data);
                return;
            }
            
             for (NE__OrderItem__c oi : orederItemList){
               
                 if(oi.NE__ProdId__r.RecordType.DeveloperName == OB_UtilityConstants.POS_RT && (oi.NE__Action__c == OB_UtilityConstants.ORDERITEM_ACTION_ADD || oi.NE__Action__c == OB_UtilityConstants.REMOVE_ACTION)){
                    isAddPos = true;
                    oi.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
                        for(NE__orderitem__c oiChild : oi.NE__Parent_Order_Item__r){
                            oiChild.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
                            listOrderItemUpdate.add(oiChild);
                        }
                    listOrderItemUpdate.add(oi);
                             
                }

                if(oi.NE__ProdId__r.RecordType.DeveloperName == OB_UtilityConstants.PAGOBANCOMAT && (oi.NE__Action__c == OB_UtilityConstants.ORDERITEM_ACTION_ADD || oi.NE__Action__c == OB_UtilityConstants.REMOVE_ACTION)&& oi.NE__Parent_Order_Item__c == null){//Simone Misani 28/10/2019 Fix Saturday.
                    oi.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
                        for(NE__orderitem__c oiChild : oi.NE__Parent_Order_Item__r){
                            oiChild.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
                            listOrderItemUpdate.add(oiChild);
                        }
                    listOrderItemUpdate.add(oi);
                             
                }

                if((oi.NE__ProdId__r.RecordType.DeveloperName == OB_UtilityConstants.ACQUIRING_RT || oi.NE__ProdId__r.RecordType.DeveloperName == OB_UtilityConstants.PRODUCT_RECORDTYPE_VAS) && oi.NE__ProdId__r.OB_Acquirer__c != OB_UtilityConstants.GT_NEXICAPS && (oi.NE__Action__c == OB_UtilityConstants.ORDERITEM_ACTION_ADD || oi.NE__Action__c == OB_UtilityConstants.REMOVE_ACTION) && oi.NE__Parent_Order_Item__c == null){
                    oi.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
                        for(NE__orderitem__c oiChild : oi.NE__Parent_Order_Item__r){
                            oiChild.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
                            listOrderItemUpdate.add(oiChild);
                        }
                    listOrderItemUpdate.add(oi);
                }
                if(oi.NE__Action__c == OB_UtilityConstants.ORDERITEM_ACTION_NONE && oi.NE__Parent_Order_Item__c == null){
                    oi.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
                    listOrderItemUpdate.add(oi);
                     for(NE__orderitem__c oiChild : oi.NE__Parent_Order_Item__r){
                            oiChild.OB_FulfilmentStatus__c = OB_UtilityConstants.FULFILMENTSTATUS_COMPLETED;
                            listOrderItemUpdate.add(oiChild);
                        }

                }
            }
            if( !listOrderItemUpdate.isEmpty()){
                confId = orederItemList.get(0).NE__OrderId__c;
                update listOrderItemUpdate;
                NE__Order__c orderUpdate = new NE__Order__c(Id = confId, OB_FirstorSecondTracking__c = 'First Tracking');
                update orderUpdate;
                OB_TrackingOrderMaintenance.updateLogRequest(confId);
            }
                                                      

        }	catch(Exception ecc)
		{
			System.debug('[EXCE] OB_QueueableClassTracking '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
		}
    }



}