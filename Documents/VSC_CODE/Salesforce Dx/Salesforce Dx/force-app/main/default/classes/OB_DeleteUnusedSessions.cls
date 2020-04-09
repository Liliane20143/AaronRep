/*******************************************************************************
Purpose:  class to clean-up unused bit2win session not related to Assets - performance
Parameters: -
Returns: Boolean

History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0         enrico.purificato        23/10/2019      Created        

********************************************************************************/
global class OB_DeleteUnusedSessions implements Database.Batchable<sobject> {
  

   global Database.Querylocator start (Database.BatchableContext BC) {
      return Database.getQueryLocator('SELECT Id FROM NE__Bit2Win_Session__c WHERE OB_Valid__c= false LIMIT 10000');
   }
   

   global void execute (Database.BatchableContext BC, List<sobject> scope) {
      List<NE__Bit2Win_Session__c> sessionList = new List<NE__Bit2Win_Session__c>();

      for (sObject objScope: scope) {
         NE__Bit2Win_Session__c sessionRecord = (NE__Bit2Win_Session__c)objScope ;
         sessionList.add(sessionRecord); // Add records to the List
      }
      
      if (sessionList != null && sessionList.size()>0) {
		Database.DeleteResult[] DR_Dels = Database.delete(sessionList);
      }
   }

   global void finish(Database.BatchableContext BC) {

   }
}