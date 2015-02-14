# Rally Tally version 1.0 
---
##### Rally Tally makes last-minute event organizing fun & easy via text-message voting.
[(We're deployed!)](http://rallytally.herokuapp.com)
-
## About
- Rally Tally an event organizing app built on Sinatra that utilized the Twilio API.
- This app was created in 4 days as a midterm project for Lighthouse Labs.
- This was the team's first introduction to 3rd party APIs and Heroku plugins.
- We had little to no web development knowledge 4 weeks prior to building this.
- We are in the process of rebuilding it in Rails to better modularize the code.

## Features
- Create an Event with a title, time, multiple venue options, and multiple guests (/app/views/ => new.erb, venues.erb, guests.erb )
- Finalizing the event will text the guests (/app/actions.rb - line 124 to 205).
- Guests can 'vote' on a location via text reply (/app/actions.rb - line 238 to 306).
- Guest votes will be calculated and displayed on Events Details page (/app/views/events/details.erb).
- In meeting either condition A) All guests have voted, or B) 90 minutes before event, guests are notified of finalized venue (/app/models/event.rb/ - line 26 to 42)  (/Rakefile/ - line 7 to 15).

## Technology
- Sinatra framework
- Twilio API
- Heroku scheduler 
- PostgreSQL database
- Bootstrap CSS framework

## Points of interest
1. /app/actions.rb/
2. /app/models/event.rb/