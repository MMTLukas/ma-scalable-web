# Final Challenge

This documents describes how to start and test the four services of this repository. The services are:
  * Item Tracking System
  * Location Management System
  * Report System
  * User Management

All commands in these document should be executed in the root directory. Every request to any resource has to be authorizied from the last service **User Management**.

## Item Tracking System

This service allows the users to store, retrieve and delete items
* **GET**: /items prints all the stored items
* **POST**: /items save an additional item. In the body of this request has to be a json object with following structures and attributes:

```json
  {
    "name": "Smiths PC",
    "location": 1,
    "id": 1
  }
```
* DELETE: /items/:id deletes an item from the store

### Commands

**Start**
```shell
bundle exec rackup -o 0.0.0.0 -p 9292 config_item_tracking_system.ru
```

**Try it out**
```shell
httparty -v -u paul:thepanther http://localhost:9292/items
httparty -v -u paul:thepanther -a post '{"name":"PC","location":"1"}' http://localhost:9292/items
httparty -v -u paul:thepanther -a delete http://localhost:9292/items/1
```

## Location Management System

This service allows the users to store, retrieve and delete locations
* **GET**: /locations prints all the stored items
* **POST**: /locations save an additional location. In the body of this request has to be a json object with following structures and attributes:

```json
  {
    "name": "University of Applied Science Salzburg",
    "address": "Urstein Sued 1, 5020 Salzburg, Austria",
    "id": 1
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
httparty -v -u paul:thepanther -a post '{"name":"FH","address":"urstein"}' http://localhost:9393/locations
httparty -v -u paul:thepanther -a delete http://localhost:9393/locations/1
```

## Report System

This system combines the two services before. A report exist of all stored locations, extended with the items at this location. The only possible url is /reports/by-location The output has the following structure:

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








# Final Challenge
## Intro
* A user management system
## The Systems
### User Management
**GET /user**