import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import '../Variable/global_variable.dart';
import '../Views/Home/home.dart';
import '../Views/Login/Login_view.dart';
import '../Services/api_db_services.dart';
import '../Services/sqflite_services.dart';
import '../Widget/widget.dart';
import '../utils/utils.dart';
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

  @override
  void onInit() async {
    // if (isLogedOut) {
    //   //open login  by log out  remove login data
    //   await removeSqfliteLoginData();

    //   // isEnableField = true;
    // } else {
    //open login Normal >> check local data That is saved befor
    List<Map> data = await sqldb.readDate("select * from USER");
    if (data.isNotEmpty) {
      //fill saved data to fileds
      userID.text = data[0]['U_ID'];
      password.text = data[0]['PASS'];
      keepmelogin = true;
      // GlobalVariable().setUserId = userID.text;
      update();
      await login();
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

  Future<void> removeSqfliteLoginData() async {
    // print("delete auto login data");
    await sqldb.deleteDate("DELETE FROM USER");
    showMessage(titleMsg: " Loged Out Done", color: Colors.greenAccent);
  }

  /*
  Future<bool> isLogedin() async {
    List<Map> data = await sqldb.readDate(
      "select * from USER",
    );
    if (data.isEmpty) {
      // print("nodata**********************");
      return false;
    } else {
      // print("auto login *********************");

      userID.text = data[0]['U_ID'];

      password.text = data[0]['PASS'];
      keepmelogin = true;
      globalVariable.setUserId = userID.text;
      update();
      return true;
    }
  }
  */

  Future<void> keepLogin() async {
    List<Map> data = await sqldb.readDate("select * from USER");
    if (data.isEmpty) {
      //no data saved before
      await sqldb.insertDate("INSERT INTO USER(U_ID,PASS) VALUES('${userID.text}','${password.text}')");
    } else {
      await sqldb.updateDate("UPDATE USER SET U_ID='${userID.text}'  , PASS='${password.text}' ");
      userID.text = data[0]['U_ID'];
      password.text = data[0]['PASS'];
      update();
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
        final jsonData = await dbServices.createRep(
          sqlStatment: "Select U_ID,U_NAME from USER1 where U_ID='${userID.text}' and U_P='${password.text}'",
          // errorCallback: (error) {
          //   // showMessage(
          //   //   msg: error,
          //   //   durationMilliseconds: 5000,
          //   // );
          // },
        );

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
          //if keep me login save data
          if (keepmelogin) {
            // print("keep me loged in next time");
            await keepLogin();
          }

          // GlobalVariable().setUserId = jsonData[0]['U_ID'].toString();
          print("Loged in user is : ${jsonData[0]['U_ID'].toString()}  -- ${jsonData[0]['U_NAME'].toString()}");
          logedInuserId = jsonData[0]['U_ID'].toString();
          logedInuserName = jsonData[0]['U_NAME'].toString();
          UserController userController = Get.put(UserController());
          await userController.getAllPrivileges();

          Get.to(() => Home()); //to find data from any where
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
      showMessage(color: secondaryColor, titleMsg: "posting error !", titleFontSize: 18, msg: e.toString(), durationMilliseconds: 1000);

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
    await removeSqfliteLoginData();

    // Remove UserController from memory
    if (Get.isRegistered<UserController>()) {
      Get.delete<UserController>();
    }

    Get.offAll(() => Login());
  }

  //
}
