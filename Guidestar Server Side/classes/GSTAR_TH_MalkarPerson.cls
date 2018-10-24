public class GSTAR_TH_MalkarPerson{

	public static void creatExternalId(List<obj> newList){
        Set<Id> idSet = getRealtedObjectIds(newList);
        Map<Id, Contact> contactMap = getLinkedContactMap(idSet);
        Map<Id, obj> malkarMap = getMalkarParentMap(idSet);
        for (obj mp : newlist){
            mp.c = malkarMap.get(mp.obj).c + '_' + mp.obj + '_' + mp.c + '_' + contactMap.get(mp.c).c;
        }
	}

	private static Set<Id> getRealtedObjectIds(List<obj> newList){
        Set<Id> idSet = new Set<Id>();
		for (obj mp : newlist){
            idSet.add(mp.obj);
            idSet.add(mp.c);
        }
        return idSet;
	}

	private static Map<Id, obj> getMalkarParentMap(Set<Id> idSet){
		Set<String> fieldNames = new Set<String>{'Id','c'};
		return new Map<Id, obj>(GSTAR_DAL.getMalkarsByIds(fieldNames, idSet));
	}

	private static Map<Id, Contact> getLinkedContactMap(Set<Id> idSet){
		Set<String> fieldNames = new Set<String>{'Id', 'c'};
		return new Map<Id, Contact>(Utils_DAL.getContactsByIds(fieldNames, idSet));
	}
}