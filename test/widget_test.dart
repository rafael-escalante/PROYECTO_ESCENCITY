import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Asegúrate de que este import coincida con el nombre de tu proyecto
import 'package:inicio_sesion/main.dart'; 

void main() {
  testWidgets('Verificar carga inicial de la aplicación (Login)', (WidgetTester tester) async {
    // 1. Construimos la app pasándole la ruta inicial obligatoria
    await tester.pumpWidget(const MyApp(initialRoute: '/login'));

    // 2. Esperamos a que los widgets se dibujen en pantalla
    await tester.pumpAndSettle();

    // 3. Verificamos que se encuentre el texto de la pantalla de Iniciar Sesión
    // y confirmamos que ya no existe el contador viejo
    expect(find.text('Escencity - Iniciar Sesión'), findsOneWidget);
    expect(find.text('0'), findsNothing); 
  });
}