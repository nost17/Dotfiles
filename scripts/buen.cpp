#include <iostream>
#include <iomanip>
#include <sstream>
#include <cstdlib>

// Función para determinar si un color hexadecimal es claro u oscuro
std::string esColorClaroOscuro(std::string colorHex) {
    // Verifica que el valor sea un número hexadecimal
    for (char c : colorHex) {
        if (!isxdigit(c)) {
            std::cerr << "Error: Esto no es un color hexadecimal." << std::endl;
            exit(1);
        }
    }

    // Convierte el color hexadecimal a valores RGB
    unsigned int colorRGB;
    std::stringstream ss(colorHex);
    ss >> std::hex >> colorRGB;

    // Extrae los componentes RGB
    int r = (colorRGB >> 16) & 0xFF;
    int g = (colorRGB >> 8) & 0xFF;
    int b = colorRGB & 0xFF;

    // Calcula la luminosidad usando la fórmula Y = 0.299*R + 0.587*G + 0.114*B
    double luminosidad = 0.299 * r + 0.587 * g + 0.114 * b;

    // Determina si el color es claro u oscuro
    if (luminosidad > 128) {
        return "claro";
    } else {
        return "oscuro";
    }
}

int main(int argc, char* argv[]) {
    // Verifica que se haya proporcionado un argumento
    if (argc != 2) {
        std::cerr << "Uso: " << argv[0] << " <color_hexadecimal>" << std::endl;
        return 1;
    }

    // Obtiene el color hexadecimal del argumento de línea de comandos
    std::string colorHex = argv[1];

    // Determina si el color es claro u oscuro
    std::string resultado = esColorClaroOscuro(colorHex);

    std::cout << "El color #" << colorHex << " es " << resultado << std::endl;

    return 0;
}

