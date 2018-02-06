# MINI-RUST & LIFETIME
## 1 Per iniziare
### 1.1 Creare il progetto
Clonare il progetto nella directory desiderata. Entrare nella cartella mini-rust.
```sh
 git clone git@github.com:dsfoza/mini-rust.git
 cd mini-rust
```   
Si può procedere in due modi:
- Utilizziare SML in modalità [interattiva](https://github.com/dsfoza/mini-rust#12-modalità-interattiva)
- Utilizzare il file [script.sml](https://github.com/dsfoza/mini-rust#13-usare-scriptsml)

### 1.2 Modalità interattiva 
Entrare nella modalità interattiva di SML chiamando il comando 
```sh
 sml
``` 
Per compilare il progetto è necessario chiamare:
```sh
CM.make "mini-rust.cm";
Rust.compile("main.sml");
``` 
Possiamo ora eseguire un file grazie al nostro mini-rust. Supponiamo di voler
eseguire il file dummy.rs nella cartella examples, basterà chiamare:
```sh
 Rust.execute("examples/dummy.rs");
```
La grammatica che viene riconosciuta dal mini-rust è nella [sezione 2](https://github.com/dsfoza/mini-rust#2-grammatica) 

### 1.3 Usare script.sml 
E' sufficiente chiamare da terminale:
```sh
 sml script.sml
``` 
## 2 Grammatica
Il progetto riconosce solo una piccola porzione del linguaggio Rust. In particolare la grammatica utilizzata è definita nel file rust.grm nella cartella src.
