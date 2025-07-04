import 'package:haute_attires/users/model/cart.dart';
import 'package:get/get.dart';

class CartListController extends GetxController {
  final RxList<Cart> _cartlist = <Cart>[].obs; //user all items in cart + record //5
  final RxList<int> _selectedItemList = <int>[].obs; //user selected items for which user want to proceed and want to place final order //2
  final RxBool _isSelectedAll = false.obs;
  final RxDouble _total = 0.0.obs;

  List<Cart> get cartList => _cartlist.value;
  List<int> get selectedItemList => _selectedItemList.value;
  bool get isSelectedAll => _isSelectedAll.value;
  double get total => _total.value;

  setList(List<Cart> list) {
    _cartlist.value = list;
  }

  addSelectedItem(int selectedItemCartID) {
    _selectedItemList.value.add(selectedItemCartID);
    update();
  }

  deleteSelectedItem(int selectedItemCartID) {
    _selectedItemList.value.remove(selectedItemCartID);
    update();
  }

  setIsSelectedAllItems() {
    //true
    _isSelectedAll.value = !_isSelectedAll.value;
  }

  clearAllSelectedItems() {
    _selectedItemList.value.clear();
    update();
  }

  void setTotal(double overallTotal) {
    _total.value = overallTotal;
      print("Total set in controller: $_total");
  }
}
