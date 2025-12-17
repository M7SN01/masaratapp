// import 'dart:io';
import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
// import 'package:zerotier_sockets/zerotier_sockets.dart';
import 'dart:convert';
import '../Widget/widget.dart';
import '../utils/utils.dart';

String? protocol; // = "http";
String? ip; // = "192.168.195.83"; //"10.242.132.113"; //192.168.192.200 MASARAT IP
String? port; // = '881';

//http://26.226.13.72:881/pos/api/values/CMD/1
//http://26.226.13.72:881/pos/api/values/CMD/1

/*
 headers: {
        'Content-Type': 'application/json',
        'CF-Access-Client-Id': '15208f41704a4bb4ac01f8f57d5b3362.access',
        'CF-Access-Client-Secret': '4bc166f99090e11e469f77a09e3cfe4c2df14f3100028bdc058a2a68274b533e',
      },
*/

class Services {
  Future<List<dynamic>> createRep({
    required String sqlStatment,
    int timeOutSeconds = 20,
    // Function(String error)? errorCallback,
  }) async {
    // var url = '$protocol://$ip:$port/pos/api/values/CMD/1';
    var url = 'https://mapi.m7sn.org/pos/api/values/CMD/1';

    var sql = {"CMD": sqlStatment};

    final response = await http.post(
      Uri.parse(url),
      body: sql,
      headers: {
        // 'Content-Type': 'application/json',
        'CF-Access-Client-Id': 'f3a5373bc6f00987dedd44a923b4df61.access',
        'CF-Access-Client-Secret': '68c84d0f95de61a5197e0b739b70c09617069a264178affef1dc8e6da72364db',
      },
    ).timeout(Duration(seconds: timeOutSeconds));
    if (response.statusCode == 200) {
      try {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse is List) {
          return jsonResponse;
        } else {
          return [jsonResponse];
        }
      } catch (e) {
        String exceptionMessage = "";
        int startIdx = response.body.toString().indexOf('"ExceptionMessage":"');
        if (startIdx != -1) {
          startIdx += '"ExceptionMessage":"'.length;

          int endIdx = response.body.toString().indexOf('","ExceptionType"', startIdx);
          if (endIdx != -1) {
            exceptionMessage = response.body.toString().substring(startIdx, endIdx);
          }
          showMessage(color: secondaryColor, titleMsg: exceptionMessage, titleFontSize: 18, durationMilliseconds: 4000);
        }
        showMessage(color: secondaryColor, titleMsg: response.body, titleFontSize: 18, durationMilliseconds: 4000);

        // errorCallback!(exceptionMessage);

        return [response.body];
      }
    } else {
      showMessage(color: secondaryColor, titleMsg: response.statusCode.toString(), msg: "فشل الإتصال بالسيرفر   \n ${response.body}", titleFontSize: 18, durationMilliseconds: 4000);
      // errorCallback!("${response.body} فشل الإتصال بالسيرفر");
      return [response.body];
    }
  }
}
