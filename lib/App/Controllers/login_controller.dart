import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// import '../Variable/global_variable.dart';
import '../Views/Home/home.dart';
import '../Services/api_db_services.dart';
import '../Services/sqflite_services.dart';
import '../Widget/widget.dart';
import '../utils/utils.dart';
import 'offline_user_controller.dart';
import 'user_controller.dart';

class LoginController extends GetxController {
  Services dbServices = Services();
  SqlDb sqldb = SqlDb();
  // GlobalVariable globalVariable = GlobalVariable();

  bool autoLogIn = false;
  // bool isLogedOut = false;
  // bool isEnableField = false;
  bool keepmelogin = false;
  bool isLogining = false;

  bool obscurePassword = true;

  TextEditingController userID = TextEditingController();
  TextEditingController password = TextEditingController();

  double screenHeight = Get.mediaQuery.size.height;
  double screenWidth = Get.mediaQuery.size.width;

  double loginCardWidth = 350;
  double loginCardHight = 500;

  String? logedInuserId;
  String? logedInuserName;
  String? logedInPassword;
  String? lastOfflineCopyDate;
  bool isOfflineMode = false;

  @override
  void onInit() async {
    // if (isLogedOut) {
    //   //open login  by log out  remove login data
    //   await removeSqfliteLoginData();

    //   // isEnableField = true;
    // } else {
    //open login Normal >> check local data That is saved befor
    List<Map> data = await sqldb.readData("select * from USER");
    if (data.isNotEmpty) {
      //fill saved data to fileds
      userID.text = data[0]['U_ID'];
      password.text = data[0]['U_P'];

      keepmelogin = data[0]['AUTO_LOGIN'].toString() == '0';
      // GlobalVariable().setUserId = userID.text;
      update();
      if (keepmelogin) {
        await login();
      }
      // isEnableField = false;
    }
    // else {
    //   //no data ? you can write your login data
    //   // isEnableField = true;
    // }
    // }

    super.onInit();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }

  changePasswordVisibility() {
    obscurePassword = !obscurePassword;
    update();
  }

  Future<void> disableAutoLogin() async {
    // debugPrint("delete auto login data");
    // await sqldb.deleteData("DELETE FROM USER");
    await sqldb.updateData("UPDATE USER SET AUTO_LOGIN='0'  ");
    showMessage(titleMsg: " Loged Out Done", color: Colors.greenAccent);
  }

  Future<void> keepLogin() async {
    List<Map> data = await sqldb.readData("select * from USER");
    if (data.isEmpty) {
      //no data saved before
      await sqldb.insertData("INSERT INTO USER(U_ID,U_NAME,U_P) VALUES('$logedInuserId','$logedInuserName','$logedInPassword')");
    } else {
      await sqldb.updateData("UPDATE USER SET U_ID='${userID.text}' ,U_NAME = '$logedInuserName', U_P='$logedInPassword' ");
      // userID.text = data[0]['U_ID'];
      // password.text = data[0]['U_P'];
      // update();
    }
  }

  Future<void> login() async {
    FocusManager.instance.primaryFocus?.unfocus();

    //start loading
    isLogining = true;
    update();

    try {
      //Check if empty fildes
      if (userID.text == "" || password.text == "") {
        showMessage(titleMsg: "All fields are required", durationMilliseconds: 2000);

        isLogining = false;
        //update();
      } else {
        var jsonData;
        if (isOfflineMode) {
          jsonData = await sqldb.readData("Select U_ID,U_NAME,U_P from USER where U_ID='${userID.text}' and U_P='${password.text}'");
        } else {
          jsonData = await dbServices.createRep(
            sqlStatment: "Select U_ID,U_NAME,U_P from USER1 where U_ID='${userID.text}' and U_P='${password.text}'",
            // errorCallback: (error) {
            //   // showMessage(
            //   //   msg: error,
            //   //   durationMilliseconds: 5000,
            //   // );
            // },
          );
        }

        // not logedin
        if (jsonData.isEmpty || jsonData == []) {
          //Stop loading
          isLogining = false;
          showMessage(titleMsg: "Login Error", msg: "userID or Password is not currect !", durationMilliseconds: 2000);
          //update();

          //no internet
        } else if (jsonData[0] == "-1") {
          showMessage(titleMsg: "Login Error", msg: "No internet Access !", durationMilliseconds: 2000);

          isLogining = false;
          //update();

          //loged in and not return error only return the required data (COMP_ID)
        } else if (jsonData.isNotEmpty && jsonData[0]['U_ID'].toString() == userID.text) {
          // GlobalVariable().setUserId = jsonData[0]['U_ID'].toString();
          debugPrint("Loged in user is : ${jsonData[0]['U_ID'].toString()}  -- ${jsonData[0]['U_NAME'].toString()}");
          logedInuserId = jsonData[0]['U_ID'].toString();
          logedInuserName = jsonData[0]['U_NAME'].toString();
          logedInPassword = jsonData[0]['U_P'].toString();

          //if keep me login save data
          if (keepmelogin) {
            // debugPrint("keep me loged in next time");
            await keepLogin();
          }

          UserController userController = Get.put(UserController(), permanent: true);
          if (isOfflineMode) {
            OfflineUserController offlineUserController = Get.put(OfflineUserController());
            offlineUserController.isOfflineMode = isOfflineMode;
            await offlineUserController.getAllOfflineData();
          } else {
            await userController.getAllPrivileges();
          }

          Get.offAll(() => Home());
          //  Get.to(() => Home()); //to find data from any where
          isLogining = false;

          //set the current user of the app

          //Server Error
        } else {
          showMessage(titleMsg: "Login Error !", msg: jsonData[0].toString(), durationMilliseconds: 5000);

          isLogining = false;
          //update();
        }
      }
    } catch (e) {
      // userController.appLog += "${e.toString()} \n------------------------------------------\n";
      showMessage(color: secondaryColor, titleMsg: "posting error !", titleFontSize: 18, msg: e.toString(), durationMilliseconds: 5000);

      isLogining = false;
      //update();
    }

    update();
  }

  Future<void> onLogout() async {
    keepmelogin = false;
    userID.clear();
    password.clear();
    // GlobalVariable().setUserId = "";
    await disableAutoLogin();

    // Remove UserController & LoginController from memory

    if (Get.isRegistered<LoginController>()) Get.delete<LoginController>();
    if (Get.isRegistered<UserController>()) Get.delete<UserController>();

    //close connection to sqflite
    // await sqldb.closeDatabase();
  }

  Future<void> changeOfflineMode() async {
    if (isOfflineMode) {
      isOfflineMode = false;
    } else {
      lastOfflineCopyDate = await getLastSyncDate();
      if (lastOfflineCopyDate != null) {
        isOfflineMode = true;
      }
      // else {
      //   showMessage(color: secondaryColor, titleMsg: "لايوجد بيانات مخزنة مسبقاً !", titleFontSize: 14, durationMilliseconds: 3000);
      // }
    }
    update();
  }

  Future<String?> getLastSyncDate() async {
    var result = await sqldb.readData("SELECT LAST_OFFLINE_SYNC FROM COMP WHERE HAS_OFFLINE_DATA = 1");
    if (result.isEmpty) {
      showMessage(
        color: secondaryColor,
        titleMsg: "لايوجد بيانات مخزنة مسبقاً !", // "No data found in USER Table !",
        titleFontSize: 16,
        msgFontSize: 12,
        durationMilliseconds: 4000,
      );
      return null;
    } else {
      try {
        return DateFormat('yyyy-MM-dd  hh:mm').format(DateTime.parse(result[0]['LAST_OFFLINE_SYNC']));
      } catch (e) {
        showMessage(
          color: secondaryColor,
          titleMsg: "Error while Formatting the last Copy Date",
          titleFontSize: 16,
          msg: e.toString(),
          msgFontSize: 12,
          durationMilliseconds: 4000,
        );
        return null;
      }
    }
  }

  //
}
