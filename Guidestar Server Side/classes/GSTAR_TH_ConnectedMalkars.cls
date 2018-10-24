public class GSTAR_TH_ConnectedMalkars{

	public static void creatExternalId(List<obj> newList){
        Set<Id> idSet = getRealtedObjectIds(newList);
		Set<String> fieldNames = new Set<String>{'Id','c'};
		Map<Id, obj> conMalkarMap =  new Map<Id, obj>(GSTAR_DAL.getMalkarsByIds(fieldNames, idSet));
		for (obj cm : newList){
			cm.c = conMalkarMap.get(cm.c).c + '_' + conMalkarMap.get(cm.c).c + '_' + cm.obj + '_' + cm.c;
		}
	}

	private static Set<Id> getRealtedObjectIds(List<obj> newList){
        Set<Id> idSet = new Set<Id>();
		for (obj cm : newlist){
            idSet.add(cm.c);
            idSet.add(cm.c);
        }
        return idSet;
	}
}