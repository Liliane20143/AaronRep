@isTest
public class OB_Asset2Order_Test {
@testSetup
    static void setup() 
    {   
        NE__Map__c mp = new NE__Map__c(NE__Map_Name__c = 'StdAsset2Order');
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

        NE__assetitemattribute__c a = new NE__assetitemattribute__c();
        a.NE__value__c ='123';
        a.Name = 'Test';
        a.NE__Asset__c = ass.id;

        insert a; 
          


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
}