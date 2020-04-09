({

    /*
    *	Author		:   Morittu Andrea
    *	Date		:   26/Nov/2019
    *	Task		:   Untracked -> creating dynamic checkbox to insert in flows (Dependency : Bit2Flow)
    *	Description	:	DoInit
    */

	doInit_Helper : function(component, event) {
        console.log('DynamicCheckBox has been fired');
        try {
        	let addressMapping = component.get('v.field.addressMapping');
			var objectDataMap = component.get('v.objectDataMap');
            
            console.log('## ADDRESS MAPPING IS : ' + JSON.stringify(addressMapping));
            let mainSchema = {};
            mainSchema.auraId;
            mainSchema.value;
            mainSchema.target = '';
            let objectDataMapNode ='';
            mainSchema.startsInEvenPosition = false;
            let isEvenPosition = true;

            // LOOP THROUGHT EVERY KEY IN ADDRESS MAPPING 
            for(var key in addressMapping) {
                switch (key) {
                    case 'objectDataMapNode'  :
						objectDataMapNode 				=  	'.' + addressMapping[key] + '.';
					break;
					case 'targetField' :
                    	mainSchema.target 				+= 	addressMapping[key];
                        mainSchema.auraId 				= 	addressMapping[key];
                    break;
                    case 'startsInEvenPosition':
                        isEvenPosition = 	addressMapping[key];
                   	break;
                    case 'labelMessage':
                        // SET DYNAMICALLY  LABEL OF INPUT
                    	let message = addressMapping[key];
                    	component.set('v.labelText' , $A.getReference("$Label.c." + message));
					break;
                }
            }
            // BOOLEAN USED TO CREATE EMPTY DIV
            component.set('v.isEvenPosition', isEvenPosition);
			
            mainSchema.target = objectDataMapNode + mainSchema.target;
          /* ANDREA MORITTU START - ADDING  MISSING PART - 29-Nov-2019*/
            function parseBoolean(stringifiedBoolean) {
                  if(stringifiedBoolean === 'false') {
                      return false;
                  } else if(stringifiedBoolean === 'true') {
                      return true;
                  }
              }
          /* ANDREA MORITTU END - ADDING  MISSING PART  29-Nov-2019*/
            let targetInobjDtMp = 'v.objectDataMap' + mainSchema.target;
            if(!$A.util.isUndefined(component.get(targetInobjDtMp))) {
               // ANDREA MORITTU START 28-Nov-2019 - Fixing predefault values to true
                if(typeof(component.get(targetInobjDtMp)) == 'string') {
                   mainSchema.value = parseBoolean(component.get(targetInobjDtMp)); 
                } else if(typeof(component.get(targetInobjDtMp)) == 'boolean') {
                   // ANDREA MORITTU START 28-Nov-2019 - Fixing selection on back button
                    mainSchema.value = component.get(targetInobjDtMp); 
                  // ANDREA MORITTU END 28-Nov-2019 - Fixing selection on back button
                }
                // ANDREA MORITTU END 28-Nov-2019 - Fixing predefault values to true
            }
            console.log('mainSchema : ' + JSON.stringify(mainSchema) );
            component.set('v.mainSchema' , mainSchema);
            
        } catch (e) {
            console.log('An error has occured : ' + e.message)
        }
	},
    
    /*
    *	Author		:   Morittu Andrea
    *	Date		:   26/Nov/2019
    *	Task		:   Untracked -> creating dynamic checkbox to insert in flows (Dependency : Bit2Flow)
    *	Description	:	Function to store true/false value
    */

    onChangeCheckboxes_Helper : function(component, event) {
        try{
        	let currentCheckBoxTarget = event.getSource().get("v.id");
            let targetToset = 'v.objectDataMap' + currentCheckBoxTarget;
            let value = event.getSource().get("v.checked");
            component.set(targetToset, value);            
        } catch(e) {
            console.log('An error has occured : ' + e.message);
        }
    }
})