({
    //giovanni spinelli 03/04/2019 save contracts informations in a map to pass in parent component 
    getBase64SingleContract : function(component) {
        
        var listFields 			= component.get("v.listFields");
		var configurationId 	= listFields[0];
		var servicePoint 		= listFields[1];
        var merchantId			= listFields[2];
        var docId =  component.get("v.docId");
        
        var action = component.get("c.getFileName");
        action.setParams({
            'merchantId' :  merchantId,
            'salespointsId' : servicePoint,
            'configurationIdOrLogRequest' : configurationId,
            'docId' : docId,
            'isLogRequest' : false
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                //_utils.info(response.getReturnValue());
                var res = response.getReturnValue();
                var filename = res['FILENAME'];
                var idDoc = res['DOCID'];
                var b64 = res['BASE64'];
                var mapValueContracts = component.get('v.mapValueContracts');
                var innerMap = {};
                innerMap['filename'] 	= filename;
                innerMap['b64'] 		= b64;
                mapValueContracts[idDoc] 	= innerMap;
                component.set('v.mapValueContracts',mapValueContracts);
                //console.log('MAP BASE 64 SINGLE: '+ JSON.stringify(component.get('v.mapValueContracts')));
                
            }else{
                console.log();
            }
        });
        $A.enqueueAction(action);
}
})