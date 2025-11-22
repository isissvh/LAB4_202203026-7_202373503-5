# Laboratorio 4 - INF245  
**Arquitectura y Organización de Computadores** 

---
## Integrantes  
- Verónica Torres - Rol 202373503-5 - Paralelo 200
- Isidora Villegas - Rol 202203026-7 - Paralelo 200


---

# Contexto  
Este laboratorio corresponde a la misión final contra la organización final.
ByteMaster ha detectado que la organización criminal planea llevar a cabo su **'Protocolo Genesis'** y nuestro objetivo es desmantelar a este para evitar un desastre!!
- Desafio 1:
ByteMaster descubrió que la organización criminal usa un sistema de encriptación jerárquico basado 
en la Secuencia de Collatz modificada para ocultar los rangos de sus miembros. El objetivo es lograr decifrar sus rangos!
---
# Desarrollo
## Desafio 1

La función collatz se implementó de forma recursiva con la siguiente estructura:

- Main y Loop:

  La función recibe en a0 el valor n del ID actual.
  
  Al inicio se reserva espacio en la pila y se guardan los registros ra (dirección de retorno) y s0 (registro donde se almacena n).
  
  Luego se copia a0 a s0 (s0 = n) para usarlo como variable local sin perder el valor original cuando se modifique a0 en las llamadas recursivas.

  - **Caso base**
    
    ```  
    Si n == 1, se salta a la rama base y se carga 0 en a0.
    Esto significa que, al llegar a 1, la función retorna 0 pasos restantes, cerrando la recursión.
    ```
  - **Caso recursivo**

    ```  
    Se determina si n es par o impar usando la propiedad de lsb (par = 0, impar = 1):
       - Si es par, se calcula el siguiente valor como n / 2 usando un corrimiento a la derecha y se guarda en a0.
       - Si es impar, se calcula 3n + 1 (doble de n, más n, más 1) y se guarda en a0.
    Con este “siguiente” valor en a0 se hace una llamada recursiva a collatz con jal: collatz(siguiente).
    Al volver de la llamada recursiva, a0 contiene la cantidad de pasos desde siguiente hasta 1;
    se suma 1 (a0 = a0 + 1) para contar el paso realizado en la llamada actual (la transformación de n a siguiente).
    ```

- Fin de la recursividad:

  Antes de regresar al llamador, se restauran s0 y ra desde la pila y se reajusta el puntero sp al valor original.
  
  Finalmente, se retorna con jr ra, dejando en **a0** el número **total de pasos** que tarda el n original en llegar a 1.


## Desafio 2
el subsistema implementa una validación secuencial en tres capas. Si una capa falla, el programa termina inmediatamente informando el error.

1.  Capa 1 (Análisis de Composición):
   - Algoritmo: Se recorre el arreglo de bytes linealmente usando un bucle simple.
   - Estructura: Se utilizan 4 registros contadores independientes.
   - Lógica: Se verifican rangos ASCII para Mayúsculas, Minúsculas y Dígitos. Para los caracteres 
     especiales, dada su dispersión en la tabla ASCII, se comparan individualmente contra el conjunto permitido.
     
2. Capa 2 (Paridad Posicional):
   - Algoritmo: Se implementa mediante bucles anidados. El bucle externo itera sobre los 4 bloques y 
     el interno suma los valores ASCII de los caracteres.
   - Lógica: Se verifica la paridad usando operaciones a nivel de bits (AND con 1). Se requiere un contador 
     de bloques válidos >= 3.
     
3. Capa 3 (Código Hash):
   - Algoritmo: Implementación iterativa de la fórmula `hash = (hash * 31 + ASCII) % 65536`.
   - Optimización Aritmética: Debido a las restricciones del set de instrucciones (ver supuestos), 
     se reemplazaron las operaciones complejas por desplazamientos lógicos (shifts).


-----------------------------------------------------------------------
# INSTRUCCIONES DE COMPILACIÓN Y EJECUCIÓN (RARS)
-----------------------------------------------------------------------

Para ambos subsistemas:
1. Abrir el simulador RARS.
2. Abrir el archivo correspondiente (`subsistema1.asm` o `subsistema2.asm`).
3. Ensamblar el código presionando F3 (o el icono de la llave inglesa/destornillador).
4. Ejecutar presionando F5 (o el botón Play verde).

Entradas requeridas:
- Subsistema 1: Ingresar primero la cantidad de IDs (n) y luego los n números enteros en la consola.
- Subsistema 2: Ingresar una cadena de caracteres de largo 16 cuando la consola lo solicite.

---
# Notas

- En desafío 1 se incorporaron los errores en caso de salir de los rangos de valores, al ocurrir, se reinicia todo el sistema.
- En desafío 1 se asume que la salida es tal como en el pdf, que no incluye el paso a paso de cada 'transición'.
- En desafío 2 al ingresar una clave diferente a 16 dígitos, se rechaza automáticamente.
