({   
    /*   
    handleChangeLea: function (cmp, event) {
        var changeValue = event.getSource().get('v.value');
        console.log("value scelta " + changeValue);
        var objectDataMap = cmp.get("v.objectDataMap");
        objectDataMap.unbind.ValueService = changeValue;
        
        
        cmp.set("v.objectDataMap",objectDataMap);
        console.log("objectDataMap:"+JSON.stringify(objectDataMap));
        
        document.getElementById('input:unbind:UNBIND7').value=changeValue;
        console.log("VALORE INPUTFLOW:"+document.getElementById('input:unbind:UNBIND7').value);
        document.getElementById('input:unbind:UNBIND7').dispatchEvent(new Event('blur'));
        document.getElementById('input:unbind:UNBIND7').value='';
        
    }
    
    
    
    
    
    */
    
     /*doInit: function(component, event){
       var nextButton = document.getElementsByClassName('slds-button slds-button--brand');
        console.log("nextButton :"+nextButton);
        for (var i = 0; i < nextButton.length; i++) {
            console.log("NextButton onclick before setAttribute "+nextButton[i].onclick);
        	nextButton[i].setAttribute("onclick","");
            console.log("NextButton onclick after setAttribute "+nextButton[i].onclick);
            nextButton[i].onclick= function(){alert("ciao");}
      
        }, */
       
    
    
    
    handleChange: function (component, event, helper) {
        
        var selectedValue = event.getSource().get('v.value');
        console.log("value scelta " + selectedValue);
        if(selectedValue==='ACQUIRING'){
            var currentState = component.get("v.acquiring");
            if(currentState === false){
                component.set("v.acquiring",true);
            }else{
                component.set("v.acquiring",false);
            }
        }else if (selectedValue==='POS'){
            var currentState = component.get("v.pos");
            if(currentState === false){
                component.set("v.pos",true);
            }else{
                component.set("v.pos",false);
            }
        }
        var changeValue = ''; 
        var isAcquring = component.get("v.acquiring");
        var isPos = component.get("v.pos");
        
        if(isAcquring && isPos){
            changeValue = 'ACQUIRING + POS';
        }else if(isAcquring && !isPos) {
            changeValue = 'ACQUIRING';
        }else if(isPos && !isAcquring){
            changeValue = 'POS';
        }
   
        var objectDataMap = component.get("v.objectDataMap");
        objectDataMap.unbind.ValueService = changeValue;
        //objectDataMap.unbind.UNBIND7 = changeValue;
       
        component.set("v.objectDataMap",objectDataMap);
        console.log("objectDataMap:"+JSON.stringify(objectDataMap));
        document.getElementById('input:unbind:UNBIND7').value=changeValue;
        console.log("VALORE INPUTFLOW:"+document.getElementById('input:unbind:UNBIND7').value);
        //document.getElementById('input:unbind:UNBIND7').dispatchEvent(new Event('blur'));
        document.getElementById('input:unbind:UNBIND7').value='';
        
    },
    
     onMultiSelectChange: function(cmp) {
         var selectCmp = cmp.find("InputSelectMultiple");
         var resultCmp = cmp.find("multiResult");
         resultCmp.set("v.value", selectCmp.get("v.value"));
	 },
    
    
    
});