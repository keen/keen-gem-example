# keen-gem-example

This example Sinatra app shows how to use the
[Keen IO Ruby gem](https://github.com/keenlabs/keen-gem)
to publish asynchronous events via the Keen IO API.

See it in action at
[http://keen-gem-example.herokuapp.com/](http://keen-gem-example.herokuapp.com/).

The app lets you compare synchronous and asynchronous response
times, and vote for your **favorite Star Trek TNG character!**

### Usage

To play with your own copy, follow these steps:

Make sure you have a [Keen IO Account](https://keen.io/). Create a new project and note its Project ID and API key.

Clone this repository. cd into the new directory.

Set the KEEN_API_KEY and KEEN_PROJECT_ID variables in a file called .env in the project root. This file is used by foreman.

    KEEN_PROJECT_ID=your-project-id
    KEEN_API_KEY=your-api-key

Use `foreman start` to start the server.

Navigate to `http://localhost:5000/` and start sending events!

Bonus: If you watch the server log as you send events, you can see
the exact moment that calls return, both in synchronous and
asynchronous cases.

### How it works

When publishing events via `publish_async`, the Keen IO Ruby
gem uses [em-http-request](https://github.com/igrigorik/em-http-request)
to make non-blocking calls. This shifts the calls to the event loop,
removing them from the critical path for the request.

### FAQ

##### Do I need an EventMachine server like thin to use the asynchronous calls?
No. In that case, just add `eventmachine` and `em-http-request` to your Gemfile and start EventMachine in a separate thread.
Put this code in an initiaizer:

    Thread.new {
      EventMachine.run
    }

For more background, here's a blog article about using [EventMachine and Passenger](http://railstips.org/blog/archives/2011/05/04/eventmachine-and-passenger/).

### Misc
If you have any questions, bugs, or suggestions, please
report them via Github Issues. Or, come chat with us anytime
at [users.keen.io](http://users.keen.io). We'd love to hear your feedback and ideas!
