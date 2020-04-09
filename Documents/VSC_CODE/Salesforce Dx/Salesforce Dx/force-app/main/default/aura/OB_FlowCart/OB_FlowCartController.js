({
	doInit:  function(component,event,helper)
	{
		console.log("into doInit FlowCart");
		helper.doInitHelper(component, event);
		helper.showQuoteButton(component, event); //gianluigi.virga 19/09/2019 - Print quote
	},

	//LUBRANO 16/01/2019 Libreria Log
	logInit: function(component){
		_utils.logInit(component.getName());
	},
	
    nextStep: function(component,event,helper)
	{
		var objectDataMap = component.get("v.objectDataMap");
		var offertaId = objectDataMap.unbind.offertaId;

        //get order ID 
        var orderId = component.get("v.orderId");
        if($A.util.isEmpty(orderId))
        {
        	orderId = objectDataMap.Configuration.Id;
        	component.set("v.orderId",orderId);
        }
                                        
        var step = parseInt(component.get('v.step')) +1;
        var contextOutput = component.get("v.contextOutput");
        var cartLength = 0;
        var backToOfferSelection = component.get("v.backToOfferSelection");
        if(contextOutput == undefined || contextOutput == null)
        {
        	cartLength = 0;
        }else
        {
        	cartLength = contextOutput.cart.length;
        }
         
        component.set('v.step',step);
        if(step == 1 && cartLength > 0 && backToOfferSelection)
        {
        	//boolean to check for same offer selected
        	var isSameOfferta = false; //useless now
	        	
            if(offertaId == contextOutput.cart[0].fields.bundleId)
            {
            	_utils.debug("you have selected the same offer!");
            	isSameOfferta = true;
            }

	        if(isSameOfferta)
	        {
	        	var updateContext =	$A.get("e.NE:Bit2win_Event_RetrieveContext");
                updateContext.setParams({
                    'componentRequest'		:	'catalog',
                    'page'					:	1
                });
                updateContext.fire();
		    } 
	        else
	        {
               //if I'm in offer selection component, this checks if cart is not empty then firing clear event when the offer is changed:
               var clearCartEvent = $A.get("e.NE:Bit2win_Event_ApplyPenalty");
               clearCartEvent.setParams({
                    "action": "clearCart"
               });
               clearCartEvent.fire();
               _utils.debug("you have selected the same offer!");
               component.set("v.clearCart", true);
	        }	
        }
        else if(step == 1)
        {
            var offertaComponent = component.find('offertaComponent');
            $A.util.addClass(offertaComponent, 'hidden');
            
            var updateContext				=	$A.get("e.NE:Bit2win_Event_RetrieveContext");
            updateContext.setParams({
                'componentRequest'		:	'catalog',
                'page'					:	1
            });
            updateContext.fire();
        } 
        //change button of offers selection in button for bundle progression
        var button1 = component.find('buttondiv');
        var button2 = component.find('navigateStepBundle');
        var previousButtonDiv = component.find('previousButtonDiv');
        $A.util.addClass(button1, 'hidden');
        $A.util.removeClass(button2, 'hidden');
        $A.util.removeClass(previousButtonDiv, 'hidden');
        document.getElementById("nextBtnId").disabled = true;

        //check if is not an usual step
        helper.isUnusualStep(component,event,'next');
    },
    
    //Marco Ferri 06/09/2018 -- structured component bundle steps
    nextStepBundle: function(component,event,helper)
    {	
		var isLoaded = true;
		var borderErrors = [];
        var borderWarning = [];
		borderErrors = document.getElementsByClassName('borderError');
		
		///*****************************************************/
		////22/02/19 francesca.ribezzi adding check for maggiorazione 
		var mapChildIdName = component.get("v.mapChildIdName");
		var childItemList = [];
        if(borderErrors.length == 0)
        {
            if(component.get("v.checkAgreedChanges") == false)
            {
                for(var key in mapChildIdName)
                {
                    if(mapChildIdName[key].warning)
                    {
                        childItemList.push(mapChildIdName[key].name);
                    }
                }
                if(childItemList.length > 0)
                {
                    var message =  $A.get("$Label.c.OB_decreaseCommission");
                    message+= ' ';
                    for(var i = 0; i<childItemList.length; i++)
                    {
                        message+= childItemList[i] + ', ';
                    }
                    var type = 'info';
                    var newMessage = message.substring(0, message.length - 2);
                    helper.showInfoToast(component, event, newMessage, type);
                    return;
                }
            }
            //end check for maggiorazione
            ///*****************************************************/
        }
    	_utils.debug('into next bundle');
    	var showPrintDocuments = component.get("v.showPrintDocuments");
		borderWarning = document.getElementsByClassName('borderWarning');
		var variation = component.get("v.variation");
		var isMaintenancePricing = component.get("v.isMaintenancePricing");
		var requestCheckout = true;
		console.log('#### ' + $A.util.isEmpty(variation));
		
		if(isMaintenancePricing || component.get("v.isEditCommissionModel"))
		{
			for(var key in component.get("v.myMap")){
				if(!component.get("v.myMap")[key]){
					isLoaded=false;
				}
			}
		}
		if(isLoaded)
		{
			_utils.debug("any border error? " + borderErrors.length);
			if( borderErrors.length > 0 ) 
			{
                _utils.debug("You must enter valid approval values before going to next step.");
				var errorMessage = "You must enter valid approval values before going to next step.";
				var type = 'error';
				var infoMessage = 'Rimuovi gli errori prima di proseguire';
				helper.showInfoToast(component, event,  infoMessage, type);
			}
			else if(showPrintDocuments == true &&  borderWarning.length > 0 ) 
			{
				component.set("v.showPrintDocuments",false);
				//call approval process
				//var bitwinMap = {};//davide.franzini - WN-239 - 02/08/2019 - bitwinMap removed cause it's unusued
			}
			else if(showPrintDocuments == true &&  borderWarning.length == 0) 
			{	
                component.set("v.showPrintDocuments",false);
                //01/02/19 documentation -> next -> create log request and go back to anagrafica
                helper.createLogRequest(component, event);
			    //LUBRANO 2019-02-07 -- stop next step if there's no variation
			}
			else if(isMaintenancePricing && ($A.util.isEmpty(variation)))
			{
				helper.showNoVariationMessage(component, event);
				return;
			}
			else
			{
				var objectDataMap = component.get("v.objectDataMap");	
				var endBundle = false;
				var step = component.get('v.bundleStep');
				var outerstep = component.get('v.step');
				var afterSummary=component.get('v.afterSummary');
				var bundId	= objectDataMap.unbind.offertaId;
				_utils.debug('into next bundle')
				var	coreOutput	= component.get("v.contextOutput");
				var isMaintenance = component.get("v.isMaintenance");
				var bundleSelected;
				var selectedBundle='';
				var activeBundleStep;
				// <daniele.gandini@accenture.com> - 07/05/2019 - TerminalsReplacement - START	
				var clonedItems = {};
				objectDataMap.clonedItems;
				// <daniele.gandini@accenture.com> - 07/05/2019 - TerminalsReplacement - END	
				
                for(var i in coreOutput.listOfBundles)
                {
                    if(bundId == coreOutput.listOfBundles[i].id)
                    {
                        var bundleLength = coreOutput.listOfBundles[i].bundleElements.length;
                        if((bundleLength-1)> step && isMaintenancePricing != true )
                        {
                            selectedBundle=  coreOutput.listOfBundles[i].bundleElements[step];
                            bundleSelected =  coreOutput.listOfBundles[i];
                            break;
                        }
                        endBundle= true;
                        outerstep++;
                    }
				}
				// Daniele Gandini <daniele.gandini@accenture.com>	- 07/05/2019 - TerminalsReplacement - Jump to Operational data if Replacement case - START	
				var isReplacement = component.get("v.isReplacement");
				if(isReplacement){
					if(outerstep == 2){
					endBundle= true;
					outerstep++;
					}else{
						endBundle= true;
						outerstep = 2;
					}
				}
				// Daniele Gandini <daniele.gandini@accenture.com>	- 07/05/2019 - TerminalsReplacement - Jump to Operational data if Replacement case - END	
				
                //francesca.ribezzi - if we are in edit commission model maintenance section, going directly to price summary! ;
                if(component.get("v.isEditCommissionModel"))
                {
                    endBundle= true;
                    outerstep++;
                }
		
				if(!endBundle)
				{
					if(step == 0 && isMaintenance)
					{
						//change button of offers selection in button for bundle progression
						var previousButtonDiv = component.find('previousButtonDiv'); 
						if(  $A.util.hasClass(previousButtonDiv,'hidden') )
						{
							$A.util.removeClass(previousButtonDiv, 'hidden');
						}
					}

                    var configureBundle 	= 	$A.get("e.NE:Bit2win_Event_BundleElements");
                    configureBundle.setParams({
                        'BundleElement'	: 	selectedBundle //entra in verifica del contenuto di un bundle element
                    });
                    _utils.debug('FIRE EVENT __Bit2win_Event_BundleElements');
                    configureBundle.fire();
					
					step++;
					
					var direction = 'next';
					activeBundleStep = bundleSelected.bundleElements[step].fields.active;
					console.log(bundleSelected.bundleElements[step].fields.name +'_active?_'+bundleSelected.bundleElements[step].fields.active);        	
					if(activeBundleStep == 'false' || activeBundleStep == false)
					{
						component.set('v.bundleElementName',bundleSelected.bundleElements[step+1].fields.name);
						step++;
						direction = 'nextJump';
					}
					else
					{
						component.set('v.bundleElementName',bundleSelected.bundleElements[step].fields.name);
					}
					
					//check minQty for bundElement Step
					if(bundleSelected.bundleElements[step].fields.minqty >= 1)
					{
						document.getElementById("nextBtnId").disabled = true;
						component.set("v.isCheckNextRequired",true);
					}
					else
					{
						document.getElementById("nextBtnId").disabled = false;
						component.set("v.isCheckNextRequired",false);
					}
					
					component.set("v.bundleMinQty",bundleSelected.bundleElements[step].fields.minqty);
					//send this info to every child

					//check maxqty for bundElement Step
					var bundleMaxQty = bundleSelected.bundleElements[step].fields.maxqty;
					component.set("v.bundleMaxQty",bundleMaxQty);
					
					//check if is not an usual step
					helper.isUnusualStep(component,event,direction);
				}
				else
				{
					var isMaintenance = component.get("v.isMaintenance");
					
					//if maintenance, hide previous HERE!
					if(isMaintenance)
					{
						//change button of offers selection in button for bundle progression
						var previousButtonDiv = component.find('previousButtonDiv'); 
						if(  !($A.util.hasClass(previousButtonDiv,'hidden')) )
						{
							$A.util.addClass(previousButtonDiv, 'hidden');
						}
					}

					if(outerstep > 2 && borderWarning.length == 0)
					{
						component.set("v.afterSummary",true);
						component.set("v.spinner",true); 
						//20/02/19 francesca.ribezzi firing savebundle here
						var configureBundle 	= 	$A.get("e.NE:Bit2Win_Event_ResetSaveConfiguration");   
						configureBundle.setParams({
							'type'	: 	'saveBundle'
						});
						_utils.debug('FIRE EVENT __Bit2Win_Event_ResetSaveConfiguration');
						configureBundle.fire();
						component.set("v.priceApprovalLevel",'');
					}else if(outerstep > 2 && borderWarning.length > 0)
					{
						component.set("v.afterSummary",true);
						outerstep = 2;
						//custom label declaring
						var warningCustomLabel = $A.get("$Label.c.OB_Warning");
						//giovanni spinelli - 19/08/2019 - start - get approval level
						var approvalLevel = component.get("v.priceApprovalLevel"); //francesca.ribezzi 26/11/19 - performance get approvalLevel from attribute
						var getLabelApprover =  $A.get("$Label.c.OB_ApproverName");
						switch ( approvalLevel )
						{
							case 'L1':
								approvalLevel = getLabelApprover.split(';')[0];
								break; 
							case 'L2':
								approvalLevel = getLabelApprover.split(';')[1];
								break;
							case 'L3':
								approvalLevel = getLabelApprover.split(';')[2];
								break;  
						}
						component.set('v.approvalLevel' , approvalLevel);
						//giovanni spinelli - 19/08/2019 - start - get approval level
						var warningCustomLabelBody = $A.get("$Label.c.OB_WarningMessageApprovalOffer");
						
						//flag to open modal
						var modalHeader = warningCustomLabel+"!"; 
						var modalDesc = warningCustomLabelBody;
						//custom Label
						component.set("v.modalHeader", modalHeader);
						component.set("v.modalDesc", modalDesc);
						component.set("v.showWarningModal", true);
						requestCheckout = false;
					}
					else if(outerstep == 2)
					{
						//20/02/19 francesca.ribezzi firing savebundle here to enter Condizioni economiche
						var configureBundle 	= 	$A.get("e.NE:Bit2Win_Event_ResetSaveConfiguration");   
						configureBundle.setParams({
							'type'	: 	'saveBundle'
						});
						_utils.debug('FIRE EVENT __Bit2Win_Event_ResetSaveConfiguration');
						configureBundle.fire();
					}
					component.set('v.requestCheckout',requestCheckout);
					console.log("start checkout: " + performance.now());
				}
				component.set('v.step',outerstep);
				component.set('v.bundleStep',step);
				_utils.debug('next bundle  with step: '+outerstep+' and bundleStep: '+step);
			}
		}
		else
		{
			var type = 'error';
			var infoMessage = 'Caricare la documentazione prima di proseguire';
			helper.showInfoToast(component, event,  infoMessage, type);
		}//end else error approval rule
    }, 
    
    onUpdateContextChildren : function(component,event, helper)
	{
        var t0 = performance.now();
        var contextOutput = component.get("v.contextOutput");
        var disabledNextBtn = event.getParam("disabledNextBtn");
        var context = event.getParam("contesto");
        var cartLength = event.getParam("cartLength");
        var outerStep = component.get("v.step");

        var objectDataMap = component.get("v.objectDataMap");
        if(context == undefined || context == null)
        {
            disabledNextBtn = event.getParam("disabledNextBtn");
            if(disabledNextBtn)
            {
                document.getElementById("nextBtnId").disabled = true;
            }
            else
            {
                document.getElementById("nextBtnId").disabled = false;
                document.getElementById("nextBtnOffertaId").disabled = false;
            }
        }
        else
        {
            component.set("v.contextOutput",context);
            var objectDataMap = component.get("v.objectDataMap");

            if(objectDataMap.JumpToStep == 3)
            {
                var button1 = component.find('buttondiv');
                var button2 = component.find('navigateStepBundle');

                $A.util.addClass(button1, 'hidden');
                $A.util.removeClass(button2, 'hidden');
                document.getElementById("nextBtnId").disabled = false;
            }
            if(component.get("v.isMaintenance") &&  outerStep==2 && component.find("detailConfigComponent") == undefined)
            {
                if(component.get("v.isMaintenancePricing") || component.get("v.isEditCommissionModel"))
                {
                    helper.createConfigurationComponent(component, event);
                }
            }
            else if(component.get("v.isMaintenance") && outerStep != 2)
            {
               //check if bundle given is active
                var step = component.get('v.bundleStep');
                var offertaId = component.get("v.offertaId");
                var isStepActive;
                var offertaIndex;
                for(var i in context.listOfBundles)
                {
                    if(context.listOfBundles[i].id==offertaId)
                    {
                        isStepActive = context.listOfBundles[i].bundleElements[step].fields.active;
                        offertaIndex = i;
                        break;
                    }
                }
                if(isStepActive == 'false' || isStepActive == false)
                {
                    //step given wasn't active
                    for(var j =0; j < context.listOfBundles[offertaIndex].bundleElements.length; j++)
                    {
                        var activeStep = context.listOfBundles[offertaIndex].bundleElements[j].fields.active;
                        if(activeStep == 'true' || activeStep == true)
                        {
                            component.set("v.bundleStep",j);
                            //02/01/19 francesca.ribezzi -  setting bundle name attribute in order to show the right active bundle:
                            component.set('v.bundleElementName',context.listOfBundles[offertaIndex].bundleElements[j].fields.name);
                            break;
                        }
                    }
                }
            }
        }
        var t1 = performance.now();
        console.log("Call onUpdateContextChildren took " + (t1 - t0) + " milliseconds.");
    },

    onUpdateContext : function(component,event, helper)
    {
    	console.log('Inside onUpdateContext for flowCart');
        var doCheckout=component.get('v.requestCheckout');
        var afterSummary=component.get('v.afterSummary');
        var goToNextStep =component.get('v.goToNextStep');
        var clearCart =component.get('v.clearCart');
        var borderWarning = document.getElementsByClassName('borderWarning');

        var isMaintenancePricing = component.get("v.isMaintenancePricing");
        var isMaintenance = component.get("v.isMaintenance");

        var context = component.get("v.contextOutput");
        _utils.debug("contextOutput inside onUpdateContext: " , component.get("v.contextOutput"));

        //TODO: new preLoad LOGIC goes here!
        //v.activatePreLoad
        if(doCheckout && afterSummary)
        {
            //AFTER LAST STEP OF BUNDLE CHECKOUT SITUATION -- Marco.Ferri
			//AFTER LAST STEP OF BUNDLE CHECKOUT SITUATION -- Marco.Ferri
			
			// _utils.debug('__CHECKOUT__');
            // var checkPenalty = 	$A.get("e.NE:Bit2win_Event_ApplyPenalty");
            // checkPenalty.setParams({
            //     'action' 	: 	'checkout'
            // });
            // _utils.debug('FIRE EVENT __Bit2win_Event_ApplyPenalty');
			// checkPenalty.fire();
			var engineContext = event.getParam("CartService_Output"); 
			console.log('@@@ engineContext' + JSON.stringify(engineContext)); 		 
            component.set("v.spinner",true);
			component.set("v.requestCheckout",false);
			//davide.franzini - 16/09/2019 - WN-190 - passing context stringified 
			helper.prepareData(component,JSON.stringify(engineContext))
                .then(function(res){
				//enrico.purificato 22/10/2019 performance Start
				   return helper.createComplexProductBatch(res.component,res.bundleId,res.products,res.configuration);
	               //return helper.createAllProducts(res.component,res.bundleId,res.products,res.configuration);
				//enrico.purificato 22/10/2019 performance end
                }).then($A.getCallback(function(){
                	console.log('DONE');
				//	var a = component.get('c.handleAfterCheckOut');
				//	$A.enqueueAction(a);
					helper.handleAfterCheckOutHelper(component,event, helper); //18/07/19 calling  checkout helper
					//this.handleAfterCheckOut(component,event, helper);
                })).catch(function(error){
                	console.log(error);
                }); 
        }
        else if(clearCart)
        {
            //retriving context after clearing cart event:
            _utils.debug("retriving context after clearing cart event");
            var updateContext =	$A.get("e.NE:Bit2win_Event_RetrieveContext");
            updateContext.setParams({
                'componentRequest'		:	'catalog',
                'page'					:	1,
                "retrieveContext"		:	"bundle"
            });
            updateContext.fire();
            _utils.debug("FIRING _RetrieveContext after clearing cart event");

            //reset maps of error,warning
            component.set("v.MapAttributeItemsError",{});
            component.set("v.MapAttributeItemsWarning",{});
            component.set("v.clearCart", false);
        }

    	//28/01/19 francesca.ribezzi hiding spinner on Maintenance Summary cmp:
    	if(context == null && component.get("v.activatePreLoad") == true)
    	{
	        var spinnerEvent = $A.get("e.c:OB_SpinnerEvent");
	        spinnerEvent.setParams({
	        	"spinner": "slds-hide"
	        });
	        spinnerEvent.fire();
	    }
    },

    handleAfterCheckOut : function(component,event, helper)
    {
		_utils.debug("into handleAfterCheckOut");
		//var t0 = performance.now();
		console.log("handleAfterCheckOut init: " + performance.now());
		var blockCheckOut = component.get("v.blockCheckOut");
		if(blockCheckOut)
		{
			return;
		}
		//18/07/19 francesca.ribezzi this code below is useless as we are using a custom checkout - performance
    	/*var isMaintenancePricing = component.get("v.isMaintenancePricing");
    	var isMaintenance = component.get("v.isMaintenance");
    	var showTechDetail = component.get("v.showTechDetail");
    	var showPrintDocuments = component.get("v.showPrintDocuments");
    	var isEditCommissionModel = component.get("v.isEditCommissionModel");
		var borderWarning = document.getElementsByClassName('borderWarning');
		// Daniele Gandini <daniele.gandini@accenture.com>	- 21/05/2019 - TerminalsReplacement - Jump to tech details if Replacement case - START
		var isReplacement = component.get("v.isReplacement");
		// Daniele Gandini <daniele.gandini@accenture.com>	- 21/05/2019 - TerminalsReplacement - Jump to tech details if Replacement case - end

		
	    	if(borderWarning.length > 0)
	    	{
	    		//11/01/19 francesca.ribezzi - use the same logic in both maintenance and bit2flow:
	    		if(!isMaintenance)
	    		{
	    			//save and exit bundle with approve flag set to true.
		    		helper.setConfigurationToApprove(component,event,bitwinMap);
		    	}
		    	else
		    	{
		    		//redirect to dati operativi //31/01/19 and is not isEditCommissionModel
		    		if(isMaintenance && !isMaintenancePricing && !showTechDetail && !showPrintDocuments && !isEditCommissionModel)
		    		{
		    			helper.setConfigurationToApprove(component, event);
					}
					//02/02/19 
					else if(isEditCommissionModel && !showTechDetail && !showPrintDocuments)
					{
						//save and exit bundle with approve flag set to true.
						helper.setConfigurationToApprove(component,event,bitwinMap);
					}
					else
					{
						//redirect to dati operativi //31/01/19 and is not isEditCommissionModel
						if(isMaintenance && !isMaintenancePricing && !showTechDetail && !showPrintDocuments && !isEditCommissionModel)
						{
							helper.setConfigurationToApprove(component, event);
						}
						//02/02/19 
						else if(isEditCommissionModel && !showTechDetail && !showPrintDocuments)
						{
							helper.setConfigurationToApprove(component,event,bitwinMap);
						}

						//redirect to stampa documenti
						else if(isMaintenance && isMaintenancePricing && !isEditCommissionModel  && !showTechDetail && !showPrintDocuments)
						{
							//update configuration variation value and then calling redirectToPrintDocuments function
							helper.updateConfVariation(component, event);
						//01/02/19 approval process -> createLogRequest -> go back to anagrafica:
						}
						else if(isEditCommissionModel  && !showPrintDocument)
						{
							helper.createLogRequest(component, event);
						}
						//redirect to stampa documenti from TechDetail
						
						else if(isMaintenance && !isMaintenancePricing && showTechDetail && !showPrintDocuments)
						{
							component.set("v.showTechDetail",false);
							//get old next back
							var button2 = component.find('navigateStepBundle');
							$A.util.removeClass(button2, 'hidden');
							
							helper.redirectToPrintDocuments(component, event);
						}
					}
				}//end if approval process
				else
				{
					if(isMaintenance && isMaintenancePricing && !isEditCommissionModel  && !showTechDetail && !showPrintDocuments) // 
					{ 
						helper.updateConfVariation(component, event);
					}
					
					else if(isMaintenance && isEditCommissionModel && !showPrintDocuments && !showTechDetail)
					{
						helper.checkAcquiringChangesAndRedirect(component, event);//helper.redirectToPrintDocuments(component, event);
					}

		    	else if(isMaintenance && !isMaintenancePricing && !showTechDetail && !showPrintDocuments && !isReplacement)// added !isReplacement condition - DG - 21/05/2019
		    	{
		    		helper.redirectToTechDetails(component, event); //TODO: call bit2Flow Method
				}
				// Daniele Gandini <daniele.gandini@accenture.com>	- 21/05/2019 - TerminalsReplacement - if added - START
				else if(isReplacement)
				{
					helper.redirectToTechDetailsReplacement_helper(component, event);
				}
				// Daniele Gandini <daniele.gandini@accenture.com>	- 21/05/2019 - TerminalsReplacement - if added - END
		    	else if(isMaintenance && !isMaintenancePricing && showTechDetail && !showPrintDocuments) //
		    	{
		    		component.set("v.showTechDetail",false);
		    		//get old next back	
		            var button2 = component.find('navigateStepBundle');
		            $A.util.removeClass(button2, 'hidden');
		            
		    		helper.redirectToPrintDocuments(component, event);
		    	}
				else if(!isMaintenance)
				{
	    			helper.showBit2flowNext(component, event);
	    		}
			}
			
		var t1 = performance.now();
		console.log("Call handleAfterCheckout took " + (t1 - t0) + " milliseconds.");*/
    },
     
	previousStepBundle: function(component,event, helper)
	{
    	_utils.debug("into previousStepBundle");
    	var objectDataMap = component.get("v.objectDataMap");	
        var firstBundle = false;
        var step = component.get('v.bundleStep');
        var outerstep = component.get('v.step');
        var borderWarning = document.getElementsByClassName('borderWarning');
        var isMaintenance = component.get("v.isMaintenance");
	    var isMaintenancePricing = component.get("v.isMaintenancePricing");
        var bundId	= objectDataMap.unbind.offertaId;
        var	coreOutput	= component.get("v.contextOutput");
 		var selectedBundle='';
 		var bundleSelected;
 		var previousBtn;
 		var isSelectOffer = false;

 		var activeBundleStep;
 		//if I'm in the first bundle step, this let's you going back to the offer selection component:
 		if(outerstep == 1 && step == 0)
 		{
	    	isSelectOffer = true;
	    	outerstep--;
	    	var nextButtonOffer = component.find('buttondiv'); 
            var nextButtonBundle = component.find('navigateStepBundle'); 
            var previousButtonDiv = component.find('previousButtonDiv');
            $A.util.addClass(nextButtonBundle, 'hidden');
            $A.util.addClass(previousButtonDiv, 'hidden');
            $A.util.removeClass(nextButtonOffer, 'hidden');
            document.getElementById("nextBtnOffertaId").disabled = true;
			component.set("v.backToOfferSelection", true);
        }
        else
        {
        	component.set("v.backToOfferSelection", false);
	        for(var i in coreOutput.listOfBundles)
	        {
	            if(bundId == coreOutput.listOfBundles[i].id)
	            {
	            	if(step > 0)
	                {
	                	selectedBundle=  coreOutput.listOfBundles[i].bundleElements[step];
	                	bundleSelected =  coreOutput.listOfBundles[i];
	                    break;
	                }
	                firstBundle= true;
	                outerstep = 1;
	            }
	         }
	    }
        if(!firstBundle && !isSelectOffer)
        {
            var configureBundle 	= 	$A.get("e.NE:Bit2win_Event_BundleElements");   
            configureBundle.setParams({
                'BundleElement'	: 	selectedBundle //entra in verifica del contenuto di un bundle element
            });
            _utils.debug('FIRE EVENT __Bit2win_Event_BundleElements');
            configureBundle.fire(); 
            //if we are in the price summary component, by clicking previous we go back to offer selection component:         
            if(outerstep == 2 || (outerstep > 2 && borderWarning.length > 0)) 
            {
                outerstep= 0;
                step= 0;
                isSelectOffer = true;
                var objectDataMap = component.get("v.objectDataMap");
                var offertaId = objectDataMap.unbind.offertaId;
                component.set("v.offertaId", offertaId);

                var nextButtonOffer = component.find('buttondiv');
                var nextButtonBundle = component.find('navigateStepBundle');
                var previousButtonDiv = component.find('previousButtonDiv');
                $A.util.addClass(nextButtonBundle, 'hidden');
                $A.util.addClass(previousButtonDiv, 'hidden');
                $A.util.removeClass(nextButtonOffer, 'hidden');
                document.getElementById("nextBtnOffertaId").disabled = true;
                component.set("v.backToOfferSelection", true);
                //added 14/02/19 FR
                component.set("v.afterSummary", false);
            }else
            {
            	step--;
            	activeBundleStep = bundleSelected.bundleElements[step].fields.active;
            }
            
            if( (activeBundleStep == 'false' || activeBundleStep == false) && activeBundleStep != null)
            {
            	component.set('v.bundleElementName',bundleSelected.bundleElements[step-1].fields.name);
            	step--;
            }
            else
            {
            	component.set('v.bundleElementName',bundleSelected.bundleElements[step].fields.name);
            }
            //check if is not an usual step
            var direction = 'previous';
            if(step == 0)
            {
            	component.set("v.isUnusualStep",false);
            	//if maintenance, hide previous HERE!
            	if(isMaintenance)
            	{
            		//change button of offers selection in button for bundle progression
		            var previousButtonDiv = component.find('previousButtonDiv'); 
		            if(  !($A.util.hasClass(previousButtonDiv,'hidden')) )
		            {
		            	$A.util.addClass(previousButtonDiv, 'hidden');
		            }
            	}
            }
            else
            {
            	helper.isUnusualStep(component,event,direction);
            }
        }
        if(isSelectOffer) //firstBundle && isSelectOffer
        {
    	   //close current configuration after next
        	var closeConfEvent 	= 	$A.get("e.NE:Bit2Win_Event_ResetSaveConfiguration");
            closeConfEvent.setParams({

			    "CartService_Output": coreOutput,
			    "type": "save"
            });

            closeConfEvent.fire();   	

           var configureBundle 	= 	$A.get("e.NE:Bit2Win_Event_ResetSaveConfiguration");   //Do I need this event??
            configureBundle.setParams({
                'type'	: 	'saveBundle'
            });
            _utils.debug('FIRE EVENT __Bit2Win_Event_ResetSaveConfiguration');
            configureBundle.fire();
        }
        component.set('v.step',outerstep);
        component.set('v.bundleStep',step);
        _utils.debug('previous bundle');
    },

          //NEW
    onUpdateApprovalOrderRules: function(component,event, helper)
    {
		var idChild = event.getParam("IdChildItem");
		var checkAttributeRules = event.getParam("checkAttributeRules");  
		if($A.util.isEmpty(idChild)){
			return;
		}
    	if(checkAttributeRules == 'error')
    	{
			//giovanni spinelli 02/08/2019 fire toast - start
			helper.showInfoToast(component, event , $A.get("$Label.c.OB_RemoveErrors") ,'Error');
    	}
    	if(checkAttributeRules == 'warning')
    	{
			//giovanni spinelli 02/08/2019 fire toast - start
			helper.showInfoToast(component, event , $A.get("$Label.c.OB_ApproverMessage")  ,'Warning');
			//giovanni spinelli 02/08/2019 fire toast - end
    	}
		if(component.get("v.isMaintenancePricing")){  
			helper.checkVariation(component, event, idChild); //francesca.ribezzi 25/11/19 - performance calling checkVariation 
		}
		component.set("v.checkAttributeRules", checkAttributeRules);
		console.log("checkAttributeRules: " + checkAttributeRules); 
    },
    
    handleModalButton: function(component,event, helper)
    {
        var configureBundle 	= 	$A.get("e.NE:Bit2Win_Event_ResetSaveConfiguration");
        configureBundle.setParams({
            'type'	: 	'saveBundle'
        });
        _utils.debug('FIRE EVENT __Bit2Win_Event_ResetSaveConfiguration');
        configureBundle.fire();
        component.set('v.requestCheckout',true);
        component.set('v.afterSummary',true);

        component.set("v.showWarningModal", false);
		component.set("v.spinner",true);
		
		//START gianluigi.virga - 20/09/2019 Update privacy fields on service point
		if((component.get("v.objectDataMap.isPreventivo") == true || component.get("v.objectDataMap.isPreventivo") == 'true') && (component.get("v.isPrivacyOk") == true || component.get("v.isPrivacyOk") == 'true')){
			helper.setPrivacy(component, event, helper);
		}
		//END gianluigi.virga - 20/09/2019 
    },
    
    //closing modal:
    handleModalCancel: function(component,event, helper)
    {
		component.set("v.objectDataMap.isPreventivo", false); //gianluigi.virga 19/09/2019
    	component.set("v.showWarningModal", false);
    	component.set("v.spinner",false);
    }, 
	
	handleMaintenanceEvent : function(component,event, helper)
	{
		console.log("into handleMaintenanceEvent");
		var t0 = performance.now();
		var ordIdParam = event.getParam("ordIdParam");
		var bundleStep = event.getParam("bundleStep");
		var step = event.getParam("step");
		var isMaintenancePricing = event.getParam("isMaintenancePricing");
		var isEditCommissionModel = event.getParam("isEditCommissionModel");
		var isMaintenance = event.getParam("isMaintenance");
		var offertaId = event.getParam("offertaId");
		console.log("offertaId id from event: " + offertaId);
		var isMaintenance = event.getParam("isMaintenance");

		console.log("ord id from event: " + ordIdParam);
		component.set("v.ordIdParam", ordIdParam);
		component.set("v.bundleStep", bundleStep);
		component.set("v.step", step);
		component.set("v.isMaintenancePricing", isMaintenancePricing);
		component.set("v.isEditCommissionModel", isEditCommissionModel);
		component.set("v.offertaId", offertaId);
		component.set("v.isMaintenance", isMaintenance);
		console.log("before calling doInitHelper");
			//enrico.purificato 23/10/2019 performance start
			var assetId = event.getParam("assetId");
			var sessionId  = event.getParam("sessionId");
			component.set("v.sessionId", sessionId);
			if(sessionId !='' && sessionId != undefined){
				helper.callAssetToOrderItem(component,ordIdParam,assetId);
			}else
			{
			 component.set("v.asset2OrderDone",true);  
			}
			//enrico.purificato 23/10/2019 performance end
		helper.handleRestartCart(component, event);
		helper.doInitHelper(component, event);
	},

	onUpdateMapForMaggiorazione : function(component,event, helper)
	{
		var mapChildIdName = event.getParam("mapChildIdName");
		console.log("mapChildIdName: ", mapChildIdName);
		component.set("v.mapChildIdName", mapChildIdName);
	},
	//andrea morittu 22/09/2019
	cancelOrder_JS : function(component, event, helper) {
		component.set('v.spinner', true);
		helper.cancelOrder(component, event, helper);
	},
	//START gianluigi.virga 18/09/2019 - Printed quote			
    flowSave : function(component, event, helper){
    	_utils.debug("__into flowSave");
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
					component.set("v.redirect", res);
					var quote = component.get('c.generateQuote');
        			$A.enqueueAction(quote);
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
	generateQuote : function(component, event){
		var quoteCmp = component.find("quote");
		Promise.all([								  
			quoteCmp.callDocService()
		]).then(function(response) {
			var exit = component.get('c.flowExit');
        	$A.enqueueAction(exit);
		}).catch(
			function(error){												 
				console.log(error);									  
		});
	},
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
	//END gianluigi.virga



})