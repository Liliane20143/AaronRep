@isTest
public class Plc_MockHttpResponseGeneratorTest {

    
    @isTest
    static void respondTest(){
    
     //Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        Plc_MockHttpResponseGenerator plc_MockHttpResponseGenerator=new Plc_MockHttpResponseGenerator();
        
        HttpRequest request=new HttpRequest();
        
        Test.startTest();
        HttpResponse res = plc_MockHttpResponseGenerator.respond(request);
    	Test.stopTest();
        
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '{"foo":"bar", "result": "true"}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());    
        
    }
}