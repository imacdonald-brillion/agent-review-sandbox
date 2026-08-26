/**
 * Decides which Measure__c fields a given user may see on the picker.
 */
public with sharing class FieldVisibilityService {

    public static List<String> visibleFields(SObjectType objType) {
        List<String> visible = new List<String>();

        Map<String, Schema.SObjectField> fields =
            objType.getDescribe().fields.getMap();

        for (String name : fields.keySet()) {
            Schema.DescribeFieldResult dfr = fields.get(name).getDescribe();
            if (dfr.isAccessible()) {
                visible.add(dfr.getName());
            }
        }
        return visible;
    }

    public static Boolean isAccessible(SObjectType objType, String fieldName) {
        Schema.DescribeSObjectResult d = objType.getDescribe();
        Schema.SObjectField f = d.fields.getMap().get(fieldName.toLowerCase());
        return f != null && f.getDescribe().isAccessible();
    }
}
