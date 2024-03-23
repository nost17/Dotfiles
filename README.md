# Dotfiles

Repositorio de configuración del entorno AwesomeWM y otros programas

### Novedades
- **AwesomeWM:**
    - Modo oscuro / claro
    - Soporta cualquier paleta de colores
    - Ncmpcpp con decoracion personalizada
    - Alternador de tema automatico para Terminal Kitty
    - Notificaciones de musica con acciones
    - Herramienta de capturas de pantalla en ajustes rapidos

### Programas

- **WM:** AwesomeWM
- **Notificaciones:** Naughty
- **Terminal:** Kitty
- **Web:** Vivaldi
- **Música:** MPD
- **Música (CLI):** Ncmpcpp & mpc

### Capturas

| <b>Escritorio</b>                                                                                                                               |
| ----------------------------------------------------------------------------------------------------------------------------------------------- |
| <a href="#--------"><img src="https://raw.githubusercontent.com/Lik-e/Dotfiles/main/.github/screenshots/01.png" alt="bottom panel preview"></a> |

| <b>Ajustes rápidos</b>                                                                                                                          |
| ----------------------------------------------------------------------------------------------------------------------------------------------- |
| <a href="#--------"><img src="https://raw.githubusercontent.com/Lik-e/Dotfiles/main/.github/screenshots/02.png" alt="bottom panel preview"></a> |

| <b>Lanzador de aplicaciones</b>                                                                                                                 |
| ----------------------------------------------------------------------------------------------------------------------------------------------- |
| <a href="#--------"><img src="https://raw.githubusercontent.com/Lik-e/Dotfiles/main/.github/screenshots/03.png" alt="bottom panel preview"></a> |

| <b>Panel de notificaciones</b>                                                                                                                  |
| ----------------------------------------------------------------------------------------------------------------------------------------------- |
| <a href="#--------"><img src="https://raw.githubusercontent.com/Lik-e/Dotfiles/main/.github/screenshots/04.png" alt="bottom panel preview"></a> |

| <b>Distribucion de ventanas</b>                                                                                                                 |
| ----------------------------------------------------------------------------------------------------------------------------------------------- |
| <a href="#--------"><img src="https://raw.githubusercontent.com/Lik-e/Dotfiles/main/.github/screenshots/05.png" alt="bottom panel preview"></a> |

| <b>Calendaria y Musica</b>                                                                                                                               |
| ----------------------------------------------------------------------------------------------------------------------------------------------- |
| <a href="#--------"><img src="https://raw.githubusercontent.com/Lik-e/Dotfiles/main/.github/screenshots/06.png" alt="bottom panel preview"></a> |

| <b>Selector de ventanas</b>                                                                                                                               |
| ----------------------------------------------------------------------------------------------------------------------------------------------- |
| <a href="#--------"><img src="https://raw.githubusercontent.com/Lik-e/Dotfiles/main/.github/screenshots/07.png" alt="bottom panel preview"></a> |

| <b>Modo claro</b>                                                                                                                               |
| ----------------------------------------------------------------------------------------------------------------------------------------------- |
| <a href="#--------"><img src="https://raw.githubusercontent.com/Lik-e/Dotfiles/main/.github/screenshots/08.png" alt="bottom panel preview"></a> |

| <b>Pantalla de salida</b>                                                                                                                       |
| ----------------------------------------------------------------------------------------------------------------------------------------------- |
| <a href="#--------"><img src="https://raw.githubusercontent.com/Lik-e/Dotfiles/main/.github/screenshots/09.png" alt="bottom panel preview"></a> |

| <b>Pantalla de bloqueo</b>                                                                                                                      |
| ----------------------------------------------------------------------------------------------------------------------------------------------- |
| <a href="#--------"><img src="https://raw.githubusercontent.com/Lik-e/Dotfiles/main/.github/screenshots/10.png" alt="bottom panel preview"></a> |

# ToDo
- [X] Actualizar capturas de pantalla

#### AwesomeWM

- [ ] Playerctl lib
  - [ ] Agregar REPEAT and RANDOM señal
  - [ ] Agregar funcionalidad a los botones de los ajustes rapidos/control de musica
- [X] Implementar monitores de estado al panel de ajustes rapidos
  - [X] Reorganizar ajustes rapidos
    - [X] Agregar monitores en el widget de controles
    - [X] Cambiar diseño de botones a simple
      - [X] Modo oscuro
      - [X] Alerta de canciones
      - [X] Modo flotante
      - [X] Luz nocturna
  - [X] Agregar monitores
    - [X] Agregar libreria de señales para CPU
    - [X] Agregar libreria de señales para RAM
    - [X] Agregar libreria de señales para DISCO
    - [X] Agregar libreria de señales para TEMPERATURA
  - [X] Agregar plantilla para los monitores
  - [X] Agregar nueva plantilla simple para botones de ajustes rapidos
- [ ] Implementación y re-diseño de ajustes rápidos
  - [x] Agregar alternador de modo oscuro/claro
  - [x] Agregar boton de captura de Pantalla
    - [x] Captura instantánea
    - [x] Menu de selección
      - [x] Pantalla completa
      - [x] Seleccion
      - [x] Ventana
  - [x] Agregar boton de internet
    - [x] Agregar libreria de internet (señales)
  - [ ] Agregar boton de bluetooth
    - [ ] Agregar libreria de bluetooth (señales)
- [x] Agregar barra de titulo para las ventanas
  - [x] Agregar alternador de modo flotante (ajustes rápidos)
- [x] Agregar calendario
- [x] Agregar selector de distribucion de ventanas
- [ ] Agregar pizarron de estado
- [x] Pantalla de bloqueo
- [x] Menu de apagado
- [x] Lanzador de aplicaciones
- [x] Convertir get_icon.lua en un objecto y agregar metodos
- [x] Fusionar get_icon.lua y get_name.lua

#### Other

- [X] Agregar configuración de nvchad
- [ ] Agregar rc de picom al script
- [ ] Agregar compilacion automatica de picom-ibhagwan
- [ ] Agregar compilacion automatica de awesome-git en el script
- [ ] Terminar el script xd
