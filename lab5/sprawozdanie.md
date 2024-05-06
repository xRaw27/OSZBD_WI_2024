# Lab 8 - sprawozdanie
## Wojciech Przybytek, Dariusz Piwowarski

### Wprowadzenie

Stworzono serwer `test_db` w katalogu `/tmp`

![img.png](img.png)

Zmieniono port serwera na `5440`

![img_1.png](img_1.png)

Uruchomiono serwer

![img_2.png](img_2.png)

Połączono się do serwera do bazy `postgres` i utworzono tabelę `tbl`

![img_3.png](img_3.png)

Do tabeli dodano 4 testowe rekordy

![img_4.png](img_4.png)

Usunięto rekordy o id mniejszym od 3, a następnie wszystkie rekordy

![img_5.png](img_5.png)

Usunięto tabelę `tbl`

![img_6.png](img_6.png)

Zatrzymano instancję serwera

![img_7.png](img_7.png)

### Przebieg ćwiczenia

Utworzono i uruchomiono serwer `primary_db` na porcie `5433`, który nasłuchuje na połączenia z dowolnego adresu

![img_8.png](img_8.png)

Stworzono użytkownika `repuser` z flagą `replication`

![img_10.png](img_10.png)

Umożliwiono użytkownikowi `repuser` łączenie się z serwerem z maszyny localhost w pliku `pg_hba.conf`

![img_11.png](img_11.png)

Utworzono replikę serwera o nazwie `replica_db`

![img_9.png](img_9.png)

![img_12.png](img_12.png)

Uruchomiono replikę na porcie `5434`

![img_13.png](img_13.png)

![img_14.png](img_14.png)

![img_15.png](img_15.png)

Na serwerze primary utworzono tabelę `tbl` i dodano do niej przykładowe rekordy

![img_16.png](img_16.png)

Na serwerze backup pojawiła się jej replika

![img_17.png](img_17.png)

Przetestowano działanie operacji `DELETE` na tabeli na serwerze primary i sprawdzono ponownie tabelę na replice

![img_18.png](img_18.png)

![img_19.png](img_19.png)

To samo przetestowano dla operacji `TRUNCATE`

![img_20.png](img_20.png)

![img_21.png](img_21.png)

Zatrzymano instancję primary

![img_22.png](img_22.png)

Wykonano ręcznego failovera i wypromowano serwer repliki na nowego mastera, a następnie przetestowano jej działanie

![img_23.png](img_23.png)

### Zadanie domowe

Dla `primary_db` stworzono multi standby setup z 3 innymi serwerami

![img_24.png](img_24.png)

![img_25.png](img_25.png)

Oraz kaskadową replikację dla z 3 serwerami

![img_26.png](img_26.png)

![img_27.png](img_27.png)

![img_31.png](img_31.png)

![img_28.png](img_28.png)

![img_30.png](img_30.png)

![img_29.png](img_29.png)