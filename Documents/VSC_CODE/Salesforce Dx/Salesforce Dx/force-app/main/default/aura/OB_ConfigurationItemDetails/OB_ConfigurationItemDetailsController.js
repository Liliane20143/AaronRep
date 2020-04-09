({
	doInit : function(component, event, helper)
	{
		console.log('I am in doInit');
		var action = component.get("c.getInfoConfigurationItem_apex");
    	console.log('confId before: ' + component.get("v.confId"));
        var configId = component.get("v.confId");

        var recordId = component.get("v.recordId");
        console.log('recordId after: ' + recordId);

        var confIdParam = null;
        if (recordId!=null)
        {
			confIdParam = recordId;
			component.set("v.confId",confIdParam);
        }
        else
        {
        	confIdParam = configId;
        }
        action.setParams({ confId : confIdParam}); 
        action.setCallback(this, function(response) 
        {
            var state = response.getState();
            if(state === "SUCCESS")
            {			
				//LUBRANO -- 2019-02-21 - BUGFIX ELEMENTI DUPLICATI
				// var terminals = []; 
				// var acquirings = [];
				var bundleId = ''; //francesca.ribezzi 28/11/19 - performance adding bundleId
				var map = response.getReturnValue();
				console.log('returned map: ',map); //giovanni spinelli  04/07/2019 PRODOB_45
				//davide.franzini - F2WAVE2-45 - 27/06/2019 - START
				var isCommunityUser = false;
				if(map['isCommunityUser']!=undefined){
					isCommunityUser = true;
				}
				//davide.franzini - F2WAVE2-45 - 27/06/2019 - END
				var products = [];

				for(var key in map) {
					//component.set("v.productName", key);
					var terminals = []; 
					var acquirings = [];
					var bankOrderStatus = ''; //giovanni spinelli  11/09/2019 add field
					var orderId = ''
					map[key].Terminali.forEach(function (terminal) {
						var terminalId = '';
						if(terminal.Id !== undefined){
							bundleId = terminal.NE__Bundle__c;  //francesca.ribezzi 28/11/19 - performance adding bundleId
							//terminalId = terminal.OB_Terminal_Id__c["NE__OrderId__c"];
							orderId = terminal["NE__OrderId__c"];
							bankOrderStatus = terminal["NE__OrderId__r"].OB_Bank_OrderStatus__c; //giovanni spinelli  11/09/2019 add field
							
							terminals.push({	Id: terminal["NE__ProdId__r"].Id,
												Name: terminal["NE__ProdId__r"].Name,
												TerminalId: terminalId,
												Quantity : terminal['NE__Qty__c'] //giovanni spinelli  04/07/2019 PRODOB_45

										}) ;
						}
					});
					
					map[key].Acquiring.forEach(function (acquiring) {
						//orderId = terminal["NE__OrderId__c"].Id,
						if(acquiring.Id !== undefined){
							bundleId = acquiring.NE__Bundle__c;  //francesca.ribezzi 28/11/19 - performance adding bundleId
							orderId = acquiring["NE__OrderId__c"];
							bankOrderStatus = acquiring["NE__OrderId__r"].OB_Bank_OrderStatus__c; //giovanni spinelli  11/09/2019 add field
							acquirings.push({	Id: acquiring["NE__ProdId__r"].Id,
												Name: acquiring["NE__ProdId__r"].Name}) 
						}
					});
					products.push({
						orderId: orderId,
						bankOrderStatus: bankOrderStatus, //giovanni spinelli  11/09/2019 add field
						productName: key,
						terminals: terminals,
						acquirings: acquirings,  //francesca.ribezzi 28/11/19 - performance adding bundleId
						bundleId: bundleId
					});

				}
				//giovanni spinelli start - 11/09/2019 - show price history table only if the order has specifi status
				var bankOrderStatus = products[0].bankOrderStatus;
				if(bankOrderStatus.toUpperCase() == ('Draft - rejected pricing').toUpperCase()   
				|| bankOrderStatus.toUpperCase() == ('Draft - approved pricing').toUpperCase()
				|| bankOrderStatus.toUpperCase() == ('Economic conditions aPproval').toUpperCase() ){
					component.set( "v.isCorrectOrderStatus" , true );
				}
				//giovanni spinelli end - 11/09/2019 - show price history table only if the order has specifi status

				//	micol.ferrari 15/11/2018
				var orderParameter = "lightningFromVF="+isCommunityUser+";ordId="+component.get("v.confId"); //enrico.purificato - 04/07/2019 - performance
				console.log('## orderParameter: '+orderParameter);
				component.set("v.orderParameter",orderParameter)

				console.log(products);				 
				component.set("v.products",products); 
				
			}
		    else if (state === "ERROR") 
		    {
		        var errors = response.getError();
		        if (errors) 
		        {
		            if (errors[0] && errors[0].message) 
		            {
		                console.log("Error message: " + errors[0].message);
		            }
		        } 
		        else 
		        {
		            console.log("Unknown error");
		        }
		    }
		});
		$A.enqueueAction(action);
	},

	handleCartPriceSummary : function(component, event, helper)
	{  
		component.set("v.openTechDetails",false);
		component.set("v.openPriceSummary",true);
	},

	handleTechDetail : function(component, event, helper)
	{
		component.set("v.openPriceSummary",false);
		component.set("v.openTechDetails",true);		
	},
	/**
	*@author Giovanni Spinelli <spinelli.giovanni@accenture.com>
	*@date 20/03/2018
	*@description Method returns test Account
	*@params -
	*@return Account
	*/
	showPricehistory : function(component, event, helper){
		console.log('PRODUCTS: '+JSON.stringify(component.get("v.products")) );
		var products = component.get("v.products");
		console.log('ORDER ID: ' + products[0]['orderId']);
		var orderId =  products[0]['orderId'];
		var namePos = event.getSource().get("v.name");
		var idPos   = (event.getSource().get("v.value")).split('_')[0];
		var terminalId   = (event.getSource().get("v.value")).split('_')[1];
		var offerName = products[0]['productName'];
		var bundleId = products[0]['bundleId'];  //francesca.ribezzi 28/11/19 - performance adding bundleId
		console.log('bundleId: ' + bundleId); 
		console.log('namePos: '+namePos );
		var action = component.get("c.retrievePriceHistory");
		action.setParams({ orderId : orderId , namePos : namePos , bundleId : bundleId , idPos : idPos}); 
        action.setCallback(this, function(response) 
        {
			var state = response.getState();
			console.log('state showPricehistory: ' + state);
            if(state === "SUCCESS")
            {
				try{
				var responseMap = JSON.parse(response.getReturnValue());
				var table = [];
				var numberOfTable = [];
				numberOfTable = component.get('v.numberOfTable');
				
                for (var key in responseMap) {
					console.log('key: ' + key);
					console.log('responseMap[key]: ' , responseMap[key]);
                    table.push({  key: key , value: responseMap[key] });
                }
				console.log('table is: ' , table);
				
				component.set('v.priceHistoryTable' , table);
					if (table.length > 0) {
						if (numberOfTable.length == 0) {
							numberOfTable.push({ key: namePos + ' ' + terminalId, value: table });
						} else {
							var listToCheck = [];
							for (var index = 0; index < numberOfTable.length; index++) {
								listToCheck.push(JSON.stringify(numberOfTable[index]));
							}
							if (!listToCheck.includes(JSON.stringify({ key: namePos + ' ' + terminalId, value: table }))) {
								numberOfTable.push({ key: namePos + ' ' + terminalId, value: table });
							} else {
								/**
								 * remove element form array
								 * if I click twice on button
								 * so that table disappears
								 */
								for (var j = 0; j < numberOfTable.length; j++) {
									var singleTable = JSON.stringify(numberOfTable[j]),
										objToCompare = JSON.stringify({ key: namePos + ' ' + terminalId, value: table });
									if (singleTable == objToCompare) {
										numberOfTable.splice(j, 1);
									}
								}
							}

						}

						component.set('v.numberOfTable', numberOfTable);
					}
				
				
					 
					
				
				//numberOfTable[namePos+' '+terminalId] = table;

				
				
				// table = component.get( 'v.priceHistoryTable' );
				console.log('table: '+ JSON.stringify(numberOfTable)   );
				if( table.length > 0 ){
					component.set( 'v.openPriceHistoryTable', 'OPEN TABLE');
				}else{
					
					helper.showToast('info' ,$A.get("$Label.c.OB_NoDiffPricing"));
				}
			}catch(err){
				console.log('error message: '+err.message);
			}
				
			}
			else if (state === "ERROR") 
		    {
		        var errors = response.getError();
		        if (errors) 
		        {
		            if (errors[0] && errors[0].message) 
		            {
		                console.log("Error message: " + errors[0].message);
		            }
		        } 
		        else 
		        {
		            console.log("Unknown error");
		        }
		    }
		});
		$A.enqueueAction(action);
	}
})