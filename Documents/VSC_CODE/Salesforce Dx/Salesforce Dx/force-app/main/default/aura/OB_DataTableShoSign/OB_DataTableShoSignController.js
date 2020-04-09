({
	doInit : function(component, event, helper) {
		
		component.set("v.columnsShopSign" , [{label: $A.get("$Label.c.OB_ShopSign"),  fieldName: 'OB_ShopSign__c',         type: 'text'}]);
		var shopSignList2 = component.get('v.shopSignList2');
		var shopSignList = component.get('v.shopSignList');
		console.log('shopSignList do init: '+ shopSignList);
		component.set( "v.showDataTable", true);
		shopSignList2 = shopSignList;
	},
	getSelectedShopSign: function(component, event, helper) {
		var selectedRows = event.getParam('selectedRows');
		var objectDataMap = component.get("v.objectDataMap");
		var selectServicePointArray = [];
		var valueShopSignWithModal = component.get('v.valueShopSignWithModal');
		for (var i = 0; i < selectedRows.length; i++){
			// component.set("v.selectServicePoint", selectedRows[i]);
			selectServicePointArray.push(selectedRows[i]);
		}
		var selectServicePoint = selectServicePointArray;
		if(selectedRows.length===1){

			component.set("v.openModalShopSign", false);
			var selectedShopSign = selectedRows[selectedRows.length-1];
			valueShopSignWithModal = (selectedShopSign.OB_ShopSign__c).substring(0, 31);
			component.set('v.valueShopSignWithModal' , valueShopSignWithModal);
			console.log('value of shop sign: ' + component.get('v.valueShopSignWithModal'));
			objectDataMap.shopSign = component.get('v.valueShopSignWithModal');
			component.set('v.objectDataMap' , objectDataMap);
			console.log('SHOP SIGN IN OBJ: ' + objectDataMap.shopSign);


		}
		// alert('1' + document.getElementById('errorIdShopSignWithModal'));
		// 	if( document.getElementById('errorIdShopSignWithModal'))
		// 	{
		// 		alert('1');
		// 		document.getElementById('errorIdShopSignWithModal').remove();
		// 	}
	}
})