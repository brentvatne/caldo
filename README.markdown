# Caldo
## RMU personal project - January 2012 course
### Created by: Brent Vatne

## Use it
1. Install dependencies: `bundle install`. Ensure you have a sqlite
	 library installed that is compatible with DataMapper.
2. `ruby app/bootstrap.rb`
3. Navigate to `http://localhost:4567/`

## Elevator pitch please
The vision: Caldo is short for Calendar do. It turns your Google Calendar events into todo-lists. Upon marking them as complete, the event will be immediately
updated in Google calendar to visually reflect the change.

## What does it *currently* do?

### Authenticate and list events

- Authenticate using OAuth2
- List events by day, accesible by path `/2012-01-14` (`yyyy-mm-dd`)

## What will it do?

Two core features are remaining:

### Mark events as "completed" in Google Calendar

- Little checkboxes beside each event to mark as completed
- Clicking will change event color to green, indicating that it was
	done.
- Removing the check will change the color to grey, indicating that it
	is not done.

### Record metadata to events upon completion

- Put a tag in the title of your event to indicate that you want to
	record some data about it upon completion. For example "Run -
	{{minutes}}" will ask you for the number of minutes it took you to
	complete the task. Assuming you input 30 minutes, Caldo will rename the event
	to "Run - 30 minutes".
- Other tags can be included in the description, and will be recorded as
	well.

Hey, that's a lot of work you say! Yeah, it is. This is my goal for the
RMU course, afterwards I would like to continue adding the following
features:

- Customize event colors so everything isn't necessarily green.
- iPhone friendly layout

## Run the tests
Uses Rspec, to run the suite: `bundle install && rake`
*Tested with: Ruby 1.9.3p0*

