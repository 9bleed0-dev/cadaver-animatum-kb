---
tags: [kb, unity, audio, sound]
aggiornato: 2026-07-25
---

# Audio in Unity

> Come si implementa il suono. Sottovalutatissimo: **l'audio è metà della percezione di
> qualità di un gioco**, e per un gioco con una punta di horror è ancora di più.

## I tre pezzi

| Pezzo | Analogia |
|---|---|
| **AudioClip** | il file audio |
| **AudioSource** | un altoparlante virtuale attaccato a un oggetto della scena |
| **AudioListener** | le orecchie. **Una sola per scena**, di solito sulla Camera |
| **AudioMixer** | il banco di regia: instrada, mixa, applica effetti |

---

## Struttura del mixer — da fare subito

Crea un AudioMixer con un gruppo **Master** e questi figli:

```
Master
├── Music
├── SFX
├── Ambience
└── UI
```

Ogni AudioSource instrada al suo gruppo tramite il campo **Output**.

> [!tip] Perché farlo il primo giorno
> Con questa struttura il menu opzioni con i cursori del volume è **un pomeriggio di
> lavoro**. Senza, è una caccia a tutti gli AudioSource del progetto.
>
> Serve anche per gli effetti dinamici: attenuare la musica quando parla qualcuno, mettere
> un filtro passa-basso quando il gioco è in pausa, abbassare tutto tranne l'allarme
> quando arriva l'ondata.

---

## La regola che separa il dilettante dal professionista

> [!danger] Il suono ripetuto identico
> Riprodurre **lo stesso identico file** per un'azione ripetuta (passi, colpi, click)
> produce l'effetto mitragliatrice: il cervello lo riconosce come artificiale in pochi
> secondi, e il gioco suona *economico*.

**Le due cure, entrambe economiche:**

1. **Più varianti dello stesso suono** (3-5 file per tipo) scelte a caso
2. **Randomizzazione di pitch e volume** a ogni riproduzione (±10% è la base)

```csharp
[SerializeField] private AudioClip[] footstepClips;
[SerializeField] private AudioSource source;

private void PlayFootstep()
{
    AudioClip clip = footstepClips[Random.Range(0, footstepClips.Length)];
    source.pitch  = Random.Range(0.92f, 1.08f);
    source.volume = Random.Range(0.85f, 1f);
    source.PlayOneShot(clip);
}
```

> [!tip] Scorciatoia in Unity 6
> Dalla 2023.2 esiste il **Random Audio Container**: un asset che pesca a caso da una lista
> con variazioni di pitch e volume già applicate, **senza scrivere codice**.
> Da usare per tutto ciò che è ripetitivo.

---

## Audio 2D vs 3D

Il parametro **Spatial Blend** su AudioSource:

- **0 = 2D** — si sente uguale ovunque. Musica, UI, notifiche.
- **1 = 3D** — posizionale: volume e panning dipendono dalla distanza e dalla direzione.
  Suoni del mondo.

Per il 3D conta anche la **curva di attenuazione** (rolloff): quanto in fretta il suono
svanisce con la distanza. Va tarata a orecchio, il default raramente va bene.

> [!tip] Per un gioco isometrico
> Le sorgenti 3D funzionano bene ma vanno tarate sulla **distanza della camera**, che è
> grande. Un errore comune è avere tutto inudibile perché il rolloff è pensato per una
> camera in prima persona.

---

## Pooling degli AudioSource

Con decine di unità che emettono suoni, creare e distruggere AudioSource genera spazzatura
e scatti.

**Soluzione:** un pool di AudioSource riutilizzati, gestito da un servizio centrale.
Stesso principio dell'[[Performance e Profiling|object pooling]].

Nota tecnica: `PlayOneShot` **non aggiorna** `AudioSource.isPlaying`, quindi non puoi usare
quel flag per sapere se una sorgente del pool è libera. Serve tenere traccia della durata a
mano.

---

## Formati

| Uso | Formato | Load Type |
|---|---|---|
| Effetti brevi | **WAV** | Decompress On Load |
| Effetti frequenti e numerosi | WAV | Compressed In Memory |
| Musica, ambienti lunghi | **OGG** | **Streaming** |
| ❌ MP3 | evitare | introduce un silenzio ai punti di loop |

---

## L'audio per il nostro gioco

Dai pilastri ([[Pilastri di Design]]) e dalla punta di horror ([[Horror e Dread]]) discendono
indicazioni precise.

### Il livello base: il rumore del lavoro
Il regno deve avere un **tappeto sonoro costante e sgradevolmente normale**: macine che
girano, martelli, passi strascicati, il cigolio di un carro. È il suono della burocrazia
macabra.

Deve essere **continuo e noioso**. Serve a stabilire una normalità.

### Il livello horror: la rottura della normalità
La punta di horror non arriva aggiungendo suoni spaventosi. Arriva **togliendoli**:

- **Il silenzio improvviso.** Il tappeto di lavoro si ferma per tre secondi. Poi riprende.
  Non succede nient'altro. È il singolo effetto più efficace ed è **gratuito**.
- **Un suono sbagliato dentro uno giusto.** La macina gira, e per un istante il suono è
  bagnato invece che secco.
- **Un suono che non ha una fonte visibile** sulla mappa.

> [!tip] Il dato di design
> La ricerca sull'horror lo conferma: **il suono costante perde efficacia, il silenzio
> improvviso dopo la tensione amplifica il terrore**. E l'attesa spaventa più della minaccia.
> → [[Horror e Dread]]

### Il livello informativo
In un gestionale l'audio è **interfaccia**: il giocatore non può guardare tutto lo schermo.
Un suono distinto per "carne finita", "muro sfondato", "ondata in arrivo" vale più di
un'icona lampeggiante.

**Regola:** ogni evento che richiede attenzione ha un suono **riconoscibile a occhi chiusi**.

---

## Middleware (FMOD / Wwise): non ora

Sono strumenti professionali che danno controllo enorme sull'audio dinamico. Sono anche
un intero sistema in più da imparare.

**Decisione: AudioSource + AudioMixer nativi.** Bastano ampiamente per il nostro scopo.
Se un giorno la musica dinamica diventasse centrale, si riapre con un ADR.

## Collegamenti
- [[Dove Trovare Asset e Suoni]] · [[Game Feel e Juice]] · [[Horror e Dread]]
- [[Performance e Profiling]] · [[Pilastri di Design]]

## Fonti
- [Unity Manual — AudioMixer overview](https://docs.unity3d.com/560/Documentation/Manual/AudioMixerOverview.html)
- [Game Dev Beginner — How to use the Random Audio Container in Unity](https://gamedevbeginner.com/how-to-use-the-random-audio-container-in-unity/)
- [Andrew Mushel — Sound Effect Variation in Unity](https://andrewmushel.com/articles/sound-effect-variation-in-unity/)
- [Audio for Game Developers: Implementing Sound and Music in Unity](https://respawn.outlookindia.com/gaming/gaming-guides/audio-for-game-developers-implementing-sound-and-music-in-unity)
- [Unity Audio Integration Guide — SFX Engine](https://sfxengine.com/blog/unity-audio-integration-guide)
- [Sutkus Audio — Random pitching in Unity](https://sutkusaudio.com/post/2022-01-12-random-pitching/2022-01-12-random-pitching/)
