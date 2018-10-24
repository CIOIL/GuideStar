global class GSTAR_SCHD_Nihul_Takin_New_Year implements Schedulable {
    
    global void execute(SchedulableContext sc) {
    	Database.executeBatch(new GSTAR_BATCH_Nihul_Takin_New_Year());
    }
/*
GSTAR_SCHD_Nihul_Takin_New_Year SCH001 = new GSTAR_SCHD_Nihul_Takin_New_Year();
String sch = '0 0 1 1 1 ? *';
system.schedule('Nihul Takin New Year Job', sch, SCH001);
*/
}