/**
 * @author Tanzi Gabriele Giovanni
 * @date Creation 10/11/2018
 * @version 1.0
 * @description Plc_Exception custom exception which provides a standard messaging form.
 */
public class Plc_Exception extends Exception {
    
    /**
     * @author Tanzi Gabriele Giovanni
     * @date Creation 10/11/2018
     * @version 1.0
     * @description Custom constructor
     *
     * @param String excMessage Apex Exception message.
     * @param String errCode Error code in platform.
     */    
    public Plc_Exception(String excMessage, String errCode) {

        this(errCode + ' ' + excMessage);
    }

    /**
     * @author Tanzi Gabriele Giovanni
     * @date Creation 10/11/2018
     * @version 1.0
     * @description Custom constructor
     *
     * @param Exception exc  Exception which contains the informations.
     * @param String errCode Error code in platform.
     */
    public Plc_Exception(Exception exc, String errCode) {

        this(errCode + ' ' + exc.getMessage() + ' ' + exc.getCause() + ' ' + exc.getStackTraceString());
    }
}