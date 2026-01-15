// tienda.dart: Gestiona la tienda del juego y la lógica de precios de los ítems.

import 'jugador.dart';

// Clase Tienda para manejar el inventario de ítems y las transacciones.
class Tienda {
  // Lista de ítems disponibles en la tienda.
  List<Item> items = [
    Item(nombre: 'Espada Corta', tipo: 'arma', valor: 5, precio: 50, ataqueEspecial: 'Corte Rápido'),
    Item(nombre: 'Hacha de Guerra', tipo: 'arma', valor: 8, precio: 80, ataqueEspecial: 'Golpe Brutal'),
    Item(nombre: 'Lanza de Hierro', tipo: 'arma', valor: 6, precio: 60, ataqueEspecial: 'Estocada Precisa'),
    Item(nombre: 'Armadura de Cuero', tipo: 'armadura', valor: 3, precio: 40),
    Item(nombre: 'Cota de Malla', tipo: 'armadura', valor: 5, precio: 60),
    Item(nombre: 'Yelmo de Acero', tipo: 'armadura', valor: 4, precio: 50),
    Item(nombre: 'Poción de Vida', tipo: 'poción', valor: 30, precio: 20),
    Item(nombre: 'Poción de Fuerza', tipo: 'consumible', valor: 5, precio: 30),
    Item(nombre: 'Amuleto de Viento', tipo: 'amuleto', valor: 3, precio: 45),
    Item(nombre: 'Anillo de Valerius', tipo: 'amuleto', valor: 5, precio: 100),
  ];

  // Muestra los ítems disponibles con precios descontados según la reputación.
  void mostrarItems(int reputacion) {
    print('\n📜 Ítems disponibles en la tienda:');
    for (int i = 0; i < items.length; i++) {
      Item item = items[i];
      int precioConDescuento = calcularPrecioConDescuento(item, reputacion); // Calcula el precio con descuento.
      String especial = item.ataqueEspecial != null ? ', Ataque Especial: ${item.ataqueEspecial}' : ''; // Incluye ataque especial si aplica.
      print('${i + 1}. ${item.nombre} (${item.tipo}, Valor: ${item.valor}$especial, Precio: $precioConDescuento oro)');
    }
  }

  // Calcula el precio de un ítem con descuento basado en la reputación del jugador.
  int calcularPrecioConDescuento(Item item, int reputacion) {
    double descuento = reputacion / 100; // Convierte la reputación en porcentaje de descuento.
    return (item.precio * (1 - descuento / 100)).floor(); // Aplica el descuento y redondea hacia abajo.
  }
}