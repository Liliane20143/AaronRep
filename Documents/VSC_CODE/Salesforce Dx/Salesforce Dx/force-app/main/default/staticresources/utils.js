window._utils = ( function () {
    
    /*--------INSERT your Lightning Component Name preceded by a 'c' letter (cComponentName) 
      and the desidered Log Level for the respectively Lightning Component in the
           var componentLogLevel.
      
      N.B.: The levels are listed from highest to lowest in this way:
                               debug -> info -> warn -> error -> fatal
	        The level is cumulative, that means if you choose INFO the log also includes 
            all events logged at the WARN, ERROR and FATAL levels. 
     ----------------------------------------------------------------------------------------       
      Best practice: insert the following function in the Lightning Component
                     if you have an handler that calls the 'doInit' method.
      
      		setUp: function(component,event,helper){
				   _utils.logInit(component.getName());
            },
      -----------------------------------------
      Upload the Static Resource in the cmp in this way:
      
      <ltng:require scripts="{!$Resource.utils}" afterScriptsLoaded="{!c.setUp}"/>  
      ------------------------------------------
    */
    
    var componentLogLevel = {
        'cComponent1': 'debug',
        'cComponent2':'error',
        'cComponent3':'fatal',
        'cComponent4':'info',
        'cComponent5':'error',
        'cMyCounter':'warn',
        'cCreateNewContact':'info',
		'cOB_FlowCart' : 'debug',
		'cOB_SelectOffer':'debug',
		'cOB_ConfigurePOS':'debug',
		'cOB_childItem':'debug',
		'cOB_configureActivePOS':'debug',
		'cOB_newCartBancomat':'debug',
		'cOB_newCartAcquiring':'debug',
		'cOB_childitemACQ_PCI':'debug',
		'cOB_ConfigureVAS':'debug',
		'cOB_newCartPriceSummary':'debug',
		'cOB_TechDetailService' : 'debug',
		'cOB_singleAttachedDocumentations' : 'debug',
		'cOB_Maintenance_AttachedDocumentations' : 'debug'
    };
    
    
    //-------------------------------DO NOT TOUCH HERE----------------------------
    
    //We have declared our Log Level as functions.
   
    var _debug=function(){};
    var _info=function(){};
    var _warn=function(){};
    var _error=function(){};
    var _fatal=function(){};
    
    
    /*We have created an objectLogger variable with the Logger method.
      It represents an advanced console.log, that, for type of arguments that are object we convert in string by JSON.stringify,
      otherwise we use a normal console.log.*/
    
    var objectLogger = {
                
		Logger:  function () {
           
            for (var i=0; i<arguments.length; ++i){
                               
               if (typeof arguments[i] === 'object'){
                   arguments[i]=JSON.stringify(arguments[i]); 
               }
            }
            console.log.apply(console, arguments);
    	},
    };
    
    return { 
        
        /*LogInit function is used to call the setLogLevel function on the Lightning Components.
          It sets the respective Log Level for each Component, which you have set in the componentLogLevel variable.*/
          
    	logInit: function (ComponentName){
            
            if (componentLogLevel.hasOwnProperty(ComponentName)) {
                _utils.setLogLevel(componentLogLevel[ComponentName]);
        	} else {
                _utils.setLogLevel('NO LOG');
            }
  		 },
        
        
        //setLoglevel method binds the Loglevel chosen and the lowest ones, to the Logger function.

        setLogLevel: function (LogLevel){
                        
        	switch (LogLevel) {
                case 'debug': 
                    _debug= objectLogger.Logger.bind(objectLogger);
                case 'info': 
                    _info= objectLogger.Logger.bind(objectLogger);
                case 'warn': 
                    _warn= objectLogger.Logger.bind(objectLogger);
                case 'error': 
                    _error= objectLogger.Logger.bind(objectLogger);
                case 'fatal': 
                    _fatal= objectLogger.Logger.bind(objectLogger);
        	}
          
            
          //The following switch reset the LogLevels higher than the one chosen.
       
            switch (LogLevel) {
                case 'fatal':
                    _error= function(){};
                case 'error':
                    _warn=function(){};
                case 'warn':
                    _info=function(){}; 
                case 'info':
                    _debug =function(){};
                case 'debug': 
                       break;
                default:  
                     _debug=function(){};
  				     _info=function(){};
                     _warn=function(){};
    				 _error=function(){};
    		         _fatal=function(){};
            } 
                       
        },
        
       
        //The following functions associate each level to the _utils.(Loglevel) inserted in the controller.
                    
            debug: function(){
                _debug.apply(_debug,arguments);
            },
            info: function(){
                _info.apply(_info,arguments);
            },
        	warn: function(){
                _warn.apply(_warn,arguments);
            },
    		error: function(){
                _error.apply(_error,arguments);
            },
    		fatal: function(){
                _fatal.apply(_fatal,arguments);
            },
    };
}());