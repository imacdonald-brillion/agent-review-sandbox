/**
 * Parses the packed Measure_Type__c token.
 *
 * Format: "<category>:<subcategory>:<label>". The label is free text entered by
 * program admins and MAY itself contain a colon, so the split is limited -- the
 * label absorbs any remaining separators.
 */
public with sharing class MeasureTypeParser {

    public class ParsedType {
        public String category;
        public String subcategory;
        public String label;
    }

    public static ParsedType parse(String token) {
        if (String.isBlank(token)) {
            return null;
        }

        // Limit of 3: everything after the second colon stays in the label.
        List<String> parts = token.split(':', 3);
        if (parts.size() < 3) {
            return null;
        }

        ParsedType result   = new ParsedType();
        result.category     = parts[0].trim();
        result.subcategory  = parts[1].trim();
        result.label        = parts[2].trim();
        return result;
    }
}
