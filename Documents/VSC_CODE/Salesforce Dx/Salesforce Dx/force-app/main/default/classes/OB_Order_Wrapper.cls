public class OB_Order_Wrapper {
   
    Static final String PRICING_RT                      = 'Pricing';
    Static final String TERMINALI_RT                    = 'Terminali';
    Static final String GATEWAY_RT                      = 'Gateway_Virtuale';
    Static final String MOTO_RT                         = 'Moto';
    Static final String ECOMMERCE_RT                    = 'eCommerce';
    Static final String ACQUIRING_RT                    = 'Acquiring';
    Static final String BANCOMAT_RT                     = 'Pagobancomat';
    Static final String VAS_RT                          = 'Vas';
    Static final String PCI_RT                          = 'PCI';
    Static final String INTEGRAZIONE_RT                 = 'Integrazione';
    Static final String VISA_CODE                       = 'VISAMASTERCARD';
    //LUBRANO 2019-04-15 -- new constant for APM RecordType
    Static final String APM                             = 'APM';
    Static final String TERMINALE_ATTRIBUTE_TERMID      = 'Terminal Id';
    Static final String TERMINALE_ATTRIBUTE_OWNERSHIP   = 'Proprietà';
    Static final String TERMINALE_ATTRIBUTE_MODEL       = 'Modello';
    Static final String TERMINALE_ATTRIBUTE_MODALITY    = 'Tipo';
    Static final String TERMINALE_ATTRIBUTE_CONNTYPE    = 'ModalitàCollegamento';
    Static final String TERMINALE_ATTRIBUTE_RELEASE     = 'Release';
    Static final String CANCELLED                       = 'Cancelled';
    Static final String SETUP                           = 'Setup';

    Map<Id,Map<String,List<Id>>>    configurationMap    = new Map<Id,Map<String,List<Id>>>();
    Map<Id,NE__OrderItem__c>        itemMap             = new Map<Id,NE__OrderItem__c>() ;
    Map<Id,List<Id>>                childItemMap        = new Map<Id,List<Id>>();
    
    public OB_Order_Wrapper(Id headerId){
        for (NE__OrderItem__c item : getOrderItems(headerId)){
            
            itemMap.put(item.Id,item);
            
            Map<String,List<Id>> currentConfig =   new Map<String,List<Id>>();
            if(configurationMap.containsKey(item.NE__OrderId__r.Id)){
                currentConfig = configurationMap.get(item.NE__OrderId__r.Id);
                
            }
            
            List<Id> currentType = new List<Id>();
            if(item.NE__ProdId__r.Recordtype.DeveloperName != null && item.NE__ProdId__r.Recordtype.DeveloperName != '' && item.NE__Parent_Order_Item__c == null){
                if(currentConfig.containsKey(item.NE__ProdId__r.Recordtype.DeveloperName)) {
                    currentType = currentConfig.get(item.NE__ProdId__r.Recordtype.DeveloperName); 
                    
                }
                currentType.add(item.Id);
                currentConfig.put(item.NE__ProdId__r.Recordtype.DeveloperName,currentType);
                configurationMap.put(item.NE__OrderId__r.Id,currentConfig);
            }
            if(item.NE__Parent_Order_Item__c != null){
            List<Id> currentChild = new List<Id>();
            
                if(childItemMap.containsKey(item.NE__Parent_Order_Item__c)) {
                    currentChild = childItemMap.get(item.NE__Parent_Order_Item__c);
                }
                currentChild.add(item.Id);
                childItemMap.put(item.NE__Parent_Order_Item__c,currentChild);
            }
        }
    }
    
    public void printConfigurations(){
        system.debug(JSON.serialize(configurationMap));
    }
    
    public class Terminale{
        public String replacement;
        public NE__OrderItem__c root;
        public List<NE__OrderItem__c> pricing = new List<NE__OrderItem__c>();
        public List<NE__OrderItem__c> enablements = new List<NE__OrderItem__c>();
        
        Terminale(Id termId,OB_Order_Wrapper orderWrapper){
            root = orderWrapper.itemMap.get(termId);
            replacement = orderWrapper.itemMap.get(termId).NE__OrderId__r.NE__Order_Header__r.OB_Sub_Process__c;
            if(orderWrapper.childItemMap.containsKey(termId)){
                for(Id childId :orderWrapper.childItemMap.get(termId)){
                    NE__OrderItem__c childItem = orderWrapper.itemMap.get(childId);
                    if(childItem.NE__ProdId__r.Recordtype.DeveloperName == PRICING_RT){
                        pricing.add(childItem);
                    }else{
                        if(!(childItem.NE__Action__c == 'Add' && childItem.OB_enablement__c == 'N')){
                            enablements.add(childItem);
                        } 
                    }
                } 
            }

        }
    }

    public List<Terminale> getTerminali(Id configId){
        
        List<Terminale> tmptermList = new List<Terminale>();    
            
        if(configurationMap.containsKey(configId)){
            if(configurationMap.get(configId).containsKey(TERMINALI_RT)){
               for(Id termId :configurationMap.get(configId).get(TERMINALI_RT)){
                    tmptermList.add(new Terminale(termId,this));
                }
            } 

            if(configurationMap.get(configId).containsKey(GATEWAY_RT)){
               for(Id termId :configurationMap.get(configId).get(GATEWAY_RT)){
                    tmptermList.add(new Terminale(termId,this));
                }
            } 
            if(configurationMap.get(configId).containsKey(MOTO_RT)){
               for(Id termId :configurationMap.get(configId).get(MOTO_RT)){
                    tmptermList.add(new Terminale(termId,this));
                }
            } 
            if(configurationMap.get(configId).containsKey(ECOMMERCE_RT)){
               for(Id termId :configurationMap.get(configId).get(ECOMMERCE_RT)){
                    tmptermList.add(new Terminale(termId,this));
                }
            } 

        }
        return tmptermList;
                
    }
    
    public class Acquiring{
        public NE__OrderItem__c root;
        public List<NE__OrderItem__c> pricing = new List<NE__OrderItem__c>();
        public List<NE__OrderItem__c> childs = new List<NE__OrderItem__c>();
        
        Acquiring(Id acquiringId,OB_Order_Wrapper orderWrapper){
            root = orderWrapper.itemMap.get(acquiringId);
            if(orderWrapper.childItemMap.containsKey(acquiringId)){
                for(Id childId :orderWrapper.childItemMap.get(acquiringId)){
                    NE__OrderItem__c childItem = orderWrapper.itemMap.get(childId);
                    if(childItem.NE__ProdId__r.Recordtype.DeveloperName == PRICING_RT){
                        pricing.add(childItem);
                    } else{
                        childs.add(childItem);
                    }
                }
            }
        }
    }

    public class Pci{
        public NE__OrderItem__c root;
        public List<NE__OrderItem__c> pricing = new List<NE__OrderItem__c>();
        public List<NE__OrderItem__c> childs = new List<NE__OrderItem__c>();
        
        Pci(Id pciId,OB_Order_Wrapper orderWrapper){
            root = orderWrapper.itemMap.get(pciId);
            if(orderWrapper.childItemMap.containsKey(pciId)){
                for(Id childId :orderWrapper.childItemMap.get(pciId)){
                    NE__OrderItem__c childItem = orderWrapper.itemMap.get(childId);
                    if(childItem.NE__ProdId__r.Recordtype.DeveloperName == PRICING_RT){
                        pricing.add(childItem);
                    } else{
                        childs.add(childItem);
                    }
                }
            }
        }
    }

    public Pci getPCI(Id configId){
        Pci tmpPCI;
        if(configurationMap.containsKey(configId)){
            if (configurationMap.get(configId).containsKey(PCI_RT)){     
                Id pciId =  configurationMap.get(configId).get(PCI_RT)[0];          
                tmpPCI = new Pci(pciId,this);
            }
        }
        return tmpPCI;
    }

    public List<Acquiring> getAcquiring(Id configId){
        
        List<Acquiring> tmpAcquiringList = new List<Acquiring>();   
            
        if(configurationMap.containsKey(configId)){
            
            //  START   micol.ferrari 08/11/2018
            if (configurationMap.get(configId).containsKey(ACQUIRING_RT))
            {                
                for(Id acquiringId :configurationMap.get(configId).get(ACQUIRING_RT)){
                    tmpAcquiringList.add(new Acquiring(acquiringId,this));
                }
            }
            //  END    micol.ferrari 08/11/2018
        }
        return tmpAcquiringList;
                
    }

    public class Vas{
        public NE__OrderItem__c root;
        public List<NE__OrderItem__c> pricing = new List<NE__OrderItem__c>();
        public List<NE__OrderItem__c> childs = new List<NE__OrderItem__c>();
        
        Vas(Id vasID,OB_Order_Wrapper orderWrapper){
            root = orderWrapper.itemMap.get(vasID);
            if(orderWrapper.childItemMap.containsKey(vasID)){
                for(Id childId :orderWrapper.childItemMap.get(vasID)){
                    NE__OrderItem__c childItem = orderWrapper.itemMap.get(childId);
                    if(childItem.NE__ProdId__r.Recordtype.DeveloperName == PRICING_RT){
                        pricing.add(childItem);
                    } else{
                        childs.add(childItem);
                    }
                }
            }
        }
    }

    public List<Vas> getVas(Id configId){
        
        List<Vas> tmpVasList = new List<Vas>(); 
            
        if(configurationMap.containsKey(configId) && configurationMap.get(configId).containsKey(VAS_RT)){
            for(Id vasId :configurationMap.get(configId).get(VAS_RT)){
                tmpVasList.add(new Vas(vasId,this));
            }
        }

        if(configurationMap.containsKey(configId) && configurationMap.get(configId).containsKey(INTEGRAZIONE_RT)){
            for(Id vasId :configurationMap.get(configId).get(INTEGRAZIONE_RT)){
                tmpVasList.add(new Vas(vasId,this));
            }
        }

        //LUBRANO 2019-04-15 -- add to tmpVasList vas item with record type APM
        if(configurationMap.containsKey(configId) && configurationMap.get(configId).containsKey(APM)){
            for(Id vasId :configurationMap.get(configId).get(APM)){
                tmpVasList.add(new Vas(vasId,this));
            }
        }
        //LUBRANO 2019-04-15 -- end
        return tmpVasList;
                
    }

    public class PagoBancomat{
        public NE__OrderItem__c root;
        public List<NE__OrderItem__c> pricing = new List<NE__OrderItem__c>();
        public List<NE__OrderItem__c> childs = new List<NE__OrderItem__c>();
        
        PagoBancomat(Id bancomatId,OB_Order_Wrapper orderWrapper){
            root = orderWrapper.itemMap.get(bancomatId);
            //  START   micol.ferrari 08/11/2018
            if (orderWrapper.childItemMap.containsKey(bancomatId))
            {
                for(Id childId :orderWrapper.childItemMap.get(bancomatId)){
                    NE__OrderItem__c childItem = orderWrapper.itemMap.get(childId);
                    if(childItem.NE__ProdId__r.Recordtype.DeveloperName == PRICING_RT){
                        pricing.add(childItem);
                    } else{
                        childs.add(childItem);
                    }
                }
            }
            //  END   micol.ferrari 08/11/2018
        }
    }
    
    public List<PagoBancomat> getPagoBancomat(Id configId){
        
        List<PagoBancomat> tmpBancomatList = new List<PagoBancomat>();  
            
        if(configurationMap.containsKey(configId)){
            //  START   micol.ferrari 08/11/2018
            if (configurationMap.get(configId).containsKey(BANCOMAT_RT))
            {
                for(Id pagobancomatId :configurationMap.get(configId).get(BANCOMAT_RT)){
                    tmpBancomatList.add(new PagoBancomat(pagobancomatId,this));
                    break; // Introdotto per un solo bancomat (prende il primo)
                }
            }
            //  END   micol.ferrari 08/11/2018
        }
        return tmpBancomatList;
                
    }
    //05/07/19 francesca.ribezzi - WN-2 - adding OB_Replacement__c
    public List<NE__OrderItem__c> getOrderItems(Id headerId){
        return [SELECT Id,Name, OB_Description__c,NE__Parent_Order_Item__c,NE__Root_Order_Item__c,  NE__StartDate__c,NE__EndDate__c,NE__State__c,
                NE__Action__c,OB_enablement__c,	OB_Old_Enablement__c,OB_Ro__c,OB_Visible__c,OB_Processor__c,OB_ServicePointCode__c,OB_ServicePointType__c,
                OB_ShopCode__c,OB_CompanyCode__c,OB_CustomerCode__c, NE__OrderId__r.Id,NE__OrderId__r.Name,NE__Bundle_Element__c,
                NE__CatalogItem__r.NE__Sequence__c, NE__ProdId__r.Name,NE__ProdId__r.OB_Contract_Type__c,NE__ProdId__r.OB_Acquirer__c,
                NE__ProdId__r.NE__Description__c,NE__ProdId__r.OB_Contract_Description__c,NE__ProdId__r.OB_Pricing_Code__c,
                NE__ProdId__r.Recordtype.DeveloperName,NE__ProdId__r.OB_Codice_sfdc__c, OB_GT__c, NE__Bundle__r.NE__Catalog_Item__r.NE__ProductId__r.OB_Codice_sfdc__c,
                OB_SettlementMethod__c,NE__OrderId__r.NE__Order_Header__r.OB_Report_Type__c,OB_Sequence__c,NE__OrderId__r.NE__Order_Header__r.OB_Main_Process__c,//22/10/2019 giovanni spinelli rollback change
                NE__OrderId__r.NE__Order_Header__r.OB_Sub_Process__c, OB_Replacement__c, OB_Sfdc_code_override__c, //gianluigi.virga 23/10/2019 added OB_Sfdc_code_override__c
                (select id,name,NE__Value__c,NE__Old_Value__c,OB_Attribute_Code__c  from NE__Order_Item_Attributes__r) 
                FROM NE__OrderItem__c where NE__OrderId__r.NE__Order_Header__c = :headerId and NE__Status__c!=: CANCELLED AND OB_FulfilmentStatus__c !=: CANCELLED ];
    }
    
    public static String calculateAction(NE__OrderItem__c oi){
        
        Boolean isEnablement = ((oi.NE__ProdId__r.Recordtype.DeveloperName == ACQUIRING_RT) || (oi.NE__ProdId__r.Recordtype.DeveloperName == VAS_RT)) && oi.NE__Parent_Order_Item__c != null;
        Boolean isPricing = oi.NE__ProdId__r.Recordtype.DeveloperName == PRICING_RT;
        Boolean isSetup = oi.NE__OrderId__r.NE__Order_Header__r.OB_Main_Process__c == SETUP;

        if(isSetup){
            return 'Add';
        }

        if(isEnablement){

           Boolean isRemove = oi.NE__Action__c == 'Remove';
           Boolean isAdd = oi.NE__Action__c == 'Add';
           Boolean newEnable = oi.OB_enablement__c == 'Y'? true:false;
           Boolean oldEnable = oi.OB_Old_Enablement__c == 'Y'? true:false;

           if(isRemove) return 'Remove';
		   if(isAdd && !newEnable) return 'None';// enrico.purificato WN-228
           if(isAdd) return 'Add';
           if(newEnable != oldEnable) return 'Change';
        }
        
        if(isPricing){
            Boolean isRemove = oi.NE__Action__c == 'Remove';
            Boolean isAdd = oi.NE__Action__c == 'Add';
            if(isRemove) return 'Remove';
            if(isAdd) return 'Add';

            for(NE__Order_Item_Attribute__c attr: oi.NE__Order_Item_Attributes__r ){
                if(attr.NE__Value__c != attr.NE__Old_Value__c){
                    return 'Change';
                }
            }

        }
        return oi.NE__Action__c;
    }

    public static Boolean calculateEnablement(NE__OrderItem__c oi){
        Boolean newEnable = oi.OB_enablement__c == 'Y'? true:false;
        Boolean oldEnable = oi.OB_Old_Enablement__c == 'Y'? true:false;
        Boolean isEnabled = newEnable ;
        Boolean isNotRemove = oi.NE__Action__c != 'Remove';

        return (isEnabled && isNotRemove);
    }

    /*Autor Simone Misani 05/07/2019 F2WAVE2-106
    Description: method for Old enablement*/
     public static Boolean calculateOldEnablement(NE__OrderItem__c oi){
        Boolean newEnable = oi.OB_enablement__c == 'Y'? true:false;
        Boolean oldEnable = oi.OB_Old_Enablement__c == 'Y'? true:false;
        Boolean isEnabled = newEnable ;
        Boolean isNotRemove = oi.NE__Action__c != 'Remove';

        return (oldEnable && isNotRemove)||(!isNotRemove && newEnable);
    }

    public List<TerminalDTO> serializeTerminals(Id configId){
        
        List<Terminale> tmptermList = getTerminali(configId);
        List<TerminalDTO> tmp = new List<TerminalDTO>();
        if(tmptermList != null){
            for(Terminale i :tmptermList) {
                tmp.add(new TerminalDTO(i));
            }
        }

        return tmp;

    }

    class PropertiesDTO{
        
        String code;
        String name;
        String value;

        PropertiesDTO(){
        }
        
        PropertiesDTO(NE__Order_Item_Attribute__c ia){
            name = ia.Name;
            code = ia.Name;

            if(ia.Name=='Codice Sia'){
                name = 'Codice SIA';
                code = 'Codice SIA';
            }
            
            value = ia.NE__Value__c;
        }
    }

    class EnablementsDTO{
        String action ;
        String name;
        Boolean value;
        Boolean oldValue;
        String code;
        EnablementsDTO(NE__OrderItem__c oi){
            code            = oi.NE__ProdId__r.OB_Codice_sfdc__c;
            action          = OB_Order_Wrapper.calculateAction(oi);
            name            = oi.NE__ProdId__r.Name;
            value           = OB_Order_Wrapper.calculateEnablement(oi);
            oldValue        = OB_Order_Wrapper.calculateOldEnablement(oi);//Simone Misani 05/07/2019 F2WAVE2-106
        }
    }

    class PricingAttributesDTO{
        String code;
        String name;
        String value;

        PricingAttributesDTO(NE__Order_Item_Attribute__c ia){
            code    = ia.OB_Attribute_Code__c;
            name    = ia.name;
            value   = ia.NE__Value__c;
        }
    }
    class PricingDTO{
        String action ;
        String code;
        String description;
        //String name; //TO DO ELIMINARE
        String startDate;
        String endDate;
        Integer sequence;
        //String sequence;//da valorizzare
        List<PricingAttributesDTO> attributes = new List<PricingAttributesDTO>();
        PricingDTO(NE__OrderItem__c oi){
            action  = OB_Order_Wrapper.calculateAction(oi);
            code    = oi.NE__ProdId__r.OB_Codice_sfdc__c;
            //START gianluigi.virga 23/10/2019 - Override sfdc code on order item
            if(oi.OB_Sfdc_code_override__c != null && oi.OB_Sfdc_code_override__c != ''){
                code = oi.OB_Sfdc_code_override__c;
            }  
            //END gianluigi.virga 23/10/2019 - Override sfdc code on order item
            //name    = oi.NE__ProdId__r.Name; //TO DO ELIMINARE
            sequence  =  Integer.valueOf(oi.OB_Sequence__c);
            startDate = OB_Serialize_Order.serializeDate(oi.NE__StartDate__c);
            endDate = OB_Serialize_Order.serializeDate(oi.NE__EndDate__c);
            description = oi.NE__ProdId__r.OB_Contract_Description__c;
            for(NE__Order_Item_Attribute__c oia : oi.NE__Order_Item_Attributes__r ){
                if(String.isNotBlank(oia.NE__Value__c)){
                    attributes.add(new PricingAttributesDTO(oia));
                }
                
            }
        }
    }

    public class BancomatDTO{
        String externalId;
        String productCode;
        String action;
        List<PropertiesDTO> properties = new List<PropertiesDTO>();
        List<PricingDTO> pricing = new List<PricingDTO>();
        BancomatDTO(PagoBancomat pb){
            action              = OB_Order_Wrapper.calculateAction(pb.root);
            externalId          = pb.root.Id;
            productCode         = pb.root.NE__ProdId__r.OB_Codice_sfdc__c;//TO DO
            if(pb.pricing != null){
                for(NE__OrderItem__c ordIt : pb.pricing ){
                    pricing.add(new PricingDTO(ordIt));
                }
            }
            if(pb.root.NE__Order_Item_Attributes__r != null){
                for(NE__Order_Item_Attribute__c ia : pb.root.NE__Order_Item_Attributes__r ){
                    properties.add(new PropertiesDTO(ia));
                }

            }
        }

    }

    public class VasDTO{
        String externalId;
        String productCode;
        String action;
        List<PropertiesDTO> properties = new List<PropertiesDTO>();
        List<PricingDTO> pricing = new List<PricingDTO>();
        List<VirtualDetailsDTO> virtualDetails = new List<VirtualDetailsDTO>();//Simone Misani WN-1333
        VasDTO(Vas vs){
            action              = OB_Order_Wrapper.calculateAction(vs.root);
            externalId          = vs.root.Id;
            productCode         = vs.root.NE__ProdId__r.OB_Codice_sfdc__c ;
            if(vs.pricing != null){
                for(NE__OrderItem__c ordIt : vs.pricing ){
                    pricing.add(new PricingDTO(ordIt));
                }
            }
            if(vs.root.NE__Order_Item_Attributes__r != null){
                for(NE__Order_Item_Attribute__c ia : vs.root.NE__Order_Item_Attributes__r ){
                    properties.add(new PropertiesDTO(ia));
                }

            }
            //START Simone Misani WN-1333
            virtualDetails.addAll(generateVasDTO(vs.root));//Simone Misani WN-1333
        }

    }
    public class VirtualDetailsDTO{
        public  String source;
        public String companyCode;
        public String pvCode;

    }
    public static List<VirtualDetailsDTO> generateVasDTO(NE__OrderItem__c root){
        List<VirtualDetailsDTO> tmp = new List<VirtualDetailsDTO>();
        if(!(root.NE__ProdId__r.OB_Codice_sfdc__c =='ONECLICK' || root.NE__ProdId__r.OB_Codice_sfdc__c =='RECURRING')){
            return tmp;
        }

        VirtualDetailsDTO monetica = new VirtualDetailsDTO();
        monetica.source = root.OB_GT__c;
        monetica.companyCode = root.OB_CustomerCode__c;
        monetica.pvCode = root.OB_ShopCode__c;
        tmp.add(monetica);
        VirtualDetailsDTO equens = new VirtualDetailsDTO();
        equens.source = root.OB_Processor__c;
        equens.companyCode = root.OB_CompanyCode__c;
        equens.pvCode = root.OB_ServicePointCode__c;
        tmp.add(equens);

        return tmp;
 //END Simone Misani WN-1333
    }

    public BancomatDTO serializeBancomat(Id configId){
        
        List<PagoBancomat> tmpBancomatList = getPagoBancomat(configId);
        /*List<BancomatDTO> tmp = new List<BancomatDTO>();
        for(PagoBancomat i :tmpBancomatList) {
            tmp.add(new BancomatDTO(i));
        }
        return tmp;
        */
       if(tmpBancomatList.size()>0){
            return new BancomatDTO(tmpBancomatList[0]);
       }
       return null;
       

    }

    public List<VasDTO> serializeVas(Id configId){
        
        List<Vas> tmpVasList = getVas(configId);
        List<VasDTO> tmp = new List<VasDTO>();
        for(Vas i :tmpVasList) {
            tmp.add(new VasDTO(i));
        }
        return tmp;

    }



    public class RailsDTO{
        String externalId;
        String productCode;
        String acquirer;
        String action;
        String processorPVCode;
        String processorSOCCode;
        String processor;
        //String codType;
        //String typeOfAccountStatement;
        List<PropertiesDTO> properties = new List<PropertiesDTO>();
        List<PricingDTO> pricing = new List<PricingDTO>();

        RailsDTO(Acquiring a,OB_Order_Wrapper orderWrapper){
            action              = OB_Order_Wrapper.calculateAction(a.root);
            externalId          = a.root.Id;
            productCode         = a.root.NE__ProdId__r.OB_Codice_sfdc__c;
            acquirer            = a.root.NE__ProdId__r.OB_Acquirer__c;
            processorPVCode     = a.root.OB_ServicePointCode__c;
            processorSOCCode    = a.root.OB_CompanyCode__c;
            processor           = a.root.OB_Processor__c;
            //codType             = a.root.OB_ServicePointType__c;
            

            if(a.pricing != null){
                for(NE__OrderItem__c ordIt : a.pricing ){
                    pricing.add(new PricingDTO(ordIt));
                }
                if(productCode == VISA_CODE){
                    Pci tmpPCI = orderWrapper.getPCI(a.root.NE__OrderId__r.Id);
                    if(tmpPCI != null){
                        for(NE__OrderItem__c ordIt : tmpPCI.pricing){
                            pricing.add(new PricingDTO(ordIt));
                        }
                    }
                }
            }

            if(a.root.NE__Order_Item_Attributes__r != null){
                for(NE__Order_Item_Attribute__c ia : a.root.NE__Order_Item_Attributes__r ){
                    properties.add(new PropertiesDTO(ia));
                }

            }

        }
    }
    public String geAccountStatement (Id configId){
        List<Acquiring> tmpRailsList = getAcquiring(configId);
        return OB_Serialize_Order.decodeval('typeOfAccountStatement', tmpRailsList[0].root.NE__OrderId__r.NE__Order_Header__r.OB_Report_Type__c);
    }

    public List<RailsDTO> serializeAcquiring(Id configId){
        
        List<Acquiring> tmpRailsList = getAcquiring(configId);
        List<RailsDTO> tmp = new List<RailsDTO>();
        if(tmpRailsList!=null){
            for(Acquiring i :tmpRailsList) {
                tmp.add(new RailsDTO(i,this));
            }
        }


        return tmp;

    }

    public class TerminalDTO{
        String action;
        String externalId;
        String id;
        String offerCode;
        String offerName;
        String technicalSolutionCode;
        String GTStabCode;
        String GTClientCode;
        String GT;
        String orderNote;
        String ownership;
        String modality;
        String model;
        String connectionType;
        String release;
        //michele.lubrano@accenture.com new fields for maintenance START
        Boolean replacement;
        //michele.lubrano@accenture.com END

        List<PropertiesDTO> properties = new List<PropertiesDTO>();
        List<EnablementsDTO> enablements = new List<EnablementsDTO>();
        List<PricingDTO> pricing = new List<PricingDTO>();
        
        TerminalDTO(Terminale t){
            action                  = OB_Order_Wrapper.calculateAction(t.root); 
            externalId              = t.root.Id;
            offerCode               = t.root.NE__ProdId__r.OB_Codice_sfdc__c;//t.root.NE__Bundle__r.NE__Catalog_Item__r.NE__ProductId__r.OB_Codice_sfdc__c;
            offerName               = t.root.NE__ProdId__r.Name;
            technicalSolutionCode   = t.root.NE__ProdId__r.OB_Codice_sfdc__c; //TO DO
            GTStabCode              = t.root.OB_ShopCode__c;
            GTClientCode            = t.root.OB_CustomerCode__c;
            GT                      = t.root.OB_GT__c != null ? t.root.OB_GT__c.toUpperCase() : t.root.OB_GT__c;//Simone Misani WN-51 26/07/2019
            orderNote               = t.root.OB_Description__c;
            //michele.lubrano@accenture.com new fields for maintenance START
            replacement             = t.root.OB_Replacement__c; //05/07/19 francesca.ribezzi - WN-2 - this field is used for 'configuratore tecnico' and not for 'sostituzione pos'
            //michele.lubrano@accenture.com END
            for(NE__Order_Item_Attribute__c oia : t.root.NE__Order_Item_Attributes__r ){
                    if(oia.Name == TERMINALE_ATTRIBUTE_TERMID) {
                        id= oia.NE__Value__c;
                    }
                    else if(oia.Name == TERMINALE_ATTRIBUTE_OWNERSHIP) {
                        ownership = oia.NE__Value__c;
                    }
                    else if(oia.Name == TERMINALE_ATTRIBUTE_MODEL) {
                        model = oia.NE__Value__c;
                    }
                    else if(oia.Name == TERMINALE_ATTRIBUTE_MODALITY) {
                        modality = oia.NE__Value__c ;
                    }                   
                    else if(oia.Name == TERMINALE_ATTRIBUTE_CONNTYPE) {
                        connectionType = oia.NE__Value__c;
                    }
                    else if(oia.Name == TERMINALE_ATTRIBUTE_RELEASE){
                        release = oia.NE__Value__c;
                    } 
                    else properties.add(new PropertiesDTO(oia));
            }
            for(NE__OrderItem__c ordIt :t.enablements ){
                enablements.add(new EnablementsDTO(ordIt));
            }
            for(NE__OrderItem__c ordIt : t.pricing ){
                pricing.add(new PricingDTO(ordIt));
            }
        }
    }
}