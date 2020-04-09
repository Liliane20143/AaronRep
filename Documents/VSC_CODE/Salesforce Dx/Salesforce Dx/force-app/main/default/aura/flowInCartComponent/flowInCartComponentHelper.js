({
    initializeZeros : function() {
        document.body.addEventListener('DOMNodeInserted', function( event ) {  
            /*var inputs = document.getElementsByClassName('slds-size--7-of-12');
            	var inputs = document.getElementsByClassName('horizontal-view');
                for(i=0;i < inputs.length; i++){
                if(typeof inputs[i].getElementsByTagName('input')[0] != 'undefined'){
                    inputs[i].getElementsByTagName('input')[0].value=0;
                    } 
                }*/
            if(document.getElementById('qtySummaryCategory')){
                document.getElementById('qtySummaryCategory').style.display = "none";
                var compareText = document.getElementsByClassName('compareText');
                var comparebutton = document.getElementById('config').getElementsByClassName('slds-button doCompareButton doCompareButtonInCatalog slds-button_icon-bare')
                if(typeof compareText != 'undefined' ){
                    compareText[1].style.marginLeft = "26%";
                }
                if(typeof comparebutton != 'undefined' ){
                    comparebutton[0].style.marginLeft = "300%";
                }
            }    
        }, false);
        
    },
    
 setLightningFromParam : function(component) {
        var siteType = component.get('c.getSiteDetail');
        siteType.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                //console.log('prefix is ' +response.getReturnValue())
                if(response.getReturnValue() == null){
                    component.set('v.lightningFromParam','lightningFromVF=false');
                }else{
                    component.set('v.lightningFromParam','lightningFromVF=true');//davide.franzini - 27/06/2019 - F2WAVE2-45
                }
            }
             else{}
        });
		$A.enqueueAction(siteType);
        /*if(prefix == 'gestione-contratti'){
            component.set('v.prefix','lightningFromVF=true');
        }*/
        
    }
    
    
})