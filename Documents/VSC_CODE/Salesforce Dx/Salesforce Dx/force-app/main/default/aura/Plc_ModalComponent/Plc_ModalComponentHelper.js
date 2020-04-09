({
    fireEvent: function (component) {
        const evt = $A.get('e.c:Plc_CloseModalEvt');
        evt.setParams({
            'modalClosed': true
        });
        evt.fire();
    },

    redirectTo: function (component, redirectTo) {
        console.log('redirectTo --> redirectTo: ', redirectTo);    
        const navEvt = $A.get('e.force:navigateToSObject');
        navEvt.setParams({
            'recordId': redirectTo,
            'slideDevName': 'related'
        });
        navEvt.fire();
    }
})