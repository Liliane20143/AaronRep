@isTest
global class MockGetFileName implements HttpCalloutMock {


    global HTTPResponse respond(HTTPRequest req) {
         //Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
         res.setBody('{"fileName":"test.pdf","documentStream":"jhkjhkjhkjhkhaGIUGIWW3456789kdkssasja"}');
        res.setStatusCode(200);
        return res;
    }

}