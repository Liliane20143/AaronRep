@isTest
public class OB_MaintenanceAssetSummary_Test 
{
    @testSetup 
    static void setup() 
    {   
        NE__Map__c mp =  new NE__Map__c(NE__Map_Name__c = 'StdAsset2Order');
        insert mp;
        NE__MapObject__c moOrder =  new NE__MapObject__c(NE__Sequence__c=0,NE__SourcePrefix__c='',NE__Source__c='asset',NE__TargetPrefix__c='NE__',NE__Target__c='order__c',NE__Map__c=mp.id);
        insert moOrder;
        NE__MapObject__c moOrderItem =  new NE__MapObject__c(NE__Sequence__c=1,NE__SourcePrefix__c='',NE__Source__c='asset',NE__TargetPrefix__c='NE__',NE__Target__c='orderitem__c',NE__Map__c=mp.id);
        insert moOrderItem;
        NE__MapObject__c moOIAttrib =  new NE__MapObject__c(NE__Sequence__c=2,NE__SourcePrefix__c='NE__',NE__Source__c='assetitemattribute__c',NE__TargetPrefix__c='NE__',NE__Target__c='orderitem__c',NE__Map__c=mp.id);
        insert moOIAttrib;
        List<NE__MapObjectItem__c> moiList = new List<NE__MapObjectItem__c>();
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='NE__', NE__Relationship__c='', NE__SourceField__c ='billing_account__c', NE__TargetPrefix__c ='NE__', NE__TargetField__c='billaccid__c', NE__Type__c = 'Field', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOrder.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='', NE__Relationship__c='', NE__SourceField__c ='ob_mcc__c', NE__TargetPrefix__c ='', NE__TargetField__c='ob_mcc__c', NE__Type__c = 'Field', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOrder.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='', NE__Relationship__c='Order_Config__r', NE__SourceField__c ='commercialmodelid__c', NE__TargetPrefix__c ='NE__', NE__TargetField__c='commercialmodelid__c', NE__Type__c = 'Relationship', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOrder.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='', NE__Relationship__c='Order_Config__r', NE__SourceField__c ='optyid__c', NE__TargetPrefix__c ='NE__', NE__TargetField__c='optyid__c', NE__Type__c = 'Relationship', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOrder.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='', NE__Relationship__c='', NE__SourceField__c ='', NE__TargetPrefix__c ='NE__', NE__TargetField__c='orderstatus__c', NE__Type__c = 'Value', NE__field_type__c ='String', NE__Value__c='Pending', NE__Map_Object__c =moOrder.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='', NE__Relationship__c='Order_Config__r', NE__SourceField__c ='quote__c', NE__TargetPrefix__c ='NE__', NE__TargetField__c='quote__c', NE__Type__c = 'Relationship', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOrder.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='', NE__Relationship__c='Order_Config__r', NE__SourceField__c ='totalrecurringfrequency__c', NE__TargetPrefix__c ='NE__', NE__TargetField__c='totalrecurringfrequency__c', NE__Type__c = 'Relationship', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOrder.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='NE__', NE__Relationship__c='', NE__SourceField__c ='service_account__c', NE__TargetPrefix__c ='NE__', NE__TargetField__c='servaccid__c', NE__Type__c = 'Field', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOrder.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='', NE__Relationship__c='Order_Config__r', NE__SourceField__c ='type__c', NE__TargetPrefix__c ='NE__', NE__TargetField__c='type__c', NE__Type__c = 'Relationship', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOrder.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='', NE__Relationship__c='', NE__SourceField__c ='accountid', NE__TargetPrefix__c ='NE__', NE__TargetField__c='accountid__c', NE__Type__c = 'Field', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOrder.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='NE__', NE__Relationship__c='', NE__SourceField__c ='catalog__c', NE__TargetPrefix__c ='NE__', NE__TargetField__c='catalogid__c', NE__Type__c = 'Field', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOrder.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='', NE__Relationship__c='', NE__SourceField__c ='', NE__TargetPrefix__c ='NE__', NE__TargetField__c='configuration_subtype__c', NE__Type__c = 'Value', NE__field_type__c ='String', NE__Value__c='Standard', NE__Map_Object__c =moOrder.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='', NE__Relationship__c='', NE__SourceField__c ='ob_bankaccount_debit_acquiring__c', NE__TargetPrefix__c ='', NE__TargetField__c='ob_bankaccount_acquiring__c', NE__Type__c = 'Field', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOrder.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='NE__', NE__Relationship__c='', NE__SourceField__c ='service_point__c', NE__TargetPrefix__c ='', NE__TargetField__c='ob_service_point__c', NE__Type__c = 'Field', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOrder.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='', NE__Relationship__c='', NE__SourceField__c ='ob_mccl2__c', NE__TargetPrefix__c ='', NE__TargetField__c='ob_mccl2__c', NE__Type__c = 'Field', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOrder.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='', NE__Relationship__c='', NE__SourceField__c ='name', NE__TargetPrefix__c ='', NE__TargetField__c='name', NE__Type__c = 'Field', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOIAttrib.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='', NE__Relationship__c='', NE__SourceField__c ='ob_minthresholdl3__c', NE__TargetPrefix__c ='', NE__TargetField__c='ob_minthresholdl3__c', NE__Type__c = 'Field', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOIAttrib.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='NE__', NE__Relationship__c='', NE__SourceField__c ='fampropid__c', NE__TargetPrefix__c ='NE__', NE__TargetField__c='fampropid__c', NE__Type__c = 'Field', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOIAttrib.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='NE__', NE__Relationship__c='', NE__SourceField__c ='value__c', NE__TargetPrefix__c ='NE__', NE__TargetField__c='old_value__c', NE__Type__c = 'Field', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOIAttrib.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='NE__', NE__Relationship__c='', NE__SourceField__c ='asset__c', NE__TargetPrefix__c ='NE__', NE__TargetField__c='order_item__c', NE__Type__c = 'Keyfield', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOIAttrib.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='NE__', NE__Relationship__c='', NE__SourceField__c ='value__c', NE__TargetPrefix__c ='NE__', NE__TargetField__c='value__c', NE__Type__c = 'Field', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOIAttrib.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='NE__', NE__Relationship__c='', NE__SourceField__c ='fampropextid__c', NE__TargetPrefix__c ='NE__', NE__TargetField__c='fampropextid__c', NE__Type__c = 'Field', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOIAttrib.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='', NE__Relationship__c='', NE__SourceField__c ='ob_attribute_code__c', NE__TargetPrefix__c ='', NE__TargetField__c='ob_attribute_code__c', NE__Type__c = 'Field', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOIAttrib.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='', NE__Relationship__c='', NE__SourceField__c ='ob_massimale__c', NE__TargetPrefix__c ='', NE__TargetField__c='ob_massimale__c', NE__Type__c = 'Field', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOIAttrib.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='', NE__Relationship__c='', NE__SourceField__c ='ob_max_absolute__c', NE__TargetPrefix__c ='', NE__TargetField__c='ob_max_absolute__c', NE__Type__c = 'Field', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOIAttrib.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='', NE__Relationship__c='', NE__SourceField__c ='ob_max_threshold__c', NE__TargetPrefix__c ='', NE__TargetField__c='ob_max_threshold__c', NE__Type__c = 'Field', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOIAttrib.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='', NE__Relationship__c='', NE__SourceField__c ='ob_min_threshold__c', NE__TargetPrefix__c ='', NE__TargetField__c='ob_min_threshold__c', NE__Type__c = 'Field', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOIAttrib.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='', NE__Relationship__c='', NE__SourceField__c ='ob_min_absolute__c', NE__TargetPrefix__c ='', NE__TargetField__c='ob_min_absolute__c', NE__Type__c = 'Field', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOIAttrib.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='NE__', NE__Relationship__c='', NE__SourceField__c ='action__c', NE__TargetPrefix__c ='NE__', NE__TargetField__c='action__c', NE__Type__c = 'Field', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOIAttrib.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='', NE__Relationship__c='', NE__SourceField__c ='ob_readonly__c', NE__TargetPrefix__c ='', NE__TargetField__c='ob_readonly__c', NE__Type__c = 'Field', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOIAttrib.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='', NE__Relationship__c='', NE__SourceField__c ='ob_maxthresholdl2__c', NE__TargetPrefix__c ='', NE__TargetField__c='ob_maxthresholdl2__c', NE__Type__c = 'Field', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOIAttrib.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='', NE__Relationship__c='', NE__SourceField__c ='ob_maxthresholdl3__c', NE__TargetPrefix__c ='', NE__TargetField__c='ob_maxthresholdl3__c', NE__Type__c = 'Field', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOIAttrib.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='', NE__Relationship__c='', NE__SourceField__c ='ob_minthresholdl2__c', NE__TargetPrefix__c ='', NE__TargetField__c='ob_minthresholdl2__c', NE__Type__c = 'Field', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOIAttrib.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='', NE__Relationship__c='', NE__SourceField__c ='ob_minthresholdl3__c', NE__TargetPrefix__c ='', NE__TargetField__c='ob_minthresholdl3__c', NE__Type__c = 'Field', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOIAttrib.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='NE__', NE__Relationship__c='', NE__SourceField__c ='value__c', NE__TargetPrefix__c ='NE__', NE__TargetField__c='old_value__c', NE__Type__c = 'Field', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOIAttrib.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='NE__', NE__Relationship__c='', NE__SourceField__c ='value__c', NE__TargetPrefix__c ='NE__', NE__TargetField__c='value__c', NE__Type__c = 'Field', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOIAttrib.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='', NE__Relationship__c='', NE__SourceField__c ='name', NE__TargetPrefix__c ='', NE__TargetField__c='name', NE__Type__c = 'Field', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOIAttrib.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='NE__', NE__Relationship__c='', NE__SourceField__c ='fampropid__c', NE__TargetPrefix__c ='NE__', NE__TargetField__c='fampropid__c', NE__Type__c = 'Field', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOIAttrib.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='', NE__Relationship__c='', NE__SourceField__c ='id', NE__TargetPrefix__c ='NE__', NE__TargetField__c='attrenterpriseid__c', NE__Type__c = 'Field', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOIAttrib.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='NE__', NE__Relationship__c='', NE__SourceField__c ='asset__c', NE__TargetPrefix__c ='NE__', NE__TargetField__c='order_item__c', NE__Type__c = 'Keyfield', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOIAttrib.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='NE__', NE__Relationship__c='', NE__SourceField__c ='fampropextid__c', NE__TargetPrefix__c ='NE__', NE__TargetField__c='fampropextid__c', NE__Type__c = 'Field', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOIAttrib.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='', NE__Relationship__c='', NE__SourceField__c ='ob_attribute_code__c', NE__TargetPrefix__c ='', NE__TargetField__c='ob_attribute_code__c', NE__Type__c = 'Field', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOIAttrib.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='', NE__Relationship__c='', NE__SourceField__c ='ob_massimale__c', NE__TargetPrefix__c ='', NE__TargetField__c='ob_massimale__c', NE__Type__c = 'Field', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOIAttrib.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='', NE__Relationship__c='', NE__SourceField__c ='ob_max_absolute__c', NE__TargetPrefix__c ='', NE__TargetField__c='ob_max_absolute__c', NE__Type__c = 'Field', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOIAttrib.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='', NE__Relationship__c='', NE__SourceField__c ='ob_max_threshold__c', NE__TargetPrefix__c ='', NE__TargetField__c='ob_max_threshold__c', NE__Type__c = 'Field', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOIAttrib.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='', NE__Relationship__c='', NE__SourceField__c ='ob_min_absolute__c', NE__TargetPrefix__c ='', NE__TargetField__c='ob_min_absolute__c', NE__Type__c = 'Field', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOIAttrib.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='', NE__Relationship__c='', NE__SourceField__c ='ob_min_threshold__c', NE__TargetPrefix__c ='', NE__TargetField__c='ob_min_threshold__c', NE__Type__c = 'Field', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOIAttrib.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='NE__', NE__Relationship__c='', NE__SourceField__c ='action__c', NE__TargetPrefix__c ='NE__', NE__TargetField__c='action__c', NE__Type__c = 'Field', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOIAttrib.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='', NE__Relationship__c='', NE__SourceField__c ='ob_readonly__c', NE__TargetPrefix__c ='', NE__TargetField__c='ob_readonly__c', NE__Type__c = 'Field', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOIAttrib.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='', NE__Relationship__c='', NE__SourceField__c ='ob_hidden__c', NE__TargetPrefix__c ='', NE__TargetField__c='ob_hidden__c', NE__Type__c = 'Field', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOIAttrib.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='', NE__Relationship__c='', NE__SourceField__c ='ob_maxthresholdl2__c', NE__TargetPrefix__c ='', NE__TargetField__c='ob_maxthresholdl2__c', NE__Type__c = 'Field', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOIAttrib.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='', NE__Relationship__c='', NE__SourceField__c ='ob_maxthresholdl3__c', NE__TargetPrefix__c ='', NE__TargetField__c='ob_maxthresholdl3__c', NE__Type__c = 'Field', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOIAttrib.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='', NE__Relationship__c='', NE__SourceField__c ='ob_minthresholdl2__c', NE__TargetPrefix__c ='', NE__TargetField__c='ob_minthresholdl2__c', NE__Type__c = 'Field', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOIAttrib.Id ));
        moiList.Add(new NE__MapObjectItem__c(NE__Stop_trigger__c=true,NE__SourcePrefix__c='', NE__Relationship__c='', NE__SourceField__c ='id', NE__TargetPrefix__c ='NE__', NE__TargetField__c='attrenterpriseid__c', NE__Type__c = 'Field', NE__field_type__c ='String', NE__Value__c='', NE__Map_Object__c =moOIAttrib.Id ));
        insert moiList;
        moiList.clear();

        OB_Integration_Configuration__c ic = new OB_Integration_Configuration__c();
        ic.Name = 'DEV1';
        ic.OB_Domain__c = 'dev1';
        ic.OB_Token_1__c = 'eyJ0eXAiOiJKV1QiLCJjdHkiOiJKV1QiLCJhbGciOiJSU0EtT0FFUCIsImVuYyI6IkExMjhDQkMtSFMyNTYifQ.nynF9045u2M-1WGn007JxObPiM3PBK0Q4GM8EBwQS0o6fJutTABfMSTtekOlCpQEv4vKSLmj0-Rgk5rQgireCX-cOp_Vvh9IYLl6xfOJfUR8f5mLUmY4r7BGrWtLbaM5wwTIJXQs8kFpp2VIePragkN2MahtjIOtBp1vQW2y';
        ic.OB_timestamp__c = '1542902538147';
        ic.OB_Timeout_Continuation__c = '30';
        insert ic;

        Account acc  = new Account(); 
        acc.Name         = 'TEST';
        acc.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Bank'].id;
        acc.OB_Employees_Number__c         = 'Minore di 10';
        acc.OB_VAT_Not_Present__c          = false;
        acc.OB_DescriptionVATNotPresent__c = 'description';
        acc.NE__Fiscal_code__c             = 'RSSMRA80A01F205X';
        acc.OB_BypassValidation__c         = true;
        acc.OB_Status__c                   = 'Active'; 
        acc.NE__VAT__c                     = '12312312312'; 
        acc.OB_ABI__c                      = '05696';
        insert acc;
 
        NE__Bundle__c bundle = new NE__Bundle__c( Name	= 'test',
											  								NE__Configuration_Type__c 		= 'Free',
											  								NE__BaseRecurringCharge__c		= 12.00,
											  								NE__RecurringChargeFrequency__c = 'Annual',
											  								NE__Start_Date__c 				= system.now(),
											  								NE__End_Date__c 				= system.now().addDays(1)	);
		insert bundle;

        NE__Order_Header__c oh    = new NE__Order_Header__c(OB_Business_Model_Acquiring__c = 'Bancario', 
                                                            OB_Business_Model_POS__c = 'Trilaterale Nuovo', 
                                                            OB_Main_Process__c = 'Setup');
        insert oh;
        NE__Service_Point__c sp   = new NE__Service_Point__c();
        sp.OB_MCC__c   ='2345';
        sp.NE__City__c = 'Yaounde';
        insert sp;
        
        NE__Billing_Profile__c bp = new NE__Billing_Profile__c(NE__Account__c = acc.id);
        insert bp;

        NE__Order__c ord        = new NE__Order__c(NE__Order_Header__c = oh.id);
        ord.NE__AccountId__c    = acc.id;
        ord.NE__BillAccId__c    = acc.Id;
        ord.NE__ServAccId__c    = acc.Id;
        ord.OB_MCCL2__c         = '0000';
        ord.OB_GT__c		    = 'Nexi';
        ord.OB_Service_Point__c = sp.id;
        ord.NE__BillingProfId__c = bp.Id;    
        insert ord; 
        
        NE__Product__c prod       = new NE__Product__c();
        Id rtCommission = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get('Commissione').getRecordTypeId();
        prod.RecordTypeId = rtCommission;
        insert prod;

        NE__Catalog__c cat        = new NE__Catalog__c();
        insert cat;
        NE__Catalog_Item__c ci    = new NE__Catalog_Item__c(NE__Catalog_Id__c = cat.id ,NE__ProductId__c = prod.id);
        insert ci;

        Id rtStd = Schema.SObjectType.Asset.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        Asset assFather = new Asset();
        assFather.Name = 'test';
        assFather.AccountId = acc.id;
        assFather.NE__Billing_Account__c = acc.id;
        assFather.NE__Service_Account__c = acc.id;
        assFather.recordTypeId = rtStd;
        assFather.NE__Status__c ='Active';
        assFather.NE__Order_Config__c = ord.id;
        assFather.NE__BillingProf__c = bp.Id; 
        assFather.quantity = 1;
        insert assFather;

        
        Asset ass = new Asset();
        ass.recordTypeId = rtStd;
        ass.NE__Order_Config__c = ord.id;
        ass.NE__BillingProf__c = bp.Id;
        ass.NE__CatalogItem__c              = ci.id;
        ass.quantity = 1;
        ass.AccountId                       = acc.id;
        ass.NE__Billing_Account__c = acc.id;
        ass.NE__Service_Account__c = acc.id;
        ass.OB_DebitProfId__c               = bp.id;
        ass.OB_ProposerABI__c               = acc.id;
        ass.IsCompetitorProduct             = false;
        ass.IsInternal                      = false;
        ass.Name                            = 'Offerta Personalizzata';
        ass.NE__Action__c                   = 'Change';
        ass.NE__AssetItemEnterpriseId__c    = '123123123';
        ass.NE__BaseOneTimeFee__c           = 0;
        ass.NE__BaseRecurringCharge__c      = 0;
        ass.NE__Billing_Account__c          = acc.id;
        ass.NE__Commitment__c               = false;
        ass.NE__Discount_One_time__c        = 0;
        ass.NE__Discount__c                 = 0;
        ass.NE__Generate_Asset_Item__c      = true;
        //ass.NE__Item_Code__c                = '';
        ass.NE__Order_Config__c             = ord.id;
        ass.NE__ProdId__c                   = prod.id;
        ass.NE__RecurringChargeFrequency__c = 'Monthly';
        ass.NE__Remove_from_total__c        = false;
        ass.NE__Service_Account__c          = acc.id;
        ass.NE__Service_Point__c            = sp.id;
        ass.NE__Status__c                   = 'Active';
        ass.OB_enablement__c                = 'N';
        ass.OB_MCCL2__c                     = '0001';
        ass.OB_MCC__c                       = '5200';
        ass.OB_Report_Type__c               = 'Punto Vendita';
        ass.OB_Ro__c                        = 'N';
        ass.OB_Visible__c                   = 'N';
        ass.Quantity                        = 1;
        ass.OB_ShopSign__c                  = '23112';
        ass.NE__Order_Config__c             = ord.id;
        ass.NE__ProdId__c                   = prod.id;
        ass.NE__Bundle_Configuration__c     = assFather.id;
        
       insert ass;

      

        


    }
    // @isTest
    // public static void callCancelOrderTest(){
    //     Asset ass=[SELECT id, Name FROM Asset LIMIT 1];
    //      Test.startTest();
    //     OB_MaintenanceAssetSummaryController.callCancelOrder(ass.id);
    //     Test.stopTest();

    // }


    @isTest
    public static void callAssetToOrderServerTest1()
    {
    	Test.startTest();

        
        Asset assFather = [SELECT id , name from Asset WHERE NE__Bundle_Configuration__c = null LIMIT 1];
        Account acc =[SELECT id, name FROM Account LIMIT 1];
        String accId = String.valueOf(acc.id);
        NE__Service_Point__c sp = [SELECT id, name FROM NE__Service_Point__c LIMIT 1 ];
        NE__Billing_Profile__c bp = [SELECT Id, Name FROM NE__Billing_Profile__c LIMIT 1];
        //NE__Order_Header__c oh    = [SELECT Id, Name FROM NE__Order_Header__c LIMIT 1 ];
        NE__Order_Header__c oh    = new NE__Order_Header__c(OB_Business_Model_Acquiring__c = 'Bancario', 
                                                            OB_Business_Model_POS__c = 'Trilaterale Nuovo', 
                                                            OB_Main_Process__c = 'Setup');
        NE__Order__c ord        = new NE__Order__c(NE__Order_Header__c = oh.id);
        ord.NE__AccountId__c    = acc.id;
        ord.NE__BillAccId__c    = acc.Id;
        ord.NE__ServAccId__c    = acc.Id;
        ord.OB_MCCL2__c         = '0000';
        ord.OB_GT__c		    = 'Nexi';
        ord.OB_Service_Point__c = sp.id;
        ord.NE__BillingProfId__c = bp.Id;    
        insert ord; 
     
        Id bankRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'bank' AND SobjectType = 'Account' LIMIT 1].Id;
        Map<String,Schema.SObjectField> fieldMap = Schema.SObjectType.OB_Bank_Profile__c.fields.getMap();
        Account bank = new Account( Name = 'merchant name', 
                                        RecordTypeId = bankRecordTypeId, 
                                        OB_Employees_Number__c = 'Minore di 10', 
                                        NE__Fiscal_code__c = 'AAAAAA11A11A111A', 
                                        OB_VAT_Not_Present__c = true, 
                                        OB_DescriptionVATNotPresent__c = 'desc', 
                                        OB_ABI__c = '12345');
                                        // OB_ABI__c= abi
                                        
        insert bank;
        System.debug('@@@@@@@@@bank.OB_ABI__c : ' + bank.OB_ABI__c);

        OB_Bank_Profile__c bankP = new OB_Bank_Profile__c();
		bankP.OB_Bank__c = bank.Id;
		bankP.OB_Service_Type__c = 'Acquiring'; 
		bankP.OB_Business_Model_POS__c = 'Bilaterale'; 
		bankP.OB_Circuit__c = 'JCB'; 
		bankP.OB_Other_Acquirer__c = 'Amex';
		bankP.OB_Applicant_RAC_Code_SIA__c = 'Banca'; 
		bankP.OB_Terminal_Id_Generator__c = 'Banca'; 
		bankP.OB_Technical_component_invoicing__c = 'TecMarket(servizio fatturazione per conto terzi)'; 
		bankP.OB_GT__c = 'Nexi'; 
		bankP.OB_Processor__c = 'SIA SMAC'; 
		bankP.OB_Bilateral_Pricing__c = 'SI'; 
		bankP.OB_Sending_Contract_to_Nexi__c = 'SI'; 
		bankP.OB_SME_Factory__c = 'SI';
		bankP.OB_Business_Model_Acquiring__c = 'Bancario';
		insert bankP;
        
        System.debug('@@@@@@@@@bankP.OB_Bank__r.OB_ABI__c : ' + bankP.OB_Bank__r.OB_ABI__c);
       
        
        system.debug('asset: '+assFather.id);
        system.debug('accId: '+accId);
       
        // String result = NE.JS_RemoteMethods.stdasset2order (assFather.id, 'Change');
		// 	system.debug('@result ' + result);
        //(Id offerAssetId,Boolean isEditCommissionModel, Boolean isPricing, String userABI, String userCAB, String accId, String proposerABI, Boolean isTerminate, Boolean isSkipToIntBE)
        //	Daniele Gandini <daniele.gandini@accenture.com>	- 02/05/2019 - TerminalsReplacement - Added first boolean parameter because of Method Signature modified - START
        OB_MaintenanceAssetSummaryController.callAssetToOrderServer(false, assFather.id,false ,true, '12345', '54321', accId, true,true);
                //	Daniele Gandini <daniele.gandini@accenture.com>	- 02/05/2019 - TerminalsReplacement - Added first boolean parameter because of Method Signature modified - START
        Test.stopTest();
    }
    
    //    @isTest
    // public static void callAssetToOrderServerTest2()
    // {

        
    //     Asset assFather = [SELECT id , name from Asset  LIMIT 1];
    //     Account acc =[SELECT id, name FROM Account LIMIT 1];
    //     String accId = String.valueOf(acc.id);
    //     NE__Service_Point__c sp = [SELECT id, name FROM NE__Service_Point__c LIMIT 1 ];
    //     NE__Billing_Profile__c bp = [SELECT Id, Name FROM NE__Billing_Profile__c LIMIT 1];
    //     //NE__Order_Header__c oh    = [SELECT Id, Name FROM NE__Order_Header__c LIMIT 1 ];
    //     NE__Order_Header__c oh    = new NE__Order_Header__c(OB_Business_Model_Acquiring__c = 'Bancario', 
    //                                                         OB_Business_Model_POS__c = 'Trilaterale Nuovo', 
    //                                                         OB_Main_Process__c = 'Setup');
    //     NE__Order__c ord        = new NE__Order__c(NE__Order_Header__c = oh.id);
    //     ord.NE__AccountId__c    = acc.id;
    //     ord.NE__BillAccId__c    = acc.Id;
    //     ord.NE__ServAccId__c    = acc.Id;
    //     ord.OB_MCCL2__c         = '0000';
    //     ord.OB_GT__c		    = 'Nexi';
    //     ord.OB_Service_Point__c = sp.id;
    //     ord.NE__BillingProfId__c = bp.Id;    
    //     insert ord; 
     
    //     Id bankRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'bank' AND SobjectType = 'Account' LIMIT 1].Id;
    //     Map<String,Schema.SObjectField> fieldMap = Schema.SObjectType.OB_Bank_Profile__c.fields.getMap();
    //     Account bank = new Account( Name = 'merchant name', 
    //                                     RecordTypeId = bankRecordTypeId, 
    //                                     OB_Employees_Number__c = 'Minore di 10', 
    //                                     NE__Fiscal_code__c = 'AAAAAA11A11A111A', 
    //                                     OB_VAT_Not_Present__c = true, 
    //                                     OB_DescriptionVATNotPresent__c = 'desc', 
    //                                     OB_ABI__c = '12345');
    //                                     // OB_ABI__c= abi
                                        
    //     insert bank;
    //     System.debug('@@@@@@@@@bank.OB_ABI__c : ' + bank.OB_ABI__c);

    //     OB_Bank_Profile__c bankP = new OB_Bank_Profile__c();
	// 	bankP.OB_Bank__c = bank.Id;
	// 	bankP.OB_Service_Type__c = 'Acquiring'; 
	// 	bankP.OB_Business_Model_POS__c = 'Bilaterale'; 
	// 	bankP.OB_Circuit__c = 'JCB'; 
	// 	bankP.OB_Other_Acquirer__c = 'Amex';
	// 	bankP.OB_Applicant_RAC_Code_SIA__c = 'Banca'; 
	// 	bankP.OB_Terminal_Id_Generator__c = 'Banca'; 
	// 	bankP.OB_Technical_component_invoicing__c = 'TecMarket(servizio fatturazione per conto terzi)'; 
	// 	bankP.OB_GT__c = 'Nexi'; 
	// 	bankP.OB_Processor__c = 'SIA SMAC'; 
	// 	bankP.OB_Bilateral_Pricing__c = 'SI'; 
	// 	bankP.OB_Sending_Contract_to_Nexi__c = 'SI'; 
	// 	bankP.OB_SME_Factory__c = 'SI';
	// 	bankP.OB_Business_Model_Acquiring__c = 'Bancario';
	// 	insert bankP;
        
    //     System.debug('@@@@@@@@@bankP.OB_Bank__r.OB_ABI__c : ' + bankP.OB_Bank__r.OB_ABI__c);
       
        
    //     system.debug('asset: '+assFather.id);
    //     system.debug('accId: '+accId);
    // 	Test.startTest();

    //     // String result = NE.JS_RemoteMethods.stdasset2order (assFather.id, 'Change');
	// 	// 	system.debug('@result ' + result);
    //     //(Id offerAssetId,Boolean isEditCommissionModel, Boolean isPricing, String userABI, String userCAB, String accId, String proposerABI, Boolean isTerminate)
    //     OB_MaintenanceAssetSummaryController.callAssetToOrderServer(assFather.id,false ,true, '12345', '54321', accId, '1231231231', true);
    //     Test.stopTest();
    // }

    //START - elena.preteni coverage increase fix-ssn 27/12/2019
    @isTest
    public static void callAssetToOrderItemServerTest(){
         Asset assFather = [SELECT id , name from Asset  LIMIT 1];
         NE__Order__c ord = [SELECT id , name from NE__Order__c  LIMIT 1];
         OB_MaintenanceAssetSummaryController.callAssetToOrderItemServer(ord.Id,assFather.Id);
    }
    //END - elena.preteni coverage increase fix-ssn 27/12/2019 

    @isTest
    public static void getCommissionServerTest()
    {   
        Id rtCommission = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get('Commissione').getRecordTypeId();
        Account acc  = new Account(); 
        acc.Name = 'TEST';
        acc.OB_BypassValidation__c = true;
        insert acc;
        NE__Product__c prod = new NE__Product__c();
        prod.RecordTypeId = rtCommission;
        insert prod;
        Id rtStd = Schema.SObjectType.Asset.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        Asset assFather = new Asset();
        assFather.recordTypeId = rtStd;
        assFather.Name = 'test';
        assFather.AccountId = acc.id;
        insert assFather;
        Asset ass = new Asset();
        ass.recordTypeId = rtStd;
        ass.Name = 'test';
        ass.AccountId = acc.id;
        ass.NE__ProdId__c = prod.id;
        ass.NE__Bundle_Configuration__c = assFather.id;
        insert ass;
        Test.startTest();
        OB_MaintenanceAssetSummaryController.getCommissionServer(assFather.id, 'offerName');
        Test.stopTest();
    }

    @isTest
    public static void shareTest()
    {
        Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Bank').getRecordTypeId();
        Account acc = new Account(  Name='TEST3',
                                    RecordTypeId = accountRecordTypeId,
                                    OB_Employees_Number__c='Minore di 10',
                                    OB_VAT_Not_Present__c=true, 
                                    OB_DescriptionVATNotPresent__c='description', 
                                    NE__Fiscal_code__c='RSSMRA80A01F205X',
                                    OB_BypassValidation__c=true,
                                    OB_Status__c='Active',
                                    OB_ABI__c = '05117'); 
        insert acc;
 
        Map<String,Object> bankAccountMap = new Map<String,Object> ();
        bankAccountMap.put('bank', acc.id);

        NE__Order_Header__c orderHeader  = new NE__Order_Header__c();
        insert orderHeader;
        NE__Order__c order = new NE__Order__c(NE__Order_Header__c=orderHeader.Id);
        insert order; 

        NE__Service_Point__c servicePoint = new NE__Service_Point__c();
        insert servicePoint;

        Test.startTest();
        OB_MaintenanceAssetSummaryController.share(bankAccountMap, orderHeader, servicePoint, acc, false);
        Test.stopTest();
    }

    @isTest
    public static void createLogRequestTest()
    { 
        Test.startTest();
        // UserRole r = new UserRole(
        //     DeveloperName = 'MyCustomRole', 
        //     Name = 'My Role');
        // insert r;

        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            
            // UserRoleId = r.Id);
        );
        insert u;

        OB_Integration_Configuration__c ic = new OB_Integration_Configuration__c();
        ic.Name = 'DEV1';
        ic.OB_Domain__c = 'dev1';
        ic.OB_Token_1__c = 'eyJ0eXAiOiJKV1QiLCJjdHkiOiJKV1QiLCJhbGciOiJSU0EtT0FFUCIsImVuYyI6IkExMjhDQkMtSFMyNTYifQ.nynF9045u2M-1WGn007JxObPiM3PBK0Q4GM8EBwQS0o6fJutTABfMSTtekOlCpQEv4vKSLmj0-Rgk5rQgireCX-cOp_Vvh9IYLl6xfOJfUR8f5mLUmY4r7BGrWtLbaM5wwTIJXQs8kFpp2VIePragkN2MahtjIOtBp1vQW2y';
        ic.OB_timestamp__c = '1542902538147';
        ic.OB_Timeout_Continuation__c = '30';
        insert ic;
        
       

        NE__Order_Header__c oh = new NE__Order_Header__c( 
                                        OB_Business_Model_Acquiring__c = 'Bancario', 
                                        OB_Business_Model_POS__c = 'Trilaterale Nuovo', 
                                        OB_Main_Process__c = 'Setup');
        insert oh;
        NE__Order__c ord = new NE__Order__c(NE__Order_Header__c = oh.id,
                                            OB_AdditionalDocumentationRequired__c = true);            
         insert ord;

        Id recordTypeIdProd = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get('Terminali').getRecordTypeId();
        NE__Product__c prod = new NE__Product__c(   Name                = 'test ',
                                                    OB_Contract_Type__c = 'Contratto POS;Modulo Off Commercial',
                                                    RecordTypeId        = recordTypeIdProd);

        insert prod;

        Id recordTypeIdTerm = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByName().get('Terminali').getRecordTypeId();
        NE__OrderItem__c orderItemP = new NE__OrderItem__c(NE__OrderId__c = ord.id, 
                                                           NE__ProdId__c  = prod.Id, 
                                                           NE__Qty__c     = 1,
                                                           OB_VariationPOSPB__c = 'PEGGIORATIVA'
                                                        );
        orderItemP.RecordTypeId = recordTypeIdTerm;

        List<NE__OrderItem__c> orderItemPOS = new List<NE__OrderItem__c>();
        orderItemPOS.add(orderItemP);
        insert orderItemPOS;
        System.debug('orderItemPOS = ' + orderItemPOS);

        Id recordTypeIdProd1 = Schema.SObjectType.NE__Product__c.getRecordTypeInfosByName().get('Acquiring').getRecordTypeId();
        NE__Product__c prod1 = new NE__Product__c(   Name                = 'test ',
                                                    OB_Contract_Type__c = 'Contratto POS;Modulo Off Commercial',
                                                    RecordTypeId        = recordTypeIdProd1);

        insert prod1;

        Id recordTypeIdAcq = Schema.SObjectType.NE__OrderItem__c.getRecordTypeInfosByName().get('Acquiring').getRecordTypeId();
        NE__OrderItem__c orderItemV = new NE__OrderItem__c(NE__OrderId__c        = ord.id, 
                                                            NE__Qty__c           = 1,
                                                            NE__ProdId__c        = prod1.Id,
                                                            OB_VariationPOSPB__c = 'PEGGIORATIVA'
                                                        );
        orderItemV.RecordTypeId = recordTypeIdAcq;

        List<NE__OrderItem__c> orderItemAcqVAS = new List<NE__OrderItem__c>();
        orderItemAcqVAS.add(orderItemV);
        insert orderItemAcqVAS;

        Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Merchant').getRecordTypeId();
        Account acc = new Account(  Name='TEST',
                                    RecordTypeId = accountRecordTypeId,
                                    OB_Employees_Number__c = 'Minore di 10',
                                    OB_VAT_Not_Present__c  = true, 
                                    OB_DescriptionVATNotPresent__c ='description', 
                                    NE__Fiscal_code__c ='RSSMRA80A01F205X',
                                    OB_BypassValidation__c = true,
                                    OB_Status__c ='Active',
                                    OB_ABI__c = '05116');
        insert acc;

        NE__Service_Point__c servicePoint = new NE__Service_Point__c();
        insert servicePoint;

        String merchantId = acc.id;
        String servicePointId = servicePoint.id; 
        String confId = ord.id;
        String abi = '05116'; 
        String cab = '12345';
        String subProcessVariazioneEconomica = 'variazione economica';
        String subProcessVariazioneOperativa = 'variazione operativa';

        OB_LogRequest__c logReq = new OB_LogRequest__c();
         logReq.OB_OrderId__c = ord.id;
         insert logReq;

        // <daniele.gandini@accenture.com> - 05/07/2019 - TerminaOfferta_LogRequStatus - start
        String subProcessterminaofferta = 'termina offerta';
        OB_MaintenanceAssetSummaryController.createLogRequest(merchantId, servicePointId, confId, abi, cab, subProcessterminaofferta,true);
        // <daniele.gandini@accenture.com> - 05/07/2019 - TerminaOfferta_LogRequStatus - stop

        OB_MaintenanceAssetSummaryController.createLogRequest(merchantId, servicePointId, confId, abi, cab, subProcessVariazioneEconomica,true);
        OB_MaintenanceAssetSummaryController.createLogRequest(merchantId, servicePointId, confId, abi, cab, subProcessVariazioneOperativa,true);
        OB_MaintenanceAssetSummaryController.createLogRequest(merchantId, null, confId, abi, cab, subProcessVariazioneOperativa,true);
        Test.stopTest();
    }
    
    /*
    * Author		:		Morittu Andrea
    * Date			:		30-Sept-2019
    * Task			:		PRODOB_469
    * Description	:		Covering getMCCdescriptionByLOV
    */	
	public static void getMCCdescriptionByLOV_Test() {
      Test.startTest();
		OB_MaintenanceAssetSummaryController.getMCCdescriptionByLOV();
      Test.stopTest();
    }

    @isTest
    public static void getMerchantTakeoverTest(){
        Id assId = [SELECT Id from Asset LIMIT 1].Id;
        OB_MaintenanceAssetSummaryController.getMerchantTakeoverFromAsset(assId);
    }

        @isTest
    public static void updateABIandCABrTest(){
        Id assId = [SELECT Id from Asset LIMIT 1].Id;
        OB_MaintenanceAssetSummaryController.updateABIandCABInsideAssetObj(assId,'abc');
    }

               /**
    *@author Elena Preteni <elena.preteni@accenture.com>
    *@date 04/07/02018
    */
        @isTest
    public static void launchMaintenanceWizard_Test()
    {
       
        Test.startTest();
        OB_MaintenanceAssetSummaryController.launchMaintenanceWizard('OB_Catalogo_Nuovo_Contratto');
        Test.stopTest();

    } 
                   /**
    *@author Elena Preteni <elena.preteni@accenture.com>
    *@date 04/07/02018
    */
        @isTest
    public static void getMerchantTakeoverFromAsset_Test()
    {
       
        Test.startTest();
         Asset a = [SELECT id , name from Asset  LIMIT 1];
        OB_MaintenanceAssetSummaryController.getMerchantTakeoverFromAsset(a.id);
        Test.stopTest();

    } 
                      /**
    *@author Elena Preteni <elena.preteni@accenture.com>
    *@date 04/07/02018
    */
        @isTest
    public static void updateABIandCABInsideAssetObj_Test()
    {
       
        Test.startTest();
         Asset a = [SELECT id , name from Asset  LIMIT 1];
        OB_MaintenanceAssetSummaryController.updateABIandCABInsideAssetObj(a.id,'12300');
        Test.stopTest();

    } 
 /*
    * Author		:		Francesca Ribezzi
    * Date			:		11-11-2019
    * Task			:		PROD-42
    * Description	:		Covering getCABandABIfromOrder
    */	
    @isTest
	public static void getCABandABIfromOrder_Test() {
        NE__Order_Header__c oh = OB_TestDataFactory.getOrderHeader();
        insert oh;
        NE__Order__c o = new NE__Order__c();
        o.NE__Order_Header__c = oh.id;
        o.OB_ABI__c = '03138';
        o.OB_CAB__c = '12300';
        insert o;
        Asset a = OB_TestDataFactory.getAsset();
        a.NE__Order_Config__c = o.Id;
        insert a;
        Test.startTest();
            OB_MaintenanceAssetSummaryController.getCABandABIfromOrder(o.Id); 
        Test.stopTest();
    }

    /*
	*	Author		:	Gianluigi Virga	
	*	Date		:	27-11-2019
	*	Task		:	Performance
	*	Description	:	test method for retrieveLineItemsAndItemAttributes
	*/
    @isTest
    public static void retrieveLineItemsAndItemAttributes_Test() {
        NE__Family__c fam = OB_TestDataFactory.getFamily();
        insert fam;
        NE__DynamicPropertyDefinition__c dPD = OB_TestDataFactory.getDynamicPropertyDefinition();
        insert dPD;
        NE__Order_Header__c oh = OB_TestDataFactory.getOrderHeader();
        insert oh;
        DateTime dT = Datetime.newInstance(2019, 11, 11);
        NE__Order__c o = new NE__Order__c();
        o.NE__Order_Header__c = oh.id;
        o.OB_ABI__c = '03138';
        o.OB_CAB__c = '12300';
        o.OB_Business_Model_Acquiring__c = 'Bancario';
        o.NE__Order_date__c = dt;
        insert o;
        
        Id cItemRT = Schema.SObjectType.NE__Catalog_Item__c.getRecordTypeInfosByName().get('Pricing').getRecordTypeId();
        NE__Catalog__c cat = OB_TestDataFactory.getCatalog();
        insert cat;
        NE__Product__c prod = OB_TestDataFactory.getProduct();
        insert prod;
        NE__Catalog_Item__c catItem = OB_TestDataFactory.getCatalogItem(cat.id, prod.id);
        catItem.RecordTypeId = cItemRT;
        insert catItem;
        NE__Bundle__c bundle = new NE__Bundle__c();
        bundle.NE__RecurringChargeFrequency__c = 'Monthly';
        bundle.NE__Start_Date__c = date.newinstance(dT.year(), dT.month(), dT.day());
        insert bundle;
        Asset a = OB_TestDataFactory.getAsset();
        a.Name = 'Offerta Personalizzata';
        a.NE__Order_Config__c = o.Id;
        a.NE__Bundle__c = bundle.Id;
        insert a;
        Asset ass = OB_TestDataFactory.getAsset();
        ass.NE__Order_Config__c = o.Id;
        ass.NE__Bundle_Configuration__c = a.Id;
        ass.NE__Status__c = 'Active';
        ass.NE__CatalogItem__c = catItem.id;
        insert ass;
        NE__ProductFamilyProperty__C famProp = OB_TestDataFactory.getProductFamilyProperty(fam.id, dPD.id);
        insert famProp;
        NE__AssetItemAttribute__c assAttr = OB_TestDataFactory.getAssetItemAttribute(ass.id);
        assAttr.ob_attribute_code__c = 'TEST';
        assAttr.NE__FamPropId__c = famProp.id;
        assAttr.NE__Asset__c = ass.id;
        insert assAttr;
        NE__Matrix_Parameter__c mp = OB_TestDataFactory.getMatrixParameter();
        mp.Name = 'CatalogoNexi';
        insert mp;
        List<NE__Matrix_Parameter_row__c> listOfMprRows = new List<NE__Matrix_Parameter_row__c>();
        NE__Matrix_Parameter_row__c mprSelfRow = OB_TestDataFactory.getMatrixParameterRow(mp.Id);
        insert mprSelfRow;
        NE__Matrix_Parameter_row__c mprow = new NE__Matrix_Parameter_row__c();
        mprow.NE__Matrix_Parameter__c = mp.Id;
        mpRow.OB_SelfLookup__c = mprSelfRow.Id;
        mprow.OB_CatalogItem__c = catItem.id;
        mprow.OB_Codici__c = 'TEST';
        mprow.OB_Componente__c = catItem.id;
        mprow.OB_Family__c = fam.id;
        mprow.OB_DynamicPropertyDefinition__c = dPD.id; 
        mprow.OB_ActiveBank__c = true;
        mpRow.OB_ABI_BANCA__c = '03138';
		Date orderDate = date.newinstance(dT.year(), dT.month(), dT.day());
        mpRow.NE__Start_Date__c = orderDate;
        mpRow.OB_Offerta_2__c = bundle.Id;
        mpRow.OB_ModelloAcquiring__c = 'Bancario';
        mpRow.NE__End_Date__c = null;        
        insert mpRow;
        Test.startTest();
            OB_MaintenanceAssetSummaryController.retrieveLineItemsAndItemAttributes(a.Id, o.id); 
            System.assertNotEquals(assAttr.ob_attribute_code__c, null);
        Test.stopTest();
    }

    /*
	*	Author		:	Gianluigi Virga	
	*	Date		:	27-11-2019
	*	Task		:	Performance
	*	Description	:	test method for getMCCdescriptionByLOV
	*/
    @isTest
    public static void getMCCdescriptionByLOV_TestMethod() {
        List<NE__LOV__c> allLov =  new List<NE__LOV__c>();
        NE__LOV__c singleLov = new NE__LOV__c();
        singleLov.Name = 'TEST';
        singleLov.NE__Active__c = true;
        insert singleLov;
        Test.startTest();
            List<NE__LOV__c> lovList = OB_MaintenanceAssetSummaryController.getMCCdescriptionByLOV(); 
            System.assertNotEquals(lovList, null);
        Test.stopTest();

    }

}