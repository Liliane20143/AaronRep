@isTest
public class OB_RedirectPageFlow_Test {
    /*******************************************************************************
       Purpose:  Method tests OB_RedirectPageFlow constructor, test is only covered when user has FullPhotoUrl, checking prop isCommunity when object is ready.
       Parameters: -
       Returns: -
       History
       --------
       VERSION     AUTHOR                  DATE            DETAIL          Description
       1.0      Michał Targiel           18/06/2019        Created             ---
       ********************************************************************************/
    @isTest(SeeAllData=true)
    public static void OB_RedirectPageFlow_CC_Test(){

        List<User> u = [ SELECT Id, FullPhotoUrl, Name
        FROM User
        WHERE FullPhotoUrl != null LIMIT 1];


        System.runAs(u.get(0)){
            Test.startTest();
            OB_RedirectPageFlow_CC a=new OB_RedirectPageFlow_CC();
            Test.stopTest();

            System.assert(a.isCommunity);
        }
    }

}