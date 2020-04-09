({

	nextStep: function(component,event,helper){
        var j$ = jQuery.noConflict(); 
        var objectDataMap = component.get("v.objectDataMap");
        var step =   objectDataMap.unbind.step;
        //var step = objectDataMap.overwriteNext;
      j$(".slds-button").click(function(){
      //  var step = objectDataMap.overwriteNext;

        console.log("LO STEP è: "+step);
        //component.set('v.step',step);
        //component.set('v.step',step);
  
        if(step == 1){
            //var source=event.getSource();
            //source.set('v.label','Acquiring');
            var offertaComponent = component.find('offertaComponent');
            var POSComponent = component.find('POSComponent');
            var test = document.getElementById("test");
            test.classList.remove("hidden");
            console.log("before setting class...");
            $A.util.addClass(offertaComponent, 'hidden');
            $A.util.removeClass(POSComponent, 'hidden');
            console.log("after setting class...");
            var updateContext				=	$A.get("e.NE:Bit2win_Event_RetrieveContext");
            updateContext.setParams({
                'componentRequest'		:	'catalog',
                'page'					:	1
            });
            updateContext.fire();

        }
        else if(step == 2){
            var source=event.getSource();
            source.set('v.label','VAS');
            var acquiringComponent = component.find('AcquiringComponent');
            var POSComponent = component.find('POSComponent');
            $A.util.addClass(POSComponent, 'hidden');
            $A.util.removeClass(acquiringComponent, 'hidden');
        }
        else if(step == 3){
                var buttondiv = component.find('buttondiv');
                var checkoutBtn = component.find('checkout');
                var acquiringComponent = component.find('AcquiringComponent');
                var VASComponent = component.find('VASComponent');
               // $A.util.addClass(buttondiv, 'hidden');
                $A.util.removeClass(checkoutBtn, 'hidden');
                $A.util.addClass(acquiringComponent, 'hidden');
                $A.util.removeClass(VASComponent, 'hidden');
         }
         else if(step == 4){
                var checkoutBtn = component.find('checkout');
                var buttondiv = component.find('buttondiv');
                var VASComponent = component.find('VASComponent');
                var priceSummaryComponent = component.find('priceSummaryComponent');
               // $A.util.addClass(buttondiv, 'hidden');
                $A.util.addClass(checkoutBtn, 'hidden');
                $A.util.addClass(VASComponent, 'hidden');
                $A.util.removeClass(priceSummaryComponent, 'hidden');
         }else if(step == 5){
            	var checkoutBtn = component.find('checkout');
                var buttondiv = component.find('buttondiv');
                var priceSummaryComponent = component.find('priceSummaryComponent');
                var bancomatComponent = component.find('bancomatComponent');
                $A.util.addClass(buttondiv, 'hidden');
                $A.util.addClass(checkoutBtn, 'hidden');
                $A.util.addClass(priceSummaryComponent, 'hidden');
                $A.util.removeClass(bancomatComponent, 'hidden');
          }

      });
        step = parseInt(step)+1;
             //   component.set("v.objectDataMap.overwriteNext", step);
        component.set("v.objectDataMap.unbind.step", step);
    },

    /*nextStep: function(component,event,helper){
        var objectDataMap = component.get("v.objectDataMap");
      //  var step = objectDataMap.overwriteNext;
    var step =   objectDataMap.unbind.step;
        console.log("LO STEP è: "+step);
        //component.set('v.step',step);
        //component.set('v.step',step);
  
        if(step == 1){
            //var source=event.getSource();
            //source.set('v.label','Acquiring');
            var offertaComponent = component.find('offertaComponent');
            var POSComponent = component.find('POSComponent');
            var test = document.getElementById("test");
            test.classList.remove("hidden");
            console.log("before setting class...");
            $A.util.addClass(offertaComponent, 'hidden');
            $A.util.removeClass(POSComponent, 'hidden');
            console.log("after setting class...");
            var updateContext				=	$A.get("e.NE:Bit2win_Event_RetrieveContext");
            updateContext.setParams({
                'componentRequest'		:	'catalog',
                'page'					:	1
            });
            updateContext.fire();

        }
        else if(step == 2){
            var source=event.getSource();
            source.set('v.label','VAS');
            var acquiringComponent = component.find('AcquiringComponent');
            var POSComponent = component.find('POSComponent');
            $A.util.addClass(POSComponent, 'hidden');
            $A.util.removeClass(acquiringComponent, 'hidden');
        }
        else if(step == 3){
                var buttondiv = component.find('buttondiv');
                var checkoutBtn = component.find('checkout');
                var acquiringComponent = component.find('AcquiringComponent');
                var VASComponent = component.find('VASComponent');
               // $A.util.addClass(buttondiv, 'hidden');
                $A.util.removeClass(checkoutBtn, 'hidden');
                $A.util.addClass(acquiringComponent, 'hidden');
                $A.util.removeClass(VASComponent, 'hidden');
         }
         else if(step == 4){
                var checkoutBtn = component.find('checkout');
                var buttondiv = component.find('buttondiv');
                var VASComponent = component.find('VASComponent');
                var priceSummaryComponent = component.find('priceSummaryComponent');
               // $A.util.addClass(buttondiv, 'hidden');
                $A.util.addClass(checkoutBtn, 'hidden');
                $A.util.addClass(VASComponent, 'hidden');
                $A.util.removeClass(priceSummaryComponent, 'hidden');
         }else if(step == 5){
            	var checkoutBtn = component.find('checkout');
                var buttondiv = component.find('buttondiv');
                var priceSummaryComponent = component.find('priceSummaryComponent');
                var bancomatComponent = component.find('bancomatComponent');
                $A.util.addClass(buttondiv, 'hidden');
                $A.util.addClass(checkoutBtn, 'hidden');
                $A.util.addClass(priceSummaryComponent, 'hidden');
                $A.util.removeClass(bancomatComponent, 'hidden');
          }
        step = parseInt(step)+1;
        component.set("v.objectDataMap.unbind.step", step);

    },*/
    checkout: function(component, event, helper){
    	/* sbagliato 
        var checkPenalty = 	$A.get("e.NE:Bit2win_Event_ApplyPenalty");
		checkPenalty.setParams({
			'action' 	: 	'checkout'
		});
		checkPenalty.fire();
    	 */
    },
    showSpinner: function(component, event, helper) {
        component.set("v.Spinner", true); 
    },
    hideSpinner : function(component,event,helper){
        component.set("v.Spinner", false);
    },
    //Marco Ferri 28/08/2018
})