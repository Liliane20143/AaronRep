/****************w*************************************************
Name: OB_ConfigOfferProductsSellingCC 
============================================================
Purpose:  Class used to configure which products sell for each ABI

History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0      Francesca Ribezzi        15/05/2019                             
********************************************************************************/

public with sharing class OB_ConfigOfferProductsSellingCC {
 /*
    *@author Francesca Ribezzi <francesca.ribezzi@accenture.com> 
    *@date 15/05/2019
    *@description this method is used to get the root matrix parameters available for the selected offer
    */
    @AuraEnabled
    public static Map<String, List<NE__Matrix_Parameter__c>> getMatrixParameterByOffer(NE__bundle__c bundle, Boolean isPricingForBank, String abi){
       String bundleId = bundle.id;
       String isEqual = isPricingForBank? '<>' : '=';
       String queryABI = isPricingForBank? ' AND OB_ABI__c = :abi' : ' AND OB_ABI__c = null';    //davide.franzini - WN-124 - 18/07/2019
       String isActive = isPricingForBank ? ' AND NE__Active__c = true' : ''; // ANDREA MORITTU START - 16-Jul-19 - F2WAVE2-141
        //START francesca.ribezzi 10/06/19 checking if we are in pricing for bank:
        //davide.franzini - 01/08/2019 - added cab filter
        String query = 'SELECT id, Name,OB_ABI__c, NE__Active__c, OB_ActiveBank__c, NE__End_Date__c,'+
            'NE__Start_Date__c,OB_ModelloAcquiring__c, OB_SchemaPrezzi__c, OB_Componente__c, OB_Componente__r.NE__Product_Name__c,'+
            'OB_Componente__r.NE__Item_Header__c, OB_Listino__r.Name,OB_Componente__r.NE__ProductId__r.RecordType.DeveloperName,'+
            'OB_MainMP__c,OB_Offerta__c,OB_ABIcatItemIdBundleId__c'+ 
            ' FROM NE__Matrix_Parameter__c'+
            ' WHERE OB_Cab__c = null AND OB_Offerta__c = :bundleId'+
            ' AND OB_MainMP__c'+isEqual+'null'+ queryABI + isActive + 
            ' ORDER BY OB_Componente__r.NE__ProductId__r.RecordType.DeveloperName, Name';
        System.debug('query: ' + query);
        //getting source matrix parameters:
      /*  List<NE__Matrix_Parameter__c> matrixParameters =
        [
            SELECT id, 
            Name,
            OB_ABI__c, 
            NE__Active__c,
            OB_ActiveBank__c,
            NE__End_Date__c,
            NE__Start_Date__c,
            OB_ModelloAcquiring__c, 
            OB_SchemaPrezzi__c, 
            OB_Componente__c, 
            OB_Componente__r.NE__Product_Name__c,
            OB_Componente__r.NE__Item_Header__c, 
            OB_Listino__r.Name,
            OB_Componente__r.NE__ProductId__r.RecordType.DeveloperName,
            OB_MainMP__c,
            OB_Offerta__c,
            OB_ABIcatItemIdBundleId__c
            FROM NE__Matrix_Parameter__c 
            WHERE OB_Offerta__c = :bundle.id
            AND OB_MainMP__c = null
            ORDER BY OB_Componente__r.NE__ProductId__r.RecordType.DeveloperName, Name
        ];*/
        //getting source matrix parameters or abi matrix parameters:
        List<NE__Matrix_Parameter__c> matrixParameters = Database.query(query);
        //END francesca.ribezzi 10/06/19 

        System.debug('matrixParameters size: ' + matrixParameters.size() );
        Map<String, List<NE__Matrix_Parameter__c>> recordTypeMatrixParametersMap = new Map<String, List<NE__Matrix_Parameter__c>>();
        for(NE__Matrix_Parameter__c matrix : matrixParameters){ 
            String recordType = matrix.OB_Componente__r.NE__ProductId__r.RecordType.DeveloperName;
            if(recordTypeMatrixParametersMap.containsKey(recordType)){
                List<NE__Matrix_Parameter__c> tempList = recordTypeMatrixParametersMap.get(recordType);
                tempList.add(matrix); 
                recordTypeMatrixParametersMap.put(recordType, tempList); 
            }else{
                recordTypeMatrixParametersMap.put(recordType, new List<NE__Matrix_Parameter__c> {matrix});
            }
        }
        System.debug('recordTypeMatrixParametersMap: ' + recordTypeMatrixParametersMap);
        return recordTypeMatrixParametersMap; 
    }

    @AuraEnabled //francesca.ribezzi 17/06/19 changing return type from void into boolean
    public static Boolean cloneMatrixParameterServer(List<NE__Matrix_Parameter__c> matrixParameters, Map<String,List<String>> matrixIdAbiListmap, String service){ 
        //francesca.ribezzi 17/06/19 adding boolean
        Boolean isOkSize;     
        try{
            system.debug('## matrixIdAbiListmap'+JSON.serializePretty(matrixIdAbiListmap));
            Map<String,Set<String>> matrixIdAbiSetmap = new Map<String,Set<String>>();
            Set<String> abiList = new Set<String>();
            //francesca.ribezzi 17/06/19 adding OB_JobStorage__c list:
            List<OB_JobStorage__c> jobStorageList = new List<OB_JobStorage__c>();
            for(String key : matrixIdAbiListmap.keyset()){
                abiList.addAll(matrixIdAbiListmap.get(key));
                matrixIdAbiSetmap.put(key,new Set<String>(matrixIdAbiListmap.get(key)));
            }
            //francesca.ribezzi 17/06/19 adding if condition:
            if(abiList.size() < 50){
                //davide.franzini - START
                for(String abi : abiList){
                    system.debug('## abi: '+abi);
                    // limit to Max 50 queueable call -TO DO 
                    if(abi!=null && abi != 'null'){
                        OB_CloneMatrixParameterQueueable updateJob = new OB_CloneMatrixParameterQueueable(matrixParameters, matrixIdAbiSetmap, abi, null, service);//davide.franzini - WN-216 - 30/07/2019 added service parameter
                        ID jobID =    System.enqueueJob(updateJob);
                        //START francesca.ribezzi 17/06/19 
                        OB_JobStorage__c tempJob = new OB_JobStorage__c();
                        tempJob.OB_JobId__c = jobID;
                        tempJob.Name = abi +'_'+ jobID;
                        jobStorageList.add(tempJob);
                        //END francesca.ribezzi 17/06/19 
                        System.debug('Job Is is : ' + jobID);
                    }
                    // retrieve Job status by id in order to lock all the nexi view until job ending
                }
                //davide.franzini - END
            //START francesca.ribezzi 17/06/19
                insert jobStorageList;
                isOkSize = true;
            }else{
                isOkSize = false;
            }
            //END francesca.ribezzi 17/06/19
       } catch(Exception exce){
            System.debug('ERROR IS: ' + exce.getMessage());  
       }
       //francesca.ribezzi 17/06/19 adding return
        return isOkSize;
    }
    /*******************************************************************************
    Purpose:  Generate matrix parameter rows
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Andrea Saracini         28/05/2019      Created         Method
    ********************************************************************************/ 
    @AuraEnabled
    public static boolean cloneMatrixParameterRowsServer(String matrixParameters){
        system.debug(LoggingLevel.INFO, '#### matrixParameters abi: '+matrixParameters);
        List<Object> matrixParametersList = (List<Object>)JSON.deserializeUntyped(matrixParameters);
        List<Object> allMatrixParameterRowsList = new List<Object>();
        //Get all matrix parameter (ABI)
        for(Object item : matrixParametersList){
            String matrixParamiter = JSON.serialize(item);
            Map<String, Object> matrixParametersMap = (Map<String, Object>)JSON.deserializeUntyped(matrixParamiter);
            String matrixParameterString = JSON.serialize(matrixParametersMap.get('matrixParameters'));
            List<Object> matrixParamList = (List<Object>)JSON.deserializeUntyped(matrixParameterString);
            allMatrixParameterRowsList.addAll(matrixParamList);
        }
        //Record type id
        //String rtNexiId = Schema.SObjectType.NE__Matrix_Parameter_Row__c.getRecordTypeInfosByName().get('OB_PriceNexi').getRecordTypeId();
        //String rtABIId =  Schema.SObjectType.NE__Matrix_Parameter_Row__c.getRecordTypeInfosByName().get('OB_PriceBankABI').getRecordTypeId();
        
        Map<Id, NE__Matrix_Parameter_Row__c> abiParentRowsMap;
        Map<Id, NE__Matrix_Parameter_Row__c> nexiParentRowsMap;

        if(!allMatrixParameterRowsList.isEmpty()){
            Set<Id> abiMatrixParamIds = new Set<Id>();
            //Matrix Parameter (ABI)
            for(Object row : allMatrixParameterRowsList){
                Map<String, Object> matrixMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(row));
                abiMatrixParamIds.add(String.valueOf(matrixMap.get('Id'))); 
            }
            //Matrix Parameter Rows Map (ABI Parent) with lookup OB_MainMPRBank__c
            abiParentRowsMap = new Map<Id, NE__Matrix_Parameter_Row__c> ([SELECT Id,
                                                                            NE__Matrix_Parameter__c,
                                                                            OB_MainMPRBank__c,
                                                                            OB_Componente__c,
                                                                            OB_Family__c,
                                                                            OB_DynamicPropertyDefinition__c,
                                                                            OB_SelfLookup__c,
                                                                            RecordTypeId,
                                                                            NE__Active__c,
                                                                            OB_ActiveBank__c,
                                                                            NE__Parent_External_Id__c,
                                                                            NE__Source_External_Id__c,
                                                                            (
                                                                                SELECT Id,
                                                                                        NE__Matrix_Parameter__c,
                                                                                        OB_MainMPRBank__c,
                                                                                        OB_Componente__c,
                                                                                        OB_Family__c,
                                                                                        OB_DynamicPropertyDefinition__c,
                                                                                        OB_SelfLookup__c,
                                                                                        RecordTypeId,
                                                                                        NE__Active__c,
                                                                                        OB_ActiveBank__c,
                                                                                        NE__Parent_External_Id__c,
                                                                                        NE__Source_External_Id__c
                                                                                FROM Self_Matrix_Parameter_Rows__r
                                                                            )
                                                                        FROM NE__Matrix_Parameter_Row__c
                                                                        WHERE NE__Matrix_Parameter__c =: abiMatrixParamIds 
                                                                        ]);
        }

        if(!abiParentRowsMap.isEmpty()){
            Set<Id> nexiParentMatrixParamRowsIds = new Set<Id>();
            //Matrix Parameter Rows ids (NEXI Parent)
            for(String key : abiParentRowsMap.keySet()){
                NE__Matrix_Parameter_Row__c row = abiParentRowsMap.get(key);
                nexiParentMatrixParamRowsIds.add(row.OB_MainMPRBank__c); 
            }
            //Matrix Parameter Rows (NEXI Parent + NEXI Childs) with lookup OB_MainMPRBank__c
            nexiParentRowsMap = new  Map<Id, NE__Matrix_Parameter_Row__c> ([SELECT Id,
                                                                                NE__Matrix_Parameter__c,
                                                                                OB_MainMPRBank__c,
                                                                                OB_Componente__c,
                                                                                OB_Family__c,
                                                                                OB_DynamicPropertyDefinition__c,
                                                                                OB_SelfLookup__c,
                                                                                RecordTypeId,
                                                                                NE__Active__c,
                                                                                OB_ActiveBank__c,
                                                                                NE__Parent_External_Id__c,
                                                                                NE__Source_External_Id__c,
                                                                                (
                                                                                    SELECT Id,
                                                                                        NE__Matrix_Parameter__c,
                                                                                        OB_MainMPRBank__c,
                                                                                        OB_Componente__c,
                                                                                        OB_Family__c,
                                                                                        OB_DynamicPropertyDefinition__c,
                                                                                        OB_SelfLookup__c,
                                                                                        RecordTypeId,
                                                                                        NE__Active__c,
                                                                                        OB_ActiveBank__c,
                                                                                        NE__Parent_External_Id__c,
                                                                                        NE__Source_External_Id__c 
                                                                                    FROM Self_Matrix_Parameter_Rows__r
                                                                                )
                                                                            FROM NE__Matrix_Parameter_Row__c
                                                                            WHERE Id =: nexiParentMatrixParamRowsIds 
                                                                        ]);
        }

        if(!nexiParentRowsMap.isEmpty()){
            // List<NE__Matrix_Parameter_Row__c> abiChildRowToUpsert = new  List<NE__Matrix_Parameter_Row__c>();
            // for(String key : abiParentRowsMap.keySet()){
            //     NE__Matrix_Parameter_Row__c abiParentRow = abiParentRowsMap.get(key);
            //     //Upsert matrix param row ABI Child
            //     NE__Matrix_Parameter_Row__c nexiParentRow = nexiParentRowsMap.get(abiParentRow.OB_MainMPRBank__c);
            //     for(NE__Matrix_Parameter_Row__c item : nexiParentRow.Self_Matrix_Parameter_Rows__r){
            //         NE__Matrix_Parameter_Row__c newAbiChildParamRow = new NE__Matrix_Parameter_Row__c();
            //         newAbiChildParamRow.OB_DynamicPropertyDefinition__c = item.OB_DynamicPropertyDefinition__c;
            //         newAbiChildParamRow.OB_Family__c = item.OB_Family__c; 
            //         newAbiChildParamRow.RecordTypeId = abiParentRow.RecordTypeId;
            //         newAbiChildParamRow.OB_Componente__c = abiParentRow.OB_Componente__c;
            //         newAbiChildParamRow.OB_SelfLookup__c = abiParentRow.Id;
            //         newAbiChildParamRow.OB_ActiveBank__c = abiParentRow.NE__Active__c;
            //         newAbiChildParamRow.NE__Active__c = abiParentRow.NE__Active__c;
            //         newAbiChildParamRow.NE__Parent_External_Id__c = item.NE__Source_External_Id__c;
            //         abiChildRowToUpsert.add(newAbiChildParamRow);
            //     }              
            // }
            // if(!abiChildRowToUpsert.isEmpty()){
            //     try{
            //         upsert abiChildRowToUpsert NE__Parent_External_Id__c;
            //     }
            //     catch(Exception e){
            //         system.debug('#### Exception: '+e.getMessage());
            //         return false;
            //     }
            // }
        }
        return true;           
    }

    /*******************************************************************************
    Purpose:  update matrix parameter rows active abi field
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         francesca.ribezzi      10/06/2019      Created          Method
    ********************************************************************************/
    @AuraEnabled
    public static boolean updateActiveBankMatrixParameterRows(List<NE__Matrix_Parameter__c> matrixParameters){
        system.debug(LoggingLevel.INFO, '#### matrixParameters : '+matrixParameters);
        //davide.franzini - F2WAVE2-117 - 11/07/2019 - START
        if(matrixParameters.size()>0){
            String abi = matrixParameters.get(0).OB_ABI__c;
            String offer = matrixParameters.get(0).OB_Offerta__c;
            List<NE__Matrix_Parameter__c> mpOffer = [SELECT Id, NE__Active__c, OB_ActiveBank__c FROM NE__Matrix_Parameter__c WHERE OB_ABI__c = :abi AND OB_Offerta__c = :offer AND OB_Componente__c = null AND RecordType.DeveloperName = 'OB_PriceNexi'];
            if(mpOffer.size()>0){
                mpOffer.get(0).OB_ActiveBank__c = true;
                update mpOffer;
            }
        }
        if(matrixParameters.size()>0){
            try{
                update matrixParameters;
                return true;
            }
            catch(Exception e){
                system.debug('Exception: '+e.getMessage());
                return false;
            }
        }else{
            return false;
        }
        //davide.franzini - F2WAVE2-117 - 11/07/2019 - END
        
    }

    /*******************************************************************************
    Purpose: deactivate offer when configuration is rejected by Bank Admin
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         davide.franzini         11/07/2019      Created         Method
    ********************************************************************************/
    @AuraEnabled
    public static boolean deactivateOffer(String abi, String offer){
        List<NE__Matrix_Parameter__c> mpOffer = [SELECT Id, NE__Active__c, OB_ActiveBank__c FROM NE__Matrix_Parameter__c WHERE OB_ABI__c = :abi AND OB_Offerta__c = :offer AND OB_Componente__c = null AND RecordType.DeveloperName = 'OB_PriceNexi'];
        if(mpOffer.size()>0){
            try{
                mpOffer.get(0).OB_ActiveBank__c = false;
                update mpOffer;
                return true;
            }
            catch(Exception e){
                system.debug('Exception: '+e.getMessage());
                return false;
            }
        }else{
            return false;
        }
        
    }

    /*******************************************************************************
    Purpose:  search for completed apex jobs
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         francesca.ribezzi      17/06/2019      Created          Method
    ********************************************************************************/
    @AuraEnabled
    public static boolean searchForApexJobs(){
        Boolean isCompleted;
        List<Id> jobsId = new List<Id>();
        List<OB_JobStorage__c> jobList = OB_JobStorage__c.getall().values();
        for(OB_JobStorage__c job : jobList){
            jobsId.add(job.OB_JobId__c);
        }
        List<AsyncApexJob> jobs = 
            [
                SELECT id, Status  
                FROM AsyncApexJob 
                WHERE id 
                IN :  jobsId
                AND (Status != 'Completed' AND Status != 'Failed') //davide.franzini - 12/07/2019 - added filter on Status Failed
            ];
            
        if(jobs.size() > 0){
            isCompleted = false;
        }else{
            isCompleted = true;
        }
        return isCompleted;
    }
}