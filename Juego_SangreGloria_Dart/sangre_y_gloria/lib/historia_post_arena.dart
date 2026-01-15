// historia_post_arena.dart: Gestiona los eventos de la historia después de las batallas en la arena según el progreso del jugador.

import 'dart:io';
import 'dart:math';
import 'jugador.dart';

// Función para manejar la progresión de la historia después de las batallas en la arena.
void historiaPostArena(Jugador jugador) {
  int evento = -1; // Bandera para identificar el evento a desencadenar.
  // Determina qué evento de la historia activar según las estadísticas y el progreso del jugador.
  if (jugador.nivel >= 1 && jugador.peleasGanadas >= 1 && jugador.progresoHistoria < 1) {
    evento = 1;
  } else if (jugador.nivel >= 2 && jugador.peleasGanadas >= 3 && jugador.progresoHistoria < 2) {
    evento = 2;
  } else if (jugador.nivel >= 3 && jugador.reputacion >= 10 && jugador.progresoHistoria < 3) {
    evento = 3;
  } else if (jugador.nivel >= 5 && jugador.reputacion >= 20 && jugador.progresoHistoria < 4) {
    evento = 4;
  } else if (jugador.nivel >= 7 && jugador.reputacion >= 30 && jugador.progresoHistoria < 5) {
    evento = 5;
  } else if (jugador.nivel >= 10 && jugador.reputacion >= 50 && jugador.progresoHistoria < 6) {
    evento = 6;
  } else if (jugador.nivel >= 12 && jugador.reputacion >= 60 && jugador.progresoHistoria < 7) {
    evento = 7;
  } else if (jugador.nivel >= 15 && jugador.reputacion >= 80 && jugador.progresoHistoria < 8) {
    evento = 8;
  }

  // Sale si no se activa ningún evento.
  if (evento == -1) {
    return;
  }

  // Muestra el encabezado de la historia.
  print('\n\n=== SUSURROS DE ROCANEGRA ===\n');

  // Maneja los diferentes eventos de la historia según la bandera de evento.
  switch (evento) {
    case 1:
      // Evento 1: Encuentro con un hombre encapuchado que cuestiona el linaje del jugador.
      print('Tras tu primera victoria, un hombre encapuchado te aborda en los túneles de la arena.');
      print('"Tu estilo de lucha... lo he visto antes. ¿Eres el hijo de Valerius?"');
      print('Te observa con ojos penetrantes: "Si es verdad, hay quienes te apoyarían... o te cazarían."\n');
      
      print('¿Cómo respondes?');
      print('1. [Confianza] "Si soy su hijo, que vengan a por mí."');
      print('2. [Cautela] "No sé de qué hablas. Solo soy un gladiador."');
      print('3. [Curiosidad] "¿Quiénes son esos que me apoyarían?"');
      stdout.write('Elige (1-3): ');

      String? opcion = stdin.readLineSync();
      switch (opcion) {
        case '1':
          jugador.reputacion += 10;
          jugador.vida -= 10;
          print('\n>> Tu desafío resuena entre los esclavos, pero te ganas enemigos. (+10 Reputación, -10 Vida)');
          break;
        case '2':
          jugador.defensa += 3;
          Item pocion = Item(nombre: 'Poción de Vida', tipo: 'poción', valor: 30, precio: 0);
          jugador.items = [...jugador.items, pocion];
          jugador.pociones++;
          print('\n>> El hombre te desliza una poción como muestra de buena fe. (+1 Poción de Vida)');
          print('>> Tu discreción te protege de miradas indeseadas. (+3 Defensa)');
          break;
        case '3':
          jugador.oro += 30;
          print('\n>> El hombre promete contactarte, pero te da oro para mantenerte con vida. (+30 Oro)');
          break;
        default:
          print('\n>> Tu silencio lo incomoda, y se marcha. Pierdes una oportunidad.');
          jugador.vida -= 5;
      }
      jugador.progresoHistoria = 1; // Actualiza el progreso de la historia.
      break;

    case 2:
      // Evento 2: Encuentra un pergamino misterioso en la celda del jugador.
      print('Tras tu tercera victoria, encuentras un pergamino escondido en tu celda.');
      print('Dice: "El hijo de Valerius aún vive. La rebelión no ha muerto."');
      print('Al final, hay un símbolo: una espada rota. ¿Qué haces con el pergamino?\n');
      
      print('1. [Valentía] Guardarlo y buscar a los rebeldes');
      print('2. [Prudencia] Quemarlo para evitar problemas');
      print('3. [Ambición] Entregarlo a los guardias por una recompensa');
      stdout.write('Elige (1-3): ');

      String? opcion = stdin.readLineSync();
      switch (opcion) {
        case '1':
          jugador.ataque += 4;
          jugador.reputacion += 5;
          Item daga = Item(nombre: 'Daga Rebelde', tipo: 'arma', valor: 6, precio: 0, ataqueEspecial: 'Puñalada Silenciosa');
          jugador.items = [...jugador.items, daga];
          print('\n>> El pergamino te inspira a luchar con más fuerza. (+4 Ataque, +5 Reputación)');
          print('>> Encuentras una daga marcada con el símbolo de la espada rota. (+Daga Rebelde)');
          break;
        case '2':
          jugador.agilidad += 3;
          print('\n>> Quemar el pergamino agudiza tu cautela. (+3 Agilidad)');
          break;
        case '3':
          jugador.oro += 50;
          jugador.reputacion -= 10;
          print('\n>> Los guardias te recompensan, pero los esclavos te desprecian. (+50 Oro, -10 Reputación)');
          break;
        default:
          print('\n>> Ignoras el pergamino, pero su mensaje te inquieta.');
          jugador.vida -= 10;
      }
      jugador.progresoHistoria = 2;
      break;

    case 3:
      // Evento 3: Encuentro con una mujer que reclama lealtad a Valerius.
      print('Tu creciente fama como gladiador atrae aliados. Una mujer vestida de negro te espera fuera de la arena.');
      print('"Valerius era mi señor. Si eres su hijo, puedo ayudarte a reclamar tu destino."');
      print('Te ofrece un anillo con el sello de Valerius. ¿Qué haces?\n');
      
      print('1. [Aceptar] Tomar el anillo y su ayuda');
      print('2. [Rechazar] Negarte, desconfiando de sus intenciones');
      print('3. [Desafío] Exigir pruebas de su lealtad');
      stdout.write('Elige (1-3): ');

      String? opcion = stdin.readLineSync();
      switch (opcion) {
        case '1':
          Item anillo = Item(nombre: 'Sello de Valerius', tipo: 'amuleto', valor: 5, precio: 0);
          jugador.items = [...jugador.items, anillo];
          jugador.reputacion += 8;
          print('\n>> Aceptas el anillo, sintiendo el peso de tu linaje. (+8 Reputación)');
          print('>> Obtuviste: Sello de Valerius (+5 Agilidad al equipar).');
          break;
        case '2':
          jugador.defensa += 4;
          print('\n>> Rechazas su oferta, fortaleciendo tu instinto protector. (+4 Defensa)');
          break;
        case '3':
          jugador.ataque += 5;
          jugador.vida -= 15;
          Item anillo = Item(nombre: 'Sello de Valerius', tipo: 'amuleto', valor: 5, precio: 0);
          jugador.items = [...jugador.items, anillo];
          print('\n>> Exiges pruebas, pero ella te reta a un duelo breve. Ganas, pero te hieres. (+5 Ataque, -15 Vida)');
          print('>> Ella te da el anillo como respeto por tu valor. (+Sello de Valerius)');
          break;
        default:
          print('\n>> Tu indecisión la decepciona, y se marcha.');
          jugador.oro += 20;
          print('>> Encuentras unas monedas en el suelo donde ella estaba. (+20 Oro)');
      }
      jugador.progresoHistoria = 3;
      break;

    case 4:
      // Evento 4: Encuentro con un espía del rey que ofrece libertad.
      print('Tu creciente fama atrae a un espía del rey. En una taberna, te susurra:');
      print('"El rey sabe de ti, heredero de Valerius. Únete a él, y serás libre."');
      print('Te muestra un sello real como prueba. ¿Qué haces?\n');
      
      print('1. [Rebelión] Rechazar la oferta y amenazar al espía');
      print('2. [Engaño] Fingir aceptar para obtener información');
      print('3. [Traición] Aceptar la oferta del rey');
      stdout.write('Elige (1-3): ');

      String? opcion = stdin.readLineSync();
      switch (opcion) {
        case '1':
          jugador.ataque += 5;
          jugador.reputacion += 10;
          Item espada = Item(nombre: 'Espada de la Rebelión', tipo: 'arma', valor: 7, precio: 0, ataqueEspecial: 'Tajo Heroico');
          jugador.items = [...jugador.items, espada];
          print('\n>> Tu desafío fortalece tu resolución y fama entre los rebeldes. (+5 Ataque, +10 Reputación)');
          print('>> Un rebelde te entrega una espada forjada para la causa. (+Espada de la Rebelión)');
          break;
        case '2':
          jugador.agilidad += 4;
          jugador.oro += 40;
          print('\n>> Engañas al espía, obteniendo planos de la guardia real. (+4 Agilidad, +40 Oro)');
          break;
        case '3':
          jugador.oro += 100;
          jugador.reputacion -= 20;
          print('\n>> El rey te recompensa, but los rebeldes te repudian. (+100 Oro, -20 Reputación)');
          break;
        default:
          print('\n>> Tu indecisión alerta al espía, que huye.');
          jugador.vida -= 10;
          print('>> (-10 Vida)');
      }
      jugador.progresoHistoria = 4;
      break;

    case 5:
      // Evento 5: Reunión con los rebeldes para planificar un asalto.
      print('Los rebeldes te convocan a una reunión secreta en las cloacas de Rocanegra.');
      print('"El hijo de Valerius debe liderar el asalto a la fortaleza del rey.", dicen.');
      print('Te piden planificar el ataque. ¿Qué estrategia eliges?\n');
      
      print('1. [Ataque Directo] Asaltar las puertas principales');
      print('2. [Infiltración] Entrar por los túneles');
      print('3. [Diplomacia] Negociar con nobles descontentos');
      stdout.write('Elige (1-3): ');

      String? opcion = stdin.readLineSync();
      switch (opcion) {
        case '1':
          jugador.maxVida += 20;
          jugador.vida = jugador.maxVida;
          Item armadura = Item(nombre: 'Armadura de Valerius', tipo: 'armadura', valor: 6, precio: 0);
          jugador.items = [...jugador.items, armadura];
          print('\n>> Tu audacia inspira a los rebeldes, fortaleciendo tu resistencia. (+20 Vida Máxima)');
          print('>> Obtienes una armadura legendaria de tu padre. (+Armadura de Valerius)');
          break;
        case '2':
          jugador.agilidad += 5;
          Item daga = Item(nombre: 'Daga de las Sombras', tipo: 'arma', valor: 8, precio: 0, ataqueEspecial: 'Corte Oculta');
          jugador.items = [...jugador.items, daga];
          print('\n>> Tu plan sigiloso mejora tu destreza. (+5 Agilidad)');
          print('>> Obtienes una daga perfecta para emboscadas. (+Daga de las Sombras)');
          break;
        case '3':
          jugador.reputacion += 15;
          jugador.oro += 50;
          print('\n>> Ganas aliados nobles, pero el plan es arriesgado. (+15 Reputación, +50 Oro)');
          break;
        default:
          print('\n>> Tu indecisión retrasa los planes rebeldes.');
          jugador.vida -= 15;
          print('>> (-15 Vida)');
      }
      jugador.progresoHistoria = 5;
      break;

    case 6:
      // Evento 6: Confrontación con el campeón del rey.
      print('Tu reputación como heredero de Valerius sacude el reino. El rey envía un campeón a la arena.');
      print('"Ríndete, o el reino arderá.", amenaza. La multitud contiene el aliento.');
      print('¿Cómo enfrentas este desafío?\n');
      
      print('1. [Honor] Luchar en un duelo justo');
      print('2. [Astucia] Sabotear su equipo antes del combate');
      print('3. [Desafío] Rechazar el duelo y exigir enfrentarte al rey');
      stdout.write('Elige (1-3): ');

      String? opcion = stdin.readLineSync();
      switch (opcion) {
        case '1':
          jugador.ataque += 6;
          jugador.reputacion += 20;
          Item espada = Item(nombre: 'Espada del Heredero', tipo: 'arma', valor: 10, precio: 0, ataqueEspecial: 'Golpe de Gloria');
          jugador.items = [...jugador.items, espada];
          print('\n>> Tu victoria heroica en el duelo inspira a las masas. (+6 Ataque, +20 Reputación)');
          print('>> Obtienes la espada definitiva de Valerius. (+Espada del Heredero)');
          break;
        case '2':
          jugador.agilidad += 6;
          jugador.oro += 60;
          print('\n>> Saboteas al campeón, ganando fácilmente y obteniendo botín. (+6 Agilidad, +60 Oro)');
          break;
        case '3':
          jugador.reputacion += 25;
          jugador.vida -= 20;
          Item anillo = Item(nombre: 'Anillo del Destino', tipo: 'amuleto', valor: 7, precio: 0);
          jugador.items = [...jugador.items, anillo];
          print('\n>> Tu desafío al rey provoca caos, pero te hiere gravemente. (+25 Reputación, -20 Vida)');
          print('>> Un aliado te entrega un anillo místico. (+Anillo del Destino)');
          break;
        default:
          print('\n>> Tu vacilación permite al campeón golpearte antes del combate.');
          jugador.vida -= 25;
          print('>> (-25 Vida)');
      }
      jugador.progresoHistoria = 6;
      break;

    case 7:
      // Evento 7: Liderar a los rebeldes para un asalto crucial.
      print('Los rebeldes se reúnen en un fuerte oculto. Te nombran líder para un asalto crucial.');
      print('"Hijo de Valerius, el reino está al borde del caos. ¿Cómo atacamos la capital?"');
      print('La estrategia definirá el destino de la rebelión.\n');
      
      print('1. [Audacia] Liderar un ataque frontal contra la muralla');
      print('2. [Táctica] Enviar espías para abrir las puertas desde dentro');
      print('3. [Unidad] Convocar a todas las facciones rebeldes, aunque sea arriesgado');
      stdout.write('Elige (1-3): ');

      String? opcion = stdin.readLineSync();
      switch (opcion) {
        case '1':
          jugador.ataque += 7;
          jugador.vida -= 20;
          Item escudo = Item(nombre: 'Escudo de la Vanguardia', tipo: 'armadura', valor: 8, precio: 0);
          jugador.items = [...jugador.items, escudo];
          print('\n>> Tu valentía lleva a una victoria parcial, pero a un alto costo. (+7 Ataque, -20 Vida)');
          print('>> Obtienes un escudo forjado para el frente. (+Escudo de la Vanguardia)');
          break;
        case '2':
          jugador.agilidad += 6;
          jugador.reputacion += 15;
          print('\n>> Los espías abren las puertas, asegurando una ventaja táctica. (+6 Agilidad, +15 Reputación)');
          Item capa = Item(nombre: 'Capa del Conspirador', tipo: 'amuleto', valor: 5, precio: 0);
          jugador.items = [...jugador.items, capa];
          print('>> Obtienes una capa que oculta tus movimientos. (+Capa del Conspirador)');
          break;
        case '3':
          jugador.reputacion += 20;
          jugador.oro += 70;
          print('\n>> Unes a los rebeldes, ganando recursos y apoyo masivo. (+20 Reputación, +70 Oro)');
          break;
        default:
          print('\n>> La falta de un plan claro debilita a los rebeldes.');
          jugador.vida -= 20;
          print('>> (-20 Vida)');
      }
      jugador.progresoHistoria = 7;
      break;

    case 8:
      // Evento 8: Batalla final contra la guardia de élite del rey.
      print('El rey, acorralado, envía a su guardia de élite a la arena para aplastarte.');
      print('"Hijo de Valerius, tu rebelión termina aquí.", declara su capitán.');
      print('La batalla decidirá el futuro del reino. ¿Cómo actúas?\n');
      
      print('1. [Fuerza] Enfrentar a la guardia en combate abierto');
      print('2. [Estrategia] Usar trampas preparadas por los rebeldes');
      print('3. [Inspiración] Pronunciar un discurso para incitar una revuelta');
      stdout.write('Elige (1-3): ');

      String? opcion = stdin.readLineSync();
      switch (opcion) {
        case '1':
          jugador.ataque += 8;
          jugador.maxVida += 30;
          jugador.vida = jugador.maxVida;
          Item corona = Item(nombre: 'Corona de Valerius', tipo: 'amuleto', valor: 10, precio: 0);
          jugador.items = [...jugador.items, corona];
          print('\n>> Derrotas a la guardia, consolidando tu poder. (+8 Ataque, +30 Vida Máxima)');
          print('>> Obtienes la corona de tu padre, símbolo de tu derecho al trono. (+Corona de Valerius)');
          break;
        case '2':
          jugador.agilidad += 7;
          jugador.reputacion += 20;
          Item daga = Item(nombre: 'Daga del Triunfo', tipo: 'arma', valor: 9, precio: 0, ataqueEspecial: 'Furia Rebelde');
          jugador.items = [...jugador.items, daga];
          print('\n>> Las trampas aniquilan a la guardia, mostrando tu astucia. (+7 Agilidad, +20 Reputación)');
          print('>> Obtienes una daga imbuida con el espíritu rebelde. (+Daga del Triunfo)');
          break;
        case '3':
          jugador.reputacion += 30;
          jugador.oro += 100;
          print('\n>> Tu discurso incita una revuelta masiva, debilitando al rey. (+30 Reputación, +100 Oro)');
          jugador.cooldownAtaqueEspecial = 0; // Reinicia el enfriamiento del ataque especial.
          print('>> Tu liderazgo inspira a los rebeldes, preparando tu ataque especial para el próximo combate.');
          break;
        default:
          print('\n>> Tu indecisión permite a la guardia atacarte primero.');
          jugador.vida -= 30;
          print('>> (-30 Vida)');
      }
      jugador.progresoHistoria = 8;
      break;
  }

  // Evento aleatorio: 30% de probabilidad de encontrar un ítem aleatorio después de una batalla.
  if (Random().nextInt(100) < 30) {
    List<Item> posiblesItems = [
      Item(nombre: 'Poción de Vida', tipo: 'poción', valor: 30, precio: 0),
      Item(nombre: 'Cuchillo Roto', tipo: 'arma', valor: 3, precio: 0, ataqueEspecial: 'Corte Rápido'),
      Item(nombre: 'Amuleto Gastado', tipo: 'amuleto', valor: 2, precio: 0),
    ];
    Item itemAleatorio = posiblesItems[Random().nextInt(posiblesItems.length)]; // Selecciona un ítem aleatorio.
    jugador.items = [...jugador.items, itemAleatorio]; // Añade el ítem al inventario del jugador.
    if (itemAleatorio.tipo == 'poción') {
      jugador.pociones++; // Incrementa el contador de pociones si corresponde.
    }
    print('\n🎁 Entre los restos de la arena, encuentras algo útil.');
    print('>> Obtuviste: ${itemAleatorio.nombre} (${itemAleatorio.tipo == 'poción' ? '+${itemAleatorio.valor} Vida al usar' : '+${itemAleatorio.valor} ${itemAleatorio.tipo == 'arma' ? 'Ataque' : 'Agilidad'} al equipar'}).');
  }

  // Mensaje final para cerrar el evento.
  print('\nLa arena te reclama de nuevo, ${jugador.nombre}. Tu destino está más cerca.\n');
}
