({
    /*-----------------------------------------------*/
    /* DO INIT METHOD */
    /*-----------------------------------------------*/
    launchDoInit: function(component, event, helper) {
    var objectDataMap = component.get("v.objectDataMap");
    
    component.set("v.openingTimeValue", objectDataMap.pv.OB_Opening_Time__c);
    component.set("v.closingTimeValue", objectDataMap.pv.OB_Ending_Time__c);
    component.set("v.breakStartTimeValue", objectDataMap.pv.OB_Break_Start_Time__c);
    component.set("v.breakEndTimeValue", objectDataMap.pv.OB_Break_End_Time__c);
    
    //ANDREA START 08/01/19
	    var timeHasError = component.get("v.timesHaveError");
	    console.log("@@@@@@@@NEWTIMEHASERROR is : " + timeHasError);
//	    if(timeHasError != '' || timeHasError != null || timeHasError != undefined){
//	    timeHasError = component.get("v.timesHaveError").get("v.value");
//	    console.log("timeHasError IS ---------- " + timeHasError);
//	    }
	    //ANDREA END 08/01/19
    
    console.log(component.get("v.timesHaveError"));
    
//    let openingTime = objectDataMap.pv.OB_Opening_Time__c;
//    let closingTime = objectDataMap.pv.OB_Ending_Time__c;
//    let breakStartTime = objectDataMap.pv.OB_Break_Start_Time__c;
//    let breakEndTime = objectDataMap.pv.OB_Break_End_Time__c;
/*
 Nel caso in cui nei campi "Orario Inizio Pausa", "Orario Fine Pausa" o entrambi vengono inseriti
 dei valori inferiori a quello inserito per il campo "Orario Apertura" 
o superiori a quello inserito per il campo "Data Chiusura"  
viene mostrato l'errore ma salva lo stesso la modifica.
*/

    },


    /*-----------------------------------------------*/
    		/* VALIDATION CONTROLS INPUT */
    /*-----------------------------------------------*/
    checkCoherencyDateHelper: function(component, event, helper, openingTime, closingTime, breakStartTime, breakEndTime) {
        console.log('@@@@ SONO NELL HELPER ');
        var midnite = "00:00:00.000";

        console.log("midnite is: " + midnite);
/*
 * LABEL : 	MandatoryField 
			OB_BreakTimeIncoherent (
 */
        var isError;

        var firstCoupleNotEmpty 	= (openingTime 		!= null 	|| 		closingTime  != null) 	&& (openingTime 		!= "" 	|| 		closingTime  != "") ;
        var secondCoupleNotEmpty 	= (breakStartTime 	!= null 	|| 		breakEndTime != null) 	&& (breakStartTime 		!= "" 	|| 		breakEndTime != "");
        
	        if(firstCoupleNotEmpty) {
	        	console.log(' firstCoupleNotEmpty is: ' + firstCoupleNotEmpty);
	        	if(openingTime == null || openingTime == "") {
		        	// SETTING "*" ON INPUT 
		        	component.set("v.openingTimeRequired", true);
		        	component.set("v.endingTimeRequired", true);
		        	/* --------- CLASS OF ERRORS ---------- */
		        	$A.util.addClass(component.find("openingTime"), 'slds-has-error flow_required');
		        	component.set("v.openingTimeError", true);
		        	component.set("v.openingTimeErrorMessage", $A.get("$Label.c.MandatoryField"));
		        	console.log("openingTimeNull");
		        	isError = true;
	        	} else if(openingTime != null && openingTime != "") {
	        		$A.util.removeClass(component.find("openingTime") , 'slds-has-error flow_required');
	        		component.set("v.openingTimeError", false);
	        		isError = false;
	        	}
	        	if(closingTime == "" || closingTime == null) {
	        		component.set("v.openingTimeRequired", true);
		        	component.set("v.endingTimeRequired", true);
		    		$A.util.addClass(component.find("closingTime"), 'slds-has-error flow_required');
		        	component.set("v.closingTimeError", true);
		        	component.set("v.closingTimeErrorMessage", $A.get("$Label.c.MandatoryField"));
		        	console.log("closingTimeNull");
		        	isError = true;
	        	} else if(closingTime == "" || closingTime == null) {
	        		$A.util.removeClass(component.find("closingTime") , 'slds-has-error flow_required');
	        		component.set("v.closingTimeError", false);
	        		isError = false;	        		
	        	}
	        	if( (openingTime != "" || openingTime != null) && (closingTime != "" || closingTime != null) && (closingTime <= openingTime) ) {
	        		/* --------- CLASS OF ERRORS ---------- */
		        	$A.util.addClass(component.find("closingTime"), 'slds-has-error flow_required');
		        	/* --------- BOOLEAN TO SET ERROR --------- */
		        	component.set("v.closingTimeError", true);
		        	/* --------- STRING CONTAINIG ERROR MESSAGE --------- */
		        	component.set("v.closingTimeErrorMessage", $A.get("$Label.c.OB_EndTimeGreater"));
		        	console.log("closingMinorThanopening");
		        	isError = true;
	        	} else if( (openingTime != "" || openingTime != null) && (closingTime != "" || closingTime != null) && (closingTime > openingTime) ) {
	        		$A.util.removeClass(component.find("openingTime") , 'slds-has-error flow_required');
	        		$A.util.removeClass(component.find("closingTime") , 'slds-has-error flow_required');
	        		component.set("v.openingTimeError", false);
	        		component.set("v.closingTimeError", false);
	        		isError = false;
	        	}
	        } else {
	        	console.log('firstCoupleNotEmpty false' + firstCoupleNotEmpty);
	        	$A.util.removeClass(component.find("openingTime") , 'slds-has-error flow_required');
        		$A.util.removeClass(component.find("closingTime") , 'slds-has-error flow_required');
        		component.set("v.openingTimeError", false);
        		component.set("v.closingTimeError", false);
        		component.set("v.openingTimeRequired", false);
	        	component.set("v.endingTimeRequired", false);
        		isError = false;
	        }
	        
	        if(secondCoupleNotEmpty) {
	        	if(breakStartTime == null || breakStartTime == "") {
	        		component.set("v.breakStartTimeRequired"	, true);
	        		component.set("v.breakEndTimeRequired"		, true);
	        		/* --------- CLASS OF ERRORS ---------- */
		    		$A.util.addClass(component.find("breakStartTime"), 'slds-has-error flow_required');
		    		component.set("v.breakStartTimeError", true);
		    		component.set("v.breakStartTimeErrorMessage", $A.get("$Label.c.MandatoryField"));
		    		isError = true;
		    		console.log("breakstart is empty");
	        	} else if(breakStartTime != null && breakStartTime != "") {
	        		$A.util.removeClass(component.find("breakStartTime") , 'slds-has-error flow_required');
					//$A.util.removeClass(component.find("breakEndTime") , 'slds-has-error flow_required');
					component.set("v.breakStartTimeError", false);
					//component.set("v.breakEndTimeError", false);
					isError = false;
	        	}
	        	if(breakEndTime == null || breakEndTime == "") {
	        		component.set("v.breakStartTimeRequired"	, true);
		    	   	component.set("v.breakEndTimeRequired"	, true);
		    		/* --------- CLASS OF ERRORS ---------- */
		    		$A.util.addClass(component.find("breakEndTime"), 'slds-has-error flow_required');
		    		component.set("v.breakEndTimeError", true);
		    		component.set("v.breakEndTimeErrorMessage", $A.get("$Label.c.MandatoryField"));
		    		console.log("breakEnd is Empty");
		    		isError = true;
	        	} else if(breakEndTime != null || breakEndTime != "") {
					$A.util.removeClass(component.find("breakEndTime") , 'slds-has-error flow_required');
					component.set("v.breakEndTimeError", false);
					isError = false;
	        	}
	        	if( (breakStartTime != null || breakStartTime != "") && (breakEndTime != null || breakEndTime != "") && ( breakEndTime <= breakStartTime )	){
	        		/* SET "*" ON REQUIRED FIELDS*/
	    	   		component.set("v.breakStartTimeRequired"	, true);
		    	   	component.set("v.breakEndTimeRequired"	, true);
		    	
		    		/* --------- CLASS OF ERRORS ---------- */
		    		$A.util.addClass(component.find("breakEndTime"), 'slds-has-error flow_required');
		    		component.set("v.breakEndTimeError", true);
		    		component.set("v.breakEndTimeErrorMessage", $A.get("$Label.c.OB_BreakTimeIncoherent"));
		    		console.log("breakEnd is maor than closing");
		    		isError = true;
	        	} else if((breakStartTime != null || breakStartTime != "") && (breakEndTime != null || breakEndTime != "") && ( breakEndTime <= breakStartTime ) ){
					$A.util.removeClass(component.find("breakEndTime") , 'slds-has-error flow_required');
					component.set("v.breakEndTimeError", false);
					isError = false;
	        	}
	        	if( (closingTime != null || closingTime!= "") && (breakEndTime >= closingTime) ) {
	        		/* SET "*" ON REQUIRED FIELDS*/
	    	   		component.set("v.breakStartTimeRequired"	, true);
		    	   	component.set("v.breakEndTimeRequired"	, true);
	        		/* --------- CLASS OF ERRORS ---------- */
		    		$A.util.addClass(component.find("breakEndTime"), 'slds-has-error flow_required');
		    		component.set("v.breakEndTimeError", true);
		    		component.set("v.breakEndTimeErrorMessage", $A.get("$Label.c.OB_BreakTimeIncoherent"));
		    		console.log("breakEnd is major than closing");   
		    		isError = true;
	        	} else if ( (closingTime != null || closingTime!= "") && (breakEndTime < closingTime)) {
//	        		$A.util.removeClass(component.find("breakStartTime") , 'slds-has-error flow_required');
					$A.util.removeClass(component.find("breakEndTime") , 'slds-has-error flow_required');
//					component.set("v.breakStartTimeError", false);
					component.set("v.breakEndTimeError", false);
					isError = false;
	        	}
	        	
	        	if( (breakStartTime != null || breakStartTime != "") && (breakEndTime != null || breakEndTime != "") && breakStartTime >= breakEndTime ) {
	        		console.log('breakStartTime minor than openingTime');
	        		component.set("v.breakStartTimeRequired"	, true);
		    	   	component.set("v.breakEndTimeRequired"	, true);
		        	/* --------- CLASS OF ERRORS ---------- */
		    		$A.util.addClass(component.find("breakEndTime"), 'slds-has-error flow_required');
		    		component.set("v.breakEndTimeError", true);
		    		component.set("v.breakEndTimeErrorMessage", $A.get("$Label.c.OB_BreakTimeIncoherent"));
		    		isError = true;
	        	}
	        } else if(!secondCoupleNotEmpty) {
	        	console.log('secondCoupleNotEmpty is: ' + secondCoupleNotEmpty);
        		$A.util.removeClass(component.find("breakStartTime") 	, 'slds-has-error flow_required');
        		$A.util.removeClass(component.find("breakEndTime") 		, 'slds-has-error flow_required');
        		component.set("v.breakStartTimeError", false);
				component.set("v.breakEndTimeError", false);
        		component.set("v.breakStartTimeRequired", false);
	        	component.set("v.breakEndTimeRequired", false);
        		isError = false;
	        }
	        if(firstCoupleNotEmpty && secondCoupleNotEmpty) {
	        	
	        	if( (openingTime != null && openingTime != "") && (breakStartTime != null || breakStartTime != "") && breakStartTime < openingTime) {
	        		component.set("v.breakStartTimeRequired"	, true);
		    	   	component.set("v.breakEndTimeRequired"	, true);
		        	/* --------- CLASS OF ERRORS ---------- */
		    		$A.util.addClass(component.find("breakEndTime"), 'slds-has-error flow_required');
		    		component.set("v.breakStartTimeError", true);
		    		component.set("v.breakStartTimeErrorMessage", $A.get("$Label.c.OB_BreakTimeIncoherent"));
		    		isError = true;
	        	} else if( (openingTime != null && openingTime != "") && breakStartTime > openingTime) {
	        		console.log('secondCoupleNotEmpty is: ' + secondCoupleNotEmpty);
	        		$A.util.removeClass(component.find("breakStartTime") 	, 'slds-has-error flow_required');
	        		$A.util.removeClass(component.find("breakEndTime") 		, 'slds-has-error flow_required');
	        		component.set("v.breakStartTimeError", false);
					component.set("v.breakEndTimeError", false);
	        		component.set("v.breakStartTimeRequired", false);
		        	component.set("v.breakEndTimeRequired", false);
	        		isError = false;
	        	}
	        	if(breakStartTime == null || breakStartTime == "") {
	        		component.set("v.breakStartTimeRequired"	, true);
	        		component.set("v.breakEndTimeRequired"		, true);
	        		/* --------- CLASS OF ERRORS ---------- */
		    		$A.util.addClass(component.find("breakStartTime"), 'slds-has-error flow_required');
		    		component.set("v.breakStartTimeError", true);
		    		component.set("v.breakStartTimeErrorMessage", $A.get("$Label.c.MandatoryField"));
		    		isError = true;
		    		console.log("breakstart is empty");
	        	} else if(breakStartTime != null && breakStartTime != "") {
	        		$A.util.removeClass(component.find("breakStartTime") , 'slds-has-error flow_required');
					//$A.util.removeClass(component.find("breakEndTime") , 'slds-has-error flow_required');
					component.set("v.breakStartTimeError", false);
					//component.set("v.breakEndTimeError", false);
					isError = false;
	        	}
	        	if(breakEndTime == null || breakEndTime == "") {
	        		component.set("v.breakStartTimeRequired"	, true);
		    	   	component.set("v.breakEndTimeRequired"	, true);
		    		/* --------- CLASS OF ERRORS ---------- */
		    		$A.util.addClass(component.find("breakEndTime"), 'slds-has-error flow_required');
		    		component.set("v.breakEndTimeError", true);
		    		component.set("v.breakEndTimeErrorMessage", $A.get("$Label.c.MandatoryField"));
		    		console.log("breakEnd is Empty");
		    		isError = true;
	        	} else if(breakEndTime != null || breakEndTime != "") {
					$A.util.removeClass(component.find("breakEndTime") , 'slds-has-error flow_required');
					component.set("v.breakEndTimeError", false);
					isError = false;
	        	}
	        	if( (breakStartTime != null || breakStartTime != "") && (breakEndTime != null || breakEndTime != "") && ( breakEndTime <= breakStartTime )	){
	        		/* SET "*" ON REQUIRED FIELDS*/
	    	   		component.set("v.breakStartTimeRequired"	, true);
		    	   	component.set("v.breakEndTimeRequired"	, true);
		    	
		    		/* --------- CLASS OF ERRORS ---------- */
		    		$A.util.addClass(component.find("breakEndTime"), 'slds-has-error flow_required');
		    		component.set("v.breakEndTimeError", true);
		    		component.set("v.breakEndTimeErrorMessage", $A.get("$Label.c.OB_BreakTimeIncoherent"));
		    		console.log("breakEnd is maor than closing");
		    		isError = true;
	        	} else if((breakStartTime != null || breakStartTime != "") && (breakEndTime != null || breakEndTime != "") && ( breakEndTime <= breakStartTime ) ){
					$A.util.removeClass(component.find("breakEndTime") , 'slds-has-error flow_required');
					component.set("v.breakEndTimeError", false);
					isError = false;
	        	}
	        	if( (closingTime != null || closingTime!= "") && (breakEndTime >= closingTime) ) {
	        		/* SET "*" ON REQUIRED FIELDS*/
	    	   		component.set("v.breakStartTimeRequired"	, true);
		    	   	component.set("v.breakEndTimeRequired"	, true);
	        		/* --------- CLASS OF ERRORS ---------- */
		    		$A.util.addClass(component.find("breakEndTime"), 'slds-has-error flow_required');
		    		component.set("v.breakEndTimeError", true);
		    		component.set("v.breakEndTimeErrorMessage", $A.get("$Label.c.OB_BreakTimeIncoherent"));
		    		console.log("breakEnd is major than closing");   
		    		isError = true;
	        	} else if ( (closingTime != null || closingTime!= "") && (breakEndTime < closingTime)) {
//	        		$A.util.removeClass(component.find("breakStartTime") , 'slds-has-error flow_required');
					$A.util.removeClass(component.find("breakEndTime") , 'slds-has-error flow_required');
//					component.set("v.breakStartTimeError", false);
					component.set("v.breakEndTimeError", false);
					isError = false;
	        	}
	        	
	        	if( (breakStartTime != null || breakStartTime != "") && (breakEndTime != null || breakEndTime != "") && breakStartTime >= breakEndTime ) {
	        		console.log('breakStartTime minor than openingTime');
	        		component.set("v.breakStartTimeRequired"	, true);
		    	   	component.set("v.breakEndTimeRequired"	, true);
		        	/* --------- CLASS OF ERRORS ---------- */
		    		$A.util.addClass(component.find("breakEndTime"), 'slds-has-error flow_required');
		    		component.set("v.breakEndTimeError", true);
		    		component.set("v.breakEndTimeErrorMessage", $A.get("$Label.c.OB_BreakTimeIncoherent"));
		    		isError = true;
				}
				/*-- START -- 01/02/2019 Simone Misani, validations on start/end break time*/
				if( (breakStartTime != null || breakStartTime != "") && (openingTime != null || openingTime != "") && breakStartTime <= openingTime ) {
					console.log('breakStartTime minor than openingTime');
      				component.set("v.breakStartTimeRequired"	, true);
		    	   	component.set("v.breakEndTimeRequired"	, true);
					/* --------- CLASS OF ERRORS ---------- */
					$A.util.addClass(component.find("breakStartTime"), 'slds-has-error flow_required');
					component.set("v.breakStartTimeError", true);
					component.set("v.breakStartTimeErrorMessage", $A.get("$Label.c.OB_BreakTimeIncoherent"));
					isError = true;
				}

				if( (breakEndTime != null || breakEndTime != "") && (closingTime != null || closingTime != "") && breakEndTime >= closingTime ) {
					console.log('breakStartTime minor than openingTime');
      				component.set("v.breakStartTimeRequired"	, true);
		    	   	component.set("v.breakEndTimeRequired"	, true);
					/* --------- CLASS OF ERRORS ---------- */
					$A.util.addClass(component.find("breakEndTime"), 'slds-has-error flow_required');
					component.set("v.breakEndTimeError", true);
					component.set("v.breakEndTimeErrorMessage", $A.get("$Label.c.OB_BreakTimeIncoherent"));
					isError = true;
				}
				/*-- END -- 01/02/2019 Simone Misani, validations on start/end break time */


	        	



//				console.log('secondCoupleNotEmpty is: ' + secondCoupleNotEmpty);
//        		$A.util.removeClass(component.find("breakStartTime") 	, 'slds-has-error flow_required');
//        		$A.util.removeClass(component.find("breakEndTime") 		, 'slds-has-error flow_required');
//        		
//	        	$A.util.removeClass(component.find("openingTime") , 'slds-has-error flow_required');
//        		$A.util.removeClass(component.find("closingTime") , 'slds-has-error flow_required');
//        		
//        		component.set("v.openingTimeTimeError", false);
//				component.set("v.closingTimeTimeError", false);
//				
//				component.set("v.breakStartTimeError", false);
//				component.set("v.breakEndTimeError", false);
//				
//				component.set("v.openingTimeRequired", false);
//	        	component.set("v.endingTimeRequired", false);
//	        	
//        		component.set("v.breakStartTimeRequired", false);
//	        	component.set("v.breakEndTimeRequired", false);
//        		isError = false;	
	        
	        
	        
	        	        	/*openingTime 
	        	console.log("openingTime is Empty");
	        	// SETTING "*" ON INPUT 
	        	component.set("v.openingTimeRequired", true);
	        	component.set("v.endingTimeRequired", true);
	        	/* --------- CLASS OF ERRORS ---------- */
	//    		$A.util.addClass(component.find("openingTime"), 'slds-has-error flow_required');
	//    		component.set("v.openingTimeError", true);
	//    		component.set("v.openingTimeErrorMessage", $A.get("$Label.c.MandatoryField"));
	//    		isError = true;
	
	        	/*closingTime 
	    		component.set("v.openingTimeRequired", true);
	        	component.set("v.endingTimeRequired", true);
	    		$A.util.addClass(component.find("closingTime"), 'slds-has-error flow_required');
	        	component.set("v.closingTimeError", true);
	        	component.set("v.closingTimeErrorMessage", $A.get("$Label.c.MandatoryField"));
	        	console.log("2o case");
	        	isError = true;*/
	
	        	/*breakStartTime 
		   		component.set("v.breakStartTimeRequired"	, true);
	    	   	component.set("v.breakEndTimeRequired"	, true);
	    		$A.util.addClass(component.find("breakStartTime"), 'slds-has-error flow_required');
	    		component.set("v.breakStartTimeError", true);
	    		component.set("v.breakStartTimeErrorMessage", $A.get("$Label.c.MandatoryField"));
	    		isError = true;
	    		console.log("breakStart is empty");/*
	        	
	        	
	        	breakEndTime
				component.set("v.breakStartTimeRequired"	, true);
	    	   	component.set("v.breakEndTimeRequired"	, true);
	        	/* --------- CLASS OF ERRORS ---------- */
	    		//$A.util.addClass(component.find("breakEndTime"), 'slds-has-error flow_required');
	    		//component.set("v.breakEndTimeError", true);
	    		//component.set("v.breakEndTimeErrorMessage", $A.get("$Label.c.MandatoryField"));
	    		//isError = true;
	    		//console.log("breakEnd is empty");






//        
///* ----------------------------------------------------------------------------------------------- */
//        /* --------------		SECOND LOGIC ON BREAK TIME INPUT 		------------------ */
///* ----------------------------------------------------------------------------------------------- */        
//         
//        if(secondCoupleNotEmpty){
//        	/* SET "*" ON REQUIRED FIELDS*/
//    	   component.set("v.breakStartTimeRequired"	, true);
//    	   component.set("v.breakEndTimeRequired"	, true);
//    	   
//    	   switch(true){
//    	   	case (breakStartTime == null || breakStartTime == ""):
//	    	   	/* SET "*" ON REQUIRED FIELDS*/
//    	   		component.set("v.breakStartTimeRequired"	, true);
//	    	   	component.set("v.breakEndTimeRequired"	, true);
//	        	/* --------- CLASS OF ERRORS ---------- */
//        		$A.util.addClass(component.find("breakStartTime"), 'slds-has-error flow_required');
//        		component.set("v.breakStartTimeError", true);
//        		component.set("v.breakStartTimeErrorMessage", $A.get("$Label.c.MandatoryField"));
//        		isError = true;
//        		console.log("breakStart is empty");
//        		break;
//    	   	
//    	   	case (breakEndTime == null || breakEndTime == ""):
//    	   		/* SET "*" ON REQUIRED FIELDS*/
//    	   		component.set("v.breakStartTimeRequired"	, true);
//	    	   	component.set("v.breakEndTimeRequired"	, true);
//	        	/* --------- CLASS OF ERRORS ---------- */
//        		$A.util.addClass(component.find("breakEndTime"), 'slds-has-error flow_required');
//        		component.set("v.breakEndTimeError", true);
//        		component.set("v.breakEndTimeErrorMessage", $A.get("$Label.c.MandatoryField"));
//        		isError = true;
//        		console.log("breakEnd is empty");
//        		
//        		break;
//        		
//        		
//        	case (( openingTime != null || openingTime != "") && breakStartTime <= openingTime):
//        		/* SET "*" ON REQUIRED FIELDS*/
//    	   		component.set("v.breakStartTimeRequired"	, true);
//	    	   	component.set("v.breakEndTimeRequired"	, true);
//        		
//	        	/* --------- CLASS OF ERRORS ---------- */
//	    		$A.util.addClass(component.find("breakStartTime"), 'slds-has-error flow_required');
//	    		component.set("v.breakStartTimeError", true);
//	    		component.set("v.breakStartTimeErrorMessage", $A.get("$Label.c.OB_BreakTimeIncoherent"));
//	    		console.log("breakStart minor than opening or breakStart major thank breakEndTime");
//	    		isError = true;
//	    		
//	    		break;
//        	
//        	case ((closingTime != null || closingTime!= "") && breakEndTime >= closingTime):
//        		/* SET "*" ON REQUIRED FIELDS*/
//    	   		component.set("v.breakStartTimeRequired"	, true);
//	    	   	component.set("v.breakEndTimeRequired"	, true);
//        		
//        		/* --------- CLASS OF ERRORS ---------- */
//	    		$A.util.addClass(component.find("breakEndTime"), 'slds-has-error flow_required');
//	    		component.set("v.breakEndTimeError", true);
//	    		component.set("v.breakEndTimeErrorMessage", $A.get("$Label.c.OB_BreakTimeIncoherent"));
//	    		console.log("breakEnd is maor than closing");
//	    		isError = true;
//	    		
//	    		break;
//	    		
//	    	case ( (breakStartTime != "" && breakEndTime != "") && ( breakEndTime <=  breakStartTime ) ):
//	    		/* SET "*" ON REQUIRED FIELDS*/
//    	   		component.set("v.breakStartTimeRequired"	, true);
//	    	   	component.set("v.breakEndTimeRequired"	, true);
//	    	
//	    		/* --------- CLASS OF ERRORS ---------- */
//	    		$A.util.addClass(component.find("breakEndTime"), 'slds-has-error flow_required');
//	    		component.set("v.breakEndTimeError", true);
//	    		component.set("v.breakEndTimeErrorMessage", $A.get("$Label.c.OB_BreakTimeIncoherent"));
//	    		console.log("breakEnd is maor than closing");
//	    		isError = true;
//	    		
//	    		break;
//	    		
//    	   	default:
//		   		$A.util.removeClass(component.find("breakStartTime") , 'slds-has-error flow_required');
//				$A.util.removeClass(component.find("breakEndTime") , 'slds-has-error flow_required');
//				component.set("v.breakStartTimeError", false);
//				component.set("v.breakEndTimeError", false);
//				isError = false;
//				
//				break;
//			    }
//			}
	        

			console.log(" Does time have an error? : " + isError);
			if(!isError){
				component.set("v.timesHaveError", false);
				
				if(openingTime != "" && closingTime != ""){
					component.set("v.openingTimeValue", 	openingTime);
					component.set("v.closingTimeValue", 	closingTime);

					
					console.log("openingTime is: " + 		component.get("v.openingTimeValue"));
					console.log("closingTime is: " + 		component.get("v.closingTimeValue"));
				} else {
					component.set("v.openingTimeValue", objectDataMap.pv.OB_Opening_Time__c);
				    component.set("v.closingTimeValue", objectDataMap.pv.OB_Ending_Time__c);
				    
				}
				if(breakStartTime != "" && breakEndTime != "") {
					component.set("v.breakStartTimeValue", 	breakStartTime);
					component.set("v.breakEndTimeValue", 	breakEndTime);

					console.log("breakStartTime is: " + 	component.get("v.breakStartTimeValue"));
					console.log("breakEndTime is: " + 		component.get("v.breakEndTimeValue"));
				} else {
					component.set("v.breakStartTimeValue", objectDataMap.pv.OB_Break_Start_Time__c);
					component.set("v.breakEndTimeValue", objectDataMap.pv.OB_Break_End_Time__c);
				}
			} else {
				component.set("v.timesHaveError", true);
				/* --------- DISABLE SAVE BUTTON --------- */
//				var saveButton = component.find("save");
//				console.log("save is: " + saveButton);
//				if(typeof(saveButton) !== undefined) {
//					component.find("save").set("v.disabled", true);
//					saveButton.set("v.disabled",true);
//					console.log("SONO IN ERRORE");
				}
				
//				var firstCoupleNull 	= (openingTime 		==  null || openingTime 		==  "") 	&& 		(closingTime == null || closingTime == "");
//				var secondCoupleNull 	= (breakStartTime 	== null  || breakStartTime 	== "") 	&& 		(breakEndTime == null || breakEndTime == null);
//				if(firstCoupleNull) {
//					console.log("@@@@@@@@@@@ firstCoupleEmpty is true");
//					$A.util.removeClass(component.find("openingTime") , 'slds-has-error flow_required');
//		    		$A.util.removeClass(component.find("closingTime") , 'slds-has-error flow_required');
//		    		
//		    		component.set("v.openingTimeError", false);
//	        		component.set("v.closingTimeError", false);
//				}
//				if(secondCoupleNull) {
//					console.log("@@@@@@@@@@@ secondCoupleEmpty is true");
//					$A.util.removeClass(component.find("breakStartTime") , 'slds-has-error flow_required');
//					$A.util.removeClass(component.find("breakEndTime") , 'slds-has-error flow_required');
//					
//					component.set("v.breakStartTimeError", false);
//					component.set("v.breakEndTimeError", false);
//				} 
				
			}
        }
})