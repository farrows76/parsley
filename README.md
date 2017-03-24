# Welcome to Parsley

Parsley is an API that parses data from a file, turns the data into a hash and inserts it into a NoSQL database (DynamoDB).
Parsley has four endpoints (Find, Update, Create, and Upload) where you can store new or update existing items
in the NoSQL database. Before the item is stored, the API will change all the "truth" and "false" strings to booleans.

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

## Links of Interest

There are three files that contain most of the code for this API

* Items Controller - https://github.com/farrows76/parsley/blob/master/app/controllers/items_controller.rb

* Item Model - https://github.com/farrows76/parsley/blob/master/app/models/item.rb

* Parser Service - https://github.com/farrows76/parsley/blob/master/app/services/parser_service.rb

## Getting Started

The database will be empty at first to allow for uploading a file from a url to see how the upload works. Use
the following curl command to upload the example file:

```shell
  curl -i -X POST -H "Content-Type:application/json" http://parsley.us-west-2.elasticbeanstalk.com/upload -d '{"url": "https://gist.githubusercontent.com/fcastellanos/86f02c83a5be6c7a30be390d63057d7d/raw/b25c562a6823a26a700a7ea08004c456ad8e2184/output" }'
```

Feel free to try some of the other endpoints before adding data to see how they work as well.

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

## Find

Find expects you to pass an **ID** along with the request to find a specific item in the database.

An example of a find request would be like this:

```shell
  # Using curl to make the GET find request
  curl --header "Accept:application/json" http://parsley.us-west-2.elasticbeanstalk.com/find/1033424
  
  # Either returns a 404 not found
  => {"status":404,"error":"Not Found"}
  
  # Or returns the item from the database
  => {"id":"1033424","sharing_settings":{"publish_rsvp_actions":true,"publish_track_actions":true}}
```

## Update

Update expects you to pass an **ITEM** hash in the body of the request. The **ITEM** hash must have at least an **id** as
a key. Updating an item will update the existing key's values that were retrieved from the database as well add any
additional key/values that are new.

An example of an update request would be like this:

```shell
  # Using curl to make the PUT update request
  curl -i -X PUT -H "Content-Type:application/json" http://parsley.us-west-2.elasticbeanstalk.com/update -d '{"item":{"id":"1033424","sharing_settings":{"publish_rsvp_actions":"false","publish_track_actions":"false"},"notification_settings":{"just_announced":"false","friend_comment":"true"}}}'
  
  # Either returns a 404 not found
  => {"status":404,"error":"Not Found"}
  
  # Or returns the updated item as it was stored in the database
  => {"id":"1033424","sharing_settings":{"publish_rsvp_actions":false,"publish_track_actions":false},"notification_settings":{"just_announced":false,"friend_comment":true}}
```

## Create

Create expects you to pass an **ITEM** hash in the body of the request. The **ITEM** hash must have at least an **id** as
a key. If the item already exists in the database it will return a validation error and not update that item.

An example of a create request would be like this:

```shell
  # Using curl to make the POST create request
  curl -i -X POST -H "Content-Type:application/json" http://parsley.us-west-2.elasticbeanstalk.com/create -d '{"item":{"id":"1033424","sharing_settings":{"publish_rsvp_actions":true,"publish_track_actions":true}}}'
  
  # Either returns a 422 unprocessable entity
  => {"error":{"data":["The conditional request failed"]}}
  
  # Or returns the created item as it was stored in the database
  => {"id":"1033424","sharing_settings":{"publish_rsvp_actions":true,"publish_track_actions":true}}
```

## Upload

Upload expects you to pass a **URL** hash in the body of the request. The **URL** hash contains a valid url string with
either an "http" or "https". This version takes each line in the file, parses and converts it to a properly formatted
hash then adds it to the DynamoDB Database. It's not the most efficient way to handle a large file, the purposes of this
API call is to show how the API can parse and format a string correclty. For larger files it would be best to do this in
batches and in a background task.

Example URL: https://gist.githubusercontent.com/fcastellanos/86f02c83a5be6c7a30be390d63057d7d/raw/b25c562a6823a26a700a7ea08004c456ad8e2184/output

An example of an upload request would be like this:

```shell
  # Using curl to make the POST upload request
  curl -i -X POST -H "Content-Type:application/json" http://parsley.us-west-2.elasticbeanstalk.com/upload -d '{"url": "https://gist.githubusercontent.com/fcastellanos/86f02c83a5be6c7a30be390d63057d7d/raw/b25c562a6823a26a700a7ea08004c456ad8e2184/output" }'
  
  # Will return a results hash with the number of success and failed items it attempted to create
  => {"success":40,"failed":87,"The conditional request failed":87}
```

## Credits
Thank you for allowing me to show you my skill set and giving me the opportunity to become a part of your team! If you have
any questions about the API please don't hesitate to ask.