# Lab 10 - sprawozdanie
## Wojciech Przybytek, Dariusz Piwowarski

### Przebieg ćwiczenia

Utworzono serwery `publisher_db` i `subscriber_db`

![img.png](img.png)

Ustawiono port `publisher_db` na 5433 oraz `wal_level` na `logical`

![img_1.png](img_1.png)

![img_2.png](img_2.png)

Ustawiono port `subscriber_db` na 5434

![img_3.png](img_3.png)

Uruchomiono obie instancje

![img_4.png](img_4.png)

Połączono się z serwerem `publisher_db`, utworzono w nim baze `pub_db`, a w niej tabelę `pub_tbl`

![img_5.png](img_5.png)

Wygenerowano 10 wierszy w tabeli

![img_6.png](img_6.png)

![img_7.png](img_7.png)

Utworzono na serwerze `subscriber_db` bazę `sub_db`

![img_8.png](img_8.png)

Przekopiowano schemat tabeli `pub_tbl` do bazy `sub_db`

![img_9.png](img_9.png)

![img_10.png](img_10.png)

W bazie `pub_db` utworzono publikację `test_publication` na tabeli `pub_tbl`

![img_11.png](img_11.png)

W bazie `sub_db` utworzono subskrypcję `test_subscription` na wcześniej stworzoną publikację

![img_12.png](img_12.png)

W bazie `sub_db` dane w tabeli `pub_tbl` zostały przekopiowane

![img_13.png](img_13.png)

W logach publishera widać utworzenie publikacji

![img_14.png](img_14.png)

W logach subscribera widać utworzenie subskrypcji

![img_15.png](img_15.png)

Utworzenie nowych 10 rekordów w bazie `pub_db` w tabeli `pub_tbl`

![img_16.png](img_16.png)

Rekordy zostały przekopiowane do bazy `sub_db`

![img_17.png](img_17.png)

Nie udało się wykonać komendy update, otrzymaliśmy następujący komunikat o błędzie

![img_18.png](img_18.png)

Według informacji które znaleźliśmy, jest to spowodowane brakiem primary key w tabeli, ale można to też obejść wykonując
proponowane przez postgresa polecenie

![img_19.png](img_19.png)

Dane zostały poprawnie uaktualnione w replice

![img_20.png](img_20.png)

Wykonano komende delete na serwerze publishera

![img_21.png](img_21.png)

Rekordy zostały usunięte również z subscribera

![img_22.png](img_22.png)

Wykonano komende truncate na serwerze publishera

![img_23.png](img_23.png)

Rekordy zostały usunięte również z subscribera

![img_24.png](img_24.png)

Dodano do tabeli publishera nową kolumnę

![img_25.png](img_25.png)

Kolumna nie została zreplikowana na serwerze subscribera

![img_26.png](img_26.png)

Do zmodyfikowanej tabeli publishera dodano nowe rekordy

![img_27.png](img_27.png)

Rekordy nie zostały zreplikowane do tabeli subscribera

![img_28.png](img_28.png)

Aby naprawić replikację do tabeli subscribera dodano nową kolumnę a następnie odświeżono subskrypcję

![img_29.png](img_29.png)

Do tabeli subscribera dodano nową kolumnę

![img_30.png](img_30.png)

Do tabeli publishera dodano nowe rekordy

![img_31.png](img_31.png)

Rekordy zostały zreplikowane w tabeli subscribera, ich wartość w nowej kolumnie wynosiła `null`

![img_32.png](img_32.png)

Dane replikacji z serwera publishera (tabela `pg_stat_replication`)

![img_33.png](img_33.png)

Na serwerze subscribera tabela `pg_stat_replication` jest pusta, dane replikacji są zapisane w tabeli 
`pg_stat_subscription`

![img_34.png](img_34.png)

Zatrzymano subskrypcję na serwerze subscribera

![img_35.png](img_35.png)

Na serwerze publishera tabela `pg_stat_replication` jest pusta

![img_36.png](img_36.png)

Ponownie uruchomiono subskrypcję

![img_37.png](img_37.png)

### Rozszerzenie konfiguracji

Utworzono 2 nowe serwery -  `sub2_db` na porcie `5435` i `sub3_db` na porcie `5436`

![img_38.png](img_38.png)

Utworzono na nich odpowiednio bazy `sub2_db` i `sub3_db`

![img_39.png](img_39.png)

![img_40.png](img_40.png)

Przekopiowano schemat tabeli `pub_tbl` do nowo utworzonych baz

![img_41.png](img_41.png)

![img_42.png](img_42.png)

![img_43.png](img_43.png)

![img_44.png](img_44.png)

Stworzono subskrypcję na obu bazach do bazy publishera

![img_45.png](img_45.png)

![img_46.png](img_46.png)

Wszystkie 3 subskrypcje są widoczne w tabeli `pg_stat_replication` publishera

![img_47.png](img_47.png)

![img_48.png](img_48.png)

Dodano nowy rekord do tabeli w bazie publishera

![img_49.png](img_49.png)

Wszystkie bazy posiadają takie same rekody w tabeli

![img_50.png](img_50.png)

![img_51.png](img_51.png)

![img_52.png](img_52.png)

![img_53.png](img_53.png)

Następnie zmieniono sposób replikacji na kaskadowy (publisher -> sub1 -> sub2 -> sub3)

![img_54.png](img_54.png)

![img_55.png](img_55.png)