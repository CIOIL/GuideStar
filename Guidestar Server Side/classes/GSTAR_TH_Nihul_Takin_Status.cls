public class GSTAR_TH_Nihul_Takin_Status {
    
    public static void createExternalIdField(List<obj> newlist){
        Set<String> fieldNames = new Set<String>{'Id','c'};
        Set<Id> idSet = new Set<Id>();
        for (obj nts : newlist){
            idSet.add(nts.c);
        }
        Map<Id, obj> malkarMap = new Map<Id, obj>(GSTAR_DAL.getMalkarsByIds(fieldNames, idSet)); 
        for (obj nts : newlist){
            nts.c = malkarMap.get(nts.c).c + '_' + Integer.valueOf(nts.c);
        }
    }

    public static void linkToParentMalkar(List<obj> newList){
        Decimal currentYear = Date.today().year();
        Map<Id, obj> nihulTakinStatusSortedByMalkar = new Map<Id, obj>();
        /*//why to put only 1 status by malkar id, it is need to be a list ??
        //it is a mistake to use "sortSObjects" function because if there is 2 statuses 
        //it is only needed to take the malkar ids
        Map<Object, SObject> retMap = Utils.sortSObjects(newlist, 'c', 'c');
        //loop over malkar id 
        for (Object obj : retMap.keySet()){
            nihulTakinStatusSortedByMalkar.put((Id)obj, (obj)retMap.get(obj));
        }*/
        Set<Id> malkarIds = Utils.getSetIDs(newlist, 'c');
        Set<string> fieldNames = new Set<string>{'Id', 'c', 'r.c', 'c', 'r.c'};
        Map<Id, obj> toUpdate = new Map<Id, obj>();
        Map<Id, obj> parentMap = new Map<Id, obj>(GSTAR_DAL.getMalkarsByIds(fieldNames, malkarIds));
        for (obj nts : newList){
        	obj parent = parentMap.get(nts.c);
            if (parent.c == null 
                || parent.r.c < nts.c){
                if (nts.c <= currentYear && nts.c){
                    parent.c = nts.Id;
                    parent.r = nts;
                    toUpdate.put(parent.Id, parent);
                }
            }
            
            if (parent.c == null 
                || parent.r.c < nts.c){
                if (nts.c > currentYear && nts.c){
                    parent.c = nts.Id;
                    toUpdate.put(parent.Id, parent);
                }
            }
        }
        if (toUpdate.size() > 0){
            update toUpdate.values();
        }
    }
}