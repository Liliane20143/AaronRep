({
	loadListini : function(component,page) {
		
		var pageSize = component.get("v.pageSize");
		
		
        var action = component.get("c.getListini");
        action.setParams({ 
        	"pageSize": pageSize,
          	"pageNumber": page || 1
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            var pageList = [];
            
            if (state === "SUCCESS") {
                //manage the resp 
                console.log("response: ",response.getReturnValue());
                var result = response.getReturnValue();
                component.set("v.listiniList", result.listiniList);
	            // Added code to set the values for the page, 
	            // total and pages attributes
	            component.set("v.page", result.page);
	            component.set("v.total", result.total);
	            component.set("v.pages", Math.ceil(result.total/pageSize));
	            for(var i = 1; i <=Math.ceil(result.total/pageSize); i++){
	            	pageList.push(i);
	            }
	            component.set("v.pagesList",pageList);
	            
	            this.changeSizePageContainer(component,result);
	            
				component.set("v.Spinner", false);
            }
            else if (state === "INCOMPLETE") {
            }
            else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
        component.set("v.Spinner", true);
	},
	searchlistini: function(component,page) {
		
		var pageSize = component.get("v.pageSize");
		var name = component.get("v.name");
		var fromDate = component.get("v.from");
		var toDate = component.get("v.to");
		
        var action = component.get("c.searchListiniServer");
        action.setParams({ 
        	"pageSize": pageSize,
          	"pageNumber": page || 1,
          	"name":name,
          	"fromDate":fromDate.toString(),
          	"toDate":toDate.toString()
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            var pageList = [];
            
            if (state === "SUCCESS") {
                //manage the resp 
                console.log("response: ",response.getReturnValue());
                var result = response.getReturnValue();
                component.set("v.listiniList", result.listiniList);
	            // Added code to set the values for the page, 
	            // total and pages attributes
	            component.set("v.page", result.page);
	            component.set("v.total", result.total);
	            component.set("v.pages", Math.ceil(result.total/pageSize));
	            for(var i = 1; i <=Math.ceil(result.total/pageSize); i++){
	            	pageList.push(i);
	            }
	            component.set("v.pagesList",pageList);
	            
	            this.changeSizePageContainer(component,result);
	            
	            if( !($A.util.isEmpty(name)) || !($A.util.isEmpty(fromDate)) || !($A.util.isEmpty(toDate)) )
	            {
	            	component.set("v.resetForm",true);
	            }
				component.set("v.Spinner", false);
            }
            else if (state === "INCOMPLETE") {
            }
            else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
        component.set("v.Spinner", true);
		
	},
	createlistini: function(component,page) {
		
		var pageSize = component.get("v.pageSize");
		var name = component.get("v.name");
		var from = component.get("v.from");
		var to = component.get("v.to");
		
		if(name == null){
			console.log("Name cannot be null");
			//border red
			return false;
		}
		
        var action = component.get("c.creaListinoServer");
        action.setParams({ 
        	"pageSize": pageSize,
          	"pageNumber": page || 1,
          	"name":name,
          	"fromDate":from.toString(), //new Date(component.get('v.myDate')).toJSON()
          	"toDate":to.toString()
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            var pageList = [];
            
            if (state === "SUCCESS") {
                //manage the resp 
                console.log("response: ",response.getReturnValue());
                var result = response.getReturnValue();
                component.set("v.listiniList", result.listiniList);
	            // Added code to set the values for the page, 
	            // total and pages attributes
	            component.set("v.page", result.page);
	            
	            var oldTotal = component.get("v.total");
	            
	            if(oldTotal == result.total){
	            	//DUPLICATE notification
					this.showWarningDuplicateToast(component,event,name);
					//end notification
	            }
	            else{
	            
		            component.set("v.total", result.total);
		            component.set("v.pages", Math.ceil(result.total/pageSize));
		            for(var i = 1; i <=Math.ceil(result.total/pageSize); i++){
		            	pageList.push(i);
		            }
		            component.set("v.pagesList",pageList);
		            
		            this.changeSizePageContainer(component,result);

					//toast notification
					this.showSuccessToast(component, event,name);
					//end notification					
				}
				component.set("v.Spinner", false);
            }
            else if (state === "INCOMPLETE") {
            }
            else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
        component.set("v.Spinner", true);
		
	},
	deletelistino: function(component,page,listino) {
		
		var pageSize = component.get("v.pageSize");
		
        var action = component.get("c.deleteListinoServer");
        action.setParams({ 
        	"pageSize": pageSize,
          	"pageNumber": page || 1,
          	"listinoToDelete":listino
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            var pageList = [];
            
            if (state === "SUCCESS") {
                //manage the resp 
                console.log("response: ",response.getReturnValue());
                var result = response.getReturnValue();
                component.set("v.listiniList", result.listiniList);
	            // Added code to set the values for the page, 
	            // total and pages attributes
	            component.set("v.page", result.page);
	            component.set("v.total", result.total);
	            component.set("v.pages", Math.ceil(result.total/pageSize));
	            for(var i = 1; i <=Math.ceil(result.total/pageSize); i++){
	            	pageList.push(i);
	            }
	            component.set("v.pagesList",pageList);
	            
	            this.changeSizePageContainer(component,result);
	            
				component.set("v.Spinner", false);
				
				//toast notification
				this.showSuccessDeleteToast(component,event,listino.Name);
				//end notification
            }
            else if (state === "INCOMPLETE") {
            }
            else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
        component.set("v.Spinner", true);
	},
	
	changeSizePageContainer: function(component,result){
	
	//marco.ferri start alghoritm to dynamically set the col size
	    var pageText = component.find('totListini');
	    var pageTextBottom = component.find('totListini2');
	    var oldnumber = component.get("v.oldNumber");
	    var pageSize = component.get("v.pageSize");
	    
	    if(oldnumber != null){ 
	    	oldsizeClass = 'slds-size_'+oldnumber+'-of-6 slds-medium-size_'+oldnumber+'-of-6 slds-small-size_'+oldnumber+'-of-6'
	    	$A.util.removeClass(pageText, oldsizeClass);
	    	$A.util.removeClass(pageTextBottom, oldsizeClass);
	    	
	    }
	    var pages = Math.ceil(result.total/pageSize); 
	    console.log("pages "+ pages);
	    //failing at alghoritms....
	    if(pages <= 6){
	    	number = 5;
	    }
	    else if(pages > 6 && pages < 10){
	    	number = 4;
	    }
	    else if(pages > 10 && pages < 20){
	    	number = 3;
	    }
	    else if(pages > 20 && pages < 30){
	    	number = 2;
	    }
	    else if(pages >30){
	    	number = 1;
	    }
	    //END
	    console.log("number "+number);
	    var sizeClass = 'slds-size_'+number+'-of-6 slds-medium-size_'+number+'-of-6 slds-small-size_'+number+'-of-6';
	    $A.util.addClass(pageText, sizeClass);
	    $A.util.addClass(pageTextBottom, sizeClass);   
	    component.set("v.oldNumber",number);
	    //end
	},
	
	showSuccessToast : function(component, event,name) {
		
		
		var successLabelmsg = $A.get("$Label.c.OB_SuccessToastLabel");
		var successLabelhead = $A.get("$Label.c.OB_SuccessToastHead");
		 
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : successLabelhead,
            message: 'test message',
            messageTemplate: '{0} {1}',
            messageTemplateData: [name,successLabelmsg],
            duration:'5000',
            key: 'info_alt',
            type: 'success',
            mode: 'dismissible'
        });
        toastEvent.fire();
	},
	showSuccessDeleteToast : function(component, event,name) {
		
		var deleteLabelmsg = $A.get("$Label.c.OB_DeleteToastLabel");
		var deleteLabelhead = $A.get("$Label.c.OB_DeleteToastHead");
		 
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
             title : deleteLabelhead,
            message: 'test message',
            messageTemplate: '{0} {1}',
            messageTemplateData: [name,deleteLabelmsg],
            duration:'5000',
            key: 'info_alt',
            type: 'success',
            mode: 'dismissible'
        });
        toastEvent.fire();
	},
	
	showWarningDuplicateToast : function(component, event,name) {
		
		var duplicateLabelmsg = $A.get("$Label.c.OB_DuplicateToastLabel");
		var duplicateLabelhead = $A.get("$Label.c.OB_DuplicateToastHead");
		 
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : duplicateLabelhead,
            message: 'test message',
            messageTemplate: '{0} {1}',
            messageTemplateData: [name,duplicateLabelmsg],
            duration:'5000',
            key: 'info_alt',
            type: 'warning',
            mode: 'dismissible'
        });
        toastEvent.fire();
	},				
})