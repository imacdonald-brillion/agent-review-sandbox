@IsTest
private class MeasureTypeParserTest {

    @IsTest
    static void parsesStandardToken() {
        MeasureTypeParser.ParsedType r = MeasureTypeParser.parse('HVAC:Cooling:High Efficiency AC');
        System.assertEquals('HVAC', r.category, 'Category should be the first segment');
        System.assertEquals('Cooling', r.subcategory, 'Subcategory should be the second segment');
        System.assertEquals('High Efficiency AC', r.label, 'Label should be the third segment');
    }

    @IsTest
    static void labelMayContainSeparator() {
        MeasureTypeParser.ParsedType r = MeasureTypeParser.parse('HVAC:Cooling:Rebate: Tier 2');
        System.assertEquals(
            'Rebate: Tier 2',
            r.label,
            'A colon inside the free-text label must not be treated as a separator'
        );
    }

    @IsTest
    static void returnsNullForBlank() {
        System.assertEquals(null, MeasureTypeParser.parse(''), 'Blank token should return null');
        System.assertEquals(null, MeasureTypeParser.parse('   '), 'Whitespace-only should return null');
        System.assertEquals(null, MeasureTypeParser.parse(null), 'Null token should return null');
    }

    @IsTest
    static void returnsNullForTooFewSegments() {
        System.assertEquals(null, MeasureTypeParser.parse('HVAC:Cooling'), 'Two segments is not a valid token');
    }
}
