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