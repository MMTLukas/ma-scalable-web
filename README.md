# Scalable Web Architectures - Challenge

TThis documents describes how to start and test the four services of this repository. The services are:
  * Item Tracking System (Port 9292)
  * Location Management System (Port 9393)
  * Report System (Port 9494)
  * User Management (Port 9595)

All services build up on [sinatra](http://www.sinatrarb.com/). All commands in this document should be executed in the root directory of the project. Every request to any resource of the services has to be authorizied from the service **User Management**. To start the services on your system make sure you have installed all necessary plugins with following command:
```shell
bundle install
```

### Directory content
```doc
./                                  # place of all config.ru files, the readme.md and the gemfile
lib/                                # directory of the four services
  item_tracking_system/             # system which stores items
  location_management_system/       # system which stores locations
  report_system/                    # system which combines items and locations
  user_management_system/           # system which authentificates
spec/lib/                           # contains the specs of the services in the lib directory

```

### Tests

**ATTENTION**: For this you have to start the Item Tracking, the Location Management and the User Management System. For informations how to start this services, scroll to the different sections in this README.MD or check the header of the files in spec/lib/**
To test all services at once, you can run the following command:
```shell
rspec
```
This should give you a overview of serveral specs testing the services.


## Item Tracking System

This service allows the users to store, retrieve and delete items
* **GET**: /items prints all the stored items
* **POST**: /items save an additional item. In the body of this request has to be a json object with following structures and attributes:

```json
  {
    "name": "Smiths PC",
    "location": 1
  }
```
* **DELETE**: /items/:id deletes an item from the store

### Commands

**Start**
```shell
bundle exec rackup -o 0.0.0.0 -p 9292 config_item_tracking_system.ru
```

**Try it out**
```shell
httparty -v -u paul:thepanther http://localhost:9292/items
httparty -v -u paul:thepanther -a post -d '{"name":"PC","location":"1"}' http://localhost:9292/items
httparty -v -u paul:thepanther -a delete http://localhost:9292/items/1
```

## Location Management System

This service allows the users to store, retrieve and delete locations
* **GET**: /locations prints all the stored items
* **POST**: /locations save an additional location. In the body of this request has to be a json object with following structures and attributes:

```json
  {
    "name": "University of Applied Science Salzburg",
    "address": "Urstein Sued 1, 5020 Salzburg, Austria"
  }
```
* **DELETE**: /locations/:id deletes an location from the store

### Commands

**Start**
```shell
bundle exec rackup -o 0.0.0.0 -p 9393 config_location_management_system.ru
```

**Try it out**
```shell
httparty -v -u paul:thepanther http://localhost:9393/locations
httparty -v -u paul:thepanther -a post -d '{"name":"FH","address":"urstein"}' http://localhost:9393/locations
httparty -v -u paul:thepanther -a delete http://localhost:9393/locations/1
```

## Report System

This system combines the two services before. A report exist of all stored locations, extended with the items at this location. The only possible url is **/reports/by-location** The output has the following structure:

```json
[
  {
    "name": "University of Applied Science Salzburg",
    "address": "Urstein Sued 1, 5020 Salzburg, Austria",
    "id": 1,
    "items": [
      {
        "name": "Smiths PC",
        "location": 1,
        "id": 1
      },
      {
        "name": "Mosers PC",
        "location": 1,
        "id": 2
      }
    ]
  },
  ...
]
```

### Commands

**Start**
```shell
bundle exec rackup -o 0.0.0.0 -p 9494 config_report_system.ru
```

**Try it out**
```shell
httparty -v -u paul:thepanther http://localhost:9494/reports/by-location
```

## User Management System

This service handles the from the users served authentification data. The url for the service is **/user**. As said before, the user needs for every request to any of the four services a valid username and password combination. Three combinations are allowed: 

User  | Password
----- | -------------
wanda | partyhard2000
paul  | thepanther
anne  | flytothemoon

### Commands

**Start**
```shell
bundle exec rackup -o 0.0.0.0 -p 9595 config_user_management_system.ru
```

**Try it out**
```shell
httparty -v -u paul:thepanther "http://localhost:9595/user
```

## [12 Factor App](http://12factor.net/)

This app try to satisfy the 12 factor rules, some of them are:
* Codebase: The codebases is stored in a version control system
* Dependencies: The gemfile explicitly declares dependencies and the system don't assume existing system tools
* Process: The processes are stateless and share nothing
* Port binding: The services communicates via a simple url with a port
* Dev/prod parity: There is no production releases, there can't be different enviroments
* Admin processes: Because there is only one stage, the tests enviroment don't differs to some other stages