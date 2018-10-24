public class GSTAR_TH_MalkarCity{

	public static void creatExternalId(List<objr> newList){
        Set<Id> idSet = getRealtedObjectIds(newList);
        Map<Id, obj> malkarMap = getMalkarParentMap(idSet);
        Map<Id, c> cityMap = getLinkedCityMap(idSet);
        for (objr mc : newlist){
            mc.c = malkarMap.get(mc.obj).c + '_' + cityMap.get(mc.c).c + '_' + mc.c;
            if(mc.obj != null && mc.c == GSTAR_Utils.MalkarCityActivityType){
            	mc.c = mc.c + '_' + mc.obj;
            }
        }
	}
	
	public static void updateMalkarDistricts(List<objr> newList){
		Map<Id, obj> parentMalkars = new Map<Id, obj>();
        Set<obj> toUpdate = new Set<obj>();
		for (objr mc : newList){
			parentMalkars.put(mc.obj, new obj(Id = mc.obj));
		}
		Map<string, Set<objr>> malkarCityMap = getMalkarCityMap(parentMalkars.keySet());
		for (string malkarId : malkarCityMap.keySet()){
			obj malkar = parentMalkars.get(malkarId);
        	Set<string> districtSet = new Set<string>();
        	Set<string> districtNumSet = new Set<string>();
        	Set<string> citySet = new Set<string>();
        	Set<string> cityNumSet = new Set<string>();
        	for (objr mc : malkarCityMap.get(malkarId)){
        		districtSet.add(mc.r.c);
        		districtNumSet.add(mc.r.c);
        		citySet.add(mc.r.Name);
        		cityNumSet.add(mc.r.c);
        	}
        	malkar.c = JSON.serialize(districtSet);
        	malkar.c = JSON.serialize(districtNumSet);
        	malkar.c = JSON.serialize(citySet);
        	malkar.c = JSON.serialize(cityNumSet);
        	toUpdate.add(malkar);
		}
		update new List<obj>(toUpdate);
	}

	private static Set<Id> getRealtedObjectIds(List<objr> newList){
        Set<Id> idSet = new Set<Id>();
		for (objr mc : newlist){
            idSet.add(mc.obj);
            idSet.add(mc.c);
        }
        return idSet;
	}

	private static Map<Id, obj> getMalkarParentMap(Set<Id> idSet){
		Set<String> fieldNames = new Set<String>{'Id','c'};
		return new Map<Id, obj>(GSTAR_DAL.getMalkarsByIds(fieldNames, idSet));
	}

	private static Map<Id, c> getLinkedCityMap(Set<Id> idSet){
		Set<String> fieldNames = new Set<String>{'Id', 'Name', 'c', 'c'};
		return new Map<Id, c>(GSTAR_DAL.getCitiesByIds(fieldNames, idSet));
	}

	private static Map<string, Set<objr>> getMalkarCityMap(Set<Id> idSet){
		Map<string, Set<objr>> retMap = new Map<string, Set<objr>>();
		for (Id  malkarId : idSet){
			retMap.put(malkarId, new Set<objr>());
		}
		Set<String> fieldNames = new Set<String>{'Id', 'obj', 'c', 'r.Name', 'r.c', 'r.c', 'r.c'};
		for (objr mc : GSTAR_DAL.getMalkarCitiesByParentIds(fieldNames, idSet, GSTAR_Utils.OnlyLastAdditionalActivities)){
			retMap.get(mc.obj).add(mc);
		}
		return retMap;
	}
}