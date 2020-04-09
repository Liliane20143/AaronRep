({
	objectDataMapChanges : function(component, event, helper) 
	{	
		//	WHAT WE DO EXPECT FROM THE OBJECTDATAMAP
		//-----------------------------------------------------------------------------
		// objectDataMap.messageNext.isMessage  			(true|false)
		// objectDataMap.messageNext.message  	(text)
		// objectDataMap.messageNext.severity 		(SUCCESS|WARNING|ERROR)
		//-----------------------------------------------------------------------------

		console.log('OB_BannerMessages inside');
		//	RETRIEVE OBJECTDATAMAP
		var objectDataMapTemp = component.get('v.objectDataMap');

		console.log('OB_BannerMessages dataMap ' + JSON.stringify(objectDataMapTemp));

		//	CHECK ON THE JSON IF THERE'S AN ERROR TO SHOW 	
		if (objectDataMapTemp.hasOwnProperty('messageNext'))
		{
			console.log('OB_BannerMessages messageNext');

			// component.set('v.hasMessage',true);
			// component.set('v.messagetype','ERROR');
			// component.set('v.messagetoshow',objectDataMapTemp.errorTest);
			// component.set('v.cssclasstheme','slds-theme_error');


			if (objectDataMapTemp.messageNext.message != null && objectDataMapTemp.messageNext.message != '')
			{
				component.set('v.hasMessage',true);
				component.set('v.messagetype',objectDataMapTemp.messageNext.severity);
				component.set('v.messagetoshow',objectDataMapTemp.messageNext.message);

				console.log('OB_BannerMessages severity '+objectDataMapTemp.messageNext.severity);

				switch (objectDataMapTemp.messageNext.severity)
				{
					case 'SUCCESS':				
						component.set('v.cssclasstheme','');
						break;				
					case 'ERROR':				
						component.set('v.cssclasstheme','slds-theme_error');
						break;				
					case 'WARNING':				
						component.set('v.cssclasstheme','slds-theme_warning');
						break;
				}	
			}		
		}			
	}
})