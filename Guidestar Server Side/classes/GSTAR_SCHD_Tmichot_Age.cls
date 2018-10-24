global class GSTAR_SCHD_Tmichot_Age implements Schedulable{

    global void execute(SchedulableContext sc) {
        Database.executeBatch(new GSTAR_BATCH_Tmichot_Age());
    }
}