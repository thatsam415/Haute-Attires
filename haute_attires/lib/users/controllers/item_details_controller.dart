import 'package:get/get.dart';

class ItemDetailsController extends GetxController {
  final RxInt _quantityItem = 1.obs;
  final RxInt _sizeItem = 0.obs;
  final RxInt _colorItem = 0.obs;
  final RxBool _isFavorite = false.obs;

  int get quantity => _quantityItem.value;
  int get size => _sizeItem.value;
  int get color => _colorItem.value;
  bool get isFavorite => _isFavorite.value;

  setQuantityItem(int quantityOfItem) {
    _quantityItem.value = quantityOfItem;
  }

  setSizeItem(int sizeOfItem) {
    _sizeItem.value = sizeOfItem;
  }

  setColorItem(int colorOfItem) {
    _colorItem.value = colorOfItem;
  }

  setIsFavorite(bool isFavorite) {
    _isFavorite.value = isFavorite;
  }
}
