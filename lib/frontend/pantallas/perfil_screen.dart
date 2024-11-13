import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:baymind/frontend/widgets/colors.dart';

class PerfilScreen extends StatefulWidget {
  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  TextEditingController _nameController = TextEditingController();
  DateTime? _birthDate;
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _nameController.text = "Nombre";
  }

  // Método para seleccionar imagen de la galería
  Future<void> _selectProfileImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  // Método para seleccionar fecha de nacimiento
  Future<void> _selectBirthDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(Duration(days: 365 * 18)), // Mayor de 18 años
      firstDate: DateTime(1900),
      lastDate: DateTime.now().subtract(Duration(days: 365 * 18)),
    );

    if (pickedDate != null) {
      setState(() {
        _birthDate = pickedDate;
      });
    }
  }

  // Método para cerrar sesión (simulación)
  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cerrar Sesión" ),
        content: const Text("¿Estás seguro de que deseas cerrar sesión?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Salir"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil",style:
                TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Manrope', color: AppColors.morado)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Imagen de Perfil
            GestureDetector(
              onTap: _selectProfileImage,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[300],
                backgroundImage:
                    _profileImage != null ? FileImage(_profileImage!) : null,
                child: _profileImage == null
                    ? const Icon(Icons.add_a_photo, size: 40, color: Colors.grey)
                    : null,
              ),
            ),
            const SizedBox(height: 20),

            // Campo para cambiar el nombre
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Nombre",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Selección de Fecha de Nacimiento
            Row(
              children: [
                Expanded(
                  child: Text(
                    _birthDate == null
                        ? "Fecha de Nacimiento"
                        : "Fecha de Nacimiento: ${DateFormat('dd/MM/yyyy').format(_birthDate!)}",
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _selectBirthDate,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Activar/Desactivar Notificaciones
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Activar Notificaciones"),
                Switch(
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Botón de Cerrar Sesión
            ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text("Cerrar Sesión",style:
                TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Manrope', color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
