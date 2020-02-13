# hoopla-rails-metrics-quiz

## REQUIREMENTS

Your goal is to create a Ruby on Rails application that interacts with the Hoopla API in order todisplay a
list of Metrics and allow their values to be updated.  We only require a functioning app;
no bonus points are given for UX styling beyond basic readability.

This application should include:
* Landing page will display the list of configured metrics
* Clicking on a metric in the list will take you to a page where metric values are listed
  * __Values are listed for all the users in the organization (even if the user does not have a value set)__
    * In the metric listing page, for users without a value, display a 0 as the value
    * If there is no value, when you click on the user, you should be directed to a page where a new value can be created for that metric and user
  * Values are accompanied by the user's name
  * Only list user values, not team values
* Clicking a user row should take you to another page to edit the metric value. After the value is saved, the user list should be redisplayed, showing the updated value.

## INSTRUCTIONS

Your test account has been set up and populated with users, metrics and their values.  Login and password are provided in an email
along with a skeleton of a rails app to get you past basic authentication, token creation, and URL bootstrapping
1. Login and navigate to the Settings page.  Provision an API Key and make note of theClient ID and Secret.
2. Save the client ID and secret in the .env file provided
3. The Hoopla APIs are documented at ​[Hoopla Developer Hub​](https://developer.hoopla.net). It includes authentication instructions with the Client ID and Secret that are implemented in the HooplaClient helper class.
4. Feel free to modify the HooplaClient helper class to add additional methods as necessary.
5. Generate the appropriate models, views and controllers for the above requirements.
6. Share the link to your Github repo.  Alternatively, zip up your entire Rails project and send to ​christine@hoopla.net
