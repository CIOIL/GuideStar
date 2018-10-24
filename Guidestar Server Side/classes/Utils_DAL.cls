public without sharing class Utils_DAL { // Was "with sharing" changed 31-07-2018 to accomodate querying all ContentDocumentLinks
	
	public static List<ContentVersion> getObjectsFiles(Id objId){
		if(objId != null){
			return getObjectsFiles(new Set<Id>{objId});
		}
		return null;
	}
	
	public static List<ContentVersion> getObjectsFiles(Set<Id> objIds){
		Set<Id> contentDocumentIds = getContentDocumentIds(objIds);
		Utils.log(contentDocumentIds);
		if(contentDocumentIds != null && !contentDocumentIds.isEmpty()){
			return [select Id, ContentDocumentId, ContentDocument.Title, ContentDocument.Description, ContentDocument.FileExtension, 
							ContentDocument.FileType, CreatedDate, ContentSize
						from ContentVersion 
						where ContentDocumentId In : contentDocumentIds];	
		}
		return null;
	}
	
	public static Set<Id> getContentDocumentIds(Set<Id> objIds){
		Set<Id> contentDocumentIds = new Set<Id>();
		List<ContentDocumentLink> cdls = [select ContentDocumentId from ContentDocumentLink where LinkedEntityId IN : objIds];
		for(ContentDocumentLink cdl : cdls){
			contentDocumentIds.add(cdl.ContentDocumentId);
		}
		return contentDocumentIds;
	}

	public static List<ContentDocumentLink> getContentDocumentLinkExtraFields(List<Id> contentDocumentLinkIds, string extraFields){
		String queryStr = 'SELECT Id, ContentDocumentId, LinkedEntityId ';
		if (String.isNotBlank(extraFields)){
			queryStr += ', ' + extraFields;
		}
		queryStr += ' FROM ContentDocumentLink ';
		queryStr += ' WHERE Id IN :contentDocumentLinkIds';
		return Database.query(queryStr);
	}

	public static List<ContentDocumentLink> getContentDocumentLinkExtraFieldsByLink(List<Id> linkedEntityIds, string extraFields){
		String queryStr = 'SELECT Id, ContentDocumentId, LinkedEntityId ';
		if (String.isNotBlank(extraFields)){
			queryStr += ', ' + extraFields;
		}
		queryStr += ' FROM ContentDocumentLink ';
		queryStr += ' WHERE LinkedEntityId IN :linkedEntityIds';
		return Database.query(queryStr);
	}

	public static List<ContentDocumentLink> getContentDocumentLinksByDocId(List<Id> docIds){
		String queryStr = 'SELECT Id, ContentDocumentId, LinkedEntityId ';
		queryStr += ' FROM ContentDocumentLink ';
		queryStr += ' WHERE ContentDocumentId IN :docIds';
		return Database.query(queryStr);
	}

	public static List<ContentDocument> getContentDocumentsById(List<Id> docIds){
		String queryStr = 'SELECT Id ';
		queryStr += ' FROM ContentDocument ';
		queryStr += ' WHERE Id IN :docIds';
		return Database.query(queryStr);
	}

	public static List<ContentVersion> getContentVersionsByIds(List<Id> verIds){
		String queryStr = 'SELECT Id, ContentDocumentId ';
		queryStr += ' FROM ContentVersion ';
		queryStr += ' WHERE Id IN :verIds';
		return Database.query(queryStr);
	}
    
    public static Profile getProfileById(Id profileId){
    	return [select Id, Name, UserLicense.Name, UserType from Profile where Id =: profileId limit 1];
    } 

    public static List<Profile> getProfilesByName(String profileName){
    	return [SELECT Id, Name, UserLicense.Name, UserType from Profile where Name =: profileName];
    }

    public static List<RecordType> getRecordTypeInfo(string type){
        string queryStr = 'SELECT Id, Name, DeveloperName, SObjectType ';
        queryStr += ' FROM RecordType ';
        queryStr += ' WHERE SObjectType = :type';
        return Database.query(queryStr);
    }
    
    public static List<RecordType> getRecordTypeInfo(string type, string developerName){
        string queryStr = 'SELECT Id, Name, DeveloperName, SObjectType ';
        queryStr += ' FROM RecordType ';
        queryStr += ' WHERE SObjectType = :type AND DeveloperName = :developerName ';
        return Database.query(queryStr);
    }
    
    public static User getCurrentUser(){
        return [select Id, Name, FirstName, LastName, Email, Phone, Street, City, PostalCode, Country, c, Profile.Name, LanguageLocaleKey from User where Id = : UserInfo.getUserId()];
    }
    
    public static User getUserByUsername(String username){
        return [select Id, Name, FirstName, LastName, Email, Phone, Street, City, PostalCode, Country, c, Profile.Name, LanguageLocaleKey, IsActive 
        			from User 
        			where Username = : username];
    }

    public static List<User> getActiveUserByUsername(String username){
        string queryStr = ' SELECT Id, Name, FirstName, LastName, Email, Phone, Street, City, PostalCode, Country, c, Profile.Name, LanguageLocaleKey, IsActive ';
        queryStr += ' FROM User ';
        queryStr += ' WHERE Username = : username AND IsActive = true';
        return Database.query(queryStr);
    }

    public static List<User> getUsersByProfileName(String profileName){
    	return [select Id, Name, FirstName, LastName, Email, Phone, Street, City, PostalCode, Country, c, Profile.Name, LanguageLocaleKey, IsActive 
        			from User 
        			where Profile.Name = : profileName];
    }

    public static List<User> getUsersbyEmail(string email){
    	string queryStr = 'SELECT Id, Name, FirstName, LastName, Email, Phone, Street, City, PostalCode, Country, c, Profile.Name, LanguageLocaleKey, IsActive ';
    	queryStr += ' FROM User WHERE Email = :email';
    	return Database.query(queryStr);
    }

    public static Map<string, string> getRecordTypeMap(string rtype){
        if (string.isEmpty(rtype)){
            return null;   
        }
        Map<string, string> returnMap = new Map<string, string>();
        for (RecordType rt :  getRecordTypeInfo(rtype)){
            returnMap.put(rt.DeveloperName.toLowerCase(), rt.Id);
        }
        return returnMap;
    }

    public static List<Contact> getContactsByIds(Set<String> fieldNames, Set<Id> idSet){ 
        string queryStr = 'SELECT ';
        queryStr += string.join(new List<string>(fieldNames), ', ');
        queryStr += ' FROM Contact ';
        queryStr += ' WHERE Id IN :idSet';
        return Database.query(queryStr);    
    }

    public static List<Contact> getContactsbyExtId(string extId){
    	String queryStr = 'SELECT Id, c ';
    	queryStr += ' FROM Contact ';
    	queryStr += ' WHERE c = :extId';
    	return Database.query(queryStr);
    }

    public static List<Contact> getContactsByWhereClause(string whereClause){
    	if (String.isBlank(whereClause)){
    		return new List<Contact>();
    	}
    	String queryStr = 'SELECT Id, FirstName, LastName, c ';
    	queryStr += ' FROM Contact ';
    	queryStr += ' WHERE ';
    	queryStr += whereClause;
    	return Database.query(queryStr);
    }
    
    public static List<> getSimilarWords(String type, String searchWord){ 
        string queryStr = 'SELECT Id, MasterLabel, DeveloperName ';
        queryStr += ' FROM  ';
        queryStr += ' WHERE c like :type '; 
        queryStr += ' AND MasterLabel like :searchWord ';
        return Database.query(queryStr);    
    }

    public static List<Network> getCommunityByName(string communityName){
    	string queryStr = 'SELECT Id, Name ';
    	queryStr += ' FROM Network ';
    	queryStr += ' WHERE Name = :communityName ';
    	return Database.query(queryStr);
    }

    public static List<CollaborationGroup> getChatterGroupByName(string groupName){
    	string queryStr = 'SELECT Id, Name, NetworkId, OwnerId ';
    	queryStr += ' FROM CollaborationGroup ';
    	queryStr += ' WHERE Name = :groupName ';
    	return Database.query(queryStr);
    }

    public static List<CollaborationGroup> getChatterGroupsByNames(List<string> groupNames){
    	//string queryStr = 'SELECT Id, Name, NetworkId, OwnerId ';
    	string queryStr = 'SELECT Id, Name, Network.Name, MemberCount, (SELECT MemberId, Member.Name FROM GroupMembers) ';
    	queryStr += ' FROM CollaborationGroup ';
    	queryStr += ' WHERE Name in :groupNames ';
    	return Database.query(queryStr);
    }

    public static List<CollaborationGroupMember> getChatterGroupMembers(string groupId){
    	string queryStr = ' SELECT Id, CollaborationGroupId, CollaborationRole, MemberId, NotificationFrequency ';
    	queryStr += ' FROM CollaborationGroupMember ';
    	queryStr += ' WHERE CollaborationGroupId = :groupId ';
    	return Database.query(queryStr);
    }

    public static Map<Id, CollaborationGroupMember> getChatterGroupMemberMap(string groupId){
    	Map<Id, CollaborationGroupMember> memberMap = new Map<Id, CollaborationGroupMember>();
    	List<CollaborationGroupMember> memberList = getChatterGroupMembers(groupId);
    	for (CollaborationGroupMember member : memberList){
    		memberMap.put(member.MemberId, member);
    	}
    	return memberMap;
    }

}