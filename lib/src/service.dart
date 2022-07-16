import 'package:dbus/dbus.dart';
import 'package:mpris_service/mpris_service.dart';

enum PlaybackStatus {
  playing,
  paused,
  stopped,
}

extension PlaybackStatusToString on PlaybackStatus {
  String toStatusString() {
    return {
      PlaybackStatus.playing: "Playing",
      PlaybackStatus.paused: "Paused",
      PlaybackStatus.stopped: "Stopped",
    }[this]!;
  }
}

class MPRISService extends DBusObject {
  MPRISService(
    String name, {
    required this.identity,
    bool canRaise = false,
    bool canQuit = false,
    this.desktopEntry,
    this.supportedUriSchemes = const [],
    this.supportedMimeTypes = const [],
    this.canControl = true,
    bool canPlay = true,
    bool canPause = true,
    bool canGoPrevious = true,
    bool canGoNext = true,
    bool canSeek = false,
  })  : _canRaise = canRaise,
        _canQuit = canQuit,
        _canPlay = canPlay,
        _canPause = canPause,
        _canGoPrevious = canGoPrevious,
        _canGoNext = canGoNext,
        _canSeek = canSeek,
        super(const DBusObjectPath.unchecked('/org/mpris/MediaPlayer2')) {
    final client = DBusClient.session();
    client.registerObject(this);
    client.requestName(
      "org.mpris.MediaPlayer2.$name",
      flags: {DBusRequestNameFlag.doNotQueue},
    );
  }

  Future<void> dispose() async {
    await client?.close();
  }

  ////////////////////////// Root //////////////////////////
  final String identity;

  final String? desktopEntry;
  final List<String> supportedUriSchemes;
  final List<String> supportedMimeTypes;

  bool _canRaise;
  set canRaise(bool canRaise) {
    emitPropertiesChanged(
      "org.mpris.MediaPlayer2",
      changedProperties: {
        "CanRaise": DBusBoolean(canRaise),
      },
    );
    _canRaise = canRaise;
  }

  Future<void> onRaise() async {}

  bool _canQuit;
  set canQuit(bool canQuit) {
    emitPropertiesChanged(
      "org.mpris.MediaPlayer2",
      changedProperties: {
        "CanQuit": DBusBoolean(canQuit),
      },
    );
    _canQuit = canQuit;
  }

  Future<void> onQuit() async {}

  ////////////////////////// Player //////////////////////////
  ///
  /// Whether the media player may be controlled over this interface.
  /// This property is not expected to change, as it describes an intrinsic capability of the implementation.
  /// If this is false, clients should assume that all properties on this interface are read-only (and will raise errors if writing to them is attempted), no methods are implemented and all other properties starting with "Can" are also false.
  final bool canControl;

  bool _canGoPrevious;
  set canGoPrevious(bool canGoPrevious) {
    emitPropertiesChanged(
      "org.mpris.MediaPlayer2.Player",
      changedProperties: {
        "CanGoPrevious": DBusBoolean(canGoPrevious),
      },
    );
    _canGoPrevious = canGoPrevious;
  }

  Future<void> doPrevious() async {}

  bool _canGoNext;
  set canGoNext(bool canGoNext) {
    emitPropertiesChanged(
      "org.mpris.MediaPlayer2.Player",
      changedProperties: {
        "CanGoNext": DBusBoolean(canGoNext),
      },
    );
    _canGoNext = canGoNext;
  }

  Future<void> doNext() async {}

  bool _canPlay;
  set canPlay(bool canPlay) {
    emitPropertiesChanged(
      "org.mpris.MediaPlayer2.Player",
      changedProperties: {
        "CanPlay": DBusBoolean(canPlay),
      },
    );
    _canPlay = canPlay;
  }

  Future<void> doPlay() async {}

  bool _canPause;
  set canPause(bool canPause) {
    emitPropertiesChanged(
      "org.mpris.MediaPlayer2.Player",
      changedProperties: {
        "CanPause": DBusBoolean(canPause),
      },
    );
    _canPause = canPause;
  }

  Future<void> doPause() async {}

  Future<void> doPlayPause() async {}

  bool _canSeek;
  set canSeek(bool canSeek) {
    emitPropertiesChanged(
      "org.mpris.MediaPlayer2.Player",
      changedProperties: {
        "CanSeek": DBusBoolean(canSeek),
      },
    );
    _canSeek = canSeek;
  }

  Future<void> doSeek(int offset) async {}

  Future<void> doStop() async {}
  Future<void> doSetPosition(String trackId, int position) async {}
  Future<void> doOpenUri(String uri) async {}

  PlaybackStatus _playingStatus = PlaybackStatus.stopped;
  set playingStatus(PlaybackStatus playingStatus) {
    emitPropertiesChanged(
      "org.mpris.MediaPlayer2.Player",
      changedProperties: {
        "PlaybackStatus": DBusString(playingStatus.toStatusString()),
      },
    );
    _playingStatus = playingStatus;
  }

  Metadata _metadata = Metadata(
    trackId: "/org/mpris/MediaPlayer2/TrackList/NoTrack",
    trackTitle: "No title",
  );
  set metadata(Metadata metadata) {
    emitPropertiesChanged(
      "org.mpris.MediaPlayer2.Player",
      changedProperties: {
        "Metadata": metadata.toValue(),
      },
    );
    _metadata = metadata;
  }

  Duration position = Duration.zero;

  @override
  List<DBusIntrospectInterface> introspect() {
    return [
      DBusIntrospectInterface('org.mpris.MediaPlayer2', methods: [
        DBusIntrospectMethod('Raise'),
        DBusIntrospectMethod('Quit')
      ], properties: [
        DBusIntrospectProperty('CanQuit', DBusSignature('b'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('Fullscreen', DBusSignature('b'),
            access: DBusPropertyAccess.readwrite),
        DBusIntrospectProperty('CanSetFullscreen', DBusSignature('b'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('CanRaise', DBusSignature('b'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('HasTrackList', DBusSignature('b'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('Identity', DBusSignature('s'),
            access: DBusPropertyAccess.read),
        if (desktopEntry != null)
          DBusIntrospectProperty('DesktopEntry', DBusSignature('s'),
              access: DBusPropertyAccess.read),
        DBusIntrospectProperty('SupportedUriSchemes', DBusSignature('as'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('SupportedMimeTypes', DBusSignature('as'),
            access: DBusPropertyAccess.read)
      ]),
      DBusIntrospectInterface('org.mpris.MediaPlayer2.Player', methods: [
        DBusIntrospectMethod('Next'),
        DBusIntrospectMethod('Previous'),
        DBusIntrospectMethod('Pause'),
        DBusIntrospectMethod('PlayPause'),
        DBusIntrospectMethod('Stop'),
        DBusIntrospectMethod('Play'),
        DBusIntrospectMethod('Seek', args: [
          DBusIntrospectArgument(DBusSignature('x'), DBusArgumentDirection.in_,
              name: 'Offset')
        ]),
        DBusIntrospectMethod('SetPosition', args: [
          DBusIntrospectArgument(DBusSignature('o'), DBusArgumentDirection.in_,
              name: 'TrackId'),
          DBusIntrospectArgument(DBusSignature('x'), DBusArgumentDirection.in_,
              name: 'Position')
        ]),
        DBusIntrospectMethod('OpenUri', args: [
          DBusIntrospectArgument(DBusSignature('s'), DBusArgumentDirection.in_,
              name: 'Uri')
        ])
      ], signals: [
        DBusIntrospectSignal('Seeked', args: [
          DBusIntrospectArgument(DBusSignature('x'), DBusArgumentDirection.out,
              name: 'Position')
        ])
      ], properties: [
        DBusIntrospectProperty('PlaybackStatus', DBusSignature('s'),
            access: DBusPropertyAccess.read),
        // DBusIntrospectProperty('LoopStatus', DBusSignature('s'),
        //     access: DBusPropertyAccess.readwrite),
        DBusIntrospectProperty('Rate', DBusSignature('d'),
            access: DBusPropertyAccess.readwrite),
        // DBusIntrospectProperty('Shuffle', DBusSignature('b'),
        //     access: DBusPropertyAccess.readwrite),
        DBusIntrospectProperty('Metadata', DBusSignature('a{sv}'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('Volume', DBusSignature('d'),
            access: DBusPropertyAccess.readwrite),
        DBusIntrospectProperty('Position', DBusSignature('x'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('MinimumRate', DBusSignature('d'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('MaximumRate', DBusSignature('d'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('CanGoNext', DBusSignature('b'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('CanGoPrevious', DBusSignature('b'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('CanPlay', DBusSignature('b'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('CanPause', DBusSignature('b'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('CanSeek', DBusSignature('b'),
            access: DBusPropertyAccess.read),
        DBusIntrospectProperty('CanControl', DBusSignature('b'),
            access: DBusPropertyAccess.read)
      ])
    ];
  }

  @override
  Future<DBusMethodResponse> handleMethodCall(DBusMethodCall methodCall) async {
    // print({"handleMethodCall", methodCall.interface, methodCall.name});
    if (methodCall.interface == 'org.mpris.MediaPlayer2') {
      if (methodCall.name == 'Raise') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        await onRaise();
        return DBusMethodSuccessResponse();
      } else if (methodCall.name == 'Quit') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        await onQuit();
        return DBusMethodSuccessResponse();
      } else {
        return DBusMethodErrorResponse.unknownMethod();
      }
    } else if (methodCall.interface == 'org.mpris.MediaPlayer2.Player') {
      if (methodCall.name == 'Next') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        await doNext();
        return DBusMethodSuccessResponse();
      } else if (methodCall.name == 'Previous') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        await doPrevious();
        return DBusMethodSuccessResponse();
      } else if (methodCall.name == 'Pause') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        await doPause();
        return DBusMethodSuccessResponse();
      } else if (methodCall.name == 'PlayPause') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        await doPlayPause();
        return DBusMethodSuccessResponse();
      } else if (methodCall.name == 'Stop') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        await doStop();
        return DBusMethodSuccessResponse();
      } else if (methodCall.name == 'Play') {
        if (methodCall.values.isNotEmpty) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        await doPlay();
        return DBusMethodSuccessResponse();
      } else if (methodCall.name == 'Seek') {
        if (methodCall.signature != DBusSignature('x')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        await doSeek(methodCall.values[0].asInt64());
        return DBusMethodSuccessResponse();
      } else if (methodCall.name == 'SetPosition') {
        if (methodCall.signature != DBusSignature('ox')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        await doSetPosition(methodCall.values[0].asObjectPath().asString(),
            methodCall.values[1].asInt64());
        return DBusMethodSuccessResponse();
      } else if (methodCall.name == 'OpenUri') {
        if (methodCall.signature != DBusSignature('s')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        await doOpenUri(methodCall.values[0].asString());
        return DBusMethodSuccessResponse();
      } else {
        return DBusMethodErrorResponse.unknownMethod();
      }
    }
    return DBusMethodErrorResponse.unknownInterface();
  }

  @override
  Future<DBusMethodResponse> getProperty(String interface, String name) async {
    // print({"getProperty", interface, name});
    if (interface == 'org.mpris.MediaPlayer2') {
      if (name == 'CanQuit') {
        return DBusMethodSuccessResponse([DBusBoolean(_canQuit)]);
      } else if (name == 'Fullscreen') {
        return DBusMethodSuccessResponse([const DBusBoolean(false)]);
      } else if (name == 'CanSetFullscreen') {
        // TODO: support fullscreen
        return DBusMethodSuccessResponse([const DBusBoolean(false)]);
      } else if (name == 'CanRaise') {
        return DBusMethodSuccessResponse([DBusBoolean(_canRaise)]);
      } else if (name == 'HasTrackList') {
        // TODO: support tracklist
        return DBusMethodSuccessResponse([const DBusBoolean(false)]);
      } else if (name == 'Identity') {
        return DBusMethodSuccessResponse([DBusString(identity)]);
      } else if (name == 'DesktopEntry') {
        if (desktopEntry != null) {
          return DBusMethodSuccessResponse([DBusString(desktopEntry!)]);
        } else {
          return DBusMethodErrorResponse.unknownProperty();
        }
      } else if (name == 'SupportedUriSchemes') {
        return DBusMethodSuccessResponse(
            [DBusArray.string(supportedUriSchemes)]);
      } else if (name == 'SupportedMimeTypes') {
        return DBusMethodSuccessResponse(
            [DBusArray.string(supportedMimeTypes)]);
      } else {
        return DBusMethodErrorResponse.unknownProperty();
      }
    } else if (interface == 'org.mpris.MediaPlayer2.Player') {
      if (name == 'PlaybackStatus') {
        return DBusMethodSuccessResponse(
            [DBusString(_playingStatus.toStatusString())]);
        // } else if (name == 'LoopStatus') {
        //   return DBusMethodSuccessResponse([const DBusString("Track")]);
      } else if (name == 'Rate') {
        return DBusMethodSuccessResponse([const DBusDouble(1)]);
        // } else if (name == 'Shuffle') {
        //   return DBusMethodSuccessResponse([const DBusBoolean(false)]);
      } else if (name == 'Metadata') {
        return DBusMethodSuccessResponse([_metadata.toValue()]);
      } else if (name == 'Volume') {
        return DBusMethodSuccessResponse([const DBusDouble(1)]);
      } else if (name == 'Position') {
        return DBusMethodSuccessResponse([DBusInt64(position.inMicroseconds)]);
      } else if (name == 'MinimumRate') {
        return DBusMethodSuccessResponse([const DBusDouble(1)]);
      } else if (name == 'MaximumRate') {
        return DBusMethodSuccessResponse([const DBusDouble(1)]);
      } else if (name == 'CanGoNext') {
        return DBusMethodSuccessResponse(
            [DBusBoolean(canControl && _canGoNext)]);
      } else if (name == 'CanGoPrevious') {
        return DBusMethodSuccessResponse(
            [DBusBoolean(canControl && _canGoPrevious)]);
      } else if (name == 'CanPlay') {
        return DBusMethodSuccessResponse([DBusBoolean(canControl && _canPlay)]);
      } else if (name == 'CanPause') {
        return DBusMethodSuccessResponse(
            [DBusBoolean(canControl && _canPause)]);
      } else if (name == 'CanSeek') {
        return DBusMethodSuccessResponse([DBusBoolean(canControl && _canSeek)]);
      } else if (name == 'CanControl') {
        return DBusMethodSuccessResponse([DBusBoolean(canControl)]);
      } else {
        return DBusMethodErrorResponse.unknownProperty();
      }
    } else {
      return DBusMethodErrorResponse.unknownProperty();
    }
  }

  @override
  Future<DBusMethodResponse> setProperty(
      String interface, String name, DBusValue value) async {
    if (interface == 'org.mpris.MediaPlayer2') {
      if (name == 'CanQuit') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'Fullscreen') {
        if (value.signature != DBusSignature('b')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        return DBusMethodErrorResponse.notSupported();
      } else if (name == 'CanSetFullscreen') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'CanRaise') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'HasTrackList') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'Identity') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'DesktopEntry') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'SupportedUriSchemes') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'SupportedMimeTypes') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else {
        return DBusMethodErrorResponse.unknownProperty();
      }
    } else if (interface == 'org.mpris.MediaPlayer2.Player') {
      if (name == 'PlaybackStatus') {
        return DBusMethodErrorResponse.propertyReadOnly();
        // } else if (name == 'LoopStatus') {
        //   if (value.signature != DBusSignature('s')) {
        //     return DBusMethodErrorResponse.invalidArgs();
        //   }
        //   // TODO: support loop
        //   // return setLoopStatus(value.asString());
        //   return DBusMethodErrorResponse.notSupported();
      } else if (name == 'Rate') {
        if (value.signature != DBusSignature('d')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        // TODO: support rate
        return DBusMethodErrorResponse.notSupported();
      } else if (name == 'Shuffle') {
        if (value.signature != DBusSignature('b')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        // TODO: support shuffle
        // return setShuffle(value.asBoolean());
        return DBusMethodErrorResponse.notSupported();
      } else if (name == 'Metadata') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'Volume') {
        if (value.signature != DBusSignature('d')) {
          return DBusMethodErrorResponse.invalidArgs();
        }
        // TODO: support volume
        // return setVolume(value.asDouble());
        return DBusMethodErrorResponse.notSupported();
      } else if (name == 'Position') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'MinimumRate') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'MaximumRate') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'CanGoNext') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'CanGoPrevious') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'CanPlay') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'CanPause') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'CanSeek') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else if (name == 'CanControl') {
        return DBusMethodErrorResponse.propertyReadOnly();
      } else {
        return DBusMethodErrorResponse.unknownProperty();
      }
    } else {
      return DBusMethodErrorResponse.unknownProperty();
    }
  }

  @override
  Future<DBusMethodResponse> getAllProperties(String interface) async {
    // print({"getAllProperties", interface});
    var properties = <String, DBusValue>{};
    if (interface == 'org.mpris.MediaPlayer2') {
      properties['CanQuit'] =
          (await getProperty('org.mpris.MediaPlayer2', 'CanQuit'))
              .returnValues[0];
      properties['Fullscreen'] =
          (await getProperty('org.mpris.MediaPlayer2', 'Fullscreen'))
              .returnValues[0];
      properties['CanSetFullscreen'] =
          (await getProperty('org.mpris.MediaPlayer2', 'CanSetFullscreen'))
              .returnValues[0];
      properties['CanRaise'] =
          (await getProperty('org.mpris.MediaPlayer2', 'CanRaise'))
              .returnValues[0];
      properties['HasTrackList'] =
          (await getProperty('org.mpris.MediaPlayer2', 'HasTrackList'))
              .returnValues[0];
      properties['Identity'] =
          (await getProperty('org.mpris.MediaPlayer2', 'Identity'))
              .returnValues[0];
      if (desktopEntry != null) {
        properties['DesktopEntry'] =
            (await getProperty('org.mpris.MediaPlayer2', 'DesktopEntry'))
                .returnValues[0];
      }
      properties['SupportedUriSchemes'] =
          (await getProperty('org.mpris.MediaPlayer2', 'SupportedUriSchemes'))
              .returnValues[0];
      properties['SupportedMimeTypes'] =
          (await getProperty('org.mpris.MediaPlayer2', 'SupportedMimeTypes'))
              .returnValues[0];
    } else if (interface == 'org.mpris.MediaPlayer2.Player') {
      properties['PlaybackStatus'] =
          (await getProperty('org.mpris.MediaPlayer2.Player', 'PlaybackStatus'))
              .returnValues[0];
      // properties['LoopStatus'] =
      //     (await getProperty('org.mpris.MediaPlayer2.Player', 'LoopStatus'))
      //         .returnValues[0];
      properties['Rate'] =
          (await getProperty('org.mpris.MediaPlayer2.Player', 'Rate'))
              .returnValues[0];
      // properties['Shuffle'] =
      //     (await getProperty('org.mpris.MediaPlayer2.Player', 'Shuffle'))
      //         .returnValues[0];
      properties['Metadata'] =
          (await getProperty('org.mpris.MediaPlayer2.Player', 'Metadata'))
              .returnValues[0];
      properties['Volume'] =
          (await getProperty('org.mpris.MediaPlayer2.Player', 'Volume'))
              .returnValues[0];
      properties['Position'] =
          (await getProperty('org.mpris.MediaPlayer2.Player', 'Position'))
              .returnValues[0];
      properties['MinimumRate'] =
          (await getProperty('org.mpris.MediaPlayer2.Player', 'MinimumRate'))
              .returnValues[0];
      properties['MaximumRate'] =
          (await getProperty('org.mpris.MediaPlayer2.Player', 'MaximumRate'))
              .returnValues[0];
      properties['CanGoNext'] =
          (await getProperty('org.mpris.MediaPlayer2.Player', 'CanGoNext'))
              .returnValues[0];
      properties['CanGoPrevious'] =
          (await getProperty('org.mpris.MediaPlayer2.Player', 'CanGoPrevious'))
              .returnValues[0];
      properties['CanPlay'] =
          (await getProperty('org.mpris.MediaPlayer2.Player', 'CanPlay'))
              .returnValues[0];
      properties['CanPause'] =
          (await getProperty('org.mpris.MediaPlayer2.Player', 'CanPause'))
              .returnValues[0];
      properties['CanSeek'] =
          (await getProperty('org.mpris.MediaPlayer2.Player', 'CanSeek'))
              .returnValues[0];
      properties['CanControl'] =
          (await getProperty('org.mpris.MediaPlayer2.Player', 'CanControl'))
              .returnValues[0];
    }
    return DBusMethodSuccessResponse([DBusDict.stringVariant(properties)]);
  }
}