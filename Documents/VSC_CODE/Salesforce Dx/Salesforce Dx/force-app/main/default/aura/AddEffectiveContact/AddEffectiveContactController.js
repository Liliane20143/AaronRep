({doInit : function(component, event, helper){
       /*    var nextButton = document.getElementsByClassName('slds-button slds-button--brand');
        for (var i = 0; i < nextButton.length; i++) {
             console.log('ID'+JSON.stringify(nextButton[i])); 
            
                nextButton[i].setAttribute("disabled","");
                nextButton[i].disabled=false;
            
        }*/
},
	onCheck: function(component, event, helper) {
     /* 	var checked = component.get("v.checked");
        if(checked){
            component.set("v.showPicklist", true);
        }else{
             component.set("v.showPicklist", false);
        } */
         var resultCmp = component.get("v.wizardStep");
         var wizardStep = resultCmp ? "step1" : "step2";     
         //component.set("v.wizardStep", wizardStep);
         if (wizardStep) {
        	 document.getElementById('input:stepToGo:UNBIND2').value='NEXT';
			 console.log("VALORE INPUTFLOW:"+document.getElementById('input:stepToGo:UNBIND2').value);
			 document.getElementById('input:stepToGo:UNBIND2').dispatchEvent(new Event('blur'));
			 document.getElementById('input:stepToGo:UNBIND2').value='';  
         }   
    },
    handleChange: function (component, event) {
        var selectedOptionValue = event.getParam("value");
        console.log("Option selected: " +  selectedOptionValue);
    }
})