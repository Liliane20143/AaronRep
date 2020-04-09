/*------------------------------------------------------------
Author:         Davide Franzini
Company:        Accenture Technology
Description:    Utility Class to Split update in order to not avoid governor limit
Inputs:         Map<String, String> relationship Map, List<NE__Matrix_Parameter_Row__c> matrix parameter rows to update with parent
History:
<Date>          <Authors Name>      <Brief Description of Change>
25/10/2019      Davide Franzini
------------------------------------------------------------*/
public class OB_CloneMPRQueueableSplit implements Queueable{
    
    private Map<String, String> relMap;
    private List<NE__Matrix_Parameter_Row__c>  matrixParameters;

    public OB_CloneMPRQueueableSplit(Map<String, String> relMap, List<NE__Matrix_Parameter_Row__c> matrixParameters){
        this.relMap = relMap;
        this.matrixParameters = matrixParameters;
    }
    
    public void execute(QueueableContext context) {
        List<NE__Matrix_Parameter_Row__c> newListOfMatrixRow = new List<NE__matrix_Parameter_Row__c>();
        try{
            for(NE__Matrix_Parameter_Row__c item : matrixParameters){
                if(item.OB_Family__c != null && item.OB_SelfLookup__c != null){
                    Id itemCompId = item.OB_Componente__c;
                    item.OB_SelfLookup__c = relMap.get(itemCompId+'_'+item.OB_Schema_Prezzi__c);
                    item.NE__Source_External_Id__c = item.Id;
                    newListOfMatrixRow.add(item);  
                }
            }
            update newListOfMatrixRow;
        }catch(Exception e){
            System.debug(LoggingLevel.ERROR, 'The following exception has occurred at line: '+e.getLineNumber()+' message : '+e.getMessage());
        }
    }
    public class OB_CloneMPRQueueableSplit_Exception extends Exception {}
}