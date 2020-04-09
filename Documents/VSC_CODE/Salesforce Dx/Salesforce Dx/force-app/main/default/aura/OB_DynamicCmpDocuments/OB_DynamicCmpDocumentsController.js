({
	delete : function(component, event, helper){
		console.log("delete ShowProductDocument")
		// var merchantId = '0019E00000pZPVBQA4';
		// var servicePointId = 'a199E000000pHf7QAE';
		// var orderItemId = 'a0w9E000002q4cjQAA';
		var merchantId = component.get("v.objectDataMap.merchant.Id");
		var servicePointId = component.get("v.objectDataMap.pv.Id");
		var configurationId =  component.get("v.objectDataMap.Configuration.Id");
		var documentIdMap = component.get("v.documentIdMap");
		//02/04/19 francesca.ribezzi adding myMap and singleDoc:
		var myMap = component.get("v.myMap");
		var singleDoc = component.get("v.singleDoc");

		//02/04/19 START francesca.ribezzi setting this singleDoc to false:
		myMap[singleDoc] = false;
		component.set("v.myMap" ,myMap);
		//02/04/19 END francesca.ribezzi
		//03/04/19 START francesca.ribezzi firing event to ShowProductDocuments2 cmp
		var dynamicDocEvent	=	$A.get("e.c:OB_DynamicDocumentsEvent");
		dynamicDocEvent.setParams({
			'myMap'		:	component.get("v.myMap")
		});
		dynamicDocEvent.fire();
		//03/04/19 END francesca.ribezzi
		console.log('documentId:'+JSON.stringify(documentIdMap));
		console.log('documentId button:'+component.get("v.Id"));
		console.log('documentId:'+documentIdMap[component.get("v.Id")]);

		var request = $A.get("e.c:OB_ContinuationRequest");
		request.setParams(
		{ 
			methodName: "filenetUpload",
			methodParams: [merchantId, servicePointId, configurationId,'','',"true",documentIdMap[component.get("v.Id")],''],
			callback: function(result)
			{
				console.log('RISULTATO: '+ result);

				documentIdMap[component.get("v.singleDoc")]='';//giovanni spinelli change key
				component.set("v.documentIdMap" ,documentIdMap);
			}
		});
		request.fire();
		component.destroy();
	},


	// callService : function(component, event , helper){
	// 	var listFields 			= component.get("v.listFields");
	// 	var configurationItem 	= listFields[0];
	// 	var servicePoint 		= listFields[1];
	// 	var merchant 			= listFields[2];

	// 	// var merchant = '0019E00000pZPVBQA4';
	// 	// var servicePoint = 'a199E000000pHf7QAE';
	// 	// var configurationItem = 'a0y9E000003WzoBQAS' ;
	// 	// var orderHeader = 'a0w9E000003BjyRQAS';
	// 	var orderHeader = component.get("v.orderHeaderId");

	// 	var docIdsMap = component.get("v.mapDocumentId");
	// 	var recordMap = component.get("v.mapRecordId");
	// 	console.log("****mapRecordId: "+ JSON.stringify(recordMap));
	// 	var singledoc= component.get("v.singleDoc");
	// 	// var recordId = recordMap[singledoc];
	// 	var recordId = 'a2D9E000000LcQkUAK';
	// 	console.log('docIdsMap[singledoc]: ' + docIdsMap[singledoc]);
	// 	// var docId = docIdsMap[singledoc]==undefined?'':docIdsMap[singledoc];
	// 	var docId = docIdsMap[singledoc];
	// 	var request = $A.get("e.c:OB_ContinuationRequest");
	// 	var isToRegenerate = docId==''?'false':'true';
	// 	request.setParams({ 
	// 		methodName: "getBase64DocID",
	// 		methodParams: [merchant,servicePoint,orderHeader,configurationItem,recordId,'false', ''],
	// 		callback: function(result)
	// 		{
	// 			console.log('****RISULTATO: '+ result);
	// 		}
	// 	});
	// 	request.fire();
	// },

})