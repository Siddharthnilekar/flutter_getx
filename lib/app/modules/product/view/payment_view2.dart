import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:getx_chapter_1/app/modules/product/controllers/cart_controller.dart';
import 'package:getx_chapter_1/app/modules/product/controllers/checkout_controller.dart';
import 'dart:convert';
import 'dart:developer' as developer;

class Bank {
  final String name;
  final String shortCode;
  final String logo;

  Bank({required this.name, required this.shortCode, required this.logo});

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      name: json['name'],
      shortCode: json['short_code'],
      logo: json['logo'],
    );
  }
}

class CardDetails {
  final String cardNumber;
  final String fullName;
  final String expiry;
  final String cvv;

  CardDetails({
    required this.cardNumber,
    required this.fullName,
    required this.expiry,
    required this.cvv,
  });
}

class PaymentView2 extends StatelessWidget {
  final CheckoutController checkoutController = Get.find<CheckoutController>();
  final CartController cartController = Get.find<CartController>();
  final RxBool isWalletExpanded = false.obs;
  final RxBool isUpiExpanded = false.obs;
  final RxBool isCardsExpanded = false.obs;
  final RxBool isNetbankingExpanded = false.obs;
  final RxBool isQrExpanded = false.obs;
  final RxBool isBankExpanded = false.obs;
  final RxBool isPayLaterExpanded = false.obs;
  final RxBool isEmiExpanded = false.obs;
  final TextEditingController contactController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final RxBool saveCard = false.obs;
  final RxList<CardDetails> savedCards = <CardDetails>[].obs;
  final RxBool showAllCards = false.obs;
  final RxList<Bank> banks = <Bank>[].obs;
  final RxString selectedBank = ''.obs;
  final FocusNode _dropdownFocus = FocusNode();

  PaymentView2({super.key}) {
    _loadBanks();
  }

  // Load bank data from JSON
  Future<void> _loadBanks() async {
    try {
      final String response = await DefaultAssetBundle.of(Get.context!).loadString('assets/bank_data.json');
      developer.log('JSON loaded: ${response.length} characters', name: 'PaymentView2');
      final List<dynamic> data = jsonDecode(response);
      banks.value = data.map((json) => Bank.fromJson(json)).toList();
      developer.log('Loaded ${banks.length} banks', name: 'PaymentView2');
      if (banks.isEmpty) {
        Get.snackbar('Error', 'No banks loaded');
      }
    } catch (e, stackTrace) {
      developer.log('Error loading bank data: $e', name: 'PaymentView2', error: e, stackTrace: stackTrace);
      Get.snackbar('Error', 'Failed to load bank data: $e');
    }
  }

  // Validation functions
  String? _validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter card number'.tr;
    }
    final cleanValue = value.replaceAll(RegExp(r'\D'), '');
    if (cleanValue.length != 16) {
      return 'Card number must be 16 digits'.tr;
    }
    return null;
  }

  String? _validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter full name'.tr;
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name can only contain letters and spaces'.tr;
    }
    return null;
  }

  String? _validateExpiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter expiry date'.tr;
    }
    final RegExp expiryRegExp = RegExp(r'^(0[1-9]|1[0-2])\/[0-9]{2}$');
    if (!expiryRegExp.hasMatch(value)) {
      return 'Invalid expiry date format (MM/YY)'.tr;
    }
    final parts = value.split('/');
    final month = int.parse(parts[0]);
    final year = int.parse('20${parts[1]}');
    final now = DateTime.now();
    final expiry = DateTime(year, month + 1);
    if (expiry.isBefore(now)) {
      return 'Card is expired'.tr;
    }
    return null;
  }

  String? _validateCvv(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter CVV'.tr;
    }
    if (value.length != 3) {
      return 'CVV must be 3 digits'.tr;
    }
    return null;
  }

  String? _validateBankSelection(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a bank'.tr;
    }
    return null;
  }

  // Validate card details
  bool _validateCardDetails() {
    final cardNumberError = _validateCardNumber(cardNumberController.text);
    final fullNameError = _validateFullName(fullNameController.text);
    final expiryError = _validateExpiryDate(expiryController.text);
    final cvvError = _validateCvv(cvvController.text);

    if (cardNumberError != null) {
      Get.snackbar('Error', cardNumberError);
      return false;
    }
    if (fullNameError != null) {
      Get.snackbar('Error', fullNameError);
      return false;
    }
    if (expiryError != null) {
      Get.snackbar('Error', expiryError);
      return false;
    }
    if (cvvError != null) {
      Get.snackbar('Error', cvvError);
      return false;
    }
    return true;
  }

  // Validate netbanking selection
  bool _validateNetbanking() {
    final bankError = _validateBankSelection(selectedBank.value);
    if (bankError != null) {
      Get.snackbar('Error', bankError);
      return false;
    }
    return true;
  }

  // Save card details
  void _saveCard() {
    if (_validateCardDetails()) {
      savedCards.add(CardDetails(
        cardNumber: cardNumberController.text.replaceAll(' ', ''),
        fullName: fullNameController.text,
        expiry: expiryController.text,
        cvv: cvvController.text,
      ));
      Get.snackbar('Success', 'Card saved successfully');
      cardNumberController.clear();
      fullNameController.clear();
      expiryController.clear();
      cvvController.clear();
      saveCard.value = false;
    }
  }

  // Auto-fill card details
  void _fillCardDetails(CardDetails card) {
    cardNumberController.text = card.cardNumber.replaceAllMapped(
        RegExp(r'(.{4})'), (Match match) => '${match.group(0)} ').trim();
    fullNameController.text = card.fullName;
    expiryController.text = card.expiry;
    cvvController.text = card.cvv;
    saveCard.value = false;
  }

  @override
  Widget build(BuildContext context) {
    final textFieldContentColor = Theme.of(context).brightness == Brightness.light ? Colors.black87 : Colors.white70;
    final screenWidth = MediaQuery.of(context).size.width;
    final boxSize = ((screenWidth - 16 - 18) / 4).clamp(70.0, 90.0);
    final upiBoxSize = ((screenWidth - 24 - 24) / 5).clamp(50.0, 70.0);
    const boxGap = 6.0;
    final totalAmountInr = (cartController.totalAmount * 83).toStringAsFixed(2);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'EaseCheckout',
          style: GoogleFonts.poppins(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: screenWidth < 600 ? 18 : 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: Theme.of(context).colorScheme.onSurface),
            onPressed: () {
              Get.snackbar('Help', 'Contact support for assistance.');
            },
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 2,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, screenWidth < 600 ? 80.0 : 100.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 4,
                  color: Theme.of(context).colorScheme.surface,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: screenWidth < 600 ? 20 : 24,
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          child: Text(
                            'TU',
                            style: GoogleFonts.poppins(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: screenWidth < 600 ? 14 : 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Top Up'.tr,
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth < 600 ? 14 : 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                'Wallet Top Up'.tr,
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth < 600 ? 10 : 12,
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Total Amount'.tr,
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth < 600 ? 14 : 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              '₹$totalAmountInr',
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth < 600 ? 12 : 14,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 4,
                  color: Theme.of(context).colorScheme.surface,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: _buildPaymentOption(
                                context,
                                title: 'Wallets'.tr,
                                logoPath: 'assets/images/wallet.png',
                                amount: '₹179.68',
                                boxSize: boxSize,
                                onTap: () {
                                  isWalletExpanded.value = !isWalletExpanded.value;
                                  if (isUpiExpanded.value) isUpiExpanded.value = false;
                                  if (isCardsExpanded.value) isCardsExpanded.value = false;
                                  if (isNetbankingExpanded.value) isNetbankingExpanded.value = false;
                                  if (isQrExpanded.value) isQrExpanded.value = false;
                                  if (isBankExpanded.value) isBankExpanded.value = false;
                                  if (isPayLaterExpanded.value) isPayLaterExpanded.value = false;
                                  if (isEmiExpanded.value) isEmiExpanded.value = false;
                                },
                                isSelected: isWalletExpanded.value,
                                isTopAligned: true,
                              ),
                            ),
                            const SizedBox(width: boxGap),
                            Expanded(
                              child: _buildPaymentOption(
                                context,
                                title: 'UPI'.tr,
                                logoPath: 'assets/images/upi.png',
                                boxSize: boxSize,
                                onTap: () {
                                  isUpiExpanded.value = !isUpiExpanded.value;
                                  if (isWalletExpanded.value) isWalletExpanded.value = false;
                                  if (isCardsExpanded.value) isCardsExpanded.value = false;
                                  if (isNetbankingExpanded.value) isNetbankingExpanded.value = false;
                                  if (isQrExpanded.value) isQrExpanded.value = false;
                                  if (isBankExpanded.value) isBankExpanded.value = false;
                                  if (isPayLaterExpanded.value) isPayLaterExpanded.value = false;
                                  if (isEmiExpanded.value) isEmiExpanded.value = false;
                                },
                                isSelected: isUpiExpanded.value,
                                isTopAligned: true,
                              ),
                            ),
                            const SizedBox(width: boxGap),
                            Expanded(
                              child: _buildPaymentOption(
                                context,
                                title: 'Cards'.tr,
                                logoPath: 'assets/images/credit_card.png',
                                boxSize: boxSize,
                                onTap: () {
                                  isCardsExpanded.value = !isCardsExpanded.value;
                                  if (isWalletExpanded.value) isWalletExpanded.value = false;
                                  if (isUpiExpanded.value) isUpiExpanded.value = false;
                                  if (isNetbankingExpanded.value) isNetbankingExpanded.value = false;
                                  if (isQrExpanded.value) isQrExpanded.value = false;
                                  if (isBankExpanded.value) isBankExpanded.value = false;
                                  if (isPayLaterExpanded.value) isPayLaterExpanded.value = false;
                                  if (isEmiExpanded.value) isEmiExpanded.value = false;
                                },
                                isSelected: isCardsExpanded.value,
                                isTopAligned: true,
                              ),
                            ),
                            const SizedBox(width: boxGap),
                            Expanded(
                              child: _buildPaymentOption(
                                context,
                                title: 'Netbanking'.tr,
                                logoPath: 'assets/images/net_banking.png',
                                boxSize: boxSize,
                                onTap: () {
                                  isNetbankingExpanded.value = !isNetbankingExpanded.value;
                                  if (isWalletExpanded.value) isWalletExpanded.value = false;
                                  if (isUpiExpanded.value) isUpiExpanded.value = false;
                                  if (isCardsExpanded.value) isCardsExpanded.value = false;
                                  if (isQrExpanded.value) isQrExpanded.value = false;
                                  if (isBankExpanded.value) isBankExpanded.value = false;
                                  if (isPayLaterExpanded.value) isPayLaterExpanded.value = false;
                                  if (isEmiExpanded.value) isEmiExpanded.value = false;
                                },
                                isSelected: isNetbankingExpanded.value,
                                isTopAligned: true,
                              ),
                            ),
                          ],
                        ),
                        Obx(
                          () => isWalletExpanded.value
                              ? Column(
                                  children: [
                                    const Divider(height: 24),
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/mufinpay.png',
                                          width: screenWidth < 600 ? 36 : 40,
                                          height: screenWidth < 600 ? 36 : 40,
                                          errorBuilder: (context, error, stackTrace) => Icon(
                                            Icons.error,
                                            color: Theme.of(context).colorScheme.primary,
                                            size: screenWidth < 600 ? 36 : 40,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'MufinPay'.tr,
                                                style: GoogleFonts.poppins(
                                                  fontSize: screenWidth < 600 ? 14 : 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context).colorScheme.onSurface,
                                                ),
                                              ),
                                              Text(
                                                'Balance: ₹179.68'.tr,
                                                style: GoogleFonts.poppins(
                                                  fontSize: screenWidth < 600 ? 10 : 12,
                                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                                ),
                                              ),
                                              Text(
                                                '🎉 Get up to 25% cash back'.tr,
                                                style: GoogleFonts.poppins(
                                                  fontSize: screenWidth < 600 ? 10 : 12,
                                                  color: Theme.of(context).colorScheme.primary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        AnimatedButton(
                                          text: 'Pay'.tr,
                                          onPressed: () => checkoutController.placeOrder(),
                                          icon: Icons.payment,
                                          gradient: const LinearGradient(
                                            colors: [Color.fromARGB(255, 75, 120, 218), Color.fromARGB(255, 113, 117, 218)],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : const SizedBox.shrink(),
                        ),
                        Obx(
                          () => isUpiExpanded.value
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Divider(height: 24),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: _buildUpiOption(
                                            context,
                                            title: 'Google Pay'.tr,
                                            logoPath: 'assets/images/google_pay.png',
                                            boxSize: upiBoxSize,
                                          ),
                                        ),
                                        const SizedBox(width: boxGap),
                                        Expanded(
                                          child: _buildUpiOption(
                                            context,
                                            title: 'PhonePe'.tr,
                                            logoPath: 'assets/images/phonepe.png',
                                            boxSize: upiBoxSize,
                                          ),
                                        ),
                                        const SizedBox(width: boxGap),
                                        Expanded(
                                          child: _buildUpiOption(
                                            context,
                                            title: 'Paytm'.tr,
                                            logoPath: 'assets/images/paytm.png',
                                            boxSize: upiBoxSize,
                                          ),
                                        ),
                                        const SizedBox(width: boxGap),
                                        Expanded(
                                          child: _buildUpiOption(
                                            context,
                                            title: 'CRED'.tr,
                                            logoPath: 'assets/images/cred.png',
                                            boxSize: upiBoxSize,
                                          ),
                                        ),
                                        const SizedBox(width: boxGap),
                                        Expanded(
                                          child: _buildUpiOption(
                                            context,
                                            title: 'See All'.tr,
                                            logoPath: '',
                                            boxSize: upiBoxSize,
                                            isSeeAll: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Collect Request'.tr,
                                      style: GoogleFonts.poppins(
                                        fontSize: screenWidth < 600 ? 14 : 16,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    TextField(
                                      controller: contactController,
                                      decoration: InputDecoration(
                                        hintText: 'Enter contact number'.tr,
                                        hintStyle: GoogleFonts.poppins(
                                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                                        ),
                                        suffixIcon: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 1,
                                              height: 24,
                                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                                              margin: const EdgeInsets.symmetric(horizontal: 8),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.contacts,
                                                color: Theme.of(context).colorScheme.primary,
                                                size: screenWidth < 600 ? 20 : 24,
                                              ),
                                              onPressed: () {},
                                            ),
                                          ],
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                            color: Theme.of(context).colorScheme.primary,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                      keyboardType: TextInputType.phone,
                                      style: GoogleFonts.poppins(
                                        fontSize: screenWidth < 600 ? 12 : 14,
                                        color: textFieldContentColor,
                                      ),
                                      cursorColor: textFieldContentColor,
                                    ),
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      width: double.infinity,
                                      child: AnimatedButton(
                                        text: 'Send Request'.tr,
                                        onPressed: () {
                                          if (contactController.text.isNotEmpty) {
                                            Get.snackbar('Request Sent', 'UPI request sent to ${contactController.text}');
                                          } else {
                                            Get.snackbar('Error', 'Please enter a contact number');
                                          }
                                        },
                                        icon: Icons.send,
                                        isLoading: false,
                                        gradient: const LinearGradient(
                                          colors: [Color.fromARGB(255, 75, 120, 218), Color.fromARGB(255, 100, 156, 224)],
                                        ),
                                        isSmall: true,
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox.shrink(),
                        ),
                        Obx(
                          () => isCardsExpanded.value
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Divider(height: 24),
                                    if (savedCards.isNotEmpty) ...[
                                      Text(
                                        'Saved Cards'.tr,
                                        style: GoogleFonts.poppins(
                                          fontSize: screenWidth < 600 ? 14 : 16,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).colorScheme.onSurface,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      ...savedCards
                                          .asMap()
                                          .entries
                                          .take(showAllCards.value ? savedCards.length : 2)
                                          .map(
                                            (entry) => Padding(
                                              padding: const EdgeInsets.only(bottom: 8.0),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: GestureDetector(
                                                      onTap: () => _fillCardDetails(entry.value),
                                                      child: Container(
                                                        padding: const EdgeInsets.all(8),
                                                        decoration: BoxDecoration(
                                                          color: Theme.of(context).colorScheme.surface,
                                                          borderRadius: BorderRadius.circular(8),
                                                          border: Border.all(
                                                            color: Colors.grey,
                                                            width: 1,
                                                          ),
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              '**** **** **** ${entry.value.cardNumber.substring(12)}',
                                                              style: GoogleFonts.poppins(
                                                                fontSize: screenWidth < 600 ? 12 : 14,
                                                                color: Theme.of(context).colorScheme.onSurface,
                                                              ),
                                                            ),
                                                            Text(
                                                              entry.value.fullName,
                                                              style: GoogleFonts.poppins(
                                                                fontSize: screenWidth < 600 ? 10 : 12,
                                                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.delete,
                                                      color: Theme.of(context).colorScheme.error,
                                                      size: screenWidth < 600 ? 20 : 24,
                                                    ),
                                                    onPressed: () {
                                                      savedCards.removeAt(entry.key);
                                                      Get.snackbar('Success', 'Card deleted');
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                      if (savedCards.length > 2 && !showAllCards.value)
                                        GestureDetector(
                                          onTap: () => showAllCards.value = true,
                                          child: Text(
                                            'View ${savedCards.length - 2} more'.tr,
                                            style: GoogleFonts.poppins(
                                              fontSize: screenWidth < 600 ? 12 : 14,
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      const SizedBox(height: 12),
                                    ],
                                    Text(
                                      'Enter Card Details'.tr,
                                      style: GoogleFonts.poppins(
                                        fontSize: screenWidth < 600 ? 14 : 16,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    TextField(
                                      controller: cardNumberController,
                                      decoration: InputDecoration(
                                        hintText: '1234 5678 9012 3456'.tr,
                                        hintStyle: GoogleFonts.poppins(
                                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                                        ),
                                        prefixIcon: Icon(Icons.credit_card, color: textFieldContentColor, size: 22),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                            color: Theme.of(context).colorScheme.primary,
                                            width: 2,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(16),
                                        _CardNumberInputFormatter(),
                                      ],
                                      style: GoogleFonts.poppins(
                                        fontSize: screenWidth < 600 ? 12 : 14,
                                        color: textFieldContentColor,
                                      ),
                                      cursorColor: textFieldContentColor,
                                    ),
                                    const SizedBox(height: 12),
                                    TextField(
                                      controller: fullNameController,
                                      decoration: InputDecoration(
                                        hintText: 'Enter full name'.tr,
                                        hintStyle: GoogleFonts.poppins(
                                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                                        ),
                                        prefixIcon: Icon(Icons.person, color: textFieldContentColor, size: 22),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                            color: Theme.of(context).colorScheme.primary,
                                            width: 2,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
                                        ),
                                      ),
                                      keyboardType: TextInputType.name,
                                      style: GoogleFonts.poppins(
                                        fontSize: screenWidth < 600 ? 12 : 14,
                                        color: textFieldContentColor,
                                      ),
                                      cursorColor: textFieldContentColor,
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller: expiryController,
                                            decoration: InputDecoration(
                                              hintText: 'MM/YY'.tr,
                                              hintStyle: GoogleFonts.poppins(
                                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                                              ),
                                              prefixIcon: Icon(Icons.calendar_today, color: textFieldContentColor, size: 22),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                borderSide: BorderSide(
                                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                borderSide: BorderSide(
                                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                borderSide: BorderSide(
                                                  color: Theme.of(context).colorScheme.primary,
                                                  width: 2,
                                                ),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
                                              ),
                                              focusedErrorBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
                                              ),
                                            ),
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
                                              LengthLimitingTextInputFormatter(5),
                                              _ExpiryDateInputFormatter(),
                                            ],
                                            style: GoogleFonts.poppins(
                                              fontSize: screenWidth < 600 ? 12 : 14,
                                              color: textFieldContentColor,
                                            ),
                                            cursorColor: textFieldContentColor,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: TextField(
                                            controller: cvvController,
                                            decoration: InputDecoration(
                                              hintText: 'CVV'.tr,
                                              hintStyle: GoogleFonts.poppins(
                                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                                              ),
                                              prefixIcon: Icon(Icons.lock, color: textFieldContentColor, size: 22),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                borderSide: BorderSide(
                                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                borderSide: BorderSide(
                                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                borderSide: BorderSide(
                                                  color: Theme.of(context).colorScheme.primary,
                                                  width: 2,
                                                ),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
                                              ),
                                              focusedErrorBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
                                              ),
                                            ),
                                            keyboardType: TextInputType.number,
                                            obscureText: true,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.digitsOnly,
                                              LengthLimitingTextInputFormatter(3),
                                            ],
                                            style: GoogleFonts.poppins(
                                              fontSize: screenWidth < 600 ? 12 : 14,
                                              color: textFieldContentColor,
                                            ),
                                            cursorColor: textFieldContentColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Obx(
                                          () => Checkbox(
                                            value: saveCard.value,
                                            onChanged: (value) => saveCard.value = value ?? false,
                                            activeColor: Theme.of(context).colorScheme.primary,
                                          ),
                                        ),
                                        Text(
                                          'Save Card'.tr,
                                          style: GoogleFonts.poppins(
                                            fontSize: screenWidth < 600 ? 12 : 14,
                                            color: Theme.of(context).colorScheme.onSurface,
                                          ),
                                        ),
                                        const Spacer(),
                                        AnimatedButton(
                                          text: 'Verify'.tr,
                                          onPressed: () {
                                            if (_validateCardDetails()) {
                                              if (saveCard.value) {
                                                _saveCard();
                                              } else {
                                                Get.snackbar('Success', 'Card verified');
                                              }
                                            }
                                          },
                                          icon: Icons.verified,
                                          gradient: const LinearGradient(
                                            colors: [Color.fromARGB(255, 75, 120, 218), Color.fromARGB(255, 100, 156, 224)],
                                          ),
                                          isSmall: true,
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : const SizedBox.shrink(),
                        ),
                        Obx(
                          () => isNetbankingExpanded.value
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Divider(height: 24),
                                    Text(
                                      'All Indian Banks'.tr,
                                      style: GoogleFonts.poppins(
                                        fontSize: screenWidth < 600 ? 14 : 16,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    GestureDetector(
                                      onTap: () {
                                        developer.log('Dropdown tapped', name: 'PaymentView2');
                                        _dropdownFocus.requestFocus();
                                      },
                                      child: Obx(
                                        () => DropdownButtonFormField<String>(
                                          focusNode: _dropdownFocus,
                                          value: selectedBank.value.isEmpty ? null : selectedBank.value,
                                          hint: Text(
                                            'Choose an Option'.tr,
                                            style: GoogleFonts.poppins(
                                              fontSize: screenWidth < 600 ? 12 : 14,
                                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                                            ),
                                          ),
                                          items: banks.isEmpty
                                              ? [
                                                  DropdownMenuItem<String>(
                                                    value: null,
                                                    child: Text(
                                                      'No banks available'.tr,
                                                      style: GoogleFonts.poppins(
                                                        fontSize: screenWidth < 600 ? 12 : 14,
                                                        color: textFieldContentColor,
                                                      ),
                                                    ),
                                                  ),
                                                ]
                                              : banks.map((bank) {
                                                  return DropdownMenuItem<String>(
                                                    value: bank.name,
                                                    child: Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                          bank.logo,
                                                          width: screenWidth < 600 ? 24 : 28,
                                                          height: screenWidth < 600 ? 24 : 28,
                                                          placeholderBuilder: (context) {
                                                            developer.log('Failed to load SVG: ${bank.logo}', name: 'PaymentView2');
                                                            return Icon(
                                                              Icons.error,
                                                              color: Theme.of(context).colorScheme.primary,
                                                              size: screenWidth < 600 ? 24 : 28,
                                                            );
                                                          },
                                                        ),
                                                        const SizedBox(width: 8),
                                                        Flexible(
                                                          child: Text(
                                                            bank.name,
                                                            style: GoogleFonts.poppins(
                                                              fontSize: screenWidth < 600 ? 12 : 14,
                                                              color: textFieldContentColor,
                                                            ),
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 1,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }).toList(),
                                          onChanged: banks.isEmpty
                                              ? null
                                              : (value) {
                                                  developer.log('Dropdown selection: $value', name: 'PaymentView2');
                                                  if (value != null) {
                                                    selectedBank.value = value;
                                                  }
                                                },
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                              borderSide: BorderSide(
                                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                              borderSide: BorderSide(
                                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                              borderSide: BorderSide(
                                                color: Theme.of(context).colorScheme.primary,
                                                width: 2,
                                              ),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                              borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
                                            ),
                                            focusedErrorBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                              borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
                                            ),
                                          ),
                                          isExpanded: true,
                                          dropdownColor: Theme.of(context).colorScheme.surface,
                                          menuMaxHeight: 300,
                                          style: GoogleFonts.poppins(
                                            fontSize: screenWidth < 600 ? 12 : 14,
                                            color: textFieldContentColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      width: double.infinity,
                                      child: AnimatedButton(
                                        text: 'Proceed'.tr,
                                        onPressed: () {
                                          if (_validateNetbanking()) {
                                            Get.snackbar('Success', 'Proceeding with ${selectedBank.value}');
                                            checkoutController.placeOrder();
                                          }
                                        },
                                        icon: Icons.arrow_forward,
                                        isLoading: false,
                                        gradient: const LinearGradient(
                                          colors: [Color.fromARGB(255, 75, 120, 218), Color.fromARGB(255, 100, 156, 224)],
                                        ),
                                        isSmall: true,
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // QR Card
                Card(
                  elevation: 4,
                  color: Theme.of(context).colorScheme.surface,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        _buildPaymentOption(
                          context,
                          title: 'QR'.tr,
                          logoPath: 'assets/images/qr-code.png',
                          description: 'Generate a QR and scan it to pay'.tr,
                          onTap: () {
                            isQrExpanded.value = !isQrExpanded.value;
                            if (isWalletExpanded.value) isWalletExpanded.value = false;
                            if (isUpiExpanded.value) isUpiExpanded.value = false;
                            if (isCardsExpanded.value) isCardsExpanded.value = false;
                            if (isNetbankingExpanded.value) isNetbankingExpanded.value = false;
                            if (isBankExpanded.value) isBankExpanded.value = false;
                            if (isPayLaterExpanded.value) isPayLaterExpanded.value = false;
                            if (isEmiExpanded.value) isEmiExpanded.value = false;
                          },
                          isSelected: isQrExpanded.value,
                        ),
                        Obx(
                          () => isQrExpanded.value
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Divider(height: 24),
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/upi.png',
                                          width: screenWidth < 600 ? 36 : 40,
                                          height: screenWidth < 600 ? 36 : 40,
                                          errorBuilder: (context, error, stackTrace) => Icon(
                                            Icons.error,
                                            color: Theme.of(context).colorScheme.primary,
                                            size: screenWidth < 600 ? 36 : 40,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            'Pay by any UPI APPS'.tr,
                                            style: GoogleFonts.poppins(
                                              fontSize: screenWidth < 600 ? 14 : 16,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context).colorScheme.onSurface,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: _buildUpiOption(
                                            context,
                                            title: 'Google Pay'.tr,
                                            logoPath: 'assets/images/google_pay.png',
                                            boxSize: upiBoxSize,
                                          ),
                                        ),
                                        const SizedBox(width: boxGap),
                                        Expanded(
                                          child: _buildUpiOption(
                                            context,
                                            title: 'PhonePe'.tr,
                                            logoPath: 'assets/images/phonepe.png',
                                            boxSize: upiBoxSize,
                                          ),
                                        ),
                                        const SizedBox(width: boxGap),
                                        Expanded(
                                          child: _buildUpiOption(
                                            context,
                                            title: 'Paytm'.tr,
                                            logoPath: 'assets/images/paytm.png',
                                            boxSize: upiBoxSize,
                                          ),
                                        ),
                                        const SizedBox(width: boxGap),
                                        Expanded(
                                          child: _buildUpiOption(
                                            context,
                                            title: '& More'.tr,
                                            logoPath: '',
                                            boxSize: upiBoxSize,
                                            isSeeAll: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Center(
                                      child: Image.asset(
                                        'assets/images/qr-code.png',
                                        width: 150,
                                        height: 150,
                                        errorBuilder: (context, error, stackTrace) => Icon(
                                          Icons.error,
                                          color: Theme.of(context).colorScheme.primary,
                                          size: 150,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Bank Card
                Card(
                  elevation: 4,
                  color: Theme.of(context).colorScheme.surface,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        _buildPaymentOption(
                          context,
                          title: 'Bank'.tr,
                          logoPath: 'assets/images/net_banking.png',
                          description: 'Pay directly using bank account'.tr,
                          onTap: () {
                            isBankExpanded.value = !isBankExpanded.value;
                            if (isWalletExpanded.value) isWalletExpanded.value = false;
                            if (isUpiExpanded.value) isUpiExpanded.value = false;
                            if (isCardsExpanded.value) isCardsExpanded.value = false;
                            if (isNetbankingExpanded.value) isNetbankingExpanded.value = false;
                            if (isQrExpanded.value) isQrExpanded.value = false;
                            if (isPayLaterExpanded.value) isPayLaterExpanded.value = false;
                            if (isEmiExpanded.value) isEmiExpanded.value = false;
                          },
                          isSelected: isBankExpanded.value,
                        ),
                        Obx(
                          () => isBankExpanded.value
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Divider(height: 24),
                                    Text(
                                      'Pay directly using bank account'.tr,
                                      style: GoogleFonts.poppins(
                                        fontSize: screenWidth < 600 ? 14 : 16,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.onSurface,
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Pay Later Card
                Card(
                  elevation: 4,
                  color: Theme.of(context).colorScheme.surface,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        _buildPaymentOption(
                          context,
                          title: 'Pay Later'.tr,
                          logoPath: 'assets/images/cred.png',
                          description: 'Use Pay Later Option to pay at a later date'.tr,
                          onTap: () {
                            isPayLaterExpanded.value = !isPayLaterExpanded.value;
                            if (isWalletExpanded.value) isWalletExpanded.value = false;
                            if (isUpiExpanded.value) isUpiExpanded.value = false;
                            if (isCardsExpanded.value) isCardsExpanded.value = false;
                            if (isNetbankingExpanded.value) isNetbankingExpanded.value = false;
                            if (isQrExpanded.value) isQrExpanded.value = false;
                            if (isBankExpanded.value) isBankExpanded.value = false;
                            if (isEmiExpanded.value) isEmiExpanded.value = false;
                          },
                          isSelected: isPayLaterExpanded.value,
                        ),
                        Obx(
                          () => isPayLaterExpanded.value
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Divider(height: 24),
                                    Text(
                                      'Use Pay Later Option to pay at a later date'.tr,
                                      style: GoogleFonts.poppins(
                                        fontSize: screenWidth < 600 ? 14 : 16,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.onSurface,
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // EMI Card
                Card(
                  elevation: 4,
                  color: Theme.of(context).colorScheme.surface,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        _buildPaymentOption(
                          context,
                          title: 'EMI'.tr,
                          logoPath: 'assets/images/emi.png',
                          description: 'Convert payments into easy EMIs'.tr,
                          onTap: () {
                            isEmiExpanded.value = !isEmiExpanded.value;
                            if (isWalletExpanded.value) isWalletExpanded.value = false;
                            if (isUpiExpanded.value) isUpiExpanded.value = false;
                            if (isCardsExpanded.value) isCardsExpanded.value = false;
                            if (isNetbankingExpanded.value) isNetbankingExpanded.value = false;
                            if (isQrExpanded.value) isQrExpanded.value = false;
                            if (isBankExpanded.value) isBankExpanded.value = false;
                            if (isPayLaterExpanded.value) isPayLaterExpanded.value = false;
                          },
                          isSelected: isEmiExpanded.value,
                        ),
                        Obx(
                          () => isEmiExpanded.value
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Divider(height: 24),
                                    Text(
                                      'Convert payments into easy EMIs'.tr,
                                      style: GoogleFonts.poppins(
                                        fontSize: screenWidth < 600 ? 14 : 16,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.onSurface,
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: SafeArea(
              child: Center(
                child: AnimatedButton(
                  text: checkoutController.isPlacingOrder.value ? 'placing_order'.tr : 'place_order'.tr,
                  onPressed: checkoutController.isPlacingOrder.value ? null : () => checkoutController.placeOrder(),
                  icon: checkoutController.isPlacingOrder.value ? Icons.hourglass_empty : Icons.check_circle,
                  isLoading: checkoutController.isPlacingOrder.value,
                  gradient: const LinearGradient(
                    colors: [Color.fromARGB(255, 75, 120, 218), Color.fromARGB(255, 100, 156, 224)],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(
    BuildContext context, {
    required String title,
    required String logoPath,
    String? amount,
    String? description,
    required VoidCallback? onTap,
    bool isSelected = false,
    double? boxSize,
    bool isTopAligned = false,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: boxSize ?? double.infinity,
        height: boxSize != null ? boxSize * 1.2 : null,
        padding: boxSize != null ? const EdgeInsets.all(3) : const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected && boxSize == null
              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: boxSize != null
              ? Border.all(
                  color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey,
                  width: isSelected ? 2 : 1,
                )
              : null,
        ),
        child: isTopAligned
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    logoPath,
                    width: boxSize != null ? boxSize * 0.5 : (screenWidth < 600 ? 36 : 40),
                    height: boxSize != null ? boxSize * 0.5 : (screenWidth < 600 ? 36 : 40),
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.error,
                      color: Theme.of(context).colorScheme.primary,
                      size: boxSize != null ? boxSize * 0.5 : (screenWidth < 600 ? 36 : 40),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: boxSize != null ? (boxSize < 80 ? 9 : 10) : (screenWidth < 600 ? 14 : 16),
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (amount != null)
                    Text(
                      amount,
                      style: GoogleFonts.poppins(
                        fontSize: boxSize != null ? (boxSize < 80 ? 70 : 8) : (screenWidth < 600 ? 10 : 12),
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    logoPath,
                    width: boxSize != null ? boxSize * 0.4 : (screenWidth < 600 ? 36 : 40),
                    height: boxSize != null ? boxSize * 0.4 : (screenWidth < 600 ? 36 : 40),
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.error,
                      color: Theme.of(context).colorScheme.primary,
                      size: boxSize != null ? boxSize * 0.4 : (screenWidth < 600 ? 36 : 40),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.poppins(
                            fontSize: boxSize != null ? (boxSize < 80 ? 9 : 10) : (screenWidth < 600 ? 14 : 16),
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (amount != null)
                          Text(
                            amount,
                            style: GoogleFonts.poppins(
                              fontSize: boxSize != null ? (boxSize < 80 ? 7 : 8) : (screenWidth < 600 ? 10 : 12),
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        if (description != null)
                          Text(
                            description,
                            style: GoogleFonts.poppins(
                              fontSize: boxSize != null ? (boxSize < 80 ? 7 : 8) : (screenWidth < 600 ? 10 : 12),
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildUpiOption(
    BuildContext context, {
    required String title,
    required String logoPath,
    required double boxSize,
    bool isSeeAll = false,
  }) {
    return GestureDetector(
      onTap: () {
        if (isSeeAll) {
          Get.snackbar('See All', 'Show all UPI options');
        } else {
          Get.snackbar(title, 'Selected $title for UPI payment');
        }
      },
      child: Container(
        width: boxSize,
        height: boxSize,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            isSeeAll
                ? Text(
                    '...',
                    style: GoogleFonts.poppins(
                      fontSize: boxSize < 60 ? 12 : 14,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                : Image.asset(
                    logoPath,
                    width: boxSize * 0.4,
                    height: boxSize * 0.4,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.error,
                      color: Theme.of(context).colorScheme.primary,
                      size: boxSize * 0.4,
                    ),
                  ),
            const SizedBox(height: 2),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: boxSize < 60 ? 8 : 9,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll(RegExp(r'\D'), '');
    String formattedText = '';
    for (int i = 0; i < newText.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formattedText += ' ';
      }
      formattedText += newText[i];
    }
    if (formattedText.length > 19) {
      formattedText = formattedText.substring(0, 19);
    }
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

class _ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (newText.length > 2) {
      newText = '${newText.substring(0, 2)}/${newText.substring(2, newText.length)}';
    }
    if (newText.length > 5) {
      newText = newText.substring(0, 5);
    }
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class AnimatedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final Gradient? gradient;
  final bool isSmall;

  const AnimatedButton({
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.gradient,
    this.isSmall = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final RxBool isTapped = false.obs;
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTapDown: onPressed != null && !isLoading ? (_) => isTapped.value = true : null,
      onTapUp: onPressed != null && !isLoading
          ? (_) {
              isTapped.value = false;
              onPressed!();
            }
          : null,
      onTapCancel: onPressed != null && !isLoading ? () => isTapped.value = false : null,
      child: Obx(
        () => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.bounceOut,
          transform: Matrix4.identity()..scale((isTapped.value && !isLoading) ? 0.95 : 1.0),
          child: Container(
            decoration: BoxDecoration(
              gradient: gradient ??
                  const LinearGradient(
                    colors: [Color.fromARGB(255, 75, 120, 218), Color.fromARGB(255, 113, 117, 218)],
                  ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: isSmall ? (screenWidth < 600 ? 8 : 10) : (screenWidth < 600 ? 10 : 12),
                  horizontal: isSmall ? (screenWidth < 600 ? 16 : 20) : (screenWidth < 600 ? 20 : 24),
                ),
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isLoading) ...[
                    SizedBox(
                      width: screenWidth < 600 ? 14 : 16,
                      height: screenWidth < 600 ? 14 : 16,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),
                    SizedBox(width: screenWidth < 600 ? 6 : 8),
                  ] else if (icon != null) ...[
                    Icon(
                      icon,
                      color: Theme.of(context).colorScheme.onSurface,
                      size: isSmall ? (screenWidth < 600 ? 16 : 18) : (screenWidth < 600 ? 18 : 20),
                    ),
                    SizedBox(width: screenWidth < 600 ? 6 : 8),
                  ],
                  Text(
                    text,
                    style: GoogleFonts.poppins(
                      fontSize: isSmall ? (screenWidth < 600 ? 10 : 12) : (screenWidth < 600 ? 12 : 14),
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}