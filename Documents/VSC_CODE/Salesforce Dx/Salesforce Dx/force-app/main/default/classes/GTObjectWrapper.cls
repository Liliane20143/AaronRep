public class GTObjectWrapper {
        
        @AuraEnabled public boolean isDefault; 
        @AuraEnabled public string GTLabel;
        
        public GTObjectWrapper(){
            isDefault = false;
            GTLabel = '';
        }
}