import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreciosScreen extends StatefulWidget {
  const PreciosScreen({super.key});

  @override
  State<PreciosScreen> createState() => _PreciosScreenState();
}

class _PreciosScreenState extends State<PreciosScreen> {
  // Llave global para manejar las validaciones del formulario
  final _formKey = GlobalKey<FormState>();

  // Controladores para leer lo que el usuario escribe
  final TextEditingController _nombrePerfumeController = TextEditingController();
  final TextEditingController _precio3mlController = TextEditingController();
  final TextEditingController _precio5mlController = TextEditingController();
  final TextEditingController _precio10mlController = TextEditingController();

  // Lógica y diseño del Dialog de Cierre de Sesión
  void _mostrarDialogoCerrarSesion(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Cierre de Sesión',
            style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold),
          ),
          content: const Text(
            '¿Estás seguro de que deseas cerrar sesión?',
            style: TextStyle(fontFamily: 'Roboto', fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancelar',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();

                if (context.mounted) {
                  Navigator.of(context).pop();
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                }
              },
              child: const Text(
                'Cerrar Sesión',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Función que se ejecuta al presionar el botón azul
  void _guardarPrecios() {
    // 1. Ocultar el teclado automáticamente al presionar el botón
    FocusScope.of(context).unfocus();

    // 2. Validamos que ningún campo esté vacío
    if (_formKey.currentState!.validate()) {
      final nombrePerfume = _nombrePerfumeController.text;
      final precio3ml = _precio3mlController.text;
      final precio5ml = _precio5mlController.text;
      final precio10ml = _precio10mlController.text;

      // Mostramos el mensaje flotante de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Precios guardados para $nombrePerfume\n3ml: \$$precio3ml | 5ml: \$$precio5ml | 10ml: \$$precio10ml'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating, // Hace que el mensaje flote sobre los elementos
          margin: const EdgeInsets.all(20),
        ),
      );
      
      // Opcional: Limpiar los campos después de guardar
      // _nombrePerfumeController.clear();
      // _precio3mlController.clear();
      // _precio5mlController.clear();
      // _precio10mlController.clear();
    } else {
      // Si hay algún error (campos vacíos), mostramos una alerta flotante
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, completa todos los campos correctamente.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(20),
        ),
      );
    }
  }

  @override
  void dispose() {
    // Limpiamos la memoria de los controladores
    _nombrePerfumeController.dispose();
    _precio3mlController.dispose();
    _precio5mlController.dispose();
    _precio10mlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Precios de Medidas',
          style: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            color: Colors.white,
            tooltip: 'Cerrar Sesión',
            onPressed: () => _mostrarDialogoCerrarSesion(context),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView( 
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey, 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nombre del Perfume:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
                ),
                const SizedBox(height: 8),
                
                // Campo para el nombre del perfume
                TextFormField(
                  controller: _nombrePerfumeController,
                  decoration: InputDecoration(
                    hintText: 'Ej. Bleu de Chanel',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Este campo no puede estar vacío';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 30),

                // Campos de texto para los precios
                _crearCampoPrecio('Precio 3ml', _precio3mlController),
                const SizedBox(height: 20),
                _crearCampoPrecio('Precio 5ml', _precio5mlController),
                const SizedBox(height: 20),
                _crearCampoPrecio('Precio 10ml', _precio10mlController),
                
                const SizedBox(height: 40),

                // Botón azul para guardar
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _guardarPrecios,
                    child: const Text(
                      'Guardar Precios',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget reutilizable para crear los campos de precio
  Widget _crearCampoPrecio(String label, TextEditingController controller) {
    return TextFormField( 
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true), 
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')), 
      ],
      decoration: InputDecoration(
        labelText: label,
        prefixText: '\$ ', 
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Este campo no puede estar vacío';
        }
        return null;
      },
    );
  }
}