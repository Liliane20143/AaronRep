/*******************************************************************************
Purpose:  Mockup class for call to AVR/SOS (OB_Util009_AVRSOS)
Parameters: -
Returns: -

History
--------
VERSION     AUTHOR                  DATE            DETAIL          Description
1.0         Damian Krzyzaniak       19/07/2019      Created         NEXI-214
********************************************************************************/
global with sharing class OB_Util009_AVRSOS_Mock implements HttpCalloutMock
{
    public static OB_Util009_AVRSOS.AVRSOSResponse dataResponse;
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