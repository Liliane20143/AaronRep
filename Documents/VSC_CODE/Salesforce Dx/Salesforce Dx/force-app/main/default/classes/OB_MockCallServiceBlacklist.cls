@isTest
global class OB_MockCallServiceBlacklist implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req) 
    {        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'text/xml');
                res.setStatus('Created');

        //res.setBody('{"access_token":"eyJ0eXAiOiJKV1QiLCJjdHkiOiJKV1QiLCJhbGciOiJkaXIiLCJlbmMiOiJBMTI4Q0JDLUhTMjU2In0..hxBlok5mj8kgmKAL2_vFvg.MoeN6WM19lzmTQjCWV7jvF86keiHCvl2BlYAPdp5dHCV5a4Iwsc5iISOhampRVi95u5uqGWwo1xd9DUxXvZHTyeS7BZsFzux9OCgEQP-Refq3hIDrdSezq48aiKlZSREj00DJApiu9mKbhdQ06yw4W0yiBdbEQxpCBFkt9BQMfmnFiazLbNMBhKxUPgJJWgiqIurZATVD9LUjWjwMb3dcFiykUn6KJ2jg_X5b6G5dbkm3CeElxlymCm8pBqopt34oXuSs0pMO8F4_0WKAFHoDYhewj2CsPwOBuB1MCx8WIEt56st2mgeFO0zNoce3Fh3sgTwE44N3RDBHsXW3uWUk71kmDDrV-ivmcWmoHJty3EneXh9imfspjkKyz-KJC2Sf9liKGaBW539dguIENajGS4feZcx30yn5vCn7H53FXydRyq2nDLCkJ0lyQWnKzEjEGLB5KxXsJiZzV5xYBY4aVvEQUQ_pufZ-lqE0NxT9WbL8CG69KvTSPiCPxOPL55cbsOuH9OHQGoyW7E3zzeHYm41ry5Z_pqVUYCoWuNzZ_RoqHU1FxthQ729ZAmBU9V6.q_SLSz3CYH8Tw95c0z2_nw",  "token_type":"Bearer",  "expires_in":3600,  "scope":"oob"}');
        res.setBody('{"result": {"code": "0","description": "OK"},"blacklist": [{ "reportingEntityABI": "80006", "agreementId": "000000005646654", "companyName": "MARITAN ARMANDO", "companySignBoard": "CARROZZERIA SAN GIUSEPPE", "reportingDateStart": "2014-01-24", "reportingDateEnd": "2017-01-24", "reportCode": "PVREV", "reportType": "I", "signalReasonCode": "02", "signalReason": "COINVOLGIMENTO ESERCENTE IN ATTIVITA CHE LA SOCIETA SEGNALANTE HA RITENUTO ESSERE SOSPETTE, IN BASE A VERIFICHE O CONTROLLI O RISCONTRI DA ESSA STESSA EFFETTUATI" }],"fraudReportList":[{"reportingEntityABI": "80006","agreementId": "000000005646654","companyName": "MARITAN ARMANDO","companySignBoard": "CARROZZERIA SAN GIUSEPPE","reportingDateStart": "2014-01-24","reportingDateEnd": "2017-01-24","reportCode": "PVREV","reportType": "I","signalReasonCode": "02","signalReason": "COINVOLGIMENTO ESERCENTE IN ATTIVITA CHE LA SOCIETA SEGNALANTE HA RITENUTO ESSERE SOSPETTE, IN BASE A VERIFICHE O CONTROLLI O RISCONTRI DA ESSA STESSA EFFETTUATI"},{"reportingEntityABI": "03141","agreementId": "000373658700003","companyName": "CARROZZERIA SAN GIUSEPPE","companySignBoard": "CARROZZERIA SAN GIUSEPPE","reportingDateStart": "2014-03-06","reportingDateEnd": "2017-03-06","reportCode": "PVREV","reportType": "I","signalReasonCode": "04","signalReason": "RICEZIONE DI COMUNICAZIONE, PROVENIENTE DA ALTRE SOCIETA CHE EMETTONO O GESTISCONO CARTE DI PAGAMENTO, CONCERNENTE L INOSSERVANZA COLPOSA O DOLOSA DELL ESERCENTE ALLE NORME CHE REGOLANO L ACCETTAZIONE IN PAGAMENTO DELLE CARTE"}]}');
        res.setStatusCode(200);
        //OB_MockCallServiceBlacklist.responseReliability objBlackList = (OB_MockCallServiceBlacklist.responseReliability)JSON.deserialize(res.getBody(),OB_MockCallServiceBlacklist.responseReliability.class);
        return res;
    }

    global class responseReliability
    {
        global result result;
        global List<Map<String,String>> fraudReportList;
        global List<Map<String,String>> blacklist;
    }
    
    /*Wrapper Object inside Reliability*/
    global class result
    {
        global String code;
        global String description;
    }
    
}