import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/login_screen.dart';
import 'screens/precios_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  

  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(initialRoute: isLoggedIn ? '/precios' : '/login'));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Escencity App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32)),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      initialRoute: initialRoute,
      routes: {
        '/login': (context) => const LoginScreen(),
        '/precios': (context) => const PreciosScreen(),
      },
    );
  }
}



class RegistroBotellasScreen extends StatefulWidget {
  const RegistroBotellasScreen({super.key});

  @override
  State<RegistroBotellasScreen> createState() => _RegistroBotellasScreenState();
}

class _RegistroBotellasScreenState extends State<RegistroBotellasScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controladores para capturar el texto de los campos
  final _nombreController = TextEditingController();
  final _marcaController = TextEditingController();
  final _mililitrosController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _marcaController.dispose();
    _mililitrosController.dispose();
    super.dispose();
  }

  void _guardarBotella() {
    // Valida que todo este lleno de los cmpaos
    if (_formKey.currentState!.validate()) {
      
      // aquí irá la petición HTTP (Backend) para insertar en mysql de la base.


      // mensaje de exito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Botella Registrada',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // Limpia el formulario para registrar la siguiente botella
      _nombreController.clear();
      _marcaController.clear();
      _mililitrosController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Registro de Botellas', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // CAMPO: NOMBRE DEL PERFUME
              TextFormField(
                controller: _nombreController,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  labelText: 'Nombre del perfume',
                  labelStyle: TextStyle(color: Colors.black54),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, ingresa el nombre del perfume';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // CAMPO: MARCA
              TextFormField(
                controller: _marcaController,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  labelText: 'Marca',
                  labelStyle: TextStyle(color: Colors.black54),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, ingresa la marca';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // CAMPO: TAMAÑO ORIGINAL (ML)
              TextFormField(
                controller: _mililitrosController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  labelText: 'Tamaño original (ml)',
                  labelStyle: TextStyle(color: Colors.black54),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, ingresa los mililitros';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Debes ingresar un número válido';
                  }
                  return null;
                },
              ),
              
              const Spacer(),

              // BOTÓN DE GUARDAR
              ElevatedButton(
                onPressed: _guardarBotella,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Guardar Botella',
                  style: TextStyle(
                    fontSize: 16, 
                    color: Colors.white, 
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
