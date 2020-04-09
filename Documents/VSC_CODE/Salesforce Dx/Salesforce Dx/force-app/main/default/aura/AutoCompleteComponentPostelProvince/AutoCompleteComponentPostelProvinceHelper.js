({
    getResponse : function(component, url, field) {
        var listaProvince = [];
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
                component.set("v.responseProv",component.get("v.response"));
                for (var key in component.get("v.response")) {
                    listaProvince.push(component.get("v.response")[key]);
                }
                component.set('v.provinceList',listaProvince.sort());
                console.log(component.get('v.provinceList'));
                console.log(listaProvince);     
                j$('[id$="provincia"]').autocomplete({
                    //GET ARRAY 
                    source: listaProvince
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
    province : function(component, event , helper){
    	var objectDataMap = component.get("v.objectDataMap");
    	var provinceId = component.get("v.provinceId");
    	var provinceElement = document.getElementById(provinceId);
    	var comuneElement = document.getElementById("comune"+sectionName);
        var provs = component.get("v.responseProv");
        var addressMapping = component.get("v.addressMapping");
        var sectionName = component.get("v.addressMapping.sectionName");
        if(sectionName == undefined || sectionName == null)
        	sectionName='';
        console.log('provs: ' + (provs!=null && provs.size>0) );
       // console.log('provs: ' + provs.includes('Error'));
        
            //**-GIOVANNI SPINELLI -START-CREAT A SET OF VALUE OF PROVINCE**//
            console.log('mapSymbolProvince: ' + JSON.stringify(component.get('v.mapSymbolProvince'))); 
            console.log('provinceList: '      + JSON.stringify(component.get('v.provinceListFromService'))); 
            var mapSymbolProvince = component.get('v.mapSymbolProvince');
            var provinceList = component.get('v.provinceListFromService');
            var provinceValue = event.target.value;
            var setProvince =[];
            console.log('provinceValue:' + provinceValue);
            var symbols ;
            for( symbols in mapSymbolProvince){
                 console.log('symbols: ' + symbols);
                // console.log('mapSymbolProvince[symbols]: ' + mapSymbolProvince[symbols]);
                // console.log('includes?: ' + symbols.includes(provinceValue.toUpperCase()) );
                for(var i=0; i<provinceList.length; i++)
                {
                    if((provinceList[i].includes(provinceValue.toUpperCase()) && !setProvince.includes(symbols+' - '+mapSymbolProvince[symbols]) )|| 
                        (symbols.includes(provinceValue.toUpperCase())) && !setProvince.includes(symbols+' - '+mapSymbolProvince[symbols]))
                    {
                        //alert('contiene la provincia: ' + mapSymbolProvince[symbols] );
                        setProvince.push(symbols+' - '+mapSymbolProvince[symbols]);
                        //setProvince.push(symbols);
                        //console.log('tipo oggetto 1: ' + typeof mapSymbolProvince[symbols].toString());
                    }
                    // if(provinceList[i].includes(provinceValue.toUpperCase()) && !setProvince.includes(provinceList[i]) )
                    // {
                    //     setProvince.push(provinceList[i].toString());
                    // }
                }
                
             }
            console.log('setProvince: ' +  setProvince);
            //**GIOVANNI SPINELLI -START-CREAT A SET OF VALUE OF PROVINCE**//
	        //var item = xml.getElementsByTagName('item')[0];
            var j$ = jQuery.noConflict();
	        console.log('provs: ' + JSON.stringify(provs));
	        var listaProvince = [];
	        var mapProvince = {};
	        
	        for (var key in provs) {
	        	var provString = (provs[key].toString()).split("_");
	        	var provName = provString[0];
	        	var provSigla = provString[1];
	            listaProvince.push(provName);
                //console.log('tipo oggetto 2: ' + typeof provName);
	            mapProvince[provName] = provSigla;
	        }
	        component.set('v.provinceList',listaProvince.sort());
	        component.set('v.provinceMap',mapProvince);
	        console.log('lista province alessandro: '+component.get('v.provinceList'));
            console.log('mappa province alessandro: '+JSON.stringify(component.get('v.provinceMap')));
			// ----11/09/2018--START--SALVATORE P.--REPLACE &#39; WITH APOSTROPHE
			for (var i = 0; i < listaProvince.length; i++) 
			{
				listaProvince[i] = listaProvince[i].replace("&#39;","\'");
			}
            //console.log('concat list: ' + setProvince.concat(listaProvince) );
            //console.log('setProvince type: ' + typeof setProvince); 

			// ----11/09/2018--END------------	
            function split( val ) {
                 console.log('val in split: ' + JSON.stringify(val['value']));
                 console.log('val splittato: ' + val['value'].split( ' - ')[1]);
                 j$('[id$="'+provinceId+'"]').val(val['value'].split( ' - ')[1]);
                 return val['value'].split( ' - ')[1];
                }
                console.log('setProvince' +JSON.stringify(setProvince) +'------'+  setProvince.length);
                // Elena Preteni 17/01/2019 CAP change to inputText but service not down
            if((setProvince!=null && setProvince.length>0 )|| (component.get("v.provinceListFromService")!=null && component.get("v.provinceListFromService").length>0)){
                // Elena Preteni 17/01/2019 CAP change to inputText but service not down
    	        j$('[id$="'+provinceId+'"]').autocomplete({
    	            source: setProvince,
                    select: function( event, ui , value) {
                        console.log('this.value: ' + this.value);
                        var terms = split( ui.item);
                        console.log('TERMS: ' + terms);
                        component.set('v.provinceString' , terms);
                        ui.item.value=terms;
                    },
                    
    	            change: function (event, ui) {
    	                if(!ui.item){
    	                    /*http://api.jqueryui.com/autocomplete/#event-change -
    	                     The item selected from the menu, if any. Otherwise the property is null
    	                     so clear the item for force selection*/
    	                   j$('[id$="'+provinceId+'"]').val("");

    	                   if(document.getElementById("comune"+sectionName)!=null && document.getElementById("comune"+sectionName)!=undefined ){
    				            document.getElementById("comune"+sectionName).disabled=true;
    		        			document.getElementById("comune"+sectionName).value='';
    		        			component.set("v.objectDataMap."+ component.get("v.addressMapping.cityinputobject") + "." + component.get("v.addressMapping.cityinputfield") ,  '' );
                                console.log('if change');
    				        }
    	                    
    	                  
    	                } else {
                            component.set("v.isServiceDown",false);
                            //(j$('[id$="'+provinceId+'"]').value).split(' - ')[1];
                            // component.set('v.provinceString' , document.getElementById(provinceId).value.split(' - ')[1]);
                            //console.log('provice value in else: ' + document.getElementById(provinceId).value.split(' - ')[1]);
                            //ui.item.value =document.getElementById(provinceId).value.split(' - ')[1];
    	                	console.log('change test');
    	                	if(document.getElementById("comune"+sectionName)!=null && document.getElementById("comune"+sectionName)!=undefined ){
    				            document.getElementById("comune"+sectionName).disabled=false;
    		        			document.getElementById("comune"+sectionName).value='';
    		        			component.set("v.objectDataMap."+ component.get("v.addressMapping.cityinputobject") + "." + component.get("v.addressMapping.cityinputfield") ,  '' );
    				        }
    	                    
    	                }
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
    		         if(document.getElementById("presso"+sectionName)!=null && document.getElementById("presso"+sectionName)!=undefined ){
    	            	document.getElementById("presso"+sectionName).value='';
    	            	component.set("v.objectDataMap."+ component.get("v.addressMapping.pressoinputobject") + "." + component.get("v.addressMapping.pressoinputfield") ,  '' );
    		         }   
    				 //component.set("v.objectDataMap."+ component.get("v.addressMapping.zipcodeinputobject") + "." + component.get("v.addressMapping.zipcodeinputfield") ,  '' );
    			
    	            },

    	        }); 
            
	        //component.set("v.triggleSpinner",false);
	        //console.log('false spinner'+component.get("v.triggleSpinner"));
        

        }
        //  START   micol.ferrari 21/12/2018
        else
        {
            component.set("v.isServiceDown",true);
        }
        //  END   micol.ferrari 21/12/2018
    },
    removeRedBorder: function (component, event , helper){
    	var sectionName = component.get("v.addressMapping.sectionName");
    	if(sectionName == undefined || sectionName == null)
    		sectionName='';
    	console.log('sectionName'+sectionName);
        var errorId = 'errorIdprovincia'+sectionName;
        console.log("errorId = "+ errorId);

        //REMOVE ERROR MESSAGE
        var x =  document.getElementById(errorId);
        console.log(" Id error provincia " +document.getElementById(errorId));

        $A.util.removeClass(document.getElementById("provincia"+sectionName), 'slds-has-error');
        $A.util.addClass(document.getElementById("provincia"+sectionName), 'slds-input');
        if(x){
        	x.remove();
            console.log(" Id error provincia " +document.getElementById(errorId));
        }
        
    },
    removeRedBorderEE: function (component, event , helper){
    	var sectionName = component.get("v.addressMapping.sectionName");
    	if(sectionName == undefined || sectionName == null)
    		sectionName='';
    	console.log('sectionName'+sectionName);
        var errorId = 'errorIdprovinceEE'+sectionName;
        console.log("errorId = "+ errorId);
        var x =  document.getElementById(errorId);
        console.log(" Id error provincia ee " +document.getElementById(errorId));

        $A.util.removeClass(document.getElementById("provinceEE"+sectionName), 'slds-has-error');
        $A.util.addClass(document.getElementById("provinceEE"+sectionName), 'slds-input');
        if(x){
        	x.remove();
            console.log(" Id error provincia ee " +document.getElementById(errorId));
        }
        
    },
    //GIOVANNI SPINELLI - 23/11/2018
    /***METHOD TO SPIT LIST OF PROVINCE AND SYMBOL OF PROVINCE IN DIFFERENT LIST***/
    getProvinceAndSymbol : function(component) {
        console.log("****in callProvince")
        //MAP WITH KEY=SYMBOL AND VALUE=PROVINCE
        //var mapSymbolProvinceTmp = new Map();
        var symbol;
        var province;
        //LIST OF PROVINCE
        var provinceList = [];
        var action = component.get("c.getProvince");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue()
                console.log('****RESPONSE Province : '+JSON.stringify(res));
                component.set("v.responseProv", res);
                for(var key in res){
                    // console.log('VALUE MAP PROVINCE: '+ res[key]);
                    // console.log('VALUE MAP PROVINCE PROVINCE: '+ res[key].split('_')[0]);
                    // console.log('VALUE MAP PROVINCE SYMBOL: '  + res[key].split('_')[1]);
                    symbol   = res[key].split('_')[1];
                    province = res[key].split('_')[0]
                    component.get('v.mapSymbolProvince')[symbol] =province ;
                    provinceList.push(res[key].split('_')[0]);
                }
                //console.log('MAP IN JAVASCRIPT: ' + JSON.stringify(mapSymbolProvinceTmp)); 
                //component.set('v.mapSymbolProvince' , JSON.stringify(mapSymbolProvinceTmp));
                component.set('v.provinceListFromService'      ,  provinceList); 
                // console.log('mapSymbolProvince: ' + JSON.stringify(component.get('v.mapSymbolProvince')));
                // console.log('provinceList: '      + JSON.stringify(component.get('v.provinceListFromService')));          
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
                    console.log("****Unknown error");
                }
            }
        });
        
        $A.enqueueAction(action);
    },

    /**
    * @author Marta Stempien <marta.stempien@accenture.com>
    * @date 01/08/2019
    * @task NEXI-245
    * @parameters component, provinceInputField
    * @description Method sets appropriate value of "v.addressMapping.provincedisabled"
    */
    disableFieldsIfNeeded : function(component, provinceInputField)
    {
        if( component.get("v.isTrueDisableFields") && component.get("v.disabledFields").includes(provinceInputField))
        {
            component.set("v.addressMapping.provincedisabled", true);
            return;
        }
        component.set("v.addressMapping.provincedisabled", false);
    }
    
})