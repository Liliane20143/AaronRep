public without sharing class OB_Maintenance_DynamicTable_Controller {
    public OB_Maintenance_DynamicTable_Controller () {
        
    } 

    private static final string OFFER_SEARCH ='OFFER';
    private static final string TERMINAL_SEARCH ='TERMINAL';
    private static final string PAGOBANCOMAT_SEARCH ='PAGOBANCOMAT';
    private static final string ACQUIRING_SEARCH ='ACQUIRING';
    private static final string COMMISSION_SEARCH ='COMMISSIONE';
    private static final string VAS_SEARCH ='VAS';
    //START Andrea Saracini 13/05/2019 Card No Present
    private static final string E_COMMERCE_SEARCH ='eCommerce';
    private static final string MOTO_SEARCH ='Moto';
    private static final string APM_SEARCH ='APM';
    private static final string INT_SEARCH ='Integrazione';
    //STOP Andrea Saracini 13/05/2019 Card No Present
    /*@auraenabled
    public string retriveData(string servicePointId){
        try{
            // retrive all 'Offer'
            list<Asset> listOfOffer = [Select Id,Name,NE__Service_Point__c from Asset where NE__Bundle__c !='' and NE__Bundle_Configuration__c='' and NE__Service_Point__c = : servicePointId];


        }
        catch(Exception e) {
            system.debug(logginglevel.error,'Exception in OB_Maintenance_Asset_Summary_Controller at '+e.getStackTraceString());
        }

    }*/

    //label: 'Name', fieldName: 'Name', type: 'text'

    public class FieldWrapper{
        @auraEnabled 
        public string fielLabel;
        @auraEnabled 
        public string fieldName;
        @auraEnabled 
        public string fieldType;

        public FieldWrapper (Schema.DescribeFieldResult fieldResult ){
            this.fielLabel = fieldResult.getLabel();
            this.fieldName = fieldResult.getName();
            Schema.DisplayType fieldType = fieldResult.getType();
            switch on fieldType {
                when DATE {     // when block 1
                   this.fieldType ='date';
                }   
                when DATETIME {     // when block 2
                    this.fieldType ='date';
                }
                when CURRENCY  {        // when block 3
                     this.fieldType ='currency';
                }
                when EMAIL {        // when block 3
                     this.fieldType ='email';
                }
                when PHONE {        // when block 3
                     this.fieldType ='phone';
                }
                when else {       // default block, optional
                   this.fieldType ='text';
                }
            }
        }
            
    }

    public class SchemaWrapper{
        @auraEnabled 
        public list<FieldWrapper> listOfField ;
        public list<SObject> dataToShow;
        public SchemaWrapper(){
            this.listOfField = new list<FieldWrapper>();
        }

    }



    public class TreeWrapper{
        @auraEnabled 
        public list<FieldWrapper> listOfField;
        public list<ObjectWrapper> dataToShow;
                public TreeWrapper(){
                    this.dataToShow = new list<ObjectWrapper>();
                    this.listOfField = new list<FieldWrapper>();
                }
    }

    public class ObjectWrapper {
        @auraEnabled
        public SObject obj;
        @auraEnabled
        public list<asset> listOfChild;
    }



    
    @auraEnabled
    public static string retriveInformationTree(list<string> fieldsToRetrive,string offerid){
        Map<String,Map<String,Schema.DescribeFieldResult>> objType2fieldData = new Map<String,Map<String,Schema.DescribeFieldResult>>();
        objType2fieldData.putAll(OB_Maintenance_Helper.fieldObjType2APINameSchema('Asset'));
        System.debug('objType2fieldData  ----<> ' + objType2fieldData);
        TreeWrapper returnWrapper = new TreeWrapper();
        Map<String,Schema.DescribeFieldResult> mapOfFields = objType2fieldData.get('Asset');
        System.debug('mapOfFields ----<> '+ mapOfFields);

        for(string fieldname : fieldsToRetrive){

            returnWrapper.listOfField.add( new FieldWrapper (mapOfFields.get(fieldname)));
        }
        retriveTerminalInformation(fieldsToRetrive,offerid,returnWrapper.dataToShow);
        string returnJSON = JSON.serialize(returnWrapper);
        System.debug('@@@returnJSON: ' + returnJSON);
        return returnJSON ;

    }


    @testVisible 
    private static void retriveTerminalInformation (list<string> fieldsToRetrive,string offerid, list<ObjectWrapper> dataToShow ) {

        system.debug('offerid is '+offerid);
        list<SObject> toreturn = new list<SObject>();
        if(!string.isblank(offerid) ){
            string  soql = 'Select id, ';
            for (string field : fieldsToRetrive){
                soql+= field+' , ';
            }
            soql = soql.removeEnd(' , ');
            soql+=' FROM ASSET';
                      
            // retriving terminal.
            Id rtTerminal = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get('Terminali' ).getRecordTypeId(); // TO DO - Remove terminal , sobstitute with constants           
            //START Andrea Saracini 14/05/2019 Card No Present
            Id rtECommerce = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get('eCommerce').getRecordTypeId(); 
            Id rtMoto = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get('Moto').getRecordTypeId();
            //soql+=  ' where NE__Bundle_Configuration__c = \''+offerid+'\'  AND  NE__ProdId__r.RecordTypeid = \''+rtTerminal+'\'';
            soql+=  ' where NE__Bundle_Configuration__c = \''+offerid+'\'  AND  NE__ProdId__r.RecordTypeid IN (\''+rtTerminal+'\',\''+rtECommerce+'\',\''+rtMoto+'\')';
            //STOP Andrea Saracini 14/05/2019 Card No Present           
            system.debug(logginglevel.info, 'OB_Maintenance_DynamicTable_Controller - retriveTerminalInformation SOQ is : '+soql  );
            List<Asset> listofAsset = (List<Asset> ) Database.query(soql);
            // retrive enablements 
            if( listofAsset != null && !listofAsset.isEmpty()){
                list<id> listOfRetrivedAsset = OB_Maintenance_Helper.retriveListOfId(listofAsset);
                // Pricing
                // francesca.ribezzi id recordtype changed from asset to ne__product!!!
                id pricingRTId = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get('Pricing' ).getRecordTypeId(); // To-do : remove hardcoded name
                // retrive enablements  Vas
                //id vasRTid = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('Vas' ).getRecordTypeId(); // To-do : remove hardcoded name
                list<Asset> listofEnablement = [select Id,
                                                       NE__Root_Order_Item__c,
                                                       NE__ProdId__r.name,
                                                       NE__ProdId__r.RecordType.Developername,
                                                       OB_enablement__c,
                                                       OB_ProposerABI__r.OB_ABI__c
                                                       from asset where 
                                                                NE__Bundle_Configuration__c = :offerid   
                                                            and NE__Root_Order_Item__c in : listOfRetrivedAsset 
                                                            and NE__ProdId__r.RecordTypeid != : pricingRTId 
                                               		 order by OB_Sequence__c];
                // set the list of enablements for each asset
                //if( listofEnablement != null && !listofEnablement.isEmpty()){
                
                system.debug('@@@listofAsset: ' + listofAsset);//lista degli order item padri
                system.debug('@@@listofEnablement: ' + listofEnablement);
                //francesca.ribezzi changed from map id list string to map id list to asset!
                    map<id,list<asset>> mapOfEnablements =   revertListOfAsset(listofEnablement) ;
                    for (Asset a : listofAsset ){
                        ObjectWrapper singleWrapper = new ObjectWrapper();
                        singleWrapper.obj = a;
                        singleWrapper.listOfChild =mapOfEnablements.containskey(a.id)? mapOfEnablements.get(a.id): null;
                        //singleWrapper.listOfChild  = new list<STring>{'figlio 1', 'figlio 2'};
                        dataToShow.add(singleWrapper);
                    }   
                 
                //}
                //else {
                    // in cose no enablements found 

                //}
            }

        }
    }



    @testVisible
    private static map<id,list<asset> > revertListOfAsset (List<Asset> listofEnablement){
         map<id,list<asset> >  mapIdRootAssetId = new map<id,list<asset>> ();
         if(listofEnablement != null && !listofEnablement.isEmpty() ){
             for( Asset a : listofEnablement){
                if( mapIdRootAssetId.containsKey(a.NE__Root_Order_Item__c) ){
                	mapIdRootAssetId.get(a.NE__Root_Order_Item__c).add(a);
                   // mapIdRootAssetId.get(a.NE__Root_Order_Item__c).add(a.OB_enablement__c);
                }
                else {
                	 mapIdRootAssetId.put(a.NE__Root_Order_Item__c,new list<asset> {a});
                   // mapIdRootAssetId.put(a.NE__Root_Order_Item__c,new list<String> {a.OB_enablement__c});
                }
             }
         }
         System.debug('@@@mapIdRootAssetId: ' + mapIdRootAssetId);
        return mapIdRootAssetId;
    }
   

    @auraEnabled 
    public static string retriveInformation(list<string> fieldsToRetrive, string SObjectToRetrive, string queryType, string parentid, string proposerABI,String bundleConfiguration){
        system.debug(logginglevel.info,'aaaaaaaaaa retrieveData fieldsToRetrive is '+fieldsToRetrive);
        system.debug(logginglevel.info,'aaaaaaaaaa retrieveData SObjectToRetrive is '+SObjectToRetrive);
        system.debug(logginglevel.info,'aaaaaaaaaa retrieveData queryType is '+queryType);
        system.debug(logginglevel.info,'aaaaaaaaaa retrieveData parentid is '+parentid);
        Map<String,Map<String,Schema.DescribeFieldResult>> objType2fieldData = new Map<String,Map<String,Schema.DescribeFieldResult>>();
        objType2fieldData.putAll(OB_Maintenance_Helper.fieldObjType2APINameSchema(SObjectToRetrive));
        SchemaWrapper returnWrapper = new SchemaWrapper();
        Map<String,Schema.DescribeFieldResult> mapOfFields = objType2fieldData.get(SObjectToRetrive);

        for(string fieldname : fieldsToRetrive){
                returnWrapper.listOfField.add( new FieldWrapper (mapOfFields.get(fieldname)));
        }
        /*for(string currentSObject : SObjectToRetrive){
                returnWrapper.mapSObjectfields.put(currentSObject,ob_maintenance_helper.estractFieldsLabel(objType2fieldData.get(currentSObject)) );
        }*/
        returnWrapper.dataToShow = retrieveData(fieldsToRetrive,SObjectToRetrive, queryType, parentid, proposerABI,bundleConfiguration);
        string toReturnJSON = JSON.serialize(returnWrapper);

        return toReturnJSON;
    }
  
    @testvisible
    private static list<SObject> retrieveData (list<string> fieldsToRetrive, string SObjectToRetrive, string queryType, string parentid, string proposerABI,String bundleConfiguration){//elena.preteni 07/05/2019 add bundleConfiguration input

        system.debug(logginglevel.debug, '*******************retrieveData  fieldsToRetrive : '+fieldsToRetrive+' SObjectToRetrive '+SObjectToRetrive+'  queryType '+queryType +' parentid  '+parentid) ;
		//09/01/19 francesca.ribezzi - adding abi filter to query:
        String abiFilter = '';
        if(String.isNotBlank(proposerABI)){
            abiFilter =' and OB_ProposerABI__r.OB_ABI__c = \''+proposerABI+'\'';
        }
        list<SObject> toreturn = new list<SObject>();
        if(!string.isblank(parentid) ){
            string  soql = 'Select id, ';
            for (string field : fieldsToRetrive){
                soql+= field+' , ';
            }
            soql = soql.removeEnd(' , ');
            soql+=' FROM '+SObjectToRetrive;
            system.debug(logginglevel.info,' retrieveData parentid is '+parentid);
            if('Asset'.equalsignorecase(SObjectToRetrive) ) {
                if(OFFER_SEARCH.equalsignorecase(queryType) ){
                    if( bundleConfiguration == null){
                        soql+= ' Where  NE__Bundle__c !=\'\' and NE__Bundle_Configuration__c= \'\' and NE__Service_Point__c = \''+parentid+'\'' + abiFilter; 
                        system.debug(logginglevel.debug,'OFFER_SEARCH --> retrieveData SOQL is  '+soql) ;
                    }else{
                        //START elena.preteni 07/05/2019 add bundleConfiguration to the query
                        soql+= ' WHERE Id = \''+bundleConfiguration+'\'';
                        system.debug(logginglevel.debug,'OFFER_SEARCH --> retrieveData SOQL is '+soql) ;
                        //END elena.preteni 07/05/2019 
                    }
                }
                if(TERMINAL_SEARCH.equalsignorecase(queryType)){
                    Id rtTerminal = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get('Terminali' ).getRecordTypeId(); // TO DO - Remove terminal , sobstitute with constants
                    soql+=  ' where NE__Bundle_Configuration__c = \''+parentid+'\'  AND  NE__ProdId__r.RecordTypeid = \''+rtTerminal+'\'' +abiFilter;

                }
                if(PAGOBANCOMAT_SEARCH.equalsignorecase(queryType)){
                    Id rtPagobancomat = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get('Pagobancomat' ).getRecordTypeId(); // TO DO - Remove terminal , sobstitute with constants
                      soql+=  ' where NE__Bundle_Configuration__c =\''+parentid+'\' and NE__ProdId__r.RecordTypeid = \''+rtPagobancomat+'\' and NE__Root_Order_Item__c = \'\' '+abiFilter+' order by OB_Sequence__c';
                }
                
                if(ACQUIRING_SEARCH.equalsignorecase(queryType)){
                    Id rtAcquiring = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get('Acquiring' ).getRecordTypeId(); // TO DO - Remove terminal , sobstitute with constants
                   // Id rtCommission = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get('Commissione' ).getRecordTypeId();
                    soql+=  ' where NE__Bundle_Configuration__c =\''+parentid+'\' AND NE__Status__c != \''+OB_UtilityConstants.ASSET_STATUS_DISCONNECTED+'\'  AND NE__ProdId__r.RecordTypeid = \''+rtAcquiring+'\'  and NE__Root_Order_Item__c = \'\' '+abiFilter+' order by OB_Sequence__c';   //davide.franzini - 05/07/2019 - F2WAVE2-104 - added filter on Status
                }
                if(VAS_SEARCH.equalsignorecase(queryType)){
                    Id rtVas = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get('Vas' ).getRecordTypeId(); // TO DO - Remove terminal , sobstitute with constants
                    soql+=  ' where NE__Bundle_Configuration__c =\''+parentid+'\' AND NE__Status__c != \''+OB_UtilityConstants.ASSET_STATUS_DISCONNECTED+'\'  AND NE__ProdId__r.RecordTypeid = \''+rtVas+'\' and NE__Root_Order_Item__c = \'\' '+abiFilter+' order by OB_Sequence__c';  //davide.franzini - 05/07/2019 - F2WAVE2-104 - added filter on Status
               	system.debug(logginglevel.debug,'@@@VASSOQL is '+soql) ;
                }
                //START Andrea Saracini 13/05/2019 Card No Present
                if(APM_SEARCH.equalsignorecase(queryType)){
                    Id rtApm = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(APM_SEARCH).getRecordTypeId(); // TO DO - Remove terminal , sobstitute with constants
                    soql+=  ' where NE__Bundle_Configuration__c =\''+parentid+'\' AND NE__Status__c != \''+OB_UtilityConstants.ASSET_STATUS_DISCONNECTED+'\'  AND NE__ProdId__r.RecordTypeid = \''+rtApm+'\' and NE__Root_Order_Item__c = \'\' '+abiFilter+' order by OB_Sequence__c';  //davide.franzini - 05/07/2019 - F2WAVE2-104 - added filter on Status
               	    system.debug(logginglevel.debug,'@@@APM_SEARCH is '+soql) ;
                }
                if(INT_SEARCH.equalsignorecase(queryType)){
                    Id rtInt = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByDeveloperName().get(INT_SEARCH).getRecordTypeId(); // TO DO - Remove terminal , sobstitute with constants
                    soql+=  ' where NE__Bundle_Configuration__c =\''+parentid+'\' AND NE__Status__c != \''+OB_UtilityConstants.ASSET_STATUS_DISCONNECTED+'\'  AND NE__ProdId__r.RecordTypeid = \''+rtInt+'\' and NE__Root_Order_Item__c = \'\' '+abiFilter+' order by OB_Sequence__c';  //davide.franzini - 05/07/2019 - F2WAVE2-104 - added filter on Status
               	    system.debug(logginglevel.debug,'@@@INT_SEARCH is '+soql) ;
                }
                //STOP Andrea Saracini 13/05/2019 Card No Present
            } 
            System.debug('SOQL INSIDE MAINTENANCE DYNAMIC TABLE IS : ' + soql );
            toreturn =  Database.query(soql);
        }
        return toreturn;
    }


    public class EnablementsWrapper{
        @auraEnabled
        public string name ;
        @auraEnabled 
        public string icon ;
        public EnablementsWrapper (string n, string i){
            this.name = n;
            this.icon = i;
        }
    }


    @auraEnabled
    public static string retriveEnablements (string terminalid, string proposerABI){
        // retrive offerid
        list<EnablementsWrapper> listOfWrapper = new list<EnablementsWrapper> ();
        string toreturn = '' ; 
        try{
            String query = 'select id, OB_ProposerABI__r.OB_ABI__c, NE__Root_Order_Item__c,NE__ProdId__r.name, NE__Status__c, OB_TermId__c, OB_Model__c, OB_ModelDescription__c,  NE__Bundle_Configuration__c  where id = :terminalid'; 
            //09/01/19 francesca.ribezzi - adding abi filter to query:
            String abiFilter = '';
            if(String.isNotBlank(proposerABI)){
                abiFilter = ' AND OB_ProposerABI__r.OB_ABI__c = :proposerABI ';
            }
            query += abiFilter + ' limit 1';
            Asset currentAsset =  Database.query(query);                      
           /* [select id, OB_ProposerABI__r.OB_ABI__c, NE__Root_Order_Item__c,NE__ProdId__r.name, NE__Status__c, OB_TermId__c, OB_Model__c, OB_ModelDescription__c,  NE__Bundle_Configuration__c  
                                  from asset 
                                  where id = : terminalid 
                                  AND OB_ProposerABI__r.OB_ABI__c = :proposerABI 
                                  limit 1
                                 ];*/
            // Pricing
            id pricingRTId = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('Pricing' ).getRecordTypeId(); // To-do : remove hardcoded name
            // retrive enablements  Vas
            id vasRTid = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('Vas' ).getRecordTypeId(); // To-do : remove hardcoded name
            list<Asset> listofEnablement = [select Id,NE__ProdId__r.name, Name,NE__Root_Order_Item__c,NE__Parent_Order_Item__c,RootAssetId,NE__ProdId__r.RecordTypeid ,  OB_ProposerABI__r.OB_ABI__c, OB_enablement__c from asset where NE__Bundle_Configuration__c =: currentAsset.NE__Bundle_Configuration__c   and NE__Root_Order_Item__c = : terminalid and NE__ProdId__r.RecordTypeid != : pricingRTId  order by OB_Sequence__c];
        
            if(listofEnablement != null && !listofEnablement.isEmpty() ){
                for( Asset a :listofEnablement ) {
                    EnablementsWrapper wrap =  (vasRTid ==  a.NE__ProdId__r.RecordTypeid ) ? new enablementsWrapper (a.name,'standard:apex_plugin') : new enablementsWrapper (a.name,'standard:performance');
                    listOfWrapper.add(wrap);
                } 
            }
            toreturn = JSON.serialize(listOfWrapper);
        }
        catch(Exception e){
            system.debug(logginglevel.debug,'Exception in retriveEnablements : '+e.getStackTraceString());
        }

        return toreturn;
    } 
	//francesca.ribezzi
    @auraEnabled
    public static userWrapper getUserLicenseServer(Id userId){
        userWrapper userWrap = new userWrapper();
    	userWrap.isCommunity = false;
		userWrap.user = [
			select id, Profile.UserLicense.Name,  contact.Account.ob_abi__c, ob_cab__c 
			from user 
			WHERE id = :userId
		];
		//if license is partner community, showing ABI column
    	if(userWrap.user.Profile.UserLicense.Name == 'Partner Community') {
    		userWrap.isCommunity = true; 		
    	}
    	return userWrap;
    }
    //francesca.ribezzi
    @auraEnabled
    public static List<NE__AssetItemAttribute__c> getAssetAttributeServer(Id assetId){
    	 List<NE__AssetItemAttribute__c> itemAttributes = 
          [
             select id, name, NE__Value__c  
             from NE__AssetItemAttribute__c 
             where NE__Asset__c = :assetId AND ( name!='Descrizione Release' AND name!='Descrizione Connessione') //giovanni spinelli - 11/10/2019 - remove two row
          ];
        return itemAttributes;
    }
    
    public class userWrapper{
        @auraEnabled
        public User user ;
        @auraEnabled 
        public Boolean isCommunity;
    }
 }