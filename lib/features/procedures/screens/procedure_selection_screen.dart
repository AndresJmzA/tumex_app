import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumex_users_app/features/procedures/models/order_draft_model.dart';
import 'package:tumex_users_app/features/procedures/providers/order_draft_provider.dart';
import 'package:tumex_users_app/features/procedures/services/procedure_service.dart';
import 'package:tumex_users_app/features/products/providers/product_provider.dart';
import 'package:tumex_users_app/features/procedures/screens/add_items_screen.dart';

class ProcedureSelectionScreen extends ConsumerStatefulWidget {
  const ProcedureSelectionScreen({super.key});

  @override
  ConsumerState<ProcedureSelectionScreen> createState() =>
      _ProcedureSelectionScreenState();
}

class _ProcedureSelectionScreenState
    extends ConsumerState<ProcedureSelectionScreen> {
  DocumentReference? _selectedSurgeryRef;

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(orderDraftProvider);

    if (draft != null) {
      final uiElements = <dynamic>[];
      final processedChoiceGroupIds = <int>{};

      // Process all items in the cart to build the UI list
      for (final cartItem in draft.cartItems) {
        if (cartItem.choiceGroup != null) {
          final groupId = cartItem.choiceGroup!;
          if (!processedChoiceGroupIds.contains(groupId)) {
            // Find all options for this group from the master template list
            final groupOptions = draft.allTemplateItems
                .where((item) => item.choiceGroup == groupId)
                .toList();
            uiElements.add(groupOptions);
            processedChoiceGroupIds.add(groupId);
          }
        } else {
          // It's a single item, just add it to the list
          uiElements.add(cartItem);
        }
      }

      // Now group the UI elements by category
      final Map<String, List<dynamic>> categorizedItemsForUI = {};
      for (final element in uiElements) {
        final category = (element is List<ItemInCart>)
            ? element.first.category
            : (element as ItemInCart).category;
        categorizedItemsForUI
            .putIfAbsent(category ?? 'Sin categoría', () => [])
            .add(element);
      }

      final sortedCategories = categorizedItemsForUI.keys.toList();
      sortedCategories.sort((a, b) {
        if (a.toLowerCase() == 'equipo') return -1;
        if (b.toLowerCase() == 'equipo') return 1;
        return a.compareTo(b);
      });

      return Scaffold(
        appBar: AppBar(
          title: const Text('Solicitar Paquete'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Elige la cirugía y procedimiento a realizar',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 24),
                      DropdownSearch<DocumentSnapshot>(
                        asyncItems: (String filter) =>
                            ref.read(procedureServiceProvider).getSurgeries(),
                        itemAsString: (DocumentSnapshot doc) =>
                            doc['surgeryName'] as String,
                        onChanged: (DocumentSnapshot? data) {
                          setState(() => _selectedSurgeryRef = data?.reference);
                          ref.read(orderDraftProvider.notifier).clearDraft();
                        },
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                              labelText: "Tipo de cirugía",
                              hintText: "Selecciona la cirugía"),
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownSearch<DocumentSnapshot>(
                        asyncItems: (String filter) async {
                          if (_selectedSurgeryRef == null) return [];
                          return ref
                              .read(procedureServiceProvider)
                              .getProceduresForSurgery(_selectedSurgeryRef!);
                        },
                        itemAsString: (DocumentSnapshot doc) =>
                            doc['procedureName'] as String,
                        onChanged: (DocumentSnapshot? data) {
                          if (data == null) return;
                          _loadTemplateItems(data.reference);
                        },
                        enabled: _selectedSurgeryRef != null,
                        popupProps: PopupProps.menu(
                            constraints: const BoxConstraints(maxHeight: 224)),
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                              labelText: "Tipo de procedimiento",
                              hintText: "Selecciona el procedimiento"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (draft != null)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: sortedCategories.length,
                  itemBuilder: (context, index) {
                    final category = sortedCategories[index];
                    final items = categorizedItemsForUI[category]!;
                    final formattedCategory = category.isNotEmpty
                        ? category[0].toUpperCase() + category.substring(1)
                        : '';

                    return ExpansionTile(
                      title: Row(
                        children: [
                          Text(formattedCategory,
                              style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(width: 16),
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Text(
                              items.length.toString(),
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      initiallyExpanded: true,
                      children: items.map<Widget>((item) {
                        if (item is List<ItemInCart>) {
                          return _ChoiceGroupCard(options: item);
                        } else if (item is ItemInCart) {
                          final itemFromCart = draft.cartItems.firstWhere(
                              (ci) => ci.itemID == item.itemID,
                              orElse: () => item);
                          return _ItemCard(item: itemFromCart);
                        }
                        return const SizedBox.shrink();
                      }).toList(),
                    );
                  },
                ),
            ],
          ),
        ),
        bottomNavigationBar: (draft?.cartItems.isNotEmpty ?? false)
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirmación'),
                            content: const Text(
                                '¿Estás seguro de que deseas continuar con esta selección?'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Cancelar',
                                    style: TextStyle(color: Colors.red)),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Dismiss the dialog
                                },
                              ),
                              ElevatedButton(
                                // Changed from OutlinedButton
                                child: const Text('Aceptar'),
                                // The ElevatedButton will use the default primary color from the theme.
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Dismiss the dialog
                                  // TODO: Navigate to the next screen (Phase 3: Surgery Details)
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text('Siguiente')),
              )
            : null,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AddItemsScreen()));
          },
          child: const Icon(Icons.add),
        ),
      );
    }
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> _loadTemplateItems(DocumentReference procedureRef) async {
    // --- START DEBUG LOGS ---
    print('🔄 Loading template items for procedure: ${procedureRef.path}');

    try {
      final templateDocs = await ref
          .read(procedureServiceProvider)
          .getTemplateItemsForProcedure(procedureRef);

      final allTemplateItems = templateDocs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ItemInCart(
          itemID: data['product_ref'],
          defaultQuantity: data['quantity'] ?? 1,
          category: data['category'],
          choiceGroup: data['choiceGroup'],
          isDefault: data['isDefault'] ?? false, // Ensure false if null
          fromTemplateItem: true,
        );
      }).toList();

      final Map<int, List<ItemInCart>> choiceGroups = {};
      final List<ItemInCart> singleItems = [];

      for (final item in allTemplateItems) {
        if (item.choiceGroup != null) {
          choiceGroups.putIfAbsent(item.choiceGroup!, () => []).add(item);
        } else {
          singleItems.add(item);
        }
      }

      final initialDraftItems = <ItemInCart>[...singleItems];
      for (final groupOptions in choiceGroups.values) {
        final defaultOption = groupOptions.firstWhere((opt) => opt.isDefault,
            orElse: () => groupOptions.first);
        initialDraftItems.add(defaultOption);
      }

      ref.read(orderDraftProvider.notifier).startDraft(
            procedureRef: procedureRef,
            initialItems: initialDraftItems,
            allTemplateItems: allTemplateItems,
          );
    } catch (e, stacktrace) {
      print('🔥 CRITICAL ERROR in _loadTemplateItems: $e');
      print(stacktrace);
    }
  }
}

// --- WIDGET FOR A GROUP OF RADIO BUTTONS ---
class _ChoiceGroupCard extends ConsumerWidget {
  final List<ItemInCart> options;
  const _ChoiceGroupCard({required this.options});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(orderDraftProvider)!;
    final choiceGroupId = options.first.choiceGroup!;

    // Find which option is currently selected in the cart
    final selectedOption = draft.cartItems.firstWhere(
      (item) => item.choiceGroup == choiceGroupId,
    );

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: options.map((option) {
            final productAsync = ref.watch(productProvider(option.itemID));
            return productAsync.when(
              data: (product) => RadioListTile<DocumentReference>(
                title: Text(product.name),
                value: option.itemID,
                groupValue: selectedOption.itemID,
                onChanged: (value) {
                  ref.read(orderDraftProvider.notifier).selectChoiceOption(
                        newOption: option,
                        choiceGroupId: choiceGroupId,
                      );
                },
              ),
              loading: () => const ListTile(title: Text('Cargando opción...')),
              error: (err, stack) => ListTile(title: Text('Error: $err')),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// --- Dedicated Widget for the Item Card ---
class _ItemCard extends ConsumerWidget {
  final ItemInCart item;

  const _ItemCard({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productProvider(item.itemID));

    return productAsync.when(
      data: (product) => Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  product.imageUrl ?? '',
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stack) =>
                      const Icon(Icons.image_not_supported, size: 60),
                ),
              ),
              const SizedBox(width: 16),
              // Name
              Expanded(
                child: Text(product.name,
                    style: Theme.of(context).textTheme.bodyLarge),
              ),
              const SizedBox(width: 16),
              // Quantity Modifier
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      if (item.defaultQuantity > 1) {
                        // If quantity is more than 1, just decrease it.
                        ref
                            .read(orderDraftProvider.notifier)
                            .updateItemQuantity(
                                item.itemID, item.defaultQuantity - 1);
                      } else {
                        // If quantity is 1, show confirmation dialog before removing.
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Eliminar Artículo'),
                              content: const Text(
                                  '¿Estás seguro de que quieres eliminar este artículo?'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Cancelar'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('Eliminar',
                                      style: TextStyle(color: Colors.red)),
                                  onPressed: () {
                                    // Use removeItem which is cleaner for this operation.
                                    ref
                                        .read(orderDraftProvider.notifier)
                                        .removeItem(item.itemID);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),
                  Text(item.defaultQuantity.toString(),
                      style: Theme.of(context).textTheme.titleMedium),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () {
                      ref.read(orderDraftProvider.notifier).updateItemQuantity(
                          item.itemID, item.defaultQuantity + 1);
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => ListTile(title: Text('Error: ${err.toString()}')),
    );
  }
}
