global without sharing class OB_ProvinceService implements OB_PostelService
{
    
    global Map<String,String> callService(String response)
    {

    	Map<String,String> province = new Map<String,String>();
    	//HTTPResponse response = OB_UtilityCallingServices.callServiceUtil('callout:OB_Postel_Autocomplete'+url,'GET');	
        system.debug(response);
    	Dom.Document doc = new Dom.Document();
		doc.load(response);

		Dom.XmlNode rootNode = doc.getRootElement();
		for(Dom.XMLNode child : rootNode.getChildren()) 
        {
    		//system.debug(child);
		    if(child.getChildElement('nome',null)!=null && child.getChildElement('id',null)!=null)
            {
		        province.put(child.getChildElement('id',null).getText(),
                            OB_UtilityCallingServices.getUnescape(child.getChildElement('nome',null).getText())+'_'+OB_UtilityCallingServices.getUnescape(child.getChildElement('sigla',null).getText()));
            }
		    //system.debug('province'+province);       
        
        }
        return province;
    }
}