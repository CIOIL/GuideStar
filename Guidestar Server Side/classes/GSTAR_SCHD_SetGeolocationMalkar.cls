global class GSTAR_SCHD_SetGeolocationMalkar implements Schedulable {
    
    global void execute(SchedulableContext sc) {
    	Database.executeBatch(new GSTAR_BATCH_SetGeolocationMalkar(), 100);
    }
}