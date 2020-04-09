/*******************************************************************************
Purpose:  Mockup class for call to Gianos (OB_Util009_Gianos)
Parameters: -
Returns: -

History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0         Adrian Dlugolecki       19/07/2019      Created         NEXI-202
********************************************************************************/
global with sharing class OB_Util009_Gianos_Mock implements HttpCalloutMock
{
    public static OB_Util009_Gianos.GianosResponse dataResponse;
    public static Integer statusCode;
    public static String status;
    global static HTTPResponse respond( HTTPRequest req )
    {
        HttpResponse res = new HttpResponse( );
        res.setHeader( 'Content-Type', 'text/xml' );
        res.setBody( JSON.serialize( dataResponse ) );
        res.setStatusCode( statusCode );
        res.setStatus( status );
        return res;
    }
}