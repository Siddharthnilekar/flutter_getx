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

  // Reactive variables for payment method
  final RxString selectedPaymentMethod = 'GPay'.obs; // Default to recommended GPay
  final paymentMethods = ['GPay', 'Other UPI', 'Credit Card', 'PayPal', 'Cash on Delivery'];

  // Reactive variables for address fields
  final RxString fullName = ''.obs;
  final RxString streetAddress = ''.obs;
  final RxString city = ''.obs;
  final RxString postalCode = ''.obs;
  final RxString country = ''.obs;

  // Reactive variables for card details
  final RxString cardNumber = ''.obs;
  final RxString expiryDate = ''.obs;
  final RxString cvv = ''.obs;

  // Coupon code
  final RxString couponCode = ''.obs;
  final RxDouble discount = 0.0.obs;

  // Stored addresses and card details
  final RxList<Address> savedAddresses = <Address>[].obs;
  final Rx<Address?> selectedAddress = Rx<Address?>(null);
  final RxList<CardDetails> savedCards = <CardDetails>[].obs;
  final Rx<CardDetails?> selectedCard = Rx<CardDetails?>(null);

  // Validation status and loading
  final RxString errorMessage = ''.obs;
  final RxBool isPlacingOrder = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Load saved addresses and cards from storage
    loadSavedData();
    // Set default address
    if (savedAddresses.isNotEmpty) {
      selectAddress(savedAddresses.first);
    }
  }

  // Load saved addresses and cards
  void loadSavedData() {
    final List<dynamic>? storedAddresses = storage.read('addresses');
    if (storedAddresses != null) {
      savedAddresses.assignAll(storedAddresses.map((e) => Address.fromJson(e)).toList());
    } else {
      // Default address
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

  // Save addresses and cards
  void saveData() {
    storage.write('addresses', savedAddresses.map((e) => e.toJson()).toList());
    storage.write('cards', savedCards.map((e) => e.toJson()).toList());
  }

  // Select an address
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

  // Select a card
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

  // Add a new address
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
      Get.back(); // Return to checkout page
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

  // Update an existing address
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

  // Apply coupon code
  void applyCoupon() {
    if (couponCode.value.trim().toLowerCase() == 'sid10') {
      discount.value = 0.1; // 10% discount
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

  // Validate inputs
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
    if (selectedPaymentMethod.value == 'Credit Card') {
      if (cardNumber.value.trim().isEmpty) {
        errorMessage.value = 'please_enter_card_number'.tr;
        return false;
      }
      if (expiryDate.value.trim().isEmpty) {
        errorMessage.value = 'please_enter_expiry_date'.tr;
        return false;
      }
      if (cvv.value.trim().isEmpty) {
        errorMessage.value = 'please_enter_cvv'.tr;
        return false;
      }
      // Save card details
      if (selectedCard.value == null) {
        savedCards.add(CardDetails(
          cardNumber: cardNumber.value,
          expiryDate: expiryDate.value,
          cvv: cvv.value,
        ));
        saveData();
      }
    }
    return true;
  }

  // Calculate discounted total
  double get discountedTotal {
    final total = cartController.totalAmount; // Assumes totalAmount is double
    return total * (1 - discount.value);
  }

  // Place order
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
    if (validateInputs()) {
      isPlacingOrder.value = true;
      await Future.delayed(Duration(seconds: 2)); // Simulate API call
      cartController.cartService.clearCart();
      discount.value = 0.0;
      couponCode.value = '';
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