# Bootloader

Desarrollo de un bootloader con la siguiente funcionalidad: <br/>

 - Implementación del acceso de modo real a modo protegido.
 - Implementación de la carga de un bootloader de segunda etapa.
 - Desde el bootloader de segunda etapa, y con la CPU corriendo en modo protegido, acceso a la memoria de vídeo y al teclado mediante los puertos.
 - Traducción de *scancode* a *ascii* solo para los caracteres alfabéticos en mayúscula.
