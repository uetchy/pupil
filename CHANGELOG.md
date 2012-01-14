0.2.0
----------------

* Fixed bug what :include(and :exclude) parameter had not worked.
* New form are supported.<br/>
  Classic form:<br/>
	`pupil = Pupil.new(…)`<br/>
    `pupil.destroy(status_id) #=> Delete tweet`<br/>
  New one:<br/>
	`status = timeline.first`<br/>
	`status.destroy`
* Mutable scheme are supported. When Twitter REST API is changed, Schemes correspond to it automatically.
* New ways to distinguish screen_name from user_id.
  If methods catch parameter of number, recognize it as screen_name.
* Almost Lists API are supported.

0.1.5
----------------

* Pupil::Stream Error handling(Pupil::Stream::StreamError) are rejected.


0.1.4
----------------

* Rename Search stream method, :filter to :search
* Search REST API are supported
* Pupil::Stream::Shash is outdated. Instead, use Pupil::Stream::Hash
* New class, Pupil::Stream::Array
* Pupil#public_timeline are supported

0.1.3
----------------

* Fixed a bug that Pupil::Stream::Status has not user variable

0.1.2
----------------

* Added new classes,
Pupil::Stream::Status and Pupil::Stream::Shash
* Pupil::Stream#start returned only Pupil::Stream::Status or Pupil::Stream::Shash
* They have "event" variable that show type of event uniformly

0.1.1
----------------

* First release