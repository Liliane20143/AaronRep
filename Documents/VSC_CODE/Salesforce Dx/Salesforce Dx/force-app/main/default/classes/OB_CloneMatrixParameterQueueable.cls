/********************************************************************************
Name: OB_CloneMatrixParameterQueueable  
=================================================================================
Purpose:  Class used to configure matrix parameter rows for each ABI
History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0         Andrea Saracini         30/05/2019      Created         Class             
********************************************************************************/
public class OB_CloneMatrixParameterQueueable  implements Queueable{
    
    private List<NE__Matrix_Parameter__c>  matrixParameters;
    private Map<String, Set<String>> matrixIdAbiListmap;
    private String abi;
    //davide.franzini - WN-216 - 30/07/2019 - START
    private String cab;
    private String service;
    //davide.franzini - WN-216 - 30/07/2019 - END
    /*******************************************************************************
    Purpose:  Set matrix parameter and ABI selected in "Nexi pee Banca"
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Andrea Saracini         30/05/2019      Created         Method
    ********************************************************************************/
    public OB_CloneMatrixParameterQueueable(List<NE__Matrix_Parameter__c> matrixParameters, Map<String,Set<String>> matrixIdAbiListmap, String abi, String cab, String service) {//davide.franzini - WN-216 - 30/07/2019 added service and cab parameters
        this.matrixParameters = matrixParameters;
        this.matrixIdAbiListmap = matrixIdAbiListmap;
        this.abi = abi;
        //davide.franzini - WN-216 - 30/07/2019 - START
        this.cab = cab;
        this.service = service;
        //davide.franzini - WN-216 - 30/07/2019 - END
    }
    /*******************************************************************************
    Purpose: Generate matrix parameter (ABI) and  matrix parameter rows childs (ABI)
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Andrea Saracini         30/05/2019      Created         Method
    ********************************************************************************/
    public void execute(QueueableContext context) {
        //davide.franzini - START 
        system.debug(LoggingLevel.INFO, '## OB_CloneMatrixParameterQueueable - in execute method - START');
        system.debug(LoggingLevel.INFO, '## matrixIdAbiListmap: '+JSON.serializePretty(matrixIdAbiListmap));
        system.debug(LoggingLevel.INFO, '## abi: '+abi);
        system.debug(LoggingLevel.INFO, '## cab: '+cab);
        system.debug(LoggingLevel.INFO, '## service: '+service);
            
        List<NE__Matrix_Parameter__c> newListOfMatrix = new List<NE__Matrix_Parameter__c>();
        List<NE__Matrix_Parameter_Row__c> newListOfMatrixRow = new List<NE__Matrix_Parameter_Row__c>();
        List<NE__Matrix_Parameter_Row__c> newListOfMatrixRow2 = new List<NE__Matrix_Parameter_Row__c>();
        //davide.franzini - F2WAVE2-117 - 12/07/2019 - START
        List<NE__Matrix_Parameter__c> activeMPList = new List<NE__Matrix_Parameter__c>();
        Map<String,NE__Matrix_Parameter__c> existingMP = new Map<String,NE__Matrix_Parameter__c>(); 
        String offerId = '';
        List<NE__Matrix_Parameter__c> mpActiveToUpdate = new List<NE__Matrix_Parameter__c>();
        //davide.franzini - F2WAVE2-117 - 12/07/2019 - END
        List<NE__Matrix_Parameter__c> offerMP = new List<NE__Matrix_Parameter__c>();//davide.franzini - WN-124 - 18/07/2019
        Map<String, NE__Matrix_Parameter__c> mpToBeCreated = new Map<String, NE__Matrix_Parameter__c>();  //davide.franzini - WN-115 - 20/07/2019
        Map<String, List<NE__Matrix_Parameter__c>> sourceMatrixTargetMatrixMap = new Map<String, List<NE__Matrix_Parameter__c>>();
        Map<Id, NE__Matrix_Parameter__c> nexiMatrixParams;
        Map<String, NE__Matrix_Parameter__c> nexiNewMatrixParams = new Map<String, NE__Matrix_Parameter__c>();

        Map<String,String> relMap = new Map<String,String>();

        String rtABIParamRowId=  Schema.SObjectType.NE__Matrix_Parameter_Row__c.getRecordTypeInfosByName().get('OB_PriceBankABI').getRecordTypeId();
        String rtABIParamId =  Schema.SObjectType.NE__Matrix_Parameter__c.getRecordTypeInfosByName().get('OB_PriceBankABI').getRecordTypeId();
        String rtCABParamRowId=  Schema.SObjectType.NE__Matrix_Parameter_Row__c.getRecordTypeInfosByName().get('OB_PriceBankCAB').getRecordTypeId();    //davide.franzini - 30/07/2019 - WN-216
        String rtCABParamId = Schema.SObjectType.NE__Matrix_Parameter__c.getRecordTypeInfosByName().get('OB_PriceBankCAB').getRecordTypeId();           //davide.franzini - 30/07/2019 - WN-216
        String rtNEXIParamRowId=  Schema.SObjectType.NE__Matrix_Parameter_Row__c.getRecordTypeInfosByName().get('OB_PriceNexi').getRecordTypeId();      //davide.franzini - 12/07/2019 - F2WAVE2-116
        String rtNEXIParamId =  Schema.SObjectType.NE__Matrix_Parameter__c.getRecordTypeInfosByName().get('OB_PriceNexi').getRecordTypeId();            //davide.franzini - 12/07/2019 - F2WAVE2-116 - START

        Set<Id> nexiParentMatrixParamIds = new Set<Id>();

        Id mainMP = null; //davide.franzini - 05/07/2019

        //francesca.ribezzi 14/06/19 adding map matrixParameterId, Boolean to keep NE__Active value:
        Map<String, NE__Matrix_Parameter__c> idActiveNEXIMatrixMap = new Map<String,NE__Matrix_Parameter__c>(); //davide.franzini - F2WAVE2-116 - 12/07/2019

        //davide.franzini - WN-216 - 30/07/2019 - START
        String mpRTFilter = service == 'ABI' ? rtNEXIParamId : rtABIParamId;        
        String mprRTFilter = service == 'ABI' ? rtNEXIParamRowId : rtABIParamRowId;

        if(service == null || service == ''){
            throw new OB_CloneMatrixParameterQueueable_Exception('OB_CloneMatrixParameterQueueable Exception: service is not defined');
        }
        //davide.franzini - WN-216 - 30/07/2019 - END   

        //Matrix Parameter Rows ids (NEXI Parent)
        for(NE__Matrix_Parameter__c item : matrixParameters){
            nexiParentMatrixParamIds.add(item.Id);
            //francesca.ribezzi 14/06/19 put into map
            idActiveNEXIMatrixMap.put(item.OB_Offerta__c+'_'+item.OB_Componente__c+'_'+item.OB_SchemaPrezzi__c, item); //davide.franzini - F2WAVE2-116 - 12/07/2019
        }
        if(!nexiParentMatrixParamIds.isEmpty()){

            nexiMatrixParams = new  Map<Id, NE__Matrix_Parameter__c> ([SELECT  Id,
                                                                                OB_MainMP__c,
                                                                                NE__Active__c,
                                                                                OB_Componente__c,
                                                                                OB_Componente__r.NE__Product_Name__c, //davide.franzini - WN-66 - 23/07/2019
                                                                                OB_Offerta__c,
                                                                                OB_SchemaPrezzi__c,
                                                                                NE__Name__c,
                                                                                NE__Start_Date__c,  //davide.franzini - 04/07/2019
                                                                                OB_ABI__c,          //davide.franzini - 05/07/2019
                                                                                OB_Listino__c,      //davide.franzini - 20/07/2019 - WN-115
                                                                                (
                                                                                    SELECT Id,
                                                                                            NE__Matrix_Parameter__c, 
                                                                                            NE__Active__c, 
                                                                                            NE__End_Date__c, 
                                                                                            NE__Matrix_Item_Identifier__c, 
                                                                                            NE__Parent_External_Id__c, 
                                                                                            NE__RequestId__c, 
                                                                                            NE__Source_External_Id__c, 
                                                                                            NE__Start_Date__c, 
                                                                                            OB_Massimale__c, 
                                                                                            OB_Read_Only_banca__c, 
                                                                                            OB_Visible__c, 
                                                                                            OB_Default_Banca__c, 
                                                                                            OB_Utilizzato_per_la_BANCA__c, 
                                                                                            OB_Family__c, 
                                                                                            OB_ABI_BANCA__c, 
                                                                                            OB_DynamicPropertyDefinition__c, 
                                                                                            OB_Valore_Default__c, 
                                                                                            OB_Minimo__c, 
                                                                                            OB_Massimo__c, 
                                                                                            OB_Componente__c, 
                                                                                            OB_Soglia_Min_Approvazione__c, 
                                                                                            OB_Product__c, 
                                                                                            OB_ReadOnly__c, 
                                                                                            OB_Soglia_Max_Approvazione__c, 
                                                                                            OB_Cab__c, 
                                                                                            OB_Hidden__c, 
                                                                                            OB_Codici__c, 
                                                                                            OB_Offerta__c, 
                                                                                            OB_Schema_Prezzi__c, 
                                                                                            OB_ModelloAcquiring__c, 
                                                                                            OB_Sequence__c, 
                                                                                            OB_Parent_Componente__c, 
                                                                                            OB_PriceId__c, 
                                                                                            OB_SelfLookup__c, 
                                                                                            OB_Read_Only_CAB__c, 
                                                                                            OB_MinThresholdL2__c, 
                                                                                            OB_MinThresholdL3__c, 
                                                                                            OB_MaxThresholdL3__c, 
                                                                                            OB_MaxThresholdL2__c, 
                                                                                            OB_ActiveBank__c, 
                                                                                            OB_MainMPRBank__c,
                                                                                            OB_MainMP__c,                   //davide.franzini - 05/07/2019 
                                                                                            OB_ABIcatItemIdBundleId__c
                                                                                    FROM NE__Matrix_Parameter_Rows__r
                                                                                    WHERE RecordTypeId = :mprRTFilter       //davide.franzini - 30/07/2019 - WN-216
                                                                                )
                                                                            FROM NE__Matrix_Parameter__c 
                                                                            WHERE Id =: nexiParentMatrixParamIds  AND 
                                                                                  RecordTypeId = :mpRTFilter                //davide.franzini - 30/07/2019 - WN-216
                                                                        ]);
        }

        String query = 'SELECT  Id, OB_MainMP__c, NE__Active__c,OB_Componente__c,OB_Componente__r.NE__Product_Name__c, OB_Offerta__c,OB_SchemaPrezzi__c,NE__Name__c,NE__Start_Date__c, OB_ABI__c,OB_Listino__c, (SELECT Id,NE__Matrix_Parameter__c, NE__Active__c, NE__End_Date__c, NE__Matrix_Item_Identifier__c, NE__Parent_External_Id__c, NE__RequestId__c, NE__Source_External_Id__c, NE__Start_Date__c, OB_Massimale__c, OB_Read_Only_banca__c, OB_Visible__c, OB_Default_Banca__c, OB_Utilizzato_per_la_BANCA__c, OB_Family__c, OB_ABI_BANCA__c, OB_DynamicPropertyDefinition__c, OB_Valore_Default__c, OB_Minimo__c, OB_Massimo__c, OB_Componente__c, OB_Soglia_Min_Approvazione__c, OB_Product__c, OB_ReadOnly__c,OB_Soglia_Max_Approvazione__c, OB_Cab__c, OB_Hidden__c, OB_Codici__c, OB_Offerta__c, OB_Schema_Prezzi__c, OB_ModelloAcquiring__c, OB_Sequence__c, OB_Parent_Componente__c,OB_PriceId__c, OB_SelfLookup__c, OB_Read_Only_CAB__c, OB_MinThresholdL2__c,OB_MinThresholdL3__c, OB_MaxThresholdL3__c, OB_MaxThresholdL2__c, OB_ActiveBank__c, OB_MainMPRBank__c,OB_MainMP__c, OB_ABIcatItemIdBundleId__c FROM NE__Matrix_Parameter_Rows__r WHERE RecordTypeId = '+mprRTFilter+' ) FROM NE__Matrix_Parameter__c WHERE Id = '+nexiParentMatrixParamIds+' AND RecordTypeId ='+mpRTFilter;
        system.debug(LoggingLevel.INFO, '## query: '+query);

        system.debug(LoggingLevel.INFO, '## OB_CloneMatrixParameterQueueable - in execute method - after query');
        //Create a savepoint
        Savepoint sp = Database.setSavepoint();
        
        if(!nexiMatrixParams.isEmpty()){
            //davide.franzini - 05/07/2019 - START
            for(String key : nexiMatrixParams.keySet()){
                NE__Matrix_Parameter__c srcMp = nexiMatrixParams.get(key);
                if(srcMp.OB_Offerta__c != null){    //davide.franzini - 12/07/2019 - F2WAVE2-116
                    offerId = srcMp.OB_Offerta__c;  //davide.franzini - 12/07/2019 - F2WAVE2-116
                    break;
                }
            }
            //davide.franzini - 05/07/2019 - END
            //davide.franzini - WN-124 - 18/07/2019 - START
            offerMP = [SELECT Id, 
                            NE__Active__c, 
                            OB_ActiveBank__c, 
                            OB_Offerta__c, 
                            OB_ABI__c, 
                            RecordTypeId, 
                            OB_Componente__c 
                        FROM NE__Matrix_Parameter__c 
                        WHERE OB_Componente__c = null 
                            AND RecordTypeId = :rtNEXIParamId 
                            AND OB_Offerta__c = :offerId 
                            AND OB_ABI__c = :abi];
            if(!offerMp.isEmpty() && offerMp != null){
                mainMP = offerMp.get(0).Id;
            }else{
                //davide.franzini - 25/10/2019 - mainMp Creation - START
                try{
                    NE__Matrix_Parameter__c newMainMp = new NE__Matrix_Parameter__c(
                        NE__Active__c = true,
                        OB_ActiveBank__c = true,
                        OB_Offerta__c = offerId, 
                        OB_ABI__c = abi,
                        RecordTypeId = rtNEXIParamId,
                        OB_Componente__c = null
                    );
                    insert newMainMp;
                    mainMp = newMainMp.Id;               
                }catch(Exception e){
                    System.debug(LoggingLevel.ERROR, 'The following exception has occurred at line: '+e.getLineNumber()+' message : '+e.getMessage());
                }
                //davide.franzini - 25/10/2019 - mainMp Creation - END
            }
            //davide.franzini - WN-124 - 18/07/2019 - END
            //davide.franzini - WN-216 - 30/07/2019 - START
            if(service == 'ABI'){
                system.debug('## service is:'+service);
                //davide.franzini - 12/07/2019 - F2WAVE2-116 - START
                AggregateResult[] groupedResults = [SELECT count(Id) 
                                                        FROM NE__Matrix_Parameter__c 
                                                        WHERE RecordTypeId = :rtABIParamId
                                                            AND OB_ABI__c = :abi 
                                                            AND OB_Offerta__c = :offerId];

                if((Double)groupedResults[0].get('expr0') > 0){
                    activeMPList = [SELECT Id, 
                                        NE__Active__c, 
                                        OB_ActiveBank__c,
                                        OB_Componente__c,
                                        OB_Componente__r.NE__Product_Name__c, 
                                        OB_Offerta__c,
                                        OB_SchemaPrezzi__c, 
                                        OB_ABI__c 
                                    FROM NE__Matrix_Parameter__c 
                                    WHERE RecordTypeId = :rtABIParamId 
                                        AND OB_ABI__c = :abi 
                                        AND OB_Offerta__c = :offerId
                                        AND OB_Componente__c <> null];
                    if(!activeMPList.isEmpty()){
                        for(NE__Matrix_Parameter__c mp : activeMPList){
                            existingMP.put(mp.OB_Offerta__c+'_'+mp.OB_Componente__c+'_'+mp.OB_SchemaPrezzi__c,mp);
                        }
                    }
                }
                //davide.franzini - 12/07/2019 - F2WAVE2-116 - END
                for(String key : nexiMatrixParams.keySet()){
                    NE__Matrix_Parameter__c sourceMp = nexiMatrixParams.get(key);
                    //create as many matrix parameter as the number of abi:
                    System.debug('### sourceMp: ' + sourceMp);
                    if(matrixIdAbiListmap.get(sourceMp.Id) != null){//davide.franzini - WN-115 - 20/07/2019
                        if((matrixIdAbiListmap.get(sourceMp.Id)).contains(abi) && sourceMp.OB_Componente__c != null){//davide.franzini - 05/07/2019 - Exclude offer MP
                            //davide.franzini - 12/07/2019 - F2WAVE2-116 - START
                            if((Double)groupedResults[0].get('expr0') > 0){

                                //davide.franzini - 20/07/2019 - WN-115 - START
                                for(String activeKey : idActiveNEXIMatrixMap.keySet()){
                                    if(!existingMP.containsKey(activeKey)){
                                        system.debug('## no BankABI MP for the key: '+activeKey);
                                        if(idActiveNEXIMatrixMap.get(activeKey).OB_Componente__c != null && idActiveNEXIMatrixMap.get(activeKey).OB_Offerta__c != null){
                                            mpToBeCreated.put(activeKey, idActiveNEXIMatrixMap.get(activeKey));
                                            system.debug('## mpToBeCreated: '+mpToBeCreated);
                                        }
                                    }
                                }
                                //davide.franzini - 20/07/2019 - WN-115 - END

                                //davide.franzini - 17/07/2019 - Fix to prevent empty Map.get - START
                                if(existingMP.get(sourceMp.OB_Offerta__c+'_'+sourceMp.OB_Componente__c+'_'+sourceMp.OB_SchemaPrezzi__c) != null && idActiveNEXIMatrixMap.get(sourceMp.OB_Offerta__c+'_'+sourceMp.OB_Componente__c+'_'+sourceMp.OB_SchemaPrezzi__c)!= null){
                                    existingMP.get(sourceMp.OB_Offerta__c+'_'+sourceMp.OB_Componente__c+'_'+sourceMp.OB_SchemaPrezzi__c).NE__Active__c = idActiveNEXIMatrixMap.get(sourceMp.OB_Offerta__c+'_'+sourceMp.OB_Componente__c+'_'+sourceMp.OB_SchemaPrezzi__c).NE__Active__c;
                                    mpActiveToUpdate.add(existingMP.get(sourceMp.OB_Offerta__c+'_'+sourceMp.OB_Componente__c+'_'+sourceMp.OB_SchemaPrezzi__c));
                                }
                                //davide.franzini - 17/07/2019 - Fix to prevent empty Map.get - END
                            }
                            //davide.franzini - 20/07/2019 - WN-115 - START
                            if((!mpToBeCreated.isEmpty() && mpToBeCreated != null) || (Double)groupedResults[0].get('expr0') == 0){ //davide.franzini - WN-115 - 22/07/2019
                                system.debug('## creating mp and relative mpr for single products');
                                if(mpToBeCreated.containsKey(sourceMp.OB_Offerta__c+'_'+sourceMp.OB_Componente__c+'_'+sourceMp.OB_SchemaPrezzi__c) || (Double)groupedResults[0].get('expr0') == 0){ //davide.franzini - WN-115 - 22/07/2019
                                    //davide.franzini - 12/07/2019 - F2WAVE2-116 - END
                                    NE__Matrix_Parameter__c newMatrix = sourceMp.clone( false, true, false, false );
                                    newMatrix.NE__Name__c = '';
                                    newMatrix.Name = sourceMp.OB_Componente__r.NE__Product_Name__c; // davide.franzini - WN-66 - 23/07/2019
                                    newMatrix.OB_ABI__c = abi;
                                    system.debug('## mainMP before relate: '+mainMP);
                                    newMatrix.OB_MainMP__c = mainMP;    //davide.franzini - 05/07/2019
                                    system.debug('## newMatrix.OB_MainMP__c: '+newMatrix.OB_MainMP__c);
                                    newMatrix.NE__Start_Date__c = sourceMp.NE__Start_Date__c;   //davide.franzini - 04/07/2019
                                    Id sourceOffId = sourceMp.OB_Offerta__c;
                                    Id sourceCompId = sourceMp.OB_Componente__c;
                                    newMatrix.OB_ABIcatItemIdBundleId__c = abi+'_'+sourceOffId+'_'+sourceCompId+'_'+sourceMp.OB_SchemaPrezzi__c; 
                                    //francesca.ribezzi 14/06/19:
                                    newMatrix.NE__Active__c = idActiveNEXIMatrixMap.get(sourceOffId+'_'+sourceCompId+'_'+sourceMp.OB_SchemaPrezzi__c).NE__Active__c; //davide.franzini - F2WAVE2-116 - 12/07/2019
                                    newMatrix.OB_ActiveBank__c = newMatrix.NE__Active__c; //davide.franzini - WN-226 - 01/08/2019
                                    //newMatrix.NE__Active__c = sourceMp.NE__Active__c;
                                    newMatrix.RecordTypeId = rtABIParamId; 
                                    // newMatrix.OB_ABIcatItemIdBundleId__c = abi+'_'+sourceMp.NE__Name__c;
                                    newListOfMatrix.add(newMatrix);
                                    nexiNewMatrixParams.put(newMatrix.OB_ABIcatItemIdBundleId__c, newMatrix);
                                    for(NE__Matrix_Parameter_Row__c item : sourceMp.NE__Matrix_Parameter_Rows__r){
                                        NE__Matrix_Parameter_Row__c newMatrixRow = new NE__Matrix_Parameter_Row__c();
                                        newMatrixRow.RecordTypeId = rtABIParamRowId;
                                        newMatrixRow.OB_ABI_BANCA__c = newMatrix.OB_ABI__c;
                                        newMatrixRow.NE__Active__c = item.NE__Active__c;
                                        newMatrixRow.OB_ActiveBank__c = item.NE__Active__c;
                                        newMatrixRow.NE__Start_Date__c = item.NE__Start_Date__c;
                                        newMatrixRow.NE__End_Date__c = item.NE__End_Date__c;
                                        newMatrixRow.OB_Componente__c = item.OB_Componente__c;
                                        newMatrixRow.OB_Product__c = item.OB_Product__c;
                                        newMatrixRow.OB_Family__c = item.OB_Family__c;
                                        newMatrixRow.OB_DynamicPropertyDefinition__c = item.OB_DynamicPropertyDefinition__c;
                                        newMatrixRow.OB_Codici__c = item.OB_Codici__c;
                                        newMatrixRow.OB_Sequence__c = item.OB_Sequence__c;
                                        newMatrixRow.OB_Read_Only_banca__c = item.OB_Read_Only_banca__c;
                                        newMatrixRow.OB_Visible__c = item.OB_Visible__c;
                                        newMatrixRow.OB_Hidden__c = item.OB_Hidden__c;
                                        newMatrixRow.OB_Read_Only_CAB__c = item.OB_Read_Only_CAB__c;

                                        newMatrixRow.OB_Minimo__c = item.OB_Minimo__c;
                                        newMatrixRow.OB_MinThresholdL3__c = item.OB_MinThresholdL3__c;
                                        newMatrixRow.OB_MinThresholdL2__c = item.OB_MinThresholdL2__c;
                                        newMatrixRow.OB_Soglia_Min_Approvazione__c = item.OB_Soglia_Min_Approvazione__c;
                                        newMatrixRow.OB_Default_Banca__c = item.OB_Default_Banca__c;                            
                                        newMatrixRow.OB_Valore_Default__c = item.OB_Valore_Default__c;
                                        newMatrixRow.OB_Soglia_Max_Approvazione__c = item.OB_Soglia_Max_Approvazione__c;
                                        newMatrixRow.OB_MaxThresholdL2__c = item.OB_MaxThresholdL2__c;
                                        newMatrixRow.OB_MaxThresholdL3__c = item.OB_MaxThresholdL3__c;
                                        newMatrixRow.OB_Massimo__c = item.OB_Massimo__c;
                                        newMatrixRow.OB_Massimale__c = item.OB_Massimale__c;

                                        newMatrixRow.OB_ModelloAcquiring__c = item.OB_ModelloAcquiring__c;
                                        newMatrixRow.OB_Schema_Prezzi__c = item.OB_Schema_Prezzi__c;
                                        newMatrixRow.OB_SelfLookup__c = item.OB_SelfLookup__c;
                                        newMatrixRow.OB_ABIcatItemIdBundleId__c = newMatrix.OB_ABIcatItemIdBundleId__c;
                                        newMatrixRow.NE__Source_External_Id__c = null;
                                        //davide.franzini - 05/07/2019 - START
                                        newMatrixRow.OB_MainMP__c = newMatrix.OB_MainMP__c;
                                        //davide.franzini - 05/07/2019 - END
                                        newListOfMatrixRow.add(newMatrixRow);
                                    }
                                    //davide.franzini - 22/07/2019 - WN-115 - START
                                    if(!mpToBeCreated.isEmpty() && mpToBeCreated != null){
                                        mpToBeCreated.remove(sourceOffId+'_'+sourceCompId+'_'+sourceMp.OB_SchemaPrezzi__c);    
                                    }
                                    //davide.franzini - 22/07/2019 - WN-115 - END
                                    system.debug('## mpToBeCreated after mp clone (should be empty): '+mpToBeCreated);
                                }
                            }
                            //davide.franzini - 20/07/2019 - WN-115 - END
                        }
                    }

                }
                try{
                    system.debug(LoggingLevel.INFO, '## OB_CloneMatrixParameterQueueable - in execute method - before upsert');
                    //davide.franzini - F2WAVE2-116 - 12/07/2019 - START
                    if((Double)groupedResults[0].get('expr0') > 0){
                        //davide.franzini - WN-170 - 22/07/2019 - START
                        for(NE__Matrix_Parameter__c mp : mpActiveToUpdate){
                            if(mp.NE__Active__c == false){
                                mp.OB_ActiveBank__c = mp.NE__Active__c;
                            }
                        }
                        //davide.franzini - WN-170 - 22/07/2019 - END
                        update matrixParameters;
                        update mpActiveToUpdate;
                    }
                    //davide.franzini - F2WAVE2-116 - 12/07/2019 - END
                    if(!newListOfMatrix.isEmpty() && newListOfMatrix != null){//davide.franzini - WN-115 - 20/07/2019
                        upsert newListOfMatrix OB_ABIcatItemIdBundleId__c;
                        if(!nexiNewMatrixParams.isEmpty()){
                            for(NE__Matrix_Parameter_Row__c item : newListOfMatrixRow){
                                item.NE__Matrix_Parameter__c = nexiNewMatrixParams.get(item.OB_ABIcatItemIdBundleId__c).Id;
                                Id matrixParOffId = nexiNewMatrixParams.get(item.OB_ABIcatItemIdBundleId__c).OB_Offerta__c;
                                Id mprCompId = item.OB_Componente__c;
                                Id mprFamId = item.OB_Family__c;
                                Id mprPropId = item.OB_DynamicPropertyDefinition__c;
                                Id mprSelfId = item.OB_SelfLookup__c;
                                String mprDateStr = item.NE__Start_Date__c.year() + '-' + item.NE__Start_Date__c.month() + '-' + item.NE__Start_Date__c.day();
                                system.debug(LoggingLevel.INFO, '## full key: '+abi+'_'+matrixParOffId+'_'+mprCompId+'_'+mprFamId+'_'+mprPropId+'_'+nexiNewMatrixParams.get(item.OB_ABIcatItemIdBundleId__c).OB_SchemaPrezzi__c+'_'+mprSelfId+'_'+mprDateStr);
                                item.OB_ABIcatItemIdBundleId__c = abi+'_'+matrixParOffId+'_'+mprCompId+'_'+mprFamId+'_'+mprPropId+'_'+nexiNewMatrixParams.get(item.OB_ABIcatItemIdBundleId__c).OB_SchemaPrezzi__c+'_'+mprSelfId+'_'+mprDateStr;
                            }
                        }

                        upsert newListOfMatrixRow OB_ABIcatItemIdBundleId__c;

                        for(NE__Matrix_Parameter_Row__c item : newListOfMatrixRow){
                            if(item.OB_SelfLookup__c == null){
                                Id itemCompId = item.OB_Componente__c; 
                                relMap.put(itemCompId+'_'+item.OB_Schema_Prezzi__c, item.Id);
                            }
                        }
                        //davide.franzini - 25/10/2019 - second update moved to new Queueable Split - START
                        OB_CloneMPRQueueableSplit updateJob = new OB_CloneMPRQueueableSplit(relMap, newListOfMatrixRow);
                        ID jobID =    System.enqueueJob(updateJob);
                        //davide.franzini - 25/10/2019 - END
                        system.debug(LoggingLevel.INFO, '## OB_CloneMatrixParameterQueueable - in execute method - after all upserts');
                    }//davide.franzini - F2WAVE2-116 - 12/07/2019
                }
                catch(Exception e) {
                    System.debug(LoggingLevel.ERROR, 'The following exception has occurred at line: '+e.getLineNumber()+' message : '+e.getMessage());
                    // Rollback to the previous null value
                    Database.rollback(sp);
                }
            }
            if(service == 'CAB'){
                system.debug('## service is:'+service);
                AggregateResult[] groupedResults = [SELECT count(Id) 
                                                    FROM NE__Matrix_Parameter__c 
                                                    WHERE RecordTypeId = :rtABIParamId
                                                        AND OB_ABI__c = :abi
                                                        AND OB_Cab__c = :cab 
                                                        AND OB_Offerta__c = :offerId];

                if((Double)groupedResults[0].get('expr0') > 0){
                    activeMPList = [SELECT Id, 
                                        NE__Active__c, 
                                        OB_ActiveBank__c,
                                        OB_Componente__c,
                                        OB_Componente__r.NE__Product_Name__c, 
                                        OB_Offerta__c,
                                        OB_SchemaPrezzi__c, 
                                        OB_ABI__c 
                                    FROM NE__Matrix_Parameter__c 
                                    WHERE RecordTypeId = :rtABIParamId 
                                        AND OB_ABI__c = :abi 
                                        AND OB_Cab__c = :cab
                                        AND OB_Offerta__c = :offerId
                                        AND OB_Componente__c <> null];
                    if(!activeMPList.isEmpty()){
                        for(NE__Matrix_Parameter__c mp : activeMPList){
                            existingMP.put(mp.OB_Offerta__c+'_'+mp.OB_Componente__c+'_'+mp.OB_SchemaPrezzi__c,mp);
                        }
                    }
                }
                for(String key : nexiMatrixParams.keySet()){
                    NE__Matrix_Parameter__c sourceMp = nexiMatrixParams.get(key);
                    //create as many matrix parameter as the number of cab:
                    System.debug('### sourceMp: ' + sourceMp);
                    if(matrixIdAbiListmap.get(sourceMp.Id) != null){
                        if((matrixIdAbiListmap.get(sourceMp.Id)).contains(cab) && sourceMp.OB_Componente__c != null){
                            if((Double)groupedResults[0].get('expr0') > 0){
                                for(String activeKey : idActiveNEXIMatrixMap.keySet()){
                                    if(!existingMP.containsKey(activeKey)){
                                        system.debug('## no BankABI MP for the key: '+activeKey);
                                        if(idActiveNEXIMatrixMap.get(activeKey).OB_Componente__c != null && idActiveNEXIMatrixMap.get(activeKey).OB_Offerta__c != null){
                                            mpToBeCreated.put(activeKey, idActiveNEXIMatrixMap.get(activeKey));
                                            system.debug('## mpToBeCreated: '+mpToBeCreated);
                                        }
                                    }
                                }

                                if(existingMP.get(sourceMp.OB_Offerta__c+'_'+sourceMp.OB_Componente__c+'_'+sourceMp.OB_SchemaPrezzi__c) != null && idActiveNEXIMatrixMap.get(sourceMp.OB_Offerta__c+'_'+sourceMp.OB_Componente__c+'_'+sourceMp.OB_SchemaPrezzi__c)!= null){
                                    existingMP.get(sourceMp.OB_Offerta__c+'_'+sourceMp.OB_Componente__c+'_'+sourceMp.OB_SchemaPrezzi__c).NE__Active__c = idActiveNEXIMatrixMap.get(sourceMp.OB_Offerta__c+'_'+sourceMp.OB_Componente__c+'_'+sourceMp.OB_SchemaPrezzi__c).NE__Active__c;
                                    mpActiveToUpdate.add(existingMP.get(sourceMp.OB_Offerta__c+'_'+sourceMp.OB_Componente__c+'_'+sourceMp.OB_SchemaPrezzi__c));
                                }
                            }

                            if((!mpToBeCreated.isEmpty() && mpToBeCreated != null) || (Double)groupedResults[0].get('expr0') == 0){ 
                                system.debug('## creating mp and relative mpr for single products');
                                if(mpToBeCreated.containsKey(sourceMp.OB_Offerta__c+'_'+sourceMp.OB_Componente__c+'_'+sourceMp.OB_SchemaPrezzi__c) || (Double)groupedResults[0].get('expr0') == 0){
                                    NE__Matrix_Parameter__c newMatrix = sourceMp.clone( false, true, false, false );
                                    newMatrix.NE__Name__c = '';
                                    newMatrix.Name = sourceMp.OB_Componente__r.NE__Product_Name__c;
                                    newMatrix.OB_ABI__c = abi;
                                    newMatrix.OB_Cab__c = cab;
                                    newMatrix.OB_MainMP__c = mainMP;
                                    newMatrix.NE__Start_Date__c = sourceMp.NE__Start_Date__c;
                                    Id sourceOffId = sourceMp.OB_Offerta__c;
                                    Id sourceCompId = sourceMp.OB_Componente__c;
                                    newMatrix.OB_ABIcatItemIdBundleId__c = abi+cab+'_'+sourceOffId+'_'+sourceCompId+'_'+sourceMp.OB_SchemaPrezzi__c; 
                                    newMatrix.NE__Active__c = idActiveNEXIMatrixMap.get(sourceOffId+'_'+sourceCompId+'_'+sourceMp.OB_SchemaPrezzi__c).NE__Active__c;
                                    newMatrix.OB_ActiveBank__c = newMatrix.NE__Active__c; //davide.franzini - WN-226 - 01/08/2019
                                    newMatrix.RecordTypeId = rtCABParamId; 
                                    newListOfMatrix.add(newMatrix);
                                    nexiNewMatrixParams.put(newMatrix.OB_ABIcatItemIdBundleId__c, newMatrix);
                                    for(NE__Matrix_Parameter_Row__c item : sourceMp.NE__Matrix_Parameter_Rows__r){
                                        NE__Matrix_Parameter_Row__c newMatrixRow = new NE__Matrix_Parameter_Row__c();
                                        newMatrixRow.RecordTypeId = rtCABParamRowId;
                                        newMatrixRow.OB_ABI_BANCA__c = newMatrix.OB_ABI__c;
                                        newMatrixRow.OB_Cab__c = newMatrix.OB_Cab__c;
                                        newMatrixRow.NE__Active__c = item.NE__Active__c;
                                        newMatrixRow.OB_ActiveBank__c = item.NE__Active__c;
                                        newMatrixRow.NE__Start_Date__c = item.NE__Start_Date__c;
                                        newMatrixRow.NE__End_Date__c = item.NE__End_Date__c;
                                        newMatrixRow.OB_Componente__c = item.OB_Componente__c;
                                        newMatrixRow.OB_Product__c = item.OB_Product__c;
                                        newMatrixRow.OB_Family__c = item.OB_Family__c;
                                        newMatrixRow.OB_DynamicPropertyDefinition__c = item.OB_DynamicPropertyDefinition__c;
                                        newMatrixRow.OB_Codici__c = item.OB_Codici__c;
                                        newMatrixRow.OB_Sequence__c = item.OB_Sequence__c;
                                        newMatrixRow.OB_Read_Only_banca__c = item.OB_Read_Only_banca__c;
                                        newMatrixRow.OB_Visible__c = item.OB_Visible__c;
                                        newMatrixRow.OB_Hidden__c = item.OB_Hidden__c;
                                        newMatrixRow.OB_Read_Only_CAB__c = item.OB_Read_Only_CAB__c;

                                        newMatrixRow.OB_Minimo__c = item.OB_Minimo__c;
                                        newMatrixRow.OB_MinThresholdL3__c = item.OB_MinThresholdL3__c;
                                        newMatrixRow.OB_MinThresholdL2__c = item.OB_MinThresholdL2__c;
                                        newMatrixRow.OB_Soglia_Min_Approvazione__c = item.OB_Soglia_Min_Approvazione__c;
                                        newMatrixRow.OB_Default_Banca__c = item.OB_Default_Banca__c;                            
                                        newMatrixRow.OB_Valore_Default__c = item.OB_Valore_Default__c;
                                        newMatrixRow.OB_Soglia_Max_Approvazione__c = item.OB_Soglia_Max_Approvazione__c;
                                        newMatrixRow.OB_MaxThresholdL2__c = item.OB_MaxThresholdL2__c;
                                        newMatrixRow.OB_MaxThresholdL3__c = item.OB_MaxThresholdL3__c;
                                        newMatrixRow.OB_Massimo__c = item.OB_Massimo__c;
                                        newMatrixRow.OB_Massimale__c = item.OB_Massimale__c;

                                        newMatrixRow.OB_ModelloAcquiring__c = item.OB_ModelloAcquiring__c;
                                        newMatrixRow.OB_Schema_Prezzi__c = item.OB_Schema_Prezzi__c;
                                        newMatrixRow.OB_SelfLookup__c = item.OB_SelfLookup__c;
                                        newMatrixRow.OB_ABIcatItemIdBundleId__c = newMatrix.OB_ABIcatItemIdBundleId__c;
                                        newMatrixRow.NE__Source_External_Id__c = null;

                                        newMatrixRow.OB_MainMP__c = newMatrix.OB_MainMP__c;

                                        newListOfMatrixRow.add(newMatrixRow);
                                    }

                                    if(!mpToBeCreated.isEmpty() && mpToBeCreated != null){
                                        mpToBeCreated.remove(sourceOffId+'_'+sourceCompId+'_'+sourceMp.OB_SchemaPrezzi__c);    
                                    }
                                }
                            }
                        }
                    }

                }
                try{
                    system.debug(LoggingLevel.INFO, '## OB_CloneMatrixParameterQueueable - in execute method - before upsert');
                    if((Double)groupedResults[0].get('expr0') > 0){
                        for(NE__Matrix_Parameter__c mp : mpActiveToUpdate){
                            if(mp.NE__Active__c == false){
                                mp.OB_ActiveBank__c = mp.NE__Active__c;
                            }
                        }
                        update matrixParameters;
                        update mpActiveToUpdate;
                    }

                    if(!newListOfMatrix.isEmpty() && newListOfMatrix != null){
                        upsert newListOfMatrix OB_ABIcatItemIdBundleId__c;
                        if(!nexiNewMatrixParams.isEmpty()){
                            for(NE__Matrix_Parameter_Row__c item : newListOfMatrixRow){
                                item.NE__Matrix_Parameter__c = nexiNewMatrixParams.get(item.OB_ABIcatItemIdBundleId__c).Id;
                                Id matrixParOffId = nexiNewMatrixParams.get(item.OB_ABIcatItemIdBundleId__c).OB_Offerta__c;
                                Id mprCompId = item.OB_Componente__c;
                                Id mprFamId = item.OB_Family__c;
                                Id mprPropId = item.OB_DynamicPropertyDefinition__c;
                                Id mprSelfId = item.OB_SelfLookup__c;
                                String mprDateStr = item.NE__Start_Date__c.year() + '-' + item.NE__Start_Date__c.month() + '-' + item.NE__Start_Date__c.day();
                                system.debug(LoggingLevel.INFO, '## full key: '+abi+cab+'_'+matrixParOffId+'_'+mprCompId+'_'+mprFamId+'_'+mprPropId+'_'+nexiNewMatrixParams.get(item.OB_ABIcatItemIdBundleId__c).OB_SchemaPrezzi__c+'_'+mprSelfId+'_'+mprDateStr);
                                item.OB_ABIcatItemIdBundleId__c = abi+cab+'_'+matrixParOffId+'_'+mprCompId+'_'+mprFamId+'_'+mprPropId+'_'+nexiNewMatrixParams.get(item.OB_ABIcatItemIdBundleId__c).OB_SchemaPrezzi__c+'_'+mprSelfId+'_'+mprDateStr;
                            }
                        }

                        upsert newListOfMatrixRow OB_ABIcatItemIdBundleId__c;

                        for(NE__Matrix_Parameter_Row__c item : newListOfMatrixRow){
                            if(item.OB_SelfLookup__c == null){
                                Id itemCompId = item.OB_Componente__c; 
                                relMap.put(itemCompId+'_'+item.OB_Schema_Prezzi__c, item.Id);
                            }
                        }
                        //davide.franzini - 25/10/2019 - second update moved to new Queueable Split - START
                        OB_CloneMPRQueueableSplit updateJob = new OB_CloneMPRQueueableSplit(relMap, newListOfMatrixRow);
                        ID jobID =    System.enqueueJob(updateJob);
                        //davide.franzini - 25/10/2019 - END
                        system.debug(LoggingLevel.INFO, '## OB_CloneMatrixParameterQueueable - in execute method - after all upserts');
                    }
                }
                catch(Exception e) {
                    System.debug(LoggingLevel.ERROR, 'The following exception has occurred at line: '+e.getLineNumber()+' message : '+e.getMessage());
                    // Rollback to the previous null value
                    Database.rollback(sp);
                }
            }

            //davide.franzini - WN-216 - 30/07/2019 - END
        }
        //davide.franzini - END
    }
    public class OB_CloneMatrixParameterQueueable_Exception extends Exception {}  //davide.franzini - 30/07/2019 - WN-216
}