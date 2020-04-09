({
    doInit : function(component, event, helper) {

        var objectDataMap  = component.get("v.objectDataMap");
        //GIOVANNI SPINELLI START 07/02/2019 --> set null the time type because of it causes the exceptio in deserialize in apex
        console.log('IS_MAINTENANCE? ' + component.get('v.isFromMaintenance'));
        console.log('SERVICE POINT DO INIT: ' +JSON.stringify(objectDataMap.pv));
        if(!objectDataMap.pv.OB_Opening_Time__c){
            component.set('v.objectDataMap.pv.OB_Opening_Time__c'       , null);
        }
        if(!objectDataMap.pv.OB_Ending_Time__c){
            component.set('v.objectDataMap.pv.OB_Ending_Time__c'        , null);
        }
        if(!objectDataMap.pv.OB_Break_Start_Time__c){
            component.set('v.objectDataMap.pv.OB_Break_Start_Time__c'   , null);
        }
        if(!objectDataMap.pv.OB_Break_End_Time__c){
            component.set('v.objectDataMap.pv.OB_Break_End_Time__c'     , null);
        }
        //GIOVANNI SPINELLI END 07/02/2019
        //VARIABLE FOR SEE IF I AM IN MAINTENANCE OR NOT
        var maintenanceEnvironment =  component.get("v.isFromMaintenance");
        console.log("maintenanceEnvironment without setting is : " + maintenanceEnvironment);
//        if(maintenanceEnvironment){
//        	var inputTimes = component.find("inputTimes");
//        	console.log('@@@ inputTimes is: ' + JSON.stringify(inputTimes));
//        	inputTimes.parentNode.removeChild(inputTimes);
//        }
        // component.set("v.isFromMaintenance", maintenanceEnvironment);
        // console.log('@@@@@@@@ maintenanceEnvironment is: ' + maintenanceEnvironment);
        
        console.log("***objectDataMap: "+ JSON.stringify(objectDataMap));

        var days= [$A.get("$Label.c.OB_Monday"),$A.get("$Label.c.OB_Tuesday"),$A.get("$Label.c.OB_Wednesday"),$A.get("$Label.c.OB_Thursday"),$A.get("$Label.c.OB_Friday"),$A.get("$Label.c.OB_Saturday"),$A.get("$Label.c.OB_Sunday")];
        var daysEn = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
        component.set("v.days", days);
        
//START s.m. - g.v. 15/03/2019
        var listOpenMorning = [true, true, true, true, true, true, true];
        var listOpenAfternoon = [true, true, true, true, true, true, true];

        var mapIdOptionOpeningTime = {};
        for(var i = 0; i < days.length; i++){
        	var stringI = i.toString();
        	
        	var todayMorning = 'v.objectDataMap.pv.OB_Opening_' + daysEn[i] + '_Morning__c';
            var todayMorningValue = component.get(todayMorning);
            console.log('todayMorning: '+todayMorning);
            console.log('todayMorningValue: '+todayMorningValue);
            var todayAfternoon =  'v.objectDataMap.pv.OB_Opening_' + daysEn[i] + '_Afternoon__c'; 
            var todayAfternoonValue = component.get(todayAfternoon);

            mapIdOptionOpeningTime[stringI+'m'] = 'OB_Opening_' + daysEn[i] + '_Morning__c';
        	console.log('@@@ My index is : ' + stringI + 'day : ' + daysEn[i]);
            mapIdOptionOpeningTime[stringI+'p'] =  'OB_Opening_' + daysEn[i] + '_Afternoon__c';
        
            if(todayMorningValue){
                console.log(todayMorning +': @@@@@@'+ todayMorningValue);
                // mapOpenMorning.days[i] = days[i];
                // mapOpenMorning.value[i] = true;
                listOpenMorning[i] = true;

            }else{
                console.log(todayMorning +': @@@@@@'+ todayMorningValue);
                // mapOpenMorning.days[i] = days[i];
                // mapOpenMorning.value[i] = false;
                listOpenMorning[i] = false;
            }
            if(todayAfternoonValue){
                // mapOpenAfternoon.days[i] = days[i];
                // mapOpenAfternoon.value[i] = true;
                listOpenAfternoon[i] = true;

            }else{
                // mapOpenAfternoon.days[i] = days[i];
                // mapOpenAfternoon.value[i] = false;
                listOpenAfternoon[i] = false;
            }
          
            
        }
        // console.log("mapOpenMorning: "+ JSON.stringify(mapOpenMorning));
        // component.set('v.mapOpenMorning', mapOpenMorning);
        // component.set('v.mapOpenAfternoon', mapOpenAfternoon);
        // console.log("v.mapOpenMorning: "+ JSON.stringify(component.get('v.mapOpenMorning')));
        console.log("listOpenMorning: "+ JSON.stringify(listOpenMorning));
        component.set('v.listOpenMorning', listOpenMorning);
        console.log("listOpenAfternoon: "+ JSON.stringify(listOpenAfternoon));
        component.set('v.listOpenAfternoon', listOpenAfternoon);
//END s.m. - g.v 15/03/2019
        console.log("fields opening times: " + JSON.stringify(mapIdOptionOpeningTime));
        component.set("v.mapIdOptionOpeningTime", mapIdOptionOpeningTime);
        var objectDataMap = component.get("v.objectDataMap");
  //       component.set("v.mapIdOptionOpeningTime", mapIdOptionOpeningTime);
		// component.set('v.objectDataMap.pv.OB_Opening_Time__c', ' ');
		// component.set('v.objectDataMap.pv.OB_Ending_Time__c', ' ');
		// component.set('v.objectDataMap.pv.OB_Break_End_Time__c', ' ');
		// component.set('v.objectDataMap.pv.OB_Break_Start_Time__c', ' ');

        
  //       /*------ SET 'TRUE' ALL CHECKBOXES MORNING/AFTERNOON TABLE -----*/
        
  //       								/*	Monday	*/
  //       component.set('v.objectDataMap.pv.OB_Opening_Monday_Afternoon__c', 		true);
  //       component.set('v.objectDataMap.pv.OB_Opening_Monday_Morning__c', 		true);
  //       								/*	Tuesday	*/
  //       component.set( 'v.objectDataMap.pv.OB_Opening_Tuesday_Morning__c', 		true);
  //       component.set( 'v.objectDataMap.pv.OB_Opening_Tuesday_Afternoon__c',	true);
  //       								/*	Wednesday*/
  //       component.set( 'v.objectDataMap.pv.OB_Opening_Wednesday_Morning__c', 	true);
  //       component.set( 'v.objectDataMap.pv.OB_Opening_Wednesday_Afternoon__c' , true);
  //      									/*	Thursday*/
  //       component.set( 'v.objectDataMap.pv.OB_Opening_Thursday_Afternoon__c' , 	true);
  //       component.set( 'v.objectDataMap.pv.OB_Opening_Thursday_Morning__c', 	true);
  //       								/*	Friday	*/
  //       component.set( 'v.objectDataMap.pv.OB_Opening_Friday_Afternoon__c', 	true);
  //       component.set( 'v.objectDataMap.pv.OB_Opening_Friday_Morning__c', 		true);
  //       								/*	Saturday	*/
  //       component.set( 'v.objectDataMap.pv.OB_Opening_Saturday_Afternoon__c', 	true);
  //       component.set( 'v.objectDataMap.pv.OB_Opening_Saturday_Morning__c', 	true);
  //       								/*	Sunday	*/
  //       component.set( 'v.objectDataMap.pv.OB_Opening_Sunday_Afternoon__c', 	true);
  //       component.set( 'v.objectDataMap.pv.OB_Opening_Sunday_Morning__c', 		true);
        
        
/*OB_Opening_Monday_Morning__c
OB_Opening_Monday_Afternoon__c

OB_Opening_Tuesday_Morning__c
OB_Opening_Tuesday_Afternoon__c

OB_Opening_Wednesday_Morning__c
OB_Opening_Wednesday_Afternoon__c

OB_Opening_Thursday_Morning__c
OB_Opening_Thursday_Afternoon__c

OB_Opening_Friday_Morning__c        
OB_Opening_Friday_Afternoon__c


OB_Opening_Saturday_Morning__c
OB_Opening_Saturday_Afternoon__c

OB_Opening_Sunday_Morning__c
OB_Opening_Sunday_Afternoon__c */
 
    },
    
    handleChangeOption: function(component, event, helper) {
    	var targetId =  event.target.id;
    	console.log('targetId is' + targetId);
        var selectedValue =  event.target.value;
    	console.log('selectedValue is' + selectedValue);
        //if(selectedValue == $A.get("$Label.c.MandatoryField")){
//START s.m. - g.v. 15/03/2019
        if(selectedValue == "Aperto"){
//END s.m. - g.v 15/03/2019
        	console.log('selectedValue in OB_Opening_Times_Open is' + selectedValue);
        	selectedValue = true;
        	console.log('Did I change the selected value to true? ' + selectedValue);
        }else{
        	selectedValue = false;
        	console.log('I didn\'t change the value of selectedValue' + selectedValue);
        }
        var mapIdOptionOpeningTime = component.get("v.mapIdOptionOpeningTime");
        var fieldName = mapIdOptionOpeningTime[targetId];
        
        /*--- Attributes for lightning input type:time ------
        var breakStartTime = component.find('breakStartTime').get('v.value');
        component.set('v.objectDataMap.pv.OB_Break_Start_Time__c', breakStartTime);
        
        var breakEndTime = component.find('breakEndTime').get('v.value');
        component.set('v.objectDatamap.OB_Break_End_Time__c', breakEndTime);
        
        var openingTime = component.find('openingTime').get('v.value');
        component.set('v.objectDataMap.pv.OB_Opening_Time__c', openingTime);
        
        var closingTime = component.find('ClosingTime').get('v.value');
        component.set('v.objectDataMap.pv.OB_Ending_Time__c', closingTime);

        */
        
        console.log("fieldName: " + fieldName);
		var objectDataMap = component.get("v.objectDataMap");
		console.log("objectDataMap pv" + JSON.stringify(objectDataMap["pv"][fieldName]));
		objectDataMap["pv"][fieldName] = selectedValue;
		component.set("v.objectDataMap", objectDataMap);
		console.log("objectDataMap updated" + JSON.stringify(objectDataMap));
    },


    //***METHOD TO SET THE RED BORDER ON MANDATORY FIELD***//
      setRedBorderSP: function(component, event, helper) 
     {
        //  micol.ferrari 21/12/2018 - DO NOT CHECK ERRORS IF WE'RE FROM THE MAINTENANCE
        if (component.get("v.isFromMaintenance")!=true)
        {
            var objectDataMap    = component.get("v.objectDataMap");

            var openingTimeValue = component.find("openingTime").get("v.value");
            var openingTime      = objectDataMap.pv.OB_Opening_Time__c; 
            console.log("opening Time : " +openingTime+'---- openingTimeValue : '+openingTimeValue);

            var closingTimeValue = component.find("ClosingTime").get("v.value");
            var closingTime      = objectDataMap.pv.OB_Ending_Time__c;
            console.log("closing Time : " + closingTime+ '------ closingTimeValue : '+closingTimeValue);

            console.log('setredbord '+objectDataMap.setRedBorderServicePointStep+ ' °°°°° '+objectDataMap.setRedBorderServicePointStepValidation);
       
    
            if(objectDataMap.setRedBorderServicePointStep==true) {
                    var mapFromNext = {};
                    
                    mapFromNext = objectDataMap.checkMapValuesServicePointStep;
                    console.log("map in opening time : " + JSON.stringify(mapFromNext));
                    for (var keys in mapFromNext)
                    {   
                        console.log("the key in open data: " + keys);
                                       
                        var errorId = 'errorId' +keys;
                        var myDiv;
                          
                        myDiv = document.createElement('div');
                        myDiv.setAttribute('id',errorId);//SET AN ID TO EVERY MESSAGE
                        myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
                        myDiv.setAttribute('class' , 'messageError'+keys);
                         //SET THE MESSAGE
                          // var errorMessage = document.createTextNode(mapFromNext[keys]);
                          // myDiv.appendChild(errorMessage); 

                         // var idSet = component.find(keys).getElement();
                        //  var standardMessageArray = document.getElementsByClassName('slds-form-element__help');
                        //  console.log("array of standard message: " + JSON.stringify(standardMessageArray));

                        //  15/10/2018----dd ----TSART
                        var errorMessage = document.createTextNode(mapFromNext[keys]);
                        myDiv.appendChild(errorMessage);

                        var idSet = document.getElementById(keys);
                        console.log("ID SET : " + idSet + ", input: " + JSON.stringify(component.find(keys)));

                        //CONTROL TO CATCH THE AURA ID IN LIGHTNING:SELECT 
                        //THIS METHOD STARTS WHEN ON DISPLAY THERE ARE THE INPUTS TO EXAMINE
                       if($A.util.isUndefinedOrNull(idSet) && !$A.util.isUndefinedOrNull(component.find(keys))){
                           idSet = component.find(keys).getElement();
                        } 
                        else if($A.util.isUndefinedOrNull(idSet)){
                           idSet = document.getElementsByName(keys)[0];
                        }
                        console.log('idSet::: '+idSet);
                        if(idSet!=null && idSet!= undefined)
                        { 
                            if(!(document.getElementById(errorId)) && !(idSet.value))
                            {
                                console.log("METHOD TO SHOW ONLY A MESSAGE");
                                idSet.after(myDiv);
                                $A.util.addClass(idSet, 'slds-has-error flow_required');
                                //idSet.className="slds-has-error flow_required";
                            }
                        }

                        //  15/10/2018----dd --- END

                       
                        
                        /*  ADD THE 'MANDATORY FIELD' MESSAGE AND THE RED BORDER 
                            ONLY IF THERE ISN'T ALREDY ONE AND IF THE FIELD IS EMPTY------*/
                        
                    //      if(document.getElementById(errorId))
                    //     {
                    //          console.log('IF CONDITION');
                    //          var hasStandardMessage = false;
                    //          var thisinput = document.getElementById(errorId);
                    //          for (var i=0; i<thisinput.childNodes.length; i++)
                    //          {
                    //              console.log("first for");
                    //              var currentChild = thisinput.childNodes[i];
                    //              for (var j=0;j<currentChild.childNodes.length;j++)
                    //              {
                    //                 var innerChild = currentChild.childNodes[j];
                    //                  console.log("innerchild: " + innerChild);
                    //                  //IF THERE IS A CLASS WITH THIS NAME SET A BOOLEAN
                    //                  if (innerChild.className=='slds-form-element__help')
                    //                 {
                    //                      hasStandardMessage = true;    
                    //                      console.log("in inf boolean");                                        
                    //                  }                                             
                    //              }
                    //          }
                    //          if (hasStandardMessage!=true)
                    //         {
                    //              idSet.after(myDiv);
                    //              idSet.className="slds-has-error flow_required"; 
                    //          }
                        
                    //     }

                    } //END FOR
                   // objectDataMap.setRedBorderServicePointStep = false ;

            }
            //  15/10/2018----DD --- START
                
                //VALIDATION TIME

            if (objectDataMap.setRedBorderServicePointStepValidation == true){   

                    var mapFromNextValidation = {};
                    mapFromNextValidation = objectDataMap.checkMapValuesServicePointStepValidation;
                    console.log("map in validation time : " + JSON.stringify(mapFromNextValidation));

                    for (var keys in mapFromNextValidation)
                    {

                        var errorId = 'errorId' +keys;
                        console.log("key  = " + keys);
                        
                        var myDiv;
                        
                        myDiv = document.createElement('div');
                        myDiv.setAttribute('id',errorId);//SET AN ID TO EVERY MESSAGE
                        myDiv.setAttribute('style','color:rgb(194, 57, 52);  position: absolute;  z-index: 1;');
                        myDiv.setAttribute('class' , 'messageError'+keys);
                        //SET THE MESSAGE
                        var errorMessage = document.createTextNode(mapFromNextValidation[keys]);
                        console.log('errorMessage:: '+JSON.stringify(errorMessage));
                        myDiv.appendChild(errorMessage);
                        
                        var idSet = document.getElementById(keys);
                        console.log("ID SET VALIDATION: " + idSet + ", input VALIDATION: " + JSON.stringify(component.find(keys)));
                        //CONTROL TO CATCH THE AURA ID IN LIGHTNING:SELECT 
                        //THIS METHOD STARTS WHEN ON DISPLAY THERE ARE THE INPUTS TO EXAMINE
                        if($A.util.isUndefinedOrNull(idSet) && !$A.util.isUndefinedOrNull(component.find(keys))){

                           idSet = component.find(keys).getElement();

                        } else if($A.util.isUndefinedOrNull(idSet)){

                           idSet = document.getElementsByName(keys)[0];
                        }
                        if(idSet!=null && idSet!= undefined)
                        { 
                            console.log('errorId doc'+(document.getElementById(errorId)));

                            if(!(document.getElementById(errorId)))
                            {
                                console.log("METHOD TO SHOW ONLY A MESSAGE");
                                idSet.after(myDiv);
                                $A.util.addClass(idSet, 'slds-has-error flow_required');
                                //idSet.className="slds-has-error flow_required";
                            }
                        }//END FOR
                    } 

                //objectDataMap.setRedBorderServicePointStepValidation = false ;
                //  15/10/2018----DD --- END

            } 
        }
               
    },


     removeRedBorderSp : function(component, event, helper) {
        
        //   //GET THE CURRENT ID FROM INPUT 
        // var currentId = event.target.id; 
        // console.log("current id is: " + currentId);

        // //RECREATE THE SAME ID OF ERROR MESSAGE
        // var errorId = 'errorId'+ currentId;
        // var changeClass = component.find(currentId);
        // console.log("changeClass ==  " + changeClass);
        // var test3 = document.getElementById(errorId).value;
        // console.log("test3 === "+ test3);
        // //REMOVE RED BORDER
        // //REMOVE ERROR MESSAGE
        // if(document.getElementById(errorId)!=null){
        //     console.log("errorID . " + errorId);
        //     document.getElementById(errorId).remove();
        // }
        
        // $A.util.removeClass(component.find('breakEndTime'), 'slds-has-error flow_required');

         // START --- 15/10/2018 --- DD
        var objectDataMap  = component.get("v.objectDataMap");
        console.log(" objectDataMap pv  ** before **  -----> "+JSON.stringify(objectDataMap.pv));

        var openingTimeValue = component.find("openingTime").get("v.value");
        var openingTime      = objectDataMap.pv.OB_Opening_Time__c; 
        var closingTimeValue = component.find("ClosingTime").get("v.value");
        var closingTime      = objectDataMap.pv.OB_Ending_Time__c;

        if(!objectDataMap.pv.OB_Opening_Time__c)
             component.set("v.objectDataMap.pv.OB_Opening_Time__c",null);
        if(!objectDataMap.pv.OB_Ending_Time__c) 
             component.set("v.objectDataMap.pv.OB_Ending_Time__c",null);
        if(!objectDataMap.pv.OB_Break_Start_Time__c)
             component.set("v.objectDataMap.pv.OB_Break_Start_Time__c",null);
        if(!objectDataMap.pv.OB_Break_End_Time__c)
            component.set("v.objectDataMap.pv.OB_Break_End_Time__c",null);

        console.log(" objectDataMap pv  ** after **  -----> "+JSON.stringify(objectDataMap.pv));


        //GET THE CURRENT ID FROM INPUT 
        var currentId = event.target.id; 
        console.log("current id is: " + currentId);
        $A.util.removeClass(document.getElementById(currentId) , 'slds-has-error');
        //RECREATE THE SAME ID OF ERROR MESSAGE
        var errorId = 'errorId'+ currentId;
        if(document.getElementById(errorId)!=null){
            console.log("errorID . " + errorId);
            document.getElementById(errorId).remove();
        }

        //  DEPENDENT ERRORS
        if (currentId=='openingTime')
        {
            $A.util.removeClass(document.getElementById('ClosingTime') , 'slds-has-error');
            var timeClose = document.getElementById('errorIdClosingTime');
            if(timeClose != null || timeClose != undefined)
                timeClose.remove();
        }
        else if (currentId=='ClosingTime')
        {
            $A.util.removeClass(document.getElementById('openingTime') , 'slds-has-error');
            var timeOpen =  document.getElementById('errorIdopeningTime');
            if( timeOpen != undefined || timeOpen != null) 
                timeOpen.remove();
        }
        else if (currentId=='breakStartTime')
        {
            $A.util.removeClass(document.getElementById('breakEndTime') , 'slds-has-error');
            var timeStartBreak = document.getElementById('errorIdbreakEndTime');
            if( timeStartBreak != undefined  || timeStartBreak != null) 
                timeStartBreak.remove();
            
        }
        else if (currentId=='breakEndTime')
        {
            $A.util.removeClass(document.getElementById('breakStartTime') , 'slds-has-error');
            var timeEndBreak = document.getElementById('errorIdbreakStartTime');
            if( timeEndBreak != undefined || timeEndBreak != null )
                timeEndBreak.remove();
           
        }
       // END --- 15/10/2018 --- DD  



     },
     
    setFormalMessage : function(component, event, helper) {
        var breakStartTime = document.getElementById("breakStartTime");
        
            if (breakStartTime.validity.typeMismatch)
            {
            
            breakStartTime.setCustomValidity("CIAO");
            } 
            else 
            {
            
            breakStartTime.setCustomValidity("");
            }
         
    }


    
})