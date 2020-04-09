({
    doInit : function(component, event, helper) {
        
        // console.log('child value ' + component.get("v.ErrorMessage"));
        
    },
    
    beforeNext : function(component,event,helper){
        document.getElementById("input:unbind:UNBIND3").value="";
        var objectDataMap = component.get("v.objectDataMap");
        for(var k=0;k<10;k++){
            var errorId ="errorId" + k;
            if(document.getElementById(errorId) != null){
                document.getElementById(errorId).remove();
            }
        }
       // var fieldMap = new Map();
       /* contatore for empty input required */
        var contatore = 0;
        var myDiv;
        
        var listAuraId = document.getElementsByClassName('required'); 
        
        for(var i=0;i<listAuraId.length;i++){
            if(listAuraId[i].value === ""){
                //fieldMap.set(listAuraId[i].getAttribute('id'),listAuraId[i].value);
                var errorId = 'errorId' + i;
              
                listAuraId[i].className="slds-has-error required";
                
                myDiv = document.createElement('div');
                myDiv.setAttribute('id',errorId);
                myDiv.setAttribute('style','color:red;');
                
                var errorMessage = document.createTextNode('Mandatory field');
                myDiv.appendChild(errorMessage);
                listAuraId[i].after(myDiv);
                contatore++;

            }
        }
        
        console.log('length of contatore ' + contatore);
        if(contatore == 0){
            /* quando serve aggiungere la logica di formalità dei campi */
            
            var unbind = document.getElementById("input:unbind:UNBIND3");
            component.set("v.objectDataMap.unbind.UNBIND3", 'Next');
            component.set("v.objectDataMap",objectDataMap);
            unbind.dispatchEvent(new Event('blur'));
        }
        

    }
})