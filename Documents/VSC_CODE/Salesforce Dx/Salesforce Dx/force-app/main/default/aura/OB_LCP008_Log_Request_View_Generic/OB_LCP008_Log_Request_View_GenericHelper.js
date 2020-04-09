({
    /**
    *@author Grzegorz Banach <grzegorz.banach@accenture.com>
    *@task NEXI-187
    *@date 10/07/2019
    *@description Method handles component initialization event
    *@history 10/07/2019 Method created
    *@returns -
    */
    doInit : function( component )
    {
        let recordId = component.get( "v.recordId" );
        let action = component.get( "c.retrieveLogRequest" );

        action.setParams({
            "logRequestId" : recordId
        });
        action.setCallback( this, function( response ) {
            let state = response.getState( );
            if ( state != "SUCCESS" )
            {
                let error = response.getError();
                if ( error == null )
                {
                    error = 'Generic Server Error';
                }
                this.showToast( component, event, $A.get( "$Label.c.OB_MAINTENANCE_TOASTERROR" ), error, "error" );
                return;
            }

            let result = JSON.parse( response.getReturnValue( ) );
            if ( result.errorOccurred )
            {
                this.showToast( component, event, $A.get( "$Label.c.OB_MAINTENANCE_TOASTERROR" ), result.errorMessage, "error" );
                return;
            }
            if ( result instanceof Array )
            {

                component.set( 'v.isCoba', result[0].isCoba );
                component.set( 'v.cobaWrapper', result );
                component.set( 'v.logRequestType', 'Modify CoBa' );//TODO: temporarily setted hardcode until Apex method won't be refactored
                return;
            }

            result.oldData = this.addMissingFieldsInCollection(component, event, result.newData, result.oldData);
            result.newData = this.addMissingFieldsInCollection(component, event, result.oldData, result.newData);

            let rebuiltObject = this.rebuildLogRequest( component, event, result );

            //NEXI-196 Marlena Lukomska-Rogala <m.lukomska-rogala@accenture.com> 26/07/2019, START Setting value of action in reducedData object
            let reducedData = rebuiltObject.reducedData;
            for ( let objectIndex=0; objectIndex < reducedData.length; objectIndex++ )
            {
                let currentObject = reducedData[objectIndex];
                currentObject.action = this.calculateAction( currentObject );
                currentObject.contactStateChange = this.checkIfContactStateChanged( currentObject );//NEXI-228 Grzegorz Banach <grzegorz.banach@accenture.com> 29/07/2019 reimplementation of NEXI-228
                // NEXI-274 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 27/08/2019 START
                for ( let codesWrapper of result.codesWrappers )
                {
                    if ( codesWrapper.recordId == currentObject.oldObjectId )
                    {
                        currentObject.companyCode = codesWrapper.companyCode;
                        currentObject.servicePointCode = codesWrapper.servicePointCode;
                        currentObject.source = codesWrapper.source;
                    }
                }
                // NEXI-274 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 27/08/2019 STOP
            }
            rebuiltObject.reducedData = reducedData;
            //NEXI-196 Marlena Lukomska-Rogala <m.lukomska-rogala@accenture.com> 26/07/2019, STOP

            component.set( 'v.logRequestWrapper', rebuiltObject );
            component.set( 'v.logRequestType', rebuiltObject.logRequestType );
        });
        $A.enqueueAction( action );
    },

    /**
    *@author Grzegorz Banach <grzegorz.banach@accenture.com>
    *@task NEXI-187
    *@date 15/07/2019
    *@description Method rebuilds Log Request Wrapper from Apex into a bit simpler version (which better suits our needs)
    *@history 15/07/2019 Method created
    *@returns Object
    */
    rebuildLogRequest : function( component, event, logRequestWrapper )
    {
        let rebuiltObject = JSON.parse( JSON.stringify( logRequestWrapper ) );
        rebuiltObject.reducedData = rebuiltObject.newData;
        delete rebuiltObject.newData;
        delete rebuiltObject.oldData;

        for ( let objectIndex = 0; objectIndex < rebuiltObject.reducedData.length; objectIndex++ )
        {
            let singleObject = rebuiltObject.reducedData[objectIndex];
            singleObject.newObjectId = singleObject.objectId;
            singleObject.oldObjectId = logRequestWrapper.oldData[objectIndex].objectId;
            singleObject.newObjectLabel = singleObject.objectLabel;
            singleObject.oldObjectLabel = logRequestWrapper.oldData[objectIndex].objectLabel;
            delete singleObject.objectId;
            for ( let fieldIndex = 0; fieldIndex < singleObject.listOfRow.length; fieldIndex++ )
            {
                let singleField = singleObject.listOfRow[fieldIndex];
                let copyOfNewData = JSON.parse( JSON.stringify( singleField ) );
                singleField.newData = copyOfNewData;
                singleField.oldData = logRequestWrapper.oldData[objectIndex].listOfRow[fieldIndex];
                delete singleField.apiname;
                delete singleField.datatype;
                delete singleField.label;
                delete singleField.value;
                delete singleField.label;
            }
        }
        return rebuiltObject;
    },

    /**
    *@author Wojciech Kucharek <wojciech.kucharek@accenture.com>
    *@date 01/07/2019
    *@description Method check if field from one collection is in second collection
    *@history 01/07/2019 Method created
    *@history 15/07/2019 grzegorz.banach@accenture.com NEXI-187 Method moved and slightly refactored
    *@returns Boolean
    */
    checkIfInCollection : function( component, event, item, collection )
    {
        let isInCollection = false;
        for( let i =0; i < collection.listOfRow.length; i++ ){
            if(collection.listOfRow[i].apiname == item.apiname){
                isInCollection = true;
                break;
            }
        }
        return isInCollection;
    },

    /**
    *@author Wojciech Kucharek <wojciech.kucharek@accenture.com>
    *@date 01/07/2019
    *@description Method add missing fields to collection if this fields are in other collection
    *@history 01/07/2019 Method created
    *@history 15/07/2019 grzegorz.banach@accenture.com NEXI-187 Method moved and slightly refactored
    *@returns updated collection of new fields
    */
    addMissingFieldsInCollection : function( component, event, fromCollection, toCollection )
    {
        for( let loopOverObject = 0; loopOverObject < fromCollection.length; loopOverObject++ )
        {
            let actualObject = fromCollection[loopOverObject];
            for ( let loopOverElements = 0; loopOverElements < actualObject.listOfRow.length; loopOverElements++ )
            {
                let actualElement = actualObject.listOfRow[loopOverElements];
                let inNewData = this.checkIfInCollection( component, event, actualElement, toCollection[loopOverObject] );
                if( !inNewData )
                {
                    toCollection[loopOverObject].listOfRow.push({
                        apiname : actualElement.apiname,
                        datatype : actualElement.datatype,
                        sequence : actualElement.sequence,
                        label : actualElement.label,
                        value : ''
                    });
                }
            }
        }

        for( let loopOverObject = 0; loopOverObject < toCollection.length; loopOverObject++)
        {
            toCollection[loopOverObject].listOfRow.sort( ( a,b ) => ( a.sequence > b.sequence ) ? 1: -1 );
        }
        return toCollection;
    },
    /**
    *@author Grzegorz Banach <grzegorz.banach@accenture.com>
    *@task NEXI-187
    *@date 10/07/2019
    *@description Method calculates action basing on object data ( of log request wrapper )
    *@history 10/07/2019 Method created
    *@returns String - Action
    */
    calculateAction : function( objectToCalculate )
    {
        let oldId = objectToCalculate.oldObjectId;
        let newId = objectToCalculate.newObjectId;
        if ( ( $A.util.isUndefinedOrNull( oldId ) || $A.util.isEmpty( oldId ) )
            && ( $A.util.isUndefinedOrNull( newId ) || $A.util.isEmpty( newId ) ) )
        {
           return 'Add';
        }

        if ( !( $A.util.isUndefinedOrNull( oldId ) || $A.util.isEmpty( oldId ) )
            && ( $A.util.isUndefinedOrNull( newId ) || $A.util.isEmpty( newId ) ) )
        {
           return 'Remove';
        }

        let listOfFields = objectToCalculate.listOfRow;
        for( let fieldIndex=0; fieldIndex < listOfFields.length; fieldIndex++ )
        {
           if( listOfFields[fieldIndex].oldData.value != listOfFields[fieldIndex].newData.value && listOfFields[fieldIndex].oldData.apiname != 'Description' )
           {
               return 'Change';
           }
        }
        return 'None';
    },

    /**
    *@author Grzegorz Banach <grzegorz.banach@accenture.com>
    *@task NEXI-187
    *@date 10/07/2019
    *@description Method fires standard toast event
    *@history 10/07/2019 Method created
    *@returns -
    */
    showToast : function( component, event, title, message, type ) {
        let toastEvent = $A.get( "e.force:showToast" );
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire( );
    },

    /**
    *@author Grzegorz Banach <grzegorz.banach@accenture.com>
    *@task NEXI-228
    *@date 29/07/2019
    *@description Method checks if Contact State has been changed to "Inactive"
    *@history 29/07/2019 Method created
    *@returns Boolean - True if contact state has been changed
    */
    checkIfContactStateChanged : function( reducedData ) {
        if ( $A.util.isEmpty( reducedData ) && $A.util.isEmpty( reducedData.listOfRow ) )
        {
            return false;
        }
        if ( reducedData.listOfRow.length === 1
            && reducedData.listOfRow[0].newData.apiname === 'OB_Contact_State__c'
            && reducedData.listOfRow[0].newData.value === 'Inactive' )
        {
            return true;
        }
        return false;
    },
})