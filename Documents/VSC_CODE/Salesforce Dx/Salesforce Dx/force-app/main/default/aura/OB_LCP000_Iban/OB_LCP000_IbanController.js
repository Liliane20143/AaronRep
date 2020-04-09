/**
 * Created by adrian.dlugolecki on 08.05.2019.
 */
({
    /**
    * @author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
    * @date 13/05/2019
    * @description Method check profile and disable or enable cab
    */
    doInit :  function(component, event, helper)
    {
        let action = component.get("c.componentInit");
        action.setCallback(this, function(response)
        {
            let state = response.getState();
            if (state === "SUCCESS")
            {
                component.set("v.disabledCab",response.getReturnValue());
            }
            else
            {
                console.log("IbanController:Code000");
                this.showToast('error','Exception',$A.get("$Label.c.OB_ServerLogicFailed"));
            }
            component.set("v.isSpinner",false);
        });
        $A.enqueueAction(action);
    },

    /**
    * @author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
    * @date 13/05/2019
    * @description Method taken from original component. Save input data and focus on next input
    */
    fieldCheck : function(component, event, helper)
    {
        var inputId 		= event.getSource().getLocalId();
        var inputValue 		= component.find(inputId).get("v.value");
        var maxLengthInput 	= component.find(inputId).get("v.maxlength");
        let nextInput;

        try
        {
            inputValue=inputValue.toUpperCase();
        }catch(err)
        {
            console.log("IbanController:Code001");
        }

        if(inputId == 'euroControlCode')
        {
            component.set("v.billingProfilePOS.OB_EuroControlCode__c",inputValue);
            nextInput = component.find("cin");
            if(maxLengthInput==inputValue.length)
            {
                nextInput.focus();
            }
        }
        else if(inputId == 'cin')
        {
            component.set("v.billingProfilePOS.OB_CINCode__c",inputValue);
            if(component.get("v.disabledCab") == true)
            {
                nextInput = component.find('bankAccountNumber');
            }
            else
            {
                nextInput = component.find('cab');
            }
            if(maxLengthInput == inputValue.length)
            {
                nextInput.focus();
            }
        }
        else if(inputId == 'bankAccountNumber')
        {
            component.set("v.billingProfilePOS.OB_Bank_Account_Number__c",inputValue);
        }
    },

    /**
    * @author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
    * @date 13/05/2019
    * @description Method taken from original component. Validate iban
    */
	completeIban : function(component,event,helper) //onblur
	{
		var inputId 				= event.getSource().getLocalId();
		var inputValue 				= component.find(inputId).get("v.value");
		var errorId 				= 'errorId' + inputId;
		var errorCustomLabel 		= '';
		var myDiv;
		var arrayIban 				= [];
		var arrayConverted 			= [];
		var countryCodeValue 		=	component.get("v.billingProfilePOS.OB_CountryCode__c");
		var euroControlCodeValue 	=	component.get("v.billingProfilePOS.OB_EuroControlCode__c");
		var cinCodeValue 			=	component.get("v.billingProfilePOS.OB_CINCode__c");
		var abiCodeValue 			=	component.get("v.billingProfilePOS.OB_ABICode__c");
		var cabCodeValue 			=	component.get("v.billingProfilePOS.OB_CABCode__c");
		var bankAccountNumberValue 	= 	component.get("v.billingProfilePOS.OB_Bank_Account_Number__c");
		var ibanComplete 			=	countryCodeValue + euroControlCodeValue + cinCodeValue + abiCodeValue + cabCodeValue + bankAccountNumberValue;

		var ibanLength = ibanComplete.length;
        component.set("v.isIbanInValid",false);
		if(inputId == 'euroControlCode')
		{
			if(countryCodeValue=="IT")
			{
				component.set("v.billingProfilePOS.OB_CountryCode__c","IT");
			}
			var typeInputValue = isNaN(inputValue);
			component.set("v.billingProfilePOS.OB_EuroControlCode__c", '');
			if(!inputValue)
			{
				console.log("control if fields value is null (onblur)");
				component.set("v.isEuroControlCodeError",true);
				component.set("v.euroControlCodeError",$A.get("$Label.c.MandatoryField"));
			}
			else if(inputValue.length > 0 && inputValue.length != 2 || typeInputValue==true)
			{
				component.set("v.isEuroControlCodeError",true);
                component.set("v.euroControlCodeError",$A.get("$Label.c.TwoDigitLength"));
			}
			else
			{
				component.set("v.billingProfilePOS.OB_EuroControlCode__c", inputValue);
				component.set("v.isEuroControlCodeError",false);
				if(ibanLength == 27)
				{
					helper.validateIban(component,inputId);
				}
			}
		}
		else if(inputId == "cin")
		{
			var typeInputValue = isNaN(inputValue);
			component.set("v.billingProfilePOS.OB_CINCode__c", '');
			if(!inputValue)
			{
				component.set("v.isCinError",true);
                component.set("v.cinError",$A.get("$Label.c.MandatoryField"));
			}
			else if(inputValue.length > 0 && inputValue.length != 1 || typeInputValue==false)
			{
				component.set("v.isCinError",true);
                component.set("v.cinError",$A.get("$Label.c.OneCharLength"));
			}
			else
			{
			    component.set("v.isCinError",false);
				component.set("v.billingProfilePOS.OB_CINCode__c", inputValue);
				if(ibanLength == 27)
				{
					helper.validateIban(component,inputId);
				}
			}
		}
		else if(inputId == "bankAccountNumber")
		{
			component.set("v.billingProfilePOS.OB_Bank_Account_Number__c", inputValue);
			var typeInputValue = false;
			if( /[^a-zA-Z0-9]/.test(inputValue))
			{
				typeInputValue = true;
			}
			if(!inputValue)
			{
				component.set("v.isBankNumberError",true);
                component.set("v.bankNumberError",$A.get("$Label.c.MandatoryField"));
			}
			else if(inputValue.length > 0 && inputValue.length != 12 || typeInputValue==true)
			{
				component.set("v.isBankNumberError",true);
                component.set("v.bankNumberError",$A.get("$Label.c.TwelveDigitLength"));
			}
			else
			{
			    component.set("v.isBankNumberError",false);
                component.set("v.billingProfilePOS.OB_Bank_Account_Number__c", inputValue);
                if(ibanLength == 27)
                {
                    helper.validateIban(component,inputId);
                }
			}
		}
	},

	saveCoBa : function (component,event,helper)
	{
	    helper.saveCoBa(component);
    }
})