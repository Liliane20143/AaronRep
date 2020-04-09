/**
 * ITriggerHandler - Trigger Handler main interface
 *
 * @author CE
 * @date Creation 25/09/2019
 * @description
 * @source
 */
public interface ITriggerChangeEventHandler {

    Boolean isDisabled();

    void afterInsert(Map<Id, SObject> newItemsMap);

    void afterUpdate(Map<Id, SObject> newItemsMap);

    void afterDelete(Map<Id, SObject> newItemsMap);

    void afterUndelete (Map<Id, SObject> newItemsMap);
}