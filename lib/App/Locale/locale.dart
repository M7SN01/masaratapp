import 'package:get/get.dart';

class AppLocale implements Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'ar': {
      'item': 'صنف',
      'price': 'سعر',
      'quantity': 'الكمية',
      'total_price': 'المجموع',
      'discount': 'الخصم',
      'tax': 'الضريبة',
      'back': 'رجوع',
      'search': 'بحث',
      'vaforite': 'المفضلة',
      'morest_sale': 'الأكثر مبيعًا',
      'total': 'الإجمالي',
      'total_discount': 'إجمالي الخصم',
      'total_tax': 'إجمالي الضريبة',
      'total_price_after_discount': 'إجمالي السعر بعد الخصم',
      'total_price_after_tax': 'إجمالي السعر بعد الضريبة',
      'payment': 'الدفع',
      'barcode': 'باركود',
    },
    'en': {
      'item': 'Item',
      'price': 'Price',
      'quantity': 'Quantity',
      'total_price': 'Total Price',
      'discount': 'Discount',
      'tax': 'Tax',
      'back': 'Back',
      'search': 'Search',
      'vaforite': 'Favorite',
      'morest_sale': 'Most Sold',
      'total': 'Total',
      'total_discount': 'Total Discount',
      'total_tax': 'Total Tax',
      'total_price_after_discount': 'Total After Discount',
      'total_price_after_tax': 'Total After Tax',
      'payment': 'Payment',
      'barcode': 'Barcode',
    },
  };
}
