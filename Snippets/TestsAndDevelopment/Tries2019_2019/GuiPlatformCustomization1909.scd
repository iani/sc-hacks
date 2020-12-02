//: Different font sizes for linux vs macos
/*
to fit needs of working with i3 on 3000x2000 screen 14" laptop
*/
//: Test if current platform is LinuxPlatform:
thisProcess.platform.class === LinuxPlatform;
//:get name of platform
thisProcess.platform.name;
//:Store defaults for a platform using Registry
Registry(thisProcess.platform.class, \font, { Font("Helvetica", 32)});
//:Work out how to get a default if settings for current platform class not found
/* Implementation notes:
Make access to the defaults as efficient as possible:
- Class variables in a single class.
- Initialize these at startup time depending on platform.
- Variables should be writeable so that they can be changed afterwards
  to experiment with different styles.
*/
