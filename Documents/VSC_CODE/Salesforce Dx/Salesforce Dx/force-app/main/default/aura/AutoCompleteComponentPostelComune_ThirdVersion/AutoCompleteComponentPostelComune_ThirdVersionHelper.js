({
    getResponse : function(component, url, field) {
        var listaComuni = [];
        var j$ = jQuery.noConflict(); 
        console.log('sono nel getResponse');
        console.log('url'+ url);
        console.log('field' + field);
        var action = component.get("c.getResult");
        console.log('action' + action);
        action.setParams({
            "url": url,
            "field": field
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.response", response.getReturnValue());
                component.set("v.responseCom",component.get("v.response"));
                for (var key in component.get("v.response")) {
                    listaComuni.push(component.get("v.response")[key]);
                }
                component.set('v.comuni',listaComuni.sort());
                //console.log('comuni'+component.get('v.comuni'));
                console.log(listaComuni);     
                j$('[id$="comune"]').autocomplete({
                    //GET ARRAY 
                    source: listaComuni
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
     city : function(component, event , helper){
        var sectionName = component.get("v.addressMapping.sectionName");
        if(sectionName == undefined || sectionName == null)
        	sectionName='';
    	var comuneId = component.get("v.cityId");
    	console.log('comune value'+document.getElementById("comune"+sectionName).value);
        var comuneElement = document.getElementById("comune"+sectionName);
        var coms = component.get("v.responseCom");
        //var item = xml.getElementsByTagName('item')[0];
        console.log('coms'+JSON.stringify(coms));
        var listaComuni = [];
        var j$ = jQuery.noConflict();
        if(coms!=null && typeof coms == 'object' ){
	        for (var key in coms) {
	            listaComuni.push(coms[key]);
	        }
	        component.set('v.comuniList',listaComuni.sort());
	        //console.log('comuni'+component.get('v.comuni'));
	        // ----11/09/2018--START--SALVATORE P.--REPLACE &#39; WITH APOSTROPHE
			for (var i = 0; i < listaComuni.length; i++) 
			{
				listaComuni[i] = listaComuni[i].replace("&#39;","\'");
			}
			// ----11/09/2018--END------------
	        console.log(listaComuni);  
	        console.log('comuneId helper'+comuneId+'  [id$="'+comuneId+'"]');   
            if(listaComuni.length>0){
    	        j$('[id$="'+comuneId+'"]').autocomplete({
    	            //GET ARRAY 
    	            source: listaComuni.sort(),
    	            change: function (event, ui) {
    		                if(!ui.item){
    		                    /*http://api.jqueryui.com/autocomplete/#event-change -
    		                     The item selected from the menu, if any. Otherwise the property is null
    		                     so clear the item for force selection*/
    		                   j$('[id$="'+comuneId+'"]').val("");
    		                    if(document.getElementById("frazione"+sectionName)!=null && document.getElementById("frazione"+sectionName)!=undefined ){
    			                	document.getElementById("frazione"+sectionName).disabled=true;
    			        			document.getElementById("frazione"+sectionName).value='';
    			        			component.set("v.objectDataMap."+ component.get("v.addressMapping.districtinputobject") + "." + component.get("v.addressMapping.districtinputfield") ,  '' );
    					         }
    					         if(document.getElementById("strada"+sectionName)!=null && document.getElementById("strada"+sectionName)!=undefined ){
    					        	document.getElementById("strada"+sectionName).disabled=true;
    				        		document.getElementById("strada"+sectionName).value='';
    				        		component.set("v.objectDataMap."+ component.get("v.addressMapping.streetinputobject") + "." + component.get("v.addressMapping.streetinputfield") ,  '' );
    					         }
    					         if(document.getElementById("civico"+sectionName)!=null && document.getElementById("civico"+sectionName)!=undefined ){
    					        	document.getElementById("civico"+sectionName).disabled=true;
    				        		document.getElementById("civico"+sectionName).value='';
    				        		component.set("v.objectDataMap."+ component.get("v.addressMapping.streetnumberinputobject") + "." + component.get("v.addressMapping.streetnumberinputfield") ,  '' );
    					         }
    		                } else {
    			                if(document.getElementById("frazione"+sectionName)!=null && document.getElementById("frazione"+sectionName)!=undefined ){
    			                	document.getElementById("frazione"+sectionName).disabled=false;
    			        			document.getElementById("frazione"+sectionName).value='';
    			        			component.set("v.objectDataMap."+ component.get("v.addressMapping.districtinputobject") + "." + component.get("v.addressMapping.districtinputfield") ,  '' );
    					         }
    					         if(document.getElementById("strada"+sectionName)!=null && document.getElementById("strada"+sectionName)!=undefined ){
    					        	document.getElementById("strada"+sectionName).disabled=false;
    				        		document.getElementById("strada"+sectionName).value='';
    				        		component.set("v.objectDataMap."+ component.get("v.addressMapping.streetinputobject") + "." + component.get("v.addressMapping.streetinputfield") ,  '' );
    					         }
    					         if(document.getElementById("civico"+sectionName)!=null && document.getElementById("civico"+sectionName)!=undefined ){
    					        	document.getElementById("civico"+sectionName).disabled=false;
    				        		document.getElementById("civico"+sectionName).value='';
    				        		component.set("v.objectDataMap."+ component.get("v.addressMapping.streetnumberinputobject") + "." + component.get("v.addressMapping.streetnumberinputfield") ,  '' );
    					         }
    			          }
    			          if(document.getElementById("presso"+sectionName)!=null && document.getElementById("presso"+sectionName)!=undefined ){
    			            	document.getElementById("presso"+sectionName).value='';
    			          }
    	
    		
    		        }
    	        }); 
            }
        }
    },
     removeRedBorder: function (component, event , helper){
    	var sectionName = component.get("v.addressMapping.sectionName");
    	if(sectionName == undefined || sectionName == null)
    		sectionName='';
        var errorId = 'errorIdcomune'+sectionName;
        //REMOVE ERROR MESSAGE
        $A.util.removeClass(document.getElementById("comune"+sectionName), 'slds-has-error flow_required');
        $A.util.addClass(document.getElementById("comune"+sectionName), 'slds-input');
       if(document.getElementById(errorId)!=null){
        console.log("errorID . " + errorId);
            document.getElementById(errorId).remove();
        }
    }, 
    removeRedBorderEE: function (component, event , helper){
    	var sectionName = component.get("v.addressMapping.sectionName");
    	if(sectionName == undefined || sectionName == null)
    		sectionName='';
    	console.log('sectionName'+sectionName);
        var errorId = 'errorIdcityEE'+sectionName;
        //REMOVE ERROR MESSAGE
        $A.util.removeClass(document.getElementById("cityEE"+sectionName), 'slds-has-error flow_required');
        $A.util.addClass(document.getElementById("cityEE"+sectionName), 'slds-input');
       if(document.getElementById(errorId)!=null){
    	   console.log("errorID . " + errorId);
            document.getElementById(errorId).remove();
        }
        
    }

})