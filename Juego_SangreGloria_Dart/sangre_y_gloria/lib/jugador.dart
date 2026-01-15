
// jugador.dart: Gestiona las clases de jugador y enemigo con lógica de guardar/cargar.
// Cambios: Añadida utilidad de entrada, optimizado manejo de JSON, asegurada compatibilidad de guardado.

import 'dart:convert';
import 'dart:io';

// Utilidad para parsear entradas robustas.
int? parseInput(String? input, int min, int max) {
  int? value = int.tryParse(input ?? ''); // Intenta convertir la entrada a entero.
  return (value != null && value >= min && value <= max) ? value : null; // Valida el rango.
}

// Clase para representar un ítem en el juego.
class Item {
  String nombre; // Nombre del ítem.
  String tipo; // Tipo de ítem (arma, armadura, poción, etc.).
  int valor; // Valor del ítem (afecta estadísticas).
  int precio; // Precio del ítem en oro.
  bool equipado; // Indica si el ítem está equipado.
  String? ataqueEspecial; // Ataque especial asociado (si aplica).

  Item({
    required this.nombre,
    required this.tipo,
    required this.valor,
    required this.precio,
    this.equipado = false,
    this.ataqueEspecial,
  });

  // Convierte el ítem a formato JSON para guardado.
  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'tipo': tipo,
        'valor': valor,
        'precio': precio,
        'equipado': equipado,
        'ataqueEspecial': ataqueEspecial,
      };

  // Crea un ítem desde un JSON cargado.
  factory Item.fromJson(Map<String, dynamic> json) => Item(
        nombre: json['nombre'] ?? 'Desconocido',
        tipo: json['tipo'] ?? 'consumible',
        valor: json['valor'] ?? 0,
        precio: json['precio'] ?? 0,
        equipado: json['equipado'] ?? false,
        ataqueEspecial: json['ataqueEspecial'],
      );
}

// Clase para representar al jugador y sus estadísticas.
class Jugador {
  String nombre; // Nombre del jugador.
  String origen; // Origen del jugador (afecta estadísticas iniciales).
  int vida; // Vida actual.
  int maxVida; // Vida máxima.
  int ataque; // Estadística de ataque.
  int defensa; // Estadística de defensa.
  int agilidad; // Estadística de agilidad.
  int nivel; // Nivel del jugador.
  int experiencia; // Puntos de experiencia.
  int pociones; // Número de pociones de vida.
  int reputacion; // Puntuación de reputación.
  int oro; // Cantidad de oro.
  int peleasGanadas; // Peleas ganadas en la arena.
  int peleasPerdidas; // Peleas perdidas en la arena.
  List<Item> items; // Lista de ítems en el inventario.
  Item? armaEquipada; // Arma equipada actualmente.
  Item? armaduraEquipada; // Armadura equipada actualmente.
  Item? amuletoEquipado; // Amuleto equipado actualmente.
  int progresoHistoria; // Progreso en la historia.
  int stamina; // Estamina actual.
  int cooldownAtaqueEspecial; // Enfriamiento para el ataque especial.

  Jugador({
    required this.nombre,
    required this.origen,
    this.vida = 100,
    this.maxVida = 100,
    this.ataque = 10,
    this.defensa = 5,
    this.agilidad = 5,
    this.nivel = 1,
    this.experiencia = 0,
    this.pociones = 3,
    this.reputacion = 0,
    this.oro = 50,
    this.peleasGanadas = 0,
    this.peleasPerdidas = 0,
    this.items = const [],
    this.armaEquipada,
    this.armaduraEquipada,
    this.amuletoEquipado,
    this.progresoHistoria = 0,
    this.stamina = 100,
    this.cooldownAtaqueEspecial = 0,
  });

  // Aplica bonificaciones según el origen del jugador.
  void aplicarOrigen() {
    switch (origen) {
      case 'Campesino rebelde':
        agilidad += 5; // Aumenta agilidad.
        break;
      case 'Esclavo de guerra':
        maxVida += 20; // Aumenta vida máxima.
        vida = maxVida; // Actualiza vida actual.
        break;
      case 'Guerrero del norte':
        ataque += 5; // Aumenta ataque.
        break;
      case 'Noble traicionado':
        reputacion += 10; // Aumenta reputación.
        break;
    }
  }

  // Muestra los datos iniciales del jugador tras su creación.
  void mostrarDatos() {
    print('\n╔═════════════ GLADIADOR CREADO ═════════════╗');
    print('  Nombre: $nombre');
    print('  Origen: $origen');
    print('  Vida: $vida/$maxVida');
    print('  Ataque: $ataque');
    print('  Defensa: $defensa');
    print('  Agilidad: $agilidad');
    print('  Reputación: $reputacion');
    print('  Oro: $oro');
    print('╚══════════════════════════════════════════╝\n');
  }

  // Muestra el estado completo del jugador.
  void mostrarEstado() {
    print('\n╔══════════════════════════════════╗');
    print('  Gladiador: $nombre');
    print('  Origen: $origen');
    print('  Vida: $vida/$maxVida');
    print('  Ataque: $ataque');
    print('  Defensa: $defensa');
    print('  Agilidad: $agilidad');
    print('  Stamina: $stamina');
    print('  Reputación: $reputacion');
    print('  Nivel: $nivel');
    print('  Experiencia: $experiencia');
    print('  Pociones: $pociones');
    print('  Oro: $oro');
    print('  Equipado:');
    print('    Arma: ${armaEquipada?.nombre ?? "Ninguna"}');
    print('    Armadura: ${armaduraEquipada?.nombre ?? "Ninguna"}');
    print('    Amuleto: ${amuletoEquipado?.nombre ?? "Ninguno"}');
    print('╚══════════════════════════════════╝\n');
  }

  // Usa una poción para restaurar vida.
  void usarPocion() {
    if (pociones > 0 && vida < maxVida) {
      pociones--; // Reduce el contador de pociones.
      int curacion = 30; // Cantidad de vida restaurada.
      vida = (vida + curacion > maxVida) ? maxVida : vida + curacion; // Asegura no superar la vida máxima.
      print('\n🧪 Usaste una poción. Vida restaurada: +$curacion (Vida actual: $vida)');
    } else if (pociones == 0) {
      print('\n❌ No tienes pociones.');
    } else {
      print('\n❌ Tu vida está al máximo.');
    }
  }

  // Equipa un ítem del inventario.
  void equiparItem(Item item, int index) {
    if (item.equipado) {
      print('\n❌ Este ítem ya está equipado.');
      return;
    }

    // Desequipa el ítem actual si ya hay uno en la misma categoría.
    if (item.tipo == 'arma' && armaEquipada != null) {
      desequiparItem(armaEquipada!);
    } else if (item.tipo == 'armadura' && armaduraEquipada != null) {
      desequiparItem(armaduraEquipada!);
    } else if (item.tipo == 'amuleto' && amuletoEquipado != null) {
      desequiparItem(amuletoEquipado!);
    }

    item.equipado = true; // Marca el ítem como equipado.
    if (item.tipo == 'arma') {
      armaEquipada = item;
      ataque += item.valor; // Aumenta el ataque.
      print('\n⚔️ Equipaste ${item.nombre}. Ataque +${item.valor}.');
    } else if (item.tipo == 'armadura') {
      armaduraEquipada = item;
      defensa += item.valor; // Aumenta la defensa.
      print('\n🛡️ Equipaste ${item.nombre}. Defensa +${item.valor}.');
    } else if (item.tipo == 'amuleto') {
      amuletoEquipado = item;
      agilidad += item.valor; // Aumenta la agilidad.
      print('\n💍 Equipaste ${item.nombre}. Agilidad +${item.valor}.');
    } else if (item.tipo == 'consumible') {
      vida = (vida + item.valor > maxVida) ? maxVida : vida + item.valor; // Aumenta la vida.
      print('\n🧪 Usaste ${item.nombre}. Vida +${item.valor}.');
      items.removeAt(index); // Elimina el consumible del inventario.
    }
  }

  // Desequipa un ítem.
  void desequiparItem(Item item) {
    if (!item.equipado) {
      print('\n❌ Este ítem no está equipado.');
      return;
    }
    item.equipado = false; // Marca el ítem como no equipado.
    if (item.tipo == 'arma' && item == armaEquipada) {
      ataque -= item.valor; // Reduce el ataque.
      armaEquipada = null;
      print('\n⚔️ Desequipaste ${item.nombre}. Ataque -${item.valor}.');
    } else if (item.tipo == 'armadura' && item == armaduraEquipada) {
      defensa -= item.valor; // Reduce la defensa.
      armaduraEquipada = null;
      print('\n🛡️ Desequipaste ${item.nombre}. Defensa -${item.valor}.');
    } else if (item.tipo == 'amuleto' && item == amuletoEquipado) {
      agilidad -= item.valor; // Reduce la agilidad.
      amuletoEquipado = null;
      print('\n💍 Desequipaste ${item.nombre}. Agilidad -${item.valor}.');
    }
  }

  // Regenera estamina del jugador.
  void regenerarStamina() {
    stamina = (stamina + 20 > 100) ? 100 : stamina + 20; // Aumenta estamina hasta un máximo de 100.
  }

  // Guarda el estado del jugador en un archivo JSON.
  void guardarPartida() {
    final datos = jsonEncode({
      'nombre': nombre,
      'origen': origen,
      'vida': vida,
      'maxVida': maxVida,
      'ataque': ataque,
      'defensa': defensa,
      'agilidad': agilidad,
      'nivel': nivel,
      'experiencia': experiencia,
      'pociones': pociones,
      'reputacion': reputacion,
      'oro': oro,
      'peleasGanadas': peleasGanadas,
      'peleasPerdidas': peleasPerdidas,
      'items': items.map((item) => item.toJson()).toList(),
      'armaEquipada': armaEquipada?.toJson(),
      'armaduraEquipada': armaduraEquipada?.toJson(),
      'amuletoEquipado': amuletoEquipado?.toJson(),
      'progresoHistoria': progresoHistoria,
      'stamina': stamina,
      'cooldownAtaqueEspecial': cooldownAtaqueEspecial,
    });
    File('partida_guardada.json').writeAsStringSync(datos); // Escribe los datos en el archivo.
    print('\n✅ Partida guardada.');
  }

  // Carga una partida guardada desde un archivo JSON.
  static Jugador cargarPartida() {
    final archivo = File('partida_guardada.json');
    if (!archivo.existsSync()) {
      throw Exception('No se encontró una partida guardada.'); // Lanza error si no existe el archivo.
    }
    final datos = jsonDecode(archivo.readAsStringSync()); // Lee y decodifica el JSON.
    return Jugador(
      nombre: datos['nombre'] ?? 'SinNombre',
      origen: datos['origen'] ?? 'Campesino rebelde',
      vida: datos['vida'] ?? 100,
      maxVida: datos['maxVida'] ?? 100,
      ataque: datos['ataque'] ?? 10,
      defensa: datos['defensa'] ?? 5,
      agilidad: datos['agilidad'] ?? 5,
      nivel: datos['nivel'] ?? 1,
      experiencia: datos['experiencia'] ?? 0,
      pociones: datos['pociones'] ?? 3,
      reputacion: datos['reputacion'] ?? 0,
      oro: datos['oro'] ?? 50,
      peleasGanadas: datos['peleasGanadas'] ?? 0,
      peleasPerdidas: datos['peleasPerdidas'] ?? 0,
      items: (datos['items'] as List<dynamic>?)
              ?.map((item) => Item.fromJson(item))
              .toList() ??
          [],
      armaEquipada: datos['armaEquipada'] != null
          ? Item.fromJson(datos['armaEquipada'])
          : null,
      armaduraEquipada: datos['armaduraEquipada'] != null
          ? Item.fromJson(datos['armaduraEquipada'])
          : null,
      amuletoEquipado: datos['amuletoEquipado'] != null
          ? Item.fromJson(datos['amuletoEquipado'])
          : null,
      progresoHistoria: datos['progresoHistoria'] ?? 0,
      stamina: datos['stamina'] ?? 100,
      cooldownAtaqueEspecial: datos['cooldownAtaqueEspecial'] ?? 0,
    );
  }
}

// Clase para representar a un enemigo en la arena.
class Enemigo {
  String nombre; // Nombre del enemigo.
  int vida; // Vida del enemigo.
  int ataque; // Estadística de ataque.
  int defensa; // Estadística de defensa.
  int agilidad; // Estadística de agilidad.
  String tipo; // Tipo de enemigo (Berserker, Defender, etc.).

  Enemigo({
    required this.nombre,
    required this.vida,
    required this.ataque,
    required this.defensa,
    required this.agilidad,
    required this.tipo,
  });
}