/**
 * @author Abdoulaye & Moussa
 * @date Creation 28/12/2018
 * @version 1.0
 * @description Plc_MockHttpResponseGenerator implements HttpCalloutMock.
 */
public class Plc_MockHttpResponseGenerator implements HttpCalloutMock {
	// Implement this interface method

    /**
    * @author Abdoulaye & Moussa
    * @date Creation 28/12/2018
    * @version 1.0
    * @description generate the response
    * @param HTTPRequest req: it's the parameter of HTTPRequest
    * @return HttpResponse
    */
    public HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"foo":"bar", "result": "true"}');
        res.setStatusCode(200);
        return res;
    }
}