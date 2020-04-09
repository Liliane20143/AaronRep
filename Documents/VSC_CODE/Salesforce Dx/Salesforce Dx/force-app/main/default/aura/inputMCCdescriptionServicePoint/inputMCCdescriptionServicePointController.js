({
    doInit : function(component, event, helper) {
        var level   = component.get("v.level");
        var objectDataMap = component.get("v.objectDataMap");



        if(level=='L1'){
            //alert('l1');
            var objectString = 'pv'; //oggetto target -- da definire
            if(!objectDataMap.order && !objectDataMap.order2){
                component.set('v.objectDataMap.order.OB_MCC_Description__c' , '');
                component.set('v.objectDataMap.order.OB_MCC__c' , '');
                component.set('v.objectDataMap.order2.OB_MCC_Description__c' , '');
                component.set('v.objectDataMap.order2.OB_MCC__c' , '');
            }
            var mappa = {
            "Name": $A.get("$Label.c.OB_MCC_Description")
            //"NE__Value2__c" : 'code'

        };
           
        }else if(level=='L2'){
            //alert('l2');
            var objectString = 'order';
            var mappa = {
            "Name": $A.get("$Label.c.OB_MCC_DescriptionL2")
            //"NE__Value2__c" : 'code'

        };
        }else if(level=='L3'){
            //alert('l3');
            var objectString = 'order2';
            //mappa = { apiName LOV : Label} -- in input
            var mappa = {
            "Name": $A.get("$Label.c.OB_MCC_DescriptionL3"),
            "NE__Value2__c" : $A.get("$Label.c.OB_MCC_Code")

        };

        }
        console.log('objectString odInit: ' + objectString);
        
        //objectDataMapTest: variabile mock per testare il componente se non si utilizza il wizard.
        //  var objectDataMapTest = {"merchant":{"sobjectType":"account","RecordTypeId":"","Id":"","Name":"", "OB_Legal_Address_State__c": "","Name": "","OB_Legal_Form__c": ""}};
        
        
        
        //   component.set("v.objectDataMap", objectDataMapTest);
        
        
        console.log("doinit objectDataMap: " + JSON.stringify(objectDataMap));
        console.log("mappa " + JSON.stringify(mappa));
        component.set("v.mapLabelColumns", mappa);
        var mapLabelColumns = component.get("v.mapLabelColumns");
        console.log("mapLabelColumns " + JSON.stringify(mapLabelColumns));
        var mappa2 = {}; 
        //VALUE TO STORE IN OBJECT DATA MAP IN NODE  'pv' , 'order' AND 'order2'
        mappa2['OB_MCC_Description__c'] = 'Name';
        mappa2['OB_MCC__c'] = 'NE__Value2__c';
        console.log('level in input mcc : ' + level);
        if(level=='L1'){
            mappa2['NE__Lov__c']     = 'Id';
            mappa2['MCC_level']      = 'NE__Value3__c';
            var lookupLov = component.get("v.lookupLov");
            component.set("v.lookupLov", lookupLov);
        }
        if(level=='L2'){
            mappa2['hasLeve3']       = 'NE__Value1__c';
            mappa2['OB_tmp_MCC__c']  = 'OB_Value4__c';
            mappa2['MCC_level']      = 'NE__Value3__c';
            mappa2['NE__Lov__c']     = 'Id';
            var lookupLovL2 = component.get("v.lookupLovL2");
            component.set("v.lookupLov", lookupLovL2);
             console.log('TMP ID LEVEL 2: ' +component.get('v.lookupLovL2'));
             console.log('ID TO PASS AT NEXT CALL LEVEL 2: ' +component.get('v.lookupLov'));
            //mappa2['idMCCselected'] = 'NE__Lov__c';
        }
        if(level=='L3'){
             mappa2['MCC_level']     = 'NE__Value3__c';
             mappa2['NE__Lov__c']     = 'NE__Lov__c';// before was mappa2['NE__Lov__c']     = 'Id';
            //  mappa2['name_L2_Parent']     = 'NE__Lov__r.Name';
             var lookupLov = component.get("v.lookupLov");
            component.set("v.lookupLov", lookupLov);
        }
        
        component.set("v.mapOfSourceFieldTargetField", mappa2);
        var mapOfSourceFieldTargetField = component.get("v.mapOfSourceFieldTargetField");
        console.log("mapOfSourceFieldTargetField in input mcc " + JSON.stringify(mapOfSourceFieldTargetField));
        var type    = component.get("v.type");
        var subType = component.get("v.subType");
        
       
        type    = 'MCC';
        subType = '';

        // level   = 'L1';
        component.set("v.subType", subType);
        component.set("v.type", type);
        // component.set("v.level", level);
        console.log('level: ' + component.get('v.level'));
        component.set("v.objectString", objectString);
        component.set("v.orderBy", "Name");
       //alert('child');
        
        console.log('ID TO PASS AT NEXT CALL: ' +lookupLov);
    },
    openModal : function(component, event, helper) {
        component.set("v.avoidDoubleClick", true);
         var objectDataMap = component.get("v.objectDataMap");
        component.set("v.spinner", true); 
        //MAINTAIN VISIBLE THE LEVEL 3
        // if(objectDataMap.order && objectDataMap.order.MCC_level == 'L2' ){
        //     component.set('v.objectDataMap.order'  , {});
            
        //     // component.set('v.objectDataMap.order2' , objectDataMap.order2);
        //     console.log('valore nel livello 3: ' + JSON.stringify(objectDataMap.order2));
        // }
        //  if(objectDataMap.order2 && objectDataMap.order.MCC_level == 'L3' ){
        //     component.set('v.objectDataMap.order2' , {});
        //  }
        
        //component.set("v.showModal", true); 
        //  helper.getLovs(component, event);    
        helper.createComponent(component, event);
    },
    
    handleShowModalEvent : function(component, event, helper) {
        var objectDataMap = event.getParam("objectDataMap");
        var level = component.get('v.level');
        if(level=='L2'){
            objectDataMap.order2.OB_MCC_Description__c = '';
            objectDataMap.order2.OB_MCC__c = '';
            component.set("v.objectDataMap", objectDataMap);
        }
 	if(level=='L3'){
            
            /*
                giovanni spinelli 11/03/2019 
                **METHOD TO AUTO POPULATE THE MCC L2 INPUT WHEN I SELECT AN MCC L3**

                query on l2 when i select first an l3
                call a methon on OB_IdentifyCompany_CC that return the parent NE__Lov__C
                order.OB_MCC__c  = > value to save on configuration l2
                order2.OB_MCC__c = > value to save on configuration l3

                THIS METHOD STARTS ONLY IF I HAVEN'T SELECT AN L2 BEFORE
            */
            
           // START shaghayegh.tofighian 23/05/2019 R1F2-170 (get the coherent OB_MCC_Description__c by choosing OB_MCC__c WHEN OB_MCC__c & OB_MCC_Description__c are already filled and you want to rechoose OB_MCC__c.  )
            if(!objectDataMap.order.OB_MCC__c)
            {
                helper.retrievLovMcc(component, objectDataMap);
            }
            else if(objectDataMap.order.OB_MCC__c)
            {
                helper.retrievLovMcc(component, objectDataMap);
            }
            // END shaghayegh.tofighian 23/05/2019 R1F2-170 (get the coherent OB_MCC_Description__c by choosing OB_MCC__c WHEN OB_MCC__c & OB_MCC_Description__c are already filled and you want to rechoose OB_MCC__c. )

        }
        console.log("handleShowModalEvent event.getParam: " + objectDataMap);
        //component.set("v.objectDataMap", objectDataMap);
    },
    formPress: function(component, event, helper) {
        if (event.keyCode === 13){
            // helper.getLovs(component, event);
            component.set("v.spinner", true);
            helper.createComponent(component, event);
            // component.set("v.showModal", true);        
        }
    },

    searchActive: function(component, event, helper){
        component.set("v.avoidDoubleClick", false);
    }

})