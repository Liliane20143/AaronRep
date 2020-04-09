global without sharing class OB_ComuneService implements OB_PostelService {
	 global Map<String,String> callService(String response){
	    Map<String,String> comune = new Map<String,String>();
    	//HTTPResponse response = OB_UtilityCallingServices.callServiceUtil('callout:OB_Postel_Autocomplete'+url,'GET');	
    	Dom.Document doc = new Dom.Document();
		doc.load(response);

		Dom.XmlNode rootNode = doc.getRootElement();
		for(Dom.XMLNode child : rootNode.getChildren()) {
    		system.debug(child);
		    if(child.getChildElement('key',null)!=null && child.getChildElement('value',null)!=null){
		        comune.put(child.getChildElement('key',null).getText(),child.getChildElement('value',null).getText());
		    }
		    system.debug('comune'+comune);       
        }
        return comune;
	 }
}