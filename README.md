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

---

# Notas

- En desafío 1 se incorporaron los errores en caso de salir de los rangos de valores, al ocurrir, se reinicia todo el sistema.
