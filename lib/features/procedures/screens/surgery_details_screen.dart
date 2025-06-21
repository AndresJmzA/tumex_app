import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tumex_users_app/features/procedures/providers/order_draft_provider.dart';
import 'package:tumex_users_app/features/profile/models/address_model.dart';
import 'package:tumex_users_app/features/profile/services/profile_service.dart';

// --- NEW: Provider to fetch user addresses ---
final userAddressesProvider = StreamProvider<List<Address>>((ref) {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) {
    return Stream.value([]);
  }
  return ref.watch(profileServiceProvider).getUserAddresses(userId);
});

class SurgeryDetailsScreen extends ConsumerStatefulWidget {
  const SurgeryDetailsScreen({super.key});

  @override
  ConsumerState<SurgeryDetailsScreen> createState() =>
      _SurgeryDetailsScreenState();
}

class _SurgeryDetailsScreenState extends ConsumerState<SurgeryDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _patientNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _patientNameController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderNotifier = ref.read(orderDraftProvider.notifier);
    final addressesAsync = ref.watch(userAddressesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de la Cirugía'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Date Picker
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Fecha de la cirugía',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    _dateController.text =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    orderNotifier.updateSurgeryDate(pickedDate);
                  }
                },
                validator: (value) =>
                    value!.isEmpty ? 'Por favor, selecciona una fecha' : null,
              ),

              const SizedBox(height: 16),

              // Time Picker
              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(
                  labelText: 'Hora de la cirugía',
                  suffixIcon: Icon(Icons.access_time),
                ),
                readOnly: true,
                onTap: () async {
                  final pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          timePickerTheme: TimePickerThemeData(
                            backgroundColor: Colors.white,
                            hourMinuteTextColor: Theme.of(context).primaryColor,
                            dayPeriodTextColor: Colors.black,
                          ),
                        ),
                        child: child ?? const SizedBox(),
                      );
                    },
                  );
                  if (pickedTime != null) {
                    _timeController.text = pickedTime.format(context);
                    orderNotifier.updateSurgeryTime(pickedTime.format(context));
                  }
                },
                validator: (value) =>
                    value!.isEmpty ? 'Por favor, selecciona una hora' : null,
              ),

              const SizedBox(height: 16),

              // Patient Name
              TextFormField(
                controller: _patientNameController,
                decoration:
                    const InputDecoration(labelText: 'Nombre del paciente'),
                onChanged: orderNotifier.updatePatientName,
                validator: (value) =>
                    value!.isEmpty ? 'Por favor, ingresa un nombre' : null,
              ),

              const SizedBox(height: 16),

              // Type of Coverage
              DropdownButtonFormField<String>(
                decoration:
                    const InputDecoration(labelText: 'Tipo de cobertura'),
                items: ['Privado', 'Seguro']
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    orderNotifier.updateTypeOfCoverage(value);
                  }
                },
                validator: (value) =>
                    value == null ? 'Por favor, selecciona un tipo' : null,
              ),

              const SizedBox(height: 16),

              // Address
              addressesAsync.when(
                data: (addresses) {
                  if (addresses.isEmpty) {
                    return Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Dirección',
                            hintText: 'No tienes direcciones guardadas',
                          ),
                          readOnly: true,
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // TODO: Navigate to Add/Manage Addresses Screen
                            },
                            child: const Text('Añadir nueva dirección'),
                          ),
                        ),
                      ],
                    );
                  }

                  final defaultAddress = addresses.firstWhere(
                    (a) => a.isDefault,
                    orElse: () =>
                        addresses.first, // Guaranteed to have a first now
                  );

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (ref.read(orderDraftProvider)?.surgeryAddress == null) {
                      orderNotifier
                          .updateSurgeryAddress(defaultAddress.toString());
                    }
                  });

                  return Column(
                    children: [
                      DropdownButtonFormField<Address>(
                        value: defaultAddress,
                        decoration:
                            const InputDecoration(labelText: 'Dirección'),
                        items: addresses
                            .map((address) => DropdownMenuItem(
                                  value: address,
                                  child: Text(address.toString(),
                                      overflow: TextOverflow.ellipsis),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            orderNotifier
                                .updateSurgeryAddress(value.toString());
                          }
                        },
                        validator: (value) => value == null
                            ? 'Por favor, selecciona una dirección'
                            : null,
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // TODO: Navigate to Add/Manage Addresses Screen
                          },
                          child: const Text('Añadir o gestionar direcciones'),
                        ),
                      ),
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) =>
                    const Text('No se pudieron cargar las direcciones'),
              ),

              const SizedBox(height: 16),

              // Notes
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notas adicionales',
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                onChanged: orderNotifier.updateNotes,
              ),

              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // TODO: Navigate to summary screen
                  }
                },
                child: const Text('Continuar a Resumen'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
