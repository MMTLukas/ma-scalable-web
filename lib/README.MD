Item Tracking System
===========================

Start:	bundle exec rackup -o 0.0.0.0 -p 9292 config_item_tracking_system.ru
Test:	httparty -v -u paul:thepanther http://localhost:9292/items
		httparty -v -u paul:thepanther -a post '{"name":"PC","location":"1"}' http://localhost:9292/items
		httparty -v -u paul:thepanther -a delete http://localhost:9292/items/1


Location Management System
===========================

Start:	bundle exec rackup -o 0.0.0.0 -p 9393 config_location_management_system.ru
Test:	httparty -v -u paul:thepanther http://localhost:9393/locations
		httparty -v -u paul:thepanther -a post '{"name":"FH","address":"urstein"}' http://localhost:9393/locations
		httparty -v -u paul:thepanther -a delete http://localhost:9393/locations/1


Report System
===========================

Start:	bundle exec rackup -o 0.0.0.0 -p 9494 config_report_system.ru
Test:	httparty -v -u paul:thepanther http://localhost:9494/reports/by-location


User Management System
===========================

Start:	bundle exec rackup -o 0.0.0.0 -p 9595 config_user_management_system.ru
Test:	httparty -v -u paul:thepanther "http://localhost:9595/user