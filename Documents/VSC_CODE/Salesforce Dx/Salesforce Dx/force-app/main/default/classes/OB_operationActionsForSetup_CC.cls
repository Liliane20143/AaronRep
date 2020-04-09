public without sharing class OB_operationActionsForSetup_CC {

    /*******************************************************************************
	Purpose:  method to get visibility buttons
    Parameters: Id orderHeaderId
    Returns: -

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         Elena Preteni           22/07/2019      Created         method to get visibility buttons
	
 	********************************************************************************/
    @AuraEnabled
    public static Map<String,String> checkButtonsVisible(Id orderHeaderId){

        Map<String,String> returnMap = new Map<String,String>();
        List<User> listUs=[SELECT id, profile.name FROM User WHERE id=:UserInfo.getUserId()];
        if(!listUs.isEmpty() ){
            returnMap.put('isOperation',String.valueOf(listUs.get(0).profile.name == 'Operation'));
        }
        List<NE__Order_Header__c> orderHeaders =
            [
                    SELECT 
                    Id, 
                    Name, 
                    CreatedBy.Profile.Name,
                    OB_StartApprovalProcess__c,
                    OB_In_Approvazione_a__c,
                    OB_Rejection_Reason__c,
                    OB_ExitFlow__c //francesca.ribezzi 13/09/19 - R1F3-48 - adding OB_ExitFlow to check whether to show or not the ResumeFlow button
                    FROM NE__Order_Header__c
                    WHERE Id = :orderHeaderId
            ];
        if(!orderHeaders.isEmpty() ){
            returnMap.put('isOperationSetup',String.valueOf(orderHeaders.get(0).CreatedBy.Profile.Name == 'Operation')); 
            returnMap.put('OB_StartApprovalProcess__c',String.valueOf(orderHeaders.get(0).OB_StartApprovalProcess__c)); 
            returnMap.put('OB_In_Approvazione_a__c',orderHeaders.get(0).OB_In_Approvazione_a__c); 
            returnMap.put('OB_Rejection_Reason__c',orderHeaders.get(0).OB_Rejection_Reason__c); 
        }
        List<NE__Order__c> configurations =
        [
                SELECT NE__Order_date__c,
                        OB_Service_Point__r.Name,
                        OB_Service_Point__r.NE__Street__c,
                        OB_Service_Point__r.OB_Street_Number__c,
                        OB_Service_Point__r.NE__City__c,
                        OB_Service_Point__r.NE__Zip_Code__c,
                        NE__Order_Header__r.OB_FulfilmentStatus__c,
                        OB_FulfilmentStatus__c, NE__Order_Header__r.OB_Main_Process__c,
                        NE__Order_Header__r.OB_StartApprovalProcess__c,OB_ApprovalStatus__c,
                        OB_PricingApproval__c
                FROM NE__Order__c
                WHERE NE__Order_Header__c = :orderHeaderId
        ];
        if ( !configurations.isEmpty( ) && OB_UtilityConstants.FULFILMENTSTATUS_DRAFT.equalsIgnoreCase( configurations.get( 0 ).NE__Order_Header__r.OB_FulfilmentStatus__c ) )
        {
            List<bit2flow__Historic_Wizard_Data__c> listOfHistoricWD = getHistoricWizards(orderHeaderId);
            if (!listOfHistoricWD.isEmpty( )  &&   !orderHeaders.get(0).OB_ExitFlow__c) //francesca.ribezzi 13/09/19 - R1F3-48 - adding OB_ExitFlow to check whether to show or not the ResumeFlow button
            {
                returnMap.put( 'showButtonFlow', 'true' );
            }
        }
        return returnMap;
    }

    /*******************************************************************************
	Purpose:  method to get historic wizard
    Parameters: Id orderHeaderId
    Returns: -

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         Elena Preteni           22/07/2019      Created         method to get historic wizard
	
 	********************************************************************************/
    @AuraEnabled
    public static List<bit2flow__Historic_Wizard_Data__c> getHistoricWizards (Id orderHeaderId){
        List<bit2flow__Historic_Wizard_Data__c> listOfHistoricWD = new List<bit2flow__Historic_Wizard_Data__c>( );
        if(!String.isEmpty(orderHeaderId)){ //francesca.ribezzi 13/09/19 - R1F3-31 if string it is not empty  
            listOfHistoricWD =
            [
                    SELECT Id,
                            Name,
                            bit2flow__Status__c,
                            bit2flow__Wizard_Id__c,
                            bit2flow__Wizard_Label__c,
                            bit2flow__Wizard_Name__c,
                            OB_OrderHeaderId__c
                    FROM bit2flow__Historic_Wizard_Data__c
                    WHERE OB_OrderHeaderId__c = :orderHeaderId
                    ORDER BY CreatedDate DESC
            ]; 
        }
        return listOfHistoricWD;

    }

    /*******************************************************************************
	Purpose:  method for the change owner for approval
    Parameters: Id orderHeaderId
    Returns: -

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         Elena Preteni           22/07/2019      Created         change owner for approval
	
 	********************************************************************************/
    @AuraEnabled
    public static void changeOwnerForApprovalProcess (Id orderHeaderId)
    {
       OB_OrderHeaderDetailsPage_CC.changeOwnerForApprovalProcess(orderHeaderId);

    }
     /*******************************************************************************
	Purpose:  Method calls method of setting Nexi and Bank Order Status from OB_Order_ChangeStatus
    Parameters: Id orderHeaderId
    Returns: -

	History
	--------
	VERSION     AUTHOR                  DATE            DETAIL          Description
	1.0         Elena Preteni           22/07/2019      Created         order_status_handleLogic
 	********************************************************************************/
    @AuraEnabled
    public static void setOrderStatusDraftIncompleteOrder( Id orderHeaderId )
    {
       OB_OrderHeaderDetailsPage_CC.setOrderStatusDraftIncompleteOrder(orderHeaderId);
    }

    @AuraEnabled
    public static void submitApprovalProcess( String orderHeaderId )
    {
        try
        {
            // NEXI-353 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 01/10/2019 START moved before avr sos callout
            System.debug( LoggingLevel.INFO, 'SubmitApprovalProcess - resubmitting : ' + orderHeaderId );

            Boolean checkAcquiring = OB_Utility.retrieveSpecialCategoryConfigurations( orderHeaderId );
            if ( checkAcquiring )
            {
                OB_Utility.submitApprovalProcess( orderHeaderId, Label.OB_ApprovalProcessAcquiring );
            }
            // NEXI-353 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 01/10/2019 STOP

            //Start Antonio.vatrano r1f3-117 27/09/2019
            List<NE__Order_Header__c> listHeader = [ SELECT Id, OB_In_Approvazione_a__c, NE__AccountId__c FROM NE__Order_Header__c WHERE Id = :orderHeaderId LIMIT 1 ];
            if ( listHeader.isEmpty( ) )
            {
                NE__Order_Header__c oHeader = listHeader.get( 0 );
                if ( OB_UtilityConstants.FASECONTROL_CONTROLS_AML.equalsIgnoreCase( oHeader.OB_In_Approvazione_a__c ) )
                {
                    OB_Util009_AVRSOS.calloutAVRSOS( oHeader.NE__AccountId__c, oHeader.Id, OB_UtilityConstants.SETUP );
                }
            }
            //End Antonio.vatrano r1f3-117 27/09/2019
        } catch ( Exception ecc )
        {
            System.debug( LoggingLevel.ERROR, '[EXCE] OB_operationActionsForSetup_CC.submitApprovalProcess ' + ecc.getMessage( ) + ' at line: ' + ecc.getLineNumber( ) + ' stack trace: ' + ecc.getStackTraceString( ) );
        }
    }
}