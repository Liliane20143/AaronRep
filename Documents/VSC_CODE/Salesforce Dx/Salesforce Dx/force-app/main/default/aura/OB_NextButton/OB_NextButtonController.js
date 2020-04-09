({
    doInit : function(component, event, helper) {
        
        var nextButton = document.getElementsByClassName('slds-button slds-button--brand');
        console.log('next button ' + nextButton.length );
        
        for(var i = 0; i < nextButton.length; i++){
            console.log('nexbutton[i] :'+nextButton[i].textContent);
            
            if(nextButton[i].textContent == "Next >"){  
                
                nextButton[i].setAttribute("onclick","");
                nextButton[i].onclick = function(){
                    console.log('onclick next button');
                    if(document.getElementById("hiddenField")!= null){
                        document.getElementById("hiddenField").dispatchEvent(new Event('blur'));
                    }
                    
                }
            }
        }
    }
    
    /* handleComponentEvent : function(component,event){  
        console.log('handler event method');
        var message = event.getParam("message");
        console.log("message of error nel next : " + message);
        component.set("v.messageFromEvent", message);

      
        var id ="item";
        var fieldsMap = event.getParam("fieldsList");
        console.log("mappa field in handler event method " + fieldsMap.size);
        for(var i=0;i<fieldsMap.size;i++){
             var id ="item" + i;
            
            if(fieldsMap.get("item2") !== "undefined"){
            // console.log('value of item map ' + fieldsMap.get(id));
            //fieldsMap.get("item2").Name = "slds-has-error required";
               $A.util.addClass( fieldsMap.get("item2"), "slds-has-error required");
            }
        }
    }*/
})