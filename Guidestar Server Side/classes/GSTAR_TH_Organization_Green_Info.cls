public class GSTAR_TH_Organization_Green_Info{

	public static void linkToParentMalkar(List<obj> newlist){
        Map<Id, obj> toUpdate = new Map<Id, obj>();
		if (newlist.size() > 0){
			for (obj ogi : newlist){
				obj m = new obj(Id = ogi.obj, 
											c = ogi.Id,
											c = ogi.LastModifiedDate);
				if (String.isNotBlank(ogi.c)){
					m.c = ogi.c;
				}
				toUpdate.put(m.Id, m);
			}
		}     
        if (toUpdate.size() > 0){
            update toUpdate.values();
        }
	}
}