public with sharing class AccountTriggerHandler {

    public static void beforeInsertHandler(Account[] insertedAccounts) {
        for(Account acc : insertedAccounts) {
            if (acc.Type == null) {
                acc.Type = 'Prospect';
            }

            if (acc.Phone != null && acc.Website != null && acc.Fax != null) {
                acc.Rating = 'Hot';
            }

            acc.BillingStreet = acc.ShippingStreet;
            acc.BillingCity = acc.ShippingCity;
            acc.BillingState = acc.ShippingState;
            acc.BillingPostalCode = acc.ShippingPostalCode;
            acc.BillingCountry = acc.ShippingCountry;
        }
    }

    public static void afterInsertHandler(Account[] insertedAccounts) {
        List<Contact> relatedContacts = new List<Contact>();

        for(Account acc : insertedAccounts) {
            Contact relatedContact = new Contact(LastName='DefaultContact', Email='default@email.com', AccountId=acc.Id);
            relatedContacts.add(relatedContact);
        }

        insert relatedContacts;
    }

}