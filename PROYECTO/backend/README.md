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


# Funcionaliades -> API con rutas /queries/set, /queries/get y /users/auth 

#### Autentifica usuarios en cloud sorage, gestionado todo mediante jwt 
#### Sube ficheros, gestionado con jwt para autenticar el usuario y guarda la query, además llama a api de info de la planta de la imagen
#### Getter de queries en función del usuario del jwt.
