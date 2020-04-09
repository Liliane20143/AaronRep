({
    /*******************************************************************************
    Purpose:  Insert order item attribute on Server 2 Server product
    History
    --------
    VERSION     AUTHOR                  DATE            DETAIL          Description
    1.0         Andrea Saracini         08/05/2019      Created         Method
    ********************************************************************************/
	onChangeAttributeValueS2S:function(component, event) {
        // <daniele.gandini@accenture.com> - 08/07/2019 - F2WAVE2-88 - start
        var currentId = component.find("{!item.fields.name}");
        var applicazionelUtilizzata = $A.get("$Label.c.OB_Applicazione_Utilizzata");
        // <daniele.gandini@accenture.com> - 08/07/2019 - F2WAVE2-88 - end
		var target = event.getSource();
		var attrVal = target.get("v.value") ;
        var attrName =  target.get("v.name");
        var itemServer2Server = component.get("v.server2serverList");					
        var itemToUpdate;
        //START francesca.ribezzi 15/07/19 deleting contextOutput logic - performance
        for(var i = 0; i< itemServer2Server[0].listOfAttributes.length; i++){
            var att = itemServer2Server[0].listOfAttributes[i];
            if(att.fields.name == attrName){
                itemServer2Server[0].listOfAttributes[i].fields.value = attrVal;
                var newValue = 	attrVal;
                var oldValue = itemServer2Server[0].listOfAttributes[i].fields.Old_Value__c;
                if(newValue != oldValue){
                    itemServer2Server[0].listOfAttributes[i].fields.NE__Action__c = 'Change';
                }else{
                    itemServer2Server[0].listOfAttributes[i].fields.NE__Action__c = 'None';
                }
                if($A.util.isEmpty(oldValue)){
                    oldValue = newValue;
                }
                break;
            }
        }

        //END francesca.ribezzi 15/07/19
        component.set("v.server2serverList", itemServer2Server);

    }
})