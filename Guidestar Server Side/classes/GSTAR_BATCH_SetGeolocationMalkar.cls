global class GSTAR_BATCH_SetGeolocationMalkar implements Database.Batchable<SObject>, Database.AllowsCallouts{
	
	global Database.QueryLocator start(Database.BatchableContext bc){
		String queryStr = 'Select Name, field, field, field , field '; 
		queryStr += ' from obj where field = true AND field != null AND field = false '; 
		queryStr += ' AND (s = null OR s = null OR  field = true)  '; 
		queryStr += ' LIMIT 2500 ';
		system.debug(queryStr);
        return Database.getQueryLocator(queryStr);
    }
    
    global void execute(Database.BatchableContext bc, List<obj> malkars){
    	List<obj> toUpdate = new List<obj>();
        for(obj malkar : malkars){
        	Utils.Geolocation geo = Utils_HttpRequests.getAddressGeolocation(getMalkarAddress(malkar) + ' , ישראל');
        	if(geo != null){
        		malkar.s = geo.lat;
        		malkar.s = geo.lng;
        		malkar.field = false;
        	}
        	else{
        		malkar.field = true;
        	}
        	toUpdate.Add(malkar);
        }
        if(!toUpdate.isEmpty()){
        	update toUpdate;
        }
    }
    
    public static String getMalkarAddress(obj malkar){
	    String addr = '';
	    if (String.isNotBlank(malkar.field)) addr += malkar.field + ' ';
	    if (String.isNotBlank(malkar.field)) addr += malkar.field;
	    if (String.isNotBlank(malkar.field)) addr += ', ' + malkar.field;
	    if (String.isNotBlank(malkar.field)) addr += ', ' + malkar.field;
	    return addr;	
    }

	global void finish(Database.BatchableContext bc){
	}
}