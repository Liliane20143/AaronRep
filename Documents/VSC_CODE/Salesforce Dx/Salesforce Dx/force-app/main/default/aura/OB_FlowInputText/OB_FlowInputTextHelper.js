({
	removeRedBorder: function (component, event , helper){
       
        //GET THE CURRENT ID FROM INPUT 
        var currentId = event.target.id; 
        console.log("current id is: " + currentId);
        $A.util.removeClass(document.getElementById(currentId) , 'slds-has-error');
        //RECREATE THE SAME ID OF ERROR MESSAGE
        var errorId = 'errorId'+ currentId;
        if(document.getElementById(errorId)!=null){
            console.log("errorID . " + errorId);
            document.getElementById(errorId).remove();
        }
    },
    setRedBorder: function (component, auraId, helper){
        var cmpValue = component.find(auraId).get("v.value");
		console.log('cmpValue:  '+cmpValue+'  auraId:: '+auraId);
		var errorId = 'errorId' +auraId;
        console.log("key  = " + auraId);
        
        var myDiv;
        
        myDiv = document.createElement('div');
        myDiv.setAttribute('id',errorId);//SET AN ID TO EVERY MESSAGE
        myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
        myDiv.setAttribute('class' , 'messageError'+auraId);
        //SET THE MESSAGE
        	            
       var idSet = component.find(auraId).getElement();
	   console.log("ID SET : " + idSet + ", input: " + JSON.stringify(component.find(auraId)));
		if(!cmpValue){
			component.set("v.validState", false);
		
            var errorMessage = document.createTextNode($A.get("$Label.c.MandatoryField"));
            console.log('errorMessage:: '+JSON.stringify(errorMessage));
            myDiv.appendChild(errorMessage);

			if(idSet!=null && idSet!= undefined)
			{ 
				console.log('errorId doc'+(document.getElementById(errorId)));
				if(!(document.getElementById(errorId)))
				{
					console.log("METHOD TO SHOW ONLY A MESSAGE");
					idSet.after(myDiv);
					$A.util.addClass(idSet, 'slds-has-error flow_required');
					//idSet.className="slds-has-error flow_required";
				}
			}
		} else {
			console.log('cmpValue ::'+cmpValue);
			if(cmpValue.length != 16 || !/^[a-zA-Z]{6}[0-9]{2}[abcdehlmprstABCDEHLMPRST]{1}[0-9]{2}([a-zA-Z]{1}[0-9]{3})[a-zA-Z]{1}$/.test(cmpValue)){
				var errorMessage = document.createTextNode($A.get("$Label.c.OB_InvalidFiscalCode"));
	            console.log('errorMessage:: '+JSON.stringify(errorMessage));
	            myDiv.appendChild(errorMessage);

				if(idSet!=null && idSet!= undefined)
				{ 
					console.log('errorId doc'+(document.getElementById(errorId)));
					if(!(document.getElementById(errorId)))
					{
						console.log("METHOD TO SHOW ONLY A MESSAGE");
						idSet.after(myDiv);
						$A.util.addClass(idSet, 'slds-has-error flow_required');
					}
				}
				component.set("v.validState", false);
			} else {
				component.set("v.validState", true);
			}
		}
	}
})