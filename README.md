# polymlb-mlton-sml-lib

This library provides an alternative `$(SML_LIB)` for [PolyMLB](https://github.com/vqns/polymlb/)
that includes many libraries from the [MLton Basis](http://mlton.org/MLBasisAvailableLibraries).
Ideally, PolyMLB would be able to load MLton libraries directly using their MLB files and this
library would not need to exist.
Currently, this is not possible because many MLB files are generated from CM files and use
[Basis fragments](http://mlton.org/MLBasisAvailableLibraries#_basis_fragments) which are not
supported by PolyMLB.
The libraries are copied from MLton with minimal changes.


## Usage

To use this library, set the MLB path variable `SML_LIB` to this directory.
For example, on the command line:
```
polymlb -mlb-path-var "SML_LIB <path/to/this/directory>" ...
```


## Common libraries

For following MLB files are provided by both MLton and PolyMLB:
  - `$(SML_LIB)/basis/basis.mlb` for the Basis Library.
  - `$(SML_LIB)/basis/sml-nj.mlb` for the structure `SMLofNJ`.


## Poly/ML-specific libraries

The following PolyMLB-specific MLB files are provided:
  - `$(SML_LIB)/basis/polyml.mlb` for the structure `PolyML`.
  - `$(SML_LIB)/basis/thread.mlb` for the structure `Thread`.
  - `$(SML_LIB)/basis/universal.mlb` for the structure `Universal`.
  - `$(SML_LIB)/basis/weak.mlb` for the structure `Weak`.
  - `$(SML_LIB)/basis/foreign.mlb` for the structure `Foreign`.
  - `$(SML_LIB)/basis/runcall.mlb` for the structure `RunCall`.


## Reusing MLB files

To enable the same MLB files to be used with both MLton and Poly/ML, it is useful to put
compiler-specific code in a subdirectory called `mlton` or `polyml` and refer to
this directory as `$(COMPILER)` in the MLB file.
The MLB path variable `COMPILER` is then set according to the compiler that is used.

In the case that an MLB file would contain either
`$(SML_LIB)/basis/mlton.mlb` for MLton builds or
`$(SML_LIB)/basis/polyml.mlb` for PolyMLB builds,
a single MLB file can work in both cases by using
`$(SML_LIB)/basis/$(COMPILER).mlb`.

