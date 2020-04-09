@isTest
global class MockGetCadastrialCode implements HttpCalloutMock 
{
	global HTTPResponse respond(HTTPRequest req) 
    {
		HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('[{ "Candidati": [ { "name": "cand1", "Arricchito": { "CodCF": "AAAAAA11A11A111A" } }, { "name": "cand2", "Arricchito": { "CodCF": "AAAAAA11A11A111A" } } ] }]');
        res.setStatusCode(200);
        return res;
    }
}