({
    getCap : function(component, street,keyCity) {
        var action = component.get("c.getCaps");
        var zipcodeinputobject = component.get("v.addressMapping.zipcodeinputobject");
        var zipcodeinputfield = component.get("v.addressMapping.zipcodeinputfield");
        console.log('street'+street);
        console.log('keyCity'+keyCity);
        action.setParams({
            "street": street,
            "keyCity": keyCity
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
            	var res = response.getReturnValue()
            	console.log('RESPONSE CAP'+JSON.stringify(res));
                component.set("v.caps", response.getReturnValue());  
                var caps = response.getReturnValue();
                 if(caps != null && caps != []){
		        	console.log("I cap sono dentro: " + caps);
		        	component.set("v.objectDataMap."+ zipcodeinputobject + "." + zipcodeinputfield ,  caps[0]); 
		        }             
            } else if (state === "INCOMPLETE") {
            } else if (state === "ERROR") {
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
    }, street: function(component, event , helper){
    		var stradaId = component.get("v.stradaId");
    		var civicoId = component.get("v.civicoId");
    		var j$ = jQuery.noConflict();    
    		var sectionName = component.get("v.addressMapping.sectionName");
	        if(sectionName == undefined || sectionName == null)
	        	sectionName='';
	        var streets = component.get("v.responseStreets");
	        if(streets!=null){
		        var listaStrade = [];
		        var j$ = jQuery.noConflict();
		      /*  if(typeof streets == 'object'){
			        for (var key in streets) {
			        	
			            listaStrade.push(streets[key].replace("&#39;","\'"));
			        }
			    }*/
			    console.log('TEST'+JSON.stringify(Object.values(streets)));
			    //listaStrade.concat(Object.values(streets));
			    Array.prototype.push.apply(listaStrade, Object.values(streets));
		        component.set('v.streets',listaStrade.sort());
		        //console.log('comuni'+component.get('v.comuni'));
				// ----11/09/2018--START--SALVATORE P.--REPLACE &#39; WITH APOSTROPHE
				for (var i = 0; i < listaStrade.length; i++) {
					listaStrade[i] = listaStrade[i].replace("&#39;","\'");
				}
				// ----11/09/2018--END------------	
				console.log('listaStrade.length>0 '+ listaStrade.length>0);			 
		        if( listaStrade.length>0){
    		        j$('[id$="'+stradaId+'"]').autocomplete({
    		            //GET ARRAY 
    		            source: listaStrade,
    		            change: function (event, ui) {
							console.log('ui.item '+ui.item);
    		                if(!ui.item){
    		                    /*http://api.jqueryui.com/autocomplete/#event-change -
    		                     The item selected from the menu, if any. Otherwise the property is null
    		                     so clear the item for force selection*/
    		                	j$('[id$="'+stradaId+'"]').val("");
    		                }
    		                component.set("v.caps",'');
    		                if(document.getElementById("civico"+sectionName)!=null && document.getElementById("civico"+sectionName)!=undefined ){
    		                	if(document.getElementById("strada"+sectionName) && document.getElementById("strada"+sectionName).value == ''){
    		                		document.getElementById("civico"+sectionName).value='';
    		                	}
    		                }
    		            }
    		        }); 
                }
	        }
	        document.getElementById(civicoId).disabled=false;
        },
    removeRedBorder: function (component, event , helper){
    	var sectionName = component.get("v.addressMapping.sectionName");
    	if(sectionName == undefined || sectionName == null)
    		sectionName='';
        var errorIdstrada = 'errorIdstrada'+sectionName;
        $A.util.removeClass(document.getElementById("strada"+sectionName), 'slds-has-error flow_required');
        $A.util.addClass(document.getElementById("strada"+sectionName), 'slds-input');
        
       if(document.getElementById(errorIdstrada)!=null){
    	    console.log("errorID . " + errorIdstrada);
            document.getElementById(errorIdstrada).remove();
        }
    },
    removeRedBorderCivico: function (component, event , helper){
    	var sectionName = component.get("v.addressMapping.sectionName");
    	if(sectionName == undefined || sectionName == null)
    		sectionName='';
        var errorIdnumber = 'errorIdcivico'+sectionName; 
		$A.util.removeClass(document.getElementById("civico"+sectionName), 'slds-has-error flow_required');
		$A.util.addClass(document.getElementById("civico"+sectionName), 'slds-input');
		
        if(document.getElementById(errorIdnumber)!=null){
    	    console.log("errorID . " + errorIdnumber);
            document.getElementById(errorIdnumber).remove();
        }
    },
     removeRedBorderEE: function (component, event , helper){
    	 var sectionName = component.get("v.addressMapping.sectionName");
    	if(sectionName == undefined || sectionName == null)
    		sectionName='';
    	console.log('sectionName'+sectionName);
        var errorIdstrada = 'errorIdstreetEE'+sectionName;
        $A.util.removeClass(document.getElementById("streetEE"+sectionName), 'slds-has-error flow_required');
        $A.util.addClass(document.getElementById("streetEE"+sectionName), 'slds-input');
        
       if(document.getElementById(errorIdstrada)!=null){
    	    console.log("errorID . " + errorIdstrada);
            document.getElementById(errorIdstrada).remove();
        }
    },
    removeRedBorderCivicoEE: function (component, event , helper){
    	var sectionName = component.get("v.addressMapping.sectionName");
    	if(sectionName == undefined || sectionName == null)
    		sectionName='';
    	console.log('sectionName'+sectionName);
        var errorIdnumber = 'errorIdcivicoEE'+sectionName; 
		$A.util.removeClass(document.getElementById("civicoEE"+sectionName), 'slds-has-error flow_required');
		$A.util.addClass(document.getElementById("civicoEE"+sectionName), 'slds-input');
		
        if(document.getElementById(errorIdnumber)!=null){
    	    console.log("errorID . " + errorIdnumber);
            document.getElementById(errorIdnumber).remove();
        }
    }
        
    
})