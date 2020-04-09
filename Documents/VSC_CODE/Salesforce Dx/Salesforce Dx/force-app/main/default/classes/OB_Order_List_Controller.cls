public without sharing class OB_Order_List_Controller {
	Static Reports.ReportResults results;
    Static List<String> fieldNames;

    @AuraEnabled
    public static List<Column> getColumns(String reportName, String ABI, String CAB) {
        List<Column> reportCols = new List<Column>();
        
        Id reportId  = [SELECT DeveloperName FROM Report where DeveloperName =:reportName LIMIT 1].Id;
        Reports.ReportDescribeResult describe = Reports.ReportManager.describeReport(reportId);
        Reports.ReportMetadata reportMd = describe.getReportMetadata();

        Reports.ReportFilter filter = reportMd.getReportFilters()[0];
        filter.setValue(ABI);
        fieldNames = reportMd.getDetailColumns(); 
        results = Reports.ReportManager.runReport(reportId, reportMd,true);
        
        Reports.ReportExtendedMetadata reportExtendedMetadata = results.getReportExtendedMetadata();
        Map<String, Reports.DetailColumn> detailColumnMap = reportExtendedMetadata.getDetailColumnInfo();
        for (String fieldName: fieldNames) {
		Reports.DetailColumn detailColumn = detailColumnMap.get(fieldName);
            Column fd = new Column();
            fd.fieldName = detailColumn.getName(); 
            fd.label = detailColumn.getLabel();
            fd.type = 'text';//
            fd.originalType = detailColumn.getDataType().name();
            
            reportCols.add(fd);
	    }  

        return reportCols;
    }

    class Column {
        @AuraEnabled public String label { get; set; }
        @AuraEnabled public String fieldName {get; set; }
        @AuraEnabled public String type { get; set; }
        @AuraEnabled public String originalType { get; set; }
    }

    public class tabularReportResponse {
        @AuraEnabled public List<fieldDef> reportFields {get; set;}
        @AuraEnabled public List<List<fieldData>> fieldDataList {get; set;}
        
        public tabularReportResponse(){}
        }

        public class fieldDef {
            @AuraEnabled public String fieldName {get; set;}
            @AuraEnabled public String fieldLabel {get; set;}
            @AuraEnabled public String dataType {get; set;}
            public fieldDef(){}
        }

        public class fieldData {
            @AuraEnabled public String fieldValue {get; set;}
            @AuraEnabled public String fieldLabel {get; set;}
            @AuraEnabled public String dataType  {get; set;}
            @AuraEnabled public Boolean isHyperLink {get; set;}          
            public fieldData(){isHyperLink=false;}
        }

    @AuraEnabled
    public Static tabularReportResponse getTabularReportResponse(String reportName, String ABI, String CAB) {   
    //public Static String getTabularReportResponse(String reportName, String ABI, String CAB) {
        System.debug('Entrato try/catch');
        
        Id reportId  = [SELECT DeveloperName FROM Report where DeveloperName =:reportName LIMIT 1].Id;
        tabularReportResponse trr = new tabularReportResponse();
        
        List<fieldDef> reportFields = new List<fieldDef> (); 
        List<List<fieldData>> fieldDataList = new List<List<fieldData>>();
        Reports.ReportDescribeResult describe = Reports.ReportManager.describeReport(reportId);       
        
        Reports.ReportMetadata reportMd = describe.getReportMetadata();
        
        Reports.ReportFilter filter = reportMd.getReportFilters()[0];
        filter.setValue(ABI);
        
        Reports.ReportFilter filter2 = reportMd.getReportFilters()[1];
        filter2.setValue(CAB);
        
        //get the report result
        Reports.ReportResults results = Reports.ReportManager.runReport(reportId,reportMd,true);

        //get the metadata
        Reports.ReportMetadata reportMetadata = results.getReportMetadata();

        //get a string array of the field names
        List<String> fieldNames = reportMetadata.getDetailColumns();        

        //get the extended metadata
        Reports.ReportExtendedMetadata reportExtendedMetadata = results.getReportExtendedMetadata();

        //get the map of the column names to their name and label
        Map<String, Reports.DetailColumn> detailColumnMap = reportExtendedMetadata.getDetailColumnInfo();

        //loop over the detailColumnMap and get the name, label, and data type
        for (String fieldName: fieldNames) {
            Reports.DetailColumn detailColumn = detailColumnMap.get(fieldName);
            fieldDef fd = new fieldDef();
            fd.fieldName = detailColumn.getName(); 
            fd.fieldLabel = detailColumn.getLabel();
            fd.dataType = detailColumn.getDataType().name();
            reportFields.add(fd);
        }

        // Get the fact map from the report results
        Reports.ReportFactWithDetails factDetails = (Reports.ReportFactWithDetails)results.getFactMap().get('T!T');     

        System.debug('facDetails:' + factDetails);

        List<Reports.ReportDetailRow> reportDetailRowList = factDetails.getRows();
        
        System.debug('reportDetailRowList:' + reportDetailRowList);

        //loop over the rows
        for (Reports.ReportDetailRow reportDetailRow: reportDetailRowList) {
            Integer cellCounter = 0;
            List<fieldData> fieldDataRow = new List<fieldData>();
            //loop over the cells in the row
            for (Reports.ReportDataCell reportDataCell: reportDetailRow.getDataCells()) {
                fieldData fd = new fieldData();
                fd.fieldValue = String.valueof(reportDataCell.getValue());
                fd.fieldLabel = String.valueof(reportDataCell.getLabel());
                fd.dataType = reportFields[cellCounter].dataType;
                cellCounter++;
                fieldDataRow.add(fd);
            }

            //add the row to the list
            fieldDataList.add(fieldDataRow);
        }
        
        trr.reportFields = reportFields;
        trr.fieldDataList = fieldDataList;
        return trr;
    }

    @AuraEnabled
    public static Report getReport(String reportName) {
        return [SELECT Name, Id FROM Report where DeveloperName =:reportName LIMIT 1];
         
    }

    @AuraEnabled
    public static User getAbiCabUserLogged() {
        return [SELECT Id, Account.OB_ABI__c, OB_CAB__c from user where id =: UserInfo.getUserId() LIMIT 1];         
    }

    @AuraEnabled
    public static String getSessionId() {
        System.debug(UserInfo.getSessionId());
        return UserInfo.getSessionId();         
    }
 
    @AuraEnabled
    public static User getFieldUserLogged(String columns) {
        try{ 
            //String columns = 'Id, Account.OB_ABI__c';  
            System.debug('Entrato get'+columns);
            String userId = UserInfo.getUserId();
            System.debug(userId);
            String query = 'select '+columns+' from User where id =\'' + userId+ '\' LIMIT 1';
            System.debug('query string:'+query); 
        
            User records = Database.query(query);

            /*
            List<String> listCol = columns.split(',');
            
            Set<String> fields = new Set<String>(listCol);

            for (String field : fields) {
                String[] fieldParts = field.split('.');
                field = fieldParts[fieldParts.size()-1];
            }
 
            System.debug(fields);
            
            Map<String, Schema.DescribeFieldResult> finalMap = 
            OB_Order_List_Controller.getFieldMetaData(User.getSObjectType().getDescribe(), fields);
            */
            return records;
        } catch(exception e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
            return null;
        } 
        //return [SELECT Id, Account.OB_ABI__c, OB_CAB__c from user where id =: UserInfo.getUserId() LIMIT 1];         
    }

    public static Map<String, Schema.DescribeFieldResult> getFieldMetaData(
    Schema.DescribeSObjectResult dsor, Set<String> fields) {
        // the map to be returned with the final data
        Map<String,Schema.DescribeFieldResult> finalMap = 
            new Map<String, Schema.DescribeFieldResult>();
        // map of all fields in the object
        Map<String, Schema.SObjectField> objectFields = dsor.fields.getMap();
                
        // iterate over the requested fields and get the describe info for each one. 
        // add it to a map with field name as key
        for(String field : fields){
            // skip fields that are not part of the object
            if (objectFields.containsKey(field)) {
            Schema.DescribeFieldResult dr = objectFields.get(field).getDescribe();
            // add the results to the map to be returned
            finalMap.put(field, dr); 
            }
        } 
        System.debug(finalMap);
        return finalMap;
    }
}