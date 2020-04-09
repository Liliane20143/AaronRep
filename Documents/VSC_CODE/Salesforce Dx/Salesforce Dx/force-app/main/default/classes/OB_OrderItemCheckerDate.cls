/**
 * OB_OrderItemCheckerDate
 *
 * @author francesca.ribezzi
 * @date Creation 30/04/2019
 * @description this class is used to update StartDate and StartValidationDate on orderItems before calling MIP
 */
public class OB_OrderItemCheckerDate {

    Public static Boolean useInTestBoolean = false; // Roland Nieznanski <roland.nieznanski@accenture.com> 13/08/2019 Boolen used only in test methods

    public static void orderItemCheckerDateServer(List<NE__Order__c> confList){
        //30/04/19 START francesca.ribezzi checking if we are on editing pricing process or on changing commission model process:
      List<NE__Order__c> commissionModelOrders = new List<NE__Order__c>();
      List<NE__Order__c> pricingOrders = new List<NE__Order__c>();
      //enrico Purificato WN-190 START
      List<Id> oderIds = new List<Id>();   
      for(NE__Order__c configuration : confList){
          oderIds.add(configuration.id);
      }
      //enrico Purificato WN-190 END
        for(NE__Order__c configuration : [SELECT Id,NE__Order_Header__r.OB_Sub_Process__c, OB_Model_Changed__c 
                                                FROM NE__Order__c 
                                                WHERE id IN :oderIds]) //enrico.purificato WN-190
        { 
            if(configuration.NE__Order_Header__r.OB_Sub_Process__c == OB_UtilityConstants.HEADER_SUBPROCESS_ECONOMICA && configuration.OB_Model_Changed__c == false){
                pricingOrders.add(configuration);
            }else if(configuration.NE__Order_Header__r.OB_Sub_Process__c == OB_UtilityConstants.HEADER_SUBPROCESS_ECONOMICA && configuration.OB_Model_Changed__c){
                commissionModelOrders.add(configuration);
            }
        }
        //enrico Purificato WN-190 START
        if(pricingOrders.size()>0){
            OB_OrderItemCheckerDate.updateStartDatePricing(pricingOrders);
        }
        if(commissionModelOrders.size()>0){
            OB_OrderItemCheckerDate.updateStartDateCommissionModel(commissionModelOrders);
        }
        //enrico Purificato WN-190 END
        //30/04/19 END francesca.ribezzi
    }

            /**
        *@author Francesca Ribezzi <francesca.ribezzi@accenture.com> 
        *@date 30/03/2019
        *@description updating StartDate and StartValidationDate on orderItems for Edit pricing process
        */
    	public static void updateStartDatePricing(List<NE__Order__c> pricingOrders){
            System.debug('im updateStartDatePricing');
            List<NE__OrderItem__c> orderItems =
            [
                SELECT 
                id,
                OB_StartValidationDate__c,
                NE__StartDate__c,
                NE__Root_Order_Item__c,
                NE__Root_Order_Item__r.OB_StartValidationDate__c,
                NE__OrderId__r.OB_AgreedChanges__c,
                NE__ProdId__r.RecordType.DeveloperName, //enrico.purificato WN-190
                NE__Root_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName, //enrico.purificato WN-190
                NE__OrderId__r.OB_Variation__c,
                OB_VariationPOSPB__c,//Simone Misani 26/07/2019 WN-67
                NE__OrderId__r.OB_ApprovalType__c//Simone Misani 26/07/2019 WN-67
                FROM NE__OrderItem__c 
                WHERE NE__Action__c = 'Change' 
                AND NE__OrderId__c IN :pricingOrders
            ];
            //START----Simone Misani 25/07/2019 wn-190
            DateTime mipDayPlusSixty = DateTime.Now().AddDays(60);
            DateTime mipDayToday = DateTime.Now();
            //Date datetoday = Date.Now();
            Integer month = DateTime.Now().month();
            Integer years = DateTime.Now().year();
            Integer countday = Date.daysInMonth(years,  month);
            Integer missingday = (countday - mipDayToday.day())+1 ;//Simone Misani 29/07/2019 
            Boolean isFirstDay = false;
            Boolean isLessTwenty = false;
            Boolean isMoreTwenty = false;
            String approvalPricingorBio;
            if(mipDayPlusSixty.day() == 1){
                isFirstDay = true;
            }
            if(mipDayToday.day()<= 20){
                isLessTwenty = true;
            }else{
                isMoreTwenty = true;
            }
            // Roland Nieznanski <roland.nieznanski@accenture.com> 13/08/2019 START
            if(Test.isRunningTest())
            {
                if ( useInTestBoolean )
                {
                    isLessTwenty = true;
                    isFirstDay = false;
                }
                else
                {
                    isMoreTwenty = true;
                    isFirstDay = true;
                }
            }
            // Roland Nieznanski <roland.nieznanski@accenture.com> 13/08/2019 END
            for(NE__OrderItem__c o : orderItems){
                approvalPricingorBio = o.NE__OrderId__r.OB_ApprovalType__c;
                Boolean agreedChanges = o.NE__OrderId__r.OB_AgreedChanges__c;
                String variation = o.NE__OrderId__r.OB_Variation__c;
                if(o.NE__Root_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName == 'Acquiring' ||o.NE__Root_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName == 'Vas')
                {
                   if(agreedChanges || (!agreedChanges && o.OB_VariationPOSPB__c == OB_UtilityConstants.MIGLIORATIVA)){
                        o.NE__StartDate__c =  DateTime.Now().AddDays(1);
                        o.NE__Root_Order_Item__r.OB_StartValidationDate__c =  DateTime.Now().AddDays(1);
                   }else if(!agreedChanges && o.OB_VariationPOSPB__c == OB_UtilityConstants.PEGGIORATIVA){
                        o.NE__StartDate__c =  DateTime.Now().AddDays(70);
                        o.NE__Root_Order_Item__r.OB_StartValidationDate__c =  DateTime.Now().AddDays(70);
                   }
                }else if(o.NE__Root_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName == 'Terminali' ||o.NE__Root_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName == 'Pagobancomat' || o.NE__Root_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName == 'eCommerce' || o.NE__Root_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName == 'Moto')// Simone Misani WN-597-09/10/2019
                {
                    if(agreedChanges){
                        o.NE__StartDate__c =  DateTime.Now().AddDays(1);
                        o.NE__Root_Order_Item__r.OB_StartValidationDate__c =  DateTime.Now().AddDays(1);
                    }else if(!agreedChanges && o.OB_VariationPOSPB__c == OB_UtilityConstants.MIGLIORATIVA && isLessTwenty){
                        o.NE__StartDate__c =  DateTime.Now();
                        o.NE__Root_Order_Item__r.OB_StartValidationDate__c =  DateTime.Now();
                    }else if(!agreedChanges && o.OB_VariationPOSPB__c == OB_UtilityConstants.MIGLIORATIVA && isMoreTwenty){
                        o.NE__StartDate__c =  DateTime.Now().AddDays(missingday);
                        o.NE__Root_Order_Item__r.OB_StartValidationDate__c =  DateTime.Now().AddDays(missingday);

                    }else if(!agreedChanges && o.OB_VariationPOSPB__c == OB_UtilityConstants.PEGGIORATIVA && isFirstDay ){

                        o.NE__StartDate__c =  DateTime.Now().AddDays(60);
                        o.NE__Root_Order_Item__r.OB_StartValidationDate__c =  DateTime.Now().AddDays(60);
                    }else if(!agreedChanges && o.OB_VariationPOSPB__c == OB_UtilityConstants.PEGGIORATIVA && !isFirstDay){
                        o.NE__StartDate__c =  DateTime.Now().AddDays(90);
                        o.NE__Root_Order_Item__r.OB_StartValidationDate__c =  DateTime.Now().AddDays(90);
                    }
                }
            }
             //END----Simone Misani 25/07/2019 wn-190
            try{
                update orderItems;
                //21/05/19 francesca.ribezzi calling OB_QueueableClass:
                //enrico.purificato WN-189 START
                for(NE__Order__c o : [SELECT Id, 
                                        OB_ApprovalType__c,
                                        NE__Order_Header__c 
                                        FROM NE__Order__c 
                                        WHERE id 
                                        IN :pricingOrders])
                {
                    if(o.OB_ApprovalType__c==null || o.OB_ApprovalType__c =='')
                    {
                        System.enqueueJob( new OB_QueueableClass( o.NE__Order_Header__c));
                    }
                }
                //enrico.purificato WN-189 END
            }		
            catch(Exception ecc)
            {
                System.debug('[EXCE] OB_QueueableClassCheckApprovalProcesses updateStartDatePricing: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
            }

        }
        /**
        *@author Francesca Ribezzi <francesca.ribezzi@accenture.com> 
        *@date 30/03/2019
        *@description updating StartDate for pricing orderItems and StartValidationDate on V/M - Edit Commission Model Process
        */
        public static void updateStartDateCommissionModel(List<NE__Order__c> commissionModelOrders){
            List<NE__OrderItem__c> orderItems =
            [
                SELECT id,OB_StartValidationDate__c, NE__StartDate__c, NE__ProdId__c, NE__ProdId__r.OB_Codice_sfdc__c,NE__Root_Order_Item__c
                FROM NE__OrderItem__c 
                WHERE ((NE__ProdId__r.RecordType.developerName = 'Pricing' AND NE__Action__c = 'Add') 
                OR (NE__Root_Order_Item__c = null AND NE__ProdId__r.OB_Codice_sfdc__c = 'visamastercard'))
                AND NE__OrderId__c  IN :commissionModelOrders
            ];
            for(NE__OrderItem__c o : orderItems){
                if(o.NE__ProdId__r.OB_Codice_sfdc__c == 'visamastercard' && o.NE__Root_Order_Item__c == null){
                    //OB_StartValidationDate__c equals to MIP send date plus one
                    o.OB_StartValidationDate__c =  DateTime.Now().AddDays(1);
                }else{
                    o.NE__StartDate__c =  DateTime.Now().AddDays(1);
                }
            }
            try{
                update orderItems;
                //21/05/19 francesca.ribezzi calling OB_QueueableClass:
                for(NE__Order__c o : commissionModelOrders){
                    System.enqueueJob( new OB_QueueableClass( o.NE__Order_Header__c));
                }
            }		
            catch(Exception ecc)
            {
                System.debug('[EXCE] OB_QueueableClassCheckApprovalProcesses updateStartDateCommissionModel: '+ecc.getMessage()+ ' at line: '+ecc.getLineNumber()+' stack trace: '+ecc.getStackTraceString());
            }
        }
        
   
}