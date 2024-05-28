## Paso 1: Preparación del Entorno

`curl https://sdk.cloud.google.com | bash`

`cd google-cloud-sdk`

Iniciar sesión y configurar: `./bin/gcloud init` 

## Paso 2: crear function

`mkdir myfunction`
`cd myfunction`

## Paso 3: iniciar projecto de node js

`npm -y init`
`npm install express @google-cloud/functions-framework`


## Paso 4: Habilitar la API de Cloud Functions

- Utilizaste el SDK de Google Cloud (`gcloud`) para habilitar la API de Cloud Functions en tu proyecto utilizando el siguiente comando:

`gcloud services enable cloudfunctions.googleapis.com --project sistemes-multimedia`


## Paso 5: desplegar la función

`../bin/gcloud functions deploy myFunction --runtime nodejs16 --trigger-http --allow-unauthenticated`

## Paso 6: Ver información de donde esta desplegada nuestra api

`./bin/gcloud functions describe myFunction`

## Paso 7:

Ya podemos utilizar nuestra api con curl o con postman

`curl https://us-central1-sistemes-multimedia.cloudfunctions.net/myFunction`

# Funcionaliades

- STATUS -> [INVALID_TOKEN, OK, ERROR]
- if status == INVALID_TOKEN OR ERROR only message response


1. POST /users/auth { email : "email@email.com" } -> { status, message, token } (OK or res.status(500))
2. GET /queries/count -> { status, data : count } (ERROR -> no remains requests, INVALID_TOKEN -> token not valid, OK -> return count, res.status(500))

3. GET /queries/get -> { status, fileName, data : [ date, fileName, name] } (INVALID_TOKEN -> token not valid, OK -> return queries, res.status(500))

3. POST /queries/set { name : plantName } -> { status, message, data : [fileName, count, date]} (INVALID_TOKEN -> token not valid, ERROR -> body not valid, OK -> querie set correctly)

#### Autentifica usuarios en cloud sorage, gestionado todo mediante jwt .
#### Getter y setter de queries para usuario de jwt.
#### Todas las requests debent tener header authentication (JWTTOKEN) para validar todas las requests., excepto /users/auth que devolverá (JWTTOKEN)

## DB NoSql

Base de datos de firestore con 3 collections.

1. count -> contador general 
- - documento -> counterid 
- - campo -> count : number (inicializar a 0)

2. queries -> registro de queries, guarda info de todas las queries de la app + nombre de imagen en cloud storage
- - documento -> nombre aleatorio generado automáticamente
- - campos -> date : string (en js, const date = new Date.toDateString()), fileName: string (fileName de cloud storage en función de count), name: string (nombre de la planta)

3. users -> registro de usuarios de la app
- - documento -> generado aleatoriamente
- - campos -> email : string (email del usuario totalemente único), count : number (contador de queries hechas por usuario) y queries: array (referencia a los documentos de las queries que pertenencen a cada usuario)


## Configuración 

- Archivos de configuración .env.ejemplo con variavles de entorno a confirugrar, provienen de google cloud storage.
- Archivo de información de google cloud service account extraido de google cloud. Necesario para interactuar con tu firestore.

## Puesta en marcha 

1. Configurar.env y .json de service account
2. 

- - `pnpm install`
- - `pnpm run dev` or `deploy gcloud`

