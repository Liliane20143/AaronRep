({
    doInit : function(component, event, helper) {
        // console.log('objectMap new order doinit :' + JSON.stringify(component.get("v.objectDataMap")));
        component.set("v.Si",$A.get("$Label.NE.SiSplit"));
        component.set("v.No",$A.get("$Label.NE.NoSplit"));
        component.set("v.Close",$A.get("$Label.NE.close"));
        
    },
    
    getSelection : function(component,event,helper){
        // console.log('objectMap nel new order begin getselection :' + JSON.stringify(component.get("v.objectDataMap")));
        var selectedValue = event.target.value;
        document.getElementById('input:unbind:NewOrderSelected').value =event.target.value;
        if(selectedValue == 'Si'){
        	component.set("v.objectDataMap.pv",{});
        	component.set("v.objectDataMap.Responsabile_Amm_PV",{});
        	component.set("v.objectDataMap.Responsabile_PV",{});
        	component.set("v.objectDataMap.Referente_TecnicoPV",{});
        	component.set("v.objectDataMap.Configuration",{});
        	component.set("v.objectDataMap.disabledABI",true);
        	component.set("v.objectDataMap.disabledCAB",true);
        	component.set("v.objectDataMap.hideFiscalCode",true);
        	component.set("v.objectDataMap.hideVat",true);
        	component.set("v.objectDataMap.hideField",true);
            //var merchant = component.get("v.objectDataMap.merchant");
            //merchant.ShowButtonSP = "true";
            
        }
        if(document.getElementById('input:unbind:NewOrderSelected').value !=null){
            document.getElementById('input:unbind:NewOrderSelected').dispatchEvent(new Event('blur'));   

        }
        // console.log('objectMap nel new order :' + JSON.stringify(component.get("v.objectDataMap")));

    }
})