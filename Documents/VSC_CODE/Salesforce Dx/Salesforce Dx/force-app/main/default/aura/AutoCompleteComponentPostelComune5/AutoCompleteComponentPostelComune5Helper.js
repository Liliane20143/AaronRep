({
    city : function(component, event , helper)
    {
        var coms = component.get("v.responseCom");
        var listaComuni = [];
        let citiesForAutocomplete = [];
        if(coms!=null && typeof coms == 'object' )
        {
            for (var key in coms)
            {
                coms[key] = coms[key].replace("&#39;","\'");
                listaComuni.push(coms[key]);
                citiesForAutocomplete.push
                ({
                    value : key,
                    label : coms[key]
                });
            }
            component.set('v.comuniList',listaComuni.sort());
            component.set("v.filteredOptions", citiesForAutocomplete);
        }
    },

    removeRedBorder: function (component, event , helper)
    {
        var sectionName = component.get("v.addressMapping.sectionName");
        if(sectionName == undefined || sectionName == null)
        {
            sectionName='';
        }
        var errorId = 'errorIdcomune'+sectionName;
        //REMOVE ERROR MESSAGE
        $A.util.removeClass(document.getElementById("comune"+sectionName), 'slds-has-error flow_required');
        $A.util.addClass(document.getElementById("comune"+sectionName), 'slds-input');
        if(document.getElementById(errorId)!=null)
        {
            document.getElementById(errorId).remove();
        }
    },

    removeRedBorderEE: function (component, event , helper)
    {
        var sectionName = component.get("v.addressMapping.sectionName");
        if(sectionName == undefined || sectionName == null)
        {
            sectionName='';
        }
        var errorId = 'errorIdcityEE'+sectionName;
        //REMOVE ERROR MESSAGE
        $A.util.removeClass(document.getElementById("cityEE"+sectionName), 'slds-has-error flow_required');
        $A.util.addClass(document.getElementById("cityEE"+sectionName), 'slds-input');
        if(document.getElementById(errorId)!=null)
        {
            document.getElementById(errorId).remove();
        }
    },

    setInputLabel : function(component)
    {
        let sectionAdress = component.get("v.addressMapping.sectionaddress");
        if(sectionAdress == "sedelegale")
        {
            component.set("v.inputLabel",$A.get("$Label.c.OB_Legal_Address_City"));
        }
        else if(sectionAdress == "sedeamministrativa")
        {
            component.set("v.inputLabel",$A.get("$Label.c.OB_Administrative_Office_City"));
        }
        else if(sectionAdress == "generaladdress")
        {
            component.set("v.inputLabel",$A.get("$Label.c.OB_Address_City"));
        }
        else if(sectionAdress == "documentrelease")
        {
            component.set("v.inputLabel",$A.get("$Label.c.OB_Document_Release_City"));
        }
        else if(sectionAdress == "birthaddress")
        {
            component.set("v.inputLabel",$A.get("$Label.c.OB_Birth_City"));
        }
    }
})