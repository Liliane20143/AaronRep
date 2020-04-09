({ 
    handleEvent : function(component, event, helper) {
        var value  = event.getParam("province");
        var value2 = event.getParam("comune");
        var value3 = event.getParam("frazione");
        var value4 = event.getParam("caps");
        var value5 = event.getParam("isDisabled");
        component.set("v.province" , value );
        component.set("v.comune"   , value2);
        component.set("v.frazione" , value3);
        component.set("v.caps" , value4);
        component.set("v.isDisabled" , value5);
        console.log("the cap is: " + component.get("v.isDisabled"));
    },
    callService : function(component, event , helper){
        console.log(event.target.id);
        //var url = '/province';
        var field = event.target.id;
        var input = ' ';
        var idField = '';
        var request = $A.get("e.c:OB_ContinuationRequest");
        console.log('siamo nel completeProvincia, stampo la request: '+request);
        request.setParams({ 
            methodName: "getPostel",
            methodParams: [field, input, idField],
            callback: function(result) {
                console.log('RISULTATO: '+ result);
                component.set("v.response" , result);
            }
        });
        
        request.fire();
        //console.log("prov response : " + component.get("v.response"));
    },
    provincia:function(component, event , helper){
        helper.province(component, event , helper);
    },
    comune: function(component, event , helper){
        helper.city(component, event , helper);
    }
})