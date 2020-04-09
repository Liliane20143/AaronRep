public class CartWrapperController {
    
    public String pref {get;set;}
    
    public CartWrapperController () {
        String servicePointId = ApexPages.currentPage().getParameters().get('servicePointId');
        System.debug('ServicePointId received into cart:'+servicePointId);
        
        pref =   Site.getSiteType();
        
    }
    
    public String getOrderIdFromUrl() {
       Id idUrl = (Id)ApexPages.currentPage().getParameters().get('accId');
       String url = (String)idUrl;
       system.debug(url);
       return url;
    }    
}