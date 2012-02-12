# Thread-safe class inheritable attributes

[GitHub repository](https://github.com/Roman2K/class-inheritable-attributes).

## Features

Allows for defining class-level attributes whose values are:

* inherited by subclasses,
* stored in a thread safe manner,
* accessible via calls to `super`,
* stored in a memory efficient manner (the registry shrinks itself on `nil` values).

## Installation

    $ gem install Roman2K-class-inheritable-attributes -s http://gems.github.com/

## Example usage

    require 'class_inheritable_attributes'
    
    class Resource
      class_inheritable_attr_accessor :site, :timeout
    
      def self.timeout
        super || 10
      end
    
      def self.timeout=(seconds)
        super(seconds.to_i)
      end
    end
  
    Resource.timeout  # => 10
    Resource.timeout = "5"
    Resource.timeout  # => 5
  
    class AccountingResource < Resource
      self.site = "http://account.example.com"
    end
  
    class Balance < AccountingResource
    end
  
    # Child's value defaults to parent's
    AccountingResource.site   # => "http://account.example.com"
    Balance.site              # => "http://account.example.com"
  
    # Child can set its own value
    Balance.site = "http://balance.account.example.com"
    AccountingResource.site   # => "http://account.example.com"
    Balance.site              # => "http://balance.account.example.com"
