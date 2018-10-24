@isTest
private class GSTAR_CtrlTestClass{

    static testMethod void testCtrlConfig(){
        Test.startTest();
        GSTAR_Ctrl_Config ctrlConf = new GSTAR_Ctrl_Config();
        CTRL ctrl = new CTRL();
        ctrlConf = new GSTAR_Ctrl_Config(ctrl);
        GSTAR_Ctrl_Config.getSearchFilter();
        GSTAR_Ctrl_Config.getSearchSort();
        GSTAR_Ctrl_Config.getTestSupportSearchFilter();
        GSTAR_Ctrl_Config.getTestSupportSearchSort();
        GSTAR_Ctrl_Config.getMainClassificationsRemote();
        Test.stopTest();
    }

    static testMethod void testGetUserInfo(){
        User u = [SELECT Id, UserType FROM User WHERE UserType LIKE '%guest%'][0];
        System.runAs(u){
            GSTAR_Ctrl.getUserInfo();
        }
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'][0].Id;
        List<User> users = GSTAR_TestUtils.createUsers(profileId, 1);
        insert users;
        System.runAs(users[0]){
            GSTAR_Ctrl.getUserInfo();
        }
    }

    static testMethod void testGetMalkarsByChunk(){
        List<obj> malkars = GSTAR_TestUtils.createMalkars(5);
        insert malkars;
        for (obj malkar : malkars){
            malkar.field = '123 Some Rd.';
        }
        update malkars;
        obj lastMalkar = malkars[4];
    }

    static testMethod void testGetMalkarById(){
        List<obj> malkars = GSTAR_TestUtils.createMalkars(5);
        insert malkars;
        GSTAR_Ctrl.getMalkarById(malkars[0].Id);
        GSTAR_Ctrl.getMalkarById('');
        GSTAR_Ctrl.getMalkarDetails(malkars[0].field);
        GSTAR_Ctrl.getMalkarDetails('');
    }

    static testMethod void testGetReportsApprovals(){
        List<obj> malkars = GSTAR_TestUtils.createMalkars(5);
        insert malkars;
        List<obj> reports = GSTAR_TestUtils.createReportsApprovals(5, malkars);
        insert reports;
        GSTAR_Ctrl.getMalkarReportsApproval(malkars[0].field);
        GSTAR_Ctrl.getMalkarReportsApproval('');
    }

    static testMethod void testGetMalkarGovSupport(){
        List<obj> malkars = GSTAR_TestUtils.createMalkars(5);
        insert malkars;
        List<obj> tmichot = GSTAR_TestUtils.createTmichot(5, malkars);
        insert tmichot;
        GSTAR_Ctrl.getMalkarSupport(malkars[0].field);
        GSTAR_Ctrl.getMalkarSupport('');
    }

    static testMethod void testGetMalkarGovConnections(){
        List<obj> malkars = GSTAR_TestUtils.createMalkars(5);
        insert malkars;
        List<obj> connections = GSTAR_TestUtils.createGovConnections(5, malkars);
        insert connections;
        GSTAR_Ctrl.getMalkarGovServices(malkars[0].field);
        GSTAR_Ctrl.getMalkarGovServices('');
    }

    static testMethod void testGetMalkarDonations(){
        List<obj> malkars = GSTAR_TestUtils.createMalkars(5);
        insert malkars;
        List<obj> donations = GSTAR_TestUtils.createDonations(5, malkars);
        insert donations;
        GSTAR_Ctrl.getMalkarDonations(malkars[0].field);
        GSTAR_Ctrl.getMalkarDonations('');
    }

    static testMethod void testGetMalkarPeople(){
        List<obj> malkars = GSTAR_TestUtils.createMalkars(5);
        insert malkars;
        Map<string, string> settingsMap = new Map<string, string>{
            'Google_recaptcha_secretKey'=> 'key1'
        };
        List<obj> settings = GSTAR_TestUtils.createGlobalSettings(settingsMap);
        insert settings;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new GooglereCaptchaMockImpl());
        GSTAR_Ctrl.getMalkarPeople(malkars[0].field, 'token');
        GSTAR_Ctrl.getMalkarPeople(malkars[0].field, '');
        Test.stopTest();
    }

    static testMethod void testGetConnectedMalkars(){
        List<field> customSettings = GSTAR_TestUtils.createClassificationSettings(5);
        insert customSettings;
        List<obj> malkars = GSTAR_TestUtils.createMalkars(6);
        insert malkars;
        List<obj> adList = GSTAR_TestUtils.createAdditionalData(5, malkars);
        adList[0].field = true;
        adList[0].field = String.valueOf(Datetime.now().Year()-1);
        adList[0].field = customSettings[0].field;
        adList[0].field = customSettings[0].field;
        adList[0].field = customSettings[0].field;
        adList[0].field = customSettings[0].field;
        adList[1].obj = adList[0].obj;
        insert adList;
        List<Account> accounts = GSTAR_TestUtils.createAccounts(1);
        insert accounts;
        List<Contact> contacts = GSTAR_TestUtils.createContacts(6, accounts[0].Id);
        insert contacts;
        List<obj> mpList = GSTAR_TestUtils.createMalkarPeople(6, malkars, contacts);
        insert mpList;
        mpList[0].field = contacts[1].Id;
        update mpList;
        List<obj> fromMalkars = new List<obj>{malkars[0], malkars[1], malkars[2]};
        List<obj> toMalkars = new List<obj>{malkars[3], malkars[4], malkars[5]};
        List<obj> cmList = GSTAR_TestUtils.createConnectedMalkars(3, fromMalkars, toMalkars);
        insert cmList;
        cmList[0].field = 'Shareholder';
        update cmList;
        GSTAR_Ctrl.getMalkarConnected(malkars[0].field);
        GSTAR_Ctrl.getMalkarConnected('');
    }

    static testMethod void testGetMalkarWageEarners(){
        List<obj> malkars = GSTAR_TestUtils.createMalkars(2);
        insert malkars;
        List<field> wageEarners = GSTAR_TestUtils.createWagerEarners(2, malkars);
        wageEarners[1].obj = wageEarners[0].obj;
        wageEarners[1].field = Date.today().addYears(-1).Year();
        insert wageEarners;
        GSTAR_Ctrl.getMalkarWageEarners(malkars[0].field);
        GSTAR_Ctrl.getMalkarWageEarners('');
    }

    static testMethod void testGetMisc(){
        GSTAR_Ctrl ctrl = new GSTAR_Ctrl();
        GSTAR_Ctrl.getReportTotals();
        GSTAR_Ctrl.getChartDataDistrict('10');
        GSTAR_Ctrl.getChartDataDistrict('');
        GSTAR_Ctrl.getHomeChartMainClassifications();
        GSTAR_Ctrl.getHomeChartDistricts();
        GSTAR_Ctrl.getHomeChartTmihot();
    }

    static testMethod void testGetTestSupport(){
        GSTAR_Ctrl.getAllTestSupports();
        List<field> testSupports = GSTAR_TestUtils.createTestSupports(5);
        testSupports[0].field = 'פנים';
        testSupports[1].field = 'פנים';
        testSupports[2].field = 'פנים';
        insert testSupports;
        string encodedTSId = EncodingUtil.base64Encode(Blob.valueOf(testSupports[0].Id));
        GSTAR_Ctrl.getTestSupportById(testSupports[0].Id);
        GSTAR_Ctrl.getTestSupportById(encodedTSId);
        GSTAR_Ctrl.getTestSupportById('');
        GSTAR_Ctrl.searchTestSupportsOnlyAC('פנים');
    }

    static testMethod void testSubmitCase(){
        List<obj> malkars = GSTAR_TestUtils.createMalkars(5);
        insert malkars;
        Map<string, string> settingsMap = new Map<string, string>{
            'Google_recaptcha_secretKey'=> 'key1'
        };
        List<obj> settings = GSTAR_TestUtils.createGlobalSettings(settingsMap);
        insert settings;
        GSTAR_Utils.CaseWrapper caseWrapped = new GSTAR_Utils.CaseWrapper();
        caseWrapped.name = 'Test case name';
        caseWrapped.phone = 'Test case phone';
        caseWrapped.email = 'Test@case.email';
        caseWrapped.subject = 'Test case subject';
        caseWrapped.body = 'Test case body';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new GooglereCaptchaMockImpl());
        //GSTAR_Ctrl.getMalkarPeople(malkars[0].field, 'token');
        GSTAR_CTRL.submitCase(caseWrapped, 'token');
        Test.stopTest();
    }

    static testMethod void testsearchMalkarsAC(){
        List<obj> malkars = GSTAR_TestUtils.createMalkars(2);
        insert malkars;
        List<field> testSupports = GSTAR_TestUtils.createTestSupports(5);
        testSupports[0].field = 'פנים';
        insert testSupports;
        GSTAR_Ctrl.searchMalkarsAC('t');
        GSTAR_Ctrl.searchMalkarsAC('test');
    }

    static testMethod void testSearchMalkars(){
        List<obj> malkars = GSTAR_TestUtils.createMalkars(2500);
        insert malkars;
        GSTAR_Utils.FilterWrapper filter = new GSTAR_Utils.FilterWrapper();
        filter.Search = 'test';
        filter.Sug_Hitagdut = new List<string>{'עמותה'};
        filter.CurrentNihulTakinActive = true;
        filter.Approval46 = true;
        filter.Reported_Last_3_Years = true;
        filter.CLSS_Main_Classification_Num = new List<string>{'10'};
        filter.CLSS_Secondary_Classification_Num = new List<string>{'1010'};
        filter.MalkarLocation = '1';
        GSTAR_Ctrl.getSeachMalkarCount(filter, null);
        GSTAR_Ctrl.getSeachMalkarCount(null, null);
        GSTAR_Utils.SortWrapper srt = new GSTAR_Utils.SortWrapper();
        srt.apiName = 'field';
        srt.sortDesc = true;
        srt.value = 2018;
        GSTAR_Ctrl.searchMalkars(filter, srt);
        srt.apiName = '';
        GSTAR_Ctrl.searchMalkars(filter, srt);
        filter.Search = '';
        GSTAR_Ctrl.getSeachMalkarCount(filter, srt);
        filter.Turnover = new List<Decimal>{1, 1000};
        GSTAR_Ctrl.getSeachMalkarCount(filter, srt);
    }

    static testMethod void testCtrlMeta(){
        string baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        Map<string, string> settingsMap = new Map<string, string>{
            'GuidestarURL'=> baseUrl
        };
        List<obj> settings = GSTAR_TestUtils.createGlobalSettings(settingsMap);
        insert settings;
        Ctrl ctrl = new Ctrl();
        GSTAR_Ctrl_Meta meta = new GSTAR_Ctrl_Meta(ctrl);
        List<obj> malkars = GSTAR_TestUtils.createMalkars(1);
        malkars[0].field = 'Test org has no goal. Test org has no goal. Test org has no goal. Test org has no goal. Test org has no goal. ';
        malkars[0].field += 'Test org has no goal. Test org has no goal. Test org has no goal. Test org has no goal. Test org has no goal. ';
        malkars[0].field += 'Test org has no goal. Test org has no goal. Test org has no goal. Test org has no goal. Test org has no goal. ';
        insert malkars;
        obj malkar = [SELECT Id, field, field FROM obj WHERE Id = :malkars[0].Id][0];
        runMetaTest('/he/organization/' + malkar.field);
        malkar.field = 'Test org has no goal.';
        update malkar;
        runMetaTest('/he/organization/' + malkar.field + '/' + GSTAR_Utils.MalkarInfoPage);
        runMetaTest('/he/organization/' + malkar.field + '/' + GSTAR_Utils.MalkarDocumentsPage);
        runMetaTest('/he/organization/' + malkar.field + '/' + GSTAR_Utils.MalkarGovsupportPage);
        runMetaTest('/he/organization/' + malkar.field + '/' + GSTAR_Utils.MalkarGovservicesPage);
        runMetaTest('/he/organization/' + malkar.field + '/' + GSTAR_Utils.MalkarDonationsPage);
        runMetaTest('/he/organization/' + malkar.field + '/' + GSTAR_Utils.MalkarPeoplePage + ';year=2016');
        runMetaTest('/he/organization/' + malkar.field + '/' + GSTAR_Utils.MalkarContactPage);
        runMetaTest('/' + GSTAR_Utils.MalkarSearchPageApp);
        runMetaTest('/' + GSTAR_Utils.TestSupportsPageApp);
        runMetaTest('/' + GSTAR_Utils.TestSupportsPageApp + ';search=test');
        List<field> testSupports = GSTAR_TestUtils.createTestSupports(1);
        testSupports[0].field  = 'Test Support description.';
        insert testSupports;
        string encodedTSId = EncodingUtil.base64Encode(Blob.valueOf(testSupports[0].Id));
        runMetaTest('/' + GSTAR_Utils.TestSupportsPageApp + '/' + testSupports[0].Id);
        runMetaTest('/' + GSTAR_Utils.TestSupportsPageApp + '/' + encodedTSId);
        field testSupport = [SELECT Id, field FROM field WHERE Id = :testSupports[0].Id][0];
        testSupport.field = 'Test Support description. Test Support description. Test Support description. Test Support description.';
        testSupport.field += 'Test Support description. Test Support description. Test Support description. Test Support description.';
        testSupport.field += 'Test Support description. Test Support description. Test Support description. Test Support description.';
        update testSupport;
        runMetaTest('/' + GSTAR_Utils.TestSupportsPageApp + '/' + encodedTSId);
        List<field> websiteContents = GSTAR_TestUtils.createWebsiteContent(1);
        websiteContents[0].field = 'Test websiteContents description';
        insert websiteContents;
        runMetaTest('/' + GSTAR_Utils.GlobalPageApp + '/' + websiteContents[0].field);
        runMetaTest('/' + GSTAR_Utils.ContactPageApp);
        runMetaTest('/' + GSTAR_Utils.HomePageApp);
        meta.getDescription();
        meta.getTitle();
    }

    static void runMetaTest(string params){
        string pageParam = EncodingUtil.base64Encode(Blob.valueOf( params));
        PageReference pageRef = new PageReference('/VF_Guidestar?number=' + pageParam);
        Test.setCurrentPage(pageRef);
        GSTAR_Ctrl_Meta meta = new GSTAR_Ctrl_Meta();
    }

    static testMethod void testUrlWriter(){
        GSTAR_UrlRewriter gsuw = new GSTAR_UrlRewriter();
        PageReference pageRef = new PageReference('/home');
        gsuw.mapRequestUrl(pageRef);
        pageRef = new PageReference('/organization');
        gsuw.mapRequestUrl(pageRef);
        pageRef = new PageReference('/test-support');
        gsuw.mapRequestUrl(pageRef);
        pageRef = new PageReference('/search');
        gsuw.mapRequestUrl(pageRef);
        pageRef = new PageReference('/page');
        gsuw.mapRequestUrl(pageRef);
        pageRef = new PageReference('/contact');
        gsuw.mapRequestUrl(pageRef);
        pageRef = new PageReference('/GS_Malkar');
        gsuw.mapRequestUrl(pageRef);
        pageRef = new PageReference('/he/organization');
        gsuw.mapRequestUrl(pageRef);
        pageRef = new PageReference('/no-page');
        gsuw.mapRequestUrl(pageRef);
        PageReference pageRef2 = new PageReference('/VF_Guidestar?number=');
        PageReference pageRef3 = new PageReference('/VF_Guidestar?number=580000000');
        gsuw.generateUrlFor(new List<PageReference>{pageRef, pageRef2, pageRef3});
    }

    static testMethod void testMalkarReports(){
        List<field> customSettings = GSTAR_TestUtils.createClassificationSettings(5);
        insert customSettings;
        List<obj> malkars = GSTAR_TestUtils.createMalkars(5);
        for (obj malkar : malkars){
            malkar.field = 'Hebrew Name';
            malkar.field = 'English Name';
            malkar.field = 'Arabic Name';
        }
        malkars[4].field = '-';
        insert malkars;
        List<obj> adList = GSTAR_TestUtils.createAdditionalData(5, malkars);
        adList[0].field = true;
        adList[0].field = String.valueOf(Datetime.now().Year()-1);
        adList[0].field = customSettings[0].field;
        adList[0].field = customSettings[0].field;
        adList[0].field = customSettings[0].field;
        adList[0].field = customSettings[0].field;
        adList[1].obj = adList[0].obj;
        insert adList;
        GSTAR_Utils.FilterWrapper filter = new GSTAR_Utils.FilterWrapper();
        //filter.Search = 'test';
        GSTAR_Utils.SortWrapper srt = new GSTAR_Utils.SortWrapper();
        //srt.sortDesc = true;
        GSTAR_Ctrl.getMalkarsForReport(filter, srt);
        GSTAR_Utils.createMalkarReportList(malkars, 'iw');
        GSTAR_Utils.createMalkarReportList(malkars, 'en_US');
        GSTAR_Utils.createMalkarReportList(malkars, 'ar');
        GSTAR_Utils.createMalkarReportList(malkars, 'ru');
    }

    static testMethod void testSupportGetters(){
        GSTAR_Ctrl.getMalkarsReportColumns();
        GSTAR_Ctrl.getCustomGlobalSettings();
        Map<string, string> settingsMap = new Map<string, string>{
            'Google_recaptcha_publicKey'=> 'key1',
            'MaxReportSize'=> 'key2',
            'Google_maps_publicKey'=> 'key3'
        };
        List<obj> settings = GSTAR_TestUtils.createGlobalSettings(settingsMap);
        insert settings;
        GSTAR_Ctrl.getCustomGlobalSettings();
    }
    
}