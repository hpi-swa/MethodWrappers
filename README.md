# MethodWrappers
Method wrappers from the AspectS project. Compatible with Squeak 5.1 and newer.

This repository replaces the following code locations:
 * `MethodWrappers` package in http://www.hpi.uni-potsdam.de/hirschfeld/squeaksource/SwaUtilities
 * All packages in http://www.squeaksource.com/MethodWrappers

## How to Install

```Smalltalk
Metacello new
  baseline: 'MethodWrappers';
  repository: 'github://hpi-swa/MethodWrappers:master/packages';
  load.
```

## Related Work

 * John Brant, Brian Foote, Ralph E. Johnson, and Donald Roberts. *Wrappers to the Rescue*. In Proceedings of European Conference on Object-Oriented Programming (ECOOP). Springer, Berlin, Heidelberg, 1998.
 * Robert Hirschfeld. *AspectS – Aspect-oriented Programming with Squeak*. In Proceedings of Objects, Components, Architectures, Services, and Applications for a Networked World, Springer LNCS 2591, pages 216-232, Springer, 2003.
 * Squeak-Wiki page on *MethodWrappers* in http://wiki.squeak.org/squeak/1891
 * Squeak-Wiki page on *AspectS* in http://wiki.squeak.org/squeak/5798
 * http://web.archive.org/web/20060101232016/http://www.prakinf.tu-ilmenau.de:80/~hirsch/Projects/Squeak/AspectS/
 * http://web.archive.org/web/20030806074803/http://st-www.cs.uiuc.edu/~brant/Applications/MethodWrappers.html
