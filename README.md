Jumu Nordost for iOS
====================

This is a companion app for participants and audiences of the ["Jugend musiziert"][jugend-musiziert] music competition. It shows all available schedules and programmes for contests held at German schools abroad within the "Nord- und Osteuropa" competition region.

[jugend-musiziert]: https://en.wikipedia.org/wiki/Jugend_musiziert

Tech Specs
----------

The app runs on iOS 9+ and is currently implemented natively using Swift and [ReactiveCocoa 4][reactive-cocoa]. It follows an [MVVM-style][mvvm-sprynthesis] architecture, but uses the term _mediator_ instead of _view model_. This is to emphasize the active, agent-like role of such classes and because, frankly, the name "view model" [isn't very good][mvvm-is-not-very-good].

[reactive-cocoa]: https://github.com/ReactiveCocoa/ReactiveCocoa
[mvvm-sprynthesis]: http://www.sprynthesis.com/2014/12/06/reactivecocoa-mvvm-introduction/
[mvvm-is-not-very-good]: http://khanlou.com/2015/12/mvvm-is-not-very-good/

Features
--------

* [x] List contests
* [x] Browse performances in contest by day and venue
* [x] See performance details, such as participants and pieces

Setup
-----

The project doesn't compile until you have provided a credentials file. Do as follows:

1. Open the file `JumuNordost/Resources/Credentials.plist.example` in your favorite text editor.
1. Fill in the API key as indicated by the placeholder.
1. Important: Save the file __under a new name__: `Credentials.plist`. This filename is ignored by Git to prevent you from checking secrets into version control.
1. Keep the `.example` file around for future reference.
1. The project should now compile :)

Acknowledgements
----------------

This project is kindly sponsored by [Futurice][futurice] as part of their fantastic [open-source program][spice-program]. Kiitos!

All icons in the app are courtesy of [Icons8][icons8].

[futurice]: http://futurice.com/
[spice-program]: http://www.spiceprogram.org/
[icons8]: https://icons8.com/
