import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'package:wiwmedia_wiwsport_v3/model/youtube/channel_info.dart';
import 'package:wiwmedia_wiwsport_v3/model/youtube/videos_list.dart';
import 'package:wiwmedia_wiwsport_v3/reusable/code_api.dart';

class Youtube_Service {
  static const CHANNEL_ID = 'UCHn5YpOue63hcWMtICpYnKA';
  static const _baseUrl = 'www.googleapis.com';
  static Future<ChannelInfo> getChannelInfo() async {
    Map<String, String> parameters = {
      'part': 'snippet,contentDetails,statistics',
      'id': CHANNEL_ID,
      'key': Constants.KEY_YT,
    };
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/channels',
      parameters,
    );
    Response response = await http.get(uri, headers: headers);
    // print(response.body);
    ChannelInfo channelInfo = channelInfoFromJson(response.body);
    return channelInfo;
  }

  static Future<VideosList> getVideosList(
      {String playListId, String pageToken}) async {
    Map<String, String> parameters = {
      'part': 'snippet',
      'playlistId': playListId,
      'maxResults': '200',
      "resultsPerPage": "100",
      'pageToken': pageToken,
      'key': Constants.KEY_YT,
    };
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/playlistItems',
      parameters,
    );
    Response response = await http.get(uri, headers: headers);
    // print(response.body);
    VideosList videosList = videosListFromJson(response.body);
    return videosList;
  }
}