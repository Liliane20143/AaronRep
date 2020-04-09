/**
 * Created by dilorenzo on 20/12/2018.
 */

public with sharing class Plc_WorkOrderPrintLabelCnt {

    public WorkOrder wo {get; set;}
    public List<WorkOrderLineItem> woli {get; set;}
    public String urlLogo {get; set;}

    public Plc_WorkOrderPrintLabelCnt(ApexPages.StandardController controller){
        String id = ApexPages.currentPage().getParameters().get('id');

        List<WorkOrder> workOrder = [SELECT id, Plc_Abi__c, Plc_Cti__c, Plc_CustomerCare__c FROM WorkOrder WHERE Id = :id LIMIT 1];
        wo = workOrder.get(0);

        List <ContentDocument> listLogo = [SELECT id, Title,LatestPublishedVersionId FROM ContentDocument WHERE Title =: wo.Plc_Abi__c LIMIT 1];
        
        if(!listLogo.isEmpty()){
            urlLogo = listLogo.get(0).LatestPublishedVersionId;
            System.debug('### IMG: ' + urlLogo);
        }else{
            urlLogo = '';
        }

        List<WorkOrderLineItem> workOrderLI = [SELECT id, Plc_ExternalTermId__c, LineItemNumber, WorkOrderId, Plc_TermId__r.Plc_TermIdCode__c  FROM WorkOrderLineItem WHERE WorkOrderId = :id];
        if(workOrderLI.size() > 0){
                woli = workOrderLI;
        }
        System.debug('### Size WorkOrder Line Item: ' + woli);
    }
}