# Welcome to Parsley

Parsely is an API that migrates data from that file and inserts the data into a NoSQL database (DynamoDB).
Parsely has two endpoints (PUT, and POST) where you can store new or update existing items in the NoSQL
database.

Example URL: https://gist.githubusercontent.com/fcastellanos/86f02c83a5be6c7a30be390d63057d7d/raw/b25c562a6823a26a700a7ea08004c456ad8e2184/output

Endpoints:

  * parsley.us-west-2.elasticbeanstalk.com/find/:id
  
  * parsley.us-west-2.elasticbeanstalk.com/update
  
  * parsley.us-west-2.elasticbeanstalk.com/create

  * parsley.us-west-2.elasticbeanstalk.com/upload

```
require 'net/http'

url = URI.parse('http://parsley.us-west-2.elasticbeanstalk.com/find/1033424')
url = URI.parse('http://localhost:3000/find/1033424')
req = Net::HTTP::Get.new(url.to_s)
res = Net::HTTP.start(url.host, url.port) {|http|
  http.request(req)
}
puts res.body
```

```
curl --header "Accept:application/json" http://parsley.us-west-2.elasticbeanstalk.com/find/1033424 | python -m json.tool
curl -i -X POST -H "Content-Type:application/json" http://parsley.us-west-2.elasticbeanstalk.com/create -d '{"item":{"id":"1033424","sharing_settings":{"publish_rsvp_actions":true,"publish_track_actions":true}}}' | python -m json.tool
curl -i -X PUT -H "Content-Type:application/json" http://parsley.us-west-2.elasticbeanstalk.com/update -d '{"item":{"id":"1033424","sharing_settings":{"publish_rsvp_actions":true,"publish_track_actions":true}}}' | python -m json.tool
curl -i -X PUT -H "Content-Type:application/json" http://parsley.us-west-2.elasticbeanstalk.com/update -d '{"item":{"id":"1033424","sharing_settings":{"publish_rsvp_actions":false,"publish_track_actions":false}, "notification_settings": {"just_announced": "false", "friend_comment": "true"}}}' | python -m json.tool
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

* ...
