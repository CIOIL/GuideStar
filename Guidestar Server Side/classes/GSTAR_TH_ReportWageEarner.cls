public class GSTAR_TH_ReportWageEarner {

	public static void createExternalIdField(List<obj> newlist){
		Set<String> fieldNames = new Set<String>{'Id','c'};
        Set<Id> idSet = new Set<Id>();
        for (obj rwe : newlist){
            idSet.add(rwe.obj);
        }
        Map<Id, obj> malkarMap = new Map<Id, obj>(GSTAR_DAL.getMalkarsByIds(fieldNames, idSet)); 
        for (obj rwe : newlist){
            rwe.c = malkarMap.get(rwe.obj).c + '_' + rwe.c;
        }
	}

	public static void linkToParentMalkar(List<obj> newlist){
		Decimal currentYear = Date.today().year();
		List<obj> relevantRecords = new List<obj>();
		for (obj rwe : newlist){
			if (rwe.c){
				relevantRecords.add(rwe);
			}
		}
		if (relevantRecords.size() == 0){
			return;
		}
        Map<Id, obj> reportWageEarnerSortedByMalkar = new Map<Id, obj>();
        Map<Object, SObject> retMap = Utils.sortSObjects(relevantRecords, 'c', 'obj');
        for (Object obj : retMap.keySet()){
            reportWageEarnerSortedByMalkar.put((Id)obj, (obj)retMap.get(obj));
        }
        Set<string> fieldNames = new Set<string>{'Id', 'c', 'r.c'};
        List<obj> toUpdate = new List<obj>();
        Map<Id, obj> parentMap = new Map<Id, obj>(GSTAR_DAL.getMalkarsByIds(fieldNames, reportWageEarnerSortedByMalkar.keySet()));
        for (obj rwe : reportWageEarnerSortedByMalkar.values()){
            obj parentMalkar = parentMap.get(rwe.obj);
            if(parentMalkar != null && rwe.c != null){
            	if (parentMalkar.c == null || parentMalkar.r.c < rwe.c){
                    if (Integer.valueOf(rwe.c) <= currentYear && rwe.c == true){
                        parentMalkar.c = rwe.Id;
                        toUpdate.add(parentMalkar);
                    }
                } 	   
            }
        }
        if (toUpdate.size() > 0){
            update toUpdate;
        }
	}
}