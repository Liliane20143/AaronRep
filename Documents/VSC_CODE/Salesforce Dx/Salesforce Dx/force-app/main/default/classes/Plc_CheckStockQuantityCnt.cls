/**
 * *************************************************
 *     * @Author nunzio.capasso@/webresults.it
 *     * @date  13/03/2019 17:18
 *     * @param
 *     * @description controller for Plc_CheckStockQuantity
 *     * @Modified by
 *   ***********************************************
 **/

public without sharing class Plc_CheckStockQuantityCnt {

    //** [START MOD 2019-09-06] @Author:Luca Belometti @Description: 
        public class ProductStockWrp {
        public String id { get; set; }
        public String modelName { get; set; }
        public String warehouse { get; set; }
        public String solutionName { get; set; }
        public String logistickDivisionName { get; set; }
        public Decimal stock { get; set; }
        public Decimal usable { get; set; }
        public Decimal withdrawn { get; set; }
        public Decimal ordered { get; set; }
        public Decimal reserved { get; set; }
        public Decimal available { get; set; }
        public Decimal other { get; set; }        
    }
    //** [END MOD 2019-09-06] @Author:Luca Belometti @Description:
    
    public static List<String> stockSerialsStatuses = new List<String>();


    /**
     * *************************************************
     *     * @Author nunzio.capasso@/webresults.it
     *     * @date  15/03/2019 16:56
     *     * @param String warehouseId
     *     * @description method called after the first lookup selection to filter the second one
     *     * @Modified by
     *   ***********************************************
     **/
    @AuraEnabled (Cacheable=true)
    public static String filterModelLookup(String warehouseId) {
        System.debug('\n\n@@@@@filterModelLookup Method Start\n\n');

        if (String.isEmpty(warehouseId)) {
            return null;
        }

        System.debug('\n\n@@@@@warehouseId: ' + warehouseId);
        try {
            Set<String> extCatItemIds = new Set<String>();

            for (Bit2Shop__Product_Stock__c ps : [
                    SELECT Id,Bit2Shop__Warehouse_Id__c,
                            Bit2Shop__External_Catalog_Item_Id__c
                    FROM Bit2Shop__Product_Stock__c
                    WHERE Bit2Shop__Warehouse_Id__c = :warehouseId
            ]) {
                if (String.isNotEmpty(ps.Bit2Shop__External_Catalog_Item_Id__c)) {
                    extCatItemIds.add(ps.Bit2Shop__External_Catalog_Item_Id__c);
                }

            }

            if (extCatItemIds.isEmpty()) {
                return '';
            }

            String stringifyCatNames = '(';
            for (String s : extCatItemIds) {
                stringifyCatNames += '\'' + s + '\',';
            }
            stringifyCatNames = stringifyCatNames.removeEnd(',');
            stringifyCatNames += ')';

            System.debug('\n\n@@@@@extCatItemNameSet: ' + extCatItemIds);
            System.debug('\n\n@@@@@stringifyCatNames: ' + stringifyCatNames);
            return stringifyCatNames;

        } catch (Exception e) {
            String errorMessage = '\n\n@@@@@filterModelLookup Error' + ' : ' + e.getCause() + ' : ' + e.getMessage() + ' : ' + e.getLineNumber() + ' : ' + e.getStackTraceString();
            System.debug(LoggingLevel.ERROR, errorMessage);
            return null;
        }

    }

    /**
     * *************************************************
     *     * @Author nunzio.capasso@/webresults.it
     *     * @date  15/03/2019 16:55
     *     * @param String warehouseId,extCatId
     *     * @description method called on "calcola" button pressed to retrive the realtive productstock
     *     * @Modified by
     *   ***********************************************
     **/
    @AuraEnabled (Cacheable=true)
    public static Object getRelativeProductStock(String warehouseId, String extCatId,String solutionName,String logistickDivisionId) {
        System.debug('\n\n@@@@@getRelativeProductStock Method Start\n\n');

        if (String.isEmpty(warehouseId) || String.isEmpty(extCatId)) {
            return null;
        }
        try {

            //** [END MOD 2019-08-20] @Author:Luca Belometti @Description: ORIGINAL QUERY

            //** [START MOD 2019-08-20] @Author:Luca Belometti @Description: Query modified - Luca Belometti */

            List<String> whereConditions = new List<String>();
            if (String.isNotBlank(logistickDivisionId)) {
            whereConditions.add(' AND Bit2Shop__Warehouse_Id__r.Plc_LogisticDivision__c = :logistickDivisionId ');
            }
            if (String.isNotBlank(solutionName)) {
            whereConditions.add(' AND Plc_Solution__c = :solutionName ');
            }
            if (String.isNotBlank(extCatId)) {
            whereConditions.add(' AND Bit2Shop__External_Catalog_Item_Id__c = :extCatId ');
            }
            //system.debug('###DEBUG DELLA LISTA WHERECONDITIONS: '+whereConditions);
            string allstringConditions = string.join(whereConditions,' ');
            //system.debug('###DEBUG DELLA LISTA WHERECONDITIONS2: '+allstringConditions);
  
            String query = 'SELECT Id,Plc_Solution__c FROM Bit2Shop__Product_Stock__c WHERE Bit2Shop__Warehouse_Id__c = :warehouseId ' + allstringConditions; 
            Bit2Shop__Product_Stock__c productStock  = Database.query(query);
            //system.debug('La query è la seguente: '+sobjList)
            
            //** [END MOD 2019-08-20] @Author:Luca Belometti @Description: Query modified - Luca Belometti */

            System.debug('\n\n@@@@@productStock: ' + productStock);
            return productStock;
        } catch (Exception e) {
            String errorMessage = '\n\n@@@@@getRelativeProductStock Method Error' + ' : ' + e.getCause() + ' : ' + e.getMessage() + ' : ' + e.getLineNumber() + ' : ' + e.getStackTraceString();
            System.debug(LoggingLevel.ERROR, errorMessage);
            return null;
        }
    }

    @AuraEnabled (Cacheable=true)
    public static Object getRelativeWarhouseAndModel(String prodstockId) {
        System.debug('\n\n@@@@@getRelativeWarhouseAndModel Method Start\n\n');

        if (String.isEmpty(prodstockId)) {
            return null;
        }
        try {
            Bit2Shop__Product_Stock__c productStock = [
                    SELECT Id,Bit2Shop__External_Catalog_Item_Id__r.B2WExtCat__External_Catalog_Item_Name__c,Bit2Shop__Warehouse_Id__r.Name,
                    //** [START MOD 2019-08-21] @Author:Luca Belometti @Description: Added 2 new Fields in the init query */
                    Bit2Shop__Warehouse_Id__r.Plc_LogisticDivision__c,Plc_Solution__c,Plc_AvailableQty__c
                    //** [END MOD 2019-08-21] @Author:Luca Belometti @Description: Added 2 new Fields in the init query */
                    FROM Bit2Shop__Product_Stock__c
                    WHERE Id = :prodstockId
            //][0];
            ];
            System.debug('\n\n@@@@@productStock: ' + productStock);
            return productStock;
        } catch (Exception e) {
            String errorMessage = '\n\n@@@@@getRelativeWarhouseAndModel Method Error' + ' : ' + e.getCause() + ' : ' + e.getMessage() + ' : ' + e.getLineNumber() + ' : ' + e.getStackTraceString();
            System.debug(LoggingLevel.ERROR, errorMessage);
            return null;
        }
    }

//** [START MOD 2019-09-06] @Author:Luca Belometti @Description: 

    @AuraEnabled

        public static String getData1(String warehouseId, String externalCatalogItemId, String logistickDivision, String solutionName, Datetime inputDate) {

        System.debug('\n\n@@@@@getData Method Start\n\n');

        List<Bit2Shop__Product_Stock__History> prodStock = new List<Bit2Shop__Product_Stock__History>();
        //InputWrapper context = new InputWrapper();
        ProductStockWrp productStockWrapper = new ProductStockWrp();
        Map<String, Object> mapProductStockHistory = new Map<String, Object>();
        Set<Id> sId = new Set<Id>();

        try{
            stockSerialsStatuses = getPicklistOptions('Bit2Shop__Status__c', 'Bit2Shop__Stock_Serials2__c');
            System.debug('\n\n@@@@@inputDate: ' + inputDate);

            List<String> whereConditions = new List<String>();

            if (String.isNotBlank(warehouseId)) {
            system.debug('##VALORE DEL WAREHOUSEID: '+warehouseId);
            whereConditions.add(' AND Parent.Bit2Shop__Warehouse_Id__c = :warehouseId ');                
            }
            if (String.isNotBlank(logistickDivision)) {
            system.debug('##VALORE DEL LOGISTICKDIVISION: '+logistickDivision);
            whereConditions.add(' AND Parent.Bit2Shop__Warehouse_Id__r.Plc_LogisticDivision__c = :logistickDivision ');
            }
            if (String.isNotBlank(solutionName)) {
            system.debug('##VALORE DEL solutionName: '+solutionName);   
            whereConditions.add(' AND Parent.Plc_Solution__c = :solutionName ');
            }
            if (String.isNotBlank(externalCatalogItemId)) {
            system.debug('##VALORE DEL externalCatalogItemId: '+externalCatalogItemId);   
            whereConditions.add(' AND Parent.Bit2Shop__External_Catalog_Item_Id__c = :externalCatalogItemId ');
            }
            if (inputDate != null) {
            whereConditions.add(' AND CreatedDate <= :inputDate ');                
            }
            
            string allstringConditions = string.join(whereConditions,' ');
            

  
            String query = 'SELECT Max(CreatedDate), Field, ParentId, Max(Id) FROM Bit2Shop__Product_Stock__History '
            +' WHERE Field IN (\'created\',\'Bit2Shop__Stock_Qty__c\', \'Plc_UsableQty__c\', \'Bit2Shop__Reserved_Qty__c\', \'Plc_WithdrawnQty__c\', \'Plc_OrderedQty__c\') ' 
            + allstringConditions + ' GROUP BY Field, ParentId LIMIT 2000';
            system.debug('##### QUERY STAMPATA: '+query);
            //prodStock = Database.query(query);

            List<AggregateResult> results = Database.query(query);

            for(AggregateResult expr1Temp:results){ 

            String expr1Value =(String)expr1Temp.get('expr1');   
            sId.add(expr1Value);          

            }

            system.debug('###SET ID: '+sId);
            system.debug('### prodStock LISTA TO CHECK HISTORY! ! !: '+prodStock);


            //** [START MOD 2019-09-06] @Author:Luca Belometti @Description: QUERY 2

            
            List<String> whereConditions1 = new List<String>();

            //system.debug('###DEBUG DELLA LISTA whereConditions1: '+whereConditions1);
            string allstringConditions1 = string.join(whereConditions1,' ');
            //system.debug('###DEBUG DELLA LISTA whereConditions12: '+allstringConditions1);
  
            String query1 = 'SELECT Id,Field,NewValue, ParentId,Parent.Plc_Solution__c,Parent.Bit2Shop__Warehouse_Id__r.Plc_LogisticDivision__c, '+
            'Parent.Bit2Shop__External_Catalog_Item_Id__r.B2WExtCat__External_Catalog_Item_Name__c, '+
            'Parent.Bit2Shop__Warehouse_Id__r.Name, Parent.Bit2Shop__Stock_Qty__c,Parent.Plc_UsableQty__c, '+
            'Parent.Plc_WithdrawnQty__c,Parent.Bit2Shop__Reserved_Qty__c, Parent.Plc_OrderedQty__c FROM Bit2Shop__Product_Stock__History '+
            'WHERE Id IN :sId'; 
            system.debug('### warehouseId: '+warehouseId);
            system.debug('### solutionName: '+solutionName);
            system.debug('##### query1 STAMPATA: '+query1);
            prodStock = Database.query(query1);
            system.debug('### PRODSTOCK LISTA TO CHECK: '+JSON.serializePretty(prodStock[0]));
            system.debug('###SIZE DEL CONTROLLO DEL RISULTATO DELLA QUERY: '+prodStock.size());
            
            Map<String, productStockWrp> productStockWrpMap = new Map<String,productStockWrp>();

            for (Bit2Shop__Product_Stock__History element : prodStock) {
                String idProductStock = element.parentId;
                if (!productStockWrpMap.containsKey(idProductStock)) {
                    ProductStockWrp productStockNew = new ProductStockWrp();
                    productStockNew.id = idProductStock;
                    productStockNew.modelName = element.Parent.Bit2Shop__External_Catalog_Item_Id__r.B2WExtCat__External_Catalog_Item_Name__c;        
                    productStockNew.warehouse = element.Parent.Bit2Shop__Warehouse_Id__r.Name; 
                    productStockNew.solutionName = element.Parent.Plc_Solution__c;
                    productStockNew.logistickDivisionName = element.Parent.Bit2Shop__Warehouse_Id__r.Plc_LogisticDivision__c;
                    productStockNew.stock = 0;
                    productStockNew.usable = 0;
                    productStockNew.withdrawn = 0;
                    productStockNew.ordered = 0;
                    productStockNew.reserved = 0; 
                    productStockNew.available = 0; 
                    productStockNew.other = 0; 
                    productStockWrpMap.put(idProductStock, productStockNew);
                }

            system.debug('ELEMENTO PROCESSATO: '+element.field);
                
            if (element.field == 'Plc_WithdrawnQty__c') {
                productStockWrpMap.get(idProductStock).withdrawn = (Decimal)element.NewValue;
            }

            if (element.field == 'Bit2Shop__Stock_Qty__c') {
                system.debug('###2');
                productStockWrpMap.get(idProductStock).stock = (Decimal)element.NewValue;
            }

            if (element.field == 'Plc_UsableQty__c') {
                system.debug('###VALORE Usable: '+(Decimal)element.NewValue);
                productStockWrpMap.get(idProductStock).usable = (Decimal)element.NewValue;
            }

            if (element.field == 'Plc_OrderedQty__c') {
                productStockWrpMap.get(idProductStock).ordered = (Decimal)element.NewValue;
            }

            if (element.field == 'Bit2Shop__Reserved_Qty__c') {
                productStockWrpMap.get(idProductStock).reserved = (Decimal)element.NewValue;
                system.debug('###VALORE RESERVED: '+(Decimal)element.NewValue);
            }
          /*  if (element.field == 'Plc_AvailableQty__c') {
                productStockWrpMap.get(idProductStock).reserved = (Decimal)element.NewValue;
                system.debug('##### VALORE DI AVAILABLE: ' +  );
            }*/

            }
            system.debug('####JSON DELLA MAPPA STAMPATA: '+JSON.serialize(productStockWrpMap));

            return JSON.serialize(productStockWrpMap);


            //** [END MOD 2019-09-06] @Author:Luca Belometti @Description: QUERY 2

        } catch (Exception e) {
            String errorMessage = '@@@@@getData Error' + ' : ' + e.getCause() + ' : ' + e.getMessage() + ' : ' + e.getLineNumber() + ' : ' + e.getStackTraceString();
            System.debug(LoggingLevel.ERROR, errorMessage);
            system.debug('### PRODSTOCK LISTA TO CHECK: '+prodStock);
            //throw new Plc_Exception(errorMessage);
            return null;
        }

    }

//** [END MOD 2019-09-06] @Author:Luca Belometti @Description:


//** [START MOD 2019-09-09] @Author:Luca Belometti @Description: 
     private static Object getListNameModelWrp(ProductStockWrp productStockWrapper) {
        System.debug('\n\n@@@@@getReservationQuantity-start ');
        try {
            String valoreDiRitorno = productStockWrapper.modelName;

            if (valoreDiRitorno == '') {
                System.debug('\n\n@@@@@valoreDiRitornoIsEmpty.returning 0');
                return null;
            }
            System.debug('\n\n@@@@@valoreDiRitorno.newValue: ' + valoreDiRitorno); //valoreDiRitorno[0].NewValue);
            return valoreDiRitorno; //productStockHistory[0].NewValue;

        } catch (Exception e) {
            String errorMessage = '\n\n@@@@@getReservationQuantity Error' + ' : ' + e.getCause() + ' : ' + e.getMessage() + ' : ' + e.getLineNumber() + ' : ' + e.getStackTraceString();
            System.debug(LoggingLevel.ERROR, errorMessage);
            return null;
        }
    }
//** [END MOD 2019-09-09] @Author:Luca Belometti @Description:

//** [START MOD 2019-09-09] @Author:Luca Belometti @Description: 

    @AuraEnabled(Cacheable=true)
    public static List<String> getPicklistOptions(String fieldName, String sObjectName) {
        List<String> options = new List<String>();

        try {
            Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
            Schema.SObjectType sobjType = gd.get(sObjectName);
            Schema.DescribeSObjectResult r = sobjType.getDescribe();
            Map<String, Schema.SObjectField> fieldMap = r.fields.getMap();
            List<Schema.PicklistEntry> picklistValues = fieldMap.get(fieldName).getDescribe().getPicklistValues();

            for (Schema.PicklistEntry f : picklistValues) {
                options.add(f.getValue());
            }

            System.debug('PicklistOptions: ' + options);
            return options;
        } catch (Exception e) {
            String errorMessage = '\n\n@@@@@getPicklistOptions Error' + ' : ' + e.getCause() + ' : ' + e.getMessage() + ' : ' + e.getLineNumber() + ' : ' + e.getStackTraceString();
            System.debug(LoggingLevel.ERROR, errorMessage);
            return null;
        }
    }

}