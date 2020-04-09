({
    prepareData:function(component,tmpContext){
        //davide.franzini - 16/09/2019 - WN-190 - passing context stringified and parsing in object
        //also removed prepareData2 and flatProducts as deprecated functions
        var context = JSON.parse(tmpContext);
        var configuration = context.configuration;
        configuration.OB_ApprovalLevel__c = component.get("v.priceApprovalLevel"); //francesca.ribezzi 26/11/19 - performance - adding approval level 
        var bundles = context.cart.filter(function(element){
            return element.fields.RecordTypeName == "Tariff_Plan";
        });
        var products = context.cart.filter(function(element){
            return element.fields.RecordTypeName != "Tariff_Plan";
        });

        if(configuration.ob_main_process =='Setup'){
            return this.createBundle(component,bundles,products,configuration);  
        }

        var wait = function(ms)
        {
            var start = new Date();
            var end = null;
            do 
            { 
                end = new Date(); 
            }
            while(end-start < ms);
        }
        
		var endTime = Number(new Date()) + 5000;
        while(!(component.get("v.asset2OrderDone") || Number(new Date()) > endTime))
        {
            wait(100);
            if(Number(new Date()) > endTime)
            {
                return Promise.reject(new Error("unknown error Asset2Order" ));
            }
        }

        return this.getConfigurationItems(component, configuration, bundles, products)
            .then(function(res){
                 var fnArray = [];
                 fnArray.push(this.removeItems(res));
                 fnArray.push(this.updateAttributes(res));
                 fnArray.push(this.updateItems(res));//davide.franzini - CheckOut Item Update Fix - 25/07/2019
                 fnArray.push(this.insertChildProducts(res));
                 return Promise.all(fnArray)
            }.bind(this)).then(
                function(res){
                    return Promise.resolve(res[0])
               }
            );
        
    },

    getConfigurationItems:function(component, configuration, bundles, products) {
         var generateItemMap = function(itemRecords){
            var finalMap = {};

            for(var key in itemRecords)
            {   
                var assetEnterpriseId = itemRecords[key].NE__AssetItemEnterpriseId__c;
                finalMap[assetEnterpriseId]={};
                finalMap[assetEnterpriseId].attributes = {};
                finalMap[assetEnterpriseId].orderItemId = key;
                finalMap[assetEnterpriseId].parent = "";
                if(itemRecords[key].NE__Parent_Order_Item__r != undefined)
                {
                    finalMap[assetEnterpriseId].parent = itemRecords[key].NE__Parent_Order_Item__r.Id;
                }
                if(itemRecords[key].NE__Order_Item_Attributes__r != undefined)
                {
                    for(var i = 0; i < itemRecords[key].NE__Order_Item_Attributes__r.length; i++ )
                    {
                        var currentAttribute = itemRecords[key].NE__Order_Item_Attributes__r[i];
                        finalMap[assetEnterpriseId].attributes[currentAttribute.NE__AttrEnterpriseId__c] = currentAttribute.Id;

                    }
                }

            }
            return finalMap; 
        }

        var mapIds = function(items,idMap) 
        {
            for(var j=0; j < items.length; j++){
                if(items[j].fields.assetitementerpriseid == undefined)
                {
                    continue;
                }
                items[j].fields.orderitemid = idMap[items[j].fields.assetitementerpriseid].orderItemId;
                items[j].fields.parent = idMap[items[j].fields.assetitementerpriseid].parent;
                for(var i=0; i<items[j].listOfAttributes.length;i++)
                {
                    //elena.preteni perf-53 12/12/2019
                    items[j].listOfAttributes[i].fields.idLineAttribute = idMap[items[j].fields.assetitementerpriseid].attributes[items[j].listOfAttributes[i].fields.enterpriseId];
                    items[j].listOfAttributes[i].fields.lineId = items[j].fields.orderitemid;
                    //elena.preteni perf-53 12/12/2019
                }
                if(items[j].childItems.length>0)
                {
                    mapIds(items[j].childItems,idMap);
                }
            }
            
        }

        var flatProducts = function(prod) {
            var finalArray = [];
            for(var i=0; i<prod.length;i++){
                if(prod[i].childItems.length>0){
                    finalArray = finalArray.concat(flatProducts(prod[i].childItems));
                }
                finalArray.push(prod[i]);
            }
            return finalArray;
        }

 		var newChilds = function(prod,parentItemId=null) {
            var finalArray = [];
            for(var i=0; i<prod.length;i++){
                if(prod[i].childItems.length>0){
                    finalArray = finalArray.concat(newChilds(prod[i].childItems,prod[i].fields.orderitemid));
                }
                if(prod[i].fields.orderitemid =='' && prod[i].fields.parentvid !=''){
                	prod[i].fields.parentItemId = parentItemId;
                	finalArray.push(prod[i]);
                }
                
            }
            return finalArray;
        }

        return new Promise($A.getCallback(function(resolve, reject){
			try{
                var confString =  JSON.stringify(configuration);
				var action = component.get("c.getConfigurationItemServer");
				action.setParams({ configuration : confString});
				action.setCallback(this, function(response){
				
				try{
                    if(response.getState() === 'SUCCESS'){
                        
                        //enrico.purificato 25/10/2019 performance START
                        var orderItemMap = response.getReturnValue();

                        var idMap = generateItemMap(orderItemMap);
                        var itemList = Object.keys(orderItemMap);
                        var bundleId = idMap[bundles[0].fields.assetitementerpriseid].orderItemId;
                        itemList = itemList.filter(x => x!=bundleId);
                
						mapIds(products,idMap);
                        //enrico.purificato 25/10/2019 performance END

                        var newItemList = [];
                    	var changedAttributes = [];
                    	var newChildProducts= [];
                    	var newCPProducts 	= [];
                        var updatedLineItem = [];   //davide.franzini - CheckOut Item Update Fix - 25/07/2019

                      	for(var i=0;i<products.length;i++){

							var itemId = products[i].fields.orderitemid;
							var parentItemId = products[i].fields.parentvid;

							if(itemId =='' && parentItemId==''){
								newCPProducts.push(products[i]);
							}
                    	}  
						products 	= products.filter(x => !newCPProducts.includes(x));

						newChildProducts = newChilds(products);
                    	
                    	var flatProductList = flatProducts(products);
						flatProductList = flatProductList.filter(x => !newChildProducts.includes(x));
                        
                        console.log('## orderItemMap: ', orderItemMap); //davide.franzini - CheckOut Item Update Fix - 25/07/2019

                    	for(var i=0;i<flatProductList.length;i++){
                    		var itemId = flatProductList[i].fields.vid;
                    		var parentItemId = flatProductList[i].fields.parent;
                    		var orderItemId = flatProductList[i].fields.orderitemid;

							if(!$A.util.isEmpty(orderItemId)){
                                newItemList.push(orderItemId);
                                //davide.franzini - CheckOut Item Update Fix - 25/07/2019 - START
                                var currItem = orderItemMap[orderItemId];
                                for(var key in flatProductList[i].fields){
                                    if(key.startsWith('OB_')){
                                        if(currItem[key] != undefined){
                                            if(!$A.util.isEmpty(flatProductList[i].fields[key]) && flatProductList[i].fields[key] != currItem[key]){
                                                updatedLineItem.push(flatProductList[i]);
                                                break;
                                            }
                                        }
                                        if(!$A.util.isEmpty(flatProductList[i].fields[key]) && currItem[key] == undefined){
                                            updatedLineItem.push(flatProductList[i]);
                                            break;
                                        }
                                    }
                                }
                                //davide.franzini - CheckOut Item Update Fix - 25/07/2019 - END
								for(var j = 0;j<flatProductList[i].listOfAttributes.length;j++){
									var currentAttr = flatProductList[i].listOfAttributes[j];
									if(currentAttr.fields.value != currentAttr.fields.Old_Value__c){
										changedAttributes.push(currentAttr);
									}	
									
								}
							}
                    	}  
             			
             			var removedItems = itemList.filter(x => !newItemList.includes(x));

                        var res = { configuration: configuration,
                                    component: component,
                                    bundleId: bundleId,
                                    removedItems: removedItems,
                                    changedAttributes: changedAttributes,
                                    updatedLineItem: updatedLineItem, //davide.franzini - CheckOut Item Update Fix - 25/07/2019
                                    products: newCPProducts,
                                    newChildProducts: newChildProducts,
                                    configuration: configuration
                                    };

                                resolve(res);  
					   } else {
                            var errors = response.getError();
                            if (errors) {
                                if (errors[0] && errors[0].message) {
                                    reject(new Error("createBundle Error message: " +errors[0].message));
                                }
                            } else {
                                reject(reject(new Error("createBundle Error message: Unknown error" )));
                            }   
					   }
                }catch(error){
                    console.log(error);
                    reject(error);
                }

				}.bind(this));
				$A.enqueueAction(action);
			}catch(error){
			   	console.log(error);
			   	reject(error);
			}
		 
		 }));
    },

    removeItems: function(req) {
        var component= req.component;
        var removedItems = req.removedItems;

		if(removedItems.length==0){
            console.log('@@@ no items to remove');
            return Promise.resolve(req);
        }


		return new Promise($A.getCallback(function(resolve, reject){
			try{
				var action = component.get("c.removeItemServer");
				action.setParams({ itemList : removedItems, confId: req.configuration.id});
				action.setCallback(this, function(response){
				try{
                    if(response.getState() === 'SUCCESS' && response.getReturnValue()){
                        resolve(req);  
					   } else {
                            var errors = response.getError();
                            if (errors) {
                                if (errors[0] && errors[0].message) {
                                    reject(new Error("createBundle Error message: " +errors[0].message));
                                }
                            } else {
                                reject(reject(new Error("createBundle Error message: Unknown error" )));
                            }   
					   }
                }catch(error){
                    console.log(error);
                    reject(error);
                }

				});
				$A.enqueueAction(action);
			}catch(error){
			   	console.log(error);
			   	reject(error);
			}
		 
		 }));
    },

    updateAttributes: function(req) {
        var component = req.component;
        var updatedAttributes = req.changedAttributes;

		if(updatedAttributes.length==0){
            console.log('@@@ no attributes to update');
            return Promise.resolve(req);
        }

		return new Promise($A.getCallback(function(resolve, reject){
			try{
				var action = component.get("c.updateAttributesServer");
				action.setParams({ attributesList : JSON.stringify(updatedAttributes), confId: req.configuration.id});
				action.setCallback(this, function(response){
				try{
                    if(response.getState() === 'SUCCESS' && response.getReturnValue()){
                        resolve(req);  
					   } else {
                            var errors = response.getError();
                            if (errors) {
                                if (errors[0] && errors[0].message) {
                                    reject(new Error("createBundle Error message: " +errors[0].message));
                                }
                            } else {
                                reject(reject(new Error("createBundle Error message: Unknown error" )));
                            }   
					   }
                }catch(error){
                    console.log(error);
                    reject(error);
                }

				});
				$A.enqueueAction(action);
			}catch(error){
			   	console.log(error);
			   	reject(error);
			}
		 
		 }));
    },

    //davide.franzini - CheckOut Item Update Fix - 25/07/2019 - START
    updateItems: function(req) {
        var component = req.component;
        var updateItems = req.updatedLineItem;

		if(updateItems.length==0){
            console.log('@@@ no attrinutes to update');
            return Promise.resolve(req);
        }

		return new Promise($A.getCallback(function(resolve, reject){
			try{
				var action = component.get("c.updateItemsServer");
				action.setParams({ itemList : JSON.stringify(updateItems), confId: req.configuration.id});
				action.setCallback(this, function(response){
				try{
                    if(response.getState() === 'SUCCESS' && response.getReturnValue()){
                        resolve(req);  
					   } else {
                            var errors = response.getError();
                            if (errors) {
                                if (errors[0] && errors[0].message) {
                                    reject(new Error("createBundle Error message: " +errors[0].message));
                                }
                            } else {
                                reject(reject(new Error("createBundle Error message: Unknown error" )));
                            }   
					   }
                }catch(error){
                    console.log(error);
                    reject(error);
                }

				});
				$A.enqueueAction(action);
			}catch(error){
			   	console.log(error);
			   	reject(error);
			}
		 
		 }));
    },
    //davide.franzini - CheckOut Item Update Fix - 25/07/2019 - END

    insertChildProducts: function(req) {
        var component = req.component;
        var newChildProducts = req.newChildProducts;

		if(newChildProducts.length==0){
            console.log('@@@ no child items to insert');
            return Promise.resolve(req);
        }


		return new Promise($A.getCallback(function(resolve, reject){
			try{
				var action = component.get("c.insertChildProductsServer");
				action.setParams({ productList : JSON.stringify(newChildProducts),configuration: JSON.stringify(req.configuration) ,bundleId: req.bundleId});
				action.setCallback(this, function(response){
				try{
                    if(response.getState() === 'SUCCESS' && response.getReturnValue()){
                        resolve(req);  
					   } else {
                            var errors = response.getError();
                            if (errors) {
                                if (errors[0] && errors[0].message) {
                                    reject(new Error("createBundle Error message: " +errors[0].message));
                                }
                            } else {
                                reject(reject(new Error("createBundle Error message: Unknown error" )));
                            }   
					   }
                }catch(error){
                    console.log(error);
                    reject(error);
                }

				});
				$A.enqueueAction(action);
			}catch(error){
			   	console.log(error);
			   	reject(error);
			}
		 
		 }));
    },

    createBundle: function(component, bundles, products, configuration) {
		
		return new Promise($A.getCallback(function(resolve, reject){
			try{
				var action = component.get("c.createBundleServer");
				action.setParams({ bundle : JSON.stringify(bundles[0]) , configuration: JSON.stringify(configuration)});
				action.setCallback(this, function(response){
				try{
                    if(response.getState() === 'SUCCESS'){
                        var res = { component: component,
                                    bundleId: response.getReturnValue(),
                                    products: products,
                                    configuration: configuration
                                    };
                        resolve(res);  
					   } else {
                            var errors = response.getError();
                            if (errors) {
                                if (errors[0] && errors[0].message) {
                                    reject(new Error("createBundle Error message: " +errors[0].message));
                                }
                            } else {
                                reject(reject(new Error("createBundle Error message: Unknown error" )));
                            }   
					   }
                }catch(error){
                    console.log(error);
                    reject(error);
                }

				});
				$A.enqueueAction(action);
			}catch(error){
			   	console.log(error);
			   	reject(error);
			}
		 
		 }));
	  },
    createComplexProductBatch: function(component, bundId, products, configuration) {
        
        var LINE_ITEM_LIMIT = 200;

        var splitObject= function(singleItem){
            var tmpArray = [];
            let currItem = JSON.parse(JSON.stringify(singleItem));
            let itemCode = currItem.fields.itemCode;
            let weigth =  currItem.childItems.length + 1;
            let targetQty = Math.max(Math.floor(LINE_ITEM_LIMIT/weigth),1);
            let quotient = Math.floor(currItem.fields.qty/targetQty);
            let remainder = currItem.fields.qty - (quotient*targetQty) ;

            for(let j= 1; j<= quotient;j++){
                let newPOS1 = JSON.parse(JSON.stringify(currItem));
                newPOS1.fields.itemCode = j+'|'+itemCode;
                newPOS1.fields.qty = targetQty;
                newPOS1.childItems = newPOS1.childItems.map(function(element){
                    element.fields.itemCode = j+'|'+element.fields.itemCode;
                    return element;
                });
                let complexity = (newPOS1.fields.qty * newPOS1.childItems.length) + newPOS1.fields.qty;
                let tmpObj = {};
                tmpObj[complexity] = newPOS1;
                tmpArray.push(tmpObj);
            }
            if(remainder > 0){
                quotient = quotient+1;
                let newPOS2 = JSON.parse(JSON.stringify(currItem));
                newPOS2.fields.itemCode = quotient +'|'+itemCode;
                newPOS2.fields.qty = remainder;
                newPOS2.childItems = newPOS2.childItems.map(function(element){
                    element.fields.itemCode = quotient+'|'+element.fields.itemCode;
                    return element;
                });
                let complexity = (newPOS2.fields.qty * newPOS2.childItems.length) + newPOS2.fields.qty;
                let tmpObj = {};
                tmpObj[complexity] = newPOS2;
                tmpArray.push(tmpObj);
            }
            return tmpArray;
        }

        var convertToObjectArray=function(itemList){
            var tmpArray = [];
            for(let i = 0 ; i< itemList.length;i++){
                let currItem = JSON.parse(JSON.stringify(itemList[i]));
                let complexity = (currItem.fields.qty * currItem.childItems.length) + currItem.fields.qty;
                if(complexity < LINE_ITEM_LIMIT || currItem.fields.qty <= 1){
                    let tmpObj = {};
                    tmpObj[complexity] = currItem;
                    tmpArray.push(tmpObj);
                    continue;
                }
                tmpArray = tmpArray.concat(splitObject(currItem));
            }
            return tmpArray;
        }

        // var splitUgePos = function(posList){
        //     let targetQty = 10;
        //     let finalList = [];
        //     for(let i = 0 ; i< posList.length;i++){
        //         let currPos = JSON.parse(JSON.stringify(posList[i]));
        //         let itemCode = currPos.fields.itemCode;
        //         if(currPos.fields.qty > targetQty ){
        //             var quotient = Math.floor(currPos.fields.qty/targetQty);
        //             var remainder = currPos.fields.qty % targetQty;
        //             for(let j= 1; j<= quotient;j++){
        //                 let newPOS1 = JSON.parse(JSON.stringify(posList[i]));
        //                 newPOS1.fields.itemCode = j+'|'+itemCode;
        //                 newPOS1.fields.qty = targetQty;
        //                 finalList.push(newPOS1);
        //             }
        //             if(remainder >0){
        //                 quotient = quotient+1;
        //                 let newPOS2 = JSON.parse(JSON.stringify(posList[i]));
        //                 newPOS2.fields.itemCode = quotient +'|'+itemCode;
        //                 newPOS2.fields.qty = remainder;
        //                 finalList.push(newPOS2);
        //             }
        //         } else{
        //             finalList.push(currPos);
        //         }
        //     }
        //     return finalList;
        // }

        var itemArray = convertToObjectArray(products);
        // let dimension = products.map(function(element){
        //         return (element.fields.qty * element.childItems.length) + element.fields.qty;
        //     }
        // );
        itemArray.sort(function(a,b){
            return -(parseInt(Object.keys(a)[0],10) - parseInt(Object.keys(b)[0],10));
        });
        
    
        var chain =  Promise.resolve();
        let totalWeight = 0;
        let arr = [];
        for(let i = 0; i < itemArray.length; i++ ){
            let key = Object.keys(itemArray[i])[0];
            let weigth = parseInt(key,10);
            if(totalWeight + weigth <= LINE_ITEM_LIMIT){
                arr.push(itemArray[i][key]);
                totalWeight = totalWeight + weigth;
                if(i == itemArray.length -1){
                    let tmpArr = JSON.parse(JSON.stringify(arr));
                    chain = chain.then(() => this.createAllProducts(component, bundId, tmpArr, configuration));
                }
                continue;
            }
            let tmpArr = JSON.parse(JSON.stringify(arr));
            chain = chain.then(() => this.createAllProducts(component, bundId, tmpArr, configuration));
            arr = [];
            arr.push(itemArray[i][key]);
            totalWeight = weigth;
        }
        
        return chain;

        // let arr = [];
        // for(let i = 0; i < itemArray.length; i++ ){
        //     let key = Object.keys(itemArray[i])[0];
        //     arr.push(itemArray[i][key]);
        // }
        // return this.createComplexProduct(component, bundId, arr, configuration);

        // let limitQty = 5;

        // let ugePos = products.filter(function(element){
        //     return element.fields.RecordTypeName == 'Terminali' && element.fields.qty > limitQty;
        // });

        // ugePos = splitUgePos(ugePos);

        // let others = products.filter(function(element){
        //     return (element.fields.RecordTypeName == 'Terminali' && element.fields.qty <= limitQty) || (element.fields.RecordTypeName != 'Terminali');
        // });
        
        // var chain =  Promise.resolve();
        // for(let i = 0; i < ugePos.length; i++ ){
        //     let arr = [];
        //     arr.push(ugePos[i]);
        //     chain = chain.then(() => this.createComplexProduct(component, bundId, arr, configuration));
        // }

        // chain = chain.then(() => this.createComplexProduct(component, bundId, others, configuration));

    },

          
      //enrico.purificato 22/10/2019 performance start
      createAllProducts: function(component, bundId, products, configuration) {
        if(products.length ==0){
            console.log('@@@ no complex items to insert');
            return Promise.resolve()
        }
        try{
            return new Promise($A.getCallback(function(resolve, reject){
    
                    var action = component.get("c.createAllProductServer");
                   
                    action.setParams({ complexProductList : JSON.stringify(products) ,bundleId: bundId, configuration: JSON.stringify(configuration)});
                    action.setCallback(this, function(response){
                        console.log('Ending createAllProducts ' + performance.now());
                        if(response.getState() === 'SUCCESS' && response.getReturnValue()){
                             resolve();
                        } else {
                            var errors = response.getError();
                            if (errors) {
                                if (errors[0] && errors[0].message) {
                                    reject(new Error("createBundle Error message: " +errors[0].message));
                                }
                            } 
                            reject(new Error("createBundle Error message: Unknown error" ));
                            
                        }
                     });
                     $A.enqueueAction(action);
                     console.log('enqueueAction CreateAllProducts  ' + performance.now());
                     
                }));

        } catch(error){
            console.log(error);
            Promise.reject(error);
        }
    },
    //enrico.purificato 22/10/2019 performance end

    createComplexProduct: function(component, bundId, products, configuration) {
        if(products.length ==0){
            console.log('@@@ no complex items to insert');
            return Promise.resolve()
        }
        try{
            var promiseArray =  products.map(function(element){

                return new Promise($A.getCallback(function(resolve, reject){
    
                    var action = component.get("c.createComplexProductServer");
                   
                    action.setParams({ complexProduct : JSON.stringify(element) ,bundleId: bundId, configuration: JSON.stringify(configuration)});
                    action.setCallback(this, function(response){
                        if(response.getState() === 'SUCCESS' && response.getReturnValue()){   
                             resolve();
                        } else {
                            var errors = response.getError();
                            if (errors) {
                                if (errors[0] && errors[0].message) {
                                    reject(new Error("createBundle Error message: " +errors[0].message));
                                }
                            } else {
                                reject(reject(new Error("createBundle Error message: Unknown error" )));
                            }
                        }
                     });
                     $A.enqueueAction(action);
                     
                }))
            });
            return Promise.all(promiseArray);
        } catch(error){
            console.log(error);
            Promise.reject(error);
        }
        
    },
    //enrico.purificato 23/10/2019 performance start
    callAssetToOrderItem: function(component,ordIdParam, assetId)
    {
        try {

            var action = component.get("c.callAssetToOrderItemServer");
            action.setParams({ 
                "orderId" : ordIdParam,
                "offerAssetId": assetId
            });

            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS" && response.getReturnValue()) {
                component.set("v.asset2OrderDone",true);
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);
        
        } catch (e)     {
            console.log('EXCEPTION! : ' + e.message);
        }
    },
    //enrico.purificato 23/10/2019 performance end
    
    objectIsEmpty: function(obj)
	{
        return Object.keys(obj).length === 0;
    },
    
    showBit2flowNext: function(component, event) 
	{
		var objectDataMap = component.get("v.objectDataMap");
		objectDataMap.unbind.goToNextStepCatalog  = "goToNextStepCatalog"; 
		component.set("v.objectDataMap", objectDataMap);
		component.set("v.spinner",false); 
    },
    
    showBit2flowSaveAndExit: function(component, event)
    {
    	_utils.debug("__into showBit2flowSaveAndExit");
    	
    	//param
    	var objectDataMap = component.get("v.objectDataMap");
    	
    	//TEMP?
    	objectDataMap.JumpToStep = 4;
    	//TEMP?
    	
    	var wizardWrapperVar = component.get("v.wizardWrapper");
    	var isCommunity = objectDataMap.isCommunityUser;
	    
	    if($A.util.isEmpty(isCommunity)){
	    	isCommunity = false;
	    }
    	//remove the size key from object
    	delete wizardWrapperVar.mapFields["size"];

    	var strWizardWrapperVar = JSON.stringify(wizardWrapperVar);
    	var strObjectDataMap = JSON.stringify(objectDataMap);
    	
    	var action = component.get("c.saveAndExitBit2FlowCaller");
        action.setParams({
            dataMap: strObjectDataMap,//objectDataMap,
            wizardWrapperString: strWizardWrapperVar,
            isCommunity: isCommunity
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS")
            {
                var res = response.getReturnValue();
                if( !($A.util.isEmpty(res)) )
                {
                    //timeout
                    window.setTimeout(
                        $A.getCallback(function()
                        {
                            window.location.replace(res);
                        }), 2500
                    )
                }
                else
                {
                    //TODO:toast message error
                }
            }
            else if (state === "INCOMPLETE") {
                component.set("v.spinner",false);
            }
            else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            _utils.debug("Error message: " +
                                        errors[0].message);
                        }
                    } else {
                        _utils.debug("Unknown error");
                    }
                    component.set("v.spinner",false);
            }
        });
        $A.enqueueAction(action);
        component.set("v.spinner", true);
    },

    isUnusualStep: function(component, event,direction)
    {
    	var bundleElementName = component.get("v.bundleElementName");
    	var bundleStep = component.get("v.bundleStep");
    	var isFirstStep = false;
    	if(bundleStep == 0){
    		var isFirstStep = true; 
    	}
    	
    	if(direction == 'previous'){
    		bundleStep = parseInt(bundleStep)-1;
    	}
    	else if(direction == 'nextJump'){
    		bundleStep = parseInt(bundleStep)+2;
    	}
    	else{
    		bundleStep = parseInt(bundleStep)+1;
    	}
    	
    	_utils.debug("bundleStep "+ bundleStep);
    	
    	if( bundleElementName != 'Gestione Pagobancomat' && bundleElementName != 'Gestione Terminali' && bundleElementName != 'Selezione Acquiring' && bundleElementName != 'Selezione VAS' && isFirstStep == false)
    	{
    		component.set("v.isUnusualStep",true);
    	}
    	else{
    		component.set("v.isUnusualStep",false);
    	}
    },

	setConfigurationToApprove: function(component,event)    //davide.franzini - WN-239 - 02/08/2019 - bitwinMap removed cause it's unusued
	{
		var t0 = performance.now();
		_utils.debug("__into setConfigurationToApprove");
    	var ordId = component.get("v.orderId");
    	var objectDataMap = component.get("v.objectDataMap");
    	if($A.util.isEmpty(ordId)){
        	ordId = objectDataMap.Configuration.Id;
        	component.set("v.orderId",ordId);
        }
		var isMaintenance = component.get("v.isMaintenance");

    	var action = component.get("c.setConfigurationToApprove");
        action.setParams({
            idOrder: ordId
        });
        action.setCallback(this, function(response)
        {
            var state = response.getState();
            if (state === "SUCCESS")
            {
                _utils.debug("response: ", response.getReturnValue());
                var res = response.getReturnValue();

                if(res)
                {
                    if(component.get("v.isMaintenance"))
                    {
                        var flowMaintenanceEvent = $A.get("e.c:OB_FlowCartMaintenanceEvent");
                        flowMaintenanceEvent.setParams({goBackToMaintenanceDetails : true});
                        flowMaintenanceEvent.fire();

                        //28/02/19 francesca.ribezzi : adding event to send the selected service point id to Maintenance Summary cmp
                        if(!$A.util.isEmpty(objectDataMap.pv.Id))
                        {
                            var servicePointId = component.get("v.objectDataMap.pv.Id");
                            console.log("servicePointId: " + servicePointId);
                            var servicePointIdEvent = $A.get("e.c:OB_PickServicePointId");
                            servicePointIdEvent.setParams({
                                "servicePointId" : objectDataMap.pv.Id
                            });
                            servicePointIdEvent.fire();
                        }
                        var type = 'success';
                        var infoMessage = 'Richiesta presa in carico';
                        this.showInfoToast(component, event, infoMessage, type);
                    }
                    else
                    {
                        //NEED
                        this.showBit2flowSaveAndExit(component, event);
                    }
                }
                else{
                    //TODO:toast message error
                }
            }
            else if (state === "INCOMPLETE")
            {
                component.set("v.spinner",false);
            }
            else if (state === "ERROR")
            {
                var errors = response.getError();
                if (errors)
                {
                    if (errors[0] && errors[0].message)
                    {
                        _utils.debug("Error message: " + errors[0].message);
                    }
                } else {
                    _utils.debug("Unknown error");
                }
                component.set("v.spinner",false);
            }
        });
        $A.enqueueAction(action);
        component.set("v.spinner", true);
        var t1 = performance.now();
        console.log("Call setConfigurationToApprove took " + (t1 - t0) + " milliseconds.");
	},
	
	createAsset: function(component,event)
	{
		_utils.debug("__into createAsset");
    	var ordId = component.get("v.orderId");
    	var objectDataMap = component.get("v.objectDataMap");
    	if($A.util.isEmpty(ordId))
    	{
        	ordId = objectDataMap.Configuration.Id;
        	component.set("v.orderId",ordId);
        }
    	var action = component.get("c.getAsset");
        action.setParams({orderId: ordId});
        action.setCallback(this, function(response)
        {
            var state = response.getState();
            if (state === "SUCCESS")
            {
                _utils.debug("response assetId: ", response.getReturnValue());
                var res = response.getReturnValue();
            }
            else if (state === "INCOMPLETE")
            {
                component.set("v.spinner",false);
            }
            else if (state === "ERROR")
            {
                var errors = response.getError();
                if (errors)
                {
                    if (errors[0] && errors[0].message)
                    {
                        _utils.debug("Error message: " + errors[0].message);
                    }
                } else {
                    _utils.debug("Unknown error");
                }
                component.set("v.spinner",false);
            }
        });
        $A.enqueueAction(action);
        component.set("v.spinner", true);
	},
	createConfigurationComponent : function(component, event)
	{
    	_utils.debug("into createConfigurationComponent");
 	   component.set("v.showConfDetail",true);
    },
	
	redirectToTechDetails : function(component, event)
	{
		_utils.debug("into redirectToTechDetails");
		var t0 = performance.now();
		component.set("v.spinner",false);
		var objectId = component.get("v.objectDataMap.Configuration.Id");
		var objectType = 'NE__Order__c';

		$A.util.addClass(component.find("navigateStepBundle"),"hidden");	

		//calling bit2flow method
		var wizardName 	= component.get("v.maintenanceWizard");// --> OB_Maintenance_Catalogo_Nuovo_Contratto
		_utils.debug("Wizard to show: "+wizardName);
		var objectType = 'NE__Order__c';
		var action = component.get("c.launchMaintenanceWizard");
		action.setParams({
			"wizardName": wizardName
		});
		action.setCallback(this, function(response)
		{
            var state = response.getState();
            if (state === "SUCCESS")
            {
                var contBrokerCmp = component.find("contBrokerCmp");
                if(!$A.util.isEmpty(contBrokerCmp))
                {
                    contBrokerCmp.destroy();
                }
                var wizId = response.getReturnValue();
                component.set("v.wizardConfigurationId", wizId);
                console.log("objectId: " + objectId);
                console.log("objectType: " + objectType);
                console.log("wizardConfigurationId: " + wizId);
                console.log("inputParameters: " + 'Id::'+objectId);

                var flowCartEngineEvent = $A.get("e.c:OB_FlowCartEngineEvent");
                flowCartEngineEvent.setParams({'destroyEngine' : true});
                flowCartEngineEvent.fire();

                var wizardConfigurationId = component.get("v.wizardConfigurationId");
                _utils.debug('wizId: ' + wizId);
                $A.createComponent
                (
                    "bit2flow:dynWizardMain",
                    {
                            "wizardConfigurationId": wizId,
                            "sourceVF": true,
                            "objectId": objectId,//,
                            "objectType": objectType,//objectType,
                            "displayMenu" : false,
                            "params" : 'Id::'+objectId,
                            "showMainToast": false
                    },

                    function(newCmp, status, errorMessage)
                    {
                        if (status === "SUCCESS" && newCmp.isValid())
                        {
                            var body = component.get("v.body");
                            //MAS && AAP 24/08/2018  avoid launching more than one wizard at the same time and window
                            if ($A.util.isUndefinedOrNull (body) || body.length > 0)
                            {
                                body = [];
                                component.set("v.body", body);
                            }
                            //END MAS && AAP 24/08/2018
                            body.push(newCmp);
                            component.set("v.body", body);
                            var t1 = performance.now();
                            console.log("Call redirectToTechDetails " + (t1 - t0) + " milliseconds.");
                        } else if (status === "INCOMPLETE") {
                            //TODO:Error handling
                        } else if (status === "ERROR") {
                            //TODO:Error handling
                        }
                    }.bind(this)
                );
                component.set("v.blockCheckOut", true);
            }
            else if (state === "ERROR")
            {
            	_utils.debug('GET WIZARD ID FROM API NAME ERROR');
            }
        });
		$A.enqueueAction(action);
	},
	
	redirectToPrintDocuments : function(component, event)
	{
		_utils.debug("into redirectToPrintDocuments");
		component.set("v.spinner",false);
		component.set("v.showPrintDocuments", true);
		component.set("v.showConfDetail",false);
	},
    
    //19/07/19 francesca.ribezzi this function is not needed anymore - custom checkout is updating configuration
	/*updateConfVariation: function(component, event)
	{
        _utils.debug("__into updateConfVariation");
        console.log("v.objectDataMap.Configuration.Id: " , component.get("v.objectDataMap").Configuration.Id);
        console.log("v.contextOutput.configuration.id: " + component.get("v.contextOutput").configuration.id);
        console.log("variation: " + component.get("v.variation"));
        var borderWarning = document.getElementsByClassName('borderWarning');
        var action = component.get("c.updateConfigVariation");
        action.setParams({
            "confId":  component.get("v.objectDataMap").Configuration.Id,
            "variation": component.get("v.variation")
        });
        action.setCallback(this, function(response)
        {
            var state = response.getState();
            if (state === "SUCCESS")
            {
                _utils.debug("response: ", response.getReturnValue());
                var res = response.getReturnValue();
                //26/02/19 francesca.ribezzi moving this logic to a new helper:
                this.checkAcquiringChanges(component, event, res);
            }
            else if (state === "INCOMPLETE")
            {
                component.set("v.spinner",false);
            }
            else if (state === "ERROR")
            {
                var errors = response.getError();
                if (errors)
                {
                    if (errors[0] && errors[0].message)
                    {
                        _utils.debug("Error message: " + errors[0].message);
                    }
                } else {
                    _utils.debug("Unknown error");
                }
                component.set("v.spinner",false);
            }
        });
        $A.enqueueAction(action);
        component.set("v.spinner", true);
	},*/
	
	createLogRequest: function(component, event)
	{
		_utils.debug("__into createLogRequest");
		//11/02/19 adding need BIO approval process check:
		var checkBIO = false;
		var objectDataMap = component.get("v.objectDataMap");
		var needBIO = component.get("v.objectDataMap").bankProfile.OB_NeedBIO__c;
		if((component.get("v.isEditCommissionModel") ||component.get("v.isMaintenancePricing")) && needBIO)
		{
			checkBIO = true;
		}
		
		// isEditCommissionModel e isMaintenancePricing	
    	var action = component.get("c.createLogRequestServer");
        action.setParams({
            "merchantId": component.get("v.objectDataMap.merchant.Id"),
            "servicePointId": component.get("v.objectDataMap.pv.Id"),
            "confId": component.get("v.objectDataMap.Configuration.Id"),
            "abi" : component.get("v.objectDataMap.abi"),
            "cab": component.get("v.objectDataMap.cab"),
            "subProcess": component.get("v.objectDataMap.OrderHeader.OB_Sub_Process__c"),
            "checkBIO": checkBIO
        });
        action.setCallback(this, function(response)
        {
            var state = response.getState();
            if (state === "SUCCESS")
            {
                _utils.debug("response log request: ", response.getReturnValue());
                var res = response.getReturnValue();
                
                if(res != null)
                {
                    //10/05/19 francesca.ribezzi adding redirectToLogRequest function:
                    this.redirectToLogRequest(component, event, res);
                }
            }
            else if (state === "INCOMPLETE")
            {
                component.set("v.spinner",false);
            }
            else if (state === "ERROR")
            {
                    var errors = response.getError();
                    if (errors)
                    {
                        if (errors[0] && errors[0].message)
                        {
                            _utils.debug("Error message: " + errors[0].message);
                        }
                    } else {
                        _utils.debug("Unknown error");
                    }
                    component.set("v.spinner",false);
            }
        });
        $A.enqueueAction(action);
        component.set("v.spinner", true);
	},
	
	showInfoToast: function(component, event, infoMessage, type)
	{
	    _utils.debug("into showInfoToast");
    	var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: '',
            message: infoMessage,
            duration: '5000',
            key: 'info_alt',
            type: type,
            mode: 'pester'
        });
        toastEvent.fire();
    },
    
    handleRestartCart: function(component,event)
    {
		var t0 = performance.now();
		var ordId = component.get("v.ordIdParam");
        console.log("ordId into handleRestartCart: " + ordId);
        //enrico.purificato - 23/10/2019 - performance start
        var sessionId = component.get("v.sessionId");
        var param	=	'&ordId='+ ordId; 
        if(sessionId!='' && sessionId != undefined){
            param	=	'&loadDataFromSession='+ sessionId; 
        }else{
            component.set("v.asset2OrderDone",true);
        }
        //enrico.purificato - 23/10/2019 - performance start
		var processOptions			=	{};
		processOptions.parameters	=	param;
		
		var restartEvent =       $A.get("e.NE:Bit2win_Event_CartEvent");
        restartEvent.setParams({
        	'process'			:	'Restart',
        	'processOptions'	:	processOptions
        });
        restartEvent.fire();

		var t1 = performance.now();
		console.log("Call handleRestartCart took " + (t1 - t0) + " milliseconds.");
	},
	
	doInitHelper: function(component,event)
	{
		console.log("into doInitHelper");
		var t0 = performance.now();
		var objectDataMap = component.get("v.objectDataMap");
        //_utils.debug("objectDataMap ", objectDataMap);
        var isCommunity = objectDataMap.isCommunityUser;
        if(isCommunity == undefined)
        {
            isCommunity= false;
        }

        if(isCommunity)
        {
            var urlImg = component.get("v.urlImages");
            var urlImgCommunity = '..' + urlImg;
            component.set("v.urlImages", urlImgCommunity);
        }
        //hide first next if we are doing maintenance
        var isMaintenance = component.get("v.isMaintenance");

        if(isMaintenance)
        {
            //change button of offers selection in button for bundle progression
            var button1 = component.find('buttondiv');
            var button2 = component.find('navigateStepBundle');

            $A.util.addClass(button1, 'hidden');
            $A.util.removeClass(button2, 'hidden');
        }

        if(objectDataMap.JumpToStep == 3)
        {
            component.set("v.step",2);
            //15/02/19 francesca.ribezzi setting bundle step for rejected pricing:
            component.set("v.bundleStep",3);
        }
        var t1 = performance.now();
        console.log("Call doInit FlowCart: " + (t1 - t0) + " milliseconds.");
        /* ANDREA MORITTU START 2019.05.13  - ID_Stream_6_Subentro */
        if(!$A.util.isUndefined(objectDataMap['offerAsset'])) {
            if(!$A.util.isEmpty(objectDataMap.offerAsset.Id)){
                var offerAssetId = objectDataMap.offerAsset.Id;
                var configId = objectDataMap.Configuration.Id;
                this.updatemerchantTakeoverConfiguration(component, event, offerAssetId, configId);
            }
        }
        /* ANDREA MORITTU END 2019.05.13  - ID_Stream_6_Subentro */
    },

    checkAcquiringChanges :function(component,event, res)
    {
        var borderWarning = document.getElementsByClassName('borderWarning');
        var goToDocuments = false;
        var action = component.get("c.checkForAcquiringChangesServer"); //change method name
        action.setParams({
            "confId":  component.get("v.objectDataMap").Configuration.Id
        });
        action.setCallback(this, function(response)
        {
            var state = response.getState();
            if (state === "SUCCESS")
            {
                _utils.debug("acqChanged: ", response.getReturnValue());
                var acqChanged = response.getReturnValue();
                goToDocuments = (acqChanged && component.get("v.checkAgreedChanges"));
                console.log("goToDocuments?:  " + goToDocuments);
                //01/02/19 adding isEditCommissionModel condition:
                if(res && (goToDocuments  || component.get("v.isEditCommissionModel")) && borderWarning.length == 0 ){ 
                    this.redirectToPrintDocuments(component, event);
                }else if(res && (!goToDocuments || component.get("v.isMaintenancePricing")) && borderWarning.length == 0 ){ 
                    this.createLogRequest(component, event);
                }else{
                    //01/02/19 adding isMaintenancePricing
                    if( borderWarning.length> 0  && (component.get("v.isEditCommissionModel") || component.get("v.isMaintenancePricing"))){
                        this.setConfigurationToApprove(component, event);
                    }
                }
            }
            else if (state === "INCOMPLETE") {
                component.set("v.spinner",false);
            }
            else if (state === "ERROR")
            {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message)
                    {
                        _utils.debug("Error message: " + errors[0].message);
                    }
                } else {
                    _utils.debug("Unknown error");
                }
                component.set("v.spinner",false);
            }
        });
        $A.enqueueAction(action);
        component.set("v.spinner", true);
    },

    checkAcquiringChangesAndRedirect :function(component,event)
    {
        var goToDocuments = false;
        var action = component.get("c.checkForAcquiringChangesServer"); //change method name
        action.setParams({
            "confId":  component.get("v.objectDataMap").Configuration.Id
        });
        action.setCallback(this, function(response)
        {
            var state = response.getState();
            if (state === "SUCCESS")
            {
                _utils.debug("acqChanged: ", response.getReturnValue());
                var acqChanged = response.getReturnValue();
                if(acqChanged){
                    this.redirectToPrintDocuments(component, event);
                }else{
                    this.createLogRequest(component, event);
                }
            }
            else if (state === "INCOMPLETE") {
                component.set("v.spinner",false);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message)
                    {
                        _utils.debug("Error message: " + errors[0].message);
                    }
                } else {
                    _utils.debug("Unknown error");
                }
                component.set("v.spinner",false);
            }
        });
        $A.enqueueAction(action);
    },

    showNoVariationMessage:function(component,event)
    {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: '',
            message: $A.get("$Label.c.OB_noVariationError"),
            duration: '5000',
            key: 'info_alt',
            type: 'info',
            mode: 'dismissible'
        });
        toastEvent.fire();
        },
    //Start antonio.vatrano 08/05/2019 r1f2-106 method to retrieve license of current user
    retrieveUser : function(component,event){
        var retrieveLicense = component.get("c.retrieveUserLicense");
        retrieveLicense.setCallback(this, function(response)
        {
            var state = response.getState();
            if (state === "SUCCESS"){
                var license = response.getReturnValue();
                component.set("v.userLicense", license);
                console.log('flowCart UserLicense: '+license);
            }
        });
        $A.enqueueAction(retrieveLicense);
    },
    //End antonio.vatrano 08/05/2019 r1f2-106 method to retrieve license of current user

    //START francesca 10/05/19 redirect to logRequest page
    redirectToLogRequest : function (component, event, logRequestId) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
          "recordId": logRequestId,
          "isredirect": true
        });
        navEvt.fire();
        var infoMessage = $A.get("$Label.c.OB_sentRequestMessage");
        var type= 'success';
        this.showInfoToast(component, event, infoMessage, type);
    },
    //END francesca 10/05/19 

    /*
        @Author     :       Morittu Andrea
        @Date       :       2019.05.13
        @Task       :       ID_Stream_6_Subentro
    */
   updatemerchantTakeoverConfiguration : function(component, event, offerAssetId, configId) {
        console.log('### configId inside updateMerchantTakeover is: ' + configId);
        try {
            var action = component.get("c.updateAssetInMerchantTakeOver");
            action.setParams({ orderId           :           configId,    
                                offerAssetId     :           offerAssetId 
                                });

            action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        var updateWasSuccesfull = response.getReturnValue();
                        if(!$A.util.isUndefinedOrNull(updateWasSuccesfull)) {
                            if(updateWasSuccesfull) {
                                console.log('updateWasSuccesfull takeover was succesfull');
                            } else {
                                console.log('updateWasSuccesfull takeover was not succesfull');
                            }
                        }
                    }
                    else if (state === "INCOMPLETE") {

                    }
                    else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message: " + 
                                        errors[0].message);
                            }
                        } else {
                            console.log("Unknown error");
                        }
                    }
                });
                $A.enqueueAction(action);
            } catch(exc) {
                console.log('an exception has occured : ' + exc.message);
            }
    },
    /*
        @Author         :       Morittu Andrea
                        END
    */
    // Daniele Gandini <daniele.gandini@accenture.com>	- 21/05/2019 - TerminalsReplacement - method for jumping into tech details if Replacement case - START	
    redirectToTechDetailsReplacement_helper : function(component, event)
    {
        var t0 = performance.now();
        component.set("v.spinner",false);
        var objectId = component.get("v.objectDataMap.Configuration.Id");
        var objectType = 'NE__Order__c';

        $A.util.addClass(component.find("navigateStepBundle"),"hidden");	

        //calling bit2flow method
        var wizardName 	= component.get("v.maintenanceWizardReplacement");// --> OB_Maintenance_Sostituzione
        var objectType = 'NE__Order__c';
        var action = component.get("c.launchMaintenanceWizard");
        action.setParams({
            "wizardName": wizardName
        });
        action.setCallback(this, function(response)
        {
            var state = response.getState();
            if (state === "SUCCESS")
            {
                var contBrokerCmp = component.find("contBrokerCmp");
                if(!$A.util.isEmpty(contBrokerCmp))
                {
                    contBrokerCmp.destroy();
                }
                var wizId = response.getReturnValue();
                component.set("v.wizardConfigurationId", wizId);
                console.log("objectId: " + objectId);
                console.log("objectType: " + objectType);
                console.log("wizardConfigurationId: " + wizId);
                console.log("inputParameters: " + 'Id::'+objectId);

                var flowCartEngineEvent = $A.get("e.c:OB_FlowCartEngineEvent");
                flowCartEngineEvent.setParams({'destroyEngine' : true});
                flowCartEngineEvent.fire();

                var wizardConfigurationId = component.get("v.wizardConfigurationId");
                $A.createComponent
                (
                    "bit2flow:dynWizardMain",
                    {
                            "wizardConfigurationId": wizId,
                            "sourceVF": true,
                            "objectId": objectId,//,
                            "objectType": objectType,//objectType,
                            "displayMenu" : false,
                            "params" : 'Id::'+objectId,
                            "showMainToast": false
                    },

                    function(newCmp, status, errorMessage)
                    {
                        if (status === "SUCCESS" && newCmp.isValid())
                        {
                            var body = component.get("v.body");
                            //MAS && AAP 24/08/2018  avoid launching more than one wizard at the same time and window
                            if ($A.util.isUndefinedOrNull (body) || body.length > 0)
                            {
                                body = [];
                                component.set("v.body", body);
                            }
                            body.push(newCmp);
                            component.set("v.body", body);
                            var t1 = performance.now();
                        } else if (status === "INCOMPLETE") {
                            //TODO:Error handling
                        } else if (status === "ERROR") {
                            //TODO:Error handling
                        }
                    }.bind(this)
                );
                component.set("v.blockCheckOut", true);
            }
            else if (state === "ERROR")
            {
            }
        });
        $A.enqueueAction(action);
    },
    // Daniele Gandini <daniele.gandini@accenture.com>	- 21/05/2019 - TerminalsReplacement - method for jumping into tech details if Replacement case - END	

    handleAfterCheckOutHelper : function(component,event, helper)
    {
		_utils.debug("into handleAfterCheckOut");
		var t0 = performance.now();
		console.log("handleAfterCheckOut init: " + performance.now());
    	var isMaintenancePricing = component.get("v.isMaintenancePricing");
    	var isMaintenance = component.get("v.isMaintenance");
    	var showTechDetail = component.get("v.showTechDetail");
    	var showPrintDocuments = component.get("v.showPrintDocuments");
    	var isEditCommissionModel = component.get("v.isEditCommissionModel");
		var borderWarning = document.getElementsByClassName('borderWarning');
		// Daniele Gandini <daniele.gandini@accenture.com>	- 21/05/2019 - TerminalsReplacement - Jump to tech details if Replacement case - START
		var isReplacement = component.get("v.isReplacement");
		// Daniele Gandini <daniele.gandini@accenture.com>	- 21/05/2019 - TerminalsReplacement - Jump to tech details if Replacement case - end
        //START gianluigi.virga 16/09/2019 - call method only if is preventivo
        if(!$A.util.isUndefinedOrNull(component.get("v.objectDataMap.isPreventivo")) && component.get("v.objectDataMap.isPreventivo") == true){
            var saveFlow = component.get('c.flowSave');
            $A.enqueueAction(saveFlow);
        }else{
        // END gianluigi.virga 16/09/2019
		
	    	if(borderWarning.length > 0)
	    	{
	    		//11/01/19 francesca.ribezzi - use the same logic in both maintenance and bit2flow:
	    		if(!isMaintenance)
	    		{
	    			//save and exit bundle with approve flag set to true.
		    		this.setConfigurationToApprove(component,event);    //davide.franzini - WN-239 - 02/08/2019 - bitwinMap removed cause it's unusued
		    	}
		    	else
		    	{
		    		//redirect to dati operativi //31/01/19 and is not isEditCommissionModel
		    		if(isMaintenance && !isMaintenancePricing && !showTechDetail && !showPrintDocuments && !isEditCommissionModel)
		    		{
		    			this.setConfigurationToApprove(component, event);
					}
					//02/02/19 
					else if(isEditCommissionModel && !showTechDetail && !showPrintDocuments)
					{
						this.setConfigurationToApprove(component,event);    //davide.franzini - WN-239 - 02/08/2019 - bitwinMap removed cause it's unusued
					}

		    		//redirect to stampa documenti
		    		else if(isMaintenance && isMaintenancePricing && !isEditCommissionModel  && !showTechDetail && !showPrintDocuments)
		    		{
                        //update configuration variation value and then calling redirectToPrintDocuments function
                        //19/07/19 francesca.ribezzi calling checkAcquiringChanges instead of updateConfVariation - not needed anymore- perfomance custom checkout
                    	this.checkAcquiringChanges(component, event, true);
					//01/02/19 approval process -> createLogRequest -> go back to anagrafica:
		    		}
		    		else if(isEditCommissionModel  && !showPrintDocument)
		    		{
						this.createLogRequest(component, event);
					}
		    		//redirect to stampa documenti from TechDetail
		    		
		    		else if(isMaintenance && !isMaintenancePricing && showTechDetail && !showPrintDocuments)
		    		{
		    			component.set("v.showTechDetail",false);
		    			//get old next back
			            var button2 = component.find('navigateStepBundle');
			            $A.util.removeClass(button2, 'hidden');
			            
		    			this.redirectToPrintDocuments(component, event);
		    		}
		    	}
	    	}//end if approval process
	    	else
	    	{
	    		if(isMaintenance && isMaintenancePricing && !isEditCommissionModel  && !showTechDetail && !showPrintDocuments) // 
	    		{ 
                    //19/07/19 francesca.ribezzi calling checkAcquiringChanges instead of updateConfVariation - not needed anymore- perfomance custom checkout
                    this.checkAcquiringChanges(component, event, true);
				}
				
				else if(isMaintenance && isEditCommissionModel && !showPrintDocuments && !showTechDetail)
				{
					this.checkAcquiringChangesAndRedirect(component, event);//helper.redirectToPrintDocuments(component, event);
				}

		    	else if(isMaintenance && !isMaintenancePricing && !showTechDetail && !showPrintDocuments && !isReplacement)// added !isReplacement condition - DG - 21/05/2019
		    	{
		    		this.redirectToTechDetails(component, event); //TODO: call bit2Flow Method
				}
				// Daniele Gandini <daniele.gandini@accenture.com>	- 21/05/2019 - TerminalsReplacement - if added - START
				else if(isReplacement)
				{
					this.redirectToTechDetailsReplacement_helper(component, event);
				}
				// Daniele Gandini <daniele.gandini@accenture.com>	- 21/05/2019 - TerminalsReplacement - if added - END
		    	else if(isMaintenance && !isMaintenancePricing && showTechDetail && !showPrintDocuments) //
		    	{
		    		component.set("v.showTechDetail",false);
		    		//get old next back	
		            var button2 = component.find('navigateStepBundle');
		            $A.util.removeClass(button2, 'hidden');
		            
		    		this.redirectToPrintDocuments(component, event);
		    	}
				else if(!isMaintenance)
				{
	    			this.showBit2flowNext(component, event);
	    		}
			}
        }	
		var t1 = performance.now();
		console.log("Call handleAfterCheckout took " + (t1 - t0) + " milliseconds.");
    },
     /**
    *   Author      :       Morittu Andrea
    *   Date        :       18-Sept-2019
    *   Task        :       EVO_PRODOB_452
    * Description   :       Method to overturn 'pending' order to cancelled and rollback asset to Active
    **/
    cancelOrder : function(component, event, helper) {
        let orderId = component.get('v.objectDataMap.Configuration.Id');
        try {
            if(!$A.util.isUndefined(orderId) && !$A.util.isEmpty(orderId)) {
                var action = component.get("c.callCancelOrder");
                action.setParams({ 
                    "orderId" : orderId
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    console.log("###state: " + state);
                    if (state === "SUCCESS") {
                        var cancelled = response.getReturnValue();
                        if(!cancelled){
                            let infoMessage = $A.get("$Label.c.OB_NoCancel");
                            let duration = '5000';
                            let type  = 'info';
                            this.showInfoMessage(component, event, infoMessage, duration, type);
                        } else {
                            let infoMessage = $A.get("$Label.c.OB_MAINTENANCE_TOAST_OPERATIONSUCCESSFULL");
                            let duration = '5000';
                            let type  = 'Success';
                            this.showInfoMessage(component, event, infoMessage, duration, type);
                            window.setTimeout(
                                function() {
                                    $A.get('e.force:refreshView').fire();
                                }, 3000);


                            component.set('v.spinner', false);
                        }
                    }
                    else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message: " + errors[0].message);
                            }
                        } else {
                            console.log("Unknown error");
                        }
                    }
                });
                $A.enqueueAction(action);
                component.set("v.spinner", false);
            }
        } catch (e)     {
            console.log('EXCEPTION! : ' + e.message);
        }
    },

    /**
    *   Author      :       Morittu Andrea
    *   Date        :       18-Sept-2019
    *   Task        :       EVO_PRODOB_452
    * Description   :       Fire toast function
    **/
    showInfoMessage : function(component, event, infoMessage, duration, type){
		console.log("into show info message");
	    var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: '',
            message: infoMessage,
            //messageTemplateData: [name],
            duration: duration,
            key: 'info_alt',
            type: type,
            mode: 'dismissible'
        });
        toastEvent.fire();
    },
    //START gianluigi.virga 19/09/2019 - Print quote
    flowExit : function(component, event, helper){
        var url = component.get("v.redirect");
        //timeout
        window.setTimeout(
            $A.getCallback(function()
            {
                window.location.replace(url);
            }), 2500
        )
    },
    showQuoteButton : function(component, event, helper){
        var action = component.get("c.getShowQuote");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var res = response.getReturnValue();
                if(!($A.util.isEmpty(res)) )
                {
					component.set("v.showQuoteButton", res);
					console.log('Show quote button: '+component.get("v.showQuoteButton"));
                }
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        _utils.debug("Error message: " +
                        errors[0].message);
                    }
                }else {
                    _utils.debug("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    setPrivacy : function(component, event, helper){
        var action = component.get("c.updatePrivacyServicePoint");
        var servicePointId = component.get("v.objectDataMap.pv.Id");
        console.log('servicePointId: '+servicePointId);
        action.setParams({
            "servicePointId": servicePointId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
				console.log('Privacy fields on Service Point was updated');
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        _utils.debug("Error message: " +
                        errors[0].message);
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },
    //END gianluigi.virga 19/09/2019
    
    /**
    *   Author      :       Francesca Ribezzi
    *   Date        :       25-11-2019
    *   Task        :       Performance
    * Description   :       check if variation is downgrade or upgrade
    **/
    checkVariation: function(component, event, idChild){
        var downgrade = 	$A.get("$Label.c.OB_ActualVariationDowngrade");
		var upgrade = 		$A.get("$Label.c.OB_ActualVariationUpgrade");
        var variation = 	component.get("v.variation");
        var newVariation = '';
		var isDowngrade = 	false;
		var isUpgrade = 	false;
        var attrVariationMap = component.get("v.attrVariationMap");
        var valueToCheck = event.getParam("newValue");
		var defaultValue = event.getParam("oldValue"); 
		if(valueToCheck > defaultValue ){
			attrVariationMap[idChild] = downgrade;
		}else if(valueToCheck < defaultValue){
			attrVariationMap[idChild] = upgrade;
		}
        for(var key in attrVariationMap){
            var value = attrVariationMap[key];
			if(value == downgrade){
				isDowngrade = true;
				newVariation = downgrade;
				break;
			}
			if(value == upgrade){
				isUpgrade = true;
			}
        }
		if(isUpgrade && !isDowngrade){
			newVariation = upgrade;
        }
        if(newVariation != variation){
            var infoMessage = $A.get("$Label.c.OB_VariationInfoMessage");
            var infoMessageVariation = infoMessage + " " + newVariation; 
            var type = 'info'; 
            this.showInfoToast(component,event, infoMessageVariation, type);  
        }
		component.set("v.attrVariationMap", attrVariationMap);
		component.set("v.variation", newVariation); 

    },
   
})