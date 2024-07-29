public with sharing class OpportunityTriggerHandler {

    public static void beforeUpdateHandler(Opportunity[] updatedOpportunities) {
        Set<Id> accountIds = new Set<Id>();
        for (Opportunity opp : updatedOpportunities) {
            if (opp.AccountId != null) {
                accountIds.add(opp.AccountId);
            }
        }

        Map<Id, Contact> contactsByAccountId = new Map<Id, Contact>();
        for (Account acc : [SELECT Id, (SELECT Id FROM Contacts WHERE Title='CEO' LIMIT 1) FROM Account WHERE Id IN :accountIds]) {
            if (!acc.Contacts.isEmpty()) {
                contactsByAccountId.put(acc.Id, acc.Contacts[0]);
            }
        }

        for (Opportunity opp : updatedOpportunities) {
            if (opp.Amount <= 5000) {
                opp.addError('Opportunity amount must be greater than 5000');
            }

            Contact contact = contactsByAccountId.get(opp.AccountId);
            if (contact != null && contact.Id != null) {
                opp.Primary_Contact__c = contact.Id;
            }
        }
    }

    public static void beforeDeleteHandler(Opportunity[] deletedOpportunities) {
        Set<Id> accountIds = new Set<Id>();
        for (Opportunity opp : deletedOpportunities) {
            if (opp.AccountId != null) {
                accountIds.add(opp.AccountId);
            }
        }

        Map<Id, Account> accounts = new Map<Id, Account>([
            SELECT Id, Industry
            FROM Account
            WHERE Id IN :accountIds
        ]);

        for (Opportunity opp : deletedOpportunities) {
            Account acc = accounts.get(opp.AccountId);
            if (opp.StageName == 'Closed Won' && acc != null && acc.Industry == 'Banking') {
                opp.addError('Cannot delete closed opportunity for a banking account that is won');
            }
        }
    }

}