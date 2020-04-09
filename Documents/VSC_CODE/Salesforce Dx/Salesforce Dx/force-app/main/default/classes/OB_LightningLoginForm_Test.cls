@IsTest
public with sharing class OB_LightningLoginForm_Test {

 @IsTest
 static void testLoginWithInvalidCredentials() {
  System.assertEquals('Argument 1 cannot be null', LightningLoginFormController.login('testUser', 'fakepwd', null));
 }

 @IsTest
 static void LightningLoginFormControllerInstantiation() {
  LightningLoginFormController controller = new LightningLoginFormController();
  System.assertNotEquals(controller, null);
 }

 @IsTest
 static void testIsUsernamePasswordEnabled() {
  System.assertEquals(true, LightningLoginFormController.getIsUsernamePasswordEnabled());
 }

 @isTest
 public static void getForgotPasswordUrlTest() 
 {
  Test.startTest();
  //LightningLoginFormController.getForgotPasswordUrl();
  Test.stopTest();
 }

 @IsTest
 static void testIsSelfRegistrationEnabled() {
  System.assertEquals(false, LightningLoginFormController.getIsSelfRegistrationEnabled());
 }

 @IsTest
 static void testGetSelfRegistrationURL() {
  System.assertEquals(null, LightningLoginFormController.getSelfRegistrationUrl());
 }

 @IsTest
 static void testAuthConfig() {
  Auth.AuthConfiguration authConfig = LightningLoginFormController.getAuthConfig();
  System.assertNotEquals(null, authConfig);
 }
    
    @isTest
    public static void setExperienceIdTest1(){
        String expId = '';
        Test.startTest();
        LightningLoginFormController.setExperienceId(expId);
        Test.stopTest();
    }   
    
    @isTest
    public static void setExperienceIdTest2(){
        String expId = null;
        Test.startTest();
        LightningLoginFormController.setExperienceId(expId);
        Test.stopTest();
    }   
}