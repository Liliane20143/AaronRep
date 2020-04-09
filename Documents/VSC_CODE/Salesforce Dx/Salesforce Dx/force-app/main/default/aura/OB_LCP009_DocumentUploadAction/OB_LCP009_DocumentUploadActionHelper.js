({
    /**
    *@author Wojciech Kucharek <wojciech.kucharek@accenture.com>
    *@task ?
    *@date ?
    *@description Method creates objectDataMap
    *@history NEXI-286 Joanna Mielczarek <joanna.mielczarek@accenture.com> added OrderHeader field
    */
	createObjectDataMap : function(component, event)
	{
	    let orderHeaderId;
	    try
	    {
            let orderId = component.get("v.recordId");
            let orderRecords = JSON.parse( JSON.stringify( event.getParams( 'orderFields' ) ) ).records;
            orderHeaderId = orderRecords[orderId].fields.NE__Order_Header__c.value;
        }
        catch ( error )
        {
            console.log( 'OB_LCP009_DocumentUploadAction.createObjectDataMap : exception during set OrderHeaderId, ' + error );
        }
        //Start antonio.vatrano 28/09/2019 r1f3-97
        var action = component.get("c.retrieveInfoRiskEvaluation");
		action.setParams({ orderId :  component.get('v.recordId') });
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
                var objMap = response.getReturnValue();
                let objectDataMap = {
                    order : {
                        OB_MCC__c : ''
                    },
                    merchant : {
                        OB_ATECO__c : '',
                        Id : objMap['MERCHANT']
                    },
                    pv : {
                        Id : objMap['PV']
                    },
                    Configuration : {
                        Id : component.get('v.recordId')
                    },
                    OrderHeader : {
                        Id : $A.util.isEmpty( orderHeaderId ) ? '' : orderHeaderId
                    },
                    unbind : {
                        isCompanyDataModified : false
                    }
                };
                component.set('v.objectDataMap', objectDataMap);
                component.set('v.showDocuments', true);
				
			}else {
				console.log("Failed with state: " + state);
			}
		});
        $A.enqueueAction(action);
        //End antonio.vatrano 28/09/2019 r1f3-97

	},
})