public class TH_JS_Error{

	public static void populateMessage(List<obj> newList){
		Integer endIndex;
		for (obj jse : newList){
			if (String.isNotBlank(jse.c)){
				endIndex = Math.min(jse.c.length(), 255);
				jse.c = jse.c.substring(0, endIndex);
			}
		}
	}
}