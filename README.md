# Syntetické EKG

<img src="ekg_animation.gif" width="600" alt="EKG Animace">

Matlab kód pro vytvoření syntetického EKG.

Kód slouží pro generování a vizualizaci syntetického EKG. Kód je rozdělen do dvou tříd:

<b>Třída classECG</b>

  Metoda calculateFourier pomocí Fourierovy řady aproximuje zadané matematické tvary pro dosažení hladkého průběhu vlny.
  Metoda synteticECG skládá jednotlivé vlny (P, QRS, T) do jednoho kompletního srdečního cyklu.
  Metoda drawRunningGraph Vykresluje plynule se pohybující EKG signál v reálném čase 

<b>Třída mainECG</b>

  Inicializace časových parametrů a odkaz na tvarové funkce jednotlivých segmentů.
  Metoda piecewisePT generuje paraboly zastupující P a T vlny.
  Metoda piecewiseQRS generuje lomenou čáru tvořící ostrou špičku QRS komplexu.
  Pomocí funkce repmat řetězí více period za sebou pro simulaci souvislého EKG záznamu.
