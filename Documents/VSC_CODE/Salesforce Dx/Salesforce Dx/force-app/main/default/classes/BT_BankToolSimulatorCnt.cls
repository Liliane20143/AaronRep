/**
* @author Raffaele Fioratto
* @date Creation 17/10/2018
* @description BT_BankToolSimulatorCnt - Apex controller for BT_BankToolSimulator Lightning Component, AKA fun with maps ;)
*/
public class BT_BankToolSimulatorCnt {

    enum AggregateOperator {
        SUM,
        AVG
    }

    enum ComparisonOperator {
        LT,
        LTE,
        GT,
        GTE
    }

    enum MathOperator {
        ADD,
        SUB,
        MUL,
        DIV
    }

    private static Map<String, List<String>> aggregateToProducts = new Map<String, List<String>> {
        'cdp' => new List<String>{'visaconsumercredit', 'visaconsumerprepaid', 'visaconsumerdebit', 'vpayconsumerdebit', 'vpayconsumerprepaid', 'mastercardconsumercredit',
        'mastercardconsumerdebit', 'mastercardconsumerprepaid', 'maestroconsumerdebit', 'maestroconsumerprepaid'},
        'comm' => new List<String>{'visacommercial', 'maestrocommercial', 'mastercardcommercial'},
        'pb' => new List<String>{'pagobancomat'},
        'asian' => new List<String>{'jcb', 'upi'}
    };

    private static List<String> herokuFixedStringFields = new List<String> {
        'mcc', 'macrocatmerceologica', 'cap', 'provincia', 'scaglione' };
        
    private static List<String> herokuFixedDecimalFields = new List<String> {
        'negoziatoannomin', 'negoziatoannomax', 'fatturatoannomin', 'fatturatoannomax', 'incrpercnegfatt'
    };

    private static List<String> configRecordPOSFixedFields = new List<String> {
        'MobilePosSmart', 'PosCordlessWifiPremium', 'PosCordSmartPstnEth', 'PosPortatile3gPremium', 'PosPortatileGprsSmart', 'PosTradizionalePremium',
        'PosTradSmartPstnEth', 'Smartpos', 'SmartposCassa', 'SmartposCassaPremium', 'SmartposPremium'
    };

    private static List<String> configRecordFeesFixedFields = new List<String> {
        'PermettiStampaMargNegCommissioni', 'PermettiStampaMargNegPOS',
        'MarginalitaDesiderataTOTPreventivo', 'PermettiInvioMailDeroga'
    };

    /**
    * @author Raffaele Fioratto
    * @date 18/10/2018
    * @description aggregates a set of fields using the specified operation and stores the result in a new map with the supplied keys
    * @param originalMap - Map<String, Object> the source map that contains the data to aggregate
    * @param aggregationMap - Map<String, List<String>> the mapping between aggregation key and the set of original fields to aggregate
    * @param prefix - String an optional string to prepend to the field in the aggregationMap
    * @param suffix - String an optional string to append to the field in the aggregationMap
    * @param op - AggregateOperator the operation to perform while aggregating
    * @param scale - Integer the number of decimal fields to consider of the resulting Decimal
    * @return Map<String, Decimal> - the resulting map, the keys are the same supplied in the @param aggregationMap
    *
    */
    private static Map<String, Decimal> computeAggregate(Map<String, Object> originalMap, Map<String, List<String>> aggregationMap, String prefix, String postfix, AggregateOperator op, Integer scale) {
        Map<String, Decimal> aggregationResult = new Map<String, Decimal>();
        String format = '{0}{1}{2}';
        for (String aggregateKey : aggregationMap.keySet()) {
            Decimal accumulator = 0;
            Decimal n = 0;
            Decimal result;
            for (String field : aggregationMap.get(aggregateKey)) {
                String actualField = String.format(format, new List<String>{prefix, field, postfix});
                if (originalMap.containsKey(actualField)) {
                    n++;
                    if (originalMap.get(actualField) instanceof Decimal) {
                        accumulator += (Decimal) originalMap.get(actualField);
                    } else {
                        accumulator += originalMap.get(actualField) == null ? 0 : Decimal.valueOf(originalMap.get(actualField).toString());
                    }
                }
            }
            if (n > 0) {
                switch on op {
                    when SUM {
                        result = accumulator;
                    }
                    when AVG {
                        result = accumulator / n;
                    }
                }
                aggregationResult.put(String.format(format, new List<String>{prefix, aggregateKey, postfix}), result.setScale(scale));
            }
        }
        return aggregationResult;
    }

    /**
    * @author Raffaele Fioratto
    * @date 18/10/2018
    * @description aggregates a set of fields from an SObject using the specified operation and stores the result in a new map with the supplied keys
    * @param record - SObject the source record that contains the data to aggregate
    * @param aggregationMap - Map<String, List<String>> the mapping between aggregation key and the set of original fields to aggregate
    * @param prefix - String an optional string to prepend to the field in the aggregationMap
    * @param suffix - String an optional string to append to the field in the aggregationMap
    * @param op - AggregateOperator the operation to perform while aggregating
    * @param scale - Integer the number of decimal fields to consider of the resulting Decimal
    * @return Map<String, Decimal> - the resulting map, the keys are the same supplied in the @param aggregationMap
    *
    */
    private static Map<String, Decimal> computeAggregate(SObject record, Map<String, List<String>> aggregationMap, String prefix, String suffix, AggregateOperator op, Integer scale) {
        Map<String, Decimal> aggregationResult = new Map<String, Decimal>();
        Map<String, Schema.SObjectField> fieldMap = record.getSobjectType().getDescribe().Fields.getMap();
        String format = '{0}{1}{2}';
        for (String aggregateKey : aggregationMap.keySet()) {
            Decimal accumulator = 0;
            Decimal n = 0;
            Decimal result;
            for (String field : aggregationMap.get(aggregateKey)) {
                String actualField = String.format(format, new List<String>{prefix, field, suffix});
                if (fieldMap.containsKey(actualField)) {
                    n++;
                    if (record.get(actualField) instanceof Decimal) {
                        accumulator += (Decimal) record.get(actualField);
                    } else {
                        accumulator += record.get(actualField) == null ? 0 : Decimal.valueOf(record.get(actualField).toString());
                    }
                }
            }
            if (n > 0) {
                switch on op {
                    when SUM {
                        result = accumulator;
                    }
                    when AVG {
                        result = accumulator / n;
                    }
                }
                aggregationResult.put(String.format(format, new List<String>{prefix, aggregateKey, suffix}), result.divide(100, scale));
            }
        }
        return aggregationResult;
    }

    /**
    * @author Raffaele Fioratto
    * @date 18/10/2018
    * @description compares to maps of Decimals with the specified operator and stores the results in a new map using the keys of the left map.
    * @param left - Map<String, Decimal> the map containing the values used on the left hand side of the comparison
    * @param right - Map<String, Decimal> the map containing the values used on the right hand side of the comparison
    * @param op - ComparisonOperator the binary operator applied for comparing
    * @return Map<String, Decimal> - the resulting map, the keys are the same of the map @param left
    *
    */
    private static Map<String, Decimal> compareAndSelectValue(Map<String, Decimal> left, Map<String, Decimal> right, ComparisonOperator op) {
        Map<String, Decimal> resultMap = new Map<String, Decimal>();
        Integer i = 0;
        for(String leftKey : left.keySet()) {
            if (i < right.size())  {
                Decimal leftValue = left.values().get(i);
                Decimal rightValue = right.values().get(i);
                Decimal res = leftValue - rightValue; 
                switch on op {
                    when LT {
                        resultMap.put(leftKey, res < 0 ? leftValue : rightValue);
                    }
                    when LTE {
                        resultMap.put(leftKey, res <= 0 ? leftValue : rightValue);
                    }
                    when GT {
                        resultMap.put(leftKey, res < 0 ? rightValue : leftValue);
                    }
                    when GTE {
                        resultMap.put(leftKey, res <= 0 ? rightValue : leftValue);
                    }
                }
                i++;
            } else {
                break;
            }
        }
        return resultMap;
    }

    /**
    * @author Raffaele Fioratto
    * @date 18/10/2018
    * @description applies an arithmetic operation to maps of Decimals with the specified operator and stores the results in a new map using the keys of the left map.
    * @param left - Map<String, Decimal> the map containing the values used on the left hand side of the operation
    * @param right - Map<String, Decimal> the map containing the values used on the right hand side of the operation
    * @param op - MathOperator the binary arithmetic operator to apply
    * @return Map<String, Decimal> - the resulting map, the keys are the same of the map @param left
    *
    */
    private static Map<String, Decimal> doMathOnMaps(Map<String, Decimal> left, Map<String, Decimal> right, MathOperator op) {
        Map<String, Decimal> resultMap = new Map<String, Decimal>();
        Integer i = 0; 
        for(String leftKey : left.keySet()) {
            if (i < right.size()) {
                switch on op {
                    when ADD {
                        resultMap.put(leftKey, left.values().get(i) + right.values().get(i));
                    }
                    when SUB {
                        resultMap.put(leftKey, left.values().get(i) - right.values().get(i));
                    }
                    when MUL {
                        resultMap.put(leftKey, left.values().get(i) * right.values().get(i));
                    }
                    when DIV {
                        if (right.get(leftKey) != 0) {
                            resultMap.put(leftKey, left.values().get(i) / right.values().get(i));
                        } else {
                            resultMap.put(leftKey, 0);
                        }
                    }
                }
                i++;
            } else {
                break;
            }
        }
        return resultMap;
    } 

    /**
    * @author Raffaele Fioratto
    * @date 18/10/2018
    * @description reads a set of fields on a record and stores them on map optionally transforming the fields by prepending a prefix and a suffix
    * @param record - SObject the source record to read
    * @param fields - List<String> the list of fields to read
    * @param prefix - String an optional string to prepend to the keys used to populate the resulting map
    * @param suffix - String an optional string to append to the keys used to populate the resulting map
    * @return Map<String, Object> - the resulting map 
    *
    */
    private static Map<String, Object> copyFieldsFromRecord(SObject record, List<String> fields, String prefix, String suffix) {
        Map<String, Object> copyResult = new Map<String, Object>();
        String format = '{0}{1}{2}';
        Map<String, Schema.SObjectField> fieldMap = record.getSobjectType().getDescribe().Fields.getMap();
        for (String field : fields) {
            String actualField = String.format(format, new List<String>{prefix, field, suffix});
            if (fieldMap.containsKey(actualField)) {
                copyResult.put(actualField, record.get(actualField));
            }
        }
        return copyResult;
    }

    private static Map<String, Object> copyFieldsFromRecord(SObject record, List<String> fields, String prefix, String suffix, Integer scale, Decimal divisor) {
        Map<String, Object> copyResult = new Map<String, Object>();
        String format = '{0}{1}{2}';
        Map<String, Schema.SObjectField> fieldMap = record.getSobjectType().getDescribe().Fields.getMap();
        for (String field : fields) {
            String actualField = String.format(format, new List<String>{prefix, field, suffix});
            if (fieldMap.containsKey(actualField)) {
                if (record.get(actualField) instanceof Decimal && divisor != 0) {
                    copyResult.put(actualField, ((Decimal) record.get(actualField)).divide(divisor, scale));
                } else {
                    copyResult.put(actualField, record.get(actualField));
                }
            }
        }
        return copyResult;
    }

    /**
    *
    *
    *
    */
    private static Map<String, Object> extractFieldsFromMap(Map<String, Object> src, List<String> fields, String prefix, String suffix) {
        Map<String, Object> copyResult = new Map<String, Object>();
        String format = '{0}{1}{2}';
        for (String field : fields) {
            String actualField = String.format(format, new List<String>{prefix, field, suffix});
            if (src.containsKey(actualField)) {
                copyResult.put(actualField, src.get(actualField));
            }
        }
        return copyResult;
    }

    private static Map<String, Decimal> toDecimalValues(Map<String, Object> src, Integer scale, Decimal divideBy) {
        Map<String, Decimal> convertedResult = new Map<String, Decimal>();
        for (String srcKey : src.keySet()) {
            Decimal valueToStore;
            if (src.get(srcKey) instanceof Decimal) {
                valueToStore = ((Decimal) src.get(srcKey));
            } else {
                valueToStore = src.get(srcKey) == null ? 0 : Decimal.valueOf(src.get(srcKey).toString());
            }
            convertedResult.put(srcKey, valueToStore.divide(divideBy, scale));
        }
        return convertedResult;
    }

    private static Map<String, Object> overrideIfSet(Map<String, Object> left, Map<String, Object> right) {
        Map<String, Object> overriddenResult = new Map<String, Object>();
        for(String k: right.keySet()) {
            System.debug('RIGHT: ' + k + ', ' + right.get(k));
        }
        Integer i = 0; 
        for(String leftKey : left.keySet()) {
            System.debug('PUNTO DEBUG: ' + leftKey + ', ' + left.get(leftKey) + ', ' + right.values().get(i));
            if (i < right.size()) {
                if (right.values().get(i) != null) {
                    overriddenResult.put(leftKey, right.values().get(i));
                } else {
                    overriddenResult.put(leftKey, left.get(leftKey));
                }
            }
            i++;
        }
        return overriddenResult;
    }

    private static Map<String, Object> propagateAggregateDown(Map<String, Object> aggregateMap, Map<String, List<String>> aggregationMap, String prefix, String suffix) {
        Map<String, Object> result = new Map<String, Object>();
        String format = '{0}{1}{2}';

        for (String aggr : aggregationMap.keySet()) {
            String srcFormat = String.format(format, new List<String>{prefix, aggr, suffix});
            if (aggregateMap.containsKey(srcFormat)) {
                for (String product : aggregationMap.get(aggr)) {
                    result.put(String.format(format, new List<String>{prefix, product, suffix}), aggregateMap.get(srcFormat));
                }
            }
        }

        return result;
    }

    @AuraEnabled
    public static Boolean isReferral() {
        User runningUser = [SELECT Account.BT_IsReferral__c FROM User WHERE Id = :UserInfo.getUserId()];
        return runningUser.Account != null ? runningUser.Account.BT_IsReferral__c : false;
    }

    @AuraEnabled 
    public static Map<String, Object> loadConfiguration(String jsonParams, String simulationMode) {
        List<String> allProducts = new List<String>();
        for (String aggrKey : aggregateToProducts.keySet()) {
            allProducts.addAll(aggregateToProducts.get(aggrKey));
        }

        Map<String, Object> recordMap = (Map<String, Object>) JSON.deserializeUntyped(queryToHeroku(constructQueryParamsList(jsonParams)));
        BT_ConfigSimulator__c configRecord = BT_AdminCnt.loadRecord(true);

        Map<String, Object> returnedMap = new Map<String, Object>();

        returnedMap.putAll(extractFieldsFromMap(recordMap, herokuFixedStringFields, '', ''));
        returnedMap.putAll(toDecimalValues(extractFieldsFromMap(recordMap, herokuFixedDecimalFields, '', ''), 4, 1));

        // mix di transato per carta
        returnedMap.putAll(toDecimalValues(extractFieldsFromMap(recordMap, allProducts, 'neg', ''), 4, 1));
        returnedMap.putAll(toDecimalValues(extractFieldsFromMap(recordMap, allProducts, 'neg', 'eea'), 4, 1));

        // mix di transato aggregato
        returnedMap.putAll(computeAggregate(recordMap, aggregateToProducts, 'neg', '', AggregateOperator.SUM, 4));
        returnedMap.putAll(computeAggregate(recordMap, aggregateToProducts, 'neg', 'eea', AggregateOperator.SUM, 4));

        // merchant fees con gestione override da pannello admin
        Map<String, Decimal> mfeeFromHeroku = toDecimalValues(extractFieldsFromMap(recordMap, allProducts, 'mfee', ''), 4, 1);
        Map<String, Decimal> mfeeFromConfig = toDecimalValues(copyFieldsFromRecord(configRecord, allProducts, 'BT_Min_', '__c'), 4, 100);
        Map<String, Decimal> finalMfee = compareAndSelectValue(mfeeFromHeroku, mfeeFromConfig, ComparisonOperator.GT);
        returnedMap.putAll(finalMfee);

        Map<String, Decimal> mfeeEeaFromHeroku = toDecimalValues(extractFieldsFromMap(recordMap, allProducts, 'mfee', 'eea'), 4, 1);
        Map<String, Decimal> mfeeEeaFromConfig = toDecimalValues(copyFieldsFromRecord(configRecord, allProducts, 'BT_Min_', 'EEA__c'), 4, 100);
        returnedMap.putAll(compareAndSelectValue(mfeeEeaFromHeroku, mfeeEeaFromConfig, ComparisonOperator.GT));

        Map<String, Decimal> overriddenBenchmarks = toDecimalValues(overrideIfSet(extractFieldsFromMap(recordMap, allProducts, 'bench', ''), 
                                                        copyFieldsFromRecord(configRecord, allProducts, 'BT_Bench_', '__c', 4, 100)), 4, 1);
        returnedMap.putAll(overriddenBenchmarks);

        Map<String, Decimal> overriddenBenchmarksEea = toDecimalValues(overrideIfSet(extractFieldsFromMap(recordMap, allProducts, 'bench', 'eea'), 
                                                        copyFieldsFromRecord(configRecord, allProducts, 'BT_Bench_', 'EEA__c', 4, 100)), 4, 1);
        returnedMap.putAll(overriddenBenchmarksEea);
        
        switch on simulationMode {
            when 'basic' {
                // merchant fees con gestione override da pannello admin
                Map<String, Decimal> aggrMfeeFromHeroku = computeAggregate(recordMap, aggregateToProducts, 'mfee', '', AggregateOperator.AVG, 4);
                Map<String, Decimal> aggrMfeeFromConfig = computeAggregate(configRecord, aggregateToProducts, 'BT_Min_', '__c', AggregateOperator.AVG, 2);
                Map<String, Decimal> finalAggrMfee = compareAndSelectValue(aggrMfeeFromHeroku, aggrMfeeFromConfig, ComparisonOperator.GT);
                returnedMap.putAll(finalAggrMfee);

                returnedMap.putAll(propagateAggregateDown(computeAggregate(configRecord, aggregateToProducts, 'BT_IF_', '__c', AggregateOperator.AVG, 4),
                    aggregateToProducts, 'BT_IF_', '__c'));
                returnedMap.putAll(propagateAggregateDown(computeAggregate(configRecord, aggregateToProducts, 'BT_Oneri_', '__c', AggregateOperator.AVG, 4),
                    aggregateToProducts, 'BT_Oneri_', '__c'));
                returnedMap.putAll(propagateAggregateDown(computeAggregate(configRecord, aggregateToProducts, 'BT_Costo_', '__c', AggregateOperator.AVG, 4),
                    aggregateToProducts, 'BT_Costo_', '__c'));

                // maggiorazione extra eea
                Map<String, Decimal> aggrMfeeEeaFromHeroku = computeAggregate(recordMap, aggregateToProducts, 'mfee', 'eea', AggregateOperator.AVG, 4);
                Map<String, Decimal> aggrMfeeEeaFromConfig = computeAggregate(configRecord, aggregateToProducts, 'BT_Min_', 'EEA__c', AggregateOperator.AVG, 4);
                Map<String, Decimal> finalAggrMfeeEea = compareAndSelectValue(aggrMfeeEeaFromHeroku, aggrMfeeEeaFromConfig, ComparisonOperator.GT);
                returnedMap.putAll(finalAggrMfeeEea);

                returnedMap.putAll(propagateAggregateDown(computeAggregate(configRecord, aggregateToProducts, 'BT_IF_', 'EEA__c', AggregateOperator.AVG, 4),
                    aggregateToProducts, 'BT_IF_', 'EEA__c'));
                returnedMap.putAll(propagateAggregateDown(computeAggregate(configRecord, aggregateToProducts, 'BT_Oneri_', 'EEA__c', AggregateOperator.AVG, 4),
                    aggregateToProducts, 'BT_Oneri_', 'EEA__c'));
                returnedMap.putAll(propagateAggregateDown(computeAggregate(configRecord, aggregateToProducts, 'BT_Costo_', 'EEA__c', AggregateOperator.AVG, 4),
                    aggregateToProducts, 'BT_Costo_', 'EEA__c'));
                
                // benchmark
                returnedMap.putAll(computeAggregate(overriddenBenchmarks, aggregateToProducts, 'bench', '', AggregateOperator.AVG, 4));

                // maggiorazione extra eea
                returnedMap.putAll(computeAggregate(overriddenBenchmarksEea, aggregateToProducts, 'bench', 'eea', AggregateOperator.AVG, 4));
            } when 'advanced' {
                Map<String, List<String>> visamc = new Map<String, List<String>>();
                List<String> products = new List<String>(aggregateToProducts.get('cdp'));
                products.addAll(aggregateToProducts.get('comm'));
                visamc.put('visamc', products);

                returnedMap.putAll(computeAggregate(overriddenBenchmarks, visamc, 'bench', '', AggregateOperator.AVG, 4));
                returnedMap.putAll(computeAggregate(finalMfee, visamc, 'mfee', '', AggregateOperator.AVG, 4));

                Map<String, Decimal> tmpDeltaBenchFromHeroku = doMathOnMaps(overriddenBenchmarksEea, overriddenBenchmarks, MathOperator.SUB);
                
                Map<String, Decimal> deltaBenchFromHeroku = new Map<String, Decimal>();
                for (String product : allProducts) {
                    if (tmpDeltaBenchFromHeroku.containsKey('bench' + product + 'eea')) {
                        deltaBenchFromHeroku.put('deltabench' + product + 'eea', Math.max(0, tmpDeltaBenchFromHeroku.get('bench' + product + 'eea')));
                    }
                }
                returnedMap.putAll(deltaBenchFromHeroku);

                returnedMap.putAll(toDecimalValues(copyFieldsFromRecord(configRecord, allProducts, 'BT_IF_', '__c'), 4, 100));
                returnedMap.putAll(toDecimalValues(copyFieldsFromRecord(configRecord, allProducts, 'BT_IF_', 'EEA__c'), 4, 100));
                returnedMap.putAll(toDecimalValues(copyFieldsFromRecord(configRecord, allProducts, 'BT_Oneri_', '__c'), 4, 100));
                returnedMap.putAll(toDecimalValues(copyFieldsFromRecord(configRecord, allProducts, 'BT_Oneri_', 'EEA__c'), 4, 100));
                returnedMap.putAll(toDecimalValues(copyFieldsFromRecord(configRecord, allProducts, 'BT_Costo_', '__c'), 4, 100));
                returnedMap.putAll(toDecimalValues(copyFieldsFromRecord(configRecord, allProducts, 'BT_Costo_', 'EEA__c'), 4, 100));
            }
        }

        // tabella POS
        returnedMap.putAll(copyFieldsFromRecord(configRecord, configRecordPOSFixedFields, 'BT_Min_', '__c'));
        returnedMap.putAll(copyFieldsFromRecord(configRecord, configRecordPOSFixedFields, 'BT_Consigliato_', '__c'));
        returnedMap.putAll(copyFieldsFromRecord(configRecord, configRecordPOSFixedFields, 'BT_Enable_', '__c'));

        // marginalità
        returnedMap.putAll(copyFieldsFromRecord(configRecord, configRecordFeesFixedFields, 'BT_', '__c'));
        returnedMap.put('BT_MarginalitaDesiderataTOTPreventivo__c', ((Decimal) returnedMap.get('BT_MarginalitaDesiderataTOTPreventivo__c')).divide(100, 4));

        return returnedMap;
    }

    @AuraEnabled
    public static Map<String, Object> loadReferralConfigurations(String jsonParams, String simulationMode) {
        Map<String, Object> paramsMap = (Map<String, Object>) JSON.deserializeUntyped(jsonParams); 
        Map<String, Object> recordMap = (Map<String, Object>) JSON.deserializeUntyped(queryToHeroku(constructQueryParamsList(jsonParams)));
        Decimal negoziato = 0;
        if (!paramsMap.containsKey('negoziato')) {
            negoziato = Decimal.valueOf((String) paramsMap.get('fatturato')) * Decimal.valueOf((String) recordMap.get('incrpercnegfatt'));
        } else {
            negoziato = Decimal.valueOf((String) paramsMap.get('negoziato'));
        }

        List<String> allProducts = new List<String>();
        for (String aggrKey : aggregateToProducts.keySet()) {
            allProducts.addAll(aggregateToProducts.get(aggrKey));
        }

        Map<String, Object> returnedMap = new Map<String, Object>();

        returnedMap.putAll(extractFieldsFromMap(recordMap, herokuFixedStringFields, '', ''));
        returnedMap.putAll(toDecimalValues(extractFieldsFromMap(recordMap, herokuFixedDecimalFields, '', ''), 4, 1));

        // mix di transato per carta
        returnedMap.putAll(toDecimalValues(extractFieldsFromMap(recordMap, allProducts, 'neg', ''), 4, 1));
        returnedMap.putAll(toDecimalValues(extractFieldsFromMap(recordMap, allProducts, 'neg', 'eea'), 4, 1));

        // mix di transato aggregato
        returnedMap.putAll(computeAggregate(recordMap, aggregateToProducts, 'neg', '', AggregateOperator.SUM, 4));
        returnedMap.putAll(computeAggregate(recordMap, aggregateToProducts, 'neg', 'eea', AggregateOperator.SUM, 4));

        List<BT_ConfigSimulator__c> offers = BT_AdminCnt.loadReferralRecords(true, negoziato, simulationMode);
        List<Map<String, Object>> offersMaps = new List<Map<String, Object>>();

        for(BT_ConfigSimulator__c offer : offers) {
            Map<String, Object> offerMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(offer));
            Map<String, Decimal> mfeeFromConfig = computeAggregate(offer, aggregateToProducts, 'BT_Min_', '__c', AggregateOperator.AVG, 4);
            Map<String, Decimal> mfeeEeaFromConfig = computeAggregate(offer, aggregateToProducts, 'BT_Min_', 'EEA__c', AggregateOperator.AVG, 4);

            offerMap.putAll(propagateAggregateDown(computeAggregate(offer, aggregateToProducts, 'BT_IF_', '__c', AggregateOperator.AVG, 4),
                aggregateToProducts, 'BT_IF_', '__c'));
            offerMap.putAll(propagateAggregateDown(computeAggregate(offer, aggregateToProducts, 'BT_Oneri_', '__c', AggregateOperator.AVG, 4),
                aggregateToProducts, 'BT_Oneri_', '__c'));
            offerMap.putAll(propagateAggregateDown(computeAggregate(offer, aggregateToProducts, 'BT_Costo_', '__c', AggregateOperator.AVG, 4),
                aggregateToProducts, 'BT_Costo_', '__c'));

            offerMap.putAll(propagateAggregateDown(computeAggregate(offer, aggregateToProducts, 'BT_IF_', 'EEA__c', AggregateOperator.AVG, 4),
                aggregateToProducts, 'BT_IF_', 'EEA__c'));
            offerMap.putAll(propagateAggregateDown(computeAggregate(offer, aggregateToProducts, 'BT_Oneri_', 'EEA__c', AggregateOperator.AVG, 4),
                aggregateToProducts, 'BT_Oneri_', 'EEA__c'));
            offerMap.putAll(propagateAggregateDown(computeAggregate(offer, aggregateToProducts, 'BT_Costo_', 'EEA__c', AggregateOperator.AVG, 4),
                aggregateToProducts, 'BT_Costo_', 'EEA__c'));

            offerMap.putAll(mfeeFromConfig);
            offerMap.putAll(mfeeEeaFromConfig);

            Map<String, Decimal> tmpDeltaBenchFromConfig = doMathOnMaps(mfeeEeaFromConfig, mfeeFromConfig, MathOperator.SUB);

            Map<String, Decimal> deltaBenchFromConfig = new Map<String, Decimal>();
            for (String productGroup : aggregateToProducts.keySet()) {
                if (tmpDeltaBenchFromConfig.containsKey('BT_Min_' + productGroup + 'EEA__c')) {
                    deltaBenchFromConfig.put('deltabench' + productGroup + 'eea', Math.max(0, tmpDeltaBenchFromConfig.get('BT_Min_' + productGroup + 'EEA__c')));
                }
            }
            offerMap.putAll(deltaBenchFromConfig);
            offersMaps.add(offerMap);
        }

        returnedMap.put('offers', offersMaps);

        return returnedMap;
    }

    @AuraEnabled
    public static String saveSimulation(BT_Simulation__c record) {
        User runningUser = [SELECT AccountId FROM User WHERE Id = :UserInfo.getUserId()];
        record.BT_Account__c = runningUser.AccountId;

        try {
            System.debug(record);
            insert record;
            return record.Id;
        } catch (Exception e) {
            throw new AuraHandledException('Errore durante il salvataggio della simulazione!');
        }
    }

    private static List<String> constructQueryParamsList(String jsonParams) {
        Map<String, Object> queryParamMap = (Map<String, Object>) JSON.deserializeUntyped(jsonParams);

        List<String> queryParams = new List<String>();
        for (String paramKey : queryParamMap.keySet()) {
            queryParams.add(paramKey + '=' + EncodingUtil.urlEncode((String) queryParamMap.get(paramKey), 'UTF-8'));
        }

        return queryParams;
    }

    private static String queryToHeroku(List<String> queryParams) {
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(String.format('callout:BT_Heroku/getData?{0}', new List<String>{String.join(queryParams, '&')}));
        HttpResponse res = h.send(req);
        if (res.getStatusCode() == 200) {
            return res.getBody();
        } else {
            throw new AuraHandledException('Errore nel caricamento dei dati.');
        }
    }
}