# Welcome to OpenReply

OpenReply is a simple CRM application, focusing on getting feedback about your employees from your customers. It also allows you to meaningfully review and evaluate the feedback given in a simple administrative interface.
Out-of-the-box, it integrates nicely with [OTRS (Opensource Ticket Request System)](http://www.otrs.com/), one of the most widely used ticketing systems. 

![](https://raw.githubusercontent.com/essential-data/openreply/master/app/assets/images/screenshot.png)

## How does it work

The application uses an URL inserted in the footer of each email, sent out from your ticketing system to your customers. This allows the customer to rate the employee answering to his ticket by simply clicking the URL in the footer. The application then offers a simple rating form facing the customer, allowing him to rate the communication with the employee. You can review the ratings collectively in a clean, user-friendly administrative interface offering various statistics and performance indicators.

So, to summarize - the application is divided in two separate modules:

- a public form used by your customers to rate an employee 
- an administration interface to evaluate and review the ratings given by your customers

## Feature list

### Filtering
- by customer, time period, employee

### Statistics
- list of rated employees
- list of customers that rated at least once
  - lists are sorted by average of their ratings
  - name, average, median, difference for time period, number of ratings

- list of all ratings
  - value, employee, customer, ticket id, time and full text of rating
  - sorted by time created
  - customer and employee is linked to filter
  - ticket id is automatically linked to ticket detail in OTRS

### Graphs
  - detailed statistics for selected period
  - histogram
  - timeline chart

### Others
  - New rating email notifications
  - Google analytics in production environment

## Requirements

The application is a standard Ruby on Rails app, using the 4.1.4 version of the framework. Apart from that, there's the following:

### Production environment
-  MySQL
    - A user with privileges to create a database or a user with r/w privileges to pre-existing test and production must exist
    
- Ruby 2.1.0 +
    - It's recommended to create a new gemset when installing
    (if using rvm `rvm use ruby-2.1.0@openreply --create`)
- Bundler
- A web server capable of running Rails apps
    - [Puma][2] is included as the default
- ssh, git
- (recommended) A web server to be used as a reverse proxy (Apache, nginx) 

## Setup

Clone the repo in the directory of your choice and checkout the master branch.

    git clone git@github.com:essential-data:openreply.git
    git checkout master[|develop]
Install all necessary requirements by running:

    bundle install
    
### Configuration

Configuration options are extracted into an [.env](https://github.com/bkeepers/dotenv) file in the project root directory. There's a commented .env.example file to be used as a template.

#### Setup the database
Seed the database after you have created one in mysql, and configured the credentials in .env

    rake db:setup
    
### Run the server
    
    rails server
    
Visit http://localhost:3000


### Deployment via [capistrano](https://github.com/capistrano/capistrano) 
Deployment to both staging and production environments is pre-configured in .env file. See .env.example - section: # DEPLOY WITH CAPISTRANO 

Then run

    cap deploy:setup                # Prepares one or more servers for deployment.
    
and:

    cap deploy:check                # Test deployment dependencies.
    
The deployment itself is done by running:

    cap deploy
    cap deploy:migrate
    
All of the commands above are for staging (the default stage). When deploying to production you need to provide the production environment explicitly:

    cap production deploy:setup
    cap production deploy
    
**Important**
You need to copy the .env file into the /path/to/openreply/shared directory (which set in OPENREPLY_DEPLOY_TO_STAGING variable) 

        
### Setting up OTRS integration (optional)
In OTRS you can setup a link for each email footer. After clicking this link your customers can provide feedback for the particular ticket and the employee.

#### Email footers
The URL in the email footer has following format:

> http://your-server.com/ratings/new?firstname=[employee_firstname]&lastname=[employee_surname]&ticketID=[ticket_id]&customer=[customer_name]

After clicking the link, the following screen appears:

![](https://raw.githubusercontent.com/essential-data/openreply/master/app/assets/images/screenshot_rating.png)

To disallow multiple ratings in a short succession, the rating is stored to user's cookie, so he / she is not allowed to rate the same customer / issue pair for the following hour.

After the rating, the user is redirected to the company website (set in .env file in OPENREPLY_REDIRECT_TO_WEBPAGE variable).

#### OTRS API

is a simple REST API built over the OTRS-backing database. It can be easily installed following [these instructions]() over the OTRS 3.1.+ database and allows additional functionality in OpenReply.

You can activate OTRS API in *config/settings.yml* and set OTRS API setting in *.env* (have a look at .env.example) 

Among other functionality, the API is first and foremost used to validate the URL parameters in the validation link. Basically, we ask the API if the **ticket** has been created by the **customer** and if it was at any time assigned to the **employee**).


## App specific configurations

- global switches and UI settings are in settings.yml
- Settings for Capistrano are in .env
- Settings for OTRS are in .env
- Usage of (optional) OTRS API is set in config/settings.yml under `otrs_api.enabled`
- Settings for SMTP mail server are in .env
- Usage of (optional) email notifications for new ratings is set in config/settings.yml under `new_rating_notifications_emails`
- Settings for Google analytics are in .env
- Usage of (optional) google analytics is set in config/settings.yml under `google_analytics` 

## Contributing
Feel free to contribute if you find it useful. 

## License
OpenReply is released under the [MIT License](http://www.opensource.org/licenses/MIT).


1. http://rubyonrails.org
2. http://otrs.com 
3. http://puma.io
