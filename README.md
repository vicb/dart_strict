## `dart_strict`

With reference to
[*Analysis engine ‘strict’ mode - a proposal*](https://docs.google.com/a/myitcv.org.uk/document/d/14CPEUzLmF__q3SDZX7H4w4Z_YV6Jeyzu_gdU3k9BOpc/edit)

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
[1:1] Missing a return type for function 'blah1'
[1:7] Parameter 'a' is missing a type annotation
[10:7] Variable 'a' cannot use dynamic as a type annotation
[11:7] Variable 'b' cannot use dynamic as a type annotation
$ echo $?
1
```

### TODO

* Clean up code
* Complete implementation of SE1 (relaxed version)
* Implement SE2 and SE3
* Integrate with Dart Analysis Engine ([see this
  thread](https://groups.google.com/a/dartlang.org/forum/#!topic/misc/b65ah3sVqiM)) which may mean this is no longer a
standalone process
