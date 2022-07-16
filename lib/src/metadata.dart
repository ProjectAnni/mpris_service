import 'package:dbus/dbus.dart';

/// https://www.freedesktop.org/wiki/Specifications/mpris-spec/metadata/
class Metadata {
  Metadata({
    required this.trackId,
    required this.trackTitle,
    this.trackLength,
    this.trackArtist,
    this.lyrics,
    this.artUrl,
    this.albumName,
    this.albumArtist,
    this.discNumber,
    this.trackNumber,
  });

  /// mpris:trackid
  ///
  /// D-Bus path: A unique identity for this track within the context of an MPRIS object (eg: tracklist).
  final String trackId;

  /// xesam:title
  ///
  /// String: The track title.
  final String trackTitle;

  /// mpris:length
  ///
  /// 64-bit integer: The duration of the track in microseconds.
  final Duration? trackLength;

  /// xesam:artist
  ///
  /// List of Strings: The track artist(s).
  final List<String>? trackArtist;

  /// xesam:asText
  ///
  /// String: The track lyrics.
  final String? lyrics;

  /// mpris:artUrl
  ///
  /// URI: The location of an image representing the track or album. Clients should not assume this will continue to exist when the media player stops giving out the URL.
  final String? artUrl;

  /// xesam:album
  ///
  /// String: The album name.
  final String? albumName;

  /// xesam:albumArtist
  ///
  /// List of Strings: The album artist(s).
  final List<String>? albumArtist;

  /// xesam:discNumber
  ///
  /// Integer: The disc number on the album that this track is from.
  final int? discNumber;

  /// xesam:trackNumber
  ///
  /// Integer: The track number on the album disc.
  final int? trackNumber;

  // xesam:audioBPM
  // Integer: The speed of the music, in beats per minute.
  //
  // xesam:autoRating
  // Float: An automatically-generated rating, based on things such as how often it has been played. This should be in the range 0.0 to 1.0.
  //
  // xesam:comment
  // List of Strings: A (list of) freeform comment(s).
  //
  // xesam:composer
  // List of Strings: The composer(s) of the track.
  //
  // xesam:contentCreated
  // Date/Time: When the track was created. Usually only the year component will be useful.
  //
  // xesam:firstUsed
  // Date/Time: When the track was first played.
  //
  // xesam:genre
  // List of Strings: The genre(s) of the track.
  //
  // xesam:lastUsed
  // Date/Time: When the track was last played.
  //
  // xesam:lyricist
  // List of Strings: The lyricist(s) of the track.
  //
  // xesam:url
  // URI: The location of the media file.
  //
  // xesam:useCount
  // Integer: The number of times the track has been played.
  //
  // xesam:userRating
  // Float: A user-specified rating. This should be in the range 0.0 to 1.0.

  DBusValue toValue() {
    final result = DBusDict.stringVariant({
      "mpris:trackid": DBusObjectPath(trackId),
      "xesam:title": DBusString(trackTitle),
      if (trackLength != null)
        "mpris:length": DBusInt64(trackLength!.inMicroseconds),
      if (trackArtist != null) "xesam:artist": DBusArray.string(trackArtist!),
      if (lyrics != null) "xesam:asText": DBusString(lyrics!),
      if (artUrl != null) "xesam:artUrl": DBusString(artUrl!),
      if (albumName != null) "xesam:album": DBusString(albumName!),
      if (albumArtist != null)
        "xesam:albumArtist": DBusArray.string(albumArtist!),
      if (discNumber != null) "xesam:discNumber": DBusInt64(discNumber!),
      if (trackNumber != null) "xesam:trackNumber": DBusInt64(trackNumber!),
    });
    return result;
  }

  Metadata copyWith({
    String? trackId,
    String? trackTitle,
    Duration? trackLength,
    List<String>? trackArtist,
    String? lyrics,
    String? artUrl,
    String? albumName,
    List<String>? albumArtist,
    int? discNumber,
    int? trackNumber,
  }) {
    return Metadata(
      trackId: trackId ?? this.trackId,
      trackTitle: trackTitle ?? this.trackTitle,
      trackLength: trackLength ?? this.trackLength,
      trackArtist: trackArtist ?? this.trackArtist,
      lyrics: lyrics ?? this.lyrics,
      artUrl: artUrl ?? this.artUrl,
      albumName: albumName ?? this.albumName,
      albumArtist: albumArtist ?? this.albumArtist,
      discNumber: discNumber ?? this.discNumber,
      trackNumber: trackNumber ?? this.trackNumber,
    );
  }
}
