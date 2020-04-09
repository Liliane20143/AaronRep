/**
* Header of the class "Plc_ExportDataToCsvCnt"
* @author: Luca Belometti 
* @version 1.0
* @description: Controllor to get the data from CRM to populate the CSV File
* @testedIn: Plc_ExportDataToCsvCntTest
* @history
* Created: 2019-09-16
* Modified By: */

public class Plc_ExportDataToCsvCnt {
    //** [START MOD 2019-09-16] @Author:Luca Belometti @Description: Paramaters to query
    public transient String titleHead { get; set; }
    public transient String header { get; set; } 
    public transient String warehouseId { get; set; }
    public transient String ldnName { get; set; }
    public transient String solutionName { get; set; }
    public transient String modelId { get; set; }
    public transient String allstring { get; set; }
    public transient String  dateAndTime { get; set; }
    public transient Datetime  dateAndTimeConv { get; set; }
    //** [END MOD 2019-09-16] @Author:Luca Belometti @Description: Paramaters to query

    //** [START MOD 2019-09-16] @Author:Luca Belometti @Description: Parameters to show in the CSV File
    public transient String warehouseName { get; set; }
    public transient String ldnToShow { get; set; }
    public transient String solutionNameToShow { get; set; }
    public transient String modelName { get; set; }
    public transient String dateToShow { get; set; }
    public transient String timeToShow { get; set; }

    //** [END MOD 2019-09-16] @Author:Luca Belometti @Description: Parameteres to show in the CSV File

        public transient List<ProductStockWrp> lstwrapper { get; set; }
        public class ProductStockWrp {
        public transient String id { get; set; }
        public transient String modelName { get; set; }
        public transient String warehouse { get; set; }
        public transient String solutionName { get; set; }
        public transient String ldnName { get; set; }
        public transient Decimal stock { get; set; }
        public transient Decimal usable { get; set; }
        public transient Decimal withdrawn { get; set; }
        public transient Decimal ordered { get; set; }
        public transient Decimal reserved { get; set; }
        public transient Decimal available { get; set; }
        public transient Decimal other { get; set; }          
    }

    public void exportToExcel(){
        this.lstwrapper = new List<ProductStockWrp>();
        //** [START MOD 2019-09-16] @Author:Luca Belometti @Description: Set parameters to show header
        if (!String.isBlank(apexpages.currentpage().getparameters().get('warehouseName'))) {
            this.warehouseName = apexpages.currentpage().getparameters().get('warehouseName');            
        }
        if (!String.isBlank(apexpages.currentpage().getparameters().get('solutionName'))) {
            this.solutionNameToShow = apexpages.currentpage().getparameters().get('solutionName');            
        }   

        if (!String.isBlank(apexpages.currentpage().getparameters().get('modelName'))) {
            this.modelName = apexpages.currentpage().getparameters().get('modelName');            
        } 
        
        if (!String.isBlank(apexpages.currentpage().getparameters().get('ldnName'))) {
            this.ldnToShow = apexpages.currentpage().getparameters().get('ldnName');            
        }

        if (!String.isBlank(apexpages.currentpage().getparameters().get('dateAndTime'))) {
            this.dateAndTime = apexpages.currentpage().getparameters().get('dateAndTime');
            this.dateAndTimeConv = date.valueOf(this.dateAndTime);
            system.debug('####VALORE DATA OK: ' + this.dateAndTimeConv);
        }

        this.dateToShow = apexpages.currentpage().getparameters().get('date');
        this.timeToShow = apexpages.currentpage().getparameters().get('time');
        this.titleHead = 'StockQuantityByGivenDate' + this.dateToShow + '_' + this.timeToShow;
        //** [END MOD 2019-09-16] @Author:Luca Belometti @Description: Set parameters to show header

        //** [START MOD 2019-09-16] @Author:Luca Belometti @Description: Set parameters to Query
          
        if (!string.Isblank(apexpages.currentpage().getparameters().get('warehouseId'))) {
            this.warehouseId = apexpages.currentpage().getparameters().get('warehouseId');
        }
        
        if (!string.Isblank(apexpages.currentpage().getparameters().get('modelId'))) {
        this.modelId = apexpages.currentpage().getparameters().get('modelId');
        }
        if (!string.Isblank(apexpages.currentpage().getparameters().get('solutionName'))) {
         this.solutionName = apexpages.currentpage().getparameters().get('solutionName');
        }
       
        //** [END MOD 2019-09-16] @Author:Luca Belometti @Description: Set parameters to Query

        transient List<Bit2Shop__Product_Stock__History> prodStock = new List<Bit2Shop__Product_Stock__History>();
        transient ProductStockWrp productStockWrapper = new ProductStockWrp();
        Map<String, Object> mapProductStockHistory = new Map<String, Object>();
        transient Set<Id> sId = new Set<Id>();

            List<String> whereConditions = new List<String>();
        //** [START MOD 2019-09-18] @Author:Luca Belometti @Description: Create the dynamic query
            if (!String.isBlank(warehouseId) && !this.warehouseId.contains('undefined')) {
            whereConditions.add(' AND Parent.Bit2Shop__Warehouse_Id__c = :warehouseId ');
            }
            
            if (!String.isBlank(this.ldnToShow) && !this.ldnToShow.contains('undefined')) {
            whereConditions.add(' AND Parent.Bit2Shop__Warehouse_Id__r.Plc_LogisticDivision__c = :ldnToShow ');
            }

            if (!String.isBlank(this.solutionName) && !this.solutionName.contains('undefined') ) {
            whereConditions.add(' AND Parent.Plc_Solution__c = :solutionName ');
            }

            if (!String.isBlank(this.modelId)&& !this.modelId.contains('undefined')) {
            whereConditions.add(' AND Parent.Bit2Shop__External_Catalog_Item_Id__c = :modelId ');
            }

             if (this.dateAndTimeConv != null) {
                whereConditions.add(' AND CreatedDate <= :dateAndTimeConv ');
            }
            //** [END MOD 2019-09-18] @Author:Luca Belometti @Description: Create the dynamic query
            
            transient string allstringConditions = string.join(whereConditions,' ');
            system.debug('@@@heapsize before: '+Limits.getHeapSize());

            transient String query = 'SELECT Max(CreatedDate), Field, ParentId, Max(Id) FROM Bit2Shop__Product_Stock__History '
            +' WHERE Field IN (\'created\',\'Bit2Shop__Stock_Qty__c\', \'Plc_UsableQty__c\', \'Bit2Shop__Reserved_Qty__c\', \'Plc_WithdrawnQty__c\', \'Plc_OrderedQty__c\') ' 
            + allstringConditions + ' GROUP BY Field, ParentId';

           transient List<AggregateResult> results = Database.query(query);

            system.debug('@@@heapsize after: '+Limits.getHeapSize());

            for(AggregateResult expr1Temp:results){ 

            String expr1Value =(String)expr1Temp.get('expr1');   
            sId.add(expr1Value);          

            }
            results = null;
            system.debug('@@@heapsize after null: '+Limits.getHeapSize());

            //** [START MOD 2019-09-06] @Author:Luca Belometti @Description: QUERY 2

            
            List<String> whereConditions1 = new List<String>();

            string allstringConditions1 = string.join(whereConditions1,' ');

         transient string queryString = 'SELECT Id,Field,NewValue, ParentId,Parent.Plc_Solution__c,Parent.Bit2Shop__Warehouse_Id__r.Plc_LogisticDivision__c, '+
            'Parent.Bit2Shop__External_Catalog_Item_Id__r.B2WExtCat__External_Catalog_Item_Name__c, '+
            'Parent.Bit2Shop__Warehouse_Id__r.Name, Parent.Bit2Shop__Stock_Qty__c,Parent.Plc_UsableQty__c, '+
            'Parent.Plc_WithdrawnQty__c,Parent.Bit2Shop__Reserved_Qty__c, Parent.Plc_OrderedQty__c FROM Bit2Shop__Product_Stock__History ' +
            'WHERE Id IN :sId'; 
        //** [START MOD 2019-09-18] @Author:Luca Belometti @Description:  populate the CSV with the data found
         transient List<Bit2Shop__Product_Stock__History> lstSearchData = DataBase.Query(queryString);
         system.debug('@@@heapsize after second query: '+Limits.getHeapSize());
          transient  Map<String, productStockWrp> productStockWrpMap = new Map<String,productStockWrp>();
          if(lstSearchData.size()>0){
              for(Bit2Shop__Product_Stock__History element :lstSearchData){
                  String idProductStock = element.parentId;
                  if (!productStockWrpMap.containsKey(idProductStock)) {
                    transient ProductStockWrp productStockNew = new ProductStockWrp();
                    productStockNew.id = element.parentId;
                    productStockNew.modelName = element.Parent.Bit2Shop__External_Catalog_Item_Id__r.B2WExtCat__External_Catalog_Item_Name__c;
                    productStockNew.warehouse = element.Parent.Bit2Shop__Warehouse_Id__r.Name; 
                    productStockNew.solutionName = element.Parent.Plc_Solution__c;
                    productStockNew.ldnName = element.Parent.Bit2Shop__Warehouse_Id__r.Plc_LogisticDivision__c;
                    productStockNew.stock = 0;
                    productStockNew.usable = 0;
                    productStockNew.withdrawn = 0;
                    productStockNew.ordered = 0;
                    productStockNew.reserved = 0; 
                    productStockNew.available = 0; 
                    productStockNew.other = 0; 
                    productStockWrpMap.put(idProductStock, productStockNew);
                  }
            if (element.field == 'Plc_WithdrawnQty__c') {
               productStockWrpMap.get(idProductStock).withdrawn = (Decimal)element.NewValue;
            }

            if (element.field == 'Bit2Shop__Stock_Qty__c') {
                 productStockWrpMap.get(idProductStock).stock = (Decimal)element.NewValue;
            }

            if (element.field == 'Plc_UsableQty__c') {
                productStockWrpMap.get(idProductStock).usable = (Decimal)element.NewValue;
            }

            if (element.field == 'Plc_OrderedQty__c') {
                productStockWrpMap.get(idProductStock).ordered = (Decimal)element.NewValue;
            }

            if (element.field == 'Bit2Shop__Reserved_Qty__c') {
                productStockWrpMap.get(idProductStock).reserved = (Decimal)element.NewValue;
            }

              }      
              system.debug('##ARRIVATO ALLA FINE');
              lstSearchData = null;
              this.lstwrapper = productStockWrpMap.values();
              productStockWrpMap = null;
              List<String> lsstr = new List<String>();
              for(productStockWrp a: lstwrapper){
                lsstr.add(String.valueOf(a.ldnName) + ',' + 
                String.valueOf(a.warehouse) + ',' +
                String.valueOf(a.solutionName) + ',' +
                String.valueOf(a.modelName) + ',' +
                String.valueOf(a.stock) + ',' +
                String.valueOf(a.usable + a.withdrawn - a.reserved ) + ',' +
                String.valueOf(a.usable) + ',' +
                String.valueOf(a.withdrawn) + ',' +
                String.valueOf(a.reserved) + ',' +
                String.valueOf(a.ordered) + ',' +
                String.valueOf(a.stock - (a.usable + a.withdrawn)));
                }
              this.allstring = string.join(lsstr,'\n');
              system.debug('@@@heapsize after null second query: '+Limits.getHeapSize());
              this.header = 'Logistick Division,Warehouse,Solution,Model,Stock Quantity,Available Quantity,Usable Quantity,Withdrawn Quantity,Reserved Quantity,Ordered Quantity,Other Quantity\r\n';   
              //** [END MOD 2019-09-18] @Author:Luca Belometti @Description: populate the CSV with the data found
          }
    }
}