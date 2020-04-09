({
    createComponentModal : function(component, event) {
        console.log("INTO HELPER METHOD OF MODAL 2");
        $A.createComponent(
            "c:modalLookupWithPagination",
            {
                "aura:id": "modal",
                "objectString":component.get("v.objectString"),
                "type":component.get("v.type"),
                "subType":component.get("v.subType"),
                "subTypeField":component.get("v.subTypeField"),
                "input":component.get("v.inputField"),
                "mapOfSourceFieldTargetField":component.get("v.mapOfSourceFieldTargetField"),
                "mapLabelColumns":component.get("v.mapLabelColumns"),
                "objectDataMap":component.get("v.objectDataMap"),
                "messageIsEmpty":component.get("v.messageIsEmpty"),
                "orderBy":component.get("v.orderBy")
            },
            function(newModal, status, errorMessage){
                if (status === "SUCCESS") {
                    var body = component.get("v.body");
                    body.push(newModal);
                    component.set("v.body", body);
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                }
                    else if (status === "ERROR") {
                        console.log("Error: " + errorMessage);
                    }
            }
        ); 
    },

    initHelper : function(component, event) {
        console.log('INSIDE DO INIT');
        if($A.util.isUndefinedOrNull(component.get("v.objectDataMap"))){
            console.log('objectDataMap mancante')
            return null;
        }

        /*  START   micol.ferrari 26/09/2018 - GET LABEL FROM ADDRESSMAPPING */
        var labelDynamic    = component.get("v.addressMapping.fieldInputLabel");
        var labelReference  = $A.getReference("$Label.c." + labelDynamic);
        component.set("v.fieldInputLabel", labelReference);
        /*  END     micol.ferrari 26/09/2018 - GET LABEL FROM ADDRESSMAPPING */

        var objectDataMap = component.get("v.objectDataMap");
        var addressMapping = component.get("v.addressMapping");
        var objectDataNode = addressMapping.objectDataNode;
        var objectDataField = addressMapping.objectDataField;
        var lovType = addressMapping.lovType;
        var lovOrderBy = addressMapping.lovOrderBy;
        var mapLabelColumns = addressMapping.mapLabelColumns;
        var lovSourceField = addressMapping.lovSourceField;

        
        var subType =  addressMapping.subType || '';
        var subTypeField =  addressMapping.subTypeField || '';
        var fatecoField = addressMapping.fatecoField || '';
        var fatecoFieldFlag = addressMapping.fatecoFieldFlag || '';


        if ((subType == null || subType == '') && subTypeField!= ''){
            subType = objectDataMap[objectDataNode][subTypeField];
        }
        console.log("*SP*subType: "+ subTypeField);
        console.log("*SP*fateco field flag: " + fatecoFieldFlag);
        console.log("*SP* fatecoField: " + fatecoField);
        console.log("*SP* object data map : " + JSON.stringify(objectDataMap));
        if(fatecoFieldFlag !='')
        {
            var fatecoFieldFlagVal = objectDataMap[objectDataNode][fatecoFieldFlag];
            console.log("fatecoFieldFlagVal: "+ fatecoFieldFlagVal);

            if(fatecoFieldFlagVal.toUpperCase() =='S')
            {

                subType = ''; 
                // objectDataMap[objectDataNode][fatecoField];
                // console.log("*SP*subType: "+ subType);
                console.log("*SP*fateco field: " + fatecoField);
                console.log("*SP*objectDataMap: "+ objectDataMap);
            }
        }

        console.log('@@@ objectDataNode: '+objectDataNode);
        console.log('@@@ fatecoField: '+fatecoField);
        console.log('@@@ subType: '+subType);
        console.log('@@@ subTypeField: '+subTypeField);
        

        component.set("v.subType", subType);
        component.set("v.subTypeField", subTypeField);


        //  SET OBJECTSTRING
        component.set("v.objectString", objectDataNode);
        //Set input Field
        component.set("v.inputField", objectDataMap[objectDataNode][objectDataField]);
        //Set Type
        component.set("v.type", lovType);
        //Set lov Source Field 
        var resultMapTargetSource = lovSourceField.split(',');
        console.log(resultMapTargetSource);
        var objTarget = {};
        for (var i=0;i<resultMapTargetSource.length;i++)
        {
            var resultTarget = resultMapTargetSource[i].split('||');
            for (var j=0;j<resultTarget.length;j++)
            {
                objTarget[resultTarget[0]] = resultTarget[1];
            }
        }
        console.log(JSON.stringify(objTarget)); 
        component.set("v.mapOfSourceFieldTargetField",objTarget);
        //Set Order By on Modal
        component.set("v.orderBy", lovOrderBy);
        //Set Map Label Colums
        var resultMapLabelCol = mapLabelColumns.split(',');
        console.log(resultMapLabelCol);
        var objColumns = {};
        for (var i=0;i<resultMapLabelCol.length;i++)
        {
            var resultCol = resultMapLabelCol[i].split('||');
            for (var j=0;j<resultCol.length;j++)
            {
                objColumns[resultCol[0]] = resultCol[1];
            }
        }
        console.log(JSON.stringify(objColumns));
        
        component.set("v.mapLabelColumns",objColumns);

    }
})