# Caldo
## RMU personal project - January 2012 course
### Created by: Brent Vatne

## Use it
1. Install dependencies: `bundle install`. Ensure you have a sqlite
	 library installed that is compatible with DataMapper.
2. Configure environment variables with Google your Google API data.
   Steps for setting up your Google API account can be found [here](http://code.google.com/p/google-api-ruby-client/source/browse/calendar/README.md?repo=samples#29). Once you have your client id and client secret, assuming a Unix environment:
    - `export CALDO_GOOGLE_API_CLIENT_ID=your_client_id_here`
    - `export CALDO_GOOGLE_API_CLIENT_SECRET=your_client_secret_here`

3. `rake server`
4. Navigate to `http://localhost:4567/`

## Elevator pitch please
The vision: Caldo is short for Calendar do, and it means soup in Spanish. It
turns your Google Calendar events into todo-lists. Upon marking them as
complete, the event will be immediately updated in Google calendar to
visually reflect the change.

## What does it *currently* do?

### Authenticate and list events

- Authenticate using OAuth2
- List events by day, accesible by path `/2012-01-14` (`yyyy-mm-dd`)
- Include events tagged as *important* 5 days before they come due.

### Mark events as "completed" in Google Calendar

- Little checkboxes beside each event to mark as completed
- Clicking will change event color to green, indicating that it was
	done.
- Removing the check will change the color to grey, indicating that it
	is not done.


## What will it do?

One core features are remaining:
### Record metadata to events upon completion

- Put a single tag in the title of your event to indicate that you want to
	record some data about it upon completion. For example "Run -
	{{minutes}}" will ask you for the number of minutes it took you to
	complete the task. Assuming you input 30 minutes, Caldo will rename the event
	to "Run - 30 minutes".

Hey, that's a lot of work you say! Yeah, it is. This is my goal for the
RMU course, afterwards I would like to continue adding the following
features:

- Metadata in the description of an event
- Customize event colors so everything isn't necessarily green.
- Choose the calendar you want to use (currently defaults to your
	primary calendar)
- iPhone friendly layout

## Run the tests
Uses Rspec, to run the suite: `bundle install && rake`
*Tested with: Ruby 1.9.3p0*
