({
    setColumns : function(component, event, helper){
                           /* Start Masoud zaribaf 13/05/2019 add columns for datatable*/
                            component.set('v.columns', [
                                // START shaghayegh.tofighian 17/05/2019 
                                { label: $A.get('$Label.c.OB_ChangeOrderLabel'), fieldName: 'id',type: 'url',typeAttributes: { label:{ fieldName: 'name'}}},
                                // END shaghayegh.tofighian 17/05/2019
                                { label: $A.get('$Label.c.OB_StartValidationDate'), fieldName: 'installationDate',type: 'text'},
                                { label: $A.get('$Label.c.OB_AgreededLabel'), fieldName: 'agreed',type: 'text'},
                                { label: $A.get('$Label.c.OB_VariationLabel'), fieldName: 'variation',type: 'text'},
                                
                                /* End Masoud zaribaf 13/05/2019 add columns for datatable*/

                            ]);

    }
})