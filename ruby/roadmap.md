# Ruby Learning Roadmap

A high-level guide to learning Ruby from scratch.

## Phase 1: Fundamentals (Start Here)

**Focus: Get comfortable with Ruby syntax and philosophy**

### Start With:
1. **Basic Syntax**
   - Variables and data types (String, Integer, Float, Boolean)
   - puts and print for output
   - gets for input
   - Comments

2. **Control Flow**
   - if/elsif/else statements
   - unless (Ruby's negative if)
   - while and until loops
   - for loops and iterators

3. **Core Data Structures**
   - Arrays (most important)
   - Hashes (Ruby's dictionaries)
   - Symbols (unique to Ruby)
   - Ranges

4. **Methods**
   - Defining methods with def
   - Parameters and return values
   - Implicit returns (last line)
   - Method naming conventions

**Practice Goal**: Build simple scripts (calculator, text processor, games)

## Phase 2: Ruby's Way of Thinking

**Focus: Learn what makes Ruby unique**

### Core Ruby Concepts:
1. **Blocks, Procs, and Lambdas**
   - Understanding blocks { } and do...end
   - yield and block_given?
   - Procs and lambdas differences
   - Common block patterns

2. **Enumerable Methods**
   - each (most important)
   - map, select, reject
   - reduce, find, any?, all?
   - Method chaining

3. **String and Array Operations**
   - String interpolation
   - String methods (split, join, gsub)
   - Array methods (push, pop, shift, unshift)
   - Slicing and ranges

4. **Symbols vs Strings**
   - When to use each
   - Hash keys as symbols
   - Performance implications

5. **Regular Expressions**
   - Basic pattern matching
   - =~ operator
   - Common regex patterns

**Practice Goal**: Refactor scripts using Ruby idioms (text parser, data transformer)

## Phase 3: Object-Oriented Ruby

**Focus: Everything is an object in Ruby**

### Key Concepts:
1. **Classes and Objects**
   - Class definition
   - initialize method
   - Instance variables (@variable)
   - attr_accessor, attr_reader, attr_writer

2. **OOP Principles**
   - Encapsulation
   - Inheritance (<)
   - super keyword
   - Method visibility (public, private, protected)

3. **Modules and Mixins**
   - Module definition
   - include vs extend
   - Namespacing
   - Common use cases

4. **Ruby's Object Model**
   - Everything is an object
   - Method lookup chain
   - self keyword
   - Class methods vs instance methods

**Practice Goal**: Build class-based applications (card game, inventory system)

## Phase 4: Advanced Ruby Features

**Focus: Write more elegant and maintainable code**

### Topics:
1. **Metaprogramming Basics**
   - define_method
   - method_missing
   - send for dynamic dispatch
   - class_eval and instance_eval

2. **File I/O and System**
   - File operations
   - Directory manipulation
   - System commands
   - CSV and JSON handling

3. **Error Handling**
   - begin/rescue/ensure
   - Custom exceptions
   - raise and fail
   - Rescue specific errors

4. **Testing**
   - Minitest basics
   - RSpec fundamentals
   - Test-driven development
   - Mocking and stubbing

**Practice Goal**: Build tested applications with proper error handling

## Phase 5: Specialized Tracks

**Choose based on your goals**

### Web Development (Most Common Path)
- **Framework**: Ruby on Rails (most popular) or Sinatra (lightweight)
- **Database**: ActiveRecord ORM
- **Testing**: RSpec, Capybara
- **Focus**: MVC pattern, routing, migrations, RESTful design
- **Timeline**: Start after Phase 3

### Gems and Libraries
- **Essential**: Bundler for dependency management
- **HTTP**: HTTParty or Faraday
- **CLI**: Thor or TTY
- **Focus**: Reading gem documentation, contributing to open source

### DevOps and Automation
- **Tools**: Rake for task automation
- **Configuration**: YAML, ENV variables
- **Deployment**: Capistrano
- **Focus**: System administration, scripting

### API Development
- **Framework**: Grape or Rails API mode
- **Serialization**: ActiveModel::Serializers
- **Auth**: Devise, JWT
- **Focus**: RESTful APIs, JSON handling

## Learning Resources Priority

### Best Starting Points:
1. **Try Ruby** - tryruby.org (interactive, quick intro)
2. **Ruby Koans** - rubykoans.com (learn by fixing tests)
3. **Codecademy Ruby** - Interactive exercises

### After Basics:
- **Ruby Docs** - ruby-doc.org (official documentation)
- **Ruby Style Guide** - Learn Ruby conventions
- **Exercism.io** - Practice with mentorship
- **The Odin Project** - Full curriculum including Rails

### Books:
- **"The Well-Grounded Rubyist"** - Comprehensive Ruby
- **"Practical Object-Oriented Design in Ruby" (POODR)** - OOP mastery
- **"Eloquent Ruby"** - Writing idiomatic Ruby

## Key Principles

### Ruby Philosophy:
- **"Principle of Least Surprise"** - Code should be intuitive
- **"Matz is nice, so we are nice"** - Friendly community
- **Multiple ways to do things** - Ruby is flexible
- **Readability matters** - Code should read like English

### Do Focus On:
- **Writing Ruby idiomatically** - Learn "The Ruby Way"
- **Reading Rails source code** - Even if not using Rails
- **Community conventions** - Follow Ruby style guide
- **Gems ecosystem** - Don't reinvent the wheel
- **Testing culture** - Ruby emphasizes TDD

### Don't Worry About:
- **Performance initially** - Ruby prioritizes developer happiness
- **Metaprogramming early** - Use it when you need it
- **Memorizing all methods** - Ruby has many, look them up
- **Rails immediately** - Learn Ruby first, then Rails

## Typical Timeline

**Note**: Timelines vary by effort and background

- **Basics (Phase 1)**: 2-3 weeks of daily practice
- **Ruby Idioms (Phase 2)**: 3-4 weeks
- **OOP Ruby (Phase 3)**: 1-2 months
- **Advanced (Phase 4)**: 2-3 months
- **Rails (if chosen)**: 2-4 months to become productive
- **Specialization (Phase 5)**: Ongoing

## Common Pitfalls to Avoid

1. **Jumping to Rails too early** - Learn Ruby first
2. **Ignoring blocks** - They're fundamental to Ruby
3. **Not using gems** - Ruby has a rich ecosystem
4. **Writing Java/Python in Ruby** - Learn Ruby idioms
5. **Skipping testing** - Ruby culture emphasizes tests
6. **Not reading documentation** - Ruby docs are excellent

## Project Ideas by Level

### Beginner:
- Command-line calculator
- Text-based adventure game
- File renaming tool
- Simple cipher/decoder

### Intermediate:
- Web scraper with Nokogiri
- Todo list with file storage
- CSV data processor
- Command-line tool with Thor

### Advanced:
- Sinatra web application
- API wrapper gem
- Rails blog with authentication
- Chat application with WebSockets

## Ruby vs Rails Distinction

**Important**: Ruby and Rails are different!

- **Ruby** = Programming language
- **Rails** = Web framework built with Ruby

**Learn Ruby first** (Phases 1-3) before Rails. You'll struggle with Rails if you don't understand Ruby fundamentals.

## Testing Culture

Ruby emphasizes testing more than most languages:

1. **Start testing early** (Phase 3 or 4)
2. **TDD is common** - Write tests first
3. **Two main frameworks**: Minitest (simpler) and RSpec (more features)
4. **Many Ruby jobs expect testing knowledge**

## Next Steps

1. Start with Phase 1 - master basics
2. Practice blocks and enumerable methods heavily
3. Read Ruby code daily (GitHub, gems)
4. Build small projects before moving phases
5. Join Ruby communities (Reddit r/ruby, Discord)
6. Consider Rails only after Phase 3

## Ruby Community

- **Very friendly and welcoming**
- **Strong open source culture**
- **RubyConf and RailsConf** - Major conferences
- **Local meetups** - Many cities have Ruby groups
- **RubyGems** - Easy to contribute

## Career Path Note

**Most Ruby jobs are Rails jobs**. If your goal is employment:

1. Learn Ruby fundamentals (Phases 1-3)
2. Learn Rails framework
3. Build portfolio projects with Rails
4. Understand databases and SQL
5. Learn Git and GitHub
6. Study testing (RSpec)

**Remember**: Ruby optimizes for programmer happiness. Enjoy the journey and embrace Ruby's elegant syntax and powerful features!
