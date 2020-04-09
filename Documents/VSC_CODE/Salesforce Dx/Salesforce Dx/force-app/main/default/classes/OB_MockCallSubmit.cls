@isTest
global class OB_MockCallSubmit implements HttpCalloutMock {
	
	    global HTTPResponse respond(HTTPRequest req) {        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'text/xml');
        res.setBody('');
        res.setStatus('Created');
        res.setStatusCode(201);
        return res;
    }
    
}