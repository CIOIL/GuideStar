trigger MalkarPerson_Trigger on obj (before insert, before update, after update, after insert) {

	if (trigger.isBefore){ 
        if (trigger.isUpdate){
            GSTAR_TH_MalkarPerson.creatExternalId(trigger.new);
        }
        else if (trigger.isInsert){
            GSTAR_TH_MalkarPerson.creatExternalId(trigger.new);
        }
    }
    else if (trigger.isAfter){
        if (trigger.isUpdate){

        }
        else if (trigger.isInsert){

        }
    }
}