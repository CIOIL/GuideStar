@isTest
private class GSTAR_TriggerTestClass{

	static TestMethod void testNihulTakinTrigger(){
		List<obj> malkars = GSTAR_TestUtils.createMalkars(3);
		insert malkars;
		List<obj> nihuls = GSTAR_TestUtils.createNihulTakinStatus(3, malkars);
		insert nihuls;
		List<Id> IdList = new List<Id>();
		for (obj nts : nihuls){
			IdList.add(nts.Id);
		}
		nihuls = [SELECT Id, c, c FROM obj WHERE Id IN :IdList];
		for (obj nts : nihuls){
			System.assertNotEquals(null, nts.c);
		}
		IdList.clear();
		for (obj malkar : malkars){
			IdList.add(malkar.Id);
		}
		malkars = [SELECT Id, c, c FROM obj WHERE Id IN :IdList];
		//for (obj malkar : malkars){
		//	System.assertNotEquals(null, malkar.c);
		//}
		nihuls[0].c = '1';
		update nihuls;
	}

	static TestMethod void testOrgGreenInfoTrigger(){
		List<obj> malkars = GSTAR_TestUtils.createMalkars(3);
		insert malkars;
		List<obj> orgInfoList = GSTAR_TestUtils.creatOrgGreenInfos(3, malkars);
		insert orgInfoList;
		List<Id> IdList = new List<Id>();
		for (obj malkar : malkars){
			IdList.add(malkar.Id);
		}
		malkars = [SELECT Id, c FROM obj WHERE Id IN :IdList];
		for (obj malkar : malkars){
			System.assertNotEquals(null, malkar.c);
		}
	}

	static TestMethod void testReportsApprovalsTrigger(){
		List<obj> malkars = GSTAR_TestUtils.createMalkars(5);
		insert malkars;
		List<obj> reportsList = GSTAR_TestUtils.createReportsApprovals(5, malkars);
		Map<string, string> recordTypeMap = Utils_DAL.getRecordTypeMap('obj');
		Integer i = 0;
		for (String devName : recordTypeMap.keySet()){
			reportsList[i++].RecordTypeId = recordTypeMap.get(devName);
		}
		insert reportsList;
		reportsList[0].c = '';
		update reportsList;
	}

	static TestMethod void testMalkarTrigger(){
		List<c> customSettings = GSTAR_TestUtils.createClassificationSettings(5);
		insert customSettings;
		List<obj> malkars = GSTAR_TestUtils.createMalkars(5);
		malkars[0].c = 'חל"ץ';
		malkars[0].c = '21';
		malkars[1].c = '1';
		malkars[1].c = 'reason';
		malkars[2].c = '2';
		malkars[3].c = '3';
		malkars[4].c = '4';
		insert malkars;
		OLD_GSTAR.getMalkarsByChunk(Datetime.now(), malkars[0].Id);
	}

	static TestMethod void testAdditionalDataTrigger(){
		List<c> customSettings = GSTAR_TestUtils.createClassificationSettings(5);
		insert customSettings;
		List<obj> malkars = GSTAR_TestUtils.createMalkars(5);
		//malkars[0].c = 'חל"ץ';
		//malkars[0].c = '21';
		//malkars[1].c = '1';
		//malkars[2].c = '2';
		//malkars[3].c = '3';
		//malkars[4].c = '4';
		insert malkars;
		malkars[1].c = '21';
		malkars[1].c = 'reason';
		update malkars;
		List<obj> adList = GSTAR_TestUtils.createAdditionalData(5, malkars);
		adList[0].c = true;
		adList[0].c = String.valueOf(Datetime.now().Year()-1);
		adList[0].c = customSettings[0].c;
		adList[0].c = customSettings[0].c;
		adList[0].c = customSettings[0].c;
		adList[0].c = customSettings[0].c;
		adList[1].obj = adList[0].obj;
		insert adList;
		adList[1].c = String.valueOf(Datetime.now().Year());
		adList[1].c = true;
		update adList;
		adList[2].c = customSettings[0].c;
		adList[2].c = customSettings[0].c;
		update adList[2];
	}
	
	static TestMethod void testReportWageEarnerTrigger(){
		List<obj> malkars = GSTAR_TestUtils.createMalkars(5);
		insert malkars;
		List<obj> rweList = GSTAR_TestUtils.createReportWageEarner(5, malkars);
		rweList[0].c = true;
		rweList[0].c = String.valueOf(Datetime.now().Year()-1);
		rweList[1].obj = rweList[0].obj;
		insert rweList;
		rweList[1].c = String.valueOf(Datetime.now().Year());
		rweList[1].c = true;
		update rweList;
	}

	static TestMethod void testConnectedMalkars(){
		List<obj> malkars = GSTAR_TestUtils.createMalkars(6);
		insert malkars;
		List<obj> fromMalkars = new List<obj>{malkars[0], malkars[1], malkars[2]};
		List<obj> toMalkars = new List<obj>{malkars[3], malkars[4], malkars[5]};
		List<obj> cmList = GSTAR_TestUtils.createConnectedMalkars(3, fromMalkars, toMalkars);
		insert cmList;
		cmList[0].c = 'Shareholder';
		update cmList;
	}

	static TestMethod void testMalkarPerson(){
		List<obj> malkars = GSTAR_TestUtils.createMalkars(3);
		insert malkars;
		List<Account> accounts = GSTAR_TestUtils.createAccounts(1);
		insert accounts;
		List<Contact> contacts = GSTAR_TestUtils.createContacts(3, accounts[0].Id);
		insert contacts;
		List<obj> mpList = GSTAR_TestUtils.createMalkarPeople(3, malkars, contacts);
		insert mpList;
		mpList[0].c = contacts[1].Id;
		update mpList;
	}

	static TestMethod void testMalkarCity(){
		List<obj> malkars = GSTAR_TestUtils.createMalkars(3);
		insert malkars;
		List<c> cities = GSTAR_TestUtils.createCities(3);
		insert cities;
		List<objr> mcList = GSTAR_TestUtils.createMalkarCities(3, malkars, cities);
		insert mcList;
		mcList[0].c = cities[1].Id;
		update mcList;
		delete mcList[0];
	}

	static TestMethod void testGovConnection(){
		List<obj> malkars = GSTAR_TestUtils.createMalkars(5);
		insert malkars;
		List<obj> govConnections = GSTAR_TestUtils.createGovConnections(5, malkars);
		govConnections[0].c = 9000;
		insert govConnections;
		govConnections[0].c = 47;
		update govConnections;
	}

	static TestMethod void testClassification(){
		List<obj> malkars = GSTAR_TestUtils.createMalkars(5);
		malkars[0].c = '1';
		malkars[1].c = '[1, 2]';
		insert malkars;
		List<obj> classifications = GSTAR_TestUtils.getClassifications(5, malkars);
		for (obj clss : classifications){
			clss.c = '1';
			clss.c = '1';
			clss.c = '1';
		}
		classifications[0].c = '10103';
		insert classifications;
		for (obj clss : classifications){
			clss.c = '2';
			clss.c = '3';
		}
		classifications[4].c = '0';
		update classifications;
	}
}