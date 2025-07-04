import 'package:get/get.dart';

class OrderNowController extends GetxController
{
  final RxString _deliverySystem = "Shipping".obs;
  final RxString _paymentSystem = "Google Pay".obs;

  String get deliverySys => _deliverySystem.value;
  String get paymentSys => _paymentSystem.value;

  setDeliverySystem(String newDeliverySystem)
  {
    _deliverySystem.value = newDeliverySystem;
  }

  setPaymentSystem(String newPaymentSystem)
  {
    _paymentSystem.value = newPaymentSystem;
  }
}