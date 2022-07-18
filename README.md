# anni_mpris_service

D-Bus MPRIS controls for Linux.

## Example

```dart
class MyMPRISService extends MPRISService {
  MyMPRISService()
      : super(
          "identifier_string",
          identity: "Application Name",
          emitSeekedSignal: true,
          canPlay: true,
          canPause: true,
          canGoPrevious: true,
          canGoNext: true,
          canSeek: true,
          supportLoopStatus: true,
          supportShuffle: true,
        );

  @override
  Future<void> onPlayPause() async {
    print("onPlayPause");
  }

  @override
  Future<void> onPlay() async {
    print("onPlay");
    await player.play();
  }

  @override
  Future<void> onPause() async {
    print("onPause");
  }

  @override
  Future<void> onPrevious() async {
    print("onPrevious");
  }

  @override
  Future<void> onNext() async {
    print("onNext");
  }

  @override
  Future<void> onSeek(int offset) async {
    print("onSeek");
  }

  @override
  Future<void> onSetPosition(String trackId, int position) async {
    print("onSetPosition");
  }

  @override
  Future<void> onLoopStatus(LoopStatus loopStatus) async {
    print("onLoopStatus");
    this.loopStatus = loopStatus;
  }

  @override
  Future<void> onShuffle(bool shuffle) async {
    print("onShuffle");
    this.shuffle = shuffle;
  }
}
```

## License

Licensed under either of

- Apache License, Version 2.0 ([LICENSE-APACHE](LICENSE) or <https://www.apache.org/licenses/LICENSE-2.0>)
- MIT license ([LICENSE-MIT](LICENSE-MIT) or <https://opensource.org/licenses/MIT>)

at your option.
