rule ExecuteMethod {
	agenda-group:'Servizio_4';
	when{
		f1 : FieldProps f1.objectsData.unbind.UNBIND7 !='';
	}
	then{
		var methodArguments= {};
		methodArguments["validationClass"] = "CustomMerchantSave";
		methodArguments["method"] = "executeMethod";
		emit("executeMethod",methodArguments);
	}
}

rule NEXTRULE {
	agenda-group:'Cart_5';
	when{
		f1 : FieldProps f1.objectsData.unbind.nextCheck !='';
	}
	then{
		var methodArguments= {};
		methodArguments['stepToGo'] = 6;
		emit("goToStep",methodArguments);
	}
}

rule showSectionOne {
	agenda-group:'Titolare_Effettivo_9';
	when{
		f1 : FieldProps f1.objectsData.unbind.UNBIND6 !='' && f1.objectsData.unbind.UNBIND7 =='' 
        				&& f1.objectsData.unbind.UNBIND8 =='' && f1.objectsData.unbind.UNBIND9 =='' 
        				&& f1.objectsData.unbind.UNBIND10 =='' && f1.objectsData.unbind.UNBIND11 =='';
	}
	then{
		var sectionsToUpdate=[];
		sectionsToUpdate.push({step:"Titolare_Effettivo_9",sectionName:"Contact_1",sectionIndex:"1",property:"hidden",value:false});
		emit("updateSections",sectionsToUpdate);
		sectionsToUpdate.push({step:"Titolare_Effettivo_9",sectionName:"contact_2",sectionIndex:"2",property:"hidden",value:true});
		emit("updateSections",sectionsToUpdate);
		sectionsToUpdate.push({step:"Titolare_Effettivo_9",sectionName:"contact_3",sectionIndex:"3",property:"hidden",value:true});
		emit("updateSections",sectionsToUpdate);
        sectionsToUpdate.push({step:"Titolare_Effettivo_9",sectionName:"contact_4",sectionIndex:"4",property:"hidden",value:true});
		emit("updateSections",sectionsToUpdate);
        sectionsToUpdate.push({step:"Titolare_Effettivo_9",sectionName:"contact_5",sectionIndex:"5",property:"hidden",value:true});
		emit("updateSections",sectionsToUpdate);
        sectionsToUpdate.push({step:"Titolare_Effettivo_9",sectionName:"contact_6",sectionIndex:"6",property:"hidden",value:true});
		emit("updateSections",sectionsToUpdate);
	}
}

rule showSectionTwo {
	agenda-group:'Titolare_Effettivo_9';
	when{		
        f1 : FieldProps f1.objectsData.unbind.UNBIND7 !='' && f1.objectsData.unbind.UNBIND6 =='' 
        				&& f1.objectsData.unbind.UNBIND8 =='' && f1.objectsData.unbind.UNBIND9 ==''
        				&& f1.objectsData.unbind.UNBIND10 =='' && f1.objectsData.unbind.UNBIND11 =='';     
	}
	then{
		var sectionsToUpdate=[];
       	sectionsToUpdate.push({step:"Titolare_Effettivo_9",sectionName:"Contact_1",sectionIndex:"1",property:"hidden",value:true});
		emit("updateSections",sectionsToUpdate);
        sectionsToUpdate.push({step:"Titolare_Effettivo_9",sectionName:"contact_2",sectionIndex:"2",property:"hidden",value:false});
		emit("updateSections",sectionsToUpdate);
		sectionsToUpdate.push({step:"Titolare_Effettivo_9",sectionName:"contact_3",sectionIndex:"3",property:"hidden",value:true});
		emit("updateSections",sectionsToUpdate);
        sectionsToUpdate.push({step:"Titolare_Effettivo_9",sectionName:"contact_4",sectionIndex:"4",property:"hidden",value:true});
		emit("updateSections",sectionsToUpdate);
        sectionsToUpdate.push({step:"Titolare_Effettivo_9",sectionName:"contact_5",sectionIndex:"5",property:"hidden",value:true});
		emit("updateSections",sectionsToUpdate);
        sectionsToUpdate.push({step:"Titolare_Effettivo_9",sectionName:"contact_6",sectionIndex:"6",property:"hidden",value:true});
		emit("updateSections",sectionsToUpdate);

	}
}

rule showSectionThree {
	agenda-group:'Titolare_Effettivo_9';
	when{
		f1 : FieldProps f1.objectsData.unbind.UNBIND8 !='' && f1.objectsData.unbind.UNBIND6 ==''
        	 			&& f1.objectsData.unbind.UNBIND7 =='' && f1.objectsData.unbind.UNBIND9 ==''
        				&& f1.objectsData.unbind.UNBIND10 =='' && f1.objectsData.unbind.UNBIND11 =='';  
	}
	then{
		var sectionsToUpdate=[];
		sectionsToUpdate.push({step:"Titolare_Effettivo_9",sectionName:"contact_3",sectionIndex:"3",property:"hidden",value:false});
		emit("updateSections",sectionsToUpdate);
		sectionsToUpdate.push({step:"Titolare_Effettivo_9",sectionName:"Contact_1",sectionIndex:"1",property:"hidden",value:true});
		emit("updateSections",sectionsToUpdate);
		sectionsToUpdate.push({step:"Titolare_Effettivo_9",sectionName:"contact_2",sectionIndex:"2",property:"hidden",value:true});
		emit("updateSections",sectionsToUpdate);
        sectionsToUpdate.push({step:"Titolare_Effettivo_9",sectionName:"contact_4",sectionIndex:"4",property:"hidden",value:true});
		emit("updateSections",sectionsToUpdate);
        sectionsToUpdate.push({step:"Titolare_Effettivo_9",sectionName:"contact_5",sectionIndex:"5",property:"hidden",value:true});
		emit("updateSections",sectionsToUpdate);
        sectionsToUpdate.push({step:"Titolare_Effettivo_9",sectionName:"contact_6",sectionIndex:"6",property:"hidden",value:true});
		emit("updateSections",sectionsToUpdate);
	}
}

rule showSectionFour {
	agenda-group:'Titolare_Effettivo_9';
	when{
		f1 : FieldProps f1.objectsData.unbind.UNBIND9 !=''&& f1.objectsData.unbind.UNBIND7 ==''  
            			&& f1.objectsData.unbind.UNBIND8 =='' && f1.objectsData.unbind.UNBIND6 ==''
        				&& f1.objectsData.unbind.UNBIND10 =='' && f1.objectsData.unbind.UNBIND11 =='';
      
	}
	then{
		var sectionsToUpdate=[];
		sectionsToUpdate.push({step:"Titolare_Effettivo_9",sectionName:"contact_3",sectionIndex:"3",property:"hidden",value:true});
		emit("updateSections",sectionsToUpdate);
		sectionsToUpdate.push({step:"Titolare_Effettivo_9",sectionName:"Contact_1",sectionIndex:"1",property:"hidden",value:true});
		emit("updateSections",sectionsToUpdate);
		sectionsToUpdate.push({step:"Titolare_Effettivo_9",sectionName:"contact_2",sectionIndex:"2",property:"hidden",value:true});
		emit("updateSections",sectionsToUpdate);
        sectionsToUpdate.push({step:"Titolare_Effettivo_9",sectionName:"contact_4",sectionIndex:"4",property:"hidden",value:false});
		emit("updateSections",sectionsToUpdate);
        sectionsToUpdate.push({step:"Titolare_Effettivo_9",sectionName:"contact_5",sectionIndex:"5",property:"hidden",value:true});
		emit("updateSections",sectionsToUpdate);
        sectionsToUpdate.push({step:"Titolare_Effettivo_9",sectionName:"contact_6",sectionIndex:"6",property:"hidden",value:true});
		emit("updateSections",sectionsToUpdate);
	}
}

rule showSectionFive {
	agenda-group:'Titolare_Effettivo_9';
	when{
		f1 : FieldProps f1.objectsData.unbind.UNBIND10 !=''&& f1.objectsData.unbind.UNBIND7 ==''  
            			&& f1.objectsData.unbind.UNBIND8 =='' && f1.objectsData.unbind.UNBIND6 ==''
        				&& f1.objectsData.unbind.UNBIND9 =='' && f1.objectsData.unbind.UNBIND11 =='';
      
	}
	then{
		var sectionsToUpdate=[];
		sectionsToUpdate.push({step:"Titolare_Effettivo_9",sectionName:"contact_3",sectionIndex:"3",property:"hidden",value:true});
		emit("updateSections",sectionsToUpdate);
		sectionsToUpdate.push({step:"Titolare_Effettivo_9",sectionName:"Contact_1",sectionIndex:"1",property:"hidden",value:true});
		emit("updateSections",sectionsToUpdate);
		sectionsToUpdate.push({step:"Titolare_Effettivo_9",sectionName:"contact_2",sectionIndex:"2",property:"hidden",value:true});
		emit("updateSections",sectionsToUpdate);
        sectionsToUpdate.push({step:"Titolare_Effettivo_9",sectionName:"contact_4",sectionIndex:"4",property:"hidden",value:true});
		emit("updateSections",sectionsToUpdate);
        sectionsToUpdate.push({step:"Titolare_Effettivo_9",sectionName:"contact_5",sectionIndex:"5",property:"hidden",value:false});
		emit("updateSections",sectionsToUpdate);
        sectionsToUpdate.push({step:"Titolare_Effettivo_9",sectionName:"contact_6",sectionIndex:"6",property:"hidden",value:true});
		emit("updateSections",sectionsToUpdate);
	}
}

rule showSectionSix {
	agenda-group:'Titolare_Effettivo_9';
	when{
		f1 : FieldProps f1.objectsData.unbind.UNBIND11 !=''&& f1.objectsData.unbind.UNBIND7 ==''  
            			&& f1.objectsData.unbind.UNBIND8 =='' && f1.objectsData.unbind.UNBIND6 ==''
        				&& f1.objectsData.unbind.UNBIND9 =='' && f1.objectsData.unbind.UNBIND10 =='';
	}
	then{
		var sectionsToUpdate=[];
		sectionsToUpdate.push({step:"Titolare_Effettivo_9",sectionName:"contact_3",sectionIndex:"3",property:"hidden",value:true});
		emit("updateSections",sectionsToUpdate);
		sectionsToUpdate.push({step:"Titolare_Effettivo_9",sectionName:"Contact_1",sectionIndex:"1",property:"hidden",value:true});
		emit("updateSections",sectionsToUpdate);
		sectionsToUpdate.push({step:"Titolare_Effettivo_9",sectionName:"contact_2",sectionIndex:"2",property:"hidden",value:true});
		emit("updateSections",sectionsToUpdate);
        sectionsToUpdate.push({step:"Titolare_Effettivo_9",sectionName:"contact_4",sectionIndex:"4",property:"hidden",value:true});
		emit("updateSections",sectionsToUpdate);
        sectionsToUpdate.push({step:"Titolare_Effettivo_9",sectionName:"contact_5",sectionIndex:"5",property:"hidden",value:true});
		emit("updateSections",sectionsToUpdate);
        sectionsToUpdate.push({step:"Titolare_Effettivo_9",sectionName:"contact_6",sectionIndex:"6",property:"hidden",value:false});
		emit("updateSections",sectionsToUpdate);
	}
}




