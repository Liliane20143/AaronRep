@isTest
global class MockGeneratorOB_UtilityCallingServices implements HttpCalloutMock 
{
	
    global static HTTPResponse respond(HTTPRequest req) 
    {        
    	// Create a fake response
    	HttpResponse res = new HttpResponse();
    	res.setHeader('Content-Type', 'text/xml');
    	res.setBody('{"access_token":"eyJ0eXAiOiJKV1QiLCJjdHkiOiJKV1QiLCJhbGciOiJkaXIiLCJlbmMiOiJBMTI4Q0JDLUhTMjU2In0..hxBlok5mj8kgmKAL2_vFvg.MoeN6WM19lzmTQjCWV7jvF86keiHCvl2BlYAPdp5dHCV5a4Iwsc5iISOhampRVi95u5uqGWwo1xd9DUxXvZHTyeS7BZsFzux9OCgEQP-Refq3hIDrdSezq48aiKlZSREj00DJApiu9mKbhdQ06yw4W0yiBdbEQxpCBFkt9BQMfmnFiazLbNMBhKxUPgJJWgiqIurZATVD9LUjWjwMb3dcFiykUn6KJ2jg_X5b6G5dbkm3CeElxlymCm8pBqopt34oXuSs0pMO8F4_0WKAFHoDYhewj2CsPwOBuB1MCx8WIEt56st2mgeFO0zNoce3Fh3sgTwE44N3RDBHsXW3uWUk71kmDDrV-ivmcWmoHJty3EneXh9imfspjkKyz-KJC2Sf9liKGaBW539dguIENajGS4feZcx30yn5vCn7H53FXydRyq2nDLCkJ0lyQWnKzEjEGLB5KxXsJiZzV5xYBY4aVvEQUQ_pufZ-lqE0NxT9WbL8CG69KvTSPiCPxOPL55cbsOuH9OHQGoyW7E3zzeHYm41ry5Z_pqVUYCoWuNzZ_RoqHU1FxthQ729ZAmBU9V6.q_SLSz3CYH8Tw95c0z2_nw",  "token_type":"Bearer",  "expires_in":3600,  "scope":"oob"}');
    	res.setStatusCode(200);
		res.setStatus('Test OK');//NEXI-88 Adrian Dlugolecki<adrian.dlugolecki@accenture.com>, 04/06/2019
    	return res;
	}
}