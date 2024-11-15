# iCal Server

This Service can be configured to parse iCal files and expose their content via gRPC or an REST API

It uses viper for configuration and the configuration supports reloads at runtime.

## Configuration

### Server config

```yaml
server:
  server: ""      # ! Does not support changing at runtime
  httpPort: 8080  # ! Does not support changing at runtime
  grpcPort: 50051 # ! Does not support changing at runtime
  debug: false    # Control if debug logs are printed
  refresh: 5m     # how often are the calendars refreshed? Must be parsable by time.ParseDuration()
```

### Calendar config

It is possible to add multiple iCal calendar feeds to pull multiple calendars from multiple sources.
ical files can be read either from a URL or from a local file

```yaml
calendars:
  calendar1:
    from: file
    ical: ./path/to/calender1.ics
  calendar2:
    from: url
    ical: www.example.com/calendar/calendar.ics
```

### Rules config

Rules allow you to filter events, or apply re-labeling.
Rules are evaluated in the order of which they are specified in.
The rule-evaluation stops after the event matches the first rule.

#### Relabel

The rule below matches if the `Title` of your calendar event contains the string `1:1` and then sets the display message to `1:1` as well as marking the event as important

```yaml
rules:
  - name: "1:1s"
    key: "title"
    contains:
      - "1:1"
    relabelConfig:
      message: "1:1"
      important: true
```

#### Skip rules

If a rule specifies `skip: true` then each calendar event that matches this rule is excluded from the API responses.
Below are examples to skip all day and non-blocking events:

```yaml
rules:
  - name: "Skip all day events"
    key: "all_day"
    contains:
      - "true"
    skip: true

  - name: "Skip non-blocking events"
    key: "busy"
    contains:
      - "Free"
    skip: true
```

#### Wildcard matching

You can use `*` as a wildcard to match everything. If `key` uses the wildcard, it will search all fields.
This is useful for catch-all rules that allow all other events that did not match previous rules to be included in the API responses.

```yaml
rules:
  - name: "Allow everything else"
    key: "*"
    important: false
    contains:
      - "*"
```
