({
	handleClick: function(component, event , helper)
    {    
        const resultNull =  '{}' //DA CAMBIARE QUANDO AVREMO IL SERVIZIO
	    //FIRST CALL THE SERVICE AND AFTER THE SALESFORCE QUERY
        //START
        //var objectDataMap = component.get("v.objectDataMap");
		var idServicePoint = component.get("v.recordId");
		console.log('Service Point id: '+ idServicePoint);

		helper.getMerchantFromService(component, 'RSSNDR80A01F205O')

		console.log('dopo get Service Point');
		//helper.getMerchantFromService(component, 'VRDFNC90P01D969G','02895590962');
		//console.log(component.get("v.responseMerchant"));
		helper.getServicePoint(component, idServicePoint);
		console.log("VAT: "+component.get("v.VAT"));	
		$A.get('e.force:refreshView').fire();
		/*
		var FC = acc['NE__Fiscal_code__c'];
		var VAT = acc['NE__VAT__c'];
		console.log('FC: '+FC);
		consolo.log('VAT: '+VAT);
		helper.getMerchantFromService(component, FC, VAT);
		
		setTimeout(function(){
			$A.get("e.force:closeQuickAction").fire();  
		}, 1000);
		*/		
		
	}
})