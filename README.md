# Strava Salesforce Integration

This project facilitates the integration of Strava athlete data into Salesforce. It leverages the Strava API to fetch athlete statistics such as ride and run totals and updates corresponding athlete records in Salesforce.

## Usage

### Setup Strava Authentication:

1. Obtain a Client ID and Client Secret from the Strava developer portal.
2. Set up OAuth 2.0 authentication in Salesforce connected app settings, providing the Client ID and Client Secret.

### Configure Salesforce Custom Object:

1. Create a custom object named Athlete__c in Salesforce with fields to store athlete data.

### Deploy Apex Classes:

1. Deploy the StravaAPIController.cls and StravaTokenRefresher.cls Apex classes to your Salesforce org.

### Execute Integration:

1. Invoke the `makeStravaAPICall()` method in the StravaAPIController class to fetch athlete statistics from Strava and update corresponding Salesforce records.
2. Ensure that the `accessToken` variable in the `makeStravaAPICall()` method contains a valid Strava access token.

### Review Results:

1. Check Salesforce athlete records to verify that the fetched statistics are updated.

## Notes

- This integration assumes familiarity with Salesforce Apex programming and Strava API authentication.
- Ensure proper error handling and testing before deploying the integration to production environments.
- For detailed documentation and troubleshooting, refer to the comments in the Apex classes and consult the Strava API and Salesforce developer documentation.


## Read All About It

- [Salesforce Extensions Documentation](https://developer.salesforce.com/tools/vscode/)
- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)

## Strava API Documentation

For details on the Strava API and how to integrate it with your Salesforce project, refer to the [Strava API Documentation](https://developers.strava.com/docs/reference/). This documentation provides information on authentication, endpoints, request parameters, and response formats.
