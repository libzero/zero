zero - a toolkit for web services
=================================

[![Build Status](https://travis-ci.org/libzero/zero.png)](http://travis-ci.org/libzero/zero)

The focus of this project is to provide small helpers for building web services
without the need of learning a complete new web stack from the bottom to the
top.

As this project is still at the beginning, some things may change or may not be
as good as other parts. But we are working on these parts to make them easier
to use and stable enough.

The following is a small list of things, the project already provides and at the
end you can find a small sample on what is already possible.

parts of the toolkit
--------------------

### Request

A new request implementation is provided to make it easier for accessing all the
various elements of a request. It provides an interface for all access headers
through the method `#access`. It also provides a method `#params`, which returns
an object with parameters seperated between *query* and *payload* parameters.

### Response

A new response is also provided. which is just some lines of code at the moment,
but will grow in functionality. We aim at a response which will take care of all
the http specific stuff itself, to make it easier for you.

### Router

A small router with variables is also provided. It can take static urls, but
also dynamic routes and push them to the appropiate controller. It is very
lightweight and can therefore be used in other projects, where a Rack::Router
is needed but can't do as much and other implementations are just to big.

### Renderer

This part should do the work for you to decide, which template to use. You can
define a template directory and a mapping of simple shortcuts of types to all
types the template should be rendered with. With these two information the
renderer will take care of selecting the correct template, so that you can
concentrate on the hard parts.

### Controller

This is in a very rough state at the moment, but already shows the potential in
which direction this hole project should go. It defines a very simple interface
for your own controllers, in that it only wants `#render` to be implemented, but
also calls `#process` to seperate the processing and rendering. It uses the
Zero tools at the moment, but later should be able to use other libs too.

example
-------

To give you an impression on what these parts can already do for you, you can
take a look at the sample application 
[here](https://github.com/Gibheer/zero-examples) and try it out. It does not
take much.
