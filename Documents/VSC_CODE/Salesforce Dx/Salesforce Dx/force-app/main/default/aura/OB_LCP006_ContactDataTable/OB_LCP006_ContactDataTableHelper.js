/**
 * Created by adrian.dlugolecki on 23.05.2019.
 */
({
    /**
     *@author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
     *@date 28/05/2019
     *@description Method is handler for component init action
     *@history 28/05/2019 Method created
               14/06/2019 NEXI-60 Joanna Mielczarek <joanna.mielczarek@accenture.com> view/edit mode control
               22/06/2019 NEXI-59 Joanna Mielczarek <joanna.mielczarek@accenture.com> added getTEFiscalCodes method
               26/06/2019 NEXI-127 Joanna Mielczarek <joanna.mielczarek@accenture.com> block removing contacts
     */
    makeInit : function ( component )
    {
        component.set( "v.isLoading", true );
        let action = component.get( "c.retrieveData" );
        action.setParam( "inAccountId", component.get( "v.accountId" ) );
        action.setCallback( this, function( response )
        {
            let state = response.getState();
            let result = response.getReturnValue();
            if ( state === "SUCCESS" )
            {
                if( !result.isError && result.dataTableRows.length > 0 )
                {
                    if ( !$A.util.isUndefinedOrNull( result.logRequest.Id ) )
                    {
                        component.set( "v.logRequestNoExists", false );
                        component.set( "v.logRequestName", result.logRequest.Name );
                    }
                    else
                    {
                        // NEXI-127 Joanna Mielczarek <joanna.mielczarek@accenture.com> 26/06/2019 START
                        let activeContacts = this.getActiveContacts( result.dataTableRows );
                        if( activeContacts <= 1 )
                        {
                            component.set( "v.isTEDeletePossible", false );
                        }
                        else
                        {
                            component.set( "v.isTEDeletePossible", true );
                        }
                        if( activeContacts >= 6 )
                        {
                            component.set( "v.isTEInsertPossible", false );
                        }
                        else
                        {
                            component.set( "v.isTEInsertPossible", true );
                        }
                        // NEXI-127 Joanna Mielczarek <joanna.mielczarek@accenture.com> 26/06/2019 STOP
                    }
                    this.fillEmptyFields( result.dataTableRows );
                    this.getTEFiscalCodes( component, result.dataTableRows ); // NEXI-59 Joanna Mielczarek <joanna.mielczarek@accenture.com> 22/06/2019
                    component.set( "v.tableData", result.dataTableRows );
                }
                else
                {
                    console.log( 'OB_LCP006_ContactDataTable : empty list' );
                }
            }
            else
            {
                console.log( 'OB_LCP006_ContactDataTable exception : connection error' );
                this.showToast( 'error', 'Exception', $A.get("$Label.c.OB_ServerLogicFailed" ) );
            }
            component.set( "v.isLoading", false );
        });
        $A.enqueueAction( action );
    },

    /**
    * @author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
    * @date 23/05/2019
    * @description Method show toast
    */
    showToast : function( type, title, message )
    {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams
        ({
            "type" : type,
            "title" : title,
            "message" : message
        });
        toastEvent.fire();
    },

    /**
    * @author Joanna Mielczarek <joanna.mielczarek@accenture.com>
    * @date 19/06/2019
    * @description Method fills empty fields with ""
    */
    fillEmptyFields: function( dataTableRows )
    {
        let fieldNames =
        [
             'FirstName',
             'LastName',
             'OB_Fiscal_Code__c',
             'OB_EndDate__c',
             'CreatedDate',
             'OB_Sex__c',
             'OB_Citizenship__c',
             'OB_Address_Country__c',
             'OB_Address_Country_Code__c',
             'OB_Address_State__c',
             'OB_Address_City__c',
             'OB_Address_Street__c',
             'OB_Address_Street_Number__c',
             'OB_Document_Release_State__c',
             'OB_Document_Release_City__c',
             'OB_Birth_State__c',
             'OB_Birth_City__c',
             'OB_Document_Type__c',
             'OB_Country_Birth__c',
             'OB_Country_Birth_Code__c',
             'OB_Birth_Date__c',
             'OB_Document_Number__c',
             'OB_Document_Release_Authority__c',
             'OB_Document_Release_Country__c',
             'OB_Document_Release_Country_Code__c',
             'OB_Document_Release_Date__c',
             'OB_Document_Expiration_Date__c'
         ];

        for( let i = 0; i < dataTableRows.length; i++ )
        {
            let oldContact = dataTableRows[i].oldContact;
            let newContact = dataTableRows[i].newContact;
            for ( let fieldName of fieldNames )
            {
                if ( $A.util.isUndefinedOrNull( oldContact[fieldName] ) )
                {
                    oldContact[fieldName] = "";
                }
                if ( $A.util.isUndefinedOrNull( newContact[fieldName] ) )
                {
                    newContact[fieldName] = "";
                }
            }
        }
    },

    /**
    * @author Joanna Mielczarek <joanna.mielczarek@accenture.com>
    * @date 22/06/2019
    * @task NEXI-59
    * @description Method puts fiscal codes to array
    * @history NEXI-127 27/06/2019 Joanna Mielczarek <joanna.mielczarek@accenture.com> added condition with OB_EndDate__c
    */
    getTEFiscalCodes : function ( component, dataTableRows )
    {
        let fiscalCodes = [];
        for( let dataRow of dataTableRows )
        {
            let loopFiscalCode = dataRow.newContact.OB_Fiscal_Code__c;
            if ( !$A.util.isEmpty( loopFiscalCode ) && $A.util.isEmpty( dataRow.newContact.OB_EndDate__c ) )
            {
                fiscalCodes.push( loopFiscalCode );
            }
        }
        component.set( "v.fiscalCodes", fiscalCodes );
    },

    /**
    * @author Joanna Mielczarek <joanna.mielczarek@accenture.com>
    * @date 26/06/2019
    * @task NEXI-127
    * @description Method checks if Contact is not to count as active
    */
    getActiveContacts : function ( dataTableRows )
    {
        let activeContacts = 0;
        for( let record of dataTableRows )
        {
            if ( $A.util.isEmpty( record.newContact.OB_EndDate__c ) )
            {
                activeContacts++;
            }
        }
        return activeContacts;
    }
})