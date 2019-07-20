# NewRelic support for Crystal

This is a binding to the New Relic C SDK, that allow to take advantage of New Relic's monitoring capabilities and features to instrument in programs written in Crystal.

The binding itself is fully featured and could be found in LibNewRelic. Also provided some wrappers and macros to simplify basic use cases. See [below](#usage)

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     newrelic:
       github: romul/newrelic.cr
   ```

2. Run `shards install`

3. Copy `libnewrelic.a` to `/usr/local/lib`

```bash
cp lib/newrelic/bin/libnewrelic.a /usr/local/lib/libnewrelic.a
```

4. Copy `newrelic-daemon` wherever you would like

```bash
cp lib/newrelic/bin/newrelic-daemon newrelic-daemon
```

Note: Copies of `libnewrelic.a` & `newrelic-daemon` are built for Linux x86_64 for 1.1.0 version of C-SDK, if you would like another target platform or version, please follow build instructions from [C-SDK](https://github.com/newrelic/c-sdk/#building-the-c-sdk)

5. export NEWRELIC_LICENSE_KEY="your license key"


## Usage

```crystal
require "newrelic"

# these 2 lines are required to call only once (when program starts) 
NewRelic::Agent.configure_log("newrelic.log") # optional
NewRelic::Agent.start("Your App Name")

NewRelic.web_transaction("transaction_name") do
  # some code
  NewRelic.segment("segment_name", "Category") do
    # some other code
  end
end
```


## Contributing

1. Fork it (<https://github.com/romul/newrelic.cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Roman Smirnov](https://github.com/romul) - creator and maintainer

**Sponsored by** [Markeaze](https://github.com/Markeaze)