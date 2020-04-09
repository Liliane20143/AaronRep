({
/*****************************************************************
    Purpose:  RI-26 - CHECK IF CURRENT USER IS MEMBER OF THE APPROVAL QUEUE                                                          
    History                                                            
    --------                                                           
    VERSION  AUTHOR             DATE           DETAIL          Description
    1.0      gianluigi.virga    19/04/2019     Created         CSR: 
    *****************************************************************/
    checkUserOwnership : function(component) {
        var confId = component.get('v.recordId');
        try{
        var action = component.get("c.checkUserOwnership");
        
            action.setParams({ confId : confId});
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var userEnabled = response.getReturnValue();
                        component.set('v.userEnabled', userEnabled);
                }
            });
            $A.enqueueAction(action);
        }catch(err){
            console.log('error in OB_ConfigurationItemsDetailsWrapperHelper.checkUserOwnership: '+err.message);
        }
    }
//  END gianluigi.virga 19/04/2019 - RI-26
})