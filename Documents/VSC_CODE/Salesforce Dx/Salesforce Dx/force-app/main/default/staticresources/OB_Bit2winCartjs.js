      
      /*
        La parte di nascondere elementi e settare valore '0'(Tao)
      */

            window.onload = function() { document.body.addEventListener('DOMNodeInserted', function( event ) {
                if(chkObject('3527:0')){
                    var val = document.getElementById('3527:0').value;
                	document.getElementById('3527:0').value = 1;
                }  
                var inputs = document.getElementsByClassName('slds-size--7-of-12');
                for(i=0;i < inputs.length; i++){
                if(typeof inputs[i].getElementsByTagName('input')[0] != 'undefined'){
                    inputs[i].getElementsByTagName('input')[0].value=0;
                    } 
                }
                if(chkObject('qtySummaryCategory')){
                    document.getElementById('qtySummaryCategory').style.display = "none";
                    var compareText = document.getElementsByClassName('compareText');
                    var comparebutton = document.getElementById('config').getElementsByClassName('slds-button doCompareButton doCompareButtonInCatalog slds-button_icon-bare')
                        if(typeof compareText != 'undefined' ) compareText[1].style.marginLeft = "26%";
                        if(typeof comparebutton != 'undefined' ) comparebutton[0].style.marginLeft = "300%";
                }     
            }, false);
    
            function chkObject(elemId) {
                return (document.getElementById(elemId))? true : false;
            }
			
			}
			