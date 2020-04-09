({
   //START francesca.ribezzi 13/06/19 adding doInit
    doInit : function(component, event, helper) {
         //START francesca.ribezzi 18/06/19 setting default active values
       /* var data = component.get("v.data"); 
        var ABIwithMatrixMap = {};
        var abiList = [];
        var matrixParameter = component.get("v.matrixParameter");
        var isActive = component.get("v.matrixParameter.NE__Active__c");
        for (var i = 0; i < data.length; i++){
            if(isActive){
               data[i].checked = true;
               abiList.push(data[i].OB_ABI__c);
            }else{
               data[i].checked = false;
            }
        }
        ABIwithMatrixMap[matrixParameter.Id] = abiList;
        component.set("v.data", data);
        component.set("v.ABIwithMatrixMap", ABIwithMatrixMap);*/
        //END francesca.ribezzi 18/06/19
    },
   //START francesca.ribezzi 14/06/19 adding getSelectedAbi
    getSelectedAbi: function(component, event, helper) {
        var clickedRow = event.target.checked;
        var abi = event.target.value;
        console.log('$$$ABI? ' + abi);
        var abiList = [];
        var data = component.get("v.data"); 
        var selectedBank = data[event.target.id]
        var ABIwithMatrixMap = {};
        for (var i = 0; i < data.length; i++){
            if(data[i].OB_ABI__c == abi && clickedRow){
               data[i].checked = true;
            }else if(data[i].OB_ABI__c == abi && !clickedRow){
               data[i].checked = false;
            }
        }
        for (var i = 0; i < data.length; i++){
            if(data[i].checked){
               abiList.push(data[i].OB_ABI__c);
            } 
        }
        var matrixParameter = component.get("v.matrixParameter");
    //    if(abiList.length > 0){
            ABIwithMatrixMap[matrixParameter.Id] = abiList;
            component.set("v.ABIwithMatrixMap", ABIwithMatrixMap);
      //  }
    
    },

    //francesca.ribezzi 03/07/19 handleActiveMatrixParameter method deleted - F2WAVE2-16.

})