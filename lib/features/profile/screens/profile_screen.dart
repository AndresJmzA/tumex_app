import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tumex_users_app/features/auth/services/auth_service.dart';
import 'package:tumex_users_app/features/profile/services/profile_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tumex_users_app/features/profile/models/user_model.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;

  bool _isEditing = false;
  bool _isLoading = false;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _loadUserData(UserModel user) {
    _nameController.text = user.displayName ?? '';
    _lastNameController.text = user.lastName ?? '';
    _phoneController.text = user.phoneNumber ?? '';
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = ref.read(firebaseAuthProvider).currentUser;
      if (user == null) throw Exception('No authenticated user found.');

      String? photoUrl;
      // 1. Upload new image if selected
      if (_imageFile != null) {
        final storageRef = FirebaseStorage.instance.ref().child(
          'users/${user.uid}/profile_image.jpg',
        );
        final uploadTask = storageRef.putFile(_imageFile!);
        final snapshot = await uploadTask.whenComplete(() {});
        photoUrl = await snapshot.ref.getDownloadURL();
      }

      // 2. Prepare data for Firestore
      final dataToUpdate = {
        'display_name': _nameController.text.trim(),
        'last_name': _lastNameController.text.trim(),
        'phone_number': _phoneController.text.trim(),
        if (photoUrl != null) 'photo_url': photoUrl,
      };

      // 3. Update Firestore
      await ref
          .read(profileServiceProvider)
          .updateUserData(user.uid, dataToUpdate);

      // 4. Update Firebase Auth profile
      if (photoUrl != null) await user.updatePhotoURL(photoUrl);
      await user.updateDisplayName(_nameController.text.trim());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil actualizado exitosamente')),
      );

      setState(() => _isEditing = false);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al actualizar perfil: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authUser = ref.watch(firebaseAuthProvider).currentUser;
    if (authUser == null) {
      return const Scaffold(
        body: Center(child: Text('Usuario no autenticado')),
      );
    }

    final userState = ref.watch(userProvider(authUser.uid));

    return userState.when(
      data: (userModel) {
        if (userModel == null) {
          return const Scaffold(
            body: Center(
              child: Text('No se pudieron cargar los datos del perfil.'),
            ),
          );
        }

        // Load data into controllers only once when the view is built or editing is cancelled.
        if (!_isEditing) {
          _loadUserData(userModel);
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Mi Perfil'),
            actions: [
              if (_isEditing)
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => setState(() => _isEditing = false),
                )
              else
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => setState(() => _isEditing = true),
                ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Profile Picture
                  GestureDetector(
                    onTap: _isEditing ? _pickImage : null,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Theme.of(
                            context,
                          ).primaryColor.withOpacity(0.1),
                          backgroundImage:
                              _imageFile != null
                                  ? FileImage(_imageFile!)
                                  : (userModel.photoUrl != null &&
                                              userModel.photoUrl!.isNotEmpty
                                          ? NetworkImage(userModel.photoUrl!)
                                          : null)
                                      as ImageProvider?,
                          child:
                              _imageFile == null &&
                                      (userModel.photoUrl == null ||
                                          userModel.photoUrl!.isEmpty)
                                  ? Icon(
                                    Icons.person,
                                    size: 50,
                                    color: Theme.of(context).primaryColor,
                                  )
                                  : null,
                        ),
                        if (_isEditing)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: Theme.of(context).primaryColor,
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ID and Email (Read-only)
                  _buildInfoCard(
                    context,
                    'ID de Usuario',
                    userModel.customId,
                    Icons.badge,
                  ),
                  _buildInfoCard(
                    context,
                    'Correo Electrónico',
                    userModel.email ?? '',
                    Icons.email,
                  ),

                  const SizedBox(height: 16),

                  // Editable Fields
                  _buildEditableTextField(
                    controller: _nameController,
                    label: 'Nombre(s)',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 16),
                  _buildEditableTextField(
                    controller: _lastNameController,
                    label: 'Apellidos',
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 16),
                  _buildEditableTextField(
                    controller: _phoneController,
                    label: 'Teléfono',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),

                  const SizedBox(height: 24),

                  if (_isEditing)
                    ElevatedButton(
                      onPressed: _isLoading ? null : _saveProfile,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child:
                          _isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text('Guardar Cambios'),
                    ),
                ],
              ),
            ),
          ),
        );
      },
      loading:
          () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
      error:
          (error, stack) =>
              Scaffold(body: Center(child: Text('Error: $error'))),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
  ) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
      ),
    );
  }

  Widget _buildEditableTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      enabled: _isEditing,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        filled: !_isEditing,
        fillColor: Theme.of(context).disabledColor.withOpacity(0.05),
      ),
      keyboardType: keyboardType,
      validator: (value) {
        if (label.contains('Nombre') || label.contains('Apellidos')) {
          if (value == null || value.trim().isEmpty) {
            return 'Este campo no puede estar vacío';
          }
        }
        return null;
      },
    );
  }
}
