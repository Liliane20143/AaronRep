public with sharing class redirectToAccountDetailController {
	
	public redirectToAccountDetailController() {
		Id servicePointId = apexpages.currentpage().getparameters().get('servicePointId');
		System.debug('ServicePointId received from URL:'+servicePointId);
	}
    
    public PageReference redirect(){
    
    Id orderId = apexpages.currentpage().getparameters().get('orderId');
    Id servicePointId = apexpages.currentpage().getparameters().get('servicePointId');
    System.debug('ServicePointId received from URL:'+servicePointId);
    NE__Order__c newOrder = [SELECT ID,NE__AccountId__c from NE__Order__c where id=:orderId limit 1];
    newOrder.OB_Service_Point__c=servicePointId;
    update newOrder;
    System.debug('orderId: '+orderId);
    
        if(orderId != null){
            PageReference pageRef = new PageReference('https://nexi-payments--dev1.lightning.force.com/lightning/r/Order/'+newOrder.Id+'/view');
            return pageRef;
        }
        else{
            return null;
        }
} 

}