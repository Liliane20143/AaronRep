/**
     * @author Roland Nieznanski
     * @date Creation 10/06/2019
     * @description Test class OB_CheckOrderHeadersInApprovalProc_Test for class OB_CheckOrderHeadersInApprovalProcess.
     */
    @isTest
    public class OB_CheckOrderHeadersInApprovalProc_Test { 

         /*
          --------------------------------------------------------
               @Author   :    Morittu Andrea
               @Date     :    10-Jan-2019
               @Task     :    Covering OB_CheckOrderHeadersInApprovalProcess.execute()
          --------------------------------------------------------
         */
          @isTest
          public static void simulateSchedulableClass() {
            Test.StartTest();
              
               NE__Order_Header__c ordh = OB_TestDataFactory.getOrderHeader();
               ordh.OB_In_Approvazione_a__c 	= 'Controlli AML';
               ordh.OB_AcquiringApproval__c 	= false;
               ordh.OB_StartApprovalProcess__c 	= true;
               insert ordh;
              
               OB_CheckOrderHeadersInApprovalProcess sh1 = new OB_CheckOrderHeadersInApprovalProcess();      
               String sch = '0 0 23 * * ?';
               System.schedule('Test check', sch, sh1);
            Test.stopTest();
        }


    }