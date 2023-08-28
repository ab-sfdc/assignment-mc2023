public class CountrySyncSchedule implements Schedulable {
    
    public void execute(SchedulableContext context) {
        if (!Test.isRunningTest()) {
           CountryDataUpdater.updateCountryData();  
        }
    }
    
    public static void scheduleJob() {
        //Scheduled for it to be run on every Sunday
        String cronExp = '0 0 0 ? * 1';
        System.schedule('Country Sync Job', cronExp, new CountrySyncSchedule());
    }

}