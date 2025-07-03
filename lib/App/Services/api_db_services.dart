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

class Services {
  Future<List<dynamic>> createRep({
    required String sqlStatment,
    // Function(String error)? errorCallback,
  }) async {
    var url = '$protocol://$ip:$port/pos/api/values/CMD/1';
    var sql = {"CMD": sqlStatment};

    final response = await http.post(Uri.parse(url), body: sql); //.timeout(Duration(seconds: 20));
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
