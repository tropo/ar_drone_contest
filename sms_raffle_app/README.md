Setup
=======
* Edit config.yml file with appropriate settings
* Setup a Tropo "WebAPI" application and set the start URL to http://your-server.com/
* Put message token in config.yml
* Setup CouchDB and put DB parameters in config
* * Tested w/ [ Iris Couch](http://www.iriscouch.com "Iris Couch").
* Start application and navigate to http://your-server.com/users

Deployment
==========

Sinatra Application
-------
    ruby app.rb
   
Rack Application
--------
    server {
       listen       80;
       server_name  localhost;
       root /www/contest_app/public;
       passenger_enabled on;
     }

CouchDB
=======

Setup Couch View
----------------
  This view returns a random record / winner from our couchDB based on the __rand__ column in our database

    function(doc) {
      if(doc._rev.charAt(0) == '1') {
        emit(doc.rand, doc);
    }
    
    