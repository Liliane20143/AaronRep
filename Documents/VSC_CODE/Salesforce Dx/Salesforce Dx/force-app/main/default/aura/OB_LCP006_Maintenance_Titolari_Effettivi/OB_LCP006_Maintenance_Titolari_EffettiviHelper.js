/**
 * Created by adrian.dlugolecki on 14.06.2019.
 */
({

    /**
     *@author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
     *@date 21/06/2019
     *@description Method handles init
     */
    initHandler : function (component)
    {
        let initAction = component.get("c.initComponent");
        initAction.setCallback(this, function(response)
        {
            let state = response.getState();
            if (state === "SUCCESS")
            {
                let  resultWrapper = response.getReturnValue();
                component.set( "v.genderList",  this.convertObjectToMap(resultWrapper.genders));
                component.set( "v.contactFieldsLabel",resultWrapper.contactFieldsLabel);
            }
            else
            {
                let errors = response.getError();
                if (errors)
                {
                    if (errors[0] && errors[0].message)
                    {
                        console.log("Error message: " + errors[0].message);
                    }
                }
                else
                {
                    console.log("Unknown error");
                }
                this.showToast( 'error', 'Exception', $A.get("$Label.c.OB_ServerLogicFailed" ) );
            }
            component.set("v.isLoaded", true );
        });
        $A.enqueueAction(initAction);
    },

    /**
    * @author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
    * @date 23/05/2019
    * @description Method shows toast
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
     *@author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
     *@date 21/06/2019
     *@description Method converts Object to Map
     */
    convertObjectToMap : function(inObject)
    {
        let result = [];
        for (let property in inObject)
        {
            if (inObject.hasOwnProperty(property))
            {
                let container = {};
                container.key = property;
                container.value = inObject[property]
                result.push(container);
            }
        }
        return result;
    },

    /**
     *@author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
     *@date 21/06/2019
     *@description Method calls .saveRequest method
                   22/06/2019 NEXI-59 Joanna Mielczarek <joanna.mielczarek@accenture.com> checking fiscal code
     */
	saveLogic : function( component )
	{
		try
		{
		    // NEXI-59 Joanna Mielczarek <joanna.mielczarek@accenture.com> 22/06/2019 START
		    if ( this.checkFiscalCode( component ) )
		    {
		        return;
            }
		    // NEXI-59 Joanna Mielczarek <joanna.mielczarek@accenture.com> 22/06/2019 STOP

			let action = component.get('c.saveRequest');
			this.updateDataOnNewContact(component);
			action.setParams
			({
				"inOldContact" : component.get("v.oldContact"),
				"inNewContact" : component.get("v.newContact")
			});
			action.setCallback(this, $A.getCallback(function (response)
			{
				let state = response.getState();
				if (state === "SUCCESS")
				{
					let result = response.getReturnValue();
					if( result.isError )
					{
                        this.showToast($A.get("$Label.c.OB_MAINTENANCE_ERROR") , result.errorMessage, 'error');
                        console.log( 'Exception in OB_LCP006_Maintenance_Titolari_EffettiviHelper.saveLogic '+result.hiddenErrorMessage);
					}
					else
					{
                        this.showToast( $A.get("$Label.c.OB_MAINTENANCE_TOAST_OPERATIONSUCCESSFULL"), $A.get("$Label.c.OB_MAINTENANCE_LOGSAVED"), 'Success');
                        this.fireContactEvent(component);
                        component.set('v.showModal', false);
					}
				}
				else
				{
					let errors = response.getError();
					this.showToast( $A.get("$Label.c.OB_MAINTENANCE_ERROR") , errors, 'error');
				}
			}));
			$A.enqueueAction(action);
		}
		catch(err)
		{
			console.log(err);
		}
	},

    /**
     *@author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
     *@date 21/06/2019
     *@description Method handle event with sending correct data due to action
     */
	fireContactEvent: function(component)
    {
        let isNewContact = component.get("v.isNewContact");
        let logRequestType = "Modificato";
        if ( isNewContact )
        {
            logRequestType = "Inserito";
        }
        let contactEvent = component.getEvent("teContactEvent");
        let serializedNewContact = JSON.stringify(component.get("v.newContact"));
        contactEvent.setParams({
            "inContactJson" : serializedNewContact,
            "logRequestType" : logRequestType
        });
        contactEvent.fire();
    },

    /**
     *@author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
     *@date 21/06/2019
     *@description Method updates data on new TE
     */
	updateDataOnNewContact : function(component)
	{
	    let newContact = component.get("v.newContact");
        let titolariEffettivi = component.get("v.objectDataMap.titolariEffettivoContact");
        newContact.OB_Address_State__c = titolariEffettivi.OB_Address_State__c;
        newContact.OB_Address_City__c = titolariEffettivi.OB_Address_City__c;
        newContact.OB_Address_Hamlet__c = titolariEffettivi.OB_Address_Hamlet__c;
        newContact.OB_Address_Street__c = titolariEffettivi.OB_Address_Street__c;
        newContact.OB_Address_Street_Number__c = titolariEffettivi.OB_Address_Street_Number__c;
        newContact.OB_Address_PostalCode__c = titolariEffettivi.OB_Address_PostalCode__c;
        newContact.OB_Address_Country__c = titolariEffettivi.OB_Address_Country__c;
        newContact.OB_Address_Country_Code__c = titolariEffettivi.OB_Address_Country_Code__c;
        newContact.OB_Address_State_Code__c = titolariEffettivi.OB_Address_State_Code__c;
        newContact.OB_Document_Release_State__c = titolariEffettivi.OB_Document_Release_State__c;
        newContact.OB_Document_Release_City__c = titolariEffettivi.OB_Document_Release_City__c;
        newContact.OB_Document_Release_Country__c = titolariEffettivi.OB_Document_Release_Country__c;
        newContact.OB_Document_Release_Country_Code__c = titolariEffettivi.OB_Document_Release_Country_Code__c;
        newContact.OB_Document_Release_State_Code__c = titolariEffettivi.OB_Document_Release_State_Code__c;
        newContact.OB_Birth_State__c = titolariEffettivi.OB_Birth_State__c;
        newContact.OB_Birth_City__c = titolariEffettivi.OB_Birth_City__c;
        newContact.OB_Country_Birth__c = titolariEffettivi.OB_Country_Birth__c;
        newContact.OB_Country_Birth_Code__c = titolariEffettivi.OB_Country_Birth_Code__c;
        newContact.OB_Birth_State_Code__c = titolariEffettivi.OB_Birth_State_Code__c;
        newContact.OB_Citizenship__c = titolariEffettivi.OB_Citizenship__c;
    },

    /**
     *@author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
     *@date 21/06/2019
     *@description Method showing toast
     */
	showToast: function (title, message, type)
	{
		let toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			"title": title,
			"message": message,
			"type": type
		});
		toastEvent.fire();
	},

    /**
     *@author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
     *@date 21/06/2019
     *@description Method sets params for Contact Address postel
     */
	setAddressMappingContactAddress : function()
	{
		let postelComponentParamsContactAddress = {};
		postelComponentParamsContactAddress.sectionaddress          = 'generaladdress';
		postelComponentParamsContactAddress.sectionName          	= 'legaleRappresentante';
		postelComponentParamsContactAddress.provincedisabled        = 'false';
		postelComponentParamsContactAddress.provinceinputobject     = 'titolariEffettivoContact';
		postelComponentParamsContactAddress.provinceinputfield      = 'OB_Address_State__c';
		postelComponentParamsContactAddress.citydisabled            = 'true';
		postelComponentParamsContactAddress.cityinputobject         = 'titolariEffettivoContact';
		postelComponentParamsContactAddress.cityinputfield          = 'OB_Address_City__c';
		postelComponentParamsContactAddress.districtdisabled        = 'true';
		postelComponentParamsContactAddress.districtinputobject     = 'titolariEffettivoContact';
		postelComponentParamsContactAddress.districtinputfield      = 'OB_Address_Hamlet__c';
		postelComponentParamsContactAddress.streetdisabled          = 'true';
		postelComponentParamsContactAddress.streetinputobject       = 'titolariEffettivoContact';
		postelComponentParamsContactAddress.streetinputfield        = 'OB_Address_Street__c';
		postelComponentParamsContactAddress.streetnumberdisabled    = 'true';
		postelComponentParamsContactAddress.streetnumberinputobject = 'titolariEffettivoContact';
		postelComponentParamsContactAddress.streetnumberinputfield  = 'OB_Address_Street_Number__c';
		postelComponentParamsContactAddress.zipcodedisabled         = 'false';
		postelComponentParamsContactAddress.zipcodeinputobject      = 'titolariEffettivoContact';
		postelComponentParamsContactAddress.zipcodeinputfield       = 'OB_Address_PostalCode__c';
		postelComponentParamsContactAddress.countrydisabled         = 'false';
		postelComponentParamsContactAddress.countryinputobject      = 'titolariEffettivoContact';
		postelComponentParamsContactAddress.countryinputfield       = 'OB_Address_Country__c';
		postelComponentParamsContactAddress.countrycodeinputobject  = 'titolariEffettivoContact';
		postelComponentParamsContactAddress.countrycodeinputfield   = 'OB_Address_Country_Code__c';
		postelComponentParamsContactAddress.provincecodeinputobject = 'titolariEffettivoContact';
		postelComponentParamsContactAddress.provincecodeinputfield  = 'OB_Address_State_Code__c';
		postelComponentParamsContactAddress.isComplete              = 'true';
		postelComponentParamsContactAddress.withCountry             = 'true';
		postelComponentParamsContactAddress.withDetail              = 'false';
		return postelComponentParamsContactAddress;
	},

    /**
     *@author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
     *@date 21/06/2019
     *@description Method sets params for Document Release Address postel
     */
	setAddressMappingDocReleaseAddress : function()
	{
		let postelComponentParamsAddress = {};
		postelComponentParamsAddress.sectionaddress          = 'documentrelease';
		postelComponentParamsAddress.sectionName             = 'legaleRappDoc';
		postelComponentParamsAddress.provincedisabled        = 'false';
		postelComponentParamsAddress.provinceinputobject     = 'titolariEffettivoContact';
		postelComponentParamsAddress.provinceinputfield      = 'OB_Document_Release_State__c';
		postelComponentParamsAddress.citydisabled            = 'true';
		postelComponentParamsAddress.cityinputobject         = 'titolariEffettivoContact';
		postelComponentParamsAddress.cityinputfield          = 'OB_Document_Release_City__c';
		postelComponentParamsAddress.countrydisabled         = 'false';
		postelComponentParamsAddress.countryinputobject      = 'titolariEffettivoContact';
		postelComponentParamsAddress.countryinputfield       = 'OB_Document_Release_Country__c';
		postelComponentParamsAddress.countrycodeinputobject  = 'titolariEffettivoContact';
		postelComponentParamsAddress.countrycodeinputfield   = 'OB_Document_Release_Country_Code__c';
		postelComponentParamsAddress.provincecodeinputobject = 'titolariEffettivoContact';
		postelComponentParamsAddress.provincecodeinputfield  = 'OB_Document_Release_State_Code__c';
		postelComponentParamsAddress.isComplete              = 'false';
		postelComponentParamsAddress.withCountry             = 'true';
        return postelComponentParamsAddress;
	},

    /**
     *@author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
     *@date 21/06/2019
     *@description Method sets params for Birth Address postel
     */
	setAddressMappingBirthAddress : function()
	{
		let postelComponentParamsBirthAddress = {};
		postelComponentParamsBirthAddress.sectionaddress          = 'birthaddress';
		postelComponentParamsBirthAddress.sectionName             = 'legaleRappBirth';
		postelComponentParamsBirthAddress.provincedisabled        = 'false';
		postelComponentParamsBirthAddress.provinceinputobject     = 'titolariEffettivoContact';
		postelComponentParamsBirthAddress.provinceinputfield      = 'OB_Birth_State__c';
		postelComponentParamsBirthAddress.citydisabled            = 'true';
		postelComponentParamsBirthAddress.cityinputobject         = 'titolariEffettivoContact';
		postelComponentParamsBirthAddress.cityinputfield          = 'OB_Birth_City__c';
		postelComponentParamsBirthAddress.countrydisabled         = 'false';
		postelComponentParamsBirthAddress.countryinputobject      = 'titolariEffettivoContact';
		postelComponentParamsBirthAddress.countryinputfield       = 'OB_Country_Birth__c';
		postelComponentParamsBirthAddress.countrycodeinputobject  = 'titolariEffettivoContact';
		postelComponentParamsBirthAddress.countrycodeinputfield   = 'OB_Country_Birth_Code__c';
		postelComponentParamsBirthAddress.provincecodeinputobject = 'titolariEffettivoContact';
		postelComponentParamsBirthAddress.provincecodeinputfield  = 'OB_Birth_State_Code__c';
		postelComponentParamsBirthAddress.isComplete              = 'false';
		postelComponentParamsBirthAddress.withCountry             = 'true';
		return postelComponentParamsBirthAddress
	},

    /**
     *@author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
     *@date 21/06/2019
     *@description Method sets params for Citizenship postel
     */
	setAddressMappingCitizenship : function()
	{
		let postelComponentParamsCitizenship = {};
		postelComponentParamsCitizenship.objectDataNode        = 'titolariEffettivoContact';
		postelComponentParamsCitizenship.objectDataField       = 'OB_Citizenship__c';
		postelComponentParamsCitizenship.lovType			   = 'COUNTRY';
		postelComponentParamsCitizenship.lovOrderBy     	   = 'Name';
		postelComponentParamsCitizenship.lovSourceField        = 'OB_Citizenship__c||Name';
		postelComponentParamsCitizenship.inputFieldId 		   = 'CittadinanzaLegaleRapp';
		postelComponentParamsCitizenship.fieldInputLabel  	   = 'OB_Citizenship';
		postelComponentParamsCitizenship.mapLabelColumns       = 'NE__Value1__c||Codice Paese,Name||Nazione';
        return postelComponentParamsCitizenship;
	},

    /**
     *@author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
     *@date 21/06/2019
     *@description Method sets params for Fiscal Code postel
     */
	setAddressMappingFiscalCode : function()
	{
		let postelComponentParamsFiscalCode = {};
		postelComponentParamsFiscalCode.objectDataNode        = 'titolariEffettivoContact';
		postelComponentParamsFiscalCode.objectDataField       = 'OB_Fiscal_Code__c';
		postelComponentParamsFiscalCode.auraId 			      = 'fiscalCodelegaleRapp';
		postelComponentParamsFiscalCode.label				  = 'OBFiscalCodeContact';
		postelComponentParamsFiscalCode.isRequired			  = 'true';
        return postelComponentParamsFiscalCode;
	},

    /**
    * @author Joanna Mielczarek <joanna.mielczarek@accenture.com>
    * @date 22/06/2019
    * @task NEXI-59
    * @description Method checks if saving contact doesn't have the same fiscal code as another contact
    */
	checkFiscalCode : function( component )
	{
	    if ( !component.get( "v.isNewContact") )
	    {
	        return false;
        }

        let newContactFiscalCode = component.get( "v.newContact" ).OB_Fiscal_Code__c;
        let oldFiscalCodes = component.get( "v.fiscalCodes" );
        for( let fiscalCode of oldFiscalCodes )
        {
            if ( fiscalCode.localeCompare( newContactFiscalCode, undefined, { sensitivity: 'base' }) === 0 )
            {
                component.set( "v.hasTheSameFiscalCode", true );
                return true;
            }
        }
        return false;
    }
})