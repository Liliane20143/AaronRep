global class OB_DeltaRun_LightService {

/*
    -	terminalId: obbligatorio
    -	clientId: obbligatorio, codice cliente monetica
    -	stabId: obbligatorio, codice stabilimento monetica
        -	terminalData
                modelCode: opzionale
                modelDescription: opzionale
                releaseCode: opzionale
                releaseDescription: opzionale
                connectionCode: opzionale
                connectionDescription: opzionale
        -	CompanyData: opzionale
                companyCode (indica la company): obbligatorio
                ABI: obbligatorio
                ActivationDate: obbligatorio uno tra ActivationDate e DeactivandDate
                DeactivandDate: obbligatorio uno tra ActivationDate e DeactivandDate
*/

	public final static String DMODELLO = 'Descrizione Modello';
	public final static String DRELEASE = 'Descrizione Release';
	public final static String DCONNESSIONE = 'Descrizione Connessione';
    public final static String MAINTENANCE = 'Maintenance';

    public class deltaRunException extends Exception {}

    global class CompanyInfo{
        webservice string companyCode;
        webservice string ABI;
        webservice string conventionCode;
        webservice date activationDate;
        webservice date deactivationdDate;
    }  
    global class TermInfo{
        webservice string modelCode;
        webservice string modelDescription;
        webservice string releaseCode;
        webservice string releaseDescription;
        webservice string connectionCode;
        webservice string connectionDescription;
        //LUBRANO 2019-03-19 -- NEW FIELDS FOR MAINTENANCE TERMINAL INSTALLATION
        webservice string CTIcode;
        webservice string stabSIA;
        webservice string progressiveSIA;
        webservice string SIAcode;
        webservice string installationStatus;
        webservice string installationDate;
        webservice string uninstallationDate;
        webservice string rejectionReason;
    }

    global class DeltaRequest{
        webservice string terminalId;
        webservice string clientId;
        webservice string stabId;
        webservice TermInfo terminalData;
        webservice CompanyInfo companyData;
    }

    global class DeltaResponse{
        webservice Integer errorCode;
        webservice string errorMessage;
        webservice Id assetId;
        public Id rootAssetEntId;
        public Id childAssEntId;
    }

    webservice static DeltaResponse updateTerminal (DeltaRequest req){
        DeltaResponse res = new DeltaResponse();

        try{
            System.debug(' @@@ req : ' + req);
            
            if(String.isBlank(req.terminalId) || String.isBlank(req.clientId) || String.isBlank(req.stabId)){
                throw new deltaRunException('Validation Error - reqest missin g mandatory data');
            }

            if(req.terminalData == null && req.companyData == null){
                throw new deltaRunException('Validation Error - Missing company and terminal data');
            }
            String terminalId   = req.terminalId;
            String clientId     = req.clientId;
            String stabId       = req.stabId;
            String ABI          = '';
            //Setting Queries
            String queryStringAsset = 'select Id,OB_TermId__c, OB_ShopCode__c, OB_CustomerCode__c, OB_MCCL2__c,OB_MCC__c,NE__Status__c,';
                    queryStringAsset += ' NE__Catalog__c, NE__CatalogItem__r.NE__Item_Header__c, NE__CatalogItem__r.NE__Type__c,';
                    queryStringAsset += ' NE__Root_Order_Item__c,RootAssetId,NE__Bundle__c,NE__Bundle_element__c, NE__Bundle_Configuration__c,NE__Order_Config__c,';
                    queryStringAsset +=  'AccountId, NE__Service_Account__c, NE__Billing_Account__c, NE__BillingProf__c,OB_ProposerABI__c,';
                    queryStringAsset += '(SELECT id,Name, NE__Value__c FROM NE__AssetItemAttributes__r) from Asset ';
                    queryStringAsset += ' WHERE OB_TermId__c = :terminalId'; 
                    queryStringAsset += ' AND OB_ShopCode__c = :stabId';
                    queryStringAsset += ' AND OB_CustomerCode__c = :clientId';
                    queryStringAsset += ' AND (NE__Status__c = \'Active\' or NE__Status__c = \'In Progress\')';

            String queryStringItem = 'select Id,OB_TermId__c, OB_ShopCode__c, OB_CustomerCode__c,OB_MCCL2__c,OB_MCC__c,NE__Action__c,';
                    queryStringItem += ' NE__Catalog__c, NE__CatalogItem__r.NE__Item_Header__c, NE__CatalogItem__r.NE__Type__c,NE__Status__c,';
                    queryStringItem += ' NE__Root_Order_Item__c,NE__Bundle__c,NE__Bundle_element__c,NE__OrderId__c, OB_ProposerABI__c,NE__OrderId__r.NE__Order_Header__r.OB_Main_Process__c,';
                    queryStringItem += 'NE__Account__c , NE__Service_Account__c, NE__Billing_Account__c, NE__BillingProfId__c,OB_FulfilmentStatus__c,';
                    queryStringItem += '(SELECT id,Name, NE__Value__c FROM NE__Order_Item_Attributes__r) from NE__OrderItem__c ';
                    queryStringItem += ' WHERE OB_TermId__c = :terminalId';  


            if(req.terminalData != null && String.isNotBlank(req.terminalData.installationStatus)){
                //LUBRANO 2019-03-19 -- INSTALLATION TERMINAL EVENT
                if(
                    (req.terminalData.installationStatus.equalsIgnoreCase('Installato') && String.isBlank(req.terminalData.installationDate))
                    || (req.terminalData.installationStatus.equalsIgnoreCase('Disinstallato') && String.isBlank(req.terminalData.uninstallationDate))
                    ){
                    throw new deltaRunException('Validation Error - request missing mandatory data');
                }
                //LUBRANO - 21-03-2019 -- removed filter maintenance from query in order to give custom error message 
                //queryStringItem += ' AND NE__OrderId__r.NE__Order_Header__r.OB_Main_Process__c = \'Maintenance\'';
                queryStringItem += ' AND NE__OrderId__r.OB_FulfilmentStatus__c = \'Pending\'';

                List<NE__OrderItem__c> terminalItemList = Database.query(queryStringItem);
                
                if(terminalItemList.size()==0){
                    throw new deltaRunException('Terminal Not Found');
                }else if(!terminalItemList[0].NE__OrderId__r.NE__Order_Header__r.OB_Main_Process__c.equalsIgnoreCase(MAINTENANCE)){
                    throw new deltaRunException('Terminal Not In Maintenance');
                }

                res = updateTerminalStatus(req, terminalItemList[0]);
            }else{
                    // queryStringItem += ' AND NE__OrderId__r.OB_FulfilmentStatus__c =\'Sent\'';
                    // queryStringItem += ' AND NE__Action__c =\'Add\''; 
                queryStringItem += ' AND OB_ShopCode__c = :stabId';
                queryStringItem += ' AND OB_CustomerCode__c = :clientId';
                if(req.companyData != null){
                    if(req.companyData.companyCode == null || String.isBlank(req.companyData.companyCode )){
                        throw new deltaRunException('Validation Error - company code');
                    }
                    if(req.companyData.conventionCode == null || String.isBlank(req.companyData.conventionCode )){
                        throw new deltaRunException('Validation Error - company code');
                    }
                    if(req.companyData.ABI == null || String.isBlank(req.companyData.ABI)){
                        throw new deltaRunException('Validation Error - ABI');
                    }
                    if(req.companyData.activationDate == null && req.companyData.deactivationdDate == null ){
                        throw new deltaRunException('Validation Error - company data date info missing');
                    }
                    ABI = req.companyData.ABI;
                    queryStringAsset += ' AND OB_ProposerABI__r.OB_ABI__c = :ABI';
                    queryStringItem += ' AND OB_ProposerABI__r.OB_ABI__c = :ABI';
                }

                queryStringAsset += ' LIMIT 1';       

                System.debug('asset query : ' + queryStringAsset);
                List<Asset> terminalAssetList = Database.query(queryStringAsset);
                Boolean verifyOrder = terminalAssetList.size() == 0 || terminalAssetList[0].NE__Status__c == 'In Progress';
                
                
                
                if(terminalAssetList.size() == 0){
                    //LUBRANO 2019-03-19 -- NEW FIELDS FOR MAINTENANCE TERMINAL INSTALLATION
                    //queryStringItem += ' AND NE__OrderId__r.OB_FulfilmentStatus__c =\'Sent\'';
                    queryStringItem += ' AND (NE__OrderId__r.OB_FulfilmentStatus__c =\'Sent\' OR NE__OrderId__r.OB_FulfilmentStatus__c =\'Pending\' )';
                    queryStringItem += ' AND NE__Action__c =\'Add\''; 
                } else if(terminalAssetList[0].NE__Status__c == 'In Progress'){
                    queryStringItem += ' AND NE__OrderId__c = \'' + terminalAssetList[0].NE__Order_Config__c + '\'';
                    queryStringItem += ' AND NE__OrderId__r.OB_FulfilmentStatus__c !=\'Cancelled\'';
                }
                queryStringItem += ' LIMIT 1';
                System.debug('item query : ' + queryStringItem);
                List<NE__OrderItem__c> terminalItemList = new List<NE__OrderItem__c> ();
                if(verifyOrder){
                    terminalItemList = Database.query(queryStringItem);
                }
                    
                if(terminalAssetList != null && terminalAssetList.size()>0 ){
                    res = updateAsset(req,terminalAssetList[0]);
                }
                //LUBRANO -- 2019-04-01 -- bug fix : allow update enablements for orders without asset (still in status 'Sent')
                /* else{
                    
                    res.errorCode = 1;
                    res.errorMessage = 'Asset not found ';           
                }*/            
                
                if(terminalItemList != null && terminalItemList.size()>0){
                    res = updateOrder(req,terminalItemList[0],res.rootAssetEntId,res.childAssEntId);
                }
                
                //LUBRANO -- 2019-04-01 -- bug fix : allow update enablements for orders without asset (still in status 'Sent')
                if(terminalAssetList.size()==0 &&  terminalItemList.size()==0){
                    res.errorCode = 1;
                    res.errorMessage = 'Item not found ';   
                }
                
            }
            return res;
        }catch(Exception e){
            System.debug('@@@ exception : ' + e.getStackTraceString());
            res.errorCode = 1;
            res.errorMessage = e.getMessage();
            return res;
        }
    }
    @testVisible
    static DeltaResponse updateAsset(DeltaRequest req, Asset terminalAsset){
        
        DeltaResponse res = new DeltaResponse();

        try{
            Id idTerminale      = terminalAsset.Id;
            String itemHeader   = terminalAsset.NE__CatalogItem__r.NE__Item_Header__c;
            Asset enablement;

            List<NE__AssetItemAttribute__c> attributes = new List<NE__AssetItemAttribute__c>();

            if(req.terminalData != null){
                for(NE__AssetItemAttribute__c  attr : terminalAsset.NE__AssetItemAttributes__r ){	

                    if(attr.Name.equalsIgnoreCase('modello') && !String.isBlank(req.terminalData.modelCode))
                    {
                        attr.NE__Value__c = req.terminalData.modelCode;
                        terminalAsset.OB_Model__c = req.terminalData.modelCode;
                        attributes.add(attr);
                    }
                    if(attr.Name.equalsIgnoreCase('release') && !String.isBlank(req.terminalData.releaseCode))
                    {
                        attr.NE__Value__c = req.terminalData.releaseCode;
                        terminalAsset.OB_Release__c = req.terminalData.releaseCode;
                        attributes.add(attr);
                    }
                    if(attr.Name.equalsIgnoreCase('modalitàCollegamento') && !String.isBlank(req.terminalData.connectionCode))
                    {
                        attr.NE__Value__c = req.terminalData.connectionCode;
                        terminalAsset.OB_LinkType__c = req.terminalData.connectionCode;
                        attributes.add(attr);
                    }
                    if(attr.Name.equalsIgnoreCase(DMODELLO)  && !String.isBlank(req.terminalData.modelDescription))
                    {
                        attr.NE__Value__c = req.terminalData.modelDescription;
                        terminalAsset.OB_ModelDescription__c = req.terminalData.modelDescription;
                        attributes.add(attr);
                    }
                    if(attr.Name.equalsIgnoreCase(DRELEASE) && !String.isBlank(req.terminalData.releaseDescription))
                    {
                        attr.NE__Value__c = req.terminalData.releaseDescription;
                        terminalAsset.OB_ReleaseDescription__c = req.terminalData.releaseDescription; 
                        attributes.add(attr);
                    }
                    if(attr.Name.equalsIgnoreCase(DCONNESSIONE) && !String.isBlank(req.terminalData.connectionDescription))
                    {
                        attr.NE__Value__c = req.terminalData.connectionDescription;
                        terminalAsset.OB_LinkDescription__c = req.terminalData.connectionDescription;
                        attributes.add(attr);
                    }
                }
                update terminalAsset;

                if(attributes.size()>0){
                    update attributes;
                }
            }

            if(req.companyData != null){
                list<NE__Lov__c> lovs = [SELECT Name,NE__Value1__c,NE__Value2__c 
                                            FROM NE__Lov__c WHERE NE__Sub_Type__c= 'TIPOLOGICHE' AND NE__Type__c='TRACKING'];

                /* ********************************************
                    * BUILD A MAP FROM SFDC VALUES TO MIP VALUES
                    * Name contains the logical gruping
                    * NE__Value1__c Monetica Company CODE
                    * NE__Value2__c contains Product Code
                    **********************************************/
                Map<String,String> decodeValues = new Map<String,String>();

                for(NE__Lov__c val : lovs ){
                    decodeValues.put(val.NE__Value1__c.trim(),val.NE__Value2__c);
                    //conventionCodes.put(val.NE__Value2__c,val.NE__Value2__c);
                }

                List<Asset> enabledCompanyCodes = [SELECT Id,NE__ProdId__r.OB_Codice_sfdc__c 
                                                        FROM Asset
                                                        WHERE NE__Parent_Order_Item__c = :idTerminale];
                /*if(enabledCompanyCodes.size()<1){
                    throw new deltaRunException('No enablements found');
                }*/

                if(!decodeValues.containskey(req.companyData.companyCode)){
                    throw new deltaRunException('No matching companycode found');
                }
                String companyCode = decodeValues.get(req.companyData.companyCode);
                
                if(enabledCompanyCodes.size()>0){
                    for(Asset currentEnablement : enabledCompanyCodes ){
                        if(currentEnablement.NE__ProdId__r.OB_Codice_sfdc__c == companyCode ){
                            enablement = currentEnablement;
                            break;
                        }
                    }
                } 
                
                
                if(enablement != null){
                    if(req.companyData.activationDate != null){
                        enablement.NE__StartDate__c = req.companyData.activationDate;
                        enablement.OB_enablement__c = 'Y';
                    }
                    if(req.companyData.deactivationdDate != null){
                        enablement.NE__EndDate__c = req.companyData.deactivationdDate;
                        enablement.OB_enablement__c = 'N';
                    }
                    update enablement;
                    res.childAssEntId = enablement.Id;


                } else {
                    if(req.companyData.activationDate != null && req.companyData.deactivationdDate != null){
                        throw new deltaRunException('No enablements found - activation and deactivation date are not null');
                    }
                    List<Asset> assetToInsert = new List<Asset>();


                    //Asset enablementAsset = [SELECT Id, OB_ProposerABI__c,AccountId, NE__Service_Account__c, NE__Billing_Account__c  
                    List<Asset> enablementAssetList = [SELECT Id, OB_ProposerABI__c,AccountId, NE__Service_Account__c, NE__Billing_Account__c  
                                                    FROM Asset 
                                                    WHERE NE__ProdId__r.OB_Codice_sfdc__c  =:companyCode 
                                                    AND OB_ProposerABI__c = : terminalAsset.OB_ProposerABI__c
                                                    AND AccountId = : terminalAsset.AccountId
                                                    AND NE__Service_Account__c = : terminalAsset.NE__Service_Account__c
                                                    AND NE__Billing_Account__c = : terminalAsset.NE__Billing_Account__c
                                                    AND NE__CatalogItem__r.NE__Type__c ='Product' LIMIT 1];

                    //NE__Catalog_Item__c childItem = [SELECT Id,NE__Type__c,NE__ProductId__c,NE__Item_Header__c  
                    List<NE__Catalog_Item__c> childItemList = [SELECT Id,NE__Type__c,NE__ProductId__c,NE__Item_Header__c, NE__ProductId__r.Name  
                                                    FROM NE__Catalog_Item__c 
                                                    WHERE NE__ProductId__r.OB_Codice_sfdc__c =:companyCode and NE__Item_Header__c = :itemHeader LIMIT 1];
                    //if(enablementAsset == null){
                        //NE__Catalog_Item__c rootItem = [SELECT Id,NE__Type__c,NE__ProductId__c,NE__Item_Header__c  
                    if(enablementAssetList.size() == 0 ){
                        List<NE__Catalog_Item__c> rootItemList = [SELECT Id,NE__Type__c,NE__ProductId__c,NE__Item_Header__c, NE__ProductId__r.Name  
                                                    FROM NE__Catalog_Item__c 
                                                    WHERE NE__ProductId__r.OB_Codice_sfdc__c =:companyCode
                                                    AND NE__Catalog_Id__c = :terminalAsset.NE__Catalog__c
                                                    AND NE__Type__c ='Product' LIMIT 1];
                        //if(rootItem != null){
                        if(rootItemList.size() > 0){
                            assetToInsert.add(
                                new Asset(
                                    NE__ProdId__c           = rootItemList[0].NE__ProductId__c,
                                    NE__CatalogItem__c      = rootItemList[0].Id,
                                    Name                    = rootItemList[0].NE__ProductId__r.Name,
                                    NE__Catalog__c          = terminalAsset.NE__Catalog__c,
                                    OB_ProposerABI__c       = terminalAsset.OB_ProposerABI__c,
                                    AccountId               = terminalAsset.AccountId,
                                    NE__Service_Account__c  = terminalAsset.NE__Service_Account__c,
                                    NE__Billing_Account__c  = terminalAsset.NE__Billing_Account__c,
                                    NE__Bundle__c           = terminalAsset.NE__Bundle__c,
                                    NE__StartDate__c        = req.companyData.activationDate,
                                    Quantity                = 1,
                                    NE__Action__c           = 'None',
                                    NE__Status__c           = 'Active',
                                    OB_Conventioncode__c    = req.companyData.conventionCode,
                                    NE__Parent_Order_Item__c= null,
                                    NE__Bundle_Configuration__c= terminalAsset.NE__Bundle_Configuration__c,
                                    NE__Order_Config__c     = terminalAsset.NE__Order_Config__c,
                                    OB_MCCL2__c             = terminalAsset.OB_MCCL2__c,
                                    OB_MCC__c               = terminalAsset.OB_MCC__c
                                )
                            );
                        }
                    }

                    assetToInsert.add(
                                new Asset(
                                    NE__ProdId__c           = childItemList[0].NE__ProductId__c,
                                    NE__CatalogItem__c      = childItemList[0].Id,
                                    Name                    = childItemList[0].NE__ProductId__r.Name,
                                    NE__Catalog__c          = terminalAsset.NE__Catalog__c,
                                    OB_ProposerABI__c       = terminalAsset.OB_ProposerABI__c,
                                    AccountId               = terminalAsset.AccountId,
                                    NE__Service_Account__c  = terminalAsset.NE__Service_Account__c,
                                    NE__Billing_Account__c  = terminalAsset.NE__Billing_Account__c,
                                    NE__Bundle__c           = terminalAsset.NE__Bundle__c,
                                    NE__Root_Order_Item__c  = terminalAsset.Id,
                                    NE__Parent_Order_Item__c= terminalAsset.Id,
                                    OB_enablement__c        = 'Y',
                                    Quantity                = 1,
                                    NE__StartDate__c        = req.companyData.activationDate,
                                    NE__Action__c           = 'None',
                                    NE__Status__c           = 'Active',
                                    OB_Conventioncode__c    = req.companyData.conventionCode,
                                    NE__Bundle_Configuration__c= terminalAsset.NE__Bundle_Configuration__c,
                                    NE__Order_Config__c     = terminalAsset.NE__Order_Config__c,
                                    OB_MCCL2__c             = terminalAsset.OB_MCCL2__c,
                                    OB_MCC__c               = terminalAsset.OB_MCC__c
                                    //RootAssetId             = terminalAsset.Id
                                )
                            );                           
                    insert assetToInsert;

                    List<NE__AssetItemAttribute__c> assetItemAttrToInsert = new List<NE__AssetItemAttribute__c>();

                    for(Asset tmp : assetToInsert){
                        tmp.NE__AssetItemEnterpriseId__c = tmp.Id;
                        if(tmp.NE__Parent_Order_Item__c != null){
                            res.childAssEntId = tmp.Id;
                        } else {
                            res.rootAssetEntId = tmp.Id;
                        }

                        // EP NON SI FA MA DOVREBBE ESSERE INNOQUA
                        List<NE__ProductFamilyProperty__c> itemAttributes = [SELECT id,Name,NE__FamilyPropertyCode__c,NE__FamilyId__c  
                                                                           FROM NE__ProductFamilyProperty__c 
                                                                           WHERE NE__FamilyId__c in ( 
                                                                               SELECT NE__FamilyId__c 
                                                                               FROM NE__ProductFamily__c 
                                                                               WHERE NE__ProdId__c = : tmp.NE__ProdId__c)];
                        if(itemAttributes.size() > 0){
                            for(NE__ProductFamilyProperty__c prop: itemAttributes){
                                NE__AssetItemAttribute__c assetItemAttr = new NE__AssetItemAttribute__c(Name = prop.Name,
                                                                                                    NE__FamPropId__c =prop.Id,
                                                                                                    NE__FamPropExtId__c = prop.NE__FamilyPropertyCode__c,
                                                                                                    NE__Asset__c = tmp.Id,
                                                                                                    NE__Action__c = 'None',
                                                                                                    NE__Value__c = req.companyData.conventionCode
                                                                                                    );
                                assetItemAttrToInsert.add(assetItemAttr);
                            }
                        }                    
                        
                    }
                    update assetToInsert;

                    if(assetItemAttrToInsert.size() >0){
                        insert assetItemAttrToInsert;

                        for(NE__AssetItemAttribute__c assetItem : assetItemAttrToInsert){
                            assetItem.NE__AttrEnterpriseId__c = assetItem.Id;
                        }

                        update assetItemAttrToInsert;
                    }
                    

                }
            }
            res.errorCode = 0;
            //res.assetId = enablement.Id;
            return res;

        }catch(Exception e){
            System.debug('@@@ exception update asset : ' + e.getStackTraceString());
            res.errorCode = 1;
            res.errorMessage = e.getMessage();
            return res;
        }
    }
    @testVisible
    static DeltaResponse updateOrder(DeltaRequest req, NE__OrderItem__c terminalItem, Id rootAssetEntId ,Id childAssEntId ){
        
        DeltaResponse res = new DeltaResponse();

        try{
            Id idTerminale      = terminalItem.Id;
            String itemHeader   = terminalItem.NE__CatalogItem__r.NE__Item_Header__c;
            NE__OrderItem__c enablement;

            List<NE__Order_Item_Attribute__c > attributes = new List<NE__Order_Item_Attribute__c >();

            if(req.terminalData != null){
                for(NE__Order_Item_Attribute__c   attr : terminalItem.NE__Order_Item_Attributes__r ){	

                    if(attr.Name.equalsIgnoreCase('modello') && !String.isBlank(req.terminalData.modelCode))
                    {
                        attr.NE__Value__c = req.terminalData.modelCode;
                        terminalItem.OB_Model__c = req.terminalData.modelCode;
                        attributes.add(attr);
                    }
                    if(attr.Name.equalsIgnoreCase('release') && !String.isBlank(req.terminalData.releaseCode))
                    {
                        attr.NE__Value__c = req.terminalData.releaseCode;
                        terminalItem.OB_Release__c = req.terminalData.releaseCode;
                        attributes.add(attr);
                    }
                    if(attr.Name.equalsIgnoreCase('modalitàCollegamento') && !String.isBlank(req.terminalData.connectionCode))
                    {
                        attr.NE__Value__c = req.terminalData.connectionCode;
                        terminalItem.OB_LinkType__c = req.terminalData.connectionCode;
                        attributes.add(attr);
                    }
                    if(attr.Name.equalsIgnoreCase(DMODELLO)  && !String.isBlank(req.terminalData.modelDescription))
                    {
                        attr.NE__Value__c = req.terminalData.modelDescription;
                        terminalItem.OB_ModelDescription__c = req.terminalData.modelDescription;
                        attributes.add(attr);
                    }
                    if(attr.Name.equalsIgnoreCase(DRELEASE) && !String.isBlank(req.terminalData.releaseDescription))
                    {
                        attr.NE__Value__c = req.terminalData.releaseDescription;
                        terminalItem.OB_ReleaseDescription__c = req.terminalData.releaseDescription; 
                        attributes.add(attr);
                    }
                    if(attr.Name.equalsIgnoreCase(DCONNESSIONE) && !String.isBlank(req.terminalData.connectionDescription))
                    {
                        attr.NE__Value__c = req.terminalData.connectionDescription;
                        terminalItem.OB_LinkDescription__c = req.terminalData.connectionDescription;
                        attributes.add(attr);
                    }
                }
                update terminalItem;

                if(attributes.size()>0){
                    update attributes;
                }
            }

            if(req.companyData != null){
                list<NE__Lov__c> lovs = [SELECT Name,NE__Value1__c,NE__Value2__c 
                                            FROM NE__Lov__c WHERE NE__Sub_Type__c= 'TIPOLOGICHE' AND NE__Type__c='TRACKING'];

                /* ********************************************
                    * BUILD A MAP FROM SFDC VALUES TO MIP VALUES
                    * Name contains the logical gruping
                    * NE__Value1__c Monetica Company CODE
                    * NE__Value2__c contains Product Code
                    **********************************************/
                Map<String,String> decodeValues = new Map<String,String>();

                for(NE__Lov__c val : lovs ){
                    decodeValues.put(val.NE__Value1__c.trim(),val.NE__Value2__c);
                    //conventionCodes.put(val.NE__Value2__c,val.NE__Value2__c);
                }

                List<NE__OrderItem__c> enabledCompanyCodes = [SELECT Id,NE__ProdId__r.OB_Codice_sfdc__c 
                                                        FROM NE__OrderItem__c
                                                        WHERE NE__Parent_Order_Item__c = :idTerminale];
                /*if(enabledCompanyCodes.size()<1){
                    throw new deltaRunException('No enablements found');
                }*/

                if(!decodeValues.containskey(req.companyData.companyCode)){
                    throw new deltaRunException('No matching companycode found');
                }
                String companyCode = decodeValues.get(req.companyData.companyCode);
                
                if(enabledCompanyCodes.size()>0){
                    for(NE__OrderItem__c currentEnablement : enabledCompanyCodes ){
                        if(currentEnablement.NE__ProdId__r.OB_Codice_sfdc__c == companyCode ){
                            enablement = currentEnablement;
                            break;
                        }
                    }
                }
                
                
                if(enablement != null){
                    if(req.companyData.activationDate != null){
                        enablement.NE__StartDate__c = req.companyData.activationDate;
                        enablement.OB_enablement__c = 'Y';
                        enablement.NE__FulfilmentStatus__c = 'Completed';
                    }
                    if(req.companyData.deactivationdDate != null){
                        enablement.NE__EndDate__c = req.companyData.deactivationdDate;
                        enablement.OB_enablement__c = 'N';
                    }
                    update enablement;

                } else {
                    if(req.companyData.activationDate != null && req.companyData.deactivationdDate != null){
                        throw new deltaRunException('No enablements found - activation and deactivation date are not null');
                    }
                    List<NE__OrderItem__c> itemToInsert = new List<NE__OrderItem__c>();

                    //NE__OrderItem__c enablementItem = [SELECT Id, OB_ProposerABI__c,NE__Account__c, NE__Service_Account__c, NE__Billing_Account__c  
                    List<NE__OrderItem__c> enablementItemList = [SELECT Id, OB_ProposerABI__c,NE__Account__c, NE__Service_Account__c, NE__Billing_Account__c  
                                                    FROM NE__OrderItem__c 
                                                    WHERE NE__ProdId__r.OB_Codice_sfdc__c  =:companyCode 
                                                    AND OB_ProposerABI__c = : terminalItem.OB_ProposerABI__c
                                                    AND NE__Account__c = : terminalItem.NE__Account__c
                                                    AND NE__Service_Account__c = : terminalItem.NE__Service_Account__c
                                                    AND NE__Billing_Account__c = : terminalItem.NE__Billing_Account__c
                                                    AND NE__CatalogItem__r.NE__Type__c ='Product' LIMIT 1];

                    //NE__Catalog_Item__c childItem = [SELECT Id,NE__Type__c,NE__ProductId__c,NE__Item_Header__c  
                    List<NE__Catalog_Item__c> childItemList = [SELECT Id,NE__Type__c,NE__ProductId__c,NE__Item_Header__c  
                                                    FROM NE__Catalog_Item__c 
                                                    WHERE NE__ProductId__r.OB_Codice_sfdc__c =:companyCode and NE__Item_Header__c = :itemHeader LIMIT 1];
                    //if(enablementItem == null){
                       //NE__Catalog_Item__c rootItem = [SELECT Id,NE__Type__c,NE__ProductId__c,NE__Item_Header__c  
                    if(enablementItemList.size() == 0){
                       List<NE__Catalog_Item__c> rootItemList = [SELECT Id,NE__Type__c,NE__ProductId__c,NE__Item_Header__c  
                                                    FROM NE__Catalog_Item__c 
                                                    WHERE NE__ProductId__r.OB_Codice_sfdc__c =:companyCode
                                                    AND NE__Catalog_Id__c = :terminalItem.NE__Catalog__c
                                                    AND NE__Type__c ='Product' LIMIT 1];

                        
                        
                        //if(rootItem != null){
                        if(rootItemList.size()>0){
                            itemToInsert.add(
                                new NE__OrderItem__c(
                                    NE__ProdId__c           = rootItemList[0].NE__ProductId__c,
                                    NE__CatalogItem__c      = rootItemList[0].Id,
                                    NE__OrderId__c          = terminalItem.NE__OrderId__c,
                                    NE__Catalog__c          = terminalItem.NE__Catalog__c,
                                    OB_ProposerABI__c       = terminalItem.OB_ProposerABI__c,
                                    NE__Account__c          = terminalItem.NE__Account__c,
                                    NE__Service_Account__c  = terminalItem.NE__Service_Account__c,
                                    NE__Billing_Account__c  = terminalItem.NE__Billing_Account__c,
                                    NE__Bundle__c           = terminalItem.NE__Bundle__c,
                                    NE__StartDate__c        = req.companyData.activationDate,
                                    NE__Qty__c              = 1,
                                    NE__Action__c           = 'Active',
                                    NE__Status__c           = 'None',
                                    //NE__FulfilmentStatus__c = 'Completed',
                                    OB_FulfilmentStatus__c = 'Completed',
                                    OB_Conventioncode__c    = req.companyData.conventionCode,
                                    NE__AssetItemEnterpriseId__c = rootAssetEntId,
                                    OB_MCCL2__c             = terminalItem.OB_MCCL2__c,
                                    OB_MCC__c               = terminalItem.OB_MCC__c
                                )
                            );
                        }
                    }

                    itemToInsert.add(
                                new NE__OrderItem__c(
                                    NE__ProdId__c           = childItemList[0].NE__ProductId__c,
                                    NE__CatalogItem__c      = childItemList[0].Id,
                                    NE__OrderId__c          = terminalItem.NE__OrderId__c,
                                    NE__Catalog__c          = terminalItem.NE__Catalog__c,
                                    OB_ProposerABI__c       = terminalItem.OB_ProposerABI__c,
                                    NE__Account__c          = terminalItem.NE__Account__c,
                                    NE__Service_Account__c  = terminalItem.NE__Service_Account__c,
                                    NE__Billing_Account__c  = terminalItem.NE__Billing_Account__c,
                                    NE__Bundle__c           = terminalItem.NE__Bundle__c,
                                    NE__Root_Order_Item__c  = terminalItem.Id,
                                    NE__Parent_Order_Item__c= terminalItem.Id,
                                    OB_enablement__c        ='Y',
                                    NE__StartDate__c        = req.companyData.activationDate,
                                    NE__Qty__c              = 1,
                                    // NE__Action__c           = 'Add',
                                    // NE__Status__c           = 'Pending',
                                    // NE__FulfilmentStatus__c = 'Completed',
                                    NE__Action__c           = terminalItem.NE__Action__c,
                                    NE__Status__c           = terminalItem.NE__Status__c,
                                    OB_FulfilmentStatus__c = terminalItem.OB_FulfilmentStatus__c,
                                    OB_Conventioncode__c    = req.companyData.conventionCode,
                                    NE__AssetItemEnterpriseId__c= childAssEntId,
                                    OB_MCCL2__c             = terminalItem.OB_MCCL2__c,
                                    OB_MCC__c               = terminalItem.OB_MCC__c
                                )
                            );                           
                    insert itemToInsert;
                    
                    List<NE__Order_Item_Attribute__c> orderItemAttrToInsert = new List<NE__Order_Item_Attribute__c>();

                    for(NE__OrderItem__c tmp : itemToInsert){
                        if(tmp.NE__AssetItemEnterpriseId__c == null){
                            tmp.NE__AssetItemEnterpriseId__c = tmp.Id;
                        }                        

                        List<NE__ProductFamilyProperty__c> itemAttributes = [SELECT id,Name,NE__FamilyPropertyCode__c,NE__FamilyId__c  
                                                                               FROM NE__ProductFamilyProperty__c 
                                                                               WHERE NE__FamilyId__c in ( 
                                                                                   SELECT NE__FamilyId__c 
                                                                                   FROM NE__ProductFamily__c 
                                                                                   WHERE NE__ProdId__c = : tmp.NE__ProdId__c)];
                        if(itemAttributes.size() > 0){
                            for(NE__ProductFamilyProperty__c prop: itemAttributes){
                                NE__Order_Item_Attribute__c orderItemAttr = new NE__Order_Item_Attribute__c(Name = prop.Name,
                                                                                                        NE__FamPropId__c =prop.Id,
                                                                                                        NE__FamPropExtId__c = prop.NE__FamilyPropertyCode__c,
                                                                                                        NE__Order_Item__c = tmp.Id,
                                                                                                        NE__Action__c = 'None',
                                                                                                        NE__Value__c = req.companyData.conventionCode
                                                                                                        );
                                orderItemAttrToInsert.add(orderItemAttr);
                            }
                        }                      
                    }
                    update itemToInsert;
                    
                    List<NE__AssetItemAttribute__c> assetAttributeList = [select id,NE__FamPropId__c,NE__AttrEnterpriseId__c,NE__Asset__r.NE__AssetItemEnterpriseId__c from NE__AssetItemAttribute__c where NE__Asset__r.NE__AssetItemEnterpriseId__c =: rootAssetEntId or NE__Asset__r.NE__AssetItemEnterpriseId__c =: childAssEntId limit 1];
                    
                    Map<String,String> assAttributeMap = new Map<String,String>();
                    for( NE__AssetItemAttribute__c assAtrr : assetAttributeList){
                        assAttributeMap.put(assAtrr.NE__Asset__r.NE__AssetItemEnterpriseId__c + '_' +assAtrr.NE__FamPropId__c , assAtrr.NE__AttrEnterpriseId__c);
                    }

                    if(orderItemAttrToInsert.size() >0){
                        insert orderItemAttrToInsert;

                        for(NE__Order_Item_Attribute__c orderItemAttr : orderItemAttrToInsert){
                            String fatherId = '';
                            for( NE__OrderItem__c itemOrder : itemToInsert){
                                if(orderItemAttr.NE__Order_Item__c == itemOrder.Id){
                                    fatherId = itemOrder.NE__AssetItemEnterpriseId__c;
                                    break;
                                }
                            }

                            if(assAttributeMap.containsKey(fatherId + '_' + orderItemAttr.NE__FamPropId__c)){
                                orderItemAttr.NE__AttrEnterpriseId__c = assAttributeMap.get(fatherId + '_' + orderItemAttr.NE__FamPropId__c);   
                            }
                            //orderItemAttr.NE__AttrEnterpriseId__c = assetItem.Id;
                        }

                        update orderItemAttrToInsert;
                    }

                }
            }
            res.errorCode = 0;
            // res.assetId = enablement.Id;
            return res;

        }catch(Exception e){
            System.debug('@@@ exception updateorder : ' + e.getStackTraceString());
            res.errorCode = 1;
            res.errorMessage = e.getMessage();
            return res;
        }
    }
    @testVisible
    static DeltaResponse updateTerminalStatus(DeltaRequest req, NE__OrderItem__c terminalItem){
        DeltaResponse res = new DeltaResponse();
        OB_TrackingOrder track = new OB_TrackingOrder();
		OB_TrackingOrder.TrackingOrderRequest trackingReq = new OB_TrackingOrder.TrackingOrderRequest();
        OB_TrackingOrder.GT currentGT			= new OB_TrackingOrder.GT();
		OB_TrackingOrder.TermsIdInformation currentTermsIdInfo 		= new OB_TrackingOrder.TermsIdInformation();
		OB_TrackingOrder.puntoVendita currentPV 	= new OB_TrackingOrder.puntoVendita();

        try{
            
            trackingReq.idOrdineSfdc 						= terminalItem.NE__OrderId__c;
            trackingReq.Acquiring 							= null;  
            trackingReq.GT  								= new List<OB_TrackingOrder.GT>();

            currentGT.sistemaSorgente 				= 'NEXI';
            currentGT.statoProvisioning 			= 'Installazione Terminali';
            currentGT.codiceCliente 				= req.clientId;
            currentGT.puntiVendita 					= new List<OB_TrackingOrder.puntoVendita>();

            currentPV.termsIdInformations  				= new List<OB_TrackingOrder.TermsIdInformation>();
            currentTermsIdInfo.codiciconvenzioni 		= new List<OB_TrackingOrder.CodiciConvenzioni>();

            currentTermsIdInfo.termId 					= req.terminalId;
            currentTermsIdInfo.modello 					= req.terminalData.modelCode;
            currentTermsIdInfo.descrizioneModello 		= req.terminalData.modelDescription;
            currentTermsIdInfo.release 					= req.terminalData.releaseCode;
            currentTermsIdInfo.descrizioneRelease 		= req.terminalData.releaseDescription;
            currentTermsIdInfo.descrizioneConnessione 	= req.terminalData.connectionDescription;
            currentTermsIdInfo.modalitaCollegamento 	= req.terminalData.connectionDescription;
		    currentTermsIdInfo.statoInstallazione 		= req.terminalData.installationStatus;
            
		    currentTermsIdInfo.dataInstallazione 		= req.terminalData.installationDate;
            currentTermsIdInfo.dataDisinstallazione 	= req.terminalData.uninstallationDate;
            currentTermsIdInfo.causaleRifiuto 			= req.terminalData.rejectionReason;

            currentPV.dataInizio						= req.terminalData.installationStatus.equalsIgnoreCase('Rifiutato') ? String.valueOf(System.today()) : req.terminalData.installationDate;
            currentPV.dataCessazione					= req.terminalData.uninstallationDate;
            currentPV.causaleCessazione					= req.terminalData.rejectionReason;
            currentPV.tipo								= 'FISICO';
            currentPV.codiceCTI							= req.terminalData.CTIcode;
            currentPV.codiceStabilimento				= req.stabId;
            currentPV.codiceStabilimentoSIA				= req.terminalData.stabSIA;
            currentPV.codiceProgressivoSIA				= req.terminalData.progressiveSIA;
            currentPV.codiceSIA							= req.terminalData.SIAcode;
            currentPV.numeroAssistenzaPOS				= '';
            currentPV.dataInizioAttivita				= req.terminalData.installationDate;

            currentPV.termsIdInformations.add(currentTermsIdInfo);
		    currentGT.puntiVendita.add(currentPV);
            trackingReq.GT.add(currentGT);
		    System.debug('@trackingReq : ' + JSON.serialize(trackingReq));
            OB_TrackingOrder.getTrackingOrder(trackingReq);
            String posId = terminalItem.Id;
		    if(posId != ''){
			    List<NE__OrderItem__c> childItems = [SELECT Id FROM NE__OrderItem__c WHERE NE__Parent_Order_Item__c =: posId ];
			    for(NE__OrderItem__c child : childItems){
				    child.OB_FulfilmentStatus__c =  req.terminalData.installationStatus.equalsIgnoreCase('Rifiutato') ? 'Cancelled' : 'Completed';
			    }
				update childItems;
            }
            OB_Maintenance_Consistenza_ConfItem_CC.checkConfiguration(terminalItem.NE__OrderId__c);

            res.errorCode = 0;
            return res;
        }catch(Exception e){
            System.debug('@@@ exception updateorder : ' + e.getStackTraceString());
            res.errorCode = 1;
            res.errorMessage = e.getMessage();
            return res;
        }
    }
}