# BouvetKantine
Et prosjekt for å telle antall besøkende på kantina hos Bouvet. Hovedsakelig brukes til å unngå kø.

## Hvordan det virker:

1. Vi har en sensor over inngangen i kantina som registrerer bevegelse. Det er satt opp to virtuelle porter i denne sensoren som registrerer passeringer inn og ut av kantina. Vi har to virtuelle porter for å sikkre oss at vi får med oss alle.
2. Sensoren sender dataene med MQTT til en VM i Azure. 
3. På VMen er det satt opp et MQTT broker som tar imot dataene fra sensoren. I dette tilfellet bruker vi Mosquitto.
4. Det kjører også et python script som hender inn dataene fra sensoren og sender de videre til en postgres database som kjøres som tidsserie database.
5. Postgres databasen er satt opp med TimescaleDB som er en utvidelse av postgres som gjør at vi kan kjøre SQL spørringer på tidsseriedata. 
6. Det er valgt å kjøre databasen i VMen isteden for som en service for å teste hvor mye det tåler i tillegg til å sprare kostnadder.
7. VMen som er satt opp er den nest enkleste VMen i Azure. Den har 1 CPU og 1GB RAM. Den kjører Ubuntu.

## Hvordan få tilgang?:

Spør Christoph for å få tilgang til VMen og databasen.

# TODO:
Frontend:
- [ ] Lage en frontend som viser antall besøkende i kantina
- [ ] Lage en frontend som viser antall besøkende i kantina over tid

Data Science:
- [ ] Lage en modell som predikerer antall besøkende i kantina
- [ ] Lage en modell som predikerer køen i kantina
- [ ] Finn flere ting vi kan predikere :D 
