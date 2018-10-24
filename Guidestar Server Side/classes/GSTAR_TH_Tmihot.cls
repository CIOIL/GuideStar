public class GSTAR_TH_Tmihot {
	
	public static void setAge(List<obj> tmihots){
		Decimal currentYear = Date.today().Year();
        for (obj tmiha : tmihots){
        	if(tmiha.c != null){
        		tmiha.c = currentYear - tmiha.c;
        	}
        }
	}
    
}