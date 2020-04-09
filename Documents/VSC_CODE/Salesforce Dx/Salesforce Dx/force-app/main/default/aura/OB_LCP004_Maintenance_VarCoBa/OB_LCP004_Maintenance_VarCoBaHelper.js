/**
 * Created by adrian.dlugolecki on 07.05.2019.
 */
({
    /**
    * @author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
    * @date 13/05/2019
    * @description Method change step to previous one
    */
    backToSearch : function(component)
    {
        component.set("v.FlowStep", $A.get("$Label.c.OB_MAINTENANCE_STEP_SUMMARY"));
    },

    /**
    * @author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
    * @date 13/05/2019
    * @description Method search Rac Sia codes releted to service points
    * @history NEXI-188 Adrian Dlugolecki <adrian.dlugolecki@accenture.com> 08/07/2019 Change calback function to process wrapper
    */
    searchRacSia : function(component)
    {
        let action = component.get("c.searchForRacSia");
        action.setParams
        ({
            inServicePointId: component.get("v.modifyServicePointId")
        });
        action.setCallback(this, function(response)
        {
            let state = response.getState();
            if (state === "SUCCESS")
            {
                let result = response.getReturnValue();
                if(result.isError)
                {
                    console.log("Error in searchRacSia ",result.errorMessage);
                    this.showToast('error',$A.get("$Label.c.OB_Exception"),$A.get("$Label.c.OB_ServerLogicFailed"));
                    return;
                }
                if(!$A.util.isEmpty(result.logRequestName))
                {
                    this.showToast('error',$A.get("$Label.c.OB_Exception"),$A.get("$Label.c.OB_MAINTENANCE_LOGALREADYEXIST") + ' '+ result.logRequestName);
                    $A.get("e.force:closeQuickAction").fire();
                    component.set("v.isLogRequest",true);
                    component.set("v.logRequestName",result.logRequestName);
                    return;
                }
                if(result.racSiaCodes.length > 0)
                {
                    component.set("v.selectedRacSia",result.racSiaCodes[0]);
                }
                else
                {
                    component.set("v.isCercaEnabled",false);
                }
                component.set("v.racSiaCodes",result.racSiaCodes);
            }
            else
            {
                console.log("Error in searchRacSia");
                this.showToast('error',$A.get("$Label.c.OB_Exception"),$A.get("$Label.c.OB_ServerLogicFailed"));
            }
        });
        $A.enqueueAction(action);
    },

    /**
    * @author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
    * @date 13/05/2019
    * @description Method search for assets related to selected rac Sia codes
    * @history 02/07/2019 NEXI-157 Joanna Mielczarek <joanna.mielczarek@accenture.com> changed method name, apex method name and attributes to *asset*
    */
    searchAsset : function(component)
    {
        let action = component.get("c.getRelatedAssetsForRacSia");
        action.setParams
        ({
            inRacSiaCode: component.get("v.selectedRacSia"),
            inServicePointId: component.get("v.modifyServicePointId")
        });
        action.setCallback(this, function(response)
        {
            let state = response.getState();
            if (state === "SUCCESS")
            {
                let result = response.getReturnValue();
                this.wrapAssetData(component,result);
                component.set("v.isSearchDone",true);
                component.set("v.rawRacRelatedAssets",result);
            }
            else
            {
                console.log("Error in searchRacSia");
                this.showToast('error',$A.get("$Label.c.OB_Exception"),$A.get("$Label.c.OB_ServerLogicFailed"));
            }
        });
        $A.enqueueAction(action);
    },

    /**
    * @author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
    * @date 13/05/2019
    * @description Method wrap data from DB into table record wrapper
    * @history 02/07/2019 NEXI-157 Joanna Mielczarek <joanna.mielczarek@accenture.com> changed method name and variables names to *asset*
    */
    wrapAssetData : function(component,inAssets)
    {
        let tableWrapper = [];
        let doItOnce = true;
        let posBillingProfile = {};
        let temporaryBillingProfile = {};
        temporaryBillingProfile.OB_IBAN__c ='';
        temporaryBillingProfile.OB_ABICode__c ='';
        temporaryBillingProfile.OB_CABCode__c ='';
        temporaryBillingProfile.OB_CountryCode__c ='';
        temporaryBillingProfile.NE__Account__c ='';
        temporaryBillingProfile.OB_Bank_Account_Owner__c ='';
        for(let loopRecord of inAssets)
        {
            if(!$A.util.isUndefinedOrNull(loopRecord.NE__BillingProf__r))
            {
                temporaryBillingProfile.OB_IBAN__c =loopRecord.NE__BillingProf__r.OB_IBAN__c;
                temporaryBillingProfile.OB_ABICode__c =loopRecord.NE__BillingProf__r.OB_ABICode__c;
                temporaryBillingProfile.OB_CABCode__c =loopRecord.NE__BillingProf__r.OB_CABCode__c;
                temporaryBillingProfile.OB_CountryCode__c =loopRecord.NE__BillingProf__r.OB_CountryCode__c;
                temporaryBillingProfile.NE__Account__c =loopRecord.NE__BillingProf__r.NE__Account__c;
                temporaryBillingProfile.OB_Bank_Account_Owner__c =loopRecord.NE__BillingProf__r.OB_Bank_Account_Owner__c;
            }
            else if(!$A.util.isUndefinedOrNull(loopRecord.OB_DebitProfId__r))
            {
                temporaryBillingProfile.OB_IBAN__c =loopRecord.OB_DebitProfId__r.OB_IBAN__c;
                temporaryBillingProfile.OB_ABICode__c =loopRecord.OB_DebitProfId__r.OB_ABICode__c;
                temporaryBillingProfile.OB_CABCode__c =loopRecord.OB_DebitProfId__r.OB_CABCode__c;
                temporaryBillingProfile.OB_CountryCode__c =loopRecord.OB_DebitProfId__r.OB_CountryCode__c;
                temporaryBillingProfile.NE__Account__c =loopRecord.OB_DebitProfId__r.NE__Account__c;
                temporaryBillingProfile.OB_Bank_Account_Owner__c =loopRecord.OB_DebitProfId__r.OB_Bank_Account_Owner__c;
            }
            let formattedTableRecord = {};
            formattedTableRecord.pos = $A.util.isUndefinedOrNull(loopRecord.NE__ProdId__r)?'': loopRecord.NE__ProdId__r.Name;
            formattedTableRecord.termId = loopRecord.OB_TermId__c;
            formattedTableRecord.iban = temporaryBillingProfile.OB_IBAN__c;
            formattedTableRecord.intestata = loopRecord.Account.Name;
            formattedTableRecord.startDate = loopRecord.NE__StartDate__c;
            formattedTableRecord.status = loopRecord.NE__Status__c;
            tableWrapper.push(formattedTableRecord);
            if(doItOnce)
            {
                posBillingProfile.OB_IBAN__c = temporaryBillingProfile.OB_IBAN__c;
                posBillingProfile.OB_ABICode__c = temporaryBillingProfile.OB_ABICode__c;
                posBillingProfile.OB_CABCode__c = temporaryBillingProfile.OB_CABCode__c;
                posBillingProfile.OB_CountryCode__c = temporaryBillingProfile.OB_CountryCode__c;
                posBillingProfile.NE__Account__c = temporaryBillingProfile.NE__Account__c;
                posBillingProfile.OB_Bank_Account_Owner__c = temporaryBillingProfile.OB_Bank_Account_Owner__c;
            }
            doItOnce=false;
        }
        component.set("v.racRelatedAssets",tableWrapper);
        component.set("v.posBillingProfile",posBillingProfile);
    },

    /**
    * @author Adrian Dlugolecki <adrian.dlugolecki@accenture.com>
    * @date 16/05/2019
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
    }
})