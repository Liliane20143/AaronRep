({
    doInit: function (component, event, helper) {
		console.log('sono nel doInit');
        component.invocationCallbacks = {}; 
        
        var action = component.get("c.getVFBaseURL");
        console.log('STO STAMPANDO LA ACTION NEL DOINIT PROXY '+ action);
        action.setStorable();
        action.setCallback(this, function (response) {
            var vfBaseURL = response.getReturnValue();
            console.log('vfBaseURL before cablatura proxy: '+vfBaseURL.toLowerCase());
            component.set("v.vfBaseURL",vfBaseURL.toLowerCase());
            console.log('vfBaseURL: '+vfBaseURL.toLowerCase());
            
            var topic = component.get("v.topic"); 

            //Test 
            
            const eventMethod = window.addEventListener ? 'addEventListener' : 'attachEvent';
            const messageEvent = eventMethod === 'attachEvent' ? 'onmessage' : 'message';
            
            // Listen to message from child window
            window.addEventListener(messageEvent, event => {
                console.log('Entrato Event: '+event.data);
                console.log('entrato nel listener');
                //console.log('topic'+topic);
                //console.log('origini'+event.origin);
                
                if (event.origin !== vfBaseURL) { 
                    console.log('event.origin !== vfBaseURL');
                    return;
                }
                // Only handle messages we are interested in
                if (event.data.topic === topic) {
                    console.log('event.data.topic === topic');
                    // Retrieve the callback for the specified invocation id
                    var callback = component.invocationCallbacks[event.data.invocationId];
                    
                    if (callback && typeof callback == 'function') {
                        console.log('callback && typeof callback');
                        callback(event.data.result);
                        delete component.invocationCallbacks[event.data.invocationId];
                    }
                }
                
            }, false);

        });
        $A.enqueueAction(action);
    },

    doInvoke: function (component, event, helper) {
        console.log("frame id is: " + component.find("vfFrame").getElement());
        var vfBaseURL = component.get("v.vfBaseURL");
        var topic = component.get("v.topic");
        var args = event.getParam('arguments');
        console.log('SONO NEL DOINVOKE VOGLIO STAMPARE I PARAMETRI PROXY : '+JSON.stringify(args));
        var invocationId = helper.getUniqueId();
        console.log('HELPER CHIAMATA PER UNICO ID'+invocationId);
        console.log('HELPER CHIAMATA PER args.callback'+args.callback);
        component.invocationCallbacks[invocationId] = args.callback;
        var message = {
            topic: topic,
            invocationId: invocationId,
            methodName: args.methodName,
            methodParams: args.methodParams
        };
        console.log('MESSAGE: '+JSON.stringify(message)+' vfBaseURL: '+vfBaseURL);

        // component.find("vfFrame").getElement().contentWindow.postMessage(message, vfBaseURL);
        //  var vf = component.find("vfFrame").getElement();
        var obj = JSON.parse(JSON.stringify(message));
        //parent.postMessage(obj, 'whatever');
            /*****GIOVANNI SPINELLI   11/09/2018    START*****/
            /*****TRY CATCH TO CONTROL  SUCCEEDING CALL FROM SERVICE*****/
            /*****IF SOMETHING DOESN'T WORK, DELETE THE TRY CATCH IN OB_ContinuationProxyCompenentControlleer*****/
             

            try 
            {
                component.set("v.message", obj);
                
                // document.getElementById("vfFrame").contentWindow.postMessage(obj, "https://nexi-payments--dev1.lightning.force.com");
                var vfWindow    =   component.find("vfFrame").getElement().contentWindow;
                console.log(vfWindow);
                                           

                setTimeout(function(){
                    vfWindow.postMessage(obj, vfBaseURL);
                },1000);
                
            }
            catch(err) 
            {
                console.log('err.message: ' + err.message);
                component.set("v.message", obj); 
                component.find("vfFrame").innerHTML = err.message;
            }
            /*****GIOVANNI SPINELLI   11/09/2018    END*****/

           
        //vf.postMessage(message, vfBaseURL);
    }
})