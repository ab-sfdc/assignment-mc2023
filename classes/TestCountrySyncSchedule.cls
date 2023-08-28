@isTest
public class TestCountrySyncSchedule {
    @isTest
    static void testScheduleJob() {
        // Enqueue the scheduled job
        Test.startTest();
        CountrySyncSchedule.scheduleJob();
        Test.stopTest();

        // Verify that the job has been scheduled
        List<CronTrigger> cronTriggers = [SELECT Id, CronExpression FROM CronTrigger WHERE CronJobDetail.Name = 'Country Sync Job'];
        System.assertEquals(1, cronTriggers.size());

    }
}