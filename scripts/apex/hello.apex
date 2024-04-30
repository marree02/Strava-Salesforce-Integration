// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents
/* String stravaAthleteId = '130827242';
String JOB_NAME = 'Strava Repeating Job';
Integer TEN_MINUTES = 10;
Datetime sysTime = System.now().addMinutes(TEN_MINUTES);
String cronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
System.schedule(JOB_NAME, cronExpression, new StravaAPIController(stravaAthleteId)); */

StravaAthleteInfoController controller = new StravaAthleteInfoController();
controller.execute(null);

