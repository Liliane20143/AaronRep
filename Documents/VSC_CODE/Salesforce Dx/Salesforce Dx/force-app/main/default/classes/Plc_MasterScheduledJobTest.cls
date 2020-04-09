/**
* @author Tanzi Gabriele Giovanni
* @date Creation 17/12/2018
* @version 1.0
* @description Test of PLC MasterScheduledJob.
*/
@isTest
public class Plc_MasterScheduledJobTest {
    
    /**
     * @author Tanzi Gabriele Giovanni
     * @date Creation 17/12/2018
     * @version 1.0
     * @description 
     */
    @isTest
    static void MasterScheduleTest(){
      //String s = new Plc_MasterScheduledJob.getSchedulerName();
      aidCls p = new aidCls();
      SchedulableContext schedulableContext;
      p.execute(schedulableContext);
    }
    
    public class aidCls extends Plc_MasterScheduledJob{
    
        public override string getSchedulerName(){
        
        
          return 'test';
        
        }
    
    }
     
}