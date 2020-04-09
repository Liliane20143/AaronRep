/**
 * Created by ripagano on 19/04/2018.
 */

public with sharing class PicklistCmpCtrl {
  
  @AuraEnabled
  public static String getPickOpts(String sObjectType, String field, String recordTypeDevName, String controlledBy, String controlledByApiName, Boolean multipleValue, String selectedValue) {
  
    Map<String, SObjectField> fields           = null;
    List<String> selectedValues                = new List<String>();
    List<PicklistCmpCtrl.SelectOption> options = new List<PicklistCmpCtrl.SelectOption>();
    List<Schema.PicklistEntry> ple             = new List<PicklistEntry>();
    
    if(recordTypeDevName != null){
      Id rId = null;
      if (Test.isRunningTest()) {
        rId = '0121r000000nKeXAAU';
      } else {
        List<RecordType> recordTypeIds = [SELECT Id FROM RecordType WHERE Name=:recordTypeDevName];
        //options = getPickListValuesByRecordType('/services/data/v42.0/ui-api/object-info/'+sObjectType+'/picklist-values/'+recordTypeIds[0].Id+'/'+field);
        rId = recordTypeIds[0].Id;
      }
      options = getPickListValuesByRecordType(sObjectType, rId, field);
    }
  
    if(controlledBy != null && controlledByApiName != null){
      fields = Schema.getGlobalDescribe().get(sObjectType).getDescribe().fields.getMap();
      SObjectField sObjectFieldController = fields.get(controlledByApiName);
      SObjectField sObjectFieldDependent = fields.get(field);
      Map<String, List<GetDependentPicklist.PicklistEntryWrapper>> dependencyMap = GetDependentPicklist.getDependentOptionsImpl(sObjectFieldDependent, sObjectFieldController);
      //System.debug('list of options retrieved '+dependencyMap.get(controlledBy));
      if(dependencyMap.get(controlledBy).isEmpty()){
        options.clear();
      } else{
        for(GetDependentPicklist.PicklistEntryWrapper option : dependencyMap.get(controlledBy)){
          options.add(new PicklistCmpCtrl.SelectOption(option.value, option.label, false));
          }
        }
    }
    if(recordTypeDevName == null && controlledBy == null && controlledByApiName == null){
      fields = Schema.getGlobalDescribe().get(sObjectType).getDescribe().fields.getMap();
      SObjectField sObjectFieldResult = fields.get(field);
      Schema.DescribeFieldResult fieldResult = sObjectFieldResult.getDescribe();
      ple = fieldResult.getPicklistValues();
      if(fields != null){
        for (Schema.PicklistEntry p : ple) {
          options.add(new SelectOption(p.getValue(), p.getLabel(), false));
        }
      }
    }
    if(multipleValue){
      selectedValues = selectedValue.split(';');
      //System.debug('selectedValues '+selectedValues);
      for(PicklistCmpCtrl.SelectOption option : options){
        if(selectedValues.contains(option.getLabel()))
          option.Setselected(true);
      }
    }
    if(options.isEmpty()){
/*      options.add(new SelectOption('0', 'Nessun valore trovato', false));
      } else{
      return JSON.serialize(options);*/
    }
    return JSON.serialize(options);

  }
  
  @TestVisible private static List<PicklistCmpCtrl.SelectOption> getPickListValuesByRecordType(String sObjectType, String recordTypeId, String field){
  
    List<PicklistCmpCtrl.SelectOption> pickListValues = new List<PicklistCmpCtrl.SelectOption>();
    
    String url = '/services/data/v42.0/ui-api/object-info/'+sObjectType+'/picklist-values/'+recordTypeId+'/'+field;
    String cachedFileName = sObjectType+'_'+recordTypeId+'_'+field;
    
//    Check if a cachedFileAlreadyExists
    
    List<Document> cachedFile = [SELECT Id, Body FROM Document WHERE Name = :cachedFileName];
    
    if(cachedFile.size() == 0){
      
      String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
      Http http = new Http();
      HttpRequest request = new HttpRequest();
      request.setEndpoint(baseUrl+url);
      request.setHeader('Content-type', 'application/json');
      if(!Test.isRunningTest()){
        String token = Page.sessionIdGathererPage.getContent().toString().trim();
        request.setHeader('Authorization', 'OAuth ' + token);
      }
      request.setMethod('GET');
      HttpResponse response = http.send(request);
      //System.debug('response '+response);
      if (response.getStatusCode() == 200) {
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        List<Object> pippo = (List<Object>) result.get('values');
        for(Object r : pippo){
          Map<String, Object> plValue = (Map<String, Object>) r;
          pickListValues.add(new PicklistCmpCtrl.SelectOption(plValue.get('value')+'', plValue.get('label')+'', false));
        }
        
        //    Create new document record
        Id cacheFolderId = [SELECT Id FROM Folder WHERE Name = 'picklist_cache'].Id;
        insert new Document(Name = cachedFileName, Body = Blob.valueOf(response.getBody()), ContentType='text/plain', Type = 'json', FolderId = cacheFolderId);
      } else{
        //System.debug('response '+response.getStatusCode());
      }
    } else{
//      CachedFile already exists
      Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(cachedFile[0].Body.toString());
      List<Object> pippo = (List<Object>) result.get('values');
      for(Object r : pippo){
        Map<String, Object> plValue = (Map<String, Object>) r;
        pickListValues.add(new PicklistCmpCtrl.SelectOption(plValue.get('value')+'', plValue.get('label')+'', false));
      }
    }
    return pickListValues;
  }
  
  public class SelectOption {
    @AuraEnabled public String label     {get; set;}
    @AuraEnabled public String value     {get; set;}
    @AuraEnabled public Boolean selected {get; set;}
    
    public SelectOption(String value, String label, Boolean selected) {
      this.value = value;
      this.label = label;
      this.selected = selected;
    }
    
    public String getLabel(){
      return this.label;
    }
    
    public void setSelected(Boolean selected){
      this.selected = selected;
    }
  }
}