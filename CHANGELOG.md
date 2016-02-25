Snoopy Cookbook CHANGELOG
=========================

v1.2.0 (2016-02-25)
-------------------
- Expose an attribute that can be overridden to leave Snoopy disabled

v1.1.0 (2015-12-23)
-------------------
- Start testing against Ubuntus 15.10 and 10.04
- Add RHEL and RHEL-alike support

v1.0.2 (2015-10-29)
-------------------
- Fix issue with `compile_time` method name collisions when using the cookbook
  in combination with older versions of Chef Sugar

v1.0.1 (2015-10-22)
-------------------
- Default config attribute to an empty hash instead of nil so overrides can be
  done without worrying about nil reference errors
- Clear up a Chef nil warning by not passing on a source attribute from the
  default recipe unless it's non-nil

v1.0.0 (2015-10-22)
-------------------
- Switch from the year-old base Ubuntu package to a custom-built version
- Add ability to manage the config file that newer versions support
- Fully refactor the resources and providers in preparation for future
  additional platform support

v0.1.0 (2015-09-30)
-------------------
- Initial release; Ubuntu only

v0.0.1 (2015-09-28)
-------------------
- Development started
