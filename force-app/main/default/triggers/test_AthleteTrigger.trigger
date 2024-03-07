@IsTest
private class AthleteTriggerTest {
    @IsTest
    static void testTrigger() {
        // Create test data
        Athlete__c athlete = new Athlete__c();
        athlete.Name = 'Test Athlete';
        // Set other required fields

        // Insert the test data
        insert athlete;

        // Verify that the trigger enqueued the job
        System.assertEquals(1, Limits.getQueueableJobs());

        // Retrieve the enqueued job
        System.QueueableContext context = System.getQueueableContext();
        System.assertEquals(StravaTokenRefresher.class, context.getJobId().getJobType());

        // Verify other assertions as needed
    }
}