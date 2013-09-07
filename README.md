libro
=====

JavaScript Helper Library

Libro is a different kind of library for JavaScript helpers. Not every one of these helpers will (or should) be used in the same application or environment. Some are specifically for Node.js or the browser. Most however can be used across standard JavaScript environments and carry no other dependencies making them very modular. You can make these functions yourself, but I hate rewriting things.

Modules in the browser are prefixed with "CA" to avoid naming conflicts and there is no global namespace pollution in any of these modules. Not all of these functions have been tested in production, so don't not jump to the conclusion that any error is automatically your fault. Please patch and fork with me.

All of these modules are written in CoffeeScript. The JavaScript is not the prettest, but it is compiled and included in the `lib/` directory. These library, I believe, can also be a learning resource. I have made many comments pretaining to the goals of a certain module or its functions. I was certainly good practic ofr me anyways.

I plan to keep expanding this library as I find more and more small modules not worthy of their own package or repositiory, yet important enough to make into a module for the sake of code reuse. 
