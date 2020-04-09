({
    /*
    *@author francesca.ribezzi
    *@date 11/07/2019
    *@task fix dati operativi step (setup) performance
    *@description Method moved from OB_TechDetailService 
    *@history 11/07/2019 Method moved
    *@history NEXI-261 Kinga Fornal <kinga.fornal@accenture.com>
              23/08/2019 Isgenerated = true removed from !($A.util.isEmpty(terminalId))
              && (readOnly != true || readOnly != 'true') scenario.
    */
    callService : function(component, event) {  //francesca.ribezzi 30/07/19 adding event in order to use event.getSource() - WN-211
		try{ //francesca.ribezzi 11/11/19 - PROD-66 - adding try/catch block
			var objectDataMap = component.get("v.objectDataMap");
			var isMaintenance = component.get("v.isMaintenance");
			//30/07/19 francesca.ribezzi get clickedBtn - WN-211:
			var clickedButton = event.getSource();
			//18/07/19 francesca.ribezzi adding terminalIdAttributIdex
			var terminalIdAttributIdex = 0;
			//get the abi from datamap
			var Abi;
			var attrId;
			if(isMaintenance) 
			{
				Abi = component.get("v.bankABI"); 
			}
			else
			{
				//	Daniele Gandini <daniele.gandini@accenture.com>	19/04/2019 - R1F2-38_R1F2-44 - Changed bank node on ObjectDatamap to user one to have right ABI value
				Abi = component.get("v.orderABI"); //Simone Misani WN-295 29/08/2019 //30/07/19 francesca.ribezzi using bank node instead of user's!
			}
			var contractId;
			var ordId;
			if(isMaintenance){
				contractId = component.get("v.orderId");
				ordId = component.get("v.orderId");
			}
			else{
				//get contract id from datamap
				contractId =objectDataMap.Configuration.Id; //'a0y9E0000043M72QAE';  //'a0y9E0000043nUlQAI';// 'a0y9E000003zJQSQA2';  		
				//get order Id
				ordId = objectDataMap.Configuration.Id;// 'a0y9E0000043M72QAE';//'a0y9E0000043nUlQAI';//'a0y9E000003zJQSQA2';
			}
			var terminalId;
			var readOnly;
			var postype;
			var Isgenerated = false;
			var skipServiceCall = false;
			//START francesca.ribezzi 11/07/19  using component.get instead of event.target.name -> not working here
			var attributeIndex = component.get("v.index");  //firstIndex+'_VAS_generateBtn		
			var itemName = component.get("v.itemName");
			var fullAttribute;  //08/10/19 francesca.ribezzi WN-576 - adding fullAttribute to keep the whole term id attribute 
			var listOfItems = [];
			if(itemName == 'POS'){
				listOfItems = component.get("v.posList");
			}else if(itemName == 'VAS'){
				listOfItems = component.get("v.vasList");
			}
			//END francesca.ribezzi 11/07/19 
			var itemToUpdate = listOfItems[parseInt(attributeIndex)];
			//got the correct item
			_utils.debug("itemToUpdate: ",itemToUpdate);
			
			//francesca.ribezzi - getting how many terminal ids there are:
			var clickedBtn = parseInt(attributeIndex);//event.target.name;
			//boolean to check if there is at least one readOnly terminalID. if so, the callback must be successful!! 
			var terminalIDnotReadOnly = false;
			var mapItemIdSuccessTerminalCall = component.get("v.mapItemIdSuccessTerminalCall");

			for(var i = 0; i < itemToUpdate.listOfAttributes.length; i++){
				//get the terminal id
				if(itemToUpdate.listOfAttributes[i].fields.name == 'Terminal Id'){
					//18/07/19 francesca.ribezzi setting terminalIdAttributIdex
					terminalIdAttributIdex = i;
					terminalId = itemToUpdate.listOfAttributes[i].fields.value;
					readOnly = itemToUpdate.listOfAttributes[i].fields.readonly;	
					attrId =  itemToUpdate.listOfAttributes[i].fields.idLineAttribute;
					terminalIDnotReadOnly = readOnly == 'false' || !readOnly ?  true : false; //francesca.ribezzi 19/09/19 setting terminalIDnotReadOnly when term id is not readonly
					fullAttribute = itemToUpdate.listOfAttributes[i]; //08/10/19 francesca.ribezzi WN-576 setting fullAttribute here
					//START francesca.ribezzi 11/07/19 
					if(!$A.util.isEmpty(terminalId) && (readOnly == true || readOnly == "true")){
						//START francesca.ribezzi 30/07/19 setting new label to clicked btn: - WN-211
						Isgenerated = true;
						var regenerateLabel = $A.get("$Label.c.OB_RegenerateTerminalIdLabel"); 
						clickedButton.set("v.label", regenerateLabel);
						//END francesca.ribezzi 30/07/19  - WN-211
					}
					//END francesca.ribezzi 11/07/19 
				}
			}
			//get pos Type
			//get record id if is terminali will be "fisico" else it will be "virtuale"
			var terminaliRecordType = "Terminali";
			terminaliRecordType = terminaliRecordType.toLowerCase();
			
			var recordTypeToMatch = itemToUpdate.fields.RecordTypeName.toLowerCase();
			
			if(recordTypeToMatch != terminaliRecordType){
				postype = 'virtuale';
			}
			else{
				postype = 'fisico';
			}
			//try to grasp if we need to verify or generate
			if( $A.util.isEmpty(terminalId) && (readOnly == true || readOnly == 'true') ){ 
				Isgenerated = true;
				//START francesca.ribezzi 30/07/19 setting new label to clicked btn: - WN-211
				Isgenerated = true;
				var regenerateLabel = $A.get("$Label.c.OB_RegenerateTerminalIdLabel"); 
				clickedButton.set("v.label", regenerateLabel);
				//END francesca.ribezzi 30/07/19  - WN-211
			}
			else if( !($A.util.isEmpty(terminalId)) && (readOnly == true || readOnly == 'true') ){
				skipServiceCall = true;
			}
			else if( $A.util.isEmpty(terminalId) && (readOnly != true || readOnly != 'true') ){
				var errorLabel = $A.get("$Label.c.OB_CustomErrorLabelTech");
				var specialErrorLabel = $A.get("$Label.c.OB_SpecialErrorLabelTech");
				var obj = this.getTerminalIdInputError(component, event, clickedBtn, itemName,listOfItems,attrId,terminalIDnotReadOnly );//
				if(obj.input.value.length != 8){
					obj.errMsg.innerHTML = errorLabel+' '+specialErrorLabel; 
					skipServiceCall = true;
				}
			}
			else if( !($A.util.isEmpty(terminalId)) && (readOnly != true || readOnly != 'true') ){
				//START francesca.ribezzi 11/07/19 commenting this code as getElementById is not working  - api version is too high
				//START francesca.ribezzi 30/07/19 setting new label to clicked btn: - WN-211
				var regenerateLabel = $A.get("$Label.c.OB_RegenerateTerminalIdLabel"); 
				clickedButton.set("v.label", regenerateLabel);
				//END francesca.ribezzi 30/07/19  - WN-211
				//francesca.ribezzi just added:
				var errorLabel = $A.get("$Label.c.OB_CustomErrorLabelTech");
				var specialErrorLabel = $A.get("$Label.c.OB_SpecialErrorLabelTech");
				var obj = this.getTerminalIdInputError(component, event, clickedBtn, itemName,listOfItems, attrId,terminalIDnotReadOnly);
				if(obj.input.value.length != 8){
					obj.errMsg.innerHTML = errorLabel+' '+specialErrorLabel; 
					skipServiceCall = true;
					fullAttribute.fields["error"] = true;//08/10/19 francesca.ribezzi WN-576 
				}
			}
			
			if(!skipServiceCall){
				var action = component.get("c.callTerminalIdService");
				action.setParams({ 
					isToGenerate: Isgenerated,
					orderId: ordId,
					proposerAbi: Abi,
					posType: postype,
					terminalId: terminalId,
					contractId: contractId 
				});
				action.setCallback(this, function(response) {
					var state = response.getState();				
					if (state === "SUCCESS") {
						//manage the resp
						var res =  response.getReturnValue();
						var contextOutput = component.get("v.contextOutput");
						if( (res.terminalId != "null" && res.terminalId != '0' && res.terminalId != undefined) || res.result == 'OK'){
							if(Isgenerated){
								//reset error Msg if result is correct
								var errMsg = document.getElementById(attributeIndex+'_'+itemName+'_ErrorTerminalId');
								//NEXI-261 Grzegorz Banach <grzegorz.banach@accenture.com> 22/08/2019 START temporary fix - to be refactored using events
								if ( $A.util.isEmpty( errMsg ) )
								{
									errMsg = document.getElementById( attributeIndex+'_'+attributeIndex+'_'+itemName+'_ErrorTerminalId' );
								}
								//NEXI-261 Grzegorz Banach <grzegorz.banach@accenture.com> 22/08/2019 STOP
								errMsg.innerHTML = '';
								fullAttribute.fields.value = res.terminalId;//08/10/19 francesca.ribezzi WN-576 
							}
							else{
								//reset error Msg if result is correct
								var obj = this.getTerminalIdInputError(component, event, clickedBtn, itemName, listOfItems, attrId,terminalIDnotReadOnly);
								obj.errMsg.innerHTML = '';
								fullAttribute.fields["error"] = false;
							}
							//START francesca.ribezzi 18/07/19 chaning action - performance
							//END francesca.ribezzi 18/07/19 
							//set the new item in the list
							component.set("v.isEnd", true);        
							mapItemIdSuccessTerminalCall[itemToUpdate.fields.id] = true;      
							fullAttribute.fields["error"] = false; //08/10/19 francesca.ribezzi WN-576 
							//francesca.ribezzi 11/07/19 commenting disable btn as this is not working anymore - api version is too high
							//14/03/19 francesca.ribezzi disable button after generating/verifying a terminalId:
							
						}
						else{
							//manage errors
							var errorLabel = $A.get("$Label.c.OB_CustomErrorLabelTech");
							if(Isgenerated){
								var x = document.getElementById(attributeIndex+'_'+itemName+'_ErrorTerminalId');
								x.innerHTML = errorLabel+' '+res.result;
							}
							else{
								var x = this.getTerminalIdInputError(component, event, clickedBtn, itemName,listOfItems, attrId,terminalIDnotReadOnly);
								x.errMsg.innerHTML = errorLabel+' '+res.result;					
							}
		
							mapItemIdSuccessTerminalCall[itemToUpdate.fields.id] = false;
							fullAttribute.fields["error"] = true; //08/10/19 francesca.ribezzi WN-576 - adding error 
							component.set("v.Spinner",false);
						}

						if(itemName == 'POS'){
							component.set("v.posList",listOfItems); 
						}else if(itemName == 'VAS'){
							component.set("v.vasList",listOfItems);
						}           
					}
					else if (state === "INCOMPLETE") {
						mapItemIdSuccessTerminalCall[itemToUpdate.fields.id] = false;
						fullAttribute.fields["error"] = false; //08/10/19 francesca.ribezzi WN-576 
						if(itemName == 'POS'){
							component.set("v.posList",listOfItems);
						}else if(itemName == 'VAS'){
							component.set("v.vasList",listOfItems);
						}  
						component.set("v.Spinner",false);
					}
					else if (state === "ERROR") {
						//START-----simone misani 27/05/2019 showErrorToast for serviceDown
						var operationFailed = $A.get("$Label.c.OB_ErrorService");
						this.showErrorToast(component,event,operationFailed);
						component.set("v.Spinner",false);
						//END-----simone misani 27/05/2019 showErrorToast for serviceDown
						if(terminalIDnotReadOnly){
							var obj = this.getTerminalIdInputError(component, event, clickedBtn, itemName,listOfItems, attrId,terminalIDnotReadOnly);
							//START gianluigi.virga 12/08/2019 - UX-197
							var errorLabel = $A.get("$Label.c.OB_ServiceUnavailable"); //"ERROR - the callback must be successful!"
							//END gianluigi.virga 12/08/2019 - UX-197
							
							obj.errMsg.innerHTML = errorLabel;
						}
							var errors = response.getError();
							if (errors) {
								if (errors[0] && errors[0].message) {
									var obj = this.getTerminalIdInputError(component, event, clickedBtn, itemName,listOfItems, attrId,terminalIDnotReadOnly);
									//START gianluigi.virga 12/08/2019 - UX-197
									obj.errMsg.innerHTML = $A.get("$Label.c.OB_ServiceUnavailable"); //"ERROR - the callback must be successful!"
									//END gianluigi.virga 12/08/2019 - UX-197
								}
							} else {
							}
							component.set("v.Spinner",false);
							mapItemIdSuccessTerminalCall[itemToUpdate.fields.id] = false;
							fullAttribute.fields["error"] = true; //08/10/19 francesca.ribezzi WN-576 - adding error 
							if(itemName == 'POS'){
								component.set("v.posList",listOfItems);
							}else if(itemName == 'VAS'){
								component.set("v.vasList",listOfItems);
							}  
						}
					//11/07/19 francesca.ribezzi setting spinner to false
					component.set("v.Spinner",false);
				});
				$A.enqueueAction(action);
				component.set("v.Spinner", true);
			}    
		}catch(e){
			console.log('Error in callService OB_generateTerminalBtnHelper' + e.stack);
		}   
	},
	getTerminalIdInputError : function(component, event, firstIndex, itemName, listOfItems, attrId,terminalIDnotReadOnly){
		//errorID : firstIndex+'_'+index+'_POS_ErrorTerminalId event.target.name = firstIndex
		try{ //francesca.ribezzi 12/11/19 - PROD-68_v2 - adding try catch 
			var obj = {};
			var itemToUpdate = listOfItems[firstIndex];
			var index;
			for(var i = 0; i<itemToUpdate.listOfAttributes.length; i++){
				var att = itemToUpdate.listOfAttributes[i];
				if(att.fields.name == 'Terminal Id'){
					index = i;
					break;
				}
			}
			if(terminalIDnotReadOnly){
				obj.errMsg = document.getElementById(attrId+'_ErrorTerminalId');
				obj.input = document.getElementById(attrId);
			}else{
				obj.errMsg = document.getElementById(firstIndex+'_'+itemName+'_ErrorTerminalId');
				obj.input = document.getElementById(firstIndex+'_'+index+'_'+itemName);
			}
		}catch(e){
			console.log('error in getTerminalIdInputError: ' + e.stack);
		}
		return obj;

	},	
	  
	/*
     *@author francesca.ribezzi
     *@date 19/09/2019
     *@description showing error toast when service is down
     *@history 19/09/2019 Method created
     */	
	showErrorToast : function(component, event, operationFailed) {	 
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : '',
            message: operationFailed,
            //messageTemplateData: [name],
            duration:'5000',
            key: 'info_alt',
            type: 'error',
            mode: 'dismissible'
        });
        toastEvent.fire();
	},
})