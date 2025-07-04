class API {
  static const hostConnect = "http://127.0.0.1/api_haute_attires";
  static const hostConnectUser = "$hostConnect/user";
  static const hostConnectAdmin = "$hostConnect/admin";
  static const hostItem = "$hostConnect/items";
  static const hostClothes = "$hostConnect/clothes";
  static const hostCart = "$hostConnect/cart";
  static const hostFavorite = "$hostConnect/favorite";
  static const hostOrder = "$hostConnect/order";
  static const hostCategories = "$hostConnect/categories";

  //signUp-login user
  static const validateEmail = "$hostConnectUser/validate_email.php";
  static const signUp = "$hostConnectUser/signup.php";
  static const login = "$hostConnectUser/login.php";
  static const user = "$hostConnectUser/user.php";


  //login admin
  static const adminLogin = "$hostConnectAdmin/login.php";
  static const adminGetAllOrders = "$hostConnectAdmin/read_orders.php";

  //items
  static const uploadNewItem = "$hostItem/upload.php";
  static const searchItems = "$hostItem/search.php";
  static const updateItems = "$hostItem/update.php";
  static const deleteItems = "$hostItem/delete.php";

  //Clothes
  static const getTrendingMostPopularClothes = "$hostClothes/trending.php";
  static const getAllClothes = "$hostClothes/all.php";

  //cart
  static const addToCart = "$hostCart/add.php";
  static const getCartList = "$hostCart/read.php";
  static const deleteSelectedItemsFromCartList = "$hostCart/delete.php";
  static const updateItemInCartList = "$hostCart/update.php";

  //favorite
  static const validateFavorite = "$hostFavorite/validate_favorite.php";
  static const addFavorite = "$hostFavorite/add.php";
  static const deleteFavorite = "$hostFavorite/delete.php";
  static const readFavorite = "$hostFavorite/read.php";

  //order
  static const addOrder = "$hostOrder/add.php";
  static const readOrders = "$hostOrder/read.php";
  static const readCancelOrders = "$hostOrder/get_cancel.php";
  static const readOldOrders = "$hostOrder/get_old.php";
  static const allNew = "$hostOrder/all_new.php";
  static const allCancel = "$hostOrder/all_cancel.php";
  static const allOld = "$hostOrder/all_old.php";
  static const updateStatusOld= "$hostOrder/update_status_old.php";
  static const updateStatusCancel = "$hostOrder/update_status_cancel.php";
  static const addCancelTable = "$hostOrder/cancel_table_add.php";
  static const readCancelTable = "$hostOrder/cancel_table_read.php";
  static const allOrderTable = "$hostOrder/all_orders_table.php";

  //categories
  static const categoriesItems = "$hostCategories/categories.php";

}
