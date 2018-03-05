public with sharing class SCV_PotentialDuplicateController {


	@AuraEnabled
    public static List<String> findDuplicates(Id accountId) {
		List<String> duplicates = new List<String>();

		try {
			List<Id> idList = new List<Id>();
			idList.add(accountId);

			//Find duplicates
			Datacloud.FindDuplicatesResult[] results = Datacloud.FindDuplicatesByIds.findDuplicatesByIds(idList);

			for (Datacloud.FindDuplicatesResult findDupeResult : results) {
				
				for (Datacloud.DuplicateResult dupeResult : findDupeResult.getDuplicateResults()) {
					
					for (Datacloud.MatchResult matchResult : dupeResult.getMatchResults()) {
						System.debug('matchResult: ' + matchResult.getSize());
						//if (matchResult.getSize() > 0) {
							//duplicates.add(accountId);
						//}

						for (Datacloud.MatchRecord matchRecord : matchResult.getMatchRecords()) {
							Account acc = (Account)matchRecord.getRecord();
							System.debug('Duplicate Record: ' + acc);
							duplicates.add(acc.Id);
						}
					}
				}
			}
            
        } catch(Exception ex){
            //return '{"error": "' + ex.getMessage() + '"}';
        }

        return duplicates;
    }

    

}