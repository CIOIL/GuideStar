global class GSTAR_BATCH_SetGeolocationCity implements Database.Batchable<SObject>, Database.AllowsCallouts{
	
	global Database.QueryLocator start(Database.BatchableContext bc){
		String queryStr = 'Select Name from field where s = null or s = null  limit 2500';
        return Database.getQueryLocator(queryStr);
    }
    
    global void execute(Database.BatchableContext bc, List<field> cities){
    	List<field> toUpdate = new List<field>();
        for(field city : cities){
        	Utils.Geolocation geo = Utils_HttpRequests.getAddressGeolocation(city.Name + ' , ישראל');
        	if(geo != null){
        		city.s = geo.lat;
        		city.s = geo.lng;
        		toUpdate.Add(city);
        	}
        }
        if(!toUpdate.isEmpty()){
        	update toUpdate;
        }
    }

	global void finish(Database.BatchableContext bc){
	}
}