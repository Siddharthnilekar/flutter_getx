import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getx_chapter_1/app/modules/product/controllers/cart_controller.dart';

class Address {
  final String fullName;
  final String streetAddress;
  final String city;
  final String postalCode;
  final String country;

  Address({
    required this.fullName,
    required this.streetAddress,
    required this.city,
    required this.postalCode,
    required this.country,
  });

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'streetAddress': streetAddress,
        'city': city,
        'postalCode': postalCode,
        'country': country,
      };

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        fullName: json['fullName'],
        streetAddress: json['streetAddress'],
        city: json['city'],
        postalCode: json['postalCode'],
        country: json['country'],
      );
}

class CardDetails {
  final String cardNumber;
  final String expiryDate;
  final String cvv;

  CardDetails({
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
  });

  Map<String, dynamic> toJson() => {
        'cardNumber': cardNumber,
        'expiryDate': expiryDate,
        'cvv': cvv,
      };

  factory CardDetails.fromJson(Map<String, dynamic> json) => CardDetails(
        cardNumber: json['cardNumber'],
        expiryDate: json['expiryDate'],
        cvv: json['cvv'],
      );
}

class CheckoutController extends GetxController {
  final CartController cartController = Get.find<CartController>();
  final storage = GetStorage();
  final formKey = GlobalKey<FormState>();

  final RxString selectedPaymentMethod = 'UPI'.obs;
  final paymentMethods = ['UPI', 'Pay using card', 'Cash on Delivery', 'Net Banking', 'EMI', 'Wallet'];
  final RxString selectedUpiOption = ''.obs;
  final RxString fullName = ''.obs;
  final RxString streetAddress = ''.obs;
  final RxString city = ''.obs;
  final RxString postalCode = ''.obs;
  final RxString country = ''.obs;
  final RxString cardNumber = ''.obs;
  final RxString expiryDate = ''.obs;
  final RxString cvv = ''.obs;
  final RxString couponCode = ''.obs;
  final RxDouble discount = 0.0.obs;
  final RxList<Address> savedAddresses = <Address>[].obs;
  final Rx<Address?> selectedAddress = Rx<Address?>(null);
  final RxList<CardDetails> savedCards = <CardDetails>[].obs;
  final Rx<CardDetails?> selectedCard = Rx<CardDetails?>(null);
  final RxString errorMessage = ''.obs;
  final RxBool isPlacingOrder = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSavedData();
    if (savedAddresses.isNotEmpty) {
      selectAddress(savedAddresses.first);
    }
  }

  void loadSavedData() {
    final List<dynamic>? storedAddresses = storage.read('addresses');
    if (storedAddresses != null) {
      savedAddresses.assignAll(storedAddresses.map((e) => Address.fromJson(e)).toList());
    } else {
      savedAddresses.add(Address(
        fullName: 'Siddharth Laxman Nilekar',
        streetAddress: 'Room no.135, 4th floor, Vikrant Sadan, Saneguruji Marg, Chinchpokli',
        city: 'Mumbai',
        postalCode: '400012',
        country: 'India',
      ));
    }
    final List<dynamic>? storedCards = storage.read('cards');
    if (storedCards != null) {
      savedCards.assignAll(storedCards.map((e) => CardDetails.fromJson(e)).toList());
    }
  }

  void saveData() {
    storage.write('addresses', savedAddresses.map((e) => e.toJson()).toList());
    storage.write('cards', savedCards.map((e) => e.toJson()).toList());
  }

  void selectAddress(Address? address) {
    selectedAddress.value = address;
    if (address != null) {
      fullName.value = address.fullName;
      streetAddress.value = address.streetAddress;
      city.value = address.city;
      postalCode.value = address.postalCode;
      country.value = address.country;
    } else {
      fullName.value = '';
      streetAddress.value = '';
      city.value = '';
      postalCode.value = '';
      country.value = '';
    }
  }

  void selectCard(CardDetails? card) {
    selectedCard.value = card;
    if (card != null) {
      cardNumber.value = card.cardNumber;
      expiryDate.value = card.expiryDate;
      cvv.value = card.cvv;
    } else {
      cardNumber.value = '';
      expiryDate.value = '';
      cvv.value = '';
    }
  }

  void removeCard(CardDetails card) {
    savedCards.remove(card);
    saveData();
    if (selectedCard.value == card) {
      selectCard(null);
    }
    Get.snackbar(
      'card_removed'.tr,
      'card_removed_successfully'.tr,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 2),
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void addNewAddress() {
    if (validateInputs()) {
      final newAddress = Address(
        fullName: fullName.value,
        streetAddress: streetAddress.value,
        city: city.value,
        postalCode: postalCode.value,
        country: country.value,
      );
      savedAddresses.add(newAddress);
      selectAddress(newAddress);
      saveData();
      Get.back();
      Get.snackbar(
        'address_saved'.tr,
        'address_added_successfully'.tr,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'error'.tr,
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void updateAddress(int index) {
    if (validateInputs()) {
      savedAddresses[index] = Address(
        fullName: fullName.value,
        streetAddress: streetAddress.value,
        city: city.value,
        postalCode: postalCode.value,
        country: country.value,
      );
      selectAddress(savedAddresses[index]);
      saveData();
      Get.back();
      Get.snackbar(
        'address_updated'.tr,
        'address_updated_successfully'.tr,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'error'.tr,
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void applyCoupon() {
    if (couponCode.value.trim().toLowerCase() == 'sid10') {
      discount.value = 0.1;
      Get.snackbar(
        'coupon_applied'.tr,
        'discount_applied'.tr,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      discount.value = 0.0;
      Get.snackbar(
        'error'.tr,
        'invalid_coupon'.tr,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  bool validateInputs() {
    errorMessage.value = '';
    if (selectedPaymentMethod.value.isEmpty) {
      errorMessage.value = 'please_select_payment_method'.tr;
      return false;
    }
    if (fullName.value.trim().isEmpty) {
      errorMessage.value = 'please_enter_full_name'.tr;
      return false;
    }
    if (streetAddress.value.trim().isEmpty) {
      errorMessage.value = 'please_enter_street_address'.tr;
      return false;
    }
    if (city.value.trim().isEmpty) {
      errorMessage.value = 'please_enter_city'.tr;
      return false;
    }
    if (postalCode.value.trim().isEmpty) {
      errorMessage.value = 'please_enter_postal_code'.tr;
      return false;
    }
    if (selectedPaymentMethod.value == 'Pay using card') {
      if (selectedCard.value == null) {
        if (cardNumber.value.trim().isEmpty) {
          errorMessage.value = 'please_enter_card_number'.tr;
          return false;
        }
        final cleanCardNumber = cardNumber.value.replaceAll(RegExp(r'\D'), '');
        if (cleanCardNumber.length != 16) {
          errorMessage.value = 'card_number_must_be_16_digits'.tr;
          return false;
        }
        if (expiryDate.value.trim().isEmpty) {
          errorMessage.value = 'please_enter_expiry_date'.tr;
          return false;
        }
        final RegExp expiryRegExp = RegExp(r'^(0[1-9]|1[0-2])\/[0-9]{2}$');
        if (!expiryRegExp.hasMatch(expiryDate.value)) {
          errorMessage.value = 'invalid_expiry_date_format'.tr;
          return false;
        }
        final now = DateTime.now();
        final parts = expiryDate.value.split('/');
        final month = int.parse(parts[0]);
        final year = int.parse('20${parts[1]}');
        final expiry = DateTime(year, month + 1);
        if (expiry.isBefore(now)) {
          errorMessage.value = 'card_is_expired'.tr;
          return false;
        }
        if (cvv.value.trim().isEmpty) {
          errorMessage.value = 'please_enter_cvv'.tr;
          return false;
        }
        if (cvv.value.length != 3) {
          errorMessage.value = 'cvv_must_be_3_digits'.tr;
          return false;
        }
        savedCards.add(CardDetails(
          cardNumber: cardNumber.value,
          expiryDate: expiryDate.value,
          cvv: cvv.value,
        ));
        saveData();
      }
    }
    if (selectedPaymentMethod.value == 'UPI') {
      if (selectedUpiOption.value.isEmpty) {
        errorMessage.value = 'please_select_upi_option'.tr;
        return false;
      }
    }
    return true;
  }

  double get discountedTotal {
    final total = cartController.totalAmount;
    return total * (1 - discount.value);
  }

  void placeOrder() async {
    if (cartController.cartItems.isEmpty) {
      Get.snackbar(
        'error'.tr,
        'cart_is_empty'.tr,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    if (selectedPaymentMethod.value == 'Pay using card' && selectedCard.value == null) {
      if (!formKey.currentState!.validate()) {
        Get.snackbar(
          'error'.tr,
          errorMessage.value.isNotEmpty ? errorMessage.value : 'please_correct_form_errors'.tr,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
    }
    if (validateInputs()) {
      isPlacingOrder.value = true;
      await Future.delayed(Duration(seconds: 2));
      cartController.cartService.clearCart();
      discount.value = 0.0;
      couponCode.value = '';
      selectedUpiOption.value = '';
      Get.snackbar(
        'order_completed'.tr,
        'order_placed'.tr,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
      isPlacingOrder.value = false;
      Get.offAllNamed('/product');
    } else {
      Get.snackbar(
        'error'.tr,
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}