## `dart_strict`

### Requirements

Needs the latest [Dart source](https://code.google.com/p/dart/wiki/GettingTheSource) for most recent
core packages

### Usage

* Modify `pubsec.yaml` to alter the paths to point to your clone of the Dart source:
* Take a note of your `/path/to/dart-sdk` - below it is assumed to be `/home/myitcv/darts/dart-sdk`

```bash
$ git clone https://github.com/myitcv/dart_strict.git
$ cd dart_strict
$ dart dart_strict.dart /home/myitcv/darts/dart-sdk _test_files/test1.dart
$ dart dart_strict.dart /home/myitcv/darts/dart-sdk _test_files/test1.dart
[1:1] Missing a return type for function 'blah1'
[1:7] Parameter 'a' is missing a type annotation
[10:7] Variable 'a' cannot use dynamic as a type annotation
[11:7] Variable 'b' cannot use dynamic as a type annotation
$ echo $?
1
```
