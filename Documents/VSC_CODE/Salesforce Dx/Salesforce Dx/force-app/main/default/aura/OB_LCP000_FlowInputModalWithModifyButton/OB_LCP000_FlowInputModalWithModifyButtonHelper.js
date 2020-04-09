({
    /**
     * @author Grzegorz Banach <grzegorz.banach@accenture.com>
     * @date 07/05/2019
     * @description The method sets attribute for opening Document Info Modal
     * @task: NEXI-30
    **/
    handleDocumentInfoEvent : function( component, event )
    {
        let cancelBtnClicked = event.getParam( "isCancelButtonClicked" );
        //NEXI-122 Monika Kocot monika.kocot@accenture.com, 09/07/2019 START Modal for check for legal form and fiscal code
        let isFiscalCodeIncorrect = component.get("v.objectDataMap.isFiscalCodeInCorrect");
        //NEXI-122 Monika Kocot monika.kocot@accenture.com, 09/07/2019 STOP
        if ( $A.util.isUndefinedOrNull( cancelBtnClicked ) || typeof cancelBtnClicked != 'boolean' )
        {
           return;
        }
        component.set( "v.isDocumentInfoModalVisible", false );
        //NEXI-122 Monika Kocot monika.kocot@accenture.com, 09/07/2019 START Modal for check for legal form and fiscal code
        if(!cancelBtnClicked && !$A.util.isUndefinedOrNull(isFiscalCodeIncorrect) && isFiscalCodeIncorrect)
        {
            //NEXI-190 Monika Kocot monika.kocot@accenture.com, 09/07/2019 START change fulfilment status of orders, orderheaders and order items after chosen "Controlla Codice Fiscale"
            let orderHeaderId = component.get("v.objectDataMap.OrderHeader.Id");
            let orderId = component.get("v.objectDataMap.Configuration.Id");
            let action = component.get('c.cleanDataMethod');
            action.setParams({"orderHeaderId" : orderHeaderId , "configurationId" : orderId});
            action.setCallback(this,function (response)
                {
                    let state = response.getState();
                    if (state == "SUCCESS")
                    {
                        $A.get('e.force:refreshView').fire();
                    }
                });
            $A.enqueueAction(action);
            //NEXI-190 Monika Kocot monika.kocot@accenture.com, 10/07/2019 STOP
        }
        if ( cancelBtnClicked )
        {
            component.set( "v.objectDataMap.isFiscalCodeInCorrect", false);
            component.set( "v.isShowModifyButton", true);
            return;
        }
        //NEXI-122 Monika Kocot monika.kocot@accenture.com, 09/07/2019 STOP
        component.set( "v.isShowModifyButton", false );
        component.set( "v.objectDataMap.unbind.isCompanyDataModified", true );
    },
})