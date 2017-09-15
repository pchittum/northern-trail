global with sharing class MerchandiseMixController {

    @AuraEnabled
    public static List<Mix_Item__c> getMixItems(Id mixId) {
        return [SELECT Id, Merchandise__r.Name, Merchandise__r.Price__c, Merchandise__r.Category__c, Merchandise__r.Picture_URL__c, Qty__c 
                FROM Mix_Item__c
                WHERE Merchandising_Mix__c = :mixId];
    }
    
    @AuraEnabled
    public static Mix_Item__c addMixItem(Id mixId, Id productId, Decimal qty) {
		Mix_Item__c item = new Mix_Item__c();
        item.Merchandising_Mix__c = mixId;
        item.Merchandise__c = productId;
        item.Qty__c = 10;
        insert item;
		return item;
    }
        
	@AuraEnabled
    public static Mix_Item__c updateMixItem(Mix_Item__c mixItem) {
        // Check available stock
        Merchandise__c merch = [SELECT Name, Stock__c FROM Merchandise__c WHERE Id = :mixItem.Merchandise__r.Id];
        if (mixItem.Qty__c > merch.Stock__c) {
            throw new AuraHandledException('Insufficient stock. Available '+ merch.Name +': '+ merch.Stock__c);
        }
        // Update mix item
        update mixItem;
		return mixItem;
    } 

	@AuraEnabled
    public static Mix_Item__c removeMixItem(Id mixItemId) {
		Mix_Item__c item = new Mix_Item__c();
        item.Id = mixItemId;
        delete item;
		return item;
    } 
    
}