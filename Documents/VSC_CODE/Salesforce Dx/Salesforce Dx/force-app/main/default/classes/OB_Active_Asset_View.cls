public without sharing class OB_Active_Asset_View {
   
    public class WrapperObject {
        public String id;
        public String abi;
        public String codiceSia;
        public String dataInstallazione;
        public String dataDinstallazione;
        public String termId;
        public String clientId;
        public String codiceStab;
        public String codiceConv;
        public String gtPos;
        public String stato;
        public String prodName;
        public String orderId;
        public String bundleId;
        public String servicePointId;
        public String prodRecordType;
        public String codiceSocieta;
        public String codicePv;
        public String processor;
        public String color;
        public String orderName;
        public String rootOrderItem;
        public String accountFC;
        // START--simone.misani@accenture.com RI-34 add wrapper fields. 03/05/2019
        public String baseUrl;
        public String orderNamePos;
        
        public String child;
        public String sortnumber;
        public String mcc;
        public String businessModel;
        public String terminalProprietaValue;
        // END--simone.misani@accenture.com RI-34 add wrapper fields. 03/05/2019
        public WrapperObject(){
            this.id ='';
            this.abi ='';
            this.codiceSia ='';
            this.dataInstallazione ='';
            this.dataDinstallazione ='';
            this.termId ='';
            this.clientId ='';
            this.codiceStab ='';
            this.codiceConv ='';
            this.gtPos ='';
            this.stato ='';
            this.prodName = '';
            this.orderId='';
            this.bundleId='';
            this.servicePointId='';
            this.prodRecordType='';
            this.codiceSocieta='';
            this.codicePv='';
            this.processor='';
            this.color='';
            this.orderName = '';
            this.rootOrderItem = '';
            this.accountFC = '';
            // START--simone.misani@accenture.com RI-34 add wrapper fields. 03/05/2019
            this.baseUrl ='';
            this.orderNamePos='';
            this.child= '';
            this.sortnumber='';   
            this.mcc='';
            this.businessModel='';    
            this.terminalProprietaValue='';  
             // END--simone.misani@accenture.com RI-34 add wrapper fields.   03/05/2019
        }
    }

    public class WrapperEnablements{
        public String enablementName;
        public String id;
        public Boolean isEnabled;
        public String flag;// START--simone.misani@accenture.com RI-34 add wrapper fields. 03/05/2019
        public String prodRecordType;
        public String dataAcquiring;// START--simone.misani@accenture.com RI-34 add wrapper fields. 03/05/2019
        public String dataVas;// START--simone.misani@accenture.com RI-34 add wrapper fields. 03/05/2019
        public WrapperEnablements(){
            this.id='';
            this.enablementName='';
            this.isEnabled=false;
            this.prodRecordType='';
            this.flag='';// START--simone.misani@accenture.com RI-34 add wrapper fields. 03/05/2019
            this.dataAcquiring='';// START--simone.misani@accenture.com RI-34 add wrapper fields. 03/05/2019
            this.dataVas='';// START--simone.misani@accenture.com RI-34 add wrapper fields. 03/05/2019
        }
         
    }
    public class WrapperAttributes{
        // start antonio.vatrano 16/04/2019 Bugfix RI-5 add get and set
        public String Value {get;set;}  
        public String Name {get;set;}
        // end antonio.vatrano 16/04/2019 Bugfix RI-5 
        public WrapperAttributes(){
            this.Name='';
            this.Value='';
        }
    }
    public class WrapperAssetView {
        public Map<String,String> bundleIdMap;
        public List<WrapperObject> wpList;
        public List<WrapperObject> pagoList ;
        public Map<String,String> mapItemAssetId;
        public List<WrapperObject> acquiringList ;
         public List<WrapperObject> acquiringListVM ;// simone.misani@accenture.com RI-34 add wrapper List. 03/05/2019
        public Map<String,List<String>> addingFeatureMap;
        public List<WrapperEnablements> enablememntsList;
        public List<WrapperEnablements> enablememntsListVas;// simone.misani@accenture.com RI-34 add wrapper List. 03/05/2019
        public List<WrapperObject> vasList ;
        public List<Asset> enablememntsListAsset;
        public String account;
        public String profileName;
        public Map<String,String> mapAbi;
        public Map<String,String> mapAssetConfig ;
        public Map<String,String> mapAssetBundleConfig ;

        public WrapperAssetView(){
            this.pagoList = new List<WrapperObject>();
            this.acquiringList = new List<WrapperObject>();
            this.acquiringListVM = new List<WrapperObject>();// simone.misani@accenture.com RI-34 add wrapper List. 03/05/2019
            this.addingFeatureMap = new   Map<String,List<String>> ();
            this.wpList = new List<WrapperObject>();
            this.enablememntsList = new List<WrapperEnablements>();
            this.enablememntsListVas = new List<WrapperEnablements>();// simone.misani@accenture.com RI-34 add wrapper List. 03/05/2019
            this.bundleIdMap = new  Map<String,String>();
            this.mapItemAssetId= new Map<String,String>();
            this.vasList = new List<WrapperObject>();
            this.enablememntsListAsset= new List<Asset>();
            this.account='';
            this.mapAbi = new Map<String,String>();
            this.mapAssetConfig = new Map<String,String>();
            this.mapAssetBundleConfig = new Map<String,String>();
            this.profileName = getProfileName();
        }
    }
    @AuraEnabled 
    public static String getActiveAssets(String servicePointId){
        WrapperAssetView wrapper = new WrapperAssetView();
        WrapperEnablements enablementObject = new WrapperEnablements();
        List<NE__OrderItem__c> orderItemList = [SELECT id,
                                        NE__StartDate__c,
                                        NE__Service_Point__c,
                                        OB_TermId__c,
                                        NE__EndDate__c,
                                        OB_ProposerABI__r.OB_ABI__c,
                                        NE__Status__c ,
                                        OB_enablement__c ,
                                        NE__ProdId__r.Name,
                                        OB_GT__c,
                                        OB_Conventioncode__c,
                                        OB_Processor__c,
                                        OB_CustomerCode__c,
                                        OB_ServicePointCode__c,
                                        OB_CompanyCode__c,
                                        OB_ShopCode__c,
                                        NE__OrderId__c,
                                        NE__Bundle__c,
                                        OB_FulfilmentStatus__c,
                                        NE__Root_Order_Item__c,
                                        NE__Bundle_Configuration__c,  // simone.misani@accenture.com RI-34 add  fields on query.          
                                        NE__ProdId__r.RecordType.DeveloperName, // simone.misani@accenture.com RI-34 add  fields on query.
                                        OB_MCC__c, // simone.misani@accenture.com RI-34 add  fields on query.
                                        NE__OrderId__r.OB_Business_Model_Acquiring__c // simone.misani@accenture.com RI-34 add  fields on query.
                                   FROM NE__OrderItem__c 
                                  WHERE NE__Service_Point__c =:servicePointId
                                  AND OB_FulfilmentStatus__c = 'Cancelled'
                                  AND NE__OrderId__r.OB_FulfilmentStatus__c = 'Completed'
                                  AND NE__ProdId__r.RecordType.DeveloperName = 'Terminali'
                                  AND NE__Root_Order_Item__c=null
                                  ORDER BY OB_ProposerABI__r.OB_ABI__c ASC];

        List<Asset> assetList = [SELECT id,
                                        NE__StartDate__c,
                                        NE__Service_Point__c,
                                        OB_TermId__c,
                                        OB_ProposerABI__r.OB_ABI__c,
                                        NE__Status__c ,
                                        NE__EndDate__c,
                                        OB_enablement__c ,
                                        NE__ProdId__r.Name,
                                        OB_GT__c,
                                        OB_Conventioncode__c,
                                        OB_Processor__c,
                                        OB_CustomerCode__c,
                                        OB_ServicePointCode__c,
                                        OB_CompanyCode__c,
                                        OB_ShopCode__c,
                                        NE__Order_Config__c,
                                        NE__Bundle_Configuration__c,
                                        NE__Bundle__c,
                                        NE__Root_Order_Item__c,
                                        NE__ProdId__r.RecordType.DeveloperName,
                                        //START--- simone.misani@accenture.com RI-34 add  fields on query.
                                        NE__Order_Config__r.Name,
                                        OB_MCC__c,
                                        NE__Order_Config__r.NE__Order_Header__r.OB_Business_Model_Acquiring__c,
                                        (SELECT NE__Value__c, Name
                                        FROM NE__AssetItemAttributes__r 
                                        WHERE name = 'Proprietà')
                                        //END--- simone.misani@accenture.com RI-34 add  fields on query.
                                   FROM Asset  
                                  WHERE NE__Service_Point__c =:servicePointId
                                  AND NE__Root_Order_Item__c=null
                                  ORDER BY OB_ProposerABI__r.OB_ABI__c ASC];

        List<NE__service_Point__c> accountList = [SELECT NE__Account__r.NE__Fiscal_code__c FROM NE__service_Point__c WHERE id=:servicePointId ];
        wrapper.account = accountList.get(0).NE__Account__r.NE__Fiscal_code__c;
        Set<String> configIds = new Set<String>();
        Map<String,String> codiceSiaMap = new Map<String,String> ();
        Map<String,String> mapAssetConfig = new Map<String,String> ();
        // Map<String,String> mapAssetBundleConfig = new Map<String,String> ();
        for(NE__OrderItem__c currentOrderItem : orderItemList){
            WrapperObject posObject = new WrapperObject();
            wrapper.mapItemAssetId.put(currentOrderItem.Id,'Order Item');
            wrapper.mapAbi.put(currentOrderItem.Id,currentOrderItem.OB_ProposerABI__r.OB_ABI__c);
            mapAssetConfig.put(currentOrderItem.Id,currentOrderItem.NE__OrderId__c);
            wrapper.bundleIdMap.put(currentOrderItem.Id,currentOrderItem.NE__Bundle__c);
            wrapper.mapAssetBundleConfig.put(currentOrderItem.Id,currentOrderItem.NE__Bundle_Configuration__c);
            if(currentOrderItem.NE__ProdId__r.RecordType.DeveloperName=='Terminali'){
                configIds.add(currentOrderItem.NE__OrderId__c);
                posObject.id =  currentOrderItem.id;
                posObject.abi =  currentOrderItem.OB_ProposerABI__r.OB_ABI__c;
                posObject.termId = currentOrderItem.OB_TermId__c;
                posObject.clientId = currentOrderItem.OB_CustomerCode__c;
                posObject.codiceStab = currentOrderItem.OB_ShopCode__c;
                posObject.codiceConv = currentOrderItem.OB_Conventioncode__c;
                posObject.gtPos = currentOrderItem.OB_GT__c;
                posObject.stato = 'Rifiuto Installazione';
                String startDateString =currentOrderItem.NE__StartDate__c!=null? currentOrderItem.NE__StartDate__c.format('dd/MM/yyyy'):'';//simone.misani@accenture.com 06/05/2019 R1F2-91  modify date format
                String endDate =currentOrderItem.NE__EndDate__c!=null? currentOrderItem.NE__EndDate__c.format('dd/MM/yyyy'):'';//simone.misani@accenture.com 06/05/2019 R1F2-91  modify date format
                posObject.dataInstallazione =startDateString;
                posObject.dataDinstallazione = endDate;
                posObject.prodName = currentOrderItem.NE__ProdId__r.Name;
                posObject.color='red'; // masoud zaribaf 08/05/2019 add color for status 'Rifiuto Installazione'
                system.debug('currentOrderItem'+posObject);
                wrapper.wpList.add(posObject);
            }
        }
        String colorAsset='';
        String statusAsset='';
        for(Asset currentAsset : assetList){
            WrapperObject posObjectAsset = new WrapperObject();
            wrapper.mapItemAssetId.put(currentAsset.Id,'Asset');
            wrapper.mapAbi.put(currentAsset.Id,currentAsset.OB_ProposerABI__r.OB_ABI__c);
            mapAssetConfig.put(currentAsset.Id,currentAsset.NE__Order_Config__c);
            wrapper.bundleIdMap.put(currentAsset.Id,currentAsset.NE__Bundle__c);
            wrapper.mapAssetBundleConfig.put(currentAsset.Id,currentAsset.NE__Bundle_Configuration__c);
            /*Start antonio.vatrano, antonio.vatrano@accenture.com 11/04/2019 add attribute COLOR for status of asset: Active=GREEN, InProgress = YELLOW, Disconnected = RED */
            if(currentAsset.NE__Status__c=='Active'){
                statusAsset='Installato';
                colorAsset='green';
            }else if(currentAsset.NE__Status__c=='Disconnected'){
                statusAsset='Disinstallato';
                colorAsset ='red';
            } else if(currentAsset.NE__Status__c=='in progress'){
                 statusAsset='Installato';
                 colorAsset='yellow';
            }
            /*End antonio.vatrano, antonio.vatrano@accenture.com 11/04/2019 add attribute COLOR for status of asset: Active=GREEN, InProgress = YELLOW, Disconnected = RED */

          
            if(currentAsset.NE__ProdId__r.RecordType.DeveloperName=='Terminali'){
                configIds.add(currentAsset.NE__Order_Config__c);
                posObjectAsset.id =  currentAsset.id;
                posObjectAsset.abi =  currentAsset.OB_ProposerABI__r.OB_ABI__c;
                posObjectAsset.termId = currentAsset.OB_TermId__c;
                posObjectAsset.clientId = currentAsset.OB_CustomerCode__c;
                posObjectAsset.codiceStab = currentAsset.OB_ShopCode__c;
                posObjectAsset.codiceConv = currentAsset.OB_Conventioncode__c;
                posObjectAsset.gtPos = currentAsset.OB_GT__c;
                posObjectAsset.stato = statusAsset ;
                posObjectAsset.orderId = currentAsset.NE__Order_Config__c ;
                posObjectAsset.orderName = currentAsset.NE__Order_Config__r.Name ;
                String startDateString =currentAsset.NE__StartDate__c!=null? currentAsset.NE__StartDate__c.format('dd/MM/yyyy'):'';//simone.misani@accenture.com 06/05/2019 R1F2-91  modify date format
                String endDate =currentAsset.NE__EndDate__c!=null? currentAsset.NE__EndDate__c.format('dd/MM/yyyy'):'';//simone.misani@accenture.com 06/05/2019 R1F2-91  modify date format
                posObjectAsset.dataDinstallazione = endDate;
                posObjectAsset.dataInstallazione =startDateString;
                posObjectAsset.prodName = currentAsset.NE__ProdId__r.Name;
                //start--- simone.misani@accenture.com  RI-34 fill object Wrapper for pos 03/05/2019
                posObjectAsset.color = colorAsset; 
                posObjectAsset.terminalProprietaValue = currentAsset.NE__AssetItemAttributes__r.get(0).NE__Value__c;
                if(colorAsset == 'yellow'){
                String url=getBaseURl();
                posObjectAsset.baseUrl = url+'/'+currentAsset.NE__Order_Config__c;//simone.misani@accenture.com 06/05/2019 R1F2-91  modify  base url.
                posObjectAsset.orderNamePos= currentAsset.NE__Order_Config__r.Name;
                }

                system.debug('currentAsset'+posObjectAsset);
                wrapper.wpList.add(posObjectAsset);
            }
            //END--- simone.misani@accenture.com RI-34 fill object Wrapper for pos 03/05/2019
                     
            if(currentAsset.NE__ProdId__r.RecordType.DeveloperName=='Pagobancomat'){
                statusAsset = currentAsset.NE__Status__c=='Active' || currentAsset.NE__Status__c=='In progress' ? 'Attivato':'Disattivato';
                WrapperObject pagobancomatObject = new WrapperObject();
                pagobancomatObject.id = currentAsset.id;
                pagobancomatObject.abi= currentAsset.OB_ProposerABI__r.OB_ABI__c;
                pagobancomatObject.stato= statusAsset;
                wrapper.pagoList.add(pagobancomatObject);
                system.debug('pagobancomatObject'+pagobancomatObject);
            }
              
            if((currentAsset.NE__ProdId__r.RecordType.DeveloperName=='Acquiring' )){
                if(currentAsset.NE__Root_Order_Item__c == null){
                    WrapperObject acquiringObject = new WrapperObject();
                    //start--- simone.misani@accenture.com RI-34 fill object Wrapper for Acquiring 03/05/2019
                    if(currentAsset.NE__ProdId__r.Name =='Visa/Mastercard'){
                        acquiringObject.sortnumber = '1';
                    }else{
                        acquiringObject.sortnumber= '2';
                    }
                    if( currentAsset.NE__ProdId__r.Name !='Visa/Mastercard'){
                    //End--- simone.misani@accenture.com RI-34 fill object Wrapper for Acquiring 03/05/2019
                        acquiringObject.id = currentAsset.id;
                        acquiringObject.abi= currentAsset.OB_ProposerABI__r.OB_ABI__c;
                        acquiringObject.stato= statusAsset;
                        acquiringObject.color= colorAsset;
                        acquiringObject.codiceSocieta= currentAsset.OB_CompanyCode__c;
                        String startDateString =currentAsset.NE__StartDate__c!=null? currentAsset.NE__StartDate__c.format('dd/MM/yyyy'):'';//simone.misani@accenture.com 06/05/2019 R1F2-91  modify date format
                        String endDate =currentAsset.NE__EndDate__c!=null? currentAsset.NE__EndDate__c.format('dd/MM/yyyy'):'';//simone.misani@accenture.com 06/05/2019 R1F2-91  modify date format
                        acquiringObject.dataDinstallazione = endDate;
                        acquiringObject.dataInstallazione =startDateString;
                        acquiringObject.codicePv= currentAsset.OB_ServicePointCode__c;
                        //start--- simone.misani@accenture.com RI-34 fill object Wrapper for Acquiring 03/05/2019
                        acquiringObject.processor= currentAsset.OB_Processor__c;                    
                        acquiringObject.prodName = currentAsset.NE__ProdId__r.Name;    
                        acquiringObject.mcc = currentAsset.OB_MCC__c;
                        acquiringObject.businessModel = currentAsset.NE__Order_Config__r.NE__Order_Header__r.OB_Business_Model_Acquiring__c;
                     //End--- simone.misani@accenture.com RI-34 fill object Wrapper for Acquiring 03/05/2019
                    wrapper.acquiringList.add(acquiringObject);
                    }else{
                        //start--- simone.misani@accenture.com RI-34 fill object Wrapper for Acquiring 03/05/2019
                        acquiringObject.id = currentAsset.id;
                        acquiringObject.abi= currentAsset.OB_ProposerABI__r.OB_ABI__c;
                        acquiringObject.stato= statusAsset;
                        acquiringObject.color= colorAsset;
                        acquiringObject.codiceSocieta= currentAsset.OB_CompanyCode__c;
                        String startDateString =currentAsset.NE__StartDate__c!=null? currentAsset.NE__StartDate__c.format('dd/MM/yyyy'):'';//simone.misani@accenture.com 06/05/2019 R1F2-91  modify date format
                        String endDate =currentAsset.NE__EndDate__c!=null? currentAsset.NE__EndDate__c.format('dd/MM/yyyy'):'';//simone.misani@accenture.com 06/05/2019 R1F2-91  modify date format
                        acquiringObject.dataDinstallazione = endDate;
                        acquiringObject.dataInstallazione =startDateString;
                        acquiringObject.codicePv= currentAsset.OB_ServicePointCode__c;
                        acquiringObject.processor= currentAsset.OB_Processor__c;                    
                        acquiringObject.prodName = currentAsset.NE__ProdId__r.Name;    
                        acquiringObject.mcc = currentAsset.OB_MCC__c;
                        acquiringObject.businessModel = currentAsset.NE__Order_Config__r.NE__Order_Header__r.OB_Business_Model_Acquiring__c;
                        wrapper.acquiringListVM.add(acquiringObject);
                    //End--- simone.misani@accenture.com RI-34 fill object Wrapper for Acquiring 03/05/2019
                    }
                }
            }
          
            
            if((currentAsset.NE__ProdId__r.RecordType.DeveloperName=='VAS' )){
                if(currentAsset.NE__Root_Order_Item__c == null){
                    WrapperObject vasObject = new WrapperObject();
                    vasObject.id = currentAsset.id;
                    vasObject.abi= currentAsset.OB_ProposerABI__r.OB_ABI__c;
                    vasObject.stato= statusAsset;
                    vasObject.prodName = currentAsset.NE__ProdId__r.Name;
                    //start--- simone.misani@accenture.com RI-34 fill object Wrapper for Vas 03/05/2019
                    if(currentAsset.NE__Status__c=='Active'){
                        statusAsset='Installato';
                        vasObject.color='green';
                    }else if(currentAsset.NE__Status__c=='Disconnected'){
                        statusAsset='Disinstallato';
                         vasObject.color ='red';
                    } else if(currentAsset.NE__Status__c=='in progress'){
                        statusAsset='Installato';
                        vasObject.color='yellow';
                    }
                    wrapper.vasList.add(vasObject);
                    //end--- simone.misani@accenture.com RI-34 fill object Wrapper for Vas 03/05/2019
                }
            }
            
        }
        wrapper.mapAssetConfig = mapAssetConfig;
       
        system.debug('wrapper '+wrapper);
         
     
        List<NE__Order_Item_Attribute__c> orderItemAttributeList = [SELECT NE__Order_Item__c,NE__Order_Item__r.NE__OrderId__c,  
                                                                           NE__Value__c,
                                                                           Name
                                                                      FROM NE__Order_Item_Attribute__c 
                                                                     WHERE NE__Order_Item__r.NE__OrderId__c in :configIds ];

        /* ANDREA MORITTU START 2019.05.28 - Fixing R1F2 217 */
        List<NE__AssetItemAttribute__c> listAssetAttributes = [ SELECT  NE__Value__c,
                                                    Name, 
                                                    NE__Asset__r.NE__Order_Config__c 
                                            FROM NE__AssetItemAttribute__c  
                                            WHERE NE__Asset__r.NE__Order_Config__c in :configIds ];
        /* ANDREA MORITTU END 2019.05.28 - Fixing R1F2 217 */

        for(NE__Order_Item_Attribute__c currentAttribute : orderItemAttributeList){
            if(configIds.contains(currentAttribute.NE__Order_Item__r.NE__OrderId__c) &&  currentAttribute.Name=='Codice Sia'){
                codiceSiaMap.put(currentAttribute.NE__Order_Item__r.NE__OrderId__c,currentAttribute.NE__Value__c);
            }
        }
        /* ANDREA MORITTU START 2019.05.28 - Fixing R1F2 217 */
        for(NE__AssetItemAttribute__c currentAssetAttribute : listAssetAttributes){
            if(configIds.contains(currentAssetAttribute.NE__Asset__r.NE__Order_Config__c) &&    currentAssetAttribute.Name=='Codice Sia'){
                codiceSiaMap.put(currentAssetAttribute.NE__Asset__r.NE__Order_Config__c,        currentAssetAttribute.NE__Value__c);
            }
        }
        /* ANDREA MORITTU END 2019.05.28 - Fixing R1F2 217 */
        for(WrapperObject wpObject : wrapper.wpList){
            wpObject.codiceSia = codiceSiaMap.get(mapAssetConfig.get( wpObject.id));
        }
        system.debug('wrapper '+wrapper);
        return JSON.serialize(wrapper);

    }
    /* 
    Simone misani
    simone.misani@accenture.com
    03/05/2019
    class for create eneblements input:assetId and retrun a wrapper to eneblements
    */
    @AuraEnabled
    public static String getEnablements(String assetId){
         
        
         List<WrapperEnablements> returnListAsset= new List<WrapperEnablements>();
         List<WrapperEnablements> returnListAssetVas= new List<WrapperEnablements>();
         List<WrapperEnablements> returnListItem= new List<WrapperEnablements>();
         WrapperAssetView wrapper = new WrapperAssetView();
         system.debug('assetId '+assetId);
        List<Asset> enablementsListAsset = [SELECT id,   
                                        OB_enablement__c ,
                                        NE__ProdId__r.Name,
                                        NE__Root_Order_Item__c,
                                        NE__StartDate__c,
                                        NE__ProdId__r.RecordType.DeveloperName
                                        FROM Asset 
                                        WHERE NE__Root_Order_Item__c =:assetId 
                                        AND OB_enablement__c='Y'
                                        AND (NE__ProdId__r.RecordType.DeveloperName='Acquiring' 
                                        OR  NE__ProdId__r.RecordType.DeveloperName='Vas' )
                                        ORDER BY NE__ProdId__r.Name desc];
         List<NE__OrderItem__c> enablementsListOrderItem = [SELECT id,   
                                        OB_enablement__c ,
                                        NE__ProdId__r.Name,
                                        NE__Root_Order_Item__c,
                                        NE__StartDate__c,
                                        NE__ProdId__r.RecordType.DeveloperName
                                        FROM NE__OrderItem__c 
                                        WHERE NE__Root_Order_Item__c =:assetId 
                                        AND OB_enablement__c='Y'
                                        AND (NE__ProdId__r.RecordType.DeveloperName='Acquiring' 
                                        OR  NE__ProdId__r.RecordType.DeveloperName='Vas' )
                            ];
        system.debug('enablementsListAsset'+enablementsListAsset);
        
        for(Asset eList : enablementsListAsset){
            if(eList.NE__ProdId__r.RecordType.DeveloperName=='Acquiring'){           
                WrapperEnablements enablementObjectAsset = new WrapperEnablements();
                enablementObjectAsset.id = eList.NE__Root_Order_Item__c;
                enablementObjectAsset.enablementName = eList.NE__ProdId__r.Name;
                enablementObjectAsset.isEnabled = eList.OB_enablement__c == 'Y' ? true : false;
                enablementObjectAsset.flag = eList.OB_enablement__c == 'Y' ? '✔' : 'false'; 
                String startDateString =eList.NE__StartDate__c!=null? eList.NE__StartDate__c.format('dd/MM/yyyy'):'';   //simone.misani@accenture.com 06/05/2019 R1F2-91  modify date format   
                enablementObjectAsset.dataAcquiring =startDateString;                
                returnListAsset.add(enablementObjectAsset);
                system.debug('enablementObjectAsset'+JSON.serialize(returnListAsset));
            }else{
                WrapperEnablements enablementObjectAssetVas = new WrapperEnablements();
                enablementObjectAssetVas.id = eList.NE__Root_Order_Item__c;
                enablementObjectAssetVas.enablementName = eList.NE__ProdId__r.Name;
                enablementObjectAssetVas.isEnabled = eList.OB_enablement__c == 'Y' ? true : false;
                enablementObjectAssetVas.flag = eList.OB_enablement__c == 'Y' ? '✔' : 'false'; 
                String startDateString =eList.NE__StartDate__c!=null? eList.NE__StartDate__c.format('dd/MM/yyyy'):''; //simone.misani@accenture.com 06/05/2019 R1F2-91  modify date format                 
                enablementObjectAssetVas.dataVas =startDateString;
                returnListAssetVas.add(enablementObjectAssetVas);
                system.debug('enablementObjectAsset'+JSON.serialize(returnListAssetVas));

            }
        }
        for(NE__OrderItem__c eList : enablementsListOrderItem){
             WrapperEnablements enablementObject = new WrapperEnablements();
            enablementObject.id = eList.NE__Root_Order_Item__c;
            enablementObject.enablementName = eList.NE__ProdId__r.Name;
            enablementObject.isEnabled = eList.OB_enablement__c == 'Y' ? true : false;
            enablementObject.flag = eList.OB_enablement__c == 'Y' ? '✔' : 'false';
            returnListItem.add(enablementObject);
        }
        if(enablementsListAsset.size()>0){
            wrapper.enablememntsList.addAll(returnListAsset);
        }
        if(enablementsListOrderItem.size()>0){
              wrapper.enablememntsList.addAll(returnListItem);
        }
        wrapper.enablememntsListVas.addAll(returnListAssetVas);
        return JSON.serialize(wrapper);
    }

    

    // start antonio.vatrano 16/04/2019 Bugfix RI-5 create a wrapper obj for datatable and return it like a string
    @AuraEnabled
    public static String getAttributes(String orderItemId){
        system.debug('orderItemId '+orderItemId);
        List<WrapperAttributes> listWrapper = new List<WrapperAttributes>();
        // START shaghayegh.tofighian Bugfix RI-30 , replacement of the list with set.
        Set<WrapperAttributes> setWrapper = new Set<WrapperAttributes>();
        List<NE__AssetItemAttribute__c> assetAttributeList = [SELECT NE__Value__c,
                                                                        Name
                                                                        FROM NE__AssetItemAttribute__c 
                                                                        WHERE NE__Asset__c=:orderItemId ]; 
        List<Asset> listAsset = [SELECT NE__StartDate__c, NE__EndDate__c FROM Asset where Id =:orderItemId];
        for(NE__AssetItemAttribute__c assetAttr : assetAttributeList){
            WrapperAttributes wrapObj = new WrapperAttributes();
            wrapObj.Name = assetAttr.Name;
            wrapObj.Value = assetAttr.NE__Value__c;
            setWrapper.add(wrapObj);
        }
        listWrapper.addAll(setWrapper);
        //END shaghayegh.tofighian Bugfix RI-30 
        System.debug('$$ : '+listWrapper);
        for(Asset ast : listAsset ){
            WrapperAttributes wrapObj = new WrapperAttributes();
            wrapObj.Name = 'Data Installazione';
            wrapObj.Value = ast.NE__StartDate__c !=null ? ast.NE__StartDate__c.format('dd-MMM-yyyy') : '';
            listWrapper.add(wrapObj);
            WrapperAttributes wrapObj1 = new WrapperAttributes();
            wrapObj1.Name = 'Data Disinstallazione';
            wrapObj1.Value = ast.NE__EndDate__c !=null ? ast.NE__EndDate__c.format('dd-MMM-yyyy') : '';
            listWrapper.add(wrapObj1);
        }
        WrapperAttributes wrapObj = new WrapperAttributes();
        wrapObj.Name = 'Causale rifiuto';
        wrapObj.Value = '';
        listWrapper.add(wrapObj);
        return JSON.serialize(listWrapper);
    }
    @AuraEnabled
    public static String getAttributesItem(String orderItemId){
        system.debug('orderItemId '+orderItemId);
         List<WrapperAttributes> listWrapper = new List<WrapperAttributes>();
        List<NE__Order_Item_Attribute__c> orderItemAttributeList = [SELECT NE__Value__c,
                                                                           Name,
                                                                           NE__Order_Item__r.NE__OrderId__r.NE__Order_Header__r.OB_Rejection_Reason__c
                                                                           FROM NE__Order_Item_Attribute__c 
                                                                           WHERE NE__Order_Item__c=:orderItemId ];
        List<NE__OrderItem__c> listOrderItem = [SELECT NE__StartDate__c, NE__EndDate__c FROM NE__OrderItem__c where Id =:orderItemId];
        for(NE__Order_Item_Attribute__c ordAttr : orderItemAttributeList){
            WrapperAttributes wrapObj = new WrapperAttributes();
            wrapObj.Name = ordAttr.Name;
            wrapObj.Value = ordAttr.NE__Value__c;
            listWrapper.add(wrapObj);
        }
        for(NE__OrderItem__c ordIte : listOrderItem ){
            WrapperAttributes wrapObj = new WrapperAttributes();
            wrapObj.Name = 'Data Installazione';
            wrapObj.Value = ordIte.NE__StartDate__c !=null ? ordIte.NE__StartDate__c.format('dd-MMM-yyyy') : '';
            listWrapper.add(wrapObj);
            WrapperAttributes wrapObj1 = new WrapperAttributes();
            wrapObj1.Name = 'Data Disinstallazione';
            wrapObj1.Value = ordIte.NE__EndDate__c !=null ? ordIte.NE__EndDate__c.format('dd-MMM-yyyy') : '';
            listWrapper.add(wrapObj1);
        }
        WrapperAttributes wrapObj = new WrapperAttributes();
        wrapObj.Name = 'Causale rifiuto';
        NE__Order_Item_Attribute__c oiAttr = orderItemAttributeList.get(0);
        wrapObj.Value = oiAttr.NE__Order_Item__r.NE__OrderId__r.NE__Order_Header__r.OB_Rejection_Reason__c ;
        listWrapper.add(wrapObj);
        return JSON.serialize(listWrapper);
      
    }
    // end antonio.vatrano 16/04/2019 Bugfix RI-5 create a wrapper obj for datatable and return it like a string

    @AuraEnabled
    public static String getOfferId (String servicePointId, String configId){
        String valueToReturn='';
        List<Asset> assetList = [SELECT id,NE__Bundle_Configuration__c FROM Asset WHERE NE__Service_Point__c=:servicePointId and NE__Order_Config__c =:configId];
        for(Asset current : assetList){
            system.debug(current.NE__Bundle_Configuration__c);
            if(current.NE__Bundle_Configuration__c!=null ){
                valueToReturn = String.valueOf(current.NE__Bundle_Configuration__c);
                break;
            }
        }
        return valueToReturn;
    }
    @AuraEnabled
    public static String getTerminalFromAsset(String assetId){
        WrapperAssetView wrapper = new WrapperAssetView();
        WrapperObject posObject = new WrapperObject();
        WrapperEnablements enablementObject = new WrapperEnablements();
        List<Asset> assetListQuery = [SELECT id,
                                        NE__StartDate__c,
                                        NE__Service_Point__c,
                                        OB_TermId__c,
                                        OB_ProposerABI__r.OB_ABI__c,
                                        NE__Status__c ,
                                        OB_enablement__c ,
                                        NE__ProdId__r.Name,
                                        OB_GT__c,
                                        OB_Conventioncode__c,
                                        OB_Processor__c,
                                        OB_CustomerCode__c,
                                        OB_ServicePointCode__c,
                                        OB_CompanyCode__c,
                                        OB_ShopCode__c,
                                        NE__Order_Config__c, 
                                        NE__Bundle__c,
                                        NE__Bundle_Configuration__c ,
                                        NE__Root_Order_Item__c,
                                        NE__ProdId__r.RecordType.DeveloperName,
                                        NE__Root_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName,
                                        Account.NE__Fiscal_code__c
                                   FROM Asset 
                                  WHERE Id =:assetId];
        for(Asset a : assetListQuery)
        {   
            system.debug('asset'+JSON.serialize(a));
            posObject.id =  a.id;
            posObject.abi =  a.OB_ProposerABI__r.OB_ABI__c;
            posObject.termId = a.OB_TermId__c;
            posObject.clientId = a.OB_CustomerCode__c;
            posObject.codiceStab = a.OB_ShopCode__c;
            posObject.codiceConv = a.OB_Conventioncode__c;
            posObject.gtPos = a.OB_GT__c;
            posObject.stato = a.NE__Status__c;
            String startDateString = a.NE__StartDate__c==null ? '' : a.NE__StartDate__c.format('dd-MMM-yyyy');
            posObject.dataInstallazione =startDateString;
            posObject.prodName = a.NE__ProdId__r.Name;
            system.debug('posObject'+JSON.serialize(posObject));
            posObject.orderId = a.NE__Order_Config__c;
            posObject.bundleId = a.NE__Bundle_Configuration__c;
            posObject.servicePointId=a.NE__Service_Point__c;
            posObject.prodRecordType=a.NE__ProdId__r.RecordType.DeveloperName;
            posObject.accountFC =  a.Account.NE__Fiscal_code__c;
            wrapper.wpList.add(posObject);
        }
         List<Asset> enablementsList = [SELECT id,   
                                        OB_enablement__c ,
                                        NE__ProdId__r.Name,
                                        NE__Root_Order_Item__c,
                                        NE__Root_Order_Item__r.NE__ProdId__r.Name
                                       
                                   FROM Asset 
                                  WHERE NE__Root_Order_Item__c =:assetId 
                                  AND OB_enablement__c='Y'];
        
        for(Asset a : enablementsList){
            string nameEnabRoot = (a.NE__ProdId__r.Name == null) ? a.NE__Root_Order_Item__r.NE__ProdId__r.Name : '';
            string nameEnab =(nameEnabRoot == '') ? a.NE__ProdId__r.Name : nameEnabRoot;
            enablementObject.id = a.NE__Root_Order_Item__c;
            enablementObject.enablementName = nameEnab;
            enablementObject.isEnabled =  true ;
            wrapper.enablememntsList.add(enablementObject);
        }
        system.debug('wrapper'+JSON.serialize(wrapper));
        return JSON.serialize(wrapper);
    }

     @AuraEnabled
    public static List<NE__AssetItemAttribute__c> getAttributesAsset(String assetId){
        system.debug('assetId '+assetId);
        List<NE__AssetItemAttribute__c> assetItemAttributeList = [SELECT id,
                                                                           NE__Asset__c, 
                                                                           NE__Value__c,
                                                                           NE__Asset__r.NE__Order_Config__c,
                                                                           Name
                                                                    FROM NE__AssetItemAttribute__c 
                                                                    WHERE NE__Asset__c=:assetId ];

        system.debug('assetItemAttributeList'+assetItemAttributeList);
        return assetItemAttributeList;
    }

    @AuraEnabled
    public static String getAcquiringFromAsset(String assetId){
        WrapperAssetView wrapper = new WrapperAssetView();
        WrapperObject posObject = new WrapperObject();
        WrapperEnablements enablementObject = new WrapperEnablements();
        

        List<Asset> enablementsList = [SELECT id, 
                                        RootAssetId,//simone misani RI-55 13/05/2019
                                        OB_enablement__c ,
                                        NE__ProdId__r.Name,
                                        NE__Root_Order_Item__c,
                                        NE__ProdId__r.RecordType.DeveloperName,
                                        NE__Root_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName,
                                        NE__Root_Order_Item__r.NE__ProdId__r.Name
                                   FROM Asset 
                                  WHERE id =:assetId];
        System.debug('enablementsList: '+enablementsList);
        List<Asset> assetList = [SELECT id,
                                        NE__StartDate__c,
                                        NE__Service_Point__c,
                                        OB_TermId__c,
                                        OB_ProposerABI__r.OB_ABI__c,
                                        NE__Status__c ,
                                        OB_enablement__c ,
                                        NE__ProdId__r.Name,
                                        OB_GT__c,
                                        Account.NE__Fiscal_code__c,
                                        OB_Conventioncode__c,
                                        OB_Processor__c,
                                        OB_CustomerCode__c,
                                        OB_ServicePointCode__c,
                                        OB_CompanyCode__c,
                                        OB_ShopCode__c,
                                        NE__Order_Config__c, 
                                        NE__Bundle__c,
                                        NE__Bundle_Configuration__c ,
                                        NE__Root_Order_Item__c,
                                        NE__ProdId__r.RecordType.DeveloperName,
                                        NE__Root_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName,
                                        NE__Root_Order_Item__r.NE__ProdId__r.Name
                                   FROM Asset 
                                  WHERE (Id =:enablementsList.get(0).NE__Root_Order_Item__c OR id =: enablementsList.get(0).RootAssetId)];//simone misani RI-55 13/05/2019
        system.debug('assetList::: '+assetList);
        system.debug('assetList::: '+enablementsList.get(0));
        for(Asset a : assetList)
        {   
            system.debug('asset'+JSON.serialize(a));
            string nameEnabRoot = (a.NE__ProdId__r.Name == null) ? a.NE__Root_Order_Item__r.NE__ProdId__r.Name : '';
            string nameEnab =(nameEnabRoot == '') ? a.NE__ProdId__r.Name : nameEnabRoot;
            string devnameEnabRoot = (a.NE__ProdId__r.RecordType.DeveloperName == null) ? a.NE__Root_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName : '';
            string devnameEnab =(nameEnabRoot == '') ? a.NE__ProdId__r.RecordType.DeveloperName : devnameEnabRoot;
            posObject.id =  a.id;
            posObject.abi =  a.OB_ProposerABI__r.OB_ABI__c;
            posObject.termId = a.OB_TermId__c;
            posObject.clientId = a.OB_CustomerCode__c;
            posObject.codiceStab = a.OB_ShopCode__c;
            posObject.codiceConv = a.OB_Conventioncode__c;
            posObject.gtPos = a.OB_GT__c;
            posObject.stato = a.NE__Status__c;
            String startDateString = a.NE__StartDate__c==null ? '' : a.NE__StartDate__c.format('dd-MMM-yyyy');
            posObject.dataInstallazione =startDateString;
            posObject.prodName = nameEnab;
            system.debug('posObject'+JSON.serialize(posObject));
            posObject.orderId = a.NE__Order_Config__c;
            posObject.bundleId = a.NE__Bundle_Configuration__c;
            posObject.servicePointId=a.NE__Service_Point__c;
            posObject.prodRecordType=devnameEnab;
            posObject.rootOrderItem =  a.NE__Root_Order_Item__c;
            posObject.accountFC =  a.Account.NE__Fiscal_code__c;

            wrapper.wpList.add(posObject);
            
        }
        for(Asset a : enablementsList){
            string nameEnabRoot = (a.NE__ProdId__r.Name == null) ? a.NE__Root_Order_Item__r.NE__ProdId__r.Name : '';
            string nameEnab =(nameEnabRoot == '') ? a.NE__ProdId__r.Name : nameEnabRoot;
            string devnameEnabRoot = (a.NE__ProdId__r.RecordType.DeveloperName == null) ? a.NE__Root_Order_Item__r.NE__ProdId__r.RecordType.DeveloperName : '';
            string devnameEnab =(nameEnabRoot == '') ? a.NE__ProdId__r.RecordType.DeveloperName : devnameEnabRoot;
            enablementObject.id = a.NE__Root_Order_Item__c;
            enablementObject.enablementName = nameEnab;
            enablementObject.isEnabled =  true ;
            enablementObject.prodRecordType=devnameEnab;
            wrapper.enablememntsList.add(enablementObject);
        }
        system.debug('wrapper'+JSON.serialize(wrapper));
        return JSON.serialize(wrapper);

    }
    @AuraEnabled
    public static String search (string jsonWrap ){
        String stringToReturn = OB_MaintenanceSearch_Controller.search(jsonWrap);
        system.debug('stringToReturn '+stringToReturn);
        return stringToReturn;
    }
    /*
    antonio.vatrano, antonio.vatrano@accenture.com
	11/04/2019
	method return a base url of current environment
    */
    @AuraEnabled
    public static String getBaseURl (){
        String stringToReturn = OB_ContinuationController.getVFBaseURL();
        return stringToReturn;
    }
    /*
    antonio.vatrano, antonio.vatrano@accenture.com
	11/04/2019
	method return a name's profile of current User 
    */
    @AuraEnabled
    public static String getProfileName (){
        list<User> listUs=[SELECT id, profile.name FROM User WHERE id=:UserInfo.getUserId()];
        return listUs.get(0).profile.name;
    }


}