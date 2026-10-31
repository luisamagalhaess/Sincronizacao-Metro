# Sincronização do Metrô (METROREC)

Implementação, em C com pthreads, das funções de sincronização entre vagões
(carros) e passageiros de uma estação de metrô. Cada carro e cada passageiro é
uma thread independente.

## Arquivos

| Arquivo | Descrição |
|---|---|
| `sync_car.h` | Declaração da `struct station` e dos protótipos das funções. |
| `sync_car.c` | Implementação de `station_init`, `station_load_car`, `station_wait_for_car` e `station_on_board`. |
| `sync_car-runner.c` | Programa de teste (contém o `main`). |
| `Makefile` | Compila o teste junto com a implementação e gera o executável `sync_car`. |

## Sistema operacional e compilador

- Desenvolvido e testado no **Ubuntu (WSL2) sobre Windows**.
- Compilador: **gcc** `13.3.0`.

## Como compilar

```
make
```

Gera o executável `sync_car`. A compilação usa
`-Wall -Wextra -Wpedantic -std=c11 -D_DEFAULT_SOURCE -pthread`.

## Como executar e testar

```
make run          # executa o teste
./sync_car        # equivalente
echo $?           # 0 = passou
```

Saída esperada (os números variam, pois o teste é aleatório), terminando em:

```
Looks good!
```

## Como limpar

```
make clean
```

## Como a sincronização funciona

Um **único mutex** (`lock`) protege todo o estado da estação, com **duas
variáveis de condição**, sem semáforos e sem espera ocupada:

- `free_seats`: assentos ainda não reservados; só é maior que 0 enquanto há um carro na estação.
- `waiting`: passageiros esperando na plataforma.
- `boarding`: passageiros já liberados que ainda não sentaram.
- `car_arrived`: os passageiros esperam aqui por um carro com assento livre.
- `car_can_leave`: o carro espera aqui até que ninguém mais possa embarcar e todos os liberados estejam sentados.

Funções:

- `station_wait_for_car`: faz `waiting++`, espera em `car_arrived` enquanto não há assento livre (`while`, para tratar acordadas espúrias), reserva o assento (`free_seats--`, `boarding++`) e avisa o carro.
- `station_load_car`: abre os assentos, acorda os passageiros (`broadcast`) e espera enquanto `(waiting > 0 && free_seats > 0) || boarding > 0`. Ao sair, fecha os assentos.
- `station_on_board`: faz `boarding--` e, quando chega a 0, acorda o carro.

Os passageiros reservam assentos dentro do lock e retornam de
`station_wait_for_car` sem esperar uns pelos outros, então vários podem embarcar
simultaneamente antes de qualquer `station_on_board`.
