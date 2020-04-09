({	
    doInit: function(component, event, helper){
        console.log("doInit");
        var back = document.getElementsByClassName('slds-button slds-button--neutral');
        for(var i = 0; i < back.length; i++){
            
            console.log("accountig"+ JSON.stringify(back[i].textContent ));
         //   if(back[i].textContent == "< Previous"){
                //console.log(document.getElementById("utilityField"));
                back[i].setAttribute("onmousedown","");
                back[i].onmousedown = function(){
                    document.getElementById("utilityField").dispatchEvent(new Event('blur'));
                }
        //    }
        } 
    }
})