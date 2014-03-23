# Puppet module for ARC CE
[![Build Status](https://travis-ci.org/HEP-Puppet/arc_ce.png?branch=master)](https://travis-ci.org/HEP-Puppet/arc_ce)

####Table of Contents

1. [Overview - What is the arc_ce module?](#overview)
2. [Module Description - What does the module do?](#module-description)
3. [Setup - The basics of getting started with arc_ce](#setup)
    * [Beginning with apache - Installation](#beginning-with-arc_ce)
4. [Usage - The classes and defined types available for configuration](#usage)
    * [Classes and Defined Types](#classes-and-defined-types)
        * [Class: arc_ce](#class-arc_ce)
        * [Defined Type: arc_ce::queue](#defined-type-arc_cequeue)
    * Other Examples - Demonstrations of some configuration options](#other-examples)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
    * [Classes](#classes)
        * [Public Classes](#public-classes)
        * [Private Classes](#private-classes)
    * [Defined Types](#defined-types)
        * [Public Defined Types](#public-defined-types)
        * [Private Defined Types](#private-defined-types)
    * [Templates](#templates)
    * [Custom Fixes](#custom-fixes)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Development - Guide for contributing to the module](#development)
    * [Contributing to the arc_ce module](#contributing)
    * [Running tests - A quick guide](#running-tests)
    
    
##Overview
The arc_ce modules allows you to set up a Nordugrid ARC Computing Element (CE) (http://www.nordugrid.org/arc/ce/).

##Module Description

Write something about ARC CE

##Setup
**What arc_ce affects:**

* configuration files and directories (created and written to)
* package/service/configuration files for ARC CE
* lcas, lcmaps package and configuration
* firewall configuration

###Beginning with ARC CE
To install ARC CE with the default parameters

```puppet
    class { 'arc_ce':  }
```

##Usage

###Classes and Defined Types
####Class: `arc_ce`

**Parameters within `arc_ce`:**

#####`apel_testing`

####Defined Type: `arc_ce::queue`

##Reference

###Classes

####Public Classes

### Custom fixes
Custom fixes are described in the fixed.md file.

##Limitations
###General

##Development

###Contributing
###Running tests

This project contains tests for both [rspec-puppet](http://rspec-puppet.com/) and [beaker-rspec](https://github.com/puppetlabs/beaker-rspec) to verify functionality. For in-depth information please see their respective documentation.

Quickstart:

    gem install bundler
    bundle install
    bundle exec rake spec
    bundle exec rspec spec/acceptance
    RS_DEBUG=yes bundle exec rspec spec/acceptance