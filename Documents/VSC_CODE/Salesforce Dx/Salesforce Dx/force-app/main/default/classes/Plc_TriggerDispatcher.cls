/**
 * TriggerDispatcher - Trigger dispatcher class
 *
 * @author EM
 * @date Creation 28/12/2018
 * @description
 * @testedIn TriggerDispatcherTest
 * @source http://chrisaldridge.com/triggers/lightweight-apex-trigger-framework/
 */
public class Plc_TriggerDispatcher{
    /*
        Call this method from your trigger, passing in an instance of a trigger handler which implements ITriggerHandler.
        This method will fire the appropriate methods on the handler depending on the trigger context.
    */
    public static void run(ITriggerHandler handler){
        // Check to see if the trigger has been disabled. If it has, return
        if (handler.isDisabled()){
            return;
        }

        // Detect the current trigger context and fire the relevant methods on the trigger handler:

        // Before trigger logic
        if (Trigger.isBefore ){
            if (Trigger.isInsert)
                handler.beforeInsert(trigger.new);

            if (Trigger.isUpdate)
                handler.beforeUpdate(trigger.newMap, trigger.oldMap);

            if (Trigger.isDelete)
                handler.beforeDelete(trigger.oldMap);
        }

        // After trigger logic
        if (Trigger.isAfter){
            if (Trigger.isInsert){
                handler.afterInsert(Trigger.newMap);
            }

            if (Trigger.isUpdate){
                handler.afterUpdate(trigger.newMap, trigger.oldMap);
            }

            if (trigger.isDelete){
                handler.afterDelete(trigger.oldMap);
            }

            if (trigger.isUndelete){
                handler.afterUndelete(trigger.oldMap);
            }
        }
    }
}