/*
* GC 18/10/2018 utilities to be used during engine iteration
*/
global class OB_EngineUtilities implements NE.Bit2WinExternalUtility.CartAPIExtension
{
    public class Poselement{
        // Roland Nieznanski <roland.nieznanski@accenture.com 07/08/2019 add public to variables START
        public String rootCatalogItem;
        public String bundleElement;
        public String bundleId;
        public String bundlevid;
        public List<String> currentItems;
        public List<String> itemsToAdd;
        public List<String> attachmentsToAdd;
        // Roland Nieznanski <roland.nieznanski@accenture.com 07/08/2019 add public to variables STOP
    }

    global object APIGenericMethod(object params)
    {
        map<String,String> mapOfResponseInput   =   (map<String,String>)params;
        map<String,String> mapOfResponse        =   new map<String,String>();
        mapOfResponse.putAll(mapOfResponseInput);

        String errorCode                =   '0';
        String errorMessage             =   '';
        String service                  =   mapOfResponse.get('service');

        if(service == 'retrieveItemData')
        {
            String parentVid                =   mapOfResponse.get('parentVid');
            String rootVid                  =   mapOfResponse.get('rootVid');
            String rootcatalogItemId        =   mapOfResponse.get('rootcatalogItemId');
            String productenginecodetoadd   =   mapOfResponse.get('productenginecodetoadd');

            list<NE__Catalog_Item__c> listOfItems   =   [SELECT id FROM NE__Catalog_Item__C WHERE NE__ProductId__r.NE__Engine_Code__c =: productenginecodetoadd AND NE__Item_Header__r.NE__Catalog_Item__c =: rootcatalogItemId];

            if(listOfItems.size() > 0)
            {
                Organization orgDetails = [SELECT Id, LanguageLocaleKey FROM Organization WHERE Id = :UserInfo.getOrganizationId()];
                String userNameFile = 'B2WGin_Element_'+orgDetails.LanguageLocaleKey+'.JSON';
                list<Attachment> allAttachments = [SELECT Id,ParentId,Body FROM Attachment WHERE Name =: userNameFile AND ParentId IN:listOfItems];

                if(allAttachments.size() > 0)
                    mapOfResponse.put('itemToAdd',allAttachments.get(0).body.toString());
                else
                {
                    errorCode       =   '-1';
                    errorMessage    =   'No attachment found for: '+productenginecodetoadd;
                }
            }
            else
            {
                errorCode       =   '-1';
                errorMessage    =   'No item found for: '+productenginecodetoadd;
            }

        }

        if(service == 'retrieveItemListData')
        {
            Map<String,Poselement>     terminalMap           = (Map<String,Poselement>)JSON.deserialize(mapOfResponse.get('prodMap'),Map<String,Poselement>.class);
            List<String> productEngineCodes                  = new List<String>();
            List<String> terminalCatalogItems                = new List<String>();

            for(Poselement term:terminalMap.values())
            {
                terminalCatalogItems.add(term.rootCatalogItem);
                productEngineCodes.addAll(term.itemsToAdd);
            }

            Organization orgDetails = [SELECT Id, LanguageLocaleKey FROM Organization WHERE Id = :UserInfo.getOrganizationId()];
            String userNameFile = 'B2WGin_Element_'+orgDetails.LanguageLocaleKey+'.JSON';

            list<NE__Catalog_Item__c> listOfItems   =   [SELECT id, NE__ProductId__r.NE__Engine_Code__c, NE__Item_Header__r.NE__Catalog_Item__c, (SELECT Id FROM Attachments WHERE Name =: userNameFile) FROM NE__Catalog_Item__C WHERE NE__ProductId__r.NE__Engine_Code__c IN :productEngineCodes AND NE__Item_Header__r.NE__Catalog_Item__c IN: terminalCatalogItems];

            if(listOfItems.size() > 0)
            {
                Map<String,String> attachPerTerm    = new Map<String,String>();
                Map<String,String> childMap         = new Map<String,String>();
                Map<String,String> termMap          = new Map<String,String>();

                for(NE__Catalog_Item__c catIt : listOfItems)
                {
                    attachPerTerm.put(catIt.Attachments[0].id,catIt.NE__Item_Header__r.NE__Catalog_Item__c +'_'+catIt.NE__ProductId__r.NE__Engine_Code__c);
                    termMap.put(catIt.Id,catIt.NE__Item_Header__r.NE__Catalog_Item__c +'_'+catIt.NE__ProductId__r.NE__Engine_Code__c);
                }

                list<Attachment> allAttachments = [SELECT Id,ParentId,Body FROM Attachment WHERE  id in: attachPerTerm.keySet() ];

                if(allAttachments.size() > 0)
                {


                    for(Attachment att:allAttachments)
                    {
                        childMap.put(termMap.get(att.ParentId),att.body.toString());
                    }

                    for (String row : terminalMap.keySet())
                    {
                        Poselement currentTrem = terminalMap.get(row);

                        List<String> rootAttachmentList = new List<String>();// Roland Nieznanski <roland.nieznanski@accenture.com 07/08/2019

                        for(String engineCode:currentTrem.itemsToAdd)
                        {
                            if(childMap.get(currentTrem.rootCatalogItem+'_'+engineCode) != null){
                                // Roland Nieznanski <roland.nieznanski@accenture.com 07/08/2019 START
                                rootAttachmentList.add(childMap.get(currentTrem.rootCatalogItem+'_'+engineCode));
                                currentTrem.attachmentsToAdd = rootAttachmentList;
                                // Roland Nieznanski <roland.nieznanski@accenture.com 07/08/2019 STOP
                            }
                        }

                    }

                    mapOfResponse.put('itemToAdd2',JSON.serialize(terminalMap));

                }
                else
                {
                    errorCode       =   '-1';
                    errorMessage    =   'No attachment found for: '+productEngineCodes;
                }

            }
            else
            {
                errorCode       =   '-1';
                errorMessage    =   'No item found for: '+productEngineCodes;
            }
        }

        if(service == 'retrieveItemsFromMatrices')
        {
            Organization orgDetails = [SELECT Id, LanguageLocaleKey FROM Organization WHERE Id = :UserInfo.getOrganizationId()];
            String userNameFile = 'B2WGin_Element_'+orgDetails.LanguageLocaleKey+'.JSON';

            String matricesString   =   mapOfResponse.get('matricesString');

            system.debug('@@@ matricesString: '+matricesString);

            list<NE__Matrix_Parameter_Row__c>   listOfMatrices  =   (list<NE__Matrix_Parameter_Row__c>)JSON.deserialize(matricesString,list<NE__Matrix_Parameter_Row__c>.class);
            //list<String> itemsToFind    =   new list<String>();
            Map<String,String> itemsToFind = new Map<String,String>();
            map<String, NE__Matrix_Parameter_Row__c> mapOfMatrices  =   new map<String, NE__Matrix_Parameter_Row__c>();
            for(NE__Matrix_Parameter_Row__c matrix:listOfMatrices)
            {
                //itemsToFind.add(matrix.OB_Componente__c);
                itemsToFind.put(matrix.OB_Componente__c,matrix.OB_Componente__c);
                mapOfMatrices.put(matrix.OB_Componente__c,matrix);
            }

            map<String, Map<String, String>> mapOfResults    =   new map<String, Map<String, String>>();


            for(Attachment itemToAdd:[SELECT Id,ParentId,Body FROM Attachment WHERE Name =: userNameFile AND ParentId IN:itemsToFind.keySet()])
            {
                NE__Matrix_Parameter_Row__c matrixFound =   mapOfMatrices.get(itemToAdd.parentId);
                system.debug('itemToAdd.parentId: '+itemToAdd.parentId);
                system.debug('Matrix found: '+matrixFound);

                if(matrixFound != null)
                {
                    Map<String, String> tmpItemList = new Map<String, String>();
                    if(mapOfResults.containsKey(matrixFound.OB_Parent_Componente__c)){
                        tmpItemList = mapOfResults.get(matrixFound.OB_Parent_Componente__c);
                    }
                    tmpItemList.put(itemToAdd.parentId,itemToAdd.body.toString());
                    system.debug('@@@ attachment ' +itemToAdd.Id +': '+ itemToAdd.body.toString());
                    mapOfResults.put(matrixFound.OB_Parent_Componente__c,tmpItemList);
                    //mapOfResults.put(matrixFound.OB_Parent_Componente__c,itemToAdd.body.toString());
                }
            }

            String trash = mapOfResponse.remove('matricesString');
            mapOfResponse.put('itemsToAdd',JSON.serialize(mapOfResults));
            system.debug('@@@ response' + JSON.serialize(mapOfResponse));
        }

        //davide.franzini - Catalogo On/Off - 18/06/2019 - START
        if(service == 'retrieveOffers')
        {

            String confJSON   =   mapOfResponse.get('config');

            Map<String, NE__Matrix_Parameter_Row__c> mapOfMatrices  =   new Map<String, NE__Matrix_Parameter_Row__c>();

            system.debug('@@@ confJSON: '+confJSON);

            NE__Order__c   conf  =   (NE__Order__c)JSON.deserialize(confJSON,NE__Order__c.class);

            Date orderDate = Date.newInstance(conf.NE__order_date__c.year(), conf.NE__order_date__c.month(), conf.NE__order_date__c.day());
            system.debug('@@ Conf Order Date: '+orderDate);

            List<NE__Matrix_Parameter__c> mpList = [SELECT Id,
                    NE__Active__c,
                    NE__Catalog_Header__c,
                    NE__End_Date__c,
                    NE__Name__c,
                    NE__Parent_External_Id__c,
                    NE__Query_Condition__c,
                    NE__RequestId__c,
                    NE__Start_Date__c,
                    NE__Status__c,
                    OB_Listino__c,
                    OB_Offerta__c,
                    OB_Componente__c,
                    OB_Product__c,
                    OB_ModelloAcquiring__c,
                    OB_SchemaPrezzi__c,
                    OB_ABI__c,
                    OB_ActiveBank__c,
                    OB_MainMP__c,
                    OB_MainMP__r.NE__Active__c, //davide.franzini - 05/07/2019
                    OB_MainMP__r.OB_ActiveBank__c, //davide.franzini - 05/07/2019
                    OB_ABIcatItemIdBundleId__c
            FROM NE__Matrix_Parameter__c
            WHERE OB_ABI__c = :conf.OB_Abi__c];
            //AND NE__Active__c = true];  //davide.franzini - 20/07/2019 - WN-115

            system.debug('@@ mpList: '+mpList);

            if(mpList!=null && !mpList.isEmpty())
            {
                mapOfResponse.put('mpToAdd',JSON.serialize(mpList));
            }
            else
            {
                errorCode       =   '-1';
                errorMessage    =   'No item found for: '+conf.OB_Abi__c;
            }

            system.debug('@@@ response' + JSON.serialize(mapOfResponse));

        }
        //davide.franzini - Catalogo On/Off - 18/06/2019 - END

        if(service == 'retrieveMatrices')
        {

            String businessModAcq = mapOfResponse.get('businessModAcq');
            String confJSON   =   mapOfResponse.get('config');
            String bundId = mapOfResponse.get('bundId');
            //davide.franzini - 09/07/2019 - CatalogOnOff_QueryIndexing - START
            String mainMP = mapOfResponse.get('mainMP');
            List<NE__Matrix_Parameter_Row__c> mprList = new List<NE__Matrix_Parameter_Row__c>();
            List<NE__Matrix_Parameter__c> matrixParamList = new List<NE__Matrix_Parameter__c>();
            //davide.franzini - 09/07/2019 - CatalogOnOff_QueryIndexing - END

            Map<String, NE__Matrix_Parameter_Row__c> mapOfMatrices  =   new Map<String, NE__Matrix_Parameter_Row__c>();

            system.debug('@@@ confJSON: '+confJSON);

            NE__Order__c   conf  =   (NE__Order__c)JSON.deserialize(confJSON,NE__Order__c.class);

            Date orderDate = Date.newInstance(conf.NE__order_date__c.year(), conf.NE__order_date__c.month(), conf.NE__order_date__c.day());
            system.debug('@@ Conf Order Date: '+orderDate);

            //davide.franzini - 31/07/2019 - WN-216 - START
            AggregateResult[] groupedResults = [SELECT count(Id)
            FROM NE__Matrix_Parameter__c
            WHERE OB_ABI__c = :conf.OB_Abi__c
            AND OB_Cab__c = :conf.OB_Cab__c
            AND OB_Offerta__c = :bundId];
            Double cabMPNumber = (Double)groupedResults[0].get('expr0');
            String cabQuery = cabMPNumber > 0 ? conf.OB_Cab__c : '';
            //davide.franzini - 31/07/2019 - WN-216 - END
            //davide.franzini - 07/10/2019 - WN-556 - START
            Map<String,Object> confObj  =   (Map<String,Object>)JSON.deserializeUntyped(confJSON);
            Boolean processQuery = true;
            try{
                String process = String.valueOf(confObj.get('ob_main_process'));
                processQuery = process =='Maintenance' ? false : true;
            }catch(Exception e){
                system.debug('>_> Exception: '+e);
            }
            //davide.franzini - 07/10/2019 - WN-556 - END
            //davide.franzini - 09/07/2019 - CatalogOnOff_QueryIndexing - START
            matrixParamList = [SELECT Id ,
            (SELECT Id,
                    Name,
                    NE__Active__c,
                    NE__End_Date__c,
                    NE__Matrix_Parameter__c,
                    NE__Start_Date__c,
                    OB_ABI_BANCA__c,
                    OB_Cab__c,
                    OB_Codici__c,
                    OB_Componente__c,
                    OB_Default_Banca__c,
                    OB_DynamicPropertyDefinition__c,
                    OB_Family__c,
                    OB_Hidden__c,
                    OB_Massimale__c,
                    OB_Massimo__c,
                    OB_Minimo__c,
                    OB_ModelloAcquiring__c,
                    OB_Offerta__c,
                    OB_Parent_Componente__c,
                    OB_Product__c,
                    OB_Read_Only_banca__c,
                    OB_ReadOnly__c,
                    OB_Schema_Prezzi__c,
                    OB_Sequence__c,
                    OB_Soglia_Min_Approvazione__c,
                    OB_Soglia_Max_Approvazione__c,
                    OB_MinThresholdL2__c,
                    OB_MaxThresholdL2__c,
                    OB_MinThresholdL3__c,
                    OB_MaxThresholdL3__c,
                    OB_Utilizzato_per_la_BANCA__c,
                    OB_Valore_Default__c,
                    OB_ActiveBank__c,
                    OB_MainMPRBank__c,
                    NE__Matrix_Parameter__r.OB_ActiveBank__c,
                    OB_SFDC_Row_Code__c //gianluigi.virga 23/10/2019 - override SFDC code
            FROM NE__Matrix_Parameter_Rows__r
            WHERE NE__Active__c = true
            AND (OB_ActiveBank__c = true OR OB_ActiveBank__c = :processQuery)   //davide.franzini - 07/10/2019 - WN-556
            AND NE__Matrix_Parameter__r.NE__Active__c = true
            AND OB_SelfLookup__c <> null
            AND OB_Componente__c <> null
            AND OB_ABI_BANCA__c = :conf.OB_Abi__c
            AND OB_ModelloAcquiring__c = :businessModAcq
            AND NE__Start_date__c <= :orderDate                                 //davide.franzini - 13/07/2019 - WN-47
            AND (NE__End_Date__c > :orderDate OR NE__End_Date__c = null)
            AND OB_Offerta__c = :bundId
            AND OB_Cab__c = :cabQuery)                                          // davide.franzini - WN-216 - 31/07/2019
            FROM NE__Matrix_Parameter__c
            WHERE OB_MainMP__c= :mainMP];

            for (NE__Matrix_Parameter__c mp : matrixParamList){
                for(NE__Matrix_Parameter_Row__c mpr : mp.NE__Matrix_Parameter_Rows__r){
                    mprList.add(mpr);
                }
            }
            //davide.franzini - 09/07/2019 - CatalogOnOff_QueryIndexing - END
            String queryCAB = 'SELECT Id ,  (SELECT Id, Name, NE__Active__c, NE__End_Date__c, NE__Matrix_Parameter__c, NE__Start_Date__c, OB_ABI_BANCA__c, OB_Cab__c, OB_Codici__c, OB_Componente__c, OB_Default_Banca__c, OB_DynamicPropertyDefinition__c, OB_Family__c, OB_Hidden__c, OB_Massimale__c, OB_Massimo__c, OB_Minimo__c, OB_ModelloAcquiring__c, OB_Offerta__c, OB_Parent_Componente__c, OB_Product__c, OB_Read_Only_banca__c, OB_ReadOnly__c, OB_Schema_Prezzi__c, OB_Sequence__c, OB_Soglia_Min_Approvazione__c, OB_Soglia_Max_Approvazione__c, OB_MinThresholdL2__c, OB_MaxThresholdL2__c, OB_MinThresholdL3__c, OB_MaxThresholdL3__c, OB_Utilizzato_per_la_BANCA__c, OB_Valore_Default__c, OB_ActiveBank__c, OB_MainMPRBank__c, NE__Matrix_Parameter__r.OB_ActiveBank__c FROM NE__Matrix_Parameter_Rows__r WHERE NE__Active__c = true AND NE__Matrix_Parameter__r.NE__Active__c = true AND OB_SelfLookup__c <> null AND OB_Componente__c <> null AND OB_ABI_BANCA__c = '+conf.OB_Abi__c+' AND OB_ModelloAcquiring__c = '+businessModAcq+' AND NE__Start_date__c <= '+orderDate+' AND (NE__End_Date__c > '+orderDate+' OR NE__End_Date__c = null) AND OB_Offerta__c = '+bundId+' AND OB_Cab__c = '+cabQuery+') FROM NE__Matrix_Parameter__c WHERE OB_MainMP__c= '+mainMP;
            String queryNoCAB = 'SELECT Id ,  (SELECT Id, Name, NE__Active__c, NE__End_Date__c, NE__Matrix_Parameter__c, NE__Start_Date__c, OB_ABI_BANCA__c, OB_Cab__c, OB_Codici__c, OB_Componente__c, OB_Default_Banca__c, OB_DynamicPropertyDefinition__c, OB_Family__c, OB_Hidden__c, OB_Massimale__c, OB_Massimo__c, OB_Minimo__c, OB_ModelloAcquiring__c, OB_Offerta__c, OB_Parent_Componente__c, OB_Product__c, OB_Read_Only_banca__c, OB_ReadOnly__c, OB_Schema_Prezzi__c, OB_Sequence__c, OB_Soglia_Min_Approvazione__c, OB_Soglia_Max_Approvazione__c, OB_MinThresholdL2__c, OB_MaxThresholdL2__c, OB_MinThresholdL3__c, OB_MaxThresholdL3__c, OB_Utilizzato_per_la_BANCA__c, OB_Valore_Default__c, OB_ActiveBank__c, OB_MainMPRBank__c, NE__Matrix_Parameter__r.OB_ActiveBank__c FROM NE__Matrix_Parameter_Rows__r WHERE NE__Active__c = true AND NE__Matrix_Parameter__r.NE__Active__c = true AND OB_SelfLookup__c <> null AND OB_Componente__c <> null AND OB_ABI_BANCA__c = '+conf.OB_Abi__c+' AND OB_ModelloAcquiring__c = '+businessModAcq+' AND NE__Start_date__c <= '+orderDate+' AND (NE__End_Date__c > '+orderDate+' OR NE__End_Date__c = null) AND OB_Offerta__c = '+bundId+' AND OB_Cab__c = null) FROM NE__Matrix_Parameter__c WHERE OB_MainMP__c= '+mainMP;
            system.debug('@@ queryCAB: '+queryCAB);
            system.debug('@@ queryNoCAB: '+queryNoCAB);

            system.debug('@@ mprList: '+mprList);

            if(mprList!=null && !mprList.isEmpty())
            {

                for(NE__Matrix_Parameter_Row__c matrix : mprList)
                {
                    mapOfMatrices.put(matrix.OB_Componente__c,matrix);
                }

            }
            else
            {
                errorCode       =   '-1';
                errorMessage    =   'No item found for: '+bundId;
            }
            system.debug('@@ mapOfMatrices: '+mapOfMatrices);

            mapOfResponse.put('itemsToAdd',JSON.serialize(mprList));
            system.debug('@@@ response' + JSON.serialize(mapOfResponse));

        }

        mapOfResponse.put('errorCode',errorCode);
        mapOfResponse.put('errorMessage',errorMessage);

        return mapOfResponse;
    }

    global void  retrieveItemsUtility(NE.RetrieveItemsService.Output retrieveItems)
    {

    }

    global void  retrieveAttributesUtility(NE.RetrieveAttributesService.Output retrieveAttributes){}

    global void  cartCheckoutUtility(NE.CartCheckOutService.Input cartCheckOut){}

    global void  retrieveCatalogsUtility(NE.RetrieveCatalogsService.Output retrieveCatalogs){}

}