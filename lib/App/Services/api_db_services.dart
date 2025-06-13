import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Widget/widget.dart';

import '../utils/utils.dart';

//10.147.19.83
// String server = "http://10.147.19.83:80";
// String server = "http://10.242.132.113:80";
String protocol = "http";
String ip = "10.242.132.113"; // Zero "10.242.132.113"; //"localhost";
String port = '881';
var url = '$protocol://$ip:$port/pos/api/values/CMD/1';

//http://26.226.13.72:881/pos/api/values/CMD/1
//http://26.226.13.72:881/pos/api/values/CMD/1
class Services {
  Future<List<dynamic>> createRep({
    required String sqlStatment,
    // Function(String error)? errorCallback,
  }) async {
    var sql = {"CMD": sqlStatment};
    // print(url);
    // print(sql);
    // print(dotenv.env['URL']!);
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

  //Car project Api
  /*
  //goldensoft.dyndns.biz
  var url = server + '/car/api/values/CMD/1';
  // Future<Either<String,List<dynamic>>>
  Future<List<dynamic>> readData(String SqlStatment) async {
    String error = "";
    try {
      var sql = {"CMD": SqlStatment};
      final response = await http.post(Uri.parse(url), headers: {"Content-Type": "application/json"}, body: jsonEncode(sql)).timeout(Duration(seconds: 20));
      try {
        final jsonResponse = json.decode(response.body);
        return jsonResponse;
      } catch (e) {
        error = response.body;
        print("+++++++++++++++++++++++++++++++++++++++++++++");
        print(error);
        print("+++++++++++++++++++++++++++++++++++++++++++++");
        return ['$error'];
      }
      // print(response.body);
    } catch (e) {
      print("==============================================");
      print(e);
      print("==============================================");

      return ['-1'];
    }
  }

  var urlimg = server + '/car/api/values/IMG/1';
  // var urlimg = 'http://192.168.192.83:54119/api/values/IMG/1';
  var urlsingleimg = server + '/car/api/values/POSTIMG/1';
  Future postSingleIMG(String name, String base64) async {
    try {
      var sql = {"IMG": name, "base64": base64};
      final response = await http.post(Uri.parse(urlsingleimg), headers: {"Content-Type": "application/json"}, body: jsonEncode(sql));
      final jsonResponse = json.decode(response.body);
      // print(response.body);
      return jsonResponse;
    } catch (e) {
      print("================================================");
      print(e);
      print("================================================");
      return ['-1'];
    }
  }

  var urlADSimg = server + '/car/api/values/ADS/1';
  Future getSlideIMG() async {
    try {
      var sql = {};
      final response = await http.post(Uri.parse(urlADSimg), headers: {"Content-Type": "application/json"}, body: jsonEncode(sql));
      final jsonResponse = json.decode(response.body);
      // print(response.body);
      return jsonResponse;
    } catch (e) {
      print("================================================");
      print(e);
      print("================================================");
      return ['-1'];
    }
  }

  var urlimgname = server + '/car/api/values/GETIMG/1';
  Future GetImgByName(String ImageName) async {
    try {
      var sql = {"IMGname": ImageName};
      final response = await http.post(Uri.parse(urlimgname), headers: {"Content-Type": "application/json"}, body: jsonEncode(sql));
      final jsonResponse = json.decode(response.body);
      // print(response.body);
      return jsonResponse;
    } catch (e) {
      print("================================================");
      print(e);
      print("================================================");
      return ['-1'];
    }
  }

  // var urlCar = 'http://10.147.19.83:80/CAR/api/values/CAR/1';
  var urlCar = server + '/car/api/values/CAR/1';
  Future GetCarSingleIMage(String SqlStatment) async {
    String error = "";
    try {
      var sql = {"CMD": SqlStatment};
      final response = await http.post(Uri.parse(urlCar), headers: {"Content-Type": "application/json"}, body: jsonEncode(sql)).timeout(Duration(seconds: 10));
      try {
        final jsonResponse = json.decode(response.body);
        return jsonResponse;
      } catch (e) {
        error = response.body;
        print("+++++++++++++++++++++++++++++++++++++++++++++");
        print(error);
        print("+++++++++++++++++++++++++++++++++++++++++++++");
        return ['$error'];
      }
      // print(response.body);
    } catch (e) {
      print("==============================================");
      print(e);
      print("==============================================");

      return ['-1'];
    }
  }

*/
}
