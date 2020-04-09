/**
 * Created by joanna.mielczarek on 27.05.2019.
 */
({

    /**
    * @author Joanna Mielczarek
    * @date 04/06/2019
    * @description Setting list of mcc's to attribute
    * @history 04/06/2019 <joanna.mielczarek@accenture.com> created - NEXI-81
    **/
    getTabData: function ( component, mcc )
    {
        component.set( "v.changeLocation", false );
        if ( mcc.length > 0 )
        {
            component.set( "v.mcc", mcc );
            this.createMap( component, mcc )
        }
        else
        {
            component.set( "v.emptyMessage", $A.get("$Label.c.OB_NoResultMsg") );
        }
    },

    /**
    * @author Joanna Mielczarek
    * @date 29/05/2019
    * @description Reused method from modalLookupWithPagination component. Set data to display in datatable.
    * @history 29/05/2019 <joanna.mielczarek@accenture.com> created - NEXI-81
    **/
    createMap: function ( component, mcc )
    {
        this.createColumns( component );

        let currentPage = component.get( "v.currentPage" );
        let recordsToDisplay = component.get( "v.recordsToDisplay" );
        let quantityOfPages = Math.ceil( mcc.length / recordsToDisplay );
        component.set( "v.quantityOfPages", quantityOfPages );
        let mccToDisplay = {};

        for ( let i = 1; i <= quantityOfPages; i++ )
        {
            let array = [];
            if( mcc.length < recordsToDisplay )
            {
                mccToDisplay[i] = mcc;
                component.set( "v.currentList", mccToDisplay[currentPage] );
            }
            else
            {
                for( let j = 0; j < recordsToDisplay; j++ )
                {
                    array.push( mcc[j] );
                }
                component.set( "v.currentList", array );
                mcc =  mcc.slice( recordsToDisplay );
                mccToDisplay[i] = array;
                component.set( "v.tabMap", mccToDisplay );
            }
        }

        component.set( "v.spinner", false );
    },

    /**
    * @author Joanna Mielczarek
    * @date 29/05/2019
    * @description Method creates columns to datatable.
    * @history 29/05/2019 <joanna.mielczarek@accenture.com> created - NEXI-81
    **/
    createColumns: function ( component )
    {
        let level = component.get( "v.level" );
        let tabColumns;
        if ( level === "L2" )
        {
            tabColumns = [{ label : $A.get( "$Label.c.OB_MCC_DescriptionL2" ), fieldName : "Name", type : "text", sortable : true }];
        }
        else if ( level === "L3" )
        {
            tabColumns =
            [
                { label : $A.get( "$Label.c.OB_MCC_DescriptionL3" ), fieldName : "Name", type : "text", sortable : true },
                { label : $A.get("$Label.c.OB_MCC_Code" ), fieldName : "NE__Value2__c", type : "text", sortable : true }
            ];
        }
        component.set( "v.tabColumns", tabColumns );
    },

    /**
    * @author Joanna Mielczarek
    * @date 29/05/2019
    * @description Reused method from modalLookupWithPagination component. Handles changing page.
    * @history 29/05/2019 <joanna.mielczarek@accenture.com> created - NEXI-81
    **/
    changePage: function ( component, event )
    {
        let tabMap = component.get( "v.tabMap" );
        let currentPage = component.get( "v.currentPage" );
        let direction = event.getSource( ).get( "v.alternativeText" );

        if( direction === "previous" )
        {
            currentPage = currentPage - 1;
            component.set( "v.currentList", tabMap[currentPage] );
            component.set( "v.currentPage", currentPage );
        }
        else
        {
            currentPage = currentPage + 1;
            component.set( "v.currentList", tabMap[currentPage] );
            component.set( "v.currentPage", currentPage );
        }
    },

    /**
    * @author Joanna Mielczarek
    * @date 29/05/2019
    * @description Method set value of selected row to input
    * @history 29/05/2019 <joanna.mielczarek@accenture.com> created - NEXI-81
    **/
    close: function ( component )
    {
        component.set( "v.isMCCModalOpen", false );
        component.set( "v.changeLocation", true );
    },

    /**
    * @author Joanna Mielczarek
    * @date 29/05/2019
    * @description Method set value of selected row to input
    * @history 29/05/2019 <joanna.mielczarek@accenture.com> created - NEXI-81
               01/07/2019 NEXI-147 Joanna Mielczarek <joanna.mielczarek@accenture.com> set mcc code - value2 or value4
    **/
    setSelectedRow: function ( component, event )
    {
        let selectedRows = event.getParam( "selectedRows" );
        let level = component.get( "v.level" );
        if ( level === "L2" )
        {
            // NEXI-147 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 01/07/2019 START set code value if value2 is empty
            let mccL2 = !$A.util.isEmpty( selectedRows[0].NE__Value2__c ) ? selectedRows[0].NE__Value2__c : selectedRows[0].OB_Value4__c;
            component.set( "v.selectedMCCL2", mccL2 );
            // NEXI-147 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 01/07/2019 STOP
            component.set( "v.MCCL2input", selectedRows[0].Name );
            this.getLov( component, event, selectedRows[0].Id, "L3", "" );
        }
        else if ( level === "L3" )
        {
            component.set( "v.selectedMCCL3", selectedRows[0].NE__Value2__c );
            component.set( "v.MCCL3input", selectedRows[0].Name );
            component.set( "v.mccL3response", [] );
            this.getLov( component, event, selectedRows[0].NE__Lov__c, "L2", "" );

            if ( !$A.util.isEmpty( component.get( "v.MCCL2input" ) ) )
            {
                component.set( "v.isDisabled", false );
            }
        }
    },

    /**
    * @author Joanna Mielczarek
    * @date 06/06/2019
    * @description Method calls ModalLookupController.getLovs and ret
    * @history 06/06/2019 <joanna.mielczarek@accenture.com> created - NEXI-81
               08/07/2019 <joanna.mielczarek@accenture.com> modified - NEXI-171 - changed logic with code - use OB_Value4__c if is not empty
    **/
    getLov: function( component, event, lookupLov, levelToQuery, inputFromSearch )
    {
        let mccLevel = component.get( "v.level" );
        if ( mccLevel == "L2" )
        {
            if ( levelToQuery == "L2" )
            {
                this.getTabData( component, component.get( "v.mccL2" ) );
                return;
            }
        } else if ( mccLevel == "L3" )
        {
            if ( levelToQuery == "L3" )
            {
                this.getTabData( component, component.get( "v.mccL3" ) );
                return;
            }
        }

        let action = component.get( "c.getLovs" );
        action.setParams({
            level : levelToQuery,
            lookupLov : lookupLov
        });

        action.setCallback( this, function ( response ) {
           let responseLovs = response.getReturnValue( );
           if ( response.getState( ) === "SUCCESS" &&  responseLovs.length > 0 )
           {
               // NEXI-171 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 08/07/2019 START
               let value2 = responseLovs[0].NE__Value2__c;
               let value4 = responseLovs[0].OB_Value4__c;
               // NEXI-171 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 08/07/2019 STOP

               if ( mccLevel == "L2" )
               {
                   if ( responseLovs.length == 1 )
                   {
                       component.set( "v.MCCL3input", responseLovs[0].Name );
                       component.set( "v.selectedMCCL3", value2 ); // NEXI-171 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 08/07/2019
                       component.set( "v.isDisabled", false );

                   }
                   else
                   {
                       component.set( "v.MCCL3input", "" );
                       component.set( "v.mccL3response", responseLovs );
                       component.set( "v.isDisabled", true );
                   }
               }
               else if ( mccLevel == "L3" )
               {
                   component.set( "v.isDisabled", false );
                   component.set( "v.MCCL2input", responseLovs[0].Name );
                   component.set( "v.selectedMCCL2", !$A.util.isEmpty( value4 ) ? value4 : value2 ); // NEXI-171 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 08/07/2019
               }
           }
           else if ( response.getState( ) === "ERROR" )
           {
               let errors = response.getError( );
               if ( errors )
               {
                   if ( errors[0] && errors[0].message )
                   {
                       console.log( "Error message: " + errors[0].message);
                   }
                   else
                   {
                       console.log( "Unknown message" );
                   }
               }
           }
           this.close( component );
        });

        $A.enqueueAction( action );
    },

    /**
    * @author Joanna Mielczarek
    * @date 11/06/2019
    * @description Method filters records with given letters
    * @history 06/06/2019 <joanna.mielczarek@accenture.com> created - NEXI-81
               01/07/2019 NEXI-154 Joanna Mielczarek <joanna.mielczarek@accenture.com> search MCC by Name or Code
    **/
    getLovFromSearch: function ( component )
    {
        component.set( "v.emptyMessage", "" );
        let mccL3response = component.get( "v.mccL3response" );
        let mccFromSearch = $A.util.isEmpty( mccL3response ) ? component.get( "v.mcc" ) : mccL3response;

        let mccRegex = new RegExp( '^.*?' + component.get( "v.input" ) + '.*?$', 'i');
        let mccToDisplay = [];
        for ( let i = 0; i < mccFromSearch.length; i++ )
        {
            // NEXI-154 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 01/07/2019 START
            let mccName = mccFromSearch[i].Name;
            let mccCodeValue4 = mccFromSearch[i].OB_Value4__c;
            let mccCodeValue2 = mccFromSearch[i].NE__Value2__c;
            if ( mccName.match( mccRegex ) ||
                 ( !$A.util.isEmpty( mccCodeValue4 ) && mccCodeValue4.match( mccRegex ) ) ||
                 ( !$A.util.isEmpty( mccCodeValue2 ) && mccCodeValue2.match( mccRegex ) )
                )
            {
                mccToDisplay.push( mccFromSearch[i] );
            }
            // NEXI-154 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 01/07/2019 STOP
        }

        if ( mccToDisplay.length > 0 )
        {
            this.createMap( component, mccToDisplay );
        }
        else
        {
            component.set( "v.emptyMessage", $A.get("$Label.c.OB_NoResultMsg") );
        }
    }
})