# Credit Mutuel Monitor

Credit Mutuel Monitor (by [Yann Very - @yannvery](https://twitter.com/yannvery)) Monitor your credit mutuel bank accounts.  
This script has been designed as a [BitBar](https://getbitbar.com) plugin

Example showing personal accounts when all accounts have a positive balance.

![Example showing positive accounts](https://raw.github.com/yannvery/credit_mutuel_monitor/master/screenshots/example-all-positive.png)

Example showing personal accounts when an account has a negative balance.

![Example showing one negative account](https://raw.github.com/yannvery/credit_mutuel_monitor/master/screenshots/example-one-negative.png)

Example showing personal accounts when an account has been exclude from monitor.

![Example showing exclude account](https://raw.github.com/yannvery/credit_mutuel_monitor/master/screenshots/example-exclude-account.png)

## Installing plugin

Download the plugin of your choice into your BitBar plugins directory.  

Install `mechanize` gem, open a terminal and execute the following command:  

```sh
gem install 'mechanize'
```

### Configure the refresh time

The refresh time is in the filename of the plugin, following this format:

    {name}.{time}.{ext}

  * `name` - The name of the file
  * `time` - The refresh rate (see below)
  * `ext` - The file extension

For example:

  * `credit_mutuel_monitor.4h.rb` would refresh every four hours.

You can change it to anything you like:

  * 10s - ten seconds
  * 1m - one minute
  * 2h - two hours
  * 1d - a day

### Ensure you have execution rights

Ensure the plugin is executable by running `chmod +x credit_mutuel_monitor.4h.rb`.

#### Plugin Configuration

Credit Mutuel Monitor plugin accessed to your bank account as a browser. You must add your username and password into the `configuration.yml` file like :

```yaml
credit_mutuel:
  username: XXXXXXXXXXX
  password: XXXXXXXXXXX
```

If you don't need to monitor one or more accounts you can specified them into `configuration.yml` file :

```yaml
credit_mutuel:
  username: XXXXXXXXXXX
  password: XXXXXXXXXXX
exclude_accounts:
  - PRET MODULIMMO
  - ETALIS
```

## Contributing

  * If you want to contribute to this plugin, please submit a pull request. Be sure to read [Bitbar guide to writing plugins](https://github.com/matryer/bitbar#writing-plugins).
