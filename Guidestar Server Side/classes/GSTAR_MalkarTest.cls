@isTest
private class GSTAR_MalkarTest{

	static TestMethod void testMalkar(){
		List<obj> malkars = GSTAR_TestUtils.createMalkars(5);
		malkars[0].field = 'שם מלקר';
		malkars[1].field = 'org name';
		malkars[2].field = 'org name Arabic';
		malkars[3].field = 'org name Hebrew';
		malkars[4].field = 'הקדש';
		insert malkars;
		List<obj> nihuls = GSTAR_TestUtils.createNihulTakinStatus(4, malkars);
		nihuls[0].field = '1';
		nihuls[1].field = '1';
		nihuls[2].field = '1';
		nihuls[3].field = '1';
		insert nihuls;
		List<Id> ids = new List<Id>{malkars[0].Id, malkars[1].Id, malkars[2].Id, malkars[3].Id, malkars[4].Id};
		malkars = GSTAR_DAL.getAllMalkars();
		//malkars = [SELECT field , field, field, r.field FROM obj WHERE Id IN :ids];
		List<GSTAR_Malkar> malkarList = GSTAR_Malkar.createMalkarList(malkars, 'iw');
		malkarList = GSTAR_Malkar.createMalkarList(malkars, 'en_US');
		malkarList = GSTAR_Malkar.createMalkarList(malkars, 'ar');
	}
}