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


### Other things you can do
- If you'd like to set a specific time for when the next match will happen, you can do so by clicking on the clock next to the displayed scheduled time.
- You can also change the size of the groups people are placed in (default is pairs), by changing the 'Mingle group size' option

### If things go weird
- If you modify either the interval type or interval number (for example, changing from 3 to 4 weeks, or 3 days to 3 weeks), Mingle will automatically reschedule the existing job for the specified time interval.
- You can always change the exact time of the next mingle by visiting the settings panel at `<yoursite.com>/admin/site_settings/category/all_results?filter=mingle` and clicking on the clock button above the settings.
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
