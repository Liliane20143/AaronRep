global without sharing class OB_CallService
{
	global static Map<String,String> getService (String service, String response)
	{
		String thisService = !String.isEmpty(service) ? service.toUpperCase() : '';
		switch on (thisService){
			when 'PROVINCIA'{
				OB_ProvinceService provService 	= new OB_ProvinceService();
				Map<String,String> province 	= new Map<String,String>();
				if(!Test.isRunningTest())
				{
					province = provService.callService(response);
				} 
				else 
				{
					province.put('TEST','TEST');
					province.put('TEST','TEST'); 
				}
				return province;	
			}
			when 'COMUNE'{
				Map<String,String> comune 		= new Map<String,String>();
				OB_ComuneService comuneService 	= new OB_ComuneService();
				if(!Test.isRunningTest()) 
				{				
					comune = comuneService.callService(response);
				} 
				else 
				{
					comune.put('TEST','TEST');
					comune.put('TEST','TEST');
				}
				return comune;
			}
			when 'STRADA'{
				Map<String,String> strada 		= new Map<String,String>();
				OB_StradaService stradaService 	= new OB_StradaService();
				if(!Test.isRunningTest()) 
				{				
					strada = stradaService.callService(response);
				} 
				else 
				{
					strada.put('TEST','TEST');
					strada.put('TEST','TEST');
				}
				return strada;
			}
			when 'NORMA'{
				Map<String,String> normalizzazione 	= new Map<String,String>();
				OB_NormaService normaService 		= new OB_NormaService();
				if(!Test.isRunningTest())
				{				
					normalizzazione = normaService.callService(response);
				} 
				else
				{
					normalizzazione.put('TEST','TEST');
					normalizzazione.put('TEST','TEST');
				}
				return normalizzazione;		
			} 
			when 'FRAZIONE'{
				System.debug('INTO APEX FRAZIONE');
				Map<String,String> frazione 		= new Map<String,String>();
				OB_DistrictService frazioneService 	= new OB_DistrictService();
				if(!Test.isRunningTest()) 
				{				
					frazione = frazioneService.callService(response);
					System.debug('THE FRAZIONE MAP IS: '+ frazione);
				} 
				else 
				{
					frazione.put('TEST','TEST');
					frazione.put('TEST','TEST');
				}
				return frazione;
			} 
			/*when 'RETRIEVEMERCHANT'{
				System.debug('INTO APEX RETRIEVEMERCHANT');
				Map<String,String> merchant				= new Map<String,String>();
				OB_RetrieveAnagraficaService conService = new OB_RetrieveAnagraficaService(); 
				if(!Test.isRunningTest()) 
				{			
					merchant = conService.callService(response);
					System.debug('THE RETRIEVEMERCHANT MAP IS: '+ merchant);
				} else {
					merchant.put('TEST','TEST');
					merchant.put('TEST','TEST');
				}
				return merchant;
			} 
			when 'RETRIEVESERVICEPOINT'{
				System.debug('INTO APEX RETRIEVESERVICEPOINT');
				Map<String,String> spoint				= new Map<String,String>();
				OB_RetrieveAnagraficaService conService = new OB_RetrieveAnagraficaService(); 
				if(!Test.isRunningTest())
				{				
					spoint = conService.callService(response);
					System.debug('THE RETRIEVESERVICEPOINT MAP IS: '+ spoint);
				} else {
					spoint.put('TEST','TEST');
					spoint.put('TEST','TEST');
				}
				return spoint;
			}*/
			when else
			{
				return null;		
			}
		}		
	}
}