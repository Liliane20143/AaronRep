/**
 * @author Tanzi Gabriele Giovanni
 * @date Creation 19/09/2018
 * @version 1.0
 * @description LogTracker - it defines a standard log format.
 */
global without sharing class LogTracker {

    /**
     * @author Tanzi Gabriele Giovanni
     * @date Creation 19/09/2018
     * @version 1.0
     * @description This method provides the debug log to track the BEGIN.
     *
     * @param String className This parameter is the name of the Apex class.
     * @param String methodName This parameter is the name of the Apex method.
     */
    global static void debugLogBegin(String className, String methodName) {
        System.debug('### >> BEGIN [' + className + '] [' + methodName + '] ###');
    }

    /**
     * @author Tanzi Gabriele Giovanni
     * @date Creation 19/09/2018
     * @version 1.0
     * @description This method provides the debug log to track the BEGIN.
     *
     * @param String className This parameter is the name of the Apex class.
     * @param String methodName This parameter is the name of the Apex method.
     * @param String message This parameter represents the information to appear in the debug log.
     */
    global static void debugLogBegin(String className, String methodName, String message) {
        System.debug('### >> BEGIN [' + className + '] [' + methodName + '] [MESSAGE] : ' + message);
    }

    /**
     * @author Tanzi Gabriele Giovanni
     * @date Creation 19/09/2018
     * @version 1.0
     * @description This method provides the debug log to track the EXECUTION.
     *
     * @param String className This parameter is the name of the Apex class.
     * @param String methodName This parameter is the name of the Apex method.
     * @param String message This parameter represents the information to appear in the debug log.
     */
    global static void debugLog(String className, String methodName, String message) {
        System.debug('### >> LOG [' + className + '] [' + methodName + '] [MESSAGE] : ' + message);
    }

    /**
     * @author Tanzi Gabriele Giovanni
     * @date Creation 19/09/2018
     * @version 1.0
     * @description This method provides the debug log to track the END.
     *
     * @param String className This parameter is the name of the Apex class.
     * @param String methodName This parameter is the name of the Apex method.
     * @param String message This parameter represents the information to appear in the debug log.
     */
    global static void debugLogEnd(String className, String methodName, String message) {
        System.debug('### >> END [' + className + '] [' + methodName + '] [MESSAGE] : ' + message);
    }

    /**
     * @author Tanzi Gabriele Giovanni
     * @date Creation 19/09/2018
     * @version 1.0
     * @description This method provides the debug log to track the END.
     *
     * @param String className This parameter is the name of the Apex class.
     * @param String methodName This parameter is the name of the Apex method.
     */
    global static void debugLogEnd(String className, String methodName) {
        System.debug('### >> END [' + className + '] [' + methodName + '] ###');
    }
}