import 'package:flutter/material.dart';

class InventarioAtomizadoresScreen extends StatefulWidget {
  const InventarioAtomizadoresScreen({super.key});

  @override
  State<InventarioAtomizadoresScreen> createState() =>
      _InventarioAtomizadoresScreenState();
}

class _InventarioAtomizadoresScreenState
    extends State<InventarioAtomizadoresScreen> {
  // Un formulario independiente para cada sección
  final _formAtomizadorKey = GlobalKey<FormState>();
  final _formEmpaqueKey = GlobalKey<FormState>();

  // Controladores
  final _cantidadAtomizadorController = TextEditingController();
  final _cantidadEmpaqueController = TextEditingController();

  // Opciones disponibles
  final List<int> _tamanosAtomizador = [3, 5, 10];
  final List<String> _tiposEmpaque = [
    'Caja individual',
    'Bolsa de organza',
    'Estuche',
    'Bolsa de papel',
  ];

  // Valores seleccionados
  int? _tamanoSeleccionado;
  String? _empaqueSeleccionado;

  // Existencias locales (mientras se conecta al backend)
  final Map<int, int> _stockAtomizadores = {3: 0, 5: 0, 10: 0};
  final Map<String, int> _stockEmpaque = {};

  @override
  void dispose() {
    _cantidadAtomizadorController.dispose();
    _cantidadEmpaqueController.dispose();
    super.dispose();
  }

  void _mostrarExito(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          mensaje,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _guardarAtomizadores() {
    if (_formAtomizadorKey.currentState!.validate()) {
      final cantidad = int.parse(_cantidadAtomizadorController.text.trim());

      // aquí irá la petición HTTP (Backend) para actualizar el inventario
      // de atomizadores en mysql: tamaño = _tamanoSeleccionado, cantidad.

      setState(() {
        _stockAtomizadores[_tamanoSeleccionado!] =
            (_stockAtomizadores[_tamanoSeleccionado!] ?? 0) + cantidad;
        _tamanoSeleccionado = null;
      });

      _mostrarExito('Atomizadores registrados');
      _cantidadAtomizadorController.clear();
    }
  }

  void _guardarEmpaque() {
    if (_formEmpaqueKey.currentState!.validate()) {
      final cantidad = int.parse(_cantidadEmpaqueController.text.trim());

      // aquí irá la petición HTTP (Backend) para actualizar el inventario
      // de empaque en mysql: tipo = _empaqueSeleccionado, cantidad.

      setState(() {
        _stockEmpaque[_empaqueSeleccionado!] =
            (_stockEmpaque[_empaqueSeleccionado!] ?? 0) + cantidad;
        _empaqueSeleccionado = null;
      });

      _mostrarExito('Empaque registrado');
      _cantidadEmpaqueController.clear();
    }
  }

  // Validador compartido para cantidades
  String? _validarCantidad(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor, ingresa la cantidad';
    }
    final numero = int.tryParse(value.trim());
    if (numero == null) {
      return 'Debes ingresar un número válido';
    }
    if (numero <= 0) {
      return 'La cantidad debe ser mayor a 0';
    }
    return null;
  }

  Widget _titulo(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        texto,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _botonGuardar(String texto, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Text(
        texto,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Inventario de Atomizadores y Empaque',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ───────────── SECCIÓN: ATOMIZADORES ─────────────
            _titulo('Atomizadores'),

            // Existencias actuales por tamaño
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _tamanosAtomizador.map((ml) {
                return Chip(
                  backgroundColor: Colors.green.shade50,
                  label: Text(
                    '$ml ml: ${_stockAtomizadores[ml]} pzas',
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            Form(
              key: _formAtomizadorKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // CAMPO: TAMAÑO DEL ATOMIZADOR
                  DropdownButtonFormField<int>(
                    value: _tamanoSeleccionado,
                    dropdownColor: Colors.white,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      labelText: 'Tamaño del atomizador',
                      labelStyle: TextStyle(color: Colors.black54),
                      border: OutlineInputBorder(),
                    ),
                    items: _tamanosAtomizador
                        .map((ml) => DropdownMenuItem<int>(
                              value: ml,
                              child: Text('$ml ml'),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() => _tamanoSeleccionado = value);
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Por favor, selecciona el tamaño';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // CAMPO: CANTIDAD DE ATOMIZADORES
                  TextFormField(
                    controller: _cantidadAtomizadorController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      labelText: 'Cantidad (piezas)',
                      labelStyle: TextStyle(color: Colors.black54),
                      border: OutlineInputBorder(),
                    ),
                    validator: _validarCantidad,
                  ),
                  const SizedBox(height: 16),

                  _botonGuardar('Guardar Atomizadores', _guardarAtomizadores),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),

            // ───────────── SECCIÓN: EMPAQUE ─────────────
            _titulo('Empaque'),

            // Existencias actuales de empaque
            if (_stockEmpaque.isNotEmpty) ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _stockEmpaque.entries.map((e) {
                  return Chip(
                    backgroundColor: Colors.green.shade50,
                    label: Text(
                      '${e.key}: ${e.value} pzas',
                      style: const TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],

            Form(
              key: _formEmpaqueKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // CAMPO: TIPO DE EMPAQUE
                  DropdownButtonFormField<String>(
                    value: _empaqueSeleccionado,
                    dropdownColor: Colors.white,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      labelText: 'Tipo de empaque',
                      labelStyle: TextStyle(color: Colors.black54),
                      border: OutlineInputBorder(),
                    ),
                    items: _tiposEmpaque
                        .map((tipo) => DropdownMenuItem<String>(
                              value: tipo,
                              child: Text(tipo),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() => _empaqueSeleccionado = value);
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Por favor, selecciona el tipo de empaque';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // CAMPO: CANTIDAD DE EMPAQUE
                  TextFormField(
                    controller: _cantidadEmpaqueController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      labelText: 'Cantidad (piezas)',
                      labelStyle: TextStyle(color: Colors.black54),
                      border: OutlineInputBorder(),
                    ),
                    validator: _validarCantidad,
                  ),
                  const SizedBox(height: 16),

                  _botonGuardar('Guardar Empaque', _guardarEmpaque),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}