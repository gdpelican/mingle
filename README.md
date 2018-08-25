# Mingle

An icebreaker bot for Discourse

### How it works

Specify a time period (e.g. 2 weeks), a group of users, and a customizable message.

Once per time period, we'll randomly pair up people in the group, and send them a friendly message, inviting them to get to know each other a little better.

### What to do

In order to set up a Mingle, follow these four steps:

- Install the plugin by following your [normal plugin installation instructions](https://meta.discourse.org/t/install-plugins-in-discourse/19157)
- Then, visit the Mingle settings panel at `<yoursite.com>/admin/site_settings/category/all_results?filter=mingle`. Select a group, setup a time period, and select a user to send the message.

- Visit the #staff category; you should see a new topic there, with 'Mingle' in the title. This is the template for your message! Click into it, read the instructions, and customize a message to send to your users.


- You're done! The first message will go out in the specified time period, and a new one will be scheduled once it's sent.

### If things go weird
- If you modify either the interval type or interval number (for example, changing from 3 to 4 weeks, or 3 days to 3 weeks), Mingle will automatically reschedule the existing job for the specified time interval.
- You can view the next scheduled Mingle in your sidekiq queue at `<yoursite.com>/sidekiq/scheduled`; it's the one called `Jobs::Mingle`. Adding it to the queue will perform it immediately, and schedule another one in the future.
- To stop scheduling Mingles, simply disable the mingle_enabled setting.
- If you end up without a scheduled job there somehow, simply disable and then re-enable the Mingle plugin, and it should come back
- If you've mangled your template beyond repair, you can get the original template back by running
```
/var/discourse/launcher enter app
rails c
Mingle::Initializer.new.reinitialize!
```

### Contributing

###### Bug reports

Check out the [issues list](http://github.com/gdpelican/mingle/issues) to take a look at known issues and report ones we don't know about yet.

###### Code

- Fork it (`https://github.com/[my-github-username]/mingle/fork`)
- Create your feature branch (`git checkout -b my-new-feature`)
- Commit your changes (`git commit -am 'Add some feature'`)
- Push to the branch (`git push origin my-new-feature`)
- Create a new pull request
- Be an awesome open source contributor!
