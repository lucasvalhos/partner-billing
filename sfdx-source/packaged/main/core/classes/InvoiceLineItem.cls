/** @Description
*   This is the decorator object for the custom object InvoiceLineItem__c.
*/
public class InvoiceLineItem {

    /** @Description    The decorated original SObject */
    @AuraEnabled
    public InvoiceLineItem__c Record {public get; private set;}

    /** @Description    Reference to the parent invoice of this line item */
    public Invoice Invoice {public get; private set;}

    /** @Description    Defines all record fields that can not be edited, if the related invoice is locked */
    public static final Set<String> ACTIVATED_LOCKED_FIELDS = new Set<String>{
        'Amount__c',
        'Description__c',
        'Discount__c',
        'Price__c',
        'Product__c',
        'Quantity__c',
        'ServiceDate__c',
        'Tax__c',
        'Unit__c'
    };

    /** @Description    Create Decorator from original SObject record */
    public InvoiceLineItem(InvoiceLineItem__c originalRecord) {
        Record = originalRecord;
    }

    /** @Description
    *   Sets the invoice lookup and the invoice id in master detail relationship.
    *   This method does not try to overwrite an existing invoice id and only works on new line items.
    *
    *   @param  parentInvoice   The invoice that will be set
    *   @return                 True, if the line item is now detail of invoice. False, if not.
    */
    public Boolean setInvoice(Invoice parentInvoice) {
        this.Invoice = parentInvoice;
        if (String.isBlank(Record.Invoice__c)) Record.Invoice__c = parentInvoice.Record.Id;
        return Record.Invoice__c == parentInvoice.Record.Id;
    }

    /** @Description
    *   Updates the internal record's fields with only those fields that
    *   are populated on the new record. Does not overwrite unpopulated fields
    *
    *   @param  newRecord   Updated record
    */
    public InvoiceLineItem__c updateRecord(InvoiceLineItem__c newRecord) {
        for (String populatedField : newRecord.getPopulatedFieldsAsMap().keySet()) {
            if (Schema.SObjectType.InvoiceLineItem__c.fields.getMap().get(populatedField).getDescribe().isUpdateable()) {
                Record.put(populatedField, newRecord.get(populatedField));
            }
        }
        return Record;
    }

}
