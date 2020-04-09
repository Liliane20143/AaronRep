/**
 * @author Tanzi Gabriele Giovanni
 * @date Creation 03/12/2018
 * @version 1.0
 * @description Test class for LogTracker.
 */
@isTest
private class LogTrackerTest {
    
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 4/12/2018
    * @version 1.0
    * @description Test of the method debugLogBegin with two parameters className and methodName.
    */
    @isTest
    static void debugLogBeginCallTest(){        

        // Start test
        Test.startTest();
        LogTracker.debugLogBegin('LogTracker','debugLogBegin');        
        // Stop test
        Test.stopTest();
        System.assert(true);
    }

    /**
    * @author Abdoulaye & Moussa
    * @date Creation 4/12/2018
    * @version 1.0
    * @description Test of the method debugLogBegin with three parameters className, methodName and message.
    */
    @isTest
    static void debugLogBeginWithMessageCallTest(){        

        // Start test
        Test.startTest();
        LogTracker.debugLogBegin('LogTracker','debugLogBegin','OK');        
        // Stop test
        Test.stopTest();
        System.assert(true);
    }

    /**
    * @author Abdoulaye & Moussa
    * @date Creation 4/12/2018
    * @version 1.0
    * @description Test of the method debugLog with two parameters className and methodName.
    */
    @isTest
    static void debugLogCallTest(){        

        // Start test
        Test.startTest();
        LogTracker.debugLog('LogTracker','debugLog','OK');        
        // Stop test
        Test.stopTest();
        System.assert(true);
    }
    
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 4/12/2018
    * @version 1.0
    * @description Test of the method debugLogEnd with two parameters className and methodName.
    */
    @isTest
    static void debugLogEndCallTest(){        

        // Start test
        Test.startTest();
        LogTracker.debugLogEnd('LogTracker','debugLogBegin');        
        // Stop test
        Test.stopTest();
        System.assert(true);
    }

      
    /**
    * @author Abdoulaye & Moussa
    * @date Creation 4/12/2018
    * @version 1.0
    * @description Test of the method debugLogEnd with three parameters className, methodName and message.
    */
    @isTest
    static void debugLogEndWithMessageCallTest(){        

        // Start test
        Test.startTest();
        LogTracker.debugLogEnd('LogTracker','debugLogBegin','OK');        
        // Stop test
        Test.stopTest();
    }

}