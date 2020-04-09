({
    doInit : function(component, event, helper) {
        console.log('RECORD ID: ' + component.get('v.recordId'));
        var confId = component.get('v.recordId');
        //alert('CONF ID: '+component.get('v.recordId'));
       
        try{
        var action = component.get("c.getWorkItemsId");
        
            action.setParams({ confId : confId});
                          // cab : cab});
            action.setCallback(this, function(response) {
                var state = response.getState();
                console.log('state searchBankProfile: ' + state);
                if (state === "SUCCESS") {
                    //alert('ID: ' +  JSON.stringify(response.getReturnValue()));
                    var returnValueMap = response.getReturnValue();
                    //alert('returnValueMap: ' + returnValueMap['approvalRequestId']);

                    component.set('v.approvalRequestId' , returnValueMap['approvalRequestId']);
                    component.set('v.currentURL'        , returnValueMap['currentURL']);
                    //show back button only if there is an approval request
                    
                    //  START   micol.ferrari@accenture.com 11/04/2019 - R1F2-11 - RETRIEVE CUSTOM METADATA RECORD  
                    var isAdminBoolean = returnValueMap['showButtons'];
                    //  END     micol.ferrari@accenture.com 11/04/2019 - R1F2-11 - RETRIEVE CUSTOM METADATA RECORD

                    if( component.get('v.approvalRequestId') && isAdminBoolean==true){
                        component.set('v.showBackButton' , true); 
                    }
                    
                }
                
                else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message searchBankProfile: " + 
                                            errors[0].message);
                            }
                        } else {
                            console.log("Unknown error");
                        }
                    }
            });
            $A.enqueueAction(action);
            //  START gianluigi.virga 19/04/2019 - RI-26 - SET v.userEnabled
            helper.checkUserOwnership(component);
            //  END gianluigi.virga 19/04/2019 - RI-26
        }catch(err){
            console.log('error do init: '+err.message);
        }
        
    },
    goToConfigurationItemsDetail : function(component, event, helper) {
        console.log('RECORD ID: ' + component.get('v.recordId'));
        var currentURL = component.get('v.currentURL');
        // alert(document.referrer);
        //giovanni spinelli - 11/03/2019 - go bck url if there is an history , else if close window
        window.history.back();
        var previousURL = document.referrer;
        if(previousURL.includes('consulta')){
            window.close();
        }
       
       // window.history.back()  ?window.history.go(-1) :  window.close();

    //    console.log("document.referrer "+document.referrer);
    //    console.log("currentURL "+(currentURL+'/'+component.get('v.approvalRequestId'))  );
    //    //nuova tab
    //     if(window.history.back()){
    //         window.history.back();
    //      } else if(document.referrer == (currentURL+'/'+component.get('v.approvalRequestId') )){   
    //          console.log("document.referrer "+document.referrer);
    //          console.log("currentURL "+(currentURL+'/'+component.get('v.approvalRequestId'))  );
    //          window.open(currentURL+'/'+component.get('v.approvalRequestId'),'_top');//chiedere a daniele
    //      }else{
    //         //window.close();
    //         alert();
    //      }
        
        // window.open(currentURL+'/'+component.get('v.approvalRequestId'),'_top');//chiedere a daniele
        //nuova tab
        // window.history.back() ? window.history.back() :  window.close();
        // alert(  window.open(currentURL+'/'+component.get('v.approvalRequestId'),'_top'));
        // if(   window.history.go(-1) !='undefined' ){
        //      alert('if');
        //      window.open(currentURL+'/'+component.get('v.approvalRequestId'),'_top');//chiedere a daniele
        //     // window.history.back();
        //     //window.history.go(-1);
        //     return false;
        // }else{
        //     alert('else');
        //     window.close();
        // }
        // window.history.back();
        // alert();
        
        
    },
    submitApprovalRequest : function(component, event, helper) {
        var confId = component.get('v.recordId');
        var approvalRequestId = component.get('v.approvalRequestId' );
        //START francesca.ribezzi 06/12/19 -PERF-25 adding comments
        var textAreaMessage = component.get("v.textAreaMessage"); 
        if ($A.util.isEmpty(textAreaMessage)) {
            textAreaMessage = '';
        }
        //END francesca.ribezzi 06/12/19 -PERF-25
        try{
            var action = component.get("c.submitApprovalRequestMethod");
        
            action.setParams({ 
                confId : confId, 
                textAreaMessage: textAreaMessage //francesca.ribezzi 06/12/19 -PERF-25 adding comments to approval process
            });
                          // cab : cab});
            action.setCallback(this, function(response) {
                var state = response.getState();
                console.log('state searchBankProfile: ' + state);
                if (state === "SUCCESS") {
                    console.log('REQUEST ' + response.getReturnValue() );
                    component.set('v.approvalRequestApproved' , response.getReturnValue() );
                    var currentURL = component.get('v.currentURL');
                    window.open(currentURL+'/'+component.get('v.approvalRequestApproved'),'_top');
                }
                
                else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message searchBankProfile: " + 
                                            errors[0].message);
                            }
                        } else {
                            console.log("Unknown error");
                        }
                    }
            });
            $A.enqueueAction(action);
        }catch(err){
            console.log(err.message);
        }
    },
    //giovanni spinelli change method 10/06/2019
    rejectApprovalRequest: function (component, event, helper) {
        //get record id from current page
        var confId = component.get('v.recordId');
        //get text area message
        if (!component.get('v.textAreaMessage')) {
            component.set('v.textAreaMessage', '');//<--if message text area is empty set it to blank string and not undefined
        }
        var textAreaMessage = component.get('v.textAreaMessage');
        try {
            var action = component.get("c.rejectApprovalRequestMethod");

            action.setParams({ confId: confId, textAreaMessage: textAreaMessage });
            // cab : cab});
            action.setCallback(this, function (response) {
                var state = response.getState();
                console.log('state searchBankProfile: ' + state);
                if (state === "SUCCESS") {
                    console.log('REQUEST ' + response.getReturnValue());
                    component.set('v.approvalRequestRejected', response.getReturnValue());
                    var currentURL = component.get('v.currentURL');
                    // alert('url: ' + currentURL);
                    // alert('apr reject: ' + component.get('v.approvalRequestRejected'));
                    window.open(currentURL + '/' + component.get('v.approvalRequestRejected'), '_top');
                }

                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error " +
                                errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);

        } catch (err) {
            console.log(err.message);
        }
    },
    //method to open modal
    openModalComments : function(component, event, helper) {
        component.set('v.openModal' , true);
    },
    //method to close modal from 'annulla' and X button
    closeModalComments : function(component, event, helper) {
        
        // if(!component.get('v.textAreaMessage')){
        //     component.set('v.textAreaMessage', '');
        //     alert(component.get('v.textAreaMessage'));
        // }
       component.set('v.openModal' , false); 
    }
})