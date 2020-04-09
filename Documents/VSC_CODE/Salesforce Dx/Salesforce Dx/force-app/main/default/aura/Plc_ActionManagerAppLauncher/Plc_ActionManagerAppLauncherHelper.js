({
    initialize: function (component) {
        var objURL = this.getParamsFromURL(component);
        var helper = this;

        console.log(`objURL >> ` + JSON.stringify(objURL));

        this.call_compatibilityCheck(component, objURL).then(
            $A.getCallback(function (responseCompatibilityCheck) {
                console.log('initialize --> responseCompatibilityCheck : ', JSON.stringify(responseCompatibilityCheck));
                component.set('v.showSpinner', false);
                
                if (responseCompatibilityCheck) {
                    //FB 20191029 NEXIPLC-745 [START]
                    if (!responseCompatibilityCheck.error) {
                    //FB 20191029 NEXIPLC-745 [END]
                        if (responseCompatibilityCheck.result === $A.get('$Label.c.Plc_ActionManagerSuccessMessage')) {
                            if (responseCompatibilityCheck.componentName) {
                                if (responseCompatibilityCheck.additionalParameters) {
                                    helper.openComponent(component, responseCompatibilityCheck.componentName, responseCompatibilityCheck.objId, responseCompatibilityCheck.additionalParameters, objURL.navigationServiceEnabled);
                                } else {
                                    helper.openComponent(component, responseCompatibilityCheck.componentName, responseCompatibilityCheck.objId, null, objURL.navigationServiceEnabled);
                                }
                            } else {
                                helper.showModal(component, 'success', 'Operation succeeded.', objURL.objId);
                            }
                        } else {
                            helper.showModal(component, 'error', responseCompatibilityCheck.result, objURL.objId);
                        }
                    //FB 20191029 NEXIPLC-745 [START]
                    } else {
                        helper.showModal(component, 'error', responseCompatibilityCheck.errorMessage, objURL.objId);
                    }
                    //FB 20191029 NEXIPLC-745 [END]
                } else {
                    helper.showModal(component, 'error', 'An error has occurred.', objURL.objId);
                }
            }),
            //FB 22-10-2019: NEXIPLC-745 [START]
            $A.getCallback(function (errorMessage) {
                console.log(errorMessage);
                component.set('v.showSpinner', false);
                helper.showModal(component, 'error', 'Error: ' + errorMessage, objURL.objId);
            })
            //FB 22-10-2019: NEXIPLC-745 [END]
        );
    },

    getParamsFromURL: function (component) {
        var myPageRef = component.get('v.pageReference');
        var objURL = {};

        objURL.objId = myPageRef.state.c__objectId;
        objURL.actionType = myPageRef.state.c__actionType;
        objURL.additionalParameters = myPageRef.state.c__additionalParameters;
        objURL.navigationServiceEnabled = !!myPageRef.state.navigationServiceEnabled;
        console.log('@@@@@log: objURL.navigationServiceEnabled: ' + objURL.navigationServiceEnabled);

        return objURL;
    },

    call_compatibilityCheck: function (component, objURL) {
        return new Promise($A.getCallback(function (resolve, reject) {
            var call_compatibilityCheck = component.get('c.compatibilityCheck');

            console.log(`objURL >> ` + JSON.stringify(objURL));
            call_compatibilityCheck.setParams({
                'parameters': JSON.stringify(objURL)
            });

            call_compatibilityCheck.setCallback(this, function (response) {
                if (component.isValid() && response.getState() === 'SUCCESS') {
                    console.log('call_compatibilityCheck --> response ' + JSON.stringify(response.getReturnValue()));
                    resolve(response.getReturnValue());

                } else if (component.isValid() && (response.getState() === 'INCOMPLETE' || response.getState() === 'ERROR')) {
                    console.log('objURL --> An error has occurred: ', response.getError()[0].message);
                    //FB 22-10-2019: NEXIPLC-745 [START]
                    reject(response.getError()[0].message);
                     //FB 22-10-2019: NEXIPLC-745 [END]
                }
            });
            $A.enqueueAction(call_compatibilityCheck);
        }));

    },

    showModal: function (component, type, message, redirectTo) {
        component.set('v.type', type);
        component.set('v.message', message);
        component.set('v.redirectTo', redirectTo);
        component.set('v.showModal', true);
    },

    openComponent: function (component, componentName, objectId, additionalParameters, navServiceEnabled) {
        console.log(`openComponent --> componentName : ${componentName}, objectId : ${objectId}, additionalParameters : ${additionalParameters}, navServiceEnabled : ${navServiceEnabled}`);
        if (componentName) {

            if (navServiceEnabled) {
                console.log('@@@@@statingWith: navService');
                console.log('@@@@@ navService', JSON.stringify(component.find('navService')));

                if (!$A.util.isEmpty(objectId) && !$A.util.isEmpty(additionalParameters)) {
                    component.find('navService').navigate({
                        type: 'standard__component',
                        attributes: {
                            componentName: 'c__' + componentName
                        },
                        state: {
                            'objectId': objectId,
                            'additionalParameters': additionalParameters
                        }
                    });
                } else if ($A.util.isEmpty(objectId) && !$A.util.isEmpty(additionalParameters)) {

                    component.find('navService').navigate({
                        type: 'standard__component',
                        attributes: {
                            componentName: 'c__' + componentName
                        },
                        state: {
                            'additionalParameters': additionalParameters
                        }
                    });
                } else if (!$A.util.isEmpty(objectId) && $A.util.isEmpty(additionalParameters)) {

                    component.find('navService').navigate({
                        type: 'standard__component',
                        attributes: {
                            componentName: 'c__' + componentName
                        },
                        state: {
                            'objectId': objectId
                        }
                    });
                } else {
                    component.find('navService').navigate({
                        type: 'standard__component',
                        attributes: {
                            componentName: 'c__' + componentName
                        }
                    });
                }

            } else {
                console.log('@@@@@statingWith: js window.location');
                var url = '/lightning/cmp/c__' + componentName;
                url += objectId ? '?c__objectId=' + objectId : '';
                url += objectId ? '&' : '?';
                url += additionalParameters ? 'c__additionalParameter=' + additionalParameters : '';

                window.location = url;

            }
        } else {
            this.showModal(component, 'error', 'Param componentName not found.', objectId);
        }
    }
})