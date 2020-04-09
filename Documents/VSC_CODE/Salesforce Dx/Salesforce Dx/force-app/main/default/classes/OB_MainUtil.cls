/**
*@author Grzegorz Banach <grzegorz.banach@accenture.com>
*@date 19/03/2018
*@description Main utility class
*@history 19/03/2018 Method created
*/
public with sharing class OB_MainUtil
{
    /**
    *@author Grzegorz Banach <grzegorz.banach@accenture.com>
    *@date 19/03/2018
    *@description Method splits given String basing on delimiter and adds single quotes and comma to splitted values
    *@params String inString, String inRegexpDelimiter
    *@return String
    *@history 19/03/2019 Method created, 27/03/2019 refactor <joanna.mielczarek@accenture.com>
    */
    public static String explodeString( String inString, String inRegexpDelimiter )
    {
        if ( inString == null || inRegexpDelimiter == null )
        {
            return null;
        }

        List<String> splittedStrings = inString.split( inRegexpDelimiter );

        String stringWithSingleQuotes = '(';
        for ( Integer i = 0; i < splittedStrings.size( ); i++ )
        {
            stringWithSingleQuotes += '\'' + splittedStrings[i];
            stringWithSingleQuotes += ( i < splittedStrings.size( ) - 1 ) ? '\',' : '\'' ;
        }
        stringWithSingleQuotes += ')';
        return stringWithSingleQuotes;
    }
}