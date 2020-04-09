/**
 * ITriggerHandler - Trigger Handler main interface
 *
 * @author EM
 * @date Creation 28/12/2018
 * @description
 * @source http://chrisaldridge.com/triggers/lightweight-apex-trigger-framework/
 */
public interface ITriggerHandler {

    void beforeInsert(List<SObject> newItems);

    void beforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems);

    void beforeDelete(Map<Id, SObject> oldItems);

    void afterInsert(Map<Id, SObject> newItems);

    void afterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems);

    void afterDelete(Map<Id, SObject> oldItems);

    void afterUndelete(Map<Id, SObject> oldItems);

    Boolean isDisabled();
}