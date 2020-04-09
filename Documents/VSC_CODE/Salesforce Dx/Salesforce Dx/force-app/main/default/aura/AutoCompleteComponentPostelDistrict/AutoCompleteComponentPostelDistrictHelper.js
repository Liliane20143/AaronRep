({
	getResponse : function(component, url, field) {
	 
		var listaDistr = [];
		var j$ = jQuery.noConflict(); 
		console.log('sono nel getResponse');
		console.log('url'+ url);
		console.log('field' + field);
		var action = component.get("c.getResult");
		console.log('action frazione' + action);
		action.setParams({
			"url": url,
			"field": field
		});
		action.setCallback(this, function(response){
			var state = response.getState();
			console.log("the state of frazione is: " + state);
			if (state === "SUCCESS") {
				console.log("the response is: " + response.getReturnValue());
				component.set("v.response", response.getReturnValue());
				component.set("v.responseDistr",response.getReturnValue());
				for (var key in component.get("v.response")) {
					listaDistr.push(component.get("v.response")[key]);
				}
				component.set('v.frazioni',listaDistr.sort());
				//console.log('comuni'+component.get('v.comuni'));
			   // console.log(listaComuni);     
				j$('[id$="frazione"]').autocomplete({
					//GET ARRAY 
					source: listaDistr
				});  
			} else if (state === "INCOMPLETE") {
				
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
	},
	district :function(component, event , helper){
		var sectionName = component.get("v.addressMapping.sectionName");
		if(sectionName == undefined || sectionName == null)
			sectionName='';
    	var districtId = component.get("v.districtId");
		var listaDistr = [];
		var j$ = jQuery.noConflict(); 
		var frazioneElement = document.getElementById("frazione"+sectionName);
		if(component.get("v.responseDistr")!=null ){
			for (var key in component.get("v.responseDistr")) {
				listaDistr.push(component.get("v.responseDistr")[key]);
			}
			component.set('v.frazioni',listaDistr.sort());
			//console.log('comuni'+component.get('v.comuni'));
			// console.log(listaComuni);
			// ----11/09/2018--START--SALVATORE P.--REPLACE &#39; WITH APOSTROPHE
			// for (var i = 0; i < listaDistr.length; i++) {
			// 	 // var valueDist = listaDistr[i];
			// 	// if(valueDist.includes("&#39;")){
			// 		// listaDistr[i] = (listaDistr[i]).replaceAll("&#39;","\'");
			// 	// } 
			// 	//listaDistr[i] = listaDistr[i].replace("&#39;","\'");
		
			// }
			// ----11/09/2018--END------------
			if(listaDistr.length>0){
				j$('[id$="'+districtId+'"]').autocomplete({
					//GET ARRAY 
					source: listaDistr,
		            change: function (event, ui) {
		                if(!ui.item){
		                    /*http://api.jqueryui.com/autocomplete/#event-change -
		                     The item selected from the menu, if any. Otherwise the property is null
		                     so clear the item for force selection*/
		                	j$('[id$="'+districtId+'"]').val("");
		                }
		                /*if(document.getElementById("strada"+sectionName)!=null && document.getElementById("strada"+sectionName)!=undefined ){
				            if(frazioneElement && frazioneElement.value == ''){
				        		document.getElementById("strada"+sectionName).value='';
				        		component.set("v.objectDataMap."+ component.get("v.addressMapping.streetinputobject") + "." + component.get("v.addressMapping.streetinputfield") ,  '' );
				        	}
				        }
				        if(document.getElementById("civico"+sectionName)!=null && document.getElementById("civico"+sectionName)!=undefined ){
				            if(frazioneElement && frazioneElement.value == ''){
				        		document.getElementById("civico"+sectionName).value='';
				        		component.set("v.objectDataMap."+ component.get("v.addressMapping.streetnumberinputobject") + "." + component.get("v.addressMapping.streetnumberinputfield") ,  '' );
				        	}
				        }
				        if(document.getElementById("presso"+sectionName)!=null && document.getElementById("presso"+sectionName)!=undefined ){
				            if( frazioneElement && frazioneElement.value == ''){
				            	document.getElementById("presso"+sectionName).value='';
				            	component.set("v.objectDataMap."+ component.get("v.addressMapping.pressoinputobject") + "." + component.get("v.addressMapping.pressoinputfield") ,  '' );
				            }
				        }*/
		
		            }
				});  
			}
		}
	},
	removeRedBorderEE: function (component, event , helper){
		var sectionName = component.get("v.addressMapping.sectionName");
		if(sectionName == undefined || sectionName == null)
			sectionName='';
        var errorIddistrict = 'errorIddistrictEE'+sectionName;
        $A.util.removeClass(document.getElementById("districtEE"+sectionName), 'slds-has-error flow_required');
        
       if(document.getElementById(errorIddistrict)!=null){
    	    console.log("errorID . " + errorIddistrict);
            document.getElementById(errorIddistrict).remove();
        }
    },
	
	
})