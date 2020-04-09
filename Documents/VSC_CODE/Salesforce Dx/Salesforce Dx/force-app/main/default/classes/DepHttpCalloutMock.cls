/**
 * Created by ripagano on 22/04/2018.
 */

global class DepHttpCalloutMock implements HttpCalloutMock {
  global HTTPResponse respond(HTTPRequest request) {
    // Create a fake response
    HttpResponse response = new HttpResponse();
    response.setHeader('Content-Type', 'application/json');
    response.setBody('{ "controllerValues" : { }, "defaultValue" : null, "url" : "/services/data/v42.0/ui-api/object-info/Account/picklist-values/0121r000000nKeXAAU/Type", "values" : [ { "attributes" : null, "label" : "Prospect", "validFor" : [ ], "value" : "Prospect" }, { "attributes" : null, "label" : "Customer - Direct", "validFor" : [ ], "value" : "Customer - Direct" }, { "attributes" : null, "label" : "Customer - Channel", "validFor" : [ ], "value" : "Customer - Channel" }, { "attributes" : null, "label" : "Channel Partner / Reseller", "validFor" : [ ], "value" : "Channel Partner / Reseller" } ] }');
    response.setStatusCode(200);
    return response;
  }

}