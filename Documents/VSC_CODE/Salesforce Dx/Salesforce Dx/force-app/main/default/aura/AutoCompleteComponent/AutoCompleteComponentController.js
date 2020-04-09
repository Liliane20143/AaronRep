({
    doInit : function(component,event,helper){
        var objectDataMap = component.get("v.objectDataMap");
        console.log("objectDataMap: "+ JSON.stringify(objectDataMap));
        
        jQuery("document").ready(function(){
            console.log('loaded');
            
            //JsonAddress json = {"City" : ["Milano","Genova","Roma"]};
            //"Country" : ["Italy","Francia","Camerun"],
            // "ZipCode" :["20156","45566","20192"]};
            var optionsStreet=["Roberto Lepetit","Aselli","Giovanelli","Roma","Vitruvio"];
            var optionsCity=["Milano","Pavia","Novara","Genova","Firenze"];
            var optionsCountry=["Italy","Camerun","Francia"];
            var optionsZipcode=["20124","20178","1912912"];
            
            
            $( "#city" ).autocomplete({
                source: optionsCity
            });
            
            
            $( "#street" ).autocomplete({
                source: optionsStreet
            });
            
            $( "#country" ).autocomplete({
                source: optionsCountry
            });
            
            $( "#zipcode" ).autocomplete({
                source: optionsZipcode
            });
            
            
        }); 
        //Giovanni Spinelli, Doris Dongmo 27/06/2018 Start Changes
        if(!objectDataMap.pv.isEmpty)
        {
            
            //set the selected row with the autocomplete of fields
            document.getElementById("street").value  = objectDataMap.pv.NE__Street__c;
        	document.getElementById("city").value    = objectDataMap.pv.NE__City__c;
        	document.getElementById("country").value = objectDataMap.pv.NE__Country__c;
            document.getElementById("Zipcode").value = objectDataMap.pv.NE__Postal_Code__c;
       		
        }
        	
        
        var back = document.getElementsByClassName('slds-button slds-button--neutral'); 
        for(var j = 0; j < back.length; j++){
            if(back[j].textContent == "< Previous"){              
                back[j].setAttribute("onclick","");
                back[j].onclick = function(){
                    if(document.getElementById("hiddenField")!= null){
                        document.getElementById("hiddenField").dispatchEvent(new Event('blur'));
                    }
                } 
            }
        }
       //Giovanni Spinelli, Doris Dongmo 28/06/2018 End Changes 
        
    },
    
    
    CompleteAddress: function(component, event, helper) {
        
        document.getElementById("input:pv:NE__Street__c").value = document.getElementById("street").value;
        document.getElementById("input:pv:NE__City__c").value = document.getElementById("city").value;
        document.getElementById("input:pv:NE__Country__c").value = document.getElementById("country").value;
        document.getElementById("input:pv:NE__Zip_Code__c").value = document.getElementById("Zipcode").value;
        
        component.set("v.objectDataMap.pv.NE__Street__c",document.getElementById("street").value);
        component.set("v.objectDataMap.pv.NE__City__c",document.getElementById("city").value);
        component.set("v.objectDataMap.pv.NE__Country__c",document.getElementById("country").value);
        component.set("v.objectDataMap.pv.NE__Zip_Code__c",document.getElementById("Zipcode").value);
        
        
    },
    
})