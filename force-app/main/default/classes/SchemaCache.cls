/**
 * Transaction-scoped describe cache.
 *
 * All describe access in this codebase MUST go through this class rather than
 * calling Schema methods directly -- repeated describe calls are a documented
 * source of CPU-limit pressure in large transactions.
 *
 * See docs/CODING_STANDARDS.md ("Describe & Schema Caching").
 */
public with sharing class SchemaCache {

    private static Map<String, Schema.DescribeSObjectResult> objectCache =
        new Map<String, Schema.DescribeSObjectResult>();
    private static Map<String, Map<String, Schema.SObjectField>> fieldCache =
        new Map<String, Map<String, Schema.SObjectField>>();

    public static Schema.DescribeSObjectResult getDescribe(SObjectType objType) {
        String key = String.valueOf(objType);
        if (!objectCache.containsKey(key)) {
            objectCache.put(key, objType.getDescribe());
        }
        return objectCache.get(key);
    }

    public static Map<String, Schema.SObjectField> getFields(SObjectType objType) {
        String key = String.valueOf(objType);
        if (!fieldCache.containsKey(key)) {
            fieldCache.put(key, getDescribe(objType).fields.getMap());
        }
        return fieldCache.get(key);
    }

    public static Schema.SObjectField getField(SObjectType objType, String fieldName) {
        return getFields(objType).get(fieldName.toLowerCase());
    }
}
