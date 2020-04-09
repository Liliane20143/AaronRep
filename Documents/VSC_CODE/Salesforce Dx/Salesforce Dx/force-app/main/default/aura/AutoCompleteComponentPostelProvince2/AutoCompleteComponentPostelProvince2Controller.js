({  
    doInit : function(component, event, helper) { 
    	String.prototype.replaceAll = function(search, replacement) {
		    var target = this;
		    return target.replace(new RegExp(search, 'g'), replacement);
		};
        console.log('function do Init of AutoCompleteProvince');
        var sectionName = component.get("v.addressMapping.sectionName");
        if(sectionName == undefined || sectionName == null)
        	sectionName='';
        var provinceinputobject = component.get("v.addressMapping.provinceinputobject");
        var provinceinputfield = component.get("v.addressMapping.provinceinputfield");
        var provincecodeinputobject = component.get("v.addressMapping.provincecodeinputobject");
        var provincecodeinputfield = component.get("v.addressMapping.provincecodeinputfield");
        console.log('provinceinputobject : ' + provinceinputobject + ' provinceinputfield: ' + provinceinputfield);
        var objectDataMaptemp = component.get("v.objectDataMap");
        console.log('objectDataMaptemp --> '+objectDataMaptemp);
        var provinceinput = null;
        var provincecodeinput = null;
        var provinceIdInput = null;
        var provinceEEIdInput = null;
        if(provinceinputobject != null && provinceinputobject != undefined && provinceinputfield != undefined && provinceinputfield != null)
           provinceinput = objectDataMaptemp[provinceinputobject][provinceinputfield];
            console.log('provinc input --> '+objectDataMaptemp[provinceinputobject][provinceinputfield]);        
       if(provincecodeinputobject != null && provincecodeinputobject != undefined && provincecodeinputfield != undefined && provincecodeinputfield != null)
           provincecodeinput = objectDataMaptemp[provincecodeinputobject][provincecodeinputfield];
       if(sectionName != null && sectionName != ''){
           provinceIdInput = 'provincia'+sectionName;
           provinceEEIdInput = 'provinceEE'+sectionName;
           component.set("v.provinceId", provinceIdInput);
           component.set("v.provinceEEId", provinceEEIdInput);
       }
       if(provinceinput == null || provinceinput == undefined){
         provinceinput='';
     }
     console.log('provinceinput: '+provinceinput);

     if(provinceinput!='')
        helper.removeRedBorder(component, event, helper);
    console.log('objectDataMap : ' + JSON.stringify(objectDataMaptemp));
    component.set("v.provinceString", provinceinput);
    component.set("v.provinceCodeString", provincecodeinput);
        //RICHIAMO SBIANCO ERRORID SE PROV != NULL
        //GIOVANNI SPINELLI
        //helper.getProvinceAndSymbol(component);
        

    },
    
    completeProvincia : function(component, event , helper){      
        helper.getResponse(component,'/province','provincia');
    },
    getValueEE : function(component, event , helper){  
        //****START EVENT METHOD****//
        console.log('getvalueEE');
        var sectionName = component.get("v.addressMapping.sectionName");
        if(sectionName == undefined || sectionName == null)
        	sectionName='';
        var provinceinputobject = component.get("v.addressMapping.provinceinputobject");
        var provinceinputfield = component.get("v.addressMapping.provinceinputfield");
        var provincecodeinputobject = component.get("v.addressMapping.provincecodeinputobject");
        var provincecodeinputfield = component.get("v.addressMapping.provincecodeinputfield");
        var province = document.getElementById('provinceEE'+sectionName).value;
        component.set("v.objectDataMap."+ provinceinputobject + "." + provinceinputfield ,  province );
        component.set("v.objectDataMap."+ provincecodeinputobject + "." + provincecodeinputfield ,  'EE' );
        var provinceEEId = component.get("v.provinceEEId");
		var regex = new RegExp("^[a-zA-Z0-9()?!&% $£  =^ °\/\"\.\']+$","g");
		province = province.replaceAll(/\\/,'0');
		if(province && !regex.test(province)){
			
			console.log('inside error');
			var errorId = 'errorId'+provinceEEId;
			var myDiv;
			
			myDiv = document.createElement('div');
			myDiv.setAttribute('id',errorId);//SET AN ID TO EVERY MESSAGE
			myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
			myDiv.setAttribute('class' , 'messageError'+provinceEEId);
			//SET THE MESSAGE
			var errorMessage = document.createTextNode($A.get("$Label.c.errorSpecialCharacter"));
			myDiv.appendChild(errorMessage);

			var idSet = document.getElementById(provinceEEId);
			console.log('idSet:: '+idSet);
			if(idSet!=null && idSet!= undefined)
			{ 
				if(!(document.getElementById(errorId)))
				{
					console.log("METHOD TO SHOW ONLY A MESSAGE");
					idSet.after(myDiv);
					$A.util.addClass(idSet, 'slds-has-error flow_required');
					//idSet.className="slds-has-error flow_required";
				}
			}//END FOR
			component.set("v.objectDataMap.errorEEMap.isErrorEEProv"+sectionName, true);
		} else {
			helper.removeRedBorderEE(component, event , helper);
			component.set("v.objectDataMap.errorEEMap.isErrorEEProv"+sectionName, false);
			
		}
    },
    getValue : function(component, event , helper){  
        //****START EVENT METHOD****//
        var sectionName = component.get("v.addressMapping.sectionName");
        if(sectionName == undefined || sectionName == null)
        	sectionName='';
        var provinceId = component.get("v.provinceId");
        var provinceinputobject = component.get("v.addressMapping.provinceinputobject");
        var provinceinputfield = component.get("v.addressMapping.provinceinputfield");
        var provincecodeinputobject = component.get("v.addressMapping.provincecodeinputobject");
        var provincecodeinputfield = component.get("v.addressMapping.provincecodeinputfield");
        var provinceMap = component.get('v.provinceMap');
        console.log('addressMapping');
        console.log(JSON.stringify(component.get("v.addressMapping")));
        var id;
        var myEvent = component.getEvent("AutocompleteEvent");
        var response = component.get("v.responseProv");
        console.log("the responseProv is: " + JSON.stringify(response));
        //GET THE KEY FROM A VALUE
        var province = document.getElementById(provinceId).value;
        //var province = $('[id$="provincia"]').val();
        component.set("v.objectDataMap."+ provinceinputobject + "." + provinceinputfield ,  province );
        component.set("v.objectDataMap."+ provincecodeinputobject + "." + provincecodeinputfield ,  provinceMap[province] );
        component.set("v.provinceValue2" , province);
        console.log("la provincia è: " + province);
        if(province == '' && document.getElementById("comune"+sectionName)){
          document.getElementById("comune"+sectionName).disabled=true;
      }
        // var idProv = Object.keys(response).find();
        console.log('typeof prov: '+typeof component.get("v.responseProv"));
        if(typeof component.get("v.responseProv") == 'object'){
         for (var key in component.get("v.responseProv")){
             var splitted = (component.get("v.responseProv")[key]).split('_')[0];
             if(splitted==province){
                 id=key;
                 console.log("the ID is: " + id);
                 component.set("v.objectDataMap.province",id);
             }
         }
     }
     myEvent.setParams({"province": id });
     myEvent.fire()
 },

 clearInput : function(component, event, helper) {
    console.log("into the clear input");
    var objectDataMap = component.get("v.objectDataMap");
    var sectionName = component.get("v.addressMapping.sectionName");
    if(sectionName == undefined || sectionName == null)
     sectionName='';
    var provinceValue = document.getElementById("provincia"+sectionName).value;
	 console.log("comune id"+"comune"+sectionName);
	 console.log("comune id"+document.getElementById("comune"+sectionName));
	   //var inputCity = document.getElementById("comune").value;
        if(document.getElementById("comune"+sectionName)!=null && document.getElementById("comune"+sectionName)!=undefined){
        	console.log('dentro comune'+ provinceValue);
        	if(provinceValue != undefined && provinceValue != null && provinceValue == ''){
	        	document.getElementById("comune"+sectionName).disabled=false;
	        }
	         
        }
        if(document.getElementById("frazione"+sectionName)!=null && document.getElementById("frazione"+sectionName)!=undefined){
        	if(provinceValue != undefined && provinceValue != null && provinceValue == ''){
        		document.getElementById("frazione"+sectionName).disabled=true;
        	 }
        }
        if(document.getElementById("strada"+sectionName)!=null && document.getElementById("strada"+sectionName)!=undefined){
            if(provinceValue != undefined && provinceValue != null && provinceValue == ''){
            	document.getElementById("strada"+sectionName).disabled=true;
            	component.set("v.caps",'');
            }
        }
        if(document.getElementById("civico"+sectionName)!=null && document.getElementById("civico"+sectionName)!=undefined){
        	if(provinceValue != undefined && provinceValue != null && provinceValue == ''){
        		document.getElementById("civico"+sectionName).disabled=true;
        	}
        }
		component.set("v.objectDataMap.province", '');
    }, 

    // callService : function(component, event , helper){
    //     console.log(event.target.id);
    //     //var url = '/province';
    //     var field = event.target.id;
    //     var input = '';
    //     var idField = '';
    //     var request = $A.get("e.c:OB_ContinuationRequest");
    //     console.log('siamo nel callService, stampo la request: '+request);
    //     request.setParams({ 
    //         methodName: "getPostel",
    //         methodParams: [field, input, idField],
    //         callback: function(result) {
    //             console.log('RISULTATO: '+ result);
    //             component.set("v.responseProv" , result);
                
    //         }
    //     });
        
    //     request.fire();
    //     //console.log("prov response : " + component.get("v.response"));
    // },

    //******************call for province***************
    callProvince : function(component) {
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










    provincia:function(component, event , helper){
        //component.set("v.triggleSpinner",true);
        //console.log('true spinner'+component.get("v.triggleSpinner"));
        helper.province(component, event , helper);
    },
    removeRedBorder: function(component, event, helper) {

        helper.removeRedBorder(component, event, helper);
    },
    removeRedBorderEE: function(component, event, helper) {

        helper.removeRedBorderEE(component, event, helper);
    },
    blankValue : function(component, event, helper) {
    	var provinceinputobject = component.get("v.addressMapping.provinceinputobject");
        var provinceinputfield = component.get("v.addressMapping.provinceinputfield");
        var provincecodeinputobject = component.get("v.addressMapping.provincecodeinputobject");
        var provincecodeinputfield = component.get("v.addressMapping.provincecodeinputfield");
        if(component.get("v.isEE") == false){
	        component.set("v.objectDataMap."+ provinceinputobject + "." + provinceinputfield ,  '' );
	        component.set("v.objectDataMap."+ provincecodeinputobject + "." + provincecodeinputfield ,  '' );
	        component.set("v.provinceString", '');
	    } else {
	    	component.set("v.objectDataMap."+ provinceinputobject + "." + provinceinputfield ,  'EE' );
	        component.set("v.objectDataMap."+ provincecodeinputobject + "." + provincecodeinputfield ,  'EE' );
	        component.set("v.provinceString", 'EE');
	    }
        console.log('provinceString'+component.get("v.provinceString"));
        helper.removeRedBorder(component, event, helper);
        helper.removeRedBorderEE(component, event, helper);
    }



})