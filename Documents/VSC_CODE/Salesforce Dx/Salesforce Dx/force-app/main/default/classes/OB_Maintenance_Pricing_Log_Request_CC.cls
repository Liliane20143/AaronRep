public class OB_Maintenance_Pricing_Log_Request_CC {
    @AuraEnabled
    public static String retrieveLogRequest(id logRequestId){
        RequestPricing reqPricing = new RequestPricing();
        try{

            List<OB_LogRequest__c> requestList = [SELECT Id,OB_Status__c,OB_Start_Date_POS__c,OB_Start_Date_Acquiring__c,OB_HasPos__c,OB_HasAcquiring__c,OB_OrderId__c 
                                                FROM OB_LogRequest__c 
                                                WHERE id = : logRequestId 
                                                LIMIT 1];
            
            system.debug('@#OB_LogRequest__c'+requestList);
            reqPricing.isApprovingProfile = getVisibilityProfiles(requestList.get(0));
            if(!requestList.isEmpty()){
                reqPricing.listOfRow = requestList;
                // reqPricing.isButtonsPushed = OB_Maintenance_Pricing_Log_Request_CC.isRejectedPushed(requestList.get(0).OB_OrderId__c);
                // system.debug('@#isButtonsPushed'+ reqPricing.isButtonsPushed);
            }else{
                reqPricing.errorMessage = 'Verificare che sia presente una Log Request';
            }

        }catch(Exception e){

            reqPricing.errorMessage = 'Exception OB_Maintenance_Pricing_Log_Request_CC:retrieveLogRequest' + e.getMessage() + ' at line: ' + e.getLineNumber() + ' StackTrace: '
             + e.getStackTraceString();
        }
        return JSON.serialize(reqPricing);

    }

    public class RequestPricing{
        @auraEnabled
        public string errorMessage;
        @auraEnabled
        public Boolean isApprovingProfile;

        @AuraEnabled
        public list<OB_LogRequest__c> listOfRow;
        // @AuraEnabled
        // public Map<String,Boolean> isButtonsPushed;
            public RequestPricing(){
                this.errorMessage='';
                this.isApprovingProfile=false;
                this.listOfRow = new list<OB_LogRequest__c>();
                // this.isButtonsPushed = new Map<String,Boolean>();
            }
    }
    
    public static Boolean getVisibilityProfiles(OB_LogRequest__c logrequest){
        Boolean isApprovingProfile = false;
        String userId = UserInfo.getUserId();
        list<User> listOfUsers = [  SELECT  Id, Profile.Name, Profile.UserLicense.Name
                                        FROM    User
                                        WHERE   Id =: userId
                                        LIMIT   1   ];
        if(!listOfUsers.isEmpty())
        {
            User user= listOfUsers.get(0);
            String license = user.Profile.UserLicense.Name;
            String profile = user.Profile.Name;
            System.debug('license:  '+license);
            System.debug('profile:  '+profile);

            String confInfProfiles;
            //Boolean profileIsInConfInf = false;
            OB_ConfigurationInformation__mdt configurationInformation = new OB_ConfigurationInformation__mdt();
            OB_ConfigurationInformation__mdt[] listOfConfigurationInformations = [  SELECT Id,MasterLabel,Label,QualifiedApiName,OB_String_Value__c
                                                                                    FROM OB_ConfigurationInformation__mdt 
                                                                                    WHERE QualifiedApiName = 'OB_Maintenance_Pricing_Consistency'   ];
            if(!listOfConfigurationInformations.isEmpty())
            {
                configurationInformation = listOfConfigurationInformations.get(0);
                confInfProfiles = configurationInformation.OB_String_Value__c;
                System.debug('@confInfProfiles : ' +  confInfProfiles);
                isApprovingProfile = confInfProfiles.contains(profile);
                System.debug('@isApprovingProfile : ' +  isApprovingProfile);
            }

        }
        return isApprovingProfile;
   }
   @AuraEnabled
   public static void saveDatePOS(Datetime startDatePOS, String logRequestId){
        
        Boolean isConfirmed = false;        
        OB_LogRequest__c log = new OB_LogRequest__c();
        List<NE__OrderItem__c> orList = new List<NE__OrderItem__c>();
        NE__Order__c config = new NE__Order__c();
        Savepoint sp = Database.setSavepoint();

        try{

            List<OB_LogRequest__c> requestList = [SELECT Id,OB_Status__c,OB_Start_Date_POS__c,OB_Start_Date_Acquiring__c,OB_HasPos__c,OB_HasAcquiring__c,OB_OrderId__c
                                                    ,OB_OrderId__r.NE__AccountId__c, OB_OrderId__r.OB_Service_Point__c 
                                                    FROM OB_LogRequest__c 
                                                    WHERE id = : logRequestId 
                                                    LIMIT 1];


            log = requestList.get(0);
            if(startDatePOS!=null){
                log.OB_Start_Date_POS__c = startDatePOS;
            }
            // if(isAcquiring && startDateAcquiring!=null){
            //     log.OB_Start_Date_Acquiring__c = startDateAcquiring;
            // }
            system.debug('OB_LogRequest__c'+ log);      
            
            

            List<NE__OrderItem__c> orderItemsList = [SELECT NE__Action__c,NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName, RecordType.DeveloperName,OB_StartValidationDate__c
                                                           FROM NE__OrderItem__c 
                                                           WHERE NE__Action__c !='None' 
                                                           AND NE__ProdId__r.RecordType.DeveloperName = 'Pricing' 
                                                           AND NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName 
                                                           IN ('Acquiring','VAS','Terminali','Pagobancomat','PCI') AND NE__OrderId__c = :log.OB_OrderId__c];
            
            system.debug('List<NE__OrderItem__c>' +orderItemsList);          

            List<NE__Order__c> orderList = [SELECT id,NE__OrderStatus__c,OB_FulfilmentStatus__c FROM  NE__Order__c WHERE id = :log.OB_OrderId__c];

            config = orderList.get(0);                                               

            for(NE__OrderItem__c ori : orderItemsList){
                // system.debug('NE__OrderItem__c'+ ori);
                // if(isAcquiring && (ori.NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName.equalsIgnoreCase('Acquiring') ||
                //      ori.NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName.equalsIgnoreCase('VAS'))){
                //         if(ori.NE__Action__c=='Remove'){
                //             ori.NE__EndDate__c =  startDateAcquiring;
                //            } else{
                //             ori.NE__StartDate__c =  startDateAcquiring;
                //            }
                        
                //         ori.NE__Account__c          = log.OB_OrderId__r.NE__AccountId__c;
                //         ori.NE__Service_Account__c  = log.OB_OrderId__r.NE__AccountId__c;
                //         ori.NE__Billing_Account__c  = log.OB_OrderId__r.NE__AccountId__c;
                //         ori.NE__Service_Point__c    = log.OB_OrderId__r.OB_Service_Point__c;

                //         ori.OB_FulfilmentStatus__c   = 'Completed';
                //         orList.add(ori);
                //         // system.debug('NE__OrderItem__c in if acq'+ ori);
                // }
                if( (ori.NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName.equalsIgnoreCase('Pagobancomat') ||
                     ori.NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName.equalsIgnoreCase('Terminali'))){
                        ori.NE__StartDate__c =  startDatePOS;
                        ori.OB_FulfilmentStatus__c   = 'Completed';
                        if((ori.NE__Action__c).equalsIgnoreCase('change')){
                            if(ori.NE__Root_Order_Item__c == null) {
                                ori.OB_StartValidationDate__c = startDatePOS;
                            }
                        } 
                        orList.add(ori);
                        // system.debug('NE__OrderItem__c in if pos'+ ori);
                }
            }
            system.debug('NE__OrderItem__c to update'+ orList);
            Database.update(orList);

            system.debug('List<NE__OrderItem__c> new' +orList); 
            if(orderItemsList.size()>0){
                isConfirmed = OB_Maintenance_Pricing_Log_Request_CC.confirmOrder(log.OB_OrderId__c);
                if(isConfirmed){
                    log.OB_Status__c = 'Confermato';
                    config.OB_FulfilmentStatus__c = 'Completed';
                    config.NE__OrderStatus__c = 'Completed';
                }
            }
            Database.update(log);
            system.debug('NE__Order__c'+ config);   
            Database.update(config);
            system.debug('OB_LogRequest__c after update'+ log); 
        }catch(Exception e){
            Database.rollback(sp);
            system.debug(logginglevel.error,'Exception in saveDate - '+e.getMessage()+'At line '+e.getLineNumber()+' where '+e.getStackTraceString());
        }
   }
    @AuraEnabled
   public static void saveDateAcquiring(Datetime startDateAcquiring, String logRequestId){
        
        Boolean isConfirmed = false;        
        OB_LogRequest__c log = new OB_LogRequest__c();
        List<NE__OrderItem__c> orList = new List<NE__OrderItem__c>();
        NE__Order__c config = new NE__Order__c();
        Savepoint sp = Database.setSavepoint();

        try{

            List<OB_LogRequest__c> requestList = [SELECT Id,OB_Status__c,OB_Start_Date_POS__c,OB_Start_Date_Acquiring__c,OB_HasPos__c,OB_HasAcquiring__c,OB_OrderId__c
                                                    ,OB_OrderId__r.NE__AccountId__c, OB_OrderId__r.OB_Service_Point__c 
                                                    FROM OB_LogRequest__c 
                                                    WHERE id = : logRequestId 
                                                    LIMIT 1];


            log = requestList.get(0);
            // if(isPOS && startDatePOS!=null){
            //     log.OB_Start_Date_POS__c = startDatePOS;
            // }
            if(startDateAcquiring!=null){
                log.OB_Start_Date_Acquiring__c = startDateAcquiring;
            }
            system.debug('OB_LogRequest__c'+ log);      
            
            

            List<NE__OrderItem__c> orderItemsList = [SELECT NE__Action__c,NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName, RecordType.DeveloperName,OB_StartValidationDate__c
                                                           FROM NE__OrderItem__c 
                                                           WHERE NE__Action__c !='None' 
                                                           AND NE__ProdId__r.RecordType.DeveloperName = 'Pricing' 
                                                           AND NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName 
                                                           IN ('Acquiring','VAS','Terminali','Pagobancomat','PCI') AND NE__OrderId__c = :log.OB_OrderId__c];
            
            system.debug('List<NE__OrderItem__c>' +orderItemsList);          

            List<NE__Order__c> orderList = [SELECT id,NE__OrderStatus__c,OB_FulfilmentStatus__c FROM  NE__Order__c WHERE id = :log.OB_OrderId__c];

            config = orderList.get(0);                                               
 
            for(NE__OrderItem__c ori : orderItemsList){
                // system.debug('NE__OrderItem__c'+ ori);
                if(ori.NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName.equalsIgnoreCase('Acquiring') ||
                     ori.NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName.equalsIgnoreCase('VAS') || 
                     ori.NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName.equalsIgnoreCase('PCI')){
                        if(ori.NE__Action__c=='Remove'){
                            ori.NE__EndDate__c =  startDateAcquiring;
                           } else if((ori.NE__Action__c).equalsIgnoreCase('Change') || (ori.NE__Action__c).equalsIgnoreCase('Add')){
                                ori.NE__StartDate__c =  startDateAcquiring;
                                if(ori.NE__Root_Order_Item__c == null) {
                                    ori.OB_StartValidationDate__c =  startDateAcquiring;
                                }
                           }
                        
                        ori.NE__Account__c          = log.OB_OrderId__r.NE__AccountId__c;
                        ori.NE__Service_Account__c  = log.OB_OrderId__r.NE__AccountId__c;
                        ori.NE__Billing_Account__c  = log.OB_OrderId__r.NE__AccountId__c;
                        ori.NE__Service_Point__c    = log.OB_OrderId__r.OB_Service_Point__c;

                        ori.OB_FulfilmentStatus__c   = 'Completed';
                        orList.add(ori);
                        // system.debug('NE__OrderItem__c in if acq'+ ori);
                }
                // if(isPOS && (ori.NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName.equalsIgnoreCase('Pagobancomat') ||
                //      ori.NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName.equalsIgnoreCase('Terminali'))){
                //         ori.NE__StartDate__c =  startDatePOS;
                //         ori.OB_FulfilmentStatus__c   = 'Completed';
                //         orList.add(ori);
                //         // system.debug('NE__OrderItem__c in if pos'+ ori);
                // }
            }
            system.debug('NE__OrderItem__c to update'+ orList);
            Database.update(orList);

            system.debug('List<NE__OrderItem__c> new' +orList); 
            if(orderItemsList.size()>0){
                isConfirmed = OB_Maintenance_Pricing_Log_Request_CC.confirmOrder(log.OB_OrderId__c);
                system.debug('isConfirmed '+isConfirmed);
                if(isConfirmed){
                    log.OB_Status__c = 'Confermato';
                    config.OB_FulfilmentStatus__c = 'Completed';
                    config.NE__OrderStatus__c = 'Completed';
                }
            }
            Database.update(log);
            system.debug('NE__Order__c'+ config);   
            Database.update(config);
            system.debug('OB_LogRequest__c after update'+ log); 
        }catch(Exception e){
            Database.rollback(sp);
            system.debug(logginglevel.error,'Exception in saveDate - '+e.getMessage()+'At line '+e.getLineNumber()+' where '+e.getStackTraceString());
        }
   }
    @AuraEnabled
    public static void rejectRequestAcquiring(String logRequestId){

        Boolean isRejected = false;     
        Boolean isConfirmed = false;    
        OB_LogRequest__c log = new OB_LogRequest__c();
        List<NE__OrderItem__c> orList = new List<NE__OrderItem__c>();
        NE__Order__c config = new NE__Order__c();
        Savepoint sp = Database.setSavepoint();

        try{

            List<OB_LogRequest__c> requestList = [SELECT Id,OB_Status__c,OB_Start_Date_POS__c,OB_Start_Date_Acquiring__c,OB_HasPos__c,OB_HasAcquiring__c,OB_OrderId__c  
                                                    FROM OB_LogRequest__c 
                                                    WHERE id = : logRequestId 
                                                    LIMIT 1];


            log = requestList.get(0);


            List<NE__Order__c> orderList = [SELECT id,NE__OrderStatus__c,OB_FulfilmentStatus__c FROM  NE__Order__c WHERE id = :log.OB_OrderId__c];

            config = orderList.get(0);

            List<NE__OrderItem__c> orderItemsList = [SELECT NE__Action__c,NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName, RecordType.DeveloperName
                                                           FROM NE__OrderItem__c 
                                                           WHERE NE__Action__c !='None' 
                                                           AND NE__ProdId__r.RecordType.DeveloperName = 'Pricing' 
                                                           AND NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName 
                                                           IN ('Acquiring','VAS','Terminali','Pagobancomat','PCI') AND NE__OrderId__c = :log.OB_OrderId__c];
            
            system.debug('List<NE__OrderItem__c>' +orderItemsList);                                                         

            for(NE__OrderItem__c ori : orderItemsList){
                if( (ori.NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName.equalsIgnoreCase('Acquiring') ||
                     ori.NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName.equalsIgnoreCase('VAS'))){
                        ori.OB_FulfilmentStatus__c   = 'Cancelled';
                        orList.add(ori);
                }
                // if(isPOS && (ori.NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName.equalsIgnoreCase('Pagobancomat') ||
                //      ori.NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName.equalsIgnoreCase('Terminali'))){
                //         ori.OB_FulfilmentStatus__c   = 'Cancelled';
                //         orList.add(ori);
                // }
            }

            Database.update(orList);

            system.debug('List<NE__OrderItem__c> new' +orList); 
            if(orderItemsList.size()>0){
                isRejected = OB_Maintenance_Pricing_Log_Request_CC.rejectOrder(log.OB_OrderId__c,orderItemsList.size());
                
                if(isRejected){
                    log.OB_Status__c = 'Rifiutato';
                    config.NE__OrderStatus__c = 'Cancelled';
                    config.OB_FulfilmentStatus__c = 'Cancelled';
                    //NE.OrderSummaryButtonExtension.cancelButton(idOrdine);
                } else if (OB_Maintenance_Pricing_Log_Request_CC.confirmOrder(log.OB_OrderId__c)){
                    log.OB_Status__c = 'Confermato';
                    config.OB_FulfilmentStatus__c = 'Completed';
                    config.NE__OrderStatus__c = 'Completed';
                }
            }
            system.debug('NE__Order__c'+ config);   
            Database.update(config);
            Database.update(log);
            system.debug('OB_LogRequest__c after update'+ log); 
        }catch(Exception e){
            Database.rollback(sp);
            system.debug(logginglevel.error,'Exception in saveDate - '+e.getMessage()+'At line '+e.getLineNumber()+' where '+e.getStackTraceString());
        }
   }
     @AuraEnabled
    public static void rejectRequestPOS(String logRequestId){

        Boolean isRejected = false;     
        Boolean isConfirmed = false;    
        OB_LogRequest__c log = new OB_LogRequest__c();
        List<NE__OrderItem__c> orList = new List<NE__OrderItem__c>();
        NE__Order__c config = new NE__Order__c();
        Savepoint sp = Database.setSavepoint();

        try{

            List<OB_LogRequest__c> requestList = [SELECT Id,OB_Status__c,OB_Start_Date_POS__c,OB_Start_Date_Acquiring__c,OB_HasPos__c,OB_HasAcquiring__c,OB_OrderId__c  
                                                    FROM OB_LogRequest__c 
                                                    WHERE id = : logRequestId 
                                                    LIMIT 1];


            log = requestList.get(0);


            List<NE__Order__c> orderList = [SELECT id,NE__OrderStatus__c,OB_FulfilmentStatus__c FROM  NE__Order__c WHERE id = :log.OB_OrderId__c];

            config = orderList.get(0);

            List<NE__OrderItem__c> orderItemsList = [SELECT NE__Action__c,NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName, RecordType.DeveloperName
                                                           FROM NE__OrderItem__c 
                                                           WHERE NE__Action__c !='None' 
                                                           AND NE__ProdId__r.RecordType.DeveloperName = 'Pricing' 
                                                           AND NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName 
                                                           IN ('Acquiring','VAS','Terminali','Pagobancomat','PCI') AND NE__OrderId__c = :log.OB_OrderId__c];
            
            system.debug('List<NE__OrderItem__c>' +orderItemsList);                                                         

            for(NE__OrderItem__c ori : orderItemsList){
                // if(isAcquiring && (ori.NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName.equalsIgnoreCase('Acquiring') ||
                //      ori.NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName.equalsIgnoreCase('VAS'))){
                //         ori.OB_FulfilmentStatus__c   = 'Cancelled';
                //         orList.add(ori);
                // }
                if((ori.NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName.equalsIgnoreCase('Pagobancomat') ||
                     ori.NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName.equalsIgnoreCase('Terminali'))){
                        ori.OB_FulfilmentStatus__c   = 'Cancelled';
                        orList.add(ori);
                }
            }

            Database.update(orList);

            system.debug('List<NE__OrderItem__c> new' +orList); 
            if(orderItemsList.size()>0){
                isRejected = OB_Maintenance_Pricing_Log_Request_CC.rejectOrder(log.OB_OrderId__c,orderItemsList.size());
                
                if(isRejected){
                    log.OB_Status__c = 'Rifiutato';
                    config.NE__OrderStatus__c = 'Cancelled';
                    config.OB_FulfilmentStatus__c = 'Cancelled';
                    //NE.OrderSummaryButtonExtension.cancelButton(idOrdine);
                } else if (OB_Maintenance_Pricing_Log_Request_CC.confirmOrder(log.OB_OrderId__c)){
                    log.OB_Status__c = 'Confermato';
                    config.OB_FulfilmentStatus__c = 'Completed';
                    config.NE__OrderStatus__c = 'Completed';
                }
            }
            system.debug('NE__Order__c'+ config);   
            Database.update(config);
            Database.update(log);
            system.debug('OB_LogRequest__c after update'+ log); 
        }catch(Exception e){
            Database.rollback(sp);
            system.debug(logginglevel.error,'Exception in saveDate - '+e.getMessage()+'At line '+e.getLineNumber()+' where '+e.getStackTraceString());
        }
   }

   private static Boolean confirmOrder(String orderId){
        Boolean isConfirmed = false; 
        Integer numberUtilToSave = [SELECT COUNT() FROM NE__OrderItem__c 
                                    WHERE NE__OrderId__c =:orderId 
                                          //e.p. 29/2/19
                                          // AND NE__Action__c='Change' 
                                          AND NE__Action__c !='None' 
                                          //e.p. 29/2/19 
                                          AND NE__ProdId__r.RecordType.DeveloperName = 'Pricing' 
                                          AND OB_FulfilmentStatus__c != 'Completed'
                                          AND OB_FulfilmentStatus__c != 'Cancelled'];
        system.debug('numberUtilToSave '+numberUtilToSave);
        if(numberUtilToSave ==0){
            system.debug('Asset in creation');
            OB_UtilityCallingServices.createAsset(orderId, 'Maintenance');
            isConfirmed = true;
        }
        return isConfirmed;
   }

   private static Boolean rejectOrder (String orderId, Integer orderItemsListSize){
        Boolean isRejected = false; 
        Integer numberUtilToSave = [SELECT COUNT() FROM NE__OrderItem__c 
                                    WHERE NE__OrderId__c =:orderId 
                                          //e.p. 29/2/19
                                          // AND NE__Action__c='Change' 
                                          AND NE__Action__c !='None' 
                                          //e.p. 29/2/19
                                          AND NE__ProdId__r.RecordType.DeveloperName = 'Pricing' 
                                          AND OB_FulfilmentStatus__c = 'Cancelled'];
        if(numberUtilToSave == orderItemsListSize){
            isRejected = true;
        }
        return isRejected;
   }

   private static Map<String,Boolean> isRejectedPushed (String configId){
       Map<String,Boolean> buttonsPushed = new Map<String,Boolean>();
       List<NE__OrderItem__c> orderItemsList = [SELECT NE__Action__c,NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName, RecordType.DeveloperName
                                                           FROM NE__OrderItem__c 
                                                           WHERE NE__Action__c !='None' 
                                                           AND NE__ProdId__r.RecordType.DeveloperName = 'Pricing' 
                                                           AND NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName 
                                                           IN ('Acquiring','VAS','Terminali','Pagobancomat') AND NE__OrderId__c = :configId];
            
            system.debug('List<NE__OrderItem__c> isRejectedPushed' +orderItemsList);                                                         

            for(NE__OrderItem__c ori : orderItemsList){
                if((ori.NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName.equalsIgnoreCase('Pagobancomat') 
                    || ori.NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName.equalsIgnoreCase('Terminali')) 
                     && ori.OB_FulfilmentStatus__c   == 'Cancelled'){
                         buttonsPushed.put('POS',true);
                     }
                     if((ori.NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName.equalsIgnoreCase('Acquiring') ||
                     ori.NE__Parent_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName.equalsIgnoreCase('VAS')) 
                     && ori.OB_FulfilmentStatus__c   == 'Cancelled'){
                         buttonsPushed.put('Acquiring',true);
                     }
            }
            system.debug('buttonsPushed' +buttonsPushed);
            return buttonsPushed;
    }
    // Start antonio.vatrano 13/05/2019 RI-61 method to retrieve information of required fields of LOGREQUEST
    @AuraEnabled
    public static String retrieveRequiredFields (String logRequestId){
        String toReturn = '';
        List <OB_LogRequest__c> listLogRequest= [SELECT id, OB_Requestor__c, OB_RequestDate__c FROM OB_LogRequest__c WHERE id =: logRequestId LIMIT 1];
        if(!listLogRequest.isEmpty()){
            OB_LogRequest__c currentLogRequest = listLogRequest.get(0);
            toReturn = returnErrorString(currentLogRequest);
        }
        return toReturn;
    }
    // End antonio.vatrano 13/05/2019 RI-61
    //  Start antonio.vatrano 13/05/2019 RI-61 method to retrieve label of fields
    public static String retrievelabel(String obj, String field){
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(obj);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        return fieldMap.get(field).getDescribe().getLabel();
    }
    //  End antonio.vatrano 13/05/2019 RI-61 method to retrieve label of fields
    //  Start antonio.vatrano 13/05/2019 RI-61 method to retrieve information of required fields
    public static String returnErrorString(OB_LogRequest__c log){
        String error = '';
        String requestorLabel =retrievelabel('OB_LogRequest__c','ob_requestor__c');
        String requestDateLabel = retrievelabel('OB_LogRequest__c','ob_requestdate__c');
        if(String.isBlank(log.OB_Requestor__c)){
            error += requestorLabel+', ';
        }
        if(String.isBlank(String.valueof(log.OB_RequestDate__c))){
            error += requestDateLabel+', ';
        }
        return error.removeEnd(', ');
    }
    //  End antonio.vatrano 13/05/2019 RI-61 method to retrieve information of required fields
}