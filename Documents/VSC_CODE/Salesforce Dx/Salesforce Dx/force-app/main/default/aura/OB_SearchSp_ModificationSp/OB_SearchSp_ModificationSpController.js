({
    doInit : function(component, event , helper)
    {   
        var objectDataMap = component.get("v.objectDataMap");
        console.log('this is doInit');  
        console.log("the boolean is" + component.get("v.showOtherInput") );
        
    },
    
    onClickToSearch:function(component, event, helper) {
        
        
        var searchAddress = component.find("searchInputAddressId").get("v.value");
        var searchName    = component.find("searchInputNameId").get("v.value"); 
        
        if((searchAddress !== undefined || searchAddress !="" || searchAddress != null) &&
           (searchName !== undefined || searchName !="" || searchName != null)){
            
            component.set("v.booleanDoSearch",false); 
        }
        
        else{
            component.set("v.booleanDoSearch",true); 
        }
        
    },
    
    closeModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "False"  
        component.set("v.isOpen", false);
    },

    
    doSearch:function(component, event, helper) {
   
        var searchAddress = component.find("searchInputAddressId").get("v.value");

        var searchName    = component.find("searchInputNameId").get("v.value"); 
        var searchAddressUpperCase;
        var searchNameUpperCase;
        if(searchAddress !== undefined || searchAddress != "" || searchAddress != null){
          searchAddressUpperCase = (searchAddress.trim()).toUpperCase();
        }
        
        if(searchName !== undefined || searchName !="" || searchName != null){
         searchNameUpperCase = (searchName.trim()).toUpperCase();
   		 }
        var servicePointData = component.get("v.servicePointData");
        
        var filteredList = [];
            
        /*Filtrer par Service point address et servicePointName */
        
        for( var i =0 ;i<servicePointData.length; i++){
             
           if(((servicePointData[i].NE__Street__c !== undefined) && ((servicePointData[i].NE__Street__c.trim()).toUpperCase()).indexOf(searchAddressUpperCase) != -1) ||
             ((servicePointData[i].OB_Service_Point_Name__c !== undefined) && ((servicePointData[i].OB_Service_Point_Name__c.trim()).toUpperCase()).indexOf(searchNameUpperCase) != -1)){
                
                console.log("sono in indexOf method *_* ");
                
                filteredList.push(servicePointData[i]);
                
                
            }
            
        }  
        console.log("filteredList length is ------>> : " + filteredList.length);
        
        component.set("v.servicePointData",filteredList);
         


    },

  
    
    searchClick : function(component, event, helper) {

      //******giovanni spinelli start******//

      var appEvent = $A.get("e.c:OB_EventNextButton");
      
      //var stepName = component.find("errorMessageId").get("v.value");
      appEvent.setParams({"showPvErrorMessage" : false  });
      appEvent.setParams({"idStep" : "step_getMerchant" });
      appEvent.fire();
      //component.set( "v.showPvErrorMessage", false);
      console.log("the show error is: " + component.get("v.showPvErrorMessage"));
      //******giovanni spinelli stop******//


      component.set("v.showNewButton", false);
        
        //boolean to open the Modal table
        component.set("v.isOpen", true);
        
		component.set("v.booleanDoSearch",true); 
        
       // component.get("v.servicePointData");
        //component.set("v.servicePointData", []);
        
        var objectDataMap = component.get("v.objectDataMap");
        var objectDataMapClone = component.get("v.objectDataMapClone");
        var fiscalCode = component.get("v.objectDataMap.merchant.NE__Fiscal_code__c");
        console.log("RESPONSE fiscalCode ----->>>>" + fiscalCode);
        
        var merchantId = component.get("v.objectDataMap.merchant.Id");
 		console.log("RESPONSE  merchantId ------>>>>>> " + merchantId);
        
        var action = component.get("c.listServicePoint");
        
        action.setParams({fiscalCode : fiscalCode, 
                          merchantId : merchantId});
        
        action.setCallback(this, function(response) 
                           {
                               var state = response.getState();
                               console.log("the state is  "+ state);
                               if (state === "SUCCESS") {
                                   console.log("RESPONSE " + JSON.stringify(response.getReturnValue()));
                                   
                                   //check if doesn't exist any service points connect to a fiscal code
                                   if(response.getReturnValue().length === 0)
                                   {
                                      /* component.set("v.showTableNew2", true);
                                       $A.util.removeClass(document.getElementById("dataTableId"), 'slds-hide');
                                       $A.util.addClass(document.getElementById("dataTableId"), 'slds-show'); */
                                   }
                                   else
                                   {
                                       //component.set("v.showTableNew2", false); 
                                   }
                                   component.set("v.servicePointData", response.getReturnValue());   
                                   console.log("RESPONSE servicePointData ******" + JSON.stringify(component.get("v.servicePointData")));
                                   
                                   component.set('v.columns', [
                                       {label: $A.get("$Label.c.City"),fieldName: 'NE__City__c',   type: 'text'},
                                       {label: $A.get("$Label.c.Street"),fieldName: 'NE__Street__c', type: 'text'},
                                       {label: $A.get("$Label.c.Name"),fieldName: 'Name', type: 'text'},
                                       {label: $A.get("$Label.c.OB_MCC_Description"),fieldName: 'OB_MCC_Description__c', type: 'text'},
                                       {label: $A.get("$Label.c.Service_Point_Name"),fieldName: 'OB_Service_Point_Name__c', type: 'text'},
                                       {label: $A.get("$Label.c.PostalCode"),fieldName: 'NE__Postal_Code__c', type: 'text'}
                                   ]);
                                   
                               }
                               else if (state === "INCOMPLETE") 
                               {
                                   // do something
                               }
                                   else if (state === "ERROR") 
                                   {
                                       // alert('You have to insert the new service point');
                                       var errors = response.getError();
                                       if (errors) {
                                           if (errors[0] && errors[0].message) 
                                           {
                                               console.log("Error message: " + 
                                                           errors[0].message);
                                           }
                                       } else 
                                       {
                                           console.log("Unknown error");
                                       }
                                   }
                           });
        $A.enqueueAction(action);
        
        
    },
    
    
    
    /*Function to select a service point */
    
    getSelectedServicePoints:function(component, event, helper) {  
        
        //component.set("v.resetTab", true);
        
        var selectedRows = event.getParam('selectedRows');
        var objectDataMap = component.get("v.objectDataMap");
        var objectDataMapClone = component.get("v.objectDataMapClone");
        console.log("SONO objectDataMap "+ JSON.stringify(objectDataMap));
        
        for (var i = 0; i < selectedRows.length; i++){
            component.set("v.selectServicePoint", selectedRows[i]);
        }
        var selectServicePoint = component.get("v.selectServicePoint");
        console.log('selectServicePoint: ' + JSON.stringify(selectServicePoint));
 
        /*var appEvent = $A.get("e.c:searchServicePointEvent");
        appEvent.setParams({ "servicePointEvent" : selectServicePoint });
        appEvent.fire();*/

        
        if(selectedRows.length===1){
             
            //close modal  after select a service point
            component.set("v.isOpen", false);
            
            console.log("la selectedRows è: " + JSON.stringify(selectedRows));
            var selectedPv = selectedRows[selectedRows.length-1];
            
            //****SET THE OBJDATAMAP WITH THE VALUE FROM A SELECTED SERVICE POINT****//
            objectDataMap.pv.NE__Account__c = selectedPv.NE__Account__c;
            objectDataMap.pv.Name = selectedPv.Name;
            objectDataMap.pv.NE__Street__c = selectedPv.NE__Street__c;
           objectDataMap.pv.OB_Street_Number__c = selectedPv.OB_Street_Number__c;
            console.log("numero civico: " + selectedPv.OB_Street_Number__c);
            objectDataMap.pv.NE__Postal_Code__c = selectedPv.NE__Postal_Code__c;
            objectDataMap.pv.NE__City__c = selectedPv.NE__City__c;
            objectDataMap.pv.NE__Country__c = selectedPv.NE__Country__c;
            objectDataMap.pv.OB_Email__c = selectedPv.OB_Email__c;
            objectDataMap.pv.OB_MCC_Description__c = selectedPv.OB_MCC_Description__c;
            objectDataMap.pv.NE__Province__c=selectedPv.NE__Province__c;
            objectDataMap.pv.Id = selectedPv.Id;
            console.log("PUNTO VENDITA ID: " +             objectDataMap.pv.Id);
        }
            component.set("v.objectDataMap" , objectDataMap ); 
            component.set("v.objectDataMapClone" , objectDataMap ); 
        
          /*if(isEmpty(objectDataMap)){
            component.set("v.objectDataMap" , objectDataMapClone ); 
		}*/
          
    },
    
    
    
    /*function to create new service point */
    
    /*newServicePoint :function(component, event, helper) { 
        
        var objectDataMap = component.get("v.objectDataMap");
        
        component.set("v.resetTab", true);
        
        //show search table 
        //component.set("v.showTable", false);
        
        //reset the objectDataMap to insert a new service point
        component.set("v.objectDataMap.pv",{});
        
        component.set("v.selectedRows", []);
        console.log(' The select row is '+ JSON.stringify(component.get("v.selectedRows")));
        
        component.set("v.showEmptyInput",true);
        // console.log("the boolean is -> "+component.get("v.showEmptyInput"));
        
        
        // console.log('Create record');
                     
    },*/
    
    CloseClick:function(component, event, helper) { 
        var closeMessage = document.getElementById("message");
        closeMessage.style.display= 'none';
        if(closeMessage.style.display= 'none'){
            closeMessage.style.display= '';
        }
        else {
            closeMessage.style.display= 'none';
        }
        
    },
    
    
    ClickSave:function(component, event, helper) {
        
        console.log("sono nel submit method");
        
        var objectDataMap= component.get("v.objectDataMap");
        //console.log("name new service point : " + JSON.stringify(objectDataMap));
        
        
        console.log("mcc  new service point dopo objectdataMap : " + component.find("mcc").get("v.value"));
        console.log("name new service point dopo objectdataMap : " + component.find('name').get('v.value'));
        console.log("mcc by id new service point dopo objectdataMap : " + document.getElementById('mcc').value);
        //comunico con il flusso
         
            objectDataMap.pv.Name               = document.getElementById("name").value;
            objectDataMap.pv.NE__Street__c      = document.getElementById("street").value;
            objectDataMap.pv.NE__Postal_Code__c = document.getElementById("Zipcode").value;
            objectDataMap.pv.NE__City__c        = document.getElementById("city").value;
            objectDataMap.pv.NE__Country__c     = document.getElementById("country").value;
            objectDataMap.pv.OB_MCC_Description__c          = document.getElementById("mcc").value;
            
             
        component.set("v.objectDataMap",objectDataMap);
        
        //Calling the Apex Function
        var action = component.get("c.checkNewServicePoint");
        
        
        //objectDataMap da trasformare in oggetto service point nel metodo apex 
        var objectDataMap = component.get("v.objectDataMap");
        console.log("ricupero objectDataMap --> objectDataMap  : " + JSON.stringify(objectDataMap));   
 
        //ricupero ID del merchant
        var merchantId = component.get("v.objectDataMap.merchant.Id");
        console.log("ricupero ID del merchant --> merchantId  : " + merchantId); 
        
        objectDataMap.pv.NE__Account__c = merchantId;
        console.log("settato object dataMap pv lookup : " + objectDataMap.pv.NE__Account__c);
        //entro nel dataTable
        var servicePointData = component.get("v.servicePointData");
        console.log("ricupero  del servicelist --> servicePointData  : " + JSON.stringify(servicePointData)); 
        
        var objectDataMapServicePoint = component.get("v.objectDataMapServicePoint");
         
        
        //objectDataMapServicePoint.push(JSON.stringify(objectDataMap.pv));
        var objectDataMapServicePoint = JSON.stringify(objectDataMap.pv);
        
        component.set("v.objectDataMapServicePoint", objectDataMapServicePoint);         
        console.log("objectDataMapServicePoint --->: " + JSON.stringify(objectDataMap.pv));
        
        
        action.setParams({
            objectDataMapServicePoint : objectDataMapServicePoint,
            servicelist : servicePointData,
            merchantId  : merchantId
        });
        
        //Setting the Callback
        action.setCallback(this,function(a){
            //get the response state
            var state = a.getState();
            
            //component.set("v.servicePointDataInsert",true);
            
            //check if result is successfull
            if(state == "SUCCESS"){
                if(a.getReturnValue() == true){
                    //console.log("messaggio di errore! service point già esistente");
                    console.log("value service point :" + JSON.stringify(a.getReturnValue()));
                    component.set("v.msgInsertServicepoint", "messaggio di errore! service point già esistente");
                }else{
                    console.log("service point inserito");
                    //component.set("v.msgInsertServicepoint", "service point inserito");
                }
                //console.log(a.getReturnValue()); 
                
            } else if(state == "ERROR"){
                
            }
        });
        
        //adds the server-side action to the queue        
        $A.enqueueAction(action);
        
        
    } ,
    
    
    clearForm: function(component, event, helper) { 
      // component.set("v.objectDataMap.pv",null);
 
    },
    
        
    CompleteAddress: function(component, event, helper) {
        
         var objectDataMap= component.get("v.objectDataMap");
         var name    = document.getElementById("name").value;
         var mcc     = document.getElementById("mcc").value; 
         var street  = document.getElementById("street").value; 
         var city    = document.getElementById("city").value; 
         var country = document.getElementById("country").value; 
         var Zipcode = document.getElementById("Zipcode").value; 
        
         //var number  = ['1','2','3','4','5','6','7','8','9','0'];
        
    
          /* if(isNaN(mcc) || mcc.includes(" ")){
             alert('insert MCC Code with number '+
                     'or insert MCC Code without spaces');  
               break;
            }*/
        

         //if(mcc.includes(" ") ){
           //alert('insert MCC Code without spaces');
           //document.getElementByClassName("mcc").required = true;
         //}


        document.getElementById("input:pv:Name").value               = name.trim();
        document.getElementById("input:pv:OB_MCC_Description__c").value          = mcc.trim();        
        document.getElementById("input:pv:NE__Street__c").value      = street.trim();
        document.getElementById("input:pv:NE__City__c").value        = city.trim();
        document.getElementById("input:pv:NE__Country__c").value     = country.trim();
        document.getElementById("input:pv:NE__Postal_Code__c").value = Zipcode.trim();
        
        
        component.set("v.objectDataMap.pv.Name",document.getElementById("name").value);
        component.set("v.objectDataMap.pv.OB_MCC_Description__c",document.getElementById("mcc").value);
        component.set("v.objectDataMap.pv.NE__Street__c",document.getElementById("street").value);
        component.set("v.objectDataMap.pv.NE__City__c",document.getElementById("city").value);
        component.set("v.objectDataMap.pv.NE__Country__c",document.getElementById("country").value);
        component.set("v.objectDataMap.pv.NE__Postal_Code__c",document.getElementById("Zipcode").value);
        
         component.set("v.objectDataMap",objectDataMap);
        
        
    },
    
    
})