// class ActPrivModel {
//   final int a53; // 53||1  1 is the user id
//   final int a57; // 57||1  1 is the user id
//   final int a58;
//   final int a59;
//   final int a60;
//   final int a61;
//   final int a77;
//   final int a99;

//   ActPrivModel({
//     required this.a53,
//     required this.a57,
//     required this.a58,
//     required this.a59,
//     required this.a60,
//     required this.a61,
//     required this.a77,
//     required this.a99,
//   });

//   //  double get total => (price * qty) - discount;
// }
class ItemsDataModel {
  final String itemId; // 53||1  1 is the user id
  final String barcode;
  final String itemName; // 57||1  1 is the user id
  final int? currentBal;
  final String unit; //List<String>?
  int qty;
  double price1;
  double priceAftrVat;
  // double discount;
  // double? discountPr;
  // double? total;
  int vatPr;

  ItemsDataModel({
    required this.itemId,
    required this.barcode,
    required this.itemName,
    required this.unit,
    this.qty = 0,
    this.currentBal,
    required this.price1,
    required this.priceAftrVat,
    // this.discount = 0,
    // this.discountPr,
    // this.total,
    this.vatPr = 15,
  });

  double get total => priceAftrVat * qty;
  double get vat => price1 * qty * (vatPr / 100);
}

class ActPrivModel {
  final int actId; // 53||1  1 is the user id
  final String actName; // 57||1  1 is the user id
  final bool chk;

  ActPrivModel({
    required this.actId,
    required this.actName,
    required this.chk,
  });
}

class CsClsPrivModel {
  final int cSClsId;
  final String cSClsName;
  final String accId;
  final int brId;
  final String curId;

  CsClsPrivModel({
    required this.cSClsId,
    required this.cSClsName,
    required this.accId,
    required this.brId,
    required this.curId,
  });
}

class CusDataModel {
  final int cusId;
  final String cusName;
  final String? mobl;
  final String? adrs;
  final String? taxNo;
  final int? slsManId;
  final int? stoped;
  final double? latitude;
  final double? longitude;
  final int? visitCnt;
  final int? vatStatus;
  final int vatPr;
  final bool isNewCus;

  CusDataModel({
    required this.cusId,
    required this.cusName,
    this.mobl,
    this.adrs,
    this.taxNo,
    this.slsManId,
    this.stoped,
    this.latitude,
    this.longitude,
    this.visitCnt,
    this.vatStatus,
    this.vatPr = 15,
    this.isNewCus = false,
  });
}

//

class SlsCntrPrivModel {
  final int slsCntrID;
  final String slsCntrName;

  SlsCntrPrivModel({
    required this.slsCntrID,
    required this.slsCntrName,
  });
}

class CstCntrPrivModel {
  final int cstCntrID;
  final String cstCntrName;

  CstCntrPrivModel({
    required this.cstCntrID,
    required this.cstCntrName,
  });
}

class StWhousesPrivModel {
  final int whID;
  final String whName;

  StWhousesPrivModel({
    required this.whID,
    required this.whName,
  });
}

class BranchPrivModel {
  final int brID;
  final String brName;

  BranchPrivModel({
    required this.brID,
    required this.brName,
  });
}

class BankPrivModel {
  final String bankID;
  final String accID;
  final String accName;
  final int bankOrCash;
  final int stoped;
  final String curId;

  BankPrivModel({
    required this.bankID,
    required this.accID,
    required this.accName,
    required this.bankOrCash,
    required this.stoped,
    required this.curId,
  });
}

class CompData {
  final String aCompName;
  final String eCompName;
  final String aActivity;
  final String eActivity;
  final String aAddress;
  final String eAddress;
  final String tel;
  final String fax;
  final String taxNo;
  final String commercialReg;

  CompData({
    required this.aCompName,
    required this.eCompName,
    required this.aActivity,
    required this.eActivity,
    required this.aAddress,
    required this.eAddress,
    required this.tel,
    required this.fax,
    required this.taxNo,
    required this.commercialReg,
  });
}
