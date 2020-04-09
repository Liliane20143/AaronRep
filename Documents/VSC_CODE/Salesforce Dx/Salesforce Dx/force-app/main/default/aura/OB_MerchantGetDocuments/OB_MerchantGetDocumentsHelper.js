({
    /*
    *   Author      :   Morittu Andrea
    *   Date        :   02-Sep-2019
    *   Description :   Retrieve documents from filenet
    */

    getMerchantDocumentHelper : function(component, event, helper) {
        var res = [];
        var documentMap = [];
        var merchant = component.get("v.recordId");
        var action = component.get("c.getMerchantDocumentsFromFilenet");
        action.setParams({
            "merchantId": merchant
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('res '+JSON.stringify(response.getReturnValue()));
                var documentIDS = [];
                documentIDS = Object.keys(response.getReturnValue());
                res = Object.values(response.getReturnValue());
                res.sort(function(a,b) {
                    var pattern = /(\d{2})\/(\d{2})\/(\d{4})/;
                    return -(new Date(a.dateCreated.replace(pattern,'$3-$2-$1')) - new Date(b.dateCreated.replace(pattern,'$3-$2-$1')));
                   
                });
                for(var singleDoc in res ) {
                    res[singleDoc].documentID = null;
                	for(var singleDocId in documentIDS) {
                		res[singleDoc].documentID = documentIDS[singleDocId];
                	}
                	
                }
                component.set("v.documentsMap", res);  
                console.log(JSON.stringify(component.get("v.documentsMap")));           
            } else {
                var errors = response.getError();
                if(errors){
                    if(errors[0] && errors[0].message){
                        console.log("Error message: " + errors[0].message);
                    }
                } else{
                    console.log("Unknown error");
                }
            }
            var docSpinner = component.find("docSpinner");
			$A.util.removeClass(docSpinner, 'slds-show');
            $A.util.addClass(docSpinner, 'slds-hide');
        });
        $A.enqueueAction(action);
    },

    /*
    *   Author      :   Morittu Andrea
    *   Date        :   02-Sep-2019
    *   Description :   Open specific document
    */

    openDoc : function(mapValueDocs, docId) {
        console.log('IN HELPER opendoc');
        base64PDF = mapValueDocs[docId]['b64'];                  
        console.log('base64PDF: ' + base64PDF);
        var raw = atob(base64PDF);
        var uint8Array = new Uint8Array(new ArrayBuffer(raw.length));
        for (var i = 0; i < raw.length; i++) {
            uint8Array[i] = raw.charCodeAt(i);
        }
        var file = new Blob([uint8Array], { type: 'application/pdf' });
        var fileURL = URL.createObjectURL(file);
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": fileURL
        });
        urlEvent.fire();
    },

    /*
    *   Author      :   Morittu Andrea
    *   Date        :   02-Sep-2019
    *   Description :   Fitler Result Function
    */

    filter_Helper : function(component, event, helper) {
        var matchedResult = [];

        var whichOne = event.currentTarget.value;
        component.set('v.showFilteredTable', false );    
        
        var docSpinner = component.find("docSpinner");

        const listOfData = component.get('v.documentsMap');

        

        component.set('v.documentsMap', listOfData );

        var documentType    = component.find('documentType').get('v.value');
        var ABI             = component.find('ABI').get('v.value');
        var servicePoint    = component.find('servicePoint').get('v.value');

        matchedResult = listOfData.filter(function (toMatch) {
            var matchedList = [];
            if(!$A.util.isUndefined(toMatch.documentType) && !$A.util.isEmpty(documentType) && toMatch.documentType.toLowerCase().includes(documentType.toLowerCase())) {
                return toMatch;
            }
            if(!$A.util.isUndefined(toMatch.ABI) && !$A.util.isEmpty(ABI) && toMatch.ABI.toLowerCase().includes(ABI.toLowerCase())) {
                return toMatch;
            }
            if(!$A.util.isUndefined(toMatch.servicePointName) && !$A.util.isEmpty(servicePoint) && toMatch.servicePointName.toLowerCase().includes(servicePoint.toLowerCase())) {
                return toMatch;
            }
            // return matchedList;
          
        });
        if(matchedResult.length >= 1) {
            component.set('v.filteredDocumentMap', matchedResult );
            component.set('v.showFilteredTable', true );

            $A.util.removeClass(docSpinner, 'slds-show');
            $A.util.addClass(docSpinner, 'slds-hide');

        } else {
            let title       =   '';
            let message     =   $A.get("$Label.c.OB_NoDataFoundLabel");
            let type        =   'warning';
            $A.util.removeClass(docSpinner, 'slds-show');
            $A.util.addClass(docSpinner, 'slds-hide');


            this.showToast(component, event,title, message, type);
            component.set('v.filteredDocumentMap', listOfData );
            component.set('v.showFilteredTable', false );
        }

        
    },

    /*
    *   Author      :   Morittu Andrea
    *   Date        :   02-Sep-2019
    *   Description :   Clear research
    */
    resetResearch_Helper : function(component, event, helper) {
        component.set('v.filteredDocumentMap', [] );
        component.set('v.showFilteredTable', false);

        component.find('documentType').set('v.value', '');
        component.find('ABI').set('v.value', '');
        component.find('servicePoint').set('v.value', '');
    },

    /*
        *   Author      :       Morittu Andrea
        *   Ddate       :       02-Sep-2019
        *   Description :       Redirect to sObject SFDC
    */
    redirectToObjectDetail_Helper : function(component, event, helper) {
                
        let whicOne = event.target.id;
        let whicObject = whicOne.split('-')[0];
        let whicId = whicOne.split('-')[1];
        
        var navLink = component.find("navLink");
        var pageReference = {    
            "type": "standard__recordPage",
            "attributes": {
                "recordId": whicId,
                "actionName": "view"
            }
        }
    
        navLink.generateUrl(pageReference)
        .then($A.getCallback(function(url) {
            console.log('success: ' + url);
            window.open(url,'_blank');
        }), 
        $A.getCallback(function(error) {
        console.log('error: ' + error);
        }));
    },

    /*
    *   Author      :   Morittu Andrea
    *   Date        :   02-Sep-2019
    *   Description :   Show toast function
    */
    showToast: function (component, event,title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    },
    
})