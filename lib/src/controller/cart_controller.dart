import 'package:get/get.dart';
import 'package:very_supply_api_client/models/catalogue/asset.dart';
import 'package:very_supply_api_client/models/trade/offer.dart';
import 'package:very_supply_api_client/models/trade/transaction_template_entry.dart';


class CartController extends GetxController {
  RxMap<Offer, int> cart = <Offer, int>{}.obs;
  RxMap<Asset, int> totalPrice = <Asset, int>{}.obs;

  void increaseItem(Offer offer) {
    cart[offer] = cart[offer]!+ 1;
    calculateTotalPrice();
  }


  void decreaseItem(Offer offer) {
    if (cart[offer]! > 1) {
      cart[offer] = cart[offer]! - 1;
      calculateTotalPrice();
    }
  }

  void addItemToCart(Offer offer) {
    cart[offer] = 1;
    calculateTotalPrice();
  }

  void removeItemFromCart(Offer offer) {
    cart.remove(offer);
    calculateTotalPrice();
  }


  void calculateTotalPrice() {
    Map<Asset, int> result = {};
    for (MapEntry<Offer, int> cartEntry in cart.entries) {
      for (TransactionTemplateEntry tte in cartEntry.key.incomeTransactionTemplate.entries) {
        result[tte.asset] ??= 0;
        result[tte.asset] = result[tte.asset]! + cartEntry.value * tte.amount;
      }
    }
    totalPrice.value = result;
    update();
  }
}