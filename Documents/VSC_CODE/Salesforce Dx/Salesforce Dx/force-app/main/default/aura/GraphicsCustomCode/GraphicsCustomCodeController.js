({
    doInit: function(component, event, helper) {
        console.log("param event nel do init : " + event.getParam("idStep") );
        var stepName = event.getParam("idStep"); 
        var neutralButtons = document.getElementsByClassName('slds-button slds-button--neutral');
        
        for(var j = 0; j < neutralButtons.length; j++){
            if(neutralButtons[j].textContent == "< Previous"){ 
                if(stepName === "step_getMerchant"){
                   neutralButtons[j].setAttribute('style','visibility: hidden;');
               
                }
                 if(stepName !== "step_getMerchant"){
                 neutralButtons[j].setAttribute('style','visibility:visible;position:absolute;left:0px;');
                }
            }
        }
        
        
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
    
    
})