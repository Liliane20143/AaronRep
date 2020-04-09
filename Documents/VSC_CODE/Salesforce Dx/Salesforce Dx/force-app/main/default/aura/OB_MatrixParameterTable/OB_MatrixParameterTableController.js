({
    doInit : function(component, event, helper) {

  
        const columns = [
            {label: 'Nome', fieldName: 'Name', type: 'text'},
            {label: 'ABI', fieldName: 'OB_ABI__c', type: 'text'}
       ];
       
       const data = [];

        var allABIlist = component.get("v.allABIlist");
        //14/06/19 francesca.ribezzi adding cleanABIlist:
        var cleanABIlist = [];
        for(var key in allABIlist){
            var tempABIopt = {};
            tempABIopt.id = allABIlist[key].id;
            tempABIopt.Name = allABIlist[key].label;
            tempABIopt.OB_ABI__c = allABIlist[key].value;
            //START francesca.ribezzi 14/06/19
            tempABIopt.checked = false; // 03/07/19 francesca.ribezzi F2WAVE2-16 setting checkbox unchecked as default
            cleanABIlist.push(allABIlist[key].value);
            //END francesca.ribezzi 14/06/19
            data.push(tempABIopt);
        }
        console.log("@DATA IN MATRIX PARAM TABLE cmp: ", data);
        component.set("v.data",data);    

        component.set("v.abicolumns", columns);
        var matrixParameterList = component.get("v.matrixParameterList");
        var ABIwithMatrixCompletedMap = component.get("v.ABIwithMatrixCompletedMap");
        var allABIlist = component.get("v.allABIlist");
        //associating all ABI list to all matrix parameter as default:
        for(var key in matrixParameterList){
            //francesca.ribezzi 14/06/19 using cleanABIlist as value
            ABIwithMatrixCompletedMap[matrixParameterList[key].Id] = cleanABIlist; 
        }
        component.set("v.ABIwithMatrixCompletedMap",ABIwithMatrixCompletedMap);
        console.log('$$$$ABIwithMatrixCompletedMap: '+ JSON.stringify(ABIwithMatrixCompletedMap));
        component.set("v.totalPages", Math.ceil(matrixParameterList.length/component.get("v.pageSize")));
        component.set("v.currentPageNumber",1);

        var allABIlist = component.get("v.allABIlist");
        var activeABIList = component.get("v.activeABIList"); 
        var availableABIList = component.get("v.availableABIList");
        for(var key in allABIlist){
           var tempABIopt = {};
           tempABIopt.value = allABIlist[key];
           tempABIopt.label = allABIlist[key];
  
           activeABIList.push(allABIlist[key]);
           availableABIList.push(tempABIopt);
        }

        console.log('activeABIList: ',activeABIList);
        console.log('availableABIList: ',availableABIList);
        component.set("v.activeABIList", activeABIList);
        component.set("v.availableABIList", availableABIList);
        //14/06/19 francesca.ribezzi helper commented
        //helper.buildData(component, helper);
    },
    onNext : function(component, event, helper) {        
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber+1);
        helper.buildData(component, helper);
    },
    
    onPrev : function(component, event, helper) {        
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber-1);
        helper.buildData(component, helper);
    },
    
    processMe : function(component, event, helper) {
        component.set("v.currentPageNumber", parseInt(event.target.name));
        helper.buildData(component, helper);
    },
    
    onFirst : function(component, event, helper) {        
        component.set("v.currentPageNumber", 1);
        helper.buildData(component, helper);
    },
    
    onLast : function(component, event, helper) {        
        component.set("v.currentPageNumber", component.get("v.totalPages"));
        helper.buildData(component, helper);
    },

    handleSetCheckBoxToAll : function(component, event, helper) {
        var setAllCheckbox = component.get("v.setAllCheckbox");
        var active = event.currentTarget.checked;
        component.set("v.setAllCheckbox", active);
    },

    updateABImatrixMap: function(component, event, helper) {
        var singleMap = event.getParam("value");
        var ABIwithMatrixCompletedMap = component.get("v.ABIwithMatrixCompletedMap");
        //updating completedMap with selected Abi list:
        for(var key in singleMap){
            ABIwithMatrixCompletedMap[key] = singleMap[key];
        }
        console.log('ABIwithMatrixCompletedMap: '+ JSON.stringify(ABIwithMatrixCompletedMap));
        component.set("v.ABIwithMatrixCompletedMap", ABIwithMatrixCompletedMap);
      
    },
    /*
     *@author francesca.ribezzi
     *@date  03/07/19
     *@task F2WAVE2-16
     *@description Method checks all banks' checkboxes
     *@history 03/07/19 Method created
     */
    updateAllCheckbox: function(component, event, helper) {
        var setAllCheckboxMatrixTable = component.get("v.setAllCheckboxMatrixTable");
        component.set("v.setAllCheckbox", setAllCheckboxMatrixTable);

    },

})