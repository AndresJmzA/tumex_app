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
  final DateTime? surgeryDate;
  final String? surgeryTime;
  final String? typeOfCoverage;
  final String? surgeryAddress;
  final String? patientName;
  final String? notes;

  OrderDraft({
    required this.cartItems,
    required this.selectedProcedurePackageRef,
    required this.allTemplateItems,
    this.rentalDate,
    this.surgeryDate,
    this.surgeryTime,
    this.typeOfCoverage,
    this.surgeryAddress,
    this.patientName,
    this.notes,
  });

  OrderDraft copyWith({
    List<ItemInCart>? cartItems,
    DocumentReference? selectedProcedurePackageRef,
    List<ItemInCart>? allTemplateItems,
    DateTime? rentalDate,
    DateTime? surgeryDate,
    String? surgeryTime,
    String? typeOfCoverage,
    String? surgeryAddress,
    String? patientName,
    String? notes,
  }) {
    return OrderDraft(
      cartItems: cartItems ?? this.cartItems,
      selectedProcedurePackageRef:
          selectedProcedurePackageRef ?? this.selectedProcedurePackageRef,
      allTemplateItems: allTemplateItems ?? this.allTemplateItems,
      rentalDate: rentalDate ?? this.rentalDate,
      surgeryDate: surgeryDate ?? this.surgeryDate,
      surgeryTime: surgeryTime ?? this.surgeryTime,
      typeOfCoverage: typeOfCoverage ?? this.typeOfCoverage,
      surgeryAddress: surgeryAddress ?? this.surgeryAddress,
      patientName: patientName ?? this.patientName,
      notes: notes ?? this.notes,
    );
  }
}
