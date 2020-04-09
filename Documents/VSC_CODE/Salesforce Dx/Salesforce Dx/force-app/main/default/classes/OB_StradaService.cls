global without sharing class OB_StradaService implements OB_PostelService{
    
    global Map<String,String> callService(String response){
    	
    	Map<String,String> strada = new Map<String,String>();
    	//HTTPResponse response = OB_UtilityCallingServices.callServiceUtil('callout:OB_Postel_Autocomplete'+url,'GET');	
        system.debug(response);
    	Dom.Document doc = new Dom.Document();
		doc.load(response);
		
		Dom.XmlNode rootNode = doc.getRootElement();
        System.debug('rootNode: ' + rootNode);
		for(Dom.XMLNode child : rootNode.getChildren()) {
            System.debug('child: ' + child);
            System.debug('child.getChildElement(\'value\',null): ' + child.getChildElement('value',null));
            Integer i = 0;
    		//system.debug(child.getChildElement('listaCap',null));
		    if(child.getChildElement('value',null)!=null && child.getChildElement('key',null)!=null){
                //system.debug(child.getChildElement('value',null));
		        strada.put(child.getChildElement('key',null).getText(),child.getChildElement('value',null).getText());
		    }
         /*   if(child.getChildElement('listaCap',null)!=null ){
                Dom.XmlNode caps = child.getChildElement('listaCap',null);
                strada.put('N_CAP_'+child.getChildElement('key',null).getText(),String.valueOf(caps.getChildren().size()));
                for(Dom.XMLNode childish : caps.getChildren()) {
                    system.debug(childish.getText());
                    strada.put('CAP_'+i+'_'+child.getChildElement('key',null).getText(),childish.getText());
                    i++;
                }              
            } */
        }
        return strada;
    }

}