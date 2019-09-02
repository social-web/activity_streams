# ActivityStreams

:warning: Development is in the **alpha** phase. Changes large and small are
expected. Feedback is very welcome.

This library provides Ruby models to represent [Activity Streams](https://www.w3.org/TR/activitystreams-core/).
It will load properties according to the given `@context`, provides an API for 
extending additional `@context`s, and can resolve IRIs automatically.

* [Install](#install)
* [Usage](#usage)
* [Extensions](#extensions)
* [Resolve IRIs](#resolve-iris)

## Install

`gem install social_web-activity_streams`

## Usage

You can load an object via JSON, assignment, or a block.

### Via JSON

```ruby
json = %({
    "@context": "https://www.w3.org/ns/activitystreams",
    "type": "Create",
    "id": "https://example.com/create/1",
    "object": {
      "type": "Note",
      "id": "https://example.com/note/1"
    }
  })

activity_stream = ActivityStreams.from_json(json) # => <ActivityStreams::Activity::Create:instance>
activity_stream.context # => 'https://www.w3.org/ns/activitystreams'
activity_stream.type # => 'Create'
activity_stream.id # => 'https://example.com/create/1'
activity_stream.object # => <ActivityStreams::Object::Note:instance>
activity_stream.object.type # => 'Note'
activity_stream.object.id # =>  'https://example.com/note/1'
```

### Via assignment

```ruby
activity_stream = ActivityStreams::Activity::Create.new
activity_stream.context # => 'https://www.w3.org/ns/activitystreams'
activity_stream.type # => 'Create'
activity_stream.id = 'https://example.com/create/1'

activity_stream.object = ActivityStreams::Object::Note.new
activity_stream.object.type # => 'Note'
activity_stream.object.id = 'https://example.com/note/1'
```

### Via block

```ruby
act = ActivityStreams.new { type 'Follow' }
act.type # => 'Follow'
```

## Extensions

ActivityStreams are [extensible](https://www.w3.org/TR/activitystreams-core/#extensibility)
via additional `@context`s. You can register a context and provide modules to
extend models. 

```ruby
module MyContext
  ActivityStreams.register_context('https://example.org/ns/mycontext', self)

  def self.extended(mod)
    mod.class_eval do
      property :my_prop
    end
  end
end

json = %({
    "@context": [
      "https://www.w3.org/ns/activitystreams",
      "https://example.org/ns/mycontext"
    ],
    "type": "Create",
    "id": "https://example.com/create/1",
    "my_prop": "My prop"
  })

activity_stream = ActivityStreams.from_json(json)
activity_stream.context # => [
  #   "https://www.w3.org/ns/activitystreams",
  #   "https://example.org/ns/mycontext"  
  # ]
activity_stream.my_prop # => 'My prop'
```

## Resolve IRIs

ActivityStreams will resolve IRIs when its internet connection is turned on.

```ruby
ActivityStreams.internet.off? # => true
ActivityStreams.internet.on
ActivityStreams.internet.on? # => true

json = %({
    "@context": "https://www.w3.org/ns/activitystreams",
    "type": "Create",
    "id": "https://example.com/create/1",
    "object": "https://example.com/note/1"
  })

activity_stream = ActivityStreams.from_json(json)
activity_stream.object # => <ActivityStreams::Object::Note:instance>

ActivityStreams.internet.off
activity_stream = ActivityStreams.from_json(json)
activity_stream.object # => 'https://example.com/note/1'
```
