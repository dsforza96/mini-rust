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
``` 
Possiamo ora eseguire un file grazie al nostro mini-rust. Supponiamo di voler
eseguire il file dummy.rs nella cartella examples, basterà chiamare:
```sh
 Rust.execute(Rust.compile("examples/dummy.rs"));
```
La grammatica che viene riconosciuta dal mini-rust è nella [sezione 2](https://github.com/dsfoza/mini-rust#2-grammatica) 

### 1.3 Usare script.sml 
E' sufficiente chiamare da terminale:
```sh
 sml script.sml
``` 
## 2 Grammatica
Il progetto riconosce solo una piccola porzione del linguaggio Rust. In particolare la grammatica utilizzata è definita nel file rust.grm nella cartella src.

> **start** &ensp;&rightarrow;&ensp; rust  <br />

> **rust** &ensp;&rightarrow;&ensp; SEMI rust  <br />
> &ensp;&ensp;&ensp;&ensp;&rightarrow;&ensp; block &ensp;rust  <br />
> &ensp;&ensp;&ensp;&ensp;&rightarrow;&ensp; exp SEMI rust  <br />
> &ensp;&ensp;&ensp;&ensp;&rightarrow;&ensp; llet  <br />
> &ensp;&ensp;&ensp;&ensp;&rightarrow;&ensp; ass SEMI rust  <br />
> &ensp;&ensp;&ensp;&ensp;&rightarrow;&ensp; ffun  <br />
> &ensp;&ensp;&ensp;&ensp;&rightarrow;&ensp; print SEMI rust  <br />
> &ensp;&ensp;&ensp;&ensp;&rightarrow;&ensp; &#949;  <br />

> **block** &ensp;&rightarrow;&ensp; LBRA rust RBRA <br />

> **exp** &ensp;&rightarrow;&ensp; expPlus  <br />
> &ensp;&ensp;&ensp;&ensp;&ensp;&rightarrow;&ensp; expPlus PLUS expPlus  <br />
> &ensp;&ensp;&ensp;&ensp;&ensp;&rightarrow;&ensp; call  <br />
> &ensp;&ensp;&ensp;&ensp;&ensp;&rightarrow;&ensp; LPAR exp RPAR  <br />

> **expPlus** &ensp;&rightarrow;&ensp; CONST  <br />
> &ensp;&ensp;&ensp;&ensp;&ensp;&rightarrow;&ensp; varId  <br />
> &ensp;&ensp;&ensp;&ensp;&ensp;&rightarrow;&ensp; AMP varId  <br />

> **call** &ensp;&rightarrow;&ensp; funId LPAR aarg RPAR  <br />

> **aarg** &ensp;&rightarrow;&ensp; arg  <br />
> &ensp;&ensp;&ensp;&ensp;&ensp;&rightarrow;&ensp; &#949; <br />

> **arg** &ensp;&rightarrow;&ensp; AMP varId <br />
> &ensp;&ensp;&ensp;&ensp;&rightarrow;&ensp; AMP varId COMMA arg <br />

> **llet** &ensp;&rightarrow;&ensp; let varId SEMI rust <br />
> &ensp;&ensp;&ensp;&ensp;&rightarrow;&ensp; let varId ASS exp SEMI rust <br />

> **ass** &ensp;&rightarrow;&ensp; varId ASS exp  <br />

> **ffun** &ensp;&rightarrow;&ensp; fn funId lltime LBRA ppar RBRA ret blockfun rust <br />
> &ensp;&ensp;&ensp;&ensp;&rightarrow;&ensp; fn funId lltime LBRA ppar RBRA block rust <br />

> **blockfun** &ensp;&rightarrow;&ensp; LBRA rust IDRET  <br />

> **lltime** &ensp;&rightarrow;&ensp; LCHE ltime RCHE <br />
> &ensp;&ensp;&ensp;&ensp;&ensp;&rightarrow;&ensp; &#949; <br />

> **ltime** &ensp;&rightarrow;&ensp; LTIME <br />
> &ensp;&ensp;&ensp;&ensp;&ensp;&rightarrow;&ensp; LTIME COMMA ltime <br />

> **ppar** &ensp;&rightarrow;&ensp; par <br />
> &ensp;&ensp;&ensp;&ensp;&ensp;&rightarrow;&ensp; &#949; <br />

> **par** &ensp;&rightarrow;&ensp; varId COLON AMP LTIME INT <br />
> &ensp;&ensp;&ensp;&rightarrow;&ensp; varId COLON AMP INT  <br />
> &ensp;&ensp;&ensp;&rightarrow;&ensp; varId COLON AMP LTIME INT COMMA par  <br />
> &ensp;&ensp;&ensp;&rightarrow;&ensp; varId COLON AMP INT COMMA par  <br />

> **ret** &ensp;&rightarrow;&ensp; ARROW AMP LTIME INT <br />
> &ensp;&ensp;&ensp;&rightarrow;&ensp; ARROW AMP INT <br />

> **print** &ensp;&rightarrow;&ensp; PRINT LPAR exp RPAR <br />

> **varId** &ensp;&rightarrow;&ensp; ID <br />

> **varId** &ensp;&rightarrow;&ensp; ID <br />

> **ID** &ensp;&rightarrow;&ensp; ID of string <br />

> **INT** &ensp;&rightarrow;&ensp; INT of integer <br />

> **LBRA** &ensp;&rightarrow;&ensp; { <br />

> **RBRA** &ensp;&rightarrow;&ensp; } <br />

> **IDRET** &ensp;&rightarrow;&ensp; } <br />

> **LPAR** &ensp;&rightarrow;&ensp; ( <br />

> **RPAR** &ensp;&rightarrow;&ensp; ) <br />

> **LCHE** &ensp;&rightarrow;&ensp; < <br />

> **RCHE** &ensp;&rightarrow;&ensp; > <br />

> **PRINT** &ensp;&rightarrow;&ensp; println! <br />

> **LCHE** &ensp;&rightarrow;&ensp; < <br />

> **LCHE** &ensp;&rightarrow;&ensp; < <br />

> **ASS** &ensp;&rightarrow;&ensp; = <br />

> **AMP** &ensp;&rightarrow;&ensp; & <br />

> **LTIME** &ensp;&rightarrow;&ensp; ' string <br />

> **ASS** &ensp;&rightarrow;&ensp; = <br />

> **COMMA** &ensp;&rightarrow;&ensp; , <br />





