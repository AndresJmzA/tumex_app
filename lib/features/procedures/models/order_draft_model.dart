import 'package:cloud_firestore/cloud_firestore.dart';

// Based on the 'itemInCart' schema
class ItemInCart {
  final DocumentReference itemID; // Doc Reference (Products)
  final int defaultQuantity;
  final String category;
  final int? choiceGroup;
  final bool isDefault;
  final bool fromTemplateItem;

  ItemInCart({
    required this.itemID,
    required this.defaultQuantity,
    required this.category,
    this.choiceGroup,
    required this.isDefault,
    required this.fromTemplateItem,
  });

  // Note: We'll need fromJson/toJson for any persistence,
  // but for pure state management, it's not strictly required yet.
}

// Based on the 'OrderDraftDataType' schema
class OrderDraft {
  final List<ItemInCart> cartItems;
  final List<ItemInCart>
      allTemplateItems; // Holds all possible items for the UI
  final DocumentReference selectedProcedurePackageRef;
  final DateTime? rentalDate;
  // final CoverageType? typeOfCoverage; // Placeholder for now

  OrderDraft({
    required this.cartItems,
    required this.selectedProcedurePackageRef,
    required this.allTemplateItems,
    this.rentalDate,
    // this.typeOfCoverage,
  });

  OrderDraft copyWith({
    List<ItemInCart>? cartItems,
    DocumentReference? selectedProcedurePackageRef,
    List<ItemInCart>? allTemplateItems,
    DateTime? rentalDate,
  }) {
    return OrderDraft(
      cartItems: cartItems ?? this.cartItems,
      selectedProcedurePackageRef:
          selectedProcedurePackageRef ?? this.selectedProcedurePackageRef,
      allTemplateItems: allTemplateItems ?? this.allTemplateItems,
      rentalDate: rentalDate ?? this.rentalDate,
    );
  }
}
