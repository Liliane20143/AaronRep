/**
 * Created by adrian.dlugolecki on 08.05.2019.
 */
({
    /**
    * @author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
    * @date 13/05/2019
    * @description Method taken from original component. Validate iban logic
    */
    validateIban : function(component,inputId)
    {
        var arrayIban 				= [];
        var arrayConverted 			= [];
        var countryCodeValue 		= component.get("v.billingProfilePOS.OB_CountryCode__c");
        var euroControlCodeValue 	= component.get("v.billingProfilePOS.OB_EuroControlCode__c");
        var cinCodeValue 			= component.get("v.billingProfilePOS.OB_CINCode__c");
        var abiCodeValue 			= component.get("v.billingProfilePOS.OB_ABICode__c");
        var cabCodeValue 			= component.get("v.billingProfilePOS.OB_CABCode__c");
        var bankAccountNumberValue 	= component.get("v.billingProfilePOS.OB_Bank_Account_Number__c");
        var ibanComplete 			= countryCodeValue 	+ euroControlCodeValue 	+ cinCodeValue + abiCodeValue 			+ cabCodeValue 		+ bankAccountNumberValue;
        var ibanToConverte 			= cinCodeValue		+ abiCodeValue			+ cabCodeValue + bankAccountNumberValue	+ countryCodeValue 	+ euroControlCodeValue;
        var ibanLength 				= ibanComplete.length;
        arrayIban.push(ibanToConverte);
        var element;
        for (var i = 0; i < arrayIban.length; i++)
        {
            arrayIban[i] = arrayIban[i].replace(/A/g,"10");
            arrayIban[i] = arrayIban[i].replace(/B/g,"11");
            arrayIban[i] = arrayIban[i].replace(/C/g,"12");
            arrayIban[i] = arrayIban[i].replace(/D/g,"13");
            arrayIban[i] = arrayIban[i].replace(/E/g,"14");
            arrayIban[i] = arrayIban[i].replace(/F/g,"15");
            arrayIban[i] = arrayIban[i].replace(/G/g,"16");
            arrayIban[i] = arrayIban[i].replace(/H/g,"17");
            arrayIban[i] = arrayIban[i].replace(/I/g,"18");
            arrayIban[i] = arrayIban[i].replace(/J/g,"19");
            arrayIban[i] = arrayIban[i].replace(/K/g,"20");
            arrayIban[i] = arrayIban[i].replace(/L/g,"21");
            arrayIban[i] = arrayIban[i].replace(/M/g,"22");
            arrayIban[i] = arrayIban[i].replace(/N/g,"23");
            arrayIban[i] = arrayIban[i].replace(/O/g,"24");
            arrayIban[i] = arrayIban[i].replace(/P/g,"25");
            arrayIban[i] = arrayIban[i].replace(/Q/g,"26");
            arrayIban[i] = arrayIban[i].replace(/R/g,"27");
            arrayIban[i] = arrayIban[i].replace(/S/g,"28");
            arrayIban[i] = arrayIban[i].replace(/T/g,"29");
            arrayIban[i] = arrayIban[i].replace(/U/g,"30");
            arrayIban[i] = arrayIban[i].replace(/V/g,"31");
            arrayIban[i] = arrayIban[i].replace(/W/g,"32");
            arrayIban[i] = arrayIban[i].replace(/X/g,"33");
            arrayIban[i] = arrayIban[i].replace(/Y/g,"34");
            arrayIban[i] = arrayIban[i].replace(/Z/g,"35");

            arrayConverted.push(arrayIban[i]);
        }
        var ibanToValidate='';
        for (var i = 0; i < arrayConverted.length; i++)
        {
            ibanToValidate += arrayConverted[i];
        }

        var reminder 			= this.longIntegerReminder(ibanToValidate,'97');
        var ibanError 			= document.getElementById("iban");
        var eccError 			= document.getElementById("euroControlCode");
        var cinError 			= document.getElementById("cin");
        var banError 			= document.getElementById("bankAccountNumber");
        if(reminder == "1")
        {
            //remove eventual errors
            component.set("v.isEuroControlCodeError",false);
            component.set("v.isCinError",false);
            component.set("v.isBankNumberError",false);
            component.set("v.isSaveDisabled",false);
            component.set("v.isIbanInValid",false);
        }
        else
        {
            //show error
            component.set("v.isSaveDisabled",true);
            component.set("v.isIbanInValid",true);
        }
        component.set("v.billingProfilePOS.OB_IBAN__c", ibanComplete);
    },

    /**
    * @author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
    * @date 13/05/2019
    * @description Method taken from original component. Submethod for iban validation
    */
    longIntegerReminder: function(x,y)
    {
        var firstDigit;
        var lastDigit;

        if(this.lessThan(x,y))
        {
            return parseInt(x);
        }

        if(this.equal(x,y)) return 0;

        for(var i = 1;i <= x.length;i++)
        {
            firstDigit = x.substring(0,i);
            lastDigit = x.substring(i,x.length);

            if(this.greaterThan(firstDigit,y)|| this.equal(firstDigit,y))
            {
                console.log('break');
                break;
            }
        }

        var reminder = parseInt(firstDigit) % parseInt(y);
        var newNumb = reminder.toString() + lastDigit.toString();

        return parseInt(this.longIntegerReminder(newNumb.toString(),y));
    },

    /**
    * @author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
    * @date 13/05/2019
    * @description Method taken from original component. Submethod for iban validation
    */
    lessThan: function(x,y)
    {
        if (x.length>y.length)
        {
            y= this.padS(y,x.length);
        }
        if (x.length<y.length)
        {
            x= this.padS(x,y.length);
        }

        return (x < y);
    },

    /**
    * @author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
    * @date 13/05/2019
    * @description Method taken from original component. Submethod for iban validation
    */
    greaterThan: function(x,y)
    {
        if (x.length > y.length)
        {
            y= this.padS(y,x.length);
        }
        if (x.length < y.length)
        {
            x= this.padS(x,y.length);
        }
        return (x > y);
    },

    /**
    * @author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
    * @date 13/05/2019
    * @description Method taken from original component. Submethod for iban validation
    */
    padS: function(s,size)
    {
        while (s.length < (size || 1)) {s = "0" + s;}
        return s;
    },

    /**
    * @author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
    * @date 13/05/2019
    * @description Method taken from original component. Submethod for iban validation
    */
    equal: function(x,y)
    {
        return (!(this.greaterThan(x,y) || this.lessThan(x,y)));
    },

    /**
    * @author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
    * @date 13/05/2019
    * @description Method show toast
    */
    showToast : function(type,title,message)
    {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams
        ({
            "type":type,
            "title": title,
            "message": message
        });
        toastEvent.fire();
    },

    /**
    * @author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
    * @date 13/05/2019
    * @description Method save billing profile update assets with new billing profile and make integration
    * @history 02/07/2019 NEXI-157 Joanna Mielczarek <joanna.mielczarek@accenture.com> changed params in apex call
    */
    saveCoBa : function(component)
    {
        component.set("v.isSpinner",true);
        var action = component.get("c.saveCoBaAndIntegrate");
        action.setParams
        ({
            inBillingProfile: component.get("v.billingProfilePOS"),
            inAssetsToUpdate: component.get("v.affectedAssets") // NEXI-157 Joanna Mielczarek <joanna.mielczarek@accenture.com>, 02/07/2019
        });
        action.setCallback(this, function(response)
        {
            var state = response.getState();
            if (state === "SUCCESS")
            {
                let resultWrapper = response.getReturnValue();
                if(resultWrapper.result == true)
                {
                    let navEvt = $A.get("e.force:navigateToSObject");
                    if(!$A.util.isEmpty(navEvt))
                    {
                        navEvt.setParams({
                          "recordId": resultWrapper.redirectToObject.Id
                        });
                        navEvt.fire();
                    }
                }
                else
                {
                    this.showToast('error','Exception',resultWrapper.errorMessage);
                }
            }
            else
            {
                console.log("IbanHelper:Code000");
                this.showToast('error','Exception','Unexpected exception try again or contact salesforce administrator');
            }
            component.set("v.isSpinner",false);
        });
        $A.enqueueAction(action);
    }
})