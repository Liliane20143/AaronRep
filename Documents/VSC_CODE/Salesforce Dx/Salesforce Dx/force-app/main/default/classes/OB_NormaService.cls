global class OB_NormaService implements OB_PostelService{
	global Map<String,String> callService(String url) {
        /*METODO COMMENTATO IL 22/09/2018 DA MARCO LAGO
		Map<String,String> norma = new Map<String,String>();
		//Map<String,String> postnorma = new Map<String,String>();
		HTTPResponse response = OB_UtilityCallingServices.callServiceUtil('callout:OB_Postel_Norm'+url,'GET');	
        String body = response.getBody();
        System.debug(body);
        norma.put('1', body);
        //List<String> jsonList = (List<String>)System.JSON.deserialize(body, List<String>.class);
        //norma = (Map<String,String>) JSON.deserializeUntyped(jsonList[0]);     
        //postnorma = (Map<String,String>)JSON.deserializeUntyped(norma.get('Descrizioni'));
    	//system.debug('SiglaProvincia: ' + postnorma.get('SiglaProvincia'));
    	//system.debug('ComuneUff: ' + postnorma.get('ComuneUff'));
    	//system.debug('ViaUff: ' + postnorma.get('ViaUff'));
        return norma;
    }		*/
         return null;}
}