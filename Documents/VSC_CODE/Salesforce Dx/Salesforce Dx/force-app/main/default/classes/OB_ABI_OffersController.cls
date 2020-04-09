public with sharing class OB_ABI_OffersController {
    @AuraEnabled
    public static List<NE__Lov__c> getABIListFromInput(String abi) {
        String input = abi + '%';
        List<NE__Lov__c> abiLovs = [
                SELECT Name, Ne__value1__c
                FROM NE__Lov__c
                WHERE NE__type__c = 'ABI' AND
                Name LIKE:input
        ];
        return abiLovs;
    }
    @AuraEnabled
    public static List<NE__Bundle__c> getOffersByABIServer(String abi) {

        String catalogName = OB_offerCatalogController.catalogName;
        List<NE__Bundle__c> bankOffers = new List<NE__Bundle__c>();
        // OfferResults res = new OfferResults();
        // res.offersToEnable =
        List<AggregateResult> arList = [
                select NE__Matrix_Parameter__r.OB_Offerta__c, NE__Matrix_Parameter__r.OB_Offerta__r.Name,
                        count(id)
                from NE__Matrix_Parameter_Row__c
                where NE__Matrix_Parameter__r.OB_Offerta__r.Name != null
                AND OB_ABI_BANCA__c = :abi
                group by NE__Matrix_Parameter__r.OB_Offerta__c, NE__Matrix_Parameter__r.OB_Offerta__r.Name
        ];
        System.debug('arList: ' + arList);
        for (AggregateResult ar : arList) {
            //new bundle -> setting its value and add to offerList
            NE__Bundle__c tempBundle = new NE__Bundle__c(
                    Id = (id) ar.get('OB_Offerta__c')
            );
            System.debug('tempBundle: ' + tempBundle);
            bankOffers.add(tempBundle);
        }

        List<NE__Bundle__c> bundlesToReturn = [
                SELECT Id, Name, NE__Start_Date__c, OB_Image__c, NE__Description__c, NE__End_Date__c, NE__Active__c
                FROM NE__Bundle__c
                WHERE id in:bankOffers
                AND NE__Catalog__r.name = :catalogName
                ORDER BY Name
        ];

        return bundlesToReturn;
    }

    @AuraEnabled
    public static List<NE__Bundle__c> getAllOffersToEnableServer(List<NE__Bundle__c> bankOffers) {
        String catalogName = OB_offerCatalogController.catalogName;
        List<NE__Bundle__c> offersToEnable = new List<NE__Bundle__c>();

        Map<id, NE__Bundle__c> mapIdOffer = new Map<id, NE__Bundle__c>([
                select Id,NE__Catalog_Item__r.NE__ProductId__r.Name, NE__Start_Date__c, OB_Image__c, NE__Description__c, Name,NE__End_Date__c, NE__Active__c
                from NE__Bundle__c
                WHERE NE__Catalog__r.Name = :catalogName
                AND NE__Start_Date__c < TODAY AND (NE__End_Date__c > TODAY OR NE__End_Date__c = null)
                AND NE__Active__c = true
        ]);

        for (NE__Bundle__c bundle : bankOffers) {
            Id tempOffer = bundle.Id;
            if (mapIdOffer.containsKey(tempOffer)) {
                //tutte le offerte meno quelle istanziate
                NE__Bundle__c tempBundle = mapIdOffer.remove(tempOffer);
            }
        }
        for (Id key : mapIdOffer.keyset()) {
            offersToEnable.add(mapIdOffer.get(key));
        }
        return offersToEnable;

    }

    @AuraEnabled
    public static List<NE__Bundle__c> searchForOffersToEnable(List<NE__Bundle__c> bankOffers, String searchText) {
        String searchInput = '%' + searchText + '%';
        String catalogName = OB_offerCatalogController.catalogName;
        List<NE__Bundle__c> offersToEnable = new List<NE__Bundle__c>();

        Map<id, NE__Bundle__c> mapIdOffer = new Map<id, NE__Bundle__c>([
                select Id,NE__Catalog_Item__r.NE__ProductId__r.Name, NE__Start_Date__c, OB_Image__c, NE__Description__c, Name,NE__End_Date__c, NE__Active__c
                from NE__Bundle__c
                WHERE NE__Catalog__r.Name = :catalogName
                AND Name LIKE:searchInput
                AND NE__Start_Date__c < TODAY AND (NE__End_Date__c > TODAY OR NE__End_Date__c = null)
                AND NE__Active__c = true
        ]);

        for (NE__Bundle__c bundle : bankOffers) {
            Id tempOffer = bundle.Id;
            if (mapIdOffer.containsKey(tempOffer)) {
                //tutte le offerte meno quelle istanziate
                NE__Bundle__c tempBundle = mapIdOffer.remove(tempOffer);
            }
        }
        for (Id key : mapIdOffer.keyset()) {
            offersToEnable.add(mapIdOffer.get(key));
        }
        return offersToEnable;
    }

    @AuraEnabled
    public static List<NE__bundle__c> getBundleOffers() {
        //TO EDIT: List<NE__Matrix_Parameter_Row__c>
        String catalogName = OB_offerCatalogController.catalogName;
        String query = '';
        List<NE__bundle__c> offers = new List<NE__bundle__c>();
        query = 'SELECT name, CreatedDate, LastModifiedDate,NE__Start_Date__c, OB_Image__c, NE__Description__c, NE__End_Date__c,' +
                'NE__Active__c from NE__bundle__c WHERE NE__Active__c =true AND NE__Catalog__r.Name =\'' + catalogName + '\' AND NE__Start_Date__c < TODAY AND (NE__End_Date__c >TODAY OR NE__End_Date__c = null) ORDER BY Name';
        System.debug(query);
        offers = Database.query(query);
        return offers;
    }

    @AuraEnabled
    public static List<NE__Matrix_Parameter_Row__c> getBundleOffersOrderBy(String selectedValue, List<NE__Matrix_Parameter_Row__c> bundleOffers) {
        //TO EDIT: List<NE__Matrix_Parameter_Row__c>
        String query = '';
        List<NE__Matrix_Parameter_Row__c> offers = new List<NE__Matrix_Parameter_Row__c>();
        query = 'SELECT id, NE__Active__c, Name,NE__Matrix_Parameter__r.OB_Offerta__c, NE__Matrix_Parameter__r.OB_Offerta__r.Name, NE__Matrix_Parameter__r.OB_Offerta__r.NE__Start_Date__c, NE__Matrix_Parameter__r.OB_Offerta__r.OB_Image__c, NE__Matrix_Parameter__r.OB_Offerta__r.NE__Description__c, NE__Matrix_Parameter__r.OB_Offerta__r.NE__End_Date__c, NE__Matrix_Parameter__r.OB_Offerta__r.NE__Active__c'
                + ' FROM NE__Matrix_Parameter_Row__c WHERE Id IN :bundleOffers ORDER BY ' + selectedValue;
        System.debug(query);
        offers = Database.query(query);
        return offers;
    }
    /*  @AuraEnabled
      public static List<NE__Matrix_Parameter_Row__c> searchForOffer(String searchText, String selectedABI){
          String searchInput = searchText+'%';
              List<NE__Matrix_Parameter_Row__c> offers =
          [
              SELECT id, NE__Active__c, Name,NE__Matrix_Parameter__r.OB_Offerta__c, NE__Matrix_Parameter__r.OB_Offerta__r.Name, NE__Matrix_Parameter__r.OB_Offerta__r.NE__Start_Date__c, NE__Matrix_Parameter__r.OB_Offerta__r.OB_Image__c, NE__Matrix_Parameter__r.OB_Offerta__r.NE__Description__c, NE__Matrix_Parameter__r.OB_Offerta__r.NE__End_Date__c, NE__Matrix_Parameter__r.OB_Offerta__r.NE__Active__c
              FROM NE__Matrix_Parameter_Row__c
              WHERE OB_ABI_BANCA__c =: selectedABI
              AND NE__Active__c = true
              AND NE__Matrix_Parameter__r.OB_Offerta__r.NE__Active__c = true
              AND NE__Matrix_Parameter__r.NE__Active__c = true
              AND NE__Matrix_Parameter__r.OB_Offerta__r.name LIKE :searchInput
              ORDER BY NE__Matrix_Parameter__r.OB_Offerta__r.Name
          ];

          return offers;
      }*/

    /* @AuraEnabled
     public static void updateRowsWithBundles(Map<String, Boolean> activeOffersMap,  List<NE__Matrix_Parameter_Row__c> rows, String selectedABI){

         List<NE__Matrix_Parameter_Row__c> listToUpdate = new List<NE__Matrix_Parameter_Row__c>();
         List<NE__Bundle__c> activeOffers = new	List<NE__Bundle__c>();
         //System.debug('before for');
         for(Integer i = 0; i<rows.size(); i++){
             for(String key : activeOffersMap.keyset()){
                 if(rows[i].NE__Matrix_Parameter__r.OB_Offerta__c == key && activeOffersMap.get(key) == false){
                     //remove Active from all parameters rows.
                     rows[i].NE__Active__c = false;
                     listToUpdate.add(rows[i]);
                 }else if(rows[i].NE__Matrix_Parameter__r.OB_Offerta__c != key  && activeOffersMap.get(key) == true){
                     NE__Bundle__c bundle = 	new NE__Bundle__c();
                     bundle.Id = key;
                     activeOffers.add(bundle);
                 }
             }
         }
         //System.debug('after for');
         System.debug('listToUpdate: ' + listToUpdate);
         System.debug('activeOffers: ' + activeOffers);
         //calling cloneParametersAndRows
         OB_ABI_OffersController.cloneParametersAndRows(activeOffers, selectedABI, listToUpdate);

     }*/

    /* @AuraEnabled
     public static List<NE__Matrix_Parameter_Row__c> cloneParametersAndRows(List<NE__Bundle__c> activeOffers, String selectedABI, List<NE__Matrix_Parameter_Row__c> listToUpdate){
         System.debug('inside cloneParametersAndRows');
         List<NE__Matrix_Parameter_Row__c> rowsToClone = [
             SELECT id, NE__Active__c, Name,NE__Matrix_Parameter__r.OB_Offerta__c, NE__Matrix_Parameter__r.OB_Offerta__r.Name, NE__Matrix_Parameter__r.OB_Offerta__r.NE__Start_Date__c, NE__Matrix_Parameter__r.OB_Offerta__r.OB_Image__c, NE__Matrix_Parameter__r.OB_Offerta__r.NE__Description__c, NE__Matrix_Parameter__r.OB_Offerta__r.NE__End_Date__c, NE__Matrix_Parameter__r.OB_Offerta__r.NE__Active__c
             FROM NE__Matrix_Parameter_Row__c
             WHERE OB_ABI_BANCA__c = null
             AND OB_Cab__c = null
             AND NE__Active__c = true
             AND NE__Matrix_Parameter__r.OB_Offerta__c in :activeOffers
             ORDER BY NE__Matrix_Parameter__r.OB_Offerta__r.Name
         ];
         System.debug('rowsToClone: ' + rowsToClone);
         List<NE__Matrix_Parameter_Row__c> newRows = rowsToClone.deepclone(false, false, false);
         for(Integer i = 0; i<newRows.size(); i++){
             newRows[i].OB_ABI_BANCA__c = selectedABI;
         }
         if(listToUpdate.size() > 0){
             for(Integer j = 0; j< listToUpdate.size(); j++){
                 newRows.add(listToUpdate[j]);
             }
         }*/
    /*try {
        upsert newRows;
    } catch(DmlException e) {
        System.debug('The following exception has occurred on cloneParametersAndRows method: ' + e.getMessage());
    }   */

    /*	return newRows;
    }*/

    @AuraEnabled
    public static void cloneParametersAndRows(List<Id> activeOffers, String abi) {
        System.debug('inside cloneParametersAndRows');
        //getting rows to clone
        System.debug('@@@activeOffers: ' + activeOffers);
        List<NE__Matrix_Parameter_Row__c> rowList = [
                SELECT RecordType.DeveloperName,NE__Matrix_Parameter__r.OB_SchemaPrezzi__c, NE__Matrix_Parameter__r.OB_ModelloAcquiring__c, NE__Matrix_Parameter__r.NE__Name__c, NE__Matrix_Parameter__r.OB_Offerta__r.Name, NE__Matrix_Parameter__r.OB_Componente__r.NE__ProductId__r.Name, NE__Active__c, NE__Matrix_Item_Identifier__c, NE__Parent_External_Id__c, NE__RequestId__c, NE__Source_External_Id__c, OB_Visible__c, OB_Default_Banca__c, OB_Utilizzato_per_la_BANCA__c, OB_Family__r.NE__Source_Family_Id__c, OB_ABI_BANCA__c, OB_DynamicPropertyDefinition__r.NE__Source_Dynamic_Property_Id__c, OB_Componente__r.NE__Id__c, OB_Product__r.NE__Source_Product_Id__c, OB_Cab__c, OB_Hidden__c, OB_Schema_Prezzi__c, OB_ModelloAcquiring__c, OB_SelfLookup__r.NE__RequestId__c, OB_Codici__c,NE__Matrix_Parameter__r.OB_Offerta__c, OB_DynamicPropertyDefinition__c,OB_DynamicPropertyDefinition__r.Name, OB_DynamicPropertyDefinition__r.NE__Description__c, OB_Family__c, OB_Family__r.Name, OB_ReadOnly__c,OB_Read_Only_banca__c,OB_SelfLookup__c, OB_Sequence__c, id, Name, OB_Componente__r.Ne__product_name__c,OB_Componente__r.Ne__productId__c, OB_Componente__r.Ne__productId__r.Ne__description__c,NE__Matrix_Parameter__r.Name, NE__Matrix_Parameter__c, NE__Matrix_Parameter__r.NE__Start_Date__c, NE__Matrix_Parameter__r.NE__End_Date__c, NE__End_Date__c,NE__Start_Date__c, OB_Product__c, OB_Product__r.name, OB_Product__r.NE__Description__c, OB_Componente__c,OB_Massimale__c,OB_Massimo__c,OB_Minimo__c,OB_Soglia_Max_Approvazione__c,OB_Soglia_Min_Approvazione__c,OB_Valore_Default__c
                FROM NE__Matrix_Parameter_Row__c
                WHERE OB_ABI_BANCA__c = null
                AND OB_Cab__c = null
                //AND NE__Active__c = true
                AND recordType.DeveloperName = 'OB_PriceNexi'
                AND NE__Matrix_Parameter__r.OB_Offerta__c in :activeOffers
                ORDER BY NE__Matrix_Parameter__r.OB_Offerta__r.Name
        ];
        System.debug('@@@rowsToClone.size: ' + rowList.size());
        Id recordTypeBank = Schema.SObjectType.NE__Matrix_Parameter_Row__c.getRecordTypeInfosByName().get('OB_PriceBankABI').getRecordTypeId();

        //leaving NE__Matrix_Parameter__c lookup as it is..
        //Id newId = rowList[0].NE__Matrix_Parameter__c;
        //creating list of parent rows:
        List<NE__Matrix_Parameter_Row__c> parentRows = new List<NE__Matrix_Parameter_Row__c>();
        for (NE__Matrix_Parameter_Row__c parentRow : rowList) {
            if (parentRow.OB_SelfLookup__c == null) {
                Id newId = parentRow.NE__Matrix_Parameter__c;
                NE__Matrix_Parameter_Row__c newRow = parentRow.clone(false, true, false, false);
                newRow.recordTypeId = recordTypeBank;
                newRow.OB_ABI_BANCA__c = abi;
                newRow.NE__Active__c = true;
                newRow.NE__Matrix_Parameter__c = newId;
                newRow.OB_ModelloAcquiring__c = parentRow.NE__Matrix_Parameter__r.OB_ModelloAcquiring__c;
                newRow.OB_Schema_Prezzi__c = parentRow.NE__Matrix_Parameter__r.OB_SchemaPrezzi__c;
                //creating an external id composed by the externalId and matrix parameter's id:
                newRow.NE__RequestId__c += '_' + newId;
                //	francesca.ribezzi 10/04/19 setting externarlSource field to empty
                //	in order to fire SetExternalIdMatrixParamrow workflow rule:
                newRow.NE__Source_External_Id__c = '';
                parentRows.add(newRow);
            }
        }
        try {
            insert parentRows;
        } catch (Exception e) {
            System.debug('Exception OB_ABI_OffersController::cloneParametersAndRows' + e.getMessage() + ' at line: ' + e.getLineNumber());
        }

        //mappa string id, externalid
        Map<String, String> mapExternalIdrowId = new Map<String, String>();
        for (NE__Matrix_Parameter_Row__c row : parentRows) {
            mapExternalIdrowId.put(row.NE__RequestId__c, row.id);

        }

        //francesca.ribezzi: adding the current matrix parameter id to the matrix parameter row child list:
        List<NE__Matrix_Parameter_Row__c> rowsToInsert = new List<NE__Matrix_Parameter_Row__c>();
        for (Integer i = 0; i < rowList.size(); i++) {
            if (rowList[i].OB_SelfLookup__c != null) {
                Id newId = rowList[i].NE__Matrix_Parameter__c;
                NE__Matrix_Parameter_Row__c newRow = rowList[i].clone(false, true, false, false);
                //creating a new row with external id equals to parent's externalId plus matrixParameterId:
                //NE__Matrix_Parameter_Row__c parentReference = new NE__Matrix_Parameter_Row__c(NE__RequestId__c = newRow.OB_SelfLookup__r.NE__RequestId__c +'_'+ newId);
                newRow.OB_SelfLookup__c = mapExternalIdrowId.get(newRow.OB_SelfLookup__r.NE__RequestId__c + '_' + newId);
                //newRow.OB_SelfLookup__r = parentReference;
                newRow.recordTypeId = recordTypeBank;
                newRow.NE__Active__c = true;
                newRow.OB_ABI_BANCA__c = abi;
                newRow.NE__Matrix_Parameter__c = newId;
                newRow.OB_Schema_Prezzi__c = rowList[i].NE__Matrix_Parameter__r.OB_SchemaPrezzi__c;
                newRow.OB_ModelloAcquiring__c = rowList[i].NE__Matrix_Parameter__r.OB_ModelloAcquiring__c;
                //	francesca.ribezzi 10/04/19 setting externarlSource field to empty
                //	in order to fire SetExternalIdMatrixParamrow workflow rule:
                newRow.NE__Source_External_Id__c = '';
                rowsToInsert.add(newRow);
            }
        }

        System.debug('rowsToInsert: ' + rowsToInsert);
        //updating the rowlist with its matrixparameterId:
        try {
            insert rowsToInsert;
        } catch (Exception e) {
            System.debug('Exception OB_ABI_OffersController::cloneParametersAndRows' + e.getMessage() + ' at line: ' + e.getLineNumber());
        }
        //setting abi and record type bank:
        /*for(Integer i = 0; i<newRows.size(); i++){
            newRows[i].OB_ABI_BANCA__c = abi;
            newRows[i].RecordTypeId = recordTypeBank;
        }
        try {
            insert newRows;
        } catch(DmlException e) {
            System.debug('The following exception has occurred on cloneParametersAndRows method: ' + e.getMessage());
        }   */

        //return newRows;
    }


    //OfferResults class to handle active and inactive offers result:
    /* public class OfferResults {

          @AuraEnabled
          public List<NE__Bundle__c> bankOffers { get;set; }

          @AuraEnabled
          public List<NE__Bundle__c> offersToEnable { get;set; }

      }*/

}