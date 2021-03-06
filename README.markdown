# Caldo
## RMU personal project - January 2012 course
### Created by: Brent Vatne

## Use it
1. Install dependencies: `bundle install`. Ensure you have a sqlite
	 library installed that is compatible with DataMapper.
2. Configure environment variables with Google your Google API data.
   Steps for setting up your Google API account can be found [here](http://code.google.com/p/google-api-ruby-client/source/browse/calendar/README.md?repo=samples#29). Once you have your client id and client secret, copy `config/api_credentials.rb.example` to `config/api_credentials.rb` and fill it in with your information.
3. `rake server`
4. Navigate to `http://localhost:4567/`

Alternatively, you give it a test run: [http://caldo.webbyapp.com/](http://caldo.webbyapp.com/)

## Elevator pitch please
The vision: Caldo is short for Calendar do, and it means soup in Spanish. It
turns your Google Calendar events into todo-lists. Upon marking them as
complete, the event will be immediately updated in Google calendar to
visually reflect the change.

## What does it *currently* do?

### Authenticate and list events

- Authenticate using OAuth2
- List events by day, accesible by path `/2012-01-14` (`yyyy-mm-dd`)
- Include events tagged as \*important\* 5 days before they come due.

### Mark events as "completed" in Google Calendar

- Checkboxes beside each event to mark as completed
- Clicking will change event color to green, indicating that it was
	done.
- Removing the check will change the color to grey, indicating that it
	is not done.

### Mobile (concentrating on iPhone) specific layout

### Backbone.js client side rendering of Todos

## What will it do?

The above functionality is all that was planned for completion during
the Mendicant University core skills course. The following features may
be implemented later:

- Choose the calendar you want to use (it uses only the primary calendar currently).
- Get more information about the Todo - description, location, link to Google Calendar event. Hidden until toggled (hover?).
- API access to your todos and a command line client that uses it
- Record metadata about events - put a single tag in the title of your event to indicate that you want to
	record some data about it upon completion. For example "Run -
	{minutes}" will ask you for the number of minutes it took you to
	complete the task. Assuming you input 30 minutes, Caldo will rename the event
	to "Run - 30 minutes". *this functionality has been temporarily removed*
- Also have metadata in the description - maybe number of pomodoros for
  example.
- Ability to uncheck events that store data and have it ask for the variable value upon marking complete again.

## Known bugs

- Crashes on production server when calendar information contains UTF-8
  characters.
- Day is displayed on important, even if it is the day of the event

## Run the tests
Uses Rspec, to run the suite: `bundle install && rake`
*Tested with: Ruby 1.9.3p0*

