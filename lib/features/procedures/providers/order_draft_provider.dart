import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumex_users_app/features/procedures/models/order_draft_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// The StateNotifier class
class OrderDraftNotifier extends StateNotifier<OrderDraft?> {
  OrderDraftNotifier() : super(null);

  // Initializes a new draft, replacing any existing one
  void startDraft({
    required DocumentReference procedureRef,
    required List<ItemInCart> initialItems,
    required List<ItemInCart> allTemplateItems,
  }) {
    state = OrderDraft(
      selectedProcedurePackageRef: procedureRef,
      cartItems: initialItems,
      allTemplateItems: allTemplateItems,
    );
  }

  // Adds an item to the cart
  void addItem(ItemInCart item) {
    if (state == null) return;
    state = state!.copyWith(
      cartItems: [...state!.cartItems, item],
    );
  }

  // Removes an item from the cart by its reference
  void removeItem(DocumentReference itemRef) {
    if (state == null) return;
    state = state!.copyWith(
      cartItems:
          state!.cartItems.where((item) => item.itemID != itemRef).toList(),
    );
  }

  // Updates the quantity of a specific item
  void updateItemQuantity(DocumentReference itemRef, int newQuantity) {
    if (state == null) return;

    // If quantity is zero or less, remove the item
    if (newQuantity <= 0) {
      removeItem(itemRef);
      return;
    }

    state = state!.copyWith(
      cartItems: state!.cartItems.map((item) {
        if (item.itemID == itemRef) {
          // This is a workaround since ItemInCart is immutable.
          // A better approach would be for ItemInCart to also have a copyWith method.
          return ItemInCart(
            itemID: item.itemID,
            defaultQuantity:
                newQuantity, // This field should probably be renamed to just `quantity`
            category: item.category,
            isDefault: item.isDefault,
            fromTemplateItem: item.fromTemplateItem,
            choiceGroup: item.choiceGroup,
          );
        }
        return item;
      }).toList(),
    );
  }

  // Swaps an item from a choice group
  void selectChoiceOption({
    required ItemInCart newOption,
    required int choiceGroupId,
  }) {
    if (state == null) return;

    // Get all items that are NOT part of the choice group being changed
    final otherItems = state!.cartItems.where((item) {
      return item.choiceGroup != choiceGroupId;
    }).toList();

    // Create the new state
    state = state!.copyWith(
      cartItems: [...otherItems, newOption],
    );
  }

  // --- NEW: Methods to update surgery details ---

  void updateSurgeryDate(DateTime date) {
    if (state == null) return;
    state = state!.copyWith(surgeryDate: date);
  }

  void updateSurgeryTime(String time) {
    if (state == null) return;
    state = state!.copyWith(surgeryTime: time);
  }

  void updateTypeOfCoverage(String coverage) {
    if (state == null) return;
    state = state!.copyWith(typeOfCoverage: coverage);
  }

  void updateSurgeryAddress(String address) {
    if (state == null) return;
    state = state!.copyWith(surgeryAddress: address);
  }

  void updatePatientName(String name) {
    if (state == null) return;
    state = state!.copyWith(patientName: name);
  }

  void updateNotes(String notes) {
    if (state == null) return;
    state = state!.copyWith(notes: notes);
  }

  // Clears the entire draft
  void clearDraft() {
    state = null;
  }
}

// The StateNotifierProvider
final orderDraftProvider =
    StateNotifierProvider<OrderDraftNotifier, OrderDraft?>((ref) {
  return OrderDraftNotifier();
});
