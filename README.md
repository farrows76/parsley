# Welcome to Parsley

Parsely is an API that migrates data from that file and inserts the data into a NoSQL database (DynamoDB).
Parsely has four endpoints (Find, Update, Create, and Upload) where you can store new or update existing items
in the NoSQL database.

Endpoints:

  * GET http://parsley.us-west-2.elasticbeanstalk.com/find/:id
  
  * PUT http://parsley.us-west-2.elasticbeanstalk.com/update
  
  * POST http://parsley.us-west-2.elasticbeanstalk.com/create

  * POST http://parsley.us-west-2.elasticbeanstalk.com/upload

## System Dependencies
  * Ruby 2.3
  * Rails 5.0.2
  * AWS DynamoDB
  * AWS Elastic Beanstalk

## Making Requests

There are four endpoints that can be used to interact with the API. http://parsley.us-west-2.elasticbeanstalk.com

A JSON request to the API would look like this:

```
  POST http://parsley.us-west-2.elasticbeanstalk.com/create 

  {
    "item": {
      "id": "1033424",
      "sharing_settings": {
        "publish_rsvp_actions": true,
        "publish_track_actions": true
      }
    }
  }
```

### Find

Find expects you to pass an **ID** along with the request to find a specific item in the database.

An example of a find request would be like this:

```shell
  # Using curl to make the GET request
  curl --header "Accept:application/json" http://parsley.us-west-2.elasticbeanstalk.com/find/1033424
  
  # Either returns a 404 not found
  => {"status":404,"error":"Not Found"}
  
  # Or the item from the database
  => {"id":"1033424","sharing_settings":{"publish_rsvp_actions":true,"publish_track_actions":true}}
```







Example URL: https://gist.githubusercontent.com/fcastellanos/86f02c83a5be6c7a30be390d63057d7d/raw/b25c562a6823a26a700a7ea08004c456ad8e2184/output


```
curl --header "Accept:application/json" http://parsley.us-west-2.elasticbeanstalk.com/find/1033424
curl -i -X POST -H "Content-Type:application/json" http://parsley.us-west-2.elasticbeanstalk.com/create -d '{"item":{"id":"1033424","sharing_settings":{"publish_rsvp_actions":true,"publish_track_actions":true}}}'
curl -i -X PUT -H "Content-Type:application/json" http://parsley.us-west-2.elasticbeanstalk.com/update -d '{"item":{"id":"1033424","sharing_settings":{"publish_rsvp_actions":true,"publish_track_actions":true}}}'
curl -i -X PUT -H "Content-Type:application/json" http://parsley.us-west-2.elasticbeanstalk.com/update -d '{"item":{"id":"1033424","sharing_settings":{"publish_rsvp_actions":false,"publish_track_actions":false}, "notification_settings": {"just_announced": "false", "friend_comment": "true"}}}'
curl -i -X POST -H "Content-Type:application/json" http://parsley.us-west-2.elasticbeanstalk.com/upload -d '{"url": "https://gist.githubusercontent.com/fcastellanos/86f02c83a5be6c7a30be390d63057d7d/raw/b25c562a6823a26a700a7ea08004c456ad8e2184/output" }'
```

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions