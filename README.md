# EtTestHelpers

A gem to assist in testing employment tribunal applications or
any other application that uses GDS components.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'et_test_helpers'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install et_test_helpers

## Usage

### Using The Capybara Selectors

The ethos of this gem is to always find the top level of a component given a selector
which is normally a visual label (can be a simple string, a hash or a symbol 
to point into an I18n file if configured).  What is meant by that is better 
demonstrated in an example text field.

The source of this information is https://design-system.service.gov.uk/components/text-input/

A govuk GDS compliant text field looks like this with a hint and errors

![Text Field With Errors And A Hint](docs/images/text-field-with-errors-and-hints.png)

and its HTML looks like this

```html
<div class="govuk-form-group govuk-form-group--error">
  <label class="govuk-label" for="event-name">
    Event name
  </label>
  <span id="event-name-hint" class="govuk-hint">
    The name you’ll use on promotional material.
  </span>
  <span id="event-name-error" class="govuk-error-message">
    <span class="govuk-visually-hidden">Error:</span> Enter an event name
  </span>
  <input class="govuk-input govuk-input--error" id="event-name" name="event-name" type="text" aria-describedby="event-name-hint event-name-error">
</div>
```

Using normal capybara selectors, if you were to do
```ruby
find(:fillable_field, 'Event name')
``` 

against the above HTML, it would provide you with the input element.
But, we dont want that, we want the wrapper around it - which
will be the root of the component - so the component can fetch its
input element, its label, its error messages etc..

All of the capybara selectors are prefixed with 'govuk_' and named 
hopefully sensibly.

So, to get access to the root of the above text field we would use

```ruby
find(:govuk_text_field, 'Event name')
```

or if you are doing a multi lingual test suite

```ruby
find(:govuk_text_field, :'root.of.component')
```

where the value will be looked up by I18n.t by adding '.label' i.e. 'root.of.component.label'.
The use of an object in i18n to represent the component is to allow specification
of at least the 'label' (the visual label for this component), but can also
be used for things like hints and errors, allowing the component to be simply
validated in your test suite using the .valid? method

or if your test suite has its own method of translation (so for example you
are separating test expectations from implementation which is good practice)

Put this somewhere that executes before any tests are run

```ruby
EtTestHelpers.configure do |c|
  c.translate = ->(key) { MyI18nLibrary.t(key) }
end
```

replacing MyI18nLibrary.t with whatever method you want

### Using The SitePrism Components

This gem provides site prism (https://rubygems.org/gems/site_prism) sections as 'components' so that you can do the following in your
page objects.

```ruby
  class MyPage < ::SitePrism::Page
  gds_text_input :govuk_text_field, 'Text field label'
  end
```

When you create an instance of this page as normal, you can then do :-

```ruby
  my_page.govuk_text_field.label.text
```
to fetch the label text or

```ruby
  my_page.govuk_text_field.hint.text
```
to fetch the hint text or

```ruby
  my_page.govuk_text_field.input.value
```
to fetch the input value or
```ruby
  my_page.govuk_text_field.error.text
```
to fetch the error text or

```ruby
    expect(my_page.govuk_text_field).to be_valid
```
this will need the label to be valid and to be attached to the input field in 
order for the component to be even found, then it will also check that it's
hint is valid if this was specified as part of the hash or i18n section.

```ruby
  expect(my_page.govuk_text_field.label).to have_text('Expected Label')
  expect(my_page.govuk_text_field.hint).to have_text('Expected Hint')
```
etc.. etc..

Note that these methods define a site prism section by calling the class method
'section' - any extra args passed are passed to that - and also - if you pass a block
using 'do .. end' or '{ ... }' then this also gets passed to the section.

#### Advanced Usage

The nice simple 'gds_' class methods above are just shortcuts to save you having to
know the various matchers to use etc..  They just define a site prism section
using the 'section' class method defined by site prism

You can take complete control by defining a section yourself like this

```ruby
section :fieldset_name, govuk_component(:fieldset), :govuk_fieldset, :'i18n.key' do
  include EtTestHelpers::Section
  #... code that would normally exist in a site prism section ...
end  
```

The key thing here is the govuk_component class method which looks up the component type
and :govuk_fieldset is a capybara selector to match the root element.

### Examples

Whilst you can use a simple string to specify the 'label' of a component,
this will not allow the use of more advanced features such as complete validation
using the valid? method, the validation of error messages using the has_error? method etc..
So, we can either use a hash if your app is not multi lingual or a symbol which uses dot
notation to point to the section in an I18n file - which is then the same as using 
a hash.

The examples below will always use the symbol and the I18n file.

#### The GDS Text Input
(https://design-system.service.gov.uk/components/text-input/)

The section in the yaml file
```yaml
    en:
      my_page:
        age_question:
          label: How old are you?
          hint: You should know this
          errors:
            too_young: Sorry, you need to be at least 16
            invalid: Please enter a number
```

Our page object

```ruby
    class MyPageObject < SitePrism::Page
      include EtTestHelpers::Page
      
      gds_text_input :age_question, :'my_page.age_question'
    end
```

As you can see :'my_page.age_question' points to 'en.my_page.age_question' in the yaml file,
so the component knows to use the 'label' from inside this section to find the root of the
component.

In our test suite, we can then do this (rspec example given - but can be adapter to anything)

```ruby
let(:my_page) { MyPageObject.new }

it 'should have an age question which is correctly labelled and has correct hint' do
  expect(my_page.age_question).to be_valid
end

it 'should have an age question with a too young error message' do
  my_page.age_question.set('15')
  ...
  expect(my_page.age_question).to have_error(:too_young)
end

```
Note that the have_error call does not need the full 'path' to the error message as
the component knows to look in 'errors' relative to the root ('en.my_page.age_question')
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/et_test_helpers. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/et_test_helpers/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the EtTestHelpers project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/et_test_helpers/blob/master/CODE_OF_CONDUCT.md).
