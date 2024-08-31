import 'package:logger/logger.dart';
import 'package:miru_app/utils/logger.dart';
import 'package:dio/dio.dart';
import 'package:miru_app/request/api.dart';
import 'package:miru_app/request/request.dart';
import 'package:miru_app/models/bangumi_item.dart';

class BangumiHTTP {
  static Future getCalendar() async {
    List<List<BangumiItem>> bangumiCalendar = [];
    try {
      var res = await Request().get(Api.bangumiCalendar);
      final jsonData = res.data;
      KazumiLogger().log(Level.info, '网络源推荐列表长度 ${jsonData.length}');
      for (dynamic jsonDayList in jsonData) {
        List<BangumiItem> bangumiList = [];
        final jsonList = jsonDayList['items'];
        for (dynamic jsonItem in jsonList) {
          try {
            BangumiItem bangumiItem = BangumiItem.fromJson(jsonItem);
            if (bangumiItem.nameCn != '') {
              bangumiList.add(bangumiItem);
            }
            // bangumiList.add(BangumiItem.fromJson(jsonItem));
          } catch (_) {}
        }
        bangumiCalendar.add(bangumiList);
      }
    } catch (e) {
      KazumiLogger().log(Level.error, '解析推荐列表错误 ${e.toString()}');
      // debugPrint('当前列表长度 ${bangumiCalendar.length}');
    }
    return bangumiCalendar;
  }

  static Future getBangumiList({int rank = 2, String tag = ''}) async {
    List<BangumiItem> bangumiList = [];
    late Map<String, dynamic> params;
    if (tag == '') {
      params = <String, dynamic>{
        'keyword': '',
        'sort': 'rank',
        "filter": {
          "type": [2],
          "tag": ["日本"],
          "rank": [">$rank", "<=1000"],
          "nsfw": false
        },
      };
    } else {
      params = <String, dynamic>{
        'keyword': '',
        'sort': 'rank',
        "filter": {
          "type": [2],
          "tag": [tag],
          "rank": [">${rank * 2}", "<=99999"],
          "nsfw": false
        },
      };
    }
    try {
      final res = await Request().post(Api.bangumiRankSearch,
          data: params, options: Options(contentType: 'application/json'));
      final jsonData = res.data;
      final jsonList = jsonData['data'];
      for (dynamic jsonItem in jsonList) {
        if (jsonItem is Map<String, dynamic>) {
          bangumiList.add(BangumiItem.fromJson(jsonItem));
        }
      }
    } catch (e) {
      KazumiLogger().log(Level.error, '解析推荐列表错误 ${e.toString()}');
      // debugPrint('当前列表长度 ${bangumiList.length}');
    }
    return bangumiList;
  }

  static Future bangumiSearch(String keyword) async {
    List<BangumiItem> bangumiList = [];
    // Bangumi API 文档要求的UA格式
    var httpHeaders = {
      'user-agent':
          'Predidit/Kazumi/${Api.version} (Android) (https://github.com/Predidit/Kazumi)',
      'referer': '',
    };
    // Map<String, String> keywordMap = {
    //   'type': '2',
    //   'responseGroup': 'large',
    //   'max_results': '25'
    // };

    var params = <String, dynamic>{
      'keyword': keyword,
      'sort': 'rank',
      "filter": {
        "type": [2],
        "tag": [],
        "rank": [">0", "<=99999"],
        "nsfw": false
      },
    };

    try {
      // final res = await Request().get(
      //     Api.bangumiSearch + Uri.encodeComponent(keyword),
      //     data: keywordMap,
      //     options: Options(headers: httpHeaders));
      final res = await Request().post(Api.bangumiRankSearch,
          data: params,
          options:
              Options(headers: httpHeaders, contentType: 'application/json'));
      final jsonData = res.data;
      final jsonList = jsonData['data'];
      for (dynamic jsonItem in jsonList) {
        if (jsonItem is Map<String, dynamic>) {
          try {
            BangumiItem bangumiItem = BangumiItem.fromJson(jsonItem);
            if (bangumiItem.nameCn != '') {
              bangumiList.add(bangumiItem);
            }
          } catch (e) {
            KazumiLogger().log(Level.error, '检索结果解析错误 ${e.toString()}');
          }
        }
      }
    } catch (e) {
      KazumiLogger().log(Level.error, '检索错误 ${e.toString()}');
    }
    // debugPrint('检索结果长度 ${bangumiList.length}');
    return bangumiList;
  }
}
