({	
    /*
    *@author francesca.ribezzi
    *@date 11/07/2019
    *@task fix dati operativi step (setup) performance
    *@description Method moved from OB_TechDetailService 
    *@history 11/07/2019 Method moved
    */
    generateTerminalId: function(component, event, helper) {	  
		  helper.callService(component, event); //francesca.ribezzi 30/07/19 adding event in order to use event.getSource()	- - WN-211	
	},
})