/**
 * @author Tanzi Gabriele Giovanni
 * @date Creation 10/11/2018
 * @version 1.0
 * @description Plc_ExceptionTest custom exception which provides a standard messaging form.
 */
@isTest
public class Plc_ExceptionTest {

    @isTest
    /**
     * [Plc_ExceptionTest description]
     */
    static void Plc_ExceptionTestOk(){
        
     //Test.startTest();
       try {
         throw new Plc_Exception('Exception thrown','02560');
        } catch (Plc_Exception e) {
            try{
                throw new Plc_Exception(e,'02561');                
            } catch (Exception ex){
                System.debug('exception message ' + ex.getMessage());
            }
            
        } 
        System.assert(true);
     //Test.stopTest();
        
    }
}